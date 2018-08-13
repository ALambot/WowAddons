local EventFrame = CreateFrame("Frame")
EventFrame:RegisterEvent("PLAYER_LOGIN")
EventFrame:SetScript("OnEvent",
	function(self, event, ...)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", filterAutoBroadcast)
			
		end)

function filterAutoBroadcast(self,event,msg)
	local five = string.sub(msg,1,5)
	if five = "[Auto" then
		return true
	end

	return false
end