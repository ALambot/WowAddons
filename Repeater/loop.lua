local buttonText = "Start";
local command = "";
local delay = 1;

local loop_running = 0;
local loop_trigger = 0;

local flag_running = 0;

local Loop_Push_dragFrame;
local Loop_Push_MainButton;
local Loop_Push_EditBoxInstr;
local Loop_Push_EditBoxDelay;
local Loop_Push_TextInstr;

--

Loop_Push_dragFrame = CreateFrame("Frame", "DragFrame", UIParent)

Loop_Push_dragFrame:SetMovable(true)
Loop_Push_dragFrame:EnableMouse(true)
Loop_Push_dragFrame:RegisterForDrag("LeftButton")
Loop_Push_dragFrame:SetScript("OnDragStart", function(self)
    self:StartMoving();
end)
Loop_Push_dragFrame:SetScript("OnDragStop", function(self)
    self:StopMovingOrSizing();
end)

Loop_Push_dragFrame:SetPoint("CENTER");
Loop_Push_dragFrame:SetWidth(130);
Loop_Push_dragFrame:SetHeight(130);

Loop_Push_dragFrame:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background",
                                            edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
                                            tile = true, tileSize = 16, edgeSize = 16,
                                            insets = { left = 4, right = 4, top = 4, bottom = 4 }});
Loop_Push_dragFrame:SetBackdropColor(0,0,0,1);

--

Loop_Push_MainButton = CreateFrame("Button", "MainButton", Loop_Push_dragFrame, "UIPanelButtonTemplate")
Loop_Push_MainButton:SetSize(100, 30) -- width, height
Loop_Push_MainButton:SetText(buttonText)
Loop_Push_MainButton:SetPoint("CENTER", 0, 45)
Loop_Push_MainButton:SetScript("OnClick", function()

    Loop_Push_EditBoxInstr:ClearFocus();
    Loop_Push_EditBoxDelay:ClearFocus();
    if(buttonText == "Start") then

        command = Loop_Push_EditBoxInstr:GetText();
        delay = Loop_Push_EditBoxDelay:GetNumber();
        if(delay > 0.2 and delay < 1000 and string.len(command) > 0) then
            flag_running = 1;
            loop_running = delay;
            loop_trigger = delay;

            buttonText = "Stop";
            Loop_Push_MainButton:SetText(buttonText);
            Loop_Push_dragFrame:SetBackdropColor(0,1,0,1);
        else
            buttonText = "Error";
            Loop_Push_MainButton:SetText(buttonText);
            Loop_Push_dragFrame:SetBackdropColor(1,0,0,1);
        end


    elseif(buttonText == "Stop") then
        flag_running = 0;
        loop_running = 0;

        buttonText = "Start";
        Loop_Push_MainButton:SetText(buttonText);
        Loop_Push_dragFrame:SetBackdropColor(0,0,0,1);

    else
        buttonText = "Start";
        Loop_Push_MainButton:SetText(buttonText);
        Loop_Push_dragFrame:SetBackdropColor(0,0,0,1);

    end
end)

Loop_Push_EditBoxInstr = CreateFrame("EditBox", "EditBoxInstr", Loop_Push_dragFrame, "InputBoxTemplate")
Loop_Push_EditBoxInstr:SetSize(100, 30) -- width, height
Loop_Push_EditBoxInstr:SetText("")
Loop_Push_EditBoxInstr:SetPoint("CENTER", 0, 0)
Loop_Push_EditBoxInstr:SetAutoFocus(false)

Loop_Push_EditBoxDelay = CreateFrame("EditBox", "EditBoxDelay", Loop_Push_dragFrame, "InputBoxTemplate")
Loop_Push_EditBoxDelay:SetSize(100, 30) -- width, height
Loop_Push_EditBoxDelay:SetText("1")
Loop_Push_EditBoxDelay:SetPoint("CENTER", 0, -40)
Loop_Push_EditBoxDelay:SetAutoFocus(false)

Loop_Push_TextInstr = Loop_Push_dragFrame:CreateFontString("TextInstr")
Loop_Push_TextInstr:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE, MONOCHROME")
Loop_Push_TextInstr:SetTextColor(1,0.9,0)
Loop_Push_TextInstr:SetPoint("CENTER", 0, 20)
Loop_Push_TextInstr:SetText("Commande")

Loop_Push_TextDelay = Loop_Push_dragFrame:CreateFontString("TextDelay")
Loop_Push_TextDelay:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE, MONOCHROME")
Loop_Push_TextDelay:SetTextColor(1,0.9,0)
Loop_Push_TextDelay:SetPoint("CENTER", 0, -20)
Loop_Push_TextDelay:SetText("Délai")

--

local function onUpdate(self,elapsed)
    loop_running = loop_running + elapsed
    if loop_running >= loop_trigger then
        --
            if(flag_running == 1) then
                SendChatMessage(command,"GUILD");
            end
        --
        loop_running = 0
    end
end

local LoopFrame = CreateFrame("Frame")
LoopFrame:SetScript("OnUpdate", onUpdate)
