const ink = require("../src")
local assets = require("./lib/assets")

type Card = { title: string, body: string, logo: string }

const COLOR_TEXT_BG = Color3.fromHex("#DDDDDD")
const COLOR_TEXT_FG = Color3.fromHex("#000000")
const TITLE_STYLE: ink.TextStyle = { size = 24, font = Enum.Font.GothamBold }
const BODY_STYLE: ink.TextStyle = { size = 16, font = Enum.Font.RobotoMono }

const CARDS = {
	{
		title = "Fusion",
		body = 'scope:New "TextLabel" { ... }',
		logo = assets.fusion,
	},
	{
		title = "React",
		body = 'e("TextLabel", { ... })',
		logo = assets.react,
	},
	{
		title = "Ink",
		body = "ink.text(...)",
		logo = assets.ink,
	},
	{
		title = "Vide",
		body = 'create "TextLabel" { ... }',
		logo = assets.vide,
	},
	{
		title = "Iris",
		body = "Iris.Text({ ... })",
		logo = assets.iris,
	},
}

const function render_card(card: Card)
	local bg = ink.solid(ink.rect_sized(320, 180))
	bg = ink.tint(bg, COLOR_TEXT_BG, 2 / 3)

	local logo = ink.image(ink.rect_sized(160, 160), card.logo)
	logo = ink.pad_all(logo, -32)
	logo = ink.align(logo, bg.bounds, 1, 1)

	local fg = ink.v_stack({
		ink.text(card.title, TITLE_STYLE),
		ink.text(card.body, BODY_STYLE),
	})
	fg = ink.tint(fg, COLOR_TEXT_FG)
	fg = ink.pad_all(fg, 12)
	fg = ink.compose({ ink.tint(ink.solid(fg.bounds), COLOR_TEXT_BG), fg })

	return ink.compose({ bg, logo, fg }, bg.bounds)
end

return ink.ui_labs_story({
	render = function(properties: ink.StoryProperties)
		const cards = {}
		for index, card in CARDS do
			cards[index] = ink.translate(render_card(card), (index - 1) * 32)
		end
		const stack = ink.v_stack(cards, 42)

		return ink.align(stack, properties.target_bounds, 0.5, 0.5)
	end,
})
