local MacLib = { 
	Options = {}, 
	Folder = "Maclib", 
	GetService = function(service)
		return cloneref and cloneref(game:GetService(service)) or game:GetService(service)
	end
}

--// Services
local TweenService = MacLib.GetService("TweenService")
local RunService = MacLib.GetService("RunService")
local HttpService = MacLib.GetService("HttpService")
local UserInputService = MacLib.GetService("UserInputService")
local Lighting = MacLib.GetService("Lighting")
local Players = MacLib.GetService("Players")

--// Variables
local LocalPlayer = Players.LocalPlayer
local tabs = {}
local currentTabInstance = nil
local tabIndex = 0

local assets = {
	interFont = "rbxassetid://12187365364",
	toggleBackground = "rbxassetid://18772190202",
	togglerHead = "rbxassetid://18772309008",
	buttonImage = "rbxassetid://10709791437",
	searchIcon = "rbxassetid://86737463322606",
	dropdown = "rbxassetid://18865373378",
	sliderbar = "rbxassetid://18772615246",
	sliderhead = "rbxassetid://18772834246",
}

local function GetGui()
	local newGui = Instance.new("ScreenGui")
	newGui.ScreenInsets = Enum.ScreenInsets.None
	newGui.ResetOnSpawn = false
	newGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	newGui.DisplayOrder = 2147483647

	local parent = RunService:IsStudio() 
		and LocalPlayer:FindFirstChild("PlayerGui")
		or (gethui and gethui())
		or MacLib.GetService("CoreGui")

	newGui.Parent = parent
	return newGui
end

local function Tween(instance, tweeninfo, propertytable)
	return TweenService:Create(instance, tweeninfo, propertytable)
end

function MacLib:Window(Settings)
	local WindowFunctions = {Settings = Settings}

	local macLib = GetGui()

	local notifications = Instance.new("Frame")
	notifications.Name = "Notifications"
	notifications.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	notifications.BackgroundTransparency = 1
	notifications.BorderSizePixel = 0
	notifications.Size = UDim2.fromScale(1, 1)
	notifications.Parent = macLib
	notifications.ZIndex = 2

	local notificationsUIListLayout = Instance.new("UIListLayout")
	notificationsUIListLayout.Padding = UDim.new(0, 10)
	notificationsUIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
	notificationsUIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	notificationsUIListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
	notificationsUIListLayout.Parent = notifications

	local notificationsUIPadding = Instance.new("UIPadding")
	notificationsUIPadding.PaddingBottom = UDim.new(0, 10)
	notificationsUIPadding.PaddingLeft = UDim.new(0, 10)
	notificationsUIPadding.PaddingRight = UDim.new(0, 10)
	notificationsUIPadding.PaddingTop = UDim.new(0, 10)
	notificationsUIPadding.Parent = notifications

	local base = Instance.new("Frame")
	base.Name = "Base"
	base.AnchorPoint = Vector2.new(0.5, 0.5)
	base.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	base.BackgroundTransparency = 0
	base.BorderSizePixel = 0
	base.Position = UDim2.fromScale(0.5, 0.5)
	base.Size = Settings.Size or UDim2.fromOffset(900, 650)

	local baseUIScale = Instance.new("UIScale")
	baseUIScale.Parent = base

	local baseUICorner = Instance.new("UICorner")
	baseUICorner.CornerRadius = UDim.new(0, 12)
	baseUICorner.Parent = base

	local sidebar = Instance.new("Frame")
	sidebar.Name = "Sidebar"
	sidebar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	sidebar.BackgroundTransparency = 0
	sidebar.BorderSizePixel = 0
	sidebar.Position = UDim2.fromScale(0, 0)
	sidebar.Size = UDim2.fromScale(0.3, 1)

	local divider = Instance.new("Frame")
	divider.Name = "Divider"
	divider.AnchorPoint = Vector2.new(1, 0)
	divider.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	divider.BackgroundTransparency = 0
	divider.BorderSizePixel = 0
	divider.Position = UDim2.fromScale(1, 0)
	divider.Size = UDim2.new(0, 1, 1, 0)
	divider.Parent = sidebar

	local windowControls = Instance.new("Frame")
	windowControls.Name = "WindowControls"
	windowControls.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	windowControls.BackgroundTransparency = 0
	windowControls.BorderSizePixel = 0
	windowControls.Size = UDim2.new(1, 0, 0, 35)

	local controls = Instance.new("Frame")
	controls.Name = "Controls"
	controls.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	controls.BackgroundTransparency = 0
	controls.BorderSizePixel = 0
	controls.Size = UDim2.fromScale(1, 1)

	local uIListLayout = Instance.new("UIListLayout")
	uIListLayout.Padding = UDim.new(0, 8)
	uIListLayout.FillDirection = Enum.FillDirection.Horizontal
	uIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	uIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	uIListLayout.Parent = controls

	local uIPadding = Instance.new("UIPadding")
	uIPadding.PaddingLeft = UDim.new(0, 12)
	uIPadding.Parent = controls

	local exit = Instance.new("TextButton")
	exit.Name = "Exit"
	exit.Text = ""
	exit.TextSize = 14
	exit.AutoButtonColor = false
	exit.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
	exit.BorderSizePixel = 0
	exit.Size = UDim2.fromOffset(10, 10)

	local exitCorner = Instance.new("UICorner")
	exitCorner.CornerRadius = UDim.new(1, 0)
	exitCorner.Parent = exit

	exit.Parent = controls

	local minimize = Instance.new("TextButton")
	minimize.Name = "Minimize"
	minimize.Text = ""
	minimize.TextSize = 14
	minimize.AutoButtonColor = false
	minimize.BackgroundColor3 = Color3.fromRGB(220, 180, 50)
	minimize.BorderSizePixel = 0
	minimize.LayoutOrder = 1
	minimize.Size = UDim2.fromOffset(10, 10)

	local minimizeCorner = Instance.new("UICorner")
	minimizeCorner.CornerRadius = UDim.new(1, 0)
	minimizeCorner.Parent = minimize

	minimize.Parent = controls

	controls.Parent = windowControls
	windowControls.Parent = sidebar

	local information = Instance.new("Frame")
	information.Name = "Information"
	information.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	information.BackgroundTransparency = 0
	information.BorderSizePixel = 0
	information.Position = UDim2.fromOffset(0, 35)
	information.Size = UDim2.new(1, 0, 0, 70)

	local divider2 = Instance.new("Frame")
	divider2.Name = "Divider"
	divider2.AnchorPoint = Vector2.new(0, 1)
	divider2.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	divider2.BorderSizePixel = 0
	divider2.Position = UDim2.fromScale(0, 1)
	divider2.Size = UDim2.new(1, 0, 0, 1)
	divider2.Parent = information

	local informationHolder = Instance.new("Frame")
	informationHolder.Name = "InformationHolder"
	informationHolder.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	informationHolder.BackgroundTransparency = 0
	informationHolder.BorderSizePixel = 0
	informationHolder.Size = UDim2.fromScale(1, 1)

	local informationHolderUIPadding = Instance.new("UIPadding")
	informationHolderUIPadding.PaddingBottom = UDim.new(0, 12)
	informationHolderUIPadding.PaddingLeft = UDim.new(0, 15)
	informationHolderUIPadding.PaddingRight = UDim.new(0, 15)
	informationHolderUIPadding.PaddingTop = UDim.new(0, 12)
	informationHolderUIPadding.Parent = informationHolder

	local titleFrame = Instance.new("Frame")
	titleFrame.Name = "TitleFrame"
	titleFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	titleFrame.BackgroundTransparency = 0
	titleFrame.BorderSizePixel = 0
	titleFrame.Size = UDim2.fromScale(1, 1)

	local title = Instance.new("TextLabel")
	title.Name = "Title"
	title.FontFace = Font.new(assets.interFont, Enum.FontWeight.SemiBold)
	title.Text = Settings.Title
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.TextSize = 18
	title.TextTransparency = 0
	title.TextTruncate = Enum.TextTruncate.SplitWord
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.AutomaticSize = Enum.AutomaticSize.Y
	title.BackgroundTransparency = 1
	title.BorderSizePixel = 0
	title.Size = UDim2.new(1, 0, 0, 0)
	title.Parent = titleFrame

	local titleFrameUIListLayout = Instance.new("UIListLayout")
	titleFrameUIListLayout.Padding = UDim.new(0, 2)
	titleFrameUIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	titleFrameUIListLayout.Parent = titleFrame

	titleFrame.Parent = informationHolder
	informationHolder.Parent = information
	information.Parent = sidebar

	local sidebarGroup = Instance.new("Frame")
	sidebarGroup.Name = "SidebarGroup"
	sidebarGroup.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	sidebarGroup.BackgroundTransparency = 0
	sidebarGroup.BorderSizePixel = 0
	sidebarGroup.Position = UDim2.fromOffset(0, 105)
	sidebarGroup.Size = UDim2.new(1, 0, 1, -105)

	local tabSwitchers = Instance.new("Frame")
	tabSwitchers.Name = "TabSwitchers"
	tabSwitchers.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	tabSwitchers.BackgroundTransparency = 0
	tabSwitchers.BorderSizePixel = 0
	tabSwitchers.Size = UDim2.fromScale(1, 1)

	local tabSwitchersScrollingFrame = Instance.new("ScrollingFrame")
	tabSwitchersScrollingFrame.Name = "TabSwitchersScrollingFrame"
	tabSwitchersScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
	tabSwitchersScrollingFrame.BottomImage = ""
	tabSwitchersScrollingFrame.ScrollBarImageTransparency = 0.7
	tabSwitchersScrollingFrame.ScrollBarThickness = 2
	tabSwitchersScrollingFrame.TopImage = ""
	tabSwitchersScrollingFrame.BackgroundTransparency = 1
	tabSwitchersScrollingFrame.BorderSizePixel = 0
	tabSwitchersScrollingFrame.Size = UDim2.fromScale(1, 1)

	local tabSwitchersScrollingFrameUIListLayout = Instance.new("UIListLayout")
	tabSwitchersScrollingFrameUIListLayout.Padding = UDim.new(0, 8)
	tabSwitchersScrollingFrameUIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	tabSwitchersScrollingFrameUIListLayout.Parent = tabSwitchersScrollingFrame

	local tabSwitchersScrollingFrameUIPadding = Instance.new("UIPadding")
	tabSwitchersScrollingFrameUIPadding.PaddingTop = UDim.new(0, 8)
	tabSwitchersScrollingFrameUIPadding.PaddingLeft = UDim.new(0, 10)
	tabSwitchersScrollingFrameUIPadding.PaddingRight = UDim.new(0, 8)
	tabSwitchersScrollingFrameUIPadding.Parent = tabSwitchersScrollingFrame

	tabSwitchersScrollingFrame.Parent = tabSwitchers
	tabSwitchers.Parent = sidebarGroup
	sidebarGroup.Parent = sidebar
	sidebar.Parent = base

	local content = Instance.new("Frame")
	content.Name = "Content"
	content.AnchorPoint = Vector2.new(1, 0)
	content.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	content.BackgroundTransparency = 0
	content.BorderSizePixel = 0
	content.Position = UDim2.fromScale(1, 0)
	content.Size = UDim2.new(1, 0, 1, 0)

	local topbar = Instance.new("Frame")
	topbar.Name = "Topbar"
	topbar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	topbar.BackgroundTransparency = 0
	topbar.BorderSizePixel = 0
	topbar.Size = UDim2.new(1, 0, 0, 50)

	local divider4 = Instance.new("Frame")
	divider4.Name = "Divider"
	divider4.AnchorPoint = Vector2.new(0, 1)
	divider4.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	divider4.BorderSizePixel = 0
	divider4.Position = UDim2.fromScale(0, 1)
	divider4.Size = UDim2.new(1, 0, 0, 1)
	divider4.Parent = topbar

	local currentTab = Instance.new("TextLabel")
	currentTab.Name = "CurrentTab"
	currentTab.FontFace = Font.new(assets.interFont)
	currentTab.Text = ""
	currentTab.TextColor3 = Color3.fromRGB(255, 255, 255)
	currentTab.TextSize = 15
	currentTab.TextTransparency = 0.3
	currentTab.TextXAlignment = Enum.TextXAlignment.Left
	currentTab.AnchorPoint = Vector2.new(0, 0.5)
	currentTab.BackgroundTransparency = 1
	currentTab.BorderSizePixel = 0
	currentTab.Position = UDim2.fromScale(0, 0.5)
	currentTab.Size = UDim2.fromScale(0.9, 0)

	local topbarUIPadding = Instance.new("UIPadding")
	topbarUIPadding.PaddingLeft = UDim.new(0, 20)
	topbarUIPadding.PaddingRight = UDim.new(0, 20)
	topbarUIPadding.Parent = topbar

	currentTab.Parent = topbar
	topbar.Parent = content
	content.Parent = base
	base.Parent = macLib

	function WindowFunctions:UpdateTitle(NewTitle)
		title.Text = NewTitle
	end

	function WindowFunctions:TabGroup()
		local SectionFunctions = {}

		local tabGroup = Instance.new("Frame")
		tabGroup.Name = "Section"
		tabGroup.AutomaticSize = Enum.AutomaticSize.Y
		tabGroup.BackgroundTransparency = 1
		tabGroup.BorderSizePixel = 0
		tabGroup.Size = UDim2.fromScale(1, 0)

		local sectionTabSwitchers = Instance.new("Frame")
		sectionTabSwitchers.Name = "SectionTabSwitchers"
		sectionTabSwitchers.BackgroundTransparency = 1
		sectionTabSwitchers.BorderSizePixel = 0
		sectionTabSwitchers.Size = UDim2.fromScale(1, 1)

		local uIListLayout1 = Instance.new("UIListLayout")
		uIListLayout1.Padding = UDim.new(0, 10)
		uIListLayout1.HorizontalAlignment = Enum.HorizontalAlignment.Center
		uIListLayout1.SortOrder = Enum.SortOrder.LayoutOrder
		uIListLayout1.Parent = sectionTabSwitchers

		local uIPadding1 = Instance.new("UIPadding")
		uIPadding1.PaddingBottom = UDim.new(0, 10)
		uIPadding1.Parent = sectionTabSwitchers

		sectionTabSwitchers.Parent = tabGroup
		tabGroup.Parent = tabSwitchersScrollingFrame

		function SectionFunctions:Tab(Settings)
			local TabFunctions = {Settings = Settings}
			local tabSwitcher = Instance.new("TextButton")
			tabSwitcher.Name = "TabSwitcher"
			tabSwitcher.Text = ""
			tabSwitcher.TextSize = 14
			tabSwitcher.AutoButtonColor = false
			tabSwitcher.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
			tabSwitcher.BorderSizePixel = 0
			tabSwitcher.Size = UDim2.new(1, -20, 0, 38)

			tabIndex += 1
			tabSwitcher.LayoutOrder = tabIndex

			local tabSwitcherUICorner = Instance.new("UICorner")
			tabSwitcherUICorner.CornerRadius = UDim.new(0, 8)
			tabSwitcherUICorner.Parent = tabSwitcher

			local tabSwitcherUIListLayout = Instance.new("UIListLayout")
			tabSwitcherUIListLayout.Padding = UDim.new(0, 8)
			tabSwitcherUIListLayout.FillDirection = Enum.FillDirection.Horizontal
			tabSwitcherUIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
			tabSwitcherUIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
			tabSwitcherUIListLayout.Parent = tabSwitcher

			local tabImage

			if Settings.Image then
				tabImage = Instance.new("ImageLabel")
				tabImage.Name = "TabImage"
				tabImage.Image = Settings.Image
				tabImage.ImageTransparency = 0.4
				tabImage.BackgroundTransparency = 1
				tabImage.BorderSizePixel = 0
				tabImage.Size = UDim2.fromOffset(16, 16)
				tabImage.Parent = tabSwitcher
			end

			local tabSwitcherName = Instance.new("TextLabel")
			tabSwitcherName.Name = "TabSwitcherName"
			tabSwitcherName.FontFace = Font.new(assets.interFont, Enum.FontWeight.Medium)
			tabSwitcherName.Text = Settings.Name
			tabSwitcherName.TextColor3 = Color3.fromRGB(255, 255, 255)
			tabSwitcherName.TextSize = 14
			tabSwitcherName.TextTransparency = 0.4
			tabSwitcherName.TextXAlignment = Enum.TextXAlignment.Left
			tabSwitcherName.AutomaticSize = Enum.AutomaticSize.Y
			tabSwitcherName.BackgroundTransparency = 1
			tabSwitcherName.BorderSizePixel = 0
			tabSwitcherName.Size = UDim2.fromScale(1, 0)
			tabSwitcherName.Parent = tabSwitcher
			tabSwitcherName.LayoutOrder = 1

			local tabSwitcherUIPadding = Instance.new("UIPadding")
			tabSwitcherUIPadding.PaddingLeft = UDim.new(0, 12)
			tabSwitcherUIPadding.PaddingRight = UDim.new(0, 12)
			tabSwitcherUIPadding.Parent = tabSwitcher

			tabSwitcher.Parent = sectionTabSwitchers

			local elements1 = Instance.new("Frame")
			elements1.Name = "Elements"
			elements1.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
			elements1.BackgroundTransparency = 0
			elements1.BorderSizePixel = 0
			elements1.Position = UDim2.fromOffset(0, 50)
			elements1.Size = UDim2.new(1, 0, 1, -50)
			elements1.ClipsDescendants = true

			local elementsUIPadding = Instance.new("UIPadding")
			elementsUIPadding.PaddingRight = UDim.new(0, 3)
			elementsUIPadding.PaddingTop = UDim.new(0, 15)
			elementsUIPadding.PaddingBottom = UDim.new(0, 15)
			elementsUIPadding.Parent = elements1

			local elementsScrolling = Instance.new("ScrollingFrame")
			elementsScrolling.Name = "ElementsScrolling"
			elementsScrolling.AutomaticCanvasSize = Enum.AutomaticSize.Y
			elementsScrolling.BottomImage = ""
			elementsScrolling.ScrollBarImageTransparency = 0.6
			elementsScrolling.ScrollBarThickness = 2
			elementsScrolling.TopImage = ""
			elementsScrolling.BackgroundTransparency = 1
			elementsScrolling.BorderSizePixel = 0
			elementsScrolling.Size = UDim2.fromScale(1, 1)

			local elementsScrollingUIPadding = Instance.new("UIPadding")
			elementsScrollingUIPadding.PaddingBottom = UDim.new(0, 8)
			elementsScrollingUIPadding.PaddingLeft = UDim.new(0, 12)
			elementsScrollingUIPadding.PaddingRight = UDim.new(0, 8)
			elementsScrollingUIPadding.PaddingTop = UDim.new(0, 5)
			elementsScrollingUIPadding.Parent = elementsScrolling

			local elementsScrollingUIListLayout = Instance.new("UIListLayout")
			elementsScrollingUIListLayout.Padding = UDim.new(0, 12)
			elementsScrollingUIListLayout.FillDirection = Enum.FillDirection.Horizontal
			elementsScrollingUIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
			elementsScrollingUIListLayout.Parent = elementsScrolling

			local left = Instance.new("Frame")
			left.Name = "Left"
			left.AutomaticSize = Enum.AutomaticSize.Y
			left.BackgroundTransparency = 1
			left.BorderSizePixel = 0
			left.Size = UDim2.new(0.5, -8, 0, 0)

			local leftUIListLayout = Instance.new("UIListLayout")
			leftUIListLayout.Padding = UDim.new(0, 10)
			leftUIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
			leftUIListLayout.Parent = left

			left.Parent = elementsScrolling

			local right = Instance.new("Frame")
			right.Name = "Right"
			right.AutomaticSize = Enum.AutomaticSize.Y
			right.BackgroundTransparency = 1
			right.BorderSizePixel = 0
			right.LayoutOrder = 1
			right.Size = UDim2.new(0.5, -8, 0, 0)

			local rightUIListLayout = Instance.new("UIListLayout")
			rightUIListLayout.Padding = UDim.new(0, 10)
			rightUIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
			rightUIListLayout.Parent = right

			right.Parent = elementsScrolling

			elementsScrolling.Parent = elements1
			elements1.Parent = tabGroup

			function TabFunctions:Section(Settings)
				local SectionFunctions = {}
				local section = Instance.new("Frame")
				section.Name = "Section"
				section.AutomaticSize = Enum.AutomaticSize.Y
				section.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
				section.BackgroundTransparency = 0
				section.BorderSizePixel = 0
				section.Size = UDim2.fromScale(1, 0)
				section.ClipsDescendants = true
				section.Parent = Settings.Side == "Left" and left or right

				local sectionUICorner = Instance.new("UICorner")
				sectionUICorner.CornerRadius = UDim.new(0, 8)
				sectionUICorner.Parent = section

				local sectionUIListLayout = Instance.new("UIListLayout")
				sectionUIListLayout.Padding = UDim.new(0, 8)
				sectionUIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
				sectionUIListLayout.Parent = section

				local sectionUIPadding = Instance.new("UIPadding")
				sectionUIPadding.PaddingBottom = UDim.new(0, 15)
				sectionUIPadding.PaddingLeft = UDim.new(0, 15)
				sectionUIPadding.PaddingRight = UDim.new(0, 15)
				sectionUIPadding.PaddingTop = UDim.new(0, 15)
				sectionUIPadding.Parent = section

				function SectionFunctions:Button(Settings, Flag)
					local ButtonFunctions = {Settings = Settings}
					local button = Instance.new("TextButton")
					button.Name = "Button"
					button.AutomaticSize = Enum.AutomaticSize.Y
					button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
					button.BorderSizePixel = 0
					button.Size = UDim2.new(1, 0, 0, 32)
					button.Parent = section
					button.Text = ""
					button.AutoButtonColor = false

					local buttonCorner = Instance.new("UICorner")
					buttonCorner.CornerRadius = UDim.new(0, 6)
					buttonCorner.Parent = button

					local buttonInteract = Instance.new("TextLabel")
					buttonInteract.Name = "ButtonInteract"
					buttonInteract.FontFace = Font.new(assets.interFont)
					buttonInteract.Text = ButtonFunctions.Settings.Name
					buttonInteract.TextColor3 = Color3.fromRGB(255, 255, 255)
					buttonInteract.TextSize = 12
					buttonInteract.TextTransparency = 0.3
					buttonInteract.TextXAlignment = Enum.TextXAlignment.Center
					buttonInteract.BackgroundTransparency = 1
					buttonInteract.BorderSizePixel = 0
					buttonInteract.Size = UDim2.fromScale(1, 1)
					buttonInteract.Parent = button

					local function Callback()
						if ButtonFunctions.Settings.Callback then
							ButtonFunctions.Settings.Callback()
						end
					end

					button.MouseButton1Click:Connect(Callback)

					function ButtonFunctions:UpdateName(Name)
						buttonInteract.Text = Name
					end

					if Flag then
						MacLib.Options[Flag] = ButtonFunctions
					end
					return ButtonFunctions
				end

				function SectionFunctions:Toggle(Settings, Flag)
					local ToggleFunctions = {Settings = Settings, Class = "Toggle"}
					local toggle = Instance.new("Frame")
					toggle.Name = "Toggle"
					toggle.AutomaticSize = Enum.AutomaticSize.Y
					toggle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
					toggle.BorderSizePixel = 0
					toggle.Size = UDim2.new(1, 0, 0, 32)
					toggle.Parent = section

					local toggleCorner = Instance.new("UICorner")
					toggleCorner.CornerRadius = UDim.new(0, 6)
					toggleCorner.Parent = toggle

					local toggleName = Instance.new("TextLabel")
					toggleName.Name = "ToggleName"
					toggleName.FontFace = Font.new(assets.interFont)
					toggleName.Text = ToggleFunctions.Settings.Name
					toggleName.TextColor3 = Color3.fromRGB(255, 255, 255)
					toggleName.TextSize = 12
					toggleName.TextTransparency = 0.3
					toggleName.TextXAlignment = Enum.TextXAlignment.Left
					toggleName.AnchorPoint = Vector2.new(0, 0.5)
					toggleName.AutomaticSize = Enum.AutomaticSize.Y
					toggleName.BackgroundTransparency = 1
					toggleName.BorderSizePixel = 0
					toggleName.Position = UDim2.fromScale(0, 0.5)
					toggleName.Size = UDim2.new(1, -50, 0, 0)

					local toggleUIPadding = Instance.new("UIPadding")
					toggleUIPadding.PaddingLeft = UDim.new(0, 12)
					toggleUIPadding.Parent = toggle

					toggleName.Parent = toggle

					local toggle1 = Instance.new("Frame")
					toggle1.Name = "Toggle"
					toggle1.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
					toggle1.BorderSizePixel = 0
					toggle1.AnchorPoint = Vector2.new(1, 0.5)
					toggle1.Position = UDim2.fromScale(1, 0.5)
					toggle1.Size = UDim2.fromOffset(40, 20)
					toggle1.Parent = toggle

					local toggleCorner2 = Instance.new("UICorner")
					toggleCorner2.CornerRadius = UDim.new(0, 10)
					toggleCorner2.Parent = toggle1

					local toggleUIPadding2 = Instance.new("UIPadding")
					toggleUIPadding2.PaddingBottom = UDim.new(0, 2)
					toggleUIPadding2.PaddingLeft = UDim.new(0, 2)
					toggleUIPadding2.PaddingRight = UDim.new(0, 2)
					toggleUIPadding2.PaddingTop = UDim.new(0, 2)
					toggleUIPadding2.Parent = toggle1

					local togglerHead = Instance.new("Frame")
					togglerHead.Name = "TogglerHead"
					togglerHead.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					togglerHead.BorderSizePixel = 0
					togglerHead.AnchorPoint = Vector2.new(1, 0.5)
					togglerHead.Position = UDim2.fromScale(0.5, 0.5)
					togglerHead.Size = UDim2.fromOffset(13, 13)
					togglerHead.Parent = toggle1

					local togglerHeadCorner = Instance.new("UICorner")
					togglerHeadCorner.CornerRadius = UDim.new(1, 0)
					togglerHeadCorner.Parent = togglerHead

					local togglebool = ToggleFunctions.Settings.Default or false

					local function NewState(State)
						local position = State and UDim2.fromScale(1, 0.5) or UDim2.fromScale(0.5, 0.5)
						local bgColor = State and Color3.fromRGB(80, 160, 255) or Color3.fromRGB(50, 50, 50)

						Tween(togglerHead, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {
							Position = position
						}):Play()

						Tween(toggle1, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {
							BackgroundColor3 = bgColor
						}):Play()

						ToggleFunctions.State = State
					end

					NewState(togglebool)

					local function Toggle()
						togglebool = not togglebool
						NewState(togglebool)
						if ToggleFunctions.Settings.Callback then
							ToggleFunctions.Settings.Callback(togglebool)
						end
					end

					toggle1.MouseButton1Click:Connect(Toggle)

					function ToggleFunctions:Toggle()
						Toggle()
					end

					function ToggleFunctions:GetState()
						return togglebool
					end

					if Flag then
						MacLib.Options[Flag] = ToggleFunctions
					end
					return ToggleFunctions
				end

				function SectionFunctions:Slider(Settings, Flag)
					local SliderFunctions = {Settings = Settings, Class = "Slider"}
					local slider = Instance.new("Frame")
					slider.Name = "Slider"
					slider.AutomaticSize = Enum.AutomaticSize.Y
					slider.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
					slider.BorderSizePixel = 0
					slider.Size = UDim2.new(1, 0, 0, 32)
					slider.Parent = section

					local sliderCorner = Instance.new("UICorner")
					sliderCorner.CornerRadius = UDim.new(0, 6)
					sliderCorner.Parent = slider

					local sliderName = Instance.new("TextLabel")
					sliderName.Name = "SliderName"
					sliderName.FontFace = Font.new(assets.interFont)
					sliderName.Text = SliderFunctions.Settings.Name
					sliderName.TextColor3 = Color3.fromRGB(255, 255, 255)
					sliderName.TextSize = 12
					sliderName.TextTransparency = 0.3
					sliderName.TextXAlignment = Enum.TextXAlignment.Left
					sliderName.AnchorPoint = Vector2.new(0, 0.5)
					sliderName.AutomaticSize = Enum.AutomaticSize.Y
					sliderName.BackgroundTransparency = 1
					sliderName.BorderSizePixel = 0
					sliderName.Position = UDim2.fromScale(0, 0.5)
					sliderName.Parent = slider

					local sliderUIPadding = Instance.new("UIPadding")
					sliderUIPadding.PaddingLeft = UDim.new(0, 12)
					sliderUIPadding.Parent = slider

					local sliderBar = Instance.new("Frame")
					sliderBar.Name = "SliderBar"
					sliderBar.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
					sliderBar.BorderSizePixel = 0
					sliderBar.AnchorPoint = Vector2.new(1, 0.5)
					sliderBar.Position = UDim2.fromScale(1, 0.5)
					sliderBar.Size = UDim2.fromOffset(100, 4)
					sliderBar.Parent = slider

					local sliderBarCorner = Instance.new("UICorner")
					sliderBarCorner.CornerRadius = UDim.new(0, 2)
					sliderBarCorner.Parent = sliderBar

					local sliderBarUIPadding = Instance.new("UIPadding")
					sliderBarUIPadding.PaddingRight = UDim.new(0, 12)
					sliderBarUIPadding.Parent = slider

					local sliderFill = Instance.new("Frame")
					sliderFill.Name = "Fill"
					sliderFill.BackgroundColor3 = Color3.fromRGB(80, 160, 255)
					sliderFill.BorderSizePixel = 0
					sliderFill.Size = UDim2.new(0.5, 0, 1, 0)
					sliderFill.Parent = sliderBar

					local sliderFillCorner = Instance.new("UICorner")
					sliderFillCorner.CornerRadius = UDim.new(0, 2)
					sliderFillCorner.Parent = sliderFill

					local sliderValue = Settings.Default or Settings.Minimum or 0

					function SliderFunctions:GetValue()
						return sliderValue
					end

					function SliderFunctions:SetValue(val)
						sliderValue = math.clamp(val, Settings.Minimum or 0, Settings.Maximum or 100)
						local percent = (sliderValue - (Settings.Minimum or 0)) / ((Settings.Maximum or 100) - (Settings.Minimum or 0))
						sliderFill.Size = UDim2.new(percent, 0, 1, 0)
						if Settings.Callback then
							Settings.Callback(sliderValue)
						end
					end

					if Flag then
						MacLib.Options[Flag] = SliderFunctions
					end
					return SliderFunctions
				end

				function SectionFunctions:Input(Settings, Flag)
					local InputFunctions = {Settings = Settings, Class = "Input"}
					local input = Instance.new("Frame")
					input.Name = "Input"
					input.AutomaticSize = Enum.AutomaticSize.Y
					input.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
					input.BorderSizePixel = 0
					input.Size = UDim2.new(1, 0, 0, 32)
					input.Parent = section

					local inputCorner = Instance.new("UICorner")
					inputCorner.CornerRadius = UDim.new(0, 6)
					inputCorner.Parent = input

					local inputName = Instance.new("TextLabel")
					inputName.Name = "InputName"
					inputName.FontFace = Font.new(assets.interFont)
					inputName.Text = InputFunctions.Settings.Name
					inputName.TextColor3 = Color3.fromRGB(255, 255, 255)
					inputName.TextSize = 12
					inputName.TextTransparency = 0.3
					inputName.TextXAlignment = Enum.TextXAlignment.Left
					inputName.AnchorPoint = Vector2.new(0, 0.5)
					inputName.AutomaticSize = Enum.AutomaticSize.Y
					inputName.BackgroundTransparency = 1
					inputName.BorderSizePixel = 0
					inputName.Position = UDim2.fromScale(0, 0.5)
					inputName.Parent = input

					local inputUIPadding = Instance.new("UIPadding")
					inputUIPadding.PaddingLeft = UDim.new(0, 12)
					inputUIPadding.PaddingRight = UDim.new(0, 12)
					inputUIPadding.Parent = input

					local inputBox = Instance.new("TextBox")
					inputBox.Name = "InputBox"
					inputBox.FontFace = Font.new(assets.interFont)
					inputBox.Text = Settings.Default or ""
					inputBox.PlaceholderText = Settings.Placeholder or "Enter text..."
					inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
					inputBox.TextSize = 12
					inputBox.TextTransparency = 0.1
					inputBox.AnchorPoint = Vector2.new(1, 0.5)
					inputBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
					inputBox.BorderSizePixel = 0
					inputBox.Position = UDim2.fromScale(1, 0.5)
					inputBox.Size = UDim2.fromOffset(100, 20)
					inputBox.Parent = input

					local inputBoxCorner = Instance.new("UICorner")
					inputBoxCorner.CornerRadius = UDim.new(0, 4)
					inputBoxCorner.Parent = inputBox

					local inputBoxUIPadding = Instance.new("UIPadding")
					inputBoxUIPadding.PaddingLeft = UDim.new(0, 6)
					inputBoxUIPadding.PaddingRight = UDim.new(0, 6)
					inputBoxUIPadding.Parent = inputBox

					inputBox.FocusLost:Connect(function()
						if Settings.Callback then
							Settings.Callback(inputBox.Text)
						end
					end)

					function InputFunctions:GetInput()
						return inputBox.Text
					end

					if Flag then
						MacLib.Options[Flag] = InputFunctions
					end
					return InputFunctions
				end

				return SectionFunctions
			end

			return TabFunctions
		end

		return SectionFunctions
	end

	return WindowFunctions
end

return MacLib
