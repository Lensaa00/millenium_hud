surface.CreateFont("Logo", {font = "Nunito Black", extended = true, size = ScreenScale(12)})
surface.CreateFont("Hunger", {font = "Nunito Black", extended = true, size = ScreenScale(10)})
surface.CreateFont("Text", {font = "Nunito Black", extended = true, size = ScreenScale(9)})
surface.CreateFont("TextShadow", {font = "Nunito Black", extended = true, blursize = 2, size = ScreenScale(9)})

local SmoothedHealth = 100
local SmoothedArmor = 100

function Interface()
    if not LocalPlayer():Alive() then return end
    local scrw, scrh = ScrW(), ScrH()

    local pivotlx, pivotly = ScreenScale(4), scrh - ScreenScale(4)

    local Player = LocalPlayer()
    local PMaxHealth = Player:GetMaxHealth()
    local PMaxArmor = Player:GetMaxArmor()
    local PHealth = math.Clamp(Player:Health(), 0, PMaxHealth)
    local PArmor = math.Clamp(Player:Armor(), 0, PMaxArmor)
    local PMoney = DarkRP.formatMoney(Player:getDarkRPVar("money"))
    local PSalary = DarkRP.formatMoney(Player:getDarkRPVar("salary"))
    local PJob = Player:getDarkRPVar("job")
    local PTeamColor = team.GetColor(Player:Team())
    local PHasLicense = Player:getDarkRPVar("HasGunlicense")
    local PWanted = Player:getDarkRPVar("wanted")
    local PWantedReason = Player:getDarkRPVar("wantedReason")
    local PHunger = Player:getDarkRPVar("Energy") or 100
    local PArrested = Player:getDarkRPVar("Arrested")

    -- Сглаживание здоровья и брони
    SmoothedHealth = Lerp(FrameTime() * 5, SmoothedHealth, PHealth)
    SmoothedArmor = Lerp(FrameTime() * 5, SmoothedArmor, PArmor)

    -- Ширина полосы
    local barWidth = scrw * 0.15

    -- Основная панель
    draw.RoundedBox(4, pivotlx, pivotly - scrh * 0.05, scrw * 0.265, scrh * 0.05, Color(35, 35, 50))

    -- Логотип
    draw.SimpleText("Mi", "Logo", pivotlx + ScreenScale(5), pivotly - ScreenScale(9.5), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

    -- Разделитель
    draw.RoundedBox(0, pivotlx + ScreenScale(20), pivotly - ScreenScale(18) + ScreenScale(3), 1, scrh * 0.05 - ScreenScale(6), Color(255, 255, 255, 10))

    -- Здоровье
    draw.RoundedBox(4, pivotlx + ScreenScale(25), pivotly - ScreenScale(14), barWidth, scrh * 0.0125, Color(116, 40, 26))
    draw.RoundedBox(4, pivotlx + ScreenScale(25), pivotly - ScreenScale(14), (SmoothedHealth / PMaxHealth) * barWidth, scrh * 0.0125, Color(255, 89, 59))

    -- Броня
    draw.RoundedBox(4, pivotlx + ScreenScale(25), pivotly - ScreenScale(8), barWidth, scrh * 0.0125, Color(30, 61, 129))
    draw.RoundedBox(4, pivotlx + ScreenScale(25), pivotly - ScreenScale(8), (SmoothedArmor / PMaxArmor) * barWidth, scrh * 0.0125, Color(59, 121, 255))

    -- Разделитель
    draw.RoundedBox(0, pivotlx + ScreenScale(125), pivotly - ScreenScale(18) + ScreenScale(3), 1, scrh * 0.05 - ScreenScale(6), Color(255, 255, 255, 10))

    -- Еда
    surface.SetDrawColor(255, 153, 85)
    surface.SetMaterial(mi_hud.icons.interface["hunger"])
    surface.DrawTexturedRect(pivotlx + scrw * 0.2025, pivotly - scrh * 0.04 + ScreenScale(0.5), ScreenScale(10), ScreenScale(10))
    draw.SimpleText(PHunger .. "%", "Hunger", pivotlx + scrw * 0.225, pivotly - scrh * 0.025, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

    -- Деньги
    draw.RoundedBox(4, pivotlx, pivotly - scrh * .09, ScreenScale(12), ScreenScale(12), Color(35, 35, 50))

    surface.SetDrawColor(255, 255, 255)
    surface.SetMaterial(mi_hud.icons.interface["money"])
    surface.DrawTexturedRect(pivotlx + ScreenScale(2.5), pivotly - scrh * .09 + ScreenScale(2.5), ScreenScale(7), ScreenScale(7))

    draw.SimpleText(PMoney .. " +" .. PSalary, "TextShadow", pivotlx + scrw * .0225, pivotly - scrh * .0737 + 2, Color(0,0,0, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    draw.SimpleText(PMoney .. " +" .. PSalary, "Text", pivotlx + scrw * .0225, pivotly - scrh * .0737, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

    -- Работа
    draw.RoundedBox(4, pivotlx, pivotly - scrh * .13, ScreenScale(12), ScreenScale(12), Color(35, 35, 50))

    surface.SetDrawColor(255, 255, 255)
    surface.SetMaterial(mi_hud.icons.interface["job"])
    surface.DrawTexturedRect(pivotlx + ScreenScale(2.5), pivotly - scrh * .13 + ScreenScale(2.5), ScreenScale(7), ScreenScale(7))

    draw.SimpleText(PJob, "TextShadow", pivotlx + scrw * .0225, pivotly - scrh * .113 + 2, Color(0,0,0, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    draw.SimpleText(PJob, "Text", pivotlx + scrw * .0225, pivotly - scrh * .113, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

    -- Лицензия
    if PHasLicense then
        draw.RoundedBox(4, pivotlx, pivotly - scrh * .17, ScreenScale(12), ScreenScale(12), Color(35, 35, 50))

        surface.SetDrawColor(255, 255, 255)
        surface.SetMaterial(mi_hud.icons.interface["license"])
        surface.DrawTexturedRect(pivotlx + ScreenScale(2.7), pivotly - scrh * .17 + ScreenScale(2.7), ScreenScale(7), ScreenScale(7))

        draw.SimpleText("Есть лицензия", "TextShadow", pivotlx + scrw * .0225, pivotly - scrh * .6 + 2, Color(0,0,0, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        draw.SimpleText("Есть лицензия", "Text", pivotlx + scrw * .0225, pivotly - scrh * .155, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

end

hook.Add("HUDPaint", "millenium.interface.draw", Interface)

hook.Add("HUDShouldDraw", "HideDefaultHud", function(name)
    if (mi_hud.config.hideHudElements[name]) then
        return false
    end
end)
