local Base = "https://raw.githubusercontent.com/sawedoffbilly/saiseiclient/refs/heads/main"

local function HttpRequire(Folder)
    local FileURL = Base .. Folder
    local FileContent = game:HttpGet(FileURL)
    
    return loadstring(FileContent)()
end

local InterfaceData = require_github("Data/Interface.lua")

print(InterfaceData.AccentColor)
