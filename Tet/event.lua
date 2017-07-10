local EventFrame = CreateFrame("Frame")
EventFrame:RegisterEvent("CHAT_MSG_CHANNEL")
EventFrame:SetScript("OnEvent",
    function(self, event, ...)
	    local arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg11, arg12 = ...
			
		if arg9 == "xkcdtet" then
			-- SendChatMessage(arg2, "SAY", nil, nil)
			local msg = arg1
			local check = string.sub(msg, 1, 3)
			if check == "tet" then
				-- print("CHECK OK")
				local submsg = string.sub(msg, 5)
				-- 12 456 8 01234
				local targetLen = tonumber(string.sub(submsg, 1, 2))
				local target = string.sub(submsg, 4, 3+targetLen)
				local pref = string.sub(submsg, 5+targetLen, 5+targetLen)
				local content = string.sub(submsg, 7+targetLen)

				if target == UnitName("player") then
					-- print(pref .. " " .. content)
					
					if pref == "S" then
						SendChatMessage(content, "SAY", nil, nil)
					elseif pref == "Y" then
						SendChatMessage(content, "YELL", nil, nil)
					elseif pref == "W" then
						local wTarLen = tonumber(string.sub(content, 1, 2))
						local wTar = string.sub(content, 4, 3+wTarLen)
						local wContent = string.sub(content, 5+wTarLen)
						print("Target : " .. wTar .. " - Content : " .. wContent)
						SendChatMessage(wContent, "WHISPER", nil, wTar)
					elseif pref == "C" then
						local wTarLen = tonumber(string.sub(content, 1, 2))
						local wTar = string.sub(content, 4, 3+wTarLen)
						local chanIndex = GetChannelName(wTar)
						local wContent = string.sub(content, 5+wTarLen) 
						SendChatMessage(wContent, "CHANNEL", nil, chanIndex)
					elseif pref == "G" then					
						SendChatMessage("." .. content, "GUILD");
					else
						print ("Invalid prefix : " .. pref)
					end

				end
			end	
		end
		
	end)