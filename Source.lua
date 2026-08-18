local Base = "https://raw.githubusercontent.com/sawedoffbilly/saiseiclient/refs/heads/main/"

local function HttpRequire(Folder)
    local FileURL = Base .. Folder
    local FileContent = game:HttpGet(FileURL)
    
    return loadstring(FileContent)()
end

local InterfaceData = HttpRequire("Data/Interface.lua")
local InterfaceUtils = HttpRequire("Utils/Interface.lua")

InterfaceUtils.Init()
