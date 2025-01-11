mi_hud.effects = {}
function mi_hud.effects.GrayFX()
    local grayScale = 0
    local ply = LocalPlayer()
    if not IsValid(ply) then return end
    local health = ply:Health() / ply:GetMaxHealth()
    health = math.Clamp(health, 0, 1)
    grayScale = 1 - health
    DrawColorModify({
        ["$pp_colour_addr"] = 0,
        ["$pp_colour_addg"] = 0,
        ["$pp_colour_addb"] = 0,
        ["$pp_colour_brightness"] = 0,
        ["$pp_colour_contrast"] = 1,
        ["$pp_colour_colour"] = 1 - grayScale,
        ["$pp_colour_mulr"] = 0,
        ["$pp_colour_mulg"] = 0,
        ["$pp_colour_mulb"] = 0
    })
end

function mi_hud.effects.BloodFX()
    local BloodMaterial = Material("resource/fx/bloodfx2.png", "smooth mips")

    local ply = LocalPlayer()
    if not IsValid(ply) then return end

    local health = ply:Health() / ply:GetMaxHealth()
    health = math.Clamp(health, 0, 1)

    local Alpha = (1 - health) * 30

    surface.SetMaterial(BloodMaterial)
    surface.SetDrawColor(255, 255, 255, Alpha)
    surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
end

