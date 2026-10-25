--============================================================
--  Visual Hub v1 - Obsidian Library
--============================================================

-- サービス
local RunService = game:GetService("RunService")
local Players    = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- 前回の残骸をクリーンアップ
for _, n in ipairs({"CoolHubHalo","CoolHubAmbientAura","CoolHubAngelWings","CoolHubTrail"}) do
    local f = Workspace:FindFirstChild(n)
    if f then f:Destroy() end
end

--============================================================
--  ライブラリ読み込み
--============================================================
local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library       = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager  = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager   = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

local Options = Library.Options
local Toggles = Library.Toggles

--============================================================
--  ウィンドウ & タブ
--============================================================
local Window = Library:CreateWindow({
    Title = "Visual Hub v1",
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2,
})

local Tabs = {
    Main = Window:AddTab("メイン"),
    FX   = Window:AddTab("特殊効果"),
    ["UI Settings"] = Window:AddTab("UI設定"),
}

--============================================================
--  §11.5. 特殊効果設定
--============================================================
local 特殊効果設定 = {
    輪の発生量 = 30, 輪の色 = Color3.fromRGB(255, 215, 0), 輪の明るさ = 2,
    輪のX位置 = 0, 輪のY位置 = 0, 輪のZ位置 = 0,
    オーラの色 = Color3.fromRGB(180, 100, 255),
    オーラのX位置 = 0, オーラのY位置 = 0, オーラのZ位置 = 0,
    翼の発生量 = 20, 翼の色 = Color3.fromRGB(220, 240, 255), 翼の明るさ = 2,
    翼のX位置 = 0, 翼のY位置 = 0,
    軌跡の色 = Color3.fromRGB(0, 255, 255), 軌跡の持続時間 = 0.5,
    レインボー有効 = false, レインボー速度 = 0.5,
    輪にレインボー = true, オーラにレインボー = true,
    翼にレインボー = true, 軌跡にレインボー = true,
    輪有効 = false, オーラ有効 = false, 翼有効 = false, 軌跡有効 = false,
}
local レインボー状態 = { 色相 = 0 }

--============================================================
--  天使の輪
--============================================================
local 輪フォルダ = Instance.new("Folder")
輪フォルダ.Name = "CoolHubHalo"
輪フォルダ.Parent = Workspace

local 輪パーツ = Instance.new("Part")
輪パーツ.Size = Vector3.new(2, 1, 1)
輪パーツ.Material = Enum.Material.ForceField
輪パーツ.Anchored = true
輪パーツ.CanCollide = false
輪パーツ.Transparency = 1
輪パーツ.Parent = 輪フォルダ

local 輪アタッチメント = Instance.new("Attachment")
輪アタッチメント.CFrame = CFrame.new(-0.25, 0.93, 0.25, 0.4689, -0.2499, -0.8471, -0.1171, 0.933, -0.3401, 0.8754, 0.2587, 0.4082)
輪アタッチメント.Visible = false
輪アタッチメント.Parent = 輪パーツ

local function 輪リング作成(サイズ, 名前)
    local p = Instance.new("ParticleEmitter")
    p.Name = 名前
    p.Texture = "rbxassetid://8819682608"
    p.Rate = 特殊効果設定.輪の発生量
    p.Lifetime = NumberRange.new(1, 1)
    p.Speed = NumberRange.new(0.001, 0.001)
    p.RotSpeed = NumberRange.new(-400, 400)
    p.Rotation = NumberRange.new(0, 360)
    p.Size = サイズ
    p.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.2, 0),
        NumberSequenceKeypoint.new(0.8, 0),
        NumberSequenceKeypoint.new(1, 1),
    })
    p.Color = ColorSequence.new(特殊効果設定.輪の色)
    p.LightEmission = 1
    p.Brightness = 特殊効果設定.輪の明るさ
    p.SpreadAngle = Vector2.new(5, 5)
    p.LockedToPart = true
    p.Shape = Enum.ParticleEmitterShape.Box
    p.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume
    p.ShapeInOut = Enum.ParticleEmitterShapeInOut.Outward
    p.Orientation = Enum.ParticleOrientation.VelocityPerpendicular
    p.Parent = 輪アタッチメント
    return p
end

local 輪リング1 = 輪リング作成(NumberSequence.new({NumberSequenceKeypoint.new(0, 2.5), NumberSequenceKeypoint.new(1, 3)}), "Ring1")
local 輪リング2 = 輪リング作成(NumberSequence.new({NumberSequenceKeypoint.new(0, 2), NumberSequenceKeypoint.new(1, 3)}), "Ring2")

local function 輪を有効化(v) 輪リング1.Enabled = v; 輪リング2.Enabled = v end
local function 輪の色を更新(c) 輪リング1.Color = ColorSequence.new(c); 輪リング2.Color = ColorSequence.new(c) end
local function 輪の発生量を更新(n) 輪リング1.Rate = n; 輪リング2.Rate = n end
local function 輪の明るさを更新(n) 輪リング1.Brightness = n; 輪リング2.Brightness = n end

--============================================================
--  オーラ
--============================================================
local オーラフォルダ = Instance.new("Folder")
オーラフォルダ.Name = "CoolHubAmbientAura"
オーラフォルダ.Parent = Workspace

local オーラパーツ = Instance.new("Part")
オーラパーツ.Size = Vector3.new(2, 2, 1)
オーラパーツ.Transparency = 1
オーラパーツ.Anchored = true
オーラパーツ.CanCollide = false
オーラパーツ.Massless = true
オーラパーツ.Parent = オーラフォルダ

local function オーラ作成(設定)
    local p = Instance.new("ParticleEmitter")
    for k, v in pairs(設定) do p[k] = v end
    p.Parent = オーラパーツ
    return p
end

local オーラ1 = オーラ作成({
    Name = "Ambient2", Texture = "rbxassetid://12713358087", Rate = 20,
    Lifetime = NumberRange.new(2, 2), Speed = NumberRange.new(0.001, 0.001),
    RotSpeed = NumberRange.new(-600, 600), Rotation = NumberRange.new(0, 360),
    Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.3, 1), NumberSequenceKeypoint.new(0.6, 2.5), NumberSequenceKeypoint.new(0.8, 4), NumberSequenceKeypoint.new(1, 6)}),
    Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1)}),
    Color = ColorSequence.new(特殊効果設定.オーラの色), LightEmission = 1, Brightness = 2,
    LockedToPart = true, EmissionDirection = Enum.NormalId.Top,
    Shape = Enum.ParticleEmitterShape.Box, ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume,
    ShapeInOut = Enum.ParticleEmitterShapeInOut.Outward, Orientation = Enum.ParticleOrientation.VelocityPerpendicular,
})
local オーラ2 = オーラ作成({
    Name = "Stars", Texture = "rbxassetid://7216849325", Rate = 20,
    Lifetime = NumberRange.new(2, 2), Speed = NumberRange.new(0.001, 0.001),
    RotSpeed = NumberRange.new(-30, 30), Rotation = NumberRange.new(0, 360),
    Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.3, 1), NumberSequenceKeypoint.new(0.6, 2.5), NumberSequenceKeypoint.new(0.8, 4), NumberSequenceKeypoint.new(1, 6)}),
    Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.6, 0.2), NumberSequenceKeypoint.new(1, 1)}),
    Color = ColorSequence.new(特殊効果設定.オーラの色), LightEmission = 1, Brightness = 2,
    LockedToPart = true, EmissionDirection = Enum.NormalId.Top,
    Shape = Enum.ParticleEmitterShape.Box, ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume,
    ShapeInOut = Enum.ParticleEmitterShapeInOut.Outward, Orientation = Enum.ParticleOrientation.VelocityPerpendicular,
})
local オーラ3 = オーラ作成({
    Name = "Ambient1", Texture = "rbxassetid://7216855136", Rate = 20,
    Lifetime = NumberRange.new(2, 2), Speed = NumberRange.new(0.001, 0.001),
    RotSpeed = NumberRange.new(-40, 40), Rotation = NumberRange.new(0, 360),
    Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.3, 2), NumberSequenceKeypoint.new(0.6, 5), NumberSequenceKeypoint.new(0.8, 8), NumberSequenceKeypoint.new(1, 12)}),
    Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.2, 0.3), NumberSequenceKeypoint.new(1, 1)}),
    Color = ColorSequence.new(特殊効果設定.オーラの色), LightEmission = 1, Brightness = 2,
    LockedToPart = true, EmissionDirection = Enum.NormalId.Top,
    Shape = Enum.ParticleEmitterShape.Box, ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume,
    ShapeInOut = Enum.ParticleEmitterShapeInOut.Outward, Orientation = Enum.ParticleOrientation.VelocityPerpendicular,
})

local オーラリスト = { オーラ1, オーラ2, オーラ3 }
local function オーラを有効化(v) for _, p in ipairs(オーラリスト) do p.Enabled = v end end
local function オーラの色を更新(c) for _, p in ipairs(オーラリスト) do p.Color = ColorSequence.new(c) end end
local function オーラの発生量を更新(n) for _, p in ipairs(オーラリスト) do p.Rate = n end end
local function オーラの明るさを更新(n) for _, p in ipairs(オーラリスト) do p.Brightness = n end end

--============================================================
--  天使の翼
--============================================================
local 翼フォルダ = Instance.new("Folder")
翼フォルダ.Name = "CoolHubAngelWings"
翼フォルダ.Parent = Workspace

local 翼パーツ = Instance.new("Part")
翼パーツ.Size = Vector3.new(2, 2, 1)
翼パーツ.Material = Enum.Material.ForceField
翼パーツ.Anchored = true
翼パーツ.CanCollide = false
翼パーツ.Transparency = 1
翼パーツ.Parent = 翼フォルダ

local 翼アタッチ左 = Instance.new("Attachment")
翼アタッチ左.CFrame = CFrame.new(-1.012, 0.5, 0.852) * CFrame.Angles(0, 0.26179938779914941, 0)
翼アタッチ左.Parent = 翼パーツ

local 翼アタッチ右 = Instance.new("Attachment")
翼アタッチ右.CFrame = CFrame.new(1.167, 0.5, 0.852) * CFrame.Angles(0, -0.26179938779914941, 0)
翼アタッチ右.Parent = 翼パーツ

local function 翼パーティクル作成(親, 方向)
    local p = Instance.new("ParticleEmitter")
    p.Texture = "http://www.roblox.com/asset/?id=13267054240"
    p.Rate = 特殊効果設定.翼の発生量
    p.Lifetime = NumberRange.new(1, 1)
    p.Speed = NumberRange.new(0.05, 0.05)
    p.RotSpeed = NumberRange.new(0, 0)
    p.Rotation = NumberRange.new(-15, -15)
    p.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 2.75), NumberSequenceKeypoint.new(1, 3.5)})
    p.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.944),
        NumberSequenceKeypoint.new(0.2, 0),
        NumberSequenceKeypoint.new(0.8, 0),
        NumberSequenceKeypoint.new(1, 1),
    })
    p.Color = ColorSequence.new(特殊効果設定.翼の色)
    p.LightEmission = 1
    p.Brightness = 特殊効果設定.翼の明るさ
    p.LockedToPart = true
    p.Shape = Enum.ParticleEmitterShape.Box
    p.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume
    p.ShapeInOut = Enum.ParticleEmitterShapeInOut.Outward
    p.Orientation = Enum.ParticleOrientation.VelocityPerpendicular
    p.EmissionDirection = 方向
    p.SpreadAngle = Vector2.new(0, 0)
    p.VelocitySpread = 0
    p.Parent = 親
    return p
end
local 翼左 = 翼パーティクル作成(翼アタッチ左, Enum.NormalId.Back)
local 翼右 = 翼パーティクル作成(翼アタッチ右, Enum.NormalId.Front)

local function 翼を有効化(v) 翼左.Enabled = v; 翼右.Enabled = v end
local function 翼の色を更新(c) 翼左.Color = ColorSequence.new(c); 翼右.Color = ColorSequence.new(c) end
local function 翼の発生量を更新(n) 翼左.Rate = n; 翼右.Rate = n end
local function 翼の明るさを更新(n) 翼左.Brightness = n; 翼右.Brightness = n end

--============================================================
--  軌跡
--============================================================
local 軌跡フォルダ = Instance.new("Folder")
軌跡フォルダ.Name = "CoolHubTrail"
軌跡フォルダ.Parent = Workspace

local 軌跡パーツ = Instance.new("Part")
軌跡パーツ.Size = Vector3.new(0.1, 0.1, 0.1)
軌跡パーツ.Transparency = 1
軌跡パーツ.Anchored = true
軌跡パーツ.CanCollide = false
軌跡パーツ.Massless = true
軌跡パーツ.Parent = 軌跡フォルダ

local 軌跡アタッチ上 = Instance.new("Attachment")
軌跡アタッチ上.Position = Vector3.new(0, 0.5, 0)
軌跡アタッチ上.Parent = 軌跡パーツ

local 軌跡アタッチ下 = Instance.new("Attachment")
軌跡アタッチ下.Position = Vector3.new(0, -0.5, 0)
軌跡アタッチ下.Parent = 軌跡パーツ

local 軌跡 = Instance.new("Trail")
軌跡.Attachment0 = 軌跡アタッチ上
軌跡.Attachment1 = 軌跡アタッチ下
軌跡.Lifetime = 特殊効果設定.軌跡の持続時間
軌跡.MinLength = 0.01
軌跡.FaceCamera = true
軌跡.LightEmission = 1
軌跡.LightInfluence = 0
軌跡.Brightness = 2
軌跡.WidthScale = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 1),
    NumberSequenceKeypoint.new(0.4, 0.6),
    NumberSequenceKeypoint.new(0.7, 0.25),
    NumberSequenceKeypoint.new(1, 0),
})
軌跡.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0),
    NumberSequenceKeypoint.new(0.5, 0.1),
    NumberSequenceKeypoint.new(0.8, 0.5),
    NumberSequenceKeypoint.new(1, 1),
})
軌跡.Color = ColorSequence.new(特殊効果設定.軌跡の色)
軌跡.Parent = 軌跡パーツ

local function 軌跡を有効化(v) 軌跡.Enabled = v end
local function 軌跡の色を更新(c) 軌跡.Color = ColorSequence.new(c) end
local function 軌跡の幅を更新(幅)
    軌跡.WidthScale = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.4, 0.6 * 幅 / 1.5),
        NumberSequenceKeypoint.new(0.7, 0.25 * 幅 / 1.5),
        NumberSequenceKeypoint.new(1, 0),
    })
    軌跡アタッチ上.Position = Vector3.new(0, 幅 / 2, 0)
    軌跡アタッチ下.Position = Vector3.new(0, -幅 / 2, 0)
end
local function 軌跡の持続時間を更新(時間) 軌跡.Lifetime = 時間 end

輪を有効化(false)
オーラを有効化(false)
翼を有効化(false)
軌跡を有効化(false)

--============================================================
--  位置更新 + レインボー
--============================================================
RunService.RenderStepped:Connect(function(差分時間)
    if 特殊効果設定.レインボー有効 then
        レインボー状態.色相 = (レインボー状態.色相 + 特殊効果設定.レインボー速度 * 差分時間) % 1
    end
    local レインボー色 = Color3.fromHSV(レインボー状態.色相, 0.85, 1)
    local キャラ = LocalPlayer.Character
    if not キャラ then return end
    local 頭 = キャラ:FindFirstChild("Head")
    local ルートパーツ = キャラ:FindFirstChild("HumanoidRootPart")
    if not (頭 and ルートパーツ) then return end

    if 特殊効果設定.輪有効 then
        輪パーツ.CFrame = CFrame.new(
            頭.Position.X + 特殊効果設定.輪のX位置,
            頭.Position.Y + 特殊効果設定.輪のY位置,
            頭.Position.Z + 特殊効果設定.輪のZ位置
        )
        if 特殊効果設定.レインボー有効 and 特殊効果設定.輪にレインボー then
            輪の色を更新(レインボー色)
        else
            輪の色を更新(特殊効果設定.輪の色)
        end
    end
    if 特殊効果設定.オーラ有効 then
        オーラパーツ.CFrame = CFrame.new(
            ルートパーツ.Position.X + 特殊効果設定.オーラのX位置,
            ルートパーツ.Position.Y + 特殊効果設定.オーラのY位置,
            ルートパーツ.Position.Z + 特殊効果設定.オーラのZ位置
        )
        if 特殊効果設定.レインボー有効 and 特殊効果設定.オーラにレインボー then
            オーラの色を更新(レインボー色)
        else
            オーラの色を更新(特殊効果設定.オーラの色)
        end
    end
    if 特殊効果設定.翼有効 then
        翼パーツ.CFrame = ルートパーツ.CFrame * CFrame.new(特殊効果設定.翼のX位置, 特殊効果設定.翼のY位置, 0)
        if 特殊効果設定.レインボー有効 and 特殊効果設定.翼にレインボー then
            翼の色を更新(レインボー色)
        else
            翼の色を更新(特殊効果設定.翼の色)
        end
    end
    if 特殊効果設定.軌跡有効 then
        軌跡パーツ.CFrame = ルートパーツ.CFrame
        if 特殊効果設定.レインボー有効 and 特殊効果設定.軌跡にレインボー then
            軌跡の色を更新(レインボー色)
        else
            軌跡の色を更新(特殊効果設定.軌跡の色)
        end
    end
end)

--============================================================
--  メインタブ
--============================================================
local メイングループ = Tabs.Main:AddLeftGroupbox("基本")

メイングループ:AddButton("通知を表示", function()
    Library:Notify("Visual Hub v1 へようこそ！", 3)
end)

--============================================================
--  特殊効果タブ UI
--============================================================
local 輪グループ         = Tabs.FX:AddLeftGroupbox("天使の輪")
local オーラグループ     = Tabs.FX:AddRightGroupbox("オーラ")
local 翼グループ         = Tabs.FX:AddLeftGroupbox("天使の翼")
local 軌跡グループ       = Tabs.FX:AddRightGroupbox("軌跡")
local レインボーグループ = Tabs.FX:AddLeftGroupbox("レインボー")

-- 天使の輪
輪グループ:AddToggle("輪トグル", {
    Text = "天使の輪",
    Default = false,
    Tooltip = "頭の上に天使の輪を表示します",
    Callback = function(有効)
        特殊効果設定.輪有効 = 有効
        輪を有効化(有効)
    end
})
輪グループ:AddLabel("輪の色"):AddColorPicker("輪の色ピッカー", {
    Default = 特殊効果設定.輪の色,
    Callback = function(色) 特殊効果設定.輪の色 = 色; 輪の色を更新(色) end
})
輪グループ:AddSlider("輪の発生量", {
    Text = "発生量", Default = 30, Min = 1, Max = 100, Rounding = 0,
    Callback = function(量) 特殊効果設定.輪の発生量 = 量; 輪の発生量を更新(量) end
})
輪グループ:AddSlider("輪の明るさ", {
    Text = "明るさ", Default = 2, Min = 0, Max = 10, Rounding = 1,
    Callback = function(明るさ) 特殊効果設定.輪の明るさ = 明るさ; 輪の明るさを更新(明るさ) end
})

-- オーラ
オーラグループ:AddToggle("オーラトグル", {
    Text = "オーラ",
    Default = false,
    Tooltip = "体の周りにオーラを発生させます",
    Callback = function(有効)
        特殊効果設定.オーラ有効 = 有効
        オーラを有効化(有効)
    end
})
オーラグループ:AddLabel("オーラの色"):AddColorPicker("オーラの色ピッカー", {
    Default = 特殊効果設定.オーラの色,
    Callback = function(色) 特殊効果設定.オーラの色 = 色; オーラの色を更新(色) end
})
オーラグループ:AddSlider("オーラの発生量", {
    Text = "発生量", Default = 20, Min = 1, Max = 100, Rounding = 0,
    Callback = function(量) 特殊効果設定.オーラの発生量 = 量; オーラの発生量を更新(量) end
})
オーラグループ:AddSlider("オーラの明るさ", {
    Text = "明るさ", Default = 2, Min = 0, Max = 10, Rounding = 1,
    Callback = function(明るさ) 特殊効果設定.オーラの明るさ = 明るさ; オーラの明るさを更新(明るさ) end
})

-- 天使の翼
翼グループ:AddToggle("翼トグル", {
    Text = "天使の翼",
    Default = false,
    Tooltip = "背中に天使の翼を表示します",
    Callback = function(有効)
        特殊効果設定.翼有効 = 有効
        翼を有効化(有効)
    end
})
翼グループ:AddLabel("翼の色"):AddColorPicker("翼の色ピッカー", {
    Default = 特殊効果設定.翼の色,
    Callback = function(色) 特殊効果設定.翼の色 = 色; 翼の色を更新(色) end
})
翼グループ:AddSlider("翼の発生量", {
    Text = "発生量", Default = 20, Min = 1, Max = 100, Rounding = 0,
    Callback = function(量) 特殊効果設定.翼の発生量 = 量; 翼の発生量を更新(量) end
})
翼グループ:AddSlider("翼の明るさ", {
    Text = "明るさ", Default = 2, Min = 0, Max = 10, Rounding = 1,
    Callback = function(明るさ) 特殊効果設定.翼の明るさ = 明るさ; 翼の明るさを更新(明るさ) end
})

-- 軌跡
軌跡グループ:AddToggle("軌跡トグル", {
    Text = "軌跡",
    Default = false,
    Tooltip = "移動時に軌跡を描きます",
    Callback = function(有効)
        特殊効果設定.軌跡有効 = 有効
        軌跡を有効化(有効)
    end
})
軌跡グループ:AddLabel("軌跡の色"):AddColorPicker("軌跡の色ピッカー", {
    Default = 特殊効果設定.軌跡の色,
    Callback = function(色) 特殊効果設定.軌跡の色 = 色; 軌跡の色を更新(色) end
})
軌跡グループ:AddSlider("軌跡の幅", {
    Text = "幅", Default = 1, Min = 0.1, Max = 5, Rounding = 1,
    Callback = function(幅) 軌跡の幅を更新(幅) end
})
軌跡グループ:AddSlider("軌跡の持続時間", {
    Text = "持続時間", Default = 0.5, Min = 0.1, Max = 3, Rounding = 1,
    Callback = function(時間) 特殊効果設定.軌跡の持続時間 = 時間; 軌跡の持続時間を更新(時間) end
})

-- レインボー
レインボーグループ:AddToggle("レインボートグル", {
    Text = "レインボー",
    Default = false,
    Tooltip = "色を虹色に変化させます",
    Callback = function(有効) 特殊効果設定.レインボー有効 = 有効 end
})
レインボーグループ:AddSlider("レインボー速度", {
    Text = "変化速度", Default = 0.5, Min = 0.1, Max = 2, Rounding = 1,
    Callback = function(速度) 特殊効果設定.レインボー速度 = 速度 end
})
レインボーグループ:AddDivider()
レインボーグループ:AddToggle("輪にレインボー", {
    Text = "天使の輪に適用", Default = true,
    Callback = function(有効) 特殊効果設定.輪にレインボー = 有効 end
})
レインボーグループ:AddToggle("オーラにレインボー", {
    Text = "オーラに適用", Default = true,
    Callback = function(有効) 特殊効果設定.オーラにレインボー = 有効 end
})
レインボーグループ:AddToggle("翼にレインボー", {
    Text = "天使の翼に適用", Default = true,
    Callback = function(有効) 特殊効果設定.翼にレインボー = 有効 end
})
レインボーグループ:AddToggle("軌跡にレインボー", {
    Text = "軌跡に適用", Default = true,
    Callback = function(有効) 特殊効果設定.軌跡にレインボー = 有効 end
})

--============================================================
--  UI設定タブ（テーマ & セーブ）
--============================================================
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
ThemeManager:ApplyToTab(Tabs["UI Settings"])
SaveManager:BuildConfigSection(Tabs["UI Settings"])
SaveManager:LoadAutoloadConfig()

--============================================================
--  初期化
--============================================================
Library:Notify("Visual Hub v1 がロードされました", 3)
