-- Custom Venyx fork with hardcoded purple theme and MacLib blur system
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/GreenDeno/Venyx-UI-Library/main/source.lua"))()
local venyx = library.new("Riot Abuse", 5013109572)

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")
local lp = Players.LocalPlayer

-- Custom theme colors
local customThemes = {
	Background = Color3.fromRGB(53, 38, 53),
	Glow = Color3.fromRGB(128, 92, 133),
	Accent = Color3.fromRGB(98, 65, 99),
	LightContrast = Color3.fromRGB(77, 63, 78),
	DarkContrast = Color3.fromRGB(21, 12, 23),  
	TextColor = Color3.fromRGB(255, 255, 255)
}

-- Notification
game:GetService("StarterGui"):SetCore("SendNotification", {
	Title = "loaded",
	Text = "key verified",
	Duration = 5
})

-- Make background 50% transparent before blur setup
venyx.container.Main.ImageTransparency = 0.5

-- ===== BLUR SYSTEM (MacLib style with DepthOfField) =====
local BlurTarget = venyx.container.Main
local HS = HttpService
local camera = workspace.CurrentCamera
local MTREL = "Glass"
local binds = {}
local wedgeguid = HS:GenerateGUID(true)

local DepthOfField

for _,v in pairs(Lighting:GetChildren()) do
	if v:IsA("DepthOfFieldEffect") and v:HasTag(".blur_riot") then
		DepthOfField = v
	end
end

if not DepthOfField then
	DepthOfField = Instance.new('DepthOfFieldEffect')
	DepthOfField.FarIntensity = 0
	DepthOfField.FocusDistance = 51.6
	DepthOfField.InFocusRadius = 50
	DepthOfField.NearIntensity = 1
	DepthOfField.Name = HS:GenerateGUID(true)
	DepthOfField:AddTag(".blur_riot")
	DepthOfField.Parent = Lighting
end

local frame = Instance.new('Frame')
frame.Parent = BlurTarget
frame.Size = UDim2.new(0.97, 0, 0.97, 0)
frame.Position = UDim2.new(0.5, 0, 0.5, 0)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundTransparency = 1
frame.Name = HS:GenerateGUID(true)

-- Wait for camera to be ready
local function IsNotNaN(x)
	return x == x
end
local continue = IsNotNaN(camera:ScreenPointToRay(0,0).Origin.x)
while not continue do
	RunService.RenderStepped:Wait()
	continue = IsNotNaN(camera:ScreenPointToRay(0,0).Origin.x)
end

-- DrawQuad function from MacLib
local DrawQuad; do
	local acos, max, pi, sqrt = math.acos, math.max, math.pi, math.sqrt
	local sz = 0.2

	local function DrawTriangle(v1, v2, v3, p0, p1)
		local s1 = (v1 - v2).magnitude
		local s2 = (v2 - v3).magnitude
		local s3 = (v3 - v1).magnitude
		local smax = max(s1, s2, s3)
		local A, B, C
		if s1 == smax then
			A, B, C = v1, v2, v3
		elseif s2 == smax then
			A, B, C = v2, v3, v1
		elseif s3 == smax then
			A, B, C = v3, v1, v2
		end

		local para = ( (B-A).x*(C-A).x + (B-A).y*(C-A).y + (B-A).z*(C-A).z ) / (A-B).magnitude
		local perp = sqrt((C-A).magnitude^2 - para*para)
		local dif_para = (A - B).magnitude - para

		local st = CFrame.new(B, A)
		local za = CFrame.Angles(pi/2,0,0)

		local cf0 = st

		local Top_Look = (cf0 * za).lookVector
		local Mid_Point = A + CFrame.new(A, B).lookVector * para
		local Needed_Look = CFrame.new(Mid_Point, C).lookVector
		local dot = Top_Look.x*Needed_Look.x + Top_Look.y*Needed_Look.y + Top_Look.z*Needed_Look.z

		local ac = CFrame.Angles(0, 0, acos(dot))

		cf0 = cf0 * ac
		if ((cf0 * za).lookVector - Needed_Look).magnitude > 0.01 then
			cf0 = cf0 * CFrame.Angles(0, 0, -2*acos(dot))
		end
		cf0 = cf0 * CFrame.new(0, perp/2, -(dif_para + para/2))

		local cf1 = st * ac * CFrame.Angles(0, pi, 0)
		if ((cf1 * za).lookVector - Needed_Look).magnitude > 0.01 then
			cf1 = cf1 * CFrame.Angles(0, 0, 2*acos(dot))
		end
		cf1 = cf1 * CFrame.new(0, perp/2, dif_para/2)

		if not p0 then
			p0 = Instance.new('Part')
			p0.FormFactor = 'Custom'
			p0.TopSurface = 0
			p0.BottomSurface = 0
			p0.Anchored = true
			p0.CanCollide = false
			p0.CastShadow = false
			p0.Material = MTREL
			p0.Size = Vector3.new(sz, sz, sz)
			p0.Name = HS:GenerateGUID(true)
			local mesh = Instance.new('SpecialMesh', p0)
			mesh.MeshType = 2
			mesh.Name = wedgeguid
		end
		p0[wedgeguid].Scale = Vector3.new(0, perp/sz, para/sz)
		p0.CFrame = cf0

		if not p1 then
			p1 = p0:clone()
		end
		p1[wedgeguid].Scale = Vector3.new(0, perp/sz, dif_para/sz)
		p1.CFrame = cf1

		return p0, p1
	end

	function DrawQuad(v1, v2, v3, v4, parts)
		parts[1], parts[2] = DrawTriangle(v1, v2, v3, parts[1], parts[2])
		parts[3], parts[4] = DrawTriangle(v3, v2, v4, parts[3], parts[4])
	end
end

local parts = {}
local parents = {}

do
	local function add(child)
		if child:IsA'GuiObject' then
			parents[#parents + 1] = child
			add(child.Parent)
		end
	end
	add(frame)
end

local function IsVisible(instance)
	while instance do
		if instance:IsA("GuiObject") then
			if not instance.Visible then
				return false
			end
		elseif instance:IsA("ScreenGui") then
			if not instance.Enabled then
				return false
			end
			break
		end
		instance = instance.Parent
	end
	return true
end

local function UpdateOrientation(fetchProps)
	if not IsVisible(frame) then
		for _, pt in pairs(parts) do
			pt.Parent = nil
			DepthOfField.Enabled = false
		end
		return
	end
	if not DepthOfField.Parent then
		DepthOfField.Parent = Lighting
	end
	DepthOfField.Enabled = true
	local properties = {
		Transparency = 0.98;
		BrickColor = BrickColor.new('Institutional white');
	}
	local zIndex = 1 - 0.05*frame.ZIndex

	local tl, br = frame.AbsolutePosition, frame.AbsolutePosition + frame.AbsoluteSize
	local tr, bl = Vector2.new(br.x, tl.y), Vector2.new(tl.x, br.y)
	do
		local rot = 0;
		for _, v in ipairs(parents) do
			rot = rot + v.Rotation
		end
		if rot ~= 0 and rot%180 ~= 0 then
			local mid = tl:lerp(br, 0.5)
			local s, c = math.sin(math.rad(rot)), math.cos(math.rad(rot))
			local vec = tl
			tl = Vector2.new(c*(tl.x - mid.x) - s*(tl.y - mid.y), s*(tl.x - mid.x) + c*(tl.y - mid.y)) + mid
			tr = Vector2.new(c*(tr.x - mid.x) - s*(tr.y - mid.y), s*(tr.x - mid.x) + c*(tr.y - mid.y)) + mid
			bl = Vector2.new(c*(bl.x - mid.x) - s*(bl.y - mid.y), s*(bl.x - mid.x) + c*(bl.y - mid.y)) + mid
			br = Vector2.new(c*(br.x - mid.x) - s*(br.y - mid.y), s*(br.x - mid.x) + c*(br.y - mid.y)) + mid
		end
	end
	DrawQuad(
		camera:ScreenPointToRay(tl.x, tl.y, zIndex).Origin, 
		camera:ScreenPointToRay(tr.x, tr.y, zIndex).Origin, 
		camera:ScreenPointToRay(bl.x, bl.y, zIndex).Origin, 
		camera:ScreenPointToRay(br.x, br.y, zIndex).Origin, 
		parts
	)
	if fetchProps then
		for _, pt in pairs(parts) do
			pt.Parent = camera
		end
		for propName, propValue in pairs(properties) do
			for _, pt in pairs(parts) do
				pt[propName] = propValue
			end
		end
	end
end

UpdateOrientation(true)
RunService.RenderStepped:Connect(UpdateOrientation)

-- ===== END BLUR SYSTEM =====

-- Apply theme after pages are created
local page = venyx:addPage("Riot Abuse", 5012544693)
local section1 = page:addSection("Toggle")
local section2 = page:addSection("Settings")

-- Riot Abuse Variables
local riotEnabled = false
local spinSpeed = 180
local riotConn = nil

local function startRiotAbuser()
	if riotConn then riotConn:Disconnect() end
	
	local t0, seed = tick(), math.random(1000, 9000)
	
	riotConn = RunService.Heartbeat:Connect(function(dt)
		if not riotEnabled then return end
		local root = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
		if not root then return end

		local t = tick() - t0
		local yaw   = math.rad(spinSpeed * dt)
		local pitch = math.rad(spinSpeed * 0.37 * dt * math.sin(t * 3.1))
		local roll  = math.rad(spinSpeed * 0.19 * dt * math.cos(t * 5.7 + seed))

		local spinCF = root.CFrame * CFrame.Angles(pitch, yaw, roll)

		-- 5x BIGGER JITTER
		local jX = (math.random() - 0.5) * 350 + math.noise(t * 9, seed, 0) * 150
		local jY = (math.random() - 0.5) * 65 + math.noise(0, t * 9, seed) * 40
		local jZ = (math.random() - 0.5) * 350 + math.noise(0, 0, t * 9 + seed) * 150

		local newY = math.max(spinCF.Position.Y + jY, 2)
		root.CFrame = spinCF + Vector3.new(jX, newY - spinCF.Position.Y, jZ)
	end)
end

local function stopRiotAbuser()
	if riotConn then riotConn:Disconnect() riotConn = nil end
end

-- Toggle Button
section1:addToggle("Enable Riot Abuse", false, function(value)
	riotEnabled = value
	if riotEnabled then
		startRiotAbuser()
	else
		stopRiotAbuser()
	end
end)

-- Speed Slider
section2:addSlider("Spin Speed", spinSpeed, 0, 720, function(value)
	spinSpeed = value
end)

-- Info Button
section1:addButton("Info", function()
	venyx:Notify("Riot Abuse", "Spin Speed: " .. spinSpeed .. " deg/s")
end)

-- Theme Page
local themePage = venyx:addPage("Theme", 5012544693)
local themeSection = themePage:addSection("Colors")

for themeName, color in pairs(customThemes) do
	themeSection:addColorPicker(themeName, color, function(color3)
		venyx:setTheme(themeName, color3)
	end)
end

-- Apply theme after pages are created
for themeName, color in pairs(customThemes) do
	venyx:setTheme(themeName, color)
end

-- Select first page
venyx:SelectPage(venyx.pages[1], true)
