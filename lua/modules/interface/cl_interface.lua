local function SetupFonts()
    surface.CreateFont("Logo", {font = "Nunito Bold", extended = true, size = ScreenScale(10)})
    surface.CreateFont("Time", {font = "Nunito Bold", extended = true, size = ScreenScale(6)})
    surface.CreateFont("Hunger", {font = "Nunito Bold", extended = true, size = ScreenScale(9)})
    surface.CreateFont("Text", {font = "Nunito Black", extended = true, size = ScreenScale(8.5)})
    surface.CreateFont("TextShadow", {font = "Nunito Black", extended = true, blursize = 2, size = ScreenScale(8.5)})
    surface.CreateFont("WatermarkTop", {font = "Nunito Black", extended = true, size = ScreenScale(7)})
    surface.CreateFont("WatermarkBottom", {font = "Nunito", extended = true, size = ScreenScale(6)})
    surface.CreateFont("Arrested", {font = "Nunito", extended = true, size = ScreenScale(6)})
    surface.CreateFont("HealthArmor", {font = "Nunito Black", extended = true, size = ScreenScale(5)})
    surface.CreateFont("HealthArmorShadow", {font = "Nunito Black", extended = true, blursize = 2, size = ScreenScale(5)})
end

SetupFonts() -- подгружаем шрифты

local SmoothedHealth = 100
local SmoothedArmor = 100

local ShowingLogo = true -- Флаг лого
local LastLogoChange = CurTime() -- Последняя смена лого
local LogoChangeDelay = 10 -- Задержка смены лого

function Interface()
    if not LocalPlayer():Alive() then return end -- Если игрок мертв, не отображаем
    local scrw, scrh = ScrW(), ScrH() -- Размеры экрана

    -- Опорная точка
    local pivotlx, pivotly = ScreenScale(6), scrh - ScreenScale(1)

    -- Переменные игрока
    local Player = LocalPlayer() -- Игрок
    local PSteamID = Player:SteamID() -- SteamID
    local PMaxHealth = Player:GetMaxHealth() -- Максимальное здоровье
    local PMaxArmor = Player:GetMaxArmor() -- Максимальная броня
    local PHealth = math.Clamp(Player:Health(), 0, PMaxHealth) -- Здоровье
    local PArmor = math.Clamp(Player:Armor(), 0, PMaxArmor) -- Броня
    local PName = Player:getDarkRPVar("rpname") -- DarkRP Имя
    local PMoney = DarkRP.formatMoney(Player:getDarkRPVar("money")) -- DarkRP Деньги
    local PSalary = DarkRP.formatMoney(Player:getDarkRPVar("salary")) -- DarkRP Зарплата
    local PJob = Player:getDarkRPVar("job") -- DarkRP Работа
    local PTeamColor = team.GetColor(Player:Team()) -- Цвет команды
    local PHasLicense = Player:getDarkRPVar("HasGunlicense") -- Флаг лицензии
    local PWanted = Player:getDarkRPVar("wanted") -- Флаг розыска
    local PHunger = math.Round(Player:getDarkRPVar("Energy")) or 100 -- Голод
    local PArrested = Player:getDarkRPVar("Arrested") -- Флаг ареста

    local PCount = player.GetCount() -- Количество игроков на сервере
    local Time = os.date("%H:%M") -- Текущее время

    -- Плавная броня и здоровье
    SmoothedHealth = Lerp(FrameTime() * 5, SmoothedHealth, PHealth)
    SmoothedArmor = Lerp(FrameTime() * 5, SmoothedArmor, PArmor)

    -- Ширина полосы
    local barWidth = scrw * 0.15

    -- Водяные знаки
    draw.SimpleText(PCount .. " MILLENIUM RP", "WatermarkTop", scrw * .995, scrh * 0.001, Color(255,255,255, 65), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
    draw.SimpleText(PName .. " | " .. PSteamID, "WatermarkBottom", scrw * .995, scrh * .02, Color(255,255,255, 65), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)

    -- Основная панель
    draw.RoundedBox(mi_hud.rounding, pivotlx, pivotly - scrh * 0.05, scrw * 0.24, scrh * 0.04, mi_hud.theme.baseOutline)
    draw.RoundedBox(mi_hud.rounding, pivotlx + 1, pivotly - scrh * 0.05 + 1, scrw * 0.24 - 2, scrh * 0.04 - 2, mi_hud.theme.base)

    -- Сменяемое лого
    if ShowingLogo then
        draw.SimpleText("Mi", "Logo", pivotlx + ScreenScale(8.1), pivotly - scrh * .03, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        if (CurTime() - LastLogoChange >= LogoChangeDelay) then
            ShowingLogo = false
            LastLogoChange = CurTime()
        end
    else
        draw.SimpleText(Time, "Time", pivotlx + ScreenScale(8.25), pivotly - scrh * .03, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
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
    draw.SimpleText(PHunger .. "%", "Hunger", pivotlx + scrw * 0.22, pivotly - scrh * 0.03 - ScreenScale(.5), Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

    -- Деньги
        -- Панель
    draw.RoundedBox(mi_hud.rounding, pivotlx, pivotly - scrh * .085, ScreenScale(11), ScreenScale(11), mi_hud.theme.baseOutline)
    draw.RoundedBox(mi_hud.rounding, pivotlx + 1, pivotly - scrh * .085 + 1, ScreenScale(11) - 2, ScreenScale(11) - 2, mi_hud.theme.base)
        -- Иконка
    surface.SetDrawColor(255, 255, 255)
    surface.SetMaterial(mi_hud.icons.interface["money"])
    surface.DrawTexturedRect(pivotlx + ScreenScale(2.4), pivotly - scrh * .085 + ScreenScale(2.4), ScreenScale(6.5), ScreenScale(6.5))
        -- Текст
    draw.SimpleText(PMoney .. " +" .. PSalary, "TextShadow", pivotlx + scrw * .022, pivotly - scrh * .072 + 2, Color(0,0,0, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    draw.SimpleText(PMoney .. " +" .. PSalary, "Text", pivotlx + scrw * .022, pivotly - scrh * .072, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

    -- Работа
        -- Панель
    draw.RoundedBox(mi_hud.rounding, pivotlx, pivotly - scrh * .12, ScreenScale(11), ScreenScale(11), mi_hud.theme.baseOutline)
    draw.RoundedBox(mi_hud.rounding, pivotlx + 1, pivotly - scrh * .12 + 1, ScreenScale(11) - 2, ScreenScale(11) - 2, mi_hud.theme.base)
        -- Иконка
    surface.SetDrawColor(255, 255, 255)
    surface.SetMaterial(mi_hud.icons.interface["job"])
    surface.DrawTexturedRect(pivotlx + ScreenScale(2.5), pivotly - scrh * .12 + ScreenScale(2.5), ScreenScale(6.5), ScreenScale(6.5))
        -- Текст
    draw.SimpleText(PJob, "TextShadow", pivotlx + scrw * .0225, pivotly - scrh * .107 + 2, Color(0,0,0, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    draw.SimpleText(PJob, "Text", pivotlx + scrw * .0225, pivotly - scrh * .107, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

    -- Лицензия
    if PHasLicense then
        -- Панель
        draw.RoundedBox(mi_hud.rounding, pivotlx, pivotly - scrh * .1555, ScreenScale(11), ScreenScale(11), mi_hud.theme.baseOutline)
        draw.RoundedBox(mi_hud.rounding, pivotlx + 1, pivotly - scrh * .1555 + 1, ScreenScale(11) - 2, ScreenScale(11) - 2, mi_hud.theme.base)
        -- Иконка
        surface.SetDrawColor(255, 255, 255)
        surface.SetMaterial(mi_hud.icons.interface["license"])
        surface.DrawTexturedRect(pivotlx + ScreenScale(2.5), pivotly - scrh * .1555 + ScreenScale(2.5), ScreenScale(6.5), ScreenScale(6.5))
        -- Текст
        draw.SimpleText("Есть лицензия", "TextShadow", pivotlx + scrw * .0225, pivotly - scrh * .143 + 2, Color(0,0,0, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        draw.SimpleText("Есть лицензия", "Text", pivotlx + scrw * .0225, pivotly - scrh * .143, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    -- Арест
    if PArrested then
        local arrestTime = Player:GetNWInt("ArrestTime") or 0 -- Время ареста
        local timeLeft = math.max(0, math.floor(arrestTime - CurTime())) -- Счетчик времени
        -- Размеры текста
        surface.SetFont("Arrested")
        local tw, th = surface.GetTextSize("Вы арестованы! Осталось: " .. timeLeft .. " сек.")
        -- Размеры панели
        local panelW = tw + scrw * .02
        local panelH = th + 7
        -- Размер иконки
        local iconSize = panelH * .6
        -- Позиция панели
        local panelX = scrw / 2 - panelW / 2
        local panelY = scrh * .90 - panelH / 2
        -- Панель
        draw.RoundedBox(mi_hud.rounding, panelX, panelY + 2, panelW, panelH, Color(255, 148, 99))
        draw.RoundedBox(mi_hud.rounding, panelX, panelY, panelW, panelH, mi_hud.theme.baseOutline)
        draw.RoundedBox(mi_hud.rounding, panelX + 1, panelY + 1, panelW - 2, panelH - 2, mi_hud.theme.base)
        -- Иконка
        surface.SetDrawColor(255, 148, 99)
        surface.SetMaterial(mi_hud.icons.interface.arrested)
        surface.DrawTexturedRect(panelX + 7, panelY + panelH / 2 - iconSize / 2, iconSize, iconSize)
        -- Текст
        draw.SimpleText("Вы арестованы! Осталось: " .. timeLeft .. " сек.", "Arrested", panelX + 7 + iconSize + 7, panelY + panelH / 2, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end
end

-- Хук отрисовки
hook.Add("HUDPaint", "millenium.interface.draw", function ()
    mi_hud.effects.GrayFX() -- эффект серого экрана при низком ХП
    mi_hud.effects.BloodFX() -- эффект крови при низком ХП
    Interface() -- Интерфейс
end)

-- Хук скрытия информации об игроке у прицела
hook.Add("HUDDrawTargetID", "HideTargetID", function()
    return false
end)

-- Хук скрытия стандартного интерфейса
hook.Add("HUDShouldDraw", "HideDefaultHud", function(name)
    if (mi_hud.config.hideHudElements[name]) then
        return false
    end
end)
