--[[
local base = CreateFrame("MessageFrame","MyBase", UIParent)
base:SetFrameStrata("BACKGROUND")
base:SetSize(200, 200)
base:SetPoint("CENTER",0,0)
base:Show()

local texture = base:CreateTexture(nil, "BACKGROUND")
texture:SetAllPoints(base)
texture:SetTexture(0.5, 0, 0, 0.5)
--]]

local dragFrame = CreateFrame("Frame", "DragFrame", UIParent)
dragFrame:SetMovable(true)
dragFrame:EnableMouse(true)
dragFrame:RegisterForDrag("LeftButton")
dragFrame:SetScript("OnDragStart", frame.StartMoving)
dragFrame:SetScript("OnDragStop", frame.StopMovingOrSizing)
-- The code below makes the frame visible, and is not necessary to enable dragging.
frame:SetPoint("CENTER"); frame:SetWidth(64); frame:SetHeight(64);
--local tex = frame:CreateTexture("ARTWORK");
--tex:SetAllPoints();
--tex:SetTexture(1.0, 0.5, 0); tex:SetAlpha(0.5);

local b = CreateFrame("Button", "MainButton", frame, "UIPanelButtonTemplate")
b:SetSize(100 ,30) -- width, height
b:SetText("Button!")
b:SetPoint("CENTER")
b:SetScript("OnClick", function()
    print("I'm in your buttonz")
end)
