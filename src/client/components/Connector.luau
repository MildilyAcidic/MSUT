local React = require(script.Parent.Parent.Roact.React)

export type Props = {
	from: Vector2,
	to: Vector2,
	thickness: number?,
	satisfied: boolean?,
}

local function Connector(props: Props)
	return nil :: any
end

return Connector
