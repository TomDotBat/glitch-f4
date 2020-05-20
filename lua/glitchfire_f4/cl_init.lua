hook.Add('ShowSpare2', 'triggerF4', function()
    if !IsValid(glitchfiref4) then
        glitchfiref4 = vgui.Create("GlitchFireF4")
    else
        if !glitchfiref4:IsVisible() then
            glitchfiref4:SetVisible(true)
        end
    end
end)

hook.Add('OnReloaded', 'reloadF4', function()
    if IsValid(glitchfiref4) then
        glitchfiref4:Remove()
    end
end)

GLITCHFIREF4 = GLITCHFIREF4 or {}

-- https://github.com/FPtje/DarkRP/blob/master/gamemode/modules/f4menu/cl_entitiestab.lua#L104-L119
function GLITCHFIREF4:CanBuyentities(item, team)
    local ply = LocalPlayer()

    if istable(item.allowed) and not table.HasValue(item.allowed, team) then return false, true end
    if item.customCheck and not item.customCheck(ply) then return false, true end

    local canbuy, suppress, message, price = hook.Call("canBuyCustomEntity", nil, ply, item)
    local cost = price or item.getPrice and item.getPrice(ply, item.price) or item.price
 
    if canbuy == false then
        return false, suppress, message, cost
    end

    return true, nil, message, cost
end

-- https://github.com/FPtje/DarkRP/blob/master/gamemode/modules/f4menu/cl_entitiestab.lua#L142-L158
function GLITCHFIREF4:CanBuyshipments(ship, team)
    local ply = LocalPlayer()

    if not table.HasValue(ship.allowed, team) then return false, true end
    if ship.customCheck and not ship.customCheck(ply) then return false, true end

    local canbuy, suppress, message, price = hook.Call("canBuyShipment", nil, ply, ship)
    local cost = price or ship.getPrice and ship.getPrice(ply, ship.price) or ship.price

    if canbuy == false then
        return false, suppress, message, cost
    end

    return true, nil, message, cost
end

-- https://github.com/FPtje/DarkRP/blob/master/gamemode/modules/f4menu/cl_entitiestab.lua#L52-L54
function GLITCHFIREF4:isItemHidden(cantBuy, important)
    return cantBuy and (GAMEMODE.Config.hideNonBuyable or (important and GAMEMODE.Config.hideTeamUnbuyable))
end