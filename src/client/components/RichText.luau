local React = require(script.Parent.Parent.Roact.React)
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local HyperText = require(ReplicatedStorage.Shared.HyperText)

export type Props = {
	text: string,
	markup: any?,
	attributes: any?,

	instant: boolean?,
	size: UDim2?,
	position: UDim2?,
	layoutOrder: number?,
}

local function RichText(props: Props)
	return nil :: any
end

return RichText
