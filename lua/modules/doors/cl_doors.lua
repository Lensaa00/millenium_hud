local ply = LocalPlayer()
local Cache = {}

surface.CreateFont("mi.doors.header", {font = "Montserrat Bold", size = ScreenScale(13), extended = true, antialias = true})
surface.CreateFont("mi.doors.header.shadow", {font = "Montserrat Bold", size = ScreenScale(13), blursize = 2, extended = true, antialias = true})
surface.CreateFont("mi.doors.subheader", {font = "Montserrat", size = ScreenScale(10), extended = true, antialias = true})
surface.CreateFont("mi.doors.subheader.shadow", {font = "Montserrat", size = ScreenScale(10), blursize = 2, extended = true, antialias = true})

local function Draw2D3DDoor(door)
    if not IsValid(door) then return end -- Ensure the door is valid

    -- Door position and angles
    local DoorData = {}
    local DoorAngles = door:GetAngles()

    if Cache[door] then
        DoorData = Cache[door]
    else
        local OBBMaxs = door:OBBMaxs()
        local OBBMins = door:OBBMins()
        local OBBCenter = door:OBBCenter()

        local size = OBBMins - OBBMaxs
        size = Vector(math.abs(size.x), math.abs(size.y), math.abs(size.z))

        local OBBCenterToWorld = door:LocalToWorld(OBBCenter)

        local TraceTbl = {
            endpos = OBBCenterToWorld,
            filter = function(ent)
                return !(ent:IsPlayer() or ent:IsWorld())
            end
        }

        local WidthOffset
        local HeightOffset = Vector(0, 0, 16)
        local DrawAngles
        local scale = 0.1
        local CanvasPos
        local CanvasPosReverse
        local canvasWidth

        if size.x > size.y then
            DrawAngles = Angle(0, 0, 90)
            TraceTbl.start = OBBCenterToWorld + door:GetRight() * (size.y / 2)

            local thickness = util.TraceLine(TraceTbl).Fraction * (size.y / 2) + 0.5
            WidthOffset = Vector(size.x / 2, thickness, 0)

            canvasWidth = size.x / scale
        else
            DrawAngles = Angle(0, 90, 90)
            TraceTbl.start = OBBCenterToWorld + door:GetForward() * (size.x / 2)

            local thickness = (1 - util.TraceLine(TraceTbl).Fraction) * (size.x / 2) + 0.5
            WidthOffset = Vector(-thickness, size.y / 2, 0)

            canvasWidth = size.y / scale
        end

        CanvasPos = OBBCenter - WidthOffset + HeightOffset
        CanvasPosReverse = OBBCenter + WidthOffset + HeightOffset

        DoorData = {
            DrawAngles = DrawAngles,
            CanvasPos = CanvasPos,
            CanvasPosReverse = CanvasPosReverse,
            scale = scale,
            canvasWidth = canvasWidth,
            start = TraceTbl.start
        }

        Cache[door] = DoorData
    end

    -- Door info
    local doorData = door:getDoorData()
    local doorHeader = ""
    local doorSubHeader = ""

    if not doorData.nonOwnable then
        if doorData.owner then
            local title = doorData.title or "Дверь"
            if #title > 35 then
                title = string.sub(title, 1, 32) .. "..."
            end
            doorHeader = title
            local doorOwner = Player(doorData.owner)
            doorSubHeader = IsValid(doorOwner) and "Владелец: " .. doorOwner:Name() or "Владелец: Неизвестен"
        elseif doorData.teamOwn then
            doorSubHeader = doorData.teamOwn
        elseif doorData.groupOwn then
            doorHeader = doorData.groupOwn
        else
            doorHeader = "Свободная дверь"
            doorSubHeader = "Нажмите F2, чтобы купить"
        end
    end


    local function drawDoor()
        draw.SimpleText(doorHeader, "mi.doors.header.shadow", DoorData.canvasWidth / 2, 1, Color(0,0,0), TEXT_ALIGN_CENTER)
        draw.SimpleText(doorSubHeader, "mi.doors.subheader.shadow", DoorData.canvasWidth / 2, 50 * 1 + 1, Color(0,0,0), TEXT_ALIGN_CENTER)
        draw.SimpleText(doorHeader, "mi.doors.header", DoorData.canvasWidth / 2, 0, color_white, TEXT_ALIGN_CENTER)
        draw.SimpleText(doorSubHeader, "mi.doors.subheader", DoorData.canvasWidth / 2, 50 * 1, color_white, TEXT_ALIGN_CENTER)
    end

    cam.Start3D()
        cam.Start3D2D(door:LocalToWorld(DoorData.CanvasPos), DoorData.DrawAngles + DoorAngles, DoorData.scale)
            drawDoor()
        cam.End3D2D()

        cam.Start3D2D(door:LocalToWorld(DoorData.CanvasPosReverse), DoorData.DrawAngles + DoorAngles + Angle(0, 180, 0), DoorData.scale)
            drawDoor()
        cam.End3D2D()
    cam.End3D()
end

hook.Add("RenderScreenspaceEffects", "millenium_hud.doors.draw", function( )
    local entities = ents.FindInSphere(LocalPlayer():EyePos(), mi_hud.drawDistance * 1.5)

    for _, curEnt in ipairs(entities) do
        if IsValid(curEnt) and curEnt:isDoor() and curEnt:GetClass() != "prop_dynamic" and not curEnt:GetNoDraw() then
            Draw2D3DDoor(curEnt)
        end
    end
end)
