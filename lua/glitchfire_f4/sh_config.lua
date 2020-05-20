GLITCHFIREF4 = GLITCHFIREF4 or {}
GLITCHFIREF4.CONFIG = {}

GLITCHFIREF4.CONFIG.MainColor = Color(0,0,0,210)
GLITCHFIREF4.CONFIG.AccentColor = Color(255, 68, 23, 100)
GLITCHFIREF4.CONFIG.Roles = {
    [1] = {
        name = "Bronze Donator",
        color = Color(205, 127, 50, 120)
    },
    [2] = {
        name = "Silver Donator",
        color = Color(192, 192, 192, 120)
    },
    [3] = {
        name = "Gold Donator",
        color = Color(255, 215, 0, 120)
    },
    [4] = {
        name = "Diamond Donator",
        color = Color(115, 185, 255, 120)
    },
    [10] = {
        name = "Staff",
        color = Color(118, 46, 166, 120)
    }
}

GLITCHFIREF4.CONFIG.News = "Welcome to Glitch Fire. We hope you enjoy your stay, feedback is welcome!"

GLITCHFIREF4.CONFIG.Tabs = {
    ["Dashboard"] = {sortOrder = 1, buildFunction = function(panel)
        panel:GetCanvas():DockPadding(0,getScaledSize(20, "y"),0,getScaledSize(20, "y"))

        local news = vgui.Create("EditablePanel", panel)
        news:SetTall(getScaledSize(35, "y"))
        news:Dock(TOP)
        news:DockMargin(getScaledSize(20, "y"),0,getScaledSize(20, "y"),getScaledSize(20, "y"))

        news.Paint = function(s,w,h)
            surface.SetDrawColor(color_white)
            surface.DrawOutlinedRect(0, 0, w, h)

            draw.SimpleText(GLITCHFIREF4.CONFIG.News, "GF_F4_20_10", getScaledSize(20, "y"), h * .5, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end

        local lawboard = vgui.Create("GFTabs", panel)
        lawboard:SetTitle("Laws")
        lawboard:SetTall(getScaledSize(258, "y"))
        lawboard:Dock(TOP)
        lawboard:DockMargin(getScaledSize(20, "y"),0,getScaledSize(20, "y"),getScaledSize(20, "y"))

        local lawscanvas = lawboard:GetCanvas()

        local laws = DarkRP.getLaws()
        local addedLaws = {}

        local function addLaw(name)
            local law = vgui.Create("EditablePanel", lawscanvas)
            law:Dock(TOP)

            surface.SetFont("GF_F4_20_30")
            local width, height = surface.GetTextSize(name)
            law:SetTall(height)

            law.Paint = function(s,w,h)
                if name == "" then return end
                draw.SimpleText("- "..name, "GF_F4_20_30", getScaledSize(20, "y"), h * .5, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            end

            addedLaws[law] = true
        end

        local function rebuildLaws()
            for k,v in pairs(addedLaws) do
                k:Remove()
            end

            addLaw("")
            laws = DarkRP.getLaws()

            for k,v in pairs(laws) do
                addLaw(v)
            end
        end

        rebuildLaws()

        hook.Add("addLaw", "RebuildLawBoard", rebuildLaws)
        hook.Add("removeLaw", "RebuildLawBoard", rebuildLaws)

        local recentjobs = vgui.Create("GFTabs", panel)
        recentjobs:SetTitle("Recent Jobs")
        recentjobs:Dock(TOP)
        recentjobs:DockMargin(getScaledSize(20, "y"),0,getScaledSize(20, "y"),getScaledSize(20, "y"))
        recentjobs:AddBoxSize(nil, getScaledSize(10, "y") )

        local recentjobscanvas = recentjobs:GetCanvas()

        if !file.Exists("gfRecentJobs.txt", "DATA") then
            file.Write("gfRecentJobs.txt", util.TableToJSON({}))
        end

        local prevJobBoxes = {}

        local function rebuildJobs()
            local previousJobs = file.Read("gfRecentJobs.txt")
            previousJobs = util.JSONToTable(previousJobs)

            for k,v in pairs(prevJobBoxes) do
                prevJobBoxes[k] = nil

                recentjobs:RemoveBoxSize(k, getScaledSize(10, "y") )
                k:Remove()
            end

            local iteration = 0
            for k,v in pairs(previousJobs) do
                iteration = iteration + 1
                if iteration > 3 then return end
                local jobbox = vgui.Create("GFF4_ProductBox", recentjobscanvas)
                jobbox:SetJobID(k)
                jobbox:SetZPos(v)

                recentjobs:AddBoxSize(jobbox, getScaledSize(10, "y") )
                prevJobBoxes[jobbox] = true
            end

            if table.Count(table.GetKeys(previousJobs)) <= 0 then
                recentjobs:SetVisible(false)
            else
                recentjobs:SetVisible(true)
            end
        end

        rebuildJobs()

        local buttonbox = vgui.Create("GFF4ButtonPanel", panel)
        buttonbox:DockMargin(getScaledSize(14, "y"),0,getScaledSize(14, "y"),0)
        buttonbox.gapsValue = 6

        buttonbox:AddButton("Discord", Color(114, 137, 218, 120), function() gui.OpenURL("https://discord.gg/pyrGrjC") end)
        buttonbox:AddButton("Store", Color(52, 152, 219, 120), function() gui.OpenURL("https://glitchfire.com/index.php?t=shop") end)
        buttonbox:AddButton("Website", Color(255, 68, 23, 120), function() gui.OpenURL("https://glitchfire.com/") end)
        buttonbox:AddButton("Workshop", Color(243, 156, 18, 120), function() gui.OpenURL("https://steamcommunity.com/sharedfiles/filedetails/?id=1940110165") end)

        hook.Add("OnPlayerChangedTeam", "UpdateRecentJobs", function(ply, old, new)
            if ply ~= LocalPlayer() then return end
            local previousJobs = file.Read("gfRecentJobs.txt")
            previousJobs = util.JSONToTable(previousJobs)
            
            if #table.GetKeys(previousJobs) >= 3 then
                local lowest = -os.time()
                for k,v in pairs(previousJobs) do
                    if v > lowest then lowest = v end
                end

                for k,v in pairs(previousJobs) do
                    if v == lowest then previousJobs[k] = nil end
                end
            end

            previousJobs[new] = -os.time()

            file.Write("gfRecentJobs.txt", util.TableToJSON(previousJobs))

            rebuildJobs()
        end)
    end},

    ["Commands"] = {sortOrder = 2, buildFunction = function(panel)
        local basiccommands = vgui.Create("GFTabs", panel)
        basiccommands:SetTitle("Basic")
        basiccommands:Dock(TOP)
        basiccommands:DockMargin(0,0,0,getScaledSize(20, "y"))

        local basiccommandscanvas = basiccommands:GetCanvas()
    
        local buttonbox1 = vgui.Create("GFF4ButtonPanel", basiccommandscanvas)
        buttonbox1.gapsValue = 5

        buttonbox1:AddButton("Change Name", Color(41, 128, 185, 120), function() 
            local confirmBox = vgui.Create("GFF4_RequestCommand")
            confirmBox:SetTtle("Change Name")
            confirmBox.func = function(entrybox)
                if !IsValid(entrybox) then confirmBox:Remove() end
                RunConsoleCommand("say", string.format( "/rpname %s", entrybox:GetText()))
                confirmBox:Remove()
            end
        end)
        buttonbox1:AddButton("Change Job", Color(41, 128, 185, 120), function()
            local confirmBox = vgui.Create("GFF4_RequestCommand")
            confirmBox:SetTtle("Change Job")
            confirmBox.func = function(entrybox)
                if !IsValid(entrybox) then confirmBox:Remove() end
                RunConsoleCommand("say", string.format( "/job %s", entrybox:GetText()))
                confirmBox:Remove()
            end
        end)
        buttonbox1:AddButton("Request License", Color(41, 128, 185, 120), function() RunConsoleCommand("say", "/requestlicense") end)
        buttonbox1:DockMargin(getScaledSize(10, "y"),getScaledSize(20, "y"),getScaledSize(10, "y"),getScaledSize(10, "y"))

        basiccommands:AddBoxSize(buttonbox1, getScaledSize(10, "y") + getScaledSize(20, "y"))

        local buttonbox2 = vgui.Create("GFF4ButtonPanel", basiccommandscanvas)
        buttonbox2.gapsValue = 5

        buttonbox2:AddButton("Drop Weapon", Color(41, 128, 185, 120), function() RunConsoleCommand("say", "/drop") end)
        buttonbox2:AddButton("Sell All Doors", Color(41, 128, 185, 120), function() RunConsoleCommand("say", "/unownalldoors") end)
        buttonbox2:DockMargin(getScaledSize(10, "y"),0,getScaledSize(10, "y"),getScaledSize(20, "y"))

        basiccommands:AddBoxSize(buttonbox2, getScaledSize(20, "y"))

        local buttonbox3 = vgui.Create("GFF4ButtonPanel", basiccommandscanvas)
        buttonbox3.gapsValue = 5

        buttonbox3:AddButton("Drop Money", Color(39, 174, 96, 120), function()
            local confirmBox = vgui.Create("GFF4_RequestCommand")
            confirmBox:SetTtle("Drop Money")
            confirmBox.entry:SetNumeric(true)
            confirmBox.func = function(entrybox)
                if !IsValid(entrybox) then confirmBox:Remove() end
                RunConsoleCommand("say", string.format( "/moneydrop %s", entrybox:GetValue() ))
                confirmBox:Remove()
            end
        end)
        buttonbox3:AddButton("Give Money", Color(39, 174, 96, 120), function()
            local confirmBox = vgui.Create("GFF4_RequestCommand")
            confirmBox:SetTtle("Drop Money")
            confirmBox.entry:SetNumeric(true)
            confirmBox.func = function(entrybox)
                if !IsValid(entrybox) then confirmBox:Remove() end
                local lookingat = LocalPlayer():GetEyeTrace().Entity
                if !IsValid(lookingat) or !IsPlayer(lookingat) then notification.AddLegacy("You need to be looking at a player!", 1, 5) return end
                RunConsoleCommand("say", string.format( "/cheque %s %i",lookingat:Nick(), cheque:GetValue() ))

                confirmBox:Remove()
            end
        end)
        buttonbox3:DockMargin(getScaledSize(10, "y"),0,getScaledSize(10, "y"),getScaledSize(20, "y"))

        basiccommands:AddBoxSize(buttonbox3, getScaledSize(20, "y"))

        local governmentcommands = vgui.Create("GFTabs", panel)
        governmentcommands:SetTitle("Government")
        governmentcommands:Dock(TOP)
        governmentcommands:DockMargin(0,0,0,getScaledSize(20, "y"))

        local governmentcommandscanvas = governmentcommands:GetCanvas()

        local buttonbox4 = vgui.Create("GFF4ButtonPanel", governmentcommandscanvas)
        buttonbox4.gapsValue = 5

        buttonbox4:AddButton("Request Search Warrant", Color(243, 156, 18, 120), function()
            local confirmBox = vgui.Create("GFF4_RequestCommand")
            confirmBox:SetTtle("Request Search Warrant")
            confirmBox.func = function(entrybox)
                if !IsValid(entrybox) then confirmBox:Remove() end
                RunConsoleCommand("say", string.format( "/warrant %s", entrybox:GetText())) 
                confirmBox:Remove()
            end
        end)
        buttonbox4:AddButton("Remove Search Warrant", Color(243, 156, 18, 120), function()
            local confirmBox = vgui.Create("GFF4_RequestCommand")
            confirmBox:SetTtle("Remove Search Warrant")
            confirmBox.func = function(entrybox)
                if !IsValid(entrybox) then confirmBox:Remove() end
                RunConsoleCommand("say", string.format( "/unwarrant %s", entrybox:GetText()))
                confirmBox:Remove()
            end
        end)
        buttonbox4:AddButton("Make Wanted", Color(243, 156, 18, 120), function()
            local confirmBox = vgui.Create("GFF4_RequestCommand")
            confirmBox:SetTtle("Make Wanted")
            confirmBox.func = function(entrybox)
                if !IsValid(entrybox) then confirmBox:Remove() end
                RunConsoleCommand("say", string.format( "/wanted %s", entrybox:GetText()))
                confirmBox:Remove()
            end
        end)
        buttonbox4:DockMargin(getScaledSize(10, "y"),getScaledSize(20, "y"),getScaledSize(10, "y"),getScaledSize(10, "y"))

        governmentcommands:AddBoxSize(buttonbox4, getScaledSize(10, "y") + getScaledSize(20, "y"))

        local buttonbox5 = vgui.Create("GFF4ButtonPanel", governmentcommandscanvas)
        buttonbox5.gapsValue = 5

        buttonbox5:AddButton("Remove Wanted", Color(243, 156, 18, 120), function()
            local confirmBox = vgui.Create("GFF4_RequestCommand")
            confirmBox:SetTtle("Remove Wanted")
            confirmBox.func = function(entrybox)
                if !IsValid(entrybox) then confirmBox:Remove() end
                RunConsoleCommand("say", string.format( "/unwanted %s", entrybox:GetText()))
                confirmBox:Remove()
            end
         end)
        buttonbox5:DockMargin(getScaledSize(10, "y"),0,getScaledSize(10, "y"),getScaledSize(20, "y"))

        governmentcommands:AddBoxSize(buttonbox5, getScaledSize(20, "y"))

        local mayorcommands = vgui.Create("GFTabs", panel)
        mayorcommands:SetTitle("Mayor")
        mayorcommands:Dock(TOP)
        mayorcommands:DockMargin(0,0,0,getScaledSize(20, "y"))

        local mayorcommandscanvas = mayorcommands:GetCanvas()

        local buttonbox6 = vgui.Create("GFF4ButtonPanel", mayorcommandscanvas)
        buttonbox6.gapsValue = 5

        buttonbox6:AddButton("Start Lockdown", Color(231, 76, 60, 120), function() RunConsoleCommand("say", "/lockdown") end)
        buttonbox6:AddButton("Stop Lockdown", Color(231, 76, 60, 120), function() RunConsoleCommand("say", "/unlockdown") end)
        buttonbox6:AddButton("Add Law", Color(231, 76, 60, 120), function()
            local confirmBox = vgui.Create("GFF4_RequestCommand")
            confirmBox:SetTtle("Add Law")
            confirmBox.func = function(entrybox)
                if !IsValid(entrybox) then confirmBox:Remove() end
                RunConsoleCommand("say", string.format( "/addlaw %s", entrybox:GetText()))
                confirmBox:Remove()
            end
        end)
        buttonbox6:DockMargin(getScaledSize(10, "y"),getScaledSize(20, "y"),getScaledSize(10, "y"),getScaledSize(10, "y"))

        mayorcommands:AddBoxSize(buttonbox6, getScaledSize(10, "y") + getScaledSize(20, "y"))

        local buttonbox7 = vgui.Create("GFF4ButtonPanel", mayorcommandscanvas)
        buttonbox7.gapsValue = 5

        buttonbox7:AddButton("Remove Law", Color(231, 76, 60, 120), function()
            local confirmBox = vgui.Create("GFF4_RequestCommand")
            confirmBox:SetTtle("Remove Law")
            confirmBox.func = function(entrybox)
                if !IsValid(entrybox) then confirmBox:Remove() end
                RunConsoleCommand("say", string.format( "/removelaw %s", entrybox:GetText()))
                confirmBox:Remove()
            end
        end)
        buttonbox7:AddButton("Place Lawboard", Color(231, 76, 60, 120), function() RunConsoleCommand("say", "/placelaws") end)
        buttonbox7:DockMargin(getScaledSize(10, "y"),0,getScaledSize(10, "y"),getScaledSize(20, "y"))

        mayorcommands:AddBoxSize(buttonbox7, getScaledSize(20, "y"))

        if !RPExtraTeams[LocalPlayer():Team()].mayor then
            mayorcommands:SetVisible(false)
        end

        governmentcommands:SetVisible(LocalPlayer():isCP())

        hook.Add("OnPlayerChangedTeam", "UpdateCommandBlocks", function(ply, old, new)
            if ply == LocalPlayer() then
                if IsValid(mayorcommands) then
                    if RPExtraTeams[new].mayor then
                        mayorcommands:SetVisible(true)
                    else
                        mayorcommands:SetVisible(false)
                    end
                end

                if IsValid(governmentcommands) then
                    timer.Simple(.1, function()
                        governmentcommands:SetVisible(LocalPlayer():isCP())
                    end)
                end
            end
        end)
    end},
    ["Jobs"] = {sortOrder = 3, buildFunction = function(panel)
        local tabTable = {}

        local exitbar = panel:GetParent():GetParent().closebar

        panel.searchicon = vgui.Create("EditablePanel", exitbar)
        panel.searchicon:Dock(LEFT)
        panel.searchicon:DockMargin(getScaledSize(15, "y"),getScaledSize(8, "y"),0,getScaledSize(8, "y"))

        local icon = Material( "glitchfire/f4/search.png", "noclamp smooth" )

        panel.searchicon.Paint = function(s,w,h)
            s:SetWide(s:GetTall())
            surface.SetMaterial( icon )
            surface.SetDrawColor( 255, 255, 255, 120 )
            local iconsizew, iconsizeh = w * .8, h * .8
            surface.DrawTexturedRect( w * .5 - iconsizew * .5, h * .5 - iconsizeh * .5, iconsizew, iconsizeh )
        end

        panel.entry = vgui.Create( "DTextEntry", exitbar )
        panel.entry:Dock(LEFT)
        panel.entry:DockMargin(getScaledSize(3, "y"),getScaledSize(8, "y"),getScaledSize(5, "y"),getScaledSize(8, "y"))
        panel.entry:SetWide(getScaledSize(112,"x"))
        panel.entry:SetDrawLanguageID(false)
        panel.entry:SetPlaceholderText( "Search..." )
        panel.entry:SetPlaceholderColor(Color(255,255,255, 120))
        panel.entry:SetFont("GF_F4_16_10")
        panel.entry.Paint = function(s,w,h)
            surface.SetDrawColor(Color(255,255,255, 120))
            surface.DrawRect(0, h - 1, w, 1)
            if s:GetText() == "" and !s:HasFocus() then draw.SimpleText("Search...", "GF_F4_16_10", getScaledSize(3, "x"), h * .5, Color( 255, 255, 255, 120 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER) end
            s:DrawTextEntryText( Color(255,255,255, 120), Color(0, 0, 255, 255), Color(255,255,255) ) 
	    end

        panel.entry.OnChange = function()
            local val = panel.entry:GetText()
            if !isstring(val) then return end
            val = string.lower(val)

            for k,v in pairs(tabTable) do
                local canvas = k:GetCanvas()
                for z, i in pairs(canvas.Jobs) do
                    if !z.overText or !IsValid(z) then return end
                    if !string.find(string.lower(z.overText), val) then
                        if z:IsVisible() then
                            k:RemoveBoxSize(z, getScaledSize(10, "y") )
                        end

                        z:SetVisible(false)
                    else
                        if !z:IsVisible() then
                            k:AddBoxSize(z, getScaledSize(10, "y") )
                        end

                        z:SetVisible(true)
                    end
                end
            end

            for k,v in pairs(tabTable) do
                local count = 0
                local canvas = k:GetCanvas()
                for i, z in pairs(canvas.Jobs) do
                    if i:IsVisible() then
                        count = count + 1
                    end
                end

                if count <= 0 then 
                    k:SetVisible(false)
                    k:GetParent():InvalidateLayout(true)
                else
                    k:SetVisible(true)
                    k:GetParent():InvalidateLayout(true)
                end
            end
        end

        panel.OnVisibleChange = function(status)
            panel.searchicon:SetVisible(status)
            panel.entry:SetVisible(status)
        end

        panel.searchicon:SetVisible(false)
        panel.entry:SetVisible(false)

        for i, z in pairs(DarkRP.getCategories().jobs) do
            local tab = vgui.Create("GFTabs", panel)
            tab:SetTitle(z.name)
            tab:Dock(TOP)
            tab:DockMargin(0,0,0,getScaledSize(20, "y"))
            tab:SetZPos(z.sortOrder)

            tabTable[tab] = true

            local canvas = tab:GetCanvas()
            canvas.Jobs = canvas.Jobs or {}

            for k,v in pairs(RPExtraTeams) do
                if !v.category or v.category ~= z.name then continue end
                local jobbox = vgui.Create("GFF4_ProductBox", canvas)
                jobbox:SetJobID(k)

                canvas.Jobs[jobbox] = true

                tab:AddBoxSize(jobbox, getScaledSize(10, "y") )
            end

            tab:AddBoxSize(nil, getScaledSize(10, "y") )
        end

        for k,v in pairs(tabTable) do
            local count = 0
            local canvas = k:GetCanvas()
            for i, z in pairs(canvas.Jobs) do
                if i:IsVisible() then
                    count = count + 1
                end
            end

            if count <= 0 then 
                k:SetVisible(false)
            else
                k:SetVisible(true)
            end
        end
    end},
    ["Entities"] = {sortOrder = 4, buildFunction = function(panel)
        local tabTable = {}

        local exitbar = panel:GetParent():GetParent().closebar

        panel.searchicon = vgui.Create("EditablePanel", exitbar)
        panel.searchicon:Dock(LEFT)
        panel.searchicon:DockMargin(getScaledSize(15, "y"),getScaledSize(8, "y"),0,getScaledSize(8, "y"))

        local icon = Material( "glitchfire/f4/search.png", "noclamp smooth" )

        panel.searchicon.Paint = function(s,w,h)
            s:SetWide(s:GetTall())
            surface.SetMaterial( icon )
            surface.SetDrawColor( 255, 255, 255, 120 )
            local iconsizew, iconsizeh = w * .8, h * .8
            surface.DrawTexturedRect( w * .5 - iconsizew * .5, h * .5 - iconsizeh * .5, iconsizew, iconsizeh )
        end

        panel.entry = vgui.Create( "DTextEntry", exitbar )
        panel.entry:Dock(LEFT)
        panel.entry:DockMargin(getScaledSize(3, "y"),getScaledSize(8, "y"),getScaledSize(5, "y"),getScaledSize(8, "y"))
        panel.entry:SetWide(getScaledSize(112,"x"))
        panel.entry:SetDrawLanguageID(false)
        panel.entry:SetPlaceholderText( "Search..." )
        panel.entry:SetPlaceholderColor(Color(255,255,255, 120))
        panel.entry:SetFont("GF_F4_16_10")
        panel.entry.Paint = function(s,w,h)
            surface.SetDrawColor(Color(255,255,255, 120))
            surface.DrawRect(0, h - 1, w, 1)
            if s:GetText() == "" and !s:HasFocus() then draw.SimpleText("Search...", "GF_F4_16_10", getScaledSize(3, "x"), h * .5, Color( 255, 255, 255, 120 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER) end
            s:DrawTextEntryText( Color(255,255,255, 120), Color(0, 0, 255, 255), Color(255,255,255) ) 
	    end

        panel.entry.OnChange = function()
            local val = panel.entry:GetText()
            if !isstring(val) then return end
            val = string.lower(val)

            for k,v in pairs(tabTable) do
                local canvas = k:GetCanvas()
                for z, i in pairs(canvas.Ents) do
                    if !z.overText or !IsValid(z) then return end
                    if !string.find(string.lower(z.overText), val) then
                        if z:IsVisible() then
                            k:RemoveBoxSize(z, getScaledSize(10, "y") )
                        end

                        z:SetVisible(false)
                    else
                        if !z:IsVisible() then
                            k:AddBoxSize(z, getScaledSize(10, "y") )
                        end

                        z:SetVisible(true)
                    end
                end
            end

            for k,v in pairs(tabTable) do
                local count = 0
                local canvas = k:GetCanvas()
                for i, z in pairs(canvas.Ents) do
                    if i:IsVisible() then
                        count = count + 1
                    end
                end

                if count <= 0 then 
                    k:SetVisible(false)
                    k:GetParent():InvalidateLayout(true)
                else
                    k:SetVisible(true)
                    k:GetParent():InvalidateLayout(true)
                end
            end
        end

        panel.OnVisibleChange = function(status)
            panel.searchicon:SetVisible(status)
            panel.entry:SetVisible(status)
        end

        panel.searchicon:SetVisible(false)
        panel.entry:SetVisible(false)

        local function buildEnts(team)
            if !team then team = LocalPlayer():Team() end
            for i, z in pairs(DarkRP.getCategories().entities) do
                local tab = vgui.Create("GFTabs", panel)
                tab:SetTitle(z.name)
                tab:Dock(TOP)
                tab:DockMargin(0,0,0,getScaledSize(20, "y"))
                tab:SetZPos(z.sortOrder)

                tabTable[tab] = true

                local canvas = tab:GetCanvas()
                canvas.Ents = canvas.Ents or {}

                for k,v in pairs(z.members) do
                    if !GLITCHFIREF4:isItemHidden(GLITCHFIREF4:CanBuyentities(v, team), true) then continue end
                    local entbox = vgui.Create("GFF4_ProductBox", canvas)
                    entbox:SetEntityData(v)

                    canvas.Ents[entbox] = true

                    tab:AddBoxSize(entbox, getScaledSize(10, "y") )
                end

                tab:AddBoxSize(nil, getScaledSize(10, "y") )
            end

            for k,v in pairs(tabTable) do
                local count = 0
                local canvas = k:GetCanvas()
                for i, z in pairs(canvas.Ents) do
                    if i:IsVisible() then
                        count = count + 1
                    end
                end

                if count <= 0 then 
                    k:SetVisible(false)
                else
                    k:SetVisible(true)
                end
            end
        end

        buildEnts()
        hook.Add("OnPlayerChangedTeam", "UpdateEntities", function(ply, old, new)
            if ply != LocalPlayer() then return end

            tabTable = {}
            if IsValid(panel) then
            	panel:Clear()
            end
            buildEnts(new)
        end)
    end},
    ["Shipments"] = {sortOrder = 5, buildFunction = function(panel)
        local tabTable = {}

        local exitbar = panel:GetParent():GetParent().closebar

        panel.searchicon = vgui.Create("EditablePanel", exitbar)
        panel.searchicon:Dock(LEFT)
        panel.searchicon:DockMargin(getScaledSize(15, "y"),getScaledSize(8, "y"),0,getScaledSize(8, "y"))

        local icon = Material( "glitchfire/f4/search.png", "noclamp smooth" )

        panel.searchicon.Paint = function(s,w,h)
            s:SetWide(s:GetTall())
            surface.SetMaterial( icon )
            surface.SetDrawColor( 255, 255, 255, 120 )
            local iconsizew, iconsizeh = w * .8, h * .8
            surface.DrawTexturedRect( w * .5 - iconsizew * .5, h * .5 - iconsizeh * .5, iconsizew, iconsizeh )
        end

        panel.entry = vgui.Create( "DTextEntry", exitbar )
        panel.entry:Dock(LEFT)
        panel.entry:DockMargin(getScaledSize(3, "y"),getScaledSize(8, "y"),getScaledSize(5, "y"),getScaledSize(8, "y"))
        panel.entry:SetWide(getScaledSize(112,"x"))
        panel.entry:SetDrawLanguageID(false)
        panel.entry:SetPlaceholderText( "Search..." )
        panel.entry:SetPlaceholderColor(Color(255,255,255, 120))
        panel.entry:SetFont("GF_F4_16_10")
        panel.entry.Paint = function(s,w,h)
            surface.SetDrawColor(Color(255,255,255, 120))
            surface.DrawRect(0, h - 1, w, 1)
            if s:GetText() == "" and !s:HasFocus() then draw.SimpleText("Search...", "GF_F4_16_10", getScaledSize(3, "x"), h * .5, Color( 255, 255, 255, 120 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER) end
            s:DrawTextEntryText( Color(255,255,255, 120), Color(0, 0, 255, 255), Color(255,255,255) ) 
	    end

        panel.entry.OnChange = function()
            local val = panel.entry:GetText()
            if !isstring(val) then return end
            val = string.lower(val)

            for k,v in pairs(tabTable) do
                local canvas = k:GetCanvas()
                for z, i in pairs(canvas.Ents) do
                    if !z.overText or !IsValid(z) then return end
                    if !string.find(string.lower(z.overText), val) then
                        if z:IsVisible() then
                            k:RemoveBoxSize(z, getScaledSize(10, "y") )
                        end

                        z:SetVisible(false)
                    else
                        if !z:IsVisible() then
                            k:AddBoxSize(z, getScaledSize(10, "y") )
                        end

                        z:SetVisible(true)
                    end
                end
            end

            for k,v in pairs(tabTable) do
                local count = 0
                local canvas = k:GetCanvas()
                for i, z in pairs(canvas.Ents) do
                    if i:IsVisible() then
                        count = count + 1
                    end
                end

                if count <= 0 then 
                    k:SetVisible(false)
                    k:GetParent():InvalidateLayout(true)
                else
                    k:SetVisible(true)
                    k:GetParent():InvalidateLayout(true)
                end
            end
        end

        panel.OnVisibleChange = function(status)
            panel.searchicon:SetVisible(status)
            panel.entry:SetVisible(status)
        end

        panel.searchicon:SetVisible(false)
        panel.entry:SetVisible(false)

        local function buildShipments(team)
            if !team then team = LocalPlayer():Team() end

            for i, z in pairs(DarkRP.getCategories().shipments) do
                local tab = vgui.Create("GFTabs", panel)
                tab:SetTitle(z.name)
                tab:Dock(TOP)
                tab:DockMargin(0,0,0,getScaledSize(20, "y"))
                tab:SetZPos(z.sortOrder)

                tabTable[tab] = true

                local canvas = tab:GetCanvas()
                canvas.Ents = canvas.Ents or {}

                for k,v in pairs(z.members) do
                    if !GLITCHFIREF4:isItemHidden(GLITCHFIREF4:CanBuyshipments(v, team), true) then continue end
                    local shipbox = vgui.Create("GFF4_ProductBox", canvas)
                    shipbox:SetShipmentData(v)

                    canvas.Ents[shipbox] = true

                    tab:AddBoxSize(shipbox, getScaledSize(10, "y") )
                end

                tab:AddBoxSize(nil, getScaledSize(10, "y") )
            end

            for k,v in pairs(tabTable) do
                local count = 0
                local canvas = k:GetCanvas()
                for i, z in pairs(canvas.Ents) do
                    if i:IsVisible() then
                        count = count + 1
                    end
                end

                if count <= 0 then 
                    k:SetVisible(false)
                else
                    k:SetVisible(true)
                end
            end
        end

        buildShipments()
        hook.Add("OnPlayerChangedTeam", "UpdateShipments", function(ply, old, new)
            if ply != LocalPlayer() then return end
            
            tabTable = {}
            if IsValid(panel) then
            	panel:Clear()
            end
            buildShipments(new)
        end)
    end}
}