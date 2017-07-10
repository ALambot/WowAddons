local ButtonText = "Freeze Z"
local Freezed = 0

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
        button:SetText(ButtonText)
    end
end)

-- Spam cacthing

local EventFrame = CreateFrame("Frame")
EventFrame:RegisterEvent("PLAYER_LOGIN")
EventFrame:SetScript("OnEvent",
	function(self, event, ...)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", filterGPS)

		end)

function filterGPS(self,event,msg)
	local five = string.sub(msg,1,5)
	if string.sub(msg,1,7) == "You are" then
		return true
    elseif string.sub(msg,1,4) == "Map:" then
        return true
	end

	return false
end

-- Freezing functions
