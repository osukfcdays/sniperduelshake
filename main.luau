-- i just use a do end for everything to isolate tables and variables i dont want taking up registers

if string.find(identifyexecutor(), "Xeno") or string.find(identifyexecutor(), "Solara") then
    game:GetService("Players").LocalPlayer:Kick("my executor kinda uncless😭👌 xeno and solara arent supported currently")
end

loadstring(game:HttpGet("https://raw.githubusercontent.com/osukfcdays/sniperduelshake/refs/heads/main/workaround.luau"))()

if not isfolder("sniperduelshake") or not isfile("sniperduelshake/version.txt") then
    local res = request({
        Url = "https://api.github.com/repos/osukfcdays/sniperduelshake/git/trees/main?recursive=1",
        Method = "GET",
        Headers = {["User-Agent"] = "microsoft support"}, -- very trustable no scam
    })

    makefolder("sniperduelshake")
    makefolder("sniperduelshake/assets")

    local tree = cloneref(game:GetService("HttpService")):JSONDecode(res.Body).tree
    local jobs, jobsfinished = {}, 0

    for _,v in tree do
        if v.path:sub(1, 7) == "assets/" then
            if v.type == "tree" then
                makefolder("sniperduelshake/" .. v.path)
            elseif v.type == "blob" then
                table.insert(jobs, v.path)
            end
        end
    end

    for _,v in jobs do
        task.spawn(function()
            pcall(function()
                local dl = request({
                    Url = "https://raw.githubusercontent.com/osukfcdays/sniperduelshake/main/" .. v:gsub(" ", "%%20"),
                    Method = "GET",
                })
                if dl and dl.StatusCode == 200 and dl.Body then
                    writefile("sniperduelshake/" .. v, dl.Body)
                end
            end)
            jobsfinished += 1
        end)
    end

    repeat
        task.wait(0.1)
    until jobsfinished == #jobs

    writefile("sniperduelshake/version.txt", "1.67")
end

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/pubmain/LinoriaLib/refs/heads/main/Library.lua"))() 
local thememanager = loadstring(game:HttpGet("https://raw.githubusercontent.com/pubmain/LinoriaLib/refs/heads/main/addons/ThemeManager.lua"))() 
local savemanager = loadstring(game:HttpGet("https://raw.githubusercontent.com/pubmain/LinoriaLib/refs/heads/main/addons/SaveManager.lua"))() 

library.ToggleKeybind = "Del"

local window = library:CreateWindow({
	Title = "SDFucker | Sniper Duels | " .. identifyexecutor(),
	Center = true,
	AutoShow = true,
	Resizable = true,
	ShowCustomCursor = true,
	UnlockMouseWhileOpen = true,
	TabPadding = 8,
	MenuFadeTime = 0.5,
	NotifySide = "Right",
	ShowToggleFrameInKeybinds = true,
})

local tabs = {
	main = window:AddTab("main"),
    visuals = window:AddTab("player"),
    worldvisuals = window:AddTab("world"),
    misc = window:AddTab("misc"),
    config = window:AddTab("configs")
}

local main = tabs.main:AddLeftGroupbox("main")
local other = tabs.main:AddRightGroupbox("movement")
local selfvisuals = tabs.visuals:AddLeftGroupbox("self visuals")
local playervisuals = tabs.visuals:AddRightGroupbox("player visuals")
local miscmain = tabs.misc:AddLeftGroupbox("queue")
local miscweapons = tabs.misc:AddRightTabbox()
local config = tabs.config:AddRightGroupbox("Misc")
local lightingvisuals = tabs.worldvisuals:AddLeftGroupbox("lighting visuals")
local skyboxvisuals = tabs.worldvisuals:AddLeftGroupbox("skybox visuals")
local atmospherevisuals = tabs.worldvisuals:AddRightTabbox()
local bloomvisuals = tabs.worldvisuals:AddRightTabbox()

local maintab = miscweapons:AddTab("main")
--local knifetab = miscweapons:AddTab("knife") -- idk what to even add rn
local guntab = miscweapons:AddTab("gun")

local lighting = cloneref(game:GetService("Lighting")) -- use cloneref here but then NEVER again, opsex level god
local runserv = cloneref(game:GetService("RunService"))
local players = cloneref(game:GetService("Players"))
local httpservice = cloneref(game:GetService("HttpService"))
local localplayer = players.LocalPlayer
local camera = cloneref(game:GetService("Workspace")).CurrentCamera

local modules = {
    weaponcontroller = require(game:GetService("ReplicatedStorage"):FindFirstChild("Modules"):WaitForChild("Controllers"):WaitForChild("WeaponController"):WaitForChild("Gun")),
    meleecontroller = require(game:GetService("ReplicatedStorage"):FindFirstChild("Modules"):WaitForChild("Controllers"):WaitForChild("WeaponController"):WaitForChild("Melee")),
    crosshaircontroller = require(game:GetService("ReplicatedStorage"):FindFirstChild("Modules"):WaitForChild("Controllers"):WaitForChild("CrosshairController")),
    cameracontroller = require(game:GetService("ReplicatedStorage"):FindFirstChild("Modules"):WaitForChild("Controllers"):WaitForChild("CameraController")),
    matchcontroller = require(game:GetService("ReplicatedStorage"):FindFirstChild("Modules"):WaitForChild("Controllers"):WaitForChild("MatchController")),
    toolcontroller = require(game:GetService("ReplicatedStorage"):FindFirstChild("Modules"):WaitForChild("Controllers"):WaitForChild("ToolController")),
    viewmodelcontroller = require(game:GetService("ReplicatedStorage"):FindFirstChild("Modules"):WaitForChild("Controllers"):WaitForChild("ViewmodelController")),
    charactercontroller = require(game:GetService("ReplicatedStorage"):FindFirstChild("Modules"):WaitForChild("Controllers"):WaitForChild("CharacterController")),
    settingsmain = require(game:GetService("ReplicatedStorage"):FindFirstChild("Modules"):WaitForChild("Configs"):WaitForChild("Settings"):WaitForChild("SettingsMain")),
    effects = require(game:GetService("ReplicatedStorage"):FindFirstChild("Modules"):WaitForChild("Controllers"):WaitForChild("Effects")),
    skinconfig = require(game:GetService("ReplicatedStorage"):FindFirstChild("Modules"):WaitForChild("Configs"):WaitForChild("SkinConfig")),
    killeffectsconfig = require(game:GetService("ReplicatedStorage"):FindFirstChild("Modules"):WaitForChild("Controllers"):WaitForChild("Effects"):WaitForChild("KillEffectsConfig")),
    bufferutils = require(game:GetService("ReplicatedStorage"):FindFirstChild("Modules"):WaitForChild("Shared"):WaitForChild("BufferUtils")),
    characterreplicationconfig = require(game:GetService("ReplicatedStorage"):FindFirstChild("Modules"):WaitForChild("Configs"):WaitForChild("CharacterReplicationConfig")),
    adjustcharacterlimbs = require(game:GetService("ReplicatedStorage"):FindFirstChild("Modules"):WaitForChild("Misc"):FindFirstChild("AdjustCharacterLimbs")),
    characterreplicationcontroller = require(game:GetService("ReplicatedStorage"):FindFirstChild("Modules"):WaitForChild("Controllers"):WaitForChild("CharacterReplicationController")),
    uicontroller = require(game:GetService("ReplicatedStorage"):FindFirstChild("Modules"):WaitForChild("Controllers"):WaitForChild("UIController")),
    replaycontroller = require(game:GetService("ReplicatedStorage"):FindFirstChild("Modules"):WaitForChild("Controllers"):WaitForChild("MatchController"):WaitForChild("MatchReplay")),
    matchendscreen = require(game:GetService("ReplicatedStorage"):FindFirstChild("Modules"):WaitForChild("Controllers"):WaitForChild("MatchController"):WaitForChild("MatchEndScreen")),
    matchreplay = require(game:GetService("ReplicatedStorage"):FindFirstChild("Modules"):WaitForChild("Controllers"):WaitForChild("MatchController"):WaitForChild("MatchReplay")),
    uitoolbar = require(game:GetService("ReplicatedStorage"):FindFirstChild("Modules"):WaitForChild("Controllers"):WaitForChild("ToolController"):WaitForChild("UIToolbar")),
    replpos = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes"):WaitForChild("Character"):WaitForChild("CustomCharacterReplication"):WaitForChild("ReplPos"),
    globalmatchmakingconfig = require(game:GetService("ReplicatedStorage"):FindFirstChild("Modules"):WaitForChild("Configs"):WaitForChild("Misc"):WaitForChild("GlobalMatchmakingConfig")),
    globalmatchmakingcontroller = require(game:GetService("ReplicatedStorage"):FindFirstChild("Modules"):WaitForChild("Controllers"):WaitForChild("GlobalMatchmakingController")),
    networkshared = require(game:GetService("ReplicatedStorage"):FindFirstChild("Modules"):WaitForChild("Shared"):WaitForChild("NetworkShared")),
    miscremotelistener = require(game:GetService("ReplicatedStorage"):FindFirstChild("Modules"):WaitForChild("Controllers"):WaitForChild("MiscRemoteListener")),
    killeffectdefault = require(game:GetService("ReplicatedStorage"):FindFirstChild("Modules"):WaitForChild("Controllers"):WaitForChild("Effects"):WaitForChild("KillEffectsConfig"))._DEFAULT,
    loadcharacterviewport = debug.getupvalue(require(game:GetService("ReplicatedStorage"):FindFirstChild("Modules"):WaitForChild("Controllers"):WaitForChild("UIController")).SetupMatchPlayers, 4),
}

local ogfuncs = {
    ogspread = modules.crosshaircontroller.SetSpread,
    ogrecoil = modules.cameracontroller.Recoil,
    ogaim = modules.weaponcontroller.Aim,
    ogweaponequip = modules.weaponcontroller.Equip,
    ogmeleeequip = modules.meleecontroller.Equip,
    ogviewmodel = modules.viewmodelcontroller.new,
    ogrun = modules.charactercontroller.Run,
    ogfiringsound = modules.effects.GunFiringSound,
    ogbullet = modules.effects.VisualizeBullet,
    ogapply = modules.killeffectdefault.Apply,
    ogwriteunitv3 = modules.bufferutils.WriteUnitV3ToBuffer,
    ogwritecframesmall = modules.bufferutils.WriteCFrameToBufferSmall,
    ogwritecframe = modules.bufferutils.WriteCFrameToBuffer,
    ogfire = modules.weaponcontroller.Fire,
    ogtooladded = modules.toolcontroller.ToolAdded,
    ogfovtag = modules.cameracontroller.ChangeFOVWithTag,
    ogscope = modules.uicontroller.Scope,
}

local cons = {
    autofirecon = nil ,
    viewmodelgetcon = nil,
    viewmodelremovecon = nil,
    movementcon = nil,
    autoqueuecon = nil,
    thirdpersoncon = nil,
    staffdetectorcon = nil,
    teleportcon = nil,
    lightingcon = nil,
    knifebotcon = nil,
    lightingchildrencon = nil,
    getglasscon = nil,
    getcharactercon = nil,
    espcon = nil,
    antiaimcon = nil,
    nojumpcooldowncon = nil,
    aspectratiocon = nil,
    roundendcon = nil,
    roundstartcon = nil,
    knifekillcon = nil,
    cloudcon = nil,
}

local lightingtbl = {
    lightingoverride = false,
    bloomoverride = false,
    atmosphereoverride = false,
    colorcorrectionoverride = false,
    sunraysoverride = false,
    skyboxoverride = false,
    cloudsoverride = false,

    oldlighting = {
        Ambient = lighting.Ambient,
        OutdoorAmbient = lighting.OutdoorAmbient,
        Brightness = lighting.Brightness,
        ClockTime = lighting.ClockTime,
        FogColor = lighting.FogColor,
        FogStart = lighting.FogStart,
        FogEnd = lighting.FogEnd,
        GlobalShadows = lighting.GlobalShadows,
        ColorShift_Top = lighting.ColorShift_Top,
        ColorShift_Bottom = lighting.ColorShift_Bottom,
        EnvironmentDiffuseScale = lighting.EnvironmentDiffuseScale,
        EnvironmentSpecularScale = lighting.EnvironmentSpecularScale,
        ShadowSoftness = lighting.ShadowSoftness
    },

    oldclouds = {
        Cover = (game:GetService("Workspace"):WaitForChild("Terrain"):FindFirstChildOfClass("Clouds") and game:GetService("Workspace"):WaitForChild("Terrain"):FindFirstChildOfClass("Clouds").Cover),
        Density = (game:GetService("Workspace"):WaitForChild("Terrain"):FindFirstChildOfClass("Clouds") and game:GetService("Workspace"):WaitForChild("Terrain"):FindFirstChildOfClass("Clouds").Density),
        Color = (game:GetService("Workspace"):WaitForChild("Terrain"):FindFirstChildOfClass("Clouds") and game:GetService("Workspace"):WaitForChild("Terrain"):FindFirstChildOfClass("Clouds").Color),
        Enabled = (game:GetService("Workspace"):WaitForChild("Terrain"):FindFirstChildOfClass("Clouds") and game:GetService("Workspace"):WaitForChild("Terrain"):FindFirstChildOfClass("Clouds").Enabled)
    },

    oldskybox = {
        SkyboxBk = (lighting:FindFirstChildOfClass("Sky") and lighting:FindFirstChildOfClass("Sky").SkyboxBk) or "",
        SkyboxDn = (lighting:FindFirstChildOfClass("Sky") and lighting:FindFirstChildOfClass("Sky").SkyboxDn) or "",
        SkyboxFt = (lighting:FindFirstChildOfClass("Sky") and lighting:FindFirstChildOfClass("Sky").SkyboxFt) or "",
        SkyboxLf = (lighting:FindFirstChildOfClass("Sky") and lighting:FindFirstChildOfClass("Sky").SkyboxLf) or "",
        SkyboxRt = (lighting:FindFirstChildOfClass("Sky") and lighting:FindFirstChildOfClass("Sky").SkyboxRt) or "",
        SkyboxUp = (lighting:FindFirstChildOfClass("Sky") and lighting:FindFirstChildOfClass("Sky").SkyboxUp) or "",
        StarCount = (lighting:FindFirstChildOfClass("Sky") and lighting:FindFirstChildOfClass("Sky").StarCount) or 0,
        SunAngularSize = (lighting:FindFirstChildOfClass("Sky") and lighting:FindFirstChildOfClass("Sky").SunAngularSize) or 0,
        MoonAngularSize = (lighting:FindFirstChildOfClass("Sky") and lighting:FindFirstChildOfClass("Sky").MoonAngularSize) or 0,
        SunTextureId = (lighting:FindFirstChildOfClass("Sky") and lighting:FindFirstChildOfClass("Sky").SunTextureId) or "",
        MoonTextureId = (lighting:FindFirstChildOfClass("Sky") and lighting:FindFirstChildOfClass("Sky").MoonTextureId) or "",
        CelestialBodiesShown = (lighting:FindFirstChildOfClass("Sky") and lighting:FindFirstChildOfClass("Sky").CelestialBodiesShown) or false,
    },

    oldbloom = {
        Intensity = (lighting:FindFirstChildOfClass("BloomEffect") and lighting:FindFirstChildOfClass("BloomEffect").Intensity) or 0,
        Size = (lighting:FindFirstChildOfClass("BloomEffect") and lighting:FindFirstChildOfClass("BloomEffect").Size) or 0,
        Threshold = (lighting:FindFirstChildOfClass("BloomEffect") and lighting:FindFirstChildOfClass("BloomEffect").Threshold) or 0,
        Enabled = (lighting:FindFirstChildOfClass("BloomEffect") and lighting:FindFirstChildOfClass("BloomEffect").Enabled) or false,
    },

    oldatmosphere = {
        Density = (lighting:FindFirstChildOfClass("Atmosphere") and lighting:FindFirstChildOfClass("Atmosphere").Density) or 0,
        Offset = (lighting:FindFirstChildOfClass("Atmosphere") and lighting:FindFirstChildOfClass("Atmosphere").Offset) or 0,
        Color = (lighting:FindFirstChildOfClass("Atmosphere") and lighting:FindFirstChildOfClass("Atmosphere").Color) or Color3.new(0, 0, 0),
        Glare = (lighting:FindFirstChildOfClass("Atmosphere") and lighting:FindFirstChildOfClass("Atmosphere").Glare) or 0,
        Haze = (lighting:FindFirstChildOfClass("Atmosphere") and lighting:FindFirstChildOfClass("Atmosphere").Haze) or 0,
        Decay = (lighting:FindFirstChildOfClass("Atmosphere") and lighting:FindFirstChildOfClass("Atmosphere").Decay) or Color3.new(0, 0, 0),
    },

    oldcolorcorrection = {
        Brightness = (lighting:FindFirstChildOfClass("ColorCorrectionEffect") and lighting:FindFirstChildOfClass("ColorCorrectionEffect").Brightness) or 0,
        Contrast = (lighting:FindFirstChildOfClass("ColorCorrectionEffect") and lighting:FindFirstChildOfClass("ColorCorrectionEffect").Contrast) or 0,
        Saturation = (lighting:FindFirstChildOfClass("ColorCorrectionEffect") and lighting:FindFirstChildOfClass("ColorCorrectionEffect").Saturation) or 0,
        TintColor = (lighting:FindFirstChildOfClass("ColorCorrectionEffect") and lighting:FindFirstChildOfClass("ColorCorrectionEffect").TintColor) or Color3.new(0, 0, 0),
        Enabled = (lighting:FindFirstChildOfClass("ColorCorrectionEffect") and lighting:FindFirstChildOfClass("ColorCorrectionEffect").Enabled) or false,
    },

    oldsunrays = {
        Intensity = (lighting:FindFirstChildOfClass("SunRaysEffect") and lighting:FindFirstChildOfClass("SunRaysEffect").Intensity) or 0,
        Spread = (lighting:FindFirstChildOfClass("SunRaysEffect") and lighting:FindFirstChildOfClass("SunRaysEffect").Spread) or 0,
        Enabled = (lighting:FindFirstChildOfClass("SunRaysEffect") and lighting:FindFirstChildOfClass("SunRaysEffect").Enabled) or false,
    },
}

local highlighttbl = {
    teamhighlight = false,
    teamfillcolor = Color3.fromRGB(8, 170, 130),
    teamoutlinecolor = Color3.fromRGB(255, 255, 255),
    teamfilltransparency = 0.5,
    teamoutlinetransparency = 0.5,
    enemyhighlight = false,
    enemyfillcolor = Color3.fromRGB(167, 9, 9),
    enemyoutlinecolor = Color3.fromRGB(255, 255, 255),
    enemyfilltransparency = 0.5,
    enemyoutlinetransparency = 0.5,
}

local devicetbl = {   
    device = "Desktop",
    spoofplatform = false,
    ogplatform = localplayer and localplayer:GetAttribute("Platform"),
}

local oghitsounds = {
    headshot = game:GetService("SoundService"):FindFirstChild("Game"):WaitForChild("Local"):WaitForChild("Hitmarker"):WaitForChild("HeadshotKill").SoundId,
    hitsound = game:GetService("SoundService"):FindFirstChild("Game"):WaitForChild("Local"):WaitForChild("Hitmarker"):WaitForChild("Kill").SoundId,
    hitmarker = game:GetService("SoundService"):FindFirstChild("Game"):WaitForChild("Local"):WaitForChild("Hitmarker"):WaitForChild("Hitmarker").SoundId,
    headshotvolume = game:GetService("SoundService"):FindFirstChild("Game"):WaitForChild("Local"):WaitForChild("Hitmarker"):WaitForChild("HeadshotKill").Volume,
    hitsoundvolume = game:GetService("SoundService"):FindFirstChild("Game"):WaitForChild("Local"):WaitForChild("Hitmarker"):WaitForChild("Kill").Volume,
    hitmarkervolume = game:GetService("SoundService"):FindFirstChild("Game"):WaitForChild("Local"):WaitForChild("Hitmarker"):WaitForChild("Hitmarker").Volume,
}

local viewmodel = {
    currentviewmodel = camera:FindFirstChild("Viewmodel") or nil,

    override = false,
    fov = modules.settingsmain.Settings.FOV,
    viewmodelx = 0.1,
    viewmodely = -1.5,
    viewmodelz = 0.15,
    viewmodelroll = 0,
    armcolor = Color3.fromRGB(255,255,255),
    armtransparency = 0,
    armmaterial = Enum.Material.Plastic,
}

local misctbl = {
    autoreload = false,
    lastreload = 0,
    lastupdate = 0,
    executeamount = 0,
    firstpersoncframe = nil,
}

local highlights = Instance.new("Folder", gethui())

lightingtbl.newlighting = table.clone(lightingtbl.oldlighting)
lightingtbl.newclouds = table.clone(lightingtbl.oldclouds)
lightingtbl.newskybox = table.clone(lightingtbl.oldskybox)
lightingtbl.newbloom = table.clone(lightingtbl.oldbloom)
lightingtbl.newatmosphere = table.clone(lightingtbl.oldatmosphere)
lightingtbl.newcolorcorrection = table.clone(lightingtbl.oldcolorcorrection)
lightingtbl.newsunrays = table.clone(lightingtbl.oldsunrays)


local function updatehighlights()
    if not modules.matchcontroller.CurrentMatch then return end

    if modules.matchcontroller.CurrentMatch and modules.matchcontroller.CurrentMatch.Players then
        for _,p in modules.matchcontroller.CurrentMatch.Players do
            if p and p:IsA("Player") and p.Character and p ~= localplayer then
                local highlight = highlights:FindFirstChild(p.Name)

                if highlight and highlight.Adornee == nil then
                    highlight:Destroy()
                end

                if highlight and highlight.Adornee ~= nil then
                    if modules.matchcontroller:IsPlayerFriendly(p) then
                        highlight.FillColor = highlighttbl.teamfillcolor
                        highlight.OutlineColor = highlighttbl.teamoutlinecolor
                        highlight.FillTransparency = highlighttbl.teamfilltransparency
                        highlight.OutlineTransparency = highlighttbl.teamoutlinetransparency
                        highlight.Enabled = highlighttbl.teamhighlight
                    else
                        highlight.FillColor = highlighttbl.enemyfillcolor
                        highlight.OutlineColor = highlighttbl.enemyoutlinecolor
                        highlight.FillTransparency = highlighttbl.enemyfilltransparency
                        highlight.OutlineTransparency = highlighttbl.enemyoutlinetransparency
                        highlight.Enabled = highlighttbl.enemyhighlight
                    end
                end

                if not highlight then
                    highlight = Instance.new("Highlight", highlights)
                    highlight.Name = p.Name
                    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    highlight.Adornee = p.Character

                    if modules.matchcontroller:IsPlayerFriendly(p) then
                        highlight.FillColor = highlighttbl.teamfillcolor
                        highlight.OutlineColor = highlighttbl.teamoutlinecolor
                        highlight.FillTransparency = highlighttbl.teamfilltransparency
                        highlight.OutlineTransparency = highlighttbl.teamoutlinetransparency
                        highlight.Enabled = highlighttbl.teamhighlight
                    else
                        highlight.FillColor = highlighttbl.enemyfillcolor
                        highlight.OutlineColor = highlighttbl.enemyoutlinecolor
                        highlight.FillTransparency = highlighttbl.enemyfilltransparency
                        highlight.OutlineTransparency = highlighttbl.enemyoutlinetransparency
                        highlight.Enabled = highlighttbl.enemyhighlight
                    end
                end
            end
        end
    end
end

local function setplatform(platform)
    local buffer = modules.networkshared.Constants.Platforms[platform]
    local number = (platform == "Desktop" and 1) or (platform == "Mobile" and 2) or 3
    local emoji = modules.networkshared.Constants.PlatformEmojis[number].emoji

    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Other"):WaitForChild("GetPlatform").OnClientInvoke = function() return buffer end
    modules.miscremotelistener.GetPlatform = function() return buffer end -- ts lwk just making it return everyones device as spoofed one i think
    modules.settingsmain.GetPlatform = function() return platform end

    localplayer:SetAttribute("Platform", number)
end

local function valuecheck(property, a, b)
    if a == b then return true end

    if type(a) ~= type(b) then return false end

    if property == "ClockTime" and type(a) == "number" then
        local diff = math.abs(a - b) % 24

        return math.min(diff, 24 - diff) < 0.05
    elseif type(a) == "number" then
        return math.abs(a - b) < 1e-2
    elseif typeof(a) == "Color3" then
        return math.abs(a.R - b.R) < 1e-2 and math.abs(a.G - b.G) < 1e-2 and math.abs(a.B - b.B) < 1e-2
    end

    return false
end

do
    local meta = getrawmetatable(modules.skinconfig)
    debug.setupvalue(debug.getupvalue(getrawmetatable(modules.skinconfig).__index, 1), 1, true)
end

do
    local hitchance = 75
    local silentaim = false
    local silentmode = "mouse"
    local fov = 30
    local maxdistance = 2500
    local order = {}
    local autofiredelay = 150
    local autofirescanrate = 1 / 60
    local lastautofirescan = 0
    local targetacquiredtime = nil
    local lasttarget = nil

    local fakeAnim = {
        Play = function() end,
        Stop = function() end,
    }

    local blacklist = {localplayer.Character}
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude

    for _,v in game:GetService("CollectionService"):GetTagged("Glass") do
        table.insert(blacklist, v)
    end

    params.FilterDescendantsInstances = blacklist

    local verticies = {
        ["Head"] = {{0, 0, 0}, {0, 0.85, 0}, {-0.85, 0, 0}, {0.85, 0, 0}},
        ["Left Arm"] = {{0, 0.6, 0}, {-0.8, 0, 0}, {0.8, 0, 0}, {0, -0.6, 0}},
        ["Right Arm"] = {{0, 0.6, 0}, {0.8, 0, 0}, {-0.8, 0, 0}, {0, -0.6, 0}},
        ["Torso"] = {{0, 0.6, 0}, {0, 0, 0}, {-0.7, 0, 0}, {0.7, 0, 0}, {0, -0.6, 0}},
        ["Left Leg"] = {{0, 0.6, 0}, {-0.8, 0, 0}, {0.8, 0, 0}, {0, -0.6, 0}},
        ["Right Leg"] = {{0, 0.6, 0}, {0.8, 0, 0}, {-0.8, 0, 0}, {0, -0.6, 0}},
    }

    cons.getglasscon = game:GetService("CollectionService"):GetInstanceAddedSignal("Glass"):Connect(function()
        if not modules.matchcontroller.CurrentMatch then return end
        if not localplayer.Character then return end

        table.clear(blacklist)
        table.insert(blacklist, localplayer.Character)

        for _,v in game:GetService("CollectionService"):GetTagged("Glass") do
            table.insert(blacklist, v)
        end

        params.FilterDescendantsInstances = blacklist
    end)

    cons.getcharactercon = localplayer.CharacterAdded:Connect(function(v)
        if table.find(blacklist, v) then 
            table.remove(blacklist, table.find(blacklist, v))
        end

        table.insert(blacklist, v)

        params.FilterDescendantsInstances = blacklist
    end)

    local function getverticies(character)
        if not character then return nil end

        local cameracframe = misctbl.firstpersoncframe or camera.CFrame
        local origin = cameracframe.Position

        for _, p in order do
            local part = character:FindFirstChild(p)
            if not part then continue end

            local half = part.Size * 0.5
            local partverticies = verticies[part.Name]
            if not partverticies then return nil end

            local sx = half.X * 0.92
            local sy = half.Y * 0.92
            local sz = half.Z * 0.92

            for _, v in partverticies do
                local pos = Vector3.new(v[1] * sx, v[2] * sy, v[3] * sz)
                local hitpos = part.CFrame * pos
                local direction = hitpos - origin
                local result = workspace:Raycast(origin, direction.Unit * (direction.Magnitude + 2), params)

                if result and result.Instance and result.Instance:IsDescendantOf(character) then
                    return hitpos, origin
                end
            end
        end
        return nil, nil
    end

    local function fireweapon(config, hitpos, origin)
        if config and hitpos and origin and math.random(1, 100) <= hitchance then
            local ogcframe = misctbl.firstpersoncframe or camera.CFrame

            camera.CFrame = CFrame.new(origin, hitpos)

            local result = ogfuncs.ogfire(config)

            camera.CFrame = ogcframe

            return result
        end

        return ogfuncs.ogfire(config)
    end

    local function reloadweapon(config)
        if misctbl.autoreload and os.clock() - misctbl.lastreload >= 3 then 
            misctbl.lastreload = os.clock()

            local fakeself = table.clone(config)
            fakeself.LastFire = 0
            fakeself.Aiming = false
            fakeself.CurAmmo = 0
            fakeself.Firing = false
            fakeself.SprintAnimation = function() end

            fakeself.Animations = {}
            for i in config.Animations do
                fakeself.Animations[i] = fakeAnim
            end

            task.spawn(function()
                modules.weaponcontroller.Reload(fakeself)
            end)
        end
    end

    local function getgunconfig(tool)
		if not tool then return nil end

		if modules.toolcontroller and modules.toolcontroller.ToolMaids then
			local maid = modules.toolcontroller.ToolMaids[tool]
			if maid and maid.Tasks then
				for _,v in maid.Tasks do
					if type(v) == "table" and v.weaponTool == tool and v.Config then
						return v
					end
				end
			end
		end
		return nil
	end

    local function getbestenemy()
        if not localplayer.Character then return end
        if not modules.matchcontroller.CurrentMatch then return end

        local bestenemy = nil
        local bestdistance = math.huge
        local besthit = nil
        local bestorigin = nil

        local match = modules.matchcontroller.CurrentMatch
        local fovdistance = (camera.ViewportSize.Magnitude / 2) * (fov / 180)
        local mouseposition = game:GetService("UserInputService"):GetMouseLocation()
        local selfroot = localplayer and localplayer.Character and localplayer.Character:FindFirstChild("HumanoidRootPart")

        for _,p in match.Players do
            if p:IsA("Player") and p ~= localplayer then
                if modules.matchcontroller:IsPlayerFriendly(p) then continue end
                if p and p.Character and p.Character:FindFirstChildOfClass("ForceField") then continue end

                local root = p and p.Character and p.Character:FindFirstChild("HumanoidRootPart")
                local hum = p and p.Character and p.Character:FindFirstChildOfClass("Humanoid")

                if not root then continue end
                if not hum then continue end
                if hum and hum:GetState() == Enum.HumanoidStateType.Dead or hum and hum:HasTag("Dead") then continue end

                if root and hum then 
                    if silentmode == "mouse" then
                        local screenpos, screen = camera:WorldToViewportPoint(root.Position)

                        if screen then
                            local distance = (Vector2.new(screenpos.X, screenpos.Y) - mouseposition).Magnitude
                            local visiblepos, neworigin = getverticies(p.Character)

                            if not visiblepos then continue end

                            if distance <= fovdistance and distance < bestdistance then
                                bestdistance = distance
                                bestenemy = p.Character
                                besthit = visiblepos
                                bestorigin = neworigin
                            end
                        end
                    end

                    if silentmode == "position" then
                        local distance = (root.Position - selfroot.Position).Magnitude
                        local visiblepos, neworigin = getverticies(p.Character)

                        if not visiblepos then continue end

                        if maxdistance == 0 and distance < bestdistance then
                            bestdistance = distance
                            bestenemy = p.Character
                            bestenemy = p.Character
                            besthit = visiblepos
                            bestorigin = neworigin
                        end

                        if distance <= maxdistance and distance < bestdistance then
                            bestdistance = distance
                            bestenemy = p.Character
                            besthit = visiblepos
                            bestorigin = neworigin
                        end
                    end
                end
            end
        end
        return besthit, bestenemy, bestorigin
    end

    modules.weaponcontroller.Fire = function(self, ...)
        if silentaim and misctbl.autoreload then
            local hitpos, enemy, neworigin = getbestenemy()

            if hitpos and enemy and neworigin then
                task.spawn(function()
                    reloadweapon(self)
                end)
                return fireweapon(self, hitpos, neworigin)
            end

            reloadweapon(self)
            return ogfuncs.ogfire(self, ...)
        end

        if silentaim then
            local hitpos, enemy, neworigin = getbestenemy()

            if hitpos and enemy and neworigin then
                return fireweapon(self, hitpos, neworigin)
            end

            return ogfuncs.ogfire(self, ...)
        end

        if misctbl.autoreload then
            reloadweapon(self)
        end

        return ogfuncs.ogfire(self, ...)
    end

    main:AddToggle("silentaim", {
        Text = "silentaim",
        Tooltip = "redirects your bullet to the enemy",
        Default = silentaim, 
        Callback = function(v)
            silentaim = v
        end
    }):AddKeyPicker('silentaimkeybind',{
		Text = "silentaim",
		SyncToggleState = true,
		Default = "None",
		Mode = "Toggle",
		NoUI = false,
	})

    main:AddToggle("autofire", {
        Text = "autofire",
        Tooltip = "automatically fires when a enemy is visible",
        Default = false, 
        Callback = function(v)
            library.Options.autofiredelay:SetVisible(v)
            library.Options.autofirescanrate:SetVisible(v)

            if v then
                cons.autofirecon = runserv.Heartbeat:Connect(function()
                    if not silentaim then return end

                    if os.clock() - lastautofirescan < autofirescanrate then return end
                    lastautofirescan = os.clock()

                    local char = localplayer and localplayer.Character
                    local tool = char and char:FindFirstChildOfClass("Tool")

                    if not (tool and tool:HasTag("Gun")) then
                        lasttarget = nil
                        targetacquiredtime = nil
                        return 
                    end

                    local config = getgunconfig(tool)
                    if not config or config.CurAmmo <= 0 then return end
                    if config.CheckCanFire and not config:CheckCanFire() then return end

                    if (os.clock()- config.LastFire + - 0.44) < 0.8 then return end -- idk what the fuck this is bro albert and einstein type shit

                    local hitpos, enemy, shiftedorigin = getbestenemy()

                    if not hitpos or not enemy then
                        lasttarget = nil
                        targetacquiredtime = nil
                        return
                    end

                    if enemy ~= lasttarget or not targetacquiredtime then
                        lasttarget = enemy
                        targetacquiredtime = os.clock()
                    end

                    if autofiredelay > 0 and (os.clock() - targetacquiredtime) < (autofiredelay / 1000) then return end

                    config.LastFire = os.clock()

                    fireweapon(config, hitpos, shiftedorigin)
                    reloadweapon(config)
                end)
            else
                if cons.autofirecon then
                    cons.autofirecon:Disconnect()
                    cons.autofirecon = nil
                end
            end
        end
    }):AddKeyPicker('autofirekeybind',{
		Text = "autofire",
		SyncToggleState = true,
		Default = "None",
		Mode = "Toggle",
		NoUI = false,
	})

    main:AddDropdown('hitbox',{
		Values = {"head", "chest", "arms", "legs"},
		Default = {"head", "chest", "arms", "legs"},
		Multi = true,
		Text = "hitboxes",
        Tooltip = "the part which silentaim will redirect to if visible",
		Callback = function(t) 
            table.clear(order)

            if t.head then 
                table.insert(order, "Head")
            end

            if t.arms then
                table.insert(order, "Left Arm")
                table.insert(order, "Right Arm")
            end

            if t.chest then
                table.insert(order, "Torso")
                table.insert(order, "HumanoidRootPart")
            end

            if t.legs then
                table.insert(order, "Left Leg")
                table.insert(order, "Right Leg")
            end
		end
	})

    main:AddDropdown('silenttype',{
		Values = {"mouse", "position"},
		Default = silentmode,
		Multi = false,
		Text = "silent type",
        Tooltip = "mouse gets closest to your mouse, position gets closest around you (ignores fov)",
		Callback = function(v)  
            silentmode = v

            if v == 'mouse' then
                library.Options.silentfov:SetVisible(true)
                library.Options.silentdistance:SetVisible(false)
            else
                library.Options.silentfov:SetVisible(false)
                library.Options.silentdistance:SetVisible(true)
            end
		end
	})

    main:AddSlider('hitchance',{
        Min = 1,
        Max = 100,
        Rounding = 0,
        Default = hitchance,
        Compact = true,
        Text = "hit chance",
        Suffix = "%",
        Visible = true,
        Tooltip = "the chance of silent redirecting",
        Callback = function(v) 
            hitchance = v
        end
    })

    main:AddSlider('autofiredelay',{
        Min = 0,
        Max = 1000,
        Rounding = 0,
        Default = autofiredelay,
        Compact = true,
        Text = "auto fire delay",
        Suffix = "ms",
        Visible = true,
        Tooltip = "time autofire waits before firing",
        Callback = function(v) 
            autofiredelay = v
        end
    })

    main:AddSlider('silentdistance',{
        Min = 0,
        Max = 10000,
        Rounding = 0,
        Default = maxdistance,
        Compact = true,
        Text = "silent distance",
        Suffix = " studs",
        Visible = false,
        Tooltip = "maxmium distance that silent will redirect at (0 means silent will redirect no matter the distance)",
        Callback = function(v) 
            maxdistance = v
        end
    })

    main:AddSlider('silentfov',{
        Min = 1,
        Max = 180,
        Rounding = 0,
        Default = fov,
        Compact = true,
        Text = "silent fov",
        Suffix = "°",
        Visible = true,
        Tooltip = "the fov that silentaim will use to redirect",
        Callback = function(v) 
            fov = v
        end
    })

    main:AddSlider('autofirescanrate',{
        Min = 30,
        Max = 240,
        Rounding = 0,
        Default = 60,
        Compact = true,
        Text = "scan rate",
        Suffix = "hz",
        Visible = false,
        Tooltip = "hz limit to autofires scanning",
        Callback = function(v) 
            autofirescanrate = 1 / v
        end
    })
end

do
    main:AddDivider("knifebot")
    
    local swing = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes"):WaitForChild("Weapons"):WaitForChild("Melee"):WaitForChild("Swing")
    local lastswing = 0
    local maxdistance = 5
    local spawncframe = nil
    local knifekillall = false
    local knifebot = false
    local lastequip = 0

    local killparts = {
        kill = true,
        death = true,
        void = true,
        lava = true,
        damage = true,
        destroy = true,
        hazard = true,
        outofbound = true,
        barrier = true
    }

    local killbarrierparms = OverlapParams.new()
    killbarrierparms.FilterType = Enum.RaycastFilterType.Exclude

    local function getspawncframe()
        spawncframe = nil

        local match = modules.matchcontroller.CurrentMatch
        
        if not match then return end
        if match and match.CurRoundCnt == 1 then return end

        if localplayer and localplayer.Character then
            local root = localplayer.Character and localplayer.Character:FindFirstChild("HumanoidRootPart") 

            if root and root.CFrame then
                spawncframe = root.CFrame
            end
        end
    end

    local function teleporttospawn()
        if not spawncframe then return end

        if localplayer and localplayer.Character then
            local root = localplayer.Character and localplayer.Character:FindFirstChild("HumanoidRootPart") 

            if root and root.CFrame and spawncframe then
                root.CFrame = spawncframe
            end
        end
    end

    local function safespot(pos, self, character)
        if pos.Y < workspace.FallenPartsDestroyHeight + 6 then
            return false
        end

        killbarrierparms.FilterDescendantsInstances = {self, character}

        local hits = workspace:GetPartBoundsInBox(CFrame.new(pos), Vector3.new(4, 7, 4), killbarrierparms)

        for _,p in hits do
            if p:IsA("BasePart") and killparts[string.lower(p.Name)] then
                return false
            end
        end
        return true
    end

    local function findsafespot(root, self, character)
        local belowpos = root.Position + Vector3.new(0, -10.25, 0)

        if safespot(belowpos, self, character) then
            return belowpos
        end

        local right = root.CFrame.RightVector * 10.25
        local ahead = root.CFrame.LookVector * 10.25
        local spots = {right, -right, -ahead, ahead, Vector3.new(0, 10.25, 0)}

        for _,v in spots do
            local spot = root.Position + v
            if safespot(spot, self, character) then
                return spot
            end
        end

        return nil
    end

    local function teleport(root)
        if not localplayer.Character then return end
        local selfroot = localplayer.Character and localplayer.Character:FindFirstChild("HumanoidRootPart")
        if not selfroot or not root or not root.Parent then return end

        local safepos = findsafespot(root, localplayer.Character, root.Parent)
        if not safepos then return end

        selfroot.CFrame = CFrame.lookAt(safepos, root.Position)
    end

    local function equipknife()
        if not localplayer.Character then return end

        local hum = localplayer and localplayer.Character and localplayer.Character:FindFirstChildOfClass("Humanoid")
        local backpack = localplayer:FindFirstChildOfClass("Backpack")
        if not (localplayer.Character and hum and backpack) then return end

        local held = localplayer.Character:FindFirstChildOfClass("Tool")
        if held and held:HasTag("Melee") then
            return held
        end

        for _, t in backpack:GetChildren() do
            if t:IsA("Tool") and t:HasTag("Melee") then
                local toolbar = modules.uitoolbar and modules.uitoolbar.currentToolbar
                if toolbar then
                    if held then
                        toolbar:ToolUnequipped(held)
                    end
                    toolbar:ToolEquipped(t)
                end

                hum:EquipTool(t)
                return t
            end
        end
    end

    cons.roundendcon = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes"):WaitForChild("Match").RoundConcluded.OnClientEvent:Connect(function()
        if not knifekillall or not knifebot then return end
        if not modules.matchcontroller.CurrentMatch then return end
        if modules.matchcontroller.CurrentMatch.CurRoundCnt == 1 then return end
        teleporttospawn()
    end)

    cons.roundstartcon = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes"):WaitForChild("Match").NewRound.OnClientEvent:Connect(function(v1, v2, spawnpos)
        if spawnpos then
            spawncframe = CFrame.new(spawnpos)
        end

        if not knifekillall or not knifebot then return end
        if not modules.matchcontroller.CurrentMatch then return end
        if modules.matchcontroller.CurrentMatch.CurRoundCnt == 1 then return end

        equipknife()
    end)

    main:AddToggle('knifebot',{
        Default = false,
        Text = "knifebot",
        Tooltip = "attempts to knife nearby enemies when knife is equipped",
        Callback = function(v)
            library.Options.knifebotdistance:SetVisible(v)
            knifebot = v

            if v then
                cons.knifebotcon = runserv.Heartbeat:Connect(function()
                    if not localplayer.Character then return end
                    if not modules.matchcontroller.CurrentMatch then return end

                    local selfroot = localplayer and localplayer.Character and localplayer.Character:FindFirstChild("HumanoidRootPart")
                    local tool = localplayer.Character:FindFirstChildOfClass("Tool")

                    if not selfroot then return end
                    if not tool:HasTag("Melee") then return end

                    if modules.matchcontroller.CurrentMatch and modules.matchcontroller.CurrentMatch.Players then
                        for _,v in modules.matchcontroller.CurrentMatch.Players do
                            if not modules.matchcontroller:IsPlayerFriendly(v) and v ~= localplayer then 
                                if not v.Character then continue end

                                local root = v and v.Character and v.Character:FindFirstChild("HumanoidRootPart")
                                local hum = v and v.Character and v.Character:FindFirstChildOfClass("Humanoid")

                                if not root or not hum then continue end
                                if hum and hum:GetState() == Enum.HumanoidStateType.Dead or hum and hum:HasTag("Dead") then continue end

                                if (root.Position - selfroot.Position).Magnitude <= maxdistance then
                                    if os.clock() - lastswing >= 0.5 then
                                        lastswing = os.clock()
                                        swing:FireServer(workspace:GetServerTimeNow(), hum, buffer.fromstring("\x01"))
                                    end
                                end
                            end
                        end
                    end
                end)
            else
                if cons.knifebotcon then
                    cons.knifebotcon:Disconnect()
                    cons.knifebotcon = nil
                end
            end
        end
    }):AddKeyPicker('knifebotkeybind',{
		Text = "knifebot",
		SyncToggleState = true,
		Default = "None",
		Mode = "Toggle",
		NoUI = false,
	})

    main:AddToggle('knifekillall',{
        Default = false,
        Text = "knife kill all",
        Tooltip = "automatically teleports to enemy spawn on round start and knifes them",
        Callback = function(v)
            knifekillall = v

            if v then
                getspawncframe()

                cons.knifekillcon = runserv.Heartbeat:Connect(function()
                    if not localplayer.Character then return end
                    if not modules.matchcontroller.CurrentMatch then return end
                    if modules.matchcontroller.CurrentMatch.CurRoundCnt == 1 then return end

                    local selfroot = localplayer and localplayer.Character and localplayer.Character:FindFirstChild("HumanoidRootPart")

                    if not selfroot then return end

                    if modules.matchcontroller.CurrentMatch and modules.matchcontroller.CurrentMatch.Players then
                        for _,v in modules.matchcontroller.CurrentMatch.Players do
                            if not modules.matchcontroller:IsPlayerFriendly(v) and v ~= localplayer then 
                                if not v.Character then continue end

                                local root = v and v.Character and v.Character:FindFirstChild("HumanoidRootPart")
                                local hum = v and v.Character and v.Character:FindFirstChildOfClass("Humanoid")

                                if not root or not hum then continue end
                                if hum and hum:GetState() == Enum.HumanoidStateType.Dead or hum and hum:HasTag("Dead") then continue end

                                if os.clock() - lastequip >= 0.25 then
                                    lastequip = os.clock()
                                    equipknife()
                                end

                                teleport(root)
                            end
                        end
                    end
                end)
            else
                if cons.knifekillcon then
                    cons.knifekillcon:Disconnect()
                    cons.knifekillcon = nil
                end

                teleporttospawn()
            end
        end
    }):AddKeyPicker('knifekillallkeybind',{
		Text = "knife kill all",
		SyncToggleState = true,
		Default = "None",
		Mode = "Toggle",
		NoUI = false,
	})


    main:AddSlider('knifebotdistance',{
        Min = 0.1,
        Max = 11,
        Rounding = 1,
        Default = maxdistance,
        Compact = true,
        Text = "distance",
        Suffix = " studs",
        Visible = false,
        Tooltip = "maxmium distance that knifebot will knife a target from",
        Callback = function(v) 
            maxdistance = v
        end
    })

    main:AddDivider("other")
end

do
    local movement = {
        nojumpcooldown = false,
        speed = 18,
        autohop = false,
        autohopon = false,
        velocitymovement = false,
    }

    modules.charactercontroller.Run = function(self, ...)
        local character = self and self.Character
        local hum = character and character:FindFirstChildOfClass("Humanoid")

        if hum then
            if cons.nojumpcooldowncon then
                cons.nojumpcooldowncon:Disconnect()
                cons.nojumpcooldowncon = nil
            end

            cons.nojumpcooldowncon = hum:GetPropertyChangedSignal("JumpPower"):Connect(function()
                if movement.nojumpcooldown and hum.JumpPower < 35.41699981689453 then
                    hum.JumpPower = 35.41699981689453
                end
            end)
        end

        return ogfuncs.ogrun(self, ...)
    end

    other:AddToggle('movement',{
        Default = false,
        Text = "enabled",
        Tooltip = "enables cframe movement",
        Callback = function(v) 
            if v then
                cons.movementcon = runserv.PreRender:Connect(function(dt)
                    if localplayer and localplayer.Character then
                        local hum = localplayer and localplayer.Character and localplayer.Character:FindFirstChildOfClass("Humanoid")
                        local root = localplayer and localplayer.Character and localplayer.Character:FindFirstChild("HumanoidRootPart")

                        if hum and root then
                            if movement.velocitymovement then
                                root.Velocity = Vector3.new(hum.MoveDirection.X * movement.speed, root.Velocity.Y, hum.MoveDirection.Z * movement.speed)
                            else
                                root.Velocity = Vector3.new(0, root.Velocity.Y, 0)
                                root.CFrame += (hum.MoveDirection * (movement.speed / (1 / dt)))
                            end
                            hum.Jump = (movement.autohopon and movement.autohop) or hum.Jump
                        end
                    end
                end)
            else
                if cons.movementcon then
                    cons.movementcon:Disconnect()
                    cons.movementcon = nil
                end
            end
        end
    }):AddKeyPicker('movementkeybind',{
        Text = "movement",
        SyncToggleState = true,
        Default = "None",
        Mode = "Toggle",
        NoUI = false,
    })

    other:AddSlider('movementspeed',{
        Min = 0,
        Max = 65,
        Rounding = 0,
        Default = 18,
        Compact = true,
        Text = "speed",
        Tooltip = "speed at which cframe movement will move at",
        Callback = function(v) 
            movement.speed = v
        end
    })

    other:AddToggle('velocitymovement',{
        Default = false,
        Text = "velocity",
        Tooltip = "makes cframe movement use velocity instead of directly setting the cframe",
        Callback = function(v) 
            movement.velocitymovement = v 
        end
    })

    other:AddToggle('nojumpcooldown',{
        Default = false,
        Text = "no jump cooldown",
        Tooltip = "removes the cooldown between jumps in matches",
        Callback = function(v) 
            movement.nojumpcooldown = v 
        end
    })

    other:AddToggle('autojump',{
        Default = false,
        Text = "auto jump",
        Tooltip = "automatically makes your character jump (right-click to make it toggle/hold to make it mimic auto-bhop)",
        Callback = function(v) 
            movement.autohopon = v
            movement.autohop = v
        end
    }):AddKeyPicker('autojumpkeybind',{
        Text = "auto bhop",
        SyncToggleState = true,
        Default = "None",
        Mode = "Toggle",
        NoUI = false,
    })
end

do
    other:AddDivider("antiaim")

    local yaw = 180
    local pitch = -90
    local spinspeed = 25
    local antiaim = false
    local packetid = -1
    local lastcframe = nil
    local lastsend = 0
    local lastlookvector = nil

    modules.bufferutils.WriteUnitV3ToBuffer = function(v1, v2, lookvector)
        if antiaim and lastlookvector then
            lookvector = lastlookvector
        end
        return ogfuncs.ogwriteunitv3(v1, v2, lookvector)
    end

    modules.bufferutils.WriteCFrameToBufferSmall = function(v1, v2, cframe)
        if antiaim then
            cframe = lastcframe
        end

        return ogfuncs.ogwritecframesmall(v1, v2, cframe)
    end

    modules.bufferutils.WriteCFrameToBuffer = function(v1, v2, cframe)
        if antiaim then
            cframe = lastcframe
        end

        return ogfuncs.ogwritecframe(v1, v2, cframe)
    end

    local function buildPacket(cframe, lookvector)
        local errorsmoothing = modules.characterreplicationconfig.errorSmoothing.enabled
        local yawonly = modules.characterreplicationconfig.sent_cframes_yaw_only
        local buff = buffer.create(4 + (errorsmoothing and 1 or 0) + (yawonly and 11 or 15) + 6)
        local pos = 0

        buffer.writef32(buff, pos, os.clock()); pos += 4

        if errorsmoothing then
            packetid = (packetid > 255 and -1 or packetid) + 1
            buffer.writeu8(buff, pos, packetid); pos += 1
        end

        if yawonly then
            modules.bufferutils.WriteCFrameToBufferSmall(buff, pos, cframe); pos += 11
        else
            modules.bufferutils.WriteCFrameToBuffer(buff, pos, cframe); pos += 15
        end
        modules.bufferutils.WriteUnitV3ToBuffer(buff, pos, lookvector)

        return buff
    end

    other:AddToggle('antiaim',{
        Default = false,
        Text = "enabled",
        ToolTip = "this is just for cosmetic effect, you can still easily be killed",
        Callback = function(v)
            antiaim = v

            if v then
                cons.antiaimcon = runserv.RenderStepped:Connect(function()
                    if not localplayer and localplayer.Character then return end

                    if modules.characterreplicationcontroller.SendingPackets then
                        modules.characterreplicationcontroller:StopSending()
                    end

                    local root = localplayer.Character and localplayer.Character:FindFirstChild("HumanoidRootPart")
                    local hum = localplayer.Character and localplayer.Character:FindFirstChild("Humanoid")
                    if not root or not hum then return end

                    local lookvector = (misctbl.firstpersoncframe and misctbl.firstpersoncframe.LookVector) or camera.CFrame.LookVector

                    local spoofedcframe
                    local horizontal

                    if yaw == "spin" then
                        root.AssemblyAngularVelocity = Vector3.new(0, math.rad(spinspeed), 0)
                        spoofedcframe = root.CFrame
                        horizontal = Vector3.new(spoofedcframe.LookVector.X, 0, spoofedcframe.LookVector.Z)
                    else
                        local yawed = CFrame.fromAxisAngle(Vector3.yAxis, math.rad(yaw)) * lookvector
                        horizontal = Vector3.new(yawed.X, 0, yawed.Z)
                        spoofedcframe = CFrame.new(root.Position) * CFrame.lookAt(Vector3.zero, horizontal).Rotation
                    end

                    local spoofedlookvector = (horizontal + Vector3.new(0, pitch, 0)).Unit
                    lastlookvector = spoofedlookvector
                    lastcframe = spoofedcframe

                    if os.clock() - lastsend >= modules.characterreplicationconfig.tickrate then -- if you send packets at a rate above 32hz it bricks replication fully
                        lastsend = os.clock()
                        modules.replpos:FireServer(buildPacket(spoofedcframe, spoofedlookvector))
                    end

                    if misctbl.firstpersoncframe then
                        localplayer.Character:SetAttribute("cv_lv", spoofedlookvector)

                        pcall(function()
                            modules.adjustcharacterlimbs(localplayer.Character, spoofedlookvector, false, false, false)
                        end)

                        hum.AutoRotate = false

                        if yaw ~= "spin" then
                            root.CFrame = spoofedcframe
                        end
                    else
                        local flatlook = Vector3.new(lookvector.X, 0, lookvector.Z).Unit
                        localplayer.Character:SetAttribute("cv_lv", flatlook)

                        pcall(function()
                            modules.adjustcharacterlimbs(localplayer.Character, flatlook, false, false, false)
                            modules.adjustcharacterlimbs(localplayer.Character, flatlook, false, true, false)
                        end)

                        if yaw == "spin" then
                            hum.AutoRotate = false
                        else
                            hum.AutoRotate = true
                            root.CFrame = CFrame.new(root.Position) * CFrame.lookAt(Vector3.zero, flatlook).Rotation
                        end
                    end
                end)
            else
                if cons.antiaimcon then
                    cons.antiaimcon:Disconnect()
                    cons.antiaimcon = nil
                end

                if localplayer and localplayer.Character then
                    local root = localplayer and localplayer.Character and localplayer.Character:FindFirstChild("HumanoidRootPart")
                    local hum = localplayer and localplayer.Character and localplayer.Character:FindFirstChildOfClass("Humanoid")

                    if not hum or not root then return end

                    local lookvector = (misctbl.firstpersoncframe and misctbl.firstpersoncframe.LookVector) or camera.CFrame.LookVector

                    root.AssemblyAngularVelocity = Vector3.zero

                    hum.AutoRotate = true

                    localplayer.Character:SetAttribute("cv_lv", nil)

                    pcall(function()
                        modules.adjustcharacterlimbs(localplayer.Character, Vector3.new(lookvector.X, 0, lookvector.Z), false, false, false)
                        modules.adjustcharacterlimbs(localplayer.Character, Vector3.new(lookvector.X, 0, lookvector.Z), false, true, false)
                    end)

                    lastcframe = nil

                    local resetcframe = CFrame.new(root.Position) * CFrame.lookAt(Vector3.zero, Vector3.new(lookvector.X, 0, lookvector.Z)).Rotation
                    modules.replpos:FireServer(buildPacket(resetcframe, Vector3.new(lookvector.X, 0, lookvector.Z)))

                    task.spawn(function()
                        modules.characterreplicationcontroller:StartSending(localplayer.Character)
                    end)
                end
            end
        end
    }):AddKeyPicker('antiaimkeybind',{
        Text = "antiaim",
        SyncToggleState = true,
        Default = "None",
        Mode = "Toggle",
        NoUI = false,
    })

    other:AddDropdown('antiaimpitch',{
		Values = {"up", "down", "forward"},
		Default = {"down"},
		Multi = false,
		Text = "pitch",
        Tooltip = "pitch that the antiaim will use",
		Callback = function(v) 
            if v == "up" then
                pitch = 90
            elseif v == "down" then
                pitch = -90
            elseif v == "forward" then
                pitch = 0
            end
		end
	})

    other:AddDropdown('antiaimyaw',{
		Values = {"left", "right", "forward", "backward", "spin"},
		Default = {"backward"},
		Multi = false,
		Text = "yaw",
        Tooltip = "yaw that the antiaim will use",
		Callback = function(v) 
            if v == "left" then
                yaw = -90
                library.Options.spinspeed:SetVisible(false)
            elseif v == "right" then
                yaw = 90
                library.Options.spinspeed:SetVisible(false)
            elseif v == "forward" then
                yaw = 0
                library.Options.spinspeed:SetVisible(false)
            elseif v == "backward" then
                yaw = 180
                library.Options.spinspeed:SetVisible(false)
            elseif v == "spin" then
                yaw = "spin"
                library.Options.spinspeed:SetVisible(true)
            end
		end
	})

    other:AddSlider('spinspeed',{
        ToolTip = "speed that spin yaw will spin at",
        Min = 0,
        Max = 7200,
        Rounding = 0,
        Default = spinspeed,
        Compact = true,
        Text = "spin speed",
        Visible = false,
        Callback = function(v) 
            spinspeed = v
        end
    })
end

do
    local instantscope = false
    local instantequip = false
    local norecoil = false
    local nospread = false
    local removescope = false

    modules.crosshaircontroller.SetSpread = function(self, v)
        if nospread then
            return ogfuncs.ogspread(self, 0)
        end
        return ogfuncs.ogspread(self, v)
    end

    main:AddToggle('nospread',{
        Default = false,
        Text = "no spread",
        Tooltip = "removes bullet spread when firing",
        Callback = function(v)
        nospread = v
        end
    })

    modules.cameracontroller.Recoil = function(self)
        if norecoil then return end
        return ogfuncs.ogrecoil(self)
    end


    main:AddToggle('norecoil',{
        Default = false,
        Text = "no recoil",
        Tooltip = "removes recoil when firing",
        Callback = function(v)
            norecoil = v
        end
    })

    modules.uicontroller.Scope = function(self, v2)
        if removescope and v2 then
            return
        end

        return ogfuncs.ogscope(self, v2)
    end

    main:AddToggle('removescope',{
        Default = false,
        Text = "no scope",
        Tooltip = "removes scope ui when aiming",
        Callback = function(v)
            removescope = v
        end
    })

    modules.weaponcontroller.Equip = function(self)
        if instantequip then
            local ogtime = self.Config.EquipTime
            self.Config.EquipTime = 0
            local result = ogfuncs.ogweaponequip(self)
            self.Config.EquipTime = ogtime
            return result
        end
        return ogfuncs.ogweaponequip(self)
    end

    modules.meleecontroller.Equip = function(self)
        if instantequip then
            local ogtime = self.Config.EquipTime
            self.Config.EquipTime = 0
            local result = ogfuncs.ogmeleeequip(self)
            self.Config.EquipTime = ogtime
            return result
        end
        return ogfuncs.ogmeleeequip(self)
    end

    main:AddToggle('instantequip',{
        Default = false,
        Text = "instant equip",
        Tooltip = "lets you equip and use the weapon instantly without delay",
        Callback = function(v)
            instantequip = v
        end
    })

    modules.cameracontroller.ChangeFOVWithTag = function(self, tag, v3, v4)
        if instantscope and string.find(tag, "Aim") then
            v4 = nil
        end

        return ogfuncs.ogfovtag(self, tag, v3, v4)
    end

    modules.weaponcontroller.Aim = function(self, state)
        if instantscope and state then
            local ogtime = self.Config.AimIn and self.Config.AimIn.Time

            if ogtime then
                self.Config.AimIn.Time = 1e-4
            end
            
            local result = ogfuncs.ogaim(self, state)

            if ogtime then
                self.Config.AimIn.Time = ogtime
            end

            return result
        else
            return ogfuncs.ogaim(self, state)
        end
    end

    main:AddToggle('instantscope',{
        Default = false,
        Text = "instant scope",
        Tooltip = "lets you scope instantly without the tweening and delay",
        Callback = function(v)
            instantscope = v
        end
    })

    main:AddToggle('autoreload',{
        Default = false,
        Text = "auto reload",
        Tooltip = "attempts to reload when you fire a bullet",
        Callback = function(v)
            misctbl.autoreload = v
        end
    })
end

do
    modules.viewmodelcontroller.new = function(config)
        local newconfig = ogfuncs.ogviewmodel(config)
        task.delay(0.01, function()
            if not newconfig.Dead and viewmodel.override then
                newconfig.offset = CFrame.new(viewmodel.viewmodelx, viewmodel.viewmodely, viewmodel.viewmodelz)
            else
                newconfig.offset = CFrame.new(0.1, -1.5, 0.15) 
            end
        end)
        return newconfig
    end

    selfvisuals:AddToggle('overrideviewmodel',{
        Default = false,
        Text = "override viewmodel",
        Callback = function(v)
            viewmodel.override = v

            if v then
                modules.cameracontroller.BaseFOV = viewmodel.fov

                if modules.viewmodelcontroller.activeViewmodel then
                    modules.viewmodelcontroller.activeViewmodel.offset = CFrame.new(viewmodel.viewmodelx, viewmodel.viewmodely, viewmodel.viewmodelz)
                end

                if viewmodel.currentviewmodel then
                    viewmodel.currentviewmodel["Left Arm"].Color = viewmodel.armcolor
                    viewmodel.currentviewmodel["Right Arm"].Color = viewmodel.armcolor
                    viewmodel.currentviewmodel["Left Arm"].Transparency = viewmodel.armtransparency
                    viewmodel.currentviewmodel["Right Arm"].Transparency = viewmodel.armtransparency
                    viewmodel.currentviewmodel["Left Arm"].Material = viewmodel.armmaterial
                    viewmodel.currentviewmodel["Right Arm"].Material = viewmodel.armmaterial
                end
            else 
                modules.cameracontroller.BaseFOV = modules.settingsmain.Settings.FOV

                if modules.viewmodelcontroller.activeViewmodel then
                    modules.viewmodelcontroller.activeViewmodel.offset = CFrame.new(0.1, -1.5, 0.15) -- prob default idfk
                end

                if viewmodel.currentviewmodel then
                    viewmodel.currentviewmodel["Left Arm"].Color = localplayer and localplayer.Character["Left Arm"].Color or Color3.fromRGB(255, 255, 255)
                    viewmodel.currentviewmodel["Right Arm"].Color = localplayer and localplayer.Character["Right Arm"].Color or Color3.fromRGB(255, 255, 255)
                    viewmodel.currentviewmodel["Left Arm"].Transparency = 0
                    viewmodel.currentviewmodel["Right Arm"].Transparency = 0
                    viewmodel.currentviewmodel["Left Arm"].Material = Enum.Material.Plastic
                    viewmodel.currentviewmodel["Right Arm"].Material = Enum.Material.Plastic
                end
            end
        end
    })

    selfvisuals:AddSlider('fov',{
        Min = 1,
        Max = 120,
        Rounding = 0,
        Compact = true,
        Default = viewmodel.fov,
        Text = "fov",
        Callback = function(v) 
            viewmodel.fov = v

            if viewmodel.override then
                modules.cameracontroller.BaseFOV = v
            end
        end
    })

    selfvisuals:AddSlider('viewmodelx',{
        Min = -5,
        Max = 5,
        Rounding = 1,
        Default = 0.1,
        Text = "viewmodel x",
        Compact = true,
        Callback = function(v) 
            viewmodel.viewmodelx = v

            if viewmodel.override and modules.viewmodelcontroller.activeViewmodel then
                modules.viewmodelcontroller.activeViewmodel.offset = CFrame.new(v, viewmodel.viewmodely, viewmodel.viewmodelz)
            end
        end
    })

    selfvisuals:AddSlider('viewmodely',{
        Min = -5,
        Max = 5,
        Rounding = 1,
        Default = -1.5,
        Text = "viewmodel y",
        Compact = true,
        Callback = function(v) 
            viewmodel.viewmodely = v

            if viewmodel.override and modules.viewmodelcontroller.activeViewmodel then
                modules.viewmodelcontroller.activeViewmodel.offset = CFrame.new(viewmodel.viewmodelx, v, viewmodel.viewmodelz)
            end
        end
    })

    selfvisuals:AddSlider('viewmodelz',{
        Min = -5,
        Max = 5,
        Rounding = 1,
        Default = 0.15,
        Compact = true,
        Text = "viewmodel z",
        Callback = function(v) 
            viewmodel.viewmodelz = v

            if viewmodel.override and modules.viewmodelcontroller.activeViewmodel then
                modules.viewmodelcontroller.activeViewmodel.offset = CFrame.new(viewmodel.viewmodelx, viewmodel.viewmodely, v)
            end
        end
    })

    selfvisuals:AddDivider("viewmodel arms")

    selfvisuals:AddDropdown('armmaterial',{
        Values = {"Plastic", "ForceField", "Neon",},
        Default = "Plastic",
        Multi = false,
        Text = "arm material",
        Callback = function(v)
            viewmodel.armmaterial = Enum.Material[v]

            if viewmodel.override and viewmodel.currentviewmodel then
                viewmodel.currentviewmodel["Left Arm"].Material = viewmodel.armmaterial
                viewmodel.currentviewmodel["Right Arm"].Material = viewmodel.armmaterial
            end
        end
    })

    selfvisuals:AddLabel("arm color"):AddColorPicker('armcolor',{
        Default = Color3.fromRGB(255,255,255),
        Title = "arm color",
        Callback = function(v) 
            viewmodel.armcolor = v

            if viewmodel.override and viewmodel.currentviewmodel then
                viewmodel.currentviewmodel["Left Arm"].Color = viewmodel.armcolor
                viewmodel.currentviewmodel["Right Arm"].Color = viewmodel.armcolor
            end
        end
    })

    selfvisuals:AddSlider('armtransparency',{
        Min = 0,
        Max = 1,
        Rounding = 1,
        Compact = true,
        Default = 0,
        Text = "arm transparency",
        Callback = function(v) 
            viewmodel.armtransparency = v

            if viewmodel.override and viewmodel.currentviewmodel then
                viewmodel.currentviewmodel["Left Arm"].Transparency = viewmodel.armtransparency
                viewmodel.currentviewmodel["Right Arm"].Transparency = viewmodel.armtransparency
            end
        end
    })
end

do
    local whitelistedparts = {["Head"] = true, ["Torso"] = true,["Left Arm"] = true, ["Right Arm"] = true, ["Left Leg"] = true, ["Right Leg"] = true}
    local excludedparts = {["FakeHead"] = true, ["HumanoidRootPart"] = true, ["SoundPoint"] = true}

    local offsetx = 0.3
    local offsety = 2.5
    local offsetz = 8

    selfvisuals:AddDivider("third person")

    selfvisuals:AddToggle('thirdperson',{
        Default = false,
        Text = "third person",
        Callback = function(v)
            if v then
                runserv:BindToRenderStep("firstpersoncframe", Enum.RenderPriority.Camera.Value + 2, function() -- need to keep first person cframe since using head as origin point just leads to misses
                    if camera.CameraType == Enum.CameraType.Custom then
                        misctbl.firstpersoncframe = camera.CFrame
                    end
                end)

                cons.thirdpersoncon = runserv.RenderStepped:Connect(function()
                    if camera.CameraType ~= Enum.CameraType.Custom then return end
                    if not localplayer.Character then return end

                    local torso = localplayer and localplayer.Character and localplayer.Character:FindFirstChild("Torso")

                    if viewmodel.currentviewmodel then
                        viewmodel.currentviewmodel["Left Arm"].Transparency = 1
			            viewmodel.currentviewmodel["Right Arm"].Transparency = 1
                    end

                    if localplayer and localplayer.Character then
                        for _,v in localplayer.Character:GetDescendants() do
                            if v:IsA("BasePart") then
                                if whitelistedparts[v.Name] and not excludedparts[v.Name] then
                                    v.Transparency = 0
                                    v.LocalTransparencyModifier = 0
                                elseif v:FindFirstAncestorOfClass("Accessory") then
                                    v.Transparency = 0
                                    v.LocalTransparencyModifier = 0
                                end
                            end
                        end
                    end

                    local distance = (camera.CFrame.Position - camera.Focus.Position).Magnitude

                    local threshold = math.max(1.5, offsety * 0.4)

                    if distance < threshold then
                        local offset = camera.CFrame.Position + camera.CFrame.RightVector * offsetx + camera.CFrame.UpVector * offsety - camera.CFrame.LookVector * offsetz
                        camera.CFrame = CFrame.lookAt(offset, offset + camera.CFrame.LookVector)
                    end

                    if torso and viewmodel.currentviewmodel then
                        local tool = localplayer and localplayer.Character and localplayer.Character:FindFirstChildOfClass("Tool")
                        local weld = tool and tool:FindFirstChild("ToolWeld")
                        local part0 = weld and weld.Part0

                        if part0 and part0:IsDescendantOf(viewmodel.currentviewmodel) then
                            local pivotoffset = part0.CFrame:ToObjectSpace(viewmodel.currentviewmodel:GetPivot())
                            viewmodel.currentviewmodel:PivotTo(torso.CFrame * pivotoffset)
                        else
                            local flat = Vector3.new(torso.CFrame.LookVector.X, 0, torso.CFrame.LookVector.Z)
                            flat = flat.Magnitude > 0.001 and flat.Unit or Vector3.new(1, 0, 0)
                            viewmodel.currentviewmodel:PivotTo(CFrame.lookAt(torso.Position, torso.Position + flat))
                        end
                    end
                end)
            else
                misctbl.firstpersoncframe = nil

                runserv:UnbindFromRenderStep("firstpersoncframe")

                if cons.thirdpersoncon then
                    cons.thirdpersoncon:Disconnect()
                    cons.thirdpersoncon = nil
                end

                if viewmodel.currentviewmodel then
                    if viewmodel.override then
                        viewmodel.currentviewmodel["Left Arm"].Transparency = viewmodel.armtransparency
                        viewmodel.currentviewmodel["Right Arm"].Transparency = viewmodel.armtransparency
                    else
                        viewmodel.currentviewmodel["Left Arm"].Transparency = 0
                        viewmodel.currentviewmodel["Right Arm"].Transparency = 0
                    end
                end

                if localplayer.Character then
                    local flatlook = Vector3.new(camera.CFrame.LookVector.X, 0, camera.CFrame.LookVector.Z).Unit
                    localplayer.Character:SetAttribute("cv_lv", flatlook)

                    pcall(function()
                        modules.adjustcharacterlimbs(localplayer.Character, flatlook, false, false, false)
                        modules.adjustcharacterlimbs(localplayer.Character, flatlook, false, true, false)
                    end)
                end
            end
        end
    }):AddKeyPicker('thirdpersonkeybind',{
        Text = "third person",
        SyncToggleState = true,
        Default = "None",
        Mode = "Toggle",
        NoUI = false,
    })

    selfvisuals:AddSlider('thirdpersonx',{
        Min = -10,
        Max = 10,
        Rounding = 1,
        Compact = true,
        Default = offsetx,
        Text = "offset x",
        Callback = function(v) 
            offsetx = v
        end
    })

    selfvisuals:AddSlider('thirdpersony',{
        Min = -5,
        Max = 5,
        Rounding = 1,
        Compact = true,
        Default = offsety,
        Text = "offset y",
        Callback = function(v) 
            offsety = v
        end
    })

    selfvisuals:AddSlider('thirdpersonz',{
        Min = 0,
        Max = 15,
        Rounding = 1,
        Compact = true,
        Default = offsetz,
        Text = "offset z",
        Callback = function(v) 
            offsetz = v
        end
    })
end

do
    playervisuals:AddToggle('enemyhighlight',{
        Default = highlighttbl.enemyhighlight,
        Text = "enemy highlight",
        Callback = function(v)
            highlighttbl.enemyhighlight = v
        end
    })

    playervisuals:AddSlider('enemyfilltransparency',{
        Min = -0,
        Max = 1,
        Rounding = 1,
        Default = highlighttbl.enemyfilltransparency,
        Compact = true,
        Text = "enemy fill transparency",
        Callback = function(v) 
            highlighttbl.enemyfilltransparency = v
        end
    })

    playervisuals:AddSlider('enemyoutlinetransparency',{
        Min = 0,
        Max = 1,
        Rounding = 1,
        Default = highlighttbl.enemyoutlinetransparency,
        Compact = true,
        Text = "enemy outline transparency",
        Callback = function(v) 
            highlighttbl.enemyoutlinetransparency = v
        end
    })

    playervisuals:AddLabel("enemy fill color"):AddColorPicker('enemyfillcolor',{
        Default = highlighttbl.enemyfillcolor,
        Title = "enemy fill color",
        Callback = function(v) 
            highlighttbl.enemyfillcolor = v
        end
    })

    playervisuals:AddLabel("enemy outline color"):AddColorPicker('enemyoutlinecolor',{
        Default = highlighttbl.enemyoutlinecolor,
        Title = "enemy outline color",
        Callback = function(v) 
            highlighttbl.enemyoutlinecolor = v
        end
    })

    playervisuals:AddDivider("team")

    playervisuals:AddToggle('teamhighlight',{
        Default = highlighttbl.teamhighlight,
        Text = "team highlight",
        Callback = function(v)
            highlighttbl.teamhighlight = v
        end
    })

    playervisuals:AddSlider('teamfilltransparency',{
        Min = -0,
        Max = 1,
        Rounding = 1,
        Default = highlighttbl.teamfilltransparency,
        Compact = true,
        Text = "team fill transparency",
        Callback = function(v) 
            highlighttbl.teamfilltransparency = v
        end
    })

    playervisuals:AddSlider('teamoutlinetransparency',{
        Min = 0,
        Max = 1,
        Rounding = 1,
        Default = highlighttbl.teamoutlinetransparency,
        Compact = true,
        Text = "team outline transparency",
        Callback = function(v) 
            highlighttbl.teamoutlinetransparency = v
        end
    })

    playervisuals:AddLabel("team fill color"):AddColorPicker('teamfillcolor',{
        Default = highlighttbl.teamfillcolor,
        Title = "team fill color",
        Callback = function(v) 
            highlighttbl.teamfillcolor = v
        end
    })

    playervisuals:AddLabel("team outline color"):AddColorPicker('teamoutlinecolor',{
        Default = highlighttbl.teamoutlinecolor,
        Title = "team outline color",
        Callback = function(v) 
            highlighttbl.teamoutlinecolor = v
        end
    })
end

do
    local queuetype = "Casual"
    local mobileconsoleonly = false
    local selectedgamemodes = {"1v1"}
    local gamemodes = {}

    for _,v in modules.globalmatchmakingconfig.Modes do
        table.insert(gamemodes, v)
    end

    if modules.globalmatchmakingconfig.LimitedTimeModes then
        for _,v in modules.globalmatchmakingconfig.LimitedTimeModes do
            if not table.find(gamemodes, v) then
                table.insert(gamemodes, v)
            end
        end
    end

    miscmain:AddDropdown('selectedgamemodes', {
        Tooltip = "gamemodes you will queue for (some LTM gamemodes wont work unless in rotation)",
        Default = "1v1",
        Multi = true,
        Values = gamemodes,
        Text = "gamemodes",
        Callback = function(v)
            selectedgamemodes = {}

            if v then
                for i,s in v do
                    if s == true then
                        table.insert(selectedgamemodes, i)
                    end
                end
            end
        end
    })

    miscmain:AddDropdown('queuetype', { -- preupdate for ranked a lil
        Default = "Casual",
        Multi = false,
        Values = {"Casual", "Ranked"},
        Text = "queue type",
        Callback = function(v)
            queuetype = v
        end
    })

    local startqueue = miscmain:AddButton({
        Text = "start queue",
        Func = function()
            if #selectedgamemodes > 0 then
                modules.globalmatchmakingcontroller.SelectedGameModes = selectedgamemodes
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Match"):WaitForChild("Matchmaking"):WaitForChild("Global"):WaitForChild("QueueUp"):InvokeServer(queuetype, selectedgamemodes, mobileconsoleonly)
            end
        end,
        DoubleClick = false,
    })

    local stopqueue = miscmain:AddButton({
        Text = "stop queue",
        Func = function()
            if modules.globalmatchmakingcontroller.CancelQueue then
                modules.globalmatchmakingcontroller:CancelQueue()
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Match"):WaitForChild("Matchmaking"):WaitForChild("Global"):WaitForChild("CancelQueue"):FireServer()
            end
        end,
        DoubleClick = false,
    })

    miscmain:AddToggle('autoqueue',{
        Tooltip = "automatically queue after a match ends",
        Default = false,
        Text = "auto queue",
        Callback = function(v)
            if v then
                cons.autoqueuecon = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes"):WaitForChild("Match"):WaitForChild("EndMatch").OnClientEvent:Connect(function()
                    if #selectedgamemodes > 0 then
                        modules.globalmatchmakingcontroller.SelectedGameModes = selectedgamemodes
                        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Match"):WaitForChild("Matchmaking"):WaitForChild("Global"):WaitForChild("QueueUp"):InvokeServer(queuetype, selectedgamemodes, mobileconsoleonly)
                    end
                end)
            else
                if cons.autoqueuecon then
                    cons.autoqueuecon:Disconnect()
                    cons.autoqueuecon = nil
                end
            end
        end
    })

    miscmain:AddToggle('mobileconsoleonly',{
        Tooltip = "queues you with console/mobile players only",
        Default = false,
        Text = "console/mobile queue only",
        Callback = function(v)
            mobileconsoleonly = v
        end
    })
end

do
    miscmain:AddDivider("device")

    miscmain:AddToggle('devicespoofing',{
        Tooltip = "spoofs your device to appear as the selected one",
        Default = false,
        Text = "spoof device",
        Callback = function(v)
            devicetbl.spoofplatform = v

            if v then
                setplatform(devicetbl.device)
            else
                if devicetbl.ogplatform == 1 then
                    setplatform("Desktop")
                elseif devicetbl.ogplatform == 2 then
                    setplatform("Mobile")
                elseif devicetbl.ogplatform == 3 then
                    setplatform("Console")
                end
            end
        end
    })

    miscmain:AddToggle('consolemobilequeue',{
        Tooltip = "lets you queue with console/mobile players only",
        Default = false,
        Text = "console/mobile queue only",
        Callback = function(v)
            if devicetbl.spoofplatform then
                if v then
                    game:GetService("ReplicatedStorage"):FindFirstChild("Remotes"):WaitForChild("Match"):WaitForChild("Matchmaking"):WaitForChild("Global"):WaitForChild("SetMobileConsoleOnly"):FireServer(true)
                else
                    game:GetService("ReplicatedStorage"):FindFirstChild("Remotes"):WaitForChild("Match"):WaitForChild("Matchmaking"):WaitForChild("Global"):WaitForChild("SetMobileConsoleOnly"):FireServer(false)
                end
            end
        end
    })

    miscmain:AddDropdown('selecteddevice',{
        Tooltip = "spoofs your device to the selected one",
        Default = "Desktop",
        Multi = false,
        Values = {"Desktop", "Mobile", "Console"},
        Text = "device",
        Callback = function(v)
            devicetbl.device = v

            if devicetbl.spoofplatform and devicetbl.device then
                setplatform(devicetbl.device)
            end
        end
    })
end

do
    miscmain:AddDivider("aspect ratio")

    local aspectscale = 1

    miscmain:AddToggle('aspectratio', {
        Default = false,
        Text = "aspect ratio",
        Callback = function(v)
            library.Options.aspectscale:SetVisible(v)

            if v then
                cons.aspectratiocon = runserv.RenderStepped:Connect(function()
                    if camera.CameraType ~= Enum.CameraType.Custom then return end

                    camera.CFrame = camera.CFrame * CFrame.new(0, 0, 0, 1, 0, 0, 0, aspectscale, 0, 0, 0, 1)
                end)
            else
                if cons.aspectratiocon then
                    cons.aspectratiocon:Disconnect()
                    cons.aspectratiocon = nil
                end
            end
        end
    })

    miscmain:AddSlider('aspectscale', {
        Min = 0.1,
        Max = 1,
        Rounding = 2,
        Compact = true,
        Default = aspectscale,
        Text = "vertical",
        Visible = false,
        Callback = function(v)
            aspectscale = v
        end,
    })
end

do -- ts is beyond scuffed bro
    local customtracer = false
    local customkilleffect = false
    local tracers = table.clone(modules.skinconfig.TracerEffects)
    local killeffects = table.clone(modules.skinconfig.KillEffects)
    local tracer = tracers[1] or "Binary"
    local killeffect = killeffects[1] or "BlackHole"

    local weaponsounds = {}
    local hitsounds = {}

    local hitsoundnames = {}
    local weaponsoundnames = {}

    local newsounds = {
        headshot = getcustomasset("sniperduelshake/assets/hitsounds/headshot_noarmor_04.mp3"),
        headshotvolume = 1,
        hit = getcustomasset("sniperduelshake/assets/hitsounds/agpa1.mp3"),
        hitvolume = 1,
        overridehit = false,
        overrideheadshot = false,
        weapon = getcustomasset("sniperduelshake/assets/weaponsounds/ssg08.mp3"),
        weaponvolume = 1,
        overrideweapon = false
    }

    for _,v in listfiles("sniperduelshake/assets/hitsounds") do
        local name = v:match("([^/\\]+)$")

        if name then
            local newname = name:gsub("%.mp3$", "")
            
            if newname then
                table.insert(hitsoundnames, newname)
                hitsounds[newname] = getcustomasset(v)
            end
        end
    end
    
    for _,v in listfiles("sniperduelshake/assets/weaponsounds") do
        local name = v:match("([^/\\]+)$")

        if name then
            local newname = name:gsub("%.mp3$", "")
            
            if newname then
                table.insert(weaponsoundnames, newname)
                weaponsounds[newname] = getcustomasset(v)
            end
        end
    end

    maintab:AddToggle('headshotsoundoverride',{
        Default = false,
        Text = "headshot sound override",
        Tooltip = "overrides the default headshot sound with a custom one",
        Callback = function(v)
            newsounds.overrideheadshot = v

            library.Options.headshotsound:SetVisible(v)
            library.Options.headshotvolume:SetVisible(v)

            if v then
                game:GetService("SoundService"):FindFirstChild("Game"):WaitForChild("Local"):WaitForChild("Hitmarker"):WaitForChild("HeadshotKill").SoundId = newsounds.headshot
                game:GetService("SoundService"):FindFirstChild("Game"):WaitForChild("Local"):WaitForChild("Hitmarker"):WaitForChild("HeadshotKill").Volume = newsounds.headshotvolume
                game:GetService("SoundService"):FindFirstChild("Game"):WaitForChild("Local"):WaitForChild("Hitmarker"):WaitForChild("HeadshotKill"):SetAttribute("og_vol", newsounds.headshotvolume)
            else
                game:GetService("SoundService"):FindFirstChild("Game"):WaitForChild("Local"):WaitForChild("Hitmarker"):WaitForChild("HeadshotKill").SoundId = oghitsounds.headshot
                game:GetService("SoundService"):FindFirstChild("Game"):WaitForChild("Local"):WaitForChild("Hitmarker"):WaitForChild("HeadshotKill").Volume = oghitsounds.headshotvolume
                game:GetService("SoundService"):FindFirstChild("Game"):WaitForChild("Local"):WaitForChild("Hitmarker"):WaitForChild("HeadshotKill"):SetAttribute("og_vol", oghitsounds.headshotvolume)
            end
        end
    })
    maintab:AddDropdown('headshotsound',{
        Values = hitsoundnames,
        Default = "headshot_noarmor_04",
        Multi = false,
        Text = "sound",
        Tooltip = "sound that will play when you get a headshot",
        Visible = false,
        Callback = function(v)
            newsounds.headshot = hitsounds[v]

            if newsounds.overrideheadshot then
                game:GetService("SoundService"):FindFirstChild("Game"):WaitForChild("Local"):WaitForChild("Hitmarker"):WaitForChild("HeadshotKill").SoundId = newsounds.headshot
            end
        end
    })
    maintab:AddSlider('headshotvolume',{
        Min = 0,
        Max = 10,
        Rounding = 1,
        Default = newsounds.headshotvolume,
        Tooltip = "volume of the headshot sound played",
        Text = "volume",
        Compact = true,
        Visible = false,
        Callback = function(v) 
            newsounds.headshotvolume = v

            if newsounds.overrideheadshot then
                game:GetService("SoundService"):FindFirstChild("Game"):WaitForChild("Local"):WaitForChild("Hitmarker"):WaitForChild("HeadshotKill").Volume = newsounds.headshotvolume
                game:GetService("SoundService"):FindFirstChild("Game"):WaitForChild("Local"):WaitForChild("Hitmarker"):WaitForChild("HeadshotKill"):SetAttribute("og_vol", newsounds.headshotvolume)
            end
        end
    })

    maintab:AddToggle('hitsoundoverride',{
        Default = false,
        Text = "hit sound override",
        Tooltip = "overrides the default hit sounds with a custom one",
        Callback = function(v)
            newsounds.overridehit = v

            library.Options.hitsounds:SetVisible(v)
            library.Options.hitsoundvolume:SetVisible(v)

            if v then
                game:GetService("SoundService"):FindFirstChild("Game"):WaitForChild("Local"):WaitForChild("Hitmarker"):WaitForChild("Kill").SoundId = newsounds.hit
                game:GetService("SoundService"):FindFirstChild("Game"):WaitForChild("Local"):WaitForChild("Hitmarker"):WaitForChild("Hitmarker").SoundId = newsounds.hit
                game:GetService("SoundService"):FindFirstChild("Game"):WaitForChild("Local"):WaitForChild("Hitmarker"):WaitForChild("Kill").Volume = newsounds.hitvolume
                game:GetService("SoundService"):FindFirstChild("Game"):WaitForChild("Local"):WaitForChild("Hitmarker"):WaitForChild("Hitmarker").Volume = newsounds.hitvolume
                game:GetService("SoundService"):FindFirstChild("Game"):WaitForChild("Local"):WaitForChild("Hitmarker"):WaitForChild("Kill"):SetAttribute("og_vol", newsounds.hitvolume)
                game:GetService("SoundService"):FindFirstChild("Game"):WaitForChild("Local"):WaitForChild("Hitmarker"):WaitForChild("Hitmarker"):SetAttribute("og_vol", newsounds.hitvolume)
            else
                game:GetService("SoundService"):FindFirstChild("Game"):WaitForChild("Local"):WaitForChild("Hitmarker"):WaitForChild("Kill").SoundId = oghitsounds.hitsound
                game:GetService("SoundService"):FindFirstChild("Game"):WaitForChild("Local"):WaitForChild("Hitmarker"):WaitForChild("Hitmarker").SoundId = oghitsounds.hitmarker
                game:GetService("SoundService"):FindFirstChild("Game"):WaitForChild("Local"):WaitForChild("Hitmarker"):WaitForChild("Kill").Volume = oghitsounds.hitsoundvolume
                game:GetService("SoundService"):FindFirstChild("Game"):WaitForChild("Local"):WaitForChild("Hitmarker"):WaitForChild("Hitmarker").Volume = oghitsounds.hitmarkervolume
                game:GetService("SoundService"):FindFirstChild("Game"):WaitForChild("Local"):WaitForChild("Hitmarker"):WaitForChild("Kill"):SetAttribute("og_vol", oghitsounds.hitsoundvolume)
                game:GetService("SoundService"):FindFirstChild("Game"):WaitForChild("Local"):WaitForChild("Hitmarker"):WaitForChild("Hitmarker"):SetAttribute("og_vol", oghitsounds.hitmarkervolume)
            end
        end
    })

    maintab:AddDropdown('hitsounds',{
        Values = hitsoundnames,
        Default = "agpa1",
        Multi = false,
        Text = "sound",
        Tooltip = "sound that will play when you kill/hit a target",
        Visible = false,
        Callback = function(v)
            newsounds.hit = hitsounds[v]

            if newsounds.overridehit then
                game:GetService("SoundService"):FindFirstChild("Game"):WaitForChild("Local"):WaitForChild("Hitmarker"):WaitForChild("Kill").SoundId = newsounds.hit
                game:GetService("SoundService"):FindFirstChild("Game"):WaitForChild("Local"):WaitForChild("Hitmarker"):WaitForChild("Hitmarker").SoundId = newsounds.hit
            end
        end
    })

    maintab:AddSlider('hitsoundvolume',{
        Tooltip = "volume of the hit sound played",
        Min = 0,
        Max = 10,
        Rounding = 1,
        Default = newsounds.hitvolume,
        Text = "volume",
        Compact = true,
        Visible = false,
        Callback = function(v) 
            newsounds.hitvolume = v

            if newsounds.overridehit then
                game:GetService("SoundService"):FindFirstChild("Game"):WaitForChild("Local"):WaitForChild("Hitmarker"):WaitForChild("Kill").Volume = newsounds.hitvolume
                game:GetService("SoundService"):FindFirstChild("Game"):WaitForChild("Local"):WaitForChild("Hitmarker"):WaitForChild("Hitmarker").Volume = newsounds.hitvolume
                game:GetService("SoundService"):FindFirstChild("Game"):WaitForChild("Local"):WaitForChild("Hitmarker"):WaitForChild("Kill"):SetAttribute("og_vol", newsounds.hitvolume)
                game:GetService("SoundService"):FindFirstChild("Game"):WaitForChild("Local"):WaitForChild("Hitmarker"):WaitForChild("Hitmarker"):SetAttribute("og_vol", newsounds.hitvolume)
            end
        end
    })

    modules.effects.GunFiringSound = function(self, v1, v2)
        if newsounds.overrideweapon and v1:IsDescendantOf(localplayer.Character) then
            local sound = Instance.new("Sound")
            sound.SoundId = newsounds.weapon
            sound.Volume = newsounds.weaponvolume
            sound.Parent = v1
            sound:Play()
            
            sound.Ended:Connect(function()
                sound:Destroy()
            end)
            return
        end 
        
        return ogfuncs.ogfiringsound(self, v1, v2)
    end

    modules.effects.VisualizeBullet = function(self, v1, v2, v3, v4, v5, v6, v7)
        if customtracer and v1 == localplayer.Character then
            v7 = tracer
        end
        return ogfuncs.ogbullet(self, v1, v2, v3, v4, v5, v6, v7)
    end

    guntab:AddToggle('traceroverride',{
        Tooltip = "overrides the default tracer with the chosen one",
        Default = false,
        Text = "override tracer",
        Callback = function(v)
            customtracer = v

            library.Options.tracer:SetVisible(v)
        end
    })

    guntab:AddDropdown('tracer',{
        Tooltip = "fx tracer that will be used when firing",
        Default = tracers[1] or "Binary",
        Multi = false,
        Values = tracers,
        Text = "tracer",
        Visible = false,
        Callback = function(v)
            tracer = v
        end
    })

    modules.killeffectdefault.Apply = function(self, v1, ...)
        if customkilleffect then
            local cfg = modules.killeffectsconfig[killeffect]

            if cfg and cfg.Apply then
                return cfg.Apply(self, v1, ...)
            end
        end

        return ogfuncs.ogapply(self, v1, ...)
    end

    guntab:AddToggle('killeffectoverride',{
        Tooltip = "overrides the default kill effect with the chosen one",
        Default = false,
        Text = "kill effect override",
        Callback = function(v)
            customkilleffect = v

            library.Options.killeffect:SetVisible(v)
        end
    })

    guntab:AddDropdown('killeffect',{
        Tooltip = "kill effect that will be applied when you get a kill",
        Default = killeffects[1] or "BlackHole",
        Multi = false,
        Values = killeffects,
        Text = "kill effect",
        Visible = false,
        Callback = function(v)
            killeffect = v
        end
    })

    guntab:AddDivider("sounds")

    guntab:AddToggle('weaponsoundoverride',{
        Tooltip = "overrides the default weapon firing sound with a custom one",
        Default = newsounds.overrideweapon,
        Text = "fire sound override",
        Callback = function(v)
            newsounds.overrideweapon = v

            library.Options.weaponsounds:SetVisible(v)
            library.Options.weaponvolume:SetVisible(v)
        end
    })

    guntab:AddDropdown('weaponsounds',{
        Default = "ssg08",
        Multi = false,
        Values = weaponsoundnames,
        Text = "sound",
        Tooltip = "sound that will be played when firing the weapon",
        Visible = false,
        Callback = function(v)
            newsounds.weapon = weaponsounds[v]
        end
    })

    guntab:AddSlider('weaponvolume',{
        Tooltip = "volume of the weapon firing sound",
        Min = 0,
        Max = 10,
        Rounding = 1,
        Default = newsounds.weaponvolume,
        Text = "volume",
        Compact = true,
        Visible = false,
        Callback = function(v) 
            newsounds.weaponvolume = v
        end
    })
end

do
    local atmospheretab = atmospherevisuals:AddTab("atmosphere")
    local colorcorrectiontab = atmospherevisuals:AddTab("color correction")
    local bloomtab = bloomvisuals:AddTab("bloom")
    local sunraystab = bloomvisuals:AddTab("sun rays")
    local cloudstab = bloomvisuals:AddTab("clouds")

    lightingvisuals:AddToggle('lighthingoverride',{ -- pasted ts from my aniphobia script
        Default = false,
        Text = "override lighting",
        Tooltip = "lets you override lighting values with your own",
        Callback = function(v)
            lightingtbl.lightingoverride = v

            if v then
                lighting.Ambient = lightingtbl.newlighting.Ambient
                lighting.OutdoorAmbient = lightingtbl.newlighting.OutdoorAmbient
                lighting.Brightness = lightingtbl.newlighting.Brightness
                lighting.ClockTime = lightingtbl.newlighting.ClockTime
                lighting.FogColor = lightingtbl.newlighting.FogColor
                lighting.FogStart = lightingtbl.newlighting.FogStart
                lighting.FogEnd = lightingtbl.newlighting.FogEnd
                lighting.GlobalShadows = lightingtbl.newlighting.GlobalShadows
                lighting.ColorShift_Top = lightingtbl.newlighting.ColorShift_Top
                lighting.ColorShift_Bottom = lightingtbl.newlighting.ColorShift_Bottom
                lighting.EnvironmentDiffuseScale = lightingtbl.newlighting.EnvironmentDiffuseScale
                lighting.EnvironmentSpecularScale = lightingtbl.newlighting.EnvironmentSpecularScale
                lighting.ShadowSoftness = lightingtbl.newlighting.ShadowSoftness
            else
                lighting.Ambient = lightingtbl.oldlighting.Ambient
                lighting.OutdoorAmbient = lightingtbl.oldlighting.OutdoorAmbient
                lighting.Brightness = lightingtbl.oldlighting.Brightness
                lighting.ClockTime = lightingtbl.oldlighting.ClockTime
                lighting.FogColor = lightingtbl.oldlighting.FogColor
                lighting.FogStart = lightingtbl.oldlighting.FogStart
                lighting.FogEnd = lightingtbl.oldlighting.FogEnd
                lighting.GlobalShadows = lightingtbl.oldlighting.GlobalShadows
                lighting.ColorShift_Top = lightingtbl.oldlighting.ColorShift_Top
                lighting.ColorShift_Bottom = lightingtbl.oldlighting.ColorShift_Bottom
                lighting.EnvironmentDiffuseScale = lightingtbl.oldlighting.EnvironmentDiffuseScale
                lighting.EnvironmentSpecularScale = lightingtbl.oldlighting.EnvironmentSpecularScale
                lighting.ShadowSoftness = lightingtbl.oldlighting.ShadowSoftness
            end
        end
    })

    lightingvisuals:AddDivider("properties")

    lightingvisuals:AddLabel('Ambient'):AddColorPicker('Ambient',{
        Title = "Ambient",
        Default = lightingtbl.oldlighting.Ambient,
        Callback = function(v)
            lightingtbl.newlighting.Ambient = v

            if lightingtbl.lightingoverride then
                lighting.Ambient = v
            end
        end
    })

    lightingvisuals:AddLabel('OutdoorAmbient'):AddColorPicker('OutdoorAmbient',{
        Title = "OutdoorAmbient",
        Default =  lightingtbl.oldlighting.OutdoorAmbient,
        Callback = function(v)
            lightingtbl.newlighting.OutdoorAmbient = v

            if lightingtbl.lightingoverride then
                lighting.OutdoorAmbient = v
            end
        end
    })

    lightingvisuals:AddSlider('Brightness',{
        Min = 0,
        Max = 10,
        Rounding = 1,
        Default = lightingtbl.oldlighting.Brightness,
        Compact = true,
        Text = "Brightness",
        Callback = function(v) 
            lightingtbl.newlighting.Brightness = v

            if lightingtbl.lightingoverride then
                lighting.Brightness = v
            end
        end
    })

    lightingvisuals:AddSlider('ClockTime',{
        Min = 0,
        Max = 24,
        Rounding = 1,
        Default = lightingtbl.oldlighting.ClockTime,
        Compact = true,
        Text = "ClockTime",
        Callback = function(v) 
            lightingtbl.newlighting.ClockTime = v

            if lightingtbl.lightingoverride then
                lighting.ClockTime = v
            end
        end
    })

    lightingvisuals:AddLabel('FogColor'):AddColorPicker('FogColor',{
        Title = "FogColor",
        Default = lightingtbl.oldlighting.FogColor,
        Callback = function(v)
            lightingtbl.newlighting.FogColor = v

            if lightingtbl.lightingoverride then
                lighting.FogColor = v
            end
        end
    })

    lightingvisuals:AddSlider('FogStart',{
        Min = 0,
        Max = 9999,
        Rounding = 0,
        Default = lightingtbl.oldlighting.FogStart,
        Compact = true,
        Text = "FogStart",
        Callback = function(v) 
            lightingtbl.newlighting.FogStart = v

            if lightingtbl.lightingoverride then
                lighting.FogStart = v
            end
        end
    })

    lightingvisuals:AddSlider('FogEnd',{
        Min = 0,
        Max = 9999,
        Rounding = 0,
        Default = lightingtbl.oldlighting.FogEnd,
        Compact = true,
        Text = "FogEnd",
        Callback = function(v) 
            lightingtbl.newlighting.FogEnd = v

            if lightingtbl.lightingoverride then
                lighting.FogEnd = v
            end
        end
    })

    lightingvisuals:AddToggle('GlobalShadows',{
        Default = lightingtbl.oldlighting.GlobalShadows,
        Text = "GlobalShadows",
        Callback = function(v)
            lightingtbl.newlighting.GlobalShadows = v

            if lightingtbl.lightingoverride then
                lighting.GlobalShadows = v
            end
        end
    })

    lightingvisuals:AddLabel('ColorShift_Top'):AddColorPicker('ColorShift_Top',{
        Title = "ColorShift_Top",
        Default = lightingtbl.oldlighting.ColorShift_Top,
        Callback = function(v)
            lightingtbl.newlighting.ColorShift_Top = v

            if lightingtbl.lightingoverride then
                lighting.ColorShift_Top = v
            end
        end
    })

    lightingvisuals:AddLabel('ColorShift_Bottom'):AddColorPicker('ColorShift_Bottom',{
        Title = "ColorShift_Bottom",
        Default =  lightingtbl.oldlighting.ColorShift_Bottom,
        Callback = function(v)
            lightingtbl.newlighting.ColorShift_Bottom = v

            if lightingtbl.lightingoverride then
                lighting.ColorShift_Bottom = v
            end
        end
    })

    lightingvisuals:AddSlider('EnvironmentDiffuseScale',{
        Min = 0,
        Max = 1,
        Rounding = 1,
        Default = lightingtbl.oldlighting.EnvironmentDiffuseScale,
        Compact = true,
        Text = "EnvironmentDiffuseScale",
        Callback = function(v) 
            lightingtbl.newlighting.EnvironmentDiffuseScale = v

            if lightingtbl.lightingoverride then
                lighting.EnvironmentDiffuseScale = v
            end
        end
    })

    lightingvisuals:AddSlider('EnvironmentSpecularScale',{
        Min = 0,
        Max = 1,
        Rounding = 1,
        Default = lightingtbl.oldlighting.EnvironmentSpecularScale,
        Compact = true,
        Text = "EnvironmentSpecularScale",
        Callback = function(v) 
            lightingtbl.newlighting.EnvironmentSpecularScale = v

            if lightingtbl.lightingoverride then
                lighting.EnvironmentSpecularScale = v
            end
        end
    })

    lightingvisuals:AddSlider('ShadowSoftness',{
        Min = 0,
        Max = 1,
        Rounding = 1,
        Default = lightingtbl.oldlighting.ShadowSoftness,
        Compact = true,
        Text = "ShadowSoftness",
        Callback = function(v) 
            lightingtbl.newlighting.ShadowSoftness = v

            if lightingtbl.lightingoverride then
                lighting.ShadowSoftness = v
            end
        end
    })

    lightingvisuals:AddDivider("reset")

    lightingreset = lightingvisuals:AddButton({
        Tooltip = "resets all lighting values to their original values",
        Text = "reset",
        Func = function()
            library.Options.Ambient:SetValue(lightingtbl.oldlighting.Ambient)
            library.Options.OutdoorAmbient:SetValue(lightingtbl.oldlighting.OutdoorAmbient)
            library.Options.Brightness:SetValue(lightingtbl.oldlighting.Brightness)
            library.Options.ClockTime:SetValue(lightingtbl.oldlighting.ClockTime)
            library.Options.FogColor:SetValue(lightingtbl.oldlighting.FogColor)
            library.Options.FogStart:SetValue(lightingtbl.oldlighting.FogStart)
            library.Options.FogEnd:SetValue(lightingtbl.oldlighting.FogEnd)
            library.Options.GlobalShadows:SetValue(lightingtbl.oldlighting.GlobalShadows)
            library.Options.ColorShift_Top:SetValue(lightingtbl.oldlighting.ColorShift_Top)
            library.Options.ColorShift_Bottom:SetValue(lightingtbl.oldlighting.ColorShift_Bottom)
            library.Options.EnvironmentDiffuseScale:SetValue(lightingtbl.oldlighting.EnvironmentDiffuseScale)
            library.Options.EnvironmentSpecularScale:SetValue(lightingtbl.oldlighting.EnvironmentSpecularScale)
            library.Options.ShadowSoftness:SetValue(lightingtbl.oldlighting.ShadowSoftness)
        end,
        DoubleClick = false,
        Visible = true
    })

    skyboxvisuals:AddToggle('skyboxoverride',{
        Default = false,
        Text = "override skybox",
        Callback = function(v)
            lightingtbl.skyboxoverride = v

            if v and lighting:FindFirstChildOfClass("Sky") then
                lighting:FindFirstChildOfClass("Sky").SkyboxBk = lightingtbl.newskybox.SkyboxBk
                lighting:FindFirstChildOfClass("Sky").SkyboxDn = lightingtbl.newskybox.SkyboxDn
                lighting:FindFirstChildOfClass("Sky").SkyboxFt = lightingtbl.newskybox.SkyboxFt
                lighting:FindFirstChildOfClass("Sky").SkyboxLf = lightingtbl.newskybox.SkyboxLf
                lighting:FindFirstChildOfClass("Sky").SkyboxRt = lightingtbl.newskybox.SkyboxRt
                lighting:FindFirstChildOfClass("Sky").SkyboxUp = lightingtbl.newskybox.SkyboxUp
                lighting:FindFirstChildOfClass("Sky").StarCount = lightingtbl.newskybox.StarCount
                lighting:FindFirstChildOfClass("Sky").MoonTextureId = lightingtbl.newskybox.MoonTextureId
                lighting:FindFirstChildOfClass("Sky").SunTextureId = lightingtbl.newskybox.SunTextureId
                lighting:FindFirstChildOfClass("Sky").SunAngularSize = lightingtbl.newskybox.SunAngularSize
                lighting:FindFirstChildOfClass("Sky").MoonAngularSize = lightingtbl.newskybox.MoonAngularSize
                lighting:FindFirstChildOfClass("Sky").CelestialBodiesShown = lightingtbl.newskybox.CelestialBodiesShown
            elseif not v and lighting:FindFirstChildOfClass("Sky") then
                lighting:FindFirstChildOfClass("Sky").SkyboxBk = lightingtbl.oldskybox.SkyboxBk
                lighting:FindFirstChildOfClass("Sky").SkyboxDn = lightingtbl.oldskybox.SkyboxDn
                lighting:FindFirstChildOfClass("Sky").SkyboxFt = lightingtbl.oldskybox.SkyboxFt
                lighting:FindFirstChildOfClass("Sky").SkyboxLf = lightingtbl.oldskybox.SkyboxLf
                lighting:FindFirstChildOfClass("Sky").SkyboxRt = lightingtbl.oldskybox.SkyboxRt
                lighting:FindFirstChildOfClass("Sky").SkyboxUp = lightingtbl.oldskybox.SkyboxUp
                lighting:FindFirstChildOfClass("Sky").StarCount = lightingtbl.oldskybox.StarCount
                lighting:FindFirstChildOfClass("Sky").MoonTextureId = lightingtbl.oldskybox.MoonTextureId
                lighting:FindFirstChildOfClass("Sky").SunTextureId = lightingtbl.oldskybox.SunTextureId
                lighting:FindFirstChildOfClass("Sky").SunAngularSize = lightingtbl.oldskybox.SunAngularSize
                lighting:FindFirstChildOfClass("Sky").MoonAngularSize = lightingtbl.oldskybox.MoonAngularSize
                lighting:FindFirstChildOfClass("Sky").CelestialBodiesShown = lightingtbl.oldskybox.CelestialBodiesShown
            end
        end
    })

    local skyboxes = {}
    local skyboxfiles = {}

    for _,v in listfiles("sniperduelshake/assets/skyboxes") do
        local name = v:match("([^/\\]+)$")

        if name then
            local newname = name:gsub("%.json$", "")
            
            if newname then
                table.insert(skyboxes, newname)
                skyboxfiles[newname] = v
            end
        end
    end

    skyboxvisuals:AddDropdown('skyboxes',{
		Values = skyboxes,
		Default = "Rainy",
		Multi = false,
		Text = "skyboxes",
		Callback = function(v) 
            if skyboxfiles[v] then
                local skybox = httpservice:JSONDecode(readfile(skyboxfiles[v]))

                lightingtbl.newskybox.SkyboxBk = skybox.SkyboxBk
                lightingtbl.newskybox.SkyboxDn = skybox.SkyboxDn
                lightingtbl.newskybox.SkyboxFt = skybox.SkyboxFt
                lightingtbl.newskybox.SkyboxLf = skybox.SkyboxLf
                lightingtbl.newskybox.SkyboxRt = skybox.SkyboxRt
                lightingtbl.newskybox.SkyboxUp = skybox.SkyboxUp
                lightingtbl.newskybox.StarCount = skybox.StarCount
                lightingtbl.newskybox.MoonTextureId = skybox.MoonTextureId
                lightingtbl.newskybox.SunTextureId = skybox.SunTextureId
                lightingtbl.newskybox.SunAngularSize = skybox.SunAngularSize
                lightingtbl.newskybox.MoonAngularSize = skybox.MoonAngularSize
                lightingtbl.newskybox.CelestialBodiesShown = skybox.CelestialBodiesShown

                if lightingtbl.skyboxoverride and lighting:FindFirstChildOfClass("Sky") then
                    lighting:FindFirstChildOfClass("Sky").SkyboxBk = lightingtbl.newskybox.SkyboxBk
                    lighting:FindFirstChildOfClass("Sky").SkyboxDn = lightingtbl.newskybox.SkyboxDn
                    lighting:FindFirstChildOfClass("Sky").SkyboxFt = lightingtbl.newskybox.SkyboxFt
                    lighting:FindFirstChildOfClass("Sky").SkyboxLf = lightingtbl.newskybox.SkyboxLf
                    lighting:FindFirstChildOfClass("Sky").SkyboxRt = lightingtbl.newskybox.SkyboxRt
                    lighting:FindFirstChildOfClass("Sky").SkyboxUp = lightingtbl.newskybox.SkyboxUp
                    lighting:FindFirstChildOfClass("Sky").StarCount = lightingtbl.newskybox.StarCount
                    lighting:FindFirstChildOfClass("Sky").MoonTextureId = lightingtbl.newskybox.MoonTextureId
                    lighting:FindFirstChildOfClass("Sky").SunTextureId = lightingtbl.newskybox.SunTextureId
                    lighting:FindFirstChildOfClass("Sky").SunAngularSize = lightingtbl.newskybox.SunAngularSize
                    lighting:FindFirstChildOfClass("Sky").MoonAngularSize = lightingtbl.newskybox.MoonAngularSize
                    lighting:FindFirstChildOfClass("Sky").CelestialBodiesShown = lightingtbl.newskybox.CelestialBodiesShown
                end
            end
		end
	})

    skyboxvisuals:AddDivider("reset")

    skyboxreset = skyboxvisuals:AddButton({
        Text = "reset",
        Func = function()
            library.Options.skyboxoverride:SetValue(false)
        end,
        DoubleClick = false,
        Visible = true
    })

    atmospheretab:AddToggle('atmosphereoverride',{
        Default = false,
        Text = "override atmosphere",
        Callback = function(v)
            lightingtbl.atmosphereoverride = v

            if v and lighting:FindFirstChildOfClass("Atmosphere") then
                lighting:FindFirstChildOfClass("Atmosphere").Density = lightingtbl.newatmosphere.Density
                lighting:FindFirstChildOfClass("Atmosphere").Offset = lightingtbl.newatmosphere.Offset
                lighting:FindFirstChildOfClass("Atmosphere").Color = lightingtbl.newatmosphere.Color
                lighting:FindFirstChildOfClass("Atmosphere").Decay = lightingtbl.newatmosphere.Decay
                lighting:FindFirstChildOfClass("Atmosphere").Glare = lightingtbl.newatmosphere.Glare
                lighting:FindFirstChildOfClass("Atmosphere").Haze = lightingtbl.newatmosphere.Haze
            elseif not v and lighting:FindFirstChildOfClass("Atmosphere") then
                lighting:FindFirstChildOfClass("Atmosphere").Density = lightingtbl.oldatmosphere.Density
                lighting:FindFirstChildOfClass("Atmosphere").Offset = lightingtbl.oldatmosphere.Offset
                lighting:FindFirstChildOfClass("Atmosphere").Color = lightingtbl.oldatmosphere.Color
                lighting:FindFirstChildOfClass("Atmosphere").Decay = lightingtbl.oldatmosphere.Decay
                lighting:FindFirstChildOfClass("Atmosphere").Glare = lightingtbl.oldatmosphere.Glare
                lighting:FindFirstChildOfClass("Atmosphere").Haze = lightingtbl.oldatmosphere.Haze
            end
        end
    })

    atmospheretab:AddDivider("properties")

    atmospheretab:AddSlider('atmospheredensity',{
        Min = 0,
        Max = 1,
        Rounding = 3,
        Default = lightingtbl.oldatmosphere.Density,
        Compact = true,
        Text = "Density",
        Callback = function(v) 
            lightingtbl.newatmosphere.Density = v

            if lightingtbl.atmosphereoverride and lighting:FindFirstChildOfClass("Atmosphere") then
                lighting:FindFirstChildOfClass("Atmosphere").Density = v
            end
        end
    })

    atmospheretab:AddSlider('atmosphereoffset',{
        Min = 0,
        Max = 1,
        Rounding = 3,
        Default = lightingtbl.oldatmosphere.Offset,
        Compact = true,
        Text = "Offset",
        Callback = function(v) 
            lightingtbl.newatmosphere.Offset = v

            if lightingtbl.atmosphereoverride and lighting:FindFirstChildOfClass("Atmosphere") then
                lighting:FindFirstChildOfClass("Atmosphere").Offset = v
            end
        end
    })

    atmospheretab:AddLabel('Color'):AddColorPicker('atmospherecolor',{
        Title = "Color",
        Default = lightingtbl.oldatmosphere.Color,
        Callback = function(v)
            lightingtbl.newatmosphere.Color = v

            if lightingtbl.atmosphereoverride and lighting:FindFirstChildOfClass("Atmosphere") then
                lighting:FindFirstChildOfClass("Atmosphere").Color = v
            end
        end
    })

    atmospheretab:AddLabel('Decay'):AddColorPicker('atmospheredecay',{
        Title = "Decay",
        Default = lightingtbl.oldatmosphere.Decay,
        Callback = function(v)
            lightingtbl.newatmosphere.Decay = v

            if lightingtbl.atmosphereoverride and lighting:FindFirstChildOfClass("Atmosphere") then
                lighting:FindFirstChildOfClass("Atmosphere").Decay = v
            end
        end
    })

    atmospheretab:AddSlider('atmosphereglare',{
        Min = 0,
        Max = 1,
        Rounding = 3,
        Default = lightingtbl.oldatmosphere.Glare,
        Compact = true,
        Text = "Glare",
        Callback = function(v) 
            lightingtbl.newatmosphere.Glare = v

            if lightingtbl.atmosphereoverride and lighting:FindFirstChildOfClass("Atmosphere") then
                lighting:FindFirstChildOfClass("Atmosphere").Glare = v
            end
        end
    })

    atmospheretab:AddSlider('atmospherehaze',{
        Min = 0,
        Max = 1,
        Rounding = 3,
        Default = lightingtbl.oldatmosphere.Haze,
        Compact = true,
        Text = "Haze",
        Callback = function(v) 
            lightingtbl.newatmosphere.Haze = v

            if lightingtbl.atmosphereoverride and lighting:FindFirstChildOfClass("Atmosphere") then
                lighting:FindFirstChildOfClass("Atmosphere").Haze = v
            end
        end
    })

    atmospheretab:AddDivider("reset")

    atmospherereset = atmospheretab:AddButton({
        Text = "reset",
        Func = function()
            library.Options.atmospheredensity:SetValue(lightingtbl.oldatmosphere.Density)
            library.Options.atmosphereoffset:SetValue(lightingtbl.oldatmosphere.Offset)
            library.Options.atmospherecolor:SetValue(lightingtbl.oldatmosphere.Color)
            library.Options.atmospheredecay:SetValue(lightingtbl.oldatmosphere.Decay)
            library.Options.atmosphereglare:SetValue(lightingtbl.oldatmosphere.Glare)
            library.Options.atmospherehaze:SetValue(lightingtbl.oldatmosphere.Haze)
        end,
        DoubleClick = false,
        Visible = true
    })

    colorcorrectiontab:AddToggle('colorcorrectionoverride',{
        Default = false,
        Text = "override color correction",
        Callback = function(v)
            lightingtbl.colorcorrectionoverride = v

            if v and lighting:FindFirstChildOfClass("ColorCorrectionEffect") then
                lighting:FindFirstChildOfClass("ColorCorrectionEffect").Enabled = lightingtbl.newcolorcorrection.Enabled
                lighting:FindFirstChildOfClass("ColorCorrectionEffect").Brightness = lightingtbl.newcolorcorrection.Brightness
                lighting:FindFirstChildOfClass("ColorCorrectionEffect").Contrast = lightingtbl.newcolorcorrection.Contrast
                lighting:FindFirstChildOfClass("ColorCorrectionEffect").TintColor = lightingtbl.newcolorcorrection.TintColor
                lighting:FindFirstChildOfClass("ColorCorrectionEffect").Saturation = lightingtbl.newcolorcorrection.Saturation
            elseif not v and lighting:FindFirstChildOfClass("ColorCorrectionEffect") then
                lighting:FindFirstChildOfClass("ColorCorrectionEffect").Enabled = lightingtbl.oldcolorcorrection.Enabled
                lighting:FindFirstChildOfClass("ColorCorrectionEffect").Brightness = lightingtbl.oldcolorcorrection.Brightness
                lighting:FindFirstChildOfClass("ColorCorrectionEffect").Contrast = lightingtbl.oldcolorcorrection.Contrast
                lighting:FindFirstChildOfClass("ColorCorrectionEffect").TintColor = lightingtbl.oldcolorcorrection.TintColor
                lighting:FindFirstChildOfClass("ColorCorrectionEffect").Saturation = lightingtbl.oldcolorcorrection.Saturation
            end
        end
    })

    colorcorrectiontab:AddDivider("properties")

    colorcorrectiontab:AddToggle('colorcorrectionenabled',{
        Default = lightingtbl.oldcolorcorrection.Enabled,
        Text = "Enabled",
        Callback = function(v)
            lightingtbl.newcolorcorrection.Enabled = v

            if lightingtbl.colorcorrectionoverride and lighting:FindFirstChildOfClass("ColorCorrectionEffect") then
                lighting:FindFirstChildOfClass("ColorCorrectionEffect").Enabled = lightingtbl.newcolorcorrection.Enabled
            end
        end
    })

    colorcorrectiontab:AddSlider('colorcorrectionbrightness',{
        Min = 0,
        Max = 1,
        Rounding = 3,
        Default = lightingtbl.oldcolorcorrection.Brightness,
        Compact = true,
        Text = "Brightness",
        Callback = function(v) 
            lightingtbl.newcolorcorrection.Brightness = v

            if lightingtbl.colorcorrectionoverride and lighting:FindFirstChildOfClass("ColorCorrectionEffect") then
                lighting:FindFirstChildOfClass("ColorCorrectionEffect").Brightness = v
            end
        end
    })

    colorcorrectiontab:AddSlider('colorcorrectioncontrast',{
        Min = 0,
        Max = 1,
        Rounding = 3,
        Default = lightingtbl.oldcolorcorrection.Contrast,
        Compact = true,
        Text = "Contrast",
        Callback = function(v) 
            lightingtbl.newcolorcorrection.Contrast = v

            if lightingtbl.colorcorrectionoverride and lighting:FindFirstChildOfClass("ColorCorrectionEffect") then
                lighting:FindFirstChildOfClass("ColorCorrectionEffect").Contrast = v
            end
        end
    })

    colorcorrectiontab:AddLabel('TintColor'):AddColorPicker('colorcorrectiontintcolor',{
        Title = "TintColor",
        Default = lightingtbl.oldcolorcorrection.TintColor,
        Callback = function(v)
            lightingtbl.newcolorcorrection.TintColor = v

            if lightingtbl.colorcorrectionoverride and lighting:FindFirstChildOfClass("ColorCorrectionEffect") then
                lighting:FindFirstChildOfClass("ColorCorrectionEffect").TintColor = v
            end
        end
    })

    colorcorrectiontab:AddSlider('colorcorrectionsaturation',{
        Min = 0,
        Max = 10,
        Rounding = 2,
        Default = lightingtbl.oldcolorcorrection.Saturation,
        Compact = true,
        Text = "Saturation",
        Callback = function(v) 
            lightingtbl.newcolorcorrection.Saturation = v

            if lightingtbl.colorcorrectionoverride and lighting:FindFirstChildOfClass("ColorCorrectionEffect") then
                lighting:FindFirstChildOfClass("ColorCorrectionEffect").Saturation = v
            end
        end
    })

    colorcorrectiontab:AddDivider("reset")

    colorcorrectionreset = colorcorrectiontab:AddButton({
        Text = "reset",
        Func = function()
            library.Options.colorcorrectionenabled:SetValue(lightingtbl.oldcolorcorrection.Enabled)
            library.Options.colorcorrectionbrightness:SetValue(lightingtbl.oldcolorcorrection.Brightness)
            library.Options.colorcorrectioncontrast:SetValue(lightingtbl.oldcolorcorrection.Contrast)
            library.Options.colorcorrectiontintcolor:SetValue(lightingtbl.oldcolorcorrection.TintColor)
            library.Options.colorcorrectionsaturation:SetValue(lightingtbl.oldcolorcorrection.Saturation)
        end,
        DoubleClick = false,
        Visible = true
    })

    bloomtab:AddToggle('bloomoverride',{
        Default = false,
        Text = "override bloom",
        Callback = function(v)
            lightingtbl.bloomoverride = v

            if v and lighting:FindFirstChildOfClass("BloomEffect") then
                lighting:FindFirstChildOfClass("BloomEffect").Enabled = lightingtbl.newbloom.Enabled
                lighting:FindFirstChildOfClass("BloomEffect").Intensity = lightingtbl.newbloom.Intensity
                lighting:FindFirstChildOfClass("BloomEffect").Size = lightingtbl.newbloom.Size
                lighting:FindFirstChildOfClass("BloomEffect").Threshold = lightingtbl.newbloom.Threshold
            elseif not v and lighting:FindFirstChildOfClass("BloomEffect") then
                lighting:FindFirstChildOfClass("BloomEffect").Enabled = lightingtbl.oldbloom.Enabled
                lighting:FindFirstChildOfClass("BloomEffect").Intensity = lightingtbl.oldbloom.Intensity
                lighting:FindFirstChildOfClass("BloomEffect").Size = lightingtbl.oldbloom.Size
                lighting:FindFirstChildOfClass("BloomEffect").Threshold = lightingtbl.oldbloom.Threshold
            end
        end
    })

    bloomtab:AddDivider("properties")

    bloomtab:AddToggle('bloomenabled',{
        Default = lightingtbl.oldbloom.Enabled,
        Text = "Enabled",
        Callback = function(v)
            lightingtbl.newbloom.Enabled = v

            if lightingtbl.bloomoverride and lighting:FindFirstChildOfClass("BloomEffect") then
                lighting:FindFirstChildOfClass("BloomEffect").Enabled = v
            end
        end
    })

    bloomtab:AddSlider('bloomintensity',{
        Min = 0,
        Max = 1,
        Rounding = 3,
        Default = lightingtbl.oldbloom.Intensity,
        Compact = true,
        Text = "Intensity",
        Callback = function(v) 
            lightingtbl.newbloom.Intensity = v

            if lightingtbl.bloomoverride and lighting:FindFirstChildOfClass("BloomEffect") then
                lighting:FindFirstChildOfClass("BloomEffect").Intensity = v
            end
        end
    })

    bloomtab:AddSlider('bloomsize',{
        Min = 0,
        Max = 1000,
        Rounding = 0,
        Default = lightingtbl.oldbloom.Size,
        Compact = true,
        Text = "Size",
        Callback = function(v) 
            lightingtbl.newbloom.Size = v

            if lightingtbl.bloomoverride and lighting:FindFirstChildOfClass("BloomEffect") then
                lighting:FindFirstChildOfClass("BloomEffect").Size = v
            end
        end
    })

    bloomtab:AddSlider('bloomthreshold',{
        Min = 0,
        Max = 4,
        Rounding = 3,
        Default = lightingtbl.oldbloom.Threshold,
        Compact = true,
        Text = "Threshold",
        Callback = function(v) 
            lightingtbl.newbloom.Threshold = v

            if lightingtbl.bloomoverride and lighting:FindFirstChildOfClass("BloomEffect") then
                lighting:FindFirstChildOfClass("BloomEffect").Threshold = v
            end
        end
    })

    bloomtab:AddDivider("reset")

    bloomreset = bloomtab:AddButton({
        Text = "reset",
        Func = function()
            library.Options.bloomenabled:SetValue(lightingtbl.oldbloom.Enabled)
            library.Options.bloomintensity:SetValue(lightingtbl.oldbloom.Intensity)
            library.Options.bloomsize:SetValue(lightingtbl.oldbloom.Size)
            library.Options.bloomthreshold:SetValue(lightingtbl.oldbloom.Threshold)
        end,
        DoubleClick = false,
        Visible = true
    })

    sunraystab:AddToggle('sunraysoverride',{
        Default = false,
        Text = "override sunrays",
        Callback = function(v)
            lightingtbl.sunraysoverride = v

            if v and lighting:FindFirstChildOfClass("SunRaysEffect") then
                lighting:FindFirstChildOfClass("SunRaysEffect").Enabled = lightingtbl.newsunrays.Enabled
                lighting:FindFirstChildOfClass("SunRaysEffect").Intensity = lightingtbl.newsunrays.Intensity
                lighting:FindFirstChildOfClass("SunRaysEffect").Spread = lightingtbl.newsunrays.Spread
            elseif not v and lighting:FindFirstChildOfClass("SunRaysEffect") then
                lighting:FindFirstChildOfClass("SunRaysEffect").Enabled = lightingtbl.oldsunrays.Enabled
                lighting:FindFirstChildOfClass("SunRaysEffect").Intensity = lightingtbl.oldsunrays.Intensity
                lighting:FindFirstChildOfClass("SunRaysEffect").Spread = lightingtbl.oldsunrays.Spread
            end
        end
    })

    sunraystab:AddDivider("properties")

    sunraystab:AddToggle('sunraysenabled',{
        Default = lightingtbl.oldsunrays.Enabled,
        Text = "Enabled",
        Callback = function(v)
           lightingtbl. newsunrays.Enabled = v

            if lightingtbl.sunraysoverride and lighting:FindFirstChildOfClass("SunRaysEffect") then
                lighting:FindFirstChildOfClass("SunRaysEffect").Enabled = v
            end
        end
    })

    sunraystab:AddSlider('sunraysintensity',{
        Min = 0,
        Max = 10,
        Rounding = 1,
        Default = lightingtbl.oldsunrays.Intensity,
        Compact = true,
        Text = "Intensity",
        Callback = function(v) 
            lightingtbl.newsunrays.Intensity = v

            if lightingtbl.sunraysoverride and lighting:FindFirstChildOfClass("SunRaysEffect") then
                lighting:FindFirstChildOfClass("SunRaysEffect").Intensity = v
            end
        end
    })

    sunraystab:AddSlider('sunraysspread',{
        Min = 0,
        Max = 10,
        Rounding = 1,
        Default = lightingtbl.oldsunrays.Spread,
        Compact = true,
        Text = "Spread",
        Callback = function(v) 
            lightingtbl.newsunrays.Spread = v

            if lightingtbl.sunraysoverride and lighting:FindFirstChildOfClass("SunRaysEffect") then
                lighting:FindFirstChildOfClass("SunRaysEffect").Spread = v
            end
        end
    })

    sunraystab:AddDivider("reset")

    sunraysreset = sunraystab:AddButton({
        Text = "reset",
        Func = function()
            library.Options.sunraysenabled:SetValue(lightingtbl.oldsunrays.Enabled)
            library.Options.sunraysintensity:SetValue(lightingtbl.oldsunrays.Intensity)
            library.Options.sunraysspread:SetValue(lightingtbl.oldsunrays.Spread)
        end,
        DoubleClick = false,
        Visible = true
    })

    cloudstab:AddToggle('cloudsoverride',{
        Default = false,
        Text = "override clouds",
        Callback = function(v)
            lightingtbl.cloudsoverride = v

            if v and game:GetService("Workspace"):WaitForChild("Terrain"):FindFirstChildOfClass("Clouds") then
                game:GetService("Workspace"):WaitForChild("Terrain"):FindFirstChildOfClass("Clouds").Cover = lightingtbl.newclouds.Cover
                game:GetService("Workspace"):WaitForChild("Terrain"):FindFirstChildOfClass("Clouds").Density = lightingtbl.newclouds.Density
                game:GetService("Workspace"):WaitForChild("Terrain"):FindFirstChildOfClass("Clouds").Color = lightingtbl.newclouds.Color
                game:GetService("Workspace"):WaitForChild("Terrain"):FindFirstChildOfClass("Clouds").Enabled = lightingtbl.newclouds.Enabled
            elseif not v and game:GetService("Workspace"):WaitForChild("Terrain"):FindFirstChildOfClass("Clouds") then
                game:GetService("Workspace"):WaitForChild("Terrain"):FindFirstChildOfClass("Clouds").Cover = lightingtbl.oldclouds.Cover
                game:GetService("Workspace"):WaitForChild("Terrain"):FindFirstChildOfClass("Clouds").Density = lightingtbl.oldclouds.Density
                game:GetService("Workspace"):WaitForChild("Terrain"):FindFirstChildOfClass("Clouds").Color = lightingtbl.oldclouds.Color
                game:GetService("Workspace"):WaitForChild("Terrain"):FindFirstChildOfClass("Clouds").Enabled = lightingtbl.oldclouds.Enabled
            end
        end
    })

    cloudstab:AddDivider("properties")

    cloudstab:AddToggle('cloudsenabled',{
        Default = lightingtbl.oldclouds.Enabled,
        Text = "Enabled",
        Callback = function(v)
            lightingtbl.oldclouds.Enabled = v

            if lightingtbl.cloudsoverride and game:GetService("Workspace"):WaitForChild("Terrain"):FindFirstChildOfClass("Clouds") then
                game:GetService("Workspace"):WaitForChild("Terrain"):FindFirstChildOfClass("Clouds").Enabled = v
            end
        end
    })

    cloudstab:AddSlider('cloudscover',{
        Min = 0,
        Max = 1,
        Rounding = 3,
        Default = lightingtbl.oldclouds.Cover,
        Compact = true,
        Text = "Cover",
        Callback = function(v) 
            lightingtbl.newclouds.Cover = v

            if lightingtbl.cloudsoverride and game:GetService("Workspace"):WaitForChild("Terrain"):FindFirstChildOfClass("Clouds") then
                game:GetService("Workspace"):WaitForChild("Terrain"):FindFirstChildOfClass("Clouds").Cover = v
            end
        end
    })

    cloudstab:AddSlider('cloudsdensity',{
        Min = 0,
        Max = 1,
        Rounding = 3,
        Default = lightingtbl.oldclouds.Density,
        Compact = true,
        Text = "Density",
        Callback = function(v) 
            lightingtbl.newclouds.Density = v

            if lightingtbl.cloudsoverride and game:GetService("Workspace"):WaitForChild("Terrain"):FindFirstChildOfClass("Clouds") then
                game:GetService("Workspace"):WaitForChild("Terrain"):FindFirstChildOfClass("Clouds").Density = v
            end
        end
    })

    cloudstab:AddLabel('Color'):AddColorPicker('cloudscolor',{
        Title = "Color",
        Default = lightingtbl.oldclouds.Color,
        Callback = function(v)
            lightingtbl.oldclouds.Color = v

            if lightingtbl.cloudsoverride and game:GetService("Workspace"):WaitForChild("Terrain"):FindFirstChildOfClass("Clouds") then
                game:GetService("Workspace"):WaitForChild("Terrain"):FindFirstChildOfClass("Clouds").Color = v
            end
        end
    })

    cloudstab:AddDivider("reset")

    cloudsreset = cloudstab:AddButton({
        Text = "reset",
        Func = function()
            library.Options.cloudsenabled:SetValue(lightingtbl.oldclouds.Enabled)
            library.Options.cloudscover:SetValue(lightingtbl.oldclouds.Cover)
            library.Options.cloudsdensity:SetValue(lightingtbl.oldclouds.Density)
            library.Options.cloudscolor:SetValue(lightingtbl.oldclouds.Color)
        end,
        DoubleClick = false,
        Visible = true
    })
end

cons.viewmodelgetcon = camera.ChildAdded:Connect(function(v)
    if v.Name == "Viewmodel" then
        viewmodel.currentviewmodel = v

        if viewmodel.override and viewmodel.currentviewmodel then
            viewmodel.currentviewmodel["Left Arm"].Color = viewmodel.armcolor
            viewmodel.currentviewmodel["Right Arm"].Color = viewmodel.armcolor
            viewmodel.currentviewmodel["Left Arm"].Transparency = viewmodel.armtransparency
            viewmodel.currentviewmodel["Right Arm"].Transparency = viewmodel.armtransparency
            viewmodel.currentviewmodel["Left Arm"].Material = viewmodel.armmaterial
            viewmodel.currentviewmodel["Right Arm"].Material = viewmodel.armmaterial
        end
    end
end)

cons.espcon = game:GetService("RunService").RenderStepped:Connect(function()
    if not modules.matchcontroller.CurrentMatch then return end
    if os.clock() - misctbl.lastupdate < 0.25 then return end
    misctbl.lastupdate = os.clock()
    updatehighlights()
end)

cons.viewmodelremovecon = camera.ChildRemoved:Connect(function(v)
    if v.Name == "Viewmodel" then
        viewmodel.currentviewmodel = nil
    end
end)

cons.lightingcon = lighting.Changed:Connect(function(v)
    if lightingtbl.oldlighting[v] == nil then return end

    local current = lighting[v]
    local new = lightingtbl.newlighting[v]
    local same = valuecheck(v, current, new)

    if not same then
        lightingtbl.oldlighting[v] = current
    end

    if lightingtbl.lightingoverride and new ~= nil and not same then
        lighting[v] = new
    end
end)

cons.cloudcon = game:GetService("Workspace"):FindFirstChild("Terrain").ChildAdded:Connect(function(v)
    if v:IsA("Clouds") then
        lightingtbl.oldclouds.Color = v.Color
        lightingtbl.oldclouds.Cover = v.Cover
        lightingtbl.oldclouds.Density = v.Density
        lightingtbl.oldclouds.Enabled = v.Enabled

        if lightingtbl.cloudsoverride and v then
            v.Color = lightingtbl.oldclouds.Color
            v.Cover = lightingtbl.oldclouds.Cover
            v.Density = lightingtbl.oldclouds.Density
            v.Enabled = lightingtbl.oldclouds.Enabled
        end
    end
end)

cons.lightingchildrencon = lighting.ChildAdded:Connect(function(v)
    if v:IsA("BloomEffect") then
        lightingtbl.oldbloom.Enabled = v.Enabled
        lightingtbl.oldbloom.Intensity = v.Intensity
        lightingtbl.oldbloom.Size = v.Size
        lightingtbl.oldbloom.Threshold = v.Threshold

        if lightingtbl.bloomoverride and v then
            v.Enabled = lightingtbl.newbloom.Enabled
            v.Intensity = lightingtbl.newbloom.Intensity
            v.Size = lightingtbl.newbloom.Size
            v.Threshold = lightingtbl.newbloom.Threshold
        end
    end

    if v:IsA("SunRaysEffect") then
        lightingtbl.oldsunrays.Enabled = v.Enabled
        lightingtbl.oldsunrays.Intensity = v.Intensity
        lightingtbl.oldsunrays.Spread = v.Spread

        if lightingtbl.sunraysoverride and v then
            v.Enabled = lightingtbl.newsunrays.Enabled
            v.Intensity = lightingtbl.newsunrays.Intensity
            v.Spread = lightingtbl.newsunrays.Spread
        end
    end

    if v:IsA("ColorCorrectionEffect") then
        lightingtbl.oldcolorcorrection.Enabled = v.Enabled
        lightingtbl.oldcolorcorrection.Brightness = v.Brightness
        lightingtbl.oldcolorcorrection.Contrast = v.Contrast
        lightingtbl.oldcolorcorrection.Saturation = v.Saturation
        lightingtbl.oldcolorcorrection.TintColor = v.TintColor

        if lightingtbl.colorcorrectionoverride and v then
            v.Enabled = lightingtbl.newcolorcorrection.Enabled
            v.Brightness = lightingtbl.newcolorcorrection.Brightness
            v.Contrast = lightingtbl.newcolorcorrection.Contrast
            v.Saturation = lightingtbl.newcolorcorrection.Saturation
            v.TintColor = lightingtbl.newcolorcorrection.TintColor
        end
    end

    if v:IsA("Atmosphere") then
        lightingtbl.oldatmosphere.Density = v.Density
        lightingtbl.oldatmosphere.Offset = v.Offset
        lightingtbl.oldatmosphere.Color = v.Color
        lightingtbl.oldatmosphere.Decay = v.Decay
        lightingtbl.oldatmosphere.Glare = v.Glare
        lightingtbl.oldatmosphere.Haze = v.Haze

        if lightingtbl.atmosphereoverride and v then
            v.Density = lightingtbl.newatmosphere.Density
            v.Offset = lightingtbl.newatmosphere.Offset
            v.Color = lightingtbl.newatmosphere.Color
            v.Decay = lightingtbl.newatmosphere.Decay
            v.Glare = lightingtbl.newatmosphere.Glare
            v.Haze = lightingtbl.newatmosphere.Haze
        end
    end

    if v:IsA("Sky") then
        lightingtbl.oldskybox.SkyboxBk = v.SkyboxBk
        lightingtbl.oldskybox.SkyboxDn = v.SkyboxDn
        lightingtbl.oldskybox.SkyboxFt = v.SkyboxFt
        lightingtbl.oldskybox.SkyboxLf = v.SkyboxLf
        lightingtbl.oldskybox.SkyboxRt = v.SkyboxRt
        lightingtbl.oldskybox.SkyboxUp = v.SkyboxUp
        lightingtbl.oldskybox.MoonAngularSize = v.MoonAngularSize
        lightingtbl.oldskybox.SunAngularSize = v.SunAngularSize
        lightingtbl.oldskybox.StarCount = v.StarCount
        lightingtbl.oldskybox.SunTextureId = v.SunTextureId
        lightingtbl.oldskybox.MoonTextureId = v.MoonTextureId
        lightingtbl.oldskybox.CelestialBodiesShown = v.CelestialBodiesShown

        if lightingtbl.skyboxoverride and v then
            v.SkyboxBk = lightingtbl.newskybox.SkyboxBk
            v.SkyboxDn = lightingtbl.newskybox.SkyboxDn
            v.SkyboxFt = lightingtbl.newskybox.SkyboxFt
            v.SkyboxLf = lightingtbl.newskybox.SkyboxLf
            v.SkyboxRt = lightingtbl.newskybox.SkyboxRt
            v.SkyboxUp = lightingtbl.newskybox.SkyboxUp
            v.MoonAngularSize = lightingtbl.newskybox.MoonAngularSize
            v.SunAngularSize = lightingtbl.newskybox.SunAngularSize
            v.StarCount = lightingtbl.newskybox.StarCount
            v.SunTextureId = lightingtbl.newskybox.SunTextureId
            v.MoonTextureId = lightingtbl.newskybox.MoonTextureId
            v.CelestialBodiesShown = lightingtbl.newskybox.CelestialBodiesShown
        end
    end
end)

config:AddToggle("onteleport", { 
    Default = false, 
    Text = "Queue on Teleport", 
    Tooltip = "queues the script to execute on teleport",
    Callback = function(v) 
        if v then
            cons.teleportcon = localplayer.OnTeleport:Connect(function()
                if misctbl.executeamount < 1 then
                    queue_on_teleport([[
                        if not game:IsLoaded() then
                            game.Loaded:Wait()
                        end

                        local players = cloneref(game:GetService("Players"))
                        local LocalPlayer = players.LocalPlayer or players.PlayerAdded:Wait()
                        local modules = game:GetService("ReplicatedStorage"):WaitForChild("Modules", 30)

                        if modules then
                            local mainmodule = modules:WaitForChild("Main", 30)

                            if mainmodule then
                                local main = require(mainmodule)

                                while not main._initialized do
                                    task.wait()
                                end
                            end
                        end

                        loadstring(request({
                            Url = "https://raw.githubusercontent.com/osukfcdays/sniperduelshake/refs/heads/main/main.luau"
                        }).Body)()
                    ]])
                    misctbl.executeamount = misctbl.executeamount + 1
                end
            end)
        else
            if cons.teleportcon then
                cons.teleportcon:Disconnect()
                cons.teleportcon = nil
            end
        end
    end
})

config:AddToggle("staffdetector", {
    Default = false,
    Text = "Staff Detector",
    Tooltip = "notifies you when a staff member joins the game",
    Callback = function(v)
        if v then
            cons.staffdetectorcon = players.PlayerAdded:Connect(function(v)
                task.spawn(function()
                    if v and v.Parent then
                        local rank = v:GetRoleInGroup(35519398)

                        if rank == "Guest" then return end
                        if rank == "LOCKED IN" then return end

                        if rank then
                            local msg = "MODERATOR JOINED " .. "(" .. v.Name .. ", " .. rank ..") " .. "EXPECT TO GET RESOLVED!"

                            if msg then
                                library:Notify({
                                    Title = "STAFF DETECTED",
                                    Description = msg,
                                    Time = 5,
                                })
                            end
                        end
                    end
                end)
            end)

            task.spawn(function()
                for _,v in players:GetPlayers() do
                    if v and v.Parent then
                        local rank = v:GetRoleInGroup(35519398)

                        if rank == "Guest" then continue end
                        if rank == "LOCKED IN" then continue end

                        if rank then
                            local msg = "MODERATOR FOUND " .. "(" .. v.Name .. ", " .. rank ..") " .. "EXPECT TO GET RESOLVED!"

                            if msg then
                                library:Notify({
                                    Title = "STAFF DETECTED",
                                    Description = msg,
                                    Time = 5,
                                })
                            end
                        end
                    end
                end
            end)
        else
            if cons.staffdetectorcon then
                cons.staffdetectorcon:Disconnect()
                cons.staffdetectorcon = nil
            end
        end
    end
})

config:AddToggle("keybindlist", { 
    Default = false, 
    Text = "Keybind List", 
    Tooltip = "makes ui library keybind list visible",
    Callback = function(v) 
        library.KeybindFrame.Visible = v 
    end
})

config:AddLabel("Menu Keybind"):AddKeyPicker("menukeybind", { 
    Default = "Insert", 
    NoUI = true, 
    Text = "Menu Keybind" 
})

library.ToggleKeybind = library.Options.menukeybind

config:AddButton("Unload", function() library:Unload() end)

thememanager:SetLibrary(library)
savemanager:SetLibrary(library)
thememanager:SetFolder("sniperduelshake")
savemanager:SetFolder('sniperduelshake')
savemanager:BuildConfigSection(tabs.config)
thememanager:ApplyToTab(tabs.config)
savemanager:LoadAutoloadConfig()

library:OnUnload(function()
    runserv:UnbindFromRenderStep("firstpersoncframe")

    for i,v in cons do
        if v and cons[i] == cons.antiaimcon then
            cons[i]:Disconnect()
            cons[i] = nil

            if not modules.characterreplicationcontroller.SendingPackets and localplayer and localplayer.Character then
                task.spawn(function()
                    modules.characterreplicationcontroller.StartSending(modules.characterreplicationcontroller, localplayer.Character)
                end)

                local root = localplayer and localplayer.Character and localplayer.Character:FindFirstChild("HumanoidRootPart")
                local hum = localplayer and localplayer.Character and localplayer.Character:FindFirstChildOfClass("Humanoid")

                if root and hum then
                    root.AssemblyLinearVelocity = Vector3.zero
                    hum.AutoRotate = true
                end
            end
        elseif v then
            cons[i]:Disconnect()
            cons[i] = nil
        end
    end

    modules.crosshaircontroller.SetSpread = ogfuncs.ogspread
    modules.cameracontroller.Recoil = ogfuncs.ogrecoil
    modules.weaponcontroller.Aim = ogfuncs.ogaim
    modules.weaponcontroller.Equip = ogfuncs.ogweaponequip
    modules.meleecontroller.Equip = ogfuncs.ogmeleeequip
    modules.viewmodelcontroller.new = ogfuncs.ogviewmodel
    modules.charactercontroller.Run = ogfuncs.ogrun
    modules.effects.GunFiringSound = ogfuncs.ogfiringsound
    modules.effects.VisualizeBullet = ogfuncs.ogbullet
    modules.killeffectdefault.Apply = ogfuncs.ogapply
    modules.bufferutils.WriteUnitV3ToBuffer = ogfuncs.ogwriteunitv3
    modules.bufferutils.WriteCFrameToBufferSmall = ogfuncs.ogwritecframesmall
    modules.bufferutils.WriteCFrameToBuffer = ogfuncs.ogwritecframe
    modules.weaponcontroller.Fire = ogfuncs.ogfire
    modules.toolcontroller.ToolAdded = ogfuncs.ogtooladded
    modules.cameracontroller.ChangeFOVWithTag = ogfuncs.ogfovtag
    modules.uicontroller.Scope = ogfuncs.ogscope

    highlights:Destroy()

    if viewmodel.currentviewmodel then
        viewmodel.currentviewmodel["Left Arm"].Color = (localplayer and localplayer.Character["Left Arm"].Color) or Color3.fromRGB(255, 255, 255)
        viewmodel.currentviewmodel["Right Arm"].Color = (localplayer and localplayer.Character["Right Arm"].Color) or Color3.fromRGB(255, 255, 255)
        viewmodel.currentviewmodel["Left Arm"].Transparency = 0
        viewmodel.currentviewmodel["Right Arm"].Transparency = 0
        viewmodel.currentviewmodel["Left Arm"].Material = Enum.Material.Plastic
        viewmodel.currentviewmodel["Right Arm"].Material = Enum.Material.Plastic

        modules.viewmodelcontroller.activeViewmodel.offset = CFrame.new(0.1, -1.5, 0.15)
    end

    if lightingtbl.lightingoverride then 
        lighting.Ambient = lightingtbl.oldlighting.Ambient
        lighting.OutdoorAmbient = lightingtbl.oldlighting.OutdoorAmbient
        lighting.Brightness = lightingtbl.oldlighting.Brightness
        lighting.ClockTime = lightingtbl.oldlighting.ClockTime
        lighting.FogColor = lightingtbl.oldlighting.FogColor
        lighting.FogStart = lightingtbl.oldlighting.FogStart
        lighting.FogEnd = lightingtbl.oldlighting.FogEnd
        lighting.GlobalShadows = lightingtbl.oldlighting.GlobalShadows
        lighting.ColorShift_Top = lightingtbl.oldlighting.ColorShift_Top
        lighting.ColorShift_Bottom = lightingtbl.oldlighting.ColorShift_Bottom
        lighting.EnvironmentDiffuseScale = lightingtbl.oldlighting.EnvironmentDiffuseScale
        lighting.EnvironmentSpecularScale = lightingtbl.oldlighting.EnvironmentSpecularScale
        lighting.ShadowSoftness = lightingtbl.oldlighting.ShadowSoftness
    end

    if lightingtbl.cloudsoverride and game:GetService("Workspace"):WaitForChild("Terrain"):FindFirstChildOfClass("Clouds") then
        game:GetService("Workspace"):WaitForChild("Terrain"):FindFirstChildOfClass("Clouds").Cover = lightingtbl.oldclouds.Cover
        game:GetService("Workspace"):WaitForChild("Terrain"):FindFirstChildOfClass("Clouds").Density = lightingtbl.oldclouds.Density
        game:GetService("Workspace"):WaitForChild("Terrain"):FindFirstChildOfClass("Clouds").Color = lightingtbl.oldclouds.Color
        game:GetService("Workspace"):WaitForChild("Terrain"):FindFirstChildOfClass("Clouds").Enabled = lightingtbl.oldclouds.Enabled
    end
    
    if lightingtbl.bloomoverride and lighting:FindFirstChildOfClass("BloomEffect") then
        lighting:FindFirstChildOfClass("BloomEffect").Enabled = lightingtbl.oldbloom.Enabled
        lighting:FindFirstChildOfClass("BloomEffect").Intensity = lightingtbl.oldbloom.Intensity
        lighting:FindFirstChildOfClass("BloomEffect").Size = lightingtbl.oldbloom.Size
        lighting:FindFirstChildOfClass("BloomEffect").Threshold = lightingtbl.oldbloom.Threshold
    end

    if lightingtbl.atmosphereoverride and lighting:FindFirstChildOfClass("Atmosphere") then
        lighting:FindFirstChildOfClass("Atmosphere").Density = lightingtbl.oldatmosphere.Density
        lighting:FindFirstChildOfClass("Atmosphere").Offset = lightingtbl.oldatmosphere.Offset
        lighting:FindFirstChildOfClass("Atmosphere").Color = lightingtbl.oldatmosphere.Color
        lighting:FindFirstChildOfClass("Atmosphere").Decay = lightingtbl.oldatmosphere.Decay
        lighting:FindFirstChildOfClass("Atmosphere").Haze = lightingtbl.oldatmosphere.Haze
        lighting:FindFirstChildOfClass("Atmosphere").Glare = lightingtbl.oldatmosphere.Glare
    end

    if lightingtbl.colorcorrectionoverride and lighting:FindFirstChildOfClass("ColorCorrectionEffect") then
        lighting:FindFirstChildOfClass("ColorCorrectionEffect").Brightness = lightingtbl.oldcolorcorrection.Brightness
        lighting:FindFirstChildOfClass("ColorCorrectionEffect").Contrast = lightingtbl.oldcolorcorrection.Contrast
        lighting:FindFirstChildOfClass("ColorCorrectionEffect").Saturation = lightingtbl.oldcolorcorrection.Saturation
        lighting:FindFirstChildOfClass("ColorCorrectionEffect").TintColor = lightingtbl.oldcolorcorrection.TintColor
        lighting:FindFirstChildOfClass("ColorCorrectionEffect").Enabled = lightingtbl.oldcolorcorrection.Enabled
    end

    if lightingtbl.sunraysoverride and lighting:FindFirstChildOfClass("SunRaysEffect") then
        lighting:FindFirstChildOfClass("SunRaysEffect").Enabled = lightingtbl.oldsunrays.Enabled
        lighting:FindFirstChildOfClass("SunRaysEffect").Intensity = lightingtbl.oldsunrays.Intensity
        lighting:FindFirstChildOfClass("SunRaysEffect").Spread = lightingtbl.oldsunrays.Spread
    end

    if lightingtbl.skyboxoverride and lighting:FindFirstChildOfClass("Sky") then
        lighting:FindFirstChildOfClass("Sky").SkyboxBk = lightingtbl.oldskybox.SkyboxBk
        lighting:FindFirstChildOfClass("Sky").SkyboxDn = lightingtbl.oldskybox.SkyboxDn
        lighting:FindFirstChildOfClass("Sky").SkyboxFt = lightingtbl.oldskybox.SkyboxFt
        lighting:FindFirstChildOfClass("Sky").SkyboxLf = lightingtbl.oldskybox.SkyboxLf
        lighting:FindFirstChildOfClass("Sky").SkyboxRt = lightingtbl.oldskybox.SkyboxRt
        lighting:FindFirstChildOfClass("Sky").SkyboxUp = lightingtbl.oldskybox.SkyboxUp
        lighting:FindFirstChildOfClass("Sky").MoonAngularSize = lightingtbl.oldskybox.MoonAngularSize
        lighting:FindFirstChildOfClass("Sky").SunAngularSize = lightingtbl.oldskybox.SunAngularSize
        lighting:FindFirstChildOfClass("Sky").StarCount = lightingtbl.oldskybox.StarCount
        lighting:FindFirstChildOfClass("Sky").SunTextureId = lightingtbl.oldskybox.SunTextureId
        lighting:FindFirstChildOfClass("Sky").MoonTextureId = lightingtbl.oldskybox.MoonTextureId
        lighting:FindFirstChildOfClass("Sky").CelestialBodiesShown = lightingtbl.oldskybox.CelestialBodiesShown
    end

    if devicetbl.ogplatform == 1 then
        setplatform("Desktop")
    elseif devicetbl.ogplatform == 2 then
        setplatform("Mobile")
    elseif devicetbl.ogplatform == 3 then
        setplatform("Console")
    end

    game:GetService("SoundService"):FindFirstChild("Game"):WaitForChild("Local"):WaitForChild("Hitmarker"):WaitForChild("Kill").SoundId = oghitsounds.hitsound
    game:GetService("SoundService"):FindFirstChild("Game"):WaitForChild("Local"):WaitForChild("Hitmarker"):WaitForChild("Hitmarker").SoundId = oghitsounds.hitmarker
    game:GetService("SoundService"):FindFirstChild("Game"):WaitForChild("Local"):WaitForChild("Hitmarker"):WaitForChild("Kill").Volume = oghitsounds.hitsoundvolume
    game:GetService("SoundService"):FindFirstChild("Game"):WaitForChild("Local"):WaitForChild("Hitmarker"):WaitForChild("Hitmarker").Volume = oghitsounds.hitmarkervolume
    game:GetService("SoundService"):FindFirstChild("Game"):WaitForChild("Local"):WaitForChild("Hitmarker"):WaitForChild("HeadshotKill").SoundId = oghitsounds.headshot
    game:GetService("SoundService"):FindFirstChild("Game"):WaitForChild("Local"):WaitForChild("Hitmarker"):WaitForChild("HeadshotKill").Volume = oghitsounds.headshotvolume
    game:GetService("SoundService"):FindFirstChild("Game"):WaitForChild("Local"):WaitForChild("Hitmarker"):WaitForChild("HeadshotKill"):SetAttribute("og_vol", oghitsounds.headshotvolume)
    game:GetService("SoundService"):FindFirstChild("Game"):WaitForChild("Local"):WaitForChild("Hitmarker"):WaitForChild("Kill"):SetAttribute("og_vol", oghitsounds.hitsoundvolume)
    game:GetService("SoundService"):FindFirstChild("Game"):WaitForChild("Local"):WaitForChild("Hitmarker"):WaitForChild("Hitmarker"):SetAttribute("og_vol", oghitsounds.hitmarkervolume)

    library.Unloaded = true
end)
