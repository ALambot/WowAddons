local GH = _G.GH;

-- GUI Frames
local GH_master;
local GH_dragFrame;
    local GH_headerFrame;
    local GH_bodyFrame;
        local GH_body_targetButton;
        local GH_body_gobDetails;
            local GH_body_gD_name;
            local GH_body_gD_ID;
            local GH_body_gD_GUID;
    local GH_detailsFrame;
        local GH_det_picker;
            local GH_det_move1Picker;
            local GH_det_move2Picker;
        local GH_det_act;
            local GH_det_move1;
            local GH_det_move2;

-- Fun declare
local pickDet;

-- GUI Definition
local function GH_master_init()
    GH_master = CreateFrame("Frame","",UIParent);
    GH_master:SetSize(GH.addon_width,GH.addon_height+25);
    GH_master:SetPoint("CENTER");

    GH_master:SetMovable(true);
    GH_master:EnableMouse(true);
    GH_master:RegisterForDrag("LeftButton");

    GH_master:SetScript("OnDragStart", function(self)
        self:StartMoving();
    end);
    GH_master:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing();
    end);

    local GH_launcher = CreateFrame("Frame","",GH_master);
    GH_launcher:SetPoint("TOPLEFT");
    GH_launcher:SetSize(150,25);
    GH_launcher:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background",
                                            edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
                                            tile = true, tileSize = 16, edgeSize = 16,
                                            insets = { left = 4, right = 4, top = 4, bottom = 4 }});
    GH_launcher:SetBackdropColor(0,0,0,1);

    local toggleButton = CreateFrame("Button","",GH_launcher,"UIPanelButtonTemplate");
    toggleButton:SetSize(60,25);
    toggleButton:SetPoint("RIGHT");
    toggleButton:SetScript("OnClick", function()
        print(GH_launcher:GetTop().." "..GH_launcher:GetLeft());
        if(GH.shown)then
            GH.shown = false;
            local top = GH_launcher:GetTop();
            local left = GH_launcher:GetLeft();
            GH_dragFrame:Hide();
            GH_master:SetSize(150,25);
            GH_master:SetPoint("BOTTOMLEFT",nil,left,top-25)
        else
            local top = GH_launcher:GetTop();
            local left = GH_launcher:GetLeft();
            GH_master:SetSize(GH.addon_width,GH.addon_height+25);
            GH_master:SetPoint("BOTTOMLEFT",nil,left,top-25-GH.addon_height);
            GH.shown = true;
            GH_dragFrame:Show();
        end
    end);

    local text = GH_launcher:CreateFontString();
    text:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE, MONOCHROME");
    text:SetTextColor(0.9,0.8,0);
    text:SetPoint("LEFT",10,0);
    text:SetText("GobHandler");
end
--
local function GH_dragFrame_init()
    --GH_dragFrame = CreateFrame("Frame", "dragFrame", UIParent);
    GH_dragFrame = CreateFrame("Frame", "dragFrame", GH_master);

    GH_dragFrame:SetPoint("TOPLEFT",0,-25);
    GH_dragFrame:SetWidth(GH.addon_width);
    GH_dragFrame:SetHeight(GH.addon_height);

    GH_dragFrame:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background",
                                            edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
                                            tile = true, tileSize = 16, edgeSize = 16,
                                            insets = { left = 4, right = 4, top = 4, bottom = 4 }});
    GH_dragFrame:SetBackdropColor(0,0,0,1);
end
--
local function GH_headerFrame_init()
    GH_headerFrame = CreateFrame("Frame", "headerFrame", GH_dragFrame);
    GH_headerFrame:SetPoint("CENTER", 0, (GH_dragFrame:GetHeight()/3));
    GH_headerFrame:SetWidth(GH_dragFrame:GetWidth()-5);
    GH_headerFrame:SetHeight((GH_dragFrame:GetHeight()/3)-5);

    GH_headerFrame:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background",
                                            edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
                                            tile = true, tileSize = 16, edgeSize = 16,
                                            insets = { left = 4, right = 4, top = 4, bottom = 4 }});
    GH_headerFrame:SetBackdropColor(0,0,0,0);

    GH_headerFrame.texture = GH_headerFrame:CreateTexture();
    --GH_headerFrame.texture:SetAllPoints(GH_headerFrame);
    GH_headerFrame.texture:SetPoint("CENTER");
    GH_headerFrame.texture:SetSize(GH_headerFrame:GetWidth()-10,GH_headerFrame:GetHeight()-10);
    GH_headerFrame.texture:SetTexture("Interface\\AddOns\\GobHandler\\wip2.tga");
end
--
local function GH_bodyFrame_init()
    GH_bodyFrame = CreateFrame("Frame", "headerFrame", GH_dragFrame);
    GH_bodyFrame:SetPoint("CENTER", 0, 0);
    GH_bodyFrame:SetWidth(GH_dragFrame:GetWidth()-5);
    GH_bodyFrame:SetHeight((GH_dragFrame:GetHeight()/3)-5);

    GH_bodyFrame:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background",
                                            edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
                                            tile = true, tileSize = 16, edgeSize = 16,
                                            insets = { left = 4, right = 4, top = 4, bottom = 4 }});
    GH_bodyFrame:SetBackdropColor(0,0,0,0);
end
--
local function GH_detailsFrame_init()
    GH_detailsFrame = CreateFrame("Frame", "headerFrame", GH_dragFrame);
    GH_detailsFrame:SetPoint("CENTER", 0, -(GH_dragFrame:GetHeight()/3));
    GH_detailsFrame:SetWidth(GH_dragFrame:GetWidth()-5);
    GH_detailsFrame:SetHeight((GH_dragFrame:GetHeight()/3)-5);

    GH_detailsFrame:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background",
                                            edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
                                            tile = true, tileSize = 16, edgeSize = 16,
                                            insets = { left = 4, right = 4, top = 4, bottom = 4 }});
    GH_detailsFrame:SetBackdropColor(0,0,0,0);
end
--
local function GH_body_targetButton_init()
    GH_body_targetButton = CreateFrame("Button", "targetButton", GH_bodyFrame, "UIPanelButtonTemplate");
    GH_body_targetButton:SetPoint("TOP",0,-5);
    GH_body_targetButton:SetSize(GH_bodyFrame:GetWidth()-5, GH_bodyFrame:GetHeight()/4); -- width, height
    GH_body_targetButton:SetText("Target nearest GOB");
    GH_body_targetButton:SetScript("OnClick", function()
        SendChatMessage(".gob t","GUILD");
    end);
end
--
local function GH_body_gobDetails_init()
    GH_body_gobDetails = CreateFrame("Frame", "gobDetails", GH_bodyFrame);
    GH_body_gobDetails:SetPoint("BOTTOM");
    GH_body_gobDetails:SetSize(GH_bodyFrame:GetWidth(), GH_bodyFrame:GetHeight()*3/4);

    local infoBorder = CreateFrame("Frame", "infoBorder", GH_body_gobDetails);
    infoBorder:SetPoint("LEFT", 50, 0);
    infoBorder:SetWidth(GH_body_gobDetails:GetWidth()-50-5);
    infoBorder:SetHeight(GH_body_gobDetails:GetHeight()-5);
    infoBorder:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background",
                                            edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
                                            tile = true, tileSize = 16, edgeSize = 10,
                                            insets = { left = 4, right = 4, top = 4, bottom = 4 }});
    infoBorder:SetBackdropColor(0.9,0.2,0.2,0.2);

    local text1 = GH_body_gobDetails:CreateFontString();
    text1:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE, MONOCHROME");
    text1:SetTextColor(0.9,0.8,0);
    text1:SetPoint("LEFT", 10, GH_bodyFrame:GetHeight()/4.3);
    text1:SetText("Name");

    local text2 = GH_body_gobDetails:CreateFontString();
    text2:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE, MONOCHROME");
    text2:SetTextColor(0.9,0.8,0);
    text2:SetPoint("LEFT", 10, 0);
    text2:SetText("ID");

    local text3 = GH_body_gobDetails:CreateFontString();
    text3:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE, MONOCHROME");
    text3:SetTextColor(0.9,0.8,0);
    text3:SetPoint("LEFT", 10, -GH_bodyFrame:GetHeight()/4.3);
    text3:SetText("GUID");

    GH_body_gD_name = GH_body_gobDetails:CreateFontString();
    GH_body_gD_name:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE, MONOCHROME");
    GH_body_gD_name:SetTextColor(0.9,0.9,0.7);
    GH_body_gD_name:SetPoint("LEFT", 10+50, GH_bodyFrame:GetHeight()/4.3);
    GH_body_gD_name:SetText(GH.gobDetails[1]);

    GH_body_gD_ID = GH_body_gobDetails:CreateFontString();
    GH_body_gD_ID:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE, MONOCHROME");
    GH_body_gD_ID:SetTextColor(0.9,0.9,0.7);
    GH_body_gD_ID:SetPoint("LEFT", 10+50, 0);
    GH_body_gD_ID:SetText(GH.gobDetails[2]);

    GH_body_gD_GUID = GH_body_gobDetails:CreateFontString();
    GH_body_gD_GUID:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE, MONOCHROME");
    GH_body_gD_GUID:SetTextColor(0.9,0.9,0.7);
    GH_body_gD_GUID:SetPoint("LEFT", 10+50, -GH_bodyFrame:GetHeight()/4.3);
    GH_body_gD_GUID:SetText(GH.gobDetails[3]);
end
--
local function GH_det_picker_init()
    GH_det_picker = CreateFrame("Frame", "", GH_detailsFrame);
    GH_det_picker:SetSize(GH_detailsFrame:GetWidth(), GH_detailsFrame:GetHeight()/8);
    GH_det_picker:SetPoint("TOP",0,0);
end
--
local function GH_det_move1Picker_init()
    GH_det_move1Picker = CreateFrame("Button", "", GH_det_picker, "UIPanelButtonTemplate");
    GH_det_move1Picker:SetPoint("LEFT",0*GH_det_picker:GetWidth()/3,0);
    GH_det_move1Picker:SetSize(GH_det_picker:GetWidth()/3, GH_det_picker:GetHeight());
    GH_det_move1Picker:SetText("Move 1");
    GH_det_move1Picker:SetScript("OnClick", function()
        pickDet("move1");
    end);
end
--
local function GH_det_move2Picker_init()
    GH_det_move2Picker = CreateFrame("Button", "", GH_det_picker, "UIPanelButtonTemplate");
    GH_det_move2Picker:SetPoint("LEFT",1*GH_det_picker:GetWidth()/3,0);
    GH_det_move2Picker:SetSize(GH_det_picker:GetWidth()/3, GH_det_picker:GetHeight());
    GH_det_move2Picker:SetText("Move 2");
    GH_det_move2Picker:SetScript("OnClick", function()
        pickDet("move2");
    end);
end
--
local function GH_det_act_init()
    GH_det_act = CreateFrame("Frame", "", GH_detailsFrame);
    GH_det_act:SetSize(GH_detailsFrame:GetWidth(), 7*GH_detailsFrame:GetHeight()/8);
    GH_det_act:SetPoint("BOTTOM",0,0);
end
--
local function GH_det_move1_init()
    GH_det_move1 = CreateFrame("Frame", "", GH_det_act);
    GH_det_move1:SetSize(GH_det_act:GetWidth(), GH_det_act:GetHeight());
    GH_det_move1:SetPoint("CENTER",0,0);
    --GH_det_move1:Hide();

    local side = 40;
    local offset = 35;

    local buttonUP = CreateFrame("Button", "", GH_det_move1, "UIPanelButtonTemplate");
    buttonUP:SetSize(side,side);
    buttonUP:SetPoint("CENTER",0,offset);
    --buttonUP:SetText("^");
    buttonUP:SetText("NORTH");
    buttonUP:SetScript("OnClick", function()
            GH.buttons_move1.Click("UP");
        end);
    GH.buttons_move1.UP = buttonUP;

    local buttonDOWN = CreateFrame("Button", "", GH_det_move1, "UIPanelButtonTemplate");
    buttonDOWN:SetSize(side,side);
    buttonDOWN:SetPoint("CENTER",0,-offset);
    --buttonDOWN:SetText("v");
    buttonDOWN:SetText("SOUTH");
    buttonDOWN:SetScript("OnClick", function()
            GH.buttons_move1.Click("DOWN");
        end);
    GH.buttons_move1.DOWN = buttonDOWN;

    local buttonLEFT = CreateFrame("Button", "", GH_det_move1, "UIPanelButtonTemplate");
    buttonLEFT:SetSize(side,side);
    buttonLEFT:SetPoint("CENTER",-offset,0);
    --buttonLEFT:SetText("<");
    buttonLEFT:SetText("WEST");
    buttonLEFT:SetScript("OnClick", function()
            GH.buttons_move1.Click("LEFT");
        end);
    GH.buttons_move1.LEFT = buttonLEFT;

    local buttonRIGHT = CreateFrame("Button", "", GH_det_move1, "UIPanelButtonTemplate");
    buttonRIGHT:SetSize(side,side);
    buttonRIGHT:SetPoint("CENTER",offset,0);
    --buttonRIGHT:SetText(">");
    buttonRIGHT:SetText("EAST");
    buttonRIGHT:SetScript("OnClick", function()
            GH.buttons_move1.Click("RIGHT");
        end);
    GH.buttons_move1.RIGHT = buttonRIGHT;

    local buttonGO = CreateFrame("Button", "", GH_det_move1, "UIPanelButtonTemplate");
    buttonGO:SetSize(side,side);
    buttonGO:SetPoint("CENTER",0,0);
    buttonGO:SetText("GO");
    buttonGO:SetScript("OnClick", function()
            GH.buttons_move1.ClickGO();
        end);
    GH.buttons_move1.GO = buttonGO;

    local buttonLIFT = CreateFrame("Button", "", GH_det_move1, "UIPanelButtonTemplate");
    buttonLIFT:SetSize(side,side);
    buttonLIFT:SetPoint("CENTER",2.5*offset,offset);
    --buttonLIFT:SetText("^\n-");
    buttonLIFT:SetText("ALT+");
    buttonLIFT:SetScript("OnClick", function()
            GH.buttons_move1.Click("LIFT");
        end);
    GH.buttons_move1.LIFT = buttonLIFT;

    local buttonLOWER = CreateFrame("Button", "", GH_det_move1, "UIPanelButtonTemplate");
    buttonLOWER:SetSize(side,side);
    buttonLOWER:SetPoint("CENTER",2.5*offset,-offset);
    --buttonLOWER:SetText("-\nv");
    buttonLOWER:SetText("ALT-");
    buttonLOWER:SetScript("OnClick", function()
            GH.buttons_move1.Click("LOWER");
        end);
    GH.buttons_move1.LOWER = buttonLOWER;

    local editBoxDIST = CreateFrame("EditBox", "", GH_det_move1, "InputBoxTemplate");
    editBoxDIST:SetSize(1.2*side, side);
    editBoxDIST:SetText("1");
    editBoxDIST:SetPoint("CENTER", -3*offset, -offset);
    editBoxDIST:SetJustifyH("CENTER");
    editBoxDIST:SetAutoFocus(false);
    GH.buttons_move1.DIST = editBoxDIST;

    local textDIST = GH_det_move1:CreateFontString();
    textDIST:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE, MONOCHROME");
    textDIST:SetTextColor(0.9,0.8,0);
    textDIST:SetPoint("CENTER", -3*offset, -0.5*offset);
    textDIST:SetText("Distance");

    local buttonLOOKNORTH = CreateFrame("Button", "", GH_det_move1, "UIPanelButtonTemplate");
    buttonLOOKNORTH:SetSize(1.5*side,side);
    buttonLOOKNORTH:SetPoint("CENTER",-2.5*offset,offset);
    buttonLOOKNORTH:SetText("Face\nNorth");
    buttonLOOKNORTH:SetScript("OnClick", function()
            GH.buttons_move1.LookNorth();
        end);
    GH.buttons_move1.LookN = buttonLOOKNORTH;

end
--
local function GH_det_move2_init()
    GH_det_move2 = CreateFrame("Frame", "", GH_det_act);
    GH_det_move2:SetSize(GH_det_act:GetWidth(), GH_det_act:GetHeight());
    GH_det_move2:SetPoint("CENTER",0,0);

    GH_det_move2.texture = GH_det_move2:CreateTexture();
    GH_det_move2.texture:SetAllPoints(GH_det_move2);
    GH_det_move2.texture:SetTexture("Interface\\AddOns\\GobHandler\\wip.tga");

    GH_det_move2:Hide();
end
--

-- GUI functions

GH.update_gobDetails = function()
    GH_body_gD_name:SetText(GH.gobDetails[1]);
    GH_body_gD_ID:SetText(GH.gobDetails[2]);
    GH_body_gD_GUID:SetText(GH.gobDetails[3]);
end

pickDet = function(panel)
    GH_det_move1:Hide();
    GH_det_move2:Hide();

    if(panel == "move1")then
        GH_det_move1:Show();
    elseif(panel == "move2")then
        GH_det_move2:Show();
    else
        --
    end
end

-- GUI INIT
GH_master_init();
GH_dragFrame_init();

GH_headerFrame_init();
GH_bodyFrame_init();
GH_detailsFrame_init();

GH_body_targetButton_init();
GH_body_gobDetails_init();

GH_det_picker_init();
GH_det_move1Picker_init();
GH_det_move2Picker_init();

GH_det_act_init();
GH_det_move1_init();
GH_det_move2_init();
