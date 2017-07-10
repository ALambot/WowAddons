local ButtonText = "Freeze Z"
local Freezed = 0
local GPSasked = 0

--local time1 = 0
--local time2 = 0

local Ztarget = nil

-- Interface

local dragFrame = CreateFrame("Frame", "DragFrame", UIParent)
dragFrame:SetMovable(true)
dragFrame:EnableMouse(true)
dragFrame:RegisterForDrag("LeftButton")
dragFrame:SetScript("OnDragStart", frame.StartMoving)
dragFrame:SetScript("OnDragStop", frame.StopMovingOrSizing)

dragFrame:SetPoint("CENTER");
dragFrame:SetWidth(140);
dragFrame:SetHeight(50);
local tex = dragFrame:CreateTexture("ARTWORK");
tex:SetAllPoints();
tex:SetTexture(1.0, 0.5, 0); tex:SetAlpha(0.2);

local button = CreateFrame("Button", "MainButton", dragFrame, "UIPanelButtonTemplate")
button:SetSize(100 ,30) -- width, height
button:SetText(ButtonText)
button:SetPoint("CENTER")
button:SetScript("OnClick", function()
    if ButtonText == "Freeze Z" then
        ButtonText = "Unfreeze Z"
        Freezed = 1
        button:SetText(ButtonText)
    else
        ButtonText = "Freeze Z"
        Freezed = 0
        Ztarget = nil
        button:SetText(ButtonText)
    end
end)

-- Spam catching

local LoginFrame = CreateFrame("Frame")
LoginFrame:RegisterEvent("PLAYER_LOGIN")
LoginFrame:SetScript("OnEvent",
	function(self, event, ...)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", filterGPS)
		end)

function filterGPS(self,event,msg)
    if string.sub(msg,1,7) == "GroundZ" then
        return true
    elseif string.sub(msg,1,4) == "no V" then
        return true
    elseif GPSasked == 0 then
        return false
    elseif string.sub(msg,1,7) == "You are" then
		return true
    elseif string.sub(msg,1,4) == "Map:" then
        return true
    elseif string.sub(msg,1,7) == " ZoneX:" then
        return true
    elseif string.sub(msg,1,7) == "GroundZ" then
        return true
    elseif string.sub(msg,1,3) == "X: " then
        return true
    elseif string.sub(msg,1,5) == "grid[" then
        return true
	end
	return false
end

-- GPS position catching

local GPSFrame = CreateFrame("Frame")
GPSFrame:RegisterEvent("CHAT_MSG_SYSTEM")
GPSFrame:SetScript("OnEvent",
    function(self, event, ...)
	    local arg1 = ...

        if ((GPSasked == 1) and (string.sub(arg1,1,3) == "X: ")) then
            GPS = arg1

            local X = nil
            local Y = nil
            local Z = nil

            local i = 4
            local j = 4

            while string.sub(GPS,j,j) ~= " " do
                j = j + 1
            end
            X = string.sub(GPS,i,j-1)
            i = j+4
            j = j+4
            while string.sub(GPS,j,j) ~= " " do
                j = j + 1
            end
            Y = string.sub(GPS,i,j-1)
            i = j+4
            j = j+4
            while string.sub(GPS,j,j) ~= " " do
                j = j + 1
            end
            Z = string.sub(GPS,i,j-1)

            if Ztarget == nil then
                Ztarget = Z
            end

            SendChatMessage(".go xyz " .. X .. " " .. Y .. " " .. Ztarget, "GUILD")
            --time2 = GetTime()
            --print(time2 - time1)

            GPS = nil
        elseif ((GPSasked == 1) and (string.sub(arg1,1,7) == "GroundZ")) then
            GPSasked = 0
        end

    end)

-- Loop

local Running = 0
local Trigger = 2 --seconds

local function onUpdate(self,elapsed)
    Running = Running + elapsed
    if Running >= Trigger then
        --
        if Freezed == 1 then
            GPSasked = 1
            --time1 = GetTime()
            SendChatMessage(".gps", "GUILD")
        else
            GPSasked = 0
        end
        --
        Running = 0
    end
end

local LoopFrame = CreateFrame("Frame")
LoopFrame:SetScript("OnUpdate", onUpdate)
