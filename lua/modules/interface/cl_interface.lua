local function SetupFonts()
    surface.CreateFont("Logo", {font = "Montserrat Bold", extended = true, size = ScreenScale(10), antialias = true})
    surface.CreateFont("Time", {font = "Montserrat Bold", extended = true, size = ScreenScale(6), antialias = true})
    surface.CreateFont("Hunger", {font = "Montserrat", extended = true, size = ScreenScale(10), antialias = true})
    surface.CreateFont("Text", {font = "Montserrat", extended = true, size = ScreenScale(8.5), antialias = true})
    surface.CreateFont("TextShadow", {font = "Montserrat", extended = true, blursize = 2, size = ScreenScale(8.5), antialias = true})
    surface.CreateFont("WatermarkTop", {font = "Montserrat Black", extended = true, size = ScreenScale(7), antialias = true})
    surface.CreateFont("WatermarkBottom", {font = "Montserrat", extended = true, size = ScreenScale(6), antialias = true})
    surface.CreateFont("Mi6", {font = "Montserrat", extended = true, size = ScreenScale(6.5), antialias = true})
    surface.CreateFont("Mi6Shadow", {font = "Montserrat", extended = true, blursize = 2, size = ScreenScale(6.5), antialias = true})
    surface.CreateFont("HealthArmor", {font = "Montserrat Black", extended = true, size = ScreenScale(5), antialias = true})
    surface.CreateFont("HealthArmorShadow", {font = "Montserrat Black", extended = true, blursize = 2, size = ScreenScale(5), antialias = true})
end

SetupFonts() -- подгружаем шрифты

function Interface()
    if not LocalPlayer():Alive() then return end -- Если игрок мертв, не отображаем
    local scrw, scrh = ScrW(), ScrH() -- Размеры экрана

    -- Опорная точка
    local pivotlx, pivotly = ScreenScale(6), scrh - ScreenScale(1)

    -- Переменные игрока
    local Player = LocalPlayer() -- Игрок
    local PSteamID = Player:SteamID() -- SteamID
    local PName = Player:getDarkRPVar("rpname") -- DarkRP Имя

    local PCount = player.GetCount() -- Количество игроков на сервере

    -- Водяные знаки
    draw.SimpleText(PCount .. " MILLENIUM RP", "WatermarkTop", scrw * .995, scrh * 0.001, Color(255,255,255, 65), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
    draw.SimpleText(PName .. " | " .. PSteamID, "WatermarkBottom", scrw * .995, scrh * .02, Color(255,255,255, 65), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)

    mi_hud.elements:Main() -- отображение главного модуля
    mi_hud.elements:Arrested() -- отображение модуля Ареста
    mi_hud.elements:Lockdown() -- отображение модуля ком. часа
end

-- Хук отрисовки
hook.Add("HUDPaint", "millenium.interface.draw", function ()
    mi_hud.effects.GrayFX() -- Эффект серого экрана при низком ХП
    mi_hud.effects.BloodFX() -- Эффект крови при низком ХП
    Interface() -- Интерфейс
    mi_hud.DeathScreen() -- Экран смерти
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
