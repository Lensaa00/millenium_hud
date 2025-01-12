local function SetupFonts()
    surface.CreateFont("ScoreboardHeader", {font = "Montserrat Regular", extended = true, size = ScreenScale(6)})
    surface.CreateFont("ScoreboardText", {font = "Montserrat", extended = true, size = ScreenScale(6)})
    surface.CreateFont("ScoreboardTextShadow", {font = "Montserrat", blursize = 3, extended = true, size = ScreenScale(6)})
    surface.CreateFont("ScoreboardButtons", {font = "Montserrat", extended = true, size = ScreenScale(6)})
end

SetupFonts()

local function CreatePlayerRow(parent, ply)
    local panel = vgui.Create("DPanel", parent)
    panel:Dock(TOP)
    panel:SetTall(ScrH() * .025)
    panel:DockMargin(0, 0, 0, 5)
    panel.Opened = false
    panel.Paint = function(me, w, h)
        draw.RoundedBox(mi_hud.rounding, 0, 0, w, h, Color(0, 0, 0, 100))
    end

    local PJobColor = team.GetColor(ply:Team())
    local PName = ply:getDarkRPVar("rpname")
    local PJob = ply:getDarkRPVar("job")
    local PPing = ply:Ping()

    local button = vgui.Create("DButton", panel)
    button:Dock(TOP)
    button:DockMargin(panel:GetTall(), 0, 0, 0)
    button:SetTall(panel:GetTall())
    button:SetText("")
    button.Paint = function(me, w, h)
        if me:IsHovered() or panel.Opened then
            draw.RoundedBox(mi_hud.rounding, 0, 0, w, h, PJobColor)
        end

        draw.SimpleText(PName, "ScoreboardTextShadow", 10, h / 2 + 1, Color(0, 0, 0, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        draw.SimpleText(PName, "ScoreboardText", 10, h / 2, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        draw.SimpleText(PJob, "ScoreboardTextShadow", w / 2, h / 2 + 1, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText(PJob, "ScoreboardText", w / 2, h / 2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        surface.SetFont("ScoreboardText")
        local tw = surface.GetTextSize(PPing)
        local iconSize = h * .6
        local iconPadding = 10

        surface.SetDrawColor(255, 255, 255)
        surface.SetMaterial(mi_hud.icons.scoreboard.network)
        surface.DrawTexturedRect(w - w * .015 - tw - iconSize - iconPadding, h / 2 - iconSize / 2, iconSize, iconSize)

        draw.SimpleText(PPing, "ScoreboardTextShadow", w - w * .015, h / 2 + 1, Color(0, 0, 0, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
        draw.SimpleText(PPing, "ScoreboardText", w - w * .015, h / 2, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
    end

    button.DoClick = function()
        if panel.Opened then
            panel:SizeTo(panel:GetWide(), ScrH() * .025, 0.3, 0, 0.1)
            panel.Opened = false
        else
            panel:SizeTo(panel:GetWide(), ScrH() * .15, 0.3, 0, 0.1)
            panel.Opened = true
        end
    end

    local avatar = vgui.Create("AvatarImage", panel)
    avatar:SetSize(panel:GetTall(), panel:GetTall())
    avatar:SetPos(0, 0)
    avatar:SetPlayer(ply, 64)

    local options = {
        {
            name = "Скопировать SteamID",
            func = function()
                SetClipboardText(ply:SteamID())
                notification.AddLegacy("Вы скопировали SteamID игрока " .. PName, NOTIFY_HINT, 3)
            end
        },
        {
            name = "Открыть профиль Steam",
            func = function()
                gui.OpenURL("https://steamcommunity.com/profiles/" .. ply:SteamID64() .. "/")
                window:Remove()
                gui.EnableScreenClicker( false )
            end
        }
    }

    for _, option in ipairs(options) do
        local optBtn = vgui.Create("DButton", panel)
        optBtn:Dock(TOP)
        optBtn:DockMargin(5, 5, 5, 0)
        optBtn:SetTall(25)
        optBtn:SetText("")
        optBtn.DoClick = option.func
        optBtn.Paint = function(me, w, h)
            draw.RoundedBox(mi_hud.rounding, 0, 0, w, h, mi_hud.theme.base)
            if me:IsHovered() then
                draw.RoundedBox(mi_hud.rounding, 0, 0, w, h, Color(mi_hud.theme.baseOutline.r, mi_hud.theme.baseOutline.g, mi_hud.theme.baseOutline.b, 50))
            end
            draw.SimpleText(option.name, "ScoreboardButtons", w * .01, h / 2, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end
    end
end

local function Scoreboard()
    gui.EnableScreenClicker(true)

    local scrw, scrh = ScrW(), ScrH()

    window = vgui.Create("DPanel")
    window:SetSize(scrw * .6, scrh * .8)
    window:Center()
    window.Paint = function(me, w, h)
        draw.RoundedBox(mi_hud.rounding, 0, 0, w, h, mi_hud.theme.baseOutline)
        draw.RoundedBox(mi_hud.rounding, 1, 1, w - 2, h - 2, mi_hud.theme.base)
    end

    local header = vgui.Create("DPanel", window)
    header:Dock(TOP)
    header:SetTall(window:GetTall() * .04)
    header.Paint = function(me, w, h)
        draw.RoundedBox(mi_hud.rounding, 0, 0, w, h, mi_hud.theme.baseOutline)
        draw.SimpleText("Millenium RP | Игроки", "ScoreboardHeader", w / 2, h / 2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    local footer = vgui.Create("DPanel", window)
    footer:Dock(BOTTOM)
    footer:SetTall(window:GetTall() * .05)
    footer.Paint = function(me, w, h)
        draw.RoundedBox(mi_hud.rounding, 0, 0, w, h, Color(20, 20, 20, 200))
        draw.SimpleText("Онлайн: " .. #player.GetAll() .. " игроков", "ScoreboardButtons", 10, h / 2, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    local playersScroll = vgui.Create("DScrollPanel", window)
    playersScroll:Dock(FILL)
    playersScroll:DockMargin(10, 10, 10, 10)

    local sortedPlayers = player.GetAll()
    table.sort(sortedPlayers, function(a, b)
        return team.GetName(a:Team()):lower() < team.GetName(b:Team()):lower()
    end)

    for _, ply in ipairs(sortedPlayers) do
        CreatePlayerRow(playersScroll, ply)
    end
end

hook.Add("ScoreboardShow", "millenium.scoreboard.show", function()
    Scoreboard()
    return false
end)

hook.Add("ScoreboardHide", "millenium.scoreboard.hide", function()
    if IsValid(window) then
        gui.EnableScreenClicker(false)
        window:Remove()
    end
end)
