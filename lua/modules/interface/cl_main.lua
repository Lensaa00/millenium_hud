surface.CreateFont("mi.hud.logo", {font = "Montserrat Bold", extended = true, size = ScreenScale(10), antialias = true})
surface.CreateFont("mi.hud.time", {font = "Montserrat Bold", extended = true, size = ScreenScale(6), antialias = true})
surface.CreateFont("mi.hud.hunger", {font = "Montserrat", extended = true, size = ScreenScale(10), antialias = true})
surface.CreateFont("mi.hud.text", {font = "Montserrat", extended = true, size = ScreenScale(8.5), antialias = true})
surface.CreateFont("mi.hud.text.shadow", {font = "Montserrat", extended = true, blursize = 2, size = ScreenScale(8.5), antialias = true})

local SmoothedHealth = 100
local SmoothedArmor = 100

local ShowingLogo = true -- Флаг лого
local LastLogoChange = CurTime() -- Последняя смена лого
local LogoChangeDelay = 10 -- Задержка смены лого

function mi_hud.elements:Main()

    -- Размеры экрана
    local scrw, scrh = ScrW(), ScrH()

    -- Опорная точка
    local pivotlx, pivotly = ScreenScale(6), scrh - ScreenScale(1)

    -- Ширина полосы
    local barWidth = scrw * 0.15

    local Player = LocalPlayer()
    local PMaxHealth = Player:GetMaxHealth() -- Максимальное здоровье
    local PMaxArmor = Player:GetMaxArmor() -- Максимальная броня
    local PHealth = math.Clamp(Player:Health(), 0, PMaxHealth) -- Здоровье
    local PArmor = math.Clamp(Player:Armor(), 0, PMaxArmor) -- Броня
    local PMoney = DarkRP.formatMoney(Player:getDarkRPVar("money")) -- DarkRP Деньги
    local PHunger = math.Round(Player:getDarkRPVar("Energy")) or 100 -- Голод
    local PSalary = DarkRP.formatMoney(Player:getDarkRPVar("salary")) -- DarkRP Зарплата
    local PJob = Player:getDarkRPVar("job") -- DarkRP Работа
    local PHasLicense = Player:getDarkRPVar("HasGunlicense") -- Флаг лицензии

    local Time = os.date("%H:%M") -- Текущее время

    draw.SimpleText("Здоровье: " .. PHealth .. "\nМакс. Здоровье: " .. PMaxHealth .. "\nБроня: " .. PArmor .. "\nМакс. Броня: " .. PMaxArmor, "DermaDefault", 5, 5, color_white)

    SmoothedHealth = Lerp(FrameTime() * 5, SmoothedHealth, PHealth)
    SmoothedArmor = Lerp(FrameTime() * 5, SmoothedArmor, PArmor)

    -- Основная панель
    draw.RoundedBox(mi_hud.rounding, pivotlx, pivotly - scrh * 0.05, scrw * 0.24, scrh * 0.04, mi_hud.theme.baseOutline)
    draw.RoundedBox(mi_hud.rounding, pivotlx + 1, pivotly - scrh * 0.05 + 1, scrw * 0.24 - 2, scrh * 0.04 - 2, mi_hud.theme.base)

    -- Сменяемое лого
    if ShowingLogo then
        draw.SimpleText("Mi", "mi.hud.logo", pivotlx + ScreenScale(8.1), pivotly - scrh * .03, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        if (CurTime() - LastLogoChange >= LogoChangeDelay) then
            ShowingLogo = false
            LastLogoChange = CurTime()
        end
    else
        draw.SimpleText(Time, "mi.hud.time", pivotlx + ScreenScale(8.25), pivotly - scrh * .03, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        if (CurTime() - LastLogoChange >= LogoChangeDelay) then
            ShowingLogo = true
            LastLogoChange = CurTime()
        end
    end

    -- Разделитель
    draw.RoundedBox(0, pivotlx + ScreenScale(16.5), pivotly - ScreenScale(19.5) + ScreenScale(4), 1, scrh * 0.05 - ScreenScale(8), mi_hud.theme.baseOutline)

    -- Полоса здоровья
    draw.RoundedBox(mi_hud.rounding, pivotlx + ScreenScale(20), pivotly - ScreenScale(14), barWidth, scrh * 0.008, Color(138, 76, 65))
    draw.RoundedBox(mi_hud.rounding, pivotlx + ScreenScale(20), pivotly - ScreenScale(14), (SmoothedHealth / PMaxHealth) * barWidth, scrh * 0.008, Color(255, 121, 97))

    -- Полоса брони
    draw.RoundedBox(mi_hud.rounding, pivotlx + ScreenScale(20), pivotly - ScreenScale(10), barWidth, scrh * 0.008, Color(68, 98, 137))
    draw.RoundedBox(mi_hud.rounding, pivotlx + ScreenScale(20), pivotly - ScreenScale(10), (SmoothedArmor / PMaxArmor) * barWidth, scrh * 0.008, Color(118, 177, 255))

    -- Разделитель
    draw.RoundedBox(0, pivotlx + scrw * .186, pivotly - ScreenScale(19.5) + ScreenScale(4), 1, scrh * 0.05 - ScreenScale(8), mi_hud.theme.baseOutline)

    -- Еда
        -- Иконка
    surface.SetDrawColor(255, 153, 85)
    surface.SetMaterial(mi_hud.icons.interface["hunger"])
    surface.DrawTexturedRect(pivotlx + scrw * 0.193, pivotly - scrh * 0.038 - ScreenScale(.5), ScreenScale(6.5), ScreenScale(6.5))
        -- Текст
    draw.SimpleText(PHunger .. "%", "mi.hud.hunger", pivotlx + scrw * 0.22, pivotly - scrh * 0.029 - ScreenScale(.5), Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

    -- Деньги
        -- Панель
    draw.RoundedBox(mi_hud.rounding, pivotlx, pivotly - scrh * .080, ScreenScale(10), ScreenScale(10), mi_hud.theme.baseOutline)
    draw.RoundedBox(mi_hud.rounding, pivotlx + 1, pivotly - scrh * .080 + 1, ScreenScale(10) - 2, ScreenScale(10) - 2, mi_hud.theme.base)
        -- Иконка
    surface.SetDrawColor(255, 255, 255)
    surface.SetMaterial(mi_hud.icons.interface["money"])
    surface.DrawTexturedRect(pivotlx + ScreenScale(2), pivotly - scrh * .080 + ScreenScale(2), ScreenScale(6), ScreenScale(6))
        -- Текст
    draw.SimpleText(PMoney .. " +" .. PSalary, "mi.hud.text.shadow", pivotlx + scrw * .02, pivotly - scrh * .067 + 2, Color(0,0,0, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    draw.SimpleText(PMoney .. " +" .. PSalary, "mi.hud.text", pivotlx + scrw * .02, pivotly - scrh * .067, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

    -- Работа
        -- Панель
    draw.RoundedBox(mi_hud.rounding, pivotlx, pivotly - scrh * .111, ScreenScale(10), ScreenScale(10), mi_hud.theme.baseOutline)
    draw.RoundedBox(mi_hud.rounding, pivotlx + 1, pivotly - scrh * .111 + 1, ScreenScale(10) - 2, ScreenScale(10) - 2, mi_hud.theme.base)
        -- Иконка
    surface.SetDrawColor(255, 255, 255)
    surface.SetMaterial(mi_hud.icons.interface["job"])
    surface.DrawTexturedRect(pivotlx + ScreenScale(2), pivotly - scrh * .112 + ScreenScale(2), ScreenScale(6), ScreenScale(6))
        -- Текст
    draw.SimpleText(PJob, "mi.hud.text.shadow", pivotlx + scrw * .02, pivotly - scrh * .098 + 2, Color(0,0,0, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    draw.SimpleText(PJob, "mi.hud.text", pivotlx + scrw * .02, pivotly - scrh * .098, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

    -- Лицензия
    if PHasLicense then
        -- Панель
        draw.RoundedBox(mi_hud.rounding, pivotlx, pivotly - scrh * .141, ScreenScale(10), ScreenScale(10), mi_hud.theme.baseOutline)
        draw.RoundedBox(mi_hud.rounding, pivotlx + 1, pivotly - scrh * .141 + 1, ScreenScale(10) - 2, ScreenScale(10) - 2, mi_hud.theme.base)
        -- Иконка
        surface.SetDrawColor(255, 255, 255)
        surface.SetMaterial(mi_hud.icons.interface["license"])
        surface.DrawTexturedRect(pivotlx + ScreenScale(2), pivotly - scrh * .141 + ScreenScale(2), ScreenScale(6), ScreenScale(6))
        -- Текст
        draw.SimpleText("Есть лицензия", "mi.hud.text.shadow", pivotlx + scrw * .02, pivotly - scrh * .128 + 2, Color(0,0,0, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        draw.SimpleText("Есть лицензия", "mi.hud.text", pivotlx + scrw * .02, pivotly - scrh * .128, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end
end
