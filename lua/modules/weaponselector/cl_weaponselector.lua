print("NO SELECTOR")

-- local selectedSlot = 0 -- Выбранный слот
-- local selectedWeaponIndex = 1 -- Индекс выбранного оружия в текущем слоте
-- local slotAnimations = {} -- Для анимации оружия
-- local selectorVisible = false -- Видимость селектора
-- local selectorAlpha = 0 -- Прозрачность селектора (0 = невидим)
-- local selectorLastUsed = 0 -- Последнее время использования селектора
-- local holdAttack = false -- Удерживается ли кнопка атаки
-- local firstScroll = true -- Для обработки первого скролла

-- surface.CreateFont("mi.ws.text", {font = "Montserrat", extended = true, size = ScreenScale(6), antialias = true})

-- -- Скрываем стандартный Weapon Selector
-- hook.Add("HUDShouldDraw", "millenium.weaponselector.hide", function(name)
--     if name == "CHudWeaponSelection" then return false end
-- end)

-- -- Заполняем слоты оружиями
-- local function PopulateSlots(ply)
--     local slots = {}

--     if not IsValid(ply) then return slots end

--     local Weapons = ply:GetWeapons()
--     for _, weapon in ipairs(Weapons) do
--         local slot = weapon:GetSlot()
--         if not slots[slot] then
--             slots[slot] = {}
--         end
--         table.insert(slots[slot], weapon)
--     end

--     return slots
-- end

-- -- Линейная интерполяция
-- local function Lerp(alpha, from, to)
--     return from + (to - from) * alpha
-- end

-- -- Анимация оружий
-- local function AnimateWeapons(slot, targetX, targetY)
--     if not slotAnimations[slot] then
--         slotAnimations[slot] = {x = targetX, y = targetY, progress = 0}
--     end

--     local anim = slotAnimations[slot]
--     anim.progress = math.min(1, anim.progress + FrameTime() * 5) -- Скорость анимации

--     anim.x = Lerp(anim.progress, anim.x, targetX)
--     anim.y = Lerp(anim.progress, anim.y, targetY)

--     return anim.x, anim.y
-- end

-- -- Проигрывание звуков
-- local function PlaySound(name)
--     surface.PlaySound(name)
-- end

-- -- Основная функция отрисовки селектора оружий
-- local function WeaponSelector()
--     if not selectorVisible and selectorAlpha <= 0 then return end

--     local Player = LocalPlayer()
--     if not IsValid(Player) then return end

--     local scrw, scrh = ScrW(), ScrH()
--     local Slots = PopulateSlots(Player)

--     -- Параметры для отображения слотов
--     local slotSize = 30
--     local slotX = scrw - slotSize - 5
--     local slotY = scrh / 2 - (#Slots * (slotSize)) / 2 -- Центрируем слоты

--     -- Анимация появления/исчезновения селектора
--     selectorAlpha = Lerp(FrameTime() * 5, selectorAlpha, selectorVisible and 255 or 0)
--     if selectorAlpha <= 0 then return end

--     -- Отображение слотов
--     for slotIndex = 0, 5 do
--         local slotWeapons = Slots[slotIndex] or {}

--         if #slotWeapons == 0 then
--             if selectedSlot == slotIndex then
--                 selectedSlot = (selectedSlot + 1) % 6
--             end
--             continue
--         end

--         local slotColor = Color(0, 0, 0, selectorAlpha * 0.5)
--         if selectedSlot == slotIndex then
--             slotColor = Color(100, 100, 255, selectorAlpha * 0.6)
--         end

--         draw.RoundedBox(8, slotX, slotY, slotSize, slotSize, slotColor)
--         draw.SimpleText(slotIndex + 1, "mi.ws.text", slotX + slotSize / 2, slotY + slotSize / 2, Color(255, 255, 255, selectorAlpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

--         -- Отображение оружий в выбранном слоте
--         if selectedSlot == slotIndex then
--             local weaponPanelWidth = 200
--             local weaponPanelHeight = 30
--             local weaponPanelX = slotX - weaponPanelWidth - 5
--             local weaponPanelY = slotY

--             for index, weapon in ipairs(slotWeapons) do
--                 local weaponColor = Color(50, 50, 50, selectorAlpha * 0.6)
--                 if index == selectedWeaponIndex then
--                     weaponColor = Color(100, 100, 255, selectorAlpha * 0.8)
--                 end

--                 -- Анимация оружия
--                 local animX, animY = AnimateWeapons(index, weaponPanelX, weaponPanelY)

--                 draw.RoundedBox(8, animX, animY, weaponPanelWidth, weaponPanelHeight, weaponColor)
--                 draw.SimpleText(weapon:GetPrintName(), "mi.ws.text", animX + 10, animY + weaponPanelHeight / 2, Color(255, 255, 255, selectorAlpha), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

--                 weaponPanelY = weaponPanelY + weaponPanelHeight + 5
--             end
--         end

--         slotY = slotY + slotSize + 5
--     end
-- end

-- -- Обработка нажатий клавиш
-- hook.Add("PlayerBindPress", "millenium.weaponselector.press", function(ply, bind, pressed)
--     if ply ~= LocalPlayer() or not pressed then return end
--     bind = bind:lower()

--     local Slots = PopulateSlots(ply)
--     local weaponsInSlot = Slots[selectedSlot] or {}

--     -- Нажатие на 1–6 для смены оружия внутри слота
--     for i = 1, 6 do
--         if bind == "slot" .. i then
--             if selectedSlot == i - 1 then
--                 selectedWeaponIndex = selectedWeaponIndex % #weaponsInSlot + 1
--             else
--                 selectedSlot = i - 1
--                 selectedWeaponIndex = 1
--             end
--             selectorVisible = true
--             selectorLastUsed = CurTime()
--             PlaySound("common/wpn_moveselect.wav")
--             return true
--         end
--     end

--     -- Прокрутка колесика мыши
--     if (bind == "invnext" or bind == "invprev") and not holdAttack then
--         if firstScroll then
--             selectorVisible = true
--             selectorLastUsed = CurTime()
--             firstScroll = false
--             return true
--         end

--         selectedWeaponIndex = selectedWeaponIndex + (bind == "invnext" and 1 or -1)
--         if selectedWeaponIndex > #weaponsInSlot then
--             selectedWeaponIndex = 1
--         elseif selectedWeaponIndex < 1 then
--             selectedWeaponIndex = #weaponsInSlot
--         end

--         selectorVisible = true
--         selectorLastUsed = CurTime()
--         PlaySound("common/wpn_moveselect.wav")
--     end

--     -- Выбор оружия
--     if bind == "+attack" then
--         holdAttack = true
--         local selectedWeapon = weaponsInSlot[selectedWeaponIndex]
--         if selectedWeapon then
--             RunConsoleCommand("use", selectedWeapon:GetClass())
--             PlaySound("common/wpn_select.wav")
--         end
--         selectorVisible = false
--     end
-- end)

-- -- Удержание кнопки атаки
-- hook.Add("Think", "millenium.weaponselector.holdattack", function()
--     if not input.IsMouseDown(MOUSE_LEFT) then
--         holdAttack = false
--     end

--     if selectorVisible and CurTime() - selectorLastUsed > 2 then
--         selectorVisible = false
--         firstScroll = true
--     end
-- end)

-- -- Отрисовка интерфейса
-- hook.Add("HUDPaint", "millenium.weaponselector.draw", function()
--     WeaponSelector()
-- end)
