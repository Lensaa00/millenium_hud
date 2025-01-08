surface.CreateFont("Pickup", {font = "Nunito Bold", extended = true, size = ScreenScale(6)})

-- Отключаем стандартную историю Pickup
hook.Add("HUDDrawPickupHistory", "millenium.pickup.disable", function()

end)

-- -- Таблица для хранения информации о поднятых предметах
-- local pickups = {}

-- -- Функция для добавления нового элемента в историю
-- local function AddPickup(text, color)
--     table.insert(pickups, {
--         text = text,
--         color = color or Color(255, 255, 255),
--         time = CurTime()
--     })
-- end

-- -- Хук для поднятых оружий
-- hook.Add("HUDWeaponPickedUp", "millenium.pickup.weapon", function(weapon)
--     if IsValid(weapon) then
--         AddPickup(weapon:GetPrintName(), Color(0, 150, 255))
--     end
-- end)

-- -- Хук для поднятых патронов
-- hook.Add("HUDAmmoPickedUp", "millenium.pickup.ammo", function(ammoType, amount)
--     AddPickup(ammoType .. " (" .. amount .. ")", Color(255, 255, 0))
-- end)

-- -- Хук для поднятых предметов
-- hook.Add("HUDItemPickedUp", "millenium.pickup.item", function(itemName)
--     AddPickup(itemName, Color(0, 255, 0))
-- end)

-- -- Отображение кастомных плашек
-- hook.Add("HUDPaint", "millenium.pickup.render", function()
--     local scrW, scrH = ScrW(), ScrH()
--     local baseX, baseY = scrW * 0.8, scrH * 0.7 -- Позиция плашек

--     for i, pickup in ipairs(pickups) do
--         local fadeTime = 3 -- Время, через которое плашка исчезает
--         local elapsedTime = CurTime() - pickup.time
--         if elapsedTime > fadeTime then
--             table.remove(pickups, i)
--         else

--             -- Размеры текста
--             surface.SetFont("Pickup")
--             local textW, textH = surface.GetTextSize(pickup.text)
--             local boxW, boxH = textW + 20, textH + 3

--             -- Рендеринг фона
--             draw.RoundedBox(0, baseX - boxW / 2, baseY - i * (boxH + 3), boxW, boxH, Color(35,35,50))
--             draw.RoundedBox(0, baseX - boxW / 2, baseY - i * (boxH + 3), 2, boxH, pickup.color)

--             -- Рендеринг текста
--             draw.SimpleText(pickup.text, "Pickup", baseX, baseY - i * (boxH + 3) + boxH / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
--         end
--     end
-- end)
