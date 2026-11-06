local function httpGet(url)
	local response = request({Url = url, Method = "GET"});
	if not response or not response.Success then error("HTTP failed: " .. url) end;
	return response.Body;
end;
local Airflow = loadstring(httpGet("https://raw.githubusercontent.com/PookiePepelsss/Airflow-UI/refs/heads/main/Source.luau"))();
local PlayerService = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local WorkspaceService = game:GetService("Workspace");
local RunService = game:GetService("RunService");
local UserInputService = game:GetService("UserInputService");
local Lighting = game:GetService("Lighting");
local SoundService = game:GetService("SoundService");
local TweenService = game:GetService("TweenService");
local Debris = game:GetService("Debris");
local LocalPlayer = PlayerService.LocalPlayer;
local AnimationFolder = ReplicatedStorage:WaitForChild("Animations", 15);
local RemoteFolder = ReplicatedStorage:WaitForChild("Remotes", 15);
local ModuleFolder = ReplicatedStorage:WaitForChild("Modules", 15);
local ShootAnimation = AnimationFolder:WaitForChild("Shoot", 15);
local ShootGunRemote = RemoteFolder:WaitForChild("ShootGun", 15);
local ThrowStartRemote = RemoteFolder:WaitForChild("ThrowStart", 15);
local ThrowHitRemote = RemoteFolder:WaitForChild("ThrowHit", 15);
local bulletRendererOk, BulletRenderer = pcall(function()
	setthreadidentity(2);
	local module = require(ModuleFolder:WaitForChild("BulletRenderer", 15));
	setthreadidentity(8);
	return module;
end);
if not bulletRendererOk then BulletRenderer = function() end end;
local MaxDistance = 250;
getgenv().killButton = {gun=false,knife=false};
getgenv().killLoop = {gun=false,knife=false};

local function GetScreenCenter() local cam=WorkspaceService.CurrentCamera;if not cam then return Vector2.new(0,0)end;return Vector2.new(cam.ViewportSize.X/2,cam.ViewportSize.Y/2)end;
local function isInFOV(pos,r) local cam=WorkspaceService.CurrentCamera;if not cam then return false end;local sp,on=cam:WorldToViewportPoint(pos);if not on then return false end;return(Vector2.new(sp.X,sp.Y)-GetScreenCenter()).Magnitude<=r end;

local recentTargets={};
local function RegisterMyTarget(player) if player then recentTargets[player]=tick()end end;
local function WasMyKill(player) local t=recentTargets[player];if t and(tick()-t)<5 then recentTargets[player]=nil;return true end;return false end;

getgenv().killSoundConfig={Enabled=false,Volume=3};
local killSound=Instance.new("Sound");killSound.SoundId="rbxassetid://8679627751";killSound.Volume=3;killSound.Parent=SoundService;killSound.Name="KS_NL";
local function PlayKillSound() if not getgenv().killSoundConfig.Enabled then return end;killSound.Volume=getgenv().killSoundConfig.Volume;killSound.TimePosition=0;pcall(function()killSound:Play()end)end;

getgenv().killEffectConfig={Enabled=false,Effect="Lightning"};
local function CreateLightningEffect(pos) for i=1,8 do local b=Instance.new("Part");b.Size=Vector3.new(0.15,math.random(4,12),0.15);b.Position=pos+Vector3.new(math.random(-4,4),math.random(0,15),math.random(-4,4));b.Anchored=true;b.CanCollide=false;b.Material=Enum.Material.Neon;b.Color=Color3.fromRGB(170,0,255);b.Parent=WorkspaceService;b.CFrame=CFrame.new(b.Position)*CFrame.Angles(math.rad(math.random(-40,40)),math.rad(math.random(0,360)),math.rad(math.random(-40,40)));local l=Instance.new("PointLight");l.Color=Color3.fromRGB(170,0,255);l.Brightness=8;l.Range=25;l.Parent=b;task.spawn(function()for t=0,1,0.05 do if not b.Parent then break end;b.Transparency=t;l.Brightness=8*(1-t);task.wait(0.02)end;b:Destroy()end)end end;
local function CreateFireEffect(pos) for i=1,10 do local p=Instance.new("Part");p.Size=Vector3.new(math.random(1,2),math.random(1,2),math.random(1,2));p.Position=pos+Vector3.new(math.random(-2,2),0,math.random(-2,2));p.Anchored=true;p.CanCollide=false;p.Material=Enum.Material.Neon;p.Shape=Enum.PartType.Ball;p.Color=Color3.fromRGB(255,math.random(50,150),0);p.Parent=WorkspaceService;task.spawn(function()for t=0,1,0.03 do if not p.Parent then break end;p.Position=p.Position+Vector3.new(0,0.25,0);p.Size=p.Size*0.97;p.Transparency=t;task.wait(0.02)end;p:Destroy()end)end end;
local function CreateExplosionEffect(pos) local s=Instance.new("Part");s.Shape=Enum.PartType.Ball;s.Size=Vector3.new(1,1,1);s.Position=pos;s.Anchored=true;s.CanCollide=false;s.Material=Enum.Material.Neon;s.Color=Color3.fromRGB(255,0,0);s.Parent=WorkspaceService;for i=1,12 do local sh=Instance.new("Part");sh.Size=Vector3.new(0.2,0.2,math.random(1,3));sh.Position=pos;sh.Anchored=true;sh.CanCollide=false;sh.Material=Enum.Material.Neon;sh.Color=Color3.fromRGB(255,math.random(0,80),0);sh.Parent=WorkspaceService;local d=Vector3.new(math.random(-100,100)/100,math.random(20,100)/100,math.random(-100,100)/100).Unit;task.spawn(function()for t=0,1,0.04 do if not sh.Parent then break end;sh.Position=sh.Position+d*0.6;sh.Transparency=t;task.wait(0.02)end;sh:Destroy()end)end;task.spawn(function()for t=0,1,0.03 do if not s.Parent then break end;s.Size=Vector3.new(1+t*15,1+t*15,1+t*15);s.Transparency=t;task.wait(0.02)end;s:Destroy()end)end;
local function CreateVortexEffect(pos) for i=1,16 do local p=Instance.new("Part");p.Size=Vector3.new(0.4,0.4,0.4);p.Position=pos;p.Anchored=true;p.CanCollide=false;p.Material=Enum.Material.Neon;p.Shape=Enum.PartType.Ball;p.Color=Color3.fromRGB(0,math.random(100,255),255);p.Parent=WorkspaceService;task.spawn(function()local a=math.rad(i*22.5);local r=0;for t=0,1,0.025 do if not p.Parent then break end;r=r+0.25;p.Position=pos+Vector3.new(math.cos(a+t*8)*r,t*8,math.sin(a+t*8)*r);p.Transparency=t;task.wait(0.02)end;p:Destroy()end)end end;
local function CreateMatrixEffect(pos) for i=1,20 do local p=Instance.new("Part");p.Size=Vector3.new(0.1,math.random(2,6),0.1);p.Position=pos+Vector3.new(math.random(-8,8),math.random(8,20),math.random(-8,8));p.Anchored=true;p.CanCollide=false;p.Material=Enum.Material.Neon;p.Color=Color3.fromRGB(0,255,0);p.Parent=WorkspaceService;task.spawn(function()for t=0,1,0.025 do if not p.Parent then break end;p.Position=p.Position-Vector3.new(0,0.4,0);p.Transparency=t;task.wait(0.03)end;p:Destroy()end)end end;
local function CreateDisintegrateEffect(pos) for i=1,25 do local p=Instance.new("Part");p.Size=Vector3.new(0.3,0.3,0.3);p.Position=pos+Vector3.new(math.random(-2,2),math.random(-2,2),math.random(-2,2));p.Anchored=true;p.CanCollide=false;p.Material=Enum.Material.Neon;p.Color=Color3.fromRGB(math.random(100,255),0,math.random(100,255));p.Parent=WorkspaceService;task.spawn(function()local d=(p.Position-pos).Unit+Vector3.new(0,math.random(1,2),0);for t=0,1,0.02 do if not p.Parent then break end;p.Position=p.Position+d*0.15;p.Transparency=t;task.wait(0.02)end;p:Destroy()end)end end;
local KillEffects={Lightning=CreateLightningEffect,Fire=CreateFireEffect,Explosion=CreateExplosionEffect,Vortex=CreateVortexEffect,Matrix=CreateMatrixEffect,Disintegrate=CreateDisintegrateEffect};
KillEffects.Blackhole=function(pos)
	local part=Instance.new("Part");part.Size=Vector3.new(1,1,1);part.Transparency=1;part.Anchored=true;part.CanCollide=false;part.CanQuery=false;part.CastShadow=false;part.Position=pos;part.Parent=WorkspaceService;
	local att=Instance.new("Attachment");att.Parent=part;
	local light=Instance.new("PointLight");light.Color=Color3.fromRGB(255,100,0);light.Brightness=5;light.Range=16;light.Parent=part;
	local NR,NS,NK,CS,CK=NumberRange.new,NumberSequence.new,NumberSequenceKeypoint.new,ColorSequence.new,ColorSequenceKeypoint.new;
	local black,white=Color3.new(0,0,0),Color3.new(1,1,1);
	local emitters={};
	local function mk(name,cfg)
		local p=Instance.new("ParticleEmitter");p.Name=name;
		p.SpreadAngle=Vector2.new(-360,360);p.VelocityInheritance=0;p.EmissionDirection=Enum.NormalId.Top;p.LightInfluence=0;
		for k,v in pairs(cfg)do p[k]=v end;
		p.Parent=att;table.insert(emitters,p);
	end;
	mk("blackhole",{RotSpeed=NR(10,10),Color=CS(black),Rate=20,Transparency=NS({NK(0,0),NK(0.7,0),NK(1,1)}),Rotation=NR(0,0),Lifetime=NR(0.5,0.5),LightEmission=0,Speed=NR(0.074,0.074),Texture="rbxassetid://14770848042",Size=NS({NK(0,2.22),NK(1,2.22)})});
	mk("blackring",{RotSpeed=NR(-360,360),Color=CS(black),Rate=20,Transparency=NS({NK(0,0),NK(0.2,1),NK(0.4,0),NK(0.6,0),NK(0.8,0),NK(1,1)}),Rotation=NR(0,0),Lifetime=NR(0.4,0.4),LightEmission=0,Speed=NR(0.37,0.37),Texture="rbxassetid://2763450503",Size=NS({NK(0,2.96),NK(1,2.96)})});
	mk("whitecenter",{RotSpeed=NR(10,10),Color=CS(white),Rate=20,Transparency=NS({NK(0,0),NK(0.2,1),NK(0.4,1),NK(0.6,0),NK(0.8,0),NK(1,1)}),Rotation=NR(0,0),Lifetime=NR(0.5,0.5),LightEmission=1,Speed=NR(0.37,0.37),Texture="rbxassetid://6644617442",Size=NS({NK(0,2.4),NK(1,2.4)})});
	mk("whitering",{RotSpeed=NR(-360,360),Color=CS(white),Rate=20,Transparency=NS({NK(0,0),NK(0.2,1),NK(0.4,1),NK(0.6,0),NK(0.8,0),NK(1,1)}),Rotation=NR(0,0),Lifetime=NR(0.4,0.4),LightEmission=0.5,Speed=NR(0.37,0.74),Texture="rbxassetid://2763450503",Size=NS({NK(0,3.7),NK(1,3.7)})});
	mk("dustring1",{RotSpeed=NR(-10,10),Color=CS({CK(0,Color3.fromRGB(242,189,0)),CK(0.5,Color3.fromRGB(255,120,0)),CK(1,black)}),Rate=10,Transparency=NS({NK(0,1),NK(0.1,0),NK(1,1)}),Lifetime=NR(0.7,1),LightEmission=0.8,Speed=NR(0.37,0.37),Texture="rbxassetid://11745241946",Size=NS({NK(0,7.4),NK(1,7.4)})});
	mk("disk1",{RotSpeed=NR(360,720),SpreadAngle=Vector2.new(0,0),Color=CS({CK(0,white),CK(1,Color3.fromRGB(255,160,0))}),Rate=10,Transparency=NS({NK(0,1),NK(0.2,0),NK(1,1)}),Lifetime=NR(1,2),LightEmission=0.5,Speed=NR(0.037,0.037),Texture="rbxassetid://9864060085",Size=NS({NK(0,4.81),NK(1,4.81)})});
	mk("outerdisk",{RotSpeed=NR(360,720),SpreadAngle=Vector2.new(0,0),Color=CS({CK(0,Color3.fromRGB(200,140,140)),CK(0.5,Color3.fromRGB(84,84,84)),CK(1,black)}),Rate=10,Transparency=NS({NK(0,1),NK(0.2,0),NK(0.74,0),NK(1,1)}),Rotation=NR(-360,360),Lifetime=NR(1,2),LightEmission=0.5,Speed=NR(0.037,0.037),Texture="rbxassetid://7150933366",Size=NS({NK(0,29.6),NK(1,29.6)})});
	task.delay(2.5,function()
		for _,e in ipairs(emitters)do e.Enabled=false end;
		for t=0,1,0.05 do light.Brightness=5*(1-t);task.wait(0.05)end;
		task.wait(1.5);
		part:Destroy();
	end);
end;
local function PlayKillEffect(pos) if not getgenv().killEffectConfig.Enabled then return end;local fn=KillEffects[getgenv().killEffectConfig.Effect];if fn then pcall(fn,pos)end end;

getgenv().hitmarkerConfig={Enabled=false};
local function ShowHitmarker(pos) if not getgenv().hitmarkerConfig.Enabled then return end;local cam=WorkspaceService.CurrentCamera;if not cam then return end;local sp,on=cam:WorldToViewportPoint(pos);local cx=on and sp.X or cam.ViewportSize.X/2;local cy=on and(sp.Y-20)or(cam.ViewportSize.Y/2-40);local txt=Drawing.new("Text");txt.Text="100";txt.Size=30;txt.Font=2;txt.Color=Color3.fromRGB(200,170,0);txt.Outline=true;txt.OutlineColor=Color3.fromRGB(80,60,0);txt.Center=true;txt.Visible=true;txt.Position=Vector2.new(cx,cy);task.spawn(function()for i=0,35 do txt.Position=Vector2.new(cx+math.random(-2,2),cy-i*1.8);txt.Transparency=1-(i/35);task.wait(0.02)end;txt:Remove()end)end;

getgenv().hitLogConfig = { Enabled = false, Position = "Left", Duration = 4, MaxEntries = 6, Console = false, HitColor = Color3.fromRGB(255, 235, 110), KillColor = Color3.fromRGB(255, 70, 110) }
local LogHit
do
	local guiParent = (gethui and gethui()) or LocalPlayer:WaitForChild("PlayerGui")
	local oldGui = guiParent:FindFirstChild("HitLogs_NL")
	if oldGui then oldGui:Destroy() end
	local gui = Instance.new("ScreenGui")
	gui.Name = "HitLogs_NL"
	gui.ResetOnSpawn = false
	gui.IgnoreGuiInset = true
	gui.DisplayOrder = 50
	gui.Parent = guiParent

	local holder = Instance.new("Frame")
	holder.BackgroundTransparency = 1
	holder.Size = UDim2.new(0, 280, 0, 320)
	holder.Parent = gui
	local layout = Instance.new("UIListLayout")
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Padding = UDim.new(0, 4)
	layout.Parent = holder

	local entries = {}
	local counter = 0

	local function applyPosition()
		local position = getgenv().hitLogConfig.Position
		if position == "Right" then
			holder.AnchorPoint, holder.Position = Vector2.new(1, 0), UDim2.new(1, -16, 0.35, 0)
		elseif position == "Crosshair" then
			holder.AnchorPoint, holder.Position = Vector2.new(0.5, 0), UDim2.new(0.5, 0, 0.6, 0)
		else
			holder.AnchorPoint, holder.Position = Vector2.new(0, 0), UDim2.new(0, 16, 0.35, 0)
		end
	end
	getgenv().hitLogApply = applyPosition
	applyPosition()

	local function toHex(color)
		return string.format("#%02x%02x%02x", math.floor(color.R * 255 + 0.5), math.floor(color.G * 255 + 0.5), math.floor(color.B * 255 + 0.5))
	end

	LogHit = function(player, damage, health, killed)
		local cfg = getgenv().hitLogConfig
		if not cfg.Enabled then return end
		local color = killed and cfg.KillColor or cfg.HitColor
		local hex = toHex(color)
		local text, plain
		if killed then
			text = string.format('<font color="%s"><b>Killed</b></font> %s  <font color="%s">-100 HP</font>', hex, player.Name, hex)
			plain = "Killed " .. player.Name .. " -100 HP"
		else
			text = string.format('<font color="%s"><b>Hit</b></font> %s  <font color="%s">-100 HP</font>', hex, player.Name, hex)
			plain = "Hit " .. player.Name .. " -100 HP"
		end
		if cfg.Console then print("[HitLog] " .. plain) end

		counter = counter + 1
		local entry = Instance.new("Frame")
		entry.Size = UDim2.new(1, 0, 0, 26)
		entry.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
		entry.BackgroundTransparency = 1
		entry.LayoutOrder = -counter
		entry.Parent = holder
		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, 6)
		corner.Parent = entry
		local accent = Instance.new("Frame")
		accent.Size = UDim2.new(0, 3, 1, -8)
		accent.Position = UDim2.new(0, 4, 0, 4)
		accent.BackgroundColor3 = color
		accent.BackgroundTransparency = 1
		accent.BorderSizePixel = 0
		accent.Parent = entry
		local accentCorner = Instance.new("UICorner")
		accentCorner.CornerRadius = UDim.new(1, 0)
		accentCorner.Parent = accent
		local label = Instance.new("TextLabel")
		label.BackgroundTransparency = 1
		label.Position = UDim2.new(0, 14, 0, 0)
		label.Size = UDim2.new(1, -18, 1, 0)
		label.Font = Enum.Font.GothamMedium
		label.TextSize = 13
		label.TextColor3 = Color3.new(1, 1, 1)
		label.TextTransparency = 1
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.RichText = true
		label.Text = text
		label.Parent = entry

		table.insert(entries, entry)
		while #entries > cfg.MaxEntries do
			local oldest = table.remove(entries, 1)
			if oldest then oldest:Destroy() end
		end

		local info = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		TweenService:Create(entry, info, { BackgroundTransparency = 0.25 }):Play()
		TweenService:Create(accent, info, { BackgroundTransparency = 0 }):Play()
		TweenService:Create(label, info, { TextTransparency = 0 }):Play()

		task.delay(cfg.Duration, function()
			if not entry.Parent then return end
			local fade = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
			TweenService:Create(entry, fade, { BackgroundTransparency = 1 }):Play()
			TweenService:Create(accent, fade, { BackgroundTransparency = 1 }):Play()
			TweenService:Create(label, fade, { TextTransparency = 1 }):Play()
			task.wait(0.4)
			local index = table.find(entries, entry)
			if index then table.remove(entries, index) end
			entry:Destroy()
		end)
	end
end
getgenv().hitLogTest = function()
	local fake = { Name = "TestPlayer" }
	LogHit(fake, 34, 66, false)
	task.delay(0.4, function() LogHit(fake, 0, 0, true) end)
end
local function TrackPlayer(player) if player==LocalPlayer then return end;local function onChar(char) task.wait(0.5);local hum=char:WaitForChild("Humanoid",5);if not hum then return end;local lastHp=hum.Health;hum.HealthChanged:Connect(function(hp) local dmg=lastHp-hp;lastHp=hp;if dmg>0 and hp>0 then local tt=recentTargets[player];if tt and(tick()-tt)<5 then task.spawn(LogHit,player,dmg,hp,false)end end;if hp<=0 and WasMyKill(player) then local rp=char:FindFirstChild("HumanoidRootPart");if rp then task.spawn(PlayKillSound);task.spawn(LogHit,player,0,0,true);task.spawn(PlayKillEffect,rp.Position);task.spawn(ShowHitmarker,rp.Position)end end end);hum.Died:Connect(function() if WasMyKill(player) then local rp=char:FindFirstChild("HumanoidRootPart");if rp then task.spawn(PlayKillSound);task.spawn(LogHit,player,0,0,true);task.spawn(PlayKillEffect,rp.Position);task.spawn(ShowHitmarker,rp.Position)end end end)end;if player.Character then onChar(player.Character)end;player.CharacterAdded:Connect(onChar)end;
for _,p in pairs(PlayerService:GetPlayers()) do TrackPlayer(p)end;PlayerService.PlayerAdded:Connect(TrackPlayer);

getgenv().chamsConfig={Enabled=false,FillColor=Color3.fromRGB(170,0,255),OutlineColor=Color3.fromRGB(255,100,255),FillTransparency=0.6,OutlineTransparency=0};
local selfHighlight=nil;
local function ApplyChams() local char=LocalPlayer.Character;if not char then return end;if selfHighlight then selfHighlight:Destroy();selfHighlight=nil end;if not getgenv().chamsConfig.Enabled then return end;selfHighlight=Instance.new("Highlight");selfHighlight.Name="SelfChams";selfHighlight.FillColor=getgenv().chamsConfig.FillColor;selfHighlight.OutlineColor=getgenv().chamsConfig.OutlineColor;selfHighlight.FillTransparency=getgenv().chamsConfig.FillTransparency;selfHighlight.OutlineTransparency=getgenv().chamsConfig.OutlineTransparency;selfHighlight.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop;selfHighlight.Parent=char end;

getgenv().ratioConfig={Enabled=false,Resolution=0.80};
local ratioConn=nil;
local function ApplyRatio()
    if ratioConn then ratioConn:Disconnect();ratioConn=nil end;
    if not getgenv().ratioConfig.Enabled then return end;
    ratioConn=RunService.RenderStepped:Connect(function()
        if not getgenv().ratioConfig.Enabled then return end;
        local cam=WorkspaceService.CurrentCamera;
        if cam then
            cam.CFrame=cam.CFrame*CFrame.new(0,0,0,1,0,0,0,getgenv().ratioConfig.Resolution,0,0,0,1);
        end;
    end);
end;

getgenv().chinaHatConfig={Enabled=false,Color=Color3.fromRGB(255,0,0),Size=5,Transparency=0.5,Rotate=false,RotateSpeed=60,Rainbow=false,RainbowSpeed=1.5,Outline=true,OutlineColor=Color3.fromRGB(255,255,255),OutlineTransparency=0.75};
local chinaHatParts = {}
local chinaHatLayers = {}
local chinaHatConn = nil
local chinaHatHue = 0

local function ClearChinaHat()
	if chinaHatConn then
		chinaHatConn:Disconnect()
		chinaHatConn = nil
	end
	for _, part in ipairs(chinaHatParts) do
		if part and part.Parent then part:Destroy() end
	end
	chinaHatParts = {}
	chinaHatLayers = {}
end

local function ApplyChinaHat()
	ClearChinaHat()
	local cfg = getgenv().chinaHatConfig
	if not cfg.Enabled then return end
	local char = LocalPlayer.Character
	local head = char and char:FindFirstChild("Head")
	if not head then return end

	local radius = cfg.Size / 2
	local height = cfg.Size * 0.25

	local function addLayer(className, props, kind)
		local adornment = Instance.new(className)
		adornment.Adornee = head
		adornment.AlwaysOnTop = false
		for key, value in pairs(props) do
			pcall(function() adornment[key] = value end)
		end
		adornment.Parent = head
		table.insert(chinaHatParts, adornment)
		table.insert(chinaHatLayers, { adornment = adornment, kind = kind })
	end

	-- Flat translucent cone with a thin bright rim.
	addLayer("ConeHandleAdornment", { Height = height, Radius = radius, Color3 = cfg.Color, Transparency = cfg.Transparency, ZIndex = 1 }, "cone")
	if cfg.Outline then
		addLayer("CylinderHandleAdornment", { Height = 0.04, Radius = radius, InnerRadius = radius - 0.08, Color3 = cfg.OutlineColor, Transparency = 0, ZIndex = 2 }, "rim")
	end

	chinaHatHue = 0
	chinaHatConn = RunService.RenderStepped:Connect(function(dt)
		if not head or not head.Parent then
			ClearChinaHat()
			return
		end
		local c = getgenv().chinaHatConfig
		if c.Rainbow then chinaHatHue = (chinaHatHue + dt * c.RainbowSpeed * 0.3) % 1 end
		local cframe = CFrame.new(0, head.Size.Y / 2 + 0.05, 0) * CFrame.Angles(math.rad(90), 0, 0)
		local camera = WorkspaceService.CurrentCamera
		local hidden = camera ~= nil and (camera.CFrame.Position - head.Position).Magnitude < 1.5
		for _, layer in ipairs(chinaHatLayers) do
			local a = layer.adornment
			if a and a.Parent then
				a.CFrame = cframe
				a.Visible = not hidden
				if layer.kind == "cone" then
					a.Color3 = c.Rainbow and Color3.fromHSV(chinaHatHue, 0.85, 1) or c.Color
				else
					a.Color3 = c.Rainbow and Color3.fromHSV(chinaHatHue, 0.5, 1) or c.OutlineColor
				end
			end
		end
	end)
end

pcall(function()Airflow:LoadFont({Name="ValleySans"})end);
local Window=Airflow:CreateWindow({Name="femboy.xyz",LoadingSubtitle="femboy.xyz",Theme="Ember",ToggleUIKeybind="G",ConfigurationSaving={Enabled=true,FolderName="femboy_xyz",FileName="default"},Home={Name="Home",Stats={"FPS","Ping","Executor","Game"}}});
local function wrapTab(rawTab,tabName)
	local tab={Raw=rawTab};
	local function flagOf(title)return(tabName.."_"..title):gsub("[^%w_]","")end;
	function tab:Section(o)rawTab:CreateSection(o.Title)end;
	function tab:Toggle(o)return rawTab:CreateToggle({Name=o.Title,Desc=o.Desc,CurrentValue=(o.Value or o.Default)==true,Flag=o.Flag or flagOf(o.Title),Callback=function(v)if o.Callback then o.Callback(v)end end})end;
	function tab:Slider(o)local r=o.Value;return rawTab:CreateSlider({Name=o.Title,Desc=o.Desc,Range={r.Min,r.Max},Increment=o.Step or r.Step or 1,CurrentValue=r.Default,Flag=o.Flag or flagOf(o.Title),Callback=function(v)if o.Callback then o.Callback(v)end end})end;
	function tab:Dropdown(o)return rawTab:CreateDropdown({Name=o.Title,Options=o.Values,CurrentOption=o.Value or o.Values[1],Flag=o.Flag or flagOf(o.Title),Callback=function(v)if o.Callback then o.Callback(type(v)=="table"and v[1]or v)end end})end;
	function tab:Button(o)return rawTab:CreateButton({Name=o.Title,Desc=o.Desc,Callback=function()if o.Callback then o.Callback()end end})end;
	function tab:Colorpicker(o)return rawTab:CreateColorPicker({Name=o.Title,Color=o.Default,Flag=o.Flag or flagOf(o.Title),Callback=function(c)if o.Callback then o.Callback(c)end end})end;
	function tab:Keybind(o)return rawTab:CreateKeybind({Name=o.Title,CurrentKeybind=o.Value,Flag=o.Flag or flagOf(o.Title),Callback=function(key)if o.Callback then o.Callback(typeof(key)=="EnumItem"and key.Name or key)end end})end;
	return tab;
end;
local MainWindow={};
function MainWindow:Tab(o)return wrapTab(Window:CreateTab({Name=o.Title,Desc=o.Desc,Icon=o.Icon}),o.Title)end;
function MainWindow:Divider()end;
local UiManager={};
function UiManager:Notify(o)Airflow:Notify({Title=o.Title,Content=o.Content,Icon="bell",Type="Warning",Duration=o.Duration or 4})end;
local NV=nil;local NV1=nil;local KillAll={};
local TV={};local TV1={};local HT={"Press to try and refresh"};local ES="";local NV2=nil;local NV3=nil;
local function Func()if not LocalPlayer.Character then return end;TV1={};HT={};for _,v in ipairs(game:GetDescendants())do local n=v.Name;if v:IsA("Animation")and not TV1[n]then TV1[n]=v;table.insert(HT,n)end end;for _,v in ipairs(TV)do if not TV1[v]then local a=Instance.new("Animation");a.AnimationId=v;TV1[v]=a;table.insert(HT,v)end end;table.sort(HT)end;
local NV4=nil;local function PlayEmote(n)if not NV4 then NV4=0;UiManager:Notify({Title="Warning",Content="Some emotes require server replicated parts.",Duration=4,Icon="triangle-alert"})end;if NV3 then NV3:Stop()end;if TV1[n]then NV3=NV2:LoadAnimation(TV1[n]);NV3:Play()end end;
local function SetupAnimator()local H=LocalPlayer.Character:WaitForChild("Humanoid");NV2=H:WaitForChild("Animator");H:GetPropertyChangedSignal("MoveDirection"):Connect(function()if NV3 and H.MoveDirection.Magnitude>0 then NV3:Stop();NV3=nil end end)end;

local TI=MainWindow:Tab({Title="Information",Icon="info"});MainWindow:Divider();

do
	-- ESP and chams ported from CompKiller.
	local Camera = WorkspaceService.CurrentCamera
	local Config = {
		ESP = {
			Enabled = true, ShowBoxes = true, ShowNames = true, ShowHealth = true, ShowDistance = true,
			ShowTracers = false, ShowSkeleton = false, TeamCheck = true, ShowTeammates = false,
			TeamColor = Color3.fromRGB(0, 255, 0), EnemyColor = Color3.fromRGB(255, 0, 0), MaxDistance = 600, TracerOrigin = "Bottom",
		},
		Chams = false,
		ChamsVisibleColor = Color3.fromRGB(255, 255, 255),
		ChamsInvisibleColor = Color3.fromRGB(0, 0, 0),
		ChamsDamageColor = Color3.fromRGB(255, 0, 0),
	}
	local ESPObjects = {}
	local Bones = {
		{"Head","UpperTorso"},{"UpperTorso","LowerTorso"},
		{"UpperTorso","LeftUpperArm"},{"LeftUpperArm","LeftLowerArm"},{"LeftLowerArm","LeftHand"},
		{"UpperTorso","RightUpperArm"},{"RightUpperArm","RightLowerArm"},{"RightLowerArm","RightHand"},
		{"LowerTorso","LeftUpperLeg"},{"LeftUpperLeg","LeftLowerLeg"},{"LeftLowerLeg","LeftFoot"},
		{"LowerTorso","RightUpperLeg"},{"RightUpperLeg","RightLowerLeg"},{"RightLowerLeg","RightFoot"},
	}

	local function IsTeammate(player)
		if not player.Team or not LocalPlayer.Team then return false end
		return player.Team == LocalPlayer.Team
	end

	local function IsAlive(player)
		if not player or not player.Character then return false end
		local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
		if not humanoid or humanoid.Health <= 0 then return false end
		return player.Character:FindFirstChild("HumanoidRootPart") ~= nil
	end

	local function CreateESP(player)
		if player == LocalPlayer or ESPObjects[player] then return end
		pcall(function()
			local esp = {
				Box = Drawing.new("Square"), Name = Drawing.new("Text"), Health = Drawing.new("Text"),
				Distance = Drawing.new("Text"), HealthBar = Drawing.new("Square"), HealthBarBG = Drawing.new("Square"),
				Tracer = Drawing.new("Line"), Skeleton = {},
			}
			esp.Box.Thickness = 1; esp.Box.Filled = false; esp.Box.Visible = false
			esp.Name.Size = 13; esp.Name.Center = true; esp.Name.Outline = true; esp.Name.Font = 2; esp.Name.Visible = false
			esp.Health.Size = 12; esp.Health.Outline = true; esp.Health.Font = 2; esp.Health.Visible = false
			esp.Distance.Size = 12; esp.Distance.Center = true; esp.Distance.Outline = true; esp.Distance.Font = 2; esp.Distance.Visible = false
			esp.HealthBarBG.Filled = false; esp.HealthBarBG.Thickness = 1; esp.HealthBarBG.Color = Color3.new(0, 0, 0); esp.HealthBarBG.Visible = false
			esp.HealthBar.Filled = true; esp.HealthBar.Visible = false
			esp.Tracer.Thickness = 1; esp.Tracer.Visible = false
			for _ = 1, 14 do
				local bone = Drawing.new("Line")
				bone.Thickness = 1.5; bone.Visible = false
				table.insert(esp.Skeleton, bone)
			end
			ESPObjects[player] = esp
		end)
	end

	local function RemoveESP(player)
		local esp = ESPObjects[player]
		if not esp then return end
		pcall(function()
			for key, value in pairs(esp) do
				if key == "Skeleton" then
					for _, bone in pairs(value) do bone:Remove() end
				else
					value:Remove()
				end
			end
		end)
		ESPObjects[player] = nil
	end

	local function UpdateESP()
		for player, esp in pairs(ESPObjects) do
			local function hide()
				esp.Box.Visible = false; esp.Name.Visible = false; esp.Health.Visible = false
				esp.Distance.Visible = false; esp.HealthBar.Visible = false; esp.HealthBarBG.Visible = false
				esp.Tracer.Visible = false
				for _, bone in pairs(esp.Skeleton) do bone.Visible = false end
			end
			if not player.Parent or not Config.ESP.Enabled or not IsAlive(player) then
				hide()
				if not player.Parent then RemoveESP(player) end
				continue
			end
			local isTeam = IsTeammate(player)
			if Config.ESP.TeamCheck and isTeam then hide() continue end
			if not Config.ESP.TeamCheck and isTeam and not Config.ESP.ShowTeammates then hide() continue end
			local char = player.Character
			local root = char:FindFirstChild("HumanoidRootPart")
			local head = char:FindFirstChild("Head")
			local hum = char:FindFirstChildOfClass("Humanoid")
			if not root or not head or not hum then hide() continue end
			local dist = (root.Position - Camera.CFrame.Position).Magnitude
			if dist > Config.ESP.MaxDistance then hide() continue end
			local sp, on = Camera:WorldToViewportPoint(root.Position)
			if not on then hide() continue end
			local hp2 = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
			local lp = Camera:WorldToViewportPoint(root.Position - Vector3.new(0, 3, 0))
			local bH = math.abs(hp2.Y - lp.Y)
			local bW = bH / 1.8
			local col = isTeam and Config.ESP.TeamColor or Config.ESP.EnemyColor

			if Config.ESP.ShowBoxes then
				esp.Box.Size = Vector2.new(bW, bH); esp.Box.Position = Vector2.new(sp.X - bW / 2, hp2.Y)
				esp.Box.Color = col; esp.Box.Visible = true
			else esp.Box.Visible = false end

			if Config.ESP.ShowNames then
				esp.Name.Text = player.Name; esp.Name.Position = Vector2.new(sp.X, hp2.Y - 16)
				esp.Name.Color = col; esp.Name.Visible = true
			else esp.Name.Visible = false end

			if Config.ESP.ShowHealth then
				local hpp = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
				local hpH = bH * hpp
				esp.HealthBarBG.Size = Vector2.new(4, bH); esp.HealthBarBG.Position = Vector2.new(sp.X - bW / 2 - 7, hp2.Y); esp.HealthBarBG.Visible = true
				esp.HealthBar.Size = Vector2.new(2, hpH); esp.HealthBar.Position = Vector2.new(sp.X - bW / 2 - 6, hp2.Y + (bH - hpH))
				esp.HealthBar.Color = Color3.fromRGB(255 * (1 - hpp), 255 * hpp, 0); esp.HealthBar.Visible = true
				esp.Health.Text = tostring(math.floor(hum.Health)); esp.Health.Position = Vector2.new(sp.X - bW / 2 - 22, hp2.Y + (bH - hpH) - 6)
				esp.Health.Color = Color3.new(1, 1, 1); esp.Health.Visible = true
			else
				esp.Health.Visible = false; esp.HealthBar.Visible = false; esp.HealthBarBG.Visible = false
			end

			if Config.ESP.ShowDistance then
				esp.Distance.Text = math.floor(dist) .. "m"; esp.Distance.Position = Vector2.new(sp.X, lp.Y + 2)
				esp.Distance.Color = Color3.new(1, 1, 1); esp.Distance.Visible = true
			else esp.Distance.Visible = false end

			if Config.ESP.ShowTracers then
				local from = Config.ESP.TracerOrigin == "Bottom" and Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y) or GetScreenCenter()
				esp.Tracer.From = from; esp.Tracer.To = Vector2.new(sp.X, sp.Y); esp.Tracer.Color = col; esp.Tracer.Visible = true
			else esp.Tracer.Visible = false end

			if Config.ESP.ShowSkeleton then
				for i, pair in ipairs(Bones) do
					local bone = esp.Skeleton[i]
					if bone then
						local p1, p2 = char:FindFirstChild(pair[1]), char:FindFirstChild(pair[2])
						if p1 and p2 then
							local s1, o1 = Camera:WorldToViewportPoint(p1.Position)
							local s2, o2 = Camera:WorldToViewportPoint(p2.Position)
							if o1 and o2 then
								bone.From = Vector2.new(s1.X, s1.Y); bone.To = Vector2.new(s2.X, s2.Y)
								bone.Color = col; bone.Visible = true
							else bone.Visible = false end
						else bone.Visible = false end
					end
				end
			else
				for _, bone in pairs(esp.Skeleton) do bone.Visible = false end
			end
		end
	end

	for _, player in ipairs(PlayerService:GetPlayers()) do CreateESP(player) end
	PlayerService.PlayerAdded:Connect(CreateESP)

	local ChamsHighlights = {}
	local ChamsLastHealth = {}

	local function RemoveChams(player)
		if ChamsHighlights[player] then
			ChamsHighlights[player]:Destroy()
			ChamsHighlights[player] = nil
		end
		ChamsLastHealth[player] = nil
	end

	PlayerService.PlayerRemoving:Connect(function(player)
		RemoveESP(player)
		RemoveChams(player)
	end)

	local function CreateChams(player)
		if ChamsHighlights[player] then return ChamsHighlights[player] end
		local character = player.Character
		if not character then return end
		local humanoid = character:FindFirstChild("Humanoid")
		if not humanoid or humanoid.Health <= 0 then return end
		local highlight = Instance.new("Highlight")
		highlight.Adornee = character; highlight.FillTransparency = 0.2; highlight.OutlineTransparency = 1
		highlight.FillColor = Config.ChamsVisibleColor; highlight.Parent = WorkspaceService
		ChamsHighlights[player] = highlight
		return highlight
	end

	local chamsParams = RaycastParams.new()
	chamsParams.FilterType = Enum.RaycastFilterType.Exclude

	local function IsBehindWallChams(player)
		local character = player.Character
		local root = character and character:FindFirstChild("HumanoidRootPart")
		if not root then return false end
		chamsParams.FilterDescendantsInstances = { LocalPlayer.Character, character }
		local result = WorkspaceService:Raycast(Camera.CFrame.Position, root.Position - Camera.CFrame.Position, chamsParams)
		return result ~= nil
	end

	local function UpdateChams()
		for _, player in ipairs(PlayerService:GetPlayers()) do
			if player == LocalPlayer or IsTeammate(player) then RemoveChams(player) continue end
			if not IsAlive(player) then RemoveChams(player) continue end
			local highlight = CreateChams(player)
			if not highlight then continue end
			local blocked = IsBehindWallChams(player)
			highlight.FillColor = blocked and Config.ChamsInvisibleColor or Config.ChamsVisibleColor
			highlight.FillTransparency = blocked and 0 or 0.2
			local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
			local last = ChamsLastHealth[player] or humanoid.MaxHealth
			if humanoid.Health < last then
				highlight.FillColor = Config.ChamsDamageColor
				task.delay(0.3, function()
					if ChamsHighlights[player] and humanoid.Health > 0 then
						highlight.FillColor = IsBehindWallChams(player) and Config.ChamsInvisibleColor or Config.ChamsVisibleColor
					end
				end)
			end
			ChamsLastHealth[player] = humanoid.Health
		end
	end

	RunService.RenderStepped:Connect(function()
		Camera = WorkspaceService.CurrentCamera
		if not Camera then return end
		UpdateESP()
		if Config.Chams then
			UpdateChams()
		else
			for player in pairs(ChamsHighlights) do RemoveChams(player) end
		end
	end)

	local EspTab = MainWindow:Tab({Title="ESP",Icon="eye"})
	EspTab:Section({Title="ESP",Icon="eye"})
	EspTab:Toggle({Title="Enable",Value=true,Callback=function(v)Config.ESP.Enabled=v end})
	EspTab:Toggle({Title="Boxes",Value=true,Callback=function(v)Config.ESP.ShowBoxes=v end})
	EspTab:Toggle({Title="Names",Value=true,Callback=function(v)Config.ESP.ShowNames=v end})
	EspTab:Toggle({Title="Health",Value=true,Callback=function(v)Config.ESP.ShowHealth=v end})
	EspTab:Toggle({Title="Distance",Value=true,Callback=function(v)Config.ESP.ShowDistance=v end})
	EspTab:Toggle({Title="Tracers",Value=false,Callback=function(v)Config.ESP.ShowTracers=v end})
	EspTab:Toggle({Title="Skeleton",Value=false,Callback=function(v)Config.ESP.ShowSkeleton=v end})
	EspTab:Section({Title="Team Settings",Icon="users"})
	EspTab:Toggle({Title="Team Check",Value=true,Callback=function(v)Config.ESP.TeamCheck=v end})
	EspTab:Toggle({Title="Show Teammates",Value=false,Callback=function(v)Config.ESP.ShowTeammates=v end})
	EspTab:Colorpicker({Title="Enemy Color",Default=Color3.fromRGB(255,0,0),Callback=function(v)Config.ESP.EnemyColor=v end})
	EspTab:Colorpicker({Title="Team Color",Default=Color3.fromRGB(0,255,0),Callback=function(v)Config.ESP.TeamColor=v end})
	EspTab:Dropdown({Title="Tracer Origin",Values={"Bottom","Center"},Value="Bottom",Callback=function(v)Config.ESP.TracerOrigin=(type(v)=="table" and v[1] or v)end})
	EspTab:Slider({Title="Max Distance",Step=10,Value={Min=100,Max=2000,Default=600},Callback=function(v)Config.ESP.MaxDistance=tonumber(v)end})
	EspTab:Section({Title="Enemy Visuals",Icon="eye"})
	EspTab:Toggle({Title="Chams",Value=false,Callback=function(v)Config.Chams=v end})
	EspTab:Colorpicker({Title="Visible Color",Default=Color3.fromRGB(255,255,255),Callback=function(v)Config.ChamsVisibleColor=v end})
	EspTab:Colorpicker({Title="Invisible Color",Default=Color3.fromRGB(0,0,0),Callback=function(v)Config.ChamsInvisibleColor=v end})
	EspTab:Colorpicker({Title="Damage Color",Default=Color3.fromRGB(255,0,0),Callback=function(v)Config.ChamsDamageColor=v end})
end

local RageTab=MainWindow:Tab({Title="Rage",Icon="skull"});
local AutoFarmTab=MainWindow:Tab({Title="Auto Farm",Icon="scroll"});AutoFarmTab:Section({Title="Auto Farm",Icon="biceps-flexed"});local lobbyFolder=WorkspaceService:FindFirstChild("Lobby");local DRG=lobbyFolder and lobbyFolder:WaitForChild("DuelRingsGroup",10);AutoFarmTab:Toggle({Title="Auto Farm Duels",Value=false,Callback=function(v)getgenv().autoFarmDuels=v;if v then if not getgenv().killLoop then getgenv().killLoop={}end;if not getgenv().killLoop.knife then getgenv().killLoop.knife=true;KillAll.loop("knife")end elseif getgenv().killLoop and getgenv().killLoop.knife then getgenv().killLoop.knife=false end end});getgenv().autoFarmDuels=false;RunService.Heartbeat:Connect(function()if getgenv().autoFarmDuels and DRG then if LocalPlayer:GetAttribute("Match")then return end;for _,r in ipairs(DRG:GetChildren())do if r.Name=="DuelRing_1v1"then local dp=r:FindFirstChild("DuelPad");if dp then for _,_ in ipairs(dp:GetChildren())do local P=r:GetChildren()[3]and r:GetChildren()[3]:FindFirstChild("Pad")or dp:FindFirstChild("Pad",true);if P and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")then LocalPlayer.Character.HumanoidRootPart.CFrame=P.CFrame+Vector3.new(0,3,0);return end end end end end end end);

RageTab:Section({Title="Kill all",Icon="sword"});RageTab:Button({Title="[Knife] Kill All",Callback=function()task.spawn(pcall,KillAll.knife)end});RageTab:Button({Title="[Gun] Kill All",Callback=function()task.spawn(pcall,KillAll.gun)end});RageTab:Section({Title="Loop Kill all",Icon="swords"});NV1=RageTab:Toggle({Title="[Knife] Loop Kill All",Callback=function(v)getgenv().killLoop.knife=v;if v then KillAll.loop("knife")end end});NV=RageTab:Toggle({Title="[Gun] Loop Kill All",Callback=function(v)getgenv().killLoop.gun=v;if v then KillAll.loop("gun")end end});
getgenv().killPriorityPlayer=nil;
local function killPriorityNames()local list={"None"};for _,pl in ipairs(PlayerService:GetPlayers())do if pl~=LocalPlayer then table.insert(list,pl.Name)end end;return list end;
local killPriorityDropdown=RageTab:Dropdown({Title="Kill Priority",Values=killPriorityNames(),Value="None",Callback=function(v)getgenv().killPriorityPlayer=v~="None"and v or nil end});
local function refreshKillPriority()if killPriorityDropdown and killPriorityDropdown.Refresh then pcall(killPriorityDropdown.Refresh,killPriorityDropdown,killPriorityNames())end end;
PlayerService.PlayerAdded:Connect(refreshKillPriority);
PlayerService.PlayerRemoving:Connect(function()task.delay(0.2,refreshKillPriority)end);
RageTab:Button({Title="Refresh Players",Callback=refreshKillPriority});

RageTab:Section({Title="Gun Auto Shoot",Icon="zap"});getgenv().autoShootConfig={Enabled=false,AntiWallbang=true,IgnoreWalls=false,HeadshotOnly=true,UseFOV=true,FOVRadius=150};
local asRP=RaycastParams.new();asRP.IgnoreWater=true;asRP.FilterType=Enum.RaycastFilterType.Exclude;
local function getGunTool()local ch=LocalPlayer.Character;if not ch then return nil end;for _,v in ipairs(ch:GetChildren())do if v:IsA("Tool")and v:FindFirstChild("Muzzle",true)then return v end end;return nil end;
local function getMuzzlePos()local g=getGunTool();if not g then return nil,nil end;local m=g:FindFirstChild("Muzzle",true);if not m then return nil,nil end;return m.WorldPosition,g end;
local function canSeeAS(tp,o)if getgenv().autoShootConfig.IgnoreWalls then return true end;if not getgenv().autoShootConfig.AntiWallbang then return true end;local ch=LocalPlayer.Character;if not ch then return false end;asRP.FilterDescendantsInstances={ch};local d=tp.Position-o;local r=WorkspaceService:Raycast(o,d.Unit*d.Magnitude,asRP);if not r then return true end;return r.Instance:IsDescendantOf(tp.Parent)end;
local function canSeeHH(tp,o)if getgenv().autoShootConfig.IgnoreWalls then local c=tp.Character;return c and c:FindFirstChild("Head")~=nil,c and c:FindFirstChild("Head")and c.Head.Position end;local ch=tp.Character;if not ch then return false,nil end;local hd=ch:FindFirstChild("Head");if not hd then return false,nil end;local mc=LocalPlayer.Character;if not mc then return false,nil end;asRP.FilterDescendantsInstances={mc};local hrp=ch:FindFirstChild("HumanoidRootPart");local es=5;if hrp then local s=hrp.Size.X;if s>es then es=s end end;local hp=hd.Position;for _,off in ipairs({Vector3.new(0,0,0),Vector3.new(es/2,0,0),Vector3.new(-es/2,0,0),Vector3.new(0,0,es/2),Vector3.new(0,0,-es/2),Vector3.new(0,es/2,0),Vector3.new(0,-es/2,0)})do local d=hp+off-o;local r=WorkspaceService:Raycast(o,d.Unit*d.Magnitude,asRP);if not r or r.Instance:IsDescendantOf(ch)then return true,hp end end;return false,hp end;
local function findTargets(myH)
	local mp=getMuzzlePos();if not mp then return {} end;
	local list={};local cfg=getgenv().autoShootConfig;
	for _,pl in ipairs(PlayerService:GetPlayers())do
		if pl~=LocalPlayer and pl.Character and pl.Character.Parent and(not pl.Team or not LocalPlayer.Team or pl.Team~=LocalPlayer.Team)then
			local ch=pl.Character;local hm=ch:FindFirstChild("Humanoid");local hrp=ch:FindFirstChild("HumanoidRootPart");local hd=ch:FindFirstChild("Head");
			if hm and hm.Health>0 and hrp and hd then
				local d=(hrp.Position-myH.Position).Magnitude;
				if d<=MaxDistance then
					local ok=true;
					if cfg.UseFOV and not isInFOV(hd.Position,cfg.FOVRadius)then ok=false end;
					if ok and not cfg.IgnoreWalls and cfg.AntiWallbang and not canSeeHH(pl,mp)then ok=false end;
					if ok then table.insert(list,{player=pl,head=hd,dist=d})end;
				end;
			end;
		end;
	end;
	table.sort(list,function(x,y)return x.dist<y.dist end);
	return list;
end;
local function findBGT(myH)local first=findTargets(myH)[1];if first then return first.player,first.head end;return nil,nil end;
getgenv().tracerConfig={Enabled=false,Style="Line",Color=Color3.fromRGB(255,60,60),Rainbow=false,Width=0.12,Duration=0.6,Transparency=0.1};
local tracerFolder=Instance.new("Folder");tracerFolder.Name="Tracers_Local";tracerFolder.Parent=WorkspaceService;
local function CreateBulletTracer(from,to)
	local cfg=getgenv().tracerConfig;if not cfg.Enabled then return end;
	local dir=to-from;local len=dir.Magnitude;if len<0.1 then return end;
	local color=cfg.Rainbow and Color3.fromHSV((os.clock()*0.5)%1,0.8,1) or cfg.Color;
	local width,duration,baseTransparency,style=cfg.Width,math.max(cfg.Duration,0.05),cfg.Transparency,cfg.Style;
	local points={from};
	if style=="Zigzag" then
		local unit=dir.Unit;local side=unit:Cross(Vector3.yAxis);if side.Magnitude<0.01 then side=Vector3.xAxis end;side=side.Unit;
		local up=side:Cross(unit);local count=math.clamp(math.floor(len/4),2,24);
		for i=1,count-1 do table.insert(points,from+dir*(i/count)+side*(math.random()-0.5)*1.2+up*(math.random()-0.5)*1.2)end;
	end;
	table.insert(points,to);
	local entries={};
	local function addSegment(a,b,thickness,transparency)
		local part=Instance.new("Part");part.Anchored=true;part.CanCollide=false;part.CanQuery=false;part.CanTouch=false;part.CastShadow=false;
		part.Material=Enum.Material.Neon;part.Color=color;part.Transparency=transparency;
		part.Size=Vector3.new(thickness,thickness,(b-a).Magnitude);part.CFrame=CFrame.lookAt((a+b)/2,b);part.Parent=tracerFolder;
		table.insert(entries,{part=part,base=transparency});
	end;
	for i=1,#points-1 do
		local a,b=points[i],points[i+1];
		if (b-a).Magnitude>0.01 then
			addSegment(a,b,width,baseTransparency);
			if style=="Glow" then addSegment(a,b,width*3,0.75)end;
		end;
	end;
	task.spawn(function()
		local start=os.clock();
		while true do
			local t=(os.clock()-start)/duration;
			if t>=1 then break end;
			for _,e in ipairs(entries)do if e.part.Parent then e.part.Transparency=e.base+(1-e.base)*t end end;
			task.wait();
		end;
		for _,e in ipairs(entries)do e.part:Destroy()end;
	end);
end;
local shootTracks=setmetatable({},{__mode="k"});
local function playShootAnimation(animator)
	local track=shootTracks[animator];
	if not track then track=animator:LoadAnimation(ShootAnimation);shootTracks[animator]=track end;
	track:Play();
end;
local function prepareShot(tH)
	local mp,gun=getMuzzlePos();if not mp or not gun then return nil end;
	if not tH or not tH:IsDescendantOf(WorkspaceService)then return nil end;
	local hm=tH.Parent and tH.Parent:FindFirstChildOfClass("Humanoid");
	if hm and hm.Health<=0 then return nil end;
	local tPos;
	if getgenv().autoShootConfig.HeadshotOnly then tPos=tH.Position else local hrp=tH.Parent and tH.Parent:FindFirstChild("HumanoidRootPart");tPos=hrp and hrp.Position+Vector3.new(0,2,0)or tH.Position end;
	if not getgenv().autoShootConfig.IgnoreWalls and getgenv().autoShootConfig.AntiWallbang then
		if not canSeeAS(tH,mp)then
			local tp=PlayerService:GetPlayerFromCharacter(tH.Parent);
			if not tp or not canSeeHH(tp,mp)then return nil end;
		end;
	end;
	return mp,gun,tPos;
end;
local function execGunShoot(tH,anim,count)
	count=count or 1;
	local mp,gun,tPos=prepareShot(tH);if not mp then return false end;
	pcall(playShootAnimation,anim);
	pcall(function()local f=gun:FindFirstChild("Fire");if f then f:Play()end end);
	for _=1,count do
		CreateBulletTracer(mp,tPos);
		pcall(function()BulletRenderer(mp,tPos,"Default")end);
		ShootGunRemote:FireServer(mp,tPos,tH,tPos);
	end;
	RegisterMyTarget(PlayerService:GetPlayerFromCharacter(tH.Parent));
	return true;
end;
getgenv().doubleTapConfig={Enabled=false,RechargeTime=1,Teleport=true,TeleportDistance=4};
getgenv().autoShootConfig.ShotDelay=0.08;getgenv().autoShootConfig.NoLimit=false;getgenv().autoShootConfig.NoDelay=false;getgenv().autoShootConfig.BurstPerTick=3;
local DoubleTap={charged=true,rechargeAt=0,retryAt=0};
local ShotLock={pending=false,busy=false,releaseAt=0,nextShotAt=0,backoff=1,conn=nil};
local targetLocks={};
local function releaseShot(confirmed)
	if ShotLock.conn then ShotLock.conn:Disconnect();ShotLock.conn=nil end;
	ShotLock.pending=false;
	ShotLock.backoff=confirmed==true and 1 or math.min(ShotLock.backoff*1.25,2);
end;
local function shotTimeout()return math.clamp(LocalPlayer:GetNetworkPing()*2+0.05,0.08,0.35)end;
local function lockShot(tH)
	local hm=tH.Parent and tH.Parent:FindFirstChildOfClass("Humanoid");
	local gun=getGunTool();local cooldown=gun and tonumber(gun:GetAttribute("Cooldown"))or 0;
	local now=os.clock();
	ShotLock.nextShotAt=now+math.max(getgenv().autoShootConfig.ShotDelay,cooldown);
	ShotLock.pending=true;
	ShotLock.releaseAt=now+math.min(shotTimeout()*ShotLock.backoff,0.5);
	if hm then ShotLock.conn=hm.HealthChanged:Connect(function()releaseShot(true)end)end;
end;
local function lockTarget(target)
	local hm=target.head.Parent and target.head.Parent:FindFirstChildOfClass("Humanoid");
	local player=target.player;
	targetLocks[player]=os.clock()+shotTimeout();
	if hm then hm.HealthChanged:Once(function()targetLocks[player]=nil end)end;
end;
local function doubleTapTeleport(hrp,tH)
	local dist=getgenv().doubleTapConfig.TeleportDistance;
	local flat=(tH.Position-hrp.Position)*Vector3.new(1,0,1);if flat.Magnitude<0.1 then return false end;
	local right=flat.Unit:Cross(Vector3.yAxis);
	local params=RaycastParams.new();params.FilterType=Enum.RaycastFilterType.Exclude;params.FilterDescendantsInstances={hrp.Parent};
	local function isFree(dir)
		if WorkspaceService:Raycast(hrp.Position,dir*(dist+1.5),params)then return false end;
		return WorkspaceService:Raycast(hrp.Position+dir*dist,Vector3.new(0,-8,0),params)~=nil;
	end;
	local rightFree,leftFree=isFree(right),isFree(-right);
	local dir;
	if rightFree and leftFree then
		local hum=hrp.Parent:FindFirstChildOfClass("Humanoid");local move=hum and hum.MoveDirection*Vector3.new(1,0,1)or Vector3.zero;
		if move.Magnitude>0.1 then
			move=move.Unit;
			if isFree(move)then dir=move else dir=move:Dot(right)>=0 and right or-right end;
		else dir=math.random(1,2)==1 and right or-right end;
	elseif rightFree then dir=right elseif leftFree then dir=-right else return false end;
	hrp.CFrame=hrp.CFrame+dir*dist;
	return true;
end;
local function matchActive()return not getgenv().modsRequireMatch or LocalPlayer:GetAttribute("Match")~=nil end;
local function fireDoubleTap(hrp,anim,tH)
	local cfg=getgenv().doubleTapConfig;
	if not prepareShot(tH)then return false end;
	local moved=false;local shift=Vector3.zero;
	local function revert()if moved and hrp.Parent then hrp.CFrame=hrp.CFrame-shift end end;
	if cfg.Teleport then
		local before=hrp.Position;
		moved=doubleTapTeleport(hrp,tH);
		if moved then shift=hrp.Position-before end;
	end;
	if moved then
		task.wait(math.clamp(LocalPlayer:GetNetworkPing()*0.5+0.03,0.04,0.15));
		if not hrp.Parent or not prepareShot(tH)then revert();DoubleTap.retryAt=os.clock()+1;return false end;
	end;
	if not execGunShoot(tH,anim,1)then revert();DoubleTap.retryAt=os.clock()+1;return false end;
	DoubleTap.charged=false;DoubleTap.rechargeAt=os.clock()+cfg.RechargeTime;
	task.wait(0.05);
	execGunShoot(tH,anim,1);
	return true;
end;
local function shootTarget(hrp,anim,tH)
	if getgenv().doubleTapConfig.Enabled and DoubleTap.charged and os.clock()>=DoubleTap.retryAt and matchActive()then
		if fireDoubleTap(hrp,anim,tH)then return true end;
	end;
	return execGunShoot(tH,anim,1);
end;
local function autoShootTick(hrp,anim)
	local cfg=getgenv().autoShootConfig;
	if not DoubleTap.charged and os.clock()>=DoubleTap.rechargeAt then DoubleTap.charged=true end;
	if cfg.NoLimit then
		for _,target in ipairs(findTargets(hrp))do execGunShoot(target.head,anim,cfg.BurstPerTick)end;
		return;
	end;
	if cfg.NoDelay then
		for _,target in ipairs(findTargets(hrp))do
			local lock=targetLocks[target.player];
			if not lock or os.clock()>=lock then
				if shootTarget(hrp,anim,target.head)then lockTarget(target)end;
			end;
		end;
		return;
	end;
	if os.clock()<ShotLock.nextShotAt then return end;
	if ShotLock.pending then if os.clock()<ShotLock.releaseAt then return end;releaseShot(false)end;
	local target=findTargets(hrp)[1];if not target then return end;
	if shootTarget(hrp,anim,target.head)then lockShot(target.head)end;
end;
local gasConns={};
local function gunAutoShootStep()
	if ShotLock.busy or not getgenv().autoShootConfig.Enabled then return end;
	local ch=LocalPlayer.Character;if not ch then return end;
	local hrp=ch:FindFirstChild("HumanoidRootPart");local hm=ch:FindFirstChildOfClass("Humanoid");local an=hm and hm:FindFirstChild("Animator");
	if not hrp or not hm or not an or hm.Health<=0 then return end;
	ShotLock.busy=true;
	local ok,err=pcall(autoShootTick,hrp,an);
	ShotLock.busy=false;
	if not ok then warn(err)end;
end;
RageTab:Toggle({Title="Gun Auto Shoot",Callback=function(s)
	getgenv().autoShootConfig.Enabled=s;
	if s and #gasConns==0 then
		gasConns[1]=RunService.Heartbeat:Connect(gunAutoShootStep);
		gasConns[2]=RunService.Stepped:Connect(gunAutoShootStep);
	elseif not s then
		for _,c in ipairs(gasConns)do c:Disconnect()end;
		table.clear(gasConns);table.clear(targetLocks);releaseShot(true);
	end;
end});
RageTab:Section({Title="Gun Settings",Icon="settings"});RageTab:Toggle({Title="Anti Wallbang",Value=true,Callback=function(v)getgenv().autoShootConfig.AntiWallbang=v end});RageTab:Toggle({Title="Ignore Walls",Value=false,Callback=function(v)getgenv().autoShootConfig.IgnoreWalls=v end});RageTab:Toggle({Title="Headshot Only",Value=true,Callback=function(v)getgenv().autoShootConfig.HeadshotOnly=v end});RageTab:Toggle({Title="Use FOV Check",Value=true,Callback=function(v)getgenv().autoShootConfig.UseFOV=v end});RageTab:Slider({Title="Gun FOV Radius",Value={Min=30,Max=500,Default=150},Callback=function(v)getgenv().autoShootConfig.FOVRadius=tonumber(v)end});
RageTab:Slider({Title="Shot Delay",Step=0.01,Value={Min=0.02,Max=0.5,Default=0.08},Callback=function(v)getgenv().autoShootConfig.ShotDelay=tonumber(v)end});
RageTab:Toggle({Title="Remove Limit",Value=false,Callback=function(v)getgenv().autoShootConfig.NoLimit=v end});
RageTab:Toggle({Title="Remove Delay",Value=false,Callback=function(v)getgenv().autoShootConfig.NoDelay=v end});
RageTab:Section({Title="Silent Aim",Icon="crosshair"});
getgenv().silentAimConfig={Enabled=false,FOVRadius=100,ShowFOV=false,WallCheck=true};
local saGuiService=game:GetService("GuiService");
local saState={circle=nil,tool=nil,lastShot=0};
local saTouches={};
local saIsMobile=UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled;
local saRP=RaycastParams.new();saRP.IgnoreWater=true;saRP.FilterType=Enum.RaycastFilterType.Exclude;
local function saVisible(origin,part)
	local ch=LocalPlayer.Character;if not ch then return false end;
	saRP.FilterDescendantsInstances={ch};
	local r=WorkspaceService:Raycast(origin,part.Position-origin,saRP);
	return r==nil or r.Instance:IsDescendantOf(part.Parent);
end;
local function saGetTarget(origin)
	local cam=WorkspaceService.CurrentCamera;if not cam then return nil end;
	local center=GetScreenCenter();
	local cfg=getgenv().silentAimConfig;
	local bestPlayer,bestPart,bestDist=nil,nil,cfg.FOVRadius;
	for _,pl in ipairs(PlayerService:GetPlayers())do
		local ch=pl.Character;
		if pl~=LocalPlayer and ch and(not pl.Team or not LocalPlayer.Team or pl.Team~=LocalPlayer.Team)then
			local hm=ch:FindFirstChildOfClass("Humanoid");
			if hm and hm.Health>0 then
				for _,part in ipairs(ch:GetChildren())do
					if part:IsA("BasePart")and part.Name~="HumanoidRootPart"then
						local sp,on=cam:WorldToViewportPoint(part.Position);
						if on then
							local d=(Vector2.new(sp.X,sp.Y)-center).Magnitude;
							if d<bestDist and(not cfg.WallCheck or saVisible(origin,part))then bestPlayer,bestPart,bestDist=pl,part,d end;
						end;
					end;
				end;
			end;
		end;
	end;
	return bestPlayer,bestPart;
end;
local function saShoot(screenPoint)
	if os.clock()-saState.lastShot<0.15 then return end;
	if getgenv().aaPause and getgenv().aaPause()then task.wait(0.08)end;
	local mp,gun=getMuzzlePos();if not mp or not gun then return end;
	local cam=WorkspaceService.CurrentCamera;if not cam then return end;
	saState.lastShot=os.clock();
	local pl,part=saGetTarget(mp);
	local pos,hitPart;
	if pl and part then
		pos=part.Position;hitPart=part;
	else
		local ray;
		if screenPoint then ray=cam:ScreenPointToRay(screenPoint.X,screenPoint.Y)
		else local c=GetScreenCenter();ray=cam:ViewportPointToRay(c.X,c.Y)end;
		local hit=WorkspaceService:Raycast(ray.Origin,ray.Direction*5000,saRP);
		pos=hit and hit.Position or ray.Origin+ray.Direction*5000;
	end;
	local ch=LocalPlayer.Character;
	local hum=ch and ch:FindFirstChildOfClass("Humanoid");
	local animator=hum and hum:FindFirstChildOfClass("Animator");
	if animator then pcall(playShootAnimation,animator)end;
	pcall(function()local f=gun:FindFirstChild("Fire");if f then f:Play()end end);
	CreateBulletTracer(mp,pos);
	pcall(function()BulletRenderer(mp,pos,"Default")end);
	ShootGunRemote:FireServer(mp,pos,hitPart,pos);
	if pl then RegisterMyTarget(pl)end;
end;
local function saFireZone(p)
	if not saIsMobile then return false end;
	local v=WorkspaceService.CurrentCamera.ViewportSize;
	return p.X>=v.X*0.82 and p.Y>=v.Y*0.30 and p.Y<=v.Y*0.48;
end;
local function saControlZone(p)
	if not saIsMobile then return false end;
	local v=WorkspaceService.CurrentCamera.ViewportSize;
	if p.X>=v.X*0.78 and p.Y>v.Y*0.62 then return true end;
	if p.X>=v.X*0.68 and p.Y>=v.Y*0.46 then return true end;
	if p.Y>=v.Y*0.66 then return true end;
	if p.X<=v.X*0.42 and p.Y>=v.Y*0.48 then return true end;
	if p.Y>=v.Y*0.58 and p.X>=v.X*0.35 then return true end;
	return false;
end;
UserInputService.InputBegan:Connect(function(input,processed)
	if processed or not getgenv().silentAimConfig.Enabled then return end;
	if input.UserInputType~=Enum.UserInputType.MouseButton1 then return end;
	local m=UserInputService:GetMouseLocation();
	saShoot(Vector2.new(m.X,m.Y));
end);
UserInputService.TouchStarted:Connect(function(touch,processed)
	if not getgenv().silentAimConfig.Enabled then return end;
	local p=Vector2.new(touch.Position.X,touch.Position.Y);
	local fire=saFireZone(p);
	if saControlZone(p)or(processed and not fire)then return end;
	saTouches[touch]={t=os.clock(),p=p};
end);
UserInputService.TouchEnded:Connect(function(touch,processed)
	local info=saTouches[touch];saTouches[touch]=nil;
	if not getgenv().silentAimConfig.Enabled then return end;
	local p=Vector2.new(touch.Position.X,touch.Position.Y);
	local fire=saFireZone(p);
	if saControlZone(p)or(processed and not fire)then return end;
	if not info and not fire then return end;
	if info and not fire then
		local v=WorkspaceService.CurrentCamera.ViewportSize;
		if os.clock()-info.t>0.2 or(p-info.p).Magnitude>math.clamp(v.X*0.018,18,34)then return end;
	end;
	saShoot(not fire and p or nil);
end);
RunService.RenderStepped:Connect(function()
	local cfg=getgenv().silentAimConfig;
	local gun=getGunTool();
	if cfg.Enabled and gun then
		saState.tool=gun;
		if gun.Enabled then pcall(function()gun.Enabled=false end)end;
	elseif saState.tool then
		pcall(function()saState.tool.Enabled=true end);
		saState.tool=nil;
	end;
	if cfg.ShowFOV and cfg.Enabled then
		if not saState.circle then
			local c=Drawing.new("Circle");c.Thickness=2;c.NumSides=64;c.Filled=false;c.Color=Color3.fromRGB(255,255,255);c.Transparency=0.7;
			saState.circle=c;
		end;
		saState.circle.Position=GetScreenCenter()+saGuiService:GetGuiInset();
		saState.circle.Radius=cfg.FOVRadius;saState.circle.Visible=true;
	elseif saState.circle then
		saState.circle.Visible=false;
	end;
end);
RageTab:Toggle({Title="Silent Aim",Value=false,Callback=function(v)getgenv().silentAimConfig.Enabled=v end});
RageTab:Slider({Title="Silent Aim FOV Radius",Step=1,Value={Min=1,Max=500,Default=100},Callback=function(v)getgenv().silentAimConfig.FOVRadius=v end});
RageTab:Toggle({Title="Silent Aim Wall Check",Value=true,Callback=function(v)getgenv().silentAimConfig.WallCheck=v end});
RageTab:Toggle({Title="Show FOV Circle",Value=false,Callback=function(v)getgenv().silentAimConfig.ShowFOV=v end});
RageTab:Section({Title="Double Tap",Icon="zap"});RageTab:Toggle({Title="Double Tap",Value=false,Callback=function(v)getgenv().doubleTapConfig.Enabled=v;DoubleTap.charged=true end});RageTab:Toggle({Title="Double Tap Teleport",Value=true,Callback=function(v)getgenv().doubleTapConfig.Teleport=v end});RageTab:Slider({Title="Teleport Distance",Step=0.5,Value={Min=1,Max=10,Default=4},Callback=function(v)getgenv().doubleTapConfig.TeleportDistance=tonumber(v)end});RageTab:Slider({Title="Recharge Time",Step=0.1,Value={Min=0.2,Max=3,Default=1},Callback=function(v)getgenv().doubleTapConfig.RechargeTime=tonumber(v)end});
RageTab:Section({Title="Anti Aim",Icon="shield"});
getgenv().antiAimConfig={Enabled=false,Yaw="Backwards",YawOffset=0,Pitch="None",PitchAngle=75,PitchTarget="Body",JitterAngle=90,JitterSpeed=10,Desync=false,DesyncMode="Jitter",DesyncDistance=3};
local aaState={hum=nil,neck=nil,neckBase=nil,root=nil,rootBase=nil,flip=1,lastFlip=0,realPos=nil,rot=nil,pauseUntil=0};
local function aaRestore()
	if aaState.neck and aaState.neckBase and aaState.neck.Parent then aaState.neck.C0=aaState.neckBase end;
	if aaState.root and aaState.rootBase and aaState.root.Parent then aaState.root.C0=aaState.rootBase end;
	if aaState.hum and aaState.hum.Parent then aaState.hum.AutoRotate=true end;
	aaState.hum,aaState.neck,aaState.neckBase,aaState.root,aaState.rootBase,aaState.realPos=nil,nil,nil,nil,nil,nil;
	aaState.enabled=false;
end;
aaState.apply=function()
	local a=aaState.pitch or 0;
	local tgt=aaState.target;
	if aaState.root and aaState.rootBase and aaState.root.Parent then aaState.root.C0=aaState.rootBase*CFrame.Angles((tgt=="Body" or tgt=="Both")and a or 0,0,0)end;
	if aaState.neck and aaState.neckBase and aaState.neck.Parent then aaState.neck.C0=aaState.neckBase*CFrame.Angles((tgt=="Head" or tgt=="Both")and a or 0,0,0)end;
end;
RunService.Stepped:Connect(function()if aaState.enabled then aaState.apply()end end);
pcall(RunService.UnbindFromRenderStep,RunService,"AntiAimPitch");
RunService:BindToRenderStep("AntiAimPitch",Enum.RenderPriority.Last.Value,function()if aaState.enabled then aaState.apply()end end);
aaState.taps={};
UserInputService.TouchStarted:Connect(function(touch)
	local p=Vector2.new(touch.Position.X,touch.Position.Y);
	if saFireZone(p)then aaState.pauseUntil=os.clock()+0.4 end;
	if not saControlZone(p)then aaState.taps[touch]={t=os.clock(),p=p}end;
end);
UserInputService.TouchEnded:Connect(function(touch)
	local info=aaState.taps[touch];aaState.taps[touch]=nil;
	local p=Vector2.new(touch.Position.X,touch.Position.Y);
	if saFireZone(p)then aaState.pauseUntil=os.clock()+0.4;return end;
	if info and os.clock()-info.t<=0.25 and(p-info.p).Magnitude<=30 then aaState.pauseUntil=os.clock()+0.4 end;
end);
getgenv().aaPause=function()
	local cfg=getgenv().antiAimConfig;
	if not(cfg.Enabled and cfg.Desync)then return false end;
	local wasActive=os.clock()>=aaState.pauseUntil;
	aaState.pauseUntil=os.clock()+0.4;
	return wasActive;
end;
RunService.Heartbeat:Connect(function()
	local cfg=getgenv().antiAimConfig;
	local ch=LocalPlayer.Character;
	local hrp=ch and ch:FindFirstChild("HumanoidRootPart");
	local hum=ch and ch:FindFirstChildOfClass("Humanoid");
	local cam=WorkspaceService.CurrentCamera;
	if not(cfg.Enabled and hrp and hum and cam and hum.Health>0)then
		if aaState.hum or aaState.neck or aaState.root then aaRestore()end;
		aaState.realPos=nil;
		return;
	end;
	if aaState.hum~=hum then aaState.hum=hum;aaState.neck,aaState.neckBase,aaState.root,aaState.rootBase=nil,nil,nil,nil end;
	hum.AutoRotate=false;
	local now=os.clock();
	if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)then aaState.pauseUntil=now+0.3 end;
	if now-aaState.lastFlip>=1/math.max(cfg.JitterSpeed,1)then aaState.flip=-aaState.flip;aaState.lastFlip=now end;
	local look=cam.CFrame.LookVector;
	local yaw=math.atan2(-look.X,-look.Z)+math.rad(cfg.YawOffset);
	if cfg.Yaw=="Backwards" then yaw=yaw+math.pi
	elseif cfg.Yaw=="Sideways" then yaw=yaw+math.pi/2
	elseif cfg.Yaw=="Jitter" then yaw=yaw+math.pi+math.rad(cfg.JitterAngle)*aaState.flip
	elseif cfg.Yaw=="Random" then yaw=math.random()*math.pi*2 end;
	local rot=CFrame.Angles(0,yaw,0);
	local pos=hrp.Position;
	local fakePos=pos;
	aaState.realPos=nil;
	if cfg.Desync and now>=aaState.pauseUntil then
		local d=cfg.DesyncDistance;
		if cfg.DesyncMode=="Jitter" then fakePos=pos+Vector3.new(look.Z,0,-look.X).Unit*d*aaState.flip
		elseif cfg.DesyncMode=="Random" then local a=math.random()*math.pi*2;fakePos=pos+Vector3.new(math.cos(a),0,math.sin(a))*d end;
		aaState.realPos=pos;aaState.rot=rot;
	end;
	hrp.CFrame=CFrame.new(fakePos)*rot;
	local head=ch:FindFirstChild("Head");
	local neck=head and head:FindFirstChild("Neck");
	if neck and neck~=aaState.neck then aaState.neck=neck;aaState.neckBase=neck.C0 end;
	local lower=ch:FindFirstChild("LowerTorso");
	local upper=ch:FindFirstChild("UpperTorso");
	local root=(lower and lower:FindFirstChild("Root"))or(upper and upper:FindFirstChild("Waist"));
	if root and root~=aaState.root then aaState.root=root;aaState.rootBase=root.C0 end;
	local pa=math.rad(cfg.PitchAngle);
	local a=0;
	if cfg.Pitch=="Up" then a=pa
	elseif cfg.Pitch=="Down" then a=-pa
	elseif cfg.Pitch=="Jitter" then a=pa*aaState.flip
	elseif cfg.Pitch=="Random" then a=(math.random()*2-1)*pa
	elseif cfg.Pitch=="Spin" then a=(now*8)%(math.pi*2)end;
	aaState.pitch=a;aaState.target=cfg.PitchTarget;aaState.enabled=true;
	aaState.apply();
end);
pcall(RunService.UnbindFromRenderStep,RunService,"AntiAimRestore");
RunService:BindToRenderStep("AntiAimRestore",Enum.RenderPriority.First.Value,function()
	if not aaState.realPos then return end;
	local ch=LocalPlayer.Character;
	local hrp=ch and ch:FindFirstChild("HumanoidRootPart");
	if hrp and aaState.rot then hrp.CFrame=CFrame.new(aaState.realPos)*aaState.rot end;
	aaState.realPos=nil;
end);
RageTab:Toggle({Title="Anti Aim",Value=false,Callback=function(v)getgenv().antiAimConfig.Enabled=v end});
RageTab:Dropdown({Title="Anti Aim Yaw",Values={"Backwards","Sideways","Jitter","Random"},Value="Backwards",Callback=function(v)getgenv().antiAimConfig.Yaw=v end});
RageTab:Slider({Title="Yaw Offset",Step=5,Value={Min=-180,Max=180,Default=0},Callback=function(v)getgenv().antiAimConfig.YawOffset=tonumber(v)end});
RageTab:Slider({Title="Jitter Angle",Step=5,Value={Min=10,Max=180,Default=90},Callback=function(v)getgenv().antiAimConfig.JitterAngle=tonumber(v)end});
RageTab:Slider({Title="Jitter Speed",Step=1,Value={Min=1,Max=30,Default=10},Callback=function(v)getgenv().antiAimConfig.JitterSpeed=tonumber(v)end});
RageTab:Dropdown({Title="Anti Aim Pitch",Values={"None","Up","Down","Jitter","Random","Spin"},Value="None",Callback=function(v)getgenv().antiAimConfig.Pitch=v end});
RageTab:Slider({Title="Pitch Angle",Step=5,Value={Min=0,Max=180,Default=75},Callback=function(v)getgenv().antiAimConfig.PitchAngle=tonumber(v)end});
RageTab:Dropdown({Title="Pitch Target",Values={"Body","Head","Both"},Value="Body",Callback=function(v)getgenv().antiAimConfig.PitchTarget=v end});
RageTab:Toggle({Title="Desync (Fake Hitbox)",Value=false,Callback=function(v)getgenv().antiAimConfig.Desync=v end});
RageTab:Dropdown({Title="Desync Mode",Values={"Jitter","Random"},Value="Jitter",Callback=function(v)getgenv().antiAimConfig.DesyncMode=v end});
RageTab:Slider({Title="Desync Distance",Step=0.5,Value={Min=1,Max=10,Default=3},Callback=function(v)getgenv().antiAimConfig.DesyncDistance=tonumber(v)end});

local function execKnife(tH,myH)if not tH or not tH:IsDescendantOf(WorkspaceService)then return end;ThrowStartRemote:FireServer(myH.Position,(tH.Position-myH.Position).Unit);task.delay(0.03,function()ThrowHitRemote:FireServer(tH,tH.Position)end);RegisterMyTarget(PlayerService:GetPlayerFromCharacter(tH.Parent))end;

local function getEnemies()
	local list={};
	for _,pl in ipairs(PlayerService:GetPlayers())do
		if pl~=LocalPlayer and(not pl.Team or not LocalPlayer.Team or pl.Team~=LocalPlayer.Team)then
			local ch=pl.Character;local hm=ch and ch:FindFirstChildOfClass("Humanoid");local hd=ch and ch:FindFirstChild("Head");
			if hm and hm.Health>0 and hd then table.insert(list,{player=pl,head=hd,root=ch:FindFirstChild("HumanoidRootPart")})end;
		end;
	end;
	return list;
end;
local function equipTool(wantGun)
	local ch=LocalPlayer.Character;local hm=ch and ch:FindFirstChildOfClass("Humanoid");if not hm then return nil end;
	local function pick(container)for _,t in ipairs(container:GetChildren())do if t:IsA("Tool")and(t:FindFirstChild("Muzzle",true)~=nil)==wantGun then return t end end end;
	local tool=pick(ch);
	if not tool then local bp=LocalPlayer:FindFirstChild("Backpack");tool=bp and pick(bp);if tool then hm:EquipTool(tool);task.wait(0.15)end end;
	return tool;
end;
local function sortEnemies(list)
	local hrp=LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart");
	local keys={};
	for _,e in ipairs(list)do keys[e]=hrp and(e.head.Position-hrp.Position).Magnitude or 0 end;
	table.sort(list,function(x,y)return keys[x]<keys[y]end);
	local name=getgenv().killPriorityPlayer;
	if not name then return end;
	for i,e in ipairs(list)do
		if e.player.Name==name then table.insert(list,1,table.remove(list,i));break end;
	end;
end;
KillAll.gun=function()
	if not equipTool(true)then return end;
	for _=1,4 do
		local enemies=getEnemies();if #enemies==0 then break end;sortEnemies(enemies);
		for _,e in ipairs(enemies)do
			local mp=getMuzzlePos();if not mp then return end;
			local pos=e.head.Position;
			for _=1,3 do
				CreateBulletTracer(mp,pos);pcall(BulletRenderer,mp,pos,"Default");
				ShootGunRemote:FireServer(mp,pos,e.head,pos);
			end;
			RegisterMyTarget(e.player);
		end;
		task.wait(0.06);
	end;
end;
KillAll.knife=function()
	if not equipTool(false)then return end;
	local hrp=LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart");if not hrp then return end;
	for _,e in ipairs(getEnemies())do if e.root then execKnife(e.root,hrp);task.wait(0.05)end end;
end;
local killLoopRunning={};
KillAll.loop=function(kind)
	if killLoopRunning[kind]then return end;killLoopRunning[kind]=true;
	task.spawn(function()
		while getgenv().killLoop[kind]do pcall(KillAll[kind]);task.wait(0.25)end;
		killLoopRunning[kind]=false;
	end);
end;



local HitboxTab=MainWindow:Tab({Title="Hitboxes",Icon="swords"});local HBC={Enabled=false,ShowHitboxes=false,Size=5,Color=Color3.fromRGB(255,0,0),Transparency=0.5};local OHD={};
local function RHL()while HBC.Enabled do task.wait(0.1);for _,pl in pairs(PlayerService:GetPlayers())do if pl~=LocalPlayer and pl.Team~=LocalPlayer.Team then local ch=pl.Character;if ch then local rp=ch:FindFirstChild("HumanoidRootPart");if rp then if not OHD[pl]then OHD[pl]={Size=rp.Size,Transparency=rp.Transparency,Color=rp.Color}end;rp.Size=Vector3.new(HBC.Size,HBC.Size,HBC.Size);rp.CanCollide=false;rp.Transparency=HBC.ShowHitboxes and HBC.Transparency or 1;rp.Color=HBC.Color end end end end end;for _,pl in pairs(PlayerService:GetPlayers())do if pl~=LocalPlayer and pl.Team~=LocalPlayer.Team then local ch=pl.Character;if ch then local rp=ch:FindFirstChild("HumanoidRootPart");if rp and OHD[pl]then rp.Size=OHD[pl].Size;rp.Transparency=OHD[pl].Transparency;rp.Color=OHD[pl].Color;rp.CanCollide=false end end end end;OHD={}end;
local function SHP(pl)pl.CharacterAdded:Connect(function(ch)if HBC.Enabled then local rp=ch:FindFirstChild("HumanoidRootPart");if rp and pl~=LocalPlayer and pl.Team~=LocalPlayer.Team then OHD[pl]={Size=rp.Size,Transparency=rp.Transparency,Color=rp.Color};rp.Size=Vector3.new(HBC.Size,HBC.Size,HBC.Size);rp.CanCollide=false;rp.Transparency=HBC.ShowHitboxes and HBC.Transparency or 1;rp.Color=HBC.Color end end end)end;
HitboxTab:Section({Title="Hitbox",Icon="gamepad-2"});for _,p in ipairs(PlayerService:GetPlayers())do SHP(p)end;PlayerService.PlayerAdded:Connect(SHP);
HitboxTab:Toggle({Title="Enable Hitbox",Default=false,Callback=function(s)HBC.Enabled=s;if s then task.spawn(RHL)end end});
HitboxTab:Section({Title="Settings",Icon="settings"});HitboxTab:Toggle({Title="Show hitboxes",Default=false,Callback=function(v)HBC.ShowHitboxes=v end});HitboxTab:Slider({Title="Hitbox Size",Value={Min=1,Max=250,Default=5,Step=0.1},Callback=function(v)HBC.Size=v end});HitboxTab:Colorpicker({Title="Hitbox Color",Default=Color3.fromRGB(255,0,0),Transparency=0.5,Callback=function(c,t)HBC.Color=c;if t then HBC.Transparency=t end end});HitboxTab:Slider({Title="Hitbox Transparency",Step=0.1,Value={Min=0,Max=1,Default=0.5},Callback=function(v)HBC.Transparency=v end});

local PlayerTab=MainWindow:Tab({Title="Player",Icon="user"});PlayerTab:Section({Title="Cooldown",Icon="ban"});PlayerTab:Toggle({Title="Set Cooldown",Value=false,Callback=function(v)getgenv().cooldownEnabled=v end});PlayerTab:Slider({Title="Cooldown Value",Step=0.1,Value={Min=0,Max=5,Default=0},Callback=function(v)getgenv().cooldownValue=tonumber(v)end});getgenv().cooldownEnabled=false;getgenv().cooldownValue=0;RunService.Heartbeat:Connect(function()if getgenv().cooldownEnabled then local bp=LocalPlayer:FindFirstChild("Backpack");if bp then for _,t in ipairs(bp:GetChildren())do if t:IsA("Tool")then pcall(function()t:SetAttribute("Cooldown",getgenv().cooldownValue)end)end end end;if LocalPlayer.Character then for _,t in ipairs(LocalPlayer.Character:GetChildren())do if t:IsA("Tool")then pcall(function()t:SetAttribute("Cooldown",getgenv().cooldownValue)end)end end end end end);
PlayerTab:Section({Title="Spin",Icon="shield-user"});getgenv().spinEnabled=false;getgenv().spinSpeed=100;getgenv().modsRequireMatch=true;PlayerTab:Toggle({Title="Spin",Value=false,Callback=function(v)getgenv().spinEnabled=v;local ch=LocalPlayer.Character;if not ch then return end;local rp=ch:FindFirstChild("HumanoidRootPart");if not rp then return end;for _,c in ipairs(rp:GetChildren())do if c.Name=="Spinning"then c:Destroy()end end;if v and(not getgenv().modsRequireMatch or LocalPlayer:GetAttribute("Match"))then local b=Instance.new("BodyAngularVelocity");b.Name="Spinning";b.Parent=rp;b.MaxTorque=Vector3.new(0,math.huge,0);b.AngularVelocity=Vector3.new(0,getgenv().spinSpeed/10,0)end end});PlayerTab:Slider({Title="Spin Speed",Step=5,Value={Min=10,Max=500,Default=100},Callback=function(v)getgenv().spinSpeed=tonumber(v);local ch=LocalPlayer.Character;if not ch then return end;local rp=ch:FindFirstChild("HumanoidRootPart");if rp then local sp=rp:FindFirstChild("Spinning");if sp then sp.AngularVelocity=Vector3.new(0,getgenv().spinSpeed/10,0)end end end});
LocalPlayer.CharacterAdded:Connect(function(ch)ch:WaitForChild("HumanoidRootPart");task.wait(0.5);local rp=ch:FindFirstChild("HumanoidRootPart");if getgenv().spinEnabled and(not getgenv().modsRequireMatch or LocalPlayer:GetAttribute("Match"))and rp then for _,c in ipairs(rp:GetChildren())do if c.Name=="Spinning"then c:Destroy()end end;local b=Instance.new("BodyAngularVelocity");b.Name="Spinning";b.Parent=rp;b.MaxTorque=Vector3.new(0,math.huge,0);b.AngularVelocity=Vector3.new(0,getgenv().spinSpeed/10,0)end;if getgenv().chamsConfig.Enabled then task.wait(0.3);ApplyChams()end;if getgenv().chinaHatConfig.Enabled then task.wait(0.3);ApplyChinaHat()end end);
getgenv().autoEquipGun = false
PlayerTab:Section({Title="Auto Equip",Icon="crosshair"});PlayerTab:Toggle({Title="Auto Equip Gun",Value=false,Callback=function(v)getgenv().autoEquipGun=v end});
do
local lastAutoEquip = 0
RunService.Heartbeat:Connect(function()
	if not getgenv().autoEquipGun then return end
	if tick() - lastAutoEquip < 0.3 then return end
	lastAutoEquip = tick()
	if getgenv().modsRequireMatch and not LocalPlayer:GetAttribute("Match") then return end
	local character = LocalPlayer.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	if not humanoid or humanoid.Health <= 0 then return end
	if character:FindFirstChildOfClass("Tool") then return end
	local backpack = LocalPlayer:FindFirstChild("Backpack")
	if not backpack then return end
	for _, tool in ipairs(backpack:GetChildren()) do
		if tool:IsA("Tool") and tool:FindFirstChild("Muzzle", true) then
			humanoid:EquipTool(tool)
			break
		end
	end
end)
end
PlayerTab:Section({Title="Local Player",Icon="user"});PlayerTab:Toggle({Title="Set Speed",Value=false,Callback=function(v)getgenv().speedEnabled=v end});PlayerTab:Slider({Title="Speed Value",Step=1,Value={Min=16,Max=150,Default=16},Callback=function(v)getgenv().walkSpeedValue=tonumber(v)end});PlayerTab:Dropdown({Title="Speed Mode",Values={"Normal","Blatant"},Value="Normal",Callback=function(v)getgenv().speedMode=v end});getgenv().speedEnabled=false;getgenv().walkSpeedValue=16;getgenv().speedMode="Normal";RunService.RenderStepped:Connect(function()if not getgenv().modsRequireMatch or LocalPlayer:GetAttribute("Match")then if not getgenv().speedEnabled then return end;local ch=LocalPlayer.Character;if not ch or not ch:FindFirstChild("Humanoid")or not ch:FindFirstChild("HumanoidRootPart")then return end;local hm=ch.Humanoid;local rp=ch.HumanoidRootPart;if getgenv().speedMode=="Normal"then hm.WalkSpeed=getgenv().walkSpeedValue elseif getgenv().speedMode=="Blatant"then local md=hm.MoveDirection;if md.Magnitude>0 then rp.CFrame=rp.CFrame+md*(getgenv().walkSpeedValue/50)end end end end);
PlayerTab:Toggle({Title="Set Jump Power",Value=false,Callback=function(v)getgenv().jumpEnabled=v end});PlayerTab:Slider({Title="Jump Power Value",Step=1,Value={Min=50,Max=200,Default=50},Callback=function(v)getgenv().jumpPowerValue=tonumber(v)end});getgenv().jumpEnabled=false;getgenv().jumpPowerValue=50;RunService.Heartbeat:Connect(function()if(not getgenv().modsRequireMatch or LocalPlayer:GetAttribute("Match"))and getgenv().jumpEnabled then local ch=LocalPlayer.Character;if ch and ch:FindFirstChild("Humanoid")then ch.Humanoid.UseJumpPower=true;ch.Humanoid.JumpPower=getgenv().jumpPowerValue end end end);
PlayerTab:Section({Title="Emote",Icon="candy-cane"});Func();PlayerTab:Dropdown({Title="Emote Selector",Values=HT,Callback=function(v)ES=v;PlayEmote(v)end});PlayerTab:Keybind({Title="Start Emote",Value="X",Callback=function()PlayEmote(ES)end});
PlayerTab:Section({Title="Misc",Icon="candy-cane"});PlayerTab:Slider({Title="Fov",Step=1,Value={Min=30,Max=120,Default=70},Callback=function(v)WorkspaceService.CurrentCamera.FieldOfView=v end});PlayerTab:Toggle({Title="Bunny Hop",Value=false,Callback=function(v)getgenv().bunnyHopEnabled=v end});getgenv().bunnyHopEnabled=false;RunService.Heartbeat:Connect(function()if(not getgenv().modsRequireMatch or LocalPlayer:GetAttribute("Match"))and getgenv().bunnyHopEnabled then local ch=LocalPlayer.Character;local hm=ch and ch:FindFirstChild("Humanoid");if hm and hm.MoveDirection.Magnitude>0 and hm.FloorMaterial~=Enum.Material.Air then hm:ChangeState(Enum.HumanoidStateType.Jumping)end end end);
PlayerTab:Toggle({Title="Anti Stun",Value=false,Callback=function(v)getgenv().antiStunEnabled=v end});getgenv().antiStunEnabled=false;RunService.Heartbeat:Connect(function()if(not getgenv().modsRequireMatch or LocalPlayer:GetAttribute("Match"))and getgenv().antiStunEnabled then local ch=LocalPlayer.Character;if ch then for _,p in ipairs(ch:GetChildren())do if p:IsA("BasePart")and p.Anchored then p.Anchored=false end end end end end);

local function buildUniversalVisuals()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")

local RENDERERS = {}
local realRunService = RunService

local function syncContext(owner, connections)
	local function track(signal)
		return {
			Connect = function(_, callback)
				local connection = signal:Connect(callback)
				table.insert(connections, connection)
				return connection
			end,
		}
	end
	local runProxy = {
		RenderStepped = track(realRunService.RenderStepped),
		Heartbeat = track(realRunService.Heartbeat),
		Stepped = track(realRunService.Stepped),
	}
	local playerProxy = setmetatable({}, {
		__index = function(_, key)
			if key == "CharacterAdded" or key == "CharacterRemoving" then
				return track(owner[key])
			end
			return owner[key]
		end,
	})
	return playerProxy, runProxy
end

local HAT = {
	Enabled = false,
	Rainbow = false,
	Color = Color3.fromRGB(255, 90, 90),
	Radius = 1.4,
	Height = 0.9,
	Transparency = 0.35,
	Glow = false,
	GlowStrength = 2,
	Gap = 0.3,
	Style = "Cone",
	FirstPersonDistance = 1.5,
}

local HAT_STYLES = { "Cone", "Chinese", "Dome", "Cylinder", "Halo", "Horns" }
local HAT_SEGMENTS = 24
local HAT_THICKNESS = 0.05

local function makeTriangle(a, b, c)
	local ab, ac, bc = b - a, c - a, c - b
	local abd, acd, bcd = ab:Dot(ab), ac:Dot(ac), bc:Dot(bc)
	if abd > acd and abd > bcd then
		c, a = a, c
	elseif acd > bcd and acd > abd then
		a, b = b, a
	end
	ab, ac, bc = b - a, c - a, c - b

	local right = ac:Cross(ab).Unit
	local up = bc:Cross(right).Unit
	local back = bc.Unit
	local height = math.abs(ab:Dot(up))

	local w1 = Instance.new("WedgePart")
	w1.Size = Vector3.new(HAT_THICKNESS, height, math.abs(ab:Dot(back)))
	w1.CFrame = CFrame.fromMatrix((a + b) / 2, right, up, back)

	local w2 = Instance.new("WedgePart")
	w2.Size = Vector3.new(HAT_THICKNESS, height, math.abs(ac:Dot(back)))
	w2.CFrame = CFrame.fromMatrix((a + c) / 2, -right, up, -back)

	return w1, w2
end

local TRAIL = {
	Enabled = false,
	Rainbow = false,
	Color = Color3.fromRGB(90, 170, 255),
	Lifetime = 1.5,
	Height = 3,
	Transparency = 0.2,
	Glow = true,
	GlowStrength = 1.5,
	Style = "Ribbon",
	FirstPersonDistance = 1.5,
}

local TRAIL_STYLES = { "Ribbon", "Wings", "Line", "Comet" }

local TRAIL_STYLE_SETTINGS = {
	["Ribbon"] = {
		Horizontal = false,
		FaceCamera = true,
		WidthFactor = 1,
		WidthScale = NumberSequence.new(1),
	},
	["Wings"] = {
		Horizontal = true,
		FaceCamera = false,
		WidthFactor = 1.4,
		WidthScale = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 1),
			NumberSequenceKeypoint.new(1, 0.1),
		}),
	},
	["Line"] = {
		Horizontal = false,
		FaceCamera = true,
		WidthFactor = 0.12,
		WidthScale = NumberSequence.new(1),
	},
	["Comet"] = {
		Horizontal = false,
		FaceCamera = true,
		WidthFactor = 0.6,
		WidthScale = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 1),
			NumberSequenceKeypoint.new(1, 0),
		}),
	},
}
local trailData = nil

local function destroyTrail()
	if trailData then
		trailData.trail:Destroy()
		trailData.a0:Destroy()
		trailData.a1:Destroy()
		trailData = nil
	end
end

local function buildTrail(character)
	destroyTrail()

	local root = character:WaitForChild("HumanoidRootPart", 5)
	if not root then
		return
	end

	local a0 = Instance.new("Attachment")
	a0.Name = "TrailA"
	a0.Parent = root

	local a1 = Instance.new("Attachment")
	a1.Name = "TrailB"
	a1.Parent = root

	local trail = Instance.new("Trail")
	trail.Name = "MovementTrail"
	trail.Attachment0 = a0
	trail.Attachment1 = a1
	trail.LightEmission = 1
	trail.FaceCamera = true
	trail.Enabled = TRAIL.Enabled
	trail.Parent = root

	trailData = {
		trail = trail,
		a0 = a0,
		a1 = a1,
		head = character:FindFirstChild("Head") or root,
		style = TRAIL.Style,
	}
end

local function rainbowSequence(offset)
	local keypoints = {}
	for i = 0, 6 do
		keypoints[#keypoints + 1] = ColorSequenceKeypoint.new(i / 6, Color3.fromHSV((offset + i / 6) % 1, 0.8, 1))
	end
	return ColorSequence.new(keypoints)
end

localPlayer.CharacterAdded:Connect(buildTrail)
localPlayer.CharacterRemoving:Connect(destroyTrail)
if localPlayer.Character then
	task.spawn(buildTrail, localPlayer.Character)
end

RunService.RenderStepped:Connect(function()
	local data = trailData

	if data and data.style ~= TRAIL.Style then
		local character = localPlayer.Character
		if character then
			buildTrail(character)
		end
		data = trailData
	end
	if not data or not data.trail.Parent then
		return
	end

	local trail = data.trail

	local camera = workspace.CurrentCamera
	local firstPerson = camera ~= nil
		and (camera.CFrame.Position - data.head.Position).Magnitude < TRAIL.FirstPersonDistance

	trail.Enabled = TRAIL.Enabled and not firstPerson
	if not TRAIL.Enabled then
		return
	end

	local style = TRAIL_STYLE_SETTINGS[TRAIL.Style] or TRAIL_STYLE_SETTINGS["Ribbon"]
	local half = TRAIL.Height * style.WidthFactor / 2
	if style.Horizontal then
		data.a0.Position = Vector3.new(-half, 0, 0)
		data.a1.Position = Vector3.new(half, 0, 0)
	else
		data.a0.Position = Vector3.new(0, half, 0)
		data.a1.Position = Vector3.new(0, -half, 0)
	end
	trail.FaceCamera = style.FaceCamera
	trail.WidthScale = style.WidthScale

	trail.Lifetime = TRAIL.Lifetime

	trail.Transparency = firstPerson and NumberSequence.new(1) or NumberSequence.new({
		NumberSequenceKeypoint.new(0, TRAIL.Transparency),
		NumberSequenceKeypoint.new(1, 1),
	})
	trail.Color = TRAIL.Rainbow and rainbowSequence(os.clock() * 0.3) or ColorSequence.new(TRAIL.Color)
	trail.LightEmission = TRAIL.Glow and 1 or 0
	trail.LightInfluence = TRAIL.Glow and 0 or 1
	trail.Brightness = TRAIL.Glow and math.max(TRAIL.GlowStrength, 0.1) or 1
end)

local PARTICLES = {
	Enabled = false,
	Rainbow = false,
	Color = Color3.fromRGB(255, 255, 255),
	Rate = 60,
	Size = 0.35,
	Range = 60,
	Style = "Sparks",
	Glow = true,
	GlowStrength = 1.5,
}

local PARTICLE_STYLES = { "Sparks", "Snow", "Lights", "Smoke", "Rain", "Dollars", "Binary Code" }

local particlePart = Instance.new("Part")
particlePart.Name = "WorldParticles"
particlePart.Anchored = true
particlePart.CanCollide = false
particlePart.CanQuery = false
particlePart.CanTouch = false
particlePart.CastShadow = false
particlePart.Transparency = 1
particlePart.Size = Vector3.new(PARTICLES.Range, PARTICLES.Range / 2, PARTICLES.Range)
particlePart.Parent = workspace

local particleEmitter = Instance.new("ParticleEmitter")
particleEmitter.Shape = Enum.ParticleEmitterShape.Box
particleEmitter.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume
particleEmitter.Lifetime = NumberRange.new(4, 7)
particleEmitter.Speed = NumberRange.new(0.5, 2)
particleEmitter.SpreadAngle = Vector2.new(180, 180)
particleEmitter.Drag = 0.5
particleEmitter.Rotation = NumberRange.new(0, 360)
particleEmitter.RotSpeed = NumberRange.new(-30, 30)
particleEmitter.LightEmission = 1
particleEmitter.LightInfluence = 0
particleEmitter.Transparency = NumberSequence.new({
	NumberSequenceKeypoint.new(0, 1),
	NumberSequenceKeypoint.new(0.15, 0.2),
	NumberSequenceKeypoint.new(0.85, 0.2),
	NumberSequenceKeypoint.new(1, 1),
})
particleEmitter.Size = NumberSequence.new(PARTICLES.Size)
particleEmitter.Rate = PARTICLES.Rate
particleEmitter.Enabled = false
particleEmitter.Parent = particlePart

local PARTICLE_STYLE_SETTINGS = {

	["Sparks"] = {
		Texture = "rbxasset://textures/particles/sparkles_main.dds",
		Acceleration = Vector3.new(0, 0, 0),
		Speed = NumberRange.new(0.5, 2),
		SpreadAngle = Vector2.new(180, 180),
		Lifetime = NumberRange.new(2, 4),
		RotSpeed = NumberRange.new(-90, 90),
		LightEmission = 1,
		SizeScale = 1,
		MinTransparency = 0.05,
	},
	["Snow"] = {
		Texture = "rbxasset://textures/particles/smoke_main.dds",
		Acceleration = Vector3.new(0, -4, 0),
		Speed = NumberRange.new(0.2, 0.8),
		SpreadAngle = Vector2.new(25, 25),
		Lifetime = NumberRange.new(5, 9),
		RotSpeed = NumberRange.new(-25, 25),
		LightEmission = 0.2,
		SizeScale = 1.2,
		MinTransparency = 0.1,
	},
	["Lights"] = {
		Texture = "rbxasset://textures/particles/fire_main.dds",
		Acceleration = Vector3.new(0, 3, 0),
		Speed = NumberRange.new(0.3, 1),
		SpreadAngle = Vector2.new(30, 30),
		Lifetime = NumberRange.new(3, 6),
		RotSpeed = NumberRange.new(-40, 40),
		LightEmission = 1,
		SizeScale = 1.6,
		MinTransparency = 0.15,
	},
	["Smoke"] = {
		Texture = "rbxasset://textures/particles/smoke_main.dds",
		Acceleration = Vector3.new(0, 0.5, 0),
		Speed = NumberRange.new(0.1, 0.4),
		SpreadAngle = Vector2.new(180, 180),
		Lifetime = NumberRange.new(6, 10),
		RotSpeed = NumberRange.new(-10, 10),
		LightEmission = 0,
		SizeScale = 6,
		MinTransparency = 0.7,
	},
}

local lastParticleSize = nil
local lastParticleStyle = nil
local lastParticleGlow = nil

RunService.RenderStepped:Connect(function()
	local usesEmitter = PARTICLES.Enabled and PARTICLES.Style ~= "Rain" and PARTICLES.Style ~= "Dollars"
		and PARTICLES.Style ~= "Binary Code"

	local styleNow = usesEmitter and PARTICLES.Style or nil
	if styleNow ~= lastParticleStyle then
		particleEmitter:Clear()
		lastParticleStyle = styleNow
		lastParticleSize = nil
		lastParticleGlow = nil
	end

	particleEmitter.Enabled = usesEmitter
	if not usesEmitter then
		return
	end

	local camera = workspace.CurrentCamera
	if camera then
		particlePart.CFrame = CFrame.new(camera.CFrame.Position)
	end

	local range = PARTICLES.Range
	particlePart.Size = Vector3.new(range, range / 2, range)
	particleEmitter.Rate = PARTICLES.Rate

	local settings = PARTICLE_STYLE_SETTINGS[PARTICLES.Style] or PARTICLE_STYLE_SETTINGS["Sparks"]

	local targetSize = PARTICLES.Size * settings.SizeScale
	if targetSize ~= lastParticleSize then
		lastParticleSize = targetSize
		particleEmitter.Size = NumberSequence.new(targetSize)
	end

	local glowKey = tostring(PARTICLES.Glow) .. "/" .. PARTICLES.GlowStrength
	if lastParticleGlow ~= glowKey then
		lastParticleGlow = glowKey
		particleEmitter.Texture = settings.Texture
		particleEmitter.Acceleration = settings.Acceleration
		particleEmitter.Speed = settings.Speed
		particleEmitter.SpreadAngle = settings.SpreadAngle
		particleEmitter.Lifetime = settings.Lifetime
		particleEmitter.RotSpeed = settings.RotSpeed

		particleEmitter.LightEmission = PARTICLES.Glow and math.max(settings.LightEmission, 0.7) or 0
		particleEmitter.LightInfluence = PARTICLES.Glow and 0 or 1
		particleEmitter.Brightness = PARTICLES.Glow and math.max(PARTICLES.GlowStrength, 0.1) or 1
		particleEmitter.Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 1),
			NumberSequenceKeypoint.new(0.15, settings.MinTransparency),
			NumberSequenceKeypoint.new(0.85, settings.MinTransparency),
			NumberSequenceKeypoint.new(1, 1),
		})
	end

	particleEmitter.Color = PARTICLES.Rainbow and rainbowSequence(os.clock() * 0.3)
		or ColorSequence.new(PARTICLES.Color)
end)

do
	local rainFolder = Instance.new("Folder")
	rainFolder.Name = "Rain_Local"
	rainFolder.Parent = workspace

	local splashPart = Instance.new("Part")
	splashPart.Anchored = true
	splashPart.CanCollide = false
	splashPart.CanQuery = false
	splashPart.CanTouch = false
	splashPart.Transparency = 1
	splashPart.Size = Vector3.new(0.2, 0.2, 0.2)
	splashPart.Parent = rainFolder

	local splash = Instance.new("ParticleEmitter")
	splash.Enabled = false
	splash.Lifetime = NumberRange.new(0.15, 0.3)
	splash.Speed = NumberRange.new(3, 6)
	splash.SpreadAngle = Vector2.new(60, 60)
	splash.EmissionDirection = Enum.NormalId.Top
	splash.Acceleration = Vector3.new(0, -40, 0)
	splash.Size = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.12),
		NumberSequenceKeypoint.new(1, 0),
	})
	splash.Transparency = NumberSequence.new(0.3, 1)
	splash.Parent = splashPart

	local WIND = Vector3.new(6, 0, 3)
	local drops = {}
	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude

	local function clearRain()
		for _, drop in ipairs(drops) do
			drop.part:Destroy()
		end
		table.clear(drops)
	end

	local function resetDrop(drop, cameraPosition, fromTop)
		local range = PARTICLES.Range
		local x = cameraPosition.X + (math.random() - 0.5) * range
		local z = cameraPosition.Z + (math.random() - 0.5) * range
		local top = cameraPosition.Y + 30
		local y = fromTop and (top - math.random() * 6) or (cameraPosition.Y - 20 + math.random() * 50)

		params.FilterDescendantsInstances = { rainFolder, localPlayer.Character }
		local hit = workspace:Raycast(Vector3.new(x, top + 5, z), Vector3.new(0, -90, 0), params)
		drop.groundY = hit and hit.Position.Y or (cameraPosition.Y - 25)
		drop.position = Vector3.new(x, math.max(y, drop.groundY + 1), z)
		drop.speed = 60 + math.random() * 25
	end

	RunService.RenderStepped:Connect(function(dt)
		local camera = workspace.CurrentCamera
		if not (PARTICLES.Enabled and PARTICLES.Style == "Rain") or not camera then
			if #drops > 0 then
				clearRain()
			end
			return
		end

		local cameraPosition = camera.CFrame.Position
		local count = math.clamp(math.floor(PARTICLES.Rate * 2), 20, 400)

		while #drops < count do
			local part = Instance.new("Part")
			part.Anchored = true
			part.CanCollide = false
			part.CanQuery = false
			part.CanTouch = false
			part.CastShadow = false
			part.Parent = rainFolder
			local drop = { part = part }
			resetDrop(drop, cameraPosition, false)
			table.insert(drops, drop)
		end
		while #drops > count do
			table.remove(drops).part:Destroy()
		end

		local color = PARTICLES.Rainbow and Color3.fromHSV((os.clock() * 0.3) % 1, 0.6, 1) or PARTICLES.Color
		local material = PARTICLES.Glow and Enum.Material.Neon or Enum.Material.SmoothPlastic
		local length = 0.8 + PARTICLES.Size * 4
		local thickness = 0.04 + PARTICLES.Size * 0.08
		local halfRange = PARTICLES.Range * 0.6
		splash.Color = ColorSequence.new(color)

		for _, drop in ipairs(drops) do
			local velocity = Vector3.new(WIND.X, -drop.speed, WIND.Z)
			drop.position += velocity * dt

			local offset = drop.position - cameraPosition
			if drop.position.Y <= drop.groundY then

				splashPart.CFrame = CFrame.new(drop.position.X, drop.groundY + 0.05, drop.position.Z)
				splash:Emit(2)
				resetDrop(drop, cameraPosition, true)
			elseif math.abs(offset.X) > halfRange or math.abs(offset.Z) > halfRange or offset.Y < -30 then

				resetDrop(drop, cameraPosition, true)
			end

			local part = drop.part
			part.Size = Vector3.new(thickness, thickness, length)
			part.CFrame = CFrame.lookAt(drop.position, drop.position + velocity, Vector3.xAxis)
			part.Color = color
			part.Material = material
			part.Transparency = 0.35
		end
	end)
end

do
	local MONEY_GREEN = Color3.fromRGB(96, 178, 104)
	local INK_GREEN = Color3.fromRGB(28, 92, 44)

	local dollarFolder = Instance.new("Folder")
	dollarFolder.Name = "Dollars_Local"
	dollarFolder.Parent = workspace

	local bills = {}

	local function clearBills()
		for _, bill in ipairs(bills) do
			bill.part:Destroy()
		end
		table.clear(bills)
	end

	local function makeBill()
		local part = Instance.new("Part")
		part.Anchored = true
		part.CanCollide = false
		part.CanQuery = false
		part.CanTouch = false
		part.CastShadow = false
		part.Material = Enum.Material.SmoothPlastic
		part.Parent = dollarFolder

		local labels = {}
		for _, face in ipairs({ Enum.NormalId.Front, Enum.NormalId.Back }) do
			local gui = Instance.new("SurfaceGui")
			gui.Face = face
			gui.CanvasSize = Vector2.new(100, 46)
			gui.LightInfluence = 1
			gui.Parent = part

			local label = Instance.new("TextLabel")
			label.Size = UDim2.fromScale(1, 1)
			label.BackgroundTransparency = 1
			label.Font = Enum.Font.GothamBlack
			label.TextScaled = true
			label.TextColor3 = INK_GREEN
			label.Text = "$"
			label.Parent = gui

			local border = Instance.new("UIStroke")
			border.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			border.Color = INK_GREEN
			border.Thickness = 3
			border.Transparency = 0.3
			border.Parent = label

			table.insert(labels, { label = label, border = border })
		end
		return { part = part, labels = labels }
	end

	local function resetBill(bill, cameraPosition)
		local range = PARTICLES.Range
		bill.position = cameraPosition + Vector3.new(
			(math.random() - 0.5) * range,
			(math.random() - 0.5) * range * 0.5,
			(math.random() - 0.5) * range
		)
		local direction = Vector3.new(math.random() - 0.5, math.random() - 0.5, math.random() - 0.5)
		direction = direction.Magnitude > 0.01 and direction.Unit or Vector3.yAxis
		bill.velocity = direction * (0.5 + math.random() * 1.5)
		bill.rotation = CFrame.Angles(math.random() * math.pi * 2, math.random() * math.pi * 2, math.random() * math.pi * 2)
		bill.spin = Vector3.new(math.random() - 0.5, math.random() - 0.5, math.random() - 0.5) * 3
		bill.age = 0
		bill.lifetime = 2 + math.random() * 2
	end

	RunService.RenderStepped:Connect(function(dt)
		local camera = workspace.CurrentCamera
		if not (PARTICLES.Enabled and PARTICLES.Style == "Dollars") or not camera then
			if #bills > 0 then
				clearBills()
			end
			return
		end

		local cameraPosition = camera.CFrame.Position
		local count = math.clamp(math.floor(PARTICLES.Rate), 5, 150)
		while #bills < count do
			local bill = makeBill()
			resetBill(bill, cameraPosition)
			bill.age = math.random() * bill.lifetime
			table.insert(bills, bill)
		end
		while #bills > count do
			table.remove(bills).part:Destroy()
		end

		local scale = 0.5 + PARTICLES.Size * 2
		local size = Vector3.new(1 * scale, 0.46 * scale, 0.02)
		local color = PARTICLES.Rainbow and Color3.fromHSV((os.clock() * 0.3) % 1, 0.6, 1) or MONEY_GREEN
		local material = PARTICLES.Glow and Enum.Material.Neon or Enum.Material.SmoothPlastic
		local drag = math.exp(-0.5 * dt)

		for _, bill in ipairs(bills) do
			bill.age += dt
			if bill.age >= bill.lifetime then
				resetBill(bill, cameraPosition)
			end

			bill.velocity *= drag
			bill.position += bill.velocity * dt
			bill.rotation *= CFrame.Angles(bill.spin.X * dt, bill.spin.Y * dt, bill.spin.Z * dt)

			local t = bill.age / bill.lifetime
			local fade = 1
			if t < 0.15 then
				fade = t / 0.15
			elseif t > 0.85 then
				fade = (1 - t) / 0.15
			end
			local transparency = 1 - fade * 0.95

			local part = bill.part
			part.Size = size
			part.CFrame = CFrame.new(bill.position) * bill.rotation
			part.Color = color
			part.Material = material
			part.Transparency = transparency
			for _, face in ipairs(bill.labels) do
				face.label.TextTransparency = transparency
				face.border.Transparency = math.max(transparency, 0.3)
			end
		end
	end)
end

do
	local DIGITS_PER_COLUMN = 9

	local codeFolder = Instance.new("Folder")
	codeFolder.Name = "BinaryCode_Local"
	codeFolder.Parent = workspace

	local holder = Instance.new("Part")
	holder.Anchored = true
	holder.CanCollide = false
	holder.CanQuery = false
	holder.CanTouch = false
	holder.Transparency = 1
	holder.Size = Vector3.new(0.1, 0.1, 0.1)
	holder.CFrame = CFrame.new()
	holder.Parent = codeFolder

	local columns = {}

	local function destroyColumn(column)
		for _, digit in ipairs(column.digits) do
			digit.attachment:Destroy()
		end
	end

	local function resetColumn(column, cameraPosition, fromTop)
		local range = PARTICLES.Range
		column.x = cameraPosition.X + (math.random() - 0.5) * range
		column.z = cameraPosition.Z + (math.random() - 0.5) * range
		column.y = fromTop and (cameraPosition.Y + 18 + math.random() * 10)
			or (cameraPosition.Y - 10 + math.random() * 35)
		column.speed = 5 + math.random() * 7
	end

	local function newColumn(cameraPosition)
		local column = { digits = {} }
		for i = 1, DIGITS_PER_COLUMN do
			local attachment = Instance.new("Attachment")
			attachment.Parent = holder
			local billboard = Instance.new("BillboardGui")
			billboard.Adornee = attachment
			billboard.LightInfluence = 0
			billboard.MaxDistance = 300
			billboard.Parent = attachment
			local label = Instance.new("TextLabel")
			label.Size = UDim2.fromScale(1, 1)
			label.BackgroundTransparency = 1
			label.Font = Enum.Font.Arcade
			label.TextScaled = true
			label.TextStrokeColor3 = Color3.new(0, 0, 0)
			label.Text = math.random() < 0.5 and "0" or "1"
			label.Parent = billboard
			table.insert(column.digits, {
				attachment = attachment,
				billboard = billboard,
				label = label,
				phase = math.random(),
			})
		end
		resetColumn(column, cameraPosition, false)
		return column
	end

	RunService.RenderStepped:Connect(function(dt)
		local camera = workspace.CurrentCamera
		if not (PARTICLES.Enabled and PARTICLES.Style == "Binary Code") or not camera then
			if #columns > 0 then
				for _, column in ipairs(columns) do
					destroyColumn(column)
				end
				table.clear(columns)
			end
			return
		end

		local cameraPosition = camera.CFrame.Position
		local count = math.clamp(math.floor(PARTICLES.Rate / 3), 6, 40)
		while #columns < count do
			table.insert(columns, newColumn(cameraPosition))
		end
		while #columns > count do
			destroyColumn(table.remove(columns))
		end

		local now = os.clock()
		local color = PARTICLES.Rainbow and Color3.fromHSV((now * 0.3) % 1, 0.7, 1) or PARTICLES.Color
		local digitSize = 0.5 + PARTICLES.Size * 1.6
		local spacing = digitSize * 1.15
		local halfRange = PARTICLES.Range * 0.6

		for _, column in ipairs(columns) do
			column.y -= column.speed * dt
			local offset = Vector3.new(column.x - cameraPosition.X, 0, column.z - cameraPosition.Z)

			if column.y < cameraPosition.Y - 25 or math.abs(offset.X) > halfRange or math.abs(offset.Z) > halfRange then
				resetColumn(column, cameraPosition, true)
			end

			for i, digit in ipairs(column.digits) do

				local position = Vector3.new(column.x, column.y + (i - 1) * spacing, column.z)
				digit.attachment.WorldPosition = position
				digit.billboard.Size = UDim2.new(digitSize * 0.7, 0, digitSize, 0)

				local tick = math.floor(now + digit.phase)
				if tick ~= digit.lastTick then
					digit.lastTick = tick
					digit.label.Text = (digit.label.Text == "0") and "1" or "0"
				end

				local fade = (i - 1) / DIGITS_PER_COLUMN
				digit.label.TextColor3 = i == 1 and color:Lerp(Color3.new(1, 1, 1), 0.6) or color
				local transparency = math.clamp(0.05 + fade * 0.85, 0, 1)
				digit.label.TextTransparency = transparency

				digit.label.TextStrokeTransparency = math.clamp(transparency * 0.9, 0, 1)
			end
		end
	end)
end

local CONSTELLATIONS = {
	Enabled = false,
	Count = 30,
	Size = 0.35,
	Speed = 1,
	Color = Color3.fromRGB(150, 185, 255),
	Rainbow = false,
	Glow = true,
}

do
	local Lighting = game:GetService("Lighting")
	local PATTERNS = {

		{ stars = { { -1, 0.3 }, { -0.6, 0.36 }, { -0.25, 0.2 }, { 0.1, 0.1 }, { 0.2, -0.3 }, { 0.75, -0.35 }, { 0.8, 0.05 } },
			lines = { { 1, 2 }, { 2, 3 }, { 3, 4 }, { 4, 5 }, { 5, 6 }, { 6, 7 }, { 7, 4 } } },

		{ stars = { { -1, 0.2 }, { -0.5, -0.3 }, { 0, 0.1 }, { 0.45, -0.35 }, { 1, 0.15 } },
			lines = { { 1, 2 }, { 2, 3 }, { 3, 4 }, { 4, 5 } } },

		{ stars = { { -0.5, 0.9 }, { 0.55, 0.8 }, { -0.14, 0.05 }, { 0, 0 }, { 0.14, -0.05 }, { -0.55, -0.85 }, { 0.6, -0.8 } },
			lines = { { 1, 3 }, { 2, 5 }, { 3, 4 }, { 4, 5 }, { 3, 6 }, { 5, 7 } } },

		{ stars = { { 0, 1 }, { 0, 0.3 }, { 0, -0.3 }, { 0, -1 }, { -0.8, 0.35 }, { 0.8, 0.25 } },
			lines = { { 1, 2 }, { 2, 3 }, { 3, 4 }, { 5, 2 }, { 2, 6 } } },

		{ stars = { { 0, 0.9 }, { -0.25, 0.35 }, { 0.25, 0.4 }, { -0.35, -0.5 }, { 0.2, -0.45 } },
			lines = { { 1, 2 }, { 1, 3 }, { 2, 3 }, { 2, 4 }, { 3, 5 }, { 4, 5 } } },

		{ stars = { { -0.9, 0.8 }, { -0.6, 0.5 }, { -0.4, 0.15 }, { -0.1, -0.2 }, { 0.2, -0.5 }, { 0.55, -0.6 }, { 0.8, -0.4 }, { 0.85, -0.1 } },
			lines = { { 1, 2 }, { 2, 3 }, { 3, 4 }, { 4, 5 }, { 5, 6 }, { 6, 7 }, { 7, 8 } } },

		{ stars = { { -0.9, 0.7 }, { 0.6, -0.4 }, { -0.3, -0.45 } },
			lines = { { 1, 2 }, { 2, 3 }, { 3, 1 } } },

		{ stars = { { -0.9, -0.3 }, { -0.4, -0.1 }, { -0.1, 0.4 }, { 0.2, 0.7 }, { 0.55, 0.5 }, { 0.4, 0.0 }, { 0.9, -0.35 } },
			lines = { { 1, 2 }, { 2, 3 }, { 3, 4 }, { 4, 5 }, { 3, 6 }, { 2, 6 }, { 6, 7 } } },
	}

	local SKY_DISTANCE = 900
	local K = SKY_DISTANCE / 70
	local SKY_ROTATION = 0.035

	local starFolder = Instance.new("Folder")
	starFolder.Name = "Constellations_Local"
	starFolder.Parent = workspace

	local constellations = {}

	local function newPart(shape)
		local part = Instance.new("Part")
		part.Shape = shape
		part.Anchored = true
		part.CanCollide = false
		part.CanQuery = false
		part.CanTouch = false
		part.CastShadow = false
		part.Material = Enum.Material.Neon
		part.Transparency = 1
		part.Parent = starFolder
		return part
	end

	local function destroyConstellation(c)
		for _, star in ipairs(c.stars) do
			star.part:Destroy()
			star.halo:Destroy()
		end
		for _, line in ipairs(c.lines) do
			line.part:Destroy()
		end
	end

	local function spawnConstellation(stagger)
		local pattern = PATTERNS[math.random(1, #PATTERNS)]

		local azimuth = math.random() * math.pi * 2
		local elevation = math.rad(1.5 + math.random() ^ 1.4 * 40)
		local direction = Vector3.new(
			math.cos(elevation) * math.cos(azimuth),
			math.sin(elevation),
			math.cos(elevation) * math.sin(azimuth)
		)
		local scale = (1.8 + math.random() * 1.4) * (0.6 + CONSTELLATIONS.Size * 1.2) * K
		local c = {
			azimuth = azimuth,
			elevation = elevation,
			direction = direction,
			scale = scale,
			rotation = math.random() * math.pi * 2,
			spin = (math.random() - 0.5) * 0.16,
			azimuthSpeed = SKY_ROTATION * (0.6 + math.random() * 0.9),
			elevationSpeed = (math.random() - 0.5) * 0.012,
			start = os.clock() - (stagger or 0),
			life = 10 + math.random() * 4,
			stars = {},
			lines = {},
		}
		for i, point in ipairs(pattern.stars) do
			table.insert(c.stars, {
				part = newPart(Enum.PartType.Ball),
				halo = newPart(Enum.PartType.Ball),
				x = point[1],
				y = point[2],
				size = 0.2 + math.random() * 0.14,
				twinkle = math.random() * math.pi * 2,
				appear = 0.2 * (i - 1),
			})
		end
		for j, pair in ipairs(pattern.lines) do
			table.insert(c.lines, {
				part = newPart(Enum.PartType.Block),
				from = pair[1],
				to = pair[2],
				draw = 1.2 + 0.3 * (j - 1),
			})
		end
		table.insert(constellations, c)
	end

	RunService.RenderStepped:Connect(function()
		local camera = workspace.CurrentCamera
		if not CONSTELLATIONS.Enabled or not camera then
			if #constellations > 0 then
				for _, c in ipairs(constellations) do
					destroyConstellation(c)
				end
				table.clear(constellations)
			end
			return
		end

		local now = os.clock()
		local count = math.clamp(math.floor(CONSTELLATIONS.Count), 1, 40)
		while #constellations < count do

			spawnConstellation(#constellations * 0.35)
		end
		while #constellations > count do
			destroyConstellation(table.remove(constellations))
		end

		local cameraPosition = camera.CFrame.Position
		local color = CONSTELLATIONS.Rainbow and Color3.fromHSV((now * 0.15) % 1, 0.5, 1) or CONSTELLATIONS.Color

		local clock = Lighting.ClockTime
		local night
		if clock < 5 or clock > 19.5 then
			night = 1
		elseif clock < 7 then
			night = 1 - (clock - 5) / 2 * 0.75
		elseif clock > 17.5 then
			night = 0.25 + (clock - 17.5) / 2 * 0.75
		else
			night = 0.25
		end
		local material = CONSTELLATIONS.Glow and Enum.Material.Neon or Enum.Material.SmoothPlastic
		local lineColor = color:Lerp(Color3.fromRGB(110, 150, 255), 0.45)

		for index = #constellations, 1, -1 do
			local c = constellations[index]
			local t = now - c.start
			if t >= c.life then
				destroyConstellation(c)
				table.remove(constellations, index)
				spawnConstellation(0)
			else

				local azimuth = c.azimuth + (t * c.azimuthSpeed + now * SKY_ROTATION * 0.3) * CONSTELLATIONS.Speed
				local elevation = math.clamp(c.elevation + t * c.elevationSpeed, math.rad(1), math.rad(50))
				local direction = Vector3.new(
					math.cos(elevation) * math.cos(azimuth),
					math.sin(elevation),
					math.cos(elevation) * math.sin(azimuth)
				)

				local horizon = math.clamp((math.deg(elevation) - 0.5) / 3, 0, 1)
				local fade = math.clamp((c.life - t) / 1.6, 0, 1) * horizon * night
				local center = cameraPosition + direction * SKY_DISTANCE
				local plane = CFrame.lookAt(center, cameraPosition) * CFrame.Angles(0, 0, c.rotation + c.spin * t * CONSTELLATIONS.Speed)

				local positions = {}
				for i, star in ipairs(c.stars) do
					local position = (plane * CFrame.new(star.x * c.scale, star.y * c.scale, 0)).Position
					positions[i] = position
					local shown = math.clamp((t - star.appear) / 0.4, 0, 1) * fade
					local twinkle = 0.75 + 0.25 * math.sin(now * 3 + star.twinkle)
					local size = star.size * (0.6 + CONSTELLATIONS.Size) * (0.85 + 0.3 * twinkle) * K
					star.part.Size = Vector3.one * size
					star.part.CFrame = CFrame.new(position)
					star.part.Color = color
					star.part.Material = material
					star.part.Transparency = 1 - shown * twinkle

					star.halo.Size = Vector3.one * size * 3.2
					star.halo.CFrame = CFrame.new(position)
					star.halo.Color = color:Lerp(Color3.fromRGB(150, 175, 255), 0.5)
					star.halo.Material = Enum.Material.Neon
					star.halo.Transparency = 1 - shown * twinkle * 0.12
				end

				for _, line in ipairs(c.lines) do
					local progress = math.clamp((t - line.draw) / 0.5, 0, 1)
					local a, b = positions[line.from], positions[line.to]
					local tip = a + (b - a) * progress
					local length = (tip - a).Magnitude
					if progress > 0 and length > 0.01 then
						local middle = (a + tip) / 2
						local thickness = 0.09 * (0.6 + CONSTELLATIONS.Size) * K
						line.part.Size = Vector3.new(thickness, thickness, length)
						line.part.CFrame = CFrame.lookAt(middle, tip)
						line.part.Color = lineColor
						line.part.Material = material
						line.part.Transparency = 1 - 0.45 * fade
					else
						line.part.Transparency = 1
					end
				end
			end
		end
	end)
end

local Lighting = game:GetService("Lighting")

local FOG = {
	Enabled = false,
	Rainbow = false,
	Start = 0,
	End = 200,
	Color = Color3.fromRGB(180, 190, 210),
	Glow = false,
	GlowStrength = 2,
}

local fogOriginal = nil

local fogBloom = Instance.new("BloomEffect")
fogBloom.Name = "JustVisualsBloom"
fogBloom.Size = 30
fogBloom.Threshold = 0.85
fogBloom.Enabled = false
fogBloom.Parent = Lighting

RunService.RenderStepped:Connect(function()
	if FOG.Enabled then
		if not fogOriginal then
			fogOriginal = {
				start = Lighting.FogStart,
				finish = Lighting.FogEnd,
				color = Lighting.FogColor,
				atmosphere = Lighting:FindFirstChildOfClass("Atmosphere"),
			}

			if fogOriginal.atmosphere then
				fogOriginal.atmosphere.Parent = nil
			end
		end

		Lighting.FogStart = FOG.Start
		Lighting.FogEnd = math.max(FOG.End, FOG.Start + 1)
		Lighting.FogColor = FOG.Rainbow and Color3.fromHSV((os.clock() * 0.1) % 1, 0.5, 1)
			or FOG.Color

		fogBloom.Enabled = FOG.Glow and FOG.GlowStrength > 0
		fogBloom.Intensity = FOG.GlowStrength * 0.3
		return
	end

	fogBloom.Enabled = false
	if fogOriginal then
		Lighting.FogStart = fogOriginal.start
		Lighting.FogEnd = fogOriginal.finish
		Lighting.FogColor = fogOriginal.color
		if fogOriginal.atmosphere then
			if fogOriginal.atmosphere:GetAttribute("JustVisualsActive") ~= false then
				fogOriginal.atmosphere.Parent = Lighting
			end
		end
		fogOriginal = nil
	end
end)

local JUMP_CIRCLE, JUMP_CIRCLE_TRIGGERS, JUMP_CIRCLE_STYLES
do
	JUMP_CIRCLE = {
		Enabled = false,
		Style = "Ring",
		Rainbow = false,
		Color = Color3.fromRGB(255, 255, 255),
		Trigger = "Landing",
		Radius = 4,
		Duration = 0.6,
		Thickness = 0.2,
		Glow = true,
		GlowStrength = 2,
	}

	JUMP_CIRCLE_TRIGGERS = { "Landing", "Jump", "Both" }
	JUMP_CIRCLE_STYLES = { "Ring", "Double", "Dashed", "Hexagon", "Rays", "Wave", "Sparks" }

	local RING_SEGMENTS = 32

	local circlesFolder = Instance.new("Folder")
	circlesFolder.Name = "JumpCircles"
	circlesFolder.Parent = workspace

	local activeCircles = {}

	local function newPart(circle, shape)
		local part = Instance.new("Part")
		part.Anchored = true
		part.CanCollide = false
		part.CanQuery = false
		part.CanTouch = false
		part.CastShadow = false
		part.Material = JUMP_CIRCLE.Glow and Enum.Material.Neon or Enum.Material.SmoothPlastic
		part.Color = JUMP_CIRCLE.Color
		part.Size = Vector3.new(0.1, 0.05, 0.1)
		part.CFrame = CFrame.new(circle.center)
		if shape then
			part.Shape = shape
		end
		part.Parent = circlesFolder
		table.insert(circle.all, part)
		return part
	end

	local function newGroup(circle, count)
		local group = {}
		for i = 1, count do
			group[i] = newPart(circle)
		end
		return group
	end

	local function layRing(group, center, radius, thickness, transparency, rotation, fill)
		local count = #group
		local length = 2 * math.pi * radius / count * (fill or 1.1)
		for i, part in ipairs(group) do
			local angle = (i - 1) / count * math.pi * 2 + (rotation or 0)
			part.Size = Vector3.new(thickness, 0.05, math.max(length, 0.05))
			part.CFrame = CFrame.new(center) * CFrame.Angles(0, angle, 0) * CFrame.new(radius, 0, 0)
			part.Transparency = transparency
		end
	end

	local function spawnJumpCircle(character)
		local root = character:FindFirstChild("HumanoidRootPart")
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if not root or not humanoid then
			return
		end

		local params = RaycastParams.new()
		params.FilterType = Enum.RaycastFilterType.Exclude
		params.FilterDescendantsInstances = { character, circlesFolder }
		local result = workspace:Raycast(root.Position, Vector3.new(0, -12, 0), params)
		local groundY = result and result.Position.Y
			or (root.Position.Y - humanoid.HipHeight - root.Size.Y / 2)

		local circle = {
			style = JUMP_CIRCLE.Style,
			center = Vector3.new(root.Position.X, groundY + 0.05, root.Position.Z),
			start = os.clock(),
			radius = JUMP_CIRCLE.Radius,
			duration = JUMP_CIRCLE.Duration,
			thickness = JUMP_CIRCLE.Thickness,
			rainbow = JUMP_CIRCLE.Rainbow,
			glowStrength = JUMP_CIRCLE.GlowStrength,
			spin = (math.random() < 0.5 and -1 or 1),
			all = {},
		}

		local style = circle.style
		if style == "Double" then
			circle.ringA = newGroup(circle, RING_SEGMENTS)
			circle.ringB = newGroup(circle, RING_SEGMENTS)
		elseif style == "Dashed" then
			circle.ringA = newGroup(circle, 16)
		elseif style == "Hexagon" then
			circle.ringA = newGroup(circle, 6)
			circle.ringB = newGroup(circle, 6)
		elseif style == "Rays" then
			circle.rays = newGroup(circle, 12)
		elseif style == "Wave" then

			circle.disk = newPart(circle, Enum.PartType.Cylinder)
			circle.ringA = newGroup(circle, RING_SEGMENTS)
		else
			circle.ringA = newGroup(circle, RING_SEGMENTS)
		end

		if style == "Sparks" then
			local holder = newPart(circle)
			holder.Transparency = 1
			holder.CFrame = CFrame.new(circle.center + Vector3.new(0, 0.2, 0))
			local emitter = Instance.new("ParticleEmitter")
			emitter.Texture = "rbxasset://textures/particles/sparkles_main.dds"
			emitter.Enabled = false
			emitter.Color = ColorSequence.new(JUMP_CIRCLE.Color)
			emitter.LightEmission = 1
			emitter.LightInfluence = 0
			emitter.Lifetime = NumberRange.new(0.35, 0.6)
			emitter.Speed = NumberRange.new(10, 18)
			emitter.SpreadAngle = Vector2.new(70, 70)
			emitter.EmissionDirection = Enum.NormalId.Top
			emitter.Acceleration = Vector3.new(0, -25, 0)
			emitter.Drag = 2
			emitter.Size = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 0.35),
				NumberSequenceKeypoint.new(1, 0),
			})
			emitter.Parent = holder
			emitter:Emit(26)
		end

		if JUMP_CIRCLE.Glow and JUMP_CIRCLE.GlowStrength > 0 then
			local lightPart = newPart(circle)
			lightPart.Transparency = 1
			lightPart.CFrame = CFrame.new(circle.center + Vector3.new(0, 0.5, 0))
			local light = Instance.new("PointLight")
			light.Shadows = false
			light.Color = JUMP_CIRCLE.Color
			light.Parent = lightPart
			circle.light = light
		end

		table.insert(activeCircles, circle)
	end

	local lastJumpCircle = 0

	local function hookJumpCircle(character)
		local humanoid = character:WaitForChild("Humanoid", 5)
		if not humanoid then
			return
		end

		humanoid.StateChanged:Connect(function(_, newState)
			if not JUMP_CIRCLE.Enabled then
				return
			end

			local trigger = JUMP_CIRCLE.Trigger
			local onLand = newState == Enum.HumanoidStateType.Landed and trigger ~= "Jump"
			local onJump = newState == Enum.HumanoidStateType.Jumping and trigger ~= "Landing"
			if not (onLand or onJump) then
				return
			end

			if os.clock() - lastJumpCircle < 0.1 then
				return
			end
			lastJumpCircle = os.clock()

			spawnJumpCircle(character)
		end)
	end

	localPlayer.CharacterAdded:Connect(hookJumpCircle)
	if localPlayer.Character then
		task.spawn(hookJumpCircle, localPlayer.Character)
	end

	RunService.RenderStepped:Connect(function()
		local now = os.clock()

		for index = #activeCircles, 1, -1 do
			local circle = activeCircles[index]
			local t = (now - circle.start) / circle.duration

			if t >= 1 then
				for _, part in ipairs(circle.all) do
					part:Destroy()
				end
				table.remove(activeCircles, index)
			else
				local eased = 1 - (1 - t) ^ 3
				local radius = 0.3 + (circle.radius - 0.3) * eased
				local center = circle.center
				local thickness = circle.thickness
				local style = circle.style

				if style == "Double" then

					local t2 = math.clamp((t - 0.2) / 0.8, 0, 1)
					local radius2 = 0.3 + (circle.radius * 0.7 - 0.3) * (1 - (1 - t2) ^ 3)
					layRing(circle.ringA, center, radius, thickness, t)
					layRing(circle.ringB, center, radius2, thickness * 0.7, t2 > 0 and (0.2 + 0.8 * t2) or 1)

				elseif style == "Dashed" then

					layRing(circle.ringA, center, radius, thickness, t, circle.spin * t * math.pi, 0.55)

				elseif style == "Hexagon" then

					local innerRadius = radius * 0.62
					for g, group in ipairs({ circle.ringA, circle.ringB }) do
						local r = g == 1 and radius or innerRadius
						local rotation = (g == 1 and 1 or -1) * circle.spin * t * 0.9
						local edge = 2 * r * math.sin(math.pi / 6) + thickness
						local apothem = r * math.cos(math.pi / 6)
						for i, part in ipairs(group) do
							local angle = (i - 0.5) / 6 * math.pi * 2 + rotation
							part.Size = Vector3.new(thickness * (g == 1 and 1 or 0.7), 0.05, edge)
							part.CFrame = CFrame.new(center) * CFrame.Angles(0, angle, 0) * CFrame.new(apothem, 0, 0)
							part.Transparency = g == 1 and t or (0.25 + 0.75 * t)
						end
					end

				elseif style == "Rays" then

					local outer = radius
					local inner = radius * 0.55
					for i, part in ipairs(circle.rays) do
						local angle = (i - 1) / #circle.rays * math.pi * 2
						local middle = (outer + inner) / 2
						part.Size = Vector3.new(thickness, 0.05, math.max(outer - inner, 0.05))
						part.CFrame = CFrame.new(center) * CFrame.Angles(0, angle, 0)
							* CFrame.new(middle, 0, 0) * CFrame.Angles(0, math.pi / 2, 0)
						part.Transparency = t
					end

				elseif style == "Wave" then
					circle.disk.Size = Vector3.new(0.04, radius * 2, radius * 2)
					circle.disk.CFrame = CFrame.new(center - Vector3.new(0, 0.01, 0)) * CFrame.Angles(0, 0, math.pi / 2)
					circle.disk.Transparency = 0.55 + 0.45 * t
					layRing(circle.ringA, center, radius, thickness, t)

				else
					layRing(circle.ringA, center, radius, thickness, t)
				end

				local color = circle.rainbow and Color3.fromHSV((now * 0.5) % 1, 0.8, 1) or nil
				if color then
					for _, part in ipairs(circle.all) do
						part.Color = color
					end
				end
				if circle.light then
					circle.light.Brightness = circle.glowStrength * (1 - t)
					circle.light.Range = 2 + radius * 1.5
					if color then
						circle.light.Color = color
					end
				end
			end
		end
	end)
end

local SKY, SKY_PRESET_ORDER, SKY_LIGHTING_MODES
do
	SKY = {
		Enabled = false,
		Preset = "Sunset",
		Clouds = true,
		MovingSun = false,
		SunSpeed = 2,

		LightingMode = "Game",
		WorldHaze = false,
		ClockTime = 14,
		Brightness = 2,
		LightColor = Color3.fromRGB(180, 190, 210),
		SunColor = Color3.fromRGB(255, 255, 255),
		Exposure = 0,
		Shadows = true,
	}

	SKY_LIGHTING_MODES = { "Game", "Sky Match", "Custom" }
	SKY_PRESET_ORDER = { "Day", "Dawn", "Sunset", "Night", "Space", "Fantasy", "Storm" }

	local rgb = Color3.fromRGB
	local PRESETS = {
		["Day"] = {
			Lighting = { ClockTime = 13, Brightness = 3, Ambient = rgb(120, 125, 140), OutdoorAmbient = rgb(140, 145, 160), ColorShift_Top = rgb(255, 255, 255) },
			Atmosphere = { Density = 0.3, Offset = 0.25, Color = rgb(199, 215, 255), Decay = rgb(106, 112, 125), Glare = 0, Haze = 1 },
			Sky = { StarCount = 0, SunAngularSize = 21, MoonAngularSize = 11 },
			Clouds = { Cover = 0.5, Density = 0.6, Color = rgb(255, 255, 255) },
		},
		["Dawn"] = {
			Lighting = { ClockTime = 6.4, Brightness = 2, Ambient = rgb(110, 90, 110), OutdoorAmbient = rgb(160, 120, 120), ColorShift_Top = rgb(255, 190, 150) },
			Atmosphere = { Density = 0.35, Offset = 0.4, Color = rgb(255, 190, 170), Decay = rgb(130, 90, 120), Glare = 0.4, Haze = 1.8 },
			Sky = { StarCount = 300, SunAngularSize = 26, MoonAngularSize = 11 },
			Clouds = { Cover = 0.55, Density = 0.6, Color = rgb(255, 200, 190) },
		},
		["Sunset"] = {
			Lighting = { ClockTime = 18.2, Brightness = 2, Ambient = rgb(90, 70, 90), OutdoorAmbient = rgb(150, 100, 90), ColorShift_Top = rgb(255, 170, 100) },
			Atmosphere = { Density = 0.4, Offset = 0.5, Color = rgb(255, 170, 120), Decay = rgb(120, 60, 80), Glare = 0.6, Haze = 2.2 },
			Sky = { StarCount = 800, SunAngularSize = 30, MoonAngularSize = 11 },
			Clouds = { Cover = 0.6, Density = 0.7, Color = rgb(255, 170, 130) },
		},
		["Night"] = {
			Lighting = { ClockTime = 0, Brightness = 0.5, Ambient = rgb(25, 30, 55), OutdoorAmbient = rgb(35, 45, 80), ColorShift_Top = rgb(60, 80, 160) },
			Atmosphere = { Density = 0.25, Offset = 0, Color = rgb(20, 25, 60), Decay = rgb(10, 10, 30), Glare = 0, Haze = 0.5 },
			Sky = { StarCount = 5000, SunAngularSize = 21, MoonAngularSize = 20 },
			Clouds = { Cover = 0.3, Density = 0.4, Color = rgb(60, 70, 110) },
		},
		["Space"] = {
			Lighting = { ClockTime = 0, Brightness = 0.3, Ambient = rgb(40, 30, 70), OutdoorAmbient = rgb(50, 40, 90), ColorShift_Top = rgb(120, 90, 255) },
			Atmosphere = { Density = 0.05, Offset = 0, Color = rgb(10, 5, 30), Decay = rgb(40, 20, 90), Glare = 0, Haze = 0 },
			Sky = { StarCount = 10000, SunAngularSize = 21, MoonAngularSize = 40 },
			Clouds = { Cover = 0, Density = 0, Color = rgb(255, 255, 255) },
		},
		["Fantasy"] = {
			Lighting = { ClockTime = 20, Brightness = 1.5, Ambient = rgb(80, 60, 120), OutdoorAmbient = rgb(120, 80, 170), ColorShift_Top = rgb(200, 120, 255) },
			Atmosphere = { Density = 0.5, Offset = 0.3, Color = rgb(190, 120, 255), Decay = rgb(60, 200, 220), Glare = 0.3, Haze = 2.8 },
			Sky = { StarCount = 3000, SunAngularSize = 15, MoonAngularSize = 35 },
			Clouds = { Cover = 0.7, Density = 0.8, Color = rgb(220, 160, 255) },
		},
		["Storm"] = {
			Lighting = { ClockTime = 14, Brightness = 1, Ambient = rgb(80, 85, 95), OutdoorAmbient = rgb(90, 95, 105), ColorShift_Top = rgb(160, 170, 190) },
			Atmosphere = { Density = 0.55, Offset = 0.1, Color = rgb(120, 125, 135), Decay = rgb(70, 72, 80), Glare = 0, Haze = 3 },
			Sky = { StarCount = 0, SunAngularSize = 21, MoonAngularSize = 11 },
			Clouds = { Cover = 0.9, Density = 0.95, Color = rgb(110, 112, 120) },
		},
	}

	local LIGHTING_PROPS = { "ClockTime", "Brightness", "Ambient", "OutdoorAmbient", "ColorShift_Top", "ExposureCompensation", "GlobalShadows" }
	local CLOUD_PROPS = { "Cover", "Density", "Color" }

	local original = nil
	local lightingOriginal = nil
	local mySky, myAtmosphere, myClouds = nil, nil, nil
	local timeOffset = 0
	local lastPreset = nil

	local function startLighting()
		lightingOriginal = {}
		for _, property in ipairs(LIGHTING_PROPS) do
			lightingOriginal[property] = Lighting[property]
		end
		timeOffset = 0
	end

	local function stopLighting()
		for property, value in pairs(lightingOriginal) do
			Lighting[property] = value
		end
		lightingOriginal = nil
	end

	local function enableSky()
		original = { clouds = nil }

		original.sky = Lighting:FindFirstChildOfClass("Sky")
		if original.sky then
			original.sky.Parent = nil
		end
		original.atmosphere = Lighting:FindFirstChildOfClass("Atmosphere")
		original.atmosphereDensity = original.atmosphere and original.atmosphere.Density or 0
		if original.atmosphere then
			original.atmosphere.Parent = nil
		end

		mySky = Instance.new("Sky")
		mySky.Name = "JustVisualsSky"
		mySky.CelestialBodiesShown = true
		mySky.Parent = Lighting

		myAtmosphere = Instance.new("Atmosphere")
		myAtmosphere.Name = "JustVisualsAtmosphere"
		myAtmosphere:SetAttribute("JustVisualsActive", true)
		myAtmosphere.Parent = Lighting

		local terrainClouds = workspace.Terrain:FindFirstChildOfClass("Clouds")
		if terrainClouds then
			original.clouds = { object = terrainClouds, enabled = terrainClouds.Enabled }
			for _, property in ipairs(CLOUD_PROPS) do
				original.clouds[property] = terrainClouds[property]
			end
			myClouds = terrainClouds
		else
			myClouds = Instance.new("Clouds")
			myClouds.Name = "JustVisualsClouds"
			myClouds.Parent = workspace.Terrain
		end

		timeOffset = 0
	end

	local function disableSky()
		if lightingOriginal then
			stopLighting()
		end

		mySky:Destroy()
		mySky = nil
		if original.sky then
			original.sky.Parent = Lighting
		end

		myAtmosphere:SetAttribute("JustVisualsActive", false)
		myAtmosphere.Parent = nil
		myAtmosphere = nil
		if original.atmosphere then
			original.atmosphere.Parent = Lighting
		end

		if original.clouds then
			local clouds = original.clouds.object
			clouds.Enabled = original.clouds.enabled
			for _, property in ipairs(CLOUD_PROPS) do
				clouds[property] = original.clouds[property]
			end
		elseif myClouds then
			myClouds:Destroy()
		end
		myClouds = nil
		original = nil
	end

	RunService.RenderStepped:Connect(function(dt)
		if not SKY.Enabled then
			if original then
				disableSky()
			end
			return
		end
		if not original then
			enableSky()
		end

		local preset = PRESETS[SKY.Preset] or PRESETS["Sunset"]
		if SKY.Preset ~= lastPreset then
			lastPreset = SKY.Preset
			timeOffset = 0
		end

		local mode = SKY.LightingMode
		local changesLighting = mode ~= "Game" or SKY.MovingSun
		if changesLighting and not lightingOriginal then
			startLighting()
		elseif not changesLighting and lightingOriginal then
			stopLighting()
		end

		if lightingOriginal then
			local baseTime = lightingOriginal.ClockTime
			if mode == "Sky Match" then
				for property, value in pairs(preset.Lighting) do
					Lighting[property] = value
				end
				baseTime = preset.Lighting.ClockTime
			elseif mode == "Custom" then
				local black = Color3.new(0, 0, 0)
				baseTime = SKY.ClockTime
				Lighting.ClockTime = SKY.ClockTime
				Lighting.Brightness = SKY.Brightness
				Lighting.Ambient = SKY.LightColor:Lerp(black, 0.55)
				Lighting.OutdoorAmbient = SKY.LightColor:Lerp(black, 0.3)
				Lighting.ColorShift_Top = SKY.SunColor
				Lighting.ExposureCompensation = SKY.Exposure
				Lighting.GlobalShadows = SKY.Shadows
			end

			if SKY.MovingSun then
				timeOffset += dt * SKY.SunSpeed / 60
				Lighting.ClockTime = (baseTime + timeOffset) % 24
			elseif mode ~= "Sky Match" and mode ~= "Custom" then
				Lighting.ClockTime = baseTime
			end
		end

		for property, value in pairs(preset.Atmosphere) do
			myAtmosphere[property] = value
		end

		if not SKY.WorldHaze then
			myAtmosphere.Density = original.atmosphereDensity
		end
		for property, value in pairs(preset.Sky) do
			mySky[property] = value
		end

		myClouds.Enabled = SKY.Clouds and preset.Clouds.Cover > 0
		for property, value in pairs(preset.Clouds) do
			myClouds[property] = value
		end
	end)
end

local AURA, AURA_STYLES
do
	AURA = {
		Enabled = false,
		Style = "Orbits",
		Rainbow = false,
		Color = Color3.fromRGB(255, 90, 90),
		Glow = true,
		Size = 1,
		Speed = 1,
		FirstPersonDistance = 1.5,
	}
	AURA_STYLES = { "Orbits", "Spiral", "Energy", "Glow", "Rings" }

	RENDERERS.Aura = function(owner, AURA)
		local connections = {}
		local localPlayer, RunService = syncContext(owner, connections)

		local RING_TILTS = {
			CFrame.Angles(0, 0, 0),
			CFrame.Angles(math.rad(65), 0, 0),
			CFrame.Angles(math.rad(-65), 0, math.rad(40)),
		}
		local RING_SEGMENTS = 24
		local SMOOTH_SEGMENTS = 36
		local ORBIT_TILTS = {
			CFrame.Angles(math.rad(20), 0, 0),
			CFrame.Angles(math.rad(-35), 0, math.rad(25)),
			CFrame.Angles(math.rad(70), 0, math.rad(-15)),
			CFrame.Angles(math.rad(-60), 0, math.rad(-50)),
		}
		local HELIX_SEGMENTS = 34
		local HELIX_RUNGS = 9
		local HELIX_SPARKS = 4

		local auraFolder = Instance.new("Folder")
		auraFolder.Name = "Aura_Local"
		auraFolder.Parent = workspace

		local aura = nil

		local function destroyAura()
			if aura then
				for _, part in ipairs(aura.parts) do
					part:Destroy()
				end
				aura = nil
			end
		end

		local function effectPart(data, shape)
			local part = Instance.new("Part")
			part.Anchored = true
			part.CanCollide = false
			part.CanQuery = false
			part.CanTouch = false
			part.CastShadow = false
			part.Material = Enum.Material.Neon
			if shape then
				part.Shape = shape
			end
			part.Parent = auraFolder
			table.insert(data.parts, part)
			return part
		end

		local function makeRing(data, count)
			local ring = {}
			for i = 1, count do
				ring[i] = effectPart(data)
			end
			return ring
		end

		local function placeRing(ring, cframe, radius, thickness, transparency, color, material)
			local count = #ring
			local segment = 2 * math.pi * radius / count * 1.08
			for i, part in ipairs(ring) do
				local angle = (i - 1) / count * math.pi * 2
				part.Size = Vector3.new(thickness, thickness, segment)
				part.CFrame = cframe * CFrame.Angles(0, angle, 0) * CFrame.new(radius, 0, 0)
				part.Transparency = transparency
				part.Color = color
				part.Material = material
			end
		end

		local function buildAura(character)
			destroyAura()
			local s = AURA.Size
			local data = { style = AURA.Style, size = s, character = character, parts = {} }

			local holder = effectPart(data)
			holder.Transparency = 1
			holder.Size = Vector3.new(0.2, 0.2, 0.2)
			local light = Instance.new("PointLight")
			light.Shadows = false
			light.Parent = holder
			data.holder = holder
			data.light = light

			if data.style == "Orbits" then

				data.orbs = {}
				for i = 1, #ORBIT_TILTS do
					local orb = effectPart(data, Enum.PartType.Ball)
					orb.Size = Vector3.one * 0.32 * s

					local a0 = Instance.new("Attachment")
					a0.Position = Vector3.new(0, 0.1 * s, 0)
					a0.Parent = orb
					local a1 = Instance.new("Attachment")
					a1.Position = Vector3.new(0, -0.1 * s, 0)
					a1.Parent = orb

					local trail = Instance.new("Trail")
					trail.Attachment0 = a0
					trail.Attachment1 = a1
					trail.Lifetime = 0.35
					trail.FaceCamera = true
					trail.LightInfluence = 0
					trail.WidthScale = NumberSequence.new({
						NumberSequenceKeypoint.new(0, 1),
						NumberSequenceKeypoint.new(1, 0),
					})
					trail.Transparency = NumberSequence.new({
						NumberSequenceKeypoint.new(0, 0.1),
						NumberSequenceKeypoint.new(1, 1),
					})
					trail.Parent = orb

					data.orbs[i] = { part = orb, trail = trail }
				end

			elseif data.style == "Spiral" then

				data.helix = { strands = {}, rungs = {}, sparks = {} }
				for strand = 1, 2 do
					local segments = {}
					for i = 1, HELIX_SEGMENTS do
						segments[i] = effectPart(data)
					end
					data.helix.strands[strand] = segments
					for i = 1, HELIX_SPARKS do
						local spark = effectPart(data, Enum.PartType.Ball)
						local a0 = Instance.new("Attachment")
						a0.Position = Vector3.new(0, 0.06, 0)
						a0.Parent = spark
						local a1 = Instance.new("Attachment")
						a1.Position = Vector3.new(0, -0.06, 0)
						a1.Parent = spark
						local trail = Instance.new("Trail")
						trail.Attachment0 = a0
						trail.Attachment1 = a1
						trail.Lifetime = 0.3
						trail.FaceCamera = true
						trail.LightInfluence = 0
						trail.WidthScale = NumberSequence.new(1, 0)
						trail.Transparency = NumberSequence.new(0.2, 1)
						trail.Parent = spark
						table.insert(data.helix.sparks, { part = spark, trail = trail, strand = strand, index = i })
					end
				end
				for i = 1, HELIX_RUNGS do
					data.helix.rungs[i] = effectPart(data)
				end

			elseif data.style == "Glow" then

				data.radiance = { streaks = {} }

				local glowBox = effectPart(data)
				glowBox.Transparency = 1
				glowBox.Size = Vector3.new(2.6, 4.2, 2.2) * AURA.Size
				local glow = Instance.new("ParticleEmitter")
				glow.Texture = "rbxasset://textures/particles/smoke_main.dds"
				glow.Shape = Enum.ParticleEmitterShape.Box
				glow.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume
				glow.Rate = 30
				glow.Lifetime = NumberRange.new(0.5, 0.9)
				glow.Speed = NumberRange.new(0, 0.4)
				glow.Rotation = NumberRange.new(0, 360)
				glow.RotSpeed = NumberRange.new(-25, 25)
				glow.Size = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 1.6 * AURA.Size),
					NumberSequenceKeypoint.new(1, 2.6 * AURA.Size),
				})
				glow.Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 1),
					NumberSequenceKeypoint.new(0.3, 0.6),
					NumberSequenceKeypoint.new(1, 1),
				})
				glow.LightInfluence = 0
				glow.Parent = glowBox
				data.radiance.glowBox = glowBox
				data.radiance.glow = glow

				local feet = effectPart(data)
				feet.Transparency = 1
				feet.Size = Vector3.new(1.8, 0.2, 1.8) * AURA.Size
				local wisps = Instance.new("ParticleEmitter")
				wisps.Texture = "rbxasset://textures/particles/smoke_main.dds"
				wisps.Shape = Enum.ParticleEmitterShape.Box
				wisps.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume
				wisps.EmissionDirection = Enum.NormalId.Top
				wisps.Rate = 10
				wisps.Lifetime = NumberRange.new(0.8, 1.3)
				wisps.Speed = NumberRange.new(0.5, 1.2)
				wisps.RotSpeed = NumberRange.new(-60, 60)
				wisps.Size = NumberSequence.new(0.5 * AURA.Size, 1.3 * AURA.Size)
				wisps.Transparency = NumberSequence.new(0.6, 1)
				wisps.LightInfluence = 0
				wisps.Parent = feet
				data.radiance.feet = feet
				data.radiance.wisps = wisps

				for i = 1, 3 do
					local orb = effectPart(data, Enum.PartType.Ball)
					orb.Size = Vector3.one * 0.18 * AURA.Size
					local a0 = Instance.new("Attachment")
					a0.Position = Vector3.new(0, 0.08, 0)
					a0.Parent = orb
					local a1 = Instance.new("Attachment")
					a1.Position = Vector3.new(0, -0.08, 0)
					a1.Parent = orb
					local trail = Instance.new("Trail")
					trail.Attachment0 = a0
					trail.Attachment1 = a1
					trail.Lifetime = 0.45
					trail.FaceCamera = true
					trail.LightInfluence = 0
					trail.WidthScale = NumberSequence.new(1, 0)
					trail.Transparency = NumberSequence.new(0.1, 1)
					trail.Parent = orb
					data.radiance.streaks[i] = { part = orb, trail = trail }
				end

			elseif data.style == "Energy" then

				data.energy = { flames = {}, sparks = {}, rates = {} }

				local highlight = Instance.new("Highlight")
				highlight.Adornee = character
				highlight.DepthMode = Enum.HighlightDepthMode.Occluded
				highlight.Parent = auraFolder
				table.insert(data.parts, highlight)
				data.energy.highlight = highlight

				for _, part in ipairs(character:GetChildren()) do
					if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" and part.Transparency < 1 then
						local volume = part.Size.X * part.Size.Y * part.Size.Z

						local flame = Instance.new("ParticleEmitter")
						flame.Name = "OpusAuraFlame"
						flame.Texture = "rbxasset://textures/particles/fire_main.dds"
						flame.EmissionDirection = Enum.NormalId.Top
						flame.SpreadAngle = Vector2.new(25, 25)
						flame.Speed = NumberRange.new(1.5, 3)
						flame.Acceleration = Vector3.new(0, 6, 0)
						flame.Lifetime = NumberRange.new(0.35, 0.6)
						flame.Rotation = NumberRange.new(0, 360)
						flame.RotSpeed = NumberRange.new(-90, 90)
						flame.Size = NumberSequence.new({
							NumberSequenceKeypoint.new(0, 0),
							NumberSequenceKeypoint.new(0.25, 0.85 * AURA.Size),
							NumberSequenceKeypoint.new(1, 0),
						})
						flame.Transparency = NumberSequence.new({
							NumberSequenceKeypoint.new(0, 0.4),
							NumberSequenceKeypoint.new(0.3, 0.25),
							NumberSequenceKeypoint.new(1, 1),
						})
						flame.LightInfluence = 0
						flame.ZOffset = 0.5
						flame.Parent = part
						table.insert(data.parts, flame)
						table.insert(data.energy.flames, flame)
						data.energy.rates[flame] = math.clamp(volume * 6, 5, 26)

						local sparks = Instance.new("ParticleEmitter")
						sparks.Name = "OpusAuraSparks"
						sparks.Texture = "rbxasset://textures/particles/sparkles_main.dds"
						sparks.Speed = NumberRange.new(0.5, 2)
						sparks.SpreadAngle = Vector2.new(180, 180)
						sparks.Acceleration = Vector3.new(0, 2, 0)
						sparks.Lifetime = NumberRange.new(0.5, 1)
						sparks.Size = NumberSequence.new(0.18 * AURA.Size, 0)
						sparks.LightInfluence = 0
						sparks.ZOffset = 0.6
						sparks.Parent = part
						table.insert(data.parts, sparks)
						table.insert(data.energy.sparks, sparks)
						data.energy.rates[sparks] = math.clamp(volume * 2.5, 2, 10)
					end
				end

				local torso = character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso")
				if torso then
					local halo = Instance.new("ParticleEmitter")
					halo.Name = "OpusAuraHalo"
					halo.Texture = "rbxasset://textures/particles/smoke_main.dds"
					halo.Rate = 6
					halo.Speed = NumberRange.new(0)
					halo.Lifetime = NumberRange.new(0.8, 1.2)
					halo.Rotation = NumberRange.new(0, 360)
					halo.RotSpeed = NumberRange.new(-30, 30)
					halo.Size = NumberSequence.new({
						NumberSequenceKeypoint.new(0, 5 * AURA.Size),
						NumberSequenceKeypoint.new(1, 6.5 * AURA.Size),
					})
					halo.Transparency = NumberSequence.new({
						NumberSequenceKeypoint.new(0, 1),
						NumberSequenceKeypoint.new(0.4, 0.75),
						NumberSequenceKeypoint.new(1, 1),
					})
					halo.LightInfluence = 0
					halo.ZOffset = -1
					halo.Parent = torso
					table.insert(data.parts, halo)
					data.energy.halo = halo
				end

			else
				data.rings = {}
				for r = 1, #RING_TILTS do
					data.rings[r] = makeRing(data, RING_SEGMENTS)
				end
			end

			aura = data
		end

		RunService.RenderStepped:Connect(function()
			local character = localPlayer.Character
			local root = character and character:FindFirstChild("HumanoidRootPart")
			local humanoid = character and character:FindFirstChildOfClass("Humanoid")

			if not AURA.Enabled or not root or not humanoid or humanoid.Health <= 0 then
				destroyAura()
				return
			end

			if not aura or aura.style ~= AURA.Style or aura.size ~= AURA.Size or aura.character ~= character then
				buildAura(character)
			end

			local now = os.clock()
			local speed = AURA.Speed
			local color = AURA.Rainbow and Color3.fromHSV((now * 0.3) % 1, 0.8, 1) or AURA.Color
			local material = AURA.Glow and Enum.Material.Neon or Enum.Material.SmoothPlastic
			local center = root.Position
			local s = aura.size

			local head = character:FindFirstChild("Head")
			local camera = workspace.CurrentCamera
			local firstPerson = head and camera
				and (camera.CFrame.Position - head.Position).Magnitude < AURA.FirstPersonDistance
			local shown = not firstPerson
			local hidden = shown and 0 or 1

			aura.holder.CFrame = CFrame.new(center)
			aura.light.Enabled = shown and AURA.Glow
			aura.light.Color = color
			aura.light.Brightness = 1.2
			aura.light.Range = 9 * s

			local feetY
			if humanoid.RigType == Enum.HumanoidRigType.R6 then
				feetY = center.Y - 3
			else
				feetY = center.Y - (humanoid.HipHeight + root.Size.Y / 2)
			end

			if aura.orbs then
				for i, orb in ipairs(aura.orbs) do
					local radius = (2 + (i % 2) * 0.5) * s
					local angle = now * speed * (1.6 + i * 0.35) + i * 1.7
					orb.part.CFrame = CFrame.new(center) * ORBIT_TILTS[i] * CFrame.new(math.cos(angle) * radius, 0, math.sin(angle) * radius)
					orb.part.Color = color
					orb.part.Material = material
					orb.part.Transparency = hidden
					orb.trail.Color = ColorSequence.new(color)
					orb.trail.Enabled = shown
					orb.trail.LightEmission = AURA.Glow and 1 or 0
				end

			elseif aura.helix then

				local height = 4.4 * s
				local turns = 2.2
				local phase = now * speed * 1.4
				local breathe = 1 + math.sin(now * speed * 1.8) * 0.05
				local radius = 1.6 * s * breathe

				local function helixPoint(h, strand)
					local angle = h * turns * math.pi * 2 - phase + (strand - 1) * math.pi
					return Vector3.new(center.X + math.cos(angle) * radius, feetY + 0.1 + h * height, center.Z + math.sin(angle) * radius)
				end

				local function edgeFade(h)
					return math.sin(math.clamp(h, 0, 1) * math.pi) ^ 0.7
				end

				for strand, segments in ipairs(aura.helix.strands) do
					local count = #segments
					for i, part in ipairs(segments) do
						local h0, h1 = (i - 1) / count, i / count
						local a, b = helixPoint(h0, strand), helixPoint(h1, strand)
						local fade = edgeFade((h0 + h1) / 2)
						local thickness = (0.05 + 0.07 * fade) * s
						local middle = (a + b) / 2
						part.Size = Vector3.new(thickness, thickness, (b - a).Magnitude + thickness * 0.6)
						part.CFrame = CFrame.lookAt(middle, b)
						part.Color = color
						part.Material = material
						part.Transparency = shown and (1 - 0.9 * fade) or 1
					end
				end

				for i, rung in ipairs(aura.helix.rungs) do
					local h = (i - 0.5) / #aura.helix.rungs
					local a, b = helixPoint(h, 1), helixPoint(h, 2)
					local fade = edgeFade(h)
					local middle = (a + b) / 2
					rung.Size = Vector3.new(0.035 * s, 0.035 * s, (b - a).Magnitude)
					rung.CFrame = CFrame.lookAt(middle, b)
					rung.Color = color
					rung.Material = material
					rung.Transparency = shown and (1 - 0.45 * fade) or 1
				end

				for _, spark in ipairs(aura.helix.sparks) do
					local h = (now * 0.22 * speed + (spark.index - 1) / HELIX_SPARKS + (spark.strand - 1) * 0.125) % 1
					local fade = edgeFade(h)
					spark.part.Size = Vector3.one * (0.12 + 0.1 * fade) * s
					spark.part.CFrame = CFrame.new(helixPoint(h, spark.strand))
					spark.part.Color = color
					spark.part.Material = Enum.Material.Neon
					spark.part.Transparency = shown and (1 - fade) or 1
					spark.trail.Color = ColorSequence.new(color)
					spark.trail.Enabled = shown and fade > 0.05
					spark.trail.LightEmission = AURA.Glow and 1 or 0.3
				end

			elseif aura.radiance then
				local radiance = aura.radiance
				local soft = color:Lerp(Color3.new(1, 1, 1), 0.35)
				radiance.glowBox.CFrame = CFrame.new(center + Vector3.new(0, 0.3 * s, 0))
				radiance.glow.Enabled = shown
				radiance.glow.Color = ColorSequence.new(soft)
				radiance.glow.LightEmission = AURA.Glow and 1 or 0.5
				radiance.glow.Rate = 30 * speed
				radiance.feet.CFrame = CFrame.new(center.X, feetY + 0.1, center.Z)
				radiance.wisps.Enabled = shown
				radiance.wisps.Color = ColorSequence.new(soft)
				radiance.wisps.LightEmission = AURA.Glow and 1 or 0.4

				local height = 4.6 * s
				for i, streak in ipairs(radiance.streaks) do

					local h = (now * 0.32 * speed + (i - 1) / #radiance.streaks) % 1
					local angle = now * speed * 2.6 + i * 2.1
					local radius = (1.25 + 0.35 * math.sin(h * math.pi)) * s
					local fade = math.sin(h * math.pi)
					streak.part.CFrame = CFrame.new(center.X + math.cos(angle) * radius, feetY + 0.2 + h * height, center.Z + math.sin(angle) * radius)
					streak.part.Color = color:Lerp(Color3.new(1, 1, 1), 0.6)
					streak.part.Material = Enum.Material.Neon
					streak.part.Transparency = shown and (1 - fade) or 1
					streak.trail.Enabled = shown and fade > 0.08
					streak.trail.Color = ColorSequence.new(soft)
					streak.trail.LightEmission = 1
				end

				aura.light.Brightness = 1.5 + math.sin(now * 2) * 0.3
				aura.light.Range = 12 * s

			elseif aura.energy then
				local energy = aura.energy
				local pulse = math.sin(now * 4 * speed) * 0.5 + 0.5
				local emission = AURA.Glow and 1 or 0.4

				energy.highlight.Enabled = shown
				energy.highlight.FillColor = color
				energy.highlight.OutlineColor = color
				energy.highlight.FillTransparency = 0.72 + 0.12 * pulse
				energy.highlight.OutlineTransparency = 0.05 + 0.25 * pulse

				local sequence = ColorSequence.new(color:Lerp(Color3.new(1, 1, 1), 0.35), color)
				for _, flame in ipairs(energy.flames) do
					flame.Enabled = shown
					flame.Rate = energy.rates[flame] * speed
					flame.Color = sequence
					flame.LightEmission = emission
				end
				for _, sparks in ipairs(energy.sparks) do
					sparks.Enabled = shown
					sparks.Rate = energy.rates[sparks] * speed
					sparks.Color = ColorSequence.new(color:Lerp(Color3.new(1, 1, 1), 0.5))
					sparks.LightEmission = emission
				end
				if energy.halo then
					energy.halo.Enabled = shown
					energy.halo.Color = ColorSequence.new(color)
					energy.halo.LightEmission = emission
				end

				aura.light.Brightness = 1 + pulse * 0.8
				aura.light.Range = 10 * s

			elseif aura.rings then
				for r, ring in ipairs(aura.rings) do
					local radius = (2.4 + r * 0.25) * s
					local segment = 2 * math.pi * radius / RING_SEGMENTS * 0.7
					local spin = now * speed * (r % 2 == 0 and -1.5 or 1.5)
					local ringCFrame = CFrame.new(center) * RING_TILTS[r] * CFrame.Angles(0, spin, 0)
					for i, part in ipairs(ring) do
						local angle = (i - 1) / RING_SEGMENTS * math.pi * 2
						part.Size = Vector3.new(0.12 * s, 0.12 * s, segment)
						part.CFrame = ringCFrame * CFrame.Angles(0, angle, 0) * CFrame.new(radius, 0, 0)
						part.Color = color
						part.Transparency = shown and (0.1 + 0.4 * (i % 3 == 0 and 1 or 0)) or 1
						part.Material = material
					end
				end
			end
		end)
		return function()
			for _, connection in ipairs(connections) do
				connection:Disconnect()
			end
			destroyAura()
			auraFolder:Destroy()
		end
	end
	RENDERERS.Aura(localPlayer, AURA)
end

local BACK, BACK_STYLES
do
	BACK = {
		Enabled = false,
		Style = "Angel Wings",
		Rainbow = false,
		Color = Color3.fromRGB(255, 255, 255),
		Transparency = 0.35,
		Glow = false,
		Size = 1,
		Animation = true,
		Speed = 1,
		FirstPersonDistance = 1.5,
	}
	BACK_STYLES = { "Angel Wings", "Light Wings", "Demon Wings", "Butterfly Wings", "Backpack", "Jetpack" }

	RENDERERS.Back = function(owner, BACK)
		local connections = {}
		local localPlayer, RunService = syncContext(owner, connections)

		local DARK = Color3.fromRGB(38, 38, 44)
		local METAL = Color3.fromRGB(96, 100, 110)
		local VERTICAL = CFrame.Angles(0, 0, math.pi / 2)

		local WING_TOP = { { 0.25, 0.35 }, { 0.9, 1.05 }, { 1.75, 1.42 }, { 2.55, 1.38 }, { 3.05, 0.95 } }
		local WING_TIPS = { { 2.95, 0.12 }, { 2.55, -0.58 }, { 2.05, -1.08 }, { 1.45, -1.38 }, { 0.88, -1.28 }, { 0.42, -0.78 } }

		local backFolder = Instance.new("Folder")
		backFolder.Name = "BackAccessory_Local"
		backFolder.Parent = workspace

		local back = nil

		local function destroyBack()
			if back then
				for _, object in ipairs(back.all) do
					object:Destroy()
				end
				back = nil
			end
		end

		local function prepare(data, part, kind)
			part.Anchored = false
			part.Massless = true
			part.CanCollide = false
			part.CanQuery = false
			part.CanTouch = false
			part.CastShadow = false
			part.Material = Enum.Material.SmoothPlastic
			part.Parent = backFolder
			table.insert(data.all, part)
			if kind then
				table.insert(data.items, { part = part, kind = kind })
			end
			return part
		end

		local function weld(anchor, part)
			local constraint = Instance.new("WeldConstraint")
			constraint.Part0 = anchor
			constraint.Part1 = part
			constraint.Parent = part
		end

		local function block(data, anchor, cframe, size, kind, shape)
			local part = Instance.new("Part")
			if shape then
				part.Shape = shape
			end
			part.Size = size
			part.CFrame = cframe
			prepare(data, part, kind)
			weld(anchor, part)
			return part
		end

		local function line(data, anchor, base, a, b, thickness, kind)
			local length = (b - a).Magnitude
			if length < 0.01 then
				return
			end
			local middle = (a + b) / 2

			local direction = (b - a).Unit
			local up = math.abs(direction.Y) > 0.99 and Vector3.zAxis or Vector3.yAxis
			return block(data, anchor, base * CFrame.lookAt(middle, b, up), Vector3.new(thickness, thickness, length), kind or "neon")
		end

		local function wireBox(data, anchor, cframe, size, thickness)
			local h = size / 2
			for _, y in ipairs({ -h.Y, h.Y }) do
				for _, z in ipairs({ -h.Z, h.Z }) do
					line(data, anchor, cframe, Vector3.new(-h.X, y, z), Vector3.new(h.X, y, z), thickness)
				end
			end
			for _, x in ipairs({ -h.X, h.X }) do
				for _, z in ipairs({ -h.Z, h.Z }) do
					line(data, anchor, cframe, Vector3.new(x, -h.Y, z), Vector3.new(x, h.Y, z), thickness)
				end
				for _, y in ipairs({ -h.Y, h.Y }) do
					line(data, anchor, cframe, Vector3.new(x, y, -h.Z), Vector3.new(x, y, h.Z), thickness)
				end
			end
		end

		local function triangle(data, anchor, a, b, c, kind)
			local w1, w2 = makeTriangle(a, b, c)
			for _, wedge in ipairs({ w1, w2 }) do
				prepare(data, wedge, kind)
				weld(anchor, wedge)
			end
		end

		local function buildWing(data, torso, side)
			local s = data.size
			local backZ = torso.Size.Z / 2

			local bone = Instance.new("Part")
			bone.Size = Vector3.new(0.1, 0.1, 0.1)
			bone.Transparency = 1
			prepare(data, bone)

			local baseC0 = CFrame.new(side * torso.Size.X * 0.18, torso.Size.Y * 0.28, backZ + 0.08)
			local motor = Instance.new("Motor6D")
			motor.Part0 = torso
			motor.Part1 = bone
			motor.C0 = baseC0
			motor.Parent = bone
			table.insert(data.all, motor)
			bone.CFrame = torso.CFrame * baseC0

			local function point(p, depth)
				return (bone.CFrame * CFrame.new(side * p[1] * s, p[2] * s, depth or 0)).Position
			end

			local contour = {}
			for _, p in ipairs(WING_TOP) do
				table.insert(contour, p)
			end
			for i, tip in ipairs(WING_TIPS) do
				table.insert(contour, tip)
				local nextTip = WING_TIPS[i + 1]
				if nextTip then
					table.insert(contour, { (tip[1] + nextTip[1]) / 2 * 0.8, (tip[2] + nextTip[2]) / 2 * 0.8 })
				end
			end
			table.insert(contour, { 0.12, -0.25 })

			local root = point({ 0, 0 })

			for i = 1, #contour - 1 do
				triangle(data, bone, root, point(contour[i]), point(contour[i + 1]), "main")
			end

			local inner = {}
			for i = 1, #WING_TOP do
				inner[#inner + 1] = { WING_TOP[i][1] * 0.6, WING_TOP[i][2] * 0.75 }
			end
			for i = 1, #WING_TIPS, 2 do
				inner[#inner + 1] = { WING_TIPS[i][1] * 0.55, WING_TIPS[i][2] * 0.55 }
			end
			local innerRoot = point({ 0, 0 }, 0.06 * s)
			for i = 1, #inner - 1 do
				triangle(data, bone, innerRoot, point(inner[i], 0.06 * s), point(inner[i + 1], 0.06 * s), "soft")
			end

			local thickness = 0.05 * s
			local boneCFrame = bone.CFrame
			local function localPoint(p, depth)
				return Vector3.new(side * p[1] * s, p[2] * s, depth or -0.03)
			end
			for _, tip in ipairs(WING_TIPS) do
				line(data, bone, boneCFrame, localPoint({ 0, 0 }), localPoint(tip), thickness)
			end
			for i = 1, #WING_TOP - 1 do
				line(data, bone, boneCFrame, localPoint(WING_TOP[i]), localPoint(WING_TOP[i + 1]), thickness * 1.4)
			end
			line(data, bone, boneCFrame, localPoint(WING_TOP[#WING_TOP]), localPoint(WING_TIPS[1]), thickness * 1.4)

			table.insert(data.wings, { motor = motor, baseC0 = baseC0, side = side })
		end

		local ANGEL_ROWS = {

			{ count = 11, length = 1.1, grow = 1.9, width = 0.55, depth = 0.0, kind = "main", lift = 0.0, span = 1.0 },
			{ count = 9, length = 0.7, grow = 0.95, width = 0.5, depth = 0.05, kind = "soft", lift = -0.12, span = 0.92 },
			{ count = 7, length = 0.4, grow = 0.45, width = 0.45, depth = 0.09, kind = "soft", lift = -0.22, span = 0.82 },
		}
		local ARC_START, ARC_CONTROL, ARC_END = Vector2.new(0.15, 0.2), Vector2.new(1.0, 1.75), Vector2.new(2.7, 1.35)

		local function arcPoint(t)
			local u = 1 - t
			return ARC_START * (u * u) + ARC_CONTROL * (2 * u * t) + ARC_END * (t * t)
		end

		local function addWingGlow(data, bone, side)
			local s = data.size
			local box = Instance.new("Part")
			box.Size = Vector3.new(2.4 * s, 2.2 * s, 0.3 * s)
			box.Transparency = 1
			box.CFrame = bone.CFrame * CFrame.new(side * 1.35 * s, 0.35 * s, 0.05 * s)
			prepare(data, box)
			local weld = Instance.new("WeldConstraint")
			weld.Part0 = bone
			weld.Part1 = box
			weld.Parent = box

			local glow = Instance.new("ParticleEmitter")
			glow.Texture = "rbxasset://textures/particles/smoke_main.dds"
			glow.Shape = Enum.ParticleEmitterShape.Box
			glow.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume
			glow.Rate = 26
			glow.Lifetime = NumberRange.new(0.45, 0.8)
			glow.Speed = NumberRange.new(0, 0.3)
			glow.Rotation = NumberRange.new(0, 360)
			glow.RotSpeed = NumberRange.new(-30, 30)
			glow.Size = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 0.9 * s),
				NumberSequenceKeypoint.new(1, 1.6 * s),
			})
			glow.Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 1),
				NumberSequenceKeypoint.new(0.3, 0.55),
				NumberSequenceKeypoint.new(1, 1),
			})
			glow.LightEmission = 1
			glow.LightInfluence = 0
			glow.LockedToPart = true
			glow.Parent = box
			table.insert(data.glows, glow)
		end

		local function buildAngelWing(data, torso, side)
			local s = data.size
			local backZ = torso.Size.Z / 2

			local bone = Instance.new("Part")
			bone.Size = Vector3.new(0.1, 0.1, 0.1)
			bone.Transparency = 1
			prepare(data, bone)

			local baseC0 = CFrame.new(side * torso.Size.X * 0.15, torso.Size.Y * 0.32, backZ + 0.1)
			data.lastBone = bone
			local motor = Instance.new("Motor6D")
			motor.Part0 = torso
			motor.Part1 = bone
			motor.C0 = baseC0
			motor.Parent = bone
			table.insert(data.all, motor)
			bone.CFrame = torso.CFrame * baseC0

			local boneCFrame = bone.CFrame
			local function world(p, depth)
				return (boneCFrame * CFrame.new(side * p.X * s, p.Y * s, depth * s)).Position
			end

			for _, row in ipairs(ANGEL_ROWS) do
				for i = 1, row.count do
					local t = 0.05 + (i - 1) / math.max(row.count - 1, 1) * (row.span - 0.05)
					local angle = math.rad(-100 + 75 * t)
					local direction = Vector2.new(math.cos(angle), math.sin(angle))
					local across = Vector2.new(-direction.Y, direction.X)
					local base = arcPoint(t) + Vector2.new(0, row.lift)
					local length = row.length + row.grow * t
					local left = base + across * (row.width / 2)
					local right = base - across * (row.width / 2)
					local tip = base + direction * length
					triangle(data, bone, world(left, row.depth), world(right, row.depth), world(tip, row.depth), row.kind)
				end
			end

			local segments = 8
			for i = 1, segments do
				local a, b = arcPoint((i - 1) / segments), arcPoint(i / segments)
				local aLow, bLow = a - Vector2.new(0, 0.3), b - Vector2.new(0, 0.3)
				triangle(data, bone, world(a, 0.11), world(b, 0.11), world(aLow, 0.11), "main")
				triangle(data, bone, world(b, 0.11), world(bLow, 0.11), world(aLow, 0.11), "main")
				line(data, bone, boneCFrame,
					Vector3.new(side * a.X * s, a.Y * s, 0.13 * s),
					Vector3.new(side * b.X * s, b.Y * s, 0.13 * s),
					0.06 * s)
			end

			table.insert(data.wings, { motor = motor, baseC0 = baseC0, side = side })
		end

		local DEMON_SHOULDER = Vector2.new(0, 0)
		local DEMON_WRIST = Vector2.new(1.3, 1.25)
		local DEMON_CLAW = Vector2.new(1.22, 1.6)
		local DEMON_FINGERS = { Vector2.new(3.0, 1.1), Vector2.new(2.9, 0.1), Vector2.new(2.3, -0.75), Vector2.new(1.45, -1.3) }
		local DEMON_BODY = Vector2.new(0.15, -0.9)

		local function buildDemonWing(data, torso, side)
			local s = data.size
			local backZ = torso.Size.Z / 2

			local bone = Instance.new("Part")
			bone.Size = Vector3.new(0.1, 0.1, 0.1)
			bone.Transparency = 1
			prepare(data, bone)

			local baseC0 = CFrame.new(side * torso.Size.X * 0.15, torso.Size.Y * 0.3, backZ + 0.1)
			local motor = Instance.new("Motor6D")
			motor.Part0 = torso
			motor.Part1 = bone
			motor.C0 = baseC0
			motor.Parent = bone
			table.insert(data.all, motor)
			bone.CFrame = torso.CFrame * baseC0

			local boneCFrame = bone.CFrame
			local function world(p, depth)
				return (boneCFrame * CFrame.new(side * p.X * s, p.Y * s, (depth or 0) * s)).Position
			end
			local function boneLocal(p, depth)
				return Vector3.new(side * p.X * s, p.Y * s, (depth or -0.03) * s)
			end

			local edge = {}
			local previous = nil
			for _, tip in ipairs(DEMON_FINGERS) do
				if previous then
					local middle = (previous + tip) / 2
					table.insert(edge, middle + (DEMON_WRIST - middle) * 0.3)
				end
				table.insert(edge, tip)
				previous = tip
			end
			local lastMiddle = (previous + DEMON_BODY) / 2
			table.insert(edge, lastMiddle + (DEMON_WRIST - lastMiddle) * 0.25)
			table.insert(edge, DEMON_BODY)

			local wrist = world(DEMON_WRIST)
			for i = 1, #edge - 1 do
				triangle(data, bone, wrist, world(edge[i]), world(edge[i + 1]), "main")
			end
			triangle(data, bone, world(DEMON_SHOULDER), wrist, world(DEMON_BODY), "main")

			line(data, bone, boneCFrame, boneLocal(DEMON_SHOULDER), boneLocal(DEMON_WRIST), 0.1 * s)
			line(data, bone, boneCFrame, boneLocal(DEMON_WRIST), boneLocal(DEMON_CLAW), 0.08 * s)
			for _, tip in ipairs(DEMON_FINGERS) do
				line(data, bone, boneCFrame, boneLocal(DEMON_WRIST), boneLocal(tip), 0.065 * s)
			end

			table.insert(data.wings, { motor = motor, baseC0 = baseC0, side = side })
		end

		local function buildBack(character, torso)
			destroyBack()
			local s = BACK.Size
			local data = { style = BACK.Style, size = s, character = character, torso = torso, all = {}, items = {}, wings = {}, flames = {}, glows = {} }
			local backZ = torso.Size.Z / 2
			local halfX, halfY = torso.Size.X / 2, torso.Size.Y / 2
			local torsoCFrame = torso.CFrame
			local thin = 0.05 * s

			if data.style == "Light Wings" then

				data.forceGlow = true
				for _, side in ipairs({ -1, 1 }) do
					buildAngelWing(data, torso, side)
					addWingGlow(data, data.lastBone, side)
				end

			elseif data.style == "Angel Wings" then
				buildAngelWing(data, torso, -1)
				buildAngelWing(data, torso, 1)

			elseif data.style == "Demon Wings" then
				buildDemonWing(data, torso, -1)
				buildDemonWing(data, torso, 1)

			elseif data.style == "Butterfly Wings" then
				buildWing(data, torso, -1)
				buildWing(data, torso, 1)

			elseif data.style == "Backpack" then

				local bodySize = Vector3.new(1.45, 1.5, 0.62) * s
				local bodyCFrame = torsoCFrame * CFrame.new(0, -0.08 * s, backZ + 0.33 * s)
				block(data, torso, bodyCFrame, bodySize, "main")
				wireBox(data, torso, bodyCFrame, bodySize, thin)

				local topCFrame = torsoCFrame * CFrame.new(0, 0.67 * s, backZ + 0.33 * s)
				block(data, torso, topCFrame, Vector3.new(1.45 * s, 0.62 * s, 0.62 * s), "soft", Enum.PartType.Cylinder)

				local pocketSize = Vector3.new(1.0, 0.62, 0.2) * s
				local pocketCFrame = torsoCFrame * CFrame.new(0, -0.38 * s, backZ + 0.74 * s)
				block(data, torso, pocketCFrame, pocketSize, "soft")
				wireBox(data, torso, pocketCFrame, pocketSize, thin * 0.8)

				block(data, torso, pocketCFrame * CFrame.new(0, 0, pocketSize.Z / 2 + 0.01) * CFrame.Angles(0, 0, math.rad(45)),
					Vector3.new(0.2, 0.2, 0.03) * s, "neon")

				for _, side in ipairs({ -1, 1 }) do
					local sideSize = Vector3.new(0.18, 0.7, 0.45) * s
					local sideCFrame = torsoCFrame * CFrame.new(side * (bodySize.X / 2 + sideSize.X / 2), -0.25 * s, backZ + 0.33 * s)
					block(data, torso, sideCFrame, sideSize, "soft")
					wireBox(data, torso, sideCFrame, sideSize, thin * 0.7)

					local x = side * halfX * 0.55
					local backTop = Vector3.new(x, halfY * 0.6, backZ + 0.05)
					local shoulderBack = Vector3.new(x, halfY + 0.06, backZ * 0.6)
					local shoulderFront = Vector3.new(x, halfY + 0.06, -backZ * 0.6)
					local chestBottom = Vector3.new(x, -halfY * 0.7, -(backZ + 0.05))
					line(data, torso, torsoCFrame, backTop, shoulderBack, thin * 1.6)
					line(data, torso, torsoCFrame, shoulderBack, shoulderFront, thin * 1.6)
					line(data, torso, torsoCFrame, shoulderFront, chestBottom, thin * 1.6)
				end

			else
				local plateCFrame = torsoCFrame * CFrame.new(0, 0.05 * s, backZ + 0.24 * s)
				local plateSize = Vector3.new(1.1, 1.3, 0.45) * s
				block(data, torso, plateCFrame, plateSize, "dark")
				wireBox(data, torso, plateCFrame, plateSize, thin * 0.8)
				for _, y in ipairs({ 0.42, -0.3 }) do
					block(data, torso, torsoCFrame * CFrame.new(0, y * s, backZ + 0.48 * s), Vector3.new(0.9, 0.1, 0.05) * s, "neon")
				end
				for _, side in ipairs({ -1, 1 }) do
					local x = side * 0.4 * s
					local z = backZ + 0.58 * s
					block(data, torso, torsoCFrame * CFrame.new(x, 0.05 * s, z) * VERTICAL, Vector3.new(1.5 * s, 0.56 * s, 0.56 * s), "main", Enum.PartType.Cylinder)
					block(data, torso, torsoCFrame * CFrame.new(x, 0.8 * s, z), Vector3.one * 0.56 * s, "main", Enum.PartType.Ball)
					block(data, torso, torsoCFrame * CFrame.new(x, -0.87 * s, z) * VERTICAL, Vector3.new(0.35 * s, 0.42 * s, 0.42 * s), "metal", Enum.PartType.Cylinder)

					local flamePart = block(data, torso, torsoCFrame * CFrame.new(x, -1.12 * s, z), Vector3.new(0.3, 0.1, 0.3) * s, nil)
					flamePart.Transparency = 1
					local emitter = Instance.new("ParticleEmitter")
					emitter.Texture = "rbxasset://textures/particles/fire_main.dds"
					emitter.EmissionDirection = Enum.NormalId.Bottom
					emitter.Speed = NumberRange.new(6, 9)
					emitter.SpreadAngle = Vector2.new(8, 8)
					emitter.Lifetime = NumberRange.new(0.12, 0.25)
					emitter.LightEmission = 1
					emitter.LightInfluence = 0
					emitter.Size = NumberSequence.new({
						NumberSequenceKeypoint.new(0, 0.45 * s),
						NumberSequenceKeypoint.new(1, 0),
					})
					emitter.Parent = flamePart
					table.insert(data.flames, emitter)
				end
			end

			back = data
		end

		RunService.RenderStepped:Connect(function()
			local character = localPlayer.Character
			local torso = character and (character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso"))
			local humanoid = character and character:FindFirstChildOfClass("Humanoid")

			if not BACK.Enabled or not torso or not humanoid or humanoid.Health <= 0 then
				destroyBack()
				return
			end

			if not back or back.style ~= BACK.Style or back.size ~= BACK.Size
				or back.character ~= character or back.torso ~= torso then
				buildBack(character, torso)
			end

			local now = os.clock()
			local color = BACK.Rainbow and Color3.fromHSV((now * 0.3) % 1, 0.7, 1) or BACK.Color
			local soft = color:Lerp(Color3.new(1, 1, 1), 0.35)
			local material = BACK.Glow and Enum.Material.Neon or Enum.Material.SmoothPlastic

			local head = character:FindFirstChild("Head")
			local camera = workspace.CurrentCamera
			local firstPerson = head and camera
				and (camera.CFrame.Position - head.Position).Magnitude < BACK.FirstPersonDistance

			local base = BACK.Transparency
			for _, item in ipairs(back.items) do
				local part = item.part
				if firstPerson then
					part.Transparency = 1
				elseif item.kind == "main" then
					part.Transparency = base
					part.Color = color
					part.Material = back.forceGlow and Enum.Material.Neon or material
				elseif item.kind == "soft" then
					part.Transparency = base + (1 - base) * 0.35
					part.Color = soft
					part.Material = back.forceGlow and Enum.Material.Neon or material
				elseif item.kind == "neon" then
					part.Transparency = base * 0.4
					part.Color = color
					part.Material = Enum.Material.Neon
				elseif item.kind == "metal" then
					part.Transparency = base * 0.5
					part.Color = METAL
					part.Material = Enum.Material.Metal
				else
					part.Transparency = base
					part.Color = DARK
					part.Material = Enum.Material.SmoothPlastic
				end
			end

			for _, glow in ipairs(back.glows or {}) do
				glow.Enabled = not firstPerson
				glow.Color = ColorSequence.new(color:Lerp(Color3.new(1, 1, 1), 0.3))
			end

			local flap = BACK.Animation and math.sin(now * 2.2 * BACK.Speed) * math.rad(14) or 0
			for _, wing in ipairs(back.wings) do
				wing.motor.C0 = wing.baseC0 * CFrame.Angles(0, -wing.side * (math.rad(24) + flap), 0)
			end

			if #back.flames > 0 then
				local state = humanoid:GetState()
				local airborne = state == Enum.HumanoidStateType.Jumping or state == Enum.HumanoidStateType.Freefall
				local moving = humanoid.MoveDirection.Magnitude > 0.1
				local rate = airborne and 90 or (moving and 35 or 12)
				for _, emitter in ipairs(back.flames) do
					emitter.Enabled = BACK.Animation and not firstPerson
					emitter.Rate = rate * BACK.Speed
					emitter.Color = BACK.Rainbow and ColorSequence.new(color)
						or ColorSequence.new(Color3.fromRGB(255, 230, 140), Color3.fromRGB(255, 90, 40))
				end
			end
		end)
		return function()
			for _, connection in ipairs(connections) do
				connection:Disconnect()
			end
			destroyBack()
			backFolder:Destroy()
		end
	end
	RENDERERS.Back(localPlayer, BACK)
end

local SHADERS, SHADER_PRESETS
do
	SHADERS = {
		Enabled = false,
		Preset = "Realism",
		Intensity = 1,
		SunRays = true,
		DepthOfField = true,
		Vignette = true,
	}
	SHADER_PRESETS = { "Realism", "Cinema", "Vivid", "Soft", "Noir" }

	local rgb = Color3.fromRGB
	local PRESETS = {
		["Realism"] = {
			Brightness = 0.02, Contrast = 0.12, Saturation = 0.08, Tint = rgb(255, 250, 244),
			Bloom = 0.6, BloomSize = 24, BloomThreshold = 1.6,
			Rays = 0.06, RaysSpread = 0.8,
			Far = 0.15, Focus = 30, Radius = 40,
			Vignette = 0.35,
		},
		["Cinema"] = {
			Brightness = 0, Contrast = 0.22, Saturation = -0.05, Tint = rgb(255, 236, 214),
			Bloom = 0.9, BloomSize = 32, BloomThreshold = 1.3,
			Rays = 0.1, RaysSpread = 0.9,
			Far = 0.25, Focus = 25, Radius = 30,
			Vignette = 0.55,
		},
		["Vivid"] = {
			Brightness = 0.03, Contrast = 0.15, Saturation = 0.3, Tint = rgb(255, 255, 255),
			Bloom = 1.0, BloomSize = 28, BloomThreshold = 1.2,
			Rays = 0.12, RaysSpread = 0.85,
			Far = 0.08, Focus = 40, Radius = 50,
			Vignette = 0.2,
		},
		["Soft"] = {
			Brightness = 0.05, Contrast = -0.05, Saturation = 0.05, Tint = rgb(255, 246, 250),
			Bloom = 1.2, BloomSize = 40, BloomThreshold = 1.0,
			Rays = 0.08, RaysSpread = 1,
			Far = 0.2, Focus = 30, Radius = 35,
			Vignette = 0.3,
		},
		["Noir"] = {
			Brightness = -0.02, Contrast = 0.35, Saturation = -1, Tint = rgb(255, 255, 255),
			Bloom = 0.4, BloomSize = 20, BloomThreshold = 1.5,
			Rays = 0.05, RaysSpread = 0.7,
			Far = 0.2, Focus = 25, Radius = 30,
			Vignette = 0.7,
		},
	}

	local POST_CLASSES = { "BloomEffect", "ColorCorrectionEffect", "SunRaysEffect", "DepthOfFieldEffect" }
	local LIGHTING_PROPS = { "EnvironmentDiffuseScale", "EnvironmentSpecularScale", "ShadowSoftness", "GlobalShadows" }

	local effects = nil
	local disabledGame = {}
	local lightingOriginal = nil

	local vignetteGui = Instance.new("ScreenGui")
	vignetteGui.Name = "OpusClient_Vignette"
	vignetteGui.IgnoreGuiInset = true
	vignetteGui.ResetOnSpawn = false
	vignetteGui.DisplayOrder = -10
	vignetteGui.Enabled = false
	vignetteGui.Parent = playerGui

	local vignetteGradients = {}
	for _, spec in ipairs({
		{ UDim2.fromScale(0, 0), UDim2.fromScale(1, 0.22), 90 },
		{ UDim2.fromScale(0, 0.78), UDim2.fromScale(1, 0.22), -90 },
		{ UDim2.fromScale(0, 0), UDim2.fromScale(0.16, 1), 0 },
		{ UDim2.fromScale(0.84, 0), UDim2.fromScale(0.16, 1), 180 },
	}) do
		local strip = Instance.new("Frame")
		strip.Position = spec[1]
		strip.Size = spec[2]
		strip.BackgroundColor3 = Color3.new(0, 0, 0)
		strip.BorderSizePixel = 0
		strip.Parent = vignetteGui
		local gradient = Instance.new("UIGradient")
		gradient.Rotation = spec[3]
		gradient.Parent = strip
		table.insert(vignetteGradients, gradient)
	end

	local function enableShaders()

		local camera = workspace.CurrentCamera
		for _, container in ipairs({ Lighting, camera }) do
			if container then
				for _, child in ipairs(container:GetChildren()) do
					for _, className in ipairs(POST_CLASSES) do
						if child:IsA(className) and child.Enabled and not child.Name:find("^JustVisuals") then
							child.Enabled = false
							table.insert(disabledGame, child)
						end
					end
				end
			end
		end

		lightingOriginal = {}
		for _, property in ipairs(LIGHTING_PROPS) do
			lightingOriginal[property] = Lighting[property]
		end

		effects = {
			grade = Instance.new("ColorCorrectionEffect"),
			bloom = Instance.new("BloomEffect"),
			rays = Instance.new("SunRaysEffect"),
			dof = Instance.new("DepthOfFieldEffect"),
		}
		for name, effect in pairs(effects) do
			effect.Name = "OpusShader_" .. name
			effect.Parent = Lighting
		end
	end

	local function disableShaders()
		for _, effect in pairs(effects) do
			effect:Destroy()
		end
		effects = nil
		for _, effect in ipairs(disabledGame) do
			if effect.Parent then
				effect.Enabled = true
			end
		end
		table.clear(disabledGame)
		for property, value in pairs(lightingOriginal) do
			Lighting[property] = value
		end
		lightingOriginal = nil
		vignetteGui.Enabled = false
	end

	RunService.RenderStepped:Connect(function()
		if not SHADERS.Enabled then
			if effects then
				disableShaders()
			end
			return
		end
		if not effects then
			enableShaders()
		end

		local p = PRESETS[SHADERS.Preset] or PRESETS["Realism"]
		local k = math.clamp(SHADERS.Intensity, 0, 1.5)

		local grade = effects.grade
		grade.Brightness = p.Brightness * k
		grade.Contrast = p.Contrast * k
		grade.Saturation = p.Saturation * k
		grade.TintColor = Color3.new(1, 1, 1):Lerp(p.Tint, math.min(k, 1))

		local bloom = effects.bloom
		bloom.Intensity = p.Bloom * k
		bloom.Size = p.BloomSize
		bloom.Threshold = p.BloomThreshold

		local rays = effects.rays
		rays.Enabled = SHADERS.SunRays
		rays.Intensity = p.Rays * k
		rays.Spread = p.RaysSpread

		local dof = effects.dof
		dof.Enabled = SHADERS.DepthOfField
		dof.FarIntensity = p.Far * k
		dof.NearIntensity = 0
		dof.FocusDistance = p.Focus
		dof.InFocusRadius = p.Radius

		Lighting.EnvironmentDiffuseScale = math.max(lightingOriginal.EnvironmentDiffuseScale, math.min(1, 0.6 * k + 0.2))
		Lighting.EnvironmentSpecularScale = math.max(lightingOriginal.EnvironmentSpecularScale, math.min(1, 0.7 * k + 0.2))
		Lighting.ShadowSoftness = math.clamp(0.1 + 0.1 * k, 0, 1)
		Lighting.GlobalShadows = true

		vignetteGui.Enabled = SHADERS.Vignette
		local edge = 1 - math.clamp(p.Vignette * k, 0, 0.9)
		for _, gradient in ipairs(vignetteGradients) do
			gradient.Transparency = NumberSequence.new(edge, 1)
		end
	end)
end

local BOTTOM, BOTTOM_STYLES, BOTTOM_MODES
do
	BOTTOM = {
		Enabled = false,
		Style = "Disc",
		Mode = "On Ground",
		Rainbow = false,
		Color = Color3.fromRGB(150, 185, 255),
		Glow = true,
		Size = 1,
		Transparency = 0.35,
		Tilt = false,
		Delay = 0,
	}
	BOTTOM_STYLES = { "Disc", "Hexagon", "Magic Circle", "Seal", "Cloud" }
	BOTTOM_MODES = { "Underfoot", "On Ground" }

	RENDERERS.Bottom = function(owner, BOTTOM)
		local connections = {}
		local localPlayer, RunService = syncContext(owner, connections)

		local folder = Instance.new("Folder")
		folder.Name = "Bottom_Local"
		folder.Parent = workspace

		local platform = nil

		local function destroyPlatform()
			if platform then
				for _, entry in ipairs(platform.parts) do
					entry.part:Destroy()
				end
				for _, hub in ipairs(platform.hubs or {}) do
					hub.part:Destroy()
				end
				platform = nil
			end
		end

		local function addPart(data, shape, size, offset, kind, spin)
			local part = Instance.new("Part")
			part.Shape = shape or Enum.PartType.Block
			part.Size = size
			part.Anchored = true
			part.CanCollide = false
			part.CanQuery = false
			part.CanTouch = false
			part.CastShadow = false
			part.Parent = folder
			table.insert(data.parts, { part = part, offset = offset, kind = kind, spin = spin or 0 })
			return part
		end

		local function ring(data, radius, thickness, segments, kind, spin, arcs, fill, y)
			arcs = arcs or 1
			fill = fill or 1
			local perArc = math.floor(segments / arcs)
			local span = math.pi * 2 / arcs * fill
			for a = 0, arcs - 1 do
				local start = a * math.pi * 2 / arcs
				local length = radius * span / perArc * 1.1
				for i = 0, perArc - 1 do
					local angle = start + (i + 0.5) / perArc * span
					addPart(data, nil, Vector3.new(thickness, thickness * 0.5, length),
						CFrame.new(0, y or 0, 0) * CFrame.Angles(0, angle, 0) * CFrame.new(radius, 0, 0), kind, spin)
				end
			end
		end

		local function buildPlatform()
			destroyPlatform()
			local s = BOTTOM.Size
			local data = { style = BOTTOM.Style, size = s, parts = {}, position = nil, tilt = CFrame.new() }

			if data.style == "Hexagon" then

				local R = 2 * s
				local corners = {}
				for i = 0, 5 do
					local angle = i / 6 * math.pi * 2
					corners[i + 1] = Vector3.new(math.cos(angle) * R, 0, math.sin(angle) * R)
				end
				for i = 1, 6 do
					local w1, w2 = makeTriangle(Vector3.zero, corners[i], corners[i % 6 + 1])
					for _, wedge in ipairs({ w1, w2 }) do
						wedge.Anchored = true
						wedge.CanCollide = false
						wedge.CanQuery = false
						wedge.CanTouch = false
						wedge.CastShadow = false
						wedge.Parent = folder

						table.insert(data.parts, { part = wedge, offset = wedge.CFrame, kind = "fill", spin = 0 })
					end
				end
				for _, scale in ipairs({ 1, 0.62 }) do
					for i = 1, 6 do
						local a, b = corners[i] * scale, corners[i % 6 + 1] * scale
						local middle = (a + b) / 2
						local thickness = (scale == 1 and 0.12 or 0.06) * s
						addPart(data, nil, Vector3.new(thickness, thickness * 0.5, (b - a).Magnitude + thickness),
							CFrame.lookAt(middle, b) + Vector3.new(0, 0.03, 0), "line", scale == 1 and 0 or 0.6)
					end
				end

			elseif data.style == "Magic Circle" then

				local R = 2.2 * s
				ring(data, R, 0.1 * s, 40, "line", 0.5, 4, 0.7)
				ring(data, R * 0.78, 0.06 * s, 36, "line", -0.8)
				for i = 0, 11 do
					local angle = i / 12 * math.pi * 2
					addPart(data, nil, Vector3.new(0.22 * s, 0.03 * s, 0.04 * s),
						CFrame.Angles(0, angle, 0) * CFrame.new(R * 0.78 + 0.13 * s, 0, 0), "line", -0.8)
				end
				ring(data, R * 0.42, 0.07 * s, 24, "line", 1.4, 3, 0.7)
				for i = 0, 5 do
					local angle = i / 6 * math.pi * 2
					addPart(data, nil, Vector3.new(R * 0.95, 0.02 * s, 0.035 * s),
						CFrame.Angles(0, angle, 0) * CFrame.new(R * 0.5, 0, 0), "line", 0.25)
				end

				addPart(data, Enum.PartType.Cylinder, Vector3.new(0.03, R * 2, R * 2),
					CFrame.new(0, -0.02, 0) * CFrame.Angles(0, 0, math.pi / 2), "fill", 0)

			elseif data.style == "Cloud" then

				for i = 1, 9 do
					local angle = (i - 1) / 9 * math.pi * 2
					local radius = (i == 1) and 0 or (0.9 + math.random() * 0.5) * s
					local size = (i == 1 and 2.2 or 1.3 + math.random() * 0.6) * s
					addPart(data, Enum.PartType.Ball, Vector3.one * size,
						CFrame.new(math.cos(angle) * radius, -size * 0.25, math.sin(angle) * radius), "soft", 0)
				end

			elseif data.style == "Seal" then

				local R = 3 * s
				data.hubs = {}
				local function layer(spin)
					local hub = Instance.new("Part")
					hub.Anchored = true
					hub.CanCollide = false
					hub.CanQuery = false
					hub.CanTouch = false
					hub.Transparency = 1
					hub.Size = Vector3.new(0.1, 0.1, 0.1)
					hub.CFrame = CFrame.new()
					hub.Parent = folder
					table.insert(data.hubs, { part = hub, spin = spin })
					return hub
				end
				local function weldTo(hub, part, kind)
					part.Anchored = false
					part.Massless = true
					part.CanCollide = false
					part.CanQuery = false
					part.CanTouch = false
					part.CastShadow = false
					part.Parent = folder
					local weld = Instance.new("WeldConstraint")
					weld.Part0 = hub
					weld.Part1 = part
					weld.Parent = part
					table.insert(data.parts, { part = part, kind = kind, welded = true })
				end
				local function stick(hub, a, b, thickness)
					local length = (b - a).Magnitude
					if length < 0.01 then
						return
					end
					local part = Instance.new("Part")
					part.Size = Vector3.new(thickness, thickness * 0.4, length + thickness * 0.8)
					part.CFrame = CFrame.lookAt((a + b) / 2, b)
					weldTo(hub, part, "line")
				end
				local function polar(radius, angle)
					return Vector3.new(math.cos(angle) * radius, 0.03, math.sin(angle) * radius)
				end
				local function circle(hub, radius, thickness, segments, arcs, fill)
					arcs, fill = arcs or 1, fill or 1
					local perArc = math.max(2, math.floor(segments / arcs))
					for a = 0, arcs - 1 do
						local start = a * math.pi * 2 / arcs
						local span = math.pi * 2 / arcs * fill
						for i = 0, perArc - 1 do
							stick(hub, polar(radius, start + i / perArc * span), polar(radius, start + (i + 1) / perArc * span), thickness)
						end
					end
				end

				local outer = layer(0.12)
				circle(outer, R, 0.07 * s, 72)
				circle(outer, R * 0.965, 0.04 * s, 72)
				local steps = 56
				local high, low = R * 0.93, R * 0.86
				for i = 0, steps - 1 do
					local a0 = i / steps * math.pi * 2
					local a1 = (i + 0.5) / steps * math.pi * 2
					local a2 = (i + 1) / steps * math.pi * 2

					stick(outer, polar(high, a0), polar(high, a1), 0.045 * s)
					stick(outer, polar(high, a1), polar(low, a1), 0.045 * s)
					stick(outer, polar(low, a1), polar(low, a2), 0.045 * s)
					stick(outer, polar(low, a2), polar(high, a2), 0.045 * s)
				end
				circle(outer, R * 0.83, 0.05 * s, 64)

				local runes = layer(-0.2)
				local seed = 7
				local function random()
					seed = (seed * 1103515245 + 12345) % 2147483648
					return seed / 2147483648
				end
				local glyphCount = 14
				local glyphSize = R * 0.085
				for g = 0, glyphCount - 1 do
					local angle = (g + 0.5) / glyphCount * math.pi * 2
					local center = polar(R * 0.755, angle)
					local tangent = Vector3.new(-math.sin(angle), 0, math.cos(angle))
					local radial = Vector3.new(math.cos(angle), 0, math.sin(angle))

					for _ = 1, 2 + math.floor(random() * 2) do
						local points = {}
						for k = 1, 2 + math.floor(random() * 2) do
							points[k] = center + tangent * (random() - 0.5) * glyphSize + radial * (random() - 0.5) * glyphSize
						end
						for k = 1, #points - 1 do
							stick(runes, points[k], points[k + 1], 0.04 * s)
						end
					end
				end
				circle(runes, R * 0.68, 0.06 * s, 60)
				for i = 0, 59 do
					local angle = i / 60 * math.pi * 2
					local long = i % 5 == 0
					stick(runes, polar(R * 0.68, angle), polar(R * (long and 0.715 or 0.695), angle), 0.03 * s)
				end
				circle(runes, R * 0.645, 0.15 * s, 36, 6, 0.55)

				local star = layer(0.3)
				for i = 0, 7 do
					local a = i / 8 * math.pi * 2
					local b = ((i + 3) % 8) / 8 * math.pi * 2
					stick(star, polar(R * 0.61, a), polar(R * 0.61, b), 0.06 * s)
					stick(star, polar(R * 0.61, a), polar(R * 0.2, a), 0.035 * s)
				end
				circle(star, R * 0.32, 0.05 * s, 36)

				local core = layer(-0.5)
				circle(core, R * 0.18, 0.05 * s, 28)
				local disc = Instance.new("Part")
				disc.Shape = Enum.PartType.Cylinder
				disc.Size = Vector3.new(0.03, R * 0.24, R * 0.24)
				disc.CFrame = CFrame.new(0, 0.02, 0) * CFrame.Angles(0, 0, math.pi / 2)
				weldTo(core, disc, "fill")

			else
				local R = 2 * s
				addPart(data, Enum.PartType.Cylinder, Vector3.new(0.06, R * 2, R * 2),
					CFrame.Angles(0, 0, math.pi / 2), "fill", 0)
				ring(data, R, 0.12 * s, 40, "line", 0, 1, 1, 0.04)
				ring(data, R * 0.7, 0.05 * s, 32, "line", 0.7, 3, 0.8, 0.04)
			end

			local lightPart = addPart(data, nil, Vector3.new(0.1, 0.1, 0.1), CFrame.new(0, 0.3, 0), "hidden", 0)
			local light = Instance.new("PointLight")
			light.Shadows = false
			light.Parent = lightPart
			data.light = light

			platform = data
		end

		local params = RaycastParams.new()
		params.FilterType = Enum.RaycastFilterType.Exclude

		RunService.RenderStepped:Connect(function(dt)
			local character = localPlayer.Character
			local root = character and character:FindFirstChild("HumanoidRootPart")
			local humanoid = character and character:FindFirstChildOfClass("Humanoid")
			if not BOTTOM.Enabled or not root or not humanoid or humanoid.Health <= 0 then
				destroyPlatform()
				return
			end
			if not platform or platform.style ~= BOTTOM.Style or platform.size ~= BOTTOM.Size then
				buildPlatform()
			end

			local feetY = humanoid.RigType == Enum.HumanoidRigType.R6 and (root.Position.Y - 3)
				or (root.Position.Y - humanoid.HipHeight - root.Size.Y / 2)
			local y = feetY
			if BOTTOM.Mode == "On Ground" then
				params.FilterDescendantsInstances = { character, folder }
				local hit = workspace:Raycast(root.Position, Vector3.new(0, -60, 0), params)
				y = hit and hit.Position.Y or feetY
			end
			local target = Vector3.new(root.Position.X, y + 0.06, root.Position.Z)

			local delay = math.clamp(BOTTOM.Delay, 0, 1)
			if delay <= 0.001 or not platform.position or (platform.position - target).Magnitude > 30 then
				platform.position = target
			else
				local followSpeed = 2 + (1 - delay) * 28
				platform.position = platform.position:Lerp(target, 1 - math.exp(-followSpeed * dt))
			end

			local velocity = root.AssemblyLinearVelocity
			local wantTilt = CFrame.new()
			if BOTTOM.Tilt then
				local pitch = math.clamp(velocity.Z * 0.008, -0.14, 0.14)
				local roll = math.clamp(-velocity.X * 0.008, -0.14, 0.14)
				wantTilt = CFrame.Angles(pitch, 0, roll)
			end
			platform.tilt = platform.tilt:Lerp(wantTilt, 1 - math.exp(-8 * dt))

			local look = root.CFrame.LookVector
			local yaw = math.atan2(-look.X, -look.Z)
			local now = os.clock()
			local base = CFrame.new(platform.position) * platform.tilt * CFrame.Angles(0, yaw, 0)

			local color = BOTTOM.Rainbow and Color3.fromHSV((now * 0.3) % 1, 0.7, 1) or BOTTOM.Color
			local light = color:Lerp(Color3.new(1, 1, 1), 0.4)
			local transparency = math.clamp(BOTTOM.Transparency, 0, 0.95)
			local pulse = 0.5 + 0.5 * math.sin(now * 2.2)
			local breathe = 1 + math.sin(now * 1.6) * 0.04

			for _, hub in ipairs(platform.hubs or {}) do
				hub.part.CFrame = base * CFrame.Angles(0, now * hub.spin, 0)
			end

			local appearanceKey = tostring(color) .. "/" .. transparency .. "/" .. tostring(BOTTOM.Glow)
			local refreshWelded = appearanceKey ~= platform.appearanceKey
			platform.appearanceKey = appearanceKey

			for _, entry in ipairs(platform.parts) do
				if entry.welded and not refreshWelded then
					continue
				end
				local offset = entry.offset or CFrame.new()
				if entry.welded then

				elseif (entry.spin or 0) ~= 0 then
					offset = CFrame.Angles(0, now * entry.spin, 0) * offset
				end
				if entry.kind == "soft" then
					local p = offset.Position
					offset = CFrame.new(p.X * breathe, p.Y, p.Z * breathe)
				end
				local part = entry.part
				if not entry.welded then
					part.CFrame = base * offset
				end
				if entry.kind == "hidden" then
					part.Transparency = 1
				elseif entry.kind == "fill" then
					part.Color = color
					part.Material = BOTTOM.Glow and Enum.Material.Neon or Enum.Material.SmoothPlastic
					part.Transparency = math.clamp(transparency + 0.4 + (entry.welded and 0 or 0.08 * pulse), 0, 0.97)
				elseif entry.kind == "soft" then
					part.Color = light
					part.Material = Enum.Material.SmoothPlastic
					part.Transparency = math.clamp(transparency * 0.6, 0, 0.9)
				else
					part.Color = light
					part.Material = BOTTOM.Glow and Enum.Material.Neon or Enum.Material.SmoothPlastic
					local flicker = entry.welded and 0 or 0.1 * pulse
					part.Transparency = math.clamp(transparency * 0.5 - flicker, 0, 0.9)
				end
			end

			platform.light.Enabled = BOTTOM.Glow
			platform.light.Color = color
			platform.light.Brightness = 1 + pulse * 0.6
			platform.light.Range = 8 * platform.size
		end)
		return function()
			for _, connection in ipairs(connections) do
				connection:Disconnect()
			end
			destroyPlatform()
			folder:Destroy()
		end
	end
	RENDERERS.Bottom(localPlayer, BOTTOM)
end

local function new(className, props)
	local obj = Instance.new(className)
	for key, value in pairs(props) do
		if key ~= "Parent" then
			obj[key] = value
		end
	end
	if props.Parent then
		obj.Parent = props.Parent
	end
	return obj
end

local CURSOR, CURSOR_STYLES
do
	CURSOR = {
		Enabled = false,
		Style = "Cross",
		Rainbow = false,
		Color = Color3.fromRGB(255, 90, 90),
		Size = 18,
		Thickness = 2,
		Outline = true,
		Spin = false,
		Transparency = 0,
	}

	CURSOR_STYLES = { "Dot", "Cross", "Circle", "Diamond" }

	local cursorGui = new("ScreenGui", {
		Name = "JustVisuals_Cursor",
		IgnoreGuiInset = true,
		ResetOnSpawn = false,
		DisplayOrder = 500,
		Enabled = false,
		Parent = playerGui,
	})

	local cursorRoot = new("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		Parent = cursorGui,
	})

	local cursorShapes = {}
	local cursorBuiltFor = nil
	local cursorHidDefault = false

	local function cursorFill(position, size, circle)
		local part = new("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = position,
			Size = size,
			BorderSizePixel = 0,
			Parent = cursorRoot,
		})
		if circle then
			new("UICorner", { CornerRadius = UDim.new(1, 0), Parent = part })
		end
		if CURSOR.Outline then
			new("UIStroke", {
				Color = Color3.fromRGB(0, 0, 0),
				Transparency = 0.35,
				Thickness = 1,
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Parent = part,
			})
		end
		table.insert(cursorShapes, { object = part })
		return part
	end

	local function cursorOutlineShape(size, circle, rotation)

		if CURSOR.Outline then
			local back = new("Frame", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromOffset(size, size),
				BackgroundTransparency = 1,
				Rotation = rotation or 0,
				Parent = cursorRoot,
			})
			if circle then
				new("UICorner", { CornerRadius = UDim.new(1, 0), Parent = back })
			end
			new("UIStroke", {
				Color = Color3.fromRGB(0, 0, 0),
				Transparency = 0.35,
				Thickness = CURSOR.Thickness + 2,
				Parent = back,
			})
		end

		local shape = new("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromOffset(size, size),
			BackgroundTransparency = 1,
			Rotation = rotation or 0,
			Parent = cursorRoot,
		})
		if circle then
			new("UICorner", { CornerRadius = UDim.new(1, 0), Parent = shape })
		end
		local stroke = new("UIStroke", {
			Thickness = CURSOR.Thickness,
			Parent = shape,
		})
		table.insert(cursorShapes, { object = shape, stroke = stroke })
	end

	local function buildCursor()
		for _, child in ipairs(cursorRoot:GetChildren()) do
			child:Destroy()
		end
		table.clear(cursorShapes)

		local size = CURSOR.Size
		local thickness = CURSOR.Thickness
		cursorRoot.Size = UDim2.fromOffset(size, size)

		if CURSOR.Style == "Dot" then
			local dot = math.max(thickness * 2, math.floor(size / 3))
			cursorFill(UDim2.fromScale(0.5, 0.5), UDim2.fromOffset(dot, dot), true)

		elseif CURSOR.Style == "Circle" then
			cursorOutlineShape(size, true)
			local dot = thickness + 2
			cursorFill(UDim2.fromScale(0.5, 0.5), UDim2.fromOffset(dot, dot), true)

		elseif CURSOR.Style == "Diamond" then
			cursorOutlineShape(math.floor(size * 0.7), false, 45)

		else
			local gap = math.max(2, math.floor(size * 0.18))
			local length = math.max(2, math.floor(size / 2 - gap))
			local offset = gap + length / 2
			cursorFill(UDim2.new(0.5, 0, 0.5, -offset), UDim2.fromOffset(thickness, length))
			cursorFill(UDim2.new(0.5, 0, 0.5, offset), UDim2.fromOffset(thickness, length))
			cursorFill(UDim2.new(0.5, -offset, 0.5, 0), UDim2.fromOffset(length, thickness))
			cursorFill(UDim2.new(0.5, offset, 0.5, 0), UDim2.fromOffset(length, thickness))
		end

		cursorBuiltFor = table.concat({ CURSOR.Style, size, thickness, tostring(CURSOR.Outline) }, "|")
	end

	RunService.RenderStepped:Connect(function()
		local enabled = CURSOR.Enabled and UserInputService.MouseEnabled
		cursorGui.Enabled = enabled

		if not enabled then

			if cursorHidDefault then
				UserInputService.MouseIconEnabled = true
				cursorHidDefault = false
			end
			return
		end

		UserInputService.MouseIconEnabled = false
		cursorHidDefault = true

		local key = table.concat({ CURSOR.Style, CURSOR.Size, CURSOR.Thickness, tostring(CURSOR.Outline) }, "|")
		if key ~= cursorBuiltFor then
			buildCursor()
		end

		local mouse = UserInputService:GetMouseLocation()
		cursorRoot.Position = UDim2.fromOffset(mouse.X, mouse.Y)
		cursorRoot.Rotation = CURSOR.Spin and (os.clock() * 120) % 360 or 0

		local color = CURSOR.Rainbow and Color3.fromHSV((os.clock() * 0.3) % 1, 0.8, 1) or CURSOR.Color
		for _, shape in ipairs(cursorShapes) do
			if shape.stroke then
				shape.stroke.Color = color
				shape.stroke.Transparency = CURSOR.Transparency
			else
				shape.object.BackgroundColor3 = color
				shape.object.BackgroundTransparency = CURSOR.Transparency
			end
		end
	end)
end
local BULBA
do
	BULBA = {
		Enabled = false,
		Size = 1,
	}

	RENDERERS.Bulba = function(owner, BULBA)
		local connections = {}
		local localPlayer, RunService = syncContext(owner, connections)

		local SKIN = Color3.fromRGB(176, 128, 72)
		local SKIN_DARK = Color3.fromRGB(122, 84, 44)

		local bulbaFolder = Instance.new("Folder")
		bulbaFolder.Name = "Bulba_Local"
		bulbaFolder.Parent = workspace

		local potato = nil

		local function restore()
			if not potato then
				return
			end
			if potato.connection then
				potato.connection:Disconnect()
			end

			for object, transparency in pairs(potato.hidden) do
				if object.Parent then
					object.Transparency = transparency
				end
			end
			for _, part in ipairs(potato.parts) do
				part:Destroy()
			end
			potato = nil
		end

		local function hide(object)
			if potato.hidden[object] ~= nil then
				return
			end
			if object:FindFirstAncestorOfClass("Tool") then
				return
			end
			if (object:IsA("BasePart") and object.Name ~= "HumanoidRootPart") or object:IsA("Decal") then
				potato.hidden[object] = object.Transparency
				object.Transparency = 1
			end
		end

		local function build(character, root, humanoid)
			restore()
			local s = BULBA.Size
			potato = { character = character, parts = {}, hidden = {}, size = s }

			for _, object in ipairs(character:GetDescendants()) do
				hide(object)
			end

			potato.connection = character.DescendantAdded:Connect(function(object)
				if potato and potato.character == character then
					hide(object)
				end
			end)

			local feet = humanoid.RigType == Enum.HumanoidRigType.R6 and -3 or -(humanoid.HipHeight + root.Size.Y / 2)
			local base = CFrame.new(0, feet + 1.55 * s, 0)
			local hub = Instance.new("Part")
			hub.Size = Vector3.new(0.1, 0.1, 0.1)
			hub.Transparency = 1
			hub.CanCollide = false
			hub.CanQuery = false
			hub.CanTouch = false
			hub.Massless = true
			hub.CFrame = root.CFrame * base
			hub.Parent = bulbaFolder
			table.insert(potato.parts, hub)
			local motor = Instance.new("Motor6D")
			motor.Part0 = root
			motor.Part1 = hub
			motor.C0 = base
			motor.Parent = hub
			potato.motor = motor
			potato.base = base

			local function piece(size, offset, color, shape, material)
				local part = Instance.new("Part")
				part.Shape = shape or Enum.PartType.Block
				part.Size = size * s
				part.CFrame = hub.CFrame * CFrame.new(offset.Position * s) * offset.Rotation
				part.Color = color
				part.Material = material or Enum.Material.SmoothPlastic
				part.CanCollide = false
				part.CanQuery = false
				part.CanTouch = false
				part.Massless = true
				part.CastShadow = true
				if not shape then
					local mesh = Instance.new("SpecialMesh")
					mesh.MeshType = Enum.MeshType.Sphere
					mesh.Parent = part
				end
				part.Parent = bulbaFolder
				local weld = Instance.new("WeldConstraint")
				weld.Part0 = hub
				weld.Part1 = part
				weld.Parent = part
				table.insert(potato.parts, part)
				return part
			end

			piece(Vector3.new(2.3, 2.9, 2.0), CFrame.new(0, 0, 0), SKIN)
			piece(Vector3.new(2.0, 2.2, 1.8), CFrame.new(0.15, 0.55, 0.05) * CFrame.Angles(0, 0, 0.15), SKIN)

			for _, spot in ipairs({
				{ -0.9, 0.6, 0.45 }, { 0.95, -0.4, 0.4 }, { -0.6, -0.9, -0.6 }, { 0.5, 1.0, -0.7 },
				{ -1.0, -0.2, -0.3 }, { 0.8, 0.5, 0.55 }, { 0.2, -1.2, 0.55 },
			}) do
				piece(Vector3.new(0.22, 0.16, 0.22), CFrame.new(spot[1], spot[2], spot[3]), SKIN_DARK)
			end

			for _, side in ipairs({ -1, 1 }) do
				piece(Vector3.new(0.5, 0.6, 0.25), CFrame.new(side * 0.42, 0.45, -0.9), Color3.new(1, 1, 1))
				piece(Vector3.new(0.25, 0.32, 0.12), CFrame.new(side * 0.42, 0.42, -1.02), Color3.fromRGB(20, 18, 16))
				piece(Vector3.new(0.08, 0.08, 0.05), CFrame.new(side * 0.36, 0.5, -1.08), Color3.new(1, 1, 1))

				piece(Vector3.new(0.32, 0.18, 0.1), CFrame.new(side * 0.72, 0.05, -0.85), Color3.fromRGB(225, 120, 110))
			end

			for i, x in ipairs({ -0.25, 0, 0.25 }) do
				local y = (i == 2) and -0.12 or -0.04

				piece(Vector3.new(0.28, 0.07, 0.07), CFrame.new(x, y, -1.0) * CFrame.Angles(0, 0, (i - 2) * 0.45),
					Color3.fromRGB(60, 30, 20), Enum.PartType.Block)
			end

			piece(Vector3.new(0.12, 0.5, 0.12), CFrame.new(0.1, 1.6, 0), Color3.fromRGB(110, 170, 70), Enum.PartType.Block)
			piece(Vector3.new(0.45, 0.08, 0.25), CFrame.new(0.32, 1.85, 0) * CFrame.Angles(0, 0, 0.5), Color3.fromRGB(120, 190, 80))
			piece(Vector3.new(0.4, 0.08, 0.22), CFrame.new(-0.12, 1.8, 0) * CFrame.Angles(0, 0, -0.5), Color3.fromRGB(120, 190, 80))
		end

		RunService.RenderStepped:Connect(function()
			local character = localPlayer.Character
			local root = character and character:FindFirstChild("HumanoidRootPart")
			local humanoid = character and character:FindFirstChildOfClass("Humanoid")
			if not BULBA.Enabled or not root or not humanoid or humanoid.Health <= 0 then
				restore()
				return
			end
			if not potato or potato.character ~= character or potato.size ~= BULBA.Size or not potato.motor.Parent then
				build(character, root, humanoid)
			end

			local now = os.clock()
			local velocity = root.AssemblyLinearVelocity
			local walking = math.clamp(Vector3.new(velocity.X, 0, velocity.Z).Magnitude / 16, 0, 1)
			local waddle = math.sin(now * 11) * 0.16 * walking
			local bounce = math.abs(math.sin(now * 11)) * 0.18 * walking * potato.size
			local breathe = (1 - walking) * math.sin(now * 2) * 0.03 * potato.size
			potato.motor.C0 = potato.base * CFrame.new(0, bounce + breathe, 0) * CFrame.Angles(0, 0, waddle)

			local camera = workspace.CurrentCamera
			local head = character:FindFirstChild("Head")
			local firstPerson = camera and head and (camera.CFrame.Position - head.Position).Magnitude < 1.5
			for i, part in ipairs(potato.parts) do
				if i > 1 then
					part.LocalTransparencyModifier = firstPerson and 1 or 0
				end
			end
		end)
		return function()
			for _, connection in ipairs(connections) do
				connection:Disconnect()
			end
			restore()
			bulbaFolder:Destroy()
		end
	end
	RENDERERS.Bulba(localPlayer, BULBA)
end

local SAHUR
do
	SAHUR = {
		Enabled = false,
		Size = 1,
		Rotation = 0,
		Forward = 0,
		Side = 0,
		Height = 0,
	}
	local SAHUR_ASSET_ID = 117733124031042

	RENDERERS.Sahur = function(owner, SAHUR)
		local connections = {}
		local localPlayer, RunService = syncContext(owner, connections)

		local sahurFolder = Instance.new("Folder")
		sahurFolder.Name = "Sahur_Local"
		sahurFolder.Parent = workspace

		local template, loading = nil, false
		local sahur = nil

		local function loadTemplate()
			loading = true
			local ok, objects = pcall(function()
				return game:GetObjects("rbxassetid://" .. SAHUR_ASSET_ID)
			end)
			local container = Instance.new("Model")
			if ok and objects and objects[1] then
				local object = objects[1]
				if object:IsA("Accessory") then
					object = object:FindFirstChildWhichIsA("BasePart") or object
				end
				object.Parent = container
				for _, descendant in ipairs(container:GetDescendants()) do
					if descendant:IsA("LuaSourceContainer") or descendant:IsA("Humanoid") or descendant:IsA("BodyMover") then
						descendant:Destroy()
					end
				end
			else
				local part = Instance.new("Part")
				part.Size = Vector3.new(4, 4, 4)
				local mesh = Instance.new("SpecialMesh")
				mesh.MeshType = Enum.MeshType.FileMesh
				mesh.MeshId = "rbxassetid://" .. SAHUR_ASSET_ID
				mesh.Parent = part
				part.Parent = container
			end
			if #container:GetDescendants() == 0 or not container:FindFirstChildWhichIsA("BasePart", true) then
				warn("Tung Tung Sahur asset failed to load")
				SAHUR.Enabled = false
				loading = false
				return
			end
			template = container
			loading = false
		end

		local function restore()
			if not sahur then
				return
			end
			if sahur.connection then
				sahur.connection:Disconnect()
			end
			for object, transparency in pairs(sahur.hidden) do
				if object.Parent then
					object.Transparency = transparency
				end
			end
			for _, part in ipairs(sahur.parts) do
				part:Destroy()
			end
			sahur = nil
		end

		local function hide(object)
			if sahur.hidden[object] ~= nil or object:FindFirstAncestorOfClass("Tool") then
				return
			end
			if (object:IsA("BasePart") and object.Name ~= "HumanoidRootPart") or object:IsA("Decal") then
				sahur.hidden[object] = object.Transparency
				object.Transparency = 1
			end
		end

		local function getBodyCenter(model, boxCFrame)
			local inverse = boxCFrame:Inverse()
			local sum, total = Vector3.zero, 0
			for _, part in ipairs(model:GetDescendants()) do
				if part:IsA("BasePart") and part.Transparency < 1 then
					local volume = part.Size.X * part.Size.Y * part.Size.Z
					sum += (inverse * part.Position) * volume
					total += volume
				end
			end
			if total <= 0 then
				return Vector3.zero
			end
			local center = sum / total
			return Vector3.new(center.X, 0, center.Z)
		end

		local function build(character, root, humanoid)
			restore()
			local s = SAHUR.Size
			sahur = { character = character, parts = {}, hidden = {}, size = s, visible = {} }

			for _, object in ipairs(character:GetDescendants()) do
				hide(object)
			end
			sahur.connection = character.DescendantAdded:Connect(function(object)
				if sahur and sahur.character == character then
					hide(object)
				end
			end)

			local height = 5.5 * s
			local feet = humanoid.RigType == Enum.HumanoidRigType.R6 and -3 or -(humanoid.HipHeight + root.Size.Y / 2)
			local base = CFrame.new(0, feet + height / 2, 0)

			local hub = Instance.new("Part")
			hub.Size = Vector3.new(0.1, 0.1, 0.1)
			hub.Transparency = 1
			hub.CanCollide = false
			hub.CanQuery = false
			hub.CanTouch = false
			hub.Massless = true
			hub.CFrame = root.CFrame * base
			hub.Parent = sahurFolder
			table.insert(sahur.parts, hub)
			local motor = Instance.new("Motor6D")
			motor.Part0 = root
			motor.Part1 = hub
			motor.C0 = base
			motor.Parent = hub
			sahur.motor = motor
			sahur.base = base

			local model = template:Clone()
			local _, boxSize = model:GetBoundingBox()
			if boxSize.Y > 0 then
				pcall(function()
					model:ScaleTo(model:GetScale() * height / boxSize.Y)
				end)
			end
			local boxCFrame = model:GetBoundingBox()
			local boxOffset = model:GetPivot():ToObjectSpace(boxCFrame)
			local anchor = getBodyCenter(model, boxCFrame)
			model:PivotTo(hub.CFrame * CFrame.new(-anchor) * boxOffset:Inverse())
			model.Parent = sahurFolder
			table.insert(sahur.parts, model)

			for _, part in ipairs(model:GetDescendants()) do
				if part:IsA("BasePart") then
					part.Anchored = false
					part.CanCollide = false
					part.CanQuery = false
					part.CanTouch = false
					part.Massless = true
					local weld = Instance.new("WeldConstraint")
					weld.Part0 = hub
					weld.Part1 = part
					weld.Parent = part
					table.insert(sahur.visible, part)
				end
			end
		end

		RunService.RenderStepped:Connect(function()
			local character = localPlayer.Character
			local root = character and character:FindFirstChild("HumanoidRootPart")
			local humanoid = character and character:FindFirstChildOfClass("Humanoid")
			if not SAHUR.Enabled or not root or not humanoid or humanoid.Health <= 0 then
				restore()
				return
			end
			if not template then
				if not loading then
					task.spawn(loadTemplate)
				end
				return
			end
			if not sahur or sahur.character ~= character or sahur.size ~= SAHUR.Size or not sahur.motor.Parent then
				build(character, root, humanoid)
			end

			local now = os.clock()
			local s = sahur.size
			local velocity = root.AssemblyLinearVelocity
			local walking = math.clamp(Vector3.new(velocity.X, 0, velocity.Z).Magnitude / 16, 0, 1)
			local waddle = math.sin(now * 10) * 0.1 * walking
			local bounce = math.abs(math.sin(now * 10)) * 0.15 * walking * s
			local breathe = (1 - walking) * math.sin(now * 2) * 0.03 * s
			local offset = CFrame.new(SAHUR.Side * s, SAHUR.Height * s + bounce + breathe, -SAHUR.Forward * s)
			sahur.motor.C0 = sahur.base * offset * CFrame.Angles(0, 0, waddle) * CFrame.Angles(0, math.rad(SAHUR.Rotation), 0)

			local camera = workspace.CurrentCamera
			local head = character:FindFirstChild("Head")
			local firstPerson = camera and head and (camera.CFrame.Position - head.Position).Magnitude < 1.5
			for _, part in ipairs(sahur.visible) do
				part.LocalTransparencyModifier = firstPerson and 1 or 0
			end
		end)
		return function()
			for _, connection in ipairs(connections) do
				connection:Disconnect()
			end
			restore()
			sahurFolder:Destroy()
		end
	end
	RENDERERS.Sahur(localPlayer, SAHUR)
end

	return {
		SAHUR = SAHUR, CURSOR = CURSOR, CURSOR_STYLES = CURSOR_STYLES, BULBA = BULBA, HAT = HAT, HAT_STYLES = HAT_STYLES,
		TRAIL = TRAIL, TRAIL_STYLES = TRAIL_STYLES,
		JUMP_CIRCLE = JUMP_CIRCLE, JUMP_CIRCLE_STYLES = JUMP_CIRCLE_STYLES, JUMP_CIRCLE_TRIGGERS = JUMP_CIRCLE_TRIGGERS,
		PARTICLES = PARTICLES, PARTICLE_STYLES = PARTICLE_STYLES,
		CONSTELLATIONS = CONSTELLATIONS, FOG = FOG,
		SKY = SKY, SKY_PRESET_ORDER = SKY_PRESET_ORDER, SKY_LIGHTING_MODES = SKY_LIGHTING_MODES,
		SHADERS = SHADERS, SHADER_PRESETS = SHADER_PRESETS,
		AURA = AURA, AURA_STYLES = AURA_STYLES,
		BACK = BACK, BACK_STYLES = BACK_STYLES,
		BOTTOM = BOTTOM, BOTTOM_STYLES = BOTTOM_STYLES, BOTTOM_MODES = BOTTOM_MODES,
	}
end
local VisualsTab=MainWindow:Tab({Title="Visuals",Icon="sparkles"});
VisualsTab:Section({Title="Kill Sound",Icon="volume-2"});VisualsTab:Toggle({Title="Kill Sound",Value=false,Callback=function(v)getgenv().killSoundConfig.Enabled=v end});VisualsTab:Slider({Title="Volume",Step=0.5,Value={Min=0.5,Max=10,Default=3},Callback=function(v)getgenv().killSoundConfig.Volume=tonumber(v)end});VisualsTab:Button({Title="Test Kill Sound",Callback=function()local w=getgenv().killSoundConfig.Enabled;getgenv().killSoundConfig.Enabled=true;PlayKillSound();getgenv().killSoundConfig.Enabled=w end});
VisualsTab:Section({Title="Kill Effect",Icon="zap"});VisualsTab:Toggle({Title="Kill Effect",Value=false,Callback=function(v)getgenv().killEffectConfig.Enabled=v end});VisualsTab:Dropdown({Title="Effect Type",Values={"Lightning","Fire","Explosion","Vortex","Matrix","Disintegrate","Blackhole"},Value="Lightning",Callback=function(v)getgenv().killEffectConfig.Effect=v end});VisualsTab:Button({Title="Test Kill Effect",Callback=function()local ch=LocalPlayer.Character;if ch and ch:FindFirstChild("HumanoidRootPart")then local fn=KillEffects[getgenv().killEffectConfig.Effect];if fn then pcall(fn,ch.HumanoidRootPart.Position+Vector3.new(0,0,-10))end end end});
VisualsTab:Section({Title="Bullet Tracers",Icon="crosshair"});VisualsTab:Toggle({Title="Bullet Tracers",Value=false,Callback=function(v)getgenv().tracerConfig.Enabled=v end});
VisualsTab:Dropdown({Title="Tracer Style",Values={"Line","Glow","Zigzag"},Value="Line",Callback=function(v)getgenv().tracerConfig.Style=v end});
VisualsTab:Colorpicker({Title="Tracer Color",Default=Color3.fromRGB(255,60,60),Callback=function(v)getgenv().tracerConfig.Color=v end});
VisualsTab:Toggle({Title="Tracer Rainbow",Value=false,Callback=function(v)getgenv().tracerConfig.Rainbow=v end});
VisualsTab:Slider({Title="Tracer Width",Step=0.01,Value={Min=0.03,Max=0.6,Default=0.12},Callback=function(v)getgenv().tracerConfig.Width=tonumber(v)end});
VisualsTab:Slider({Title="Tracer Duration",Step=0.05,Value={Min=0.1,Max=15,Default=0.6},Callback=function(v)getgenv().tracerConfig.Duration=tonumber(v)end});
VisualsTab:Slider({Title="Tracer Transparency",Step=0.05,Value={Min=0,Max=0.9,Default=0.1},Callback=function(v)getgenv().tracerConfig.Transparency=tonumber(v)end});
VisualsTab:Button({Title="Test Tracer",Callback=function()local cam=WorkspaceService.CurrentCamera;if not cam then return end;local w=getgenv().tracerConfig.Enabled;getgenv().tracerConfig.Enabled=true;local o=cam.CFrame.Position+cam.CFrame.LookVector*3-Vector3.new(0,1,0);CreateBulletTracer(o,o+cam.CFrame.LookVector*80);getgenv().tracerConfig.Enabled=w end});
VisualsTab:Section({Title="Hitmarker",Icon="crosshair"});VisualsTab:Toggle({Title="Kill Hitmarker (100)",Value=false,Callback=function(v)getgenv().hitmarkerConfig.Enabled=v end});
VisualsTab:Section({Title="Hit Logs",Icon="list"});VisualsTab:Toggle({Title="Hit Logs",Value=false,Callback=function(v)getgenv().hitLogConfig.Enabled=v end});VisualsTab:Dropdown({Title="Log Position",Values={"Left","Right","Crosshair"},Value="Left",Callback=function(v)getgenv().hitLogConfig.Position=(type(v)=="table" and v[1] or v);getgenv().hitLogApply()end});VisualsTab:Slider({Title="Log Duration",Step=0.5,Value={Min=1,Max=10,Default=4},Callback=function(v)getgenv().hitLogConfig.Duration=tonumber(v)end});VisualsTab:Slider({Title="Max Entries",Step=1,Value={Min=3,Max=12,Default=6},Callback=function(v)getgenv().hitLogConfig.MaxEntries=tonumber(v)end});VisualsTab:Toggle({Title="Log To Console",Value=false,Callback=function(v)getgenv().hitLogConfig.Console=v end});VisualsTab:Colorpicker({Title="Hit Color",Default=Color3.fromRGB(255,235,110),Callback=function(v)getgenv().hitLogConfig.HitColor=v end});VisualsTab:Colorpicker({Title="Kill Color",Default=Color3.fromRGB(255,70,110),Callback=function(v)getgenv().hitLogConfig.KillColor=v end});VisualsTab:Button({Title="Test Hit Log",Callback=function()getgenv().hitLogTest()end});
VisualsTab:Section({Title="Self Chams",Icon="user"});VisualsTab:Toggle({Title="Enable Self Chams",Value=false,Callback=function(v)getgenv().chamsConfig.Enabled=v;ApplyChams()end});VisualsTab:Colorpicker({Title="Fill Color",Default=Color3.fromRGB(170,0,255),Callback=function(v)getgenv().chamsConfig.FillColor=v;ApplyChams()end});VisualsTab:Colorpicker({Title="Outline Color",Default=Color3.fromRGB(255,100,255),Callback=function(v)getgenv().chamsConfig.OutlineColor=v;ApplyChams()end});VisualsTab:Slider({Title="Fill Transparency",Step=0.1,Value={Min=0,Max=1,Default=0.6},Callback=function(v)getgenv().chamsConfig.FillTransparency=tonumber(v);ApplyChams()end});

VisualsTab:Section({Title="Ratio (Stretched Res)",Icon="monitor"});
VisualsTab:Toggle({Title="Enable Ratio",Value=false,Desc="Stretches screen via CFrame manipulation",Callback=function(v)
    getgenv().ratioConfig.Enabled=v;
    ApplyRatio();
end});
VisualsTab:Slider({Title="Resolution",Step=0.01,Value={Min=0.50,Max=1.0,Default=0.80},Desc="Lower = more stretched | 1.0 = normal",Callback=function(v)
    getgenv().ratioConfig.Resolution=tonumber(v);
end});

VisualsTab:Section({Title="China Hat",Icon="hard-hat"});VisualsTab:Toggle({Title="China Hat",Value=false,Callback=function(v)getgenv().chinaHatConfig.Enabled=v;ApplyChinaHat()end});VisualsTab:Colorpicker({Title="Hat Color",Default=Color3.fromRGB(255,0,0),Callback=function(v)getgenv().chinaHatConfig.Color=v;ApplyChinaHat()end});VisualsTab:Slider({Title="Hat Size",Value={Min=3,Max=15,Default=5},Callback=function(v)getgenv().chinaHatConfig.Size=tonumber(v);ApplyChinaHat()end});VisualsTab:Slider({Title="Hat Transparency",Step=0.05,Value={Min=0,Max=0.95,Default=0.5},Callback=function(v)getgenv().chinaHatConfig.Transparency=tonumber(v);ApplyChinaHat()end});VisualsTab:Toggle({Title="Rotate",Value=true,Callback=function(v)getgenv().chinaHatConfig.Rotate=v end});VisualsTab:Slider({Title="Rotation Speed",Step=5,Value={Min=0,Max=360,Default=60},Callback=function(v)getgenv().chinaHatConfig.RotateSpeed=tonumber(v)end});VisualsTab:Toggle({Title="Rainbow",Value=false,Callback=function(v)getgenv().chinaHatConfig.Rainbow=v end});VisualsTab:Toggle({Title="Outline",Value=true,Callback=function(v)getgenv().chinaHatConfig.Outline=v;ApplyChinaHat()end});VisualsTab:Colorpicker({Title="Outline Color",Default=Color3.fromRGB(255,255,255),Callback=function(v)getgenv().chinaHatConfig.OutlineColor=v;ApplyChinaHat()end});
do
	local okVisuals,V=pcall(buildUniversalVisuals);
	if not okVisuals then warn("Visuals failed: "..tostring(V))else
	local COLOR_NAMES={"White","Red","Orange","Yellow","Green","Cyan","Blue","Purple","Pink","Black"};
	local COLOR_PRESETS={White=Color3.fromRGB(255,255,255),Red=Color3.fromRGB(255,60,60),Orange=Color3.fromRGB(255,150,40),Yellow=Color3.fromRGB(255,230,60),Green=Color3.fromRGB(60,255,90),Cyan=Color3.fromRGB(0,255,255),Blue=Color3.fromRGB(60,110,255),Purple=Color3.fromRGB(170,80,255),Pink=Color3.fromRGB(255,100,200),Black=Color3.fromRGB(0,0,0)};
	local currentSection="";
	local function flagFor(name)return("Vis_"..currentSection.."_"..name):gsub("[^%w_]","")end;
	local function firstOption(value)if type(value)=="table"then return value[1]end;return value end;
	local function nearestColorName(color)
		local bestName,bestDist="White",math.huge;
		if typeof(color)~="Color3"then return bestName end;
		for name,preset in pairs(COLOR_PRESETS)do local d=(preset.R-color.R)^2+(preset.G-color.G)^2+(preset.B-color.B)^2;if d<bestDist then bestName,bestDist=name,d end end;
		return bestName;
	end;
	local function visSection(title)currentSection=title;VisualsTab:Section({Title=title})end;
	local function visToggle(name,tbl,key)VisualsTab:Toggle({Title=name,Flag=flagFor(name),Value=tbl[key]==true,Callback=function(v)tbl[key]=v end})end;
	local function visSlider(name,tbl,key,min,max)
		local span=max-min;local step=span>20 and 1 or(span>3 and 0.1 or 0.05);
		VisualsTab:Slider({Title=name,Flag=flagFor(name),Step=step,Value={Min=min,Max=max,Default=math.clamp(tonumber(tbl[key])or min,min,max)},Callback=function(v)tbl[key]=tonumber(v)end});
	end;
	local function visChoice(name,tbl,key,options)
		local current=tbl[key];if not table.find(options,current)then current=options[1]end;
		VisualsTab:Dropdown({Title=name,Flag=flagFor(name),Values=options,Value=current,Callback=function(v)v=firstOption(v);if v then tbl[key]=v end end});
	end;
	local function visColor(name,tbl,key)
		VisualsTab:Dropdown({Title=name,Flag=flagFor(name),Values=COLOR_NAMES,Value=nearestColorName(tbl[key]),Callback=function(v)local c=COLOR_PRESETS[firstOption(v)];if c then tbl[key]=c end end});
	end;
	visSection("Cursor");
	visToggle("Custom Cursor",V.CURSOR,"Enabled");visChoice("Style",V.CURSOR,"Style",V.CURSOR_STYLES);visToggle("Rainbow",V.CURSOR,"Rainbow");visColor("Color",V.CURSOR,"Color");visSlider("Size",V.CURSOR,"Size",6,48);visSlider("Thickness",V.CURSOR,"Thickness",1,6);visToggle("Outline",V.CURSOR,"Outline");visToggle("Spin",V.CURSOR,"Spin");visSlider("Transparency",V.CURSOR,"Transparency",0,0.9);
	visSection("Tung Tung Sahur");
	visToggle("Tung Tung Sahur Model",V.SAHUR,"Enabled");visSlider("Sahur Size",V.SAHUR,"Size",0.5,2);visSlider("Sahur Rotation",V.SAHUR,"Rotation",0,360);visSlider("Sahur Forward",V.SAHUR,"Forward",-4,4);visSlider("Sahur Side",V.SAHUR,"Side",-4,4);visSlider("Sahur Height",V.SAHUR,"Height",-3,3);
	visSection("I Am Potato");
	visToggle("Potato Model",V.BULBA,"Enabled");visSlider("Potato Size",V.BULBA,"Size",0.5,2);
	visSection("Character Trail");
	visToggle("Trail",V.TRAIL,"Enabled");visChoice("Type",V.TRAIL,"Style",V.TRAIL_STYLES);visToggle("Rainbow",V.TRAIL,"Rainbow");visColor("Color",V.TRAIL,"Color");visToggle("Glow",V.TRAIL,"Glow");visSlider("Glow Strength",V.TRAIL,"GlowStrength",0,5);visSlider("Lifetime",V.TRAIL,"Lifetime",0.2,5);visSlider("Height",V.TRAIL,"Height",0.5,4);visSlider("Transparency",V.TRAIL,"Transparency",0,1);
	visSection("Jump Circle");
	visToggle("Jump Circle",V.JUMP_CIRCLE,"Enabled");visChoice("Style",V.JUMP_CIRCLE,"Style",V.JUMP_CIRCLE_STYLES);visChoice("Trigger",V.JUMP_CIRCLE,"Trigger",V.JUMP_CIRCLE_TRIGGERS);visToggle("Rainbow",V.JUMP_CIRCLE,"Rainbow");visColor("Color",V.JUMP_CIRCLE,"Color");visToggle("Glow",V.JUMP_CIRCLE,"Glow");visSlider("Glow Strength",V.JUMP_CIRCLE,"GlowStrength",0,5);visSlider("Radius",V.JUMP_CIRCLE,"Radius",1,15);visSlider("Duration",V.JUMP_CIRCLE,"Duration",0.2,3);visSlider("Thickness",V.JUMP_CIRCLE,"Thickness",0.05,1);
	visSection("Particles");
	visToggle("Particles",V.PARTICLES,"Enabled");visChoice("Type",V.PARTICLES,"Style",V.PARTICLE_STYLES);visToggle("Rainbow",V.PARTICLES,"Rainbow");visColor("Color",V.PARTICLES,"Color");visToggle("Glow",V.PARTICLES,"Glow");visSlider("Glow Strength",V.PARTICLES,"GlowStrength",0,5);visSlider("Amount",V.PARTICLES,"Rate",5,500);visSlider("Size",V.PARTICLES,"Size",0.1,2);visSlider("Area",V.PARTICLES,"Range",20,200);
	visSection("Constellations");
	visToggle("Constellations",V.CONSTELLATIONS,"Enabled");visSlider("Count",V.CONSTELLATIONS,"Count",1,40);visSlider("Size",V.CONSTELLATIONS,"Size",0.1,2);visSlider("Speed",V.CONSTELLATIONS,"Speed",0,3);visToggle("Rainbow",V.CONSTELLATIONS,"Rainbow");visColor("Color",V.CONSTELLATIONS,"Color");visToggle("Glow",V.CONSTELLATIONS,"Glow");
	visSection("Fog");
	visToggle("Fog",V.FOG,"Enabled");visToggle("Rainbow",V.FOG,"Rainbow");visColor("Color",V.FOG,"Color");visToggle("Glow (Bloom)",V.FOG,"Glow");visSlider("Glow Strength",V.FOG,"GlowStrength",0,5);visSlider("Start",V.FOG,"Start",0,2000);visSlider("End",V.FOG,"End",10,5000);
	visSection("Custom Sky");
	visToggle("Custom Sky",V.SKY,"Enabled");visChoice("Sky",V.SKY,"Preset",V.SKY_PRESET_ORDER);visToggle("Clouds",V.SKY,"Clouds");visToggle("Moving Sun",V.SKY,"MovingSun");visSlider("Sun Speed",V.SKY,"SunSpeed",0.1,60);visToggle("World Haze",V.SKY,"WorldHaze");visChoice("Lighting",V.SKY,"LightingMode",V.SKY_LIGHTING_MODES);visSlider("Clock Time",V.SKY,"ClockTime",0,24);visSlider("Sun Brightness",V.SKY,"Brightness",0,6);visColor("Light Color",V.SKY,"LightColor");visColor("Sun Color",V.SKY,"SunColor");visSlider("Exposure",V.SKY,"Exposure",-3,3);visToggle("Shadows",V.SKY,"Shadows");
	visSection("Shaders");
	visToggle("Shaders",V.SHADERS,"Enabled");visChoice("Style",V.SHADERS,"Preset",V.SHADER_PRESETS);visSlider("Intensity",V.SHADERS,"Intensity",0,1.5);visToggle("Sun Rays",V.SHADERS,"SunRays");visToggle("Depth Of Field",V.SHADERS,"DepthOfField");visToggle("Vignette",V.SHADERS,"Vignette");
	visSection("Auras");
	visToggle("Aura",V.AURA,"Enabled");visChoice("Style",V.AURA,"Style",V.AURA_STYLES);visToggle("Rainbow",V.AURA,"Rainbow");visColor("Color",V.AURA,"Color");visToggle("Glow",V.AURA,"Glow");visSlider("Size",V.AURA,"Size",0.5,2.5);visSlider("Speed",V.AURA,"Speed",0.2,4);
	visSection("Back");
	visToggle("Back Accessory",V.BACK,"Enabled");visChoice("Accessory",V.BACK,"Style",V.BACK_STYLES);visToggle("Rainbow",V.BACK,"Rainbow");visColor("Color",V.BACK,"Color");visToggle("Glow",V.BACK,"Glow");visSlider("Transparency",V.BACK,"Transparency",0,0.9);visSlider("Size",V.BACK,"Size",0.6,2);visToggle("Animation",V.BACK,"Animation");visSlider("Animation Speed",V.BACK,"Speed",0.2,3);
	visSection("Bottom");
	visToggle("Bottom Platform",V.BOTTOM,"Enabled");visChoice("Platform",V.BOTTOM,"Style",V.BOTTOM_STYLES);visChoice("Position",V.BOTTOM,"Mode",V.BOTTOM_MODES);visToggle("Rainbow",V.BOTTOM,"Rainbow");visColor("Color",V.BOTTOM,"Color");visToggle("Glow",V.BOTTOM,"Glow");visSlider("Size",V.BOTTOM,"Size",0.5,3);visSlider("Transparency",V.BOTTOM,"Transparency",0,0.9);visSlider("Walk Delay",V.BOTTOM,"Delay",0,1);visToggle("Tilt",V.BOTTOM,"Tilt");
	-- Self chams.
	visSection("Self Chams");
	getgenv().selfChamsConfig = { Enabled = false, HideBody = true, ThroughWalls = true, Rainbow = false, Pulse = false, PulseSpeed = 3, FlashOnDamage = false, FlashColor = Color3.fromRGB(255, 60, 60), Glow = false, OutlineColor = Color3.fromRGB(255, 120, 255), OutlineTransparency = 0, FillColor = Color3.fromRGB(255, 120, 255), FillTransparency = 1 };
	do
		local SELF = getgenv().selfChamsConfig
		local selfHighlight, selfCharacter, selfLight = nil, nil, nil
		local selfLastHealth, flashUntil = nil, 0
		local selfHidden = {}
		local lastScan = 0

		local function restoreHidden()
			for object, transparency in pairs(selfHidden) do
				if object.Parent then object.Transparency = transparency end
			end
			selfHidden = {}
		end

		local function restoreSelf()
			restoreHidden()
			if selfHighlight then selfHighlight:Destroy() end
			if selfLight then selfLight:Destroy() end
			selfHighlight, selfCharacter, selfLight, selfLastHealth = nil, nil, nil, nil
		end

		local function hideObject(object)
			if selfHidden[object] ~= nil or object:FindFirstAncestorOfClass("Tool") then return end
			if (object:IsA("BasePart") and object.Name ~= "HumanoidRootPart") or object:IsA("Decal") then
				selfHidden[object] = object.Transparency
				object.Transparency = 0.99
			end
		end

		RunService.RenderStepped:Connect(function()
			local character = LocalPlayer.Character
			local humanoid = character and character:FindFirstChildOfClass("Humanoid")
			local conflict = (V.SAHUR and V.SAHUR.Enabled) or (V.BULBA and V.BULBA.Enabled) or (getgenv().verityConfig and getgenv().verityConfig.Enabled)
			if not SELF.Enabled or not humanoid or humanoid.Health <= 0 or conflict then
				restoreSelf()
				return
			end
			if selfCharacter ~= character then
				restoreSelf()
				selfCharacter = character
			end

			if SELF.HideBody then
				if os.clock() - lastScan > 0.5 then
					lastScan = os.clock()
					for _, object in ipairs(character:GetDescendants()) do hideObject(object) end
				end
			elseif next(selfHidden) then
				restoreHidden()
			end

			if not selfHighlight or selfHighlight.Parent ~= character then
				if selfHighlight then selfHighlight:Destroy() end
				selfHighlight = Instance.new("Highlight")
				selfHighlight.Name = "SelfChams_NL"
				selfHighlight.Adornee = character
				selfHighlight.Parent = character
			end
			if selfLastHealth and humanoid.Health < selfLastHealth then flashUntil = os.clock() + 0.35 end
			selfLastHealth = humanoid.Health
			local color = SELF.Rainbow and Color3.fromHSV((os.clock() * 0.2) % 1, 0.6, 1) or SELF.OutlineColor
			local outlineTransparency = SELF.OutlineTransparency
			local fillTransparency = SELF.FillTransparency
			if SELF.Pulse then
				outlineTransparency = outlineTransparency + (1 - outlineTransparency) * (0.5 + 0.5 * math.sin(os.clock() * SELF.PulseSpeed)) * 0.6
			end
			if SELF.FlashOnDamage and os.clock() < flashUntil then
				color, outlineTransparency, fillTransparency = SELF.FlashColor, 0, math.min(fillTransparency, 0.6)
			end
			local rootPart = character:FindFirstChild("HumanoidRootPart")
			if SELF.Glow and rootPart then
				if not selfLight or selfLight.Parent ~= rootPart then
					if selfLight then selfLight:Destroy() end
					selfLight = Instance.new("PointLight")
					selfLight.Name = "SelfGlow_NL"
					selfLight.Range = 12
					selfLight.Brightness = 1.5
					selfLight.Parent = rootPart
				end
				selfLight.Color = color
			elseif selfLight then
				selfLight:Destroy()
				selfLight = nil
			end
			local head = character:FindFirstChild("Head")
			local camera = WorkspaceService.CurrentCamera
			local firstPerson = head and camera and (camera.CFrame.Position - head.Position).Magnitude < 1.5
			selfHighlight.DepthMode = SELF.ThroughWalls and Enum.HighlightDepthMode.AlwaysOnTop or Enum.HighlightDepthMode.Occluded
			selfHighlight.OutlineColor = color
			selfHighlight.FillColor = SELF.Rainbow and color or SELF.FillColor
			selfHighlight.OutlineTransparency = outlineTransparency
			selfHighlight.FillTransparency = fillTransparency
			selfHighlight.Enabled = not firstPerson
		end)
	end
	visToggle("Self Chams", getgenv().selfChamsConfig, "Enabled");visToggle("Invisible Body", getgenv().selfChamsConfig, "HideBody");visToggle("Through Walls", getgenv().selfChamsConfig, "ThroughWalls");visToggle("Self Rainbow", getgenv().selfChamsConfig, "Rainbow");visToggle("Self Pulse", getgenv().selfChamsConfig, "Pulse");visToggle("Damage Flash", getgenv().selfChamsConfig, "FlashOnDamage");visToggle("Glow Light", getgenv().selfChamsConfig, "Glow");visSlider("Pulse Speed", getgenv().selfChamsConfig, "PulseSpeed", 0.5, 8);
	visSlider("Outline Transparency", getgenv().selfChamsConfig, "OutlineTransparency", 0, 1);visSlider("Fill Transparency", getgenv().selfChamsConfig, "FillTransparency", 0, 1);
	VisualsTab:Colorpicker({Title="Outline Color",Default=Color3.fromRGB(255,120,255),Callback=function(c)getgenv().selfChamsConfig.OutlineColor=c end});
	VisualsTab:Colorpicker({Title="Fill Color",Default=Color3.fromRGB(255,120,255),Callback=function(c)getgenv().selfChamsConfig.FillColor=c end});
	VisualsTab:Colorpicker({Title="Damage Flash Color",Default=Color3.fromRGB(255,60,60),Callback=function(c)getgenv().selfChamsConfig.FlashColor=c end});

	-- Avatar changer (client-side, built by hand because ApplyDescription is server-only).
	visSection("Avatar Changer");
	getgenv().avatarConfig = { Korblox = false, Headless = false, Target = "", KeepOnRespawn = true };
	do
		local AVATAR = getgenv().avatarConfig
		local busy = false
		local extrasBackup = { head = nil, legs = {} }

		local KORBLOX_R15 = {
			RightUpperLeg = "rbxassetid://902942096",
			RightLowerLeg = "rbxassetid://902942093",
			RightFoot = "rbxassetid://902942089",
		}
		local KORBLOX_TEXTURE = "rbxassetid://902843398"

		local function notify(text)
			pcall(function() UiManager:Notify({ Title = "Avatar Changer", Content = text, Duration = 4 }) end)
		end

		local function resolveUserId(text)
			text = (text or ""):gsub("%s", "")
			if text == "" then return nil end
			local id = tonumber(text)
			if id then return id end
			local ok, result = pcall(PlayerService.GetUserIdFromNameAsync, PlayerService, text)
			return ok and result or nil
		end

		local function loadAsset(id)
			if not id or id == 0 then return nil end
			local ok, objects = pcall(function() return game:GetObjects("rbxassetid://" .. id) end)
			if ok and objects then return objects[1] end
			return nil
		end

		-- Put the look from a HumanoidDescription onto the local character.
		local function applyLook(character, humanoid, description)
			for _, child in ipairs(character:GetChildren()) do
				if child:IsA("Accessory") or child:IsA("Shirt") or child:IsA("Pants") or child:IsA("ShirtGraphic") then
					child:Destroy()
				end
			end

			local colors = character:FindFirstChildOfClass("BodyColors")
			if not colors then
				colors = Instance.new("BodyColors")
				colors.Parent = character
			end
			colors.HeadColor3 = description.HeadColor
			colors.TorsoColor3 = description.TorsoColor
			colors.LeftArmColor3 = description.LeftArmColor
			colors.RightArmColor3 = description.RightArmColor
			colors.LeftLegColor3 = description.LeftLegColor
			colors.RightLegColor3 = description.RightLegColor

			for _, assetId in ipairs({ description.Shirt, description.Pants, description.GraphicTShirt }) do
				local clothing = loadAsset(assetId)
				if clothing and (clothing:IsA("Shirt") or clothing:IsA("Pants") or clothing:IsA("ShirtGraphic")) then
					clothing.Parent = character
				end
			end

			local head = character:FindFirstChild("Head")
			local faceDecal = head and head:FindFirstChildOfClass("Decal")
			local face = loadAsset(description.Face)
			if faceDecal and face and face:IsA("Decal") then faceDecal.Texture = face.Texture end

			for _, info in ipairs(description:GetAccessories(true)) do
				local accessory = loadAsset(info.AssetId)
				if accessory and not accessory:IsA("Accessory") then accessory = accessory:FindFirstChildOfClass("Accessory") end
				if accessory then pcall(humanoid.AddAccessory, humanoid, accessory) end
			end
		end

		-- Korblox leg and headless head, layered on whatever look is active.
		local function refreshExtras(character)
			local head = character:FindFirstChild("Head")
			if extrasBackup.head and head then
				head.Transparency = extrasBackup.head.transparency
				for decal, transparency in pairs(extrasBackup.head.decals) do
					if decal.Parent then decal.Transparency = transparency end
				end
			end
			extrasBackup.head = nil
			for part, saved in pairs(extrasBackup.legs) do
				if part.Parent then
					pcall(function()
						if part:IsA("MeshPart") then
							part.MeshId, part.TextureID = saved.mesh, saved.texture
						else
							saved.object.MeshId, saved.object.TextureId = saved.mesh, saved.texture
						end
					end)
				end
			end
			extrasBackup.legs = {}

			if AVATAR.Headless and head then
				extrasBackup.head = { transparency = head.Transparency, decals = {} }
				head.Transparency = 1
				for _, decal in ipairs(head:GetChildren()) do
					if decal:IsA("Decal") then
						extrasBackup.head.decals[decal] = decal.Transparency
						decal.Transparency = 1
					end
				end
			end
			if AVATAR.Korblox then
				for name, meshId in pairs(KORBLOX_R15) do
					local part = character:FindFirstChild(name)
					if part and part:IsA("MeshPart") then
						extrasBackup.legs[part] = { mesh = part.MeshId, texture = part.TextureID }
						pcall(function()
							part.MeshId = meshId
							part.TextureID = KORBLOX_TEXTURE
						end)
					end
				end
				local leg = character:FindFirstChild("Right Leg")
				local mesh = leg and leg:FindFirstChildOfClass("SpecialMesh")
				if mesh then
					extrasBackup.legs[leg] = { object = mesh, mesh = mesh.MeshId, texture = mesh.TextureId }
					pcall(function()
						mesh.MeshId = "rbxassetid://101851696"
						mesh.TextureId = "rbxassetid://101851254"
					end)
				end
			end
		end

		local function run(useOwnLook, loadTarget)
			if busy then return end
			local character = LocalPlayer.Character
			local humanoid = character and character:FindFirstChildOfClass("Humanoid")
			if not humanoid then return end
			busy = true
			task.spawn(function()
				local ok, err = pcall(function()
					if loadTarget then
						local userId = useOwnLook and LocalPlayer.UserId or resolveUserId(AVATAR.Target)
						if not userId then error("Player not found") end
						local description = PlayerService:GetHumanoidDescriptionFromUserId(userId)
						applyLook(character, humanoid, description)
					end
					refreshExtras(character)
				end)
				if not ok then
					warn("[Avatar] " .. tostring(err))
					notify(tostring(err))
				end
				busy = false
			end)
		end

		LocalPlayer.CharacterAdded:Connect(function(character)
			extrasBackup = { head = nil, legs = {} }
			if not AVATAR.KeepOnRespawn then return end
			if AVATAR.Target == "" and not AVATAR.Korblox and not AVATAR.Headless then return end
			character:WaitForChild("Humanoid", 10)
			task.wait(1.5)
			run(false, AVATAR.Target ~= "")
		end)

		-- Small window with a text box for the username / UserId.
		local guiParent = (gethui and gethui()) or LocalPlayer:WaitForChild("PlayerGui")
		local oldGui = guiParent:FindFirstChild("AvatarChanger_NL")
		if oldGui then oldGui:Destroy() end
		local gui = Instance.new("ScreenGui")
		gui.Name = "AvatarChanger_NL"
		gui.ResetOnSpawn = false
		gui.DisplayOrder = 60
		gui.Enabled = false
		gui.Parent = guiParent

		local frame = Instance.new("Frame")
		frame.Size = UDim2.new(0, 300, 0, 150)
		frame.AnchorPoint = Vector2.new(0.5, 0)
		frame.Position = UDim2.new(0.5, 0, 0.2, 0)
		frame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
		frame.Active = true
		frame.Draggable = true
		frame.Parent = gui
		local frameCorner = Instance.new("UICorner")
		frameCorner.CornerRadius = UDim.new(0, 10)
		frameCorner.Parent = frame
		local frameStroke = Instance.new("UIStroke")
		frameStroke.Color = Color3.fromRGB(60, 60, 80)
		frameStroke.Parent = frame

		local function makeLabel(text, y, size, color)
			local label = Instance.new("TextLabel")
			label.BackgroundTransparency = 1
			label.Position = UDim2.new(0, 12, 0, y)
			label.Size = UDim2.new(1, -24, 0, 20)
			label.Font = Enum.Font.GothamMedium
			label.TextSize = size
			label.TextColor3 = color
			label.TextXAlignment = Enum.TextXAlignment.Left
			label.Text = text
			label.Parent = frame
		end
		makeLabel("Avatar Changer", 8, 15, Color3.new(1, 1, 1))
		makeLabel("Korblox / Headless: toggles in the menu", 124, 11, Color3.fromRGB(150, 150, 165))

		local textBox = Instance.new("TextBox")
		textBox.Position = UDim2.new(0, 12, 0, 36)
		textBox.Size = UDim2.new(1, -24, 0, 34)
		textBox.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
		textBox.Font = Enum.Font.Gotham
		textBox.TextSize = 14
		textBox.TextColor3 = Color3.new(1, 1, 1)
		textBox.PlaceholderText = "Username or UserId"
		textBox.PlaceholderColor3 = Color3.fromRGB(130, 130, 145)
		textBox.ClearTextOnFocus = false
		textBox.Text = ""
		textBox.Parent = frame
		local boxCorner = Instance.new("UICorner")
		boxCorner.CornerRadius = UDim.new(0, 6)
		boxCorner.Parent = textBox

		local function makeButton(text, x, width, color, callback)
			local button = Instance.new("TextButton")
			button.Position = UDim2.new(0, x, 0, 80)
			button.Size = UDim2.new(0, width, 0, 34)
			button.BackgroundColor3 = color
			button.Font = Enum.Font.GothamMedium
			button.TextSize = 14
			button.TextColor3 = Color3.new(1, 1, 1)
			button.Text = text
			button.Parent = frame
			local corner = Instance.new("UICorner")
			corner.CornerRadius = UDim.new(0, 6)
			corner.Parent = button
			button.MouseButton1Click:Connect(callback)
		end
		makeButton("Apply", 12, 130, Color3.fromRGB(70, 110, 255), function()
			AVATAR.Target = textBox.Text
			run(false, true)
		end)
		makeButton("Reset", 148, 78, Color3.fromRGB(70, 70, 90), function()
			AVATAR.Target = ""
			textBox.Text = ""
			run(true, true)
		end)
		makeButton("Close", 232, 56, Color3.fromRGB(150, 50, 70), function() gui.Enabled = false end)

		VisualsTab:Button({Title="Open Avatar Changer",Callback=function()gui.Enabled=not gui.Enabled end});
		VisualsTab:Toggle({Title="Korblox",Value=false,Callback=function(v)AVATAR.Korblox=v;run(false,false)end});
		VisualsTab:Toggle({Title="Headless",Value=false,Callback=function(v)AVATAR.Headless=v;run(false,false)end});
		VisualsTab:Toggle({Title="Keep On Respawn",Value=true,Callback=function(v)AVATAR.KeepOnRespawn=v end});
	end

	-- Verity model.
	visSection("Verity");
	getgenv().verityConfig = { Enabled = false, Size = 1, Height = 0.8, Glow = true, Color = Color3.fromRGB(255, 221, 0) };
	do
		local VERITY = getgenv().verityConfig
		local oldFolder = WorkspaceService:FindFirstChild("Verity_Local")
		if oldFolder then oldFolder:Destroy() end
		local verityFolder = Instance.new("Folder")
		verityFolder.Name = "Verity_Local"
		verityFolder.Parent = WorkspaceService
		local verityState = nil

		local function restoreVerity()
			if not verityState then return end
			if verityState.connection then verityState.connection:Disconnect() end
			for object, transparency in pairs(verityState.hidden) do
				if object.Parent then object.Transparency = transparency end
			end
			for _, part in ipairs(verityState.parts) do part:Destroy() end
			verityState = nil
		end

		local function hideVerityObject(object)
			if verityState.hidden[object] ~= nil or object:FindFirstAncestorOfClass("Tool") then return end
			if (object:IsA("BasePart") and object.Name ~= "HumanoidRootPart") or object:IsA("Decal") then
				verityState.hidden[object] = object.Transparency
				object.Transparency = 1
			end
		end

		local function buildVerity(character, root, humanoid)
			restoreVerity()
			local size = VERITY.Size
			local radius = 2 * size
			verityState = { character = character, parts = {}, hidden = {}, size = size, visible = {} }
			for _, object in ipairs(character:GetDescendants()) do hideVerityObject(object) end
			verityState.connection = character.DescendantAdded:Connect(function(object)
				if verityState and verityState.character == character then hideVerityObject(object) end
			end)

			local feet = humanoid.RigType == Enum.HumanoidRigType.R6 and -3 or -(humanoid.HipHeight + root.Size.Y / 2)
			verityState.feet = feet
			local base = CFrame.new(0, feet + radius + VERITY.Height * size, 0)

			local body = Instance.new("Part")
			body.Shape = Enum.PartType.Ball
			body.Size = Vector3.new(radius * 2, radius * 2, radius * 2)
			body.Material = Enum.Material.Neon
			body.Color = VERITY.Color
			body.CanCollide, body.CanQuery, body.CanTouch, body.Massless = false, false, false, true
			body.CFrame = root.CFrame * base
			body.Parent = verityFolder
			table.insert(verityState.parts, body)
			table.insert(verityState.visible, body)
			local motor = Instance.new("Motor6D")
			motor.Part0 = root
			motor.Part1 = body
			motor.C0 = base
			motor.Parent = body
			verityState.motor, verityState.body = motor, body

			local light = Instance.new("PointLight")
			light.Color = VERITY.Color
			light.Range = 16 * size
			light.Brightness = 2
			light.Parent = body
			verityState.light = light

			-- Face parts sit on the sphere surface, facing the character's front (-Z).
			local function addFace(width, height, thickness, x, y)
				local dir = Vector3.new(x, y, -math.sqrt(math.max(1 - x * x - y * y, 0.01)))
				local pos = dir * radius * 0.97
				local part = Instance.new("Part")
				part.Size = Vector3.new(width * radius, height * radius, thickness * radius)
				part.Color = Color3.fromRGB(15, 15, 15)
				part.Material = Enum.Material.SmoothPlastic
				part.CanCollide, part.CanQuery, part.CanTouch, part.Massless = false, false, false, true
				part.CFrame = body.CFrame * CFrame.lookAt(pos, pos + dir)
				local mesh = Instance.new("SpecialMesh")
				mesh.MeshType = Enum.MeshType.Sphere
				mesh.Parent = part
				part.Parent = verityFolder
				local weld = Instance.new("WeldConstraint")
				weld.Part0, weld.Part1 = body, part
				weld.Parent = part
				table.insert(verityState.parts, part)
				table.insert(verityState.visible, part)
			end
			addFace(0.2, 0.4, 0.14, -0.3, 0.2)
			addFace(0.2, 0.4, 0.14, 0.3, 0.2)
			for i = 0, 12 do
				local t = (i / 12) * 2 - 1
				local dot = 0.12 * (1 - 0.25 * t * t)
				addFace(dot, dot, 0.1, 0.42 * t, -0.52 + 0.22 * t * t)
			end
		end

		RunService.RenderStepped:Connect(function()
			local character = LocalPlayer.Character
			local root = character and character:FindFirstChild("HumanoidRootPart")
			local humanoid = character and character:FindFirstChildOfClass("Humanoid")
			local otherModel = (V.SAHUR and V.SAHUR.Enabled) or (V.BULBA and V.BULBA.Enabled)
			if not VERITY.Enabled or not root or not humanoid or humanoid.Health <= 0 or otherModel then
				restoreVerity()
				return
			end
			if not verityState or verityState.character ~= character or verityState.size ~= VERITY.Size or not verityState.motor.Parent then
				buildVerity(character, root, humanoid)
			end

			local now = os.clock()
			local velocity = root.AssemblyLinearVelocity
			local moving = math.clamp(Vector3.new(velocity.X, 0, velocity.Z).Magnitude / 16, 0, 1)
			local size = verityState.size
			local bob = math.sin(now * 2.2) * 0.18 * size
			local base = CFrame.new(0, verityState.feet + 2 * size + VERITY.Height * size + bob, 0)
			verityState.motor.C0 = base * CFrame.Angles(-moving * 0.12, 0, math.sin(now * 1.4) * 0.05)
			verityState.body.Color = VERITY.Color
			verityState.body.Material = VERITY.Glow and Enum.Material.Neon or Enum.Material.SmoothPlastic
			verityState.light.Color = VERITY.Color
			verityState.light.Enabled = VERITY.Glow
			verityState.light.Brightness = 2 + math.sin(now * 3) * 0.4

			local camera = WorkspaceService.CurrentCamera
			local firstPerson = camera and (camera.CFrame.Position - verityState.body.Position).Magnitude < 2 * size + 0.8
			for _, part in ipairs(verityState.visible) do
				part.LocalTransparencyModifier = firstPerson and 1 or 0
			end
		end)
	end
	visToggle("Verity Model", getgenv().verityConfig, "Enabled");visSlider("Verity Size", getgenv().verityConfig, "Size", 0.5, 2.5);visSlider("Verity Float", getgenv().verityConfig, "Height", 0, 3);visToggle("Verity Glow", getgenv().verityConfig, "Glow");
	VisualsTab:Colorpicker({Title="Verity Color",Default=Color3.fromRGB(255,221,0),Callback=function(c)getgenv().verityConfig.Color=c end});

	-- World color.
	visSection("World Color");
	getgenv().worldColorConfig = {
		Enabled = false, Preset = "Cyberpunk", Intensity = 0.8, Saturation = 0, Contrast = 0, Brightness = 0,
		Glow = true, GlowStrength = 0.5, Rainbow = false, RainbowSpeed = 0.1, TintAtmosphere = true,
		Ambient = Color3.fromRGB(120, 70, 200), Top = Color3.fromRGB(255, 60, 200), Bottom = Color3.fromRGB(0, 200, 255), Tint = Color3.fromRGB(255, 225, 255),
	}
	local function preset(ambient, top, bottom, tint, saturation, contrast, brightness)
		return { Ambient = ambient, Top = top, Bottom = bottom, Tint = tint, Saturation = saturation, Contrast = contrast, Brightness = brightness }
	end
	local rgb = Color3.fromRGB
	local WORLD_PRESETS = {
		Cyberpunk = preset(rgb(110, 60, 190), rgb(255, 60, 190), rgb(0, 190, 255), rgb(255, 215, 255), 0.3, 0.12, 0),
		Sunset = preset(rgb(255, 140, 90), rgb(255, 120, 60), rgb(255, 60, 120), rgb(255, 225, 200), 0.25, 0.1, 0.02),
		Toxic = preset(rgb(80, 255, 120), rgb(140, 255, 60), rgb(0, 200, 120), rgb(225, 255, 225), 0.3, 0.12, 0),
		Crimson = preset(rgb(200, 30, 50), rgb(255, 40, 60), rgb(120, 0, 30), rgb(255, 205, 205), 0.2, 0.18, -0.03),
		Ocean = preset(rgb(40, 140, 220), rgb(60, 200, 255), rgb(0, 90, 200), rgb(205, 235, 255), 0.2, 0.08, 0),
		Candy = preset(rgb(255, 150, 220), rgb(255, 170, 230), rgb(170, 150, 255), rgb(255, 225, 245), 0.35, 0.05, 0.04),
		Frost = preset(rgb(170, 215, 255), rgb(200, 235, 255), rgb(140, 190, 255), rgb(225, 240, 255), -0.1, 0.1, 0.05),
		Midnight = preset(rgb(25, 35, 90), rgb(40, 60, 160), rgb(10, 10, 60), rgb(180, 195, 255), 0.1, 0.2, -0.08),
		Golden = preset(rgb(255, 200, 90), rgb(255, 210, 100), rgb(255, 150, 50), rgb(255, 240, 210), 0.2, 0.1, 0.03),
		Monochrome = preset(rgb(150, 150, 150), rgb(60, 60, 60), rgb(30, 30, 30), rgb(255, 255, 255), -1, 0.25, 0),
	}
	local WORLD_PRESET_ORDER = { "Custom", "Cyberpunk", "Sunset", "Toxic", "Crimson", "Ocean", "Candy", "Frost", "Midnight", "Golden", "Monochrome" }
	local worldOriginal, worldCurrent, worldCorrection, worldBloom = nil, nil, nil, nil

	local function restoreWorld()
		if worldOriginal then
			Lighting.Ambient = worldOriginal.Ambient
			Lighting.OutdoorAmbient = worldOriginal.OutdoorAmbient
			Lighting.ColorShift_Top = worldOriginal.ColorShift_Top
			Lighting.ColorShift_Bottom = worldOriginal.ColorShift_Bottom
			local atmosphere = worldOriginal.atmosphere
			if atmosphere and atmosphere.Parent then
				atmosphere.Color = worldOriginal.atmosphereColor
				atmosphere.Decay = worldOriginal.atmosphereDecay
			end
		end
		if worldCorrection then worldCorrection:Destroy() end
		if worldBloom then worldBloom:Destroy() end
		worldOriginal, worldCurrent, worldCorrection, worldBloom = nil, nil, nil, nil
	end

	local function snapshotWorld()
		local atmosphere = Lighting:FindFirstChildOfClass("Atmosphere")
		worldOriginal = {
			Ambient = Lighting.Ambient, OutdoorAmbient = Lighting.OutdoorAmbient,
			ColorShift_Top = Lighting.ColorShift_Top, ColorShift_Bottom = Lighting.ColorShift_Bottom,
			atmosphere = atmosphere, atmosphereColor = atmosphere and atmosphere.Color, atmosphereDecay = atmosphere and atmosphere.Decay,
		}
		worldCurrent = {
			Ambient = Lighting.Ambient, Top = Lighting.ColorShift_Top, Bottom = Lighting.ColorShift_Bottom,
			Tint = Color3.new(1, 1, 1), Saturation = 0, Contrast = 0, Brightness = 0,
		}
		worldCorrection = Instance.new("ColorCorrectionEffect")
		worldCorrection.Name = "WC_NL"
		worldCorrection.Parent = Lighting
		worldBloom = Instance.new("BloomEffect")
		worldBloom.Name = "WC_Bloom_NL"
		worldBloom.Size = 28
		worldBloom.Threshold = 0.95
		worldBloom.Intensity = 0
		worldBloom.Parent = Lighting
	end

	RunService.RenderStepped:Connect(function(dt)
		local cfg = getgenv().worldColorConfig
		if not cfg.Enabled then
			if worldOriginal then restoreWorld() end
			return
		end
		if not worldOriginal or not worldCorrection or not worldCorrection.Parent then
			restoreWorld()
			snapshotWorld()
		end

		local target
		if cfg.Rainbow then
			local hue = (os.clock() * cfg.RainbowSpeed) % 1
			target = preset(Color3.fromHSV(hue, 0.55, 0.85), Color3.fromHSV(hue, 0.7, 1), Color3.fromHSV((hue + 0.45) % 1, 0.7, 1), Color3.fromHSV(hue, 0.22, 1), 0.25, 0.1, 0)
		elseif cfg.Preset ~= "Custom" and WORLD_PRESETS[cfg.Preset] then
			target = WORLD_PRESETS[cfg.Preset]
		else
			target = preset(cfg.Ambient, cfg.Top, cfg.Bottom, cfg.Tint, 0.15, 0.08, 0)
		end

		local k = cfg.Intensity
		local alpha = 1 - math.exp(-dt * 5)
		local cur = worldCurrent
		cur.Ambient = cur.Ambient:Lerp(worldOriginal.Ambient:Lerp(target.Ambient, k), alpha)
		cur.Top = cur.Top:Lerp(worldOriginal.ColorShift_Top:Lerp(target.Top, k), alpha)
		cur.Bottom = cur.Bottom:Lerp(worldOriginal.ColorShift_Bottom:Lerp(target.Bottom, k), alpha)
		cur.Tint = cur.Tint:Lerp(Color3.new(1, 1, 1):Lerp(target.Tint, k), alpha)
		cur.Saturation = cur.Saturation + (target.Saturation * k + cfg.Saturation - cur.Saturation) * alpha
		cur.Contrast = cur.Contrast + (target.Contrast * k + cfg.Contrast - cur.Contrast) * alpha
		cur.Brightness = cur.Brightness + (target.Brightness * k + cfg.Brightness - cur.Brightness) * alpha

		Lighting.Ambient = cur.Ambient
		Lighting.OutdoorAmbient = worldOriginal.OutdoorAmbient:Lerp(cur.Ambient, 0.9)
		Lighting.ColorShift_Top = cur.Top
		Lighting.ColorShift_Bottom = cur.Bottom
		worldCorrection.TintColor = cur.Tint
		worldCorrection.Saturation = math.clamp(cur.Saturation, -1, 1)
		worldCorrection.Contrast = math.clamp(cur.Contrast, -1, 1)
		worldCorrection.Brightness = math.clamp(cur.Brightness, -1, 1)
		worldBloom.Enabled = cfg.Glow
		worldBloom.Intensity = cfg.GlowStrength * k

		local atmosphere = worldOriginal.atmosphere
		if cfg.TintAtmosphere and atmosphere and atmosphere.Parent then
			atmosphere.Color = worldOriginal.atmosphereColor:Lerp(cur.Top, 0.5 * k)
			atmosphere.Decay = worldOriginal.atmosphereDecay:Lerp(cur.Bottom, 0.5 * k)
		end
	end)

	visToggle("World Color", getgenv().worldColorConfig, "Enabled");visChoice("World Preset", getgenv().worldColorConfig, "Preset", WORLD_PRESET_ORDER);visSlider("World Intensity", getgenv().worldColorConfig, "Intensity", 0, 1);
	visSlider("World Saturation", getgenv().worldColorConfig, "Saturation", -1, 1);visSlider("World Contrast", getgenv().worldColorConfig, "Contrast", -0.5, 0.5);visSlider("World Brightness", getgenv().worldColorConfig, "Brightness", -0.3, 0.3);
	visToggle("World Glow", getgenv().worldColorConfig, "Glow");visSlider("World Glow Strength", getgenv().worldColorConfig, "GlowStrength", 0, 2);visToggle("World Atmosphere Tint", getgenv().worldColorConfig, "TintAtmosphere");
	visToggle("World Rainbow", getgenv().worldColorConfig, "Rainbow");visSlider("World Rainbow Speed", getgenv().worldColorConfig, "RainbowSpeed", 0.02, 1);
	VisualsTab:Colorpicker({Title="Custom Ambient",Default=Color3.fromRGB(120,70,200),Callback=function(c)getgenv().worldColorConfig.Ambient=c end});
	VisualsTab:Colorpicker({Title="Custom Sky Top",Default=Color3.fromRGB(255,60,200),Callback=function(c)getgenv().worldColorConfig.Top=c end});
	VisualsTab:Colorpicker({Title="Custom Sky Bottom",Default=Color3.fromRGB(0,200,255),Callback=function(c)getgenv().worldColorConfig.Bottom=c end});
	VisualsTab:Colorpicker({Title="Custom Tint",Default=Color3.fromRGB(255,225,255),Callback=function(c)getgenv().worldColorConfig.Tint=c end});
	end;
end;

local ConfigTab=MainWindow:Tab({Title="Config",Icon="paperclip"});
ConfigTab:Section({Title="Config",Icon="paperclip"});ConfigTab.Raw:CreateConfigManager({Name="Configs"});
local UiSettingsTab=MainWindow:Tab({Title="UI Settings",Icon="settings"});UiSettingsTab:Section({Title="UI Settings",Icon="settings"});UiSettingsTab.Raw:CreateThemePicker({Flag="Theme"});UiSettingsTab.Raw:CreateKeybind({Name="Toggle UI Keybind",CurrentKeybind="G",OnChanged=function(key)Window:SetKeybind(key)end});

LocalPlayer.CharacterAdded:Connect(SetupAnimator);if LocalPlayer.Character then SetupAnimator()end;Window:LoadConfig();
