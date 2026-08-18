local Players = game:GetService("Players")

local React = require(script.Roact.React)
local ReactRoblox = require(script.Roact.ReactRoblox)

local ClientState = require(script.ClientState)
local App = require(script.components.App)

ClientState.start()

local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MainUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.DisplayOrder = 10
screenGui.Parent = playerGui

local root = ReactRoblox.createRoot(screenGui)
root:render(React.createElement(App))

--> for world SurfaceGuis make a second root on the SurfaceGui and render the
--> same components with context = "surface", separate roots stop an expensive
--> world board from re rendering the hud
