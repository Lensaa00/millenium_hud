surface.CreateFont("DoorHeader", {font = "Montserrat Bold", size = 40, extended = true, antialias = true})
surface.CreateFont("DoorSubHeader", {font = "Montserrat", size = 30, extended = true, antialias = true})
surface.CreateFont("DoorHeaderShadow", {font = "Montserrat Bold", size = 40, blursize = 4, extended = true, antialias = true})
surface.CreateFont("DoorSubHeaderShadow", {font = "Montserrat", size = 30, blursize = 4, extended = true, antialias = true})

local ply = LocalPlayer()
local Cache = {}

local function Draw2D3DDoor(door)
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
            doorHeader = doorData.title or "Дверь"
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
        draw.SimpleText(doorHeader, "DoorHeaderShadow", DoorData.canvasWidth / 2, 1, Color(0,0,0), TEXT_ALIGN_CENTER)
        draw.SimpleText(doorSubHeader, "DoorSubHeaderShadow", DoorData.canvasWidth / 2, 50 * 1 + 1, Color(0,0,0), TEXT_ALIGN_CENTER)
        draw.SimpleText(doorHeader, "DoorHeader", DoorData.canvasWidth / 2, 0, color_white, TEXT_ALIGN_CENTER)
        draw.SimpleText(doorSubHeader, "DoorSubHeader", DoorData.canvasWidth / 2, 50 * 1, color_white, TEXT_ALIGN_CENTER)
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

hook.Add("RenderScreenspaceEffects", "millenium_hud.doors.draw", function()
    local entities = ents.FindInSphere(ply:EyePos(), 280)

    for _, curEnt in ipairs(entities) do
        if curEnt:isDoor() and curEnt:GetClass() != "prop_dynamic" and not curEnt:GetNoDraw() then
            Draw2D3DDoor(curEnt)
        end
    end
end)
