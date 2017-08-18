local ButtonText = "Gob Delete"
local GobAsked = 0
local maxDist = 40

local listenToNext = 0
local listenGobPos = 0
local listenGPS = 0

local X1, Y1, Z1, X2, Y2, Z2

-- Interface

local GDdragFrame = CreateFrame("Frame", "GDDragFrame", UIParent)
GDdragFrame:SetMovable(true)
GDdragFrame:EnableMouse(true)
GDdragFrame:RegisterForDrag("LeftButton")
GDdragFrame:SetScript("OnDragStart", frame.StartMoving)
GDdragFrame:SetScript("OnDragStop", frame.StopMovingOrSizing)

GDdragFrame:SetPoint("CENTER");
GDdragFrame:SetWidth(150);
GDdragFrame:SetHeight(125);
    --[[ local tex = GDdragFrame:CreateTexture("ARTWORK");
    tex:SetAllPoints();
    tex:SetTexture(1.0, 0.5, 0); tex:SetAlpha(0.2); ]]--

GDdragFrame:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background",
                                            edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
                                            tile = true, tileSize = 16, edgeSize = 16,
                                            insets = { left = 4, right = 4, top = 4, bottom = 4 }});
GDdragFrame:SetBackdropColor(0,0,0,1);

local GDMainButton = CreateFrame("Button", "GDMainButton", GDdragFrame, "UIPanelButtonTemplate")
GDMainButton:SetSize(120 ,40) -- width, height
GDMainButton:SetText(ButtonText)
GDMainButton:SetPoint("TOP", 0, -15)
GDMainButton:SetScript("OnClick", function()
    SendChatMessage(".gob t", "GUILD")
    GobAsked = 1
end)

local GDchatFilterCheckButton = CreateFrame("CheckButton", "GDCheckButton1", GDdragFrame, "OptionsCheckButtonTemplate")
GDchatFilterCheckButton:SetSize(30 ,30) -- width, height
GDchatFilterCheckButton:SetPoint("LEFT", 15, -20)
GDchatFilterCheckButton:SetChecked(true);
getglobal(GDchatFilterCheckButton:GetName() .. "Text"):SetText("Chat Filter");

local GDdistanceCheckButton = CreateFrame("CheckButton", "GDCheckButton2", GDdragFrame, "OptionsCheckButtonTemplate")
GDdistanceCheckButton:SetSize(30 ,30) -- width, height
GDdistanceCheckButton:SetPoint("LEFT", 15, -40)
GDdistanceCheckButton:SetChecked(true);
getglobal(GDdistanceCheckButton:GetName() .. "Text"):SetText("Max Distance");

-- Nearest Gob catching

local GobFrame = CreateFrame("Frame")
GobFrame:RegisterEvent("CHAT_MSG_SYSTEM")
GobFrame:SetScript("OnEvent",
    function(self, event, ...)
	    local arg1 = ...

        if ( string.sub(arg1,1,16) == "Selected object:" ) then
            listenToNext = 1

        elseif (GobAsked == 1 and listenToNext == 1) then

            local i = 1
            local found = false
            while ( i+5 < string.len(arg1) and string.sub(arg1,i,i+5) ~= "GUID: ") do
                if(string.sub(arg1,i,i+5) ~= "GUID: ") then
                    found = true
                end
                i = i+1
            end

            if found then

                local j = i+6

                while (string.sub(arg1,j,j) ~= " ") do
                    j = j+1
                end

                GUID = string.sub(arg1,i+6,j-1)

                if tonumber(GUID) > 11600000 then -- GUID security check
                    --SendChatMessage(".gob del " .. GUID, "GUILD")
                    if GDdistanceCheckButton:GetChecked() ~= nil then
                        listenGobPos = 1
                    else
                        SendChatMessage(".gob del " .. GUID, "GUILD")
                        print("Gob removed : " .. GUID)
                    end
                else
                    print("GUID TOO OLD !")
                end

                GobAsked = 0
                listenToNext = 0

            end

        elseif (listenGobPos == 1 and (string.sub(arg1,1,3) == "X: ")) then
            GPS = arg1

            local X = nil
            local Y = nil
            local Z = nil

            local i = 4
            local j = 4

            while string.sub(GPS,j,j) ~= " " do
                j = j + 1
            end
            X = tonumber(string.sub(GPS,i,j-1))
            i = j+4
            j = j+4
            while string.sub(GPS,j,j) ~= " " do
                j = j + 1
            end
            Y = tonumber(string.sub(GPS,i,j-1))
            i = j+4
            j = j+4
            while string.sub(GPS,j,j) ~= " " do
                j = j + 1
            end
            Z = tonumber(string.sub(GPS,i,j-1))

            X1 = X
            Y1 = Y
            Z1 = Z

            SendChatMessage(".gps ", "GUILD")

            listenGobPos = 0
            listenGPS = 1

        elseif (listenGPS == 1 and (string.sub(arg1,1,3) == "X: ")) then
            GPS = arg1

            local X = nil
            local Y = nil
            local Z = nil

            local i = 4
            local j = 4

            while string.sub(GPS,j,j) ~= " " do
                j = j + 1
            end
            X = tonumber(string.sub(GPS,i,j-1))
            i = j+4
            j = j+4
            while string.sub(GPS,j,j) ~= " " do
                j = j + 1
            end
            Y = tonumber(string.sub(GPS,i,j-1))
            i = j+4
            j = j+4
            while string.sub(GPS,j,j) ~= " " do
                j = j + 1
            end
            Z = tonumber(string.sub(GPS,i,j-1))

            local dist = (X-X1)*(X-X1) + (Y-Y1)*(Y-Y1) + (Z-Z1)*(Z-Z1)

            if maxDist*maxDist > dist then
                SendChatMessage(".gob del " .. GUID, "GUILD")
                print("Gob removed : " .. GUID)
            else
                print("Gob too far")
            end

            listenGPS = 0

        end

    end)


-- Chat filter

local GDChatFilterFrame = CreateFrame("Frame")
GDChatFilterFrame:RegisterEvent("PLAYER_LOGIN")
GDChatFilterFrame:SetScript("OnEvent",
	function(self, event, ...)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", GDChatFilter)
		end)

function GDChatFilter(self,event,msg)
    if GDchatFilterCheckButton:GetChecked() ~= nil then
        return true
    end

	return false
end
