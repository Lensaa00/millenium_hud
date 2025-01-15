local voices = {}

surface.CreateFont("mi.voice.name", {font = "Montserrat", size = ScreenScale(7), extended = true, antialias = true})

local function AddVoice(ply)
    if not ply then return end

    local scrw, scrh = ScrW(), ScrH()

    local panelW = scrw * 0.12 -- Ширина панели
    local panelH = 35 -- Высота панели

    local panelX = scrw - panelW - 10 -- Отступ справа
    local panelY = scrh - panelH - scrh * .2 -- Нижний отступ

    if #voices > 0 then
        local lastPanel = voices[#voices].Panel
        local _, lastPanelY = lastPanel:GetPos()
        panelY = lastPanelY - panelH - 5 -- Располагаем панели друг над другом с отступом
    end

    local voice = {}
    voice.Ply = ply

    voice.Panel = vgui.Create("DPanel")
    voice.Panel:SetSize(panelW, panelH)
    voice.Panel:SetPos(panelX, panelY)
    voice.Panel:SetBackgroundColor(Color(0, 0, 0, 150))
    voice.Panel:SetAlpha(0)
    voice.Panel:AlphaTo(255, .2, 0)

    function voice.Panel:Paint(w, h)
        local voiceAlpha = 50 * ply:VoiceVolume()
        draw.RoundedBox(mi_hud.rounding, 0, 0, w, h, mi_hud.theme.baseOutline)
        draw.RoundedBox(mi_hud.rounding, 1, 1, w - 2, h - 2, mi_hud.theme.base)

        draw.RoundedBox(mi_hud.rounding, 1, 1, w - 2, h - 2, Color(255,255,255, voiceAlpha))

        draw.SimpleText(ply:getDarkRPVar("rpname"), "mi.voice.name", h + 5, h / 2, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    voice.Avatar = vgui.Create("AvatarImage", voice.Panel)
    voice.Avatar:SetSize(voice.Panel:GetTall() - 6, voice.Panel:GetTall() - 6)
    voice.Avatar:SetPos(3, 3)
    voice.Avatar:SetPlayer(ply, 64)

    table.insert(voices, voice)
end

local function RemoveVoice(ply)
    for i, voice in ipairs(voices) do
        if voice.Ply == ply then
            table.remove(voices, i)
            if IsValid(voice.Panel) then
                voice.Panel:AlphaTo(0, .2, 0, function ()
                    voice.Panel:Remove()
                end)
            end
            break
        end
    end

    -- Переместить оставшиеся панели вниз
    local scrh = ScrH()
    local panelH = 30
    for index, voice in ipairs(voices) do
        local panelX = ScrW() - voice.Panel:GetWide() - 10
        local panelY = scrh - (panelH + 5) * index - 10
        voice.Panel:SetPos(panelX, panelY)
    end
end

hook.Add("PlayerStartVoice", "millenium.voice.start", function(ply)
    for _, voice in ipairs(voices) do
        if voice.Ply == ply then
            return -- Игрок уже добавлен
        end
    end

    AddVoice(ply)
end)

hook.Add("PlayerEndVoice", "millenium.voice.end", function(ply)
    RemoveVoice(ply)
end)

hook.Add("HUDPaint", "millenium.voices.draw", function()
    -- HUDPaint не используется, но можно добавить эффекты, если нужно
end)

mi_hud:Log("[VoiceHUD] Загружен")
