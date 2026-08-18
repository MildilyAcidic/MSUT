

--[[

subscribes a component to discrete state like levels, stats and unlocks this port is react 17 so theres no useSyncExternalStore, this is the manual
version, read in render, subscribe in an effect, force an update on change, the tearing problems that hook was made for dont apply here since this port has no
concurrent rendering dont use this for balances, see useCurrencyBinding
]]

local React = require(script.Parent.Parent.Roact.React)
local ClientState = require(script.Parent.Parent.ClientState)

--[[

selector picks the slice you care about, the component only re renders when that
slice changes

todo:
local selected, setSelected = React.useState(function() return selector(ClientState) end)
React.useEffect(function()
    local conn = ClientState.changed:Connect(function() ... end)
    --> read again right away, a change can land between render and effect
    return function() conn:Disconnect() end
end, { selector })

pass a stable selector, either a module level function or one wrapped in
useCallback, an inline closure is a new value every render so the effect
resubscribes every render, which is a leak that just looks like the game slowly
getting worse

]]
local function useStore<T>(selector: (any) -> T): T
	return nil :: any
end

return useStore
