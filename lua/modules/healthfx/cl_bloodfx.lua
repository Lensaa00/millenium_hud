local BloodMaterial = Material("resource/fx/bloodfx2.png", "smooth mips")

hook.Add("HUDPaint", "BloodFX", function()
    local ply = LocalPlayer()
    if not IsValid(ply) then return end

    local health = ply:Health() / ply:GetMaxHealth()
    health = math.Clamp(health, 0, 1)

    local Alpha = (1 - health) * 30

    surface.SetMaterial(BloodMaterial)
    surface.SetDrawColor(255, 255, 255, Alpha)
    surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
end)
