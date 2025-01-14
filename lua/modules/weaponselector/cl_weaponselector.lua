surface.CreateFont("mi.ws.slot", {font = "Montserrat Bold", size = ScreenScale(10), extended = true})
surface.CreateFont("mi.ws.weapon", {font = "Montserrat", size = ScreenScale(8), extended = true})

local Slots = {}
local activeSlots = {}

local selectorSlot = 1
local selectorWeaponIndex = 1
local selectorVisible = false
local selectorFirstChange = true
local lastInvChange = CurTime()
local hideTime = 2
local attackHeld = false

-- Анимация для альфа-канала (прозрачности)
local alphaValue = 0
local alphaIncrement = 1500

local function populateSlots()
    local slots = {}

    local Player = LocalPlayer()
    local Weapons = Player:GetWeapons()

    -- Инициализация слотов от 0 до 6
    for i = 0, 6 do
        slots[i] = {
            Weapons = {},
            PosX = 0,
            PosY = 0
        }
    end

    -- Распределение оружия по слотам
    for _, weapon in ipairs(Weapons) do
        local slot = weapon:GetSlot()

        -- Проверяем, существует ли слот
        if not slots[slot] then
            slots[slot] = { Weapons = {}, PosX = 0, PosY = 0 }
        end

        table.insert(slots[slot].Weapons, weapon)
    end

    return slots
end

local function updateActiveSlots()
    activeSlots = {}

    for slotIndex, slot in pairs(Slots) do
        if #slot.Weapons > 0 then
            table.insert(activeSlots, slot)
        end
    end
end

local function updateSelectedWeapon()
    local ply = LocalPlayer()
    local activeWeapon = ply:GetActiveWeapon()

    for slotIndex, slot in ipairs(activeSlots) do
        for weaponIndex, weapon in ipairs(slot.Weapons) do
            if weapon == activeWeapon then
                selectorSlot = slotIndex
                selectorWeaponIndex = weaponIndex
                return
            end
        end
    end

    -- Если активное оружие не найдено, сбрасываем выбор
    selectorSlot = 1
    selectorWeaponIndex = 1
end

-- Отображение пользовательского интерфейса
hook.Add("DrawOverlay", "millenium.ws.draw", function()
    if not selectorVisible then return end

    -- Обновление альфа-канала для анимации появления
    if alphaValue < 255 then
        alphaValue = math.min(255, alphaValue + (FrameTime() * alphaIncrement))
    end

    if CurTime() - lastInvChange >= hideTime then
        selectorVisible = false
        selectorFirstChange = true
        alphaValue = 0
        return
    end

    local scrw, scrh = ScrW(), ScrH()

    -- Формируем список активных слотов
    local slotSize = 30
    local slotsGap = 5
    local startX = scrw - slotSize - 10
    local startY = scrh / 2 - (#activeSlots / 2 * (slotSize + slotsGap))

    -- Отображение слотов
    for index, slot in ipairs(activeSlots) do
        slot.PosX = startX
        slot.PosY = startY

        local alpha = (index == selectorSlot) and alphaValue or math.max(100, alphaValue / 10)

        draw.RoundedBox(0, startX, startY, slotSize, slotSize, Color(mi_hud.theme.baseOutline.r, mi_hud.theme.baseOutline.g, mi_hud.theme.baseOutline.b, alpha))
        draw.RoundedBox(0, startX + 1, startY + 1, slotSize - 2, slotSize - 2, Color(mi_hud.theme.base.r, mi_hud.theme.base.g, mi_hud.theme.base.b, alpha))

        if index == selectorSlot then
            draw.RoundedBox(0, startX + 1, startY + 1, slotSize - 2, slotSize - 2, Color(mi_hud.theme.baseOutline.r, mi_hud.theme.baseOutline.g, mi_hud.theme.baseOutline.b, alpha))
        end

        draw.SimpleText(index, "mi.ws.slot", startX + slotSize / 2, startY + slotSize / 2, Color(255, 255, 255, alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        startY = startY + slotSize + slotsGap
    end

    -- Отображение оружия в текущем слоте
    if activeSlots[selectorSlot] then
        local panelW = 0
        local panelH = slotSize
        local panelGap = 5

        for _, weapon in ipairs(activeSlots[selectorSlot].Weapons) do
            surface.SetFont("mi.ws.weapon")
            local name = weapon:GetPrintName()
            local tw = surface.GetTextSize(name)
            panelW = math.max(panelW, tw + 20)
        end

        local panelX = activeSlots[selectorSlot].PosX - panelW - panelGap
        local panelY = activeSlots[selectorSlot].PosY

        for weaponIndex, weapon in ipairs(activeSlots[selectorSlot].Weapons) do
            draw.RoundedBox(0, panelX, panelY, panelW, panelH, mi_hud.theme.baseOutline)
            draw.RoundedBox(0, panelX + 1, panelY + 1, panelW - 2, panelH - 2, mi_hud.theme.base)

            if selectorWeaponIndex == weaponIndex then
                draw.RoundedBox(0, panelX, panelY, panelW, panelH, mi_hud.theme.baseOutline)
            end

            draw.SimpleText(weapon:GetPrintName(), "mi.ws.weapon", panelX + panelW - 10, panelY + panelH / 2, Color(255, 255, 255, alphaValue), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)

            panelY = panelY + panelH + panelGap
        end
    end
end)

hook.Add("PlayerBindPress", "millenium.ws.binds", function(ply, bind, pressed)
    if ply ~= LocalPlayer() then return end
    bind = bind:lower()

    print(bind)

    for i = 1, 6 do
        if string.find(bind, "slot" .. tostring(i)) and pressed then
            if not activeSlots[i] then return end
            surface.PlaySound("millenium_hud/click2.wav")
            lastInvChange = CurTime()
            if selectorFirstChange then
                selectorVisible = true
                selectorFirstChange = false
                updateSelectedWeapon()
                selectorSlot = i
                selectorWeaponIndex = 1
                return
            else
                if selectorSlot ~= i then
                    selectorSlot = i
                    selectorWeaponIndex = 1
                else
                    selectorWeaponIndex = selectorWeaponIndex + 1
                    if selectorWeaponIndex > #activeSlots[selectorSlot].Weapons then
                        selectorWeaponIndex = 1
                    end
                end
            end

            return true
        end
    end

    -- Обработка прокрутки колесика "invnext"
    if string.find(bind, "invnext") then
        lastInvChange = CurTime()

        if attackHeld then return end -- Если атака зажата, не открываем селектор

        if selectorFirstChange then
            selectorVisible = true
            selectorFirstChange = false
            updateSelectedWeapon()
        else
            selectorWeaponIndex = selectorWeaponIndex + 1
            if selectorWeaponIndex > #activeSlots[selectorSlot].Weapons then
                selectorSlot = selectorSlot + 1
                if selectorSlot > #activeSlots then selectorSlot = 1 end
                selectorWeaponIndex = 1
            end
        end
        surface.PlaySound("millenium_hud/click2.wav")
    elseif string.find(bind, "invprev") then
        lastInvChange = CurTime()

        if attackHeld then return end -- Если атака зажата, не открываем селектор

        if selectorFirstChange then
            selectorVisible = true
            selectorFirstChange = false
            updateSelectedWeapon()
        else
            selectorWeaponIndex = selectorWeaponIndex - 1
            if selectorWeaponIndex < 1 then
                selectorSlot = selectorSlot - 1
                if selectorSlot < 1 then selectorSlot = #activeSlots end
                selectorWeaponIndex = #activeSlots[selectorSlot].Weapons
            end
        end
        surface.PlaySound("millenium_hud/click2.wav")
    elseif string.find(bind, "attack") and not string.find(bind, "attack2") then
        if selectorVisible then
            local selectedWeapon = activeSlots[selectorSlot] and activeSlots[selectorSlot].Weapons[selectorWeaponIndex]
            if selectedWeapon then
                RunConsoleCommand("use", selectedWeapon:GetClass())
                surface.PlaySound("millenium_hud/click.wav")
            end
            selectorVisible = false
            selectorFirstChange = true
            alphaValue = 0
            return true
        end
    end
end)


hook.Add("Think", "millenium.ws.updateSlots", function()
    if LocalPlayer():KeyPressed(IN_ATTACK) then
        attackHeld = true
    elseif LocalPlayer():KeyReleased(IN_ATTACK) then
        attackHeld = false
    end
    Slots = populateSlots()
    updateActiveSlots()
end)
