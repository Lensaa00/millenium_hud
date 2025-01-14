surface.CreateFont("mi.sb.header", { font = "Montserrat", extended = true, size = ScreenScale(7), antialias = true})
surface.CreateFont("mi.sb.text", { font = "Montserrat", extended = true, size = ScreenScale(6), antialias = true})
surface.CreateFont("mi.sb.text.shadow", { font = "Montserrat", extended = true, size = ScreenScale(6), antialias = true})

local function CopyColor( color )
    return Color(color.r, color.g, color.b, color.a)
end

local function createPlayerPanel( ply, parent, height )
    if not ply or not IsValid(ply) then return end
    if not parent then return end
    if not height then return end

    local animationSmooth = 10

    local PlayerName = ply:getDarkRPVar("rpname")
    local PlayerJob = ply:getDarkRPVar("job")
    local PlayerTeamColor = team.GetColor(ply:Team())
    local PlayerPing = ply:Ping()
    local PlayerSteam = ply:SteamID()

    local panel = vgui.Create("DPanel", parent)
    panel:Dock(TOP)
    panel:DockMargin(5, 0, 5, 5)
    panel:SetTall(height)
    panel.Paint = function () end
    panel.ClosedHeight = height
    panel.Closed = true
    panel.Paint = function (me, w, h)
        draw.RoundedBox(0, 0, 0, w, h, mi_hud.scoreboard.theme.outline)
        draw.RoundedBox(0, 1, 1, w - 2, h - 2, mi_hud.scoreboard.theme.panel)

        surface.SetDrawColor(0,0,0,50)
        surface.SetMaterial(Material("gui/gradient_down", "smooth mips"))
        surface.DrawTexturedRect(0,panel.ClosedHeight,w, 20)
    end

    local avatar = vgui.Create("AvatarImage", panel)
    avatar:SetPlayer( ply, 64 )
    avatar:SetSize( panel.ClosedHeight, panel.ClosedHeight )

    local button = vgui.Create("DButton", panel)
    button:Dock(TOP )
    button:SetTall(panel.ClosedHeight)
    button:SetText("")
    button:DockMargin(panel.ClosedHeight, 0, 0, 0)
    button.DefaultAlpha = 70
    button.HoveredAlpha = 150
    button.CurAlpha = button.DefaultAlpha
    button.SoundPlayed = false
    button.Paint = function (me, w, h)
        local gradient = Material("gui/gradient_up")
        local outlineColor = CopyColor(PlayerTeamColor)
        outlineColor.a = 70
        local color = CopyColor(PlayerTeamColor)
        color.a = button.CurAlpha

        draw.RoundedBox(mi_hud.rounding, 0, 0, 1, h, outlineColor) -- Left
        draw.RoundedBox(mi_hud.rounding, 0, 0, w, 1, outlineColor) -- Top
        draw.RoundedBox(mi_hud.rounding, w - 1, 0, 1, h, outlineColor) -- Right
        draw.RoundedBox(mi_hud.rounding, 0, h - 1, w, 1, outlineColor) -- Bottom

        if me:IsHovered() then
            button.CurAlpha = Lerp(FrameTime() * animationSmooth, button.CurAlpha, button.HoveredAlpha)
            if not me.SoundPlayed then
                surface.PlaySound("millenium_hud/click2.wav")
                me.SoundPlayed = true
            end
        else
            button.CurAlpha = Lerp(FrameTime() * animationSmooth, button.CurAlpha, button.DefaultAlpha)
            me.SoundPlayed = false
        end

        surface.SetDrawColor(color)
        surface.SetMaterial(gradient)
        surface.DrawTexturedRect(0, 0, w, h)

        draw.SimpleText(PlayerName, "mi.sb.text", w * .01, h / 2 + 1, mi_hud.scoreboard.theme.text, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

        draw.SimpleText(PlayerJob, "mi.sb.text", w / 2, h / 2 + 1, mi_hud.scoreboard.theme.text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        draw.SimpleText(PlayerPing, "mi.sb.text", w - w * .01, h / 2 + 1, mi_hud.scoreboard.theme.text, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)


    end
    button.DoClick = function ( me )
        if panel.Closed then
            panel:SizeTo(panel:GetWide(), parent:GetTall() * .15, 1, 0, .1)
        else
            panel:SizeTo(panel:GetWide(), panel.ClosedHeight, 1, 0, .1)
        end
        panel.Closed = not panel.Closed
        -- surface.PlaySound("ambient/water/rain_drip1.wav")
        surface.PlaySound("millenium_hud/click.wav")
    end
end

local function createWindow(width, height)

    local sortedPlayers = player.GetAll()
    table.sort(sortedPlayers, function(a, b)
        local aName = a:getDarkRPVar("rpname"):lower()
        local bName = b:getDarkRPVar("rpname"):lower()
        local aJob =  team.GetName(a:Team()):lower()
        local bJob =  team.GetName(b:Team()):lower()

        if aJob == bJob then
            return aName < bName
        else
            return aJob < bJob
        end
    end)

    local panel = vgui.Create("DPanel")
    panel:SetSize(0, 0)
    panel.opening = true
    panel:SizeTo(width, height, .5, 0, .1, function ()
        panel.opening = false
    end)
    panel.Paint = function (me, w, h)
        draw.RoundedBox(mi_hud.rounding, 0, 0, w, h, mi_hud.scoreboard.theme.baseOutline)
        draw.RoundedBox(mi_hud.rounding, 1, 1, w - 2, h - 2, mi_hud.scoreboard.theme.base)
    end

    local header = vgui.Create("DPanel", panel)
    header.Paint = function (me, w, h)
        draw.RoundedBox(mi_hud.rounding, 0, 0, w, h, mi_hud.scoreboard.theme.header)
        draw.SimpleText("Millenium RP | Игроки", "mi.sb.header", w / 2, h / 2, mi_hud.scoreboard.theme.text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    local footer = vgui.Create("DPanel", panel)
    footer.Paint = function (me, w, h)
        draw.RoundedBox(mi_hud.rounding, 0, 0, w, h, mi_hud.scoreboard.theme.header)
    end

    local scroll = vgui.Create("DScrollPanel", panel)
    scroll:DockMargin(0, 5, 0, 5)
    local sbar = scroll:GetVBar()
    sbar.HoveredAlpha = 5
    sbar.DefaultAlpha = 0
    sbar.CurAlpha = sbar.DefaultAlpha
    sbar:SetWide(scroll:GetWide() * .2)
    function sbar:Paint(w, h)
        local width = w * .5
        draw.RoundedBox(100, w / 2 - width, 0, width, h, Color(0,0,0,100))
    end
    function sbar.btnUp:Paint(w, h)
    end
    function sbar.btnDown:Paint(w, h)
    end
    function sbar.btnGrip:Paint(w, h)
        local alpha
        local width = w * .5
        draw.RoundedBox(100, w / 2 - width, 0, width, h, mi_hud.scoreboard.theme.panel)
        if sbar.btnGrip:IsHovered() then
            sbar.CurAlpha = Lerp(FrameTime() * 10, sbar.CurAlpha, sbar.HoveredAlpha)
        else
            sbar.CurAlpha = Lerp(FrameTime() * 10, sbar.CurAlpha, sbar.DefaultAlpha)
        end

        draw.RoundedBox(100, w / 2 - width, 0, width, h, Color(255,255,255,sbar.CurAlpha))

    end

    for _, ply in ipairs(sortedPlayers) do
        createPlayerPanel(ply, scroll, 30)
    end

    panel.Think = function ()
        if panel.opening then
            panel:Center()
            header:Dock(TOP)
            header:SetTall(panel:GetTall() * .04)
            footer:Dock(BOTTOM)
            footer:SetTall(panel:GetTall() * .04)
            scroll:Dock(FILL)
        end
    end

    return panel
end

local function Scoreboard()

    gui.EnableScreenClicker( true )
    local scrw, scrh = ScrW(), ScrH()

    scoreboard = createWindow(scrw * .6, scrh * .8)

end

hook.Add("ScoreboardShow", "millenium.scoreboard.show", function()
    Scoreboard()
    return false
end)

hook.Add("ScoreboardHide", "millenium.scoreboard.hide", function()
    gui.EnableScreenClicker(false)
    if IsValid(scoreboard) then
        scoreboard:AlphaTo(0, .1, 0, function ()
            if IsValid(scoreboard) then
                scoreboard:Remove()
            end
        end)
    end
end)

mi_hud:Log("[Scoreboard] Загружен")
