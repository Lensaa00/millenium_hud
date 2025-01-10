local grayScale = 0

hook.Add("HUDPaint", "HealthToGrayEffect", function()
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
end)
