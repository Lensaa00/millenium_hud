surface.CreateFont("ScoreboardHeader", {font = "Nunito", extended = true, size = ScreenScale(8)})
surface.CreateFont("ScoreboardText", {font = "Nunito Bold", extended = true, size = ScreenScale(7)})

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
        playerPanel.Paint = function (me, w, h)
            draw.RoundedBox(0, 0, 0, w, h, PJobColor)
            draw.SimpleText(PName, "ScoreboardText", me:GetTall() + 10, h / 2, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
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

        local playerAvatar = vgui.Create("AvatarImage", playerPanel)
        playerAvatar:SetSize(playerPanel:GetTall(), playerPanel:GetTall())
        playerAvatar:Dock(LEFT)
        playerAvatar:SetPlayer(ply, 64)
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
