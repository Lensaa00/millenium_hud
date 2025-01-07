mi_hud = {}

if SERVER then
    include("config.lua")
    AddCSLuaFile("config.lua")
end

if CLIENT then
    include("config.lua")
end

local function LoadFolder(path)
    local files, folders = file.Find(path .. "/*", "LUA")

    for _, fileName in ipairs(files) do
        local prefix = string.sub(fileName, 1, 3)
        local filePath = path .. "/" .. fileName

        if prefix == "sv_" then
            if SERVER then
                print("[SERVER] Including: " .. filePath)
                include(filePath)
            end
        elseif prefix == "cl_" then
            if SERVER then
                print("[SERVER] Adding to client: " .. filePath)
                AddCSLuaFile(filePath)
            end
            if CLIENT then
                print("[CLIENT] Including: " .. filePath)
                include(filePath)
            end
        elseif prefix == "sh_" then
            if SERVER then
                print("[SERVER] Adding to client and including: " .. filePath)
                AddCSLuaFile(filePath)
                include(filePath)
            end
            if CLIENT then
                print("[CLIENT] Including: " .. filePath)
                include(filePath)
            end
        else
            print("[WARNING] Unknown prefix for file: " .. filePath)
        end
    end

    for _, folderName in ipairs(folders) do
        print("[INFO] Entering folder: " .. folderName)
        LoadFolder(path .. "/" .. folderName)
    end
end

-- Загружаем все файлы из папки modules
LoadFolder("modules")
