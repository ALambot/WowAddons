local ButtonText = "Gob Delete"
local GobAsked = 0
local maxDist = 20

local listenToNext = 0

-- Interface

local GDdragFrame = CreateFrame("Frame", "GDDragFrame", UIParent)
GDdragFrame:SetMovable(true)
GDdragFrame:EnableMouse(true)
GDdragFrame:RegisterForDrag("LeftButton")
GDdragFrame:SetScript("OnDragStart", frame.StartMoving)
GDdragFrame:SetScript("OnDragStop", frame.StopMovingOrSizing)

GDdragFrame:SetPoint("CENTER");
GDdragFrame:SetWidth(140);
GDdragFrame:SetHeight(50);
local tex = GDdragFrame:CreateTexture("ARTWORK");
tex:SetAllPoints();
tex:SetTexture(1.0, 0.5, 0); tex:SetAlpha(0.2);

local button = CreateFrame("Button", "GDMainButton", GDdragFrame, "UIPanelButtonTemplate")
button:SetSize(100 ,30) -- width, height
button:SetText(ButtonText)
button:SetPoint("CENTER")
button:SetScript("OnClick", function()
    SendChatMessage(".gob t", "GUILD")
    GobAsked = 1
end)

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

                SendChatMessage(".gob del " .. GUID, "GUILD")

                GobAsked = 0
                listenToNext = 0

            end

        end

    end)
