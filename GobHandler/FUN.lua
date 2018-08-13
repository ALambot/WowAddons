local GH = _G.GH;

GH.data = {};
GH.charPos = {};
GH.listen_add = false;
GH.listen_GPS = false;
GH.look_north = false;

-- Variables

local pack;
local split;
local resetData;
local resetCharPos;
local sendGobDetails;

local LoopFrame;

-- Loop

local loop_queue = {length=0};
local function onUpdate(self,elapsed)
    for i=0,(loop_queue.length)-1 do
        local bloc = loop_queue[i];
        bloc.timer = bloc.timer + elapsed;
        if(bloc.valid and bloc.timer>bloc.limit)then
            bloc.valid = false;
            bloc.func();
        end
        if(i == loop_queue.length-1 and bloc.valid == false)then
            loop_queue.length = loop_queue.length - 1;
        end
    end
end
local function delay(Flimit,Ffunc)
    loop_queue[loop_queue.length] = {limit=Flimit,func=Ffunc,timer=0,valid=true};
    loop_queue.length = (loop_queue.length) + 1;
end
LoopFrame = CreateFrame("Frame");
LoopFrame:SetScript("OnUpdate", onUpdate);

-- Events

local EventFrame = CreateFrame("Frame");
EventFrame:RegisterEvent("CHAT_MSG_SYSTEM");
EventFrame:SetScript("OnEvent",
    function(self, event, ...)
        local msg = ... ;
        pack(msg);
    end
);

-- Functions

split = function(str)
    local ret = {};
    ret.length = 0;

    local temp = "";
    local j = 1;
    for i=1,string.len(str) do
        if(string.sub(str,i,i)==" ") then
            ret.length = ret.length+1;
            ret[ret.length] = string.sub(str,j,i-1);
            j = i+1;
        end
    end
    ret.length = ret.length+1;
    ret[ret.length] = string.sub(str,j,string.len(str));
    return ret;
end

resetData = function()
    GH.data = {};
end

resetCharPos = function()
    GH.charPos = {};
end

sendGobDetails = function()
    GH.gobDetails = {GH.data.gobName, GH.data.ID, GH.data.GUID};
    GH.update_gobDetails();
end

pack = function(msg)
    if(msg == "Selected object:")then
        resetData();
        GH.data.type = "gob_target";
        GH.data.step = 0;
    elseif(string.sub(msg,1,18) == ">> Add Game Object" and GH.listen_add)then
        resetData();
        GH.data.type = "gob_add";
        GH.data.step = 0;
    elseif(string.sub(msg,1,5) == "Map: ")then --GPS
        resetCharPos();
        GH.charPos.step = 0;
    end

    if(GH.data.type == "gob_target")then
        local spl = split(msg);

        if(GH.data.step == 0 and spl.length == 5 and spl[2] == "GUID:" and spl[4] == "ID:")then
            GH.data.gobName = spl[1];
            GH.data.GUID = spl[3];
            GH.data.ID = spl[5];
            GH.data.step = 1;
        elseif(GH.data.step == 1 and spl.length == 8 and spl[1] == "X:" and spl[7] == "MapId:")then
            GH.data.X = spl[2];
            GH.data.Y = spl[4];
            GH.data.Z = spl[6];
            GH.data.MapID = spl[7];
            GH.data.step = 2;
        elseif(GH.data.step == 2 and spl.length == 2 and spl[1] == "Orientation:")then
            GH.data.Orientation = spl[2];
            GH.data.step = 3;
        else
            --
        end

        if(GH.data.step == 3)then
            sendGobDetails();
            GH.data.step = 4;
        end
    elseif(GH.data.type == "gob_add")then
        local spl = split(msg);

        if(GH.data.step == 0)then
            GH.data.gobName = string.sub(spl[6],2,string.len(spl[6])-1);
            GH.data.GUID = string.sub(spl[8],1,string.len(spl[8])-1);
            GH.data.ID = string.sub(spl[5],2,string.len(spl[5])-1);
            GH.data.X = string.sub(spl[11],2,string.len(spl[11]));
            GH.data.Y = spl[12];
            GH.data.Z = string.sub(spl[13],1,string.len(spl[13])-2);
            GH.data.step = 1;
            GH.listen_add = false;
        end

        if(GH.data.step == 1)then
            sendGobDetails();
            GH.data.step = 2;
        end
    end

    if(GH.listen_GPS)then --GPS
        local spl = split(msg);

        if(GH.charPos.step == 0 and spl[1] == "Map:")then
            GH.charPos.Map = spl[2];
            GH.charPos.step = 1;
        elseif(GH.charPos.step == 1 and spl.length == 8 and spl[3] == "Y:")then
            GH.charPos.X = spl[2];
            GH.charPos.Y = spl[4];
            GH.charPos.Z = spl[6];
            GH.charPos.Orientation = spl[8];
            GH.charPos.step = 2;
        else
            --
        end

        if(GH.charPos.step == 2)then
            GH.charPos.step = 3;
            if(GH.look_north)then
                GH.look_north = false;
                GH.listen_GPS = false;
                SendChatMessage(".go xyz "..GH.charPos.X.." "..GH.charPos.Y.." "..GH.charPos.Z.." "..GH.charPos.Map.." "..0,"GUILD");
            end
        end
    end
end

GH.buttons_move1.Click = function(button)
    GH.listen_add = true;
    -- print(button);
    local DIST = tonumber((GH.buttons_move1.DIST):GetText());
    if(DIST == nil)then
        print("<GobHandler> Invalid number format : Move1-Distance");
    elseif(GH.data ~= nil)then
        local dirs = {};
        dirs["UP"] = {X=1,Y=0,Z=0};
        dirs["DOWN"] = {X=-1,Y=0,Z=0};
        dirs["RIGHT"] = {X=0,Y=1,Z=0};
        dirs["LEFT"] = {X=0,Y=-1,Z=0};
        dirs["LIFT"] = {X=0,Y=0,Z=1};
        dirs["LOWER"] = {X=0,Y=0,Z=-1};

        local dir = dirs[button];

        local gobX = GH.data.X + dir.X*DIST;
        local gobY = GH.data.Y + dir.Y*DIST;
        local gobZ = GH.data.Z + dir.Z*DIST;
        local gobMap = GH.data.MapID;
        local gobOri = GH.data.Orientation;
        local gobID = GH.data.ID;
        local oldGUID = GH.data.GUID;

        if(gobX ~= nil)then
            SendChatMessage(".go xyz "..gobX.." "..gobY.." "..gobZ,"GUILD");
            SendChatMessage(".gob delete "..oldGUID,"GUILD")
            delay(0.5, function() SendChatMessage(".gob add "..gobID,"GUILD"); end);
        end

    end
end

GH.buttons_move1.ClickGO = function()
    local GUID = GH.data.GUID;
    if(GUID ~= nil)then
        SendChatMessage(".go o "..GUID,"GUILD");
    end
end

GH.buttons_move1.LookNorth = function()
    GH.look_north = true;
    GH.listen_GPS = true;
    SendChatMessage(".gps","GUILD");
end


-- Filters

local FilterFrame = CreateFrame("Frame");
FilterFrame:RegisterEvent("PLAYER_LOGIN");
FilterFrame:SetScript("OnEvent",
	function(self, event, ...)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", SystFilter);
	end
);

function SystFilter(self,event,msg)
    return false;
end
