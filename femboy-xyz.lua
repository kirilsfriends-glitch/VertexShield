local m = {
    [59] = table.pack,
    rH = function(self, dest, offset, ...)
        local h = table.pack(...)
        table.move(h, 1, h.n, offset + 1, dest)
    end,
    qH = function(self, dest, offset, pack)
        for h = 1, pack.n, 1 do
            dest[offset + h] = pack[h]
        end
        dest.n = offset + pack.n
    end
};

local D={cache={}};
D.load=function(j)if not(D.cache[j])then
    local h,b=D.cache,{};
    b.c,h[j]=D[j](),b;
end;
return D.cache[j].c;
end;
D.a=function()local j=getgenv();
local h=rawget(j,"\0sh");
local b;
if type(h)~="table"then h={fields={},detours={}};
rawset(j,"\0sh",h);
b=h;
else
    b=h;
end;
local j=cloneref and cloneref(game:GetService("RunService"))or game:GetService("RunService");
local h=hookfunction or replaceclosure;
local K,S,o=restorefunction or restorefunc,isreadonly,setreadonly;
local function t(G)if type(o)~="function"then return false;
elseif  type(S)~="function"then return false;
end;
local i,Y=pcall(S,G);
if i then
    if not(Y)then
        return false;
    end;
else
    return false;
end;
return pcall(o,G,false);
end;
local function S(G,i)if i then
    pcall(o,G,true);
end;
end;
local function o(G,i,Y)local O,T=t(G),pcall(function()G[i]=Y;
end);
S(G,O);
return T;
end;
local S,t,G,i,Y,O={},{},{},{},{},true;
local T,x={shared=b,takeover=function()local p=b.unload;
b.unload=nil;
if type(p)=="function"then pcall(p);
end;
end,publish=function(p)b.unload=p;
end,adopt=function(p)if p then
    S[#S+1]=p;
end;
return p;
end,connect=function(p,A)local M=p:Connect(A);
S[#S+1]=M;
return M;
end,bind=function(p,A)local M="\0"..tostring(math.random(10000000,90000000));
j:BindToRenderStep(M,p,A);
t[#t+1]=M;
return M;
end,own=function(p)G[#G+1]=p;
return p;
end,spawn=function(p,...)local A=task.spawn(p,...);
i[#i+1]=A;
return A;
end,teardown=function(p)Y[#Y+1]=p;
return p;
end,field=function(p,A,M)local a,B=b.fields[p];
if a then
    B=a;
else
    a={};
    b.fields[p]=a;
    B=a;
end;
local a,N=B[A];
if a==nil then
    a=p[A];
    if a==nil then
        return nil;
    end;
    B[A]=a;
    N=a;
else
    N=a;
end;
local a=M(N);
if type(a)~="function"then return N;
end;
if not(o(p,A,a))then
    B[A]=nil;
    return N;
end;
Y[#Y+1]=function()if p[A]==a then
    o(p,A,N);
end;
B[A]=nil;
end;
return N;
end,detour=function(o,p)if type(h)~="function"then return nil;
elseif  type(o)~="function"then return nil;
end;
local A=b.detours[o];
if A then
    return A;
end;
local A,M=pcall(h,o,p);
if A then
    if type(M)~="function"then return nil;
end;
else
    return nil;
end;
b.detours[o]=M;
Y[#Y+1]=function()if type(K)~="function"then pcall(h,o,M);
elseif  not(pcall(K,o))then
    pcall(h,o,M);
end;
b.detours[o]=nil;
end;
return M;
end
},getupvalues or debug and debug.getupvalues;
local h=setupvalue or debug and debug.setupvalue;
T.upvalue=function(K,o,p)if type(x)~="function"then return false;
elseif  type(h)~="function"then return false;
end;
local A,M=pcall(x,K);
if A then
    if type(M)~="table"then return false;
end;
else
    return false;
end;
local A=M[o];
if not(pcall(h,K,o,p))then
    return false;
end;
Y[#Y+1]=function()local M,a=pcall(x,K);
if M then
    if type(a)=="table"then if a[o]==p then
        pcall(h,K,o,A);
    end;
end;
end;
end;
return true;
end;
T.alive=function()local h=O;
return h;
end;
T.release=function()if not(O)then
    return;
end;
O=false;
for h=#Y,1,-1 do
    pcall(Y[h]);
    Y[h]=nil;
end;
for h=#t,1,-1 do
    pcall(j.UnbindFromRenderStep,j,t[h]);
    t[h]=nil;
end;
for j=#S,1,-1 do
    local h=S[j];
    S[j]=nil;
    if typeof(h)=="RBXScriptConnection"then pcall(h.Disconnect,h);
elseif  type(h)=="function"then pcall(h);
elseif  type(h)=="table"then if type(h.Disconnect)=="function"then pcall(h.Disconnect,h);
end;
end;
end;
for j=#i,1,-1 do
    pcall(task.cancel,i[j]);
    i[j]=nil;
end;
for j=#G,1,-1 do
    local h=G[j];
    G[j]=nil;
    pcall(h.Destroy,h);
end;
b.unload=nil;
end;
return T;
end;
D.b=function()local j=cloneref or function(h)return h;
end;
local h,b=getgenv(),{};
b.players=game:GetService("Players");
b.run=j(game:GetService("RunService"));
b.input=j(game:GetService("UserInputService"));
b.storage=j(game:GetService("ReplicatedStorage"));
b.lighting=j(game:GetService("Lighting"));
b.workspace=j(game:GetService("Workspace"));
b.collection=j(game:GetService("CollectionService"));
b.guiservice=j(game:GetService("GuiService"));
b.http=j(game:GetService("HttpService"));
b.stats=j(game:GetService("Stats"));
b.tween=j(game:GetService("TweenService"));
b.sounds=j(game:GetService("SoundService"));
b.content=j(game:GetService("ContentProvider"));
b.assets=j(game:GetService("AssetService"));
b.debris=j(game:GetService("Debris"));
b.keyframes=j(game:GetService("KeyframeSequenceProvider"));
b.clips=j(game:GetService("AnimationClipProvider"));
b.lp=b.players.LocalPlayer;
b.hook=hookfunction or replaceclosure;
b.newc=newcclosure or function(K)return K;
end;
b.getups=getupvalues or debug and debug.getupvalues;
b.setup=setupvalue or debug and debug.setupvalue;
b.info=debug and(debug.info or debug.getinfo);
b.custom_asset=getcustomasset;
local K=getthreadidentity or getidentity;
local S=setthreadidentity or setidentity;
b.identity=(function()if type(K)~="function"then return nil;
end;
local o,t=pcall(K);
if o then
    if type(t)=="number"then return t;
end;
end;
return nil;
end)();
b.reclaim=function()if type(S)=="function"then if b.identity then
    pcall(S,b.identity);
end;
end;
end;
b.elevate=function(o,t,G,i,Y)if type(S)~="function"then return pcall(o,t,G,i,Y);
end;
local O;
if type(K)=="function"then local T,x=pcall(K);
O=if T then
    if type(x)=="number"then x
else
    O
else
    O;
else
end;
pcall(S,b.identity or 8);
task.spawn(pcall,o,t,G,i,Y);
if O then
    pcall(S,O);
end;
end;
b.plain=function(o,...)if type(S)~="function"then return pcall(o,...);
end;
local t=b.identity;
if type(K)=="function"then local G,i=pcall(K);
t=if G then
    if type(i)=="number"then i
else
    t
else
    t;
else
end;
pcall(S,2);
local K=table.pack(pcall(o,...));
if t then
    pcall(S,t);
end;
return table.unpack(K,1,K.n);
end;
b.host=(function()if type(gethui)=="function"then local K,S=pcall(gethui);
if K then
    if typeof(S)=="Instance"then return j(S);
end;
end;
end;
local K,S=pcall(game.GetService,game,"CoreGui");
if K then
    if typeof(S)=="Instance"then return j(S);
end;
end;
return b.lp:FindFirstChildOfClass("PlayerGui");
end)();
b.screen=function(j)local K=Instance.new("ScreenGui");
K.IgnoreGuiInset=true;
K.ResetOnSpawn=false;
K.ZIndexBehavior=Enum.ZIndexBehavior.Sibling;
K.DisplayOrder=j or 0;
j=pcall(function()K.Parent=b.host;
end);
if j then
else
    local S=b.lp:FindFirstChildOfClass("PlayerGui");
    j=S~=nil and pcall(function()K.Parent=S;
end);
end;
if j then
    if not(K.Parent)then
        K:Destroy();
        return nil;
    end;
else
    K:Destroy();
    return nil;
end;
return K;
end;
b.weak=function()return setmetatable({},{__mode="k"});
end;
b.module=function(j,...)local K=j or b.storage;
for j=1,select("#",...),1 do
    K=K:FindFirstChild((select(j,...)));
    if not(K)then
        return nil;
    end;
end;
if not(K:IsA("ModuleScript"))then
    return nil;
end;
local j,S=pcall(require,K);
if j then
    return S;
end;
return nil;
end;
b.drawmask=function()local j=rawget(h,"shitaro_drawmask");
if type(j)=="table"then return j;
end;
return nil;
end;
return b;
end;
D.c=function()local j=bit32.band;
local h=bit32.bxor;
local b=bit32.bnot;
local K=bit32.rrotate;
local S=bit32.rshift;
local o=string.char;
local t=string.byte;
local G=string.rep;
local i=string.sub;
local Y=string.gsub;
local O=string.format;
local T=table.concat;
local x=table.create;
local p=math.floor;
local A,M=request or syn and syn.request or http and http.request or fluxus and fluxus.request or http_request,{1116352408,1899447441,3049323471,3921009573,961987163,1508970993,2453635748,2870763221,3624381080,310598401,607225278,1426881987,1925078388,2162078206,2614888103,3248222580,3835390401,4022224774,264347078,604807628,770255983,1249150122,1555081692,1996064986,2554220882,2821834349,2952996808,3210313671,3336571891,3584528711,113926993,338241895,666307205,773529912,1294757372,1396182291,1695183700,1986661051,2177026350,2456956037,2730485921,2820302411,3259730800,3345764771,3516065817,3600352804,4094571909,275423344,430227734,506948616,659060556,883997877,958139571,1322822218,1537002063,1747873779,1955562222,2024104815,2227730452,2361852424,2428436474,2756734187,3204031479,3329325298};
local a=x(64,0);
local function B(N)return o(p(N/16777216)%256,p(N/65536)%256,p(N/256)%256,N%256);
end;
local function N(I)local R=#I;
local n,E=R*8%4294967296,p(R*8/4294967296);
I..="\128"..G("\0",(56-(R+1)%64)%64)..B(E)..B(n);
local d,w,P,r,L,Z,X,q=1779033703,3144134277,1013904242,2773480762,1359893119,2600822924,528734635,1541459225;
for U=1,#I,64 do
    for z=0,15,1 do
        R=U+z*4;
        a[z+1]=t(I,R)*16777216+t(I,R+1)*65536+t(I,R+2)*256+t(I,R+3);
    end;
    for I=17,64,1 do
        U,n=a[I-15],a[I-2];
        local R,z=h(K(U,7),K(U,18),S(U,3)),h(K(n,17),K(n,19),S(n,10));
        a[I]=(a[I-16]+R+a[I-7]+z)%4294967296;
    end;
    local S,I,R,n,z,J,y,f=L,Z,X,q,d,w,P,r;
    for k=1,64,1 do
        E,U=h(K(S,6),K(S,11),K(S,25)),h(j(S,I),j(b(S),R));
        local b,g=(n+E+U+M[k]+a[k])%4294967296,(h(K(z,2),K(z,13),K(z,22))+h(j(z,J),j(z,y),j(J,y)))%4294967296;
        S,n,z,f,I,R,J,y=(f+b)%4294967296,R,(b+g)%4294967296,y,S,I,z,J;
    end;
    d,w,P,r,L,Z,X,q=(d+z)%4294967296,(w+J)%4294967296,(P+y)%4294967296,(r+f)%4294967296,(L+S)%4294967296,(Z+I)%4294967296,(X+R)%4294967296,(q+n)%4294967296;
end;
return B(d)..B(w)..B(P)..B(r)..B(L)..B(Z)..B(X)..B(q);
end;
local j=x(64,"");
local b=x(64,"");
local function K(S,M)S=if#S>64 then
    N(S)
else
    S;
    S=if#S<64 then
        S..G("\0",64-#S)
    else
        S;
        for a=1,64,1 do
            local B=t(S,a);
            j[a]=o(h(B,92));
            b[a]=o(h(B,54));
        end;
        return N(T(j)..N(T(b)..M));
    end;
    local j={};
    for b=1,64,1 do
        j[i("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/",b,b)]=b-1;
    end;
    local function b(S)local M,a={},0;
    for B=1,#S,3 do
        local I,R,n=t(S,B),t(S,B+1),t(S,B+2);
        B=I*65536+(R or 0)*256+(n or 0);
        local S,E=p(B/262144)+1,p(B/4096)%64+1;
        a+=1;
        M[a]=i("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_",S,S);
        a+=1;
        M[a]=i("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_",E,E);
        if R then
            I=p(B/64)%64+1;
            a+=1;
            M[a]=i("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_",I,I);
        else
        end;
        if n then
            S=B%64+1;
            a+=1;
            M[a]=i("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_",S,S);
        else
        end;
    end;
    return T(M);
end;
local function S(M)M=Y(Y(Y(M,"-","+"),"_","/"),"[^A-Za-z0-9+/=]","");
M..=G("=",(4-#M%4)%4);
local G,a={},0;
for B=1,#M,4 do
    local I,R=i(M,B+2,B+2),i(M,B+3,B+3);
    local n=(j[i(M,B,B)]or 0)*262144+(j[i(M,B+1,B+1)]or 0)*4096+(j[I]or 0)*64+(j[R]or 0);
    a+=1;
    G[a]=o(p(n/65536)%256);
    if I~="="then a+=1;
    G[a]=o(p(n/256)%256);
else
end;
if R~="="then a+=1;
G[a]=o(n%256);
else
end;
end;
return T(G);
end;
local j=Y("02d417c2bd7b033a00d3c4e9fda43fc56761f68f516cf68a68a6110f2cb99e49","..",function(G)return o(tonumber(G,16));
end);
local G=Random.new(os.time()+p(os.clock()*1000000)%2147483647);
local function i()local M=x(16);
for a=1,16,1 do
    M[a]=o(G:NextInteger(0,255));
end;
return T(M);
end;
local function G(M)local a=x(8);
for x=8,1,-1 do
    a[x]=o(M%256);
    M=p(M/256);
end;
return T(a);
end;
local function x(p)return(Y(p,"[^%w%-%._~/]",function(p)return O("%%%02X",t(p));
end));
end;
local p=bit32.lshift;
local M=bit32.rshift;
local a=bit32.band;
local function B(I)local function R(n)local E,d,w,P=t(I,n,n+3);
return P*16777216+w*65536+d*256+E;
end;
local I=R(1);
local n=R(5);
local E=R(9);
local d=R(13);
local R,w,P,r;
if I==0 and n==0 and E==0 and d==0 then
    I,n,E,d=2654435769,608135816,3084996962,2246822507;
    R,w,P,r=I,n,E,d;
else
    R,w,P,r=I,n,E,d;
end;
local function I()local n=h(R,p(R,11));
n,R,w,P=h(n,M(n,8)),w,P,r;
local p=h(h(r,M(r,19)),n);
r=p;
return p;
end;
return I;
end;
local function p(I,R)local n,E=B(K(j,"SHITARO-ASSET-MASK-v1\0"..R)),#I;
if buffer and buffer.fromstring then
    local B,d=buffer.fromstring(I),0;
    while d+4<=E do
        buffer.writeu32(B,d,h(buffer.readu32(B,d),n()));
        d+=4;
    end;
    if d<E then
        local w,P=n(),0;
        while d+P<E do
            buffer.writeu8(B,d+P,h(buffer.readu8(B,d+P),a(M(w,P*8),255)));
            P+=1;
        end;
    end;
    return buffer.tostring(B);
end;
local B,d,w={},1,0;
while d<=E do
    R=n();
    for n=0,3,1 do
        if d+n<=E then
            w+=1;
            B[w]=o(h(t(I,d+n),a(M(R,n*8),255)));
        else
        end;
    end;
    d=d+4;
end;
return T(B);
end;
local function h(o,T,M,a)if not(A)then
    return nil;
end;
local B,I=i(),G(os.time());
local i={["X-Shitaro-Token"]=b(B..I..K(j,"SHITARO-"..T.."-REQ-v1\0"..M.."\0"..B.."\0"..I)),Accept="*/*",["Cache-Control"]="no-cache"};
if a then
    i["Content-Type"]="application/json";
end;
local b,R=pcall(A,{Url=o,Method=a and"POST"or"GET",Headers=i,Body=a});
if b then
    if type(R)~="table"then return nil;
end;
else
    return nil;
end;
if R.StatusCode~=200 then
    return nil,nil,R.StatusCode;
end;
a=R.Body;
if type(a)~="string"then return nil;
elseif #a==0 then
    return nil;
end;
i=R.Headers or{};
I=i["X-Shitaro-Sig"]or i["x-shitaro-sig"];
if I then
    if I==""then return nil;
end;
else
    return nil;
end;
o=K(j,"SHITARO-"..T.."-RESP-v1\0"..M.."\0"..B.."\0"..G(#a)..a);
if S(I)~=o then
    return nil;
end;
return a,B;
end;
local function j(b)return(Y(b,".",function(b)return O("%02x",t(b));
end));
end;
return{library=function(b)for K=1,3,1 do
    K=h("https://shitaro.lol/api/library/"..x(b),"LIB",b);
    if type(K)=="string"then if#K>0 then
        return K;
    end;
end;
task.wait(0.5);
end;
return nil;
end,asset=function(b)local K,S=h("https://shitaro.lol/api/assets/"..x(b),"ASSET",b);
if type(K)~="string"then return nil;
elseif #K==0 then
    return nil;
end;
return p(K,S);
end,share_put=function(b)local K,S,S=h("https://shitaro.lol/api/share","CFGPUT",j(N(b)),b);
if type(K)~="string"then return nil,S;
end;
S=string.match(K,"\"code\"%s*:%s*\"([%w%-]+)\"");
if not S then
    return nil,0;
end;
return S;
end,share_get=function(j)j=string.upper(Y(j,"[^%w%-]",""));
if#j<4 then
    return nil,404;
elseif #j>16 then
    return nil,404;
end;
local b,K,K=h("https://shitaro.lol/api/share/"..j,"CFGGET",j);
if type(b)~="string"then return nil,K;
end;
return b;
end
};
end;
-- femboy.xyz / SIGNAL. Native Luau interface.
local function CreateSignalUI()
    local input=game:GetService("UserInputService")
    local players=game:GetService("Players")
    local http=game:GetService("HttpService")
    local tween=game:GetService("TweenService")
    local lib={els={},flags={},profiles={},connections={},cleanup={}}
    local palette={
        bg=Color3.fromRGB(14,20,28), rail=Color3.fromRGB(18,26,35),
        card=Color3.fromRGB(23,34,44), field=Color3.fromRGB(30,45,55),
        edge=Color3.fromRGB(49,68,78), text=Color3.fromRGB(234,245,249),
        muted=Color3.fromRGB(144,170,184), mint=Color3.fromRGB(105,242,200)
    }
    local O,S,U=UDim2.fromOffset,UDim2.fromScale,UDim2.new
    local Control,Section,Page,Tab,Window={},{},{},{},{}
    for _,class in ipairs({Control,Section,Page,Tab,Window}) do class.__index=class end

    local function make(class,parent,props)
        local obj=Instance.new(class)
        if obj:IsA("GuiObject") then obj.BorderSizePixel=0; obj.BackgroundTransparency=1 end
        if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
            obj.Font=Enum.Font.GothamMedium
            obj.TextSize=13
            obj.TextColor3=palette.text
            obj.Text=""
        end
        for key,value in pairs(props or {}) do obj[key]=value end
        obj.Parent=parent
        return obj
    end
    local function rounded(obj,radius)
        make("UICorner",obj,{CornerRadius=UDim.new(0,radius)})
    end
    local function border(obj,color,transparency)
        return make("UIStroke",obj,{Color=color or palette.edge,Transparency=transparency or 0,ApplyStrokeMode=Enum.ApplyStrokeMode.Border})
    end
    local function pad(obj,x,y)
        make("UIPadding",obj,{PaddingLeft=UDim.new(0,x),PaddingRight=UDim.new(0,x),PaddingTop=UDim.new(0,y),PaddingBottom=UDim.new(0,y)})
    end
    local function list(obj,gap,horizontal)
        return make("UIListLayout",obj,{Padding=UDim.new(0,gap),SortOrder=Enum.SortOrder.LayoutOrder,
            FillDirection=horizontal and Enum.FillDirection.Horizontal or Enum.FillDirection.Vertical,
            VerticalAlignment=horizontal and Enum.VerticalAlignment.Center or Enum.VerticalAlignment.Top})
    end
    local function label(parent,text,size,props)
        props=props or {}; props.Text=text; props.TextSize=size or 13
        props.TextXAlignment=props.TextXAlignment or Enum.TextXAlignment.Left
        return make("TextLabel",parent,props)
    end
    local function button(parent,text,size,callback)
        local obj=make("TextButton",parent,{Text=text,Size=size,BackgroundColor3=palette.field,BackgroundTransparency=0,AutoButtonColor=true,TextTruncate=Enum.TextTruncate.AtEnd})
        rounded(obj,7)
        if callback then obj.Activated:Connect(callback) end
        return obj
    end
    local function panel(parent,size)
        local frame=make("Frame",parent,{Size=size,BackgroundColor3=palette.card,BackgroundTransparency=0})
        rounded(frame,11);border(frame)
        return frame
    end
    local function clone(value)
        return type(value)=="table" and table.clone(value) or value
    end
    local function pack(value,alpha)
        if typeof(value)=="Color3" then
            local color="#"..value:ToHex()
            return alpha and color..string.format("%02x",math.round(alpha*255)) or color
        end
        return clone(value)
    end
    local function colorFrom(value)
        if type(value)~="string" then return end
        local hex=value:gsub("^#","")
        if (#hex==6 or #hex==8) and hex:match("^%x+$") then
            return Color3.fromHex(hex:sub(1,6)),#hex==8 and tonumber(hex:sub(7),16)/255 or 1
        end
    end
    local function safely(callback,...)
        if not callback then return end
        local ok,err=pcall(callback,...)
        if not ok then warn("[femboy.xyz] "..tostring(err)) end
    end
    function lib:connect(signal,callback)
        local connection=signal:Connect(callback)
        table.insert(self.connections,connection)
        return connection
    end
    function lib:onunload(callback) table.insert(self.cleanup,callback) end
    function lib:unload()
        if self.dead then return end
        self.dead=true
        for _,connection in ipairs(self.connections) do connection:Disconnect() end
        self.gui:Destroy()
        for _,callback in ipairs(self.cleanup) do safely(callback) end
    end

    local function row(section,name)
        local outer=make("Frame",section.frame,{Size=U(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y})
        list(outer,5)
        local bar=make("Frame",outer,{Size=U(1,0,0,44),BackgroundColor3=palette.field,BackgroundTransparency=.46})
        rounded(bar,7)
        local title=label(bar,name or "",13,{Position=O(11,0),Size=U(1,-100,1,0),TextTruncate=Enum.TextTruncate.AtEnd})
        local accessories=make("Frame",bar,{AnchorPoint=Vector2.new(1,.5),Position=U(1,-7,.5,0),Size=O(0,34),AutomaticSize=Enum.AutomaticSize.X})
        list(accessories,5,true)
        local function fit()
            local width=accessories.AbsoluteSize.X/(lib.scale and lib.scale.Scale or 1)
            title.Size=U(1,-(width+24),1,0)
        end
        accessories:GetPropertyChangedSignal("AbsoluteSize"):Connect(fit)
        return outer,accessories
    end
    local function sectionFor(parent,page,title)
        local frame=panel(parent,U(1,0,0,0))
        frame.AutomaticSize=Enum.AutomaticSize.Y
        pad(frame,10,10);list(frame,5)
        if title and title~="" then
            label(frame,string.upper(title),11,{Size=U(1,0,0,24),TextColor3=palette.mint,Font=Enum.Font.GothamBold})
        end
        return setmetatable({frame=frame,page=page},Section)
    end
    local function control(section,options,kind,initial,host)
        local self=setmetatable({o=options,kind=kind,val=initial,default=clone(initial),flag=options.flag,section=section,children={},watchers={}},Control)
        self.row,self.accessories=nil,nil
        if host then self.row,self.accessories=host.row,host.accessories
        else self.row,self.accessories=row(section,options.name or options.text) end
        table.insert(lib.els,self)
        if self.flag then
            local profile=section.page and section.page.tab.profileData
            if profile and not options.noprof then
                self.profile=profile; profile.controls[self.flag]=self
            end
        end
        return self
    end
    function Control:effective()
        if self.bind and self.bind.active then
            if self.kind=="toggle" then return not self.val end
            return self.bind.v or self.val
        end
        return self.val
    end
    function Control:fire(silent)
        local value=self:effective()
        if self.flag then lib.flags[self.flag]=value end
        if self.profile and not self.profile.loading then self.profile:store(self) end
        for _,callback in ipairs(self.watchers) do callback() end
        if not silent then safely(self.o.cb or self.o.callback,value,self.alpha) end
        return self
    end
    function Control:get() return self.val end
    function Control:ser() return pack(self.val,self.alpha) end
    function Control:load(value,silent)
        if self.kind=="color" then
            local color,alpha=colorFrom(value)
            if color then self.alpha=alpha; self:set(color,silent) end
        else self:set(value,silent) end
    end
    function Control:set(value,silent)
        if self.kind=="toggle" then value=value==true
        elseif self.kind=="slider" then
            local min,max=self.o.min or 0,self.o.max or 100
            local step=self.o.step or 10^-(self.o.dec or self.o.decimals or 0)
            value=math.clamp(math.round(((tonumber(value) or min)-min)/step)*step+min,min,max)
        elseif self.kind=="dropdown" then
            if self.o.multi then
                if type(value)~="table" then return self end
                local filtered={}
                for _,item in ipairs(value) do if table.find(self.values,item) then table.insert(filtered,item) end end
                value=filtered
            elseif value~=nil and not table.find(self.values,value) then return self end
        elseif self.kind=="cards" then
            if value~=nil and not self.items[value] then return self end
        elseif self.kind=="color" and typeof(value)~="Color3" then return self end
        self.val=value
        if self.draw then self:draw() end
        return self:fire(silent)
    end
    function Control:dep(source,wanted)
        local function update()
            local value=source:effective()
            local allowed
            if type(wanted)=="function" then allowed=wanted(value)
            elseif wanted==nil then allowed=value==true
            else allowed=value==wanted end
            if self.row==source.row and self.widget then
                self.widget.Visible=allowed
            else
                self.row.Visible=allowed
            end
        end
        table.insert(source.watchers,update);update()
        return self
    end
    function Control:settings()
        if self.nested then return self.nested end
        local nested=sectionFor(self.row,self.section.page,nil)
        nested.frame.Visible=false
        button(self.accessories,"···",O(27,30),function()nested.frame.Visible=not nested.frame.Visible end)
        self.nested=nested
        return nested
    end
    local function setBind(control,bind)
        control.bind=bind and {k=bind.k,m=bind.m=="hold" and "hold" or "toggle",v=bind.v} or nil
        control:fire()
    end
    local function bindMenu(control,button)
        if not control.flag then return end
        if control.o.bind then control.bind={k=control.o.bind,m=control.o.mode or "toggle"} end
        button.MouseButton2Click:Connect(function()
            lib:popup(button,"Keybind",{"Press a key","Hold mode","Toggle mode","Clear"},function(action)
                local bind=control.bind or {m="toggle"}
                if action=="Press a key" then
                    lib.capture=control
                    lib:notify("Press a key • Esc to cancel")
                elseif action=="Clear" then setBind(control,nil)
                else
                    bind.m=action=="Hold mode" and "hold" or "toggle"
                    if control.kind=="slider" then bind.v=control.val end
                    setBind(control,bind)
                end
            end)
        end)
    end
    function Section:toggle(options)
        local self=control(self,options,"toggle",options.default==true)
        local track=button(self.accessories,"",O(42,24),function()self:set(not self.val) end)
        self.widget=track
        bindMenu(self,track)
        local knob=make("Frame",track,{Size=O(15,15),BackgroundTransparency=0})
        rounded(knob,9)
        function self:draw()
            track.BackgroundColor3=self.val and palette.mint or palette.edge
            knob.BackgroundColor3=self.val and palette.bg or palette.muted
            local goal={Position=O(self.val and 22 or 5,4.5)}
            tween:Create(knob,TweenInfo.new(.14),goal):Play()
        end
        self:draw()
        return self
    end
    function Section:slider(options,host)
        local self=control(self,options,"slider",options.default or options.min or 0,host)
        local field=make("Frame",self.accessories,{Size=O(118,32)})
        self.widget=field
        local value=make("TextBox",field,{Size=O(46,32),ClearTextOnFocus=false,TextSize=11,BackgroundColor3=palette.field,BackgroundTransparency=0})
        rounded(value,6)
        local track=button(field,"",O(62,32))
        track.Position=O(54,0);track.BackgroundTransparency=1
        bindMenu(self,track)
        local line=make("Frame",track,{Position=U(0,0,.5,-2),Size=U(1,0,0,4),BackgroundColor3=palette.edge,BackgroundTransparency=0})
        rounded(line,3)
        local fill=make("Frame",line,{Size=S(0,1),BackgroundColor3=palette.mint,BackgroundTransparency=0})
        rounded(fill,3)
        function self:draw()
            value.Text=string.format("%."..(options.dec or options.decimals or 0).."f",self.val)..(options.suffix or "")
            local min,max=options.min or 0,options.max or 100
            fill.Size=S(math.clamp((self.val-min)/math.max(max-min,.001),0,1),1)
        end
        local function seek(x)
            local min,max=options.min or 0,options.max or 100
            self:set(min+(max-min)*math.clamp((x-track.AbsolutePosition.X)/math.max(1,track.AbsoluteSize.X),0,1))
        end
        track.InputBegan:Connect(function(event)
            local kind=event.UserInputType
            if kind==Enum.UserInputType.Touch or kind==Enum.UserInputType.MouseButton1 then
                lib.drag={event=event,touch=kind==Enum.UserInputType.Touch,move=function(pos)seek(pos.X) end}
                seek(event.Position.X)
            end
        end)
        value.FocusLost:Connect(function() self:set(tonumber(value.Text:match("^%-?[%d%.]+")) or self.val) end)
        self:draw()
        return self
    end
    function Section:dropdown(options,host)
        local values=options.values or options.options or {}
        local default=options.default
        if options.multi then default=type(default)=="table" and clone(default) or (default~=nil and {default} or {})
        elseif default==nil and not options.none then default=values[1] end
        local self=control(self,options,"dropdown",default,host)
        self.values=values
        local trigger=button(self.accessories,"",O(options.w or 122,32))
        self.widget=trigger
        function self:draw()
            trigger.Text=(type(self.val)=="table" and (#self.val==0 and "none" or table.concat(self.val,", ")) or tostring(self.val or options.empty or "none")).."  ▾"
        end
        function self:setvalues(items,silent)
            self.values=items or {}
            if self.o.multi then self:set(self.val,silent)
            elseif not table.find(self.values,self.val) then self:set(not self.o.none and self.values[1] or nil,silent)
            else self:draw() end
            return self
        end
        trigger.Activated:Connect(function()
            lib:popup(trigger,options.name or "Select",self.values,function(item)
                if options.multi then
                    local selected=table.clone(self.val)
                    local index=table.find(selected,item)
                    if index then table.remove(selected,index) else table.insert(selected,item) end
                    self:set(selected)
                else self:set(item) end
            end)
        end)
        self:draw()
        return self
    end
    function Section:colorpicker(options,host)
        local self=control(self,options,"color",options.default or Color3.new(1,1,1),host)
        self.alpha=options.alpha or 1
        local swatch=button(self.accessories,"",O(28,28))
        self.widget=swatch
        function self:draw() swatch.BackgroundColor3=self.val end
        swatch.Activated:Connect(function()
            lib:popup(swatch,"Color",{"Mint","Ice","Lilac","Rose","Gold","White","Custom HEX"},function(item)
                local hex=({Mint="69F2C8",Ice="7DCBFF",Lilac="BCA3FF",Rose="F78DB8",Gold="FAD177",White="FFFFFF"})[item]
                if hex then self:set(Color3.fromHex(hex)) end
            end,function(box)
                box.Text=self:ser()
                box.FocusLost:Connect(function(enter)
                    if enter then self:load(box.Text);lib:closePopup() end
                end)
            end)
        end)
        self:draw()
        return self
    end
    function Section:button(options)
        local obj=button(self.frame,options.name or options.text,U(1,0,0,40),function()safely(options.cb or options.callback) end)
        return obj
    end
    function Control:color(options) return self.section:colorpicker(options,self) end
    function Control:slider(options) return self.section:slider(options,self) end
    function Control:dropdown(options) return self.section:dropdown(options,self) end
    function Section:cards(options)
        local self=control(self,options,"cards",options.default)
        self.accessories.Parent.Visible=false
        local grid=make("Frame",self.row,{Size=U(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y})
        local layout=make("UIGridLayout",grid,{CellSize=U(1/3,-5,0,118),CellPadding=O(7,7),SortOrder=Enum.SortOrder.LayoutOrder})
        local function fit()
            local width=grid.AbsoluteSize.X/(lib.scale and lib.scale.Scale or 1)
            local count=math.clamp(math.floor((width+7)/113),1,options.cols or 3)
            layout.CellSize=U(1/count,-7*(count-1)/count,0,118)
        end
        grid:GetPropertyChangedSignal("AbsoluteSize"):Connect(fit)
        function self:draw()
            for key,card in pairs(self.items) do
                local selected=key==self.val
                card.stroke.Color=selected and palette.mint or palette.edge
                card.tag.Visible=selected
                card.button.BackgroundColor3=selected and Color3.fromRGB(27,57,56) or palette.field
            end
        end
        function self:setvalues(values,silent)
            for _,child in ipairs(grid:GetChildren()) do if child:IsA("GuiObject") then child:Destroy() end end
            self.items={}
            local first
            for index,item in ipairs(values or {}) do
                local key=type(item)=="table" and (item.value or item.name) or item
                local title=type(item)=="table" and (item.name or key) or key
                first=first or key
                local card=button(grid,"",O(100,118),function() self:set(key) end)
                card.LayoutOrder=index
                local picture=make("ImageLabel",card,{Position=O(6,8),Size=U(1,-12,1,-38),Image=type(item)=="table" and (item.image or "") or "",ScaleType=type(item)=="table" and item.crop and Enum.ScaleType.Crop or Enum.ScaleType.Fit})
                if picture.Image=="" then label(picture,"◇",36,{Size=S(1,1),TextXAlignment=Enum.TextXAlignment.Center,TextColor3=palette.muted}) end
                label(card,tostring(title),12,{Position=U(0,7,1,-27),Size=U(1,-14,0,24),TextTruncate=Enum.TextTruncate.AtEnd})
                local tag=label(card,"◆",12,{Position=U(1,-19,0,5),Size=O(14,16),TextColor3=palette.mint})
                self.items[key]={button=card,stroke=border(card),tag=tag}
            end
            if not self.items[self.val] then self.val=first end
            fit();self:draw()
            if not silent then self:fire() end
            return self
        end
        return self:setvalues(options.values,true)
    end
    function lib:closePopup()
        if self.overlay then self.overlay:Destroy();self.overlay=nil end
    end
    function lib:popup(anchor,title,values,selectValue,custom)
        self:closePopup()
        local overlay=make("TextButton",self.gui,{Size=S(1,1),ZIndex=80,AutoButtonColor=false})
        self.overlay=overlay
        overlay.Activated:Connect(function() self:closePopup() end)
        local width=math.min(230,math.max(140,self.gui.AbsoluteSize.X-20))
        local height=math.min(320,math.max(110,self.gui.AbsoluteSize.Y-20),54+#values*36+(custom and 40 or 0))
        local popup=panel(overlay,O(width,height))
        popup.Active=true;popup.ZIndex=81
        popup.Position=O(math.clamp(anchor.AbsolutePosition.X,8,math.max(8,self.gui.AbsoluteSize.X-width-8)),
            math.clamp(anchor.AbsolutePosition.Y+anchor.AbsoluteSize.Y+4,8,math.max(8,self.gui.AbsoluteSize.Y-height-8)))
        label(popup,title,13,{Position=O(10,0),Size=U(1,-48,0,38),TextColor3=palette.mint,TextTruncate=Enum.TextTruncate.AtEnd})
        local close=button(popup,"×",O(28,27),function()self:closePopup() end)
        close.Position=U(1,-35,0,5)
        local scroll=make("ScrollingFrame",popup,{Position=O(7,39),Size=U(1,-14,1,-46),CanvasSize=O(0,0),AutomaticCanvasSize=Enum.AutomaticSize.Y,ScrollBarThickness=3})
        pad(scroll,3,2);list(scroll,4)
        for _,item in ipairs(values) do
            if item~="Custom HEX" or not custom then
                button(scroll,tostring(item),U(1,-5,0,32),function() self:closePopup();selectValue(item) end)
            end
        end
        if custom then
            local box=make("TextBox",scroll,{Size=U(1,-5,0,33),PlaceholderText="#RRGGBBAA",ClearTextOnFocus=false,BackgroundColor3=palette.field,BackgroundTransparency=0})
            rounded(box,7);custom(box)
        end
    end
    function Page:section(options)
        if type(options)=="string" then options={name=options} end
        options=options or {}
        local side=tonumber(options.side) or (options.side=="right" and 2 or 1)
        side=math.clamp(math.floor(side),1,#self.columns)
        local section=sectionFor(self.columns[side],self,options.name)
        table.insert(self.sections,{frame=section.frame,side=side})
        self:layout()
        return section
    end
    function Page:layout()
        local narrow=self.tab.window.compact
        local count=#self.columns
        for i,column in ipairs(self.columns) do
            column.Visible=not narrow or i==1
            column.Position=narrow and O(0,0) or U((i-1)/count,(i-1)*10/count,0,0)
            column.Size=narrow and S(1,1) or U(1/count,-(count-1)*10/count,1,0)
        end
        for i,entry in ipairs(self.sections) do
            entry.frame.LayoutOrder=i
            entry.frame.Parent=self.columns[narrow and 1 or entry.side]
        end
    end
    function Tab:selectPage(page)
        self.current=page
        lib:closePopup()
        for _,candidate in ipairs(self.pages) do
            candidate.frame.Visible=candidate==page
            candidate.button.TextColor3=candidate==page and palette.mint or palette.muted
        end
    end
    function Tab:page(options)
        if type(options)=="string" then options={name=options} end
        options=options or {}
        local page=setmetatable({tab=self,sections={},columns={}},Page)
        page.frame=make("Frame",self.pagesHost,{Size=S(1,1),Visible=false})
        for _=1,math.clamp(options.cols or 2,1,4) do
            local column=make("ScrollingFrame",page.frame,{CanvasSize=O(0,0),AutomaticCanvasSize=Enum.AutomaticSize.Y,ScrollBarThickness=3,ScrollBarImageColor3=palette.edge})
            pad(column,4,4);list(column,10)
            table.insert(page.columns,column)
        end
        page.button=button(self.pageBar,options.name or "main",O(76,28),function()self:selectPage(page)end)
        table.insert(self.pages,page)
        page:layout()
        if not self.current then self:selectPage(page) end
        return page
    end
    function Tab:section(options) return (self.pages[1] or self:page("main")):section(options) end
    function Tab:profile(options)
        local global=options.global or "global"
        local items={global}
        for _,name in ipairs(options.items or {}) do if name~=global then table.insert(items,name) end end
        local profile={controls={},data={},cur=global,global=global,id=options.id,items=items}
        self.profileData=profile
        lib.profiles[options.id]=profile
        function profile:store(control)
            local bucket=self.data[self.cur] or {}
            self.data[self.cur]=bucket
            bucket[control.flag]=control:ser()
        end
        function profile:get(flag,item)
            local control=self.controls[flag]
            if not control then return nil end
            if item==self.cur then return control:effective() end
            local bucket=self.data[item]
            local globalData=self.data[self.global]
            local value=bucket and bucket[flag]
            if value==nil and globalData then value=globalData[flag] end
            if value==nil then return clone(control.default) end
            if control.kind=="color" then return colorFrom(value) end
            return clone(value)
        end
        function profile:select(value)
            self.cur=value;self.loading=true
            for _,control in pairs(self.controls) do
                local bucket=self.data[value]
                local globalData=self.data[self.global]
                local stored=bucket and bucket[control.flag]
                if stored==nil and globalData then stored=globalData[control.flag] end
                if stored==nil then control:set(clone(control.default),true) else control:load(stored,true) end
            end
            self.loading=false
            self.button.Text=string.upper(value).."  ▾"
            safely(self.cb)
        end
        local pick=button(self.pageBar,string.upper(global).."  ▾",O(112,28))
        profile.button=pick
        pick.Activated:Connect(function()
            lib:popup(pick,"Weapon profile",items,function(value)profile:select(value)end)
        end)
        return profile
    end
    function Window:select(tab)
        self.current=tab;lib:closePopup()
        for _,candidate in ipairs(self.tabs) do
            candidate.frame.Visible=candidate==tab
            candidate.button.TextColor3=candidate==tab and palette.mint or palette.muted
            candidate.button.BackgroundColor3=candidate==tab and Color3.fromRGB(30,57,61) or palette.rail
        end
        self.title.Text=string.upper(tab.name)
        self.index.Text=string.format("%02d / SIGNAL",tab.index)
    end
    function Window:tab(options)
        if type(options)=="string" then options={name=options} end
        local tab=setmetatable({name=options.name,pages={},window=self,index=#self.tabs+1},Tab)
        tab.button=button(self.nav,string.upper(tab.name),O(126,41),function()self:select(tab)end)
        tab.button.LayoutOrder=tab.index
        tab.frame=make("Frame",self.content,{Size=S(1,1),Visible=false})
        tab.pageBar=make("ScrollingFrame",tab.frame,{Size=U(1,0,0,31),CanvasSize=O(0,0),AutomaticCanvasSize=Enum.AutomaticSize.X,ScrollingDirection=Enum.ScrollingDirection.X,ScrollBarThickness=0})
        list(tab.pageBar,5,true)
        tab.pagesHost=make("Frame",tab.frame,{Position=O(0,36),Size=U(1,0,1,-36)})
        table.insert(self.tabs,tab)
        self:layout()
        self:select(self.current or tab)
        return tab
    end
    function Window:layout()
        local size=lib.gui.AbsoluteSize
        if size.X<1 or size.Y<1 then return end
        local compact=size.X<770
        self.compact=compact
        local width=compact and math.max(360,math.min(570,size.X-20)) or 980
        local height=compact and math.max(350,math.min(710,size.Y-26)) or 594
        self.root.Size=O(width,height)
        lib.scale.Scale=math.min(1,(size.X-16)/width,(size.Y-16)/height)
        self.rail.Position=compact and O(10,58) or O(12,68)
        self.rail.Size=compact and U(1,-20,0,48) or U(0,150,1,-82)
        self.nav.ScrollingDirection=compact and Enum.ScrollingDirection.X or Enum.ScrollingDirection.Y
        self.nav.AutomaticCanvasSize=compact and Enum.AutomaticSize.X or Enum.AutomaticSize.Y
        self.navList.FillDirection=compact and Enum.FillDirection.Horizontal or Enum.FillDirection.Vertical
        self.navList.VerticalAlignment=compact and Enum.VerticalAlignment.Center or Enum.VerticalAlignment.Top
        for _,tab in ipairs(self.tabs) do
            tab.button.Size=compact and O(76,36) or U(1,-2,0,43)
            for _,page in ipairs(tab.pages) do page:layout() end
        end
        local left=compact and 12 or 177
        local top=compact and 111 or 70
        self.heading.Position=O(left,top)
        self.heading.Size=U(1,-left-12,0,53)
        self.content.Position=O(left,top+61)
        self.content.Size=U(1,-left-12,1,-top-73)
    end
    function lib:toggle(force)
        local visible=force
        if visible==nil then visible=not self.win.root.Visible end
        self.win.root.Visible=visible
        if not visible then self:closePopup() end
    end
    function lib:notify(message)
        if self.dead or not self.gui then return end
        if self.toast then self.toast:Destroy() end
        local toast=panel(self.gui,O(math.min(340,math.max(230,self.gui.AbsoluteSize.X-30)),50))
        self.toast=toast
        toast.AnchorPoint=Vector2.new(1,1);toast.Position=U(1,-14,1,-14);toast.ZIndex=60
        label(toast,tostring(message),13,{Position=O(12,4),Size=U(1,-24,1,-8),TextWrapped=true,TextColor3=palette.mint})
        task.delay(3,function() if self.toast==toast then self.toast=nil;toast:Destroy() end end)
    end
    function lib:spectators(entries)
        if not self.spectator then return end
        local names={}
        for _,entry in ipairs(entries or {}) do
            table.insert(names,typeof(entry)=="Instance" and entry.DisplayName or tostring(type(entry)=="table" and entry.name or entry))
        end
        self.spectator.Text=#names==0 and "SIGNAL / LIVE" or ("WATCHING  "..table.concat(names,", "))
    end
    function lib:window(options)
        local global=getgenv and getgenv() or _G
        if global.FemboySignalUI then safely(global.FemboySignalUI.unload,global.FemboySignalUI) end
        global.FemboySignalUI=self
        self:onunload(function() if global.FemboySignalUI==self then global.FemboySignalUI=nil end end)
        self.folder=options.folder or "femboy-signal"
        for _,folder in ipairs({self.folder,self.folder.."/configs"}) do
            local ok,exists=pcall(isfolder,folder)
            if ok and not exists then pcall(makefolder,folder) end
        end
        local platform
        pcall(function()platform=input:GetPlatform() end)
        self.mobile=platform==Enum.Platform.Android or platform==Enum.Platform.IOS or
            ((platform==nil or platform==Enum.Platform.None) and input.TouchEnabled and not input.MouseEnabled)
        local parent=(gethui and gethui()) or players.LocalPlayer:WaitForChild("PlayerGui")
        local gui=make("ScreenGui",parent,{Name="FemboySignal",IgnoreGuiInset=true,ResetOnSpawn=false,DisplayOrder=10001})
        self.gui=gui
        local root=panel(gui,O(980,594))
        root.Name="SignalWindow";root.AnchorPoint=Vector2.new(.5,.5);root.Position=S(.5,.5);root.BackgroundColor3=palette.bg
        self.scale=make("UIScale",root)
        local header=make("Frame",root,{Size=U(1,0,0,56),Active=true})
        make("Frame",header,{Position=U(0,0,1,-1),Size=U(1,0,0,1),BackgroundTransparency=0,BackgroundColor3=palette.edge})
        local badge=panel(header,O(34,32));badge.Position=O(14,12);badge.BackgroundColor3=palette.mint
        label(badge,"ƒ",22,{Size=S(1,1),TextColor3=palette.bg,TextXAlignment=Enum.TextXAlignment.Center,Font=Enum.Font.GothamBold})
        label(header,options.title or "femboy.xyz",16,{Position=O(57,0),Size=O(115,56),Font=Enum.Font.GothamBold})
        self.spectator=label(header,"SIGNAL / LIVE",10,{Position=O(177,0),Size=U(1,-260,1,0),TextColor3=palette.muted,TextTruncate=Enum.TextTruncate.AtEnd})
        local save=button(header,"SAVE",O(65,30),function()self:save()end);save.Position=U(1,-78,0,13)
        local rail=panel(root,O(150,450));rail.BackgroundColor3=palette.rail
        local nav=make("ScrollingFrame",rail,{Position=O(6,5),Size=U(1,-12,1,-10),CanvasSize=O(0,0),ScrollBarThickness=0})
        local navList=list(nav,5)
        local heading=make("Frame",root,{Size=O(600,53)})
        local index=label(heading,"01 / SIGNAL",11,{Size=U(1,0,0,18),TextColor3=palette.mint,Font=Enum.Font.GothamBold})
        local title=label(heading,"",27,{Position=O(0,18),Size=U(1,0,0,34),Font=Enum.Font.GothamBold})
        local content=make("Frame",root,{Size=O(600,450)})
        local window=setmetatable({root=root,rail=rail,nav=nav,navList=navList,heading=heading,title=title,index=index,content=content,tabs={}},Window)
        self.win=window
        self:connect(gui:GetPropertyChangedSignal("AbsoluteSize"),function()window:layout()end)
        self:connect(input.InputChanged,function(event)
            local drag=self.drag
            if drag and (drag.touch and drag.event==event or not drag.touch and event.UserInputType==Enum.UserInputType.MouseMovement) then drag.move(event.Position) end
        end)
        local function keyName(event)
            return event.KeyCode~=Enum.KeyCode.Unknown and event.KeyCode.Name or event.UserInputType.Name
        end
        self:connect(input.InputEnded,function(event)
            if self.drag and self.drag.event==event then self.drag=nil end
            local name=keyName(event)
            for _,control in ipairs(self.els) do
                local bind=control.bind
                if bind and bind.active and bind.m=="hold" and name==bind.k then
                    bind.active=false;control:fire()
                end
            end
        end)
        self:connect(input.InputBegan,function(event,processed)
            if self.capture then
                local capture=self.capture;self.capture=nil
                if event.KeyCode~=Enum.KeyCode.Escape then
                    local bind=capture.bind or {m="toggle"}
                    bind.k=keyName(event)
                    if capture.kind=="slider" then bind.v=capture.val end
                    setBind(capture,bind)
                    self:notify("Bound  /  "..bind.k)
                end
                return
            end
            if processed or input:GetFocusedTextBox() then return end
            if not self.mobile and event.KeyCode==Enum.KeyCode[options.key or "Insert"] then self:toggle();return end
            local name=keyName(event)
            for _,control in ipairs(self.els) do
                local bind=control.bind
                if bind and name==bind.k then
                    if bind.m=="toggle" and control.kind=="toggle" then control:set(not control.val)
                    else bind.active=bind.m=="hold" or not bind.active;control:fire() end
                end
            end
        end)
        header.InputBegan:Connect(function(event)
            local kind=event.UserInputType
            if kind~=Enum.UserInputType.Touch and kind~=Enum.UserInputType.MouseButton1 then return end
            local initial,origin=event.Position,root.AbsolutePosition+root.AbsoluteSize/2
            self.drag={event=event,touch=kind==Enum.UserInputType.Touch,move=function(pos)
                local size=gui.AbsoluteSize
                root.Position=O(math.clamp(origin.X+pos.X-initial.X,42,math.max(42,size.X-42)),math.clamp(origin.Y+pos.Y-initial.Y,root.AbsoluteSize.Y/2,math.max(root.AbsoluteSize.Y/2,size.Y-root.AbsoluteSize.Y/2)))
            end}
        end)
        if self.mobile then
            local mobile=button(gui,"ƒ",O(49,49),function()self:toggle()end)
            mobile.Position=U(0,8,.41,0);mobile.ZIndex=75
            border(mobile,palette.mint)
            task.spawn(function()
                local path=self.folder.."/signal-mobile.jpg"
                local requestImage=request or http_request or (syn and syn.request)
                local customAsset=getcustomasset or getsynasset
                if not customAsset then return end
                local ok,exists=pcall(isfile,path)
                if not ok or not exists then
                    local received,response=pcall(requestImage,{Url="https://i.pinimg.com/474x/82/6b/91/826b91578b3818556969a899889aa660.jpg?nii=t",Method="GET"})
                    if not received or type(response)~="table" or response.StatusCode~=200 or type(response.Body)~="string" or response.Body:sub(1,2)~="\255\216" then return end
                    if not pcall(writefile,path,response.Body) then return end
                end
                local loaded,asset=pcall(customAsset,path)
                if loaded and not self.dead then
                    local image=make("ImageLabel",mobile,{Size=S(1,1),Image=asset,ScaleType=Enum.ScaleType.Crop,ZIndex=76})
                    rounded(image,7);mobile.Text=""
                end
            end)
        end
        window:layout()
        return window
    end
    local function configName(name)
        name=tostring(name or ""):gsub('[\\/:%*%?"<>|]',''):match("^%s*(.-)%s*$"):sub(1,40)
        return name~="" and name or "signal"
    end
    function lib:save(name)
        name=configName(name or self.config)
        local state={flags={},profs={},binds={}}
        for _,control in ipairs(self.els) do
            if control.flag and not control.profile then state.flags[control.flag]=control:ser() end
            if control.flag and control.bind and control.bind.k then
                state.binds[control.flag]={k=control.bind.k,m=control.bind.m,v=control.bind.v}
            end
        end
        for key,profile in pairs(self.profiles) do state.profs[key]={cur=profile.cur,data=profile.data} end
        local ok=pcall(function()
            writefile(self.folder.."/configs/"..name..".json",http:JSONEncode(state))
            writefile(self.folder.."/last.txt",name)
        end)
        if ok then self.config=name end
        self:notify(ok and ("Saved  /  "..name) or "Config could not be saved")
    end
    function lib:load(name,quiet)
        name=configName(name)
        local ok,state=pcall(function()return http:JSONDecode(readfile(self.folder.."/configs/"..name..".json")) end)
        if not ok or type(state)~="table" then if not quiet then self:notify("Config unavailable") end;return end
        local flags=type(state.flags)=="table" and state.flags or {}
        local binds=type(state.binds)=="table" and state.binds or {}
        for _,control in ipairs(self.els) do
            if control.flag and not control.profile and flags[control.flag]~=nil then control:load(flags[control.flag]) end
            if control.flag and (control.kind=="toggle" or control.kind=="slider") then
                local bind=binds[control.flag]
                setBind(control,type(bind)=="table" and type(bind.k)=="string" and bind or nil)
            end
        end
        for key,profile in pairs(self.profiles) do
            local saved=type(state.profs)=="table" and state.profs[key]
            if type(saved)=="table" then
                profile.data=type(saved.data)=="table" and saved.data or {}
                profile:select(table.find(profile.items,saved.cur) and saved.cur or profile.global)
            end
        end
        self.config=name
        pcall(writefile,self.folder.."/last.txt",name)
        if not quiet then self:notify("Loaded  /  "..name) end
    end
    function Page:settings()
        local menu=self:section("Interface")
        menu:button({name=lib.mobile and "Hide menu • tap image to reopen" or "Hide menu • Insert to reopen",cb=function()lib:toggle(false)end})
        self:section({name="Session",side=2}):button({name="Unload femboy.xyz",cb=function()lib:unload()end})
        return self
    end
    function Page:configs(options)
        local section=self:section("Local presets")
        local box=make("TextBox",section.frame,{Size=U(1,0,0,39),ClearTextOnFocus=false,PlaceholderText="Preset name",BackgroundColor3=palette.field,BackgroundTransparency=0})
        rounded(box,7)
        section:button({name="Save preset",cb=function()lib:save(box.Text)end})
        section:button({name="Load preset",cb=function()lib:load(box.Text)end})
        local browse
        browse=section:button({name="Browse saved presets",cb=function()
            local ok,files=pcall(listfiles,lib.folder.."/configs")
            local names={}
            if ok and type(files)=="table" then
                for _,path in ipairs(files) do
                    local name=path:match("([^/\\]+)%.json$")
                    if name then table.insert(names,name) end
                end
            end
            table.sort(names)
            if #names==0 then lib:notify("No saved presets");return end
            lib:popup(browse,"Presets",names,function(name)box.Text=name;lib:load(name)end)
        end})
        if not options or options.autoload~=false then
            local ok,last=pcall(readfile,lib.folder.."/last.txt")
            if ok and type(last)=="string" and last~="" then lib:load(last,true);box.Text=last end
        end
        return self
    end
    return lib
end

D.d=CreateSignalUI;
D.e=function()local j,b=D.load("a"),D.load("d");
local K=b:window({title="femboy.xyz",folder="shitaroblox",key="Insert"});
local h={lib=b,win=K,tabs={aim=K:tab({name="aim",icon="crosshair"}),trigger=K:tab({name="trigger",icon="trigger"}),visuals=K:tab({name="visuals",icon="eye"}),misc=K:tab({name="misc",icon="gear"}),skins=K:tab({name="skins",icon="skins"})},finish=function()local S=b.els;
for o=1,#S,1 do
    S[o]:fire();
end;
S=K:tab({name="settings",icon="sliders"});
S:page("menu"):settings();
S:page("configs"):configs();
end
};
b:onunload(j.release);
j.teardown(function()b:unload();
end);
return h;
end;
D.f=function()local j=table.create;
local h=table.clear;
local b,K=table.move,{trim=function(S,o)for t=#S,o+1,-1 do
    S[t]=nil;
end;
return S;
end,drop=function(S,o)local t=#S;
S[o]=S[t];
S[t]=nil;
end
};
K.copy_with=function(S,o,t)local G=#o;
b(o,1,G,1,S);
if t~=nil then
    G+=1;
    S[G]=t;
else
end;
return K.trim(S,G);
end;
local S={};
S.__index=S;
S.new=function(o)return setmetatable({items=j(o or 8),head=1,tail=0},S);
end;
S.count=function(j)return j.tail-j.head+1;
end;
S.push=function(j,o)local t=j.tail+1;
j.tail=t;
j.items[t]=o;
return o;
end;
S.peek=function(j)if j.head>j.tail then
    return nil;
end;
return j.items[j.head];
end;
S.shift=function(j)local o=j.head;
if o>j.tail then
    return nil;
end;
local t=j.items;
local G=t[o];
t[o]=nil;
j.head=o+1;
if j.head>j.tail then
    j.head=1;
    j.tail=0;
elseif  o>64 then
    local i=j.tail-o;
    b(t,o+1,j.tail,1);
    K.trim(t,i);
    j.head=1;
    j.tail=i;
end;
return G;
end;
S.remove=function(j,o)local t=j.items;
b(t,o+1,j.tail,o);
t[j.tail]=nil;
j.tail=j.tail-1;
if j.head>j.tail then
    j.head=1;
    j.tail=0;
end;
end;
S.reset=function(j)h(j.items);
j.head=1;
j.tail=0;
end;
K.queue=S;
local j={};
j.__index=j;
j.new=function(h,b)return setmetatable({items={},create=h,hide=b,count=0,used=0},j);
end;
j.open=function(h)h.used=0;
end;
j.next=function(h)local b=h.used+1;
h.used=b;
local S=h.items[b];
if S==nil then
    S=h.create();
    if S==nil then
        h.used=b-1;
        return nil;
    end;
    h.items[b]=S;
    if b>h.count then
        h.count=b;
    end;
else
end;
return S;
end;
j.close=function(h)local b=h.hide;
if not(b)then
    return;
end;
local S=h.items;
for o=h.used+1,h.count,1 do
    local h=S[o];
    if h~=nil then
        b(h);
    end;
end;
end;
j.purge=function(h,b)local S=h.items;
for o=h.count,1,-1 do
    local t=S[o];
    S[o]=nil;
    if t~=nil then
        if b then
            b(t);
        end;
    end;
end;
h.count=0;
h.used=0;
end;
K.pool=j;
return K;
end;
D.g=function()local j,h=D.load("b"),D.load("a");
local b=j.storage;
local K=j.workspace;
local S=j.players;
local o,t,G,i,Y,O,T,x,p,A=os.clock,{version=0},{},0,{},{},{},{},{};
local M={GetAttribute=function(a,B)return rawget(a,"folder"):GetAttribute(B);
end,GetAttributes=function(a)return rawget(a,"folder"):GetAttributes();
end,GetAttributeChangedSignal=function(a,B)return rawget(a,"folder"):GetAttributeChangedSignal(B);
end
};
local function a(B,N)return B:IsA("Model")and B:GetAttribute("Bot")==true and B:GetAttribute("CombatantId")==N;
end;
local function B(N,I,R,n)if not(N)then
    return R,n;
end;
local E=N:GetChildren();
for d=1,#E,1 do
    N=E[d];
    if a(N,I)then
        d=(N:GetAttribute("Dead")~=true and 2 or 0)+(N:IsDescendantOf(K)and 1 or 0);
        if d>n then
            n,R=d,N;
        else
        end;
    else
    end;
end;
return R,n;
end;
local function N(I)local R=rawget(I,"folder"):GetAttribute("CombatantId");
if R==nil then
    return nil;
end;
local n=rawget(I,"m");
if n then
    if n.Parent then
        if n:GetAttribute("Dead")~=true then
            if n:IsDescendantOf(K)then
                if a(n,R)then
                    return n;
                end;
            end;
        end;
    end;
end;
local a=o();
if a<(rawget(I,"next")or 0)then
    return n and n.Parent and n or nil;
end;
rawset(I,"next",a+0.1);
a,n=B(K:FindFirstChild("Characters"),R,nil,-1);
a=if n<3 then
    B(b:FindFirstChild("_PVS_CulledCharacters"),R,a,n)
else
    a;
    rawset(I,"m",a);
    return a;
end;
local K={__index=function(o,a)local B=M[a];
if B then
    return B;
end;
B=rawget(o,"folder");
if a=="Character"then return N(o);
elseif  a=="Parent"then return B.Parent~=nil and S or nil;
elseif  a=="Name"or a=="DisplayName"then local S=B:GetAttribute("DisplayName");
return type(S)=="string"and S or B.Name;
elseif  a=="UserId"then local S=B:GetAttribute("UserId");
return tonumber(S)or S;
elseif  a=="avatar"then return B:GetAttribute("AvatarUserId");
end;
return nil;
end,__tostring=function(S)return"npc:"..tostring(rawget(S,"folder").Name);
end
};
local function S()i=0;
table.clear(O);
table.clear(T);
for o,M in Y,nil,nil do
    i+=1;
    G[i]=M;
    local a=o:GetAttribute("ActorId");
    if a~=nil then
        O[a]=M;
    end;
    a=o:GetAttribute("UserId");
    if a~=nil then
        T[a]=M;
        o=tonumber(a);
        if o then
            T[o]=M;
        end;
    end;
end;
local o,M=#G,i;
for a=o,M+1,-1 do
    G[a]=nil;
end;
t.version=t.version+1;
end;
local function o(M)if M:IsA("Folder")then
    if Y[M]then
        return;
    end;
else
    return;
end;
local a=setmetatable({folder=M},K);
Y[M]=a;
S();
h.connect(M:GetAttributeChangedSignal("ActorId"),S);
for M=1,#x,1 do
    pcall(x[M],a);
end;
end;
local function M(a)local B=Y[a];
if not(B)then
    return;
end;
Y[a]=nil;
S();
for S=1,#p,1 do
    pcall(p[S],B);
end;
end;
local function S(a)if A==a then
    return;
end;
A=a;
h.connect(a.ChildAdded,o);
h.connect(a.ChildRemoved,M);
local A=a:GetChildren();
for M=1,#A,1 do
    o(A[M]);
end;
end;
t.list=function()local o=i;
return G,o;
end;
t.is=function(o)return type(o)=="table"and getmetatable(o)==K;
end;
t.actor=function(K)return K~=nil and O[K]or nil;
end;
t.key=function(K)if K==nil then
    return nil;
end;
return T[K]or T[tonumber(K)or K];
end;
t.on=function(K,o)if K then
    x[#x+1]=K;
end;
if o then
    p[#p+1]=o;
end;
end;
j=b:FindFirstChild("Combatants");
if j then
    S(j);
end;
h.connect(b.ChildAdded,function(j)if j.Name=="Combatants"then if j:IsA("Folder")then
    S(j);
end;
end;
end);
h.teardown(function()table.clear(Y);
table.clear(O);
table.clear(T);
table.clear(x);
table.clear(p);
table.clear(G);
i=0;
end);
return t;
end;
D.h=function()local j,h,b,K=D.load("b"),D.load("f"),D.load("a"),D.load("g");
local S=j.players;
local o,t,G,i=h.trim,{},0,true;
local h=-1;
local function Y()i=true;
end;
local function O()i=true;
task.defer(Y);
end;
b.connect(S.PlayerAdded,Y);
b.connect(S.PlayerRemoving,O);
j={all=function()local Y,O=i;
if Y then
    O=Y;
else
    local T=h;
    O=T~=K.version;
end;
if O then
    i=false;
    h=K.version;
    Y=S:GetPlayers();
    local h=#Y;
    for S=1,h,1 do
        t[S]=Y[S];
    end;
    local S,Y=K.list();
    for K=1,Y,1 do
        h+=1;
        t[h]=S[K];
    end;
    o(t,h);
    G=h;
end;
O=G;
return t,O;
end,reset=function()o(t,0);
G,i=0,true;
end
};
b.teardown(j.reset);
return j;
end;
D.i=function()return{vis=true,aim=false,mem=30,age=0.3,err=24,peek=0.25,visualAge=0.25};
end;
D.j=function()local j=D.load("b").storage;
local function h(...)local b=j;
for j=1,select("#",...),1 do
    local K,S=pcall(b.WaitForChild,b,select(j,...),5);
    if K then
        if not(S)then
            return nil;
        end;
    else
        return nil;
    end;
    b=S;
end;
local j,K=pcall(require,b);
if j then
    return K;
end;
return nil;
end;
local j={weapon=h("Components","Weapon"),bullet=h("Components","Weapon","Classes","Bullet"),grenade=h("Components","Grenade"),raycast=h("Shared","Raycast"),ray_ignore=h("Components","Common","GetRayIgnore"),remotes=h("Database","Security","Remotes"),camera=h("Controllers","CameraController"),local_char=h("Controllers","CharacterController","LocalCharacter"),inventory=h("Controllers","InventoryController"),data=h("Controllers","DataController"),hints=h("Controllers","HintController"),spectate=h("Controllers","SpectateController"),runstep=h("Controllers","RunServiceController"),pose=h("Components","Common","CharacterPose"),char_velocity=h("Components","Common","GetCharacterVelocity"),char_resolver=h("Components","Common","CharacterResolver"),skin_info=h("Components","Common","GetResolvedSkinInformation"),weapon_props=h("Components","Common","GetWeaponProperties"),skins=h("Database","Components","Libraries","Skins"),buy_area=h("Database","Components","Common","IsInBuyArea"),buy_menu=h("Interface","Screens","Gameplay","Middle","BuyMenu"),defuse_ui=h("Interface","Screens","Gameplay","Middle","DefuseBomb"),crosshair=h("Interface","Screens","Gameplay","Middle","Crosshair"),mv_runtime=h("MovementV2","Client","Runtime"),constants=h("Database","Custom","Constants"),nade_sim=h("Shared","GrenadeSimulator"),kinematics=h("MovementV2","RuntimeKinematics"),snap_codec=h("MovementV2","RemoteSnapshotCodec"),root_frame=h("MovementV2","RootFrame"),viewmodel=h("Classes","WeaponComponent","Classes","Viewmodel"),character=h("Classes","Character"),flash_fx=h("Components","Common","VFXLibary","FlashEffect"),smoke_fx=h("Components","Common","VFXLibary","CreateVoxelSmoke"),tracer_fx=h("Components","Common","VFXLibary","CreateTracer"),vm_flash=h("Components","Common","VFXLibary","CreateMuzzleFlash","Camera"),emit_fx=h("Components","Common","VFXLibary","CreateMuzzleFlash","EmitParticles"),tp_model=h("Controllers","Observers","Players","Components","CreateWeaponModel"),platform=h("Components","Common","GetUserPlatform"),mobile_shoot=h("Controllers","MobileAutoShootController"),hit_flinch=h("Controllers","CharacterController","HitFlinch")};
local h,b=j.weapon,j.bullet;
j.fire_ready=type(h)=="table"and type(h.shoot)=="function";
j.legit_ready=type(b)=="table"and type(j.raycast)=="table"and type(j.ray_ignore)=="function";
return j;
end;
D.k=function()local j,h,b=D.load("b"),D.load("j"),D.load("g");
local K=j.lp;
local S=j.workspace;
local o,t=j.storage,h.kinematics;
local G=Vector3.zero;
local i=Vector3.new;
local Y=math.min;
local O=math.max;
local T,x,p=math.atan2,{["Counter-Terrorists"]=true,Terrorists=true},{run=19.5,walk=0.52,duck=0.34,scope=0.6};
h=o:FindFirstChild("MovementV2");
h=h and(h:FindFirstChild("SpeedProfile"));
if h then
    if h:IsA("ModuleScript")then
        j,o=pcall(require,h);
        if j then
            if type(o)=="table"then if type(o.TopSpeed)=="number"then if o.TopSpeed>0 then
                p.run=o.TopSpeed;
            end;
        end;
        if type(o.WalkModifier)=="number"then if o.WalkModifier>0 then
            p.walk=o.WalkModifier;
        end;
    end;
    if type(o.CrouchModifier)=="number"then if o.CrouchModifier>0 then
        p.duck=o.CrouchModifier;
    end;
end;
end;
end;
end;
end;
local j={spd=p,slots={}};
local h=j.slots;
local function o(A)local M=A.LookVector;
return T(-M.X,-M.Z);
end;
local function T(A,M)if t then
    if type(t.getVelocity)=="function"then local a,B=pcall(t.getVelocity,A,M);
    if a then
        if typeof(B)=="Vector3"then return B;
    end;
end;
end;
end;
return M.AssemblyLinearVelocity;
end;
local function t(A)if typeof(A)~="Vector3"then return G;
end;
return i(A.X,0,A.Z);
end;
j.slot=function(i)local A=h[i];
if A then
else
    A={plr=i,mode="none",pos=nil,at=0,hit=0,vel=G,yaw=0,err=0,gen=nil,live=nil,cur=nil,cerr=0,ghost=nil,stand=nil,duck=nil,snap=0,spos=nil,svel=G,syaw=0,dk=0,void=false,seen=nil,peek=0};
    h[i]=A;
end;
return A;
end;
j.drop=function(i)h[i]=nil;
end;
j.frozen=function()return S:GetAttribute("GameState")=="Buy Period";
end;
j.who=function(i)return typeof(i)=="Instance"or b.is(i);
end;
local function b(i)return i:GetAttribute("CharacterGeneration")or i:GetAttribute("Generation");
end;
j.dead=function(i)if i:GetAttribute("Dead")==true then
    return true;
end;
local A=i:GetAttribute("Health");
if type(A)=="number"then if A<=0 then
    return true;
end;
end;
local M=i.Character;
if M then
    if M:GetAttribute("Dead")==true then
        return true;
    end;
    A=M:GetAttribute("Health");
    if type(A)=="number"then if A<=0 then
        return true;
    end;
end;
end;
A=h[i];
return A~=nil and A.died~=nil and os.clock()-A.died<2 and A.died_gen==b(i);
end;
j.kill=function(h)h.died=os.clock();
h.died_gen=b(h.plr);
h.mode="none";
h.live=nil;
end;
j.enemy=function(h)if h==K then
    return false;
elseif  not(j.who(h))then
    return false;
end;
local i=h:GetAttribute("Team");
if not(x[i])then
    return false;
end;
if S:GetAttribute("Gamemode")=="Deathmatch"then return true;
end;
return i~=K:GetAttribute("Team");
end;
j.shown=function(h)local K=h.Character;
if K then
    if K.Parent then
        if not(K:IsDescendantOf(S))then
            return nil;
        end;
    else
        return nil;
    end;
else
    return nil;
end;
if K:GetAttribute("Dead")==true then
    return nil;
elseif  K:GetAttribute("ClientCharacterPresentationVisible")==false then
    return nil;
end;
h=K:FindFirstChild("HumanoidRootPart");
if h then
    if not(h:IsA("BasePart"))then
        return nil;
    end;
else
    return nil;
end;
return K,h;
end;
j.spawn=function(h,K,S)local i=h.plr;
local x,A,M=i:GetAttribute("PresentationSpawnPosition"),i:GetAttribute("PresentationSpawnYaw"),1;
h.stand=nil;
h.duck=nil;
h.pos=nil;
h.cur=nil;
h.live=nil;
h.visualPosition=nil;
h.visualTime=nil;
h.visualAt=nil;
h.at=K;
h.void=false;
h.seen=nil;
if S then
    if K-h.snap<1 and h.spos then
        x,A,M=h.spos,h.syaw,0.3;
    else
        x=if j.frozen()then
            x
        else
            nil;
        end;
    else
    end;
    if typeof(x)~="Vector3"then h.mode="none";
    h.live=nil;
    return;
end;
h.pos=x;
h.at=K;
h.hit=0;
h.vel=G;
h.err=M;
h.yaw=type(A)=="number"and A or 0;
h.mode="est";
end;
j.snap=function(h,K,S,i,x,A)h.snap=A;
h.spos=K;
h.svel=t(S);
h.syaw=type(i)=="number"and i or h.syaw;
h.dk=type(x)=="number"and x or 0;
if h.mode=="live"then return;
elseif  j.dead(h.plr)then
    return;
end;
h.pos=K;
h.vel=h.svel;
h.yaw=h.syaw;
h.at=A;
h.hit=A;
h.err=0.3;
h.mode="est";
h.void=false;
h.seen=nil;
end;
j.sync=function(h,K,S)local i=h.plr;
if j.dead(i)then
    h.mode="none";
    h.live=nil;
    return;
end;
local x=b(i);
if x~=h.gen then
    local b=h.gen==nil;
    h.gen=x;
    j.spawn(h,K,b);
end;
local b,A=j.shown(i);
if b then
    x=A.CFrame;
    h.pos=x.Position;
    h.vel=t(T(b,A));
    h.yaw=o(x);
    h.at=K;
    h.hit=K;
    h.err=0.5;
    h.mode="live";
    h.live=b;
    h.void=false;
    h.seen=nil;
    return;
end;
if h.mode=="live"then h.mode="est";
h.live=nil;
h.void=false;
h.seen=nil;
if h.spos then
    if K-h.snap<0.25 then
        h.pos=h.spos;
        h.vel=h.svel;
        h.yaw=h.syaw;
        h.at=h.snap;
        h.hit=h.snap;
        h.err=0.3;
    else
        h.at=K;
    end;
else
    h.at=K;
end;
end;
if S then
    if h.mode=="est"then h.at=K;
    h.vel=G;
end;
end;
end;
j.crouched=function(h,b)if b-h.snap<0.5 then
    return h.dk>=0.5;
end;
return h.plr:GetAttribute("IsCrouching")==true;
end;
j.guess=function(h,b)local K,S=h.pos,b-h.at;
if K then
    if S<=0 then
        return K,h.err;
    end;
else
    return K,h.err;
end;
local o=h.plr;
local t,G=if j.crouched(h,b)then
    p.run*p.duck
else
    if o:GetAttribute("IsWalking")==true then
        p.run*p.walk
    else
        if o:GetAttribute("IsSniperScoped")==true then
            p.run*p.scope
        else
            p.run,h.vel;
            local b,o,i=G.Magnitude,K+G*Y(S,0.3),S-0.3;
            if i<=0 then
                return o,h.err;
            end;
            return if b>0.5 then
                if t>0 then
                    o+G*(Y(b,t)/b*Y(i,1.5))
                else
                    o
                else
                    o,h.err+i*O(t,3);
                end;
                return j;
            end;
            D.l=function()local j,h=D.load("b"),D.load("a");
            local b=j.storage;
            local K=math.clamp;
            local S=Vector3.new;
            local o,t=Vector3.one,{"Head","UpperTorso","LowerTorso","LeftUpperArm","LeftLowerArm","LeftHand","RightUpperArm","RightLowerArm","RightHand","LeftUpperLeg","LeftLowerLeg","LeftFoot","RightUpperLeg","RightLowerLeg","RightFoot"};
            local G=Instance.new("Folder");
            h.own(G);
            local i={};
            local Y=j.weak();
            local j={names=t,owners=Y};
            local function O(T)local x=T:FindFirstChild("HumanoidRootPart");
            if x then
                if not(x:IsA("BasePart"))then
                    return nil;
                end;
            else
                return nil;
            end;
            local p,A,M,a=x.CFrame:Inverse(),{},{},0;
            for B=1,#t,1 do
                local N=t[B];
                B=T:FindFirstChild(N);
                if B then
                    if B:IsA("BasePart")then
                        A[N]=p*B.CFrame;
                        M[N]=B.Size;
                        a+=1;
                    else
                    end;
                else
                end;
            end;
            if a<8 then
                return nil;
            end;
            return{off=A,size=M,root=x.Size};
        end;
        j.grab=O;
        local function T(x)local p={};
        for A,M in x.off,nil,nil do
            p[A]=M-S(0,1.35*K((M.Position.Y+3)/4.4,0,1),0);
        end;
        return{off=p,size=x.size,root=x.root};
    end;
    j.kit=function(K)if type(K)~="string"then return nil;
end;
local x=i[K];
if x then
    return x;
end;
x=b:FindFirstChild("Assets");
x=x and(x:FindFirstChild("Characters"));
local b=x and(x:FindFirstChild(K));
x=b and O(b)or nil;
i[K]=x or false;
return x;
end;
j.learn=function(b,K,x,p)local A=x and"duck"or"stand";
if b.stance~=A then
    b.stance=A;
    b.since=p;
    return;
end;
if p-(b.since or 0)<0.35 then
    return;
elseif  p-(b.learnt or 0)<0.25 then
    return;
end;
x=O(K);
if x then
    b.learnt=p;
    b[A]=x;
end;
end;
j.pick=function(b,K)if K then
    if b.duck then
        return b.duck;
    end;
end;
local x=b.stand;
if not x then
    local p=b.plr.Character;
    x=p and p.Parent and p:GetAttribute("Dead")~=true and O(p)or false;
    b.stand=x;
else
end;
x=x or j.kit(j.look(b.plr));
if not(x)then
    return b.duck;
end;
if not(K)then
    return x;
end;
K=x.low;
if K then
else
    K=T(x);
    x.low=K;
end;
return K;
end;
local function b(K,O,T)local x=Instance.new("Part");
x.Name=K;
x.Size=O;
x.Anchored=true;
x.CanCollide=false;
x.CanQuery=false;
x.CanTouch=false;
x.CastShadow=false;
x.Massless=true;
x.Transparency=1;
x.Parent=T;
return x;
end;
j.look=function(K)return K:GetAttribute("PresentationCharacterName")or K:GetAttribute("CharacterName");
end;
j.ghost=function(K,O)local T,x=j.look(K.plr)or"?",K.ghost;
if x and x.key==T and x.model.Parent==G then
    if x.src~=O.size then
        x.src=O.size;
        for p,A in x.parts,nil,nil do
            local M=O.size[p];
            if M then
                if A.Size~=M then
                    A.Size=M;
                end;
            end;
        end;
    end;
    return x;
end;
if x then
    Y[x.model]=nil;
    pcall(x.model.Destroy,x.model);
end;
local p=Instance.new("Model");
p.Name=K.plr.Name;
local A,M=b("HumanoidRootPart",O.root or S(2,2,1),p),{};
for S=1,#t,1 do
    local a=t[S];
    M[a]=b(a,O.size[a]or o,p);
end;
p.PrimaryPart=A;
p:SetAttribute("CharacterType","PlayerCustomCharacter");
p:SetAttribute("Dead",false);
p.Parent=G;
x={model=p,root=A,parts=M,key=T,src=O.size};
K.ghost=x;
Y[p]=K.plr;
return x;
end;
j.place=function(b,K,S)b.root.CFrame=S;
local o=K.off;
for t,G in b.parts,nil,nil do
    K=o[t];
    if K then
        G.CFrame=S*K;
    end;
end;
end;
j.mirror=function(b,K)local S,o=b.model,K:GetAttribute("Health");
if b.hp~=o then
    b.hp=o;
    S:SetAttribute("Health",o);
end;
o=K:GetAttribute("MaxHealth");
if b.cap~=o then
    b.cap=o;
    S:SetAttribute("MaxHealth",o);
end;
end;
j.drop=function(b)local K=b.ghost;
b.ghost=nil;
if K then
    Y[K.model]=nil;
    pcall(K.model.Destroy,K.model);
end;
end;
h.teardown(function()table.clear(i);
end);
return j;
end;
D.m=function()local j,h=D.load("b"),D.load("a");
local b,K=D.load("j"),D.load("g");
local S=D.load("k");
local o=j.players;
local j=b.remotes;
local b,t=S.slots,{};
local function G(i)if type(i)~="table"then return;
end;
local Y=tonumber(i.Victim);
if not(Y)then
    return;
end;
i=Y>0 and o:GetPlayerByUserId(Y)or K.key(Y);
Y=i and b[i];
if Y then
    S.kill(Y);
end;
end;
local b=false;
t.start=function()if b then
    return;
end;
b=true;
h.spawn(function()local b=j and j.UI;
local j=type(b)=="table"and b.UIPlayerKilled or nil;
if type(j)~="table"then return;
elseif  type(j.Listen)~="function"then return;
end;
local b,K=pcall(j.Listen,function(j)pcall(G,j);
end);
if b then
    if type(K)=="function"then h.adopt(K);
end;
end;
end);
end;
return t;
end;
D.n=function()local j,h=D.load("b"),D.load("a");
local b,K=D.load("j"),D.load("g");
local S=D.load("i");
local o=D.load("k");
local t=j.lp;
local G=j.players;
local i=j.storage;
local j,Y,O=b.snap_codec,b.root_frame,os.clock;
local b=Vector3.new;
local T=type(j)=="table"and j.decode or nil;
local x=type(j)=="table"and j.applyDeltaToCanonicalBaseline or nil;
local j,p,A=type(Y)=="table"and Y.simulationToVisualRootPosition or nil,{};
local Y,M={};
local a={};
local B,N,I=-1,{},{tick=-1,at=0,codecReady=T~=nil,connected=false};
local function R(n)local E,d=n.Position,n.DuckAmount or 0;
if j then
    local n,w=pcall(j,E,d);
    if n then
        if typeof(w)=="Vector3"then return w;
    end;
end;
end;
return E-b(0,(d>=0.999 and 4.05 or 5.4)*0.5-3,0);
end;
local function j(b)if type(b)~="number"then return nil;
elseif  b<=0 then
    return nil;
end;
local n=N[b];
if not n or n.Parent~=G then
    n=G:GetPlayerByUserId(b)or false;
    N[b]=n;
else
end;
return n or nil;
end;
local function b(n,E)for d,w in n,nil,nil do
    d=j(w.UserId)or K.actor(w.ActorId);
    if d then
        if d~=t then
            if o.enemy(d)then
                o.snap(o.slot(d),R(w),w.Velocity,w.LookYaw,w.DuckAmount,E);
            end;
        end;
    end;
end;
end;
local function j(K,o)local t=K.Sequence;
if t==A then
    return;
end;
if t~=M then
    M,Y=t,{};
    table.clear(a);
end;
local R=K.ChunkIndex or 0;
if a[R]then
    return;
end;
a[R]=true;
R=K.Actors or{};
for n,E in R,nil,nil do
    n=Y;
    n[E.ActorId]=E;
end;
local n=K.ServerTick;
if type(n)=="number"then if n>=B then
    B=n;
    I.tick=n;
    I.at=o;
    b(R,o);
end;
end;
R,o=K.ChunkCount or 1,0;
for K in a,nil,nil do
    o+=1;
end;
if o>=R then
    p,A,Y,M=Y,t,{},nil;
    table.clear(a);
end;
end;
local function K(o,t)local R=o.ServerTick;
if type(R)~="number"then return;
elseif  R<=B then
    return;
end;
B=R;
I.tick=R;
I.at=t;
local B,n={},0;
if o.BaselineSequence==A then
    R={};
    for E,E in o.RemovedActorIds or{},nil,nil do
        R[E]=true;
    end;
    local E={};
    if x then
        local d=o.Deltas or{};
        for w,P in d,nil,nil do
            w=p;
            local d=w[P.ActorId];
            if d then
                if not(R[P.ActorId])then
                    local w,r=pcall(x,d,P);
                    if w then
                        if type(r)=="table"then E[P.ActorId]=r;
                    end;
                end;
            end;
        end;
    end;
end;
local x=p;
for d,w in x,nil,nil do
    if R[d]then
    else
        n+=1;
        B[n]=E[d]or w;
    end;
end;
else
end;
for x,x in o.Actors or{},nil,nil do
    n+=1;
    B[n]=x;
end;
b(B,t);
end;
local function b(o)if S.vis then
    if not(T)then
        return;
    end;
elseif  S.aim then
    if not(T)then
        return;
    end;
else
    return;
end;
local S,t=pcall(T,o);
if S then
    if type(t)~="table"then return;
end;
else
    I.lastError=tostring(t);
    return;
end;
S=O();
if t.Kind=="Baseline"then j(t,S);
elseif  t.Kind=="Delta"then K(t,S);
end;
end;
local j=false;
I.start=function()if j then
    return;
elseif  not(T)then
    return;
end;
j=true;
h.spawn(function()local j=i:WaitForChild("MovementV2Remotes",30);
local K=j and(j:WaitForChild("RemoteSnapshot",30));
if not(K)then
    return;
end;
I.connected=true;
h.connect(K.OnClientEvent,function(j)local ok,err=pcall(b,j);
if not ok then I.lastError=tostring(err); end;
end);
end);
end;
h.connect(G.PlayerRemoving,function(j)N[j.UserId]=nil;
end);
h.teardown(function()table.clear(p);
table.clear(Y);
table.clear(a);
table.clear(N);
A,M=nil,nil;
end);
return I;
end;
D.o=function()local j,h=D.load("b"),D.load("a");
local b=j.workspace;
local K=j.collection;
local S=j.lp;
local j=os.clock;
local o=string.lower;
local t,G,i,Y,O=string.sub,{barriers=true,pvscells=true,pvsvolumes=true,pvsstaticocclusion=true,pvsvisibilitygeometry=true},{"BreakableDoor","BreakableGlass","Ceiling Fan","Flag","Flower Pot","Garage","Market Window","Snowman","Television","TugBoat","Vent","VertigoCar","VertigoCrane","VertigoGenerator","Water"},{"BreakableDoor","BreakableGlass","Garage","Market Window","Vent"},{};
O[Enum.Material.Glass]=true;
O[Enum.Material.ForceField]=true;
local T={["Counter-Terrorists"]=true,Terrorists=true};
local x=Enum.AlphaMode.Transparency;
local p=RaycastParams.new();
p.FilterType=Enum.RaycastFilterType.Include;
p.IgnoreWater=true;
p.RespectCanCollide=false;
local A,M={ready=false};
local a=0;
local function B(N,I)return N:GetAttribute(I)==true or K:HasTag(N,I);
end;
local function N(I,R)for n=1,#R,1 do
    if K:HasTag(I,R[n])then
        return true;
    end;
end;
return false;
end;
local function K(I)return B(I,"PVSIgnore")or B(I,"PVSDynamic")or N(I,i);
end;
local function i(I)local R=o(I);
return G[R]==true or t(R,1,24)=="__pvsvisibilityobjstage_";
end;
local function o(t)if t.Anchored then
    if O[t.Material]then
        return false;
    elseif  t.Transparency>0.01 then
        return false;
    end;
else
    return false;
end;
local G=t:GetChildren();
for O=1,#G,1 do
    t=G[O];
    if t:IsA("SurfaceAppearance")then
        if t.AlphaMode==x then
            return false;
        end;
    end;
end;
return true;
end;
local function t(G)return G:GetAttribute("PVSNegativeAuthority")~=nil or G:GetAttribute("PVSVisibilityGeometryVersion")~=nil or G:GetAttribute("PVSVisibilityGeometryComplete")~=nil or G:GetAttribute("PVSVisibilityGeometryFingerprint")~=nil;
end;
local function G(O,x,I)if i(O.Name)then
    return 0;
end;
local R,n,E,d,w,P,r={O},{B(O,"PVSOccluder")},{K(O)},1,0,0,(j());
while d>0 do
    local L,Z,X=R[d],n[d],E[d];
    R[d]=nil;
    n[d]=nil;
    E[d]=nil;
    d-=1;
    if Z then
        if X then
        else
            if L:IsA("BasePart")then
                if o(L)then
                    O=w+1;
                    x[O]=L;
                    w=O;
                else
                end;
            else
            end;
        end;
    else
    end;
    local o=L:GetChildren();
    for O=1,#o,1 do
        L=o[O];
        if i(L.Name)then
        else
            d+=1;
            R[d]=L;
            n[d]=Z or B(L,"PVSOccluder");
            E[d]=X or K(L);
        end;
    end;
    P+=1;
    if P%64==0 then
        if j()-r>0.004 then
            task.wait();
            if not(I())then
                return nil;
            end;
            r=(j());
        else
        end;
    else
    end;
end;
return w;
end;
local function K(o,i,O)local x=o:FindFirstChild("Barriers")or o:FindFirstChild("Barriers",true);
if not(x)then
    return 0;
end;
o=x:GetDescendants();
o[#o+1]=x;
local B,I=0,(j());
for R=1,#o,1 do
    local n=o[R];
    if n:IsA("BasePart")and n.CanQuery and(n:IsA("Part")or n:IsA("WedgePart")or n:IsA("CornerWedgePart"))then
        local o,E=n,false;
        while o do
            local d=E;
            if o:GetAttribute("PVSIgnore")==true or N(o,Y)then
                E=true;
                break;
            end;
            if o==x then
                E=d;
                break;
            end;
            o=o.Parent;
        end;
        if E then
        else
            B+=1;
            i[B]=n;
        end;
    else
    end;
    if R%64==0 then
        if j()-I>0.004 then
            task.wait();
            if not(O())then
                return nil;
            end;
            I=(j());
        else
        end;
    else
    end;
end;
return B;
end;
local function j(o)a+=1;
local i=a;
M=o;
A.ready=false;
p.FilterDescendantsInstances={};
if not o then
    return;
end;
h.spawn(function()local function Y()local O=a==i and o.Parent~=nil;
return O;
end;
for i=1,5,1 do
    if not(Y())then
        return;
    end;
    local O,x={},t(o);
    local t=(x and G or K)(o,O,Y);
    if t then
        if not(Y())then
            return;
        end;
    else
        return;
    end;
    local K=x and tonumber(o:GetAttribute("PVSVisibilityExportExpectedParts"))or nil;
    if t>0 and((if K then
        t>=K*0.9
    else
        not K)or i==5)then
            x=b:FindFirstChildOfClass("Terrain");
            if x then
                O[t+1]=x;
            end;
            p.FilterDescendantsInstances=O;
            A.ready=true;
            return;
        end;
        task.wait(2);
    end;
end);
end;
local function K()local o=b:FindFirstChild("Map");
if o then
    if o:GetAttribute("MapName")~=nil then
        return o;
    end;
end;
return nil;
end;
A.sync=function()local o=K();
if o~=M then
    j(o);
end;
return A.ready;
end;
A.eye=function()if A.ready then
    if not(T[S:GetAttribute("Team")])then
        return nil;
    end;
else
    return nil;
end;
local j=S.Character;
if j then
    if j:GetAttribute("Dead")~=false then
        return nil;
    elseif  not(j:IsDescendantOf(b))then
        return nil;
    end;
else
    return nil;
end;
local K=j:FindFirstChild("CameraPart")or j:FindFirstChild("Head");
if K then
    if K:IsA("BasePart")then
        return K.Position;
    end;
end;
return nil;
end;
A.clear=function(j,K)return b:Raycast(j,K-j,p)==nil;
end;
h.teardown(function()a+=1;
M=nil;
A.ready=false;
p.FilterDescendantsInstances={};
end);
return A;
end;
D.p=function()local j,h,b=D.load("b"),D.load("a"),D.load("h");
local K,S=D.load("g"),D.load("i");
local o=D.load("k");
local t=D.load("l");
local G,i,Y=D.load("m"),D.load("n"),D.load("o");
local O,T=j.players,j.lp;
local j=os.clock;
local x=o.slots;
local p=t.owners;
local A=math.clamp;
local M=math.min;
local a=CFrame.new;
local B,N=CFrame.Angles,{cfg=S,state=o,snap=i,sight=Y};
local function I(R)local n=x[R];
if n then
    t.drop(n);
    o.drop(R);
end;
end;
local function R(n,E)return n.mode=="est"and not n.void and n.ghost~=nil and n.cur~=nil and E-n.at<=S.mem and n.cerr<=S.err;
end;
local function n(E,d,w,P,r)if P-E.peek<0.05 then
    return;
end;
E.peek=P;
local L=d.parts;
local d,Z=L.Head,L.UpperTorso;
if d and Y.clear(w,d.Position)or Z and Y.clear(w,Z.Position)then
    L=E.seen;
    if L then
        if P-L>=r then
            E.void=true;
        end;
    else
        E.seen=P;
    end;
else
    E.seen=nil;
end;
end;
local function updateEspPlayer(player,now,frozen,eye,peekDelay)
    if not o.enemy(player) then
        if x[player] then I(player); end;
        return;
    end;
    local slot=o.slot(player);
    o.sync(slot,now,frozen);
    if slot.mode=="live" then
        slot.visualPosition=slot.pos;
        slot.visualTime=now;
        slot.visualAt=nil;
        t.learn(slot,slot.live,o.crouched(slot,now),now);
    elseif slot.mode=="est" then
        local position,errorRadius=o.guess(slot,now);
        slot.cur=position;
        slot.cerr=errorRadius;
        local age=now-(slot.hit or 0);
        if not slot.pos or (slot.hit or 0)<=0 or age<0 or age>(S.visualAge or 0.25) then
            slot.visualPosition=nil;
            slot.visualTime=nil;
            slot.visualAt=nil;
            return;
        end;
        local template=t.pick(slot,o.crouched(slot,now));
        if not template then slot.visualAt=nil; return; end;
        local ghost=t.ghost(slot,template);
        local target=slot.pos;
        local previous=slot.visualPosition;
        local dt=math.max(0,now-(slot.visualTime or now));
        if previous and dt<0.25 and (target-previous).Magnitude<10 then
            target=previous:Lerp(target,1-math.exp(-dt/0.05));
        end;
        slot.visualPosition=target;
        slot.visualTime=now;
        t.place(ghost,template,a(target)*B(0,slot.yaw,0));
        t.mirror(ghost,player);
        slot.visualAt=now;
        if eye and R(slot,now) then n(slot,ghost,eye,now,peekDelay); end;
    else
        slot.visualPosition=nil;
        slot.visualTime=nil;
        slot.visualAt=nil;
    end;
end;
N.step=function()
    if not S.vis and not S.aim then return; end;
    local now,frozen=j(),o.frozen();
    local eye=Y.sync()and Y.eye()or nil;
    local peekDelay=S.peek+A(tonumber(T:GetAttribute("Ping"))or 100,0,500)/1000;
    local players,count=b.all();
    for index=1,count do
        local ok,err=pcall(updateEspPlayer,players[index],now,frozen,eye,peekDelay);
        if not ok then
            N.lastError=tostring(players[index])..": "..tostring(err);
        end;
    end;
end;
N.char=function(b)if S.vis then
    if not(o.who(b))then
        return nil;
    end;
else
    return nil;
end;
local Y=x[b];
if not(Y)then
    return nil;
end;
if Y.mode=="live"then return Y.live;
end;
if Y.mode=="est" and Y.pos and Y.ghost and Y.ghost.model.Parent and not o.dead(b) and (Y.hit or 0)>0 and j()-Y.hit<=(S.visualAge or 0.25) and Y.visualAt and j()-Y.visualAt<=0.1 then
    return Y.ghost.model;
end;
return false;
end;
N.armed=function(b,Y)if not(S.aim)then
    return false;
end;
local T=x[b];
return T~=nil and T.mode=="est"and not T.void and T.ghost~=nil and T.ghost.model==Y and j()-T.hit<=S.age;
end;
N.target=function(b)local Y=S.aim and x[b];
if Y then
    if Y.mode=="est"then if not(Y.void)then
        if Y.ghost then
            if j()-Y.hit<=S.age then
                return Y.ghost.model;
            end;
        end;
    end;
end;
end;
return b.Character;
end;
N.ghost=function(b)return b~=nil and p[b]~=nil;
end;
N.fade=function(b)return 1;
end;
N.info=function(b)local S=x[b];
if not(S)then
    return nil;
end;
return S.mode,S.cur or S.pos,S.cerr,j()-S.at,j()-S.snap,S.void;
end;
h.connect(O.PlayerRemoving,I);
K.on(nil,I);
h.teardown(function()for j,h in x,nil,nil do
    t.drop(h);
    x[j]=nil;
end;
end);
G.start();
i.start();
return N;
end;
D.q=function()local j=Color3.new(1,1,1);
local h={white=j};
h.black=Color3.new();
h.world={fog=false,fog_col=j,fog_start=0,fog_end=500,time=false,time_hour=12,bloom=false,bloom_power=100,bloom_size=24,bloom_limit=200,hands=false,hands_x=0,hands_y=0,hands_z=0,sky=false,sky_preset="jungle",fx=false,fx_type="snow",fx_col=j,fx_rate=250,ambient=false,ambient_col=j,exposure=false,exposure_val=0,fullbright=false,fb_col=j,fb_power=200,no_shadows=false,xhair=false,xhair_col=j,xhair_size=100,xhair_gap=6,force_xhair=false,pen=false,pen_yes=Color3.fromRGB(50,255,115),pen_no=Color3.fromRGB(255,65,75),pen_size=12,third=false,third_dist=10,cc=false,cc_tint=j,cc_sat=0,cc_bright=0,cc_contrast=0,body_chams=false,body_chams_col=j,body_chams_mat="forcefield",tool_chams=false,tool_chams_col=j,tool_chams_mat="forcefield",tool_chams_kinds=nil,hand_chams=false,hand_chams_col=j,hand_chams_mat="forcefield",tracers=false,tracers_col=j,tracers_width=0.05,tracers_life=1.2,impacts=false,impacts_col=j,impacts_life=3,bomb_esp=false,bomb_icon_col=j,bomb_timer_col=j,bomb_timer_grad=false,bomb_timer_grad_col=j,nade_path=false,nade_path_col=j,nade_radius_col=j,nade_path_width=2,nade_zones=false,smoke_zone_col=j,smoke_zone_icon=j,fire_zone_col=j,fire_zone_icon=j,nades_live=false,nade_icon_col=j,nade_dmg_col=j,esp_set=nil,view=nil,zonefill=nil};
h.misc={scope=false,flash=false,smoke=false,hands=false,bullets=false,auto_plant=false,auto_defuse=false,knife=false,knife_heavy=true,knife_range=3.5,zeus=false,zeus_range=12,auto_reload=false,auto_reload_min=1,auto_buy=false,buy_primary="AK-47",buy_secondary="USP-S",buy_zeus=false,buy_nades={},buy_dirty=true};
local b=Color3.fromRGB(133,220,255);
h.notify={master={hit=false,kill=false},log={hit=false,kill=false},fx={hit={on=false,col=b},kill={on=false,col=b}},screen={hit={on=false,col=b,power=100},kill={on=false,col=b,power=100}},marks={hit={on=false,col=j,size=18,fade=1},kill={on=false,col=j,size=18,fade=1}},sounds={hit={on=false,name="mc bow",vol=1},kill={on=false,name="skeet",vol=1}},list={"primordial","neverlose","sparkle","mc bow","skeet","break","rust","applepay","bubble","combobreak","killcard","xp","na naxuy","stony","hentai"}};
h.attach=function(j)h.world.esp_set=j.shSet;
h.world.view=j.ViewResolver;
end;
return h;
end;
D.t=function()local j=D.load("b");
local h,b=D.load("a"),j.guiservice;
local K=math.min;
local S=math.max;
local o,t,G=Vector2.new,{Line={"From","To"},Square={"Position","Size"},Image={"Position","Size"},Text={"Position"},Circle={"Position"},Triangle={"PointA","PointB","PointC"}},{};
for i,Y in t,nil,nil do
    local O={Visible=true};
    for T=1,#Y,1 do
        O[Y[T]]=true;
    end;
    G[i]=O;
end;
local i,Y,O,T,x,p,A,M,a={},0,0,{},0,{},0,{},{};
local function B(N,I,R,n,E)local d=Y;
for w=1,d,1 do
    local d=i[w];
    if N<d[3]+E then
        if R>d[1]-E then
            if I<d[4]+E then
                if n>d[2]-E then
                    return true;
                end;
            end;
        end;
    end;
end;
return false;
end;
local function N()Y=0;
local I=j.drawmask();
if not(I)then
    return;
end;
local j=#I;
if j==0 then
    return;
end;
local R=b:GetGuiInset();
for b=1,j,1 do
    local j=I[b];
    if typeof(j)=="Instance"then if j.Parent then
        if j.Visible then
            local I,n=j.AbsolutePosition,j.AbsoluteSize;
            if n.X>0.5 then
                if n.Y>0.5 then
                    Y+=1;
                    b=i[Y];
                    if b then
                    else
                        b={};
                        i[Y]=b;
                    end;
                    b[1]=I.X+R.X;
                    b[2]=I.Y+R.Y;
                    b[3]=b[1]+n.X;
                    b[4]=b[2]+n.Y;
                end;
            end;
        end;
    end;
end;
end;
end;
local function j(b,I)local R,n,E,d,w=b.X,b.Y,I.X,I.Y,Y;
local P=false;
for r=1,w,1 do
    local w,L,Z,X,q,U=i[r],E-R,d-n,0,1,true;
    if L==0 then
        U=if R<w[1]then
            false
        else
            if R>w[3]then
                false
            else
                U;
            else
                local z,J=(w[1]-R)/L,(w[3]-R)/L;
                if z>J then
                    z,J=J,z;
                else
                end;
                X,q=if z>X then
                    z
                else
                    X,if J<q then
                        J
                    else
                        q;
                    end;
                    if U then
                        if Z==0 then
                            U=if n<w[2]then
                                false
                            else
                                if n>w[4]then
                                    false
                                else
                                    U;
                                else
                                    local z,J=(w[2]-n)/Z,(w[4]-n)/Z;
                                    if z>J then
                                        z,J=J,z;
                                    else
                                    end;
                                    X,q=if z>X then
                                        z
                                    else
                                        X,if J<q then
                                            J
                                        else
                                            q;
                                        end;
                                    else
                                    end;
                                    if U then
                                        if X<=q then
                                            r=(L*L+Z*Z)^0.5;
                                            if X*r<1 then
                                                if(1-q)*r<1 then
                                                    return nil;
                                                end;
                                            end;
                                            if X>=1-q then
                                                local r,U=R+L*X,n+Z*X;
                                                E,d=r,U;
                                            else
                                                local r,X=R+L*q,n+Z*q;
                                                R,n=r,X;
                                            end;
                                            w=true;
                                            P=w;
                                        else
                                        end;
                                    else
                                    end;
                                end;
                                if not(P)then
                                    return b,I;
                                end;
                                return o(R,n),o(E,d);
                            end;
                            local function b(I,R)local n,E=I.X,I.Y;
                            local d,w,P=n+R.X,E+R.Y,Y;
                            local r=false;
                            for L=1,P,1 do
                                local P=i[L];
                                if n<P[3]then
                                    if d>P[1]then
                                        if E<P[4]then
                                            if w>P[2]then
                                                local Z,X,q,U,z=0;
                                                if P[2]>E then
                                                    L=K(w,P[2]);
                                                    local J=(d-n)*(L-E);
                                                    if J>Z then
                                                        Z,X,q,U,z=J,n,E,d,L;
                                                    else
                                                    end;
                                                else
                                                end;
                                                if P[4]<w then
                                                    local L=S(E,P[4]);
                                                    local J=(d-n)*(w-L);
                                                    if J>Z then
                                                        Z,X,q,U,z=J,n,L,d,w;
                                                    else
                                                    end;
                                                else
                                                end;
                                                if P[1]>n then
                                                    local L=K(d,P[1]);
                                                    local J=(L-n)*(w-E);
                                                    if J>Z then
                                                        Z,X,q,U,z=J,n,E,L,w;
                                                    else
                                                    end;
                                                else
                                                end;
                                                if P[3]<d then
                                                    local L=S(n,P[3]);
                                                    local P=(d-L)*(w-E);
                                                    if P>Z then
                                                        Z,n=P,L;
                                                    else
                                                        n,E,d,w=X,q,U,z;
                                                    end;
                                                else
                                                    n,E,d,w=X,q,U,z;
                                                end;
                                                if Z<=1 then
                                                    return nil;
                                                end;
                                                local P=true;
                                                r=P;
                                            else
                                            end;
                                        else
                                        end;
                                    else
                                    end;
                                else
                                end;
                            end;
                            if not(r)then
                                return I,R;
                            end;
                            return o(n,E),o(d-n,w-E);
                        end;
                        local function I(R)local n,E,d=R.d,R.w,R.keys;
                        for w=1,#d,1 do
                            local P=d[w];
                            n[P]=E[P];
                        end;
                        R.hid=false;
                        n.Visible=true;
                    end;
                    local function R(n)local E,d,w=n.d,n.w,n.cls;
                    if not(d.Visible)then
                        E.Visible=false;
                        n.hid=false;
                        return;
                    end;
                    if Y==0 then
                        I(n);
                        return;
                    end;
                    if w=="Line"then local P,r=j(d.From,d.To);
                    if not(P)then
                        E.Visible=false;
                        n.hid=true;
                        return;
                    end;
                    E.From=P;
                    E.To=r;
                    n.hid=false;
                    E.Visible=true;
                    return;
                end;
                if w=="Square"then if E.Filled then
                    local j,P=b(d.Position,d.Size);
                    if not(j)then
                        E.Visible=false;
                        n.hid=true;
                        return;
                    end;
                    E.Position=j;
                    E.Size=P;
                    n.hid=false;
                    E.Visible=true;
                    return;
                end;
            end;
            local j,b,P,r;
            if w=="Text"then local L,Z=d.Position,E.TextBounds;
            j=E.Center and L.X-Z.X*0.5 or L.X;
            b=j+Z.X;
            P,r=L.Y,L.Y+Z.Y;
        else
            if w=="Circle"then local L,Z=d.Position,E.Radius;
            j,P,b,r=L.X-Z,L.Y-Z,L.X+Z,L.Y+Z;
        else
            if w=="Triangle"then local w,L,Z=d.PointA,d.PointB,d.PointC;
            j,b,P=K(w.X,L.X,Z.X),S(w.X,L.X,Z.X),K(w.Y,L.Y,Z.Y);
            r=S(w.Y,L.Y,Z.Y);
        else
            local K,S=d.Position,d.Size;
            j,P,b,r=K.X,K.Y,K.X+S.X,K.Y+S.Y;
        end;
    end;
end;
if B(j,P,b,r,n.hid and 6 or 0)then
    E.Visible=false;
    n.hid=true;
    return;
end;
I(n);
end;
local function j(b)local K=M[b];
if not(K)then
    return;
end;
local S=T[x];
local I=M[S];
T[K.i]=S;
if I then
    I.i=K.i;
end;
T[x]=nil;
x-=1;
if K.mi>0 then
    S=p[A];
    I=M[S];
    p[K.mi]=S;
    if I then
        I.mi=K.mi;
    end;
    p[A]=nil;
    A-=1;
end;
M[b]=nil;
end;
local function b(K)local S=M[K];
if not(S)then
    return;
end;
j(K);
pcall(S.d.Remove,S.d);
end;
local K={__index=function(S,I)local n=M[S];
if not(n)then
    return nil;
end;
if I=="Remove"then return b;
elseif  I=="Destroy"then return b;
end;
if n.tr[I]then
    return n.w[I];
end;
return n.d[I];
end,__newindex=function(b,S,I)local n=M[b];
if not(n)then
    return;
end;
if not(n.tr[S])then
    b=n.u;
    if b[S]~=I then
        b[S]=I;
        n.d[S]=I;
    end;
    return;
end;
b=n.w[S];
if b~=I then
    n.w[S]=I;
    if Y==0 then
        n.d[S]=I;
    elseif  n.mi==0 then
        n.d[S]=I;
    else
        R(n);
    end;
end;
end
};
local function b(S,I)return S[I];
end;
a.new=function(S,I)local n,E,d,w=Drawing.new(S),G[S]or G.Square,t[S]or t.Square,{};
for t in E,nil,nil do
    local G,P=pcall(b,n,t);
    if G then
        w[t]=P;
    end;
end;
if w.Visible==nil then
    w.Visible=false;
end;
for b=1,#d,1 do
    local t=d[b];
    if w[t]==nil then
        w[t]=o();
    end;
end;
local b=setmetatable({},K);
x+=1;
T[x]=b;
local K={d=n,cls=S,tr=E,keys=d,w=w,u={},hid=false,i=x,mi=0};
M[b]=K;
if I then
    A+=1;
    p[A]=b;
    K.mi=A;
end;
return b;
end;
a.mask_step=function()if not(pcall(N))then
    Y=0;
end;
local b=A>0 and(Y>0 or O>0);
if b then
    local b=A;
    for K=b,1,-1 do
        local b=p[K];
        K=M[b];
        if K then
            if not(pcall(R,K))then
                j(b);
            end;
        end;
    end;
end;
O=Y;
end;
a.count=function()local j=x;
return j;
end;
a.mask_active=function()local j=Y;
return j>0;
end;
a.mask_test=function(j,b,K,S)if Y==0 then
    return false;
end;
return B(j,b,K,S,0);
end;
a.purge=function()local j=x;
for b=j,1,-1 do
    local K=T[b];
    if K then
        local S=M[K];
        if S then
            pcall(S.d.Remove,S.d);
            M[K]=nil;
        end;
    end;
    T[b]=nil;
end;
j=A;
for b=j,1,-1 do
    p[b]=nil;
end;
x,A,Y,O=0,0,0,0;
table.clear(M);
table.clear(i);
end;
h.teardown(a.purge);
return a;
end;
D.u=function()local j=D.load("a");
local h=string.byte;
local b=string.char;
local K,S,o,t=string.sub,{},3,3;
local G,i=Drawing and rawget(Drawing,"Fonts");
if type(G)=="table"then if type(rawget(G,"Monospace"))=="number"then o=G.Monospace;
else
end;
for Y,Y in G,nil,nil do
    if type(Y)=="number"and Y>t then
        t=Y;
    else
    end;
end;
i=o;
else
    i=o;
end;
S.numeric=i;
local o,G,Y=i,0.5;
S.face=function()local O=o;
return O;
end;
S.bounds=function(O,T)local x=Y;
if not(x)then
    local p,A=#T*O,G;
    return p*A,O;
end;
local p=0;
for A=1,#T,1 do
    p+=x[h(T,A)];
end;
return p*O,O;
end;
S.advance=function(h)local O=G;
return h*O;
end;
local function h(O)return type(O)=="string"and#O>20000 and K(O,1,4)=="\0\1\0\0";
end;
local function K()if type(isfile)=="function"then if type(readfile)=="function"then local O,T=pcall(isfile,"bs_inter_600.ttf");
if O then
    if T then
        local O,T=pcall(readfile,"bs_inter_600.ttf");
        if O then
            if h(T)then
                return T;
            end;
        end;
    end;
end;
end;
end;
local O,T=pcall(game.HttpGet,game,"https://fonts.gstatic.com/s/inter/v20/UcCO3FwrK3iLTeHuS_nVMrMxCp50SjIw2boKoduKmMEVuGKYMZg.ttf");
if O then
    if not(h(T))then
        return nil;
    end;
else
    return nil;
end;
if type(writefile)=="function"then pcall(writefile,"bs_inter_600.ttf",T);
end;
return T;
end;
local function h()local O=j.shared.font;
if type(O)=="table"then if O.src=="https://fonts.gstatic.com/s/inter/v20/UcCO3FwrK3iLTeHuS_nVMrMxCp50SjIw2boKoduKmMEVuGKYMZg.ttf"then local T,x=pcall(function()return O.item.Font;
end);
if T then
    if x==O.id then
        return x;
    end;
end;
end;
end;
local O=K();
if not O then
    return nil;
end;
local K,T=pcall(Drawing.new,"Font");
if K then
    if not T then
        return nil;
    end;
else
    return nil;
end;
local K,x=pcall(function()T.Data=O;
return T.Font;
end);
if(if K then
    type(x)~="number"else not K)or x<=t then
        pcall(T.Remove,T);
        return nil;
    end;
    j.shared.font={item=T,id=x,src="https://fonts.gstatic.com/s/inter/v20/UcCO3FwrK3iLTeHuS_nVMrMxCp50SjIw2boKoduKmMEVuGKYMZg.ttf"};
    return x;
end;
local function K(t)local O,T=pcall(Drawing.new,"Text");
if O then
    if not T then
        return nil;
    end;
else
    return nil;
end;
local x,p,A={},0,0;
O=pcall(function()T.Visible=false;
T.Center=false;
T.Outline=false;
T.Font=t;
T.Size=64;
for t=32,126,1 do
    T.Text=b(t);
    local b=T.TextBounds;
    local M=typeof(b)=="Vector2"and b.X/64 or 0;
    x[t]=M;
    if t>32 then
        p+=M;
        A+=1;
    end;
end;
end);
pcall(T.Remove,T);
if O then
    if A==0 then
        return nil;
    elseif  x[87]>x[105]then
        if not(x[105]>0)then
            return nil;
        end;
    else
        return nil;
    end;
else
    return nil;
end;
O=p/A;
for b=0,31,1 do
    x[b]=O;
end;
x[127]=O;
for b=128,191,1 do
    x[b]=0;
end;
for b=192,255,1 do
    x[b]=O;
end;
return x,O;
end;
local function b()local t=Drawing.new("Text");
t.Visible=false;
t.Center=false;
t.Outline=false;
t.Font=i;
t.Size=16;
t.Text="ABCDEFGHIJKLMNOPQRST";
local i=game:GetService("RunService");
i.RenderStepped:Wait();
i.RenderStepped:Wait();
i=t.TextBounds;
if typeof(i)=="Vector2"then if i.X>1 then
    local O=i.X/20/16;
    if O>0.2 then
        if O<2 then
            G=O;
        end;
    end;
end;
end;
pcall(t.Remove,t);
end;
local function t()local i=h();
if i then
    local h,O=K(i);
    if h then
        Y,G,o=h,O,i;
        return;
    end;
end;
b();
end;
j.spawn(t);
return S;
end;
D.v=function()local j=D.load("a");
local h=D.load("t");
local b,K,S=D.load("u"),{},1;
K.scale=function(o)S=o or 1;
end;
K.k=function()local o=S;
return o;
end;
local o=type(DrawingImmediate)=="table"and type(DrawingImmediate.GetPaint)=="function"and type(DrawingImmediate.FilledRectangle)=="function";
K.immediate=o;
if o then
    local o=DrawingImmediate.Line;
    local t=DrawingImmediate.Rectangle;
    local G=DrawingImmediate.FilledRectangle;
    local i=DrawingImmediate.Triangle;
    local Y=DrawingImmediate.FilledTriangle;
    local O=DrawingImmediate.Quad;
    local T=DrawingImmediate.FilledQuad;
    local x=DrawingImmediate.Circle;
    local p=DrawingImmediate.FilledCircle;
    local A=DrawingImmediate.Text;
    local M=DrawingImmediate.OutlinedText;
    K.line=function(a,B,N,I,R)o(a,B,N,I*S,R);
end;
K.rect=function(o,a,B,N,I,R)t(o,a,B,N*S,R or 0,I);
end;
K.filled_rect=function(o,t,a,B,N)G(o,t,a,B*S,N or 0);
end;
K.tri=function(o,t,G,a,B,N)i(o,t,G,a,B*S,N);
end;
K.filled_tri=function(o,t,G,i,a)Y(o,t,G,i,a*S);
end;
K.quad=function(o,t,G,i,Y,a,B)O(o,t,G,i,Y,a*S,B);
end;
K.filled_quad=function(o,t,G,i,Y,O)T(o,t,G,i,Y,O*S);
end;
K.circle=function(o,t,G,i,Y,O)x(o,t,G,i*S,Y or 24,O);
end;
K.filled_circle=function(o,t,G,i,Y)p(o,t,G,i*S,Y or 24);
end;
K.text=function(o,t,G,i,Y,O)A(o,b.face(t),t,G,i*S,Y,O);
end;
K.outlined_text=function(o,t,G,i,Y,O,T,x)M(o,b.face(t),t,G,i*S,Y,O*S,T,x);
end;
local o;
K.run=function(t)if o then
    return;
end;
local G=DrawingImmediate.GetPaint(0);
o=G:Connect(t);
j.adopt(o);
end;
K.pump=function()end;
return K;
end;
local o,t,G,i={Line={},Square={},Triangle={},Circle={},Text={}},{Line=0,Square=0,Triangle=0,Circle=0,Text=0},{Line=0,Square=0,Triangle=0,Circle=0,Text=0},0;
local function Y(O)local T=G[O]+1;
G[O]=T;
local x=o[O];
local p=x[T];
if p then
else
    p=h.new(O,true);
    x[T]=p;
    if T>t[O]then
        t[O]=T;
    end;
end;
i+=1;
p.ZIndex=i;
return p;
end;
K.line=function(h,O,T,x,p)local A=Y("Line");
A.From=h;
A.To=O;
A.Color=T;
A.Transparency=x*S;
A.Thickness=p;
A.Visible=true;
end;
K.rect=function(h,O,T,x,p)local A=Y("Square");
A.Position=h;
A.Size=O;
A.Color=T;
A.Transparency=x*S;
A.Thickness=p;
A.Filled=false;
A.Visible=true;
end;
K.filled_rect=function(h,O,T,x)local p=Y("Square");
p.Position=h;
p.Size=O;
p.Color=T;
p.Transparency=x*S;
p.Thickness=1;
p.Filled=true;
p.Visible=true;
end;
K.tri=function(h,O,T,x,p,A)local M=Y("Triangle");
M.PointA=h;
M.PointB=O;
M.PointC=T;
M.Color=x;
M.Transparency=p*S;
M.Thickness=A;
M.Filled=false;
M.Visible=true;
end;
K.filled_tri=function(h,O,T,x,p)local A=Y("Triangle");
A.PointA=h;
A.PointB=O;
A.PointC=T;
A.Color=x;
A.Transparency=p*S;
A.Filled=true;
A.Visible=true;
end;
K.quad=function(h,O,T,x,p,A,M)K.line(h,O,p,A,M);
K.line(O,T,p,A,M);
K.line(T,x,p,A,M);
K.line(x,h,p,A,M);
end;
K.filled_quad=function(h,O,T,x,p,A)K.filled_tri(h,O,T,p,A);
K.filled_tri(h,T,x,p,A);
end;
K.circle=function(h,O,T,x,p,A)local M=Y("Circle");
M.Position=h;
M.Radius=O;
M.Color=T;
M.Transparency=x*S;
M.NumSides=p or 24;
M.Thickness=A;
M.Filled=false;
M.Visible=true;
end;
K.filled_circle=function(h,O,T,x,p)local A=Y("Circle");
A.Position=h;
A.Radius=O;
A.Color=T;
A.Transparency=x*S;
A.NumSides=p or 24;
A.Filled=true;
A.Visible=true;
end;
K.text=function(h,O,T,x,p,A)local M=Y("Text");
M.Font=b.face(O);
M.Size=O;
M.Text=p;
M.Position=h;
M.Color=T;
M.Transparency=x*S;
M.Center=A;
M.Outline=false;
M.Visible=true;
end;
K.outlined_text=function(h,O,T,x,p,A,M,a)A=Y("Text");
A.Font=b.face(O);
A.Size=O;
A.Text=M;
A.Position=h;
A.Color=T;
A.Transparency=x*S;
A.Center=a;
A.Outline=true;
A.OutlineColor=p;
A.Visible=true;
end;
local function h(b)local Y=o[b];
for O=G[b]+1,t[b],1 do
    local T=Y[O];
    if T then
        T.Visible=false;
    end;
end;
G[b]=0;
end;
local function b()h("Line");
h("Square");
h("Triangle");
h("Circle");
h("Text");
i=0;
end;
local h;
K.run=function(Y)h=Y;
end;
K.pump=function()if not(h)then
    return;
end;
pcall(h);
b();
end;
j.teardown(function()for j,h in o,nil,nil do
    for b=t[j],1,-1 do
        h[b]=nil;
    end;
    t[j]=0;
    G[j]=0;
end;
i,S=0,1;
end);
return K;
end;
-- SIGNAL ESP. Screen-space markers driven by live character models.
local function CreateSignalESP(services,app)
    local players,world,run=services.players,services.workspace,services.run
    local localPlayer=services.lp
    local http=game:GetService("HttpService")
    local options={
        enabled=false,box=true,name=true,health=true,healthText=true,armor=false,
        weapon=true,distance=true,arrows=true,skeleton=false,highlight=false,fill=false,
        team=false,limit=false,range=150,flags=false,style="corners",
        accent=Color3.fromRGB(105,242,200),friendly=Color3.fromRGB(126,190,255)
    }
    local black=Color3.fromRGB(10,17,24)
    local white=Color3.fromRGB(238,251,255)
    local O,U=UDim2.fromOffset,UDim2.new
    local gui,connection,leaving
    local visuals={}
    local esp={_loaded=false}
    local bodyNames={
        "Head","HumanoidRootPart","UpperTorso","LowerTorso","Torso",
        "LeftUpperArm","LeftLowerArm","LeftHand","RightUpperArm","RightLowerArm","RightHand",
        "LeftUpperLeg","LeftLowerLeg","LeftFoot","RightUpperLeg","RightLowerLeg","RightFoot",
        "Left Arm","Right Arm","Left Leg","Right Leg"
    }
    local bones={
        {"Head","UpperTorso"},{"UpperTorso","LowerTorso"},
        {"UpperTorso","LeftUpperArm"},{"LeftUpperArm","LeftLowerArm"},{"LeftLowerArm","LeftHand"},
        {"UpperTorso","RightUpperArm"},{"RightUpperArm","RightLowerArm"},{"RightLowerArm","RightHand"},
        {"LowerTorso","LeftUpperLeg"},{"LeftUpperLeg","LeftLowerLeg"},{"LeftLowerLeg","LeftFoot"},
        {"LowerTorso","RightUpperLeg"},{"RightUpperLeg","RightLowerLeg"},{"RightLowerLeg","RightFoot"},
        {"Head","Torso"},{"Torso","Left Arm"},{"Torso","Right Arm"},{"Torso","Left Leg"},{"Torso","Right Leg"}
    }
    local function frame(parent,color,transparency)
        local object=Instance.new("Frame")
        object.BorderSizePixel=0
        object.BackgroundColor3=color
        object.BackgroundTransparency=transparency or 0
        object.Parent=parent
        return object
    end
    local function rounded(object,radius)
        local corner=Instance.new("UICorner")
        corner.CornerRadius=UDim.new(0,radius)
        corner.Parent=object
    end
    local function text(parent,size)
        local label=Instance.new("TextLabel")
        label.BackgroundTransparency=1
        label.Font=Enum.Font.GothamBold
        label.TextSize=size
        label.TextColor3=white
        label.TextTruncate=Enum.TextTruncate.AtEnd
        label.Parent=parent
        return label
    end
    local function pill(parent,width,y)
        local back=frame(parent,black,.10)
        back.AnchorPoint=Vector2.new(.5,0)
        back.Position=U(.5,0,y>=0 and 1 or 0,y)
        back.Size=O(width,20)
        back.ZIndex=4
        rounded(back,5)
        local label=text(back,11)
        label.Position=O(5,0)
        label.Size=U(1,-10,1,0)
        label.ZIndex=5
        local line=frame(back,options.accent)
        line.Size=O(2,10);line.Position=O(2,5);line.ZIndex=5
        rounded(line,2)
        return back,label,line
    end
    local function bar(parent,x)
        local back=frame(parent,black,.16)
        back.Position=U(x,x==0 and -9 or 5,0,0)
        back.Size=U(0,4,1,0)
        rounded(back,3)
        local fill=frame(back,options.accent)
        fill.AnchorPoint=Vector2.new(0,1)
        fill.Position=U(0,0,1,0)
        fill.Size=U(1,0,1,0)
        rounded(fill,3)
        return back,fill
    end
    local function marker(player,parent)
        local root=frame(parent,black,1)
        root.Name="Signal_"..player.UserId
        root.Visible=false
        local box=frame(root,black,1)
        box.Size=U(1,0,1,0)
        local fill=frame(box,options.accent,.94)
        fill.Size=U(1,0,1,0);rounded(fill,4)
        local corners={}
        for i=1,8 do
            local shadow=frame(box,black,.10)
            local edge=frame(shadow,options.accent)
            edge.Position=O(1,1);edge.Size=U(1,-2,1,-2)
            rounded(shadow,2);rounded(edge,2)
            corners[i]={shadow=shadow,edge=edge}
        end
        local top,name,nameAccent=pill(root,120,-26)
        local bottom,details,detailsAccent=pill(root,136,6)
        local health,healthFill=bar(root,0)
        local armor,armorFill=bar(root,1)
        local healthText=text(root,10)
        healthText.AnchorPoint=Vector2.new(1,.5)
        healthText.Size=O(29,14)
        healthText.TextXAlignment=Enum.TextXAlignment.Right
        healthText.TextStrokeTransparency=.45
        local skeleton=frame(parent,black,1)
        skeleton.Size=U(1,0,1,0);skeleton.Visible=false
        local lines={}
        for i=1,#bones do
            local line=frame(skeleton,options.accent,.22)
            line.AnchorPoint=Vector2.new(.5,.5);line.ZIndex=2;line.Visible=false
            lines[i]=line
        end
        local arrow=frame(parent,black,.14)
        arrow.Size=O(27,27);arrow.AnchorPoint=Vector2.new(.5,.5);arrow.Visible=false
        rounded(arrow,7)
        local pointer=text(arrow,16)
        pointer.Size=U(1,0,1,0);pointer.Text="▲"
        local arrowBorder=Instance.new("UIStroke")
        arrowBorder.Thickness=1;arrowBorder.Transparency=.18;arrowBorder.Parent=arrow
        local highlight=Instance.new("Highlight")
        highlight.Enabled=false;highlight.FillTransparency=.88;highlight.OutlineTransparency=.22
        highlight.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop;highlight.Parent=root
        local entry={root=root,box=box,fill=fill,corners=corners,top=top,name=name,nameAccent=nameAccent,
            bottom=bottom,details=details,detailsAccent=detailsAccent,health=health,healthFill=healthFill,
            armor=armor,armorFill=armorFill,healthText=healthText,skeleton=skeleton,lines=lines,
            arrow=arrow,pointer=pointer,arrowBorder=arrowBorder,highlight=highlight,points={},parts={}}
        if parent==gui then visuals[player]=entry end
        return entry
    end
    local function hide(entry)
        entry.root.Visible=false;entry.skeleton.Visible=false;entry.arrow.Visible=false
        entry.highlight.Enabled=false;entry.highlight.Adornee=nil
    end
    local function remove(player)
        local entry=visuals[player]
        if not entry then return end
        entry.root:Destroy();entry.arrow:Destroy();entry.skeleton:Destroy()
        visuals[player]=nil
    end
    local function validCharacter(model)
        return model and model:IsA("Model") and model:IsDescendantOf(world) and
            model:GetAttribute("ClientCharacterPresentationVisible")~=false and
            model:GetAttribute("Dead")~=true
    end
    local function character(player,folder)
        local presentation=folder and folder:FindFirstChild(player.Name)
        if presentation and presentation:GetAttribute("CharacterType")=="PlayerCustomCharacter" then
            return validCharacter(presentation) and presentation or nil
        end
        if validCharacter(player.Character) then return player.Character end
        if validCharacter(presentation) then return presentation end
    end
    local function teamOf(player)
        local team=player:GetAttribute("Team")
        if type(team)=="string" and team~="" then return team end
        return player.Team and player.Team.Name
    end
    local function decode(value)
        if type(value)~="string" or value:sub(1,1)~="{" then return nil end
        local ok,result=pcall(http.JSONDecode,http,value)
        return ok and type(result)=="table" and result or nil
    end
    local function updateMetadata(entry,player)
        local equipped=player:GetAttribute("CurrentEquipped")
        if equipped~=entry.equipped then
            local item=decode(equipped)
            entry.equipped=equipped
            entry.weapon=item and type(item.Name)=="string" and item.Name or ""
        end
        local armor=player:GetAttribute("Armor")
        if armor~=entry.armorData then
            local item=decode(armor)
            entry.armorData=armor
            entry.armorValue=tonumber(item and item.Health or armor) or 0
        end
        local slot=player:GetAttribute("Slot5")
        if slot~=entry.slot then
            local item=decode(slot)
            entry.slot=slot
            entry.bomb=item~=nil and item.Weapon=="C4"
        end
    end
    local function updateParts(entry,model)
        table.clear(entry.parts)
        for _,name in ipairs(bodyNames) do
            local part=model:FindFirstChild(name)
            if part and part:IsA("BasePart") then entry.parts[name]=part end
        end
    end
    local function project(entry,camera)
        local left,top,right,bottom=math.huge,math.huge,-math.huge,-math.huge
        table.clear(entry.points)
        for name,part in pairs(entry.parts) do
            local center=camera:WorldToViewportPoint(part.Position)
            if center.Z>0.12 then
                entry.points[name]=Vector2.new(center.X,center.Y)
                if name~="HumanoidRootPart" then
                    local half=part.Size*.5
                    for i=0,7 do
                        local localCorner=Vector3.new(i%2==0 and -half.X or half.X,
                            math.floor(i/2)%2==0 and -half.Y or half.Y,i<4 and -half.Z or half.Z)
                        local point=camera:WorldToViewportPoint(part.CFrame:PointToWorldSpace(localCorner))
                        if point.Z>.12 then
                            left=math.min(left,point.X);right=math.max(right,point.X)
                            top=math.min(top,point.Y);bottom=math.max(bottom,point.Y)
                        end
                    end
                end
            end
        end
        if left==math.huge then return end
        return left-2,top-2,right+2,bottom+2
    end
    local function drawArrow(entry,camera,position,accent)
        entry.arrow.Visible=options.arrows
        if not options.arrows then return end
        local localPoint=camera.CFrame:PointToObjectSpace(position)
        local direction=Vector2.new(localPoint.X,-localPoint.Y)
        if direction.Magnitude<.01 then direction=Vector2.new(0,1) end
        direction=direction.Unit
        local center=camera.ViewportSize*.5
        local reach=math.min(math.max(1,center.X-25)/math.max(.001,math.abs(direction.X)),
            math.max(1,center.Y-25)/math.max(.001,math.abs(direction.Y)))
        local point=center+direction*reach
        entry.arrow.Position=O(point.X,point.Y)
        entry.pointer.Rotation=math.deg(math.atan2(direction.Y,direction.X))+90
        entry.pointer.TextColor3=accent;entry.arrowBorder.Color=accent
    end
    local function drawBox(entry,width,height,accent)
        entry.box.Visible=options.box or options.fill
        entry.fill.Visible=options.fill;entry.fill.BackgroundColor3=accent
        local horizontal=options.style=="full" and width or math.clamp(width*.28,5,29)
        local vertical=options.style=="full" and height or math.clamp(height*.19,7,33)
        for i,segment in ipairs(entry.corners) do
            local index=math.floor((i-1)/2)
            local right=index%2==1
            local bottom=index>=2
            local sideways=i%2==1
            local w,h=sideways and horizontal or 4,sideways and 4 or vertical
            segment.shadow.Visible=options.box and (options.style~="full" or index==0 or (index==1 and not sideways) or (index==2 and sideways))
            segment.shadow.Size=O(w,h)
            segment.shadow.Position=O(right and width-w or 0,bottom and height-h or 0)
            segment.edge.BackgroundColor3=accent
        end
    end
    local function drawSkeleton(entry,accent)
        entry.skeleton.Visible=options.skeleton
        if not options.skeleton then return end
        for i,bone in ipairs(bones) do
            local a,b=entry.points[bone[1]],entry.points[bone[2]]
            local line=entry.lines[i]
            line.Visible=a~=nil and b~=nil
            if a and b then
                local delta=b-a
                local center=(a+b)*.5
                line.Position=O(center.X,center.Y);line.Size=O(delta.Magnitude,1.5)
                line.Rotation=math.deg(math.atan2(delta.Y,delta.X));line.BackgroundColor3=accent
            end
        end
    end
    local function render(player,entry,camera,folder,myTeam)
        local theirTeam=teamOf(player)
        local friendly=myTeam~=nil and theirTeam==myTeam
        local model=not (friendly and not options.team) and character(player,folder)
        if not model then hide(entry);return end
        local root=model:FindFirstChild("HumanoidRootPart") or model.PrimaryPart or model:FindFirstChild("Head")
        if not root or not root:IsA("BasePart") then hide(entry);return end
        local humanoid=model:FindFirstChildOfClass("Humanoid")
        local hp=tonumber(model:GetAttribute("Health")) or (humanoid and humanoid.Health) or 100
        local maxHP=tonumber(model:GetAttribute("MaxHealth")) or (humanoid and humanoid.MaxHealth) or 100
        local distance=(camera.CFrame.Position-root.Position).Magnitude
        if hp<=0 or (options.limit and distance>options.range) then hide(entry);return end
        local accent=friendly and options.friendly or options.accent
        local view=camera.ViewportSize
        local center=camera:WorldToViewportPoint(root.Position)
        if center.Z<=.12 or center.X<0 or center.X>view.X or center.Y<0 or center.Y>view.Y then
            hide(entry);drawArrow(entry,camera,root.Position,accent);return
        end
        updateParts(entry,model)
        local x,y,right,bottom=project(entry,camera)
        if not x then hide(entry);return end
        x=math.clamp(x,0,view.X);right=math.clamp(right,0,view.X)
        y=math.clamp(y,0,view.Y);bottom=math.clamp(bottom,0,view.Y)
        local w,h=right-x,bottom-y
        if w<4 or h<7 then hide(entry);return end
        entry.root.Position=O(x,y);entry.root.Size=O(w,h);entry.root.Visible=true;entry.arrow.Visible=false
        drawBox(entry,w,h,accent);drawSkeleton(entry,accent)
        entry.top.Visible=options.name
        entry.top.Position=U(.5,0,0,y<27 and 3 or -26)
        entry.name.Text=player.DisplayName;entry.nameAccent.BackgroundColor3=accent
        updateMetadata(entry,player)
        local tags={}
        if options.weapon and entry.weapon and entry.weapon~="" then table.insert(tags,string.upper(entry.weapon)) end
        if options.distance then table.insert(tags,math.round(distance).." st") end
        if options.flags then
            if entry.bomb then table.insert(tags,"C4") end
            if player:GetAttribute("IsDefusingBomb")==true then table.insert(tags,"DEFUSE") end
            if (tonumber(player:GetAttribute("ScopeIncrement")) or 0)>0 then table.insert(tags,"SCOPE") end
        end
        local info=table.concat(tags,"  ·  ")
        entry.bottom.Visible=#tags>0
        entry.bottom.Position=U(.5,0,1,bottom>view.Y-26 and -23 or 6)
        entry.bottom.Size=O(math.clamp(18+#info*6,58,220),20)
        entry.details.Text=info;entry.detailsAccent.BackgroundColor3=accent
        local ratio=math.clamp(hp/math.max(1,maxHP),0,1)
        local healthColor=Color3.fromRGB(245,102,126):Lerp(options.accent,ratio)
        entry.health.Visible=options.health;entry.healthFill.BackgroundColor3=healthColor
        entry.healthFill.Size=U(1,0,ratio,0)
        entry.healthText.Visible=options.health and options.healthText
        entry.healthText.Text=tostring(math.round(hp))
        entry.healthText.Position=U(0,-12,1-ratio,0)
        entry.healthText.TextColor3=healthColor
        local armor=entry.armorValue or 0
        entry.armor.Visible=options.armor and armor>0
        entry.armorFill.BackgroundColor3=options.friendly;entry.armorFill.Size=U(1,0,math.clamp(armor/100,0,1),0)
        entry.highlight.Enabled=options.highlight
        entry.highlight.Adornee=options.highlight and model or nil
        entry.highlight.FillColor=accent;entry.highlight.OutlineColor=accent
    end
    function esp.Load()
        if esp._loaded then return end
        gui=Instance.new("ScreenGui")
        gui.Name="FemboySignalESP";gui.IgnoreGuiInset=true;gui.ResetOnSpawn=false;gui.DisplayOrder=9998
        gui.Parent=(gethui and gethui()) or localPlayer:WaitForChild("PlayerGui")
        leaving=players.PlayerRemoving:Connect(remove)
        connection=run.PreRender:Connect(function()
            local camera=world.CurrentCamera
            if not options.enabled or not camera then
                for _,entry in pairs(visuals) do hide(entry) end
                return
            end
            local folder=world:FindFirstChild("Characters")
            local myTeam=teamOf(localPlayer)
            for _,player in ipairs(players:GetPlayers()) do
                if player~=localPlayer then
                    render(player,visuals[player] or marker(player,gui),camera,folder,myTeam)
                end
            end
        end)
        esp._loaded=true
    end
    function esp.Unload()
        if connection then connection:Disconnect();connection=nil end
        if leaving then leaving:Disconnect();leaving=nil end
        if gui then gui:Destroy();gui=nil end
        table.clear(visuals);esp._loaded=false
    end
    local page=app.tabs.visuals:page({name="ESP",cols=3})
    local main=page:section("Signal ESP")
    local style=page:section({name="Geometry",side=2})
    local readout=page:section({name="Readout",side=3})
    local function change(key)
        return function(value)options[key]=value end
    end
    local function toggle(section,name,flag,key)
        return section:toggle({name=name,flag="vis."..flag,default=options[key],cb=change(key)})
    end
    toggle(main,"Enable ESP","on","enabled")
    toggle(main,"Show teammates","team","team")
    local limit=toggle(main,"Limit distance","distance_limit","limit")
    main:slider({name="Max distance",flag="vis.max_distance",min=50,max=5000,default=150,suffix=" st",cb=change("range")}):dep(limit)
    style:colorpicker({name="Enemy color",flag="vis.signal_accent",default=options.accent,cb=change("accent")})
    style:colorpicker({name="Team color",flag="vis.signal_team",default=options.friendly,cb=change("friendly")})
    toggle(style,"Box","box","box")
    style:dropdown({name="Box shape",flag="vis.boxstyle",values={"corners","full"},cb=change("style")})
    toggle(style,"Tinted fill","boxfill","fill")
    toggle(style,"Skeleton","skel","skeleton")
    toggle(style,"Offscreen arrows","arrow","arrows")
    toggle(style,"Silhouette","hlt","highlight")
    toggle(readout,"Player name","name","name")
    local health=toggle(readout,"Health bar","hp","health")
    toggle(readout,"Health number","ht","healthText"):dep(health)
    toggle(readout,"Armor","arm","armor")
    toggle(readout,"Weapon","wep","weapon")
    toggle(readout,"Distance","dis","distance")
    toggle(readout,"C4 / scope / defuse","signal_flags","flags")
    function esp.Preview()
        local preview=page:section({name="Sample marker",side=2})
        local canvas=frame(preview.frame,black,.24)
        canvas.Size=U(1,0,0,205);rounded(canvas,7)
        local sample=marker({UserId=0},canvas)
        sample.root.AnchorPoint=Vector2.new(.5,0)
        sample.root.Position=U(.5,0,0,35);sample.root.Size=O(58,126);sample.root.Visible=true
        sample.name.Text="PLAYER 01";sample.details.Text="AK-47  ·  42 st"
        sample.healthText.Text="74";sample.healthText.Position=U(0,-12,.26,0)
        sample.armor.Visible=false
        sample.healthFill.Size=U(1,0,.74,0)
        drawBox(sample,58,126,options.accent)
    end
    return esp
end

D.G=function() D.load("i").vis=false; return CreateSignalESP(D.load("b"),D.load("e")) end;
D.H=function()local j,h,b,K=D.load("b"),D.load("q"),D.load("a"),D.load("j");
local S=h.world;
local o=j.lp;
local t=j.http;
local G=j.workspace;
local i=K.tp_model;
local Y=K.char_resolver;
local O=K.inventory;
local T,x=K.remotes,K.vm_flash;
local p=K.emit_fx;
local A=Enum.CameraMode.LockFirstPerson;
local M=Enum.CameraMode.Classic;
local a=Enum.CameraType.Custom;
local B=table.concat;
local N=math.max;
local I,R,n,E,d,w=type(i)=="table"and type(rawget(i,"ClearPlayerCache"))=="function",{},false,false,false;
local P={};
local function r(L)if type(L)~="string"then return nil;
elseif  L==""then return nil;
end;
local Z,X=pcall(t.JSONDecode,t,L);
if Z then
    if type(X)=="table"then return X;
end;
end;
return nil;
end;
local function t(L)if type(L)~="table"then return"";
end;
local Z={};
for X,q in L,nil,nil do
    local L=type(q)=="table"and q.Position or nil;
    if type(L)=="table"then Z[X]=tostring(q.Sticker).."@"..tostring(L.Rotation)..","..tostring(L.X)..","..tostring(L.Y);
else
    Z[X]=tostring(type(q)=="table"and q.Sticker or q);
end;
end;
return B(Z,";");
end;
local function L(Z)return B({tostring(Z.Identifier),tostring(Z.Name),tostring(Z.Skin),tostring(Z.Float),tostring(Z.StatTrack),tostring(Z.NameTag),t(Z.Stickers)},"|");
end;
local function t()local B={};
for Z=1,3,1 do
    local X=r(o:GetAttribute("Slot"..Z));
    if X then
        B[Z]=X;
    end;
end;
return B;
end;
local function B()local Z;
if type(Y)=="table"then if type(Y.getPlayerCharacter)=="function"then local X,q=pcall(Y.getPlayerCharacter,o);
Z=if X then
    if typeof(q)=="Instance"then q
else
    Z
else
    Z;
else
end;
else
end;
Z=Z or o.Character;
if Z then
    if Z.Parent then
        if Z:GetAttribute("Dead")~=true then
            return Z;
        end;
    end;
end;
return nil;
end;
local Y=j.plain;
local function Z(X,...)task.spawn(Y,X,...);
end;
local function X()if n then
    n=false;
    Y(i.ClearPlayerCache,o);
end;
table.clear(R);
end;
local function q(U)local z,J,y,f,k,g,Q=o:GetAttribute("CurrentEquipped"),o:GetAttribute("Slot1"),o:GetAttribute("Slot2"),o:GetAttribute("Slot3"),o:GetAttribute("Slot5"),o:GetAttribute("HasDefuseKit")==true or o:GetAttribute("HasRescueKit")==true,o:GetAttribute("Team");
local c=U==R.char and J==R.s1 and y==R.s2 and f==R.s3 and k==R.s5 and g==R.kit and Q==R.team;
if c then
    if z==R.raw then
        return;
    end;
end;
R.char=U;
R.raw=z;
R.s1=J;
R.s2=y;
R.s3=f;
R.s5=k;
R.kit=g;
R.team=Q;
f=r(z);
k,g=f and L(f)or nil,f~=nil and f.IsSuppressed==true;
if c then
    if n then
        if k==R.sig then
            if g==R.sup then
                return;
            end;
            R.sup=g;
            J,Q=Y(i.RefreshSuppressorState,o,f);
            if J then
                if Q then
                    return;
                end;
            end;
        end;
    end;
end;
R.sig=k;
R.sup=g;
R.name=f and f.Name or nil;
n=true;
if f then
    Z(i,o,f,t());
else
    Z(i.ClearPlayerCache,o);
    Z(i.RefreshObjectiveKitHolster,o);
    Z(i.RefreshBombHolster,o);
end;
end;
local function t(i)local Y,r=o.Character,G.CurrentCamera;
if Y then
    if r then
        if Y:GetAttribute("Dead")==true then
            return;
        elseif  o:GetAttribute("IsSpectating")==true then
            return;
        end;
    else
        return;
    end;
else
    return;
end;
local G=r.CameraSubject;
if r.CameraType~=a then
    return;
elseif  typeof(G)~="Instance"then return;
elseif  not(G:IsDescendantOf(Y))then
    return;
end;
G=i and N(tonumber(S.third_dist)or 10,0.5)or 0.5;
if o.CameraMaxZoomDistance~=G then
    o.CameraMaxZoomDistance=G;
    o.CameraMinZoomDistance=G;
elseif  o.CameraMinZoomDistance~=G then
    o.CameraMaxZoomDistance=G;
    o.CameraMinZoomDistance=G;
end;
G=i and M or A;
if o.CameraMode~=G then
    o.CameraMode=G;
end;
end;
local function G()local i=type(O)=="table"and rawget(O,"peekCurrentEquippedForMovement")or nil;
if type(i)~="function"then return"MuzzlePart";
end;
local Y,O=pcall(i);
i=Y and type(O)=="table"and O.Properties or nil;
if type(i)=="table"then if i.ShootingOptions=="Dual"then return O.ShootingHand=="Left"and"MuzzlePartL"or"MuzzlePartR";
end;
end;
return"MuzzlePart";
end;
P.on=function()local i=n and S.third==true;
return i;
end;
P.name=function()if n then
    if S.third then
        return R.name;
    end;
end;
return nil;
end;
P.model=function()if n then
    if not(S.third)then
        return nil;
    end;
else
    return nil;
end;
local i=R.char;
local Y=i and(i:FindFirstChild("WeaponModel"));
i=Y and(Y:FindFirstChild("Equipped"));
if i then
    if i:IsA("Model")then
        return i;
    end;
end;
return nil;
end;
P.muzzle=function(i)local Y=P.model();
local O=Y and(Y:FindFirstChild("Interactables"));
if not(O)then
    return nil;
end;
Y=O:FindFirstChild(i or G());
if Y then
    if Y:IsA("BasePart")then
        return Y;
    end;
end;
Y=O:FindFirstChild("MuzzlePart");
if Y then
    if Y:IsA("BasePart")then
        return Y;
    end;
end;
return nil;
end;
P.step=function()local G=S.third==true;
local i=G~=d or G and S.third_dist~=w;
if i then
    local Y;
    Y,d=S.third_dist,G;
    w=Y;
    t(G);
end;
if not(I)then
    return;
end;
i=G and B()or nil;
if not i then
    if n then
        X();
    elseif  next(R)~=nil then
        X();
    end;
    return;
end;
q(i);
end;
h=K.weapon;
K=type(h)=="table"and b.shared.fields[h]or nil;
local G,i=K and K.shoot or(type(h)=="table"and rawget(h,"shoot")or nil),j.getups;
if type(x)=="function"and type(p)=="function"and type(G)=="function"and type(i)=="function"then K,j=pcall(i,G);
if K and type(j)=="table"then for h,Y in j,nil,nil do
    if Y==x then
        b.upvalue(G,h,function(j,h,...)if not(E)then
            if n then
                if S.third then
                    if typeof(j)=="Instance"then if type(h)=="string"then local S=P.muzzle(j.Name);
                    local Y=S and(S:FindFirstChild(h));
                    if Y then
                        pcall(p,Y);
                    end;
                end;
            end;
        end;
    end;
end;
return x(j,h,...);
end);
break;
end;
end;
end;
end;
i=type(T)=="table"and T.VFX or nil;
G=type(i)=="table"and i.CreateCharacterMuzzleFlash or nil;
if type(G)=="table"then if type(G.Listen)=="function"then K,T=pcall(G.Listen,function(j)if type(j)=="table"then if j.UserId==o.UserId then
    E=true;
end;
end;
end);
if K then
    if type(T)=="function"then b.adopt(T);
end;
end;
end;
end;
b.teardown(function()if I then
    X();
end;
if d then
    d=false;
    t(false);
end;
end);
return P;
end;
D.I=function()local j=D.load("b");
local h,b,K,S,o=D.load("q"),D.load("f"),D.load("a"),D.load("j"),D.load("H");
local t=h.world;
local G=h.misc;
local i=j.workspace;
local Y=j.host;
local O=S.local_char;
local T=S.weapon_props;
local S=b.trim;
local b=table.clear;
local x=Enum.Material.ForceField;
local p=Enum.HighlightDepthMode.Occluded;
local A,M=h.white,{forcefield=x};
M.neon=Enum.Material.Neon;
M.metal=Enum.Material.Metal;
M.chrome=Enum.Material.Glass;
local h,a,B,N={HumanoidRootPart=true,Camera=true,ViewmodelLight=true,MuzzlePart=true},{SurfaceGui=1,BillboardGui=1,Beam=1,Trail=1,Highlight=1,PointLight=1,SpotLight=1,SurfaceLight=1,Smoke=1,Fire=1,Sparkles=1,ParticleEmitter=2,Decal=3},{Shirt="ShirtTemplate",Pants="PantsTemplate"},{WeaponModel=true,WeaponAttachments=true};
local I=NumberSequence.new(1);
local R=j.weak();
local n=j.weak();
local E=j.weak();
local d=j.weak();
local w=j.weak();
local P=j.weak();
local r,L,Z,X,q=j.weak(),{},{},{};
local U,z,J=true,0,{};
local function y(f)local k=J[f];
if k then
    return k;
end;
k=nil;
if type(T)=="function"then local g,Q=pcall(T,f);
k=if g then
    if type(Q)=="table"then Q
else
    k
else
    k;
else
end;
if k then
else
    local T=j.module(j.storage,"Database","Custom","Weapons",f);
    k=if type(T)=="table"then T
else
    k;
end;
j.reclaim();
local j="other";
if k then
    local T,g,Q=k.Class,k.MuzzleType,k.Type;
    j=if T=="Melee"then"knife"else if T=="Grenade"then"grenades"else if T=="C4"then"bomb"else if T=="Weapon"then if g=="Sniper"then"snipers"else if g=="ShotGun"then"shotguns"else if g=="MachineGun"then"machine guns"else if Q=="Pistol"and g~="Zeus x27"then"pistols"else if Q=="Rifle"then"rifles"else if Q=="SMG"then"smgs"else j
else
    j;
else
end;
if k then
    J[f]=j;
end;
return j;
end;
local function j(T,J)local f=T.Name;
if f=="Left Arm"then return true;
elseif  f=="Right Arm"then return true;
elseif  f=="Glove"then return true;
elseif  f=="Sleeve"then return true;
end;
local k=T.Parent;
while k and k~=J do
    f=k.Name;
    if f=="Left Arm"then return true;
elseif  f=="Right Arm"then return true;
elseif  f=="Arms"then return true;
end;
k=k.Parent;
end;
return false;
end;
local function T(J,f)local k=J.Parent;
while k and k~=f do
    if N[k.Name]then
        if k.Parent==f then
            return true;
        end;
    end;
    k=k.Parent;
end;
return false;
end;
local function N()local J=i.CurrentCamera;
if J~=q then
    for i=#X,1,-1 do
        X[i]:Disconnect();
        X[i]=nil;
    end;
    q,U=J,true;
    if J then
        local function i()U=true;
    end;
    X[1]=J.ChildAdded:Connect(i);
    X[2]=J.ChildRemoved:Connect(i);
end;
end;
if U then
    U=false;
    local i=0;
    if J then
        local f=J:GetChildren();
        for J=1,#f,1 do
            local k=f[J];
            if k:IsA("Model")then
                i+=1;
                Z[i]=k;
            else
            end;
        end;
    else
    end;
    S(Z,i);
end;
return Z;
end;
local function i(J,f)local k,g=r[J];
if k then
    g=k;
else
    g={parts={},texs={},arms={},vis={},cloth={},dirty=true};
    r[J]=g;
    local function k()g.dirty=true;
end;
g.added=J.DescendantAdded:Connect(k);
g.gone=J.DescendantRemoving:Connect(k);
end;
if g.dirty then
    g.dirty=false;
    g.arm_tops=nil;
    g.tool_tops=nil;
    local k,Q,c,H,_=g.parts,g.texs,g.arms,g.vis,g.cloth;
    b(c);
    local b,s,F,v,u=J:GetDescendants(),0,0,0,0;
    for V=1,#b,1 do
        local e=b[V];
        if not(f)then
            if T(e,J)then
                continue;
            end;
        end;
        if e:IsA("BasePart")then
            V=e.Name;
            if f then
                if h[V]then
                else
                    s+=1;
                    k[s]=e;
                    c[e]=j(e,J);
                end;
            else
                if V~="HumanoidRootPart"then if V~="CameraPart"then local j=s+1;
                k[j]=e;
                s=j;
            else
            end;
        else
        end;
    end;
else
    if e:IsA("Texture")then
        F+=1;
        Q[F]=e;
    else
        if f then
            if a[e.ClassName]then
                v+=1;
                H[v]=e;
            else
            end;
        else
            if e.ClassName=="Decal"then v+=1;
            H[v]=e;
        else
            if B[e.ClassName]then
                u+=1;
                _[u]=e;
            else
            end;
        end;
    end;
end;
end;
end;
S(k,s);
S(Q,F);
S(H,v);
S(_,u);
end;
return g;
end;
local function j()for h,b in r,nil,nil do
    if not(h.Parent)then
        if b.added then
            b.added:Disconnect();
        end;
        if b.gone then
            b.gone:Disconnect();
        end;
        r[h]=nil;
    end;
end;
end;
local function h(b,T,J,f,k)local g,Q=J or x,R[b];
if Q then
else
    Q={mat=b.Material,col=b.Color,refl=b.Reflectance};
    if b:IsA("MeshPart")then
        Q.tex=b.TextureID;
    end;
    R[b]=Q;
    J=b:GetChildren();
    for c=1,#J,1 do
        local H=J[c];
        if H:IsA("SurfaceAppearance")then
            if n[H]==nil then
                n[H]=b;
                c=Q.sa;
                if c then
                else
                    c={};
                    Q.sa=c;
                end;
                c[#c+1]=H;
                H.Parent=nil;
            end;
        end;
    end;
end;
Q.gen=k;
if b.Material~=g then
    b.Material=g;
end;
if b.Color~=T then
    b.Color=T;
end;
if f then
    if b.Reflectance~=f then
        b.Reflectance=f;
    end;
    Q.lit=true;
elseif  Q.lit then
    Q.lit=nil;
    b.Reflectance=Q.refl;
end;
if Q.tex then
    if b.TextureID~=""then b.TextureID="";
end;
end;
end;
local function b(T,J,f,k,g)if not(k)then
    h(T,J,f,nil,g);
    return false;
end;
if T.Transparency<1 then
    if T.LocalTransparencyModifier<1 then
        h(T,J,f,1,g);
        return true;
    end;
end;
return false;
end;
local function h(T)local J=R[T];
if not(J)then
    return;
end;
R[T]=nil;
local f=T.Parent~=nil;
if f then
    T.Material=J.mat;
    T.Color=J.col;
    if J.lit then
        T.Reflectance=J.refl;
    end;
    if J.tex then
        T.TextureID=J.tex;
    end;
end;
local k=J.sa;
if k then
    for g=1,#k,1 do
        J=k[g];
        n[J]=nil;
        if f then
            J.Parent=T;
        end;
    end;
end;
end;
local function T(J,f)local k=E[J];
if k then
    k.gen=f;
else
    E[J]={t=J.Transparency,gen=f};
end;
if J.Transparency~=1 then
    J.Transparency=1;
end;
end;
local function J(f)local k=E[f];
if not(k)then
    return;
end;
E[f]=nil;
if f.Parent then
    f.Transparency=k.t;
end;
end;
local function f(k,g)local Q=d[k];
if Q then
    Q.gen=g;
else
    d[k]={t=k.Transparency,gen=g};
end;
if k.Transparency<1 then
    k.Transparency=1;
end;
end;
local function k(g)local Q=d[g];
if not(Q)then
    return;
end;
d[g]=nil;
if g.Parent then
    g.Transparency=Q.t;
end;
end;
local function g(Q,c)local H=a[Q.ClassName];
if not(H)then
    return;
end;
local a=w[Q];
if a then
    a.gen=c;
else
    a={k=H,gen=c};
    if H==3 then
        a.t=Q.Transparency;
    else
        a.e=Q.Enabled;
        if H==2 then
            a.t=Q.Transparency;
        end;
    end;
    w[Q]=a;
end;
if H==3 then
    if Q.Transparency<1 then
        Q.Transparency=1;
    end;
else
    if Q.Enabled then
        Q.Enabled=false;
    end;
    if H==2 then
        if Q.Transparency~=I then
            Q.Transparency=I;
        end;
    end;
end;
end;
local function a(I)local Q=w[I];
if not(Q)then
    return;
end;
w[I]=nil;
if not(I.Parent)then
    return;
end;
if Q.k==3 then
    I.Transparency=Q.t;
else
    if Q.k==2 then
        I.Transparency=Q.t;
    end;
    I.Enabled=Q.e;
end;
end;
local function I(Q,c)local H=P[Q];
local _=H and H.k or B[Q.ClassName];
local B=Q[_];
if H then
    if B~=""then H.t=B;
end;
else
    H={k=_,t=B};
    P[Q]=H;
end;
H.gen=c;
if B~=""then Q[_]="";
end;
end;
local function B(Q)local c=P[Q];
if not(c)then
    return;
end;
P[Q]=nil;
if Q.Parent then
    Q[c.k]=c.t;
end;
end;
local function Q(c,H,_)local s=_ and"arm_tops"or"tool_tops";
local F=c[s];
if F~=nil then
    return F;
end;
local v,u,V=c.parts,c.arms,{};
for e=1,#v,1 do
    local l=v[e];
    if u[l]~=_ then
        while l and l~=H and not V[l]do
            V[l]=true;
            l=l.Parent;
        end;
    end;
end;
local e,l={},0;
F={};
for C=1,#v,1 do
    local W=v[C];
    if u[W]==_ then
        local _,v=W.Parent,W;
        while _ and _~=H and not V[_]do
            v=if _:IsA("Model")then
                _
            else
                v;
                _=_.Parent;
            end;
            if e[v]then
            else
                e[v]=true;
                l+=1;
                C=F;
                if l>8 then
                    F=false;
                    break;
                end;
                C[l]=v;
            end;
        else
        end;
    end;
    c[s]=F;
    return F;
end;
local function c(H,_,s)local F=L[H];
if F then
else
    local v=Instance.new("Highlight");
    v.FillTransparency=1;
    v.OutlineTransparency=0.2;
    v.DepthMode=p;
    v.Adornee=H;
    v.Parent=Y;
    F={inst=v};
    L[H]=F;
end;
F.gen=s;
if F.col~=_ then
    F.col=_;
    F.inst.OutlineColor=_:Lerp(A,0.6);
end;
end;
local function Y()for p,A in L,nil,nil do
    L[p]=nil;
    pcall(A.inst.Destroy,A.inst);
end;
end;
local p={restore_all=function()for A in R,nil,nil do
    h(A);
end;
for A,H in n,nil,nil do
    n[A]=nil;
    if H then
        if H.Parent then
            A.Parent=H;
        end;
    end;
end;
end,show_all=function()for A in E,nil,nil do
    J(A);
end;
for A in d,nil,nil do
    k(A);
end;
for A in w,nil,nil do
    a(A);
end;
for A in P,nil,nil do
    B(A);
end;
end,drop_cache=function()for A,n in r,nil,nil do
    if n.added then
        n.added:Disconnect();
    end;
    if n.gone then
        n.gone:Disconnect();
    end;
    r[A]=nil;
end;
for A=#X,1,-1 do
    X[A]:Disconnect();
    X[A]=nil;
end;
S(Z,0);
q,U=nil,true;
end,sync=function()local S,A,n,r=t.body_chams,t.tool_chams,t.third,t.hand_chams;
if S then
elseif  A then
elseif  n then
elseif  r then
elseif  next(R)==nil then
    if next(E)==nil then
        if next(d)==nil then
            if next(w)==nil then
                if next(P)==nil then
                    if next(L)==nil then
                        return;
                    end;
                end;
            end;
        end;
    end;
end;
local Z=O and O.getCurrentCharacter()or nil;
local O,X=Z and not Z.IsDestroyed and Z.Character or nil,N();
z+=1;
Z=z;
if O and S then
    local N=i(O,false);
    local q,U,z=N.parts,t.body_chams_col,t.body_chams_mat;
    local H,_,s=M[z]or x,z=="chrome",false;
    for z=1,#q,1 do
        s=if b(q[z],U,H,_,Z)then
            true
        else
            s;
        end;
        if s then
            H,_,q=N.texs,N.vis,N.cloth;
            for N=1,#H,1 do
                f(H[N],Z);
            end;
            for N=1,#_,1 do
                g(_[N],Z);
            end;
            for N=1,#q,1 do
                I(q[N],Z);
            end;
            c(O,U,Z);
        end;
    end;
    S,O=t.hand_chams_mat,t.tool_chams_mat;
    local N,I,q,U,z,H,_=M[S]or x,M[O]or x,S=="chrome",O=="chrome",t.hand_chams_col,t.tool_chams_col,G.hands;
    S,O=_ or r and(q or N==x),t.tool_chams_kinds;
    for t=1,#X,1 do
        local G=X[t];
        t=i(G,true);
        local M,s,F,v,u=t.parts,t.texs,t.arms,t.vis,A and(O==nil or O[y(G.Name)]==true);
        local V,e,l=u and(U or I==x),false,false;
        for x=1,#M,1 do
            local C=M[x];
            x=F[C];
            if n or _ and x then
                T(C,Z);
            else
                if x then
                    e=if r then
                        if b(C,z,N,q,Z)then
                            true
                        else
                            e
                        else
                            e;
                        else
                            l=if u then
                                if b(C,H,I,U,Z)then
                                    true
                                else
                                    l
                                else
                                    l;
                                end;
                            end;
                        end;
                        if n then
                            for T=1,#s,1 do
                                f(s[T],Z);
                            end;
                            for T=1,#v,1 do
                                g(v[T],Z);
                            end;
                        elseif  e or l then
                            if S and V then
                                c(G,l and H or z,Z);
                            else
                                F=Q(t,G,e);
                                if F then
                                    M=e and z or H;
                                    for t=1,#F,1 do
                                        c(F[t],M,Z);
                                    end;
                                end;
                            end;
                        end;
                    end;
                    if n and A then
                        S=o.model();
                        if S and(O==nil or O[y(o.name()or"")]==true)then
                            z,X=i(S,true).parts,false;
                            for o=1,#z,1 do
                                X=if b(z[o],H,I,U,Z)then
                                    true
                                else
                                    X;
                                end;
                                if X then
                                    c(S,H,Z);
                                end;
                            end;
                        end;
                        for b,S in R,nil,nil do
                            if S.gen~=Z then
                                h(b);
                            end;
                        end;
                        for h,b in E,nil,nil do
                            if b.gen~=Z then
                                J(h);
                            end;
                        end;
                        for h,b in d,nil,nil do
                            if b.gen~=Z then
                                k(h);
                            end;
                        end;
                        for h,b in w,nil,nil do
                            if b.gen~=Z then
                                a(h);
                            end;
                        end;
                        for h,b in P,nil,nil do
                            if b.gen~=Z then
                                B(h);
                            end;
                        end;
                        for h,b in L,nil,nil do
                            if b.gen~=Z then
                                L[h]=nil;
                                b.inst:Destroy();
                            end;
                        end;
                        j();
                    end
                };
                p.unload=function()Y();
                p.restore_all();
                p.show_all();
                p.drop_cache();
            end;
            K.teardown(p.unload);
            return p;
        end;
        D.J=function()local j,h,b=D.load("b"),D.load("q"),D.load("a");
        local K,S=D.load("j"),h.world;
        local o=j.lighting;
        local t=j.workspace;
        local G=j.lp;
        local j=math.floor;
        local i=math.clamp;
        local Y=math.max;
        local O,T=math.abs,{};
        T.ambient=o.Ambient;
        T.outdoor=o.OutdoorAmbient;
        T.bright=o.Brightness;
        T.exposure=o.ExposureCompensation;
        T.clock=o.ClockTime;
        T.fog_col=o.FogColor;
        T.fog_start=o.FogStart;
        T.fog_end=o.FogEnd;
        T.shadows=o.GlobalShadows;
        local x;
        local p,A=true;
        local function M()if p then
            p=false;
            x=o:FindFirstChildOfClass("Atmosphere");
        end;
        if x then
            if not(x.Parent)then
                x=nil;
            end;
        end;
        local a=x;
        return a;
    end;
    local function x()p=true;
end;
b.connect(o.ChildAdded,x);
b.connect(o.ChildRemoved,x);
local function x()if A then
    return;
end;
local p=M();
if not(p)then
    return;
end;
A={density=p.Density,col=p.Color,offset=p.Offset};
end;
local function p()local a=M();
if a then
    if not(A)then
        return;
    end;
else
    return;
end;
a.Density=A.density;
a.Color=A.col;
a.Offset=A.offset;
end;
local A,a;
local function B()if A then
    if A.Parent then
        local N=A;
        return N;
    end;
    A:Destroy();
end;
A=Instance.new("ColorCorrectionEffect");
A.Parent=o;
local N=A;
return N;
end;
local function N()if a then
    if a.Parent then
        local I=a;
        return I;
    end;
    a:Destroy();
end;
a=Instance.new("BloomEffect");
a.Parent=o;
local I=a;
return I;
end;
local I,R,n,E,d={jungle={SkyboxBk="rbxassetid://214399891",SkyboxDn="rbxassetid://214399887",SkyboxFt="rbxassetid://214399894",SkyboxLf="rbxassetid://214405668",SkyboxRt="rbxassetid://214399899",SkyboxUp="rbxassetid://214399889"},blossom={SkyboxBk="rbxassetid://271042516",SkyboxDn="rbxassetid://271077243",SkyboxFt="rbxassetid://271042556",SkyboxLf="rbxassetid://271042310",SkyboxRt="rbxassetid://271042467",SkyboxUp="rbxassetid://271077958"},["red night"]={SkyboxBk="rbxassetid://401664839",SkyboxDn="rbxassetid://401664862",SkyboxFt="rbxassetid://401664960",SkyboxLf="rbxassetid://401664881",SkyboxRt="rbxassetid://401664901",SkyboxUp="rbxassetid://401664936"},purple={SkyboxBk="rbxassetid://13694952867",SkyboxDn="rbxassetid://13694968325",SkyboxFt="rbxassetid://13694980654",SkyboxLf="rbxassetid://13694998113",SkyboxRt="rbxassetid://13695002700",SkyboxUp="rbxassetid://13695007103"},foggy={SkyboxBk="rbxassetid://1370717244",SkyboxDn="rbxassetid://1370717336",SkyboxFt="rbxassetid://1370717438",SkyboxLf="rbxassetid://1370717567",SkyboxRt="rbxassetid://1370717698",SkyboxUp="rbxassetid://1370717782"}},{galaxy=15983996673,anime=13107361022,minecraft=2758029221};
local function w()if E then
    return;
end;
local P=o:FindFirstChildOfClass("Sky");
if P then
    if P~=n then
        E=P;
        d=P.Parent;
        P.Parent=nil;
    end;
end;
end;
local function P(r)local L=I[r];
if L then
    w();
    if n then
        n:Destroy();
    end;
    local I=Instance.new("Sky");
    for Z,X in L,nil,nil do
        I[Z]=X;
    end;
    I.Parent=o;
    n=I;
    return;
end;
local I=R[r];
if not I then
    return;
end;
b.spawn(function()local R,r=pcall(game.GetObjects,game,"rbxassetid://"..I);
if R then
    if type(r)~="table"then return;
end;
else
    return;
end;
R=nil;
for I=1,#r,1 do
    local L=r[I];
    R=R or(if L:IsA("Sky")then
        L
    else
        (L:FindFirstChildWhichIsA("Sky",true)));
    end;
    for I=1,#r,1 do
        local L=r[I];
        if L~=R then
            if R then
                if not(R:IsDescendantOf(L))then
                    L:Destroy();
                end;
            else
                L:Destroy();
            end;
        end;
    end;
    if R then
        if b.alive()then
            if not(S.sky)then
                if R then
                    R:Destroy();
                end;
                return;
            end;
        else
            if R then
                R:Destroy();
            end;
            return;
        end;
    else
        if R then
            R:Destroy();
        end;
        return;
    end;
    w();
    if n then
        n:Destroy();
    end;
    R.Parent=o;
    n=R;
end);
end;
local function I()if n then
    n:Destroy();
    n=nil;
end;
if E then
    E.Parent=d or o;
    E,d=nil,nil;
end;
end;
local R,n,E,d;
local function w(r)r.Orientation=Enum.ParticleOrientation.FacingCamera;
r.Brightness=1;
end;
local function r(L)L.Brightness=2;
end;
local function L(Z)Z.Shape=Enum.ParticleEmitterShape.Box;
Z.ShapeStyle=Enum.ParticleEmitterShapeStyle.Volume;
end;
local function Z(X,q,U)local z=n;
if not(z)then
    return;
end;
E,d=nil,nil;
z.Texture=X=="stars"and"rbxasset://textures/particles/sparkles_main.dds"or"rbxasset://textures/particles/smoke_main.dds";
z.LightInfluence=0;
z.LightEmission=0.4;
z.ZOffset=0;
z.Drag=0;
z.EmissionDirection=Enum.NormalId.Bottom;
z.Rate=U;
z.Color=ColorSequence.new(q);
pcall(w,z);
if X=="stars"then z.LightEmission=0.15;
z.Rate=Y(10,U*0.4);
z.Lifetime=NumberRange.new(6,9);
z.Speed=NumberRange.new(4,8);
z.Acceleration=Vector3.new(1,-3,0.6);
z.SpreadAngle=Vector2.new(16,16);
z.Rotation=NumberRange.new(0,360);
z.RotSpeed=NumberRange.new(-14,14);
z.Squash=NumberSequence.new(0);
z.Size=NumberSequence.new({NumberSequenceKeypoint.new(0,0,0),NumberSequenceKeypoint.new(0.1,0.5,0.14),NumberSequenceKeypoint.new(0.5,0.62,0.16),NumberSequenceKeypoint.new(0.9,0.44,0.12),NumberSequenceKeypoint.new(1,0,0)});
z.Transparency=NumberSequence.new(0);
pcall(r,z);
elseif  X=="snow"then z.Lifetime=NumberRange.new(4,6);
z.Speed=NumberRange.new(6,12);
z.Acceleration=Vector3.new(2,-6,1);
z.SpreadAngle=Vector2.new(35,35);
z.Rotation=NumberRange.new(0,360);
z.RotSpeed=NumberRange.new(-40,40);
z.Squash=NumberSequence.new(0);
z.Size=NumberSequence.new(0.55);
z.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0.2),NumberSequenceKeypoint.new(0.8,0.3),NumberSequenceKeypoint.new(1,1)});
else
    z.Lifetime=NumberRange.new(5,7);
    z.Speed=NumberRange.new(5,10);
    z.Acceleration=Vector3.new(4,-5,2);
    z.SpreadAngle=Vector2.new(40,40);
    z.Rotation=NumberRange.new(0,360);
    z.RotSpeed=NumberRange.new(-80,80);
    z.Squash=NumberSequence.new(1.4);
    z.Size=NumberSequence.new(0.5);
    z.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0.15),NumberSequenceKeypoint.new(0.85,0.25),NumberSequenceKeypoint.new(1,1)});
end;
end;
local function w()if R then
    R:Destroy();
end;
R,n,E,d=nil,nil,nil,nil;
end;
local function r()if R then
    if R.Parent then
        return;
    end;
end;
R=Instance.new("Part");
R.Anchored=true;
R.CanCollide=false;
R.CanQuery=false;
R.CanTouch=false;
R.Transparency=1;
local X=R;
X.Size=Vector3.new(260,140,260);
R.Parent=t;
n=Instance.new("ParticleEmitter");
pcall(L,n);
n.Parent=R;
Z(S.fx_type,S.fx_col,S.fx_rate);
X=n;
X:Emit(i(j(S.fx_rate*0.16),30,140));
end;
local L,X=K.data;
local function q()if not(L)then
    return nil;
end;
local U,z=pcall(L.Get,G,"Settings.Game.Viewmodel");
if U then
    if type(z)=="table"then return z;
end;
end;
return nil;
end;
local function G()if not(X)then
    return;
end;
local L=q();
if L then
    L["X Offset"]=X.x;
    L["Y Offset"]=X.y;
    L["Z Offset"]=X.z;
end;
X=nil;
end;
local function L()if not(S.hands)then
    G();
    return;
end;
local U=q();
if not(U)then
    return;
end;
X=X or{x=tonumber(U["X Offset"])or 0,y=tonumber(U["Y Offset"])or 0,z=tonumber(U["Z Offset"])or 0};
if U["X Offset"]~=S.hands_x then
    U["X Offset"]=S.hands_x;
end;
if U["Y Offset"]~=S.hands_y then
    U["Y Offset"]=S.hands_y;
end;
if U["Z Offset"]~=S.hands_z then
    U["Z Offset"]=S.hands_z;
end;
end;
h=K.camera;
if type(h)=="table"then if type(h.setPerspective)=="function"then b.field(h,"setPerspective",function(K)return function(X,q,U)if S.third then
    return K(false,q,S.third_dist);
end;
return K(X,q,U);
end;
end);
end;
end;
local K,X,q,U,z,J;
h={sync=function()L();
if S.fullbright then
    if o.Ambient~=S.fb_col then
        o.Ambient=S.fb_col;
    end;
    if o.OutdoorAmbient~=S.fb_col then
        o.OutdoorAmbient=S.fb_col;
    end;
    local L=S.fb_power/100*Y(T.bright,1);
    if O(o.Brightness-L)>0.001 then
        o.Brightness=L;
    end;
elseif  S.ambient then
    if o.Ambient~=S.ambient_col then
        o.Ambient=S.ambient_col;
    end;
    if o.OutdoorAmbient~=S.ambient_col then
        o.OutdoorAmbient=S.ambient_col;
    end;
    if o.Brightness~=T.bright then
        o.Brightness=T.bright;
    end;
else
    if o.Ambient~=T.ambient then
        o.Ambient=T.ambient;
    end;
    if o.OutdoorAmbient~=T.outdoor then
        o.OutdoorAmbient=T.outdoor;
    end;
    if o.Brightness~=T.bright then
        o.Brightness=T.bright;
    end;
end;
if S.no_shadows then
    if o.GlobalShadows then
        o.GlobalShadows=false;
    end;
elseif  o.GlobalShadows~=T.shadows then
    o.GlobalShadows=T.shadows;
end;
if S.exposure then
    local L=S.exposure_val/100;
    if O(o.ExposureCompensation-L)>0.001 then
        o.ExposureCompensation=L;
    end;
elseif  o.ExposureCompensation~=T.exposure then
    o.ExposureCompensation=T.exposure;
end;
if S.time then
    if O(o.ClockTime-S.time_hour)>0.001 then
        o.ClockTime=S.time_hour;
    end;
elseif  O(o.ClockTime-T.clock)>0.001 then
    o.ClockTime=T.clock;
end;
if S.fog then
    x();
    local x=M();
    if x then
        local M=i(100/Y(S.fog_end,1),0,1);
        if O(x.Density-M)>0.001 then
            x.Density=M;
        end;
        if x.Color~=S.fog_col then
            x.Color=S.fog_col;
        end;
    end;
    if o.FogStart~=S.fog_start then
        o.FogStart=S.fog_start;
    end;
    if o.FogEnd~=S.fog_end then
        o.FogEnd=S.fog_end;
    end;
    if o.FogColor~=S.fog_col then
        o.FogColor=S.fog_col;
    end;
else
    p();
    if o.FogStart~=T.fog_start then
        o.FogStart=T.fog_start;
    end;
    if o.FogEnd~=T.fog_end then
        o.FogEnd=T.fog_end;
    end;
    if o.FogColor~=T.fog_col then
        o.FogColor=T.fog_col;
    end;
end;
if S.cc then
    local Y=B();
    Y.Enabled=true;
    local O,x,M=S.cc_sat/100,S.cc_bright/100,S.cc_contrast/100;
    if Y.Saturation~=O then
        Y.Saturation=O;
    end;
    if Y.Brightness~=x then
        Y.Brightness=x;
    end;
    if Y.Contrast~=M then
        Y.Contrast=M;
    end;
    if Y.TintColor~=S.cc_tint then
        Y.TintColor=S.cc_tint;
    end;
elseif  A then
    if A.Parent then
        A.Enabled=false;
    end;
end;
if S.bloom then
    local Y=N();
    Y.Enabled=true;
    local O,x=S.bloom_power/100,S.bloom_limit/100;
    if Y.Intensity~=O then
        Y.Intensity=O;
    end;
    if Y.Size~=S.bloom_size then
        Y.Size=S.bloom_size;
    end;
    if Y.Threshold~=x then
        Y.Threshold=x;
    end;
elseif  a then
    if a.Parent then
        a.Enabled=false;
    end;
end;
if S.sky~=K or S.sky_preset~=X then
    local Y,O=S.sky,S.sky_preset;
    K,X=Y,O;
    if S.sky then
        P(S.sky_preset);
    else
        I();
    end;
end;
if S.fx~=q then
    q=S.fx;
    if S.fx then
        r();
    else
        w();
    end;
end;
local K=S.fx and(S.fx_type~=U or S.fx_col~=z or S.fx_rate~=J);
if K then
    Z(S.fx_type,S.fx_col,S.fx_rate);
    if n then
        local K=n;
        K:Emit(i(j(S.fx_rate*0.16),30,140));
    end;
end;
local j,K,i=S.fx_type,S.fx_col,S.fx_rate;
U,z,J=j,K,i;
end,step_fx=function()if R then
    if not(R.Parent)then
        return;
    end;
else
    return;
end;
local j=t.CurrentCamera;
if not(j)then
    return;
end;
local K=j.CFrame;
local t,i=K.Position,K.LookVector;
j=Vector3.new(i.X,0,i.Z);
j=if j.Magnitude<0.05 then
    Vector3.new(0,0,-1)
else
    j.Unit;
    if E then
        if d then
            if(t-E).Magnitude<10 then
                if j:Dot(d)>0.95 then
                    return;
                end;
            end;
        end;
    end;
    E,d=t,j;
    i=R;
    i.CFrame=CFrame.new(t+j*57.2+Vector3.new(0,44,0));
end,unload=function()S.third=false;
S.body_chams=false;
S.body_chams_mat="forcefield";
S.tool_chams=false;
S.tool_chams_mat="forcefield";
S.hand_chams=false;
S.hand_chams_mat="forcefield";
S.tracers=false;
S.impacts=false;
S.hands=false;
S.xhair=false;
S.pen=false;
S.nade_path=false;
w();
I();
if A then
    A:Destroy();
    A=nil;
end;
if a then
    a:Destroy();
    a=nil;
end;
p();
G();
o.Ambient=T.ambient;
o.OutdoorAmbient=T.outdoor;
o.Brightness=T.bright;
o.ExposureCompensation=T.exposure;
o.ClockTime=T.clock;
o.FogColor=T.fog_col;
o.FogStart=T.fog_start;
o.FogEnd=T.fog_end;
o.GlobalShadows=T.shadows;
end
};
b.teardown(h.unload);
return h;
end;
D.K=function()local j,h,b,K=D.load("b"),D.load("q"),D.load("a"),D.load("j");
local S=h.world;
local o=h.misc;
local t=j.lp;
local G=j.workspace;
local i=K.inventory;
local Y=K.spectate;
local K=math.floor;
local O=math.min;
local T,x,p,A=math.max,{AWP=true,["SSG 08"]=true};
local M=j.screen(2147483647);
if not M then
    return{step=function()end
};
end;
M.Enabled=false;
b.own(M);
local j=Instance.new("Frame");
j.Size=UDim2.fromScale(1,1);
j.BackgroundTransparency=1;
j.BorderSizePixel=0;
j.Parent=M;
local a=NumberSequence.new({NumberSequenceKeypoint.new(0,1),NumberSequenceKeypoint.new(0.06,0.957),NumberSequenceKeypoint.new(0.12,0.844),NumberSequenceKeypoint.new(0.18,0.684),NumberSequenceKeypoint.new(0.24,0.5),NumberSequenceKeypoint.new(0.3,0.316),NumberSequenceKeypoint.new(0.36,0.156),NumberSequenceKeypoint.new(0.42,0.043),NumberSequenceKeypoint.new(0.48,0),NumberSequenceKeypoint.new(1,0)});
local B=NumberSequence.new({NumberSequenceKeypoint.new(0,0),NumberSequenceKeypoint.new(0.52,0),NumberSequenceKeypoint.new(0.58,0.043),NumberSequenceKeypoint.new(0.64,0.156),NumberSequenceKeypoint.new(0.7,0.316),NumberSequenceKeypoint.new(0.76,0.5),NumberSequenceKeypoint.new(0.82,0.684),NumberSequenceKeypoint.new(0.88,0.844),NumberSequenceKeypoint.new(0.94,0.957),NumberSequenceKeypoint.new(1,1)});
local function N(I,R)local n=Instance.new("Frame");
n.BackgroundTransparency=1;
n.BorderSizePixel=0;
n.Parent=j;
local j=Instance.new("Frame");
j.BorderSizePixel=0;
j.BackgroundColor3=S.xhair_col;
j.BackgroundTransparency=0;
j.ZIndex=3;
j.AnchorPoint=Vector2.new(0.5,0.5);
j.Position=UDim2.fromScale(0.5,0.5);
j.Size=I and UDim2.new(0,3,1,0)or UDim2.new(1,0,0,3);
j.Parent=n;
local E=Instance.new("UICorner");
E.CornerRadius=UDim.new(1,0);
E.Parent=j;
E=Instance.new("UIGradient");
E.Rotation=I and 90 or 0;
E.Transparency=R and B or a;
E.Parent=j;
return{holder=n,core=j};
end;
local j={};
m:rH(j,0,N(false,false),N(false,true),N(true,false),(N(true,true)));
j[1].holder.AnchorPoint=Vector2.new(1,0.5);
j[2].holder.AnchorPoint=Vector2.new(0,0.5);
j[3].holder.AnchorPoint=Vector2.new(0.5,1);
j[4].holder.AnchorPoint=Vector2.new(0.5,0);
local a,B,N,I;
local function R()if not(A and A.Parent and p and p.Parent)then
    local n=t:FindFirstChildOfClass("PlayerGui");
    p=n and n:FindFirstChild("MainGui");
    n=p and p:FindFirstChild("Gameplay");
    A=n and n:FindFirstChild("Middle");
    if not(A)then
        return false;
    end;
end;
local n=p.Enabled and A.Visible and A.Parent.Visible;
return n;
end;
local function n()local E=t.Character;
if E then
    if E:IsDescendantOf(G)then
        if E:GetAttribute("Dead")~=false then
            return false;
        end;
    else
        return false;
    end;
else
    return false;
end;
local d=E:GetAttribute("Health");
return typeof(d)=="number"and d>0;
end;
local function E()local d=Y.GetCurrentSpectateInstance();
if not(d)then
    return nil;
end;
local Y,w=d.CurrentEquipped,d.Player;
return Y~=nil and x[Y.Name]==true and d.PerspectiveState=="First-Person"and w~=nil and(tonumber(w:GetAttribute("ScopeIncrement"))or 0)>0;
end;
local function Y()if S.xhair then
    if o.scope then
        if not(R())then
            return false;
        end;
    else
        return false;
    end;
else
    return false;
end;
if t:GetAttribute("IsSpectating")==true then
    local o=E();
    if o~=nil then
        return o;
    end;
end;
if not(n())then
    return false;
end;
local o=i.peekCurrentEquippedForMovement();
local t=type(o)=="table"and o.Properties;
return type(t)=="table"and not o.IsDestroyed and o.IsEquipped==true and o.IsAiming==true and t.HasScope==true;
end;
h={step=function()local o,t=pcall(Y);
t=o and t==true;
if t~=I then
    M.Enabled=t;
    I=t;
end;
if not(t)then
    return;
end;
o=G.CurrentCamera;
if not o then
    return;
end;
local t=o.ViewportSize;
local o,G=T(24,K(O(t.X,t.Y)*0.36*S.xhair_size/100)),T(0,S.xhair_gap);
if o~=a or G~=B then
    j[1].holder.Position=UDim2.new(0.5,-G,0.5,0);
    j[1].holder.Size=UDim2.fromOffset(o,10);
    j[2].holder.Position=UDim2.new(0.5,G,0.5,0);
    j[2].holder.Size=UDim2.fromOffset(o,10);
    j[3].holder.Position=UDim2.new(0.5,0,0.5,-G);
    j[3].holder.Size=UDim2.fromOffset(10,o);
    j[4].holder.Position=UDim2.new(0.5,0,0.5,G);
    j[4].holder.Size=UDim2.fromOffset(10,o);
    a,B=o,G;
end;
t=S.xhair_col;
if t~=N then
    for K=1,4,1 do
        j[K].core.BackgroundColor3=t;
    end;
    N=t;
end;
end
};
b.teardown(function()p,A=nil,nil;
end);
return h;
end;
D.L=function()local j=D.load("b");
local h=D.load("a");
local b,K=D.load("j"),j.workspace;
local S=b.raycast;
local o=Enum.Material;
local t=o.Metal;
local G=table.clear;
local i,Y,O=math.max,{},{};
O[o.Cardboard]=10;
O[o.Fabric]=25;
O[o.Glass]=25;
O[o.Plastic]=10;
O[o.SmoothPlastic]=10;
O[o.Wood]=10;
O[o.WoodPlanks]=10;
local T,x,p={["Sandy Brick"]=0,IndoorWall=0},{Reactor=-1};
local function A()local M=K:FindFirstChild("Debris");
p=M and M:FindFirstChild("RaycastVisualizers")or nil;
return M;
end;
o=A();
if o then
    h.connect(o.ChildAdded,function(M)if M.Name=="RaycastVisualizers"then p=M;
end;
end);
h.connect(o.ChildRemoved,function(M)if M==p then
    p=nil;
end;
end);
else
    h.connect(K.ChildAdded,function(M)if M.Name=="Debris"then A();
end;
end);
end;
local A,M={ready=true},RaycastParams.new();
M.FilterType=Enum.RaycastFilterType.Exclude;
M.IgnoreWater=false;
M.CollisionGroup="Bullet";
local a=RaycastParams.new();
a.CollisionGroup="Bullet";
local B=RaycastParams.new();
B.FilterType=Enum.RaycastFilterType.Include;
B.CollisionGroup="Bullet";
local N,I,R={},{},{};
local n,E=j.weak(),{instance=nil,position=nil,normal=nil,material=nil};
local function d(w)local P=n[w];
if P~=nil then
    return P;
end;
P=w.Name=="CollisionCapsule"or w.Name=="HumanoidRootPart"or w:HasTag("CharacterAccessory")or w:FindFirstAncestorWhichIsA("Accessory")~=nil or p~=nil and w:IsDescendantOf(p);
n[w]=P;
return P;
end;
local function n(w)local P=w.Parent;
if P then
    if P:HasTag("BreakableDoor")then
        return t;
    end;
end;
return w.Material;
end;
local function t(w)if w~=0 then
    return w;
end;
local P=K:GetAttribute("Map");
if typeof(P)~="string"then return w;
end;
return x[P]or w;
end;
local function x(w,P,r,L)r=r or M;
r.FilterDescendantsInstances=L or Y;
local M=(K:Raycast(w,P,r));
while M do
    local L=M.Instance;
    if not(d(L))then
        E.instance=L;
        E.position=M.Position;
        E.normal=M.Normal;
        E.material=M.Material;
        return E;
    end;
    r:AddToFilter(L);
    M=(K:Raycast(w,P,r));
end;
E.instance=nil;
E.position=w+P;
E.normal=nil;
E.material=nil;
return E;
end;
local function M(w,P,r,L)local Z=x(w,P,r,L);
return{instance=Z.instance,position=Z.position,normal=Z.normal,material=Z.material};
end;
local function w(P,r,L,Z,X,q)a.FilterDescendantsInstances=Z or Y;
G(I);
G(R);
Z=r.Unit;
local Y,U,z,J,y=Z*1000,{},false,P,0;
for f=1,100,1 do
    if z then
        break;
    end;
    r=1000;
    if q then
        r=q+8-i((J-P):Dot(Z),0);
        if r<=0 then
            break;
        end;
    else
    end;
    f=K:Raycast(J,Z*r,a);
    if not f then
        break;
    end;
    local i=f.Instance;
    a:AddToFilter(i);
    if d(i)then
    else
        local a=f.Position;
        y+=1;
        U[y]={instance=i,position=a,normal=f.Normal,material=n(i)};
        local d=X~=nil and(i.Parent==X or i:IsDescendantOf(X));
        z=if d then
            true
        else
            if q then
                if(a-P):Dot(Z)>=q then
                    true
                else
                    z
                else
                    z;
                    N[1]=i;
                    B.FilterDescendantsInstances=N;
                    local i=a+Y;
                    local Y=K:Raycast(i,a-i,B);
                    if not(Y)then
                        break;
                    end;
                    local K,B=Y.Instance,(a-Y.Position).Magnitude;
                    i=K.MaterialVariant;
                    local P,r=i~=""and T[i]or nil;
                    if P~=nil then
                        if not(d)then
                            a=(R[i]or 0)+B;
                            R[i]=a;
                            if a>t(P)+L then
                                break;
                            end;
                        end;
                        r=(n(K));
                    else
                        local i=n(K);
                        if not(d)then
                            local T=(I[i]or 0)+B;
                            I[i]=T;
                            if T>t(O[i]or 0)+L then
                                break;
                            end;
                        end;
                        r=Y.Material;
                    end;
                    y+=1;
                    U[y]={instance=K,position=Y.Position,normal=Y.Normal,material=r};
                    J=Y.Position;
                end;
            end;
            return U;
        end;
        A.cast=M;
        A.probe=x;
        A.through=w;
        A.patch=function(K)if type(S)~="table"then return;
    elseif  type(K)~="function"then return;
end;
local t=j.getups;
if type(t)~="function"then return;
end;
local j,i=pcall(t,K);
if j then
    if type(i)~="table"then return;
end;
else
    return;
end;
for j,t in i,nil,nil do
    if t==S.cast then
        h.upvalue(K,j,M);
    elseif  t==S.castThrough then
        h.upvalue(K,j,w);
    end;
end;
end;
o=b.bullet;
if type(o)=="table"then A.patch(rawget(o,"_performRaycast"));
end;
h.teardown(function()G(N);
G(I);
G(R);
E.instance=nil;
E.position=nil;
E.normal=nil;
E.material=nil;
p=nil;
end);
return A;
end;
D.M=function()local j=D.load("b").lp;
return{origin=function(h)local b=h.ViewportSize;
local K,S=h:ViewportPointToRay(b.X*0.5,b.Y*0.5).Origin,j.Character;
if not(S)then
    return K,false;
end;
h=nil;
b=S:FindFirstChild("CameraPart");
if b and(b:IsA("BasePart"))then
    h=b.Position;
else
    local j=S:FindFirstChild("Head");
    if j and(j:IsA("BasePart"))then
        h=j.Position;
    else
        local j=S:FindFirstChild("HumanoidRootPart");
        h=if j then
            if j:IsA("BasePart")then
                j.Position+Vector3.new(0,1.6,0)
            else
                h
            else
                h;
            end;
        end;
        if not h then
            return K,false;
        end;
        if(h-K).Magnitude>1 then
            return h,true;
        end;
        return h,false;
    end
};
end;
D.N=function()local j,h,b,K,S,o=D.load("b"),D.load("q"),D.load("a"),D.load("j"),D.load("L"),D.load("M");
local t=h.world;
local G=h.white;
local h=j.workspace;
local j=S.cast;
local i=S.through;
local Y=K.ray_ignore;
local O=K.inventory;
local T=K.legit_ready;
local K=math.clamp;
local x=math.floor;
local p=math.abs;
local A=math.tan;
local M=math.rad;
local a=math.max;
local B=Instance.new("Part");
B.Anchored=true;
B.CanCollide=false;
B.CanQuery=false;
B.CanTouch=false;
B.CastShadow=false;
B.Massless=true;
B.Transparency=1;
B.Size=Vector3.new(0.01,0.01,0.001);
B.CFrame=CFrame.new(0,-100000,0);
B.Parent=h;
b.own(B);
local N=Instance.new("SurfaceGui");
N.Adornee=B;
N.AlwaysOnTop=true;
N.LightInfluence=0;
N.Face=Enum.NormalId.Front;
N.CanvasSize=Vector2.new(64,64);
N.Enabled=false;
N.Parent=B;
local I=Instance.new("Frame");
I.Size=UDim2.fromScale(1,1);
I.BackgroundColor3=t.pen_no;
I.BackgroundTransparency=0.58;
I.BorderSizePixel=0;
I.Parent=N;
local R=Instance.new("UIStroke");
R.ApplyStrokeMode=Enum.ApplyStrokeMode.Border;
R.LineJoinMode=Enum.LineJoinMode.Miter;
R.Thickness=7;
R.Color=t.pen_no:Lerp(G,0.18);
R.Transparency=0.04;
R.Parent=I;
local n=RaycastParams.new();
n.FilterType=Enum.RaycastFilterType.Exclude;
n.IgnoreWater=false;
n.CollisionGroup="Bullet";
local E,d,w,P,r;
local L,Z,X,q=false,0;
local function U()E,d,w,P,r,L=nil,nil,nil,nil,nil,false;
if N.Enabled then
    N.Enabled=false;
end;
end;
local function z(J,y,f,k)local g=Y();
local Q=j(J,y*f,n,g);
if Q then
    if Q.instance then
        if typeof(Q.position)~="Vector3"then return Q,false;
    end;
else
    return Q,false;
end;
else
    return Q,false;
end;
f=i(J,y,k,g,nil,a((Q.position-J):Dot(y)-0.05,0));
y,J=f and f[1],f and f[2];
return Q,y~=nil and J~=nil and y.instance==Q.instance and J.instance==Q.instance;
end;
S={step=function()if not(t.pen)then
    if d then
        U();
    elseif  N.Enabled then
        U();
    end;
    return;
end;
if not(B.Parent)then
    return;
end;
local a=h.CurrentCamera;
if not(a)then
    U();
    return;
end;
local n=os.clock();
if n-Z>=0.033 then
    Z=n;
    local Z=O and O.peekCurrentEquippedForMovement();
    local O=Z and Z.Properties;
    if T and type(j)=="function"and type(i)=="function"and type(Y)=="function"and Z~=nil and not Z.IsDestroyed and Z.IsEquipped~=false then
        if O~=nil then
            if O.Class=="Weapon"then local j=a.ViewportSize;
            local i,Y,T=a:ViewportPointToRay(j.X*0.5,j.Y*0.5).Direction,tonumber(O.Range)or 500,tonumber(O.Penetration)or 0;
            if i.Magnitude<=0 then
                U();
            elseif  Y<=0 then
                U();
            else
                j=i.Unit;
                local i,O,Z=pcall(z,o.origin(a),j,Y,T);
                if if i then
                    not O
                else
                    not i then
                        U();
                    elseif  O.instance then
                        if typeof(O.position)~="Vector3"then U();
                    else
                        local o=typeof(O.normal)=="Vector3"and O.normal or-j;
                        o,E,P,r=o.Magnitude<=0 and-j or o.Unit,nil,nil,nil;
                        d,w=O.position,o;
                        L=Z==true;
                        if O.instance:IsA("BasePart")then
                            local j=O.instance.CFrame;
                            E=O.instance;
                            P=j:PointToObjectSpace(O.position);
                            r=j:VectorToObjectSpace(o);
                        end;
                    end;
                else
                    U();
                end;
            end;
        else
            U();
        end;
    else
        U();
    end;
else
    U();
end;
end;
if not(d)then
    return;
end;
local j,o=d,w;
if E then
    if not(E:IsDescendantOf(h))then
        U();
        return;
    end;
    n=E.CFrame;
    j,o=n:PointToWorldSpace(P),n:VectorToWorldSpace(r);
    if o.Magnitude<=0 then
        U();
        return;
    end;
    o=o.Unit;
else
end;
n=a.ViewportSize;
local h=a:ViewportPointToRay(n.X*0.5,n.Y*0.5);
local i=h.Direction;
if i.Magnitude>0 then
    i=i.Unit;
    local Y=o:Dot(i);
    if p(Y)>0.001 then
        local O=o:Dot(j-h.Origin)/Y;
        j=if O>0 then
            h.Origin+i*O
        else
            j;
        else
        end;
    else
    end;
    i=a.CFrame;
    h=(j-i.Position):Dot(i.LookVector);
    if h<=0 then
        N.Enabled=false;
        return;
    end;
    local Y=i.UpVector;
    Y-=o*Y:Dot(o);
    if Y.Magnitude<=0.001 then
        Y=i.RightVector;
        Y-=o*Y:Dot(o);
    else
    end;
    if Y.Magnitude<=0.001 then
        N.Enabled=false;
        return;
    end;
    Y=Y.Unit;
    local O,T,p=x(K(tonumber(t.pen_size)or 12,6,36)+0.5),math.max(n.Y,1),1+K((16-h)/16,0,1)*0.6;
    i=math.max(0.004,2*h*A(M(a.FieldOfView*0.5))*O*p/T);
    h=K(i*0.015,0.002,0.025);
    B.Size=Vector3.new(i,i,0.001);
    B.CFrame=CFrame.lookAt(j+o*h,j+o*(h+1),Y);
    T=L and t.pen_yes or t.pen_no;
    if T~=X then
        X=T;
        I.BackgroundColor3=T;
        R.Color=T:Lerp(G,0.18);
    end;
    if O~=q then
        q=O;
        R.Thickness=K(64/O,3,16);
    end;
    if not(N.Enabled)then
        N.Enabled=true;
    end;
end
};
b.teardown(U);
return S;
end;
D.O=function()local j=bit32.bxor;
local h=bit32.band;
local b=bit32.rshift;
local K=math.floor;
local S=math.ceil;
local o=math.min;
local t,G=math.clamp,{};
for i=0,255,1 do
    local Y=i;
    for O=1,8,1 do
        Y=if Y%2==1 then
            j(3988292384,b(Y,1))
        else
            b(Y,1);
        end;
        G[i]=Y;
    end;
    local function i(Y,O,T)local x=4294967295;
    for p=O,O+T-1,1 do
        x=j(G[h(j(x,buffer.readu8(Y,p)),255)],b(x,8));
    end;
    return j(x,4294967295);
end;
local function j(G,Y,O)buffer.writeu8(G,Y,h(b(O,24),255));
buffer.writeu8(G,Y+1,h(b(O,16),255));
buffer.writeu8(G,Y+2,h(b(O,8),255));
buffer.writeu8(G,Y+3,h(O,255));
end;
local G={137,80,78,71,13,10,26,10};
local Y={mask=function(O,T,x)if not(buffer)then
    return nil;
end;
local p=T*(1+O*4);
local A,M,a=buffer.create(p),1,0;
local function B(N)M=(M+N)%65521;
a=(a+M)%65521;
end;
local N=0;
for I=0,T-1,1 do
    local R=(I+0.5)/T;
    buffer.writeu8(A,N,0);
    B(0);
    N+=1;
    for n=0,O-1,1 do
        I=K(t(x(math.abs((n+0.5)/O*2-1),R),0,1)*255+0.5);
        buffer.writeu8(A,N,255);
        buffer.writeu8(A,N+1,255);
        buffer.writeu8(A,N+2,255);
        buffer.writeu8(A,N+3,I);
        B(255);
        B(255);
        B(255);
        B(I);
        N+=4;
    end;
end;
x=2+math.max(1,S(p/65535))*5+p+4;
local K,S=buffer.create(45+x+12),0;
for t=1,#G,1 do
    buffer.writeu8(K,S,G[t]);
    S+=1;
end;
j(K,S,13);
S+=4;
buffer.writestring(K,S,"IHDR");
B=S;
S=B+4;
j(K,S,O);
S+=4;
j(K,S,T);
S+=4;
buffer.writeu8(K,S,8);
S+=1;
buffer.writeu8(K,S,6);
S+=1;
buffer.writeu8(K,S,0);
S+=1;
buffer.writeu8(K,S,0);
S+=1;
buffer.writeu8(K,S,0);
S+=1;
j(K,S,i(K,B,17));
S+=4;
j(K,S,x);
S+=4;
buffer.writestring(K,S,"IDAT");
T=S;
S=T+4;
buffer.writeu8(K,S,120);
S+=1;
buffer.writeu8(K,S,1);
B=p;
S+=1;
O=0;
while B>0 do
    p=o(65535,B);
    buffer.writeu8(K,S,B-p==0 and 1 or 0);
    S+=1;
    buffer.writeu8(K,S,h(p,255));
    S+=1;
    buffer.writeu8(K,S,h(b(p,8),255));
    S+=1;
    local o=h(bit32.bnot(p),65535);
    buffer.writeu8(K,S,h(o,255));
    S+=1;
    buffer.writeu8(K,S,h(b(o,8),255));
    S+=1;
    buffer.copy(K,S,A,O,p);
    S+=p;
    O+=p;
    B=B-p;
end;
j(K,S,a*65536+M);
S+=4;
j(K,S,i(K,T,4+x));
S+=4;
j(K,S,0);
S+=4;
buffer.writestring(K,S,"IEND");
j(K,S+4,i(K,S,4));
return buffer.tostring(K);
end
};
return Y;
end;
D.P=function()local j=D.load("b");
local h,b=D.load("q"),D.load("f");
local K=D.load("a");
local S=D.load("j");
local o,t=D.load("O"),D.load("H");
local G=h.world;
local i=j.workspace;
local Y=j.tween;
local O=j.debris;
local T,x=j.custom_asset,math.clamp;
local p=math.max;
local A=math.min;
local M=math.abs;
local a=math.exp;
local B=math.tan;
local N=math.rad;
local I,I,R=math.floor,Color3.new(1,1,1),true;
local function n(E)return x(tonumber(E)or 0,0,1);
end;
local function E(d)d=n(d);
return d*d*(3-2*d);
end;
local function d(w,P)local r=E(A(P,1-P)/0.18);
local E,L=0.004+r^2.6*0.996,r^1.25;
r,P=w/(0.26*E),w/(0.8*E);
E=n(L*a(-(r*r)*2.66))*0.98;
return E+n(L*a(-(P*P)*2.66))*0.4*(1-E);
end;
local a;
h=K.shared;
local E,w=h.beam_uri,false;
if type(isfile)=="function"then local P,r=pcall(isfile,"bs_beam_profile_v2.png");
w=P and r==true;
else
end;
local P;
if type(E)=="string"and#E>0 and w then
    P=E;
else
    if type(writefile)=="function"then if type(T)=="function"then if buffer then
        local w=o.mask(128,512,d);
        if w then
            if pcall(writefile,"bs_beam_profile_v2.png",w)then
                local w,r=pcall(T,"bs_beam_profile_v2.png");
                if w then
                    if type(r)=="string"then if#r>0 then
                        h.beam_uri=r;
                        a=r;
                    else
                    end;
                else
                end;
            else
            end;
        else
        end;
    else
    end;
else
end;
else
end;
else
end;
P=a;
end;
local h,T={},{0,0.02,0.05,0.09,0.13,0.18,0.5,0.82,0.87,0.91,0.95,0.98,1};
for a=1,#T,1 do
    h[a]={T[a],1-d(0,T[a])};
end;
local function a(w)if P then
    return NumberSequence.new(n(w));
end;
local r,L={},1-n(w);
for Z=1,#h,1 do
    w=h[Z];
    r[Z]=NumberSequenceKeypoint.new(w[1],n(1-(1-w[2])*L));
end;
return NumberSequence.new(r);
end;
local h=Instance.new("Part");
h.Anchored=true;
h.CanCollide=false;
h.CanQuery=false;
h.CanTouch=false;
h.CastShadow=false;
h.Transparency=1;
h.Size=Vector3.one;
h.CFrame=CFrame.new();
h.Parent=i.CurrentCamera or i;
K.own(h);
K.connect(i:GetPropertyChangedSignal("CurrentCamera"),function()if not(R)then
    return;
end;
local n=i.CurrentCamera;
if n then
    if h.Parent~=n then
        h.Parent=n;
    end;
end;
end);
local n,w,r={},{},0;
local function L()local Z=Instance.new("Attachment");
Z.Parent=h;
local X=Instance.new("Attachment");
X.Parent=h;
local q=Instance.new("Beam");
q.Attachment0=Z;
q.Attachment1=X;
q.FaceCamera=true;
q.TextureMode=Enum.TextureMode.Stretch;
q.TextureSpeed=0;
q.TextureLength=1;
q.LightEmission=0;
q.LightInfluence=0;
q.Segments=2;
q.CurveSize0=0;
q.CurveSize1=0;
q.ZOffset=0;
q.Width0=0;
q.Width1=0;
q.Color=ColorSequence.new(I);
q.Transparency=NumberSequence.new(1);
q.Enabled=false;
if P then
    q.Texture=P;
end;
q.Parent=h;
local h=Instance.new("NumberValue");
h.Value=1;
h.Parent=q;
local P={beam=q,first=Z,second=X,driver=h,conn=h:GetPropertyChangedSignal("Value"):Connect(function()q.Transparency=a(h.Value);
end)};
r+=1;
return P;
end;
local function h(P)local Z=P.tween;
if not(Z)then
    return;
end;
P.tween=nil;
pcall(Z.Cancel,Z);
end;
local function P(Z)h(Z);
Z.beam.Enabled=false;
end;
local function Z(X)h(X);
if X.conn then
    X.conn:Disconnect();
    X.conn=nil;
end;
pcall(X.beam.Destroy,X.beam);
pcall(X.first.Destroy,X.first);
pcall(X.second.Destroy,X.second);
end;
local function X(q)P(q);
n[#n+1]=q;
end;
local function P()local q=table.remove(n);
if q then
    return q;
end;
if r<96 then
    return L();
end;
q=table.remove(w,1);
if q then
    h(q);
end;
return q;
end;
local function h(r,L,q)local U=r.ViewportSize;
if U.Y<=0 then
    return 0;
end;
return L*(2*q*B(N(r.FieldOfView)*0.5))/U.Y;
end;
local function B(N,r)if R then
    if N.tween~=r then
        return;
    end;
else
    return;
end;
for r=#w,1,-1 do
    if w[r]==N then
        b.drop(w,r);
        break;
    end;
end;
X(N);
end;
local function N(r,L,q,U,z)if R then
    if typeof(r)~="Vector3"then return;
elseif  typeof(L)~="Vector3"then return;
end;
else
    return;
end;
if(L-r).Magnitude<0.05 then
    return;
end;
local J=i.CurrentCamera;
if not(J)then
    return;
end;
local y=P();
if not(y)then
    return;
end;
local P=tonumber(U)or 5;
P=x(if P<=0.25 then
    P*100
else
    P,1,20)*1.25;
    local f,k,g=x(tonumber(z)or 1.2,0.05,10),(typeof(q)=="Color3"and q or I):Lerp(I,0.15),J.CFrame;
    U,z=p(-g:PointToObjectSpace(r).Z,0.25),p(-g:PointToObjectSpace(L).Z,0.25);
    q,g=h(J,P,U),h(J,P,z);
    if q<=0 then
        X(y);
        return;
    elseif  g<=0 then
        X(y);
        return;
    end;
    U=A(0.08,f*0.2);
    local h,A,I=p(f-U,0.01),y.beam,y.driver;
    y.first.Position=r;
    y.second.Position=L;
    A.Color=ColorSequence.new(k);
    A.Width0=q;
    A.Width1=g;
    I.Value=0;
    A.Transparency=a(0);
    A.Enabled=true;
    k=Y:Create(I,TweenInfo.new(h,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut,0,false,U),{Value=1});
    y.tween=k;
    w[#w+1]=y;
    k:Play();
    task.delay(f+0.02,B,y,k);
end;
local h={};
local function Y(p,A,a)local B=Instance.new("Part");
B.Size=Vector3.new(0.05,0.05,0.05);
B.CFrame=CFrame.new(p);
B.Anchored=true;
B.CanCollide=false;
B.CanQuery=false;
B.CanTouch=false;
B.CastShadow=false;
B.Transparency=1;
B.Parent=i:FindFirstChild("Debris")or i;
p=Instance.new("BoxHandleAdornment");
p.Adornee=B;
p.Size=Vector3.new(0.35,0.35,0.35);
p.CFrame=CFrame.new();
p.AlwaysOnTop=true;
p.ZIndex=10;
p.Color3=A;
p.Transparency=0;
p.Visible=true;
p.Parent=B;
local i,A=#h+1,{part=B,box=p};
A.born,A.life,h[i]=os.clock(),a,A;
O:AddItem(B,a+0.5);
end;
local i=b.queue.new(16);
local function O(p)while true do
    local A=i:peek();
    if A then
        if p-A.time<=0.75 then
            break;
        end;
    else
        break;
    end;
    i:shift();
end;
while i:count()>64 do
    i:shift();
end;
end;
local function p(A,a)O((os.clock()));
local B=i.items;
for I=i.head,i.tail,1 do
    local P=B[I].packet;
    if type(P)=="table"then if type(P.Distance)=="number"then if typeof(P.Direction)=="Vector3"then if M(P.Distance-A)<=0.001 then
        if(P.Direction-a).Magnitude<=1.0E-5 then
            i:remove(I);
            return P;
        end;
    end;
end;
end;
end;
end;
return nil;
end;
local A={};
local function a(B,I)local P=1;
A[1]=B;
B=I.Hits;
if type(B)=="table"then for r=1,#B,1 do
    local L=B[r];
    if L then
        if typeof(L.Position)=="Vector3"then r=P+1;
        A[r]=L.Position;
        P=r;
    else
    end;
else
end;
end;
else
end;
if P==1 then
    if typeof(I.Origin)~="Vector3"then return;
elseif  typeof(I.Direction)~="Vector3"then return;
elseif  type(I.Distance)~="number"then return;
elseif  I.Distance<=0 then
    return;
end;
A[2]=I.Origin+I.Direction*I.Distance;
P=2;
else
end;
b.trim(A,P);
for B=1,P-1,1 do
    N(A[B],A[B+1],G.tracers_col,G.tracers_width,G.tracers_life);
end;
end;
local B={impacts=function(N)if G.impacts then
    if type(N)~="table"then return;
end;
else
    return;
end;
local I=N.Hits;
if type(I)~="table"then return;
end;
N=x(tonumber(G.impacts_life)or 3,1,30);
for x=1,#I,1 do
    local P=I[x];
    x=P and P.Position;
    if typeof(x)=="Vector3"then Y(x,G.impacts_col,N);
end;
end;
end,step=function()local Y=#h;
if Y==0 then
    return;
end;
local x=os.clock();
for N=Y,1,-1 do
    local Y=h[N];
    local I=Y.part;
    if I.Parent then
        local P=(x-Y.born)/Y.life;
        if P>=1 then
            b.drop(h,N);
            I:Destroy();
        else
            Y.box.Transparency=P;
        end;
    else
        b.drop(h,N);
    end;
end;
end
};
local function Y(x,N)local I=x.Hits;
if type(I)~="table"then return nil,nil;
end;
local P;
for r=#I,1,-1 do
    local L=I[r];
    if L and typeof(L.Position)=="Vector3"then P=L.Position;
    break;
end;
end;
P=P or(if typeof(x.Origin)=="Vector3"then if typeof(x.Direction)=="Vector3"then if type(x.Distance)=="number"then if x.Distance>0 then
    x.Origin+x.Direction*x.Distance
else
    P
else
    P
else
    P
else
    P);
    if not(P)then
        return nil,nil;
    end;
    I=P-N;
    N=I.Magnitude;
    if N<0.05 then
        return nil,nil;
    end;
    return N,I/N;
end;
local x;
do
    local N=S.tracer_fx;
    if type(N)=="function"then local function I(P,r,L,...)if t.on()then
        local X=t.muzzle();
        r=if X then
            X.Position
        else
            r;
        else
        end;
        if typeof(P)=="number"then if P>0 then
            if typeof(r)=="Vector3"then if typeof(L)=="Vector3"then if M(L.Magnitude-1)<=0.02 then
                local M=p(P,L);
                if M then
                    if G.tracers then
                        pcall(a,r,M);
                    end;
                    local p,a=Y(M,r);
                    if p then
                        if a then
                            return N(p,r,a,...);
                        end;
                    end;
                end;
            end;
        end;
    end;
end;
end;
return N(P,r,L,...);
end;
T=S.weapon;
E=type(T)=="table"and rawget(T,"shoot")or nil;
if type(E)=="function"and type(j.getups)=="function"then o,d=pcall(j.getups,E);
if o and type(d)=="table"then for o,Y in d,nil,nil do
    if Y==N then
        if K.upvalue(E,o,I)then
            x=E;
        else
        end;
        break;
    end;
end;
else
end;
else
end;
else
end;
end;
B.attach=function(o)local Y=S.bullet;
if type(Y)~="table"then return;
elseif  type(Y.create)~="function"then return;
end;
K.field(Y,"create",function(S)return function(Y,T,p)local M=S(Y,T,p);
if x and(G.tracers or t.on())then
    O(os.clock());
    if type(M)=="table"then if typeof(M.Origin)=="Vector3"then if typeof(M.Direction)=="Vector3"then if type(M.Distance)=="number"then if M.Distance>0 then
        i:push({packet=M,time=os.clock()});
    end;
end;
end;
end;
end;
end;
if G.impacts then
    j.elevate(B.impacts,M);
end;
if o then
    j.elevate(o,Y,M);
end;
return M;
end;
end);
end;
B.unload=function()R=false;
G.tracers=false;
G.impacts=false;
for j=#h,1,-1 do
    local S=h[j];
    h[j]=nil;
    if S.part.Parent then
        pcall(S.part.Destroy,S.part);
    end;
end;
for j=#w,1,-1 do
    Z(w[j]);
    w[j]=nil;
end;
for j=#n,1,-1 do
    Z(n[j]);
    n[j]=nil;
end;
i:reset();
b.trim(A,0);
end;
K.teardown(B.unload);
return B;
end;
D.Q=function()local j,h,b=D.load("b"),D.load("q"),D.load("a");
local K=j.assets;
local S=math.clamp;
local o=math.min;
local t=math.max;
local G=math.floor;
local i=math.ceil;
local Y=math.abs;
local O=string.sub;
local T=Color3.new(1,1,1);
local x=Color3.new();
local p,A=Vector2.zero,{alive=true,available=false,resolution=256,owners={}};
local M=j.screen(2147479999);
A.gui=M;
A.available=M~=nil;
local j=Enum.ImageCombineType.Overwrite;
local a,B=A.owners,{};
local function N(I)local R=a[I];
if R then
else
    R={open=false,ready=false,failed=false,expect=false,fill_used=0,fills={},stroke_used=0,strokes={},point_used=0,points={}};
    a[I]=R;
    B[#B+1]=I;
end;
return R;
end;
local function I(R)if not(R)then
    return;
end;
local n=R.banks;
for E=1,#n,1 do
    R=n[E];
    if R then
        if R.label then
            pcall(R.label.Destroy,R.label);
        end;
        if R.image then
            pcall(R.image.Destroy,R.image);
        end;
    end;
end;
end;
local function R(n)if not(n)then
    return;
end;
local E=n.banks;
for d=1,#E,1 do
    n=E[d];
    if n then
        d=n.groups;
        for n=1,#d,1 do
            local E=d[n];
            if E then
                pcall(E.Destroy,E);
            end;
        end;
    end;
end;
end;
local function n(E)if not(E)then
    return;
end;
local d=E.banks;
for w=1,#d,1 do
    E=d[w];
    if E then
        w=E.frames;
        for E=1,#w,1 do
            local d=w[E];
            if d then
                pcall(d.Destroy,d);
            end;
        end;
    end;
end;
end;
local E;
local function d()local w,P=E,Vector2.new(A.resolution,A.resolution);
for r=1,2,1 do
    local L=K:CreateEditableImage({Size=P});
    if not(L)then
        error("image");
    end;
    local K={image=L};
    w.banks[r]=K;
    r=Instance.new("ImageLabel");
    K.label=r;
    r.BackgroundTransparency=1;
    r.BorderSizePixel=0;
    r.ImageColor3=T;
    r.ImageTransparency=0.72;
    r.ScaleType=Enum.ScaleType.Stretch;
    r.Visible=false;
    r.ZIndex=1;
    r.ImageContent=Content.fromObject(L);
    r.Parent=M;
end;
end;
local function K()local w=E;
for P=1,2,1 do
    local r={groups={},paths={}};
    w.banks[P]=r;
    for w=1,3,1 do
        P=Instance.new("CanvasGroup");
        r.groups[w]=P;
        P.BackgroundTransparency=1;
        P.BorderSizePixel=0;
        P.Position=UDim2.fromOffset(0,0);
        P.Size=UDim2.fromScale(1,1);
        P.GroupTransparency=1;
        P.Visible=false;
        P.ZIndex=w+2;
        P.Parent=M;
        local L=Instance.new("Path2D");
        r.paths[w]=L;
        L.Visible=false;
        L.ZIndex=w+2;
        L.Parent=P;
    end;
end;
end;
local function w()local P=E;
for r=1,2,1 do
    local L={frames={}};
    P.banks[r]=L;
    for P=1,3,1 do
        r=Instance.new("Frame");
        L.frames[P]=r;
        r.AnchorPoint=Vector2.new(0.5,0.5);
        r.BackgroundTransparency=1;
        r.BorderSizePixel=0;
        r.Visible=false;
        r.ZIndex=P+11;
        r.Parent=M;
        P=Instance.new("UICorner");
        P.CornerRadius=UDim.new(1,0);
        P.Parent=r;
    end;
end;
end;
local function P(r,L)if A.alive then
    if not(A.available)then
        return nil;
    end;
else
    return nil;
end;
local Z={banks={},active=0};
E=Z;
local X=pcall(r);
E=nil;
if not(X)then
    L(Z);
    return nil;
end;
return Z;
end;
local function E(r)return typeof(r)=="Vector2"and r.X==r.X and r.Y==r.Y and Y(r.X)<100000000 and Y(r.Y)<100000000;
end;
local function r(L,Z,X,q)if type(X)~="table"then return false;
end;
local U,z,J,y,f=typeof(q)=="Vector2"and q or p,o(L.X,Z.X),o(L.Y,Z.Y),t(L.X,Z.X),t(L.Y,Z.Y);
for Z=1,#X,1 do
    q=X[Z];
    if typeof(q)=="Instance"then if q.Parent then
        if q.Visible then
            L,Z=q.AbsolutePosition+U,q.AbsoluteSize;
            if Z.X>0 then
                if Z.Y>0 then
                    if z<L.X+Z.X then
                        if y>L.X then
                            if J<L.Y+Z.Y then
                                if f>L.Y then
                                    return true;
                                end;
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;
end;
end;
return false;
end;
local L,Z,X={},{},{};
local function q(U,z)local J=0;
for y=1,#U,1 do
    local f=U[y];
    if E(f)then
        y=J>0 and L[J]or nil;
        if y then
            if(f-y).Magnitude>0.2 then
                local y=J+1;
                L[y]=f;
                J=y;
            else
            end;
        else
            local y=J+1;
            L[y]=f;
            J=y;
        end;
    else
    end;
end;
J=if z then
    if J>2 then
        if(L[1]-L[J]).Magnitude<=0.2 then
            J-1
        else
            J
        else
            J
        else
            J;
            if J<=96 then
                return L,J;
            end;
            U=z and J or J-1;
            X[1]=0;
            for y=1,U,1 do
                local f=y==J and 1 or y+1;
                X[y+1]=X[y]+(L[f]-L[y]).Magnitude;
            end;
            local y=X[U+1];
            if y<=0.2 then
                return L,0;
            end;
            local f=1;
            for k=1,96,1 do
                local g=y*(z and(k-1)/96 or(k-1)/95);
                while f<U and X[f+1]<g do
                    f+=1;
                end;
                local U,z=f==J and 1 or f+1,X[f+1]-X[f];
                local J=z>0 and(g-X[f])/z or 0;
                Z[k]=L[f]:Lerp(L[U],S(J,0,1));
            end;
            return Z,96;
        end;
        local L={};
        local function Z(X,U,z)for J=1,U,1 do
            local y,f,k=X[J];
            if z then
                local z,g=X[J==1 and U or J-1],X[J==U and 1 or J+1];
                local Q,c=(g-z)/6,o((y-z).Magnitude,(g-y).Magnitude)*0.42;
                Q=if Q.Magnitude>c then
                    if Q.Magnitude>0 then
                        Q.Unit*c
                    else
                        Q
                    else
                        Q;
                        f,k=-Q,Q;
                    else
                        if J==1 and U>1 then
                            f,k=p,(X[2]-y)/3;
                        else
                            if J==U and U>1 then
                                f,k=(X[U-1]-y)/3,p;
                            else
                                if U>2 then
                                    local z,g=X[J-1],X[J+1];
                                    local X,Q=(g-z)/6,o((y-z).Magnitude,(g-y).Magnitude)*0.42;
                                    X=if X.Magnitude>Q then
                                        if X.Magnitude>0 then
                                            X.Unit*Q
                                        else
                                            X
                                        else
                                            X;
                                            f,k=-X,X;
                                        else
                                            f,k=p,p;
                                        end;
                                    end;
                                end;
                            end;
                            L[J]=Path2DControlPoint.new(UDim2.fromOffset(y.X,y.Y),UDim2.fromOffset(f.X,f.Y),UDim2.fromOffset(k.X,k.Y));
                        end;
                        for X=#L,U+1,-1 do
                            L[X]=nil;
                        end;
                        return L;
                    end;
                    local function X(U)if U then
                        if not(U.label)then
                            return true;
                        end;
                    else
                        return true;
                    end;
                    U.label.Visible=false;
                    return true;
                end;
                local function U(z)if not(z)then
                    return true;
                end;
                local J=z.banks;
                for z=1,#J,1 do
                    X(J[z]);
                end;
                return true;
            end;
            local function z(J)if not(J)then
                return true;
            end;
            local y,f=J.groups,J.paths;
            for k=1,#y,1 do
                J=f[k];
                if J then
                    J.Visible=false;
                end;
                local J=y[k];
                if J then
                    J.Visible=false;
                end;
            end;
            return true;
        end;
        local function J(y)if not(y)then
            return true;
        end;
        local f=y.banks;
        for y=1,#f,1 do
            z(f[y]);
        end;
        return true;
    end;
    local function y(f)if not(f)then
        return true;
    end;
    local k=f.frames;
    for g=1,#k,1 do
        f=k[g];
        if f then
            f.Visible=false;
        end;
    end;
    return true;
end;
local function f(k)if not(k)then
    return true;
end;
local g=k.banks;
for k=1,#g,1 do
    y(g[k]);
end;
return true;
end;
local function k(g)if g then
    if not(g.label)then
        return false;
    end;
else
    return false;
end;
g.label.Visible=true;
return true;
end;
local function g(Q)local c=Q and Q.groups;
if c then
    if#c<3 then
        return false;
    end;
else
    return false;
end;
for Q=1,3,1 do
    c[Q].Visible=true;
end;
return true;
end;
local function Q(c)local H=c and c.frames;
if H then
    if#H<3 then
        return false;
    end;
else
    return false;
end;
for c=1,3,1 do
    H[c].Visible=true;
end;
return true;
end;
local function c(H,_)if not(H)then
    return;
end;
local s=H.pending;
H.pending=nil;
if type(s)=="number"then if s>0 then
    if s~=H.active then
        _(H.banks[s]);
    end;
end;
end;
end;
local function H(_)local s,F,v=_.fills,_.strokes,_.points;
for u=1,#s,1 do
    c(s[u],X);
end;
for s=1,#F,1 do
    c(F[s],z);
end;
for s=1,#v,1 do
    c(v[s],y);
end;
_.ready=false;
end;
local function c(_,s,F)local v=_.pending;
if v==nil then
    return;
end;
if v==0 then
    F(_);
    _.active=0;
else
    local F,u=_.banks[v],_.banks[_.active];
    if u then
        if u~=F then
            s(u);
        end;
    end;
    _.active=v;
end;
_.pending=nil;
end;
local function _(s)local F,v,u,V=s.fills,s.strokes,s.points,true;
for e=1,#F,1 do
    local l=F[e];
    e=l.pending;
    if type(e)=="number"and e>0 and not k(l.banks[e])then
        V=false;
        break;
    end;
end;
if V then
    for k=1,#v,1 do
        local e=v[k];
        k=e.pending;
        if type(k)=="number"and k>0 and not g(e.banks[k])then
            V=false;
            break;
        end;
    end;
else
end;
if V then
    for k=1,#u,1 do
        local g=u[k];
        k=g.pending;
        if type(k)=="number"and k>0 and not Q(g.banks[k])then
            V=false;
            break;
        end;
    end;
    if not(V)then
        H(s);
        return false;
    end;
else
    H(s);
    return false;
end;
for k=1,#F,1 do
    c(F[k],X,U);
end;
for k=1,#v,1 do
    c(v[k],z,J);
end;
for k=1,#u,1 do
    c(u[k],y,f);
end;
s.ready=false;
return true;
end;
local k={};
local function g()local Q,c,s,F,v,u,V,e=k.bank,k.style,k.color,k.closed,k.width,k.opacity,k.base,k.controls;
local l,C=Q.groups,Q.paths;
for W=1,3,1 do
    local mF,DF,jF;
    if c=="trail"then mF,DF=W==1 and 5.4 or W==2 and 2.7 or 1.25,W==1 and 0.26 or W==2 and 0.72 or 1;
    Q=W==1 and 0.12 or W==2 and 0.42;
    jF=Q or 0.78;
else
    if c=="wave"then mF,DF=W==1 and 5 or W==2 and 2.45 or 0.95,W==1 and 0.22 or W==2 and 0.62 or 1;
    local Q=W==1 and 0.08 or W==2 and 0.34;
    jF=Q or 0.68;
else
    mF,DF=W==1 and 4.8 or W==2 and 2.35 or 1,W==1 and 0.14 or W==2 and 0.46 or 0.94;
    local Q=W==1 and 0 or W==2 and 0.22;
    jF=Q or 0.58;
end;
end;
local Q,c,hF=V+W,l[W],C[W];
c.ZIndex=Q;
c.GroupTransparency=1-u*DF;
hF.ZIndex=Q;
hF.Color3=s:Lerp(T,jF);
hF.Thickness=v*mF;
hF.Closed=F;
hF:SetControlPoints(e);
hF.Visible=true;
end;
end;
local function Q(c,s,F,v,u,V,e,l)if c then
    if F<(v and 3 or 2)then
        return false;
    end;
else
    return false;
end;
local C=c.active~=0 and c.active or 1;
local W=c.banks and c.banks[C];
if not(W)then
    return false;
end;
if C~=c.active then
    z(W);
end;
k.bank=W;
k.style=e;
k.color=u;
k.closed=v;
k.width=t(0.65,tonumber(V)or 1.5);
k.opacity=S(tonumber(l)or 1,0,1);
k.base=e=="trail"and 8 or e=="wave"and 5 or 2;
k.controls=Z(s,F,v);
if not(pcall(g))then
    if C~=c.active then
        z(W);
    end;
    return false;
end;
c.pending=C;
return true;
end;
local function Z(z,k,g,c,s,F,v,u)local V=N(z);
z=V.stroke_used+1;
V.stroke_used=z;
local e=V.strokes[z];
if e then
else
    e=P(K,R);
    if not(e)then
        V.failed=true;
        return false;
    end;
    V.strokes[z]=e;
end;
z=Q(e,k,g,c,s,F,v,u);
if not z then
    V.failed=true;
end;
return z;
end;
local K={};
local function z(k,g,Q,c,s,F,v,u,V)local e,l=q(g,Q);
if l<(Q and 3 or 2)then
    return true;
end;
if type(F)~="table"then return Z(k,e,l,Q,c,s,u,V);
elseif #F==0 then
    return Z(k,e,l,Q,c,s,u,V);
end;
local C,W=0;
if not(Q)then
    W=C;
    for mF=1,l-1,1 do
        local DF,jF=e[mF],e[mF+1];
        if r(DF,jF,F,v)then
            if W>=2 then
                Z(k,K,W,false,c,s,u,V);
            end;
            W=0;
        else
            if W==0 then
                g=W+1;
                K[g]=DF;
                W=g;
            else
                if(DF-K[W]).Magnitude>0.1 then
                    mF=W+1;
                    K[mF]=DF;
                    W=mF;
                else
                end;
            end;
            if(jF-K[W]).Magnitude>0.1 then
                W+=1;
                K[W]=jF;
            else
            end;
        end;
    end;
    if W>=2 then
        Z(k,K,W,false,c,s,u,V);
    end;
    return true;
end;
Q=nil;
for mF=1,l,1 do
    g=mF==l and 1 or mF+1;
    if r(e[mF],e[g],F,v)then
        Q=mF;
        break;
    end;
end;
if not Q then
    return Z(k,e,l,true,c,s,u,V);
end;
W=C;
for mF=1,l,1 do
    g=(Q+mF-1)%l+1;
    mF,C=g==l and 1 or g+1,e[g];
    local g=e[mF];
    if r(C,g,F,v)then
        if W>=2 then
            Z(k,K,W,false,c,s,u,V);
        end;
        W=0;
    else
        if W==0 then
            mF=W+1;
            K[mF]=C;
            W=mF;
        else
            if(C-K[W]).Magnitude>0.1 then
                local Q=W+1;
                K[Q]=C;
                W=Q;
            else
            end;
        end;
        if(g-K[W]).Magnitude>0.1 then
            W+=1;
            K[W]=g;
        else
        end;
    end;
end;
if W>=2 then
    Z(k,K,W,false,c,s,u,V);
end;
return true;
end;
local K={};
local function Z()local k,g,Q,c,s=K.bank,K.at,K.color,K.core,K.opacity;
local F=k.frames;
for k=1,3,1 do
    local v,u,V=k==1 and 3.4 or k==2 and 1.9 or 1,k==1 and 0.13 or k==2 and 0.52 or 1,k==1 and 0.08 or k==2 and 0.36 or 0.78;
    local e,l=c*2*v,F[k];
    l.Position=UDim2.fromOffset(g.X,g.Y);
    l.Size=UDim2.fromOffset(e,e);
    l.BackgroundColor3=Q:Lerp(T,V);
    l.BackgroundTransparency=1-s*u;
end;
end;
local function k(g,Q,c,s,F,v,u)if E(Q)then
    if typeof(c)~="Color3"then return false;
end;
else
    return false;
end;
local V=S(tonumber(u)or 1,0,1);
if V<=0 then
    return true;
elseif  r(Q,Q,F,v)then
    return true;
end;
v=N(g);
g=v.point_used+1;
v.point_used=g;
u=v.points[g];
if u then
else
    u=P(w,n);
    if not u then
        v.failed=true;
        return false;
    end;
    v.points[g]=u;
end;
F=u.active==1 and 2 or 1;
g=u.banks and u.banks[F];
if not g then
    v.failed=true;
    return false;
end;
y(g);
K.bank=g;
K.at=Q;
K.color=c;
K.core=t(1,tonumber(s)or 3);
K.opacity=V;
if not(pcall(Z))then
    y(g);
    v.failed=true;
    return false;
end;
u.pending=F;
return true;
end;
local K,w={begin=function(r)if not(A.alive)then
    return false;
end;
local Z=N(r);
if Z.ready then
    _(Z);
else
    H(Z);
end;
Z.open=true;
Z.failed=false;
Z.expect=false;
Z.fill_used=0;
Z.stroke_used=0;
Z.point_used=0;
return A.available;
end,expectFill=function(r)if A.alive then
    if not(A.available)then
        return false;
    end;
else
    return false;
end;
N(r).expect=true;
return true;
end,stroke=function(r,Z,y,g,Q,c,s,F,v)if A.alive then
    if not(A.available)then
        return false;
    end;
else
    return false;
end;
if type(Z)~="table"then return false;
elseif  typeof(g)~="Color3"then return false;
end;
return z(r,Z,y==true,g,Q,c,s,F,v);
end,point=function(r,Z,y,g,Q,c,s)if A.alive then
    if not(A.available)then
        return false;
    end;
else
    return false;
end;
return k(r,Z,y,g,Q,c,s);
end,trail=function(r,Z,y,g,Q,c,s)if A.alive then
    if not(A.available)then
        return false;
    end;
else
    return false;
end;
if type(Z)~="table"then return false;
elseif #Z<2 then
    return false;
elseif  typeof(y)~="Color3"then return false;
end;
local F,v,u=z(r,Z,false,y,g,Q,c,"trail",s),q(Z,false);
if u>0 then
    k(r,v[u],y,t(2.5,(tonumber(g)or 2)*1.45),Q,c,s);
end;
return F;
end
},{};
K.pulse=function(r,Z,q,y,k,g,Q,c,s)if A.alive then
    if not(A.available)then
        return false;
    end;
else
    return false;
end;
if E(Z)then
    if type(q)~="table"then return false;
elseif #q<3 then
    return false;
elseif  typeof(k)~="Color3"then return false;
end;
else
    return false;
end;
local F=S(tonumber(y)or 0,0,1);
if F<=0.01 then
    return true;
end;
y=#q;
for v=1,y,1 do
    w[v]=Z:Lerp(q[v],F);
end;
for Z=#w,y+1,-1 do
    w[Z]=nil;
end;
return z(r,w,true,k,g,Q,c,"wave",s);
end;
local w=table.create(32);
K.circle=function(r,Z,q,y,k,g,Q,c)if A.alive then
    if not(A.available)then
        return false;
    end;
else
    return false;
end;
if E(Z)then
    if typeof(y)~="Color3"then return false;
end;
else
    return false;
end;
local s=t(0,tonumber(q)or 0);
if s<=0.2 then
    return true;
end;
for F=1,32,1 do
    q=6.283185307179586*(F-1)/32;
    w[F]=Z+Vector2.new(math.cos(q),math.sin(q))*s;
end;
return z(r,w,true,y,k,g,Q,"wave",c);
end;
local w,r,Z,q={},{},{},{};
local z=Vector2.new(A.resolution,A.resolution);
local function y(k,g,Q,c,s,F)if g==0 then
    return 0;
end;
local v=k[g];
local u=Q and v.X or v.Y;
local V=s and u>=c or(if s then
    not s
else
    u<=c);
    local e=0;
    for l=1,g,1 do
        local g=k[l];
        l=Q and g.X or g.Y;
        local k=s and l>=c or(if s then
            not s
        else
            l<=c);
            if k~=V then
                local Q=l-u;
                local s=Q~=0 and(c-u)/Q or 0;
                e+=1;
                F[e]=v+(g-v)*S(s,0,1);
            else
            end;
            if k then
                e+=1;
                F[e]=g;
            else
            end;
            V,u,v=k,l,g;
        end;
        return e;
    end;
    local function k(g,Q,c,s,F,v)w[1]=g;
    w[2]=Q;
    w[3]=c;
    return y(r,y(w,y(r,y(w,3,true,0,true,r),true,s,false,w),false,0,true,r),false,F,false,v);
end;
local w={};
local function r()local y,g,Q,c,s,F,v,u=w.image,w.color,w.left,w.top,w.width,w.height,w.scale,w.used;
y:DrawRectangle(p,z,x,1,j);
for z=1,u,1 do
    local V,e=Z[z],q[z];
    z=V[1];
    local l=Vector2.new((z.X-Q)/s*v,(z.Y-c)/F*v);
    for C=2,e-1,1 do
        local e,W=V[C],V[C+1];
        z,C=Vector2.new((e.X-Q)/s*v,(e.Y-c)/F*v),Vector2.new((W.X-Q)/s*v,(W.Y-c)/F*v);
        if Y((z.X-l.X)*(C.Y-l.Y)-(z.Y-l.Y)*(C.X-l.X))>0.001 then
            y:DrawTriangle(l,z,C,g,0,j);
            y:DrawLine(l,z,g,0,j);
            y:DrawLine(z,C,g,0,j);
            y:DrawLine(C,l,g,0,j);
        end;
    end;
end;
u=w.masks;
if type(u)~="table"then return;
end;
local Y,z,V,e=w.resolution,w.right,w.bottom,typeof(w.inset)=="Vector2"and w.inset or p;
for p=1,#u,1 do
    g=u[p];
    if typeof(g)=="Instance"then if g.Parent then
        if g.Visible then
            local p,u=g.AbsolutePosition+e,g.AbsoluteSize;
            local g,e,l,C=t(Q,p.X),t(c,p.Y),o(z,p.X+u.X),o(V,p.Y+u.Y);
            if l>g then
                if C>e then
                    local p,z,u,V=S(G((g-Q)/s*v)-1,0,Y),S(G((e-c)/F*v)-1,0,Y),S(i((l-Q)/s*v)+1,0,Y),S(i((C-c)/F*v)+1,0,Y);
                    if u>p then
                        if V>z then
                            y:DrawRectangle(Vector2.new(p,z),Vector2.new(u-p,V-z),x,1,j);
                        end;
                    end;
                end;
            end;
        end;
    end;
end;
end;
end;
K.draw=function(j,S,Y,x,p,z,y)if A.alive then
    if not(A.available)then
        return false;
    end;
else
    return false;
end;
if E(S)then
    if type(Y)~="table"then return false;
elseif #Y<3 then
    return false;
end;
else
    return false;
end;
if typeof(x)~="Color3"then return false;
elseif  typeof(y)~="Vector2"then return false;
elseif  y.X<=1 then
    return false;
elseif  y.Y<=1 then
    return false;
end;
local g,Q,c,s,F,v,u,V=y.X,y.Y,math.huge,math.huge,-math.huge,-math.huge,#Y,0;
for e=1,u,1 do
    local l,C=Y[e],Y[e==u and 1 or e+1];
    if E(l)then
        if E(C)then
            y=Z[V+1];
            if y then
            else
                y={};
                Z[V+1]=y;
            end;
            e=k(S,l,C,g,Q,y);
            if e>=3 then
                local E=V+1;
                q[E]=e;
                local k,l,C,W=c,s,F,v;
                for mF=1,e,1 do
                    local e=y[mF];
                    k,l,C=o(k,e.X),o(l,e.Y),t(C,e.X);
                    W=t(W,e.Y);
                end;
                V,c,s,F,v=E,k,l,C,W;
            else
            end;
        else
        end;
    else
    end;
end;
if V==0 then
    return true;
end;
S,u,y,Y=t(0,G(c)-2),t(0,G(s)-2),o(g,i(F)+2),o(Q,i(v)+2);
g,Q=y-S,Y-u;
if g<=0 then
    return true;
elseif  Q<=0 then
    return true;
end;
local o=N(j);
j=o.fill_used+1;
o.fill_used=j;
local t=o.fills[j];
if t then
else
    t=P(d,I);
    if not(t)then
        return false;
    end;
    o.fills[j]=t;
end;
j=t.active~=0 and t.active or 1;
local G,i=j==1 and 2 or 1,t.banks and t.banks[j];
j=t.banks and t.banks[G];
if i then
    if i.image then
        if i.label then
            if j then
                if j.image then
                    if not(j.label)then
                        return false;
                    end;
                else
                    return false;
                end;
            else
                return false;
            end;
        else
            return false;
        end;
    else
        return false;
    end;
else
    return false;
end;
j.label.Visible=false;
o=A.resolution;
w.image=j.image;
w.color=x;
w.masks=p;
w.inset=z;
w.left=S;
w.top=u;
w.right=y;
w.bottom=Y;
w.width=g;
w.height=Q;
w.resolution=o;
w.scale=o-1;
w.used=V;
if not(pcall(r))then
    X(j);
    return false;
end;
x=j.label;
x.Position=UDim2.fromOffset(S,u);
x.Size=UDim2.fromOffset(g,Q);
x.ImageColor3=T;
x.ImageTransparency=0.72;
x.Visible=true;
if i~=j then
    X(i);
end;
t.active=G;
t.pending=nil;
t.misses=0;
return true;
end;
K.finish=function(j)local S=a[j];
if S then
    if not(S.open)then
        return;
    end;
else
    return;
end;
S.open=false;
if S.failed then
    H(S);
    S.failed=false;
    return;
end;
local o,t,G=S.fills,S.strokes,S.points;
if j=="prediction"and S.expect and S.fill_used==0 then
    local i=o[1];
    if i then
        if i.active~=0 then
            i.misses=(i.misses or 0)+1;
            if i.misses>=3 then
                i.pending=0;
            else
                i.pending=nil;
            end;
        end;
    end;
    for i=2,#o,1 do
        o[i].pending=0;
    end;
else
    for i=S.fill_used+1,#o,1 do
        o[i].pending=0;
    end;
end;
o=O(j,1,10)=="prediction";
for i=1,S.stroke_used,1 do
    local Y=t[i];
    if Y then
        Y.missed=0;
    end;
end;
for i=S.stroke_used+1,#t,1 do
    local Y=t[i];
    if o then
        if Y.active~=0 then
            Y.missed=(Y.missed or 0)+1;
            if Y.missed>=2 then
                Y.pending=0;
            else
                Y.pending=nil;
            end;
        else
            Y.pending=0;
        end;
    else
        Y.pending=0;
    end;
end;
for o=S.point_used+1,#G,1 do
    G[o].pending=0;
end;
S.ready=true;
if j~="prediction"then _(S);
end;
end;
K.clear=function(j)local S=a[j];
if not(S)then
    return;
end;
S.open=false;
S.ready=false;
S.failed=false;
S.expect=false;
S.fill_used=0;
S.stroke_used=0;
S.point_used=0;
local o,t,G=S.fills,S.strokes,S.points;
for i=1,#o,1 do
    j=o[i];
    j.pending=nil;
    j.active=0;
    U(j);
end;
for j=1,#t,1 do
    S=t[j];
    S.pending=nil;
    S.active=0;
    J(S);
end;
for j=1,#G,1 do
    t=G[j];
    t.pending=nil;
    t.active=0;
    f(t);
end;
end;
local j,S=A.available and Instance.new("BindableFunction")or nil,{};
local function o()local t=S.fn;
if not(t)then
    return false;
end;
return t(S[1],S[2],S[3],S[4],S[5],S[6],S[7],S[8],S[9]);
end;
local function t()S.fn=nil;
S[1]=nil;
S[2]=nil;
S[3]=nil;
S[4]=nil;
S[5]=nil;
S[6]=nil;
S[7]=nil;
S[8]=nil;
S[9]=nil;
end;
local function G(i)i.OnInvoke=nil;
pcall(i.Destroy,i);
end;
K.destroy=function()if not(A.alive)then
    return;
end;
A.alive=false;
A.available=false;
for i=1,#B,1 do
    local Y=a[B[i]];
    if Y then
        local O,T,x=Y.fills,Y.strokes,Y.points;
        for Y=1,#O,1 do
            I(O[Y]);
        end;
        for Y=1,#T,1 do
            R(T[Y]);
        end;
        for Y=1,#x,1 do
            n(x[Y]);
        end;
        table.clear(O);
        table.clear(T);
        table.clear(x);
    end;
    B[i]=nil;
end;
table.clear(a);
table.clear(Z);
table.clear(q);
table.clear(L);
t();
if A.gui then
    pcall(A.gui.Destroy,A.gui);
    A.gui=nil;
end;
local i=j;
j=nil;
if i then
    task.defer(G,i);
end;
end;
if not j then
    local function G()return false;
end;
A.begin=G;
A.expectFill=G;
A.stroke=G;
A.point=G;
A.trail=G;
A.pulse=G;
A.circle=G;
A.draw=G;
A.finish=G;
A.clear=G;
A.destroy=K.destroy;
b.teardown(K.destroy);
h.world.zonefill=A;
return A;
end;
j.OnInvoke=o;
local o=j.Invoke;
local function G(i,Y,O,T,x,p,a,B,N,I)S.fn=i;
S[1]=Y;
S[2]=O;
S[3]=T;
S[4]=x;
S[5]=p;
S[6]=a;
S[7]=B;
S[8]=N;
S[9]=I;
a,B=pcall(o,j);
t();
if not a then
    A.last_error=tostring(B);
    return false;
end;
A.last_error=nil;
return B;
end;
local function S(o)return function(t,i,Y,O,T,x,p,a,B)if not(A.alive)then
    return false;
end;
return G(o,t,i,Y,O,T,x,p,a,B);
end;
end;
A.begin=S(K.begin);
A.expectFill=S(K.expectFill);
A.stroke=S(K.stroke);
A.point=S(K.point);
A.trail=S(K.trail);
A.pulse=S(K.pulse);
A.circle=S(K.circle);
A.draw=S(K.draw);
A.finish=S(K.finish);
A.clear=S(K.clear);
A.destroy=function()if not(A.alive)then
    return;
end;
if j then
    G(K.destroy);
else
    K.destroy();
end;
end;
b.own(M);
b.teardown(A.destroy);
h.world.zonefill=A;
return A;
end;
D.R=function()local j=D.load("b");
local h,b=D.load("q"),D.load("a");
local K,S,o=D.load("j"),D.load("f"),h.world;
local t=j.workspace;
local G=j.guiservice;
local i=j.input;
local Y=j.lp;
local O=h.white;
local h=math.clamp;
local T=math.min;
local x=math.max;
local p=math.abs;
local A=math.floor;
local M=math.ceil;
local a,B=math.sqrt,3.141592653589793;
local N=math.cos;
local I=math.sin;
local R,n=S.trim,{step=function()end
};
local S=K.nade_sim;
local E=K.inventory;
local d=K.char_velocity;
local w=K.remotes;
if type(S)~="table"then return n;
elseif  type(S.calculateThrowParameters)~="function"then return n;
elseif  type(S.createInitialState)~="function"then return n;
elseif  type(S.createConfig)~="function"then return n;
elseif  type(S.step)~="function"then return n;
end;
local K,P,r,L={["HE Grenade"]=true,Flashbang=true,["Smoke Grenade"]=true,["Decoy Grenade"]=true,["Incendiary Grenade"]=true,Molotov=true},{["HE Grenade"]={radius=0.497488707304,fuse=1.6,restitution=0.4,maxBounces=20},Flashbang={radius=0.61398953199387,fuse=1.5,restitution=0.4,maxBounces=20},["Smoke Grenade"]={radius=0.56614202260971,fuse=0,restitution=0.4,maxBounces=20},["Decoy Grenade"]={radius=0.61398953199387,fuse=1.5,restitution=0.4,maxBounces=20},["Incendiary Grenade"]={radius=0.56614208221436,fuse=2.4,restitution=0.4,maxBounces=20},Molotov={radius=0.92103540897369,fuse=2.4,restitution=0.4,maxBounces=20}},{["Smoke Grenade"]="smoke",["Incendiary Grenade"]="fire",Molotov="fire"},{smoke=14.7,fire=17.6};
local Z=RaycastParams.new();
Z.FilterType=Enum.RaycastFilterType.Exclude;
Z.RespectCanCollide=false;
Z.IgnoreWater=true;
local function X(q,U)q.CollisionGroup=U;
end;
local q=Vector3.new(0,-20,0);
local U=Vector3.new(0,7,0);
local z=Vector3.new(0,1.25,0);
local J=Vector3.new(0,0.08,0);
local y=Vector3.new(0,1,0);
local f=Vector3.new(0,0,1);
local k;
local g,Q,c,H=0,false,0;
local _,s,F,v=0,0,0,{points={},bounces={},ring={},center=nil,key=nil,started=nil};
local function u()local V=o.zonefill;
if type(V)=="table"then V.clear("prediction");
V.clear("prediction_path");
V.clear("prediction_fx");
end;
end;
local function V(e,l)local C=e:WorldToViewportPoint(l);
if C.Z<=0.05 then
    return nil;
end;
return Vector2.new(C.X,C.Y);
end;
local function e(l,C,W,mF)local DF,jF=-C:PointToObjectSpace(W).Z,-C:PointToObjectSpace(mF).Z;
if DF<=0.05 then
    if jF<=0.05 then
        return nil;
    end;
end;
if DF<=0.05 then
    W=(W:Lerp(mF,h((0.05-DF)/(jF-DF),0,1)));
else
    mF=if jF<=0.05 then
        mF:Lerp(W,h((0.05-jF)/(DF-jF),0,1))
    else
        mF;
    end;
    jF,DF=l:WorldToViewportPoint(W),l:WorldToViewportPoint(mF);
    if jF.Z<=0 then
        return nil;
    elseif  DF.Z<=0 then
        return nil;
    end;
    return Vector2.new(jF.X,jF.Y),Vector2.new(DF.X,DF.Y);
end;
local function l(C,W)if typeof(C)~="Vector3"then return nil;
elseif  typeof(W)~="Vector3"then return nil;
elseif  W.Magnitude<0.001 then
    return nil;
end;
local mF=W.Unit;
return CFrame.lookAt(C,C+mF,p(mF.Y)>0.98 and f or y);
end;
local function y(f,C,W,mF)local DF=#C;
for jF=1,DF,1 do
    f[jF]=mF:PointToWorldSpace(W:PointToObjectSpace(C[jF]));
end;
R(f,DF);
end;
local function f(C,W,mF)local DF=#W;
for jF=1,DF,1 do
    C[jF]=W[jF]+mF;
end;
R(C,DF);
end;
local C,W={},0;
local function mF(DF)if W==0 then
    W+=1;
    C[W]=DF;
elseif (DF-C[W]).Magnitude>0.1 then
    W+=1;
    C[W]=DF;
end;
end;
local function DF(jF,hF,bF,KF,SF,oF,tF,GF)local iF,YF=o.zonefill,#oF;
if type(iF)~="table"then return;
elseif  YF<2 then
    return;
end;
W=0;
local OF=YF-1;
for YF=1,OF,1 do
    local OF,TF=e(hF,bF,oF[YF],oF[YF+1]);
    if OF and TF then
        if W>0 then
            if(C[W]-OF).Magnitude>1.5 then
                if W>=2 then
                    R(C,W);
                    iF.stroke(jF,C,false,tF,GF,KF,SF,"base",0.98);
                end;
                W=0;
            end;
        end;
        mF(OF);
        mF(TF);
    elseif  W>=2 then
        R(C,W);
        iF.stroke(jF,C,false,tF,GF,KF,SF,"base",0.98);
        W=0;
    else
        W=0;
    end;
end;
if W>=2 then
    R(C,W);
    iF.stroke(jF,C,false,tF,GF,KF,SF,"base",0.98);
end;
W=0;
end;
local jF={};
local function hF(bF,KF,SF,oF,tF,GF,iF,YF,OF,TF)local xF,pF=o.zonefill,#GF;
if type(xF)~="table"then return;
elseif  pF<2 then
    return;
end;
local AF,MF=h(tonumber(OF)or 0,0,1),h(tonumber(TF)or 0,0,1);
if AF<=0 then
    return;
elseif  MF<=0 then
    return;
end;
jF[1]=0;
for aF=1,pF-1,1 do
    jF[aF+1]=jF[aF]+(GF[aF+1]-GF[aF]).Magnitude;
end;
TF=jF[pF];
if TF<=0.01 then
    return;
end;
OF=TF*AF;
AF=x(0,OF-TF*0.135);
W=0;
TF=pF-1;
for aF=1,TF,1 do
    local TF,BF=jF[aF],jF[aF+1];
    pF=BF-TF;
    if pF>0 then
        if BF>=AF then
            if TF<=OF then
                local BF,NF=h((AF-TF)/pF,0,1),h((OF-TF)/pF,0,1);
                if NF>=BF then
                    local OF,TF=e(KF,SF,GF[aF]:Lerp(GF[aF+1],BF),GF[aF]:Lerp(GF[aF+1],NF));
                    if OF and TF then
                        if W>0 then
                            if(C[W]-OF).Magnitude>1.5 then
                                if W>=2 then
                                    R(C,W);
                                    xF.trail(bF,C,iF,YF,oF,tF,MF);
                                end;
                                W=0;
                            end;
                        end;
                        mF(OF);
                        mF(TF);
                    elseif  W>=2 then
                        R(C,W);
                        xF.trail(bF,C,iF,YF,oF,tF,MF);
                        W=0;
                    else
                        W=0;
                    end;
                end;
            end;
        end;
    end;
end;
if W>=2 then
    R(C,W);
    xF.trail(bF,C,iF,YF,oF,tF,MF);
end;
W=0;
end;
local function e(W,mF,bF,KF,SF,oF)local tF=o.zonefill;
if type(tF)~="table"then return;
end;
for GF=1,#SF,1 do
    local iF=V(mF,SF[GF]);
    if iF then
        tF.point(W,iF,oF,1.7,bF,KF,0.82);
    end;
end;
end;
local function W(mF,bF,KF,SF,oF,tF)local GF,iF=V(bF,oF),o.zonefill;
if GF then
    if type(iF)=="table"then iF.point(mF,GF,tF,3.4,KF,SF,0.98);
end;
end;
return GF;
end;
local function V(mF,bF)if typeof(mF)~="CFrame"then return-math.huge;
elseif  typeof(bF)~="Vector3"then return-math.huge;
end;
return-mF:PointToObjectSpace(bF).Z;
end;
local function mF(bF,KF,SF,oF)if typeof(SF)~="Vector3"then return nil;
end;
local tF=V(KF,SF);
if tF>0.15 then
    local GF=bF:WorldToViewportPoint(SF);
    if GF.Z>0 then
        return Vector2.new(GF.X,GF.Y);
    end;
    return nil;
end;
if typeof(oF)~="Vector3"then return nil;
end;
local GF=V(KF,oF);
if GF<=0.15 then
    return nil;
end;
KF=bF:WorldToViewportPoint(SF:Lerp(oF,h((0.15-tF)/(GF-tF),0,1)));
if KF.Z>0 then
    return Vector2.new(KF.X,KF.Y);
end;
return nil;
end;
local function bF(KF,SF,oF)if V(KF,SF)>0.15 then
    return SF;
end;
local tF,GF;
for iF=1,#oF,1 do
    SF=oF[iF];
    if typeof(SF)=="Vector3"then iF=V(KF,SF);
    if iF>0.15 then
        if tF then
            if iF>tF then
                tF,GF=iF,SF;
            else
            end;
        else
            tF,GF=iF,SF;
        end;
    else
    end;
else
end;
end;
return GF;
end;
local V={};
local function KF(SF,oF,tF,GF,iF,YF,OF,TF)local xF,pF=o.zonefill,#OF;
if type(xF)~="table"then return;
elseif  pF<3 then
    return;
end;
xF.expectFill(SF);
local AF=bF(tF,YF,OF);
if not(AF)then
    return;
end;
local bF,MF=mF(oF,tF,YF,AF),0;
for aF=1,pF,1 do
    YF=mF(oF,tF,OF[aF],AF);
    if YF then
    else
        local mF=oF:WorldToViewportPoint(OF[aF]:Lerp(AF,0.5));
        YF=if mF.Z>0 then
            Vector2.new(mF.X,mF.Y)
        else
            YF;
        end;
        if YF then
            MF+=1;
            V[MF]=YF;
        else
        end;
    end;
    if MF<3 then
        return;
    end;
    R(V,MF);
    xF.stroke(SF,V,true,TF,1.5,GF,iF,"base",0.94);
    if bF then
        xF.draw(SF,bF,V,TF,GF,iF,oF.ViewportSize);
    end;
    return bF,V;
end;
local function mF(bF,SF,oF,tF,GF,iF)local YF=k;
if if YF then
    not bF
else
    not YF then
        u();
        return;
    elseif  YF.weapon~=SF then
        u();
        return;
    elseif  YF.mode~=oF then
        u();
        return;
    elseif  p(YF.rangeScale-tF)>0.001 then
        u();
        return;
    end;
    local OF,TF=YF.throwFrame,l(GF,iF);
    if OF then
        if not(TF)then
            u();
            return;
        end;
    else
        u();
        return;
    end;
    y(v.points,YF.points,OF,TF);
    y(v.bounces,YF.bounces,OF,TF);
    iF=TF:PointToWorldSpace(OF:PointToObjectSpace(YF.endpoint));
    if YF.ring and typeof(YF.ringCenter)=="Vector3"then TF=iF-YF.endpoint;
    f(v.ring,YF.ring,TF);
    v.center=YF.ringCenter+TF;
else
    R(v.ring,0);
    v.center=nil;
end;
TF=j.drawmask();
local j,y,f,xF=TF and G:GetGuiInset()or Vector2.zero,bF.CFrame,h(tonumber(o.nade_path_width)or 2,1,4),o.nade_path_col or O;
local G,O,pF=o.nade_radius_col or xF,SF.."|"..tostring(oF).."|"..tostring(tF),os.clock();
if v.key~=O then
    v.key=O;
    v.started=pF;
elseif  type(v.started)~="number"then v.key=O;
v.started=pF;
end;
OF,tF,SF,oF,GF=(pF-v.started)%2.15;
if OF<1.35 then
    O=h(OF/1.35,0,1);
    tF,SF=O*O*(3-2*O),T(h(O/0.06,0,1),h((1-O)/0.035,0,1))*0.98;
else
    if OF<1.97 then
        pF=h((OF-1.35)/0.62,0,1);
        oF,GF=pF*pF*(3-2*pF),I(B*pF)^0.78*0.98;
    else
    end;
end;
O=o.zonefill;
OF=type(O)=="table";
if OF then
    O.begin("prediction_path");
end;
DF("prediction_path",bF,y,TF,j,v.points,xF,f);
e("prediction_path",bF,TF,j,v.bounces,xF);
pF=W("prediction_path",bF,TF,j,iF,xF);
if OF then
    O.finish("prediction_path");
end;
if OF then
    O.begin("prediction");
end;
local T,e;
if YF.ring then
    if v.center then
        T,e=KF("prediction",bF,y,TF,j,v.center,v.ring,G);
    else
    end;
else
end;
if OF then
    O.finish("prediction");
end;
if OF then
    O.begin("prediction_fx");
end;
hF("prediction_fx",bF,y,TF,j,v.points,xF,f,tF,SF);
if T and e and oF then
    O.pulse("prediction_fx",T,e,oF,G,1.7,TF,j,GF);
elseif  v.center then
elseif  pF then
    if oF then
        O.circle("prediction_fx",pF,26*oF,xF,1.7,TF,j,GF);
    end;
end;
if OF then
    O.finish("prediction_fx");
end;
end;
local function j(G,O)local T=G[#G];
if T then
    if(O-T).Magnitude>0.01 then
        G[#G+1]=O;
    end;
else
    G[#G+1]=O;
end;
end;
local function G(O,T,y)local f=t:Raycast(O+U,q,Z);
O=if f then
    f.Position+f.Normal*0.06
else
    O;
    local e,W=table.create(32),O+z;
    for z=1,32,1 do
        f=B*2*(z-1)/32;
        local B=Vector3.new(N(f),0,I(f));
        local N=t:Raycast(W,B*T,Z);
        local I=O+B*(if N then
            if p(N.Normal.Y)<0.65 then
                h(N.Distance-0.12,0.35,T)
            else
                T
            else
                T);
                N=t:Raycast(I+U,q,Z);
                e[z]=if N then
                    N.Position+N.Normal*0.06
                else
                    I+J;
                    if y then
                        if z%4==0 then
                            if y()then
                                coroutine.yield();
                            end;
                        end;
                    end;
                end;
                return O,e;
            end;
            local function O()if type(E)~="table"then return nil;
        elseif  type(E.peekCurrentEquippedForMovement)~="function"then return nil;
    end;
    local T,B=pcall(E.peekCurrentEquippedForMovement);
    if T then
        if B then
            if B.IsDestroyed then
                return nil;
            elseif  B.IsEquipped==false then
                return nil;
            end;
        else
            return nil;
        end;
    else
        return nil;
    end;
    T=B.Properties;
    if T then
        if T.Class~="Grenade"then return nil;
    elseif  not(K[B.Name])then
        return nil;
    end;
else
    return nil;
end;
return B;
end;
local function T(B)if d then
    local N,I=pcall(d,B);
    if N then
        if typeof(I)=="Vector3"then return I;
    end;
end;
end;
local N=B and(B:FindFirstChild("HumanoidRootPart"));
if N then
    if N:IsA("BasePart")then
        return N.AssemblyLinearVelocity;
    end;
end;
return Vector3.zero;
end;
local function B()local N,I,E=O(),t.CurrentCamera,Y.Character;
if N then
    if I then
        if E then
            if E:IsDescendantOf(t)then
                if E:GetAttribute("Dead")==true then
                    return nil;
                end;
            else
                return nil;
            end;
        else
            return nil;
        end;
    else
        return nil;
    end;
else
    return nil;
end;
local O=E.PrimaryPart or E:FindFirstChild("HumanoidRootPart");
if O then
    if not(O:IsA("BasePart"))then
        return nil;
    end;
else
    return nil;
end;
local d,q=i:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)and"Near"or"Far",N.Properties;
local i=x(0.01,(tonumber(q and q.Range)or 60)/40);
i=if Y:GetAttribute("IsCrouching")==true then
    i*0.8
else
    i;
    local U,z=O.Position,I.CFrame.LookVector;
    q,O=S.calculateThrowParameters(U,z,d,i);
    if typeof(q)~="Vector3"then return nil;
elseif  typeof(O)~="Vector3"then return nil;
end;
return N,I,E,d,i,q,O,z,U;
end;
local i={};
local function O(N,I,E)local d,q,q,U,z,J,y,f,e=B();
if not(d)then
    return nil;
end;
local W=P[d.Name];
if not(W)then
    return nil;
end;
local DF,hF=T(q),t:GetServerTimeNow();
local bF,KF,SF=S.createInitialState(J,y,U,DF,z,hF),d.Name=="Molotov"or d.Name=="Incendiary Grenade",W.fuse and W.fuse>0 and W.fuse or nil;
hF=S.createConfig(W.radius,z,U=="Near",SF,KF and 0.1 or nil,KF or nil);
hF.restitution=W.restitution or hF.restitution;
hF.maxBounces=W.maxBounces or hF.maxBounces;
SF,W=t:FindFirstChild("Debris"),0;
if SF then
    W=1;
    i[W]=SF;
else
end;
W+=1;
i[W]=q;
R(i,W);
Z.FilterDescendantsInstances=i;
q=Y:GetAttribute("Team");
KF,W=pcall,q=="Terrorists"and"TGrenade"or q=="Counter-Terrorists"and"CTGrenade";
KF(X,Z,W or"Default");
q=S.Constants or{};
SF=tonumber(I)or tonumber(q.FIXED_TIMESTEP)or 0.0078125;
local t,Y,X,oF,tF=M((tonumber(q.MAX_SIMULATION_TIME)or 10)/SF)+2,x(1,A(0.0625/SF+0.5)),{bF.position},{},bF.position;
KF,W=0;
q=0;
for A=1,t,1 do
    local t,A=S.step(bF,hF,Z,SF);
    tF=t.position;
    KF+=1;
    if A then
        if A.type=="bounce"then oF[#oF+1]=A.position;
        j(X,A.position);
    else
        W=A;
    end;
else
end;
if KF>=Y or A or t.isAtRest then
    j(X,t.position);
    KF=0;
else
end;
if W then
    bF=t;
    break;
elseif  t.isAtRest then
    bF=t;
    break;
end;
q+=1;
if q>=8 then
    if N then
        if N()then
            coroutine.yield();
        end;
    end;
    q=0;
else
end;
bF=t;
end;
j(X,tF);
q,hF,KF=r[d.Name];
if q then
    if E~=false then
        hF,KF=G(tF,L[q],N);
    else
    end;
else
end;
return{points=X,bounces=oF,endpoint=tF,ringCenter=hF,ring=KF,weapon=d.Name,mode=U,rangeScale=z,rootPosition=e,aimLook=f,velocity=DF,throwFrame=l(J,y),exact=I==nil,computedAt=os.clock(),reason=W and W.type or"rest"};
end;
local function j(S)if type(S)~="table"then return;
elseif  K[S.Weapon]then
    if type(S.Physics)~="table"then return;
end;
else
    return;
end;
local K,t=S.Physics,P[S.Weapon]or{};
local G,Y,A,M=tonumber(K.Radius),tonumber(K.FuseTime),tonumber(K.Restitution),tonumber(K.MaxBounces);
if G then
    if G>0 then
        t.radius=G;
    end;
end;
if Y then
    if Y>=0 then
        t.fuse=Y;
    end;
end;
if A then
    t.restitution=A;
end;
if M then
    t.maxBounces=M;
end;
P[S.Weapon]=t;
end;
local function K(S)if type(S)~="table"then return;
elseif  type(S.Voxels)~="table"then return;
end;
local t=S.Voxels;
S=#t;
if S==0 then
    return;
end;
local G,Y=0,0;
for A=1,S,1 do
    local M=t[A].Position;
    G,Y=G+M.X,Y+M.Z;
end;
local A,M,N=G/S,Y/S,0;
for G=1,S,1 do
    local S=t[G];
    local t,G=S.Position.X-A,S.Position.Z-M;
    N=x(N,a(t*t+G*G)+(tonumber(S.Size)or 0)*0.5);
end;
if N>0 then
    L.smoke=x(L.smoke,h(N,8,24));
end;
end;
local function S(t)if type(t)~="table"then return;
elseif  typeof(t.Position)~="Vector3"then return;
elseif  type(t.Voxels)~="table"then return;
end;
local G=t.Voxels;
local Y=#G;
if Y<2 then
    return;
else
    local A=tonumber(t.Duration);
    if A then
        if A<2 then
            return;
        end;
    else
        return;
    end;
end;
local A,M=t.Position,0;
for N=1,Y,1 do
    t=G[N];
    local G,Y,I=t.Position,(tonumber(t.SizeX)or 0)*0.5,(tonumber(t.SizeZ)or 0)*0.5;
    local t,E=G.X-A.X,G.Z-A.Z;
    for A=-1,1,2 do
        for d=-1,1,2 do
            N,G=t+Y*A,E+I*d;
            M=x(M,a(N*N+G*G));
        end;
    end;
end;
if M>0 then
    L.fire=x(L.fire,h(M,8,24));
end;
end;
local function h(t,G)if type(t)~="table"then return;
elseif  type(t.Listen)~="function"then return;
end;
local Y,x=pcall(t.Listen,G);
if Y then
    if type(x)=="function"then b.adopt(x);
end;
end;
end;
local function t()if type(w)~="table"then return;
elseif  not(b.alive())then
    return;
end;
h(w.Projectile and w.Projectile.Spawn,j);
h(w.VFX and w.VFX.CreateVoxelSmoke,K);
h(w.VFX and w.VFX.CreateVoxelFire,S);
end;
b.spawn(t);
local function j()local h,K=os.clock(),_;
return h>=K;
end;
local function h(K,S,t,G)if Q then
    return;
end;
Q,g=true,K;
H={generation=c,weapon=S,mode=t,rangeScale=G,thread=coroutine.create(O)};
end;
local function K(S,t)if type(S)~="table"or S.weapon~=t.weapon or S.mode~=t.mode then
    return false;
elseif  type(S.rangeScale)~="number"then return false;
elseif  type(t.rangeScale)~="number"then return false;
elseif  p(S.rangeScale-t.rangeScale)>0.001 then
    return false;
elseif  type(S.points)~="table"then return false;
elseif #S.points<1 then
    return false;
elseif  type(S.bounces)~="table"then return false;
elseif  typeof(S.endpoint)~="Vector3"then return false;
elseif  typeof(S.rootPosition)~="Vector3"then return false;
elseif  typeof(S.aimLook)~="Vector3"then return false;
elseif  typeof(S.velocity)~="Vector3"then return false;
elseif  typeof(S.throwFrame)~="CFrame"then return false;
elseif  type(S.computedAt)~="number"then return false;
elseif  S.computedAt~=S.computedAt then
    return false;
elseif  S.exact~=true then
    return false;
end;
t=S.points;
for G=1,#t,1 do
    if typeof(t[G])~="Vector3"then return false;
end;
end;
t=S.bounces;
for G=1,#t,1 do
    if typeof(t[G])~="Vector3"then return false;
end;
end;
if S.ring~=nil then
    t=S.ring;
    if type(t)~="table"then return false;
elseif #t<3 then
    return false;
elseif  typeof(S.ringCenter)~="Vector3"then return false;
end;
for G=1,#t,1 do
    if typeof(t[G])~="Vector3"then return false;
end;
end;
elseif  S.ringCenter~=nil then
    return false;
end;
return true;
end;
local function S()local t=H;
if not(t)then
    return;
end;
_=os.clock()+(k and 7.5E-4 or 0.0015);
local G,Y=coroutine.resume(t.thread,j);
if not(G)then
    if H==t then
        H,Q=nil,false;
    end;
    return;
end;
if coroutine.status(t.thread)~="dead"then return;
elseif  H~=t then
    return;
end;
H,Q=nil,false;
if K(Y,t)then
    if t.generation==c then
        if o.nade_path==true then
            k=Y;
        end;
    end;
end;
end;
local function j()if Q then
    c+=1;
end;
Q,H,k,g,s,F=false,nil,nil,0,0,0;
R(v.points,0);
R(v.bounces,0);
R(v.ring,0);
v.center=nil;
v.started=nil;
v.key=nil;
u();
end;
local function K(t,G,Y,x)return t~=nil and t.weapon==G and t.mode==Y and p(t.rangeScale-x)<=0.001;
end;
n.step=function()if o.nade_path~=true then
    if k then
        j();
    elseif  Q then
        j();
    else
        u();
    end;
    return;
end;
local o,t,G,Y,x,p,A,M,a=B();
if not(o)then
    if k then
        j();
    elseif  Q then
        j();
    else
        u();
    end;
    return;
end;
local j,B,N=os.clock(),T(G),o.Name;
o=K(k,N,Y,x);
G=not o;
G=if o then
    (a-k.rootPosition).Magnitude>=0.02 or M:Dot(k.aimLook)<=0.9999995 or(B-k.velocity).Magnitude>=0.2
else
    G;
    if G then
        F=j;
        if H then
            c+=1;
            Q,H,g=false,nil,0;
        end;
        if if o then
            j-s>=0.011111111111111112
        else
            not o then
                M,a=pcall(O,nil,0.03125,true);
                s=j;
                if M then
                    if a then
                        k=a;
                    end;
                end;
            end;
        end;
        if not(Q)then
            if K(k,N,Y,x)then
                o=j-F;
                G=k.exact~=true and o>=0.04 or k.exact==true and o>=0.04 and j-k.computedAt>=0.3;
                if G then
                    if j-g>=0.04 then
                        h(j,N,Y,x);
                    end;
                end;
            end;
        end;
        S();
        if K(k,N,Y,x)then
            mF(t,N,Y,x,p,A);
        else
            u();
        end;
    end;
    b.teardown(function()c+=1;
    Q,H,k=false,nil,nil;
    R(v.points,0);
    R(v.bounces,0);
    R(v.ring,0);
    v.center=nil;
    v.started=nil;
    v.key=nil;
    u();
    table.clear(C);
    table.clear(jF);
    table.clear(V);
    table.clear(i);
end);
return n;
end;
D.S=function()local j=D.load("b");
local h,b=D.load("q"),D.load("a");
local K,S=D.load("j"),D.load("u");
local o=h.world;
local t=j.workspace;
local G=j.guiservice;
local i=j.http;
local Y=j.collection;
local O=j.lp;
local T=h.white;
local x=h.black;
local h=math.clamp;
local p=math.min;
local A=math.max;
local M=math.abs;
local a=math.floor;
local B,N=math.sqrt,3.141592653589793;
local I=math.cos;
local R=math.sin;
local n=math.exp;
local E=string.sub;
local d,w,P=string.format,{step=function()end
},{["HE Grenade"]="rbxassetid://111110976385167",Flashbang="rbxassetid://132038996524430",["Smoke Grenade"]="rbxassetid://137305344844339",["Decoy Grenade"]="rbxassetid://81385239843859",["Incendiary Grenade"]="rbxassetid://81255981095065",Molotov="rbxassetid://95390644612614",Bomb="rbxassetid://80566367391881"};
local r=K.nade_sim;
local L=K.remotes;
if type(r)~="table"then return w;
elseif  type(L)~="table"then return w;
end;
local K=t:FindFirstChild("Debris");
local Z=j.screen(2147480000);
if not Z then
    return w;
end;
b.own(Z);
local X=RaycastParams.new();
X.FilterType=Enum.RaycastFilterType.Exclude;
X.RespectCanCollide=false;
X.IgnoreWater=true;
local function q(U,z)U.CollisionGroup=z;
end;
pcall(q,X,"Default");
local U,z,J,y,f={},{},{},{},{};
local k=Vector3.new(0,-20,0);
local g=Vector3.new(0,7,0);
local Q=Vector3.new(0,1.25,0);
local c=Vector3.new(0,0.08,0);
local H=Vector3.new(0,1.35,0);
local function _(s)if type(Drawing)~="table"then return nil;
elseif  type(Drawing.new)~="function"then return nil;
end;
local F,v=pcall(Drawing.new,s);
if F then
    if not(v)then
        return nil;
    end;
else
    return nil;
end;
v.Visible=false;
v.Transparency=1;
if s=="Line"then v.Thickness=1;
end;
return v;
end;
local function s(F)if F then
    pcall(F.Remove,F);
end;
end;
local function F(v,u,V,e)if type(V)~="table"then return false;
end;
local l,C,W,mF=p(v.X,u.X),p(v.Y,u.Y),A(v.X,u.X),A(v.Y,u.Y);
for DF=1,#V,1 do
    v=V[DF];
    if typeof(v)=="Instance"then if v.Parent then
        if v.Visible then
            DF,u=v.AbsolutePosition+e,v.AbsoluteSize;
            if u.X>0 then
                if u.Y>0 then
                    if l<DF.X+u.X then
                        if W>DF.X then
                            if C<DF.Y+u.Y then
                                if mF>DF.Y then
                                    return true;
                                end;
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;
end;
end;
return false;
end;
local v={Camera=nil};
v.CFrame=CFrame.new();
v.ViewportSize=Vector2.zero;
v.FieldOfView=70;
v.Override=false;
local function u()local V=o.view;
if type(V)=="table"then if type(V.Resolve)=="function"then local e,l=pcall(V.Resolve);
if e then
    if type(l)=="table"then if typeof(l.CFrame)=="CFrame"then if typeof(l.ViewportSize)=="Vector2"then return l;
end;
end;
end;
end;
end;
end;
V=t.CurrentCamera;
if not V then
    return nil;
end;
v.Camera=V;
v.CFrame=V.CFrame;
v.ViewportSize=V.ViewportSize;
v.FieldOfView=V.FieldOfView;
return v;
end;
local function v(V,e)local l=o.view;
if type(l)=="table"then if type(l.Project)=="function"then local C,W,mF,DF=pcall(l.Project,e,V);
if C then
    return W,mF,DF;
end;
end;
end;
l=V and V.Camera;
if not l then
    return nil,false,-math.huge;
end;
local V,C=l:WorldToViewportPoint(e);
return Vector2.new(V.X,V.Y),C,V.Z;
end;
local function V(e,l)local C,W,W=v(e,l);
if typeof(C)~="Vector2"then return nil;
elseif  type(W)~="number"then return nil;
elseif  W<=0.05 then
    return nil;
end;
return C;
end;
local function e(l,C)if type(l)~="table"then return-math.huge;
elseif  typeof(l.CFrame)~="CFrame"then return-math.huge;
elseif  typeof(C)~="Vector3"then return-math.huge;
end;
return-l.CFrame:PointToObjectSpace(C).Z;
end;
local function l(C,W,mF)if typeof(W)~="Vector3"then return nil;
end;
local DF=e(C,W);
if DF>0.15 then
    local jF,hF,hF=v(C,W);
    if typeof(jF)=="Vector2"then if type(hF)=="number"then if hF>0 then
        return jF;
    end;
end;
end;
return nil;
end;
if typeof(mF)~="Vector3"then return nil;
end;
local jF=e(C,mF);
if jF<=0.15 then
    return nil;
end;
local hF,bF,bF=v(C,W:Lerp(mF,h((0.15-DF)/(jF-DF),0,1)));
if typeof(hF)=="Vector2"then if type(bF)=="number"then if bF>0 then
    return hF;
end;
end;
end;
return nil;
end;
local function v(C,W,mF)if e(C,W)>0.15 then
    return W;
end;
local DF,jF;
for hF=1,#mF,1 do
    W=mF[hF];
    if typeof(W)=="Vector3"then hF=e(C,W);
    if hF>0.15 then
        if DF then
            if hF>DF then
                DF,jF=hF,W;
            else
            end;
        else
            DF,jF=hF,W;
        end;
    else
    end;
else
end;
end;
return jF;
end;
local e=Instance.new("ImageLabel");
e.AnchorPoint=Vector2.new(0.5,0.5);
e.BackgroundTransparency=1;
e.BorderSizePixel=0;
e.Size=UDim2.fromOffset(34,34);
e.ScaleType=Enum.ScaleType.Fit;
e.Visible=false;
e.ZIndex=2;
e.Parent=Z;
local function C()local W=Instance.new("ImageLabel");
W.AnchorPoint=Vector2.new(0.5,0.5);
W.BackgroundTransparency=1;
W.BorderSizePixel=0;
W.Size=UDim2.fromOffset(30,30);
W.ScaleType=Enum.ScaleType.Fit;
W.Visible=false;
W.ZIndex=2;
W.Parent=Z;
local Z=Instance.new("TextLabel");
Z.AnchorPoint=Vector2.new(0.5,0);
Z.BackgroundTransparency=1;
Z.BorderSizePixel=0;
Z.Position=UDim2.new(0.5,0,1,2);
Z.Size=UDim2.fromOffset(90,18);
Z.Font=Enum.Font.GothamBold;
Z.TextSize=13;
Z.TextStrokeColor3=x;
Z.TextStrokeTransparency=0;
Z.TextXAlignment=Enum.TextXAlignment.Center;
Z.TextYAlignment=Enum.TextYAlignment.Center;
Z.Visible=false;
Z.ZIndex=3;
Z.Parent=W;
local mF=Instance.new("UIGradient");
mF.Enabled=false;
mF.Rotation=0;
mF.Offset=Vector2.zero;
mF.Parent=Z;
return{image=W,text=Z,grad=mF};
end;
local Z,W,mF,DF={},0,{},0;
local function jF(hF)local bF=Z[hF];
if bF then
else
    bF=C();
    Z[hF]=bF;
    if hF>W then
        W=hF;
    end;
end;
return bF;
end;
local C=NumberSequence.new(0);
local hF,bF,KF,SF=ColorSequence.new(T),{},false;
local oF,tF,GF={},0,{};
local iF=math.random();
local function YF()if SF then
    SF.Visible=false;
end;
local OF=tF;
for TF=1,OF,1 do
    local OF=oF[TF];
    if OF then
        OF.Visible=false;
    end;
end;
end;
local function OF()e.Visible=false;
YF();
end;
local function TF(xF)local pF=xF.text;
if type(pF)~="string"then YF();
return;
elseif  pF==""then YF();
return;
end;
local YF=o.esp_set;
local AF,MF,aF,BF=tonumber(type(YF)=="table"and YF.tSz)or 13,S.face(),xF.position.Y+xF.size*0.5+2,xF.textcolor or T;
YF=xF.textgradientcolor or BF;
if xF.textgradient~=true then
    local S=tF;
    for NF=1,S,1 do
        local IF=oF[NF];
        if IF then
            IF.Visible=false;
        end;
    end;
    SF=SF or _("Text");
    S=SF;
    if S then
        S.Center=true;
        S.Size=AF;
        S.Font=MF;
        S.Text=pF;
        S.Color=BF;
        S.Outline=true;
        S.OutlineColor=x;
        S.Transparency=1;
        S.Position=Vector2.new(xF.position.X,aF);
        S.Visible=true;
    end;
    return;
end;
if SF then
    SF.Visible=false;
end;
local S,NF=#pF,0;
for IF=1,S,1 do
    local RF=oF[IF];
    if RF then
    else
        RF=_("Text");
        oF[IF]=RF;
        if IF>tF then
            tF=IF;
        end;
    end;
    local _=0;
    if RF then
        RF.Center=false;
        RF.Size=AF;
        RF.Font=MF;
        RF.Text=E(pF,IF,IF);
        RF.Outline=true;
        RF.OutlineColor=x;
        RF.Transparency=1;
        _=RF.TextBounds.X;
    else
    end;
    GF[IF]=_;
    NF+=_;
end;
AF,pF=xF.position.X-NF*0.5,os.clock();
for x=1,S,1 do
    MF=oF[x];
    if MF then
        xF=R((S>1 and(x-1)/(S-1)or 0)*N+pF*2+iF*N*2)*0.5+0.5;
        MF.Color=BF:Lerp(YF,xF);
        MF.Position=Vector2.new(AF,aF);
        MF.Visible=true;
        AF+=GF[x];
    else
    end;
end;
xF,YF=S+1,tF;
for S=xF,YF,1 do
    BF=oF[S];
    if BF then
        BF.Visible=false;
    end;
end;
end;
local function S()if KF then
    if typeof(bF.position)~="Vector2"then OF();
    return;
end;
else
    OF();
    return;
end;
e.Position=UDim2.fromOffset(bF.position.X,bF.position.Y);
e.Size=UDim2.fromOffset(bF.size,bF.size);
e.Image=bF.asset;
e.ImageColor3=bF.color;
e.ImageTransparency=0;
e.Visible=true;
TF(bF);
end;
local function x()local _=W;
for e=1,_,1 do
    local _=Z[e];
    if _ then
        _.image.Visible=false;
        _.text.Visible=false;
    end;
end;
end;
local function _()local e=DF;
for iF=1,e,1 do
    local YF=mF[iF];
    if YF then
        local TF=jF(iF);
        local jF,iF,xF=TF.image,TF.text,TF.grad;
        jF.Position=UDim2.fromOffset(YF.position.X,YF.position.Y);
        jF.Size=UDim2.fromOffset(YF.size,YF.size);
        jF.Image=YF.asset;
        jF.ImageColor3=YF.color;
        jF.ImageTransparency=0;
        jF.Visible=true;
        jF=YF.textcolor or T;
        local TF,pF=YF.textgradientcolor or jF,YF.text~=nil and YF.textgradient==true;
        xF.Enabled=pF;
        xF.Rotation=0;
        xF.Offset=Vector2.zero;
        xF.Transparency=C;
        xF.Color=ColorSequence.new(jF,TF);
        if YF.text then
            iF.Text=YF.text;
            iF.TextColor3=pF and T or jF;
            iF.TextTransparency=0;
            iF.TextStrokeTransparency=0;
            iF.Visible=true;
        else
            iF.Text="";
            iF.TextColor3=T;
            iF.Visible=false;
        end;
    end;
end;
local jF,iF=DF+1,W;
for YF=jF,iF,1 do
    e=Z[YF];
    if e then
        e.image.Visible=false;
        e.text.Text="";
        e.text.Visible=false;
        YF=e.grad;
        YF.Enabled=false;
        YF.Rotation=0;
        YF.Offset=Vector2.zero;
        YF.Transparency=C;
        YF.Color=hF;
    end;
end;
end;
local function e(C,jF,hF,iF,YF,TF,xF,pF,AF,MF,aF)local BF=V(C,iF);
if BF then
    if F(BF,BF,jF,hF)then
        return;
    end;
else
    return;
end;
DF+=1;
hF=mF[DF];
if hF then
else
    hF={};
    mF[DF]=hF;
end;
hF.position=BF;
hF.size=AF;
hF.asset=YF;
hF.color=TF;
hF.text=xF;
hF.textcolor=pF;
hF.textgradient=MF==true;
hF.textgradientcolor=aF;
end;
local function C(jF,hF,iF,YF,TF)local xF=V(jF,YF);
if xF then
    if F(xF,xF,hF,iF)then
        return;
    end;
else
    return;
end;
bF.position=xF;
bF.size=34;
bF.asset=P.Bomb;
bF.color=o.bomb_icon_col or T;
bF.text=type(TF)=="number"and d("%.1fs",TF)or nil;
bF.textcolor=o.bomb_timer_col or T;
bF.textgradient=o.bomb_timer_grad==true;
bF.textgradientcolor=o.bomb_timer_grad_col or bF.textcolor;
KF=true;
end;
local function d()local F,V={K},O.Character;
if V then
    F[2]=V;
end;
X.FilterDescendantsInstances=F;
end;
local function F(V,jF)d();
local d=t:Raycast(V+g,k,X);
V=if d then
    d.Position+d.Normal*0.06
else
    V;
    local hF,bF=table.create(32),V+Q;
    for Q=1,32,1 do
        d=N*2*(Q-1)/32;
        local N=Vector3.new(I(d),0,R(d));
        local I=t:Raycast(bF,N*jF,X);
        local R=V+N*(if I then
            if M(I.Normal.Y)<0.65 then
                h(I.Distance-0.12,0.35,jF)
            else
                jF
            else
                jF);
                I=t:Raycast(R+g,k,X);
                hF[Q]=if I then
                    I.Position+I.Normal*0.06
                else
                    R+c;
                end;
                return V,hF;
            end;
            local function N(I,R,d)if type(I)~="table"then return nil;
        elseif #I==0 then
            return nil;
        end;
        local X,k=Vector3.zero,0;
        for g=1,#I,1 do
            local Q=I[g];
            if type(Q)=="table"then if typeof(Q.Position)=="Vector3"then local g,c=X+Q.Position,k+1;
            X,k=g,c;
        else
        end;
    else
    end;
end;
if k==0 then
    return nil;
end;
local g,Q=typeof(d)=="Vector3"and d or X/k,0;
for X=1,#I,1 do
    d=I[X];
    if type(d)=="table"then if typeof(d.Position)=="Vector3"then local I,k=M(d.Position.X-g.X),M(d.Position.Z-g.Z);
    if R=="smoke"then X=A(0,tonumber(d.Size)or 0)*0.5;
    Q=A(Q,B(I*I+k*k)+X);
else
    local M,X=I+A(0,tonumber(d.SizeX)or 0)*0.5,k+A(0,tonumber(d.SizeZ)or 0)*0.5;
    Q=A(Q,B(M*M+X*X));
end;
else
end;
else
end;
end;
return g,h(if Q<=0 then
    R=="smoke"and 14.7 or 17.6
else
    Q,2,40);
end;
local function M(B)if B=="Smoke Grenade"then return"smoke";
end;
if B=="Molotov"then return"fire";
elseif  B=="Incendiary Grenade"then return"fire";
end;
return nil;
end;
local function B(I,R)local d,X,k=os.clock(),10;
for g=#f,1,-1 do
    local Q=f[g];
    if d-Q.time>2.5 then
        table.remove(f,g);
    else
        if M(Q.weapon)==R then
            local R=(Q.position-I).Magnitude;
            if R<X then
                X,k=R,Q;
            else
            end;
        else
        end;
    end;
end;
if k then
    table.remove(f,table.find(f,k));
    return k.weapon;
end;
return nil;
end;
local function I(R)local d=z[R];
if not(d)then
    return;
end;
local X=#U;
local k=U[X];
U[d]=k;
U[X]=nil;
z[R]=nil;
if k then
    if d~=X then
        z[k.key]=d;
    end;
end;
end;
local function R(d,X,k)local g=z[d.key];
if g then
    if U[g]==d then
        local g=K;
        d.instance=g:FindFirstChild(X..k)or d.instance;
    end;
end;
end;
local function d(X,k,g,Q,c,V)if k==nil then
    return nil;
end;
k=tostring(k);
local jF,hF=N(g,X,Q);
if not(jF)then
    return nil;
end;
g,Q=F(jF,hF);
local N,F=X..":"..k,os.clock();
jF=z[N];
local bF=jF and U[jF];
if bF then
else
    bF={id=k,key=N,kind=X,created=F};
    U[#U+1]=bF;
    z[N]=#U;
end;
bF.center=g;
bF.ring=Q;
bF.radius=hF;
bF.team=V or bF.team;
N=tonumber(c);
if N then
    if N>0 then
        bF.expires=F+N;
    elseif  not(bF.expires)then
        bF.expires=F+20;
    end;
elseif  not(bF.expires)then
    bF.expires=F+20;
end;
V=B(g,X);
if V then
    bF.weapon=V;
end;
if not(bF.weapon)then
    bF.weapon=X=="smoke"and"Smoke Grenade"or"Molotov";
end;
task.defer(R,bF,X=="smoke"and"VoxelSmoke_"or"VoxelFire_",k);
return bF;
end;
local function B(N)if N~=nil then
    I("smoke:"..tostring(N));
end;
end;
local function N(R)if R~=nil then
    I("fire:"..tostring(R));
end;
end;
local function I(R)if type(R)=="table"then d("smoke",R.SmokeId,R.Voxels,nil,R.Duration,R.Team);
end;
end;
local function R(X)if type(X)=="table"then d("fire",X.FireId,X.Voxels,X.Position,X.Duration,nil);
end;
end;
local function X(k)if type(k)~="table"then return;
elseif  k.FireId==nil then
    return;
end;
local g=z["fire:"..tostring(k.FireId)];
local Q=g and U[g];
local c,F,V,jF,hF=Q and Q.center or nil,Q and Q.expires,Q and Q.weapon,Q and Q.created,Q and Q.instance;
g=d("fire",k.FireId,k.Voxels,c,nil,nil);
if g then
    if Q then
        g.expires=F;
        g.weapon=V;
        g.created=jF;
        g.instance=hF;
    end;
end;
end;
local function k(g)return{simulationTime=g.elapsed or 0,bounceCount=g.bounces or 0,isGrounded=false,isAtRest=false,hasTouched=(g.bounces or 0)>0,accumulatedTime=0,position=g.position,velocity=g.velocity,angularVelocity=Vector3.zero,timestamp=g.starttime,isJumpThrow=g.jump==true};
end;
local function g(Q)local c,F=k(Q),Q.physics;
Q=tonumber(F.FuseTime);
Q=if Q then
    if Q<=0 then
        nil
    else
        Q
    else
        nil;
        local k=r.createConfig(tonumber(F.Radius)or 0.5,1,false,Q,nil,nil);
        k.restitution=tonumber(F.Restitution)or k.restitution;
        k.maxBounces=tonumber(F.MaxBounces)or k.maxBounces;
        Q=RaycastParams.new();
        Q.FilterType=Enum.RaycastFilterType.Exclude;
        Q.RespectCanCollide=false;
        Q.IgnoreWater=true;
        local V,jF={K},O.Character;
        if jF then
            V[2]=jF;
        end;
        Q.FilterDescendantsInstances=V;
        pcall(q,Q,F.CollisionGroup or"Default");
        V=r.Constants or{};
        local hF,bF=h(tonumber(F.Step)or tonumber(V.FIXED_TIMESTEP)or 0.0078125,0.001,0.05),tonumber(V.MAX_SIMULATION_TIME)or 10;
        V=math.ceil(A(0,bF-c.simulationTime)/hF)+2;
        for h=1,p(12000,V),1 do
            jF,bF=r.step(c,k,Q,hF);
            if jF.isAtRest then
                c=jF;
                break;
            elseif  bF then
                if bF.type~="bounce"then c=jF;
                break;
            end;
        end;
        c=jF;
    end;
    return c.position;
end;
local function h(k,Q)local c,F=pcall(g,k);
if c then
    if typeof(F)~="Vector3"then return;
elseif  k.generation~=Q then
    return;
end;
else
    return;
end;
Q=y[k.id];
if Q then
    if J[Q]==k then
        k.endpoint=F;
    end;
end;
end;
local function k(g)if g.weapon~="HE Grenade"then return;
end;
local Q=(g.generation or 0)+1;
g.generation=Q;
if typeof(g.position)~="Vector3"then return;
elseif  typeof(g.velocity)~="Vector3"then return;
elseif  type(g.physics)~="table"then return;
end;
task.defer(h,g,Q);
end;
local function h(g)J[#J+1]=g;
y[g.id]=#J;
end;
local function g(Q)local c=y[Q.id];
if c then
    if J[c]==Q then
        local c=K;
        Q.model=c:FindFirstChild(Q.id)or Q.model;
        Q.modelseen=Q.model~=nil or Q.modelseen;
    end;
end;
end;
local function Q(c)if type(c)~="table"then return;
elseif  c.Id==nil then
    return;
elseif  not(P[c.Weapon])then
    return;
end;
if type(c.State)~="table"then return;
elseif  type(c.Physics)~="table"then return;
end;
if typeof(c.State.Position)~="Vector3"then return;
elseif  typeof(c.State.Velocity)~="Vector3"then return;
end;
local F,V=tostring(c.Id),os.clock();
local jF={id=F,weapon=c.Weapon,position=c.State.Position,velocity=c.State.Velocity,starttime=tonumber(c.State.StartTime)or t:GetServerTimeNow(),elapsed=0,bounces=0,jump=c.State.IsJumpThrow==true,physics=c.Physics,group=c.Physics.CollisionGroup,born=V,expires=V+12,model=K:FindFirstChild(F)};
jF.modelseen=jF.model~=nil;
V=y[F];
if V then
    J[V]=jF;
else
    h(jF);
end;
k(jF);
task.defer(g,jF);
end;
local function g(c)if type(c)~="table"then return;
elseif  c.Id==nil then
    return;
end;
local F=y[tostring(c.Id)];
local V=F and J[F];
if not(V)then
    return;
end;
if typeof(c.Position)=="Vector3"then V.position=c.Position;
end;
if typeof(c.Velocity)=="Vector3"then V.velocity=c.Velocity;
end;
V.bounces=tonumber(c.BounceIndex)or V.bounces or 0;
F=tonumber(c.Timestamp);
if F then
    c=tonumber(V.starttime)or F;
    V.starttime=c;
    V.elapsed=A(tonumber(V.elapsed)or 0,F-c);
end;
k(V);
end;
local function k(c)local F=J[c];
if not(F)then
    return;
end;
local V=#J;
local jF=J[V];
J[c]=jF;
J[V]=nil;
y[F.id]=nil;
if jF then
    if c~=V then
        y[jF.id]=c;
    end;
end;
end;
local function c(F)if type(F)~="table"then return;
elseif  F.Id==nil then
    return;
end;
local V=y[tostring(F.Id)];
local jF=V and J[V];
local hF,bF=F.Grenade or jF and jF.weapon,typeof(F.Position)=="Vector3"and F.Position or jF and jF.position;
if V then
    k(V);
end;
if hF then
    if typeof(bF)~="Vector3"then return;
end;
else
    return;
end;
V=os.clock();
f[#f+1]={weapon=hF,position=bF,time=V};
jF=M(hF);
if not jF then
    return;
end;
local M,k=10;
for iF=1,#U,1 do
    F=U[iF];
    if F.kind==jF then
        if V-F.created<1.5 then
            iF=(F.center-bF).Magnitude;
            if iF<M then
                M,k=iF,F;
            else
            end;
        else
        end;
    else
    end;
end;
if k then
    k.weapon=hF;
end;
end;
local function M(k)if typeof(k)~="Instance"then return;
elseif  not(k:IsA("Model"))then
    return;
end;
local F=k:GetAttribute("GrenadeName");
if not(P[F])then
    return;
end;
local V=k.Name;
local jF=y[V];
local hF=jF and J[jF];
if hF then
    hF.model=k;
    hF.modelseen=true;
    return;
end;
jF,hF=pcall(k.GetPivot,k);
if not jF then
    return;
end;
jF=os.clock();
h({id=V,weapon=F,position=hF.Position,model=k,modelseen=true,born=jF,expires=jF+12});
end;
local function h(k,F,V)local jF,hF={},k:GetChildren();
for bF=1,#hF,1 do
    local iF=hF[bF];
    if iF:IsA("BasePart")then
        bF=iF.Size;
        if F=="smoke"then local YF,TF=#jF+1,{Position=iF.Position};
        TF.Size,jF[YF]=A(bF.X,bF.Z),TF;
    else
        jF[#jF+1]={Position=iF.Position,SizeX=bF.X,SizeZ=bF.Z};
    end;
end;
end;
hF=d(F,V,jF,nil,nil,nil);
if hF then
    hF.instance=k;
    hF.expires=math.huge;
end;
end;
local function d()local k=Y:GetTagged("Grenade");
for F=1,#k,1 do
    M(k[F]);
end;
k=K:GetChildren();
for F=1,#k,1 do
    local V=k[F];
    F=V.Name;
    if E(F,1,11)=="VoxelSmoke_"then local k=E(F,12);
    if not(z["smoke:"..k])then
        h(V,"smoke",k);
    end;
elseif  E(F,1,10)=="VoxelFire_"then local k=E(F,11);
if not(z["fire:"..k])then
    h(V,"fire",k);
end;
end;
end;
end;
local function h(E,k)if type(E)~="table"then return;
elseif  type(E.Listen)~="function"then return;
end;
local F,V=pcall(E.Listen,k);
if F then
    if type(V)=="function"then b.adopt(V);
end;
end;
end;
local function E(k)local F=k.model;
if F then
    if F.Parent then
        local V=F.PrimaryPart;
        if V then
            k.position=V.Position;
            return V.Position;
        end;
        local V,jF=pcall(F.GetPivot,F);
        if V then
            k.position=jF.Position;
            return jF.Position;
        end;
        return k.position;
    end;
end;
if not(F)then
    local F=K;
    local V=F:FindFirstChild(k.id);
    if V then
        if V:IsA("Model")then
            k.model=V;
            k.modelseen=true;
            return E(k);
        end;
    end;
end;
if k.modelseen then
    k.expires=0;
end;
return k.position;
end;
local function k(F)if F.weapon~="HE Grenade"then return false;
elseif  not(F.group)then
    return false;
end;
if t:GetAttribute("Gamemode")=="Deathmatch"then return true;
end;
if t:GetAttribute("VIPFriendlyFireEnabled")==true then
    return true;
end;
local V=O:GetAttribute("Team");
if V=="Terrorists"then return F.group~="TGrenade";
end;
if V=="Counter-Terrorists"then return F.group~="CTGrenade";
end;
return false;
end;
local function F(V)return i:JSONDecode(V);
end;
local function i()local V=O:GetAttribute("Armor");
if type(V)=="number"then return A(0,V);
end;
if type(V)=="string"then local jF,hF=pcall(F,V);
if jF then
    if type(hF)=="table"then return A(0,tonumber(hF.Health)or 0);
end;
end;
end;
V=O.Character;
if V then
    return A(0,tonumber(V:GetAttribute("Armor"))or 0);
end;
return 0;
end;
local V=RaycastParams.new();
V.FilterType=Enum.RaycastFilterType.Exclude;
V.RespectCanCollide=false;
V.IgnoreWater=true;
pcall(q,V,"Default");
local function q(jF)if k(jF)then
    if typeof(jF.endpoint)~="Vector3"then return nil;
end;
else
    return nil;
end;
local k=O.Character;
if k then
    if k:IsDescendantOf(t)then
        if k:GetAttribute("Dead")==true then
            return nil;
        end;
    else
        return nil;
    end;
else
    return nil;
end;
local O=k.PrimaryPart or k:FindFirstChild("HumanoidRootPart")or k:FindFirstChild("UpperTorso");
if O then
    if not(O:IsA("BasePart"))then
        return nil;
    end;
else
    return nil;
end;
local hF=O.Position-jF.endpoint;
local bF=hF.Magnitude;
local iF=bF/(tonumber(r.Constants and r.Constants.SOURCE_TO_STUDS)or 0.0763888888888889);
if iF>350 then
    return nil;
end;
if bF>0.3 then
    local r=jF.endpoint+hF.Unit*0.2;
    local hF,YF=O.Position-r,{K,k};
    if jF.model then
        YF[3]=jF.model;
    end;
    V.FilterDescendantsInstances=YF;
    YF=t:Raycast(r,hF,V);
    if YF then
        if YF.Distance<hF.Magnitude-0.2 then
            return nil;
        end;
    end;
end;
jF=(iF-25)/140;
k,O=p(98,105*n(-(jF*jF))),i();
if O>0 then
    bF=k*0.5;
    k=if(k-bF)*0.5>O then
        k-O/0.5
    else
        bF;
    else
    end;
    k=a(k+0.5);
    if k<1 then
        return nil;
    end;
    return k;
end;
local i={};
local function O(p,a,n,r)local k=r.ring;
local V=type(k)=="table"and#k or 0;
if V<3 then
    return;
end;
local jF=v(p,r.center,k);
if not(jF)then
    return;
end;
local v=r.kind=="smoke";
local hF,bF,iF,YF=v and(o.smoke_zone_col or T)or(o.fire_zone_col or T),v and(o.smoke_zone_icon or T)or(o.fire_zone_icon or T),l(p,r.center,jF),true;
for TF=1,V,1 do
    local xF=l(p,k[TF],jF);
    if not(xF)then
        YF=false;
        break;
    end;
    i[TF]=xF;
end;
k=o.zonefill;
if YF and type(k)=="table"then for l=#i,V+1,-1 do
    i[l]=nil;
end;
k.stroke("active",i,true,hF,1.5,a,n,"base",0.92);
if iF then
    k.draw("active",iF,i,hF,a,n,p.ViewportSize);
end;
end;
k=P[r.weapon]or P[v and"Smoke Grenade"or"Molotov"];
e(p,a,n,r.center+H,k,bF,nil,T,32);
end;
local function p(a)local n=0;
for r=1,#J,1 do
    local k=J[r];
    r=k.model;
    if a>=(k.expires or 0)or r and k.modelseen and not r.Parent or r and r:GetAttribute("SimulationFinished")==true then
        y[k.id]=nil;
    else
        n+=1;
        J[n]=k;
        y[k.id]=n;
    end;
end;
for r=#J,n+1,-1 do
    J[r]=nil;
end;
n=0;
for r=1,#U,1 do
    local k=U[r];
    if a>=(k.expires or math.huge)or k.instance and not k.instance.Parent then
        z[k.key]=nil;
    else
        n+=1;
        U[n]=k;
        z[k.key]=n;
    end;
end;
for r=#U,n+1,-1 do
    U[r]=nil;
end;
for n=#f,1,-1 do
    if a-f[n].time>2.5 then
        table.remove(f,n);
    end;
end;
end;
local function a(n)if typeof(n)~="Instance"then return nil;
elseif  not(n.Parent)then
    return nil;
end;
if n:IsA("Model")then
    if n.PrimaryPart then
        return n.PrimaryPart.Position;
    end;
end;
if n:IsA("BasePart")then
    return n.Position;
end;
local r,k=pcall(n.GetPivot,n);
if r then
    if typeof(k)=="CFrame"then return k.Position;
end;
end;
return nil;
end;
local n=j.weak();
local function r(k)local H,v=k:GetAttribute("BombPlanted"),n[k];
if v then
else
    v={};
    n[k]=v;
end;
if v.raw~=H then
    v.raw=H;
    v.started=nil;
    v.duration=nil;
    if type(H)=="string"then if H~=""then local n,k=pcall(F,H);
    if n then
        if type(k)=="table"then if type(k.Time)=="number"then if type(k.TimeUntilExplode)=="number"then v.started=k.Time;
        v.duration=k.TimeUntilExplode;
    end;
end;
end;
end;
end;
end;
end;
return v.started,v.duration;
end;
local function n(k)return typeof(k)=="Instance"and k:IsDescendantOf(t)and k:GetAttribute("Defused")~=true and k:GetAttribute("Exploded")~=true and k:GetAttribute("Exploding")~=true and k:GetAttribute("BombPlanted")~=nil;
end;
local function k(H)return typeof(H)=="Instance"and H:IsDescendantOf(t)and H:GetAttribute("Weapon")=="C4";
end;
local H,F;
local function v(V)local l=a(V);
if not(l)then
    return nil;
end;
local jF,hF=r(V);
if type(jF)=="number"then if type(hF)=="number"then if hF>0 then
    V=A(jF+hF-t:GetServerTimeNow(),0);
    if V>0 then
        return l,V;
    end;
end;
end;
end;
return l,nil;
end;
local function A()if H then
    if F then
        if n(H)then
            local r=H;
            return v(r);
        end;
    elseif  k(H)then
        local r=H;
        return a(r),nil;
    end;
    H=nil;
end;
local r=Y:GetTagged("Bomb");
local V=#r;
for l=1,V,1 do
    local jF=r[l];
    if n(jF)then
        local n,l=v(jF);
        if n then
            H,F=jF,true;
            return n,l;
        end;
    end;
end;
V=Y:GetTagged("WeaponDropped");
r=#V;
for n=1,r,1 do
    local r=V[n];
    if k(r)then
        n=a(r);
        if n then
            H,F=r,false;
            return n,nil;
        end;
    end;
end;
return nil,nil;
end;
local function a()p(os.clock());
local p=u();
if p then
    local n=j.drawmask();
    local r=n and G:GetGuiInset()or Vector2.zero;
    if o.bomb_esp==true then
        local G,k=A();
        if typeof(G)=="Vector3"then C(p,n,r,G,k);
    end;
end;
if o.nade_zones==true then
    for G=1,#U,1 do
        O(p,n,r,U[G]);
    end;
end;
if o.nades_live==true then
    for G=1,#J,1 do
        local O=J[G];
        G=E(O);
        if typeof(G)=="Vector3"then local A=q(O);
        e(p,n,r,G,P[O.weapon],o.nade_icon_col or T,A and tostring(A).." dmg"or nil,o.nade_dmg_col or T,30);
    end;
end;
end;
end;
end;
w.step=function()DF,KF=0,false;
if K then
    local G=o.zonefill;
    local O=type(G)=="table";
    if O then
        G.begin("active");
    end;
    pcall(a);
    if O then
        G.finish("active");
    end;
end;
if not(pcall(_))then
    pcall(x);
end;
if not(pcall(S))then
    pcall(OF);
end;
end;
local function S()if not(K)then
    local G=t:WaitForChild("Debris",60);
    j.reclaim();
    if G then
        if not(b.alive())then
            return;
        end;
    else
        return;
    end;
    K=G;
end;
h(L.Projectile and L.Projectile.Spawn,Q);
h(L.Projectile and L.Projectile.Bounce,g);
h(L.Projectile and L.Projectile.Resolve,c);
h(L.VFX and L.VFX.CreateVoxelSmoke,I);
h(L.VFX and L.VFX.DestroyVoxelSmoke,B);
h(L.VFX and L.VFX.CreateVoxelFire,R);
h(L.VFX and L.VFX.UpdateVoxelFire,X);
h(L.VFX and L.VFX.DestroyVoxelFire,N);
b.connect(Y:GetInstanceAddedSignal("Grenade"),M);
d();
end;
b.spawn(S);
b.teardown(function()local j=o.zonefill;
if type(j)=="table"then j.clear("active");
end;
s(SF);
SF=nil;
j=tF;
for h=1,j,1 do
    s(oF[h]);
end;
tF=0;
table.clear(oF);
table.clear(GF);
table.clear(Z);
table.clear(mF);
table.clear(U);
table.clear(z);
table.clear(J);
table.clear(y);
table.clear(f);
table.clear(i);
W,DF,H=0,0,nil;
end);
return w;
end;
D.T=function()local j,h=os.clock,{hooked=false,on=false,fresh=false,broke=false,target=nil,beat=0,samples=0,still=0,ground=false,bx=0,by=0,bj=false,input_at=0};
h.engage=function(b)if not(h.on)then
    h.on=true;
    h.fresh=true;
    h.broke=false;
    h.samples=0;
    h.still=0;
    h.ground=false;
end;
h.target=b;
h.beat=j();
end;
h.release=function()h.on=false;
h.fresh=false;
h.broke=false;
h.target=nil;
h.samples=0;
h.still=0;
h.ground=false;
end;
h.active=function(j)if not(h.on)then
    return false;
end;
if j-h.beat>0.5 then
    h.release();
    return false;
end;
return true;
end;
return h;
end;
D.U=function()local j,h,b=D.load("b"),D.load("a"),D.load("h");
local K,S,o=D.load("j"),D.load("L"),D.load("o");
local t=D.load("k").slots;
local G=D.load("T");
local i=j.lp;
local Y=j.workspace;
local O=K.pose;
local T,x,p=K.grenade,K.inventory,os.clock;
local K=S.probe;
local S=Vector3.new;
local A=math.rad;
local M=math.random;
local a=math.clamp;
local B=math.atan2;
local N=math.cos;
local I,R,n,E,d,w,P,r,L,Z,X,q,U,z,J=math.sin,3.141592653589793,{["Counter-Terrorists"]=true,Terrorists=true},2,4.5,3.5,0.05,0.25,2,10,{on=false,yaw="backward",jitter=45,spin_rate=25,pitch="off",air_spin=false,air_rate=30,air_pitch="off",duck=false,duck_rate=4,man=0,auto=false,ang=90},0;
local y,f,k,g,Q=0,false,{s=0,at=0,lk=0,ch=nil},{},false;
local c=type(O)=="table"and type(O.getJoints)=="function"and type(O.applyVerticalLook)=="function";
local function H()if c then
    if z then
        pcall(O.applyVerticalLook,z,0,0);
    end;
end;
end;
local function _(s)if c then
    if not(s)then
        return nil;
    end;
else
    return nil;
end;
if J==s then
    if z then
        local F=z;
        return F;
    end;
end;
H();
z,J=nil,nil;
local F,v=pcall(O.getJoints,s);
if F then
    if type(v)=="table"then z,J=v,s;
end;
end;
s=z;
return s;
end;
local function s(F)local v,u,V,e,l=i:GetAttribute("Team"),Y:GetAttribute("Gamemode")=="Deathmatch",p(),b.all();
local b,C,W,mF,DF;
for jF=1,l,1 do
    local l=e[jF];
    if l~=i then
        jF=l:GetAttribute("Team");
        if u or v~=nil and jF~=nil and n[v]and n[jF]and v~=jF then
            local n,v,u=l.Character;
            local e=false;
            if n then
                if n:GetAttribute("Dead")~=true then
                    if n:IsDescendantOf(Y)then
                        if n:GetAttribute("ClientCharacterPresentationVisible")~=false then
                            local Y=n:FindFirstChild("HumanoidRootPart");
                            if Y then
                                local jF,hF=n:FindFirstChild("Head"),Y.Position;
                                u=jF and jF.Position or hF+S(0,1.8,0);
                                jF=true;
                                v,e=hF,jF;
                            else
                            end;
                        else
                        end;
                    else
                    end;
                else
                end;
            else
            end;
            local Y=mF;
            if v then
                mF=u;
            else
                local jF=t[l];
                local t=jF and jF.mode=="est"and jF.cerr<=Z and V-jF.at<=L and jF.cur;
                if t then
                    local L=jF.ghost;
                    local Z=L and L.parts.Head;
                    mF=Z and Z.Position or t+S(0,1.8,0);
                    v=t;
                else
                    mF=u;
                end;
            end;
            if v then
                local t=(v-F).Magnitude;
                if(if b then
                    e and not C
                else
                    not b)or e==C and t<b then
                        b,C,W,DF=t,e,v,e and n or nil;
                    else
                        mF=Y;
                    end;
                else
                    mF=Y;
                end;
            else
            end;
        else
        end;
    end;
    return W,mF,DF;
end;
local function b(t,Y)if Q then
    return o.clear(t,Y);
end;
return K(t,Y-t,nil,g).instance==nil;
end;
local function K(t,Y,n)Q=o.sync();
if n then
    local o=b(n,t-Y*E);
    if o~=b(n,t+Y*E)then
        return o and 1 or-1;
    end;
    if o then
        return 0;
    end;
    o=b(n,t-Y*d);
    if o~=b(n,t+Y*d)then
        return o and 1 or-1;
    end;
end;
n=not b(t,t-Y*w);
if n~=not b(t,t+Y*w)then
    return n and-1 or 1;
end;
return nil;
end;
local function b(o,t,Y,n,E)local d=p();
if k.ch~=o then
    k.ch=o;
    k.s=0;
    k.at=0;
    k.lk=0;
end;
if d<k.at then
    return k.s;
end;
k.at=d+P;
g[1]=o;
g[2]=E;
local E,w=t.Position,o and(o:FindFirstChild("Head"));
t=S(E.X,w and w.Position.Y or E.Y+1.8,E.Z);
o,w=pcall(K,t,S(-N(Y),0,I(Y)),n);
if o then
    if w~=nil then
        if w~=k.s then
            if k.s==0 then
                k.s,k.lk=w,d+r;
            elseif  d>=k.lk then
                k.s,k.lk=w,d+r;
            end;
        end;
    end;
end;
return k.s;
end;
local function K()if p()<y then
    return true;
elseif  G.on then
    return true;
end;
return i:GetAttribute("IsDefusingBomb")==true or i:GetAttribute("IsLocallyDefusingBomb")==true;
end;
if type(T)=="table"then if type(rawget(T,"Throw"))=="function"then h.field(T,"Throw",function(S)local function o(t,...)if X.on then
    y=p()+1.25;
end;
return S(t,...);
end;
return o;
end);
end;
end;
if type(x)=="table"then if type(rawget(x,"PredictGrenadeThrow"))=="function"then h.field(x,"PredictGrenadeThrow",function(S)local function o(...)local t=S(...);
if t==true then
    if X.on then
        y=p()+0.35;
    end;
end;
return t;
end;
return o;
end);
end;
end;
j={cfg=X,reset=function()q,U=0,nil;
k.s=0;
k.at=0;
k.lk=0;
end,relax=function()H();
end,apply=function(S,o)if not(X.on)then
    return;
end;
if K()then
    if not(f)then
        f=true;
        H();
    end;
    return;
end;
f=false;
local K,t,G=tonumber(o.LookYaw)or 0,tonumber(o.VerticalLook)or 0,S and S.MovementState;
local i=G and G.OnGround==false and X.air_spin==true;
local Y,T=i and X.air_pitch or X.pitch;
if i then
    G=q;
    q=G+A(tonumber(X.air_rate)or 30);
    T=K+q;
else
    local x=U;
    if x~=X.yaw then
        q=0;
        U=X.yaw;
    end;
    local p,n,E,d=X.yaw,X.man,K+R,S and S.HumanoidRootPart;
    if d and(n~=0 or X.auto or p=="backward"or p=="jitter")then
        x=d.Position;
        local R,w,P=s(x);
        if R then
            local r=R-x;
            E=B(r.X,r.Z);
        else
        end;
        n=if n==0 then
            if X.auto then
                b(S.Character,d,E,w,P)
            else
                n
            else
                n;
            else
            end;
            if n~=0 then
                T=E+A(tonumber(X.ang)or 90)*(Y=="up"and-n or n);
            else
                if p=="spin"then x=q;
                q=x+A(tonumber(X.spin_rate)or 25);
                T=K+q;
            else
                T=if p=="backward"then E
            else
                if p=="jitter"then E
            else
                K;
            end;
        end;
        T=if p=="jitter"then T+A((M()*2-1)*(tonumber(X.jitter)or 0))
    else
        T;
    end;
    i=Y~="off";
    t=a(if Y=="down"then-1
else
    if Y=="up"then 1
else
    if Y=="jitter"then M()*2-1
else
    t,-1,1);
    o.LookYaw=T;
    o.VerticalLook=t;
    if typeof(o.Move)=="Vector2"then G=T-K;
    if math.abs(G)>1.0E-6 then
        local b,T,x=N(G),I(G),o.Move;
        o.Move=Vector2.new(x.X*b-x.Y*T,x.X*T+x.Y*b);
    end;
end;
if X.duck then
    K,Y=1/(2*a(tonumber(X.duck_rate)or 4,1,12)),tonumber(o.Buttons)or 0;
    if math.floor(os.clock()/K)%2==1 then
        o.Buttons=bit32.bor(Y,2);
    else
        o.Buttons=bit32.band(Y,bit32.bnot(2));
    end;
end;
if i then
    if c then
        if S then
            if S.Character then
                K=_(S.Character);
                if K then
                    pcall(O.applyVerticalLook,K,t,0);
                end;
            end;
        end;
    end;
end;
end,unload=function()X.on=false;
y,f=0,false;
H();
z,J=nil,nil;
k.ch=nil;
table.clear(g);
end
};
h.teardown(j.unload);
return j;
end;
D.V=function()local j={weapon=nil,cframe=nil,yaw=0,pitch=0,expires=0,cmd_samples=0};
j.cmd_active=function(h)h=h or os.clock();
if j.cmd_samples<=0 then
    return false;
elseif  h>j.expires then
    return false;
end;
if type(j.yaw)~="number"then return false;
elseif  type(j.pitch)~="number"then return false;
end;
return true;
end;
j.cmd_consume=function()if j.cmd_samples>0 then
    j.cmd_samples=j.cmd_samples-1;
end;
end;
j.clear=function()j.weapon=nil;
j.cframe=nil;
j.yaw=0;
j.pitch=0;
j.expires=0;
j.cmd_samples=0;
end;
return j;
end;
D.W=function()local j,h,b,K=D.load("b"),D.load("a"),D.load("j"),D.load("U");
local S=D.load("V");
local o=D.load("T");
local t,G,i=j.lp,j.storage,math.clamp;
local Y=math.floor;
local O=math.sqrt;
local T=math.abs;
local x=math.cos;
local p,A=math.sin,3.141592653589793;
local M=math.atan2;
local a=bit32.bor;
local B=bit32.band;
local N,I,R,n,E,d,w=bit32.bnot,{bhop=false,strafe=false,edge_jump=false,jump_bug=false,edge_bug=false,slow_walk=false,pixel_surf=false};
local P,r,L,Z,X,q,U=false;
do
    local z=G:FindFirstChild("MovementV2");
    if z then
        local J,y,f,k,g,Q=pcall(function()return require(z.Simulation),require(z.Simulation.State),require(z.Simulation.RuntimeSettings),require(z.Serial),require(z.Buttons);
    end);
    if J and type(y)=="table"then if type(y.step)=="function"then if type(f)=="table"then if type(k)=="table"then if type(g)=="table"then if type(Q)=="table"then local z=true;
    R,n,E,d,w,P=y,f,k,g,Q,z;
else
end;
else
end;
else
end;
else
end;
else
end;
else
end;
else
end;
r,L,Z,X,q,U=R,n,E,d,w,P;
end;
local R=q and q.Jump or 1;
local n=q and q.Duck or 2;
local E,d,w=q and q.Walk or 4,{char=nil,runtime=nil,bug_pending=false,hz=nil,config=nil,strafe_yaw=nil,strafe_side=1,capture=false,world=nil,world_tick=nil,world_owner=nil},{mode=nil,normal=nil,duck=false,wide=false,ticks=0,check=0,away=0,rest=0,jump=false,air=false};
local P=math.round;
local z=math.max;
local J=math.log;
local y,f,k,g=math.exp,6.283185307179586,{1,0.5,0},{};
for Q=0,7,1 do
    G=Q*A/4;
    g[Q+1]=Vector3.new(x(G),0,p(G));
end;
local Q={};
m:rH(Q,0,Vector2.zero);
for c=0,15,1 do
    j=c*A/8;
    Q[#Q+1]=Vector2.new(x(j),p(j));
end;
local c,H={},{};
G=b.mv_runtime;
if type(G)=="table"then if type(rawget(G,"advance"))=="function"then h.field(G,"advance",function(_)return function(s,...)d.runtime=s;
return _(s,...);
end;
end);
end;
end;
if type(G)=="table"then if type(rawget(G,"_composeWorld"))=="function"then j=h.field(G,"_composeWorld",function(_)return function(s,F,...)local v,u=_(s,F,...);
if v~=nil then
    d.world=v;
    d.world_tick=F;
    d.world_owner=s;
end;
return v,u;
end;
end);
d.capture=rawget(G,"_composeWorld")~=j;
h.teardown(function()d.capture=false;
d.world=nil;
d.world_tick=nil;
d.world_owner=nil;
end);
end;
end;
local function _(s,F,v)if q then
    if type(q.with)=="function"then return q.with(s,F,v);
end;
end;
if v then
    return a(s,F);
end;
return B(s,N(F));
end;
local function q(s)local F=d.runtime;
if type(F)~="table"then return nil;
end;
if rawget(F,"_started")~=true then
    return nil;
end;
if type(s)=="table"then local v=rawget(F,"_mapping");
if type(v)~="table"then return nil;
elseif  v.Generation~=s.Generation then
    return nil;
end;
end;
return F;
end;
local function s(F)local v=type(F)=="table"and tonumber(F.SimulationHz)or nil;
if not(v)then
    return nil;
end;
if d.hz==v then
    if d.config then
        return d.config;
    end;
end;
local F,u=pcall(Z.getMovementConfig,v);
if F then
    if type(u)~="table"then return nil;
end;
else
    return nil;
end;
d.hz=v;
d.config=u;
return u;
end;
local function Z(F,v)if U then
    if type(F)~="table"then return nil;
elseif  type(v)~="table"then return nil;
elseif  type(F.Support)~="table"then return nil;
end;
else
    return nil;
end;
local U=tonumber(F.ServerTick);
if not(U)then
    return nil;
end;
local u=q(F.Mapping);
if not(u)then
    return nil;
end;
local q=rawget(u,"_commandStream");
if type(q)~="table"then return nil;
end;
local V=d.world_owner==u and d.world_tick==U and d.world or nil;
if V then
else
    if d.capture then
    else
        local e=rawget(u,"_timeline");
        if type(e)~="table"then return nil;
    end;
    local l,C=pcall(e.resolve,e,U);
    if l then
        if type(C)~="table"then return nil;
    end;
else
    return nil;
end;
l,e=pcall(u._composeWorld,u,U,C.Revision,nil,v);
V=l and e or nil;
end;
end;
if type(V)~="table"then return nil;
elseif  type(V.Composed)~="table"then return nil;
elseif  type(V.Composed.Query)~="table"then return nil;
end;
U=s(F.Mapping);
if not U then
    return nil;
end;
local s,e=pcall(q.lastSampledCommandNumber,q);
if not(s)then
    return nil;
end;
q,s=pcall(X.addUInt32,e or 4294967295,1);
if not q then
    return nil;
end;
return{runtime=u,state=v,support=F.Support,world=V,config=U,step=i(tonumber(F.StepSeconds)or 0.015625,0.001,0.05),number=s};
end;
local function X(q)local U,s=pcall(L.clone,q.state);
if U then
    if type(s)~="table"then return nil;
end;
else
    return nil;
end;
local U,F=pcall(L.cloneSupport,q.support);
if U then
    if type(F)~="table"then return nil;
end;
else
    return nil;
end;
return s,F;
end;
local function L(q)local U=P(q%f/f*65536)%65536/65536*f;
if U>=A then
    return U-f;
end;
return U;
end;
local function A(q,U,f,s,F,v,u,V)local e,l=pcall(q.runtime._resolveSupportMotion,q.runtime,q.world,U,f);
if not(e)then
    return nil;
end;
local e,C,W,mF=pcall(r.step,U,f,{CommandNumber=s,Move=Vector2.new(P(i(F.X,-1,1)*127)/127,P(i(F.Y,-1,1)*127)/127),LookYaw=L(v),VerticalLook=P(i(u,-1,1)*127)/127,Buttons=V},q.step,q.world.Composed.Query,l,q.config,nil);
if e then
    if type(C)~="table"then return nil;
elseif  type(W)~="table"then return nil;
elseif  type(mF)~="table"then return nil;
end;
else
    return nil;
end;
return C,W,mF;
end;
local function P(r,L,q,U,f)local s,F=X(r);
if not(s)then
    return nil;
end;
return A(r,s,F,r.number,L,q,U,f);
end;
local function A(r,L,X,q)if q.Landed then
    return false;
elseif  q.StartSolid then
    return false;
elseif  L.OnGround==true then
    return false;
elseif  X.OnGround==true then
    return false;
end;
local U,f=L.Velocity,X.Velocity;
if typeof(U)~="Vector3"then return false;
elseif  typeof(f)~="Vector3"then return false;
elseif  U.Y>=-4 then
    return false;
end;
q=T(tonumber(r.config.Gravity)or 60);
local s=math.max(1.25,q*r.step*1.35);
if T(f.Y)>s then
    return false;
elseif  f.Y<=U.Y+4 then
    return false;
end;
return X.Position.Y<=L.Position.Y+0.05;
end;
local function r(L,X,q,U,f)local s=_(_(f,R,false),n,false);
local F,v,v=P(L,X,q,U,s);
if not(F)then
    return nil;
end;
if A(L,L.state,F,v)then
    return X,false;
end;
if not(v.Landed)then
    return nil;
end;
f=#Q+1;
for u=0,#Q,1 do
    F=u+1;
    c[F]=u;
    H[F]=((u==0 and X or Q[u])-X).Magnitude;
end;
for u=2,f,1 do
    local V,e,l=c[u],H[u],u-1;
    while l>=1 and H[l]>e do
        c[l+1]=c[l];
        H[l+1]=H[l];
        l-=1;
    end;
    c[l+1]=V;
    H[l+1]=e;
end;
local u,V,e;
for l=0,1,1 do
    v=l==1;
    local C,W=v and 0.25 or 0,_(s,n,v);
    for s=1,f,1 do
        F=c[s];
        if l~=0 or F~=0 then
            local f=H[s]+C;
            if u then
                if f>=u then
                    break;
                end;
            end;
            local c=F==0 and X or Q[F];
            local X,Q,Q=P(L,c,q,U,W);
            if X then
                if A(L,L.state,X,Q)then
                    u,V,e=f,c,v;
                    break;
                end;
            end;
        end;
    end;
end;
return V,e;
end;
local function A(L,X)local q,U=p(X),x(X);
local f,Q=U*L.X+q*L.Y,-q*L.X+U*L.Y;
X=f*f+Q*Q;
if X>1 then
    U=1/O(X);
    f,Q=f*U,Q*U;
else
end;
return Vector3.new(f,0,Q);
end;
local function O(L,X)local q,U=p(X),x(X);
return Vector2.new(U*L.X-q*L.Z,q*L.X+U*L.Z);
end;
local function L(X,q,U,f)local Q=Vector3.new(U.X,0,U.Z);
local c,H=Q.Magnitude,d.strafe_yaw;
d.strafe_yaw=q;
if c<=0.05 then
    if X.Magnitude>0.001 then
        return X.Magnitude>1 and X.Unit or X;
    end;
    U=d.strafe_side or 1;
    d.strafe_side=U;
    return Vector2.new(U,0);
end;
U=Q/c;
Q=Vector3.new(U.Z,0,-U.X);
c=A(X,q):Dot(Q);
X=nil;
if T(c)>0.01 then
    X=c>0 and 1 or-1;
else
    if H~=nil then
        U=math.atan2(p(q-H),x(q-H));
        X=if T(U)>1.0E-4 then
            U>0 and 1 or-1
        else
            X;
        else
        end;
    end;
    if X then
    else
        U=tonumber(f);
        X=if U then
            Y(U)%2==0 and 1 or-1
        else
            -(d.strafe_side or 1);
        end;
        d.strafe_side=X;
        return O(Q*X,q);
    end;
    local function Y(X)if typeof(X)~="Vector3"then return nil;
elseif  T(X.Y)>=0.7 then
    return nil;
end;
local q=Vector3.new(X.X,0,X.Z);
if q.Magnitude<0.3 then
    return nil;
end;
return q.Unit;
end;
local function X(q)return q.Stance=="Ducking"and"Ducking"or"Standing";
end;
local function q(U,f)local Q=f=="Ducking"and U.PlayerSizeDucking or U.PlayerSizeStanding;
return typeof(Q)=="Vector3"and Q.X*0.5 or 1.2;
end;
local function U(f,Q)local c=Q=="Ducking"and f.PlayerSizeDucking or f.PlayerSizeStanding;
return typeof(c)=="Vector3"and c.Y*0.5 or 2.7;
end;
local function f(Q,c)return c.Position.Y-U(Q,X(c));
end;
local function Q(c)local H,s=c.PlayerSizeStanding,c.PlayerSizeDucking;
if typeof(H)~="Vector3"then return 0.27;
elseif  typeof(s)~="Vector3"then return 0.27;
end;
return(H.Y-s.Y)*(tonumber(c.DuckJumpOriginShiftFraction)or 0.2);
end;
local function c(H)local s=tonumber(H.DuckAmount);
if s then
    if s>=0.999 then
        return true;
    end;
end;
s=tonumber(H.DuckCooldownSeconds);
if s then
    if s>0 then
        local s=tonumber(H.DuckAmount);
        if s then
            if s<=0.75 then
                return false;
            end;
        else
            return false;
        end;
    end;
end;
return(tonumber(H.DuckSpeed)or 8)>=3.5;
end;
local function H(s,F,v,u)local V,e=pcall(s.Sweep,s,F,v,u,nil,1,1);
if V then
    if type(e)=="table"then return e;
end;
end;
return nil;
end;
local function s(F,v,u,V)local e,l=pcall(F.FindGround,F,v,u,V,1);
if e then
    if type(l)=="table"then return l;
end;
end;
return nil;
end;
local function F(v,u,V)local e,l=pcall(v.IsClear,v,u,V,1);
return e and l==true;
end;
local function v(u,V)if V<=0 then
    return 0;
end;
local e=z(tonumber(u.Friction)or 5.2,0.1);
local l=(tonumber(u.GroundAccelerate)or 5.5)*z(tonumber(u.DefaultBaseMoveSpeed)or 18.75,1)/e;
u=J(1+V/l)/e;
return(V+l)/e*(1-y(-e*u))-l*u;
end;
local function J(y,u,V,e,l)local C=u-Vector3.new(0,0.5,0);
u=C+V*(e*2+0.35);
if not(F(y,u,l))then
    return V;
end;
e=H(y,u,C,l);
if e then
    if not(e.StartSolid)then
        C=tonumber(e.Fraction);
        if C then
            if C<1 then
                u=Y(e.Normal);
                if u then
                    if u:Dot(V)>0.5 then
                        return u;
                    end;
                end;
            end;
        end;
    end;
end;
return V;
end;
local function y(u)return(tonumber(u.MaxStepHeight)or 1.35)+0.15;
end;
local function u(V,e,l,C)return F(V,e,l)and s(V,e,l,C)==nil;
end;
local function V(e,l,C)return s(e,l,C,1.5)~=nil;
end;
local function e(l)w.mode=nil;
w.normal=nil;
w.duck=false;
w.wide=false;
w.ticks=0;
w.check=0;
w.away=0;
if l then
    w.rest=10;
end;
end;
local function l(C,W)local mF,DF,jF,hF=C.world.Composed.Query,C.config,X(W),W.Position;
local bF,KF,SF=q(DF,jF),y(DF),w.mode=="catch"and w.normal or nil;
e(false);
SF=SF and(if u(mF,hF+SF*(bF*2+0.6),jF,KF)then
    SF
else
    nil);
    if SF then
    else
        C,DF=bF*2+0.35,Vector3.zero;
        for oF=1,#g,1 do
            W=g[oF];
            DF=if u(mF,hF+W*C,jF,KF)then
                DF+W
            else
                DF;
            end;
            SF=if DF.Magnitude>0.3 then
                J(mF,hF,DF.Unit,bF,jF)
            else
                SF;
            end;
            if not(SF)then
                return;
            end;
            w.mode="ride";
            w.normal=SF;
            w.wide=not u(mF,hF-SF*(bF*2+0.35),jF,KF);
        end;
        local function J(C,W,mF,DF,jF,hF,bF)local KF,SF,oF=C.world.Composed.Query,C.config,w.normal;
        local tF,GF=Vector3.new(-oF.Z,0,oF.X),A(mF,DF);
        mF=GF:Dot(oF);
        if mF>0.7 then
            w.away=w.away+1;
            if w.away>=30 then
                e(true);
                return nil;
            end;
        else
            w.away=0;
        end;
        local iF=X(W);
        w.check=w.check+1;
        if w.check>=8 then
            w.check=0;
            if not(u(KF,W.Position+oF*(q(SF,iF)*2+0.6),iF,y(SF)))then
                e(false);
                return nil;
            end;
        end;
        local y,u,YF,OF,TF=_(_(hF,R,false),n,false),GF:Dot(tF),bF:Dot(oF),bF:Dot(tF),false;
        GF=v(SF,T(OF))+0.45;
        if T(OF)>0.5 and not V(KF,W.Position+tF*(OF>0 and GF or-GF),iF)then
            u,TF=OF>0 and-1 or 1,true;
        else
            if T(u)>0.05 and(u*OF<=0 or T(OF)<=0.5)then
                if V(KF,W.Position+tF*(u>0 and GF or-GF),iF)then
                else
                    bF,hF=true,0;
                    u,TF=hF,bF;
                end;
            else
            end;
        end;
        bF=if w.wide then
            z(YF,0)*0.9+z(-mF,0)
        else
            YF*0.9;
            for OF=1,3,1 do
                iF=if OF==1 then
                    tF*u-oF*i(bF,-1,1)
                else
                    if OF==2 then
                        tF*(u*0.5)-oF*(YF>=0 and 1 or-1)
                    else
                        Vector3.zero;
                        iF=if iF.Magnitude>1 then
                            iF.Unit
                        else
                            iF;
                            mF=iF.Magnitude>0.01 and O(iF,DF)or Vector2.zero;
                            if OF==1 then
                                if not(TF)then
                                    if YF<=0 then
                                        if iF:Dot(oF)<=0 then
                                            return mF;
                                        end;
                                    end;
                                end;
                            end;
                            W=P(C,mF,DF,jF,y);
                            if W then
                                if W.OnGround==true then
                                    hF=W.Velocity;
                                    GF=hF.X*oF.X+hF.Z*oF.Z;
                                    if GF<=0.35 then
                                        return mF;
                                    elseif  V(KF,W.Position+oF*v(SF,GF),X(W))then
                                        return mF;
                                    end;
                                end;
                            end;
                        end;
                        e(true);
                        return nil;
                    end;
                    local function y(v,u,V,C)local W=Vector3.new(V.X,0,V.Z);
                    local mF,DF,jF,hF=W.Magnitude>1 and W.Unit or nil,v.world.Composed.Query,X(u),u.Position;
                    V=if mF then
                        C+mF*0.6
                    else
                        C;
                        if V.Magnitude<0.15 then
                            return nil;
                        end;
                        W=Y(u.WallNormal);
                        u,C=W and-V.Unit:Dot(W)or nil,W;
                        for bF=1,#g,1 do
                            mF=g[bF];
                            if V:Dot(mF)>0.15 then
                                v=H(DF,hF,hF+mF*2.6,jF);
                                if v then
                                    if v.AllSolid then
                                    else
                                        bF=tonumber(v.Fraction);
                                        if bF then
                                            if bF<1 then
                                                W=Y(v.Normal);
                                                if W then
                                                    local Y=-V.Unit:Dot(W);
                                                    if Y>0.25 then
                                                        if u then
                                                            if Y>u then
                                                                u,C=Y,W;
                                                            else
                                                            end;
                                                        else
                                                            u,C=Y,W;
                                                        end;
                                                    else
                                                    end;
                                                else
                                                end;
                                            else
                                            end;
                                        else
                                        end;
                                    end;
                                else
                                end;
                            else
                            end;
                        end;
                        return C;
                    end;
                    local function Y(g,H,v,u)local V,C,W,mF=g.world.Composed.Query,g.config,H.Position,X(H);
                    local X,DF=f(C,H),T(tonumber(C.Gravity)or 60);
                    local f,jF,hF,bF,KF=u.Y>0 and u.Y*u.Y/(2*DF)or 0,z(0,tonumber(C.AutoJumpLedgeAssistHeight)or 0),U(C,mF),(tonumber(H.DuckAmount)or 0)>=0.999,0;
                    if bF then
                    else
                        KF=Q(C);
                        KF=if mF~="Ducking"then KF+(C.PlayerSizeStanding.Y-C.PlayerSizeDucking.Y)*0.5
                    else
                        KF;
                    end;
                    g=s(V,W,mF,14);
                    DF,u=g and g.Position.Y-hF or X-14,X+f;
                    f,g=u+jF;
                    for U=1,3,1 do
                        X=W-v*(U==1 and 0.1 or U==2 and 0.4 or q(C,mF)+0.2);
                        for q=1,#k,1 do
                            jF=f+KF*k[q]+0.2;
                            U=Vector3.new(X.X,jF+hF,X.Z);
                            if F(V,U,mF)then
                                q=s(V,U,mF,jF-DF+14);
                                if q then
                                    g=q.Position.Y-hF;
                                    break;
                                end;
                            end;
                        end;
                        if g then
                            break;
                        end;
                    end;
                    if g then
                        if g<=DF+0.6 then
                            return nil;
                        end;
                    else
                        return nil;
                    end;
                    if g<=u-0.2 then
                        return bF;
                    end;
                    if KF>0 then
                        if g<=f+KF then
                            if c(H)then
                                return true;
                            end;
                        end;
                    end;
                    if g<=f then
                        return bF;
                    end;
                    return nil;
                end;
                local function X(q,U,z,f,k,g)local Q,c=A(z,f),w.mode=="catch"and w.normal or nil;
                if c then
                    w.ticks=w.ticks+1;
                    if w.ticks>40 then
                        e(false);
                        c=nil;
                    else
                        if Q:Dot(c)>0.7 then
                            e(false);
                            c=nil;
                        else
                        end;
                    end;
                else
                end;
                z=c;
                if not z then
                    c=y(q,U,k,Q);
                    if not(c)then
                        return nil;
                    end;
                    local A=Y(q,U,c,k);
                    if A==nil then
                        return nil;
                    end;
                    w.mode="catch";
                    w.normal=c;
                    w.duck=A;
                    w.ticks=0;
                    w.check=0;
                    return O(-c,f),A or g;
                end;
                w.check=w.check+1;
                if w.check>=3 then
                    w.check=0;
                    Q=Y(q,U,z,k);
                    if Q==nil then
                        e(false);
                        return nil;
                    end;
                    if Q then
                        w.duck=true;
                    end;
                end;
                return O(-z,f),w.duck or g;
            end;
            local function Y(A,q,U,z,y,f,k,g,Q,c,H)if g then
                if H then
                    e(true);
                    return nil;
                end;
                if Q or w.mode=="catch"then if w.rest>0 then
                    e(false);
                    return nil;
                elseif  c then
                    e(false);
                    return nil;
                end;
                l(A,q);
            end;
            if w.mode~="ride"then return nil;
        end;
        local g=J(A,q,U,z,y,f,k);
        if g then
            return g,false;
        end;
        return nil;
    end;
    if w.mode=="ride"then e(false);
end;
if w.rest>0 then
    return nil;
end;
return X(A,q,U,z,k,B(f,n)~=0);
end;
local function A(X)d.char=X;
d.bug_pending=false;
d.hz=nil;
d.config=nil;
d.strafe_yaw=nil;
d.strafe_side=1;
w.mode=nil;
w.normal=nil;
w.duck=false;
w.wide=false;
w.ticks=0;
w.check=0;
w.away=0;
w.rest=0;
w.jump=false;
w.air=false;
end;
local function X(q,U,z)local J=U and U.State or q and q.MovementState;
if type(J)~="table"then return nil;
end;
local y=q and q.Character;
if d.char~=y then
    A(y);
end;
local f,k,g,Q,c,H,s,F,v=tonumber(z.Buttons)or 0,typeof(z.Move)=="Vector2"and z.Move or Vector2.zero,tonumber(z.LookYaw)or tonumber(J.LookYaw)or 0,tonumber(z.VerticalLook)or tonumber(J.VerticalLook)or 0,typeof(J.Velocity)=="Vector3"and J.Velocity or q and q.GlobalVelocity or Vector3.zero,J.OnGround==true,J.MovementMode==nil or J.MovementMode=="Walking";
y=false;
if not(I.jump_bug)then
    d.bug_pending=false;
end;
if s and I.strafe then
    if H then
        d.strafe_yaw=nil;
    end;
else
    d.strafe_yaw=nil;
end;
local u=B(f,R)~=0;
local V,l=u and not w.jump,w.air and H;
w.jump=u;
local C=not H;
w.air=C;
local W=I.pixel_surf and s;
if W then
    if w.rest>0 then
        w.rest=w.rest-1;
    end;
elseif  w.mode~=nil then
    e(false);
end;
local w=if s and I.bhop then
    if q then
        if q.JumpInputDown then
            H
        else
            nil
        else
            nil
        else
            nil;
            if d.bug_pending then
                d.bug_pending=false;
                if I.jump_bug then
                    if s then
                        if H then
                            local e,mF,DF=true,false,true;
                            w,F,y=e,mF,DF;
                        else
                        end;
                    else
                    end;
                else
                end;
            else
            end;
            q=s and(W or I.edge_jump and H or(if H then
                C
            else
                I.jump_bug or I.edge_bug))and Z(U,J)or nil;
                if q and not y then
                    if W then
                        local e,mF=Y(q,J,k,g,Q,f,c,H,l,u,V);
                        if e then
                            local Y,DF,jF=false,mF==true,true;
                            w,F,v,y=Y,DF,e,jF;
                        else
                        end;
                    else
                    end;
                else
                end;
                if q and not y then
                    if I.edge_jump then
                        if H then
                            V,u,J=P(q,k,g,Q,_(f,R,false));
                            w=if V and J.LeftGround then
                                if J.Jumped then
                                    w
                                else
                                    if V.OnGround~=true then
                                        true
                                    else
                                        w
                                    else
                                        w;
                                    else
                                    end;
                                else
                                end;
                            else
                            end;
                            if q and not y and I.edge_bug and C then
                                if c.Y<-4 then
                                    W=if w~=nil then
                                        (_(f,R,w))
                                    else
                                        f;
                                        W=if F~=nil then
                                            (_(W,n,F))
                                        else
                                            W;
                                            l,J=r(q,k,g,Q,W);
                                            if typeof(l)=="Vector2"then local Y,r,u=false,J==true,true;
                                            w,F,v,y=Y,r,l,u;
                                        else
                                        end;
                                    else
                                    end;
                                else
                                end;
                                if q and not y and I.jump_bug and C then
                                    if c.Y<-4 then
                                        l=_(_(f,R,false),n,true);
                                        V,J,W=P(q,k,g,Q,l);
                                        if V then
                                            if W.Landed then
                                                d.bug_pending=true;
                                                local Y,d,r=false,true,true;
                                                w,F,y=Y,d,r;
                                            else
                                            end;
                                        else
                                        end;
                                    else
                                    end;
                                else
                                end;
                                v=if(if y then
                                    not y
                                else
                                    s)and I.strafe then
                                        if H then
                                            v
                                        else
                                            L(k,g,c,U and U.ServerTick)
                                        else
                                            v;
                                            if typeof(v)=="Vector2"then z.Move=v;
                                        end;
                                        f=if w~=nil then
                                            (_(f,R,w))
                                        else
                                            f;
                                            f=if F~=nil then
                                                (_(f,n,F))
                                            else
                                                f;
                                                z.Buttons=if I.slow_walk and s then
                                                    if H then
                                                        _(f,E,true)
                                                    else
                                                        f
                                                    else
                                                        f;
                                                        return F;
                                                    end;
                                                    local function Y(n,E,d)if typeof(n.Move)~="Vector2"then return;
                                                end;
                                                local w=E-d;
                                                if T(w)<=1.0E-6 then
                                                    return;
                                                end;
                                                local T,E,d=x(w),p(w),n.Move;
                                                n.Move=Vector2.new(d.X*T-d.Y*E,d.X*E+d.Y*T);
                                            end;
                                            local function T(x)if x>0.1 then
                                                return 1;
                                            elseif  x<-0.1 then
                                                return-1;
                                            end;
                                            return 0;
                                        end;
                                        local function x(p)if typeof(p)~="Vector3"then return 0;
                                    end;
                                    return Vector3.new(p.X,0,p.Z).Magnitude;
                                end;
                                local function p(n)local E=n.CameraPart;
                                if typeof(E)=="Instance"then if E:IsA("BasePart")then
                                    if E.Parent then
                                        return E.Position;
                                    end;
                                end;
                            end;
                            E=n.HumanoidRootPart;
                            if typeof(E)=="Instance"then if E:IsA("BasePart")then
                                if E.Parent then
                                    return E.Position+Vector3.new(0,2,0);
                                end;
                            end;
                        end;
                        return nil;
                    end;
                    local function n(E,d,w,r,L)local q=d.Velocity;
                    if typeof(q)~="Vector3"then return Vector2.zero;
                elseif  d.OnGround~=true then
                    return Vector2.zero;
                end;
                local U=Vector3.new(q.X,0,q.Z);
                q=U.Magnitude;
                if q<0.05 then
                    return Vector2.zero;
                end;
                local z,J=O(-U/q,w),Z(E,d);
                if J then
                    U,E=P(J,Vector2.zero,w,r,L),P(J,z,w,r,L);
                    if U then
                        if E then
                            if x(E.Velocity)<x(U.Velocity)then
                                return z;
                            end;
                            return Vector2.zero;
                        end;
                    end;
                end;
                if q>2.5 then
                    return z;
                end;
                return Vector2.zero;
            end;
            local function O(E,d,w,P,r,L)local Z=os.clock();
            if P.Magnitude>0.1 then
                o.input_at=Z;
            elseif  r then
                o.input_at=Z;
            end;
            if E then
                if o.broke then
                    return;
                elseif  not(o.active(Z))then
                    return;
                end;
            else
                return;
            end;
            local q,U=T(P.X),T(P.Y);
            if o.fresh then
                o.fresh=false;
                o.bx=q;
                o.by=U;
                o.bj=r;
            elseif  q~=0 and q~=o.bx or U~=0 and U~=o.by then
                o.broke=true;
                return;
            elseif  r then
                if not(o.bj)then
                    o.broke=true;
                    return;
                end;
            end;
            if q~=o.bx then
                o.bx=0;
            end;
            if U~=o.by then
                o.by=0;
            end;
            if not(r)then
                o.bj=false;
            end;
            U=d and d.State or E.MovementState;
            if type(U)~="table"then return;
        end;
        q,r=tonumber(w.LookYaw)or tonumber(U.LookYaw)or 0,tonumber(w.VerticalLook)or 0;
        if L then
            o.samples=0;
        else
            Z,P=p(E),o.target;
            if Z then
                if typeof(P)=="Vector3"then local T=P-Z;
                local p=T.Magnitude;
                if p>0.05 then
                    local E=T/p;
                    local T,p=M(-E.X,-E.Z),i(E.Y,-0.98,0.98);
                    w.LookYaw=T;
                    w.VerticalLook=p;
                    o.samples=o.samples+1;
                    q,r=T,p;
                else
                end;
            else
            end;
        else
        end;
    end;
    P=_(tonumber(w.Buttons)or 0,R,false);
    w.Buttons=P;
    w.Move=n(d,U,q,r,P);
    o.ground=U.OnGround==true;
    if o.ground then
        if x(U.Velocity)<=0.25 then
            o.still=o.still+1;
        else
            o.still=0;
        end;
    else
        o.still=0;
    end;
end;
j,G={cfg=I},b.character;
if type(G)=="table"then if type(G.SampleInput)=="function"then b=h.field(G,"SampleInput",function(i)return function(T,x)local p=i(T,x);
if type(p)~="table"then return p;
end;
local i,M,I=typeof(p.Move)=="Vector2"and p.Move or Vector2.zero,T~=nil and T.JumpInputDown==true,X(T,x,p);
K.apply(T,p);
if I~=nil then
    local K=tonumber(p.Buttons)or 0;
    if I then
        p.Buttons=a(K,2);
    else
        p.Buttons=B(K,N(2));
    end;
end;
I=false;
if S.cmd_samples>0 then
    if os.clock()<=S.expires then
        local K=tonumber(p.LookYaw)or S.yaw;
        p.LookYaw=S.yaw;
        p.VerticalLook=S.pitch;
        Y(p,S.yaw,K);
        S.cmd_samples=S.cmd_samples-1;
        if S.cmd_samples<=0 then
            S.expires=0;
        end;
        I=true;
    else
        S.cmd_samples=0;
        S.expires=0;
    end;
else
end;
O(T,x,p,i,M,I);
return p;
end;
end);
o.hooked=G.SampleInput~=b;
A(nil);
h.connect(t.CharacterAdded,function(b)S.clear();
o.release();
A(b);
end);
end;
end;
h.teardown(function()S.clear();
o.hooked=false;
o.release();
A(nil);
end);
return j;
end;
D.X=function()local j,h,b,K,S=D.load("b"),D.load("q"),D.load("f"),D.load("a"),D.load("j");
local o=h.misc;
local h=j.lp;
local t=j.hook;
local G=b.trim;
local b=S.flash_fx;
local i=S.smoke_fx;
local Y=S.tracer_fx;
local O=S.camera;
local T,x=tonumber(S.constants and S.constants.DEFAULT_CAMERA_FOV)or 70,{};
local function p(A)if type(b)~="table"then return;
end;
if A then
    if not(x.flash)then
        x.flash=b.Flash;
        function b.Flash()return false;
    end;
end;
elseif  x.flash then
    b.Flash=x.flash;
    x.flash=nil;
end;
end;
local b;
local A=type(i)=="table"and rawget(i,"Create")or nil;
if type(A)=="function"then b=K.detour(A,j.newc(function(...)if o.smoke then
    return nil;
end;
return b(...);
end));
else
end;
local function M(a)if x.smoke==a then
    return;
elseif  type(i)~="table"then return;
end;
x.smoke=a;
if not(b)then
    if A then
        i.Create=a and function()end
        or A;
    end;
end;
if a then
    if type(i.DestroyAll)=="function"then pcall(i.DestroyAll);
end;
end;
end;
local function b(i)if type(Y)~="function"then return;
elseif  type(t)~="function"then return;
end;
if i then
    if not(x.tracer)then
        x.tracer=t(Y,function()end);
    end;
elseif  x.tracer then
    pcall(t,Y,x.tracer);
    x.tracer=nil;
end;
end;
local function t(i)if type(O)~="table"then return;
elseif  type(O.updateCameraFOV)~="function"then return;
end;
if i then
    if not(x.fov)then
        local i=O.updateCameraFOV;
        x.fov=i;
        function O.updateCameraFOV()return i(T);
    end;
end;
elseif  x.fov then
    O.updateCameraFOV=x.fov;
    x.fov=nil;
end;
end;
local i=j.weak();
local function Y(O)local T,x=i[O];
if T then
    x=T;
else
    x={parts={},guis={},dirty=true};
    i[O]=x;
    local function i()x.dirty=true;
end;
x.added=O.DescendantAdded:Connect(i);
x.gone=O.DescendantRemoving:Connect(i);
end;
if x.dirty then
    x.dirty=false;
    local i,T,A,a,B=x.parts,x.guis,O:GetDescendants(),0,0;
    for O=1,#A,1 do
        local N=A[O];
        if N:IsA("MeshPart")then
            a+=1;
            i[a]=N;
        else
            if N:IsA("SurfaceGui")then
                B+=1;
                T[B]=N;
            else
            end;
        end;
    end;
    G(i,a);
    G(T,B);
end;
return x;
end;
local function i(O)if O then
    if typeof(O)~="Instance"then return;
end;
else
    return;
end;
local T=Y(O);
local Y,O=T.parts,T.guis;
for x=1,#Y,1 do
    T=Y[x];
    if T.Transparency~=1 then
        T.Transparency=1;
    end;
end;
for Y=1,#O,1 do
    T=O[Y];
    if T.Enabled then
        T.Enabled=false;
    end;
end;
end;
local Y;
local O,T,x,A={},{},{},true;
local function a()if Y then
    if Y.Parent then
        local B=Y;
        return B;
    end;
end;
Y=nil;
local B=h:FindFirstChild("PlayerGui");
if not(B)then
    return nil;
end;
local h=B:FindFirstChild("MainGui");
h=h and(h:FindFirstChild("Gameplay"));
h=h and(h:FindFirstChild("Middle"));
return h and(h:FindFirstChild("SniperScope"));
end;
local function h()for B=#O,1,-1 do
    O[B]:Disconnect();
    O[B]=nil;
end;
G(T,0);
G(x,0);
Y,A=nil,true;
end;
local B;
local function N(I)if Y==I then
    return;
end;
h();
Y=I;
if not I then
    return;
end;
O[1]=I.DescendantAdded:Connect(function()A=true;
if o.scope then
    B(I);
end;
end);
O[2]=I.DescendantRemoving:Connect(function()A=true;
end);
if I:IsA("GuiObject")then
    O[3]=I:GetPropertyChangedSignal("Visible"):Connect(function()if o.scope then
        if I.Visible then
            I.Visible=false;
        end;
    end;
end);
elseif  I:IsA("LayerCollector")then
    O[3]=I:GetPropertyChangedSignal("Enabled"):Connect(function()if o.scope then
        if I.Enabled then
            I.Enabled=false;
        end;
    end;
end);
end;
A=true;
end;
local function O(I)I.Visible=false;
end;
local function I(R)R.Enabled=false;
end;
local function R(n)n.ImageTransparency=1;
end;
B=function(n)if not(n)then
    return;
end;
if n:IsA("GuiObject")then
    pcall(O,n);
elseif  n:IsA("LayerCollector")then
    pcall(I,n);
end;
if A then
    A=false;
    local A,E=n:GetDescendants(),0;
    for n=1,#A,1 do
        local d=A[n];
        if d:IsA("UIStroke")then
            E+=1;
            T[E]=d;
            x[E]=1;
        else
            if d:IsA("GuiObject")then
                E+=1;
                T[E]=d;
                x[E]=(d:IsA("ImageLabel")or d:IsA("ImageButton"))and 2 or 0;
            else
            end;
        end;
    end;
    G(T,E);
    G(x,E);
end;
for G=1,#T,1 do
    local A,n=T[G],x[G];
    if n==1 then
        if A.Enabled then
            pcall(I,A);
        end;
    else
        if A.Visible then
            pcall(O,A);
        end;
        if n==2 then
            if A.ImageTransparency~=1 then
                pcall(R,A);
            end;
        end;
    end;
end;
end;
j={removals=function(G)o.scope=G.scope==true;
o.flash=G.flash==true;
o.smoke=G.smoke==true;
o.hands=G.hands==true;
o.bullets=G.bullets==true;
p(o.flash);
M(o.smoke);
b(o.bullets);
t(o.scope);
end,sync=function()if not(o.scope)then
    if Y then
        h();
    end;
    return;
end;
local G=a();
N(G);
B(G);
G=S.inventory;
if not G then
    return;
end;
local S=G.peekCurrentEquippedForMovement();
if S then
    if S.IsDestroyed then
        return;
    end;
else
    return;
end;
G=S.Viewmodel;
S=G and G.Bobble;
if not S then
    return;
end;
i(S.Scope);
i(S.ScopeReticlePart);
end,unload=function()p(false);
M(false);
b(false);
t(false);
o.scope=false;
o.hands=false;
h();
end
};
K.teardown(j.unload);
return j;
end;
D.Y=function()local j=D.load("b");
local h,b=j.module(j.storage,"Components","Common","WeaponTimings"),{};
b.last=j.weak();
b.global_last=0;
b.min_interval=function(j)local K=0.05;
if type(j)~="table"then return K;
end;
if type(h)=="table"then if type(h.MinShotInterval)=="function"then local S,o=pcall(h.MinShotInterval,j);
K=if S then
    if type(o)=="number"then if o>0 then
        if o<math.huge then
            if o>K then
                o
            else
                K
            else
                K
            else
                K
            else
                K
            else
                K;
            else
            end;
        else
        end;
        local h=tonumber(j.FireRate);
        K=if h then
            if h>0 then
                if h>K then
                    h
                else
                    K
                else
                    K
                else
                    K;
                    h=j.FireModes;
                    if type(h)=="table"then j=h.Primary;
                    if type(j)=="table"then local S=tonumber(j.FireRate);
                    K=if S then
                        if S>0 then
                            if S<K then
                                S
                            else
                                K
                            else
                                K
                            else
                                K;
                            else
                            end;
                            local j=h.Secondary;
                            if type(j)=="table"then local h=tonumber(j.FireRate);
                            K=if h then
                                if h>0 then
                                    if h<K then
                                        h
                                    else
                                        K
                                    else
                                        K
                                    else
                                        K;
                                    else
                                    end;
                                else
                                end;
                                return if K<0.05 then
                                    0.05
                                else
                                    K;
                                end;
                                b.wait=function(j,h,K)K=K or os.clock();
                                local S=if h==nil then
                                    if j then
                                        j.Properties
                                    else
                                        h
                                    else
                                        h;
                                        local o,t=b.min_interval(S),b.global_last;
                                        if j then
                                            h=b.last[j];
                                            t=if h then
                                                if h>t then
                                                    h
                                                else
                                                    t
                                                else
                                                    t;
                                                else
                                                end;
                                                j=t+o-K;
                                                if j>0 then
                                                    return j;
                                                end;
                                                return 0;
                                            end;
                                            b.ready=function(j,h,K)return b.wait(j,h,K)<=0;
                                        end;
                                        b.mark=function(j,h)h=h or os.clock();
                                        if j then
                                            b.last[j]=h;
                                        end;
                                        b.global_last=h;
                                    end;
                                    b.clear=function(j)if j then
                                        b.last[j]=nil;
                                    end;
                                end;
                                return b;
                            end;
                            D.Z=function()local j,h,b,K=D.load("b"),D.load("a"),D.load("j"),D.load("V");
                            local S=D.load("Y");
                            local o=j.workspace;
                            local t=j.input;
                            local G=j.plain;
                            local i=math.clamp;
                            local Y=table.pack;
                            local O=table.unpack;
                            local T,x,p=Enum.UserInputType.MouseButton1,false,false;
                            local A=b.platform;
                            if type(A)=="function"then local M,a=pcall(A);
                            j.reclaim();
                            x=M and type(a)=="table"and table.find(a,"Mobile")~=nil and#a<=1;
                        else
                        end;
                        A=b.mobile_shoot;
                        if x then
                            if type(A)=="table"then if type(rawget(A,"SetManualFireHeld"))=="function"then h.field(A,"SetManualFireHeld",function(b)local function A(M,...)p=M==true;
                            return b(M,...);
                        end;
                        return A;
                    end);
                end;
            end;
        end;
        local b,A=x,{alive=true,generation=0};
        A.forcing=j.weak();
        A.intent=j.weak();
        A.manual=j.weak();
        A.last_target=j.weak();
        A.pending=j.weak();
        A.last_shot=0;
        A.last_scan=0;
        A.props=nil;
        A.origin=nil;
        A.target=nil;
        A.held=function()if b then
            local j=p;
            return j;
        end;
        return t:IsMouseButtonPressed(T);
    end;
    A.open_gate=function(j)local b=rawget(j,"ShootDelayThread");
    if b then
        pcall(task.cancel,b);
    end;
    j.ShootDelayThread=nil;
    j.IsShooting=false;
    j.NextShotDue=nil;
end;
A.can_force=function(j,b)if j then
    if j.IsDestroyed then
        return false;
    elseif  not(j.IsEquipped)then
        return false;
    end;
else
    return false;
end;
if j.IsReloading then
    return false;
elseif  j.IsAdjustingSuppressor then
    return false;
end;
if type(j.Rounds)~="number"then return false;
elseif  j.Rounds<=0 then
    return false;
end;
local t=j.Properties;
if t then
    if t.Class~="Weapon"then return false;
end;
else
    return false;
end;
if b=="rapid"then if j.IsChargeFiring then
    return false;
elseif  j.IsBurstShooting then
    return false;
end;
if t.ShootingOptions=="Revolver"then return false;
end;
end;
return true;
end;
A.has_pending=function(j)for b,b in A.pending,nil,nil do
    if b==j then
        return true;
    end;
end;
return false;
end;
A.bind=function(j,b,t)A.props=j;
A.origin=b;
A.target=t;
end;
A.unbind=function()A.props=nil;
A.origin=nil;
A.target=nil;
end;
A.cancel=function()A.generation=A.generation+1;
for j in A.pending,nil,nil do
    pcall(task.cancel,j);
    A.pending[j]=nil;
end;
for j,b in A.manual,nil,nil do
    A.manual[j]=nil;
    if type(b)=="table"then if b.thread then
        pcall(task.cancel,b.thread);
        b.thread=nil;
    end;
end;
end;
for j in A.last_target,nil,nil do
    A.last_target[j]=nil;
end;
for j in A.intent,nil,nil do
    A.intent[j]=nil;
end;
A.unbind();
end;
A.toward=function(j,b,t,...)local T=o.CurrentCamera;
if T then
    if j then
        if typeof(b)~="Vector3"then return false;
    elseif  typeof(t)~="Vector3"then return false;
end;
else
    return false;
end;
else
    return false;
end;
if(t-b).Magnitude<=1.0E-4 then
    return false;
end;
if not(S.ready(j))then
    return false;
end;
local o,x=T.CFrame,CFrame.lookAt(b,t);
t,b=x:ToEulerAnglesYXZ();
K.weapon=j;
K.cframe=x;
K.yaw=b;
K.pitch=i(x.LookVector.Y,-1,1);
K.expires=os.clock()+0.12;
K.cmd_samples=4;
A.last_target[j]=nil;
A.forcing[j]=(A.forcing[j]or 0)+1;
T.CFrame=x;
x=Y(G(j.shoot,j,...));
T.CFrame=o;
A.last_target[j]=nil;
b=(A.forcing[j]or 1)-1;
A.forcing[j]=b>0 and b or nil;
K.weapon=nil;
K.cframe=nil;
if x[1]then
    S.mark(j);
else
    K.expires=0;
    K.cmd_samples=0;
end;
return O(x,1,x.n);
end;
A.force=function(j,b,o)if not(A.can_force(j,o))then
    return false;
end;
if not(S.ready(j))then
    return false;
end;
A.open_gate(j);
A.last_target[j]=nil;
A.forcing[j]=(A.forcing[j]or 0)+1;
local t,i,Y=tonumber(j.ShotSeq),tonumber(j.Rounds),G(j.shoot,j,O(b,1,b.n));
if o=="rapid"then A.open_gate(j);
end;
b=(A.forcing[j]or 1)-1;
A.forcing[j]=b>0 and b or nil;
A.last_target[j]=nil;
o,b=tonumber(j.ShotSeq),tonumber(j.Rounds);
local G=t and o and o>t;
G=G or(if i then
    if b then
        b<i
    else
        G
    else
        G);
        if Y then
            if G then
                S.mark(j);
                return true;
            end;
        end;
        return false;
    end;
    h.teardown(function()A.alive=false;
    A.cancel();
    K.clear();
end);
return A;
end;
D._=function()local j=D.load("b");
local h,b,K,S=D.load("q"),D.load("f"),D.load("a"),D.load("h");
local o,t=D.load("j"),D.load("Z");
local G=D.load("M");
local i=D.load("T");
local Y=h.misc;
local O=j.lp;
local T=j.workspace;
local x=j.collection;
local p=b.trim;
local b=j.getups;
local A=j.setup;
local M=os.clock;
local a=o.inventory;
local B=o.kinematics;
local N=o.remotes;
local I=o.buy_menu;
local R=o.buy_area;
local n=o.ray_ignore;
local E,d=o.defuse_ui,math.clamp;
local w=math.floor;
local P=math.deg;
local r=math.acos;
local L,L=math.abs,math.max;
local Z=RaycastParams.new();
Z.FilterType=Enum.RaycastFilterType.Exclude;
Z.IgnoreWater=true;
local X=RaycastParams.new();
X.FilterType=Enum.RaycastFilterType.Exclude;
X.IgnoreWater=true;
local q=RaycastParams.new();
q.FilterType=Enum.RaycastFilterType.Exclude;
q.IgnoreWater=true;
q.CollisionGroup="Bullet";
local U={};
local z,J,y,f,k=Vector3.new(0,-5,0),0,1,2,3;
local g={phase=J,session=0,since=0,sent=0,sent_at=0,acked=0,final=0,total=10,bomb=nil,retry=0,fails=0,spot=nil,out=false,orphan=0};
local Q,c=type(E)=="table"and rawget(E,"StartDefuse")or nil;
if type(Q)=="function"and type(b)=="function"then h,E=pcall(b,Q);
if h and type(E)=="table"then o=0;
for h,H in E,nil,nil do
    if type(H)=="number"then o+=1;
    c=h;
else
end;
end;
if o~=1 then
    c=nil;
else
end;
else
end;
else
end;
local h,o={pending={},tried={},last=0,wait_until=0,was_open=false,was_inside=false,team="",generation=-1,game_state=""},0;
if O:GetAttribute("IsLocallyDefusingBomb")==true then
    if O:GetAttribute("IsDefusingBomb")~=true then
        O:SetAttribute("IsLocallyDefusingBomb",nil);
    end;
end;
local function E()if a then
    if type(a.peekCurrentEquippedForMovement)~="function"then return nil;
end;
else
    return nil;
end;
local H,_=pcall(a.peekCurrentEquippedForMovement);
if H then
    if _ then
        if _.IsDestroyed then
            return nil;
        end;
    else
        return nil;
    end;
else
    return nil;
end;
return _;
end;
local function H()local _=O.Character;
if _ then
    if not(_:IsDescendantOf(T))then
        return nil;
    end;
else
    return nil;
end;
if _:GetAttribute("Dead")~=false then
    return nil;
end;
local s=_:GetAttribute("Health");
if typeof(s)~="number"then return nil;
elseif  s<=0 then
    return nil;
end;
return _;
end;
local function _(s)local F=s.Character;
if F then
    if not(F:IsDescendantOf(T))then
        return nil;
    end;
else
    return nil;
end;
if F:GetAttribute("Dead")~=false then
    return nil;
end;
s=F:GetAttribute("Health");
if typeof(s)~="number"then return nil;
elseif  s<=0 then
    return nil;
end;
return F;
end;
local function s(F)if F==O then
    return false;
end;
if T:GetAttribute("Gamemode")=="Deathmatch"then return true;
end;
local v,u=O:GetAttribute("Team"),F:GetAttribute("Team");
if v then
    if not(u)then
        return false;
    end;
else
    return false;
end;
if v~="Counter-Terrorists"then if v~="Terrorists"then return false;
end;
end;
if u~="Counter-Terrorists"then if u~="Terrorists"then return false;
end;
end;
return v~=u;
end;
local function F(v,u,V)local e=0;
if v then
    e=1;
    U[e]=v;
else
end;
if u then
    e+=1;
    U[e]=u;
else
end;
v=T:FindFirstChild("Debris");
if v then
    e+=1;
    U[e]=v;
else
end;
v,u=S.all();
for l=1,u,1 do
    local u=v[l].Character;
    if u then
        if u~=V then
            l=e+1;
            U[l]=u;
            e=l;
        else
        end;
    else
    end;
end;
return p(U,e);
end;
local v={plant=function()local u=E();
local V=u and u.Properties;
if V then
    if V.Class~="C4"then return;
elseif  type(u.shoot)~="function"then return;
end;
else
    return;
end;
V=H();
if V then
    if u.IsPlanting then
        return;
    end;
else
    return;
end;
if tick()-(u.PlantStartedTick or 0)<0.55 then
    return;
end;
local e=V.PrimaryPart;
if not(e)then
    return;
end;
if B then
    if type(B.isOnGround)=="function"then if not(B.isOnGround(V))then
        return;
    end;
end;
end;
Z.FilterDescendantsInstances=F(V,T.CurrentCamera);
V=T:Raycast(e.Position,z,Z);
if V then
    if not(V.Instance)then
        return;
    end;
else
    return;
end;
if V.Instance:HasTag("PlantArea")then
    if V.Instance:GetAttribute("Site")==nil then
        return;
    end;
else
    return;
end;
j.plain(u.shoot,u);
end
};
local function B()local Z=x:GetTagged("Bomb");
for x=1,#Z,1 do
    local z=Z[x];
    if z:IsDescendantOf(T)then
        if z:GetAttribute("Defused")~=true then
            if z:GetAttribute("Exploded")~=true then
                if z:GetAttribute("Exploding")~=true then
                    if z:GetAttribute("BombPlanted")~=nil then
                        return z;
                    end;
                end;
            end;
        end;
    end;
end;
return nil;
end;
local function x()local Z,z=S.all();
for u=1,z,1 do
    local z=Z[u];
    if z~=O then
        if z:GetAttribute("IsDefusingBomb")==true then
            return z;
        end;
    end;
end;
return nil;
end;
local function Z()local z=g.session;
if c then
    local u,V=pcall(b,Q);
    local b=u and type(V)=="table"and V[c]or nil;
    z=if type(b)=="number"then if b>z then
        b
    else
        z
    else
        z;
    else
    end;
    return w(z);
end;
local function b()local w=Z()%4294967295+1;
g.session=w;
if c then
    if type(A)=="function"then pcall(A,Q,c,w);
end;
end;
return w;
end;
local function A()local w=tonumber(O:GetAttribute("Ping"));
if not(w)then
    return 0.15;
end;
return d(w/1000,0,1);
end;
v.stop_defuse=function(w)local z=g.phase;
if z==J then
    if not(i.on)then
        return;
    end;
end;
g.phase=J;
g.bomb=nil;
g.final=0;
i.release();
if z~=f then
    if z~=k then
        return;
    end;
end;
if O:GetAttribute("IsLocallyDefusingBomb")~=nil then
    O:SetAttribute("IsLocallyDefusingBomb",nil);
end;
z=w and N and N.C4 and N.C4.CancelDefuse;
if z then
    pcall(z.Send,{SessionId=g.session});
end;
end;
local function w(z,Q)g.fails=g.fails+1;
g.spot=Q;
g.retry=z+(g.fails>=2 and 1.5 or 0.6);
end;
local function z(Q)local c=b();
g.phase=f;
g.sent=Q;
g.sent_at=T:GetServerTimeNow();
g.acked=0;
g.final=0;
g.total=O:GetAttribute("HasDefuseKit")==true and 5 or 10;
O:SetAttribute("IsLocallyDefusingBomb",true);
if not(pcall(N.C4.StartDefuse.Send,{SessionId=c}))then
    v.stop_defuse(false);
    g.retry=Q+0.5;
end;
end;
local function b(Q,c)g.session=Z();
g.phase=k;
g.bomb=c;
g.since=Q;
g.sent=Q;
g.sent_at=T:GetServerTimeNow()-12;
g.acked=Q;
g.final=0;
g.orphan=0;
g.total=O:GetAttribute("HasDefuseKit")==true and 5 or 10;
O:SetAttribute("IsLocallyDefusingBomb",true);
end;
v.defuse=function()local Z,Q,c=M(),N and N.C4,H();
local M,N=c and c.PrimaryPart,B();
c=N and N.PrimaryPart;
if(if Q then
    not M
else
    not Q)or not c or O:GetAttribute("Team")~="Counter-Terrorists"then v.stop_defuse(c~=nil);
    g.out=false;
    g.fails=0;
    g.spot=nil;
    return;
end;
local B=M.Position;
local u,V=(B-c.Position).Magnitude,O:GetAttribute("IsDefusingBomb")==true;
if i.broke then
    v.stop_defuse(true);
    g.out=true;
    return;
end;
if g.phase~=J then
    if g.bomb~=N then
        v.stop_defuse(true);
        return;
    end;
end;
if g.spot then
    if(B-g.spot).Magnitude>0.75 then
        g.fails=0;
        g.spot=nil;
    end;
end;
local e,l=x(),O:GetAttribute("IsLocallyDefusingBomb")==true;
if g.phase<=y then
    if V then
        if l then
            g.orphan=0;
        elseif  e then
            g.orphan=0;
        elseif  g.out then
            g.orphan=0;
        elseif  u<=10 then
            if g.orphan==0 then
                g.orphan=Z;
            elseif  Z-g.orphan>1 then
                i.release();
                b(Z,N);
            end;
        else
            g.orphan=0;
        end;
    else
        g.orphan=0;
    end;
else
    g.orphan=0;
end;
if g.phase<=y then
    if V or e or l or N:GetAttribute("IsGettingDefused")==true then
        v.stop_defuse(false);
        g.retry=L(g.retry,Z+0.5);
        return;
    end;
elseif  e then
    if not(V)then
        v.stop_defuse(true);
        g.retry=Z+0.5;
        return;
    end;
end;
if g.out then
    if u<=5.5 then
        if Z-i.input_at<0.5 then
            return;
        end;
    end;
    g.out=false;
end;
if g.phase==J then
    if u>5 then
        return;
    elseif  Z<g.retry then
        return;
    elseif  g.fails>=3 then
        return;
    end;
    g.phase=y;
    g.since=Z;
    g.bomb=N;
    i.engage(c.Position);
    if not(i.hooked)then
        z(Z);
    end;
    return;
end;
i.engage(c.Position);
if g.phase==y then
    c=i.still>=6 or i.ground and Z-g.since>0.75;
    if u>5.25 or c and u>5 then
        v.stop_defuse(false);
        return;
    end;
    if Z-g.since>2 then
        v.stop_defuse(false);
        w(Z,B);
        return;
    end;
    if c then
        if i.samples>=10 then
            z(Z);
        end;
    end;
    return;
end;
if g.phase==f then
    if not(V)then
        if Z-g.sent>1+A()*2 then
            v.stop_defuse(true);
            w(Z,B);
        end;
        return;
    end;
    g.phase=k;
    g.acked=Z;
    g.final=0;
end;
if not(V)then
    v.stop_defuse(false);
    w(Z,B);
    return;
end;
B,e,M=Z-g.acked,O:GetAttribute("DefuseStartTime"),T:GetServerTimeNow();
if(if typeof(e)=="number"then if e>=g.sent_at-1 then
    if e<=M then
        M-e
    else
        B
    else
        B
    else
        B)>=g.total+0.05 and(g.final==0 or Z-g.final>=0.5)then
            g.final=Z;
            pcall(Q.Defused.Send);
        end;
    end;
    local function b(i,x)if i then
        if not(x)then
            return false;
        end;
    else
        return false;
    end;
    local A,M=i.PrimaryPart or i:FindFirstChild("HumanoidRootPart"),x.PrimaryPart or x:FindFirstChild("HumanoidRootPart");
    if A then
        if not(M)then
            return false;
        end;
    else
        return false;
    end;
    return P(r(d(M.CFrame.LookVector:Dot((A.Position-M.Position).Unit),-1,1)))>100;
end;
local function i(x,A,M,B)local N;
if type(n)=="function"then local w,P=pcall(n);
N=if w then
    if type(P)=="table"then P
else
    N
else
    N;
else
end;
X.FilterDescendantsInstances=N or F(x,T.CurrentCamera);
local N,n=S.all();
local w,P,r;
for L=1,n,1 do
    x=N[L];
    if s(x)then
        L=_(x);
        if L then
            local x=L:FindFirstChild("Head")or L:FindFirstChild("UpperTorso")or L.PrimaryPart;
            if x then
                local N=x.Position-A;
                local n=N.Magnitude;
                if n>0.05 and n<=B and(if w then
                    n<w
                else
                    not w)then
                        local B=N.Unit*M;
                        local M=T:Raycast(A,B,X)or(T:Spherecast(A,1.5,B,X));
                        if M then
                            if M.Instance then
                                if M.Instance:IsDescendantOf(L)then
                                    w,P,r=n,L,x;
                                else
                                end;
                            else
                            end;
                        else
                        end;
                    else
                    end;
                else
                end;
            else
            end;
        else
        end;
    end;
    return P,r;
end;
v.knife=function()local x=E();
local A=x and x.Properties;
if A then
    if A.Class~="Melee"then return;
elseif  type(x.shoot)~="function"then return;
end;
else
    return;
end;
if x.IsShooting then
    return;
end;
if x.WeaponEquippedTick then
    if tick()-x.WeaponEquippedTick<=1 then
        return;
    end;
end;
local M=H();
if M then
    if not(M.PrimaryPart)then
        return;
    end;
else
    return;
end;
local B=M:FindFirstChild("Head")or M.PrimaryPart;
if not(B)then
    return;
end;
local N,n=tonumber(A.Range)or 3,d(tonumber(Y.knife_range)or 3.5,2,5);
local A,w=i(M,B.Position,N,n);
if A then
    if not(w)then
        return;
    end;
else
    return;
end;
t.toward(x,B.Position,w.Position,Y.knife_heavy and b(M,A));
end;
v.zeus=function()local b=E();
if b then
    if b.Properties then
        if b.Name~="Zeus x27"then return;
    end;
else
    return;
end;
else
    return;
end;
if b.IsShooting then
    return;
elseif  b.IsReloading then
    return;
end;
if typeof(b.Rounds)=="number"then if b.Rounds<=0 then
    return;
end;
end;
local i=H();
if i then
    if not(i.PrimaryPart)then
        return;
    end;
else
    return;
end;
local x=T.CurrentCamera;
if not(x)then
    return;
end;
local A,M,B,N=d(Y.zeus_range,5,13.5),G.origin(x),S.all();
local S,G;
for n=1,N,1 do
    local d=B[n];
    if s(d)then
        n=_(d);
        if n then
            local d=n:FindFirstChild("HumanoidRootPart");
            if d then
                local w=(d.Position-M).Magnitude;
                if w<=A then
                    if S then
                        if w<S then
                            S,G=w,n;
                        else
                        end;
                    else
                        S,G=w,n;
                    end;
                else
                end;
            else
            end;
        else
        end;
    else
    end;
end;
if not(G)then
    return;
end;
B=G:FindFirstChild("Head")or G:FindFirstChild("UpperTorso")or G.PrimaryPart;
if not B then
    return;
end;
N=B.Position-M;
local S=N.Magnitude;
if S<0.5 then
    return;
elseif  S>A then
    return;
end;
q.FilterDescendantsInstances=F(i,x,G);
i=T:Raycast(M,N,q);
if i then
    if i.Instance then
        if not(i.Instance:IsDescendantOf(G))then
            return;
        end;
    end;
end;
t.toward(b,M,B.Position);
end;
v.reload=function()local b=E();
local S=b and b.Properties;
if S then
    if S.Class~="Weapon"then return;
end;
else
    return;
end;
if b.IsReloading then
    return;
elseif  b.IsShooting then
    return;
elseif  b.IsAdjustingSuppressor then
    return;
end;
if t.forcing[b]then
    return;
elseif  t.manual[b]then
    return;
elseif  t.has_pending(b)then
    return;
end;
local G,i=tonumber(b.Rounds),tonumber(S.Rounds)or 30;
if G then
    if G>=i then
        return;
    elseif  G>=Y.auto_reload_min then
        return;
    end;
else
    return;
end;
i=tick();
if i-o<0.8 then
    return;
end;
if t.held()then
    return;
end;
o=i;
j.plain(b.reload,b);
end;
local j,b={"Pistols","Mid Tier","Rifles","Grenades"},{{"AK-47","M4A1-S","M4A4"},{"Galil AR","FAMAS"},{"SG 553","AUG"},{"MAC-10","MP9"},{"Sawed-Off","MAG-7"},{"Glock-18","USP-S","P2000"},{"Tec-9","Five-SeveN"},{"Molotov","Incendiary Grenade"}};
local function S()local o={};
if a then
    if type(a.GetEquippedInventoryItem)~="function"then return o;
end;
else
    return o;
end;
for t=1,#j,1 do
    local G=j[t];
    for j=1,8,1 do
        t=("Loadout.%s.Options.%d"):format(G,j);
        local j,G=pcall(a.GetEquippedInventoryItem,O,t);
        if j then
            if G then
                if type(G.Name)=="string"then o[G.Name]=t;
            end;
        end;
    end;
end;
end;
local j,t=pcall(a.GetEquippedInventoryItem,O,"Equipped.Equipped Zeus x27");
if j then
    if t then
        if t.Name=="Zeus x27"then o[t.Name]="Equipped.Equipped Zeus x27";
    end;
end;
end;
return o;
end;
local function j(o,t)if t[o]then
    return o,t[o];
end;
for G=1,#b,1 do
    local i=b[G];
    if table.find(i,o)then
        for o=1,#i,1 do
            G=i[o];
            if t[G]then
                return G,t[G];
            end;
        end;
        break;
    end;
end;
return nil,nil;
end;
local function o(t,G)if G[t]then
    return true;
end;
for i=1,#b,1 do
    local x=b[i];
    if table.find(x,t)then
        for b=1,#x,1 do
            if G[x[b]]then
                return true;
            end;
        end;
        break;
    end;
end;
return false;
end;
local function b()local t,G,i,x,A={},false,false,false,false;
if a then
    if type(a.getCurrentInventory)=="function"then local M,B=pcall(a.getCurrentInventory);
    if M then
        if type(B)=="table"then local M,a,N,n=true,G,x,i;
        for d,w in B,nil,nil do
            d=type(w)=="table"and w._items or nil;
            if type(d)=="table"then local B=w._settings;
            local w=type(B)=="table"and B._strict_type=="Melee";
            a=if w then
                true
            else
                a;
                for B,P in d,nil,nil do
                    if type(P)=="table"then if P.IsDestroyed~=true then
                        if type(P.Name)=="string"then t[P.Name]=(t[P.Name]or 0)+1;
                        B=true;
                        N,n=B,if w then
                            true
                        else
                            n;
                        else
                        end;
                    else
                    end;
                else
                end;
            end;
        else
        end;
    end;
    G,i,x,A=a,n,N,M;
else
end;
else
end;
else
    local M,a=true,true;
    x,A=a,M;
end;
else
    local M,a=true,true;
    x,A=a,M;
end;
local M=E();
if M then
    if type(M.Name)=="string"then if not(t[M.Name])then
        t[M.Name]=1;
    end;
end;
end;
return t,A and(G and i or(if G then
    not G
else
    x));
end;
local function t(G)table.clear(h.pending);
local i=O:GetAttribute("Team");
if i~="Terrorists"then if i~="Counter-Terrorists"then return;
end;
end;
local x,A,M=S(),{},0;
local function S(a)if a then
    if a==""then return;
elseif  a=="none"then return;
end;
else
    return;
end;
local B,N=j(a,x);
if B then
    if not(N)then
        return;
    end;
else
    return;
end;
if o(B,G)then
    return;
elseif  o(B,h.tried)then
    return;
elseif  A[B]then
    return;
end;
A[B]=true;
M+=1;
h.pending[M]={name=B,path=N,fails=0};
end;
S(Y.buy_primary);
S(Y.buy_secondary);
if Y.buy_zeus then
    S("Zeus x27");
end;
i=Y.buy_nades;
if type(i)=="table"then for j=1,#i,1 do
    S(i[j]);
end;
end;
end;
v.autobuy=function()if I then
    if type(I.purchase)~="function"then return;
elseif  not(R)then
    return;
end;
else
    return;
end;
if not(H())then
    return;
end;
local j=T:GetAttribute("Gamemode");
if j~="Bomb Defusal"then if j~="Hostage Rescue"then return;
end;
end;
j=O:GetAttribute("Team")or"";
if j~="Terrorists"then if j~="Counter-Terrorists"then return;
end;
end;
local S=T:GetAttribute("GameState")or"";
local G,i,T=O:GetAttribute("BuyMenu")==true or S=="Buy Period",pcall(R,O);
local x,A,M=if i then
    T==true
else
    false,tonumber(O:GetAttribute("CharacterGeneration"))or-1,tick();
    if S~=h.game_state then
        if S=="Buy Period"then table.clear(h.tried);
        Y.buy_dirty=true;
        h.wait_until=0;
    end;
    h.game_state=S;
end;
if G then
    if not(h.was_open)then
        Y.buy_dirty=true;
    end;
end;
if x then
    if not(h.was_inside)then
        Y.buy_dirty=true;
    end;
end;
if j~=h.team or A~=h.generation then
    table.clear(h.tried);
    Y.buy_dirty=true;
    h.wait_until=0;
end;
h.was_open=G;
h.was_inside=x;
h.team=j;
h.generation=A;
if G then
    if not(x)then
        return;
    end;
else
    return;
end;
T,j=b();
if j then
    if h.wait_until>0 then
        h.wait_until=0;
        Y.buy_dirty=true;
    end;
else
    if h.wait_until<=0 then
        h.wait_until=M+2;
    end;
    if M<h.wait_until then
        Y.buy_dirty=true;
        return;
    end;
end;
if Y.buy_dirty then
    Y.buy_dirty=false;
    t(T);
end;
j=h.pending[1];
while j and(o(j.name,T)or o(j.name,h.tried))do
    table.remove(h.pending,1);
    j=h.pending[1];
end;
if j then
    if M-h.last<0.38 then
        return;
    end;
else
    return;
end;
h.last=M;
if pcall(I.purchase,j.name,j.path,false)then
    h.tried[j.name]=true;
    table.remove(h.pending,1);
else
    j.fails=j.fails+1;
    if j.fails>=3 then
        table.remove(h.pending,1);
    end;
end;
end;
v.step=function()if Y.auto_plant then
    pcall(v.plant);
end;
if Y.auto_defuse then
    pcall(v.defuse);
else
    v.stop_defuse(true);
end;
if Y.knife then
    pcall(v.knife);
end;
if Y.zeus then
    pcall(v.zeus);
end;
if Y.auto_reload then
    pcall(v.reload);
end;
if Y.auto_buy then
    pcall(v.autobuy);
end;
end;
K.connect(O.CharacterAdded,function()v.stop_defuse(true);
g.retry=0;
g.fails=0;
g.spot=nil;
g.out=false;
end);
K.teardown(function()v.stop_defuse(true);
table.clear(h.pending);
table.clear(h.tried);
p(U,0);
end);
return v;
end;
D.aa=function()local j=D.load("b");
local h,b=D.load("q"),D.load("f");
local K=D.load("a");
local S=h.notify;
local o=h.world;
local t=j.workspace;
local G=j.guiservice;
local i=math.clamp;
local Y=math.max;
local O,O=math.floor,{};
m:rH(O,0,Vector2.new(0.70710678,-0.70710678),Vector2.new(-0.70710678,-0.70710678),Vector2.new(-0.70710678,0.70710678),Vector2.new(0.70710678,0.70710678));
local m,T={-45,45,-45,45};
local function x()if T then
    if T.Parent then
        local p=T;
        return p;
    end;
end;
T=j.screen(1000);
if T then
    K.own(T);
end;
local p=T;
return p;
end;
local function p(A)local M=Instance.new("Frame");
M.AnchorPoint=Vector2.new(0.5,0.5);
M.BackgroundColor3=Color3.new(1,1,1);
M.BackgroundTransparency=0;
M.BorderSizePixel=0;
M.Visible=false;
M.ZIndex=10;
local a=Instance.new("UICorner");
a.CornerRadius=UDim.new(1,0);
a.Parent=M;
a=Instance.new("UIStroke");
a.Thickness=1.25;
a.Color=Color3.new();
a.Transparency=0;
a.ApplyStrokeMode=Enum.ApplyStrokeMode.Border;
a.LineJoinMode=Enum.LineJoinMode.Round;
a.Parent=M;
M.Parent=A;
return{frame=M,stroke=a};
end;
local function A()local M=x();
if not(M)then
    return nil;
end;
local a={};
for B=1,4,1 do
    a[B]=p(M);
end;
return a;
end;
local function p(M)if not(M)then
    return;
end;
for a=1,4,1 do
    M[a].frame.Visible=false;
end;
end;
local M,a={},{};
local function B()local N=table.remove(M);
if N then
    local I=x();
    if I then
        for R=1,4,1 do
            if N[R].frame.Parent~=I then
                N[R].frame.Parent=I;
            end;
        end;
    end;
    return N;
end;
return A();
end;
local function A(N)if not(N.arms)then
    return;
end;
p(N.arms);
M[#M+1]=N.arms;
N.arms=nil;
end;
local N={Camera=nil};
N.CFrame=CFrame.new();
N.ViewportSize=Vector2.zero;
N.FieldOfView=70;
N.Override=false;
local function I()local R=o.view;
if type(R)=="table"then if type(R.Resolve)=="function"then local n,E=pcall(R.Resolve);
if n then
    if type(E)=="table"then if typeof(E.CFrame)=="CFrame"then if typeof(E.ViewportSize)=="Vector2"then return E;
end;
end;
end;
end;
end;
end;
R=t.CurrentCamera;
if not R then
    return nil;
end;
N.Camera=R;
N.CFrame=R.CFrame;
N.ViewportSize=R.ViewportSize;
N.FieldOfView=R.FieldOfView;
return N;
end;
local function t(N,R)local n=o.view;
if type(n)=="table"then if type(n.Project)=="function"then local o,E,d,w=pcall(n.Project,R,N);
if o then
    return E,d,w;
end;
end;
end;
n=N and N.Camera;
if not n then
    return nil,false,-math.huge;
end;
local o,N=n:WorldToViewportPoint(R);
return Vector2.new(o.X,o.Y),N,o.Z;
end;
local function o(N,R,n)if not(n)then
    return false;
end;
for E=1,#n,1 do
    local d=n[E];
    if typeof(d)=="Instance"then if d.Parent then
        if d.Visible then
            local n,E=d.AbsolutePosition+R,d.AbsoluteSize;
            if N.X>=n.X then
                if N.X<=n.X+E.X then
                    if N.Y>=n.Y then
                        if N.Y<=n.Y+E.Y then
                            return true;
                        end;
                    end;
                end;
            end;
        end;
    end;
end;
end;
return false;
end;
local function N(R,n,E,d,w,P,r)local L=R.frame;
L.Position=UDim2.fromOffset(n.X,n.Y);
L.Size=UDim2.fromOffset(d,w);
L.Rotation=E;
L.BackgroundColor3=P;
L.BackgroundTransparency=1-r;
L.Visible=r>0.001;
R.stroke.Thickness=Y(1,w*0.22);
R.stroke.Transparency=1-r;
end;
local function R(n,E,d)local w=x();
if not(w)then
    return;
end;
local x=i(tonumber(n.size)or 14,4,24);
local P,r,L,Z=x*0.95,Y(2,x*0.32),Y(2,x*0.22),n.arms;
for Y=1,4,1 do
    x=Z[Y];
    if x.frame.Parent~=w then
        x.frame.Parent=w;
    end;
    N(x,E+O[Y]*(L+P*0.5),m[Y],P,r,n.col,d);
end;
end;
h={emit=function(m,Y)local O=S.marks[m];
if O then
    if S.master[m]then
        if not(O.on)then
            return;
        end;
    else
        return;
    end;
else
    return;
end;
Y=if typeof(Y)=="CFrame"then Y.Position
else
    Y;
    if typeof(Y)~="Vector3"then return;
end;
local S=os.clock();
if m=="kill"then for x=#a,1,-1 do
    local N=a[x];
    if N.channel=="hit"then if S-N.born<=2.5 then
        if(N.position-Y).Magnitude<=0.25 then
            A(N);
            b.drop(a,x);
        end;
    end;
end;
end;
end;
local x=B();
if not(x)then
    return;
end;
if#a>=200 then
    local B=table.remove(a,1);
    if B then
        A(B);
    end;
end;
a[#a+1]={arms=x,channel=m,position=Y,col=typeof(O.col)=="Color3"and O.col or Color3.new(1,1,1),size=i(tonumber(O.size)or 14,4,24),duration=i(tonumber(O.fade)or 1,0.1,5),born=S};
end,step=function()local m=#a;
if m==0 then
    return;
end;
local S=I();
if not(S)then
    for Y=m,1,-1 do
        p(a[Y].arms);
    end;
    return;
end;
local Y=j.drawmask();
local j,O=Y and G:GetGuiInset()or Vector2.zero,os.clock();
for G=m,1,-1 do
    local m=a[G];
    local x=(O-m.born)/m.duration;
    if x>=1 then
        A(m);
        b.drop(a,G);
    else
        local G,O,A=t(S,m.position);
        if typeof(G)=="Vector2"then if O then
            if type(A)=="number"then if A>0.05 then
                if o(G,j,Y)then
                    p(m.arms);
                else
                    local j=i(x,0,1);
                    R(m,G,1-j*j*(3-2*j));
                end;
            else
                p(m.arms);
            end;
        else
            p(m.arms);
        end;
    else
        p(m.arms);
    end;
else
    p(m.arms);
end;
end;
end;
end,unload=function()for m=#a,1,-1 do
    p(a[m].arms);
    a[m]=nil;
end;
b.trim(M,0);
if T then
    pcall(T.Destroy,T);
    T=nil;
end;
end
};
K.teardown(h.unload);
return h;
end;
D.ab=function()local m,j,h=D.load("b"),D.load("q"),D.load("a");
local b=j.notify;
local K=m.workspace;
local S=Color3.fromRGB(133,220,255);
local function o(t)local G=Instance.new("ParticleEmitter");
G.Acceleration=Vector3.new(0,-50,0);
G.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.new(1,0.999969,0.999985)),ColorSequenceKeypoint.new(0.25,Color3.new(0.333333,1,0)),ColorSequenceKeypoint.new(1,Color3.new(0.333333,1,0.498039))});
G.Lifetime=NumberRange.new(0.5,1);
G.LightEmission=1;
G.Enabled=false;
G.Orientation=Enum.ParticleOrientation.VelocityParallel;
G.Rate=0;
G.Size=NumberSequence.new({NumberSequenceKeypoint.new(0,0.6,0),NumberSequenceKeypoint.new(0.5,0.6,0),NumberSequenceKeypoint.new(1,0,0)});
G.Speed=NumberRange.new(15,15);
G.SpreadAngle=Vector2.new(50,-50);
G.Texture="http://www.roblox.com/asset/?id=18540695516";
G.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0,0),NumberSequenceKeypoint.new(0.5,0,0),NumberSequenceKeypoint.new(1,1,0)});
G.Parent=t;
return G;
end;
local function t()local G=Instance.new("Part");
G.Anchored=true;
G.CanCollide=false;
G.CanQuery=false;
G.CanTouch=false;
G.Massless=true;
G.CastShadow=false;
G.Transparency=1;
G.Size=Vector3.new(0.01,0.01,0.01);
G.CFrame=CFrame.new(0,-10000,0);
local i={part=G,emitter=o(G),col=nil,count=30};
G.Parent=K;
h.own(G);
return i;
end;
local o={};
j,m=pcall(t);
if j then
    o.hit=m;
end;
m,j=pcall(t);
if m then
    o.kill=j;
end;
t={emit=function(m,j)local G,i=b.fx[m],o[m];
if G then
    if b.master[m]then
        if G.on then
            if not(i)then
                return;
            end;
        else
            return;
        end;
    else
        return;
    end;
else
    return;
end;
m=nil;
if typeof(j)=="CFrame"then m=j;
else
    if typeof(j)=="Vector3"then m=CFrame.new(j);
else
    return;
end;
end;
if not(i.part.Parent)then
    i.part.Parent=K;
end;
i.part.CFrame=m;
m=typeof(G.col)=="Color3"and G.col or S;
if i.col~=m then
    i.col=m;
    i.emitter.Color=ColorSequence.new(m);
end;
i.emitter:Emit(i.count);
end,unload=function()for m,j in o,nil,nil do
    o[m]=nil;
    if j.part then
        pcall(j.part.Destroy,j.part);
    end;
end;
end
};
h.teardown(t.unload);
return t;
end;
D.ac=function()local m=D.load("b");
local j,h=D.load("q"),D.load("a");
local b,K=D.load("O"),j.notify;
local S=os.clock;
local o=math.min;
local t=math.max;
local G=math.abs;
local i=math.sqrt;
local Y=math.exp;
local O=math.clamp;
local T=Rect.new(64,64,66,66);
local x=Y(-4);
local function p(A,M)local a,B=t(A*130*0.5-1,0),t(G(M*2-1)*130*0.5-1,0);
return(Y(-4*(1-O((i(a*a+B*B)-24)/40,0,1))^2)-x)/(1-x);
end;
local G;
local i,Y,O=h.shared,m.custom_asset,false;
if type(isfile)=="function"then local x,A=pcall(isfile,"bs_health_shot.png");
O=x and A==true;
else
end;
local x;
if type(i.edge_uri)=="string"and O then
    G=i.edge_uri;
    x=G;
else
    if type(writefile)=="function"then if type(Y)=="function"then if buffer then
        j=b.mask(130,130,p);
        if j then
            if pcall(writefile,"bs_health_shot.png",j)then
                local j,b=pcall(Y,"bs_health_shot.png");
                if j then
                    if type(b)=="string"then if#b>0 then
                        i.edge_uri=b;
                        G=b;
                    else
                    end;
                else
                end;
            else
            end;
        else
        end;
    else
    end;
else
end;
else
end;
else
end;
x=G;
end;
if x then
    h.spawn(function()local j=Instance.new("ImageLabel");
    j.Image=x;
    pcall(m.content.PreloadAsync,m.content,{j});
    j:Destroy();
end);
end;
local j,b;
local G,i,O=false,0;
local p=1;
local A,M,a=-1,0,0;
local function B()if j then
    if j.Parent then
        return true;
    end;
end;
if not(x)then
    return false;
end;
j=m.screen(1000);
if not(j)then
    return false;
end;
h.own(j);
b=Instance.new("ImageLabel");
b.BackgroundTransparency=1;
local m=b;
m.Size=UDim2.fromScale(1,1);
b.Image=x;
m=b;
m.ImageColor3=O or K.fx.hit.col;
b.ImageTransparency=1;
m=b;
m.ScaleType=Enum.ScaleType.Slice;
b.SliceCenter=T;
b.Parent=j;
A=1;
return true;
end;
local function m(T)if A~=T then
    if b then
        A=T;
        b.ImageTransparency=T;
    end;
end;
end;
local function T(x)return x*x*(3-2*x);
end;
local function x(N)if N<0.18 then
    local I,R=M,(1-M)*T(N/0.18);
    return I+R;
end;
return 1-T((N-0.18)/0.95);
end;
Y={emit=function(T)local N=K.screen[T];
if N then
    if K.master[T]then
        if not(N.on)then
            return;
        end;
    else
        return;
    end;
else
    return;
end;
if not(B())then
    return;
end;
local T,B=j.AbsoluteSize,b;
B.SliceScale=t(o(T.X,T.Y),180)/180;
B=typeof(N.col)=="Color3"and N.col or K.fx.hit.col;
if O~=B then
    O=B;
    b.ImageColor3=B;
end;
B=G and a or 0;
p=t((tonumber(N.power)or 100)/100,B);
M=p>0 and o(B/p,1)or 0;
i,G=S(),true;
end,step=function()if not(G)then
    return;
end;
local K=S()-i;
if K>=1.13 then
    G,a=false,0;
    m(1);
    return;
end;
a=x(K)*p;
m(1-o(a,3.3333333333333335)*0.3);
end,unload=function()G,a,b,O,A=false,0,nil,nil,-1;
if j then
    pcall(j.Destroy,j);
    j=nil;
end;
end
};
h.teardown(Y.unload);
return Y;
end;
D.ad=function()local m=bit32.bxor;
local j=bit32.lrotate;
local h=bit32.lshift;
local b=bit32.rshift;
local K=bit32.band;
local S=string.byte;
local o=string.char;
local t=string.sub;
local G=table.concat;
local i=table.create;
local Y,O,T,x=math.floor,{91,39,228,145,12,189,122,54,241,72,146,174,99,213,31,140,42,116,176,89,238,19,199,109,159,53,136,76,161,112,219,38},{{2654435769,2246822507},{608135816,3266489909},{3084996962,668265263},{2246822507,374761393}};
local function p(A)if not(x)then
    x={};
    for M=1,64,1 do
        local a=x;
        a[S("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/",M)]=M-1;
    end;
end;
local M,a,B,N,I={},#A,0,0,0;
for R=1,a,1 do
    local a=S(A,R);
    R=x[a];
    if R then
        B=B*64+R;
        N+=6;
        if N>=8 then
            N-=8;
            local x=2^N;
            local A=Y(B/x);
            B-=A*x;
            I+=1;
            M[I]=o(A%256);
        else
        end;
    else
        if a~=61 then
            if a~=10 then
                if a~=13 then
                    if a~=32 then
                        if a~=9 then
                            return nil;
                        end;
                    end;
                end;
            end;
        end;
    end;
end;
return G(M);
end;
local function Y(x,A,M)local a=A;
for A=1,#x,1 do
    a=(m(j(m(a,x[A]),7),M));
end;
return a;
end;
local function x(A)local M=#O;
local a=i(M+#A);
for i=1,M,1 do
    a[i]=O[i];
end;
for i=1,#A,1 do
    a[M+i]=S(A,i);
end;
local i=Y(a,T[1][1],T[1][2]);
local O=Y(a,T[2][1],T[2][2]);
local A=Y(a,T[3][1],T[3][2]);
local M=Y(a,T[4][1],T[4][2]);
local Y,T,a,B;
if i==0 and O==0 and A==0 and M==0 then
    i,O,A,M=2654435769,608135816,3084996962,2246822507;
    Y,T,a,B=i,O,A,M;
else
    Y,T,a,B=i,O,A,M;
end;
local function i()local O=m(Y,h(Y,11));
O,Y,T,a=m(O,b(O,8)),T,a,B;
local h=m(m(B,b(B,19)),O);
B=h;
return h;
end;
return i;
end;
local function h(i,Y)local O,T=x(i),#Y;
if buffer and buffer.fromstring then
    local x,A=buffer.fromstring(Y),0;
    while A+4<=T do
        buffer.writeu32(x,A,m(buffer.readu32(x,A),O()));
        A+=4;
    end;
    if A<T then
        local M,a=O(),0;
        while A+a<T do
            buffer.writeu8(x,A+a,m(buffer.readu8(x,A+a),K(b(M,a*8),255)));
            a+=1;
        end;
    end;
    return buffer.tostring(x);
end;
local x,A,M={},1,0;
while A<=T do
    i=O();
    for O=0,3,1 do
        if A+O<=T then
            M+=1;
            x[M]=o(m(S(Y,A+O),K(b(i,O*8),255)));
        else
        end;
    end;
    A=A+4;
end;
return G(x);
end;
local function b(K)local o,G,i=#K,1,608135816;
while G+7<=o do
    local Y,O,T,x,A,M,a,B=S(K,G,G+7);
    i=m(j(m(m(j(m(m(j(m(m(j(m(m(j(m(m(j(m(m(j(m(m(j(m(i,Y),7),2654435769),O),7),2654435769),T),7),2654435769),x),7),2654435769),A),7),2654435769),M),7),2654435769),a),7),2654435769),B),7),2654435769);
    G=G+8;
end;
while G<=o do
    i=m(j(m(i,S(K,G)),7),2654435769);
    G=G+1;
end;
return i;
end;
return{decode=function(m)if type(m)~="string"then return nil;
elseif #m<11 then
    return nil;
end;
local j;
if S(m,1)~=83 then
    j=p(m);
    if type(j)~="string"then return nil;
elseif #j<11 then
    return nil;
end;
else
    j=m;
end;
if S(j,1)~=83 then
    return nil;
end;
m=S(j,2);
if m~=1 then
    if m~=2 then
        return nil;
    end;
end;
local K,o,G,i=S(j,7,10);
m=h(t(j,3,6),t(j,11));
if b(m)~=i*16777216+G*65536+o*256+K then
    return nil;
end;
return m;
end
};
end;
D.ae=function()local m,j,h=D.load("b"),D.load("q"),D.load("a");
local b=D.load("c");
local K=D.load("ad");
local S=j.notify;
local o=m.sounds;
local t=m.content;
local G=m.http;
local i=m.custom_asset;
local Y=string.format;
local O=string.match;
local T=string.gsub;
local x,p,A,M,a,B,N,I,R,n,E,d,w,P,r=math.random,{primordial=true,neverlose=true,sparkle=true,["mc bow"]=true,skeet=true,["break"]=true,rust=true},{hentai="hentai1"},{"shitaroebet/","assets/","khen_juju/assets/","khen_juju/custom/","sounds/","","shitaro_sounds/"},{".ogg",".mp3",".wav",""},{},{},{},{},{hit=0,kill=0},{},{};
local L,Z,X=false,false,true;
local function q(U)if type(U)~="string"then return nil;
elseif  U==""then return nil;
end;
local z,J=pcall(G.JSONDecode,G,U);
if z then
    if type(J)=="table"then if type(J.f)=="table"then return J;
end;
end;
end;
return nil;
end;
local function G()if P then
    local U=P;
    return U;
end;
local U=K.decode(b.asset("b53227f0da.png"));
if type(U)~="string"then return nil;
elseif  U==""then return nil;
end;
local z,J,y={},{},0;
for f in U:gmatch("([^\10]+)")do
    local U,k,g,Q=O(f,"^(.-)\9(.-)\9(%d+)\9(%a+)$");
    f=tonumber(g);
    if U then
        if U~=""then if k then
            if k~=""then if f then
                if f>0 then
                    z[U]={srv=k,size=f,kind=Q};
                    if Q~="data"then g=y+1;
                    J[g]=U;
                    y=g;
                else
                end;
            else
            end;
        else
        end;
    else
    end;
else
end;
else
end;
else
end;
end;
if not(next(z))then
    return nil;
end;
table.sort(J);
P,r=z,J;
return z;
end;
local function U()local z=G();
if z then
    local J,y={},#r;
    for f=1,y,1 do
        local y=r[f];
        J[f]={n=y,s=z[y].size};
    end;
    return J;
end;
if w then
    z=w;
    return z.f;
end;
w=q(b.asset("index"));
z=w and w.f or{};
return z;
end;
local function q(z)local J=G();
if J then
    local y=J[z];
    return y and y.size or nil;
end;
J=w and w.f or U();
for y=1,#J,1 do
    local f=J[y];
    if type(f)=="table"then if f.n==z then
        return f.s;
    end;
end;
end;
return nil;
end;
local function z(J)local y=Instance.new("Sound");
y.SoundId=J;
local J;
local function f(k,k)J=k;
end;
pcall(t.PreloadAsync,t,{y},f);
pcall(y.Destroy,y);
f=J==Enum.AssetFetchStatus.Success;
return f;
end;
local function J(y)if type(delfile)~="function"then return false;
end;
return pcall(delfile,y)==true;
end;
local function y(f,k,g)if type(i)~="function"then return nil;
elseif  type(writefile)~="function"then return nil;
end;
local Q=O(f,"(%.%w+)$")or".ogg";
f=Y("%s_%08x%08x%s",g,x(0,268435455),x(0,268435455),Q);
if not(pcall(writefile,f,k))then
    return nil;
end;
Q,g=pcall(i,f);
if Q then
    if type(g)~="string"then J(f);
    return nil;
elseif  g==""then J(f);
return nil;
end;
else
    J(f);
    return nil;
end;
z(g);
if L then
else
    if Z then
    else
        L=true;
        if J(f)then
            if z(g)then
                return g;
            end;
            Z=true;
            if not(pcall(writefile,f,k))then
                return nil;
            end;
            local Y,x=pcall(i,f);
            if Y then
                if type(x)~="string"then return nil;
            elseif  x==""then return nil;
        end;
    else
        return nil;
    end;
    z(x);
    g=x;
else
    Z=true;
end;
end;
end;
if Z then
    d[#d+1]=f;
elseif  not(J(f))then
    d[#d+1]=f;
end;
return g;
end;
local function Y(x)local L=E[x];
if L then
    return L;
end;
L=G();
local G=L and L[x];
L=b.asset(G and G.srv or x);
if type(L)~="string"then return nil;
elseif  L==""then return nil;
end;
if G then
    L=K.decode(L);
    if type(L)~="string"then return nil;
elseif #L~=G.size then
    return nil;
end;
else
    local b=q(x);
    if type(b)=="number"then if b>0 then
        if#L~=b then
            return nil;
        end;
    end;
end;
end;
G=y(x,L,"shv");
if G then
    E[x]=G;
end;
return G;
end;
local function b(K)if type(isfile)~="function"then return false;
end;
local G,x=pcall(isfile,K);
return G and x==true;
end;
local function K(G)if b(G)then
    if type(readfile)~="function"then return nil;
end;
else
    return nil;
end;
local x,L=pcall(readfile,G);
if x then
    if type(L)~="string"then return nil;
elseif  L==""then return nil;
end;
else
    return nil;
end;
return y(G,L,"shitaro_snd");
end;
local function G(x)local L=A[x]or x;
for Z=1,#M,1 do
    for q=1,#a,1 do
        x=K(M[Z]..L..a[q]);
        if x then
            return x;
        end;
    end;
end;
return nil;
end;
local function K(x)local M,a=A[x]or x,U();
for A=1,#a,1 do
    x=a[A];
    A=type(x)=="table"and x.n;
    if type(A)=="string"then local x,a=O(A,"^([^/]+)(%.[^%.]+)$");
    if x==M then
        if a==".mp3"then local x=Y(A);
        if x then
            return x;
        end;
    elseif  a==".wav"then local x=Y(A);
    if x then
        return x;
    end;
elseif  a==".ogg"then local x=Y(A);
if x then
    return x;
end;
end;
end;
end;
end;
return nil;
end;
local function Y(x)if N[x]~=nil then
    return N[x];
end;
if not(p[x])then
    N[x]=false;
    return false;
end;
local p="shitaro_sounds/"..x..".ogg";
if b(p)then
    N[x]=true;
    return true;
end;
if type(isfolder)~="function"then N[x]=false;
return false;
elseif  type(makefolder)~="function"then N[x]=false;
return false;
end;
if not(pcall(function()if not(isfolder("shitaro_sounds/"))then
    makefolder("shitaro_sounds/");
end;
end))then
    N[x]=false;
    return false;
end;
local b="https://github.com/khenn791/lmao/raw/refs/heads/main/"..T(x," ","%%20")..".ogg";
local A,M=pcall(game.HttpGet,game,b);
if A then
    if type(M)~="string"then return false;
elseif #M<256 then
    return false;
elseif  type(writefile)~="function"then return false;
end;
else
    return false;
end;
if pcall(writefile,p,M)then
    N[x]=true;
    return true;
end;
return false;
end;
local function b(x)local p=B[x];
if p then
    return p;
end;
if type(writefile)~="function"then return nil;
elseif  type(i)~="function"then return nil;
end;
p=G(x)or K(x);
p=p or(if Y(x)then
    (G(x))
else
    p);
    if p then
        B[x]=p;
    end;
    return p;
end;
local function K(G)R[G]=nil;
if G then
    pcall(G.Destroy,G);
end;
end;
local function G(i)if not(X)then
    return nil;
end;
local Y=S.sounds[i];
if not(Y)then
    return nil;
end;
local x=b(Y.name);
if not(x)then
    local b=I[i];
    I[i]=nil;
    if b then
        pcall(b.Destroy,b);
    end;
    return nil;
end;
local b=I[i];
if b then
    if b.Parent then
        if b.SoundId==x then
            b.Volume=Y.vol;
            return b;
        end;
    end;
end;
if b then
    pcall(b.Destroy,b);
end;
local b=Instance.new("Sound");
b.SoundId=x;
b.Volume=Y.vol;
b.Looped=false;
b.Parent=o;
I[i]=b;
h.spawn(function()if X then
    if b.Parent then
        pcall(t.PreloadAsync,t,{b});
    end;
end;
end);
return b;
end;
local function b(t,i)if X then
    if t then
        if not(t.Parent)then
            return;
        end;
    else
        return;
    end;
else
    return;
end;
local Y=t:Clone();
Y.Volume=i;
Y.Looped=false;
Y.PlayOnRemove=false;
Y.TimePosition=0;
Y.Parent=o;
R[Y]=true;
local function o()if not(R[Y])then
    return;
end;
R[Y]=nil;
pcall(Y.Destroy,Y);
end;
Y.Ended:Once(o);
task.delay(5,o);
Y:Play();
end;
local o={prepare=function(t,i)if not(X)then
    return;
end;
local Y=S.sounds[t];
if not(Y)then
    return;
end;
local x=G(t);
if i then
    if x then
        b(x,Y.vol);
    end;
end;
end,play=function(t)if not(X)then
    return;
end;
local i=S.sounds[t];
if not i or not S.master[t]then
    return;
elseif  not(i.on)then
    return;
end;
local S=os.clock();
if S-(n[t]or 0)<0.05 then
    return;
end;
local Y=I[t];
if not(Y)then
    h.spawn(function()local x=G(t);
    if x then
        if X then
            n[t]=os.clock();
            b(x,i.vol);
        end;
    end;
end);
return;
end;
n[t]=S;
b(Y,i.vol);
end,unload=function()X=false;
for b,S in I,nil,nil do
    I[b]=nil;
    pcall(S.Destroy,S);
end;
for b in R,nil,nil do
    K(b);
end;
for b=#d,1,-1 do
    J(d[b]);
    d[b]=nil;
end;
table.clear(B);
table.clear(N);
table.clear(E);
P,r,w=nil,nil,nil;
end
};
h.teardown(o.unload);
if type(listfiles)=="function"and type(delfile)=="function"then j,m=pcall(listfiles,"");
if j and type(m)=="table"then for j=1,#m,1 do
    local b=tostring(m[j]);
    j=O(T(b,"\\","/"),"([^/]+)$");
    if j then
        if O(j,"^shitaro_snd_%x+")then
            pcall(delfile,b);
        elseif  O(j,"^shv_%x+")then
            pcall(delfile,b);
        end;
    end;
end;
end;
end;
h.spawn(function()o.prepare("hit",false);
o.prepare("kill",false);
end);
return o;
end;
D.af=function()local m=D.load("b");
local j,h=D.load("q"),D.load("a");
local b=D.load("h");
local K=D.load("g");
local S,o,t=D.load("j"),D.load("e"),D.load("ab");
local G=D.load("ac");
local i=D.load("aa");
local Y=D.load("ae");
local O=j.notify;
local j=m.lp;
local T=m.workspace;
local x=m.players;
local p=S.char_resolver;
local A=S.remotes;
local M=S.inventory;
local a=S.weapon_props;
local S=o.lib;
local o=string.format;
local B=string.lower;
local N=math.floor;
local I=math.max;
local R,n,E,d,w,P,r,L,Z,X=math.clamp,{Head="head",UpperTorso="chest",Torso="chest",LowerTorso="stomach",LeftUpperArm="left arm",LeftLowerArm="left arm",LeftHand="left arm",RightUpperArm="right arm",RightLowerArm="right arm",RightHand="right arm",LeftUpperLeg="left leg",LeftLowerLeg="left leg",LeftFoot="left leg",RightUpperLeg="right leg",RightLowerLeg="right leg",RightFoot="right leg"},{},{},true,true,false,false;
local function q(U)if not(U)then
    return"body";
end;
return n[U]or B(tostring(U));
end;
local function B(n,U,z)pcall(S.notify,S,n,U,z);
end;
local function S(n)if n then
    if typeof(n)~="Instance"then return nil,nil;
end;
else
    return nil,nil;
end;
local U=n;
while U and not U:IsA("Model")do
    U=U.Parent;
end;
if not(U)then
    return nil,nil;
end;
local z=x:GetPlayerFromCharacter(U);
z=z or(if p then
    if type(p.getPlayerFromCharacter)=="function"then p.getPlayerFromCharacter(U)
else
    z
else
    z);
    if z then
    else
        local J,y=b.all();
        for b=1,y,1 do
            if J[b].Character==U or J[b].Name==U.Name then
                z=J[b];
                break;
            end;
        end;
    end;
    return z,n;
end;
local function b(n)local U=n and n.Character;
if not(U)then
    return nil;
end;
n=U:FindFirstChild("HumanoidRootPart")or U.PrimaryPart or U:FindFirstChild("Head");
if n then
    if n:IsA("BasePart")then
        return n.Position;
    end;
end;
local n,z=pcall(U.GetPivot,U);
if n then
    if typeof(z)=="CFrame"then return z.Position;
end;
end;
return nil;
end;
local function n(U)if T:GetAttribute("Gamemode")=="Deathmatch"then return true;
end;
if T:GetAttribute("VIPFriendlyFireEnabled")==true then
    return true;
end;
local T,z=j:GetAttribute("Team"),U:GetAttribute("Team");
if T~=nil then
    if z~=nil then
        if T==z then
            return false;
        end;
    end;
end;
return true;
end;
local T={};
local function U(z,J,y,f)if y<=0 then
    return;
end;
B(o("hit {%s} in the {%s} for {%d} damage (%d health left)",z.DisplayName or z.Name,q(J),N(y+0.5),I(0,N(f+0.5))),nil,3);
end;
T.from_packet=function()end;
local function q(z)if z=="Head"then return"Head";
elseif  z=="UpperTorso"then return"Torso";
elseif  z=="LowerTorso"then return"Torso";
elseif  z=="Torso"then return"Torso";
elseif  z=="HumanoidRootPart"then return"Torso";
elseif  z=="LeftUpperArm"then return"Arms";
elseif  z=="LeftLowerArm"then return"Arms";
elseif  z=="LeftHand"then return"Arms";
elseif  z=="RightUpperArm"then return"Arms";
elseif  z=="RightLowerArm"then return"Arms";
elseif  z=="RightHand"then return"Arms";
else
    return"Legs";
end;
end;
local function z(J)local y=tonumber(J.VictimUserId);
if y then
    local f,k=x:GetPlayerByUserId(y)or K.key(y),type(J.HitPartName)=="string"and J.HitPartName or nil;
    local y=f and f.Character;
    return f,k and y and y:FindFirstChild(k)or nil,k;
end;
local y,f=S(J.Instance);
return y,f,f and f.Name or nil;
end;
local function S(J)if w then
    if type(J)~="table"then return;
elseif  J.Exit==true then
    return;
end;
else
    return;
end;
local y,f=O.master.hit,O.master.kill;
local k,g,Q,c,H,_,s=y and O.log.hit,y and O.fx.hit.on,y and O.screen.hit.on,y and O.marks.hit.on,y and O.sounds.hit.on,f and O.fx.kill.on,f and O.marks.kill.on;
if k then
elseif  g then
elseif  Q then
elseif  c then
elseif  H then
elseif  _ then
elseif  s then
else
    return;
end;
if tonumber(J.AttackerUserId)~=j.UserId then
    return;
end;
local F,v,u=z(J);
m.reclaim();
if F then
    if F==j then
        return;
    end;
else
    return;
end;
if not(n(F))then
    return;
end;
f=if typeof(J.Position)=="Vector3"then J.Position
else
    if v then
        if v:IsA("BasePart")then
            v.Position
        else
            nil
        else
            nil;
            if H then
                Y.play("hit");
            end;
            if _ or s then
                if f then
                    H,y=F.UserId,{position=f};
                    y.time,E[H]=os.clock(),y;
                end;
            end;
            if Q then
                G.emit("hit");
            end;
            if g then
                if f then
                    t.emit("hit",f);
                end;
            end;
            if c then
                if f then
                    i.emit("hit",f);
                end;
            end;
            if not(k)then
                return;
            end;
            Q,k=F.Character or v and v:FindFirstAncestorOfClass("Model"),M and type(M.peekCurrentEquippedForMovement)=="function"and M.peekCurrentEquippedForMovement();
            g=k and k.Properties;
            g=g or(if k then
                if k.Name then
                    if a then
                        a(k.Name)
                    else
                        g
                    else
                        g
                    else
                        g);
                        c,v=q(u),g and g.DamagePerPart;
                        _,H=type(v)=="table"and tonumber(v[c])or 25,j.Character;
                        k=H and(H.PrimaryPart or H:FindFirstChild("HumanoidRootPart")or H:FindFirstChild("Head"));
                        y=k and k.Position;
                        if y then
                            if f then
                                if g then
                                    if g.RangeModifier then
                                        v=(y-f).Magnitude;
                                        _*=(tonumber(g.RangeModifier)or 1)^I(0,v/100);
                                    else
                                    end;
                                else
                                end;
                            else
                            end;
                        else
                        end;
                        _=if J.IsWallbang then
                            if g then
                                if g.WallbangMultiplier then
                                    _*(tonumber(g.WallbangMultiplier)or 0.7)
                                else
                                    _
                                else
                                    _
                                else
                                    _;
                                    f,H=I(1,N((if c=="Head"then if J.WasHelmetHeadshot then
                                        if g then
                                            if g.ArmorPenetration then
                                                _*R(tonumber(g.ArmorPenetration)or 0.85,0.2,1)
                                            else
                                                _
                                            else
                                                _
                                            else
                                                _
                                            else
                                                if F:GetAttribute("Armor")then
                                                    if g then
                                                        if g.ArmorPenetration then
                                                            _*R(tonumber(g.ArmorPenetration)or 0.85,0.2,1)
                                                        else
                                                            _
                                                        else
                                                            _
                                                        else
                                                            _)+0.5)),d[F.UserId];
                                                            if H then
                                                            else
                                                                if p then
                                                                    if type(p.getHealth)=="function"then if Q then
                                                                        y,k=pcall(p.getHealth,Q);
                                                                        H=if y then
                                                                            if type(k)=="number"then if k>0 then
                                                                                k
                                                                            else
                                                                                H
                                                                            else
                                                                                H
                                                                            else
                                                                                H;
                                                                            else
                                                                            end;
                                                                        else
                                                                        end;
                                                                    else
                                                                    end;
                                                                    H=H or 100;
                                                                end;
                                                                _=I(0,H-f);
                                                                d[F.UserId]=_;
                                                                m.reclaim();
                                                                U(F,u,f,_);
                                                            end;
                                                            local function p(M)m.elevate(S,M);
                                                        end;
                                                        local function S(M)if P then
                                                            if type(M)~="table"then return;
                                                        end;
                                                    else
                                                        return;
                                                    end;
                                                    local a=O.master.kill;
                                                    local N,I,R,n,q=a and O.log.kill,a and O.fx.kill.on,a and O.screen.kill.on,a and O.marks.kill.on,a and O.sounds.kill.on;
                                                    if N then
                                                    elseif  I then
                                                    elseif  R then
                                                    elseif  n then
                                                    elseif  q then
                                                    else
                                                        return;
                                                    end;
                                                    if tonumber(M.Killer)~=j.UserId then
                                                        return;
                                                    end;
                                                    if q then
                                                        Y.play("kill");
                                                    end;
                                                    if R then
                                                        G.emit("kill");
                                                    end;
                                                    q=tonumber(M.Victim);
                                                    R,a=q and(x:GetPlayerByUserId(q)or K.key(q));
                                                    if I or n then
                                                        local K=q and E[q];
                                                        a=if K then
                                                            if type(K.time)=="number"then if os.clock()-K.time<=2.5 then
                                                                K.position
                                                            else
                                                                a
                                                            else
                                                                a
                                                            else
                                                                a;
                                                                a=a or(if typeof(M.DeathPosition)=="Vector3"then M.DeathPosition
                                                            else
                                                                a)or(b(R));
                                                            else
                                                            end;
                                                            if I then
                                                                if a then
                                                                    t.emit("kill",a);
                                                                end;
                                                            end;
                                                            if n then
                                                                if a then
                                                                    i.emit("kill",a);
                                                                end;
                                                            end;
                                                            if q then
                                                                E[q]=nil;
                                                            end;
                                                            if not(N)then
                                                                return;
                                                            end;
                                                            local b,K,t=R and(R.DisplayName or R.Name)or"player "..tostring(M.Victim),{},0;
                                                            local function G(i,Y)if i then
                                                                t+=1;
                                                                K[t]=Y;
                                                            end;
                                                        end;
                                                        G(M.Headshot,"headshot");
                                                        G(M.NoScope,"no-scope");
                                                        G(M.Wallbang,"wallbang");
                                                        G(M.Blind,"blind");
                                                        G(M.Smoke,"smoke");
                                                        G(M.Jump,"jump");
                                                        if q then
                                                            d[q]=100;
                                                        end;
                                                        N=o("killed {%s} with {%s}",b,tostring(M.Weapon or"?"));
                                                        N=if t>0 then
                                                            N..o(" ({%s})",table.concat(K,", ",1,t))
                                                        else
                                                            N;
                                                            B(N,nil,4);
                                                        end;
                                                        local function b(K)m.elevate(S,K);
                                                    end;
                                                    local function m(K,S)if type(K)~="table"then return nil;
                                                elseif  type(K.Listen)~="function"then return nil;
                                            end;
                                            local o,t=pcall(K.Listen,S);
                                            if o then
                                                if type(t)=="function"then return t;
                                            end;
                                        end;
                                        return nil;
                                    end;
                                    T.start=function()if r then
                                        return;
                                    elseif  not(w)then
                                        return;
                                    end;
                                    r=true;
                                    local function K(S)if w then
                                        if S==j then
                                            return;
                                        end;
                                    else
                                        return;
                                    end;
                                    local function j()d[S.UserId]=100;
                                end;
                                if S.Character then
                                    j();
                                end;
                                h.adopt(S.CharacterAdded:Connect(j));
                            end;
                            local j=x:GetPlayers();
                            for S=1,#j,1 do
                                K(j[S]);
                            end;
                            h.adopt(x.PlayerAdded:Connect(K));
                            h.spawn(function()if w then
                                if not(A)then
                                    return;
                                end;
                            else
                                return;
                            end;
                            local j=m(A.VFX and A.VFX.CreateImpact,p);
                            if j then
                                if w then
                                    Z=h.adopt(j);
                                else
                                    pcall(j);
                                end;
                            end;
                        end);
                        if L then
                            return;
                        end;
                        L=true;
                        h.spawn(function()if P then
                            if not(A)then
                                return;
                            end;
                        else
                            return;
                        end;
                        local j=m(A.UI and A.UI.UIPlayerKilled,b);
                        if j then
                            if P then
                                X=h.adopt(j);
                            else
                                pcall(j);
                            end;
                        end;
                    end);
                end;
                T.unload=function()w,P=false,false;
                table.clear(d);
                table.clear(E);
                Z,X=nil,nil;
            end;
            h.teardown(T.unload);
            return T;
        end;
        D.ag=function()local m=D.load("q").white;
        return{on=false,team_check=true,boxes={head=true,chest=true},prefer="head",auto_shoot=false,auto_scope=false,auto_wall=false,wallbang=false,wall_power=3,magic=false,auto_revolver=false,auto_switch=false,double_tap=false,rapid=false,no_recoil=false,no_spread=false,insta_reload=false,min_damage=0,wall_min_damage=0,fov=8,draw_fov=false,fov_col=m,fov_grad=false,fov_col2=m,fov_fill=false,fov_fill_col=m,fov_fill_grad=false,fov_fill_col2=m,multipoint=false,origin_shift=0,head_size=65,chest_size=60,stomach_size=60,arms_size=55,legs_size=55,reg_hits=0,reg_miss=0,reg_lead=0};
    end;
    D.ah=function()local m,j=D.load("b"),D.load("a");
    local h=m.lp;
    local b=m.http;
    local K=os.clock;
    local S=math.max;
    local o=math.min;
    local t=string.lower;
    local G=string.find;
    local i=table.remove;
    local Y=m.weak();
    local O,T=m.weak(),0.15;
    local m,x=-1,{};
    local function p(A)if A-m<0.25 then
        local M=T;
        return M;
    end;
    m=A;
    local m,A=pcall(h.GetNetworkPing,h);
    local M,a=if m then
        if type(A)=="number"then if A==A then
            if A>0 then
                A
            else
                0.05
            else
                0.05
            else
                0.05
            else
                0.05,tonumber(h:GetAttribute("Ping"));
                M=if a then
                    if a==a then
                        if a>0 then
                            if a<2000 then
                                if a/1000>M then
                                    a/1000
                                else
                                    M
                                else
                                    M
                                else
                                    M
                                else
                                    M
                                else
                                    M;
                                    T=o(M,1);
                                    A=T;
                                    return A;
                                end;
                                x.pending=function(m,h)local o=O[m];
                                if not(o)then
                                    return 0;
                                end;
                                local T,A=o.shots,o.hp;
                                o.hp=h;
                                if h>A+0.01 then
                                    table.clear(T);
                                    return 0;
                                end;
                                o=K();
                                m=p(o);
                                local p,M,a=o-(m*1.25+0.08),h<A-0.01 and o-m*0.8 or nil,0;
                                for h=#T,1,-1 do
                                    m=T[h];
                                    if m.t<=p or M and m.t<=M then
                                        i(T,h);
                                    else
                                        a+=m.dmg;
                                    end;
                                end;
                                return a;
                            end;
                            x.reserve=function(m)local h,o=m and m.char,tonumber(m and m.dmg);
                            if h then
                                if o then
                                    if o<=0 then
                                        return;
                                    end;
                                else
                                    return;
                                end;
                            else
                                return;
                            end;
                            m=h:GetAttribute("Health");
                            if typeof(m)~="number"then return;
                        elseif  m<=0 then
                            return;
                        end;
                        local T=O[h];
                        if T then
                        else
                            T={hp=m,shots={}};
                            O[h]=T;
                        end;
                        m=T.shots;
                        m[#m+1]={t=K(),dmg=o};
                        if#m>64 then
                            i(m,1);
                        end;
                    end;
                    x.armor=function(m)if not(m)then
                        return 0,false;
                    end;
                    local h,K=m:GetAttribute("Armor"),m.Character;
                    local o,i=K and K:GetAttribute("Armor")or nil,m:GetAttribute("Helmet");
                    i=if i==nil then
                        (m:GetAttribute("HasHelmet"))
                    else
                        i;
                        K=Y[m];
                        if K then
                            if K.raw==h then
                                if K.char_armor==o then
                                    if K.helmet_flag==i then
                                        return K.health,K.helmet;
                                    end;
                                end;
                            end;
                        end;
                        local T,p=0,i==true;
                        if type(h)=="number"then T=(S(0,h));
                    else
                        if type(h)=="string"then local A,M=pcall(b.JSONDecode,b,h);
                        if A then
                            if type(M)=="table"then K=S(0,tonumber(M.Health)or 0);
                            p=p or M.Helmet==true;
                            p=if G(t(tostring(M.Type or"")),"helmet",1,true)then
                                true
                            else
                                p;
                                T=K;
                            else
                            end;
                        else
                        end;
                    else
                    end;
                end;
                T=if T<=0 then
                    if type(o)=="number"then S(0,o)
                else
                    T
                else
                    T;
                    Y[m]={raw=h,char_armor=o,helmet_flag=i,health=T,helmet=p};
                    return T,p;
                end;
                x.effective_armor=function(m)return x.armor(m);
            end;
            x.clear=function()for m in Y,nil,nil do
                Y[m]=nil;
            end;
            for m in O,nil,nil do
                O[m]=nil;
            end;
        end;
        j.teardown(x.clear);
        return x;
    end;
    D.ai=function()return{groups={head={"Head"},chest={"UpperTorso"},stomach={"LowerTorso"},arms={"LeftUpperArm","RightUpperArm","LeftLowerArm","RightLowerArm","LeftHand","RightHand"},legs={"LeftUpperLeg","RightUpperLeg","LeftLowerLeg","RightLowerLeg","LeftFoot","RightFoot"}},order={"head","chest","stomach","arms","legs"},damage_key={Head="Head",UpperTorso="Torso",LowerTorso="Torso",LeftUpperArm="Arms",RightUpperArm="Arms",LeftLowerArm="Arms",RightLowerArm="Arms",LeftHand="Arms",RightHand="Arms",LeftUpperLeg="Legs",RightUpperLeg="Legs",LeftLowerLeg="Legs",RightLowerLeg="Legs",LeftFoot="Legs",RightFoot="Legs"},group_of={Head="head",UpperTorso="chest",LowerTorso="stomach",LeftUpperArm="arms",RightUpperArm="arms",LeftLowerArm="arms",RightLowerArm="arms",LeftHand="arms",RightHand="arms",LeftUpperLeg="legs",RightUpperLeg="legs",LeftLowerLeg="legs",RightLowerLeg="legs",LeftFoot="legs",RightFoot="legs"},size_key={head="head_size",chest="chest_size",stomach="stomach_size",arms="arms_size",legs="legs_size"},teams={["Counter-Terrorists"]=true,Terrorists=true}};
end;
D.aj=function()local m,j,h=D.load("b"),D.load("ai"),D.load("ag");
local b=D.load("ah");
local K=D.load("p");
local S=m.lp;
local o=m.workspace;
local t=m.players;
local G=j.teams;
local j=os.clock;
local i=m.weak();
local Y,O=m.weak(),{};
local function m(T)local x=Y[T];
if x then
else
    x={stamp=0,shield_stamp=0,shield=false,player=nil,ok=false,root=nil};
    Y[T]=x;
end;
return x;
end;
O.part=function(Y,T)local x=i[Y];
if x then
else
    x={};
    i[Y]=x;
end;
local i=x[T];
if i then
    if i.Parent==Y then
        return i;
    end;
end;
i=Y:FindFirstChild(T);
i=i and(if i:IsA("BasePart")then
    i
else
    nil);
    x[T]=i;
    return i;
end;
O.shielded=function(i)local Y,T=m(i),j();
if T<Y.shield_stamp then
    return Y.shield;
end;
local x=i:FindFirstChildWhichIsA("ForceField",true)~=nil;
Y.shield_stamp=T+0.1;
Y.shield=x;
return x;
end;
O.alive=function(i)if i then
    if not(i:IsDescendantOf(o))then
        return false;
    end;
else
    return false;
end;
if i:GetAttribute("Dead")~=false then
    return false;
end;
local Y=i:GetAttribute("Health");
return typeof(Y)=="number"and Y>0;
end;
local function i(Y,T,x)if T:GetAttribute("Dead")~=false then
    return false;
elseif  T:GetAttribute("Invincible")==true then
    return false;
end;
if Y:GetAttribute("Invincible")==true then
    return false;
elseif  Y:GetAttribute("Dead")==true then
    return false;
end;
local p=T:GetAttribute("Health");
if typeof(p)~="number"then return false;
elseif  p<=0 then
    return false;
end;
local A=j();
if A>=x.shield_stamp then
    x.shield_stamp=A+0.1;
    x.shield=T:FindFirstChildWhichIsA("ForceField",true)~=nil;
end;
if x.shield then
    return false;
end;
if p-b.pending(T,p)<=0 then
    return false;
end;
p=O.part(T,"HumanoidRootPart");
if not p then
    return false;
end;
if not(O.part(T,"Head"))then
    return false;
end;
if not(O.part(T,"UpperTorso"))then
    return false;
end;
if not(O.part(T,"LowerTorso"))then
    return false;
end;
if h.team_check then
    A,T=S:GetAttribute("Team"),Y:GetAttribute("Team");
    if A then
        if not T then
            return false;
        end;
    else
        return false;
    end;
    if G[A]then
        if not(G[T])then
            return false;
        end;
    else
        return false;
    end;
    if o:GetAttribute("Gamemode")~="Deathmatch"then if A==T then
        return false;
    end;
end;
end;
return true,p;
end;
O.valid=function(h,b)if h then
    if h==S then
        return false;
    elseif  h.Parent~=t then
        return false;
    elseif  b then
    else
        return false;
    end;
else
    return false;
end;
if not(K.armed(h,b))then
    if h.Character~=b then
        return false;
    elseif  not(b:IsDescendantOf(o))then
        return false;
    end;
end;
local K,S=m(b),j();
if K.player==h then
    if S<K.stamp then
        return K.ok,K.root;
    end;
end;
local m,j=i(h,b,K);
K.stamp=S+0.005;
K.player=h;
K.ok=m;
K.root=j;
return m,j;
end;
return O;
end;
D.ak=function()local m,j,h,b,K,S=D.load("b"),D.load("f"),D.load("a"),D.load("j"),D.load("L"),D.load("ag");
local o=D.load("aj");
local t=m.lp;
local G=m.workspace;
local i,Y=m.storage,K.probe;
local O=K.through;
local T=j.copy_with;
local x=j.trim;
local p=math.sqrt;
local A=math.abs;
local M,M,M=math.max,math.min,{on=false,power=1,step=0.015625,ticks=2,gravity=60,max_speed=262.5,ground_speed=24.375,measured=0};
local a=m.weak();
local B,N;
local I=-1;
m,j=i:FindFirstChild("MovementV2"),b.kinematics;
if m then
    i=m:FindFirstChild("Config");
    if i then
        if i:IsA("ModuleScript")then
            local R,n=pcall(require,i);
            K=R and type(n)=="table"and n.Default or nil;
            if type(K)=="table"then R=K.SimulationHz;
            if type(R)=="number"then if R>=20 then
                if R<=240 then
                    M.step=1/R;
                end;
            end;
        end;
        n=K.RenderInterpolationTicks;
        if type(n)=="number"then if n>=0 then
            M.ticks=n;
        end;
    end;
end;
end;
end;
local K=m:FindFirstChild("Simulation");
i=K and(K:FindFirstChild("Config"));
if i then
    if i:IsA("ModuleScript")then
        local R,n=pcall(require,i);
        K=R and type(n)=="table"and n.Default or nil;
        if type(K)=="table"then R=K.Gravity;
        if type(R)=="number"then if R>0 then
            M.gravity=R;
        end;
    end;
    n=K.MaxVelocity;
    if type(n)=="number"then if n>0 then
        M.max_speed=n;
    end;
end;
local i=K.MaxBaseMoveSpeed;
if type(i)=="number"then if i>0 then
    M.ground_speed=i*1.25;
end;
end;
end;
end;
end;
end;
m=b.char_velocity;
if type(m)=="function"then B=m;
else
    if j and type(j.getVelocity)=="function"then local m=j.getVelocity;
    B=function(b)return m(b,b.PrimaryPart);
end;
else
end;
end;
if j then
    if type(j.isOnGround)=="function"then local m=j.isOnGround;
    N=m;
else
end;
else
end;
local m,j,b,K,i=B,N,{},{},{};
local B=RaycastParams.new();
B.FilterType=Enum.RaycastFilterType.Include;
B.IgnoreWater=false;
B.CollisionGroup="Bullet";
local N=RaycastParams.new();
N.FilterType=Enum.RaycastFilterType.Exclude;
N.IgnoreWater=false;
N.CollisionGroup="Bullet";
local R=RaycastParams.new();
R.FilterType=Enum.RaycastFilterType.Exclude;
R.IgnoreWater=false;
R.CollisionGroup="Bullet";
M.lead=function()local n=I;
if n~=M.power then
    I=M.power;
    S.reg_hits=0;
    S.reg_miss=0;
    S.reg_lead=0;
end;
if not(M.on)then
    return 0;
end;
n=tonumber(M.power);
if n then
    if n~=n then
        return 0;
    elseif  A(n)<0.001 then
        return 0;
    end;
else
    return 0;
end;
local S=t:GetNetworkPing();
S=if type(S)~="number"then 0.05
else
    if S~=S then
        0.05
    else
        if S<=0 then
            0.05
        else
            if S>1 then
                1
            else
                S;
                M.measured=S;
                local t=S*n;
                if t~=t then
                    return 0;
                elseif  A(t)<0.001 then
                    return 0;
                end;
                if t>2 then
                    return 2;
                end;
                if t<-2 then
                    return-2;
                end;
                return t;
            end;
            M.filter=function(S,t)return T(b,S,t);
        end;
        local function S(t,T)local I=o.part(t,"HumanoidRootPart");
        if not(I)then
            return T;
        end;
        local n=o.part(t,"LeftFoot")or o.part(t,"RightFoot");
        local E,d=if n then
            n.Position.Y-n.Size.Y*0.5
        else
            I.Position.Y-I.Size.Y*0.5-2,-T.Y;
            i[1]=t;
            x(i,1);
            N.FilterDescendantsInstances=i;
            n=G:Raycast(I.Position,Vector3.new(0,-(d+6),0),N);
            if not n then
                return T;
            end;
            t=E-n.Position.Y;
            t=if t~=t then
                0
            else
                if t<0 then
                    0
                else
                    t;
                    if d<=t then
                        return T;
                    end;
                    return Vector3.new(T.X,-t,T.Z);
                end;
                local function t(T)local N=o.part(T,"HumanoidRootPart");
                if not(N)then
                    return Vector3.zero;
                end;
                local I,n,E=os.clock(),N.Position,a[T];
                if not(E)then
                    a[T]={pos=n,time=I,vel=Vector3.zero};
                    return Vector3.zero;
                end;
                T=I-E.time;
                if T<0.008 then
                    return E.vel;
                end;
                if T>0.5 then
                    E.pos=n;
                    E.time=I;
                    E.vel=Vector3.zero;
                    return Vector3.zero;
                end;
                N=(n-E.pos)/T;
                E.pos=n;
                E.time=I;
                T,I=N.X,N.Z;
                n=p(T*T+I*I);
                if n~=n then
                    N=Vector3.zero;
                else
                    if n>M.ground_speed then
                        local p=M.ground_speed/n;
                        N=Vector3.new(T*p,N.Y,I*p);
                    else
                    end;
                end;
                n=N.Y;
                N=if n~=n then
                    Vector3.zero
                else
                    if n>M.max_speed then
                        Vector3.zero
                    else
                        if n<-M.max_speed then
                            Vector3.zero
                        else
                            N;
                            E.vel=N;
                            return N;
                        end;
                        M.offset=function(T,p)if T then
                            if A(p)<0.001 then
                                return Vector3.zero;
                            end;
                        else
                            return Vector3.zero;
                        end;
                        local a=if m then
                            (m(T))
                        else
                            nil;
                            if typeof(a)~="Vector3"or a.Magnitude<0.05 then
                                local m=o.part(T,"HumanoidRootPart");
                                a=m and m.AssemblyLinearVelocity or nil;
                            else
                            end;
                            a=if typeof(a)~="Vector3"then t(T)
                        else
                            if a.Magnitude<0.05 then
                                t(T)
                            else
                                a;
                                local m=a.Magnitude;
                                if m~=m then
                                    return Vector3.zero;
                                elseif  m<0.05 then
                                    return Vector3.zero;
                                end;
                                local o,t=(if m>M.max_speed then
                                    a*(M.max_speed/m)
                                else
                                    a)*p,j and j(T)or nil;
                                    o=if t==true then
                                        Vector3.new(o.X,0,o.Z)
                                    else
                                        if t==false then
                                            if p>0 then
                                                o-Vector3.new(0,0.5*M.gravity*p*p,0)
                                            else
                                                o
                                            else
                                                o;
                                                if o.X~=o.X then
                                                    return Vector3.zero;
                                                elseif  o.Y~=o.Y then
                                                    return Vector3.zero;
                                                elseif  o.Z~=o.Z then
                                                    return Vector3.zero;
                                                end;
                                                return if o.Y<-0.05 then
                                                    S(T,o)
                                                else
                                                    o;
                                                end;
                                                local function m(j,S,o,t)local T,p,a,N,I,n,E=o:PointToObjectSpace(j),o:VectorToObjectSpace(S),t*0.5,-math.huge,0,-1,math.huge;
                                                for d=1,3,1 do
                                                    S,j,t=nil;
                                                    if d==1 then
                                                        S,j,t=T.X,p.X,a.X;
                                                    else
                                                        if d==2 then
                                                            S,j,t=T.Y,p.Y,a.Y;
                                                        else
                                                            S,j,t=T.Z,p.Z,a.Z;
                                                        end;
                                                    end;
                                                    if A(j)<1.0E-7 then
                                                        if S<-t then
                                                            return nil;
                                                        elseif  S>t then
                                                            return nil;
                                                        end;
                                                    else
                                                        local T,p,A,w=(-t-S)/j,(t-S)/j,-1,n;
                                                        if T>p then
                                                            A=1;
                                                            T,p,n=p,T,A;
                                                        else
                                                            n=A;
                                                        end;
                                                        if T>N then
                                                            N,I=T,d;
                                                        else
                                                            n=w;
                                                        end;
                                                        E=if p<E then
                                                            p
                                                        else
                                                            E;
                                                            if N>E then
                                                                return nil;
                                                            end;
                                                        end;
                                                    end;
                                                    if I==0 then
                                                        return nil;
                                                    elseif  N~=N then
                                                        return nil;
                                                    elseif  N<=0.05 then
                                                        return nil;
                                                    end;
                                                    a=if I==1 then
                                                        Vector3.new(n,0,0)
                                                    else
                                                        if I==2 then
                                                            Vector3.new(0,n,0)
                                                        else
                                                            Vector3.new(0,0,n);
                                                            return N,o:VectorToWorldSpace(a);
                                                        end;
                                                        M.hit=function(j,S,o,t,T)K[1]=o;
                                                        x(K,1);
                                                        B.FilterDescendantsInstances=K;
                                                        local p=j-t;
                                                        local A=G:Raycast(p,S*(T+1),B);
                                                        if A then
                                                            if A.Instance==o then
                                                                local G=(A.Position-p).Magnitude;
                                                                if G>0.05 then
                                                                    if G<=T+1 then
                                                                        return G,A.Normal;
                                                                    end;
                                                                end;
                                                            end;
                                                        end;
                                                        return m(j,S,o.CFrame+t,o.Size);
                                                    end;
                                                    M.path=function(m,j,S,o,t)local G,T=S-0.02,Y(m,j*S,R,t);
                                                    if T then
                                                        if not(T.instance)then
                                                            return 0,0,nil,nil;
                                                        end;
                                                    else
                                                        return 0,0,nil,nil;
                                                    end;
                                                    local Y=T.position-m;
                                                    if Y.X*j.X+Y.Y*j.Y+Y.Z*j.Z>=G then
                                                        return 0,0,nil,nil;
                                                    end;
                                                    if not(o)then
                                                        return 2,0,nil,nil;
                                                    end;
                                                    Y=O(m+j*-0.001,j*(S+0.001),o,t,nil,S);
                                                    if not Y then
                                                        return 2,0,nil,nil;
                                                    end;
                                                    T=0;
                                                    for o=1,#Y,1 do
                                                        t=Y[o];
                                                        if not(t.instance)then
                                                            break;
                                                        end;
                                                        S=t.position-m;
                                                        if S.X*j.X+S.Y*j.Y+S.Z*j.Z>=G then
                                                            break;
                                                        end;
                                                        T=o;
                                                    end;
                                                    if T==0 then
                                                        return 2,0,nil,nil;
                                                    elseif  T%2~=0 then
                                                        return 2,0,nil,nil;
                                                    end;
                                                    return 1,T*0.5,Y,T+1;
                                                end;
                                                h.teardown(function()M.on=false;
                                                x(b,0);
                                                x(K,0);
                                                x(i,0);
                                            end);
                                            return M;
                                        end;
                                        D.al=function()local m,j,h,b,K=D.load("b"),D.load("a"),D.load("j"),D.load("ai"),D.load("ag");
                                        local S=D.load("ak");
                                        local o=D.load("ah");
                                        local t=D.load("i");
                                        local G=m.storage;
                                        local i,Y,O=h.inventory,b.groups,{names={},valid={},aliases={}};
                                        O.by_props=m.weak();
                                        O.active=nil;
                                        O.weapon=nil;
                                        O.on_apply=nil;
                                        O.ui=nil;
                                        local m={pistols=1,rifles=2,snipers=3,smgs=4,shotguns=5,["machine guns"]=6,heavy=7,other=8};
                                        O.boxes=function(h)local b={};
                                        if type(h)=="table"then for T,T in h,nil,nil do
                                            if Y[T]then
                                                b[T]=true;
                                            end;
                                        end;
                                    end;
                                    return b;
                                end;
                                O.category=function(h)if type(h)~="table"then return nil;
                            end;
                            local b,Y=tostring(rawget(h,"Type")or""),tostring(rawget(h,"MuzzleType")or"");
                            if Y=="Zeus x27"then return nil;
                        end;
                        if Y=="Sniper"then return"snipers";
                    end;
                    if Y=="ShotGun"then return"shotguns";
                end;
                if Y=="MachineGun"then return"machine guns";
            end;
            if b=="Pistol"then return"pistols";
        end;
        if b=="Rifle"then return"rifles";
    end;
    if b=="SMG"then return"smgs";
end;
if b=="Heavy"then return"heavy";
end;
return"other";
end;
O.load=function()local h=G:FindFirstChild("Database");
local b=h and(h:FindFirstChild("Custom"));
h=b and(b:FindFirstChild("Weapons"));
if not h then
    return;
end;
b=h:GetChildren();
for G=1,#b,1 do
    h=b[G];
    if h:IsA("ModuleScript")then
        if h.Name~="Zeus x27"then local b,Y=pcall(require,h);
        G=b and type(Y)=="table"and Y.Class=="Weapon"and O.category(Y);
        if G then
            O.by_props[Y]=G;
            O.aliases[h.Name:lower()]=G;
            if not(O.valid[G])then
                O.valid[G]=true;
                O.names[#O.names+1]=G;
            end;
        end;
    end;
end;
end;
table.sort(O.names,function(h,b)local G,Y=m[h]or math.huge,m[b]or math.huge;
if G==Y then
    return h<b;
end;
return G<Y;
end);
end;
O.find_type=function(m)if type(m)~="table"then return nil;
end;
local h=rawget(m,"Properties");
local b=h and O.by_props[h]or nil;
b=b or(if type(h)=="table"then O.category(h)
else
    b);
    if b then
    else
        h=rawget(m,"Name");
        b=if type(h)=="string"then O.aliases[h:lower()]
    else
        b;
    end;
    if b then
        if O.valid[b]then
            return b;
        end;
    end;
    return nil;
end;
O.apply=function(m)local h=O.ui;
if not h then
    return;
end;
local function b(G)return h:get("legit."..G,m);
end;
local h,G,Y=m~=nil,K.double_tap,K.rapid;
K.on=h and b("on")or false;
K.team_check=b("team");
K.boxes=O.boxes(b("hb"));
K.prefer=b("prefer");
K.auto_shoot=h and b("auto")or false;
K.auto_scope=h and b("autoscope")==true or false;
K.auto_wall=h and b("aw")or false;
K.wallbang=false;
K.magic=false;
K.auto_revolver=h and b("autorev")or false;
K.auto_switch=h and b("autoswitch")or false;
K.double_tap=h and b("dt")or false;
K.rapid=h and b("rapid")or false;
K.no_recoil=h and b("norecoil")or false;
K.no_spread=h and b("nospread")or false;
K.insta_reload=h and b("instantreload")or false;
K.min_damage=b("mindmg");
K.wall_min_damage=b("awmindmg");
K.fov=b("fov");
K.draw_fov=h and b("dfov")or false;
K.fov_col=b("dfov_col");
K.fov_grad=b("dfov_grad");
K.fov_col2=b("dfov_col2");
K.fov_fill=b("dfov_fill");
K.fov_fill_col=b("dfov_fcol");
K.fov_fill_grad=b("dfov_fgrad");
K.fov_fill_col2=b("dfov_fcol2");
K.multipoint=h and b("multipoint")or false;
K.origin_shift=h and tonumber(b("originshift"))or 0;
K.head_size=b("headsize");
K.chest_size=b("chestsize");
K.stomach_size=b("stomachsize");
K.arms_size=b("armssize");
K.legs_size=b("legssize");
S.on=h and b("predict")==true or false;
h=tonumber(b("predict_power"));
if type(h)=="number"then if h==h then
    S.power=h/100;
else
    S.power=1;
end;
else
    S.power=1;
end;
t.aim=false;
if O.on_apply then
    O.on_apply(G,Y);
end;
end;
O.refresh=function()O.apply(O.active);
end;
O.activate=function(m)local h=O.find_type(m);
if O.weapon==m then
    if O.active==h then
        return;
    end;
end;
O.weapon=m;
O.active=h;
O.apply(h);
end;
local m;
local h=type(i)=="table"and rawget(i,"peekCurrentEquippedForMovement")or nil;
local function b()if type(h)~="function"then return nil;
end;
local K,S=pcall(h);
if K then
    if type(S)~="table"then return nil;
elseif  S.IsDestroyed then
    return nil;
elseif  not(S.IsEquipped)then
    return nil;
end;
else
    return nil;
end;
return S;
end;
O.held=function()local h=m;
if h then
    if not(h.IsDestroyed)then
        if h.IsEquipped then
            O.activate(h);
            return h;
        end;
    end;
end;
m=nil;
O.activate(nil);
return nil;
end;
O.adopt=function(h)m=h;
end;
O.ensure=function()local h=O.held();
if h then
    return h;
end;
h=b();
if h then
    m=h;
end;
O.activate(h);
return h;
end;
O.load();
j.teardown(function()m=nil;
O.weapon=nil;
O.active=nil;
O.ui=nil;
o.clear();
end);
return O;
end;
D.am=function()local m,j=D.load("b"),D.load("a");
local h=D.load("h");
local b,K=D.load("ai"),m.lp;
local S=m.workspace;
local o=m.players;
local t=b.teams;
local b,G,i,Y,O=string.lower,{},{},{},{};
local T=m.weak();
local m;
local x=false;
local p={picked=G,values=O,set=function(A)if x then
    return;
end;
local M={};
if type(A)=="table"then for a,B in A,nil,nil do
    local N=if type(a)=="string"and B==true then
        a
    else
        if type(B)=="string"then B
    else
        nil;
        B=N and i[N];
        if B then
            M[B]=true;
        end;
    end;
elseif  type(A)=="string"then local a=i[A];
if a then
    M[a]=true;
end;
end;
table.clear(G);
for A in M,nil,nil do
    G[A]=true;
end;
end
};
local function A(M,a)local B,N=b(M),b(a);
if B==N then
    return M<a;
end;
return B<N;
end;
p.refresh=function(b)table.clear(i);
table.clear(Y);
local M,a,B={},h.all();
local h,N=K:GetAttribute("Team"),S:GetAttribute("Gamemode")=="Deathmatch";
local I,R=t[h]==true,0;
for n=1,B,1 do
    local B=a[n];
    if B~=b then
        if B~=K then
            if B.Parent==o then
                if not(T[B])then
                    local b,K=j.adopt,function()p.refresh();
                end;
                T[B]=b(B:GetAttributeChangedSignal("Team"):Connect(K));
            end;
            n=B:GetAttribute("Team");
            if I and t[n]and(N or h~=n)then
                local h,b=B.UserId,B.DisplayName;
                local K,t=if b==B.Name then"@"..B.Name
            else
                b.." (@"..B.Name..")",R+1;
                O[t]=K;
                i[K]=h;
                Y[h]=K;
                M[h]=true;
                R=t;
            else
            end;
        else
        end;
    else
    end;
else
end;
end;
for h=#O,R+1,-1 do
    O[h]=nil;
end;
table.sort(O,A);
I={};
for h in G,nil,nil do
    if M[h]then
        I[#I+1]=Y[h];
    else
        G[h]=nil;
    end;
end;
if m then
    x=true;
    pcall(m.setvalues,m,O);
    pcall(m.set,m,I);
    x=false;
end;
end;
p.bind=function(h)m=h;
end;
p.unload=function()m,x=nil,false;
table.clear(G);
table.clear(i);
table.clear(Y);
table.clear(O);
end;
j.connect(S:GetAttributeChangedSignal("Gamemode"),function()p.refresh();
end);
j.connect(o.PlayerAdded,function()p.refresh();
end);
j.connect(o.PlayerRemoving,function(m)G[m.UserId]=nil;
p.refresh(m);
end);
j.teardown(p.unload);
return p;
end;
D.an=function()local m,j,h,b=D.load("b"),D.load("f"),D.load("a"),D.load("h");
local K,S,o,t=D.load("j"),D.load("L"),D.load("ai"),D.load("ag");
local G=D.load("ah");
local i=D.load("aj");
local Y=D.load("am");
local O=D.load("ak");
local T=D.load("p");
local x=D.load("M");
local p=m.lp;
local A=m.workspace;
local m=S.probe;
local M=S.through;
local a=K.ray_ignore;
local K=o.groups;
local B=o.order;
local N=o.damage_key;
local I=o.size_key;
local o=j.trim;
local j=math.clamp;
local R=math.max;
local n,n,n=math.min,math.abs,math.huge;
local E=math.cos;
local d=math.rad;
local w,w=math.floor,Vector3.zero;
local P,r=Vector3.yAxis,{};
local L=RaycastParams.new();
L.FilterType=Enum.RaycastFilterType.Exclude;
L.IgnoreWater=false;
L.CollisionGroup="Bullet";
local Z,X,q,U,z,J,y={};
local f,k,g,Q,c,H,_,s,F,v,u,V,e,l,C,W,mF,DF,jF,hF,bF,KF,SF,oF,tF={},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{};
local function GF(iF)local YF=SF[iF];
if YF~=nil then
    return YF,oF[iF];
end;
local YF,OF=G.effective_armor(iF);
SF[iF]=YF;
oF[iF]=OF;
return YF,OF;
end;
local function G(iF,YF,OF,TF,xF)local pF=N[YF];
if not(pF)then
    return 0,0;
end;
YF=xF.DamagePerPart;
if type(YF)~="table"then return 0,0;
end;
local AF=YF[pF]or 0;
if AF<=0 then
    return 0,0;
end;
YF=AF*(tonumber(xF.RangeModifier)or 1)^R(0,OF/100);
YF=if TF>0 then
    YF*(tonumber(xF.WallbangMultiplier)or 1)
else
    YF;
    AF,TF=GF(iF);
    iF=0;
    if AF>0 and(pF~="Head"or TF)then
        OF=YF*j(tonumber(xF.ArmorPenetration)or 1,0,1);
        iF=(YF-OF)*0.5;
        if iF>AF then
            iF,OF=AF,YF-AF/0.5;
        else
        end;
        YF=(R(0,OF));
    else
    end;
    return YF,iF;
end;
local function GF(iF,YF,OF)local TF=N[iF];
if not(TF)then
    return 0;
end;
iF=OF.DamagePerPart;
if type(iF)~="table"then return 0;
end;
local N=iF[TF]or 0;
if type(N)~="number"then return n;
end;
if N<=0 then
    return 0;
end;
TF=tonumber(OF.RangeModifier)or 1;
if TF~=TF then
    return n;
elseif  TF<0 then
    return n;
elseif  TF>1 then
    return n;
end;
if YF then
    iF=tonumber(OF.WallbangMultiplier)or 1;
    if iF~=iF then
        return n;
    elseif  iF<0 then
        return n;
    end;
    return N*iF;
end;
return N;
end;
local function N(iF,YF,OF)local TF=t.min_damage;
if tF then
    local xF=G(iF,tF,YF,0,OF);
    if xF>0 then
        if xF<TF then
            return xF;
        end;
    end;
end;
return TF;
end;
local function iF(YF)return(x.origin(YF));
end;
local function x(YF,OF,TF)local xF=j(tonumber(TF)or 0,0,100)/100;
if xF<=0 then
    return 0;
end;
TF=YF.Size;
local pF,AF,MF,aF,BF=R(TF.X*0.5-0.05,0)*xF,R(TF.Y*0.5-0.05,0)*xF,R(TF.Z*0.5-0.05,0)*xF,YF.CFrame,0;
if OF=="head"or OF=="chest"or OF=="stomach"then if pF>0.001 then
    mF[1]=aF:PointToWorldSpace(Vector3.new(pF,0,0));
    BF=2;
    mF[BF]=aF:PointToWorldSpace(Vector3.new(-pF,0,0));
else
end;
if AF>0.001 then
    BF+=1;
    mF[BF]=aF:PointToWorldSpace(Vector3.new(0,AF,0));
    BF+=1;
    mF[BF]=aF:PointToWorldSpace(Vector3.new(0,-AF,0));
else
end;
else
    YF=if AF>=pF and AF>=MF then
        Vector3.new(0,AF,0)
    else
        if pF>=MF then
            Vector3.new(pF,0,0)
        else
            Vector3.new(0,0,MF);
            if YF.Magnitude>0.001 then
                mF[1]=aF:PointToWorldSpace(YF);
                mF[2]=aF:PointToWorldSpace(-YF);
                BF=2;
            else
            end;
        end;
        for YF=BF+1,4,1 do
            mF[YF]=nil;
        end;
        return BF;
    end;
    local function YF(OF,TF,xF,pF,AF,MF)local aF=OF-TF;
    OF=aF.Magnitude;
    if OF<0.5 then
        return nil;
    elseif  OF>MF+5 then
        return nil;
    end;
    TF=aF/OF;
    if pF<180 then
        if xF:Dot(TF)<AF then
            return nil;
        end;
    end;
    return TF,OF;
end;
local function OF(TF,xF)local pF,AF,MF,aF,BF=not not xF.head,not not xF.chest,not not xF.stomach,not not xF.arms,not not xF.legs;
if X==TF then
    if q==pF then
        if U==AF then
            if z==MF then
                if J==aF then
                    if y==BF then
                        return Z;
                    end;
                end;
            end;
        end;
    end;
end;
X,q,U,z,J,y=TF,pF,AF,MF,aF,BF;
pF,aF={},0;
if xF[TF]then
    aF=1;
    pF[aF]=TF;
else
end;
for q=1,#B,1 do
    BF=B[q];
    if BF~=TF then
        if xF[BF]then
            q=aF+1;
            pF[q]=BF;
            aF=q;
        else
        end;
    else
    end;
end;
if aF==0 then
    pF[1]=TF;
    aF=1;
    for q=1,#B,1 do
        MF=B[q];
        if MF~=TF then
            aF+=1;
            pF[aF]=MF;
        else
        end;
    end;
else
end;
AF=0;
for B=1,aF,1 do
    TF=pF[B];
    MF=K[TF];
    Z[B]={group=TF,parts=MF,slot=AF};
    AF+=#MF;
end;
o(Z,aF);
return Z;
end;
local function K(B,q,U,z,J,y,TF,xF)local pF,AF,MF=#f,b.all();
local b,aF=0,false;
for BF=1,MF,1 do
    local MF=AF[BF];
    local AF=T.target(MF);
    if AF~=TF then
        local TF,NF=i.valid(MF,AF);
        if TF then
            local TF=NF.Position-B;
            local B=TF.Magnitude;
            if B>0.5 then
                if B-4<=J then
                    local J=U>=180;
                    J=J or(if B>0.01 then
                        q:Dot(TF/B)>=z
                    else
                        J);
                        if J then
                        else
                            if xF then
                                if xF>0 then
                                    local B=O.offset(AF,xF);
                                    if B.X~=0 or B.Y~=0 or B.Z~=0 then
                                        local U=TF+B;
                                        local B=U.Magnitude;
                                        J=if B>0.01 then
                                            q:Dot(U/B)>=z
                                        else
                                            J;
                                        else
                                        end;
                                    else
                                    end;
                                else
                                end;
                            end;
                            if J then
                                local B=b+1;
                                f[B]=MF;
                                k[B]=AF;
                                g[B]=BF;
                                Q[B]=T.ghost(AF);
                                aF=if y then
                                    if Y.picked[MF.UserId]then
                                        true
                                    else
                                        aF
                                    else
                                        aF;
                                        b=B;
                                    else
                                    end;
                                else
                                end;
                            else
                            end;
                        else
                        end;
                    else
                    end;
                end;
                for T=b+1,pF,1 do
                    f[T]=nil;
                    k[T]=nil;
                    g[T]=nil;
                    Q[T]=nil;
                end;
                return b,aF;
            end;
            local function b(T,B,q,U)table.clear(DF);
            table.clear(jF);
            table.clear(hF);
            table.clear(bF);
            table.clear(KF);
            tF=nil;
            local z,J=#T,0;
            for y=1,z,1 do
                local TF=T[y].parts;
                y=#TF;
                for xF=1,y,1 do
                    local y=TF[xF];
                    xF=GF(y,false,B);
                    if xF>J then
                        if xF<n then
                            tF,J=y,xF;
                        else
                        end;
                    else
                    end;
                end;
            end;
            z=t.min_damage;
            z=if tF then
                if J<z then
                    J
                else
                    z
                else
                    z;
                    for J=1,#T,1 do
                        local y=T[J];
                        local tF,TF,xF=y.group==q and 1000000 or 0,-n,y.parts;
                        for q=1,#xF,1 do
                            y=xF[q];
                            local xF,pF=GF(y,false,B),-n;
                            pF=if xF>=z then
                                xF+tF+100000
                            else
                                pF;
                                q=-n;
                                if U then
                                    if t.magic then
                                    else
                                        local U,AF=if xF>=z then
                                            xF+tF
                                        else
                                            q,GF(y,true,B);
                                            q=if AF>=t.wall_min_damage then
                                                R(U,AF+tF)
                                            else
                                                U;
                                            end;
                                        else
                                        end;
                                        DF[y]=pF;
                                        jF[y]=q;
                                        hF[y]=R(pF,q);
                                        TF=R(TF,hF[y]);
                                    end;
                                    bF[J]=TF;
                                end;
                                B=-n;
                                for q=#T,1,-1 do
                                    B=R(B,bF[q]);
                                    KF[q]=B;
                                end;
                            end;
                            local function T(B,q,U,z,J,y)local tF=M(B,q,U,z,J,y);
                            if tF then
                                if#tF==0 then
                                    return nil;
                                end;
                            else
                                return nil;
                            end;
                            y=0;
                            for M=1,#tF,1 do
                                z=tF[M];
                                if z.instance then
                                    if z.instance:IsDescendantOf(J)then
                                        return z,y,tF,M;
                                    end;
                                    y=if M%2~=0 then
                                        y+1
                                    else
                                        y;
                                    else
                                    end;
                                end;
                                return nil;
                            end;
                            local function M(B,q,U)local z=q.Magnitude;
                            if z<0.25 then
                                return nil;
                            end;
                            local J=m(B,q,L,U);
                            if not(J.instance)then
                                return B+q;
                            end;
                            U=(J.position-B).Magnitude-0.3;
                            if U<0.25 then
                                return nil;
                            end;
                            return B+q*(U/z);
                        end;
                        local function B(q,U,z,J,y)local tF,GF=(q-1)*5,W[q];
                        if GF then
                            return tF,GF;
                        end;
                        local TF=Vector3.new(z.X-U.X,0,z.Z-U.Z);
                        z=nil;
                        if TF.Magnitude>0.001 then
                            TF=TF.Unit;
                            z=Vector3.new(-TF.Z,0,TF.X);
                        else
                            z=w;
                        end;
                        TF=y*0.5;
                        GF=0;
                        for xF=1,5,1 do
                            local pF=M(U,if xF==1 then
                                z*TF
                            else
                                if xF==2 then
                                    z*-TF
                                else
                                    if xF==3 then
                                        z*y
                                    else
                                        if xF==4 then
                                            z*-y
                                        else
                                            P*y,J);
                                            if pF then
                                                xF=true;
                                                for M=1,GF,1 do
                                                    if(C[tF+M]-pF).Magnitude<0.2 then
                                                        xF=false;
                                                        break;
                                                    end;
                                                end;
                                                if xF then
                                                    GF+=1;
                                                    C[tF+GF]=pF;
                                                else
                                                end;
                                            else
                                            end;
                                        end;
                                        W[q]=GF;
                                        return tF,GF;
                                    end;
                                    S={find=function(M,P,q,U)if not(t.on)then
                                        return nil;
                                    end;
                                    if M then
                                        if M.Class~="Weapon"then return nil;
                                    end;
                                else
                                    return nil;
                                end;
                                local z=A.CurrentCamera;
                                if not(z)then
                                    return nil;
                                end;
                                if not(i.alive(p.Character))then
                                    return nil;
                                end;
                                local p,A,J=P or iF(z)or z.CFrame.Position,z.CFrame.LookVector,j(t.fov,0,180);
                                local y,tF,GF,iF=E(d(J/2)),tonumber(M.Range)or 500,t.auto_wall or t.wallbang,R(tonumber(M.Penetration)or 0,0);
                                P,z=GF and iF or nil,t.prefer;
                                local R,E,d,TF,xF=OF(z,t.boxes),a(),O.lead(),0,t.magic and 0 or j(tonumber(t.origin_shift)or 0,0,20);
                                local j,a,OF=xF>=0.25,K(p,A,J,y,tF,q==true,U,d);
                                if a==0 then
                                    return nil;
                                end;
                                table.clear(SF);
                                table.clear(oF);
                                table.clear(W);
                                b(R,M,z,GF);
                                local b,K,pF,AF,MF,aF,BF,NF,IF,RF,nF,EF,dF,wF,PF,rF,LF,ZF,XF,qF=-1,-n,n;
                                q,U=0,0;
                                for UF=1,#R,1 do
                                    local zF=R[UF];
                                    if OF then
                                        if b==1 then
                                            if K>KF[UF]then
                                                break;
                                            end;
                                        end;
                                    elseif  K>KF[UF]then
                                        break;
                                    end;
                                    UF=zF.group;
                                    local JF,yF=UF==z and 1000000 or 0,zF.parts;
                                    local fF=0;
                                    for kF=1,a,1 do
                                        local gF,QF,cF,HF=f[kF],k[kF],g[kF],Q[kF];
                                        local _F=OF and Y.picked[gF.UserId]and 1 or 0;
                                        for sF=1,#yF,1 do
                                            local FF=yF[sF];
                                            local vF=hF[FF];
                                            if vF>-n and _F>=b and(_F>b or not(K>vF))then
                                                local vF=i.part(QF,FF);
                                                if vF then
                                                    local uF=vF.Position;
                                                    local VF=uF-p;
                                                    local eF=VF.Magnitude;
                                                    if eF>=0.5 and eF<=tF+5 then
                                                        local lF,CF,WF,m7=VF/eF,cF*100+zF.slot+sF,false,false;
                                                        if t.magic then
                                                            local cF,sF=G(gF,vF.Name,eF,0,M);
                                                            if cF>=N(gF,eF,M)then
                                                                local VF=cF+JF+100000;
                                                                if _F>b or _F==b and(VF>K or VF==K and CF<pF)then
                                                                    b,K,pF,AF,MF,aF,BF,NF,IF,RF,nF,EF,dF,wF,PF,rF,LF,ZF,XF,qF=_F,VF,CF,gF,QF,vF,UF,cF,sF,true,lF,vF,uF,-lF,vF.Material,0,nil,nil,eF,p;
                                                                else
                                                                end;
                                                            else
                                                            end;
                                                        else
                                                            if HF then
                                                                local cF,sF=O.hit(p,lF,vF,w,eF);
                                                                local VF=cF or eF;
                                                                local D7,j7,h7,b7=O.path(p,lF,VF,P,O.filter(E,QF));
                                                                if D7~=2 then
                                                                    local D7,K7=G(gF,FF,VF,j7,M);
                                                                    if D7>=(j7>0 and t.wall_min_damage or N(gF,VF,M))then
                                                                        cF=D7+JF+(j7==0 and 100000 or 0);
                                                                        if _F>b or _F==b and(cF>K or cF==K and CF<pF)then
                                                                            b,K,pF,AF,MF,aF,BF,NF,IF,RF,nF,EF,dF,wF,PF,rF,LF,ZF,XF,qF=_F,cF,CF,gF,QF,vF,UF,D7,K7,j7==0,lF,vF,p+lF*VF,sF or-lF,vF.Material,j7,h7,b7,VF,p;
                                                                        else
                                                                        end;
                                                                    else
                                                                    end;
                                                                else
                                                                end;
                                                            else
                                                                local cF=m(p,lF*tF,L,E);
                                                                local sF=cF and cF.instance;
                                                                if sF and(sF:IsDescendantOf(QF))then
                                                                    m7=true;
                                                                    local VF=(cF.position-p).Magnitude;
                                                                    local D7,j7=G(gF,sF.Name,VF,0,M);
                                                                    if D7>=N(gF,VF,M)then
                                                                        WF=true;
                                                                        local h7=D7+JF+100000;
                                                                        if _F>b or _F==b and(h7>K or h7==K and CF<pF)then
                                                                            dF,wF=cF.position,cF.normal or w;
                                                                            b,K,pF,AF,MF,aF,BF,NF,IF,RF,nF,EF,PF,rF,LF,ZF,XF,qF=_F,h7,CF,gF,QF,vF,UF,D7,j7,true,lF,sF,cF.material,0,nil,nil,VF,p;
                                                                        else
                                                                        end;
                                                                    else
                                                                    end;
                                                                else
                                                                    if GF and sF and(_F>b or not(K>jF[FF]))then
                                                                        fF+=1;
                                                                        c[fF]=gF;
                                                                        H[fF]=QF;
                                                                        _[fF]=vF;
                                                                        s[fF]=lF;
                                                                        F[fF]=eF;
                                                                        v[fF]=CF;
                                                                        u[fF]=jF[FF];
                                                                        V[fF]=false;
                                                                        e[fF]=p;
                                                                        l[fF]=0;
                                                                    else
                                                                    end;
                                                                end;
                                                            end;
                                                        end;
                                                        if t.multipoint and not WF and not t.magic and not HF and q<40 then
                                                            lF=I[UF];
                                                            for I=1,x(vF,UF,lF and t[lF]or 0),1 do
                                                                if q>=40 then
                                                                    break;
                                                                end;
                                                                local x=mF[I];
                                                                local cF,sF=YF(x,p,A,J,y,tF);
                                                                if cF then
                                                                    q+=1;
                                                                    local YF,VF=CF+I/1000,m(p,cF*tF,L,E);
                                                                    x=VF and VF.instance;
                                                                    if x and(x:IsDescendantOf(QF))then
                                                                        m7=true;
                                                                        local I=(VF.position-p).Magnitude;
                                                                        local eF,WF=G(gF,x.Name,I,0,M);
                                                                        if eF>=N(gF,I,M)then
                                                                            local D7=eF+JF+100000;
                                                                            if _F>b or _F==b and(D7>K or D7==K and YF<pF)then
                                                                                dF,wF=VF.position,VF.normal or w;
                                                                                b,K,pF,AF,MF,aF,BF,NF,IF,RF,nF,EF,PF,rF,LF,ZF,XF,qF=_F,D7,YF,gF,QF,vF,UF,eF,WF,true,cF,x,VF.material,0,nil,nil,I,p;
                                                                            else
                                                                            end;
                                                                        else
                                                                        end;
                                                                    else
                                                                        if GF and x and(_F>b or not(K>jF[FF]))then
                                                                            fF+=1;
                                                                            c[fF]=gF;
                                                                            H[fF]=QF;
                                                                            _[fF]=vF;
                                                                            s[fF]=cF;
                                                                            F[fF]=sF;
                                                                            v[fF]=YF;
                                                                            u[fF]=jF[FF];
                                                                            V[fF]=true;
                                                                            e[fF]=p;
                                                                            l[fF]=0;
                                                                        else
                                                                        end;
                                                                    end;
                                                                else
                                                                end;
                                                            end;
                                                        else
                                                        end;
                                                        if j and not m7 and not HF and(_F>b or not(K>DF[FF]))then
                                                            local x,I=B(kF,p,uF,E,xF);
                                                            for B=1,I,1 do
                                                                lF=C[x+B];
                                                                local x=uF-lF;
                                                                local I=x.Magnitude;
                                                                if I>=0.5 then
                                                                    if I<=tF+5 then
                                                                        local YF=x/I;
                                                                        local x=m(lF,YF*(I+5),L,E);
                                                                        local m,L=x.instance,CF+0.5+B/100;
                                                                        if m and(m:IsDescendantOf(QF))then
                                                                            local kF=(x.position-lF).Magnitude;
                                                                            local cF,HF=G(gF,m.Name,kF,0,M);
                                                                            if cF>=N(gF,kF,M)then
                                                                                local sF=cF+JF+100000-B*0.01;
                                                                                if _F>b or _F==b and(sF>K or sF==K and L<pF)then
                                                                                    local uF,VF=true,x.position;
                                                                                    wF=x.normal or w;
                                                                                    local eF,CF,WF,m7=x.material,0;
                                                                                    b,K,pF,AF,MF,aF,BF,NF,IF,RF,nF,EF,dF,PF,rF,LF,ZF,XF,qF=_F,sF,L,gF,QF,vF,UF,cF,HF,uF,YF,m,VF,eF,CF,WF,m7,kF,lF;
                                                                                else
                                                                                end;
                                                                            else
                                                                            end;
                                                                            break;
                                                                        elseif  GF and m and(_F>b or not(K>jF[FF]))then
                                                                            local m=fF+1;
                                                                            c[m]=gF;
                                                                            H[m]=QF;
                                                                            _[m]=vF;
                                                                            s[m]=YF;
                                                                            F[m]=I;
                                                                            v[m]=L;
                                                                            u[m]=jF[FF];
                                                                            V[m]=true;
                                                                            e[m]=lF;
                                                                            l[m]=B*0.01;
                                                                            fF=m;
                                                                        else
                                                                        end;
                                                                    else
                                                                    end;
                                                                else
                                                                end;
                                                            end;
                                                        else
                                                        end;
                                                    else
                                                    end;
                                                else
                                                end;
                                            else
                                            end;
                                        end;
                                    end;
                                    for m=1,fF,1 do
                                        zF=c[m];
                                        yF=OF and Y.picked[zF.UserId]and 1 or 0;
                                        local x,B=yF>=b and(yF>b or not(K>u[m]));
                                        if x then
                                            local I=V[m];
                                            B=if I then
                                                U<8
                                            else
                                                not I;
                                            else
                                                B=x;
                                            end;
                                            if B then
                                                U=if V[m]then
                                                    U+1
                                                else
                                                    U;
                                                    local B,I,L=H[m],s[m],e[m]or p;
                                                    local YF,kF,gF,QF=T(L,I,iF,E,B,F[m]);
                                                    x=YF and YF.instance;
                                                    if x then
                                                        local T=(YF.position-L).Magnitude;
                                                        local cF,HF=G(zF,x.Name,T,kF,M);
                                                        if cF>=(kF>0 and t.wall_min_damage or N(zF,T,M))then
                                                            local _F,sF=v[m],cF+JF-(l[m]or 0);
                                                            if yF>b or yF==b and(sF>K or sF==K and _F<pF)then
                                                                aF,dF,wF=_[m],YF.position,YF.normal or w;
                                                                b,K,pF,AF,MF,BF,NF,IF,RF,nF,EF,PF,rF,LF,ZF,XF,qF=yF,sF,_F,zF,B,UF,cF,HF,false,I,x,YF.material,kF,gF,QF,T,L;
                                                            else
                                                            end;
                                                        else
                                                        end;
                                                    else
                                                    end;
                                                else
                                                end;
                                            end;
                                            for m=1,fF,1 do
                                                c[m]=nil;
                                                H[m]=nil;
                                                _[m]=nil;
                                                s[m]=nil;
                                                F[m]=nil;
                                                v[m]=nil;
                                                u[m]=nil;
                                                V[m]=nil;
                                                e[m]=nil;
                                                l[m]=nil;
                                            end;
                                        end;
                                        if O.on and d~=0 and not aF then
                                            J,iF=#R,0;
                                            for m=1,a,1 do
                                                if iF>=12 then
                                                    break;
                                                end;
                                                y,GF=f[m],k[m];
                                                U=OF and Y.picked[y.UserId]and 1 or 0;
                                                if U>=b then
                                                    A=O.offset(GF,d);
                                                    if A.X~=0 or A.Y~=0 or A.Z~=0 then
                                                        j=g[m];
                                                        for m=1,J,1 do
                                                            if iF>=12 then
                                                                break;
                                                            end;
                                                            if U>b or not(K>KF[m])then
                                                                xF=R[m];
                                                                q=xF.group;
                                                                local m,Y=q==z and 1000000 or 0,xF.parts;
                                                                for T=1,#Y,1 do
                                                                    local x=Y[T];
                                                                    if hF[x]>-n then
                                                                        local Y=i.part(GF,x);
                                                                        if Y and(Y:IsA("BasePart"))then
                                                                            iF+=1;
                                                                            local B=Y.Position+A-p;
                                                                            local I=B.Magnitude;
                                                                            if I>0.5 and I<=tF+5 then
                                                                                local n=B/I;
                                                                                local B,L=O.hit(p,n,Y,A,I);
                                                                                local YF,UF,zF,JF,yF=B or I,0,0;
                                                                                local I,fF=LF,ZF;
                                                                                if t.magic then
                                                                                    LF,ZF=JF,yF;
                                                                                else
                                                                                    UF,zF,LF,ZF=O.path(p,n,YF,P,O.filter(E,GF));
                                                                                end;
                                                                                JF,B=G(y,x,YF,zF,M);
                                                                                yF=zF>0 and t.wall_min_damage or N(y,YF,M);
                                                                                if UF~=2 and JF>=yF then
                                                                                    local x,UF=JF+m,j*100+xF.slot+T;
                                                                                    if U>b or U==b and(x>K or x==K and UF<pF)then
                                                                                        b,K,pF,AF,MF,aF,BF,NF,IF,RF,nF,EF,dF,wF,PF,rF,XF,qF,TF=U,x,UF,y,GF,Y,q,JF,B,zF==0,n,Y,p+n*YF,L or-n,Y.Material,zF,YF,p,d;
                                                                                    else
                                                                                        LF,ZF=I,fF;
                                                                                    end;
                                                                                else
                                                                                    LF,ZF=I,fF;
                                                                                end;
                                                                            else
                                                                            end;
                                                                            break;
                                                                        end;
                                                                    end;
                                                                end;
                                                            else
                                                            end;
                                                        end;
                                                    else
                                                    end;
                                                else
                                                end;
                                            end;
                                        else
                                        end;
                                        if aF then
                                            if i.valid(AF,MF)then
                                                if not(aF:IsDescendantOf(MF))then
                                                    return nil;
                                                end;
                                            else
                                                return nil;
                                            end;
                                        else
                                            return nil;
                                        end;
                                        if O.on and d>0 and TF==0 and aF:IsA("BasePart")then
                                            U=O.offset(MF,d);
                                            if U.X~=0 or U.Y~=0 or U.Z~=0 then
                                                a=typeof(qF)=="Vector3"and qF or p;
                                                j=aF.Position+U-a;
                                                GF=j.Magnitude;
                                                if GF>0.5 and GF<=tF+5 then
                                                    q=j/GF;
                                                    R,z=O.hit(a,q,aF,U,GF);
                                                    y,J,iF,xF,A=R or GF,0,0;
                                                    local m,b=LF,ZF;
                                                    if t.magic then
                                                        LF,ZF=xF,A;
                                                    else
                                                        J,iF,LF,ZF=O.path(a,q,y,P,O.filter(E,MF));
                                                    end;
                                                    local K,i=G(AF,aF.Name,y,iF,M);
                                                    OF=iF>0 and t.wall_min_damage or N(AF,y,M);
                                                    if J~=2 and K>=OF then
                                                        TF,NF,IF,RF,nF,EF,dF,wF,PF,rF,XF,qF=d,K,i,iF==0,q,aF,a+q*y,z or-q,aF.Material,iF,y,a;
                                                    else
                                                        LF,ZF=m,b;
                                                    end;
                                                else
                                                end;
                                            else
                                            end;
                                        else
                                        end;
                                        d=nil;
                                        if LF then
                                            d={};
                                            j=0;
                                            for m=1,ZF-1,1 do
                                                J=LF[m];
                                                if J then
                                                    if J.instance then
                                                        A=j+1;
                                                        d[A]={Position=J.position,Instance=J.instance,Material=J.material and J.material.Name or"Plastic",Normal=J.normal or w,Exit=m%2==0};
                                                        j=A;
                                                    else
                                                    end;
                                                else
                                                end;
                                            end;
                                        else
                                            d=r;
                                        end;
                                        return{player=AF,char=MF,part=aF,shot={visible=RF,dir=nF,hit_part=EF,hit_pos=dF,normal=wF,material=PF,walls=rF,wall_hits=d,dist=XF,origin=qF},dmg=NF,armor_dmg=IF or 0,group=BF,lead=TF};
                                    end
                                };
                                h.teardown(function()o(f,0);
                                o(k,0);
                                o(g,0);
                                o(Q,0);
                                o(c,0);
                                o(H,0);
                                o(_,0);
                                o(s,0);
                                o(F,0);
                                o(v,0);
                                o(u,0);
                                o(V,0);
                                o(e,0);
                                o(l,0);
                                o(C,0);
                                table.clear(W);
                                o(mF,0);
                                o(Z,0);
                                table.clear(DF);
                                table.clear(jF);
                                table.clear(hF);
                                table.clear(bF);
                                table.clear(KF);
                                table.clear(SF);
                                table.clear(oF);
                                X=nil;
                            end);
                            return S;
                        end;
                        D.ao=function()local m=D.load("q").white;
                        return{on=false,team_check=true,auto_wall=false,boxes={head=true,chest=true,stomach=true,arms=true},prefer="head",min_damage=0,wall_min_damage=0,auto_revolver=false,auto_switch=false,hit_chance=70,draw_fov=false,fov_col=m,fov_grad=false,fov_col2=m,fov_fill=false,fov_fill_col=m,fov_fill_grad=false,fov_fill_col2=m};
                    end;
                    D.ap=function()local m,j=D.load("b"),D.load("a");
                    local h=D.load("h");
                    local b,K=D.load("j"),D.load("Z");
                    local S=D.load("ag");
                    local o=D.load("ao");
                    local t=D.load("al");
                    local G=D.load("aj");
                    local i=m.lp;
                    local Y=m.workspace;
                    local O=m.input;
                    local T,x=m.storage,m.clips;
                    local p=m.keyframes;
                    local A,M,a,B=m.getups,m.info,b.weapon,Enum.UserInputType.MouseButton2;
                    local N=math.max;
                    local I=math.min;
                    local R=math.clamp;
                    local n=math.huge;
                    local E=os.clock;
                    local d,w=m.plain,{};
                    local P=m.weak();
                    local r=m.weak();
                    local L,Z,X=m.weak(),0,0.03333333333333333;
                    local q=-n;
                    local U,z,J=-n,false;
                    m=type(a)=="table"and rawget(a,"startRevolverCharge")or nil;
                    if type(m)=="function"and type(A)=="function"and type(M)=="function"then a,b=pcall(A,m);
                    if a and type(b)=="table"then for y,y in b,nil,nil do
                        if type(y)=="function"and M(y,"n")=="completeRevolverChargeShot"then J=y;
                        break;
                    end;
                end;
            else
            end;
        else
        end;
        local function y(f)if type(f)~="table"then return nil;
    elseif  f.ShootingOptions~="Revolver"then return nil;
end;
local k=f.FireModes;
f=type(k)=="table"and k.Primary or nil;
if type(f)=="table"then if f.InputBehavior=="Charge"then return f;
end;
end;
return nil;
end;
local function f(k,g)local Q=k.Viewmodel;
k=type(Q)=="table"and Q.Animation or nil;
if type(k)~="table"then return nil;
end;
Q=g.Animation;
return type(Q)=="string"and k:getAnimation(Q)or nil or(k:getAnimation("Shoot"));
end;
local function k(g)local Q;
if g:IsA("KeyframeSequence")then
    local c=g:GetKeyframes();
    for H=1,#c,1 do
        local _=c[H];
        H=_:GetMarkers();
        for c=1,#H,1 do
            Q=if H[c].Name=="Shoot"then if Q then
                if _.Time<Q then
                    _.Time
                else
                    Q
                else
                    _.Time
                else
                    Q;
                end;
            end;
        else
            local c=g:GetDescendants();
            for g=1,#c,1 do
                local H=c[g];
                if H:IsA("MarkerCurve")then
                    g=H:GetMarkers();
                    for c=1,#g,1 do
                        local H=g[c];
                        Q=if H.Value=="Shoot"then if Q then
                            if H.Time<Q then
                                H.Time
                            else
                                Q
                            else
                                H.Time
                            else
                                Q;
                            end;
                        else
                        end;
                    end;
                end;
                return Q;
            end;
            local function g(Q,c,H)if not(Q)then
                return nil;
            end;
            local _,s=pcall(Q[c],Q,H);
            if _ then
                if typeof(s)~="Instance"then return nil;
            end;
        else
            return nil;
        end;
        _,Q=pcall(k,s);
        pcall(s.Destroy,s);
        if _ then
            if type(Q)=="number"then return Q;
        end;
    end;
    return nil;
end;
local function k(Q)local c=g(x,"GetAnimationClipAsync",Q)or g(p,"GetKeyframeSequenceAsync",Q);
if c then
    if j.alive()then
        w[Q]=c;
    end;
end;
end;
local function x(p)if type(p)=="string"then if p~=""then if w[p]==nil then
    w[p]=false;
    j.spawn(k,p);
end;
end;
end;
end;
A=T:FindFirstChild("Database");
b=A and(A:FindFirstChild("Custom"));
T=b and(b:FindFirstChild("Weapons"));
if T then
    b=T:GetChildren();
    for T=1,#b,1 do
        a=b[T];
        if a:IsA("ModuleScript")then
            A,M=pcall(require,a);
            T=A and y(M)or nil;
            m=T and M.CameraAnimations;
            if typeof(m)=="Instance"then local b=m:FindFirstChild(type(T.Animation)=="string"and T.Animation or"Shoot");
            if b then
                if b:IsA("Animation")then
                    x(b.AnimationId);
                end;
            end;
        end;
    end;
end;
end;
local function m(b,T)local p,A=N(tonumber(b.ChargeTime)or 0,0),T and T.Animation;
b=A and A.AnimationId;
x(b);
A=b and w[b];
if A then
    return N(p,A)+0.03333333333333333,A;
end;
return p+0.05,nil;
end;
local function b(T,x)P[T]=nil;
r[T]=nil;
L[T]=x;
if T.IsChargeFiring then
    d(T.cancelRevolverCharge,T,false);
end;
end;
local function T(x,p)if x.IsDestroyed then
    return false;
elseif  not(x.IsEquipped)then
    return false;
end;
if x.IsShooting then
    return false;
elseif  x.IsReloading then
    return false;
elseif  x.IsAdjustingSuppressor then
    return false;
elseif  x.IsAlternativeFireHeld then
    return false;
elseif  x.IsInspecting then
    return false;
end;
local A=x.Rounds;
if type(A)~="number"then return false;
elseif  A<=0 then
    return false;
end;
if p-(L[x]or-n)<0.05 then
    return false;
end;
if O:IsMouseButtonPressed(B)then
    return false;
elseif  Y:GetAttribute("GameState")=="Buy Period"then return false;
end;
if i:GetAttribute("IsDefusingBomb")==true then
    return false;
elseif  i:GetAttribute("IsLocallyDefusingBomb")==true then
    return false;
end;
if not(G.alive(i.Character))then
    return false;
end;
A=x.Viewmodel;
p=type(A)=="table"and A.Animation or nil;
A=type(p)=="table"and p:getAnimation("Equip")or nil;
p=A and A.Length or 0;
return(p>0 and p*0.925 or 0.5)<tick()-(tonumber(x.WeaponEquippedTick)or 0);
end;
local function Y(O)local x=O and P[O];
if x==nil then
    return nil,nil;
elseif  O.IsChargeFiring~=true then
    return nil,nil;
elseif  r[O]~=O.ChargeStartTick then
    return nil,nil;
end;
return x,tick()-(tonumber(O.ChargeStartTick)or 0);
end;
local function O(x)local p,A=Y(x);
return p~=nil and p-A<=0.05;
end;
local function x(p)if p-U<0.1 then
    local A=z;
    return A;
end;
U,z=p,false;
p=i.Character;
local A=p and(p:FindFirstChild("HumanoidRootPart"));
if not(A)then
    return false;
end;
local M,a,B=A.Position,h.all();
for h=1,B,1 do
    p=a[h];
    if p~=i then
        h=p.Character;
        if h then
            local i,A=G.valid(p,h);
            if i then
                if A then
                    if(A.Position-M).Magnitude<=50 then
                        z=true;
                        break;
                    end;
                end;
            end;
        end;
    end;
end;
B=z;
return B;
end;
local function h(G)local i=G-q<0.75 or x(G);
return i;
end;
local G={spot=function(i)q=i or E();
end,engage=function(i,x)x=x or(E());
q=x;
local p,A=Y(i);
if p then
    if p-A>0.05 then
        if not(K.held())then
            b(i,x);
        end;
    end;
end;
end,wait=function(i)local x,p=Y(i);
if not(x)then
    return nil,nil;
end;
return N(x-p,0),x;
end,ready=function(i)local x,p=Y(i);
i=x~=nil and p>=x and p<=x+X;
return i;
end,held=function(i)return Y(i)~=nil;
end,can_slam=function(i,Y)if i then
    if i.IsChargeFiring then
        return false;
    end;
else
    return false;
end;
return(Y or E())-(L[i]or-n)>=0.05;
end
};
G.fire=function(i)local Y=y(i.Properties);
if Y then
    if not(G.ready(i))then
        return false;
    end;
else
    return false;
end;
local x=f(i,Y);
Y=nil;
if J then
    Y=d(J,i);
else
    i.CurrentWalkSpeedOverride=nil;
    Y=d(i.shoot,i,"Primary");
end;
if not(i.IsChargeFiring)then
    P[i]=nil;
    r[i]=nil;
    if x then
        if x.Speed==0 then
            pcall(x.AdjustSpeed,x,1);
        end;
    end;
end;
return Y;
end;
G.slam=function(i)if not(G.can_slam(i,E()))then
    return false;
end;
return d(i.shoot,i,"Secondary");
end;
G.pull=function(i,Y)if G.ready(i)then
    return G.fire(i);
end;
if Y then
    return G.slam(i);
end;
return false;
end;
local function i(Y,x,p,A)local M=Y.ChargeShootConnection;
if M then
    pcall(M.Disconnect,M);
    Y.ChargeShootConnection=nil;
end;
M=Y.ChargeThread;
if M then
    pcall(task.cancel,M);
    Y.ChargeThread=nil;
end;
M=f(Y,x);
local a,B=m(x,M);
x=tick()-(tonumber(Y.ChargeStartTick)or 0);
P[Y]=a;
if M then
    local m,U=N((B or a)-0.01,0),M.TimePosition;
    if M.Speed~=0 then
        if U+p>=m then
            M:AdjustSpeed(0);
        end;
    end;
    if M.Speed==0 then
        local p=I(x,m);
        if U<p then
            M.TimePosition=p;
        elseif  U>m then
            M.TimePosition=p;
        end;
    end;
end;
if x<a then
    return;
end;
if K.held()then
    if G.fire(Y)then
        return;
    end;
end;
if Y.IsChargeFiring then
    if x>a+X then
        b(Y,A);
    end;
end;
end;
G.step=function()local m=E();
local Y=R((m-Z)*2,0.02,0.1);
Z=m;
X=R(Y,0.03333333333333333,0.05);
local x=t.ensure();
local t=x and y(x.Properties);
if not(t)then
    return;
end;
if x.IsChargeFiring then
    L[x]=m;
end;
local p,A=S.on and S.auto_revolver,o.on and o.auto_revolver;
local M=p or A;
M=if M and(if p then
    S.auto_switch
else
    not p)and(if A then
        o.auto_switch
    else
        not A)then
            if h(m)then
                false
            else
                M
            else
                M;
                if P[x]~=nil then
                    if x.IsChargeFiring~=true then
                        P[x]=nil;
                        r[x]=nil;
                    elseif  r[x]~=x.ChargeStartTick then
                        P[x]=nil;
                        r[x]=nil;
                    elseif  M then
                        i(x,t,Y,m);
                        return;
                    elseif  K.held()then
                        i(x,t,Y,m);
                        return;
                    elseif  O(x)then
                        i(x,t,Y,m);
                        return;
                    else
                        b(x,m);
                        return;
                    end;
                end;
                if M then
                    if not(x.IsChargeFiring)then
                        if T(x,m)then
                            if d(x.startRevolverCharge,x,nil)then
                                if x.IsChargeFiring then
                                    x.IsFireHeld=false;
                                    x.FireInputBinding=nil;
                                    r[x]=x.ChargeStartTick;
                                    L[x]=m;
                                    i(x,t,Y,m);
                                end;
                            end;
                        end;
                    end;
                end;
            end;
            j.teardown(function()for m in P,nil,nil do
                P[m]=nil;
                if m.IsChargeFiring then
                    if not(m.IsDestroyed)then
                        d(m.cancelRevolverCharge,m,false);
                    end;
                end;
            end;
            table.clear(r);
            table.clear(L);
            table.clear(w);
            q,z=-n,false;
        end);
        return G;
    end;
    D.aq=function()local m,j,h,b=D.load("b"),D.load("a"),D.load("j"),D.load("Z");
    local K=D.load("V");
    local S=D.load("M");
    local o=D.load("Y");
    local t=D.load("ag");
    local G=D.load("ah");
    local i=D.load("aj");
    local Y=D.load("al");
    local O=D.load("an");
    local T=D.load("ap");
    local x=D.load("g");
    local p=m.lp;
    local A=m.workspace;
    local M,a=m.info,m.plain;
    local B,N,I,R,n=h.weapon,h.bullet,h.camera,h.crosshair,h.remotes;
    local E=h.hints;
    local d=h.root_frame;
    local w,P=h.hit_flinch,h.fire_ready;
    local r=h.legit_ready;
    local L=table.pack;
    local Z=table.unpack;
    local X=math.max;
    local q=math.abs;
    local U,U,z,J=math.floor,L(),{tick=nil,seq=nil,id=nil};
    local y,f=h.mv_runtime,h.local_char;
    h=type(f)=="table"and rawget(f,"GetRemoteViewTick")or nil;
    if type(y)=="table"and type(h)=="function"and type(m.getups)=="function"then local k,g=pcall(m.getups,h);
    if k and type(g)=="table"then for k,k in g,nil,nil do
        if type(k)=="table"and getmetatable(k)==y then
            J=k;
            break;
        end;
    end;
else
end;
else
end;
local function k()local g=J and rawget(J,"_remoteClock");
if type(g)~="table"then return true;
end;
local Q,c,H=rawget(g,"_position"),rawget(g,"_latestTicks"),rawget(g,"_renderOffsetTicks");
if type(Q)~="number"then return true;
elseif  type(c)~="number"then return true;
elseif  type(H)~="number"then return true;
end;
return Q-H-c<=1;
end;
local function g(Q)local c=Q.VisualRoot;
if typeof(c)=="Vector3"then return c;
end;
c=Q.Actor;
if type(d)=="table"then local Q,H=pcall(d.simulationToVisualRootPosition,c.Position,c.DuckAmount);
if Q then
    if typeof(H)=="Vector3"then return H;
end;
end;
end;
return c.Position;
end;
local function d(Q,c)local H=#Q;
local _=Q[H];
local s,F=_.Actor.Generation,_.Actor.ActorId;
if c>=_.ServerTick then
    return g(_),_.Actor.LookYaw;
end;
for v=H-1,1,-1 do
    _=Q[v];
    if _.ServerTick<=c then
        local H=Q[v+1];
        if _.Actor.Generation~=s then
            return nil,nil;
        elseif  _.Actor.ActorId~=F then
            return nil,nil;
        elseif  H.Actor.Generation~=s then
            return nil,nil;
        elseif  H.Actor.ActorId~=F then
            return nil,nil;
        end;
        local Q=H.ServerTick-_.ServerTick;
        local s,F,v=Q>0 and(c-_.ServerTick)/Q or 0,_.Actor.LookYaw,H.Actor.LookYaw;
        return g(_):Lerp(g(H),s),F+((v-F+3.141592653589793)%6.283185307179586-3.141592653589793)*s;
    end;
end;
return nil,nil;
end;
local function g(Q)local c,H=J and rawget(J,"_remoteClock"),J and rawget(J,"_remoteBuffer");
if type(c)~="table"then return nil;
elseif  type(H)~="table"then return nil;
end;
local _,s=Q.player;
if x.is(_)then
    local x,F=_:GetAttribute("ActorId"),rawget(H,"_actorIdToKey");
    s=x~=nil and type(F)=="table"and F[x]or nil;
else
    s=if _ then
        _.UserId
    else
        s;
    end;
    _=rawget(H,"_actors");
    local x=s~=nil and type(_)=="table"and _[s]or nil;
    _=type(x)=="table"and x.Samples or nil;
    if type(_)~="table"then return nil;
elseif #_==0 then
    return nil;
end;
local s,F=pcall(J.getRemoteViewTick,J);
local J,v,u=rawget(H,"_latestServerTick"),rawget(c,"_latestAtSeconds"),rawget(c,"_hz");
if s then
    if type(F)~="number"then return nil;
elseif  type(J)~="number"then return nil;
elseif  type(v)~="number"then return nil;
elseif  type(u)~="number"then return nil;
end;
else
    return nil;
end;
c=_[#_];
s,H=c.ServerTick,x.Activity;
x=type(H)=="table"and H[#H]or nil;
s=if type(x)=="table"then if x.Active then
    if x.Generation==c.Actor.Generation then
        if x.ActorId==c.Actor.ActorId then
            if type(x.ServerTick)=="number"then if x.ServerTick>s then
                x.ServerTick
            else
                s
            else
                s
            else
                s
            else
                s
            else
                s
            else
                s;
                x=X(F,J+(p:GetNetworkPing()+X(os.clock()-v,0))*u-11);
                x=if x>s then
                    s
                else
                    x;
                    if q(x-F)<0.25 then
                        return nil;
                    end;
                    F,v,c=Q.char and i.part(Q.char,"HumanoidRootPart"),d(_,x);
                    if F then
                        if v then
                            if type(c)~="number"then return nil;
                        end;
                    else
                        return nil;
                    end;
                else
                    return nil;
                end;
                return x,CFrame.new(v)*CFrame.Angles(0,c,0)*F.CFrame:Inverse();
            end;
            local function x(d,J,Q)z.tick=nil;
            if d.rewound then
                return;
            elseif  J then
                if type(Q)~="number"then return;
            end;
        else
            return;
        end;
        d.rewound=true;
        local c=d.shot;
        if type(c)~="table"then return;
    elseif  typeof(c.origin)~="Vector3"then return;
elseif  typeof(c.hit_pos)~="Vector3"then return;
end;
local H,_=g(d);
if not(H)then
    return;
end;
d=_*c.hit_pos;
local g=d-c.origin;
local s=g.Magnitude;
if s<=0.001 then
    return;
end;
c.hit_pos=d;
c.dir=g/s;
c.dist=s;
if typeof(c.normal)=="Vector3"then c.normal=_:VectorToWorldSpace(c.normal);
end;
z.tick=H;
z.seq=Q;
z.id=J.Identifier;
end;
h=type(n)=="table"and n.Inventory or nil;
y=type(h)=="table"and h.ShootWeapon or nil;
if type(y)=="table"then if type(rawget(y,"Send"))=="function"then j.field(y,"Send",function(d)return function(J,...)o.mark();
local g=z.tick;
if g then
    z.tick=nil;
    if type(J)=="table"then if J.Seq==z.seq+1 then
        if J.Identifier==z.id then
            J.ViewTick=g;
        end;
    end;
end;
end;
return d(J,...);
end;
end);
end;
end;
if type(w)=="table"then h={"flickHead","flinchBody"};
for d,d in h,nil,nil do
    if type(rawget(w,d))=="function"then j.field(w,d,function(h)return function(...)if t.on then
        return;
    end;
    return h(...);
end;
end);
end;
end;
end;
local h={};
if type(I)=="table"then local d;
d=j.detour(rawget(I,"setWeaponRecoil"),function(...)if t.no_recoil then
    return nil;
end;
return d(...);
end);
local d;
d=j.detour(rawget(I,"weaponKick"),function(...)if t.no_recoil then
    return nil;
end;
return d(...);
end);
end;
if type(N)=="table"then local d;
d=j.detour(rawget(N,"getTrueSpread"),function(...)if t.no_spread then
    return 0;
end;
return d(...);
end);
end;
y=type(R)=="table"and rawget(R,"UpdateCrosshair")or nil;
if type(y)=="function"and type(m.getups)=="function"and type(M)=="function"then I,f=pcall(m.getups,y);
if I and type(f)=="table"then local m=UDim2.new();
for I,R in f,nil,nil do
    if type(R)=="function"then if M(R,"n")=="calculateRecoilOffset"then j.upvalue(y,I,function(...)if t.no_recoil then
        return m;
    end;
    return R(...);
end);
break;
end;
end;
end;
end;
end;
local function m(M,I)if b.manual[M]~=I then
    return;
end;
I.thread=nil;
local R=b.alive;
if(if R then
    I.generation~=b.generation
else
    not R)or not t.rapid or Y.held()~=M or not b.held()or not b.can_force(M,"rapid")then
        b.manual[M]=nil;
        b.last_target[M]=nil;
        return;
    end;
    R=o.wait(M);
    if R>0 then
        I.thread=task.delay(R+0.001,m,M,I);
        return;
    end;
    R=b.force(M,I.args,"rapid");
    if b.manual[M]~=I then
        return;
    elseif  I.generation~=b.generation then
        return;
    end;
    if not R then
        b.manual[M]=nil;
        b.last_target[M]=nil;
        return;
    end;
    b.last_shot=os.clock();
    I.thread=task.defer(m,M,I);
end;
local function M(I,R)if b.manual[I]then
    return;
elseif  b.alive then
    if not(t.rapid)then
        return;
    end;
else
    return;
end;
b.cancel();
if b.alive then
    if t.rapid then
        if Y.held()~=I then
            return;
        elseif  b.held()then
            if not(b.can_force(I,"rapid"))then
                return;
            end;
        else
            return;
        end;
    else
        return;
    end;
else
    return;
end;
local d={args=R,generation=b.generation,thread=nil};
b.manual[I]=d;
b.open_gate(I);
d.thread=task.defer(m,I,d);
end;
local function m(I,R)local d,w=I and I.Properties,A.CurrentCamera;
if d then
    if d.Class~="Weapon"then return nil;
elseif  w then
else
    return nil;
end;
else
    return nil;
end;
I=S.origin(w);
w=O.find(d,I,true,R);
if not w then
    return nil;
end;
return d,I,w;
end;
local function I(R,d,w,J)if b.alive then
    if not(t.double_tap)then
        return;
    end;
else
    return;
end;
if type(R.Rounds)~="number"then return;
elseif  R.Rounds<=0 then
    return;
end;
if b.manual[R]then
    return;
elseif  b.has_pending(R)then
    return;
end;
local y,f=b.generation;
f=task.defer(function()local g=b.alive;
if(if g then
    y~=b.generation
else
    not g)or not t.double_tap then
        b.pending[f]=nil;
        return;
    elseif  Y.held()~=R then
        b.pending[f]=nil;
        return;
    elseif  b.manual[R]then
        b.pending[f]=nil;
        return;
    end;
    g=o.wait(R);
    if g>0 then
        task.wait(g+0.001);
        local Q=b.alive;
        if(if Q then
            y~=b.generation
        else
            not Q)or not t.double_tap then
                b.pending[f]=nil;
                return;
            elseif  Y.held()~=R then
                b.pending[f]=nil;
                return;
            elseif  b.manual[R]then
                b.pending[f]=nil;
                return;
            end;
        end;
        g=false;
        if w or J then
            local y,Q,c;
            if J then
                y,Q,c=m(R,J);
            else
            end;
            if c then
            else
                y,Q,c=m(R);
            end;
            if c then
                b.bind(y,Q,c);
                g=true;
            else
                if w then
                    b.pending[f]=nil;
                    return;
                end;
            end;
        else
        end;
        if b.manual[R]then
            if g then
                b.unbind();
            end;
            b.pending[f]=nil;
            return;
        end;
        local w=b.force(R,d,"double");
        if g then
            b.unbind();
        end;
        b.pending[f]=nil;
        if w then
            b.last_shot=os.clock();
        end;
    end);
    b.pending[f]=R;
end;
Y.on_apply=function(R,d)if R and not t.double_tap then
    b.cancel();
elseif  d~=t.rapid then
    b.cancel();
end;
if d~=t.rapid then
    b.last_scan=0;
end;
if not(t.on)then
    G.clear();
end;
end;
if P then
    j.field(B,"shoot",function(R)return function(d,...)if b.alive then
        if b.forcing[d]then
            return R(d,...);
        end;
    else
        return R(d,...);
    end;
    if b.manual[d]then
        b.open_gate(d);
        b.last_target[d]=nil;
        return nil;
    end;
    local w=b.intent[d]==true;
    local J,y=t.rapid and not w and b.held(),L(...);
    b.last_target[d]=nil;
    local f,g,Q,c=tonumber(d.ShotSeq),tonumber(d.Rounds),L(R(d,...)),b.last_target[d];
    b.last_target[d]=nil;
    local R,H=tonumber(d.ShotSeq),tonumber(d.Rounds);
    local _=f and R and R>f;
    if _ or(if g then
        if H then
            H<g
        else
            _
        else
            _)then
                o.mark(d);
                if J then
                    M(d,y);
                else
                    I(d,y,w,c);
                end;
            end;
            return Z(Q,1,Q.n);
        end;
    end);
end;
local function M(I)local R=n and n.Inventory;
local n=R and R.ReloadWeapon;
if type(n)~="table"then return false;
elseif  type(n.Send)~="function"then return false;
end;
if I then
    if I.IsDestroyed then
        return false;
    elseif  I.IsEquipped~=true then
        return false;
    elseif  I.IsAdjustingSuppressor then
        return false;
    end;
else
    return false;
end;
local d=I.Properties;
if type(d)~="table"then return false;
elseif  d.Class~="Weapon"then return false;
elseif  d.RechargeTime then
    return false;
end;
local w,J,y=tonumber(d.Rounds),tonumber(I.Rounds),tonumber(I.Capacity);
if w then
    if J then
        if y then
            if J>=w then
                return false;
            end;
        else
            return false;
        end;
    else
        return false;
    end;
else
    return false;
end;
local f=I.Identifier;
if type(f)~="string"then return false;
end;
local g=A:GetAttribute("Gamemode")=="Deathmatch";
if y<=0 then
    if not(g)then
        return false;
    end;
end;
if I.IsChargeFiring then
    a(I.cancelRevolverCharge,I,false,false);
end;
local Q=R.CreateMagazine;
if type(Q)=="table"then if type(Q.Send)=="function"then pcall(Q.Send,f);
end;
end;
if not(pcall(n.Send,{Identifier=f,Rounds=J,Capacity=y}))then
    return false;
end;
if g and tonumber(d.ReloadAnimationCount)==1 then
    I.Rounds=w;
    I.Capacity=tonumber(d.Capacity)or y;
else
    Q=q(w-J);
    if y-Q>0 then
        I.Rounds=w;
        I.Capacity=X(0,y-Q);
    else
        I.Rounds=J+y;
        I.Capacity=0;
    end;
end;
I.CurrentReloadIdentity=nil;
I.IsReloading=false;
I.IsShooting=false;
I.CurrentWalkSpeedOverride=nil;
y=rawget(I,"ReloadTrackFinishedConnection");
if y then
    pcall(y.Disconnect,y);
    I.ReloadTrackFinishedConnection=nil;
end;
b.open_gate(I);
a(I.stopAllAnimations,I);
if E then
    if type(E.clearHint)=="function"then a(E.clearHint,E,"Reload");
end;
end;
return true;
end;
if P and type(B.reload)=="function"then j.field(B,"reload",function(B)return function(I,...)if t.insta_reload then
    if b.alive then
        local R,n=pcall(M,I);
        if R then
            if n then
                return;
            end;
        end;
    end;
end;
return B(I,...);
end;
end);
end;
local M={weapon=nil,seq=nil,at=0,target=false};
local function B(I)local R,n,E=I.char,I.part,I.shot;
I=type(E)=="table"and E.hit_part or nil;
return R~=nil and R.Parent~=nil and R:GetAttribute("Dead")==false and typeof(n)=="Instance"and n:IsDescendantOf(R)and typeof(I)=="Instance"and I:IsDescendantOf(R);
end;
local function I(R,n)local E=b.target;
if E then
    if b.props==R then
        if b.origin==n then
            if B(E)then
                if i.valid(E.player,E.char)then
                    return E;
                end;
            end;
        end;
    end;
end;
E=O.find(R,n,t.magic==true);
if E then
    if B(E)then
        return E;
    end;
end;
return nil;
end;
local function i(R,n,E)local d=A.CurrentCamera;
if not(d)then
    return R(n,E);
end;
local w,X=S.origin(d);
if not(X)then
    return R(n,E);
end;
X=d.CFrame;
d.CFrame=X.Rotation+w;
w=L(pcall(R,n,E));
d.CFrame=X;
if not(w[1])then
    error(w[2],0);
end;
return Z(w,2,w.n);
end;
if r then
    j.field(N,"_performRaycast",function(R)return function(n,E)if K.weapon then
        if n then
            if n.Weapon==K.weapon then
                if K.cframe then
                    local d=A.CurrentCamera;
                    if not(d)then
                        return R(n,0);
                    end;
                    local w=d.CFrame;
                    d.CFrame=K.cframe;
                    local K=L(pcall(R,n,0));
                    d.CFrame=w;
                    if not(K[1])then
                        error(K[2],0);
                    end;
                    return Z(K,2,K.n);
                end;
            end;
        end;
    end;
    local K=n and n.Properties;
    if t.on then
        if not(K)then
            return i(R,n,E);
        end;
    else
        return i(R,n,E);
    end;
    local d=A.CurrentCamera;
    if not(d)then
        return R(n,E);
    end;
    local w=n.Weapon;
    local L,Z=w and tonumber(w.ShotSeq),os.clock();
    local X;
    if w and M.weapon==w and M.seq==L and Z-M.at<0.02 then
        X=M.target;
        X=X and(if B(X)then
            X
        else
            false);
        else
            X=I(K,(S.origin(d)))or false;
            M.weapon=w;
            M.seq=L;
            M.at=Z;
            if X then
                x(X,w,L);
            end;
        end;
        M.target=X;
        if not(X)then
            return i(R,n,E);
        end;
        L=X.shot;
        K=L.hit_part;
        Z=K:IsA("BasePart");
        if(if Z then
            typeof(L.hit_pos)~="Vector3"else not Z)or typeof(L.dir)~="Vector3"or L.dir.Magnitude<=1.0E-4 or typeof(L.normal)~="Vector3"or type(L.dist)~="number"or L.dist~=L.dist or L.dist<=0 or type(L.wall_hits)~="table"then M.target=false;
            z.tick=nil;
            return i(R,n,E);
        end;
        Z=typeof(L.origin)=="Vector3"and L.origin or S.origin(d);
        d=L.hit_pos-Z;
        local x=d.Magnitude;
        if x<=1.0E-4 or q(x-L.dist)>0.05 or d.Unit:Dot(L.dir.Unit)<0.999 then
            M.target=false;
            z.tick=nil;
            return i(R,n,E);
        end;
        E,n,x={},L.wall_hits,0;
        for i=1,#n,1 do
            x+=1;
            E[x]=n[i];
        end;
        n=if typeof(L.material)=="EnumItem"then L.material.Name
    else
        if typeof(K.Material)=="EnumItem"then K.Material.Name else"Plastic";
        E[x+1]={Position=L.hit_pos,Instance=K,Material=n,Normal=L.normal,Exit=false};
        if w then
            b.last_target[w]=X.char;
        end;
        G.reserve(X);
        return{Distance=L.dist,Origin=Z,Direction=L.dir,Hits=E};
    end;
end);
j.field(N,"setActive",function(j)return function(K,G)if G then
    b.cancel();
    Y.adopt(K.Weapon);
    b.intent[K.Weapon]=nil;
    Y.activate(K.Weapon);
elseif  K.Weapon==Y.weapon then
    b.intent[K.Weapon]=nil;
    b.cancel();
    Y.adopt(nil);
    Y.activate(nil);
end;
return j(K,G);
end;
end);
end;
local function j(K)if A:GetAttribute("GameState")=="Buy Period"then return false;
end;
if p:GetAttribute("IsDefusingBomb")==true then
    return false;
elseif  p:GetAttribute("IsLocallyDefusingBomb")==true then
    return false;
end;
local G=K.Viewmodel;
local i=type(G)=="table"and G.Animation or nil;
if type(i)~="table"then return true;
elseif  type(i.getAnimation)~="function"then return true;
end;
local G,x=pcall(i.getAnimation,i,"Equip");
i=G and x and tonumber(x.Length)or 0;
return tick()-(tonumber(K.WeaponEquippedTick)or 0)>i*0.925;
end;
h.auto=function()if r then
    if t.on then
        if not(t.auto_shoot)then
            return;
        end;
    else
        return;
    end;
else
    return;
end;
if b.held()then
    return;
elseif  not(k())then
    return;
end;
local K,G=os.clock(),Y.held();
if G then
    if b.manual[G]then
        return;
    end;
else
    return;
end;
local i=G.Properties;
if i then
    if i.Class~="Weapon"then return;
end;
else
    return;
end;
if P then
    if t.rapid then
        if b.can_force(G,"rapid")then
            if o.wait(G,i,K)>0 then
                return;
            end;
            if K-b.last_scan<0.033 then
                return;
            end;
            b.last_scan=K;
            local Y,x,p=m(G);
            if not(p)then
                return;
            end;
            b.bind(Y,x,p);
            p=b.force(G,U,"rapid");
            b.unbind();
            if p then
                b.last_shot=K;
            end;
            return;
        end;
    end;
end;
if G.IsAdjustingSuppressor then
    return;
elseif  G.IsReloading then
    if i.MuzzleType~="ShotGun"then return;
end;
end;
if G.Rounds then
    if G.Rounds<=0 then
        return;
    end;
else
    return;
end;
local m,Y=i.ShootingOptions=="Revolver",t.auto_revolver;
local x,p=if Y then
    t.auto_switch
else
    not Y,false;
    if m then
        if G.IsShooting then
            return;
        end;
        if T.ready(G)then
        else
            if x and T.can_slam(G,K)then
            else
                if x then
                    if not(T.held(G))then
                        return;
                    end;
                else
                    return;
                end;
                p=true;
            end;
        end;
    else
    end;
    if o.wait(G,i,K)>0 then
        return;
    elseif  not(j(G))then
        return;
    end;
    Y=A.CurrentCamera;
    if not Y then
        return;
    end;
    local j=S.origin(Y);
    Y=O.find(i,j,true);
    if not Y then
        return;
    end;
    if t.auto_scope then
        if i.HasScope then
            if not(G.IsAiming)then
                if type(G.scope)=="function"then b.open_gate(G);
                a(G.scope,G,true);
                if G.IsAiming then
                    return;
                end;
            end;
        end;
    end;
end;
if m then
    if p then
        T.engage(G,K);
        return;
    end;
    T.spot(K);
end;
b.bind(i,j,Y);
b.open_gate(G);
Y,j=tonumber(G.ShotSeq),tonumber(G.Rounds);
b.intent[G]=true;
i=if m then
    T.pull(G,x)
else
    a(G.shoot,G);
    b.intent[G]=nil;
    b.unbind();
    x,m=tonumber(G.ShotSeq),tonumber(G.Rounds);
    G=Y and x and x>Y;
    G=G or(if j then
        if m then
            m<j
        else
            G
        else
            G);
            if i then
                if G then
                    b.last_shot=K;
                end;
            end;
        end;
        return h;
    end;
    D.ar=function()local m=D.load("b");
    local j=D.load("a");
    local h=Color3.new(1,1,1);
    local b,K=math.floor,{};
    K.__index=K;
    K.new=function(S)return setmetatable({order=S or 999},K);
end;
K.build=function(S)local o=S.gui;
if o then
    if o.Parent then
        return true;
    end;
end;
o=m.screen(S.order);
if not(o)then
    return false;
end;
j.own(o);
local m=Instance.new("Frame");
m.BackgroundColor3=h;
m.BackgroundTransparency=1;
m.BorderSizePixel=0;
m.AnchorPoint=Vector2.new(0.5,0.5);
m.Visible=false;
m.ZIndex=1;
m.Parent=o;
local j=Instance.new("UICorner");
j.CornerRadius=UDim.new(1,0);
j.Parent=m;
j=Instance.new("UIGradient");
j.Enabled=false;
j.Rotation=0;
j.Parent=m;
local t=Instance.new("UIStroke");
t.ApplyStrokeMode=Enum.ApplyStrokeMode.Border;
t.Thickness=1;
t.Color=h;
t.LineJoinMode=Enum.LineJoinMode.Round;
t.Parent=m;
local G=Instance.new("UIGradient");
G.Enabled=false;
G.Rotation=0;
G.Parent=t;
S.gui=o;
S.frame=m;
S.stroke=t;
S.edge=G;
S.fill=j;
S.size=nil;
S.x=nil;
S.y=nil;
S.col=nil;
S.col2=nil;
S.grad=nil;
S.filled=nil;
S.fcol=nil;
S.fcol2=nil;
S.fgrad=nil;
S.shown=nil;
return true;
end;
K.hide=function(m)local j=m.frame;
if j then
    if m.shown~=false then
        j.Visible=false;
        m.shown=false;
    end;
end;
end;
K.show=function(m,j,S,o,t)if o~=o then
    m:hide();
    return;
elseif  o<=0.5 then
    m:hide();
    return;
end;
if not(m:build())then
    return;
end;
local G,i,Y=m.frame,m.stroke,b(o*2+0.5);
if Y~=m.size then
    m.size=Y;
    G.Size=UDim2.fromOffset(Y,Y);
end;
if j~=m.x or S~=m.y then
    m.x=j;
    m.y=S;
    G.Position=UDim2.fromOffset(j,S);
end;
S,Y,j=t.fov_col,t.fov_col2,t.fov_grad==true;
if j~=m.grad then
    m.grad=j;
    m.col=nil;
    m.col2=nil;
    m.edge.Enabled=j;
    if j then
        i.Color=h;
    end;
end;
if j then
    if S~=m.col or Y~=m.col2 then
        m.col=S;
        m.col2=Y;
        m.edge.Color=ColorSequence.new(S,Y);
    end;
elseif  S~=m.col then
    m.col=S;
    i.Color=S;
end;
j=t.fov_fill==true;
S=j and t.fov_fill_grad==true;
if j~=m.filled or S~=m.fgrad then
    m.filled=j;
    m.fgrad=S;
    m.fcol=nil;
    m.fcol2=nil;
    m.fill.Enabled=S;
    G.BackgroundTransparency=j and 0.65 or 1;
    if S then
        G.BackgroundColor3=h;
    end;
end;
if j then
    o,i=t.fov_fill_col,t.fov_fill_col2;
    if S then
        if o~=m.fcol or i~=m.fcol2 then
            m.fcol=o;
            m.fcol2=i;
            m.fill.Color=ColorSequence.new(o,i);
        end;
    elseif  o~=m.fcol then
        m.fcol=o;
        G.BackgroundColor3=o;
    end;
end;
if m.shown~=true then
    G.Visible=true;
    m.shown=true;
end;
end;
K.destroy=function(m)local j=m.gui;
if j then
    pcall(j.Destroy,j);
end;
m.gui=nil;
m.frame=nil;
m.stroke=nil;
m.edge=nil;
m.fill=nil;
m.shown=nil;
end;
return K;
end;
D.as=function()local m,j,h,b=D.load("b"),D.load("a"),D.load("ar"),D.load("ag");
local K=D.load("al");
local S=m.workspace;
local o=math.tan;
local t=math.rad;
local G=h.new(999);
local function h()local i=K.weapon;
if i then
    if i.IsDestroyed then
        return false;
    elseif  not(i.IsEquipped)then
        return false;
    end;
else
    return false;
end;
local K=i.Properties;
if K then
    if K.Class~="Weapon"then return false;
end;
else
    return false;
end;
return i.Name~="Zeus x27";
end;
m={step=function()if b.on then
    if b.draw_fov then
        if not(h())then
            G:hide();
            return;
        end;
    else
        G:hide();
        return;
    end;
else
    G:hide();
    return;
end;
local h=S.CurrentCamera;
if not(h)then
    return;
end;
local K=tonumber(b.fov)or 0;
if K<=0 then
    G:hide();
    return;
elseif  K>=360 then
    G:hide();
    return;
end;
local S=h.ViewportSize;
local i=o(t(K*0.5))*(S.Y*0.5)/o(t(h.FieldOfView*0.5));
G:show(S.X*0.5,S.Y*0.5,i,b);
end,unload=function()G:destroy();
end
};
j.teardown(m.unload);
return m;
end;
D.at=function()local m,j=D.load("a"),D.load("al");
local h,b=D.load("ao"),{active=nil,weapon=nil,ui=nil};
b.apply=function(K)local S=b.ui;
if not S then
    return;
end;
local function o(t)return S:get("trig."..t,K);
end;
local S=K~=nil;
h.on=S and o("on")or false;
h.team_check=o("team");
h.auto_wall=S and o("aw")or false;
h.auto_revolver=S and o("autorev")or false;
h.auto_switch=S and o("autoswitch")or false;
h.boxes=j.boxes(o("hb"));
h.prefer=o("prefer");
h.min_damage=o("mindmg");
h.wall_min_damage=o("awmindmg");
h.hit_chance=o("hc");
h.draw_fov=S and o("dfov")or false;
h.fov_col=o("dfov_col");
h.fov_grad=o("dfov_grad");
h.fov_col2=o("dfov_col2");
h.fov_fill=o("dfov_fill");
h.fov_fill_col=o("dfov_fcol");
h.fov_fill_grad=o("dfov_fgrad");
h.fov_fill_col2=o("dfov_fcol2");
end;
b.refresh=function()b.apply(b.active);
end;
b.activate=function(K)local S=j.find_type(K);
if b.weapon==K then
    if b.active==S then
        return;
    end;
end;
b.weapon=K;
b.active=S;
b.apply(S);
end;
m.teardown(function()b.weapon=nil;
b.active=nil;
b.ui=nil;
h.on=false;
h.draw_fov=false;
end);
return b;
end;
D.au=function()local m,j,h=D.load("b"),D.load("j"),D.load("ag");
local b,K,S=j.camera,m.getups,math.rad;
local o=math.min;
local t=math.max;
local G=math.clamp;
local i,Y,O,T=Vector3.zero;
m,j=type(b)=="table"and rawget(b,"toWeaponFirePosition")or nil,type(b)=="table"and rawget(b,"getWeaponKickRotation")or nil;
if type(m)=="function"and type(j)=="function"and type(K)=="function"then local x,p=pcall(K,m);
local m,A=pcall(K,j);
if x and m and type(p)=="table"and type(A)=="table"then b=nil;
for m,m in A,nil,nil do
    if type(m)=="table"then b=m;
    break;
end;
end;
for m,m in p,nil,nil do
    if type(m)=="function"then Y=m;
else
    if type(m)=="table"and rawget(m,"p")~=nil and rawget(m,"d")~=nil then
        if m==b then
            O=m;
        else
            T=m;
        end;
    else
    end;
end;
end;
else
end;
else
end;
local m={ok=false,origin=i};
m.dir=Vector3.zAxis;
m.up=Vector3.yAxis;
m.right=Vector3.xAxis;
m.half=0;
local function j(b)if Y then
    if O then
        if T then
            local K,x=O.p,T.p;
            O.p,T.p=i,i;
            local i,p=pcall(Y,1);
            O.p,T.p=K,x;
            if i then
                if typeof(p)=="CFrame"then return p;
            end;
        end;
    end;
end;
end;
return b.CFrame;
end;
local function b(K,i,Y)local O=K.Bullet;
if type(O)~="table"then return nil;
elseif  O.IsDestroyed then
    return nil;
end;
local T,x=i.Spread,i.FireModes;
if type(x)=="table"then local p=x.Primary;
p=if i.ShootingOptions=="Revolver"then if Y then
    p
else
    x.Secondary or p
else
    p;
    T=if type(p)=="table"then if type(p.Spread)=="table"then p.Spread
else
    T
else
    T;
else
end;
Y=type(T)=="table"and T.Range;
if typeof(Y)~="NumberRange"then return nil;
end;
local p,A=pcall(O.getBaseSpreadForConfig,O,T);
local M,a=pcall(O.getMovementSpreadForConfig,O,T);
if p then
    if M then
        if type(A)~="number"then return nil;
    elseif  type(a)~="number"then return nil;
end;
else
    return nil;
end;
else
    return nil;
end;
M,p=tonumber(T.MovementMultiplier)or 1,i.AimingOptions=="SniperScope";
x=M==2 and 6 or M==3 and 12 or 15;
M=if h.no_spread and O:getTrueSpread()==0 then
    0
else
    (if p then
        if K.IsAiming then
            A
        else
            if A<x then
                G(x,Y.Min,Y.Max)
            else
                A
            else
                A)+a;
                return o(if p then
                    if K.IsAiming then
                        if K.Name=="AWP"then if tick()-(tonumber(K.ScopeStartTick)or 0)<0.2 then
                            t(M,x)
                        else
                            M
                        else
                            M
                        else
                            M
                        else
                            M,69);
                        end;
                        m.update=function(h,K,o,t)local G=b(h,K,t);
                        if not(G)then
                            m.ok=false;
                            return false;
                        end;
                        h=j(o);
                        m.origin=h.Position;
                        m.dir=h.LookVector;
                        m.up=h.UpVector;
                        m.right=h.RightVector;
                        m.half=S(G*0.5);
                        m.ok=true;
                        return true;
                    end;
                    return m;
                end;
                D.av=function()local m=D.load("b");
                local j,h,b=D.load("f"),D.load("a"),D.load("h");
                local K,S=D.load("j"),D.load("Z");
                local o,t=D.load("L"),D.load("M");
                local G,i=D.load("ai"),D.load("ah");
                local Y=D.load("aj");
                local O=D.load("al");
                local T=D.load("ap");
                local x=D.load("ao");
                local p=D.load("at");
                local A=D.load("au");
                local M=m.lp;
                local a=m.workspace;
                local B=o.probe;
                local N=o.through;
                local o=K.ray_ignore;
                local I=K.fire_ready;
                local K=j.trim;
                local j=G.groups;
                local R=G.group_of;
                local n=G.damage_key;
                local E=G.teams;
                local G=os.clock;
                local d=math.sin;
                local w=math.cos;
                local P=math.tan;
                local r=math.asin;
                local L=math.acos;
                local Z=math.min;
                local X=math.max;
                local q=math.clamp;
                local U=math.ceil;
                local z=math.huge;
                local J=Vector3.zero;
                local y=RaycastParams.new();
                y.FilterType=Enum.RaycastFilterType.Exclude;
                y.IgnoreWater=false;
                y.CollisionGroup="Bullet";
                local f=m.weak();
                local k=m.weak();
                local g,Q,c=m.weak(),{};
                local H,_,s,F=0;
                local v,u,V,e,l=0,0,0,1;
                local C,W,mF=0,J;
                local DF,jF=0,{};
                local function hF()local bF,KF=G(),M.Character;
                if c then
                    if KF==_ then
                        if bF-H<0.5 then
                            local SF=c;
                            return SF;
                        end;
                    end;
                end;
                H,_=bF,KF;
                if type(o)=="function"then local H,bF=pcall(o);
                if H then
                    if type(bF)=="table"then c=bF;
                    return bF;
                end;
            end;
        end;
        local o,H,bF=0,a.CurrentCamera,a:FindFirstChild("Debris");
        if H then
            o=1;
            Q[o]=H;
        else
        end;
        if bF then
            o+=1;
            Q[o]=bF;
        else
        end;
        if KF then
            o+=1;
            Q[o]=KF;
        else
        end;
        c=K(Q,o);
        KF=c;
        return KF;
    end;
    local function o(H)local bF=k[H];
    if bF~=nil then
        return bF,g[H];
    end;
    local bF,KF=i.effective_armor(H);
    k[H]=bF;
    g[H]=KF;
    return bF,KF;
end;
local function i(H,bF,KF,SF)local oF=s;
local tF=oF.DamagePerPart;
local GF=type(tF)=="table"and tF[bF]or 0;
if type(GF)~="number"then return 0;
elseif  GF<=0 then
    return 0;
end;
tF=GF*(tonumber(oF.RangeModifier)or 1)^X(0,KF/100);
tF=if SF>0 then
    tF*(tonumber(oF.WallbangMultiplier)or 1)
else
    tF;
    KF,SF=o(H);
    if KF>0 and(bF~="Head"or SF)then
        GF=tF*q(tonumber(oF.ArmorPenetration)or 1,0,1);
        tF=(X(0,if(tF-GF)*0.5>KF then
            tF-KF/0.5
        else
            GF));
        else
        end;
        KF=e;
        return tF*KF;
    end;
    local function o(H)local bF=H.Name;
    H=R[bF];
    if H then
        return H,n[bF];
    end;
    if bF=="HumanoidRootPart"then H=F.chest and"chest"or"stomach";
    return H,"Torso";
end;
return nil,nil;
end;
local function R(n)return n.Transparency>0 or n.LocalTransparencyModifier>0;
end;
local function n(H,bF,KF,SF,oF,tF)local GF=H.Parent;
H=f[GF];
if H then
    if not(F[bF])then
        return nil;
    end;
else
    return nil;
end;
if i(H,KF,SF,oF)<(tF and x.min_damage or x.wall_min_damage)then
    return nil;
end;
return GF,bF,SF;
end;
local function i(H,bF)local KF=B(H,bF*v,y,c);
local B=KF.instance;
if not(B)then
    return nil;
end;
local y,SF,oF=KF.position,o(B);
if SF then
    return n(B,SF,oF,(y-H).Magnitude,0,true);
end;
y,SF=x.auto_wall,R(B);
if SF then
elseif  y then
else
    return nil;
end;
oF,KF=N(H,bF,V,c,nil,u),0;
for N=1,#oF,2 do
    bF=oF[N];
    B=bF.instance;
    if B then
        local N,oF=o(B);
        if N then
            return n(B,N,oF,(bF.position-H).Magnitude,KF,SF);
        end;
        KF+=1;
        if SF then
            if R(B)then
            else
                if not y then
                    return nil;
                end;
                SF=false;
            end;
        else
        end;
    else
    end;
end;
return nil;
end;
local function o(B,N,R,n)if N:IsDescendantOf(a)then
    if N:GetAttribute("Dead")~=false then
        return false;
    elseif  N:GetAttribute("Invincible")==true then
        return false;
    end;
else
    return false;
end;
if B:GetAttribute("Invincible")==true then
    return false;
elseif  B:GetAttribute("Dead")==true then
    return false;
end;
local y=N:GetAttribute("Health");
if typeof(y)~="number"then return false;
elseif  y<=0 then
    return false;
elseif  Y.shielded(N)then
    return false;
end;
if x.team_check then
    y=B:GetAttribute("Team");
    if R then
        if y then
            if E[R]then
                if not(E[y])then
                    return false;
                end;
            else
                return false;
            end;
        else
            return false;
        end;
    else
        return false;
    end;
    if not(n)then
        if R==y then
            return false;
        end;
    end;
end;
return true;
end;
local function B(N,R,n)table.clear(f);
local E,y,H,bF,KF=v+5,M:GetAttribute("Team"),a:GetAttribute("Gamemode")=="Deathmatch",b.all();
local b,SF,oF=0,z,0;
for z=1,KF,1 do
    local KF=bF[z];
    if KF~=M then
        z=KF.Character;
        local bF=z and Y.part(z,"HumanoidRootPart");
        if bF then
            local tF=bF.Position-N;
            local N=tF.Magnitude;
            if N>0.5 then
                if N<=E then
                    local E=L(q(R:Dot(tF)/N,-1,1));
                    if E<=n+r(Z(1,4.5/N))then
                        if o(KF,z,y,H)then
                            f[z]=KF;
                            b=if N>b then
                                N
                            else
                                b;
                                if E<SF then
                                    SF,oF=E,N;
                                else
                                end;
                            else
                            end;
                        else
                        end;
                    else
                    end;
                else
                end;
            else
            end;
        else
        end;
    end;
    return b,oF;
end;
local function b(o,N,R,n,E,z)local y,H,bF,KF,SF=A.up,A.right,d(R),w(R),true;
for oF=1,n,1 do
    R=(oF-E)*6.283185307179586/n;
    local n,n=i(o,N*KF+(y*w(R)+H*d(R))*bF);
    if not(n)then
        return false,false;
    end;
    SF=if n~=z then
        false
    else
        SF;
    end;
    return true,SF;
end;
local function o(N,R,n,E,z,y,H)local bF,KF,SF,oF=A.up,A.right,z-1.0E-6,q(U(E*P(n)/0.3),2,6);
local tF,GF,iF,YF=1/oF,1,0;
z=0;
for OF=oF,1,-1 do
    local oF=(OF-0.5)*n*tF;
    local n,TF,xF=d(oF),w(oF),q(U(E*P(oF)*6.283185307179586/0.3),6,24);
    local E,pF=tF/xF,OF%2*0.5;
    for tF=1,xF,1 do
        OF=(tF-pF)*6.283185307179586/xF;
        GF-=E;
        tF,oF=i(N,R*TF+(bF*w(OF)+KF*d(OF))*n);
        if tF then
            iF,YF,z=iF+E,YF or tF,if oF==y then
                z+E
            else
                z;
            else
            end;
            if iF+GF<SF then
                return nil,false;
            end;
            if H then
                if z>=SF then
                    return YF,true;
                elseif  iF>=SF then
                    if z+GF<SF then
                        return YF,false;
                    end;
                end;
            elseif  iF>=SF then
                return YF,true;
            end;
        end;
    end;
    if iF>=SF then
        return YF,if H then
            z>=SF
        else
            not H;
        end;
        return nil,false;
    end;
    local function N(R)local n=G();
    local E=n-C;
    if l then
        if E>0 then
            if E<0.1 then
                local d=W;
                W=d:Lerp(l:Cross(R)/E,Z(E/0.05,1));
            else
                W=J;
            end;
        else
            W=J;
        end;
    else
        W=J;
    end;
    l,C=R,n;
end;
local function R(n,E,d,w,z,y)local H,C,bF,KF,SF=W:Cross(d),w*y,j[z],0.15;
for j=1,#bF,1 do
    y=Y.part(n,bF[j]);
    if y then
        w=y.Position-E;
        j=w.Magnitude;
        if j>0.5 then
            local oF=y.Size;
            local tF=r(Z(1,Z(oF.X,oF.Y,oF.Z)*0.5/j));
            if tF>=C then
                oF=w/j;
                local j=q(d:Dot(oF),-1,1);
                local w,r=L(j)+C-tF,oF-d*j;
                j=r.Magnitude;
                if w>0 then
                    if j>1.0E-6 then
                        local d=H:Dot(r)/j;
                        if d>0 then
                            if w<=KF*d then
                                local j=w/d;
                                KF,SF=j,oF;
                            else
                            end;
                        else
                        end;
                    else
                    end;
                else
                end;
            else
            end;
        else
        end;
    else
    end;
end;
if not(SF)then
    mF=nil;
    return false;
end;
H=G();
if mF then
    if H-DF>0.1 then
        mF=H;
    end;
else
    mF=H;
end;
DF=H;
if H-mF+KF>0.15 then
    return false;
end;
bF,y=i(E,SF);
return bF==n and y==z;
end;
local function j(n,E,d)local w,r,L,Z=A.dir,A.half,t.origin(d);
L,s=if Z then
    L
else
    A.origin,n;
    F=x.boxes;
    v=tonumber(n.Range)or 500;
    d,Z=B(L,w,r);
    if d<=0 then
        return false;
    end;
    table.clear(k);
    table.clear(g);
    hF();
    u=d+6;
    V=tonumber(n.Penetration)or 0;
    e=X(tonumber(n.BulletsPerShot)or 1,1);
    n=x.prefer;
    local t,B,z,y=F[n]==true,i(L,w);
    d=y or Z;
    y=d*P(r);
    if E>=0.999999 or y<=0.02 then
        if not(B)then
            return false;
        end;
        Z=z==n;
        if y>0.02 then
            local i=q(U(y*6.283185307179586/0.3),6,24);
            local P,H=b(L,w,r,i,0,n);
            if not(P)then
                return false;
            end;
            Z=Z and H;
            if y>0.45 then
                H,P=b(L,w,r*0.5,X(4,U(i*0.5)),0.5,n);
                if not H then
                    return false;
                end;
                Z=Z and P;
            else
            end;
        else
        end;
        if Z then
            return true;
        elseif  t then
        else
            return true;
        end;
        return not R(B,L,w,r,n,E);
    end;
    z,Z=o(L,w,r,d,E,n,t);
    if not z then
        return false;
    end;
    if Z then
        return true;
    end;
    return not R(B or z,L,w,r,n,E);
end;
local function b(o,t)if o.IsShooting then
    return false;
elseif  o.IsBurstShooting then
    return false;
elseif  o.IsAdjustingSuppressor then
    return false;
end;
if o.IsChargeFiring then
    if not(T.held(o))then
        return false;
    end;
end;
if o.IsReloading then
    if t.MuzzleType~="ShotGun"then return false;
end;
end;
t=o.Rounds;
if type(t)~="number"then return false;
elseif  t<=0 then
    return false;
end;
if S.manual[o]then
    return false;
elseif  S.forcing[o]then
    return false;
elseif  S.has_pending(o)then
    return false;
end;
return not S.held();
end;
local function o(t,i,B)local R,n,E,d,w=tonumber(t.ShotSeq),tonumber(t.Rounds),if B then
    T.fire(t)
else
    if i.ShootingOptions=="Revolver"then T.slam(t)
else
    m.plain(t.shoot,t),tonumber(t.ShotSeq),tonumber(t.Rounds);
    t=R and d and d>R;
    t=t or(if n then
        if w then
            w<n
        else
            t
        else
            t);
            if E then
                if t then
                    S.last_shot=G();
                end;
            end;
        end;
        local function m()if not(I)then
            return false;
        end;
        local t=O.ensure();
        p.activate(t);
        if x.on then
            if not(t)then
                return false;
            end;
        else
            return false;
        end;
        local i=t.Properties;
        if type(i)~="table"then return false;
    elseif  i.Class~="Weapon"then return false;
elseif  t.Name=="Zeus x27"then return false;
end;
local O=a.CurrentCamera;
if O then
    if not(Y.alive(M.Character))then
        return false;
    end;
else
    return false;
end;
local Y,p,M=i.ShootingOptions=="Revolver",x.auto_revolver and not x.auto_switch,T.ready(t);
local a=(if M then
    not M
else
    Y)and(p or not T.can_slam(t,G()));
    if not(A.update(t,i,O,M or a))then
        return false;
    end;
    N(A.dir);
    local B=q((tonumber(x.hit_chance)or 100)*0.01,0.01,1);
    if a then
        if not(p)then
            if T.held(t)then
                if not(S.held())then
                    if j(i,B,O)then
                        T.engage(t,G());
                    end;
                end;
            end;
        end;
        return true;
    end;
    if b(t,i)then
        if j(i,B,O)then
            if Y then
                T.spot(G());
            end;
            o(t,i,M);
        end;
    end;
    return true;
end;
jF.step=function()A.ok=false;
if not(m())then
    l,mF,W=nil,nil,J;
end;
end;
h.teardown(function()A.ok=false;
table.clear(f);
table.clear(k);
table.clear(g);
K(Q,0);
c,_,s,F,l,mF,W=nil,nil,nil,nil,nil,nil,J;
end);
return jF;
end;
D.aw=function()local m,j,h,b=D.load("b"),D.load("a"),D.load("ar"),D.load("ao");
local K=D.load("au");
local S=m.workspace;
local m=math.tan;
local o=math.rad;
local t=math.max;
local G=h.new(999);
h={step=function()if b.on then
    if b.draw_fov then
        if not(K.ok)then
            G:hide();
            return;
        end;
    else
        G:hide();
        return;
    end;
else
    G:hide();
    return;
end;
local i=S.CurrentCamera;
if not(i)then
    return;
end;
local S=i.ViewportSize;
local Y,O,T,x=m(K.half)*(S.Y*0.5)/m(o(i.FieldOfView*0.5)),S.X*0.5,S.Y*0.5,i:WorldToViewportPoint(K.origin+K.dir*100);
if x.Z>0 then
    O,T=x.X,x.Y;
else
end;
G:show(O,T,t(Y,2),b);
end,unload=function()G:destroy();
end
};
j.teardown(h.unload);
return h;
end;
D.ax=function()local m=D.load("b");
local j,h=D.load("a"),D.load("j");
local b=h.skins;
local K,S,o,t,G=h.data,h.skin_info,h.weapon_props,h.viewmodel,m.lp;
local i,Y,O,T,x,p=m.newc,m.getups,m.info,{"GetCameraModel","GetCharacterModel","GetWorldModel","GetBaseWeaponModel","GetMagazine","GetItemIconImage","GetSkinInformation"},{knife={t={model="Stock",skin="Stock",wear=0,stat=false},ct={model="Stock",skin="Stock",wear=0,stat=false}},glove={t={model="Stock",skin="Stock"},ct={model="Stock",skin="Stock"}}},false;
local function A()p=x.knife.t.model~="Stock"or x.knife.ct.model~="Stock"or x.glove.t.model~="Stock"or x.glove.ct.model~="Stock";
end;
local M,a={["T Knife_Stock"]={"knife","t"},["CT Knife_Stock"]={"knife","ct"},["T Glove_Stock"]={"glove","t"},["CT Glove_Stock"]={"glove","ct"}},{["T Knife"]={"knife","t"},["CT Knife"]={"knife","ct"},["T Glove"]={"glove","t"},["CT Glove"]={"glove","ct"}};
local function B(N,I)local R=N[I];
if R then
    return x[R[1]][R[2]],R[1];
end;
return nil,nil;
end;
local N,I;
if type(K)=="table"then if type(K.Get)=="function"then if type(Y)=="function"then local R,n=pcall(Y,K.Get);
if R then
    if type(n)=="table"then local K=n[1];
    N=K;
else
end;
else
end;
else
end;
else
end;
I=N;
else
    I=N;
end;
local function K()if p then
    if not(I)then
        return;
    end;
else
    return;
end;
local N=I[G];
local I=N and N.Inventory;
if type(I)~="table"then return;
end;
for R=1,#I,1 do
    N=I[R];
    local I,R=B(M,N._id);
    if I then
        if I.model~="Stock"then N.Name=I.model;
        N.Skin=I.skin~="Stock"and I.skin or"Stock";
        N.Float=tonumber(I.wear)or 0;
        N.StatTrack=R=="knife"and I.stat==true;
    else
        N.Name=tostring(N._id):gsub("_Stock$","");
        N.Skin="Stock";
        N.Float=0;
        N.StatTrack=false;
    end;
    N.NameTag=false;
    N.Charm=false;
    N.Stickers={};
end;
end;
end;
j.connect(m.run.Heartbeat,K);
if type(o)=="function"then local N;
N=j.detour(o,i(function(I,...)local R=B(a,I);
if R then
    if R.model~="Stock"then return N(R.model,...);
end;
end;
return N(I,...);
end));
end;
local N;
if type(b)=="table"then if type(b.ObserveItemStockSchemas)=="function"then h,o=pcall(b.ObserveItemStockSchemas,function(I)if type(I)=="table"then N=I;
end;
end);
if h then
    j.adopt(o);
end;
end;
end;
if type(b)=="table"then for I=1,#T,1 do
    h=T[I];
    if type(b[h])=="function"then j.field(b,h,function(I)return function(R,n,...)local E=B(a,R);
    if E then
        if E.model~="Stock"then local d=E.skin~="Stock"and E.skin or n;
        return I(E.model,d,...);
    end;
end;
return I(R,n,...);
end;
end);
end;
end;
end;
local function I()if type(O)~="function"then return false;
end;
local R,n=pcall(O,3,"s");
return R and type(n)=="string"and n:find("Viewmodel",1,true)~=nil;
end;
if type(b)=="table"then if type(b.GetGloves)=="function"then j.field(b,"GetGloves",function(R)return function(n,E,...)local d=B(a,n);
if d then
    if d.model~="Stock"then if I()then
        return R(d.model,d.skin~="Stock"and d.skin or E,...);
    end;
end;
end;
return R(n,E,...);
end;
end);
end;
end;
local function I()return G:GetAttribute("Team")=="Counter-Terrorists"and"ct"or"t";
end;
local function G(R)local n,E=B(a,R);
local a,R=if E=="knife"then if n.model~="Stock"then n.model.."/"..tostring(n.skin).."/"..tostring(n.wear).."/"..tostring(n.stat)
else
    nil
else
    nil,x.glove[I()];
    return if R.model~="Stock"then(a and a.."/"or"")..R.model.."/"..tostring(R.skin)
else
    a;
end;
if type(t)=="table"and type(Y)=="function"and type(O)=="function"then T,h={"claim","new"};
for a,R in T,nil,nil do
    K=rawget(t,R);
    if type(K)=="function"then R,o=pcall(Y,K);
    if R then
        if type(o)=="table"then a=h;
        for t,Y in o,nil,nil do
            if type(Y)=="function"then if O(Y,"n")=="getCarryOverKey"then local o;
            if a then
                o=a;
            else
                local O=Y;
                o=function(Y,T,R,...)local n=O(Y,T,R,...);
                if type(n)=="string"then if p then
                    R=G(type(Y)=="table"and Y.ViewmodelCameraWeapon or T);
                    n=if R then
                        n.."|"..R
                    else
                        n;
                    else
                    end;
                else
                end;
                return n;
            end;
        end;
        j.upvalue(K,t,o);
        a=o;
    else
    end;
else
end;
end;
h=a;
else
end;
else
end;
else
end;
end;
end;
if type(S)=="function"then local h;
h=j.detour(S,i(function(j,...)if type(j)=="table"then local K,S=B(M,j._id);
if K then
    if K.model~="Stock"then local o=table.clone(j);
    o.Name=K.model;
    o.Skin=K.skin~="Stock"and K.skin or j.Skin;
    o.Float=tonumber(K.wear)or j.Float;
    if S=="knife"then o.StatTrack=K.stat==true;
end;
return h(o,...);
end;
end;
end;
return h(j,...);
end));
end;
local j,h,K,S={sel=x},{knife={t="T Knife",ct="CT Knife"},glove={t="T Glove",ct="CT Glove"}},{knife="Melee",glove="Glove"},{knife={"Butterfly Knife","Karambit","M9 Bayonet","Flip Knife","Gut Knife","Skeleton Knife","Stiletto Knife","LightSaber"},glove={"Sports Gloves","Driver Gloves","Operator Gloves","Hand Wraps"}};
local function o(t)return(tostring(t):gsub("_PATTERN_(%d+)"," #%1"):gsub("_"," "));
end;
local function t(G)local i,Y=tostring,function(O)return string.format("%06d",tonumber(O)or 0);
end;
return(i(G):gsub("%d+",Y):lower());
end;
local function G(i)if type(b)=="table"and type(b.GetAllSkinsForWeapon)=="function"then local Y,O=pcall(b.GetAllSkinsForWeapon,i);
if Y and type(O)=="table"then for Y=1,#O,1 do
    local T=O[Y];
    if type(T)=="table"then if T.skin=="Stock"then return T;
end;
end;
end;
end;
end;
local Y=m.module(m.storage,"Database","Custom","Weapons",i);
i=type(Y)=="table"and(Y.Icon or Y.ReverseIcon)or nil;
if type(i)=="string"then if i~=""then return{imageAssetId=i};
end;
end;
return nil;
end;
local function m(i,Y)if type(i)~="table"then return nil,false;
end;
local O=i.wearImages;
if type(O)=="table"then if#O>0 then
    if type(b.GetWearImageForFloat)=="function"then local T,p=pcall(b.GetWearImageForFloat,i,tonumber(Y)or 0);
    if T then
        if type(p)=="string"then if p~=""then return p,true;
    end;
end;
end;
end;
local T=O[1];
if type(T)=="table"then if type(T.assetId)=="string"then if T.assetId~=""then return T.assetId,true;
end;
end;
end;
end;
end;
Y=i.imageAssetId;
if type(Y)=="string"then if Y~=""then return Y,false;
end;
end;
return nil,false;
end;
j.models=function(i)local Y,O,T=S[i]or{},K[i],{};
if type(N)=="table"and O then
    i=N;
    for K,S in i,nil,nil do
        if type(K)=="string"and type(S)=="table"then for i,i in S,nil,nil do
            if type(i)=="table"then if i.type==O then
                if i.isEnabled then
                    if i.skin~="Stock"then T[#T+1]=K;
                    break;
                end;
            end;
        end;
    end;
end;
end;
end;
end;
if#T==0 then
    T=table.clone(Y);
else
    local K={};
    for S=1,#Y,1 do
        K[Y[S]]=S;
    end;
    table.sort(T,function(S,i)local Y,O=K[S]or math.huge,K[i]or math.huge;
    if Y~=O then
        return Y<O;
    end;
    return S<i;
end);
end;
table.insert(T,1,"Stock");
return T;
end;
j.cards=function(K,S,i)local Y={};
if S==nil or S=="Stock"then local O=h[K]and h[K][I()];
local h,T=m(O and G(O),0);
Y[1]={value="Stock",name="Stock",image=h,crop=T};
return Y;
end;
if K=="knife"then local h,O=m(G(S),0);
Y[1]={value="Stock",name="Stock",image=h,crop=O};
end;
if type(b)~="table"then return Y;
elseif  type(b.GetAllSkinsForWeapon)~="function"then return Y;
end;
local h,G=pcall(b.GetAllSkinsForWeapon,S);
if h then
    if type(G)~="table"then return Y;
end;
else
    return Y;
end;
S={};
for b=1,#G,1 do
    h=G[b];
    if type(h)=="table"then if h.isEnabled then
        if type(h.skin)=="string"then if h.skin~="Stock"then b,K=#S+1,{entry=h};
        K.key,S[b]=t(h.skin),K;
    end;
end;
end;
end;
end;
table.sort(S,function(b,t)return b.key<t.key;
end);
for b=1,#S,1 do
    K=S[b].entry;
    h,G=m(K,i);
    local m,b=#Y+1,{value=K.skin};
    b.name,b.image,b.crop,Y[m]=o(K.skin),h,G,b;
end;
return Y;
end;
j.set=function(m,h,b)local K=x[m];
K.t[h]=b;
K.ct[h]=b;
A();
end;
return j;
end;
D.ay=function()local m=D.load("b");
local j,h=D.load("q"),D.load("a");
local b,K=D.load("j"),j.world;
local S=m.lp;
local o=b.inventory;
local t=b.char_resolver;
local G=b.crosshair;
local i,Y,O,T,x=b.runstep,{},{};
local b,p,A=false;
local M=0;
local function a()if K.force_xhair then
    if not(t.isAliveCharacter(S.Character))then
        return;
    end;
else
    return;
end;
local S=o.peekCurrentEquippedForMovement();
local o=type(S)=="table"and rawget(S,"Properties");
if type(o)~="table"then return;
elseif  S.IsEquipped~=true then
    return;
elseif  o.Class~="Weapon"then return;
elseif  o.ShowCrosshair~=false then
    return;
end;
local t=Y[o];
if t then
else
    t=table.freeze(setmetatable({ShowCrosshair=true},{__index=o}));
    Y[o]=t;
end;
rawset(S,"Properties",t);
T,x=S,o;
end;
local function S()local o,t=T,x;
if not(o)then
    return;
end;
T,x=nil,nil;
if rawget(o,"Properties")==Y[t]then
    rawset(o,"Properties",t);
end;
end;
local function o(t)if A then
    local T=A;
    return T;
end;
if type(t)~="function"then return nil;
end;
local T=loadstring("local run, enter, leave, guard, raise = ...\10return function(...)\10\9guard(enter)\10\9local ok, err = guard(run, ...)\10\9guard(leave)\10\9if not ok then\10\9\9raise(err, 0)\10\9end\10end","=bs_xhair");
if type(T)~="function"then return nil;
end;
setfenv(T,{});
local x;
x,p=T(t,a,S,pcall,error),t;
A=x;
T=A;
return T;
end;
local function t()local T,x=type(i)=="table"and rawget(i,"Unbind"),m.getups;
if type(T)~="function"then return nil;
elseif  type(x)~="function"then return nil;
end;
local i,a=pcall(x,T);
if i then
    if type(a)~="table"then return nil;
end;
else
    return nil;
end;
for i,i in a,nil,nil do
    T=type(i)=="table"and rawget(i,"RenderStepped");
    i=type(T)=="table"and rawget(T,"BindingsByName");
    if type(i)=="table"then return i;
end;
end;
return nil;
end;
local function i()if not(A)then
    return;
end;
local T=t();
local t=T and rawget(T,"UI.Crosshair.Update");
if type(t)~="table"then return;
elseif  t.Callback==A then
    return;
elseif  type(t.Callback)~="function"then return;
end;
t.Callback=A;
if not(O[t])then
    O[t]=true;
    h.teardown(function()if t.Callback==A then
        t.Callback=p;
    end;
end);
end;
end;
local function t()if b then
    return;
elseif  type(G)~="table"then return;
elseif  type(setfenv)~="function"then return;
end;
b=true;
h.field(G,"UpdateCrosshair",o);
i();
h.connect(m.run.Heartbeat,function()if not(K.force_xhair)then
    return;
end;
local m=os.clock();
if m<M then
    return;
end;
M=m+1;
i();
end);
end;
j={set=function(m)K.force_xhair=m==true;
if K.force_xhair then
    t();
end;
end
};
h.teardown(function()K.force_xhair=false;
S();
table.clear(Y);
end);
return j;
end;
D.az=function()local m,j,h,b=D.load("q"),D.load("e"),D.load("ay"),D.load("X");
local K=m.world;
local S=m.white;
m=j.tabs.visuals;
local function o(t)return function(G)K[t]=G;
end;
end;
j=m:page("world");
local t,G,i,Y,O=j:section({name="lighting"}),j:section({name="sky"}),j:section({name="grenades",side=2}),j:section({name="bullets",side=2}),j:section({name="bomb",side=2});
j=t:toggle({name="time",flag="world.time",cb=o("time")});
j:slider({flag="world.time_hour",min=0,max=24,dec=1,default=12,suffix="h",cb=o("time_hour")}):dep(j);
j=t:toggle({name="fog",flag="world.fog",cb=o("fog")});
j:color({flag="world.fog_color",default=S,cb=o("fog_col")});
local T=j:settings();
T:slider({name="start",flag="world.fog_start",min=0,max=1000,cb=o("fog_start")});
T:slider({name="end",flag="world.fog_end",min=50,max=5000,default=500,cb=o("fog_end")});
t:toggle({name="ambient",flag="world.ambient",cb=o("ambient")}):color({flag="world.ambient_color",default=S,cb=o("ambient_col")});
j=t:toggle({name="fullbright",flag="world.fullbright",cb=o("fullbright")});
j:color({flag="world.fullbright_color",default=S,cb=o("fb_col")});
j:slider({flag="world.fullbright_brightness",min=0,max=500,default=200,suffix="%",cb=o("fb_power")}):dep(j);
T=t:toggle({name="exposure",flag="world.exposure",cb=o("exposure")});
T:slider({flag="world.exposure_value",min=-300,max=300,default=0,suffix="%",cb=o("exposure_val")}):dep(T);
T=t:toggle({name="bloom",flag="world.bloom",cb=o("bloom")}):settings();
T:slider({name="intensity",flag="world.bloom_intensity",min=0,max=400,default=100,suffix="%",cb=o("bloom_power")});
T:slider({name="size",flag="world.bloom_size",min=1,max=100,default=24,cb=o("bloom_size")});
T:slider({name="threshold",flag="world.bloom_threshold",min=0,max=500,default=200,suffix="%",cb=o("bloom_limit")});
T=t:toggle({name="color correction",flag="world.color_correction",cb=o("cc")});
T:color({flag="world.color_correction_tint",default=S,cb=o("cc_tint")});
j=T:settings();
j:slider({name="saturation",flag="world.color_correction_saturation",min=-100,max=200,default=0,suffix="%",cb=o("cc_sat")});
j:slider({name="brightness",flag="world.color_correction_brightness",min=-100,max=100,default=0,suffix="%",cb=o("cc_bright")});
j:slider({name="contrast",flag="world.color_correction_contrast",min=-100,max=200,default=0,suffix="%",cb=o("cc_contrast")});
t:toggle({name="no shadows",flag="world.no_shadows",cb=o("no_shadows")});
G:toggle({name="skybox",flag="world.skybox",cb=o("sky")}):dropdown({flag="world.skybox_preset",values={"jungle","blossom","red night","purple","foggy","galaxy","anime","minecraft"},cb=o("sky_preset")});
j=G:toggle({name="effects",flag="world.effects",cb=o("fx")});
j:color({flag="world.effects_color",default=S,cb=o("fx_col")});
j:dropdown({flag="world.effects_type",values={"snow","sakura","stars"},cb=o("fx_type")});
j:settings():slider({name="rate",flag="world.effects_rate",min=20,max=900,default=250,cb=o("fx_rate")});
j=i:toggle({name="trajectory",flag="world.grenade_prediction",cb=o("nade_path")});
j:color({flag="world.grenade_prediction_color",default=S,cb=o("nade_path_col")});
G=j:settings();
G:colorpicker({name="radius",flag="world.grenade_prediction_radius_color",default=S,cb=o("nade_radius_col")});
G:slider({name="thickness",flag="world.grenade_prediction_thickness",min=1,max=4,default=2,suffix="px",cb=o("nade_path_width")});
T=i:toggle({name="zones",flag="world.grenadeareas",cb=o("nade_zones")}):settings();
T:colorpicker({name="smoke",flag="world.smokegrenadeareacolor",default=S,cb=o("smoke_zone_col")});
T:colorpicker({name="smoke icon",flag="world.smokegrenadeareaiconcolor",default=S,cb=o("smoke_zone_icon")});
T:colorpicker({name="molotov",flag="world.molotovgrenadeareacolor",default=S,cb=o("fire_zone_col")});
T:colorpicker({name="molotov icon",flag="world.molotovgrenadeareaiconcolor",default=S,cb=o("fire_zone_icon")});
i:toggle({name="flying",flag="world.flyinggrenades",cb=o("nades_live")}):color({flag="world.flyinggrenadeiconcolor",default=S,cb=o("nade_icon_col")});
i=Y:toggle({name="tracers",flag="world.bullet_tracers",cb=o("tracers")});
i:color({flag="world.tracers_color",default=S,cb=o("tracers_col")});
j=i:settings();
j:slider({name="thickness",flag="world.tracers_thickness",min=1,max=20,default=5,cb=function(i)K.tracers_width=i/100;
end
});
j:slider({name="life",flag="world.tracers_life",min=0.2,max=4,dec=1,default=1.2,suffix="s",cb=o("tracers_life")});
j=Y:toggle({name="impacts",flag="world.impacts",cb=o("impacts")});
j:color({flag="world.impactscolor",default=S,cb=o("impacts_col")});
j:settings():slider({name="life",flag="world.impactslife",min=1,max=30,default=3,suffix="s",cb=o("impacts_life")});
T=O:toggle({name="esp",flag="world.bomb_esp",cb=o("bomb_esp")});
T:color({flag="world.bomb_icon_color",default=S,cb=o("bomb_icon_col")});
O=T:settings();
O:colorpicker({name="timer",flag="world.bomb_timer_color",default=S,cb=o("bomb_timer_col")});
O:toggle({name="timer gradient",flag="world.bomb_timer_gradient",cb=o("bomb_timer_grad")}):color({flag="world.bomb_timer_gradient_color",default=S,cb=o("bomb_timer_grad_col")});
G=m:page("local");
local m,j,i=G:section({name="view"}),G:section({name="crosshair"}),G:section({name="chams",side=2});
Y=m:toggle({name="third person",flag="world.third_person",cb=o("third")});
Y:slider({flag="world.third_person_distance",min=5,max=30,default=10,suffix="st",cb=o("third_dist")}):dep(Y);
t=m:toggle({name="viewmodel",flag="world.hands",cb=o("hands")}):settings();
t:slider({name="x",flag="world.hands_x",min=-100,max=100,default=0,cb=o("hands_x")});
t:slider({name="y",flag="world.hands_y",min=-100,max=100,default=0,cb=o("hands_y")});
t:slider({name="z",flag="world.hands_z",min=-100,max=100,default=0,cb=o("hands_z")});
m:dropdown({name="removals",flag="misc.removals",multi=true,values={"scope","flash","smoke","hands","bullets"},cb=function(m)local t={};
for Y,Y in m,nil,nil do
    t[Y]=true;
end;
b.removals(t);
end
});
G=j:toggle({name="scope",flag="world.scope_xhair",cb=o("xhair")});
G:color({flag="world.scope_xhair_color",default=S,cb=o("xhair_col")});
T=G:settings();
T:slider({name="size",flag="world.scope_xhair_size",min=25,max=200,default=100,suffix="%",cb=o("xhair_size")});
T:slider({name="gap",flag="world.scope_xhair_gap",min=0,max=40,default=6,suffix="px",cb=o("xhair_gap")});
j:toggle({name="force",flag="world.force_xhair",cb=h.set});
T=j:toggle({name="penetration",flag="world.penetration",cb=o("pen")}):settings();
T:colorpicker({name="yes",flag="world.penetrationyes",default=K.pen_yes,cb=o("pen_yes")});
T:colorpicker({name="no",flag="world.penetrationno",default=K.pen_no,cb=o("pen_no")});
T:slider({name="size",flag="world.penetrationsize",min=6,max=36,default=12,suffix="px",cb=o("pen_size")});
local function m(j,b,t,G)local Y=i:toggle({name=j,flag=b,cb=o(t)});
Y:color({flag=b.."_color",default=S,cb=o(t.."_col")});
Y:dropdown({flag=b.."_mat",values=G,cb=o(t.."_mat")});
return Y;
end;
h={"knife","pistols","rifles","snipers","smgs","shotguns","machine guns","grenades","bomb","other"};
m("body","world.local_chams","body_chams",{"forcefield","chrome"});
m("weapon","world.tool_chams","tool_chams",{"forcefield","neon","metal","chrome"}):settings():dropdown({name="apply to",flag="world.tool_chams_filter",multi=true,values=h,default=h,cb=function(j)local h={};
for b,b in j,nil,nil do
    h[b]=true;
end;
K.tool_chams_kinds=h;
end
});
m("hands","world.hand_chams","hand_chams",{"forcefield","neon","metal","chrome"});
return true;
end;
D.aA=function()local m,j,h=D.load("e"),D.load("W"),D.load("U");
local b=j.cfg;
local K,S=h.cfg,{"off","down","up","jitter"};
local function o(t)return function(G)b[t]=G;
end;
end;
j=m.tabs.misc:page("movement");
local b,t=j:section({name="movement"}),j:section({name="anti aim",side=2});
b:toggle({name="bhop",flag="mv.bhop",cb=o("bhop")});
b:toggle({name="auto strafe",flag="mv.strafe",cb=o("strafe")});
b:toggle({name="edge jump",flag="mv.edgejump",cb=o("edge_jump")});
b:toggle({name="jump bug",flag="mv.jumpbug",cb=o("jump_bug")});
b:toggle({name="edge bug",flag="mv.edgebug",cb=o("edge_bug")});
b:toggle({name="slow walk",flag="mv.slowwalk",cb=o("slow_walk")});
b:toggle({name="pixel surf",flag="mv.pixelsurf",cb=o("pixel_surf")});
m=t:toggle({name="enable",flag="aa.on",cb=function(j)K.on=j;
h.reset();
if not(j)then
    h.relax();
end;
end
});
o=t:dropdown({name="yaw",flag="aa.yaw",values={"backward","spin","jitter","off"},cb=function(j)K.yaw=j;
h.reset();
end
}):dep(m);
t:slider({name="jitter",flag="aa.jitter",min=0,max=180,default=45,suffix="\194\176",cb=function(j)K.jitter=j;
end
}):dep(o,"jitter");
t:slider({name="spin speed",flag="aa.spinspeed",min=1,max=90,default=25,cb=function(j)K.spin_rate=j;
end
}):dep(o,"spin");
t:dropdown({name="pitch",flag="aa.pitch",values=S,cb=function(j)K.pitch=j;
if j=="off"then h.relax();
end;
end
}):dep(m);
o=t:toggle({name="spin in air",flag="aa.spinair",cb=function(j)K.air_spin=j;
h.reset();
end
}):dep(m);
o:slider({flag="aa.spinairspeed",min=0,max=90,default=30,sw=56,cb=function(j)K.air_rate=j;
end
}):dep(o);
t:dropdown({name="air pitch",flag="aa.airpitch",values=S,cb=function(j)K.air_pitch=j;
if j=="off"then h.relax();
end;
end
}):dep(o);
local j;
local b=t:toggle({name="manual left",flag="aa.manleft",cb=function(S)if S then
    K.man=-1;
    if j then
        j:set(false);
    end;
elseif  K.man==-1 then
    K.man=0;
end;
end
}):dep(m);
j=t:toggle({name="manual right",flag="aa.manright",cb=function(j)if j then
    K.man=1;
    b:set(false);
elseif  K.man==1 then
    K.man=0;
end;
end
}):dep(m);
t:toggle({name="auto manual",flag="aa.automan",cb=function(j)K.auto=j;
h.reset();
end
}):dep(m);
t:slider({name="manual angle",flag="aa.manangle",min=0,max=180,default=90,suffix="\194\176",cb=function(j)K.ang=j;
end
}):dep(m);
return true;
end;
D.aB=function()local m,j,h=D.load("q"),D.load("e"),D.load("ax");
local b=D.load("ae");
local K=D.load("a");
local S=m.misc;
local o=m.notify;
local t=m.white;
m=j.tabs.misc;
local function G(i)return function(Y)S[i]=Y;
end;
end;
local function i(Y)return function(O)S[Y]=O;
S.buy_dirty=true;
end;
end;
local Y=m:page("utility");
local O,T,x=Y:section({name="combat"}),Y:section({name="bomb"}),Y:section({name="auto buy",side=2});
Y=O:toggle({name="knife bot",flag="misc.kbot",cb=G("knife")});
Y:slider({flag="misc.kbotrange",min=2,max=5,dec=1,default=3.5,suffix="st",sw=56,cb=G("knife_range")}):dep(Y);
Y:settings():toggle({name="heavy swing",flag="misc.kbotheavy",default=true,cb=G("knife_heavy")});
Y=O:toggle({name="zeus bot",flag="misc.zbot",cb=G("zeus")});
Y:slider({flag="misc.zbotrange",min=5,max=13,dec=1,default=12,suffix="st",sw=56,cb=G("zeus_range")}):dep(Y);
O:toggle({name="auto reload",flag="misc.autoreload",cb=G("auto_reload")});
T:toggle({name="auto plant",flag="misc.autoplant",cb=G("auto_plant")});
T:toggle({name="auto defuse",flag="misc.autodefuse",cb=G("auto_defuse")});
G=x:toggle({name="enable",flag="misc.autobuy",cb=i("auto_buy")});
x:dropdown({name="primary",flag="misc.autobuyprimary",values={"none","AK-47","M4A4","M4A1-S","AWP","SG 553","AUG","SSG 08","Galil AR","FAMAS","MAC-10","MP9","MP7","MP5-SD","P90","UMP-45","PP-Bizon","Nova","XM1014","MAG-7","Sawed-Off","M249","Negev"},default="AK-47",cb=i("buy_primary")}):dep(G);
x:dropdown({name="secondary",flag="misc.autobuysecondary",values={"none","USP-S","P2000","Glock-18","P250","Five-SeveN","Tec-9","CZ75-Auto","Dual Berettas","Desert Eagle","R8 Revolver"},default="USP-S",cb=i("buy_secondary")}):dep(G);
x:dropdown({name="grenades",flag="misc.autobuygrenades",multi=true,values={"HE Grenade","Flashbang","Smoke Grenade","Decoy Grenade","Incendiary Grenade","Molotov"},cb=function(Y)S.buy_nades=table.clone(Y);
S.buy_dirty=true;
end
}):dep(G);
x:toggle({name="zeus",flag="misc.autobuyzeus",cb=i("buy_zeus")}):dep(G);
local S=m:page("feedback");
local function m(G,i,Y)local O,T,x=S:section({name=G,side=i}),"misc."..G,o.fx[G];
local S=o.screen[G];
local p=o.marks[G];
local A=o.sounds[G];
i=O:toggle({name="enable",flag=T.."_master",cb=function(M)o.master[G]=M;
end
});
O:toggle({name="log",flag=T.."_notify",cb=function(M)o.log[G]=M;
end
}):dep(i);
O:toggle({name="effect",flag=T.."_effect",cb=function(M)x.on=M;
end
}):dep(i):color({flag=T.."_effect_color",default=x.col,cb=function(M)x.col=M;
end
});
local x=O:toggle({name="health shot",flag=T.."_screen",cb=function(M)S.on=M;
end
}):dep(i);
x:color({flag=T.."_screen_color",default=S.col,cb=function(M)S.col=M;
end
});
x:slider({flag=T.."_screen_power",min=10,max=200,default=100,suffix="%",sw=56,cb=function(M)S.power=M;
end
}):dep(x);
x=O:toggle({name="marker",flag=T.."_marker",cb=function(S)p.on=S;
end
}):dep(i);
x:color({flag=T.."_marker_color",default=t,cb=function(S)p.col=S;
end
});
local S=x:settings();
S:slider({name="size",flag=T.."_marker_size",min=4,max=24,default=14,suffix="px",cb=function(t)p.size=t;
end
});
S:slider({name="fade",flag=T.."_marker_fade",min=0.1,max=5,dec=1,default=1,suffix="s",cb=function(t)p.fade=t;
end
});
S=O:toggle({name="sound",flag=T.."_sound",cb=function(t)A.on=t;
if t then
    K.spawn(b.prepare,G,false);
end;
end
}):dep(i);
S:dropdown({flag=T.."_sound_value",values=o.list,default=Y,cb=function(o)A.name=o;
K.spawn(b.prepare,G,false);
end
});
S:settings():slider({name="volume",flag=T.."_sound_volume",min=0.1,max=5,dec=1,default=1,cb=function(K)A.vol=K;
b.prepare(G,false);
end
});
end;
m("hit",1,"mc bow");
m("kill",2,"skeet");
local function m(b,K,S)local o,t,G="skins."..K,h.sel[K].t;
b:dropdown({name="model",flag=o..".model",values=h.models(K),cb=function(i)h.set(K,"model",i);
if not(G)then
    return;
end;
local Y=h.cards(K,i,t.wear);
i=Y[1]and Y[1].value or nil;
for O=1,#Y,1 do
    if Y[O].value==t.skin then
        i=t.skin;
        break;
    end;
end;
G:setvalues(Y,true);
G:set(i);
end
});
if S then
    b:slider({name="wear",flag=o..".wear",min=0,max=100,suffix="%",cb=function(S)h.set(K,"wear",S/100);
    if G then
        G:setvalues(h.cards(K,t.model,t.wear),true);
    end;
end
});
end;
G=b:cards({flag=o..".skin",cols=3,values=h.cards(K,"Stock",0),default="Stock",cb=function(b)h.set(K,"skin",b);
end
});
end;
m(j.tabs.skins:section({name="knives"}),"knife",true);
m(j.tabs.skins:section({name="gloves",side=2}),"glove");
return true;
end;
D.aC=function()local m,j,h,b,K=D.load("e"),D.load("ai"),D.load("al"),D.load("am"),Color3.new(1,1,1);
local S,o,t=j.order,h.refresh,m.tabs.aim;
j=t:profile({id="aim",items=h.names,global="global"});
j.cb=o;
h.ui=j;
j=t:page({name="main",cols=3});
h,t,m=j:section({name="silent aim"}),j:section({name="accuracy",side=2}),j:section({name="weapon",side=3});
j=h:toggle({name="enable",flag="legit.on",cb=o});
h:toggle({name="team check",flag="legit.team",default=true,cb=o}):dep(j);
h:toggle({name="auto shoot",flag="legit.auto",cb=o}):dep(j);
h:toggle({name="auto revolver",flag="legit.autorev",cb=o}):dep(j):settings():toggle({name="auto switch",flag="legit.autoswitch",cb=o});
b.bind(h:dropdown({name="target",multi=true,values=b.values,cb=b.set}):dep(j));
h:dropdown({name="hitboxes",flag="legit.hb",multi=true,values=S,default={"head","chest"},cb=o}):dep(j);
h:dropdown({name="prefer",flag="legit.prefer",values=S,default="head",cb=o}):dep(j);
h:slider({name="fov",flag="legit.fov",min=0,max=180,default=8,suffix="\194\176",cb=o}):dep(j);
S=h:toggle({name="draw fov",flag="legit.dfov",cb=o}):dep(j);
S:color({flag="legit.dfov_col",default=K,cb=o});
h=S:settings();
h:toggle({name="gradient",flag="legit.dfov_grad",cb=o}):color({flag="legit.dfov_col2",default=K,cb=o});
h:toggle({name="fill",flag="legit.dfov_fill",cb=o}):color({flag="legit.dfov_fcol",default=K,cb=o});
h:toggle({name="fill gradient",flag="legit.dfov_fgrad",cb=o}):color({flag="legit.dfov_fcol2",default=K,cb=o});
t:slider({name="min damage",flag="legit.mindmg",min=0,max=150,cb=o}):dep(j);
t:toggle({name="auto wall",flag="legit.aw",cb=o}):dep(j):settings():slider({name="min damage",flag="legit.awmindmg",min=0,max=150,cb=o});
h=t:toggle({name="multipoints",flag="legit.multipoint",cb=o}):dep(j):settings();
h:slider({name="head",flag="legit.headsize",min=0,max=100,default=65,suffix="%",cb=o});
h:slider({name="chest",flag="legit.chestsize",min=0,max=100,default=60,suffix="%",cb=o});
h:slider({name="stomach",flag="legit.stomachsize",min=0,max=100,default=60,suffix="%",cb=o});
h:slider({name="arms",flag="legit.armssize",min=0,max=100,default=55,suffix="%",cb=o});
h:slider({name="legs",flag="legit.legssize",min=0,max=100,default=55,suffix="%",cb=o});
t:toggle({name="auto scope",flag="legit.autoscope",cb=o}):dep(j);
t:slider({name="force origin",flag="legit.originshift",min=0,max=8,dec=1,zero="off",suffix="st",cb=o}):dep(j);
m:toggle({name="no recoil",flag="legit.norecoil",cb=o});
m:toggle({name="no spread",flag="legit.nospread",cb=o});
m:toggle({name="insta reload",flag="legit.instantreload",cb=o});
b.refresh();
return true;
end;
D.aD=function()local m,j,h,b,K=D.load("e"),D.load("ai"),D.load("al"),D.load("at"),Color3.new(1,1,1);
local S,o,t=j.order,b.refresh,m.tabs.trigger;
m=t:profile({id="trigger",items=h.names,global="global"});
m.cb=o;
b.ui=m;
m,b=t:section({name="trigger bot"}),t:section({name="accuracy",side=2});
h=m:toggle({name="enable",flag="trig.on",cb=o});
m:toggle({name="team check",flag="trig.team",default=true,cb=o}):dep(h);
m:toggle({name="auto revolver",flag="trig.autorev",cb=o}):dep(h):settings():toggle({name="auto switch",flag="trig.autoswitch",cb=o});
m:dropdown({name="hitboxes",flag="trig.hb",multi=true,values=S,default={"head","chest","stomach","arms"},cb=o}):dep(h);
m:dropdown({name="prefer",flag="trig.prefer",values=S,default="head",cb=o}):dep(h);
t=m:toggle({name="draw fov",flag="trig.dfov",cb=o}):dep(h);
t:color({flag="trig.dfov_col",default=K,cb=o});
j=t:settings();
j:toggle({name="gradient",flag="trig.dfov_grad",cb=o}):color({flag="trig.dfov_col2",default=K,cb=o});
j:toggle({name="fill",flag="trig.dfov_fill",cb=o}):color({flag="trig.dfov_fcol",default=K,cb=o});
j:toggle({name="fill gradient",flag="trig.dfov_fgrad",cb=o}):color({flag="trig.dfov_fcol2",default=K,cb=o});
b:slider({name="min damage",flag="trig.mindmg",min=0,max=150,cb=o}):dep(h);
b:slider({name="hit chance",flag="trig.hc",min=1,max=100,default=70,suffix="%",cb=o}):dep(h);
b:toggle({name="auto wall",flag="trig.aw",cb=o}):dep(h):settings():slider({name="min damage",flag="trig.awmindmg",min=0,max=150,cb=o});
return true;
end;
D.aE=function()local m,j=D.load("b"),D.load("a");
local h,b=D.load("e"),m.lp;
local K=m.players;
local S=m.workspace;
local m=h.lib;
local h=string.lower;
local o=math.max;
local t,G,i=math.floor,{},false;
local function Y(O,T)local x=O:GetAttribute("LastKiller")==b.Name;
if x~=(T:GetAttribute("LastKiller")==b.Name)then
    return x;
end;
return h(O.DisplayName.."\0"..O.Name)<h(T.DisplayName.."\0"..T.Name);
end;
local function h()local O,T={},o(0,t(tonumber(b:GetAttribute("Spectators"))or 0));
if T==0 then
    return O;
end;
local o,t=b:GetAttribute("Team"),S:GetAttribute("ServerGamemode")=="Competitive";
for S,S in K:GetPlayers()do
    if S~=b then
        if S.Parent==K then
            if S:GetAttribute("IsSpectating")==true then
                if t then
                    if o then
                        if o=="Spectators"then O[#O+1]=S;
                    elseif  S:GetAttribute("Team")==o then
                        O[#O+1]=S;
                    end;
                else
                    O[#O+1]=S;
                end;
            else
                O[#O+1]=S;
            end;
        end;
    end;
end;
end;
table.sort(O,Y);
for S=#O,T+1,-1 do
    O[S]=nil;
end;
return O;
end;
local function S()if i then
    return;
elseif  not(j.alive())then
    return;
end;
i=true;
task.defer(function()i=false;
if j.alive()then
    pcall(m.spectators,m,h());
end;
end);
end;
local function m(h)if h==b then
    return;
elseif  G[h]then
    return;
end;
G[h]=h:GetAttributeChangedSignal("IsSpectating"):Connect(S);
end;
for h,h in K:GetPlayers()do
    m(h);
end;
j.connect(b:GetAttributeChangedSignal("Spectators"),S);
j.connect(K.PlayerAdded,function(h)m(h);
S();
end);
j.connect(K.PlayerRemoving,function(m)local h=G[m];
if h then
    h:Disconnect();
    G[m]=nil;
end;
S();
end);
j.teardown(function()for m,j in G,nil,nil do
    j:Disconnect();
    G[m]=nil;
end;
end);
S();
return true;
end;
local m=D.load("a");
m.takeover();
local j=D.load("b").reclaim;
local h,b=D.load("e"),D.load("p");
local K=D.load("G");
local S=D.load("I");
local o=D.load("J");
local t=D.load("K");
local G=D.load("N");
local i=D.load("H");
local Y=D.load("P");
local O=D.load("v");
D.load("Q");
local T=D.load("R");
local x=D.load("S");
D.load("W");
local p=D.load("X");
local A=D.load("_");
local M=D.load("aa");
local a,B=D.load("af"),D.load("ac");
local N=D.load("aq");
local I=D.load("as");
local R=D.load("ap");
local n=D.load("av");
local E=D.load("aw");
D.load("ax");
j();
D.load("az");
D.load("aA");
D.load("aB");
D.load("aC");
D.load("aD");
D.load("aE");
local function d(w)local ok,err=pcall(w);
if not ok and w==D.load("p").step then
    D.load("p").lastError=tostring(err);
end;
j();
end;
local function j()d(p.sync);
d(o.sync);
d(i.step);
d(A.step);
d(N.auto);
end;
local function i()d(b.step);
d(R.step);
d(n.step);
d(B.step);
d(o.step_fx);
d(t.step);
d(T.step);
d(G.step);
d(Y.step);
d(I.step);
d(E.step);
end;
local function b()d(S.sync);
d(O.pump);
d(x.step);
d(M.step);
end;
local S,o={beat=j,early=i,late=b},loadstring("local s = ...\10local rs = game:GetService(\"RunService\")\10local a = \"\\0\" .. tostring(math.random(1e7, 9e7))\10local b = \"\\0\" .. tostring(math.random(1e7, 9e7))\10s.hb = rs.Heartbeat:Connect(s.beat)\10rs:BindToRenderStep(a, Enum.RenderPriority.Camera.Value + 3, s.early)\10rs:BindToRenderStep(b, Enum.RenderPriority.Last.Value + 1, s.late)\10s.stop = function()\10\9rs:UnbindFromRenderStep(a)\10\9rs:UnbindFromRenderStep(b)\10end\10","=bs_world");
if o and pcall(o,S)then
    m.adopt(S.hb);
    if type(S.stop)=="function"then m.teardown(S.stop);
end;
else
    m.connect(D.load("b").run.Heartbeat,j);
    m.bind(Enum.RenderPriority.Camera.Value+3,i);
    m.bind(Enum.RenderPriority.Last.Value+1,b);
end;
Y.attach(a.from_packet);
a.start();
K.Load();
m.teardown(function()if K._loaded then
    pcall(K.Unload);
end;
end);
h.finish();
m.publish(m.release);
return true;

