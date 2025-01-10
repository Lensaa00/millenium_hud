surface.CreateFont("ScoreboardHeader", {font = "Nunito Bold", extended = true, size = ScreenScale(8)})
surface.CreateFont("ScoreboardText", {font = "Nunito Bold", extended = true, size = ScreenScale(7)})
surface.CreateFont("ScoreboardButtons", {font = "Nunito", extended = true, size = ScreenScale(5)})

local function Scoreboard()
    gui.EnableScreenClicker(true)

    local scrw, scrh = ScrW(), ScrH()

    window = vgui.Create("DPanel")
    window:SetSize(scrw * .6, scrh * .8)
    window:Center()
    window.Paint = function (me, w, h)
        draw.RoundedBox(mi_hud.rounding, 0, 0, w, h, mi_hud.theme.baseOutline)
        draw.RoundedBox(mi_hud.rounding, 1, 1, w - 2, h - 2, mi_hud.theme.base)
    end

    local header = vgui.Create("DPanel", window)
    header:Dock(TOP)
    header:SetTall(window:GetTall() * .05)
    header.Paint = function (me, w, h)
        draw.RoundedBox(mi_hud.rounding, 0, 0, w, h, mi_hud.theme.baseOutline)
        draw.SimpleText("Millenium RP | Игроки", "ScoreboardHeader", w / 2, h / 2, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    -- local footer = vgui.Create("DPanel", window)
    -- footer:Dock(BOTTOM)
    -- footer:SetTall(window:GetTall() * .05)
    -- footer.Paint = function (me, w, h)
    --     draw.RoundedBox(mi_hud.rounding, 0, 0, w, h, mi_hud.theme.baseOutline)
    -- end

    local playersScroll = vgui.Create("DScrollPanel", window)
    playersScroll:Dock(FILL)
    playersScroll:DockMargin(10, 10, 10, 10)
    playersScroll.OnMouseWheeled = function(self, delta)
        local scroll = self:GetVBar():GetScroll()
        self:GetVBar():SetScroll(scroll - delta * 5)
    end

    local vbar = playersScroll:GetVBar()
    vbar:SetWide(10)
    vbar.Paint = function (me, w, h)
        draw.RoundedBox(100, w * .7, 0, w * .3, h, Color(0,0,0,100))
    end
    function vbar.btnUp:Paint(w, h)
    end
    function vbar.btnDown:Paint(w, h)
    end
    function vbar.btnGrip:Paint(w, h)
        draw.RoundedBox(100, w * .7, 0, w * .3, h, mi_hud.theme.baseOutline)
    end

    for _, ply in ipairs(player.GetAll()) do

        local playerVars = {
            {
                value = ply:getDarkRPVar("rpname"),
            },
            {
                value = ply:getDarkRPVar("job"),
            },
            {
                value = ply:Ping(),
                icon = mi_hud.icons.scoreboard.network,
            }
        }

        local PlayerOptions = {
            {
                name = ply:SteamID(),
                func = function ()
                    SetClipboardText(ply:SteamID())
                    notification.AddLegacy("Вы скопировали SteamID игрока " .. ply:getDarkRPVar("rpname"), NOTIFY_HINT, 3)
                end
            },
            {
                name = "Открыть профиль Steam",
                func = function ()
                    window:Remove()
                    gui.EnableScreenClicker(false)
                    gui.OpenURL("https://steamcommunity.com/profiles/" .. ply:SteamID64() .. "/")
                end
            }
        }

        local PJobColor = team.GetColor(ply:Team())
        local PName = ply:getDarkRPVar("rpname")
        local PJob = ply:getDarkRPVar("job")
        local PPing = ply:Ping()

        local playerPanel = vgui.Create("DPanel", playersScroll)
        playerPanel:Dock(TOP)
        playerPanel:SetTall(window:GetTall() * .035)
        playerPanel:DockMargin(0, 0, 0, 5)
        playerPanel.Opened = false
        playerPanel.Paint = function (me, w, h)
            draw.RoundedBox(mi_hud.rounding, 0, 0, w, h, Color(0,0,0,100))
        end

        local playerButton = vgui.Create("DButton", playerPanel)
        playerButton:Dock(TOP)
        playerButton:DockMargin(playerPanel:GetTall(), 0, 0, 0)
        playerButton:SetTall(playerPanel:GetTall())
        playerButton:SetText("")
        playerButton.Paint = function (me, w, h)
            draw.RoundedBox(0, 0, 0, w, h, PJobColor)
            if me:IsHovered() then
                surface.SetDrawColor(255,255,255, 20)
            else
                surface.SetDrawColor(255,255,255, 10)
            end
            surface.SetMaterial(Material("gui/gradient_up", "smooth mips"))
            surface.DrawTexturedRect(0, 0, w, h)
            draw.SimpleText(PName, "ScoreboardText", 10, h / 2, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            draw.SimpleText(PJob, "ScoreboardText", w / 2, h / 2, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

            surface.SetFont("ScoreboardText")
            local tw, th = surface.GetTextSize(PPing)
            local iconSize = h * .6
            local iconPadding = 10

            surface.SetDrawColor(255,255,255)
            surface.SetMaterial(mi_hud.icons.scoreboard.network)
            surface.DrawTexturedRect(w - w * .02 - tw - iconSize - iconPadding, h / 2 - iconSize / 2, iconSize, iconSize)

            draw.SimpleText(PPing, "ScoreboardText", w - w * .02, h / 2, Color(255,255,255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
        end
        playerButton.DoClick = function ()
            if playerPanel.Opened then
                playerPanel:SizeTo(playerPanel:GetWide(), window:GetTall() * .035, 1, 0, .1)
                playerPanel.Opened = false
            else
                playerPanel:SizeTo(playerPanel:GetWide(), window:GetTall() * .15, 1, 0, .1)
                playerPanel.Opened = true
            end
        end

        -- Аватар игрока
        local playerAvatar = vgui.Create("AvatarImage", playerPanel)
        playerAvatar:SetSize(playerPanel:GetTall(), playerPanel:GetTall())
        playerAvatar:SetPos(0, 0)
        playerAvatar:SetPlayer(ply, 64)

        -- Добавление кнопок у пользователя
        for _, option in ipairs(PlayerOptions) do
            local button = vgui.Create("DButton", playerPanel)
            button:Dock(TOP)
            button:DockMargin(5, 5, 5, 0)
            button:SetTall(25)
            button:SetText("")
            button.DoClick = option.func
            button.Paint = function (me, w, h)
                draw.RoundedBox(0, 0, 0, w, h, mi_hud.theme.base)
                if me:IsHovered() then
                    draw.RoundedBox(0, 0, 0, w, h, Color(mi_hud.theme.baseOutline.r, mi_hud.theme.baseOutline.g, mi_hud.theme.baseOutline.b, 50))
                end
                draw.SimpleText(option.name, "ScoreboardButtons", w * .01, h / 2, Color(255,255,255), TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
            end
        end

    end
end

hook.Add("ScoreboardShow", "millenium.scoreboard.show", function ()
    Scoreboard()
    return false
end)

hook.Add("ScoreboardHide", "millenium.scoreboard.hide", function ()
    if IsValid(window) then
        gui.EnableScreenClicker(false)
        window:Remove()
    end
end)
