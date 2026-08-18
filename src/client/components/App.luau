local React = require(script.Parent.Parent.Roact.React)

local Leaderboard = require(script.Parent.Leaderboard)
local Themes = require(script.Parent.Leaderboard.Themes)

local function App()
	return React.createElement(React.Fragment, nil, {
		leaderboard = React.createElement(Leaderboard, {
			theme = Themes.classic,
		}),
	})
end

return App
