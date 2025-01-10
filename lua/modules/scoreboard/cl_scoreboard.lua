surface.CreateFont("ScoreboardHeader", {font = "Nunito Bold", extended = true, size = ScreenScale(8)})
surface.CreateFont("ScoreboardText", {font = "Nunito Bold", extended = true, size = ScreenScale(7)})
surface.CreateFont("ScoreboardButtons", {font = "Nunito Bold", extended = true, size = ScreenScale(6)})

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

        local PJobColor = team.GetColor(ply:Team())
        local PName = ply:getDarkRPVar("rpname")
        local PJob = ply:getDarkRPVar("job")
        local PPing = ply:Ping()

        local playerPanel = vgui.Create("DPanel", playersScroll)
        playerPanel:Dock(TOP)
        playerPanel:SetTall(40)
        playerPanel:DockMargin(0, 0, 0, 5)
        playerPanel.Opened = false
        playerPanel.Paint = function (me, w, h)
            draw.RoundedBox(mi_hud.rounding, 0, 0, w, h, Color(0,0,0,100))
        end

        local playerButton = vgui.Create("DButton", playerPanel)
        playerButton:Dock(TOP)
        playerButton:DockMargin(40, 0, 0, 0)
        playerButton:SetTall(playerPanel:GetTall())
        playerButton:SetText("")
        playerButton.Paint = function (me, w, h)
            draw.RoundedBox(0, 0, 0, w, h, PJobColor)
            if me:IsHovered() then
                surface.SetDrawColor(255,255,255, 10)
            else
                surface.SetDrawColor(255,255,255, 5)
            end
            surface.SetMaterial(Material("gui/gradient_up", "smooth mips"))
            surface.DrawTexturedRect(0, 0, w, h)
            draw.SimpleText(PName, "ScoreboardText", 10, h / 2, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            draw.SimpleText(PJob, "ScoreboardText", w / 2, h / 2, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

            surface.SetFont("ScoreboardText")
            local tw, th = surface.GetTextSize(PPing)
            local iconSize = h * .4
            local iconPadding = 10

            surface.SetDrawColor(255,255,255)
            surface.SetMaterial(mi_hud.icons.scoreboard.network)
            surface.DrawTexturedRect(w - w * .02 - tw - iconSize - iconPadding, h / 2 - iconSize / 2, iconSize, iconSize)

            draw.SimpleText(PPing, "ScoreboardText", w - w * .02, h / 2, Color(255,255,255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
        end
        playerButton.DoClick = function ()
            if playerPanel.Opened then
                playerPanel:SizeTo(playerPanel:GetWide(), 40, 1, 0, .1)
                playerPanel.Opened = false
            else
                playerPanel:SizeTo(playerPanel:GetWide(), 150, 1, 0, .1)
                playerPanel.Opened = true
            end
        end

        local playerAvatar = vgui.Create("AvatarImage", playerPanel)
        playerAvatar:SetSize(40, 40)
        playerAvatar:SetPos(0, 0)
        playerAvatar:SetPlayer(ply, 64)

        local playerCopySteamId = vgui.Create("DButton", playerPanel)
        playerCopySteamId:Dock(TOP)
        playerCopySteamId:SetText("")
        playerCopySteamId:SetTall(30)
        playerCopySteamId:DockMargin(10, 10, 10, 0)
        playerCopySteamId.Paint = function (me, w, h)
            draw.RoundedBox(0, 0, 0, w, h, mi_hud.theme.base)
            if me:IsHovered() then
                draw.RoundedBox(0, 0, 0, w, h, Color(255,255,255, 2.5))
            end
            draw.SimpleText(ply:SteamID(), "ScoreboardButtons", 10, h / 2, Color(255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
        end
        playerCopySteamId.DoClick = function ()
            notification.AddLegacy("Вы скопировали SteamID игрока " .. ply:getDarkRPVar("rpname"), NOTIFY_HINT, 5)
            SetClipboardText(ply:SteamID())
        end

        local playerOpenProfile = vgui.Create("DButton", playerPanel)
        playerOpenProfile:Dock(TOP)
        playerOpenProfile:SetText("")
        playerOpenProfile:SetTall(30)
        playerOpenProfile:DockMargin(10, 10, 10, 0)
        playerOpenProfile.Paint = function (me, w, h)
            draw.RoundedBox(0, 0, 0, w, h, mi_hud.theme.base)
            if me:IsHovered() then
                draw.RoundedBox(0, 0, 0, w, h, Color(255,255,255, 2.5))
            end
            draw.SimpleText("Открыть профиль Steam", "ScoreboardButtons", 10, h / 2, Color(255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
        end
        playerOpenProfile.DoClick = function ()
            window:Remove()
            gui.EnableScreenClicker(false)
            gui.OpenURL("https://steamcommunity.com/profiles/" .. ply:SteamID64() .. "/")
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
