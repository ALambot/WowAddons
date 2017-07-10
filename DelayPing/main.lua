local total = 0
 
local function onUpdate(self,elapsed)
    total = total + elapsed
    if total >= 2 then
        DEFAULT_CHAT_FRAME:AddMessage("ping!")
        total = 0
    end
end
 
local f = CreateFrame("frame")
f:SetScript("OnUpdate", onUpdate)