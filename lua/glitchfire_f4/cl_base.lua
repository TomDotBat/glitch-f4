
include("glitchfire_f4/sh_config.lua")

local logo = Material( "glitchfire/logo/logo_cut.png", "noclamp smooth" )

local ply = LocalPlayer()

hook.Add("Think", "fixPlayer", function()
    if !IsValid(ply) then ply = LocalPlayer() hook.Remove("Think", "fixPlayer") end
end)

local PANEL = {}
local cos, sin, rad = math.cos, math.sin, math.rad

AccessorFunc( PANEL, "m_masksize", "MaskSize", FORCE_NUMBER )

function PANEL:Init()
    self.Avatar = vgui.Create("AvatarImage", self)
    self.Avatar:SetPaintedManually(true)
end

function PANEL:PerformLayout()
    self.Avatar:SetSize(self:GetWide(), self:GetTall())
end

function PANEL:SetPlayer( id, size )
    self.Avatar:SetPlayer( id, size )
end

function PANEL:Paint(w, h)
    render.ClearStencil()
    render.SetStencilEnable(true)

    render.SetStencilWriteMask( 1 )
    render.SetStencilTestMask( 1 )

    render.SetStencilFailOperation( STENCILOPERATION_REPLACE )
    render.SetStencilPassOperation( STENCILOPERATION_ZERO )
    render.SetStencilZFailOperation( STENCILOPERATION_ZERO )
    render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_NEVER )
    render.SetStencilReferenceValue( 1 )
    
    local _m = self.m_masksize
    
    local circle, t = {}, 0
    for i = 1, 360 do
        t = rad(i*720)/720
        circle[i] = { x = w/2 + cos(t)*_m, y = h/2 + sin(t)*_m }
    end
    draw.NoTexture()
    surface.SetDrawColor(color_white)
    surface.DrawPoly(circle)

    render.SetStencilFailOperation( STENCILOPERATION_ZERO )
    render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
    render.SetStencilZFailOperation( STENCILOPERATION_ZERO )
    render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL )
    render.SetStencilReferenceValue( 1 )

    self.Avatar:SetPaintedManually(false)
    self.Avatar:PaintManual()
    self.Avatar:SetPaintedManually(true)

    render.SetStencilEnable(false)
    render.ClearStencil()
end

vgui.Register("AvatarCircleMask", PANEL)

local PANEL = {}
local cos, sin, rad = math.cos, math.sin, math.rad

AccessorFunc( PANEL, "m_masksize", "MaskSize", FORCE_NUMBER )

function PANEL:Init()
    self.Model = vgui.Create("DModelPanel", self)
    self.Model:SetPaintedManually(true)
end

function PANEL:PerformLayout()
    self.Model:SetSize(self:GetWide(), self:GetTall())
end

function PANEL:GetModelPanel()
    return self.Model
end

function PANEL:Paint(w, h)
    render.ClearStencil()
    render.SetStencilEnable(true)

    render.SetStencilWriteMask( 1 )
    render.SetStencilTestMask( 1 )

    render.SetStencilFailOperation( STENCILOPERATION_REPLACE )
    render.SetStencilPassOperation( STENCILOPERATION_ZERO )
    render.SetStencilZFailOperation( STENCILOPERATION_ZERO )
    render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_NEVER )
    render.SetStencilReferenceValue( 1 )
    
    local _m = self.m_masksize
    
    local circle, t = {}, 0
    for i = 1, 360 do
        t = rad(i*720)/720
        circle[i] = { x = w/2 + cos(t)*_m, y = h/2 + sin(t)*_m }
    end
    draw.NoTexture()
    surface.SetDrawColor(color_white)
    surface.DrawPoly(circle)

    render.SetStencilFailOperation( STENCILOPERATION_ZERO )
    render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
    render.SetStencilZFailOperation( STENCILOPERATION_ZERO )
    render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL )
    render.SetStencilReferenceValue( 1 )
    
    surface.SetDrawColor(self.JobColor and self.JobColor or Color(36,36,36))
    surface.DrawRect(0, 0, w, h)

    self.Model:SetPaintedManually(false)
    self.Model:PaintManual()
    self.Model:SetPaintedManually(true)

    render.SetStencilEnable(false)
    render.ClearStencil()
end

vgui.Register("ModelCircleMask", PANEL)

local PANEL = {}

function PANEL:Init()
    self:Dock(TOP)
    self:DockMargin(0,0,0,getScaledSize(20, "y"))
    self:SetTall(getScaledSize(40, "y"))
end

function PANEL:AddButton(name, col, func)
    self.buttons = self.buttons or {}

    local num = #self.buttons + 1

    self.buttons[num] = vgui.Create("DButton", self)
    self.buttons[num].DoClick = func
    self.buttons[num].Paint = function(s,w,h)
        s:SetWide(math.Round(math.Round(self:GetWide()) / #self.buttons - (self.gapsValue and getScaledSize(self.gapsValue * 2, "y") or 0)))

        surface.SetDrawColor(s:IsHovered() and Color(math.Clamp(col.r + 40, 0, 255), math.Clamp(col.g + 40, 0, 255), math.Clamp(col.b + 40, 0, 255), 150) or col)
        surface.DrawRect(0, 0, w, h)

        draw.SimpleText(name, "GF_F4_20_30", w * .5, h * .5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    self.buttons[num]:Dock(LEFT)
    self.buttons[num]:SetText("")

    for i=1, #self.buttons do
        self.buttons[i]:DockMargin((self.gapsValue and getScaledSize(self.gapsValue, "y") or 0),0,(self.gapsValue and getScaledSize(self.gapsValue, "y") or 0),0)
    end
end

vgui.Register("GFF4ButtonPanel", PANEL)

local PANEL = {}

function PANEL:Init()
    self:SetTall(getScaledSize(60, "y"))
    self:Dock(TOP)
    self:DockMargin(0, getScaledSize(10, "y"), 0, 0)
    self:DockPadding(0,self:GetTall() * .30, getScaledSize(20, "x"), self:GetTall() * .30)

    self.modelDisplay = vgui.Create("ModelCircleMask", self)
    self.modelDisplay:SetSize(getScaledSize(50, "x"), getScaledSize(50, "x"))
    self.modelDisplay:SetPos(getScaledSize(20, "y"), getScaledSize(5, "y"))
    self.modelDisplay:SetMaskSize( getScaledSize(50 / 2, "x") )
end

function PANEL:GetModelDisplay()
    return self.modelDisplay
end

function PANEL:SetShipmentData(shipment)
    self:SetJobColor(Color(41, 128, 185, 60))

    self.overText = shipment.name
    self.underText = "Price: "..DarkRP.formatMoney(shipment.price)
    self.ButtonText = "Purchase [x"..shipment.amount.."]"

    local modeldisplay = self:GetModelDisplay().Model
    modeldisplay:SetModel(shipment.model)
    modeldisplay:SetFOV(50)
	modeldisplay:SetLookAt( Vector( 0, 0, 0 ) )

    self.buybutton = vgui.Create("DButton", self)
    self.buybutton:Dock(RIGHT)
    self.buybutton:SetText("")

    self.buybutton.DoClick = function()
        RunConsoleCommand("darkrp", "buyshipment", shipment.name)
    end

    surface.SetFont("GF_F4_20_30")
    local buttonW, buttonH = surface.GetTextSize(self.ButtonText)
    self.buybutton:SetWide(buttonW + getScaledSize(10, "x"))

    self.buybutton.Paint = function(s,w,h)
        local selectedColor = (LocalPlayer():getDarkRPVar("money") >= shipment.price ) and Color(46,204,113, 120) or Color(231, 76, 60, 120)
        
        if s:IsHovered() and (LocalPlayer():getDarkRPVar("money") >= shipment.price ) then
            selectedColor.r = selectedColor.r + 40
            selectedColor.g = selectedColor.g + 40
            selectedColor.b = selectedColor.b + 40
            selectedColor.a = 150
        end

        surface.SetDrawColor(selectedColor)
        surface.DrawRect(0, 0, w, h)

        draw.SimpleText(self.ButtonText, "GF_F4_16", w * .5, h * .5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
end


function PANEL:SetEntityData(tbl)
    self:SetJobColor(Color(41, 128, 185, 60))

    self.overText = tbl.name
    self.underText = "Price: "..DarkRP.formatMoney(tbl.price)
    self.ButtonText = "Purchase"

    local modeldisplay = self:GetModelDisplay().Model
    modeldisplay:SetModel(tbl.model)
    modeldisplay:SetFOV(50)
	modeldisplay:SetLookAt( Vector( 0, 0, 0 ) )

    self.buybutton = vgui.Create("DButton", self)
    self.buybutton:Dock(RIGHT)
    self.buybutton:SetText("")

    self.buybutton.DoClick = function()
        RunConsoleCommand("darkrp", tbl.cmd)
    end

    surface.SetFont("GF_F4_20_30")
    local buttonW, buttonH = surface.GetTextSize(self.ButtonText)
    self.buybutton:SetWide(buttonW + getScaledSize(10, "x"))

    self.buybutton.Paint = function(s,w,h)
        local selectedColor = (LocalPlayer():getDarkRPVar("money") >= tbl.price ) and Color(46,204,113, 120) or Color(231, 76, 60, 120)
        
        if s:IsHovered() and (LocalPlayer():getDarkRPVar("money") >= tbl.price ) then
            selectedColor.r = selectedColor.r + 40
            selectedColor.g = selectedColor.g + 40
            selectedColor.b = selectedColor.b + 40
            selectedColor.a = 150
        end

        surface.SetDrawColor(selectedColor)
        surface.DrawRect(0, 0, w, h)

        draw.SimpleText(self.ButtonText, "GF_F4_16", w * .5, h * .5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
end

function PANEL:SetJobID(id)
    self.jobID = id
    self.overText = RPExtraTeams[id].name
    self.underText = "Salary: "..DarkRP.formatMoney(RPExtraTeams[id].salary)
    self:SetJobColor(RPExtraTeams[id].color)

    local modeldisplay = self:GetModelDisplay().Model

    local model = istable(RPExtraTeams[id].model) and RPExtraTeams[id].model[1] or RPExtraTeams[id].model
    model = util.IsValidModel(model) and model or "models/player/skeleton.mdl"
    modeldisplay:SetModel(model)
    function modeldisplay:LayoutEntity( Entity ) return end


	local eyepos = modeldisplay.Entity:LookupBone( "ValveBiped.Bip01_Head1" ) and modeldisplay.Entity:GetBonePosition( modeldisplay.Entity:LookupBone( "ValveBiped.Bip01_Head1" ) ) or Vector(15, 0, 45)
    eyepos:Add( Vector( 10, 0, 2 ) )
    modeldisplay:SetLookAt( eyepos )
    modeldisplay:SetCamPos( eyepos-Vector( -12, 0, 0 ) )
    modeldisplay.Entity:SetEyeTarget( eyepos-Vector( -12, 0, 0 ) )

    self.becomebutton = vgui.Create("DButton", self)
    self.becomebutton:Dock(RIGHT)
    self.becomebutton:SetText("")

    self.becomebutton.DoClick = function()
        glitchfiref4:SetVisible(false)
        if ((team.NumPlayers(id) >= RPExtraTeams[id].max) and RPExtraTeams[id].max > 0) then
            return
        end

        if istable(RPExtraTeams[id].model) and #RPExtraTeams[id].model > 1 then
            local TopBarHeight = getScaledSize(24, "y")

            local modelselector = vgui.Create("DFrame")
            modelselector:MakePopup()
            modelselector:SetTitle("")
            modelselector:ShowCloseButton(false)
            modelselector:SetSize(ScrW() * .25, ScrH() * .172)
            modelselector:DockPadding(0,getScaledSize(24, "y"),0,0)
            modelselector:Center()

            modelselector.Paint = function(s,w,h)
                surface.SetDrawColor(Color(20,20,20, 250))
                surface.DrawRect(0, 0, w, h)

                surface.SetDrawColor(Color(26,26,26, 250))
                surface.DrawRect(0, 0, w, TopBarHeight)

                draw.SimpleText("Model Selector", "GF_F4_22",  getScaledSize(10, "x"), TopBarHeight * .5, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            end

            local closebutton = vgui.Create("DButton", modelselector)
            closebutton:SetSize(TopBarHeight,TopBarHeight)
            closebutton:SetPos(modelselector:GetWide() - closebutton:GetWide(), 0)
            closebutton:SetText("")
        
            closebutton.DoClick = function()
                modelselector:Remove()
            end
        
            closebutton.Paint = function(s,w,h)
                local width = getScaledSize(1, "X")
                local height = h * .9
        
                draw.NoTexture()
        
                surface.SetDrawColor(color_white)
                surface.DrawTexturedRectRotated(w - (height * .5), h * .5 - (width * .5), width, height, 45)
                surface.DrawTexturedRectRotated(w - (height * .5), h * .5 - (width * .5), width, height, -45)
            end

            local modelpanel = vgui.Create("DScrollPanel", modelselector)
            modelpanel:Dock(FILL)

            local vbar = modelpanel:GetVBar()

            vbar:SetWide(7)
        
            vbar.Paint = function(s,w,h)
                surface.SetDrawColor(GLITCHFIREF4.CONFIG.MainColor)
                surface.DrawRect(0, 0, w, h)
            end
        
            vbar.btnGrip.Paint = function(s,w,h)
                surface.SetDrawColor(50, 50, 50, 255)
                surface.DrawRect(0, 0, w, h)
            end
        
            vbar.btnUp.Paint = function() end
            vbar.btnDown.Paint = function() end

            local function addModelRow(row)
            	local modelselection = vgui.Create("EditablePanel", modelpanel)
                modelselection:Dock(TOP)
                modelselection:SetTall(getScaledSize(80, "y"))
                modelselection:DockMargin(getScaledSize(10, "x"), 0, 0, 0)
                modelselection:DockPadding(0, 0, getScaledSize(30, "x"), 0)

                for k,v in pairs(row) do
                	local modelDisplay = vgui.Create("ModelCircleMask", modelselection)
	                modelDisplay:Dock(LEFT)
                	modelDisplay:DockPadding(0, 0, getScaledSize(30, "x"), 0)
                	modelDisplay:DockMargin(0, 0, getScaledSize(10, "x"), 0)
	                modelDisplay:SetSize(getScaledSize(67, "x"), getScaledSize(67, "x"))
	                modelDisplay:SetPos(getScaledSize(40, "y"), getScaledSize(10, "y"))
	                modelDisplay:SetMaskSize( getScaledSize(67 / 2, "x") )
	                modelDisplay.JobColor = RPExtraTeams[id].color

	                local modelpreview = modelDisplay:GetModelPanel()
	                modelpreview:SetFOV(50)
	                modelpreview:SetLookAt( Vector( 0, 0, 0 ) )
	                v = util.IsValidModel(v) and v or "models/player/skeleton.mdl"
	                modelpreview:SetModel(v)

	                function modelpreview:LayoutEntity( Entity ) return end
            
	                local eyepos = modelpreview.Entity:LookupBone( "ValveBiped.Bip01_Head1" ) and modelpreview.Entity:GetBonePosition( modelpreview.Entity:LookupBone( "ValveBiped.Bip01_Head1" ) ) or Vector(15, 0, 45)
	                eyepos:Add( Vector( 10, 0, 2 ) )
	                modelpreview:SetLookAt( eyepos )
	                modelpreview:SetCamPos( eyepos-Vector( -12, 0, 0 ) )
	                modelpreview.Entity:SetEyeTarget( eyepos-Vector( -12, 0, 0 ) )

	                local selectbutton = vgui.Create("DButton", modelDisplay)
	                selectbutton:Dock(FILL)
	                selectbutton:SetText("")

	                selectbutton.DoClick = function()
	                	modelselector:Remove()
	                    DarkRP.setPreferredJobModel(id, v)
	                    if RPExtraTeams[id].vote then
				        	RunConsoleCommand("darkrp", "vote" .. RPExtraTeams[id].command)
				        else
				        	RunConsoleCommand("darkrp", RPExtraTeams[id].command)
				        end
	                end
	                
	                selectbutton.Paint = function(s,w,h) end
                end
                modelselection:InvalidateLayout(true)
            end

            local row = {}
            for k,v in pairs(RPExtraTeams[id].model) do
            	row[#row + 1] = v
            	if #row > 5 then
            		addModelRow(row)
            		row = {}
            	end
            end

            if #row > 0 then
        		addModelRow(row)
        	end

        return end

        if RPExtraTeams[id].vote then
        	RunConsoleCommand("darkrp", "vote" .. RPExtraTeams[id].command)
        else
        	RunConsoleCommand("darkrp", RPExtraTeams[id].command)
        end
    end

    self.becomebutton.Paint = function(s,w,h)
        local action = RPExtraTeams[id].vote and "Create Vote" or "Become" --- Sick optimization right?

        self.ButtonText = action.." ["..team.NumPlayers(id).."/"..(RPExtraTeams[id].max > 0 and RPExtraTeams[id].max or "∞").."]"

        surface.SetFont("GF_F4_20_30")
        local buttonW, buttonH = surface.GetTextSize(self.ButtonText)

        self.becomebutton:SetWide(buttonW + getScaledSize(10, "x"))

        local selectedColor = ((team.NumPlayers(id) < RPExtraTeams[id].max) or RPExtraTeams[id].max <= 0) and Color(46,204,113, 120) or Color(231, 76, 60, 120)
        
        if s:IsHovered() and ((team.NumPlayers(id) < RPExtraTeams[id].max) or RPExtraTeams[id].max <= 0) then
            selectedColor.r = selectedColor.r + 40
            selectedColor.g = selectedColor.g + 40
            selectedColor.b = selectedColor.b + 40
            selectedColor.a = 150
        end
        surface.SetDrawColor(selectedColor)
        surface.DrawRect(0, 0, w, h)

        draw.SimpleText(self.ButtonText, "GF_F4_16", w * .5, h * .5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    if RPExtraTeams[id].description then
        local infobutton = vgui.Create("DButton", self)
        infobutton:Dock(RIGHT)
        infobutton:SetText("")
        infobutton:SetWide(getScaledSize(24, "y"))
        infobutton:DockMargin(0,0,getScaledSize(10, "x"), 0)

        infobutton.Paint = function(s,w,h)
            local infocolor = Color(41,128,185, 120)

            if s:IsHovered() then
                infocolor.r = infocolor.r + 40
                infocolor.g = infocolor.g + 40
                infocolor.b = infocolor.b + 40
                infocolor.a = 150
            end
            surface.SetDrawColor(infocolor)
            surface.DrawRect(0, 0, w, h)

            draw.SimpleText("i", "GF_F4_16_30", w * .45, h * .5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        infobutton.DoClick = function()
            local infopanel = vgui.Create("GFF4_InfoBox")
            infopanel:SetText(RPExtraTeams[id].description)
            infopanel:SetTtle("Description")
        end
    end   
end

function PANEL:SetJobColor(col)
    col.a = 100
    self:GetModelDisplay().JobColor = col
end

function PANEL:Paint(w, h)
    draw.SimpleText(self.overText and self.overText or "", "GF_F4_20_50", getScaledSize(80, "y"), h * .5, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
    draw.SimpleText(self.underText and self.underText or "", "GF_F4_16_10", getScaledSize(80, "y"), h * .5, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    
    if self.jobID and RPExtraTeams[self.jobID].role and GLITCHFIREF4.CONFIG.Roles[RPExtraTeams[self.jobID].role] then
        surface.SetFont("GF_F4_20_50")
        local overtextwide, overtextheight = surface.GetTextSize(self.overText and self.overText or "")
        
        surface.SetFont("GF_F4_12_10")
        local innerboxwide, innerboxheight = surface.GetTextSize(GLITCHFIREF4.CONFIG.Roles[RPExtraTeams[self.jobID].role].name)

        draw.RoundedBox(6, getScaledSize(80, "y") + overtextwide + getScaledSize(5, "x"), h * .5 - (overtextheight * .5) - ((innerboxheight + getScaledSize(7, "y")) * .5), innerboxwide + getScaledSize(12, "x"), innerboxheight + getScaledSize(7, "y"), GLITCHFIREF4.CONFIG.Roles[RPExtraTeams[self.jobID].role].color)
        draw.SimpleText(GLITCHFIREF4.CONFIG.Roles[RPExtraTeams[self.jobID].role].name, "GF_F4_12_10",getScaledSize(80, "y") + overtextwide + getScaledSize(5, "x") + ((innerboxwide + getScaledSize(12, "x")) * .5),h * .5 - (overtextheight * .5) - ((innerboxheight + getScaledSize(7, "y")) * .5) + ((innerboxheight + getScaledSize(7, "y")) * .5), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
end

vgui.Register("GFF4_ProductBox", PANEL)

local PANEL = {}

function PANEL:Init()
    self.TopBarHeight = getScaledSize(24, "y")

    self:SetTall(self.TopBarHeight)

    surface.SetFont("GF_F4_22")

    self:SetWide(select(1, surface.GetTextSize("Information")) + getScaledSize(20))


    self.closebutton = vgui.Create("DButton", self)
    self.closebutton:SetSize(self.TopBarHeight,self.TopBarHeight)
    self.closebutton:SetPos(self:GetWide() - self.closebutton:GetWide(), 0)
    self.closebutton:SetText("")

    self.closebutton.DoClick = function()
        self:Remove()
    end

    self.closebutton.Paint = function(s,w,h)
        local width = getScaledSize(1, "X")
        local height = h * .9

        draw.NoTexture()

        surface.SetDrawColor(color_white)
        surface.DrawTexturedRectRotated(w - (height * .5), h * .5 - (width * .5), width, height, 45)
        surface.DrawTexturedRectRotated(w - (height * .5), h * .5 - (width * .5), width, height, -45)
    end

    self:Center()
    self:SetTitle("")
    self:ShowCloseButton(false)
    self:MakePopup()
end

function PANEL:Resize()
    surface.SetFont("GF_F4_22")

    local titlew, titleh = surface.GetTextSize(self.Title and self.Title or "")
    local comparew = self.Parsed and self.Parsed:GetWidth() or 0


    self:SetWide((titlew > comparew and titlew or comparew) + getScaledSize(20))
    self:SetTall(self.TopBarHeight + (self.Parsed and self.Parsed:GetHeight() or 0) + getScaledSize(20))

    self.closebutton:SetPos(self:GetWide() - self.closebutton:GetWide(), 0)

    self:Center()
end

function PANEL:SetText(str)
    self.Parsed = markup.Parse( "<colour=255, 255, 255, 255><font=GF_F4_20_50>"..str.."</font></colour>" )

    self:Resize()
end

function PANEL:SetTtle(str)
    self.Title = str

    self:Resize()
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(Color(20,20,20, 250))
    surface.DrawRect(0, 0, w, h)

    surface.SetDrawColor(Color(26,26,26, 250))
    surface.DrawRect(0, 0, w, self.TopBarHeight)

    draw.SimpleText(self.Title and self.Title or "Information", "GF_F4_22",  getScaledSize(10, "x"), self.TopBarHeight * .5, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

    h = h - self.TopBarHeight
    
    if self.Parsed then
        self.Parsed:Draw(w * .5, self.TopBarHeight + h * .5,TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)     
    end
end

vgui.Register("GFF4_InfoBox", PANEL, "DFrame")

local PANEL = {}

function PANEL:Init()
    self.TopBarHeight = getScaledSize(24, "y")

    surface.SetFont("GF_F4_22")

    self:SetWide(select(1, surface.GetTextSize("Information")) + getScaledSize(20))

    self.closebutton = vgui.Create("DButton", self)
    self.closebutton:SetSize(self.TopBarHeight,self.TopBarHeight)
    self.closebutton:SetPos(self:GetWide() - self.closebutton:GetWide(), 0)
    self.closebutton:SetText("")

    self.closebutton.DoClick = function()
        self:Remove()
    end

    self.closebutton.Paint = function(s,w,h)
        local width = getScaledSize(1, "X")
        local height = h * .9

        draw.NoTexture()

        surface.SetDrawColor(color_white)
        surface.DrawTexturedRectRotated(w - (height * .5), h * .5 - (width * .5), width, height, 45)
        surface.DrawTexturedRectRotated(w - (height * .5), h * .5 - (width * .5), width, height, -45)
    end

	self.entry = vgui.Create( "DTextEntry", self )
	self.entry:Dock(TOP)
    self.entry:DockMargin(0,getScaledSize(10, "y"),0,getScaledSize(10, "y"))
	self.entry:SetTall(getScaledSize(32,"y"))
	self.entry:SetDrawLanguageID(false)
	self.entry:SetFont("GF_F4_16_10") 
	self.entry.Paint = function(s,w,h)
		surface.SetDrawColor(Color(255,255,255, 120))
		surface.DrawRect(0, h - 1, w, 1)
		s:DrawTextEntryText( Color(255,255,255, 120), Color(0, 0, 255, 255), Color(255,255,255) ) 
	end

    self.submitbutton = vgui.Create("DButton", self)
    self.submitbutton:Dock(FILL)
    self.submitbutton:SetTall(getScaledSize(32,"y"))
    self.submitbutton.DoClick = function() self.func(self.entry) end
    self.submitbutton:SetText("")

    local col = Color(41, 128, 185, 120)

    self.submitbutton.Paint = function(s,w,h)
        surface.SetDrawColor(s:IsHovered() and Color(math.Clamp(col.r + 40, 0, 255), math.Clamp(col.g + 40, 0, 255), math.Clamp(col.b + 40, 0, 255), 150) or col)
        surface.DrawRect(0, 0, w, h)

        draw.SimpleText("Submit", "GF_F4_20_30", w * .5, h * .5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    self:SetTall(self.TopBarHeight + self.submitbutton:GetTall() + self.entry:GetTall() + getScaledSize(10, "y") + getScaledSize(10, "y"))

    self:Center()
    self:SetTitle("")
    self:ShowCloseButton(false)
    self:MakePopup()
end

function PANEL:Resize()
    surface.SetFont("GF_F4_22")

    local titlew, titleh = surface.GetTextSize(self.Title and self.Title or "")

    self:SetWide((titlew) + getScaledSize(70))
    self.submitbutton:SetWide((titlew) + getScaledSize(70))
    self.entry:SetWide((titlew) + getScaledSize(70))

    self.closebutton:SetPos(self:GetWide() - self.closebutton:GetWide(), 0)

    self:Center()
end

function PANEL:SetTtle(str)
    self.Title = str

    self:Resize()
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(Color(20,20,20, 250))
    surface.DrawRect(0, 0, w, h)

    surface.SetDrawColor(Color(26,26,26, 250))
    surface.DrawRect(0, 0, w, self.TopBarHeight)

    draw.SimpleText(self.Title and self.Title or "Information", "GF_F4_22",  getScaledSize(10, "x"), self.TopBarHeight * .5, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
end

vgui.Register("GFF4_RequestCommand", PANEL, "DFrame")

local PANEL = {}

function PANEL:Init()
    self:SetTall(getScaledSize(40, "y"))

    local titlebox = vgui.Create("EditablePanel", self)
    titlebox:Dock(TOP)
    titlebox:SetTall(getScaledSize(40, "y"))

    titlebox.Paint = function(s,w,h)
        surface.SetDrawColor(color_black)
        surface.DrawRect(0, 0, w, h)
        draw.SimpleText(self.title and self.title or "", "GF_F4_22_30", getScaledSize(20, "y"), h * .5, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    self.canvas = vgui.Create("DScrollPanel", self)
    self.canvas:Dock(FILL)
    self.canvas.Paint = function(s,w,h)
        surface.SetDrawColor(GLITCHFIREF4.CONFIG.MainColor)
        surface.DrawRect(0, 0, w, h)
    end
end

function PANEL:RemoveBoxSize(box, additional)
    additional = additional or 0
    if !IsValid(box) then self:SetTall(self:GetTall() - additional) return end
    self:SetTall(self:GetTall() - box:GetTall() - additional)
end

function PANEL:AddBoxSize(box, additional)
    additional = additional or 0
    if !IsValid(box) then self:SetTall(self:GetTall() + additional) return end
    self:SetTall(self:GetTall() + box:GetTall() + additional)
end

function PANEL:Paint(w,h)

end

function PANEL:GetCanvas()
    return self.canvas
end

function PANEL:SetTitle(str)
    self.title = str
end

vgui.Register("GFTabs", PANEL)

local PANEL = {}

function PANEL:Init()
    self:SetSize(getScaledSize(1040, "x") , getScaledSize(768, "y"))
    self:Center()
    self:MakePopup()

    self.closebar = vgui.Create("EditablePanel", self)
    self.closebar:Dock(TOP)
    self.closebar:DockMargin(getScaledSize(214, "x") + 1,0,0,0)
    self.closebar:SetTall(getScaledSize(36, "y"))

    self.closebar.Paint = function(s,w,h)
        surface.SetDrawColor(color_black)
        surface.DrawRect(0, 0, w, h)
    end

    self.closebutton = vgui.Create("DButton", self.closebar)
    self.closebutton:Dock(RIGHT)
    self.closebutton:SetWide(getScaledSize(36, "y") - getScaledSize(10, "x"))
    self.closebutton:DockMargin(getScaledSize(5, "x"),getScaledSize(5, "x"),getScaledSize(5, "x"),getScaledSize(5, "x"))
    self.closebutton:SetText("")

    self.closebutton.DoClick = function()
        self:Close()
    end

    self.closebutton.Paint = function(s,w,h)
        local width = getScaledSize(1, "X")
        local height = h * .9

        draw.NoTexture()

        surface.SetDrawColor(color_white)
        surface.DrawTexturedRectRotated(w - (height * .5), h * .5 - (width * .5), width, height, 45)
        surface.DrawTexturedRectRotated(w - (height * .5), h * .5 - (width * .5), width, height, -45)
    end

    self:CreateSidepanel()
    self:CreateCanvas()

    for k,v in pairs(GLITCHFIREF4.CONFIG.Tabs) do
        self:AddTab(k)
    end
end

function PANEL:HandleTab(name)
    if IsValid(self.activeTab) then
        self.activeTab:SetVisible(false)
        if (self.activeTab.OnVisibleChange) and isfunction(self.activeTab.OnVisibleChange) then
            self.activeTab.OnVisibleChange(false)
        end
    end

    self.activeTab = self.tabs[name]

    if IsValid(self.tabs[name]) then
        self.tabs[name]:SetVisible(true)

        if ( self.tabs[name].OnVisibleChange) and isfunction( self.tabs[name].OnVisibleChange) then
             self.tabs[name].OnVisibleChange(true)
        end
    end
end

function PANEL:AddTab(name)
    self.tabs = self.tabs or {}

    local tabcanvas = vgui.Create("DScrollPanel", self.Canvas) 
    tabcanvas:Dock(FILL)
    
    tabcanvas:GetCanvas():DockPadding(getScaledSize(20, "y"), getScaledSize(20, "y"), getScaledSize(20, "y"), getScaledSize(20, "y"))

    tabcanvas:SetVisible(false)

    local vbar = tabcanvas:GetVBar()

    vbar:SetWide(7)

    vbar.Paint = function(s,w,h)
        surface.SetDrawColor(GLITCHFIREF4.CONFIG.MainColor)
        surface.DrawRect(0, 0, w, h)
    end

    vbar.btnGrip.Paint = function(s,w,h)
        surface.SetDrawColor(50, 50, 50, 255)
        surface.DrawRect(0, 0, w, h)
    end

    vbar.btnUp.Paint = function() end
    vbar.btnDown.Paint = function() end

    self.tabs[name] = tabcanvas

    local tab = vgui.Create("DButton", self.sidetabs)
    tab:SetTall(getScaledSize(60, "y"))
    tab:Dock(TOP)
    tab:DockMargin(0, getScaledSize(5, "y"), 0, getScaledSize(5, "y"))
    tab:SetText("")
    tab:SetZPos(GLITCHFIREF4.CONFIG.Tabs[name] and (GLITCHFIREF4.CONFIG.Tabs[name].sortOrder and GLITCHFIREF4.CONFIG.Tabs[name].sortOrder or 0) or 9999 )

    tab.generated = false

    tab.DoClick = function()
        if !tab.generated and isfunction(GLITCHFIREF4.CONFIG.Tabs[name].buildFunction) then
            GLITCHFIREF4.CONFIG.Tabs[name].buildFunction(tabcanvas)
            tab.generated = true
        end
        self:HandleTab(name)
    end


    tab.Paint = function(s,w,h)
        tab.alpha = tab.alpha or 0
        tab.alpha = Lerp(RealFrameTime() * 20, tab.alpha, (self.activeTab == tabcanvas and 255 or (s:IsHovered() and 255 or 0)))
        surface.SetDrawColor(Color(GLITCHFIREF4.CONFIG.AccentColor.r, GLITCHFIREF4.CONFIG.AccentColor.g, GLITCHFIREF4.CONFIG.AccentColor.b, math.Clamp(tab.alpha, 0, GLITCHFIREF4.CONFIG.AccentColor.a)))
        surface.DrawRect(0, 0, w, h)

        draw.SimpleText(name, "GF_F4_22_10", w * .5, h * .5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    if !self.activeTab and GLITCHFIREF4.CONFIG.Tabs[name] and GLITCHFIREF4.CONFIG.Tabs[name].sortOrder == 1 then self.activeTab = tabcanvas tab.DoClick() end
end

function PANEL:CreateSidepanel()
    self.sidepanel = vgui.Create("EditablePanel", self)
    self.sidepanel:SetSize(getScaledSize(215, "x"), self:GetTall())

    self.sidepanel.Paint = function(s,w,h)
        surface.SetDrawColor(GLITCHFIREF4.CONFIG.MainColor)
        surface.DrawRect(0, 0, w, h)
    end

    self.profilepicture = vgui.Create("AvatarCircleMask", self.sidepanel)
    self.profilepicture:SetPlayer(LocalPlayer(), 184)
    self.profilepicture:SetSize(getScaledSize(115, "x"), getScaledSize(115, "x"))
    self.profilepicture:SetPos(self.sidepanel:GetWide() * .5 - self.profilepicture:GetWide() * .5, getScaledSize(40, "y"))
    self.profilepicture:SetMaskSize( getScaledSize(115 / 2, "x") )

    self.persona = vgui.Create("EditablePanel", self.sidepanel)
    self.persona:SetSize(getScaledSize(215, "x"), getScaledSize(768, "y"))
    self.persona:SetPos(0, getScaledSize(115, "x") + getScaledSize(40, "y") + getScaledSize(5, "y"))

    surface.SetFont("GF_F4_22")

    local namew, nameh = surface.GetTextSize(ply:Nick())
    local jobw, jobh = surface.GetTextSize(ply:getJobTable().name)
    
    self.persona:SetTall(nameh + jobh + getScaledSize(5, "y") + getScaledSize(25,"y"))

    self.persona.Paint = function(s,w,h)
        if !IsValid(ply) then ply = LocalPlayer() end
        draw.SimpleText(ply:Nick(), "GF_F4_22_10000", w * .5, 0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
        draw.SimpleText(ply:getJobTable().name, "GF_F4_22_10", w * .5, nameh + getScaledSize(5, "y"), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
    end

    self.sidetabs = vgui.Create("DScrollPanel", self.sidepanel)
    self.sidetabs:SetSize(getScaledSize(215, "x"), self:GetTall() - self.persona:GetTall() - self.profilepicture:GetTall() - getScaledSize(40, "y") - getScaledSize(20, "y"))
    self.sidetabs:SetPos(0,self:GetTall() - self.sidetabs:GetTall() - getScaledSize(5, "y"))

    local vbar = self.sidetabs:GetVBar()
    vbar:SetWidth(0)
    vbar.Paint = function() end

    for k,v in pairs(vbar:GetChildren()) do
        v.Paint = function() end
    end
end

function PANEL:CreateCanvas()
    self.Canvas = vgui.Create("EditablePanel", self)
    self.Canvas:SetSize(self:GetWide() - self.sidepanel:GetWide(), self:GetTall() - getScaledSize(36, "y"))
    self.Canvas:SetPos(self.sidepanel:GetWide(), getScaledSize(36, "y"))

end

function PANEL:Close()
    self:SetVisible(false)
    self.OpenedProperly = false
end

function PANEL:Think()
    if input.IsButtonDown(KEY_F4) then
        if self.OpenedProperly then
            self:Close()
        end
    else  
        self.OpenedProperly = true
    end
end

function PANEL:Paint(w,h)
    local sizew, sizeh = getScaledSize(574, "x"), getScaledSize(574, "x")
	surface.SetMaterial( logo )
	surface.SetDrawColor( 255, 255, 255, 150 )
	surface.DrawTexturedRect( w - sizew, h - sizeh, sizew, sizeh )

    surface.SetDrawColor(GLITCHFIREF4.CONFIG.MainColor)
    surface.DrawRect(0, 0, w, h)
end

vgui.Register("GlitchFireF4", PANEL, "EditablePanel")