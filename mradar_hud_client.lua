local SCREEN_WIDTH, SCREEN_HEIGHT = guiGetScreenSize()
local TEXTURE_QUALITY_FORMAT = "dxt3"
local TEXTURE_FILE_FORMAT = ".png"
local TEXTURE_MIPMAPS = false
local TEXTURE_EDGE = "clamp"
local FONT_PATH = "font/"
local FONT_QUALITY = "antialiased"

local HUD_TOP_OFFSET = SCREEN_HEIGHT / 24
local HUD_RIGHT_OFFSET = HUD_TOP_OFFSET
local HUD_PADDING = SCREEN_HEIGHT / 216
local HUD_FONT_HEIGHT = math.floor(SCREEN_HEIGHT / 27)
local HUD_FONT_BORDER = math.floor(SCREEN_HEIGHT / 270)
local HUD_FONT = dxCreateFont(FONT_PATH .. "pricedown.ttf", HUD_FONT_HEIGHT - (HUD_FONT_BORDER * 2), false, FONT_QUALITY)
local HUD_FONT_SYMBOL_WIDTH = math.floor(dxGetTextWidth("4", 1, HUD_FONT)) + 1
local HUD_WIDTH = HUD_FONT_SYMBOL_WIDTH * 9 + HUD_FONT_BORDER * 2

local HUD_TIME_ENABLED = true
local HUD_TIME_HEIGHT = HUD_FONT_HEIGHT
local HUD_TIME_FONT = HUD_FONT
local HUD_TIME_WIDTH = HUD_FONT_SYMBOL_WIDTH * 5 + HUD_FONT_BORDER * 2
local HUD_TIME_LEFT = SCREEN_WIDTH - HUD_RIGHT_OFFSET - HUD_TIME_WIDTH
local HUD_TIME_RIGHT = HUD_TIME_LEFT
local HUD_TIME_TOP = HUD_TOP_OFFSET
local HUD_TIME_BOTTOM = HUD_TIME_TOP + HUD_TIME_HEIGHT
local HUD_TIME_X_ALIGN = "left"
local HUD_TIME_Y_ALIGN = "center"
local HUD_TIME_COLOR = tocolor(225, 225, 225, 255)

local HUD_WEAPON_ENABLED = true
local HUD_WEAPON_TEXTURE_PATH = "txd/weapon/"
local HUD_WEAPON_SPRITE_SIZE = HUD_WIDTH - HUD_TIME_WIDTH - HUD_PADDING
local HUD_WEAPON_SPRITE_X = HUD_TIME_LEFT - HUD_PADDING - HUD_WEAPON_SPRITE_SIZE
local HUD_WEAPON_SPRITE_Y = HUD_TOP_OFFSET
local HUD_WEAPON_SPRITE_Y_OFFSET = - HUD_WEAPON_SPRITE_SIZE/16
local HUD_WEAPON_SPRITE_COLOR = tocolor(255, 255, 255, 255)

local HUD_PROGRESS_BAR_WIDTH = math.floor(HUD_TIME_WIDTH)
local HUD_PROGRESS_BAR_HEIGHT = math.floor(SCREEN_HEIGHT / 64)
local HUD_PROGRESS_BAR_BORDER = HUD_FONT_BORDER

local HUD_WEAPON_AMMO_ENABLED = HUD_WEAPON_ENABLED
local HUD_WEAPON_AMMO_FONT = dxCreateFont(FONT_PATH .. "futurabold.ttf", math.floor(HUD_WEAPON_SPRITE_SIZE / 6), false, FONT_QUALITY)
local HUD_WEAPON_AMMO_FONT_BORDER = math.floor(HUD_WEAPON_SPRITE_SIZE / 6 / 8)
local HUD_WEAPON_AMMO_LEFT = HUD_WEAPON_SPRITE_X
local HUD_WEAPON_AMMO_RIGHT = HUD_WEAPON_SPRITE_X + HUD_WEAPON_SPRITE_SIZE
local HUD_WEAPON_AMMO_TOP = HUD_WEAPON_SPRITE_Y + HUD_WEAPON_SPRITE_SIZE + HUD_WEAPON_SPRITE_SIZE/32
local HUD_WEAPON_AMMO_BOTTOM = HUD_WEAPON_AMMO_TOP
local HUD_WEAPON_AMMO_X_ALIGN = "center"
local HUD_WEAPON_AMMO_Y_ALIGN = "bottom"
local HUD_WEAPON_AMMO_COLOR = tocolor(172, 203, 241, 255)

local HUD_ARMOR_ENABLED = true
local HUD_ARMOR_WIDTH = HUD_PROGRESS_BAR_WIDTH
local HUD_ARMOR_HEIGHT = HUD_PROGRESS_BAR_HEIGHT
local HUD_ARMOR_X = HUD_WEAPON_SPRITE_X + HUD_WEAPON_SPRITE_SIZE + HUD_PADDING
local HUD_ARMOR_Y = HUD_TIME_TOP + HUD_TIME_HEIGHT + HUD_PADDING/2
local HUD_ARMOR_COLOR = tocolor(225, 225, 225, 255)

local HUD_OXYGEN_ENABLED = true
local HUD_OXYGEN_WIDTH = HUD_PROGRESS_BAR_WIDTH
local HUD_OXYGEN_HEIGHT = HUD_PROGRESS_BAR_HEIGHT
local HUD_OXYGEN_X = HUD_WEAPON_SPRITE_X + HUD_WEAPON_SPRITE_SIZE + HUD_PADDING
local HUD_OXYGEN_Y = HUD_ARMOR_Y + HUD_ARMOR_HEIGHT + HUD_PADDING/2
local HUD_OXYGEN_COLOR = tocolor(172, 203, 241, 255)

local HUD_HEALTH_ENABLED = true
local HUD_HEALTH_WIDTH = HUD_PROGRESS_BAR_WIDTH
local HUD_HEALTH_HEIGHT = HUD_PROGRESS_BAR_HEIGHT
local HUD_HEALTH_X = HUD_WEAPON_SPRITE_X + HUD_WEAPON_SPRITE_SIZE + HUD_PADDING
local HUD_HEALTH_Y = HUD_OXYGEN_Y + HUD_OXYGEN_HEIGHT + HUD_PADDING/2
local HUD_HEALTH_COLOR = tocolor(180, 25, 29, 255)

local HUD_MONEY_ENABLED = true
local HUD_MONEY_ZEROS = 8
local HUD_MONEY_HEIGHT = HUD_FONT_HEIGHT
local HUD_MONEY_FONT = HUD_FONT
local HUD_MONEY_RIGHT = SCREEN_WIDTH - HUD_RIGHT_OFFSET
local HUD_MONEY_LEFT = 0
local HUD_MONEY_TOP = HUD_WEAPON_SPRITE_Y + HUD_WEAPON_SPRITE_SIZE + HUD_PADDING
local HUD_MONEY_BOTTOM = HUD_MONEY_TOP + HUD_MONEY_HEIGHT
local HUD_MONEY_X_ALIGN = "right"
local HUD_MONEY_Y_ALIGN = "center"
local HUD_MONEY_COLOR = tocolor(54, 104, 44, 255)
local HUD_MONEY_COLOR_NEGATIVE = tocolor(180, 25, 29, 255)

local HUD_WANTED_ENABLED = true
local HUD_WANTED_MAX = 6
local HUD_WANTED_SHOW_MAX = true
local HUD_WANTED_TEXTURE = dxCreateTexture("txd/hud/star" .. TEXTURE_FILE_FORMAT, TEXTURE_QUALITY_FORMAT, TEXTURE_MIPMAPS, TEXTURE_EDGE)
local HUD_WANTED_SIZE = math.floor(HUD_WIDTH / 6)
local HUD_WANTED_RIGHT = SCREEN_WIDTH - HUD_RIGHT_OFFSET
local HUD_WANTED_TOP = HUD_MONEY_BOTTOM + HUD_PADDING*2
local HUD_WANTED_COLOR = tocolor(144, 98, 16, 255)
local HUD_WANTED_EMPTY_COLOR = tocolor(0, 0, 0, 127)


------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

local math_floor = math.floor
local string_gmatch = string.gmatch
local tocolor = tocolor
local getPedStat = getPedStat
local dxDrawText = dxDrawText
local dxGetTextWidth = dxGetTextWidth
local dxDrawImage = dxDrawImage
local dxDrawRectangle = dxDrawRectangle

local function fromcolor(color)

	return
	bitExtract(color, 16, 8),
	bitExtract(color, 8, 8),
	bitExtract(color, 0, 8),
	bitExtract(color, 24, 8)
end

local function dxDrawTextWithOutline(text, x, y, rightX, bottomY, color, scaleXY, scaleY, font, alignX, alignY, offset, ...)

	rightX = rightX or x
	bottomY = bottomY or y
	offset = offset or HUD_FONT_BORDER

	x = x + offset
	y = y + offset
	rightX = rightX - offset
	bottomY = bottomY - offset

	for i = -1, 1 do
		for j = -1, 1 do
			dxDrawText(
				text,
				x + i * offset, y + j * offset,
				rightX + i * offset, bottomY + j * offset,
				tocolor(0, 0, 0, 255),
				scaleXY, scaleY,
				font,
				alignX, alignY, ...)
		end
	end

	return dxDrawText(text, x, y, rightX, bottomY, color, scaleXY, scaleY, font, alignX, alignY, ...)
end

local function dxDrawTextWithOutlineMonospaced(text, x, y, rightX, bottomY, color, scaleXY, scaleY, font, alignX, alignY, offset, ...)

	rightX = rightX or x
	bottomY = bottomY or y

	offset = offset or HUD_FONT_BORDER
	local sw = math_floor(dxGetTextWidth("4", scaleXY, font)) + 1

	x = alignX == "left" and x or (rightX - sw * utf8.len(text) - offset*2)
	x = x + offset
	y = y + offset
	bottomY = bottomY - offset

	for i = -1, 1 do
		for j = -1, 1 do
			local sx = x
			for c in string_gmatch(text, ".") do
				dxDrawText(
					c,
					sx + i * offset, y + j * offset,
					sx + sw + i * offset, bottomY + j * offset,
					tocolor(0, 0, 0, 255),
					scaleXY, scaleY,
					font,
					"center", alignY, ...)
				sx = sx + sw
			end
		end
	end

	local sx = x
	for c in string_gmatch(text, ".") do
		dxDrawText(c, sx, y, sx + sw, bottomY, color, scaleXY, scaleY, font, "center", alignY, ...)
		sx = sx + sw
	end

	return true
end

local function dxDrawImageWithOutline(x, y, w, h, image, rot, rotx, roty, color, postGUI)

	local offset = math_floor(h / 6)

	dxDrawImage(
		x, y,
		w, h,
		image,
		rot, rotx, roty, tocolor(0, 0, 0, 255), postGUI)

	return dxDrawImage(
		x + offset,
		y + offset,
		w - offset * 2,
		h - offset * 2,
		image,
		rot, rotx, roty, color, postGUI)
end

local function dxDrawRectangleProgressBar(x, y, width, height, progress, color)

	progress = (progress < 0 and 0) or (progress > 1 and 1) or progress

	x = math_floor(x)
	y = math_floor(y)
	width = math_floor(width)
	height = math_floor(height)

	local border = HUD_PROGRESS_BAR_BORDER
	local r, g, b, a = fromcolor(color)
	local color2 = tocolor(math_floor(r / 2), math_floor(g / 2), math_floor(b / 2), a)

	dxDrawRectangle(
		x, y,
		width, height,
		tocolor(0, 0, 0, a))

	x = x + border
	y = y + border
	width = width - (border * 2)
	height = height - (border * 2)

	dxDrawRectangle(
		x, y,
		width * progress, height,
		color)

	dxDrawRectangle(
		x + width * progress, y,
		width * (1 - progress), height,
		color2)

	return true
end

local function getPedHealthMax(ped)

	local value = 100 + (getPedStat(ped, 24) - 569) / 4.31
	if value < 1 then return 1 end
	return value
end

local function getPedOxygenLevelMax(ped)

	return 1000 + getPedStat(ped, 225) * 1.5 + getPedStat(ped, 22) * 1.5
end

------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------



local drawData = {}

drawData.weaponSpriteTextures = {}
drawData.showHud = true



------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------


local function loadTexturesHud()

	for id, name in pairs(WEAPON_SPRITE_TEXTURE_NAMES) do
		drawData.weaponSpriteTextures[id] = dxCreateTexture(
			HUD_WEAPON_TEXTURE_PATH .. name .. TEXTURE_FILE_FORMAT,
			TEXTURE_QUALITY_FORMAT,
			TEXTURE_MIPMAPS,
			TEXTURE_EDGE)
	end

	return true
end

local function drawTime()

	if not HUD_TIME_ENABLED then return true end

	local h, m = getTime()

	return dxDrawTextWithOutlineMonospaced(
		string.format("%02d:%02d", h, m),
		HUD_TIME_LEFT, HUD_TIME_TOP,
		HUD_TIME_RIGHT, HUD_TIME_BOTTOM,
		HUD_TIME_COLOR,
		1, 1,
		HUD_TIME_FONT,
		HUD_TIME_X_ALIGN, HUD_TIME_Y_ALIGN)
end

local function drawWeapon()

	if not HUD_WEAPON_ENABLED then return true end

	local weapon = getPedWeapon(localPlayer)
	local texture = drawData.weaponSpriteTextures[weapon]
	if not texture then return false end

	return dxDrawImage(
		HUD_WEAPON_SPRITE_X, HUD_WEAPON_SPRITE_Y + HUD_WEAPON_SPRITE_Y_OFFSET,
		HUD_WEAPON_SPRITE_SIZE, HUD_WEAPON_SPRITE_SIZE,
		texture,
		0, 0, 0,
		HUD_WEAPON_SPRITE_COLOR)
end

local function drawAmmo()

	if not HUD_WEAPON_AMMO_ENABLED then return true end

	local slot = getPedWeaponSlot(localPlayer)
	if slot <= 1 or slot >= 10 then return true end

	local weapon = getPedWeapon(localPlayer)
	local total = getPedTotalAmmo(localPlayer)
	local text = tostring(total)

	if WEAPON_AMMO_CLIPPED[weapon] then
		local clip = getPedAmmoInClip(localPlayer)
		text = (total - clip) .. "-" .. clip
	end

	return dxDrawTextWithOutline(
		text,
		HUD_WEAPON_AMMO_LEFT, HUD_WEAPON_AMMO_TOP,
		HUD_WEAPON_AMMO_RIGHT, HUD_WEAPON_AMMO_BOTTOM,
		HUD_WEAPON_AMMO_COLOR,
		1, 1,
		HUD_WEAPON_AMMO_FONT,
		HUD_WEAPON_AMMO_X_ALIGN, HUD_WEAPON_AMMO_Y_ALIGN,
		HUD_WEAPON_AMMO_FONT_BORDER)
end

local function drawHealth()

	if not HUD_HEALTH_ENABLED then return true end

	local health = getElementHealth(localPlayer)
	if health < 10 and getTickCount() % 800 < 400 then return true end

	local max = getPedHealthMax(localPlayer)

	return dxDrawRectangleProgressBar(
		HUD_HEALTH_X, HUD_HEALTH_Y,
		HUD_HEALTH_WIDTH, HUD_HEALTH_HEIGHT,
		health / max,
		HUD_HEALTH_COLOR)
end

local function drawArmor()

	if not HUD_ARMOR_ENABLED then return true end

	local armor = getPedArmor(localPlayer)
	if armor <= 0 then return true end

	return dxDrawRectangleProgressBar(
		HUD_ARMOR_X, HUD_ARMOR_Y,
		HUD_ARMOR_WIDTH, HUD_ARMOR_HEIGHT,
		armor / 100,
		HUD_ARMOR_COLOR)
end

local function drawOxygen()

	if not HUD_OXYGEN_ENABLED then return true end
	if isPedDead(localPlayer) then return true end

	local level = getPedOxygenLevel(localPlayer)
	local max = getPedOxygenLevelMax(localPlayer)

	if level < max or getPedSimplestTask(localPlayer) == "TASK_SIMPLE_SWIM" then
		dxDrawRectangleProgressBar(
			HUD_OXYGEN_X, HUD_OXYGEN_Y,
			HUD_OXYGEN_WIDTH, HUD_OXYGEN_HEIGHT,
			level / max,
			HUD_OXYGEN_COLOR)
	end

	return true
end

local function formatMoney(money)

	local negative = money < 0
	local str = string.format("%0"..HUD_MONEY_ZEROS.."d", math_floor(negative and (-money) or money))
	return negative and "-$" .. str or "$" .. str
end

local function drawMoney()

	if not HUD_MONEY_ENABLED then return true end

	local money = getPlayerMoney(localPlayer)

	return dxDrawTextWithOutlineMonospaced(
		formatMoney(money),
		HUD_MONEY_LEFT, HUD_MONEY_TOP,
		HUD_MONEY_RIGHT, HUD_MONEY_BOTTOM,
		money >= 0 and HUD_MONEY_COLOR or HUD_MONEY_COLOR_NEGATIVE,
		1, 1,
		HUD_MONEY_FONT,
		HUD_MONEY_X_ALIGN, HUD_MONEY_Y_ALIGN)
end

local function drawWantedLevel()

	if not HUD_WANTED_ENABLED then return true end

	local level = getPlayerWantedLevel()
	if level == 0 then return true end

	local x = HUD_WANTED_RIGHT - HUD_WANTED_SIZE
	for s = 1, level do
		dxDrawImageWithOutline(
			x, HUD_WANTED_TOP,
			HUD_WANTED_SIZE, HUD_WANTED_SIZE,
			HUD_WANTED_TEXTURE,
			0, 0, 0,
			HUD_WANTED_COLOR)
		x = x - HUD_WANTED_SIZE
	end

	if HUD_WANTED_SHOW_MAX then
		for s = level + 1, HUD_WANTED_MAX do
			dxDrawImage(
				x, HUD_WANTED_TOP,
				HUD_WANTED_SIZE, HUD_WANTED_SIZE,
				HUD_WANTED_TEXTURE,
				0, 0, 0,
				HUD_WANTED_EMPTY_COLOR)
			x = x - HUD_WANTED_SIZE
		end
	end

	return true
end

local function drawHud()

	if not drawData.showHud then return true end

	drawTime()
	drawWeapon()
	drawAmmo()
	drawHealth()
	drawArmor()
	drawOxygen()
	drawMoney()
	drawWantedLevel()

	return true
end

local function initHud()

	loadTexturesHud()

	setPlayerHudComponentVisible("ammo", false)
	setPlayerHudComponentVisible("armour", false)
	setPlayerHudComponentVisible("breath", false)
	setPlayerHudComponentVisible("clock", false)
	setPlayerHudComponentVisible("health", false)
	setPlayerHudComponentVisible("money", false)
	setPlayerHudComponentVisible("weapon", false)
	setPlayerHudComponentVisible("wanted", false)

	addEventHandler("onClientRender", root, drawHud, false, "low")

	return true
end

local function termHud()

	setPlayerHudComponentVisible("ammo", true)
	setPlayerHudComponentVisible("armour", true)
	setPlayerHudComponentVisible("breath", true)
	setPlayerHudComponentVisible("clock", true)
	setPlayerHudComponentVisible("health", true)
	setPlayerHudComponentVisible("money", true)
	setPlayerHudComponentVisible("weapon", true)
	setPlayerHudComponentVisible("wanted", true)

	return true
end

addEventHandler("onClientResourceStart", resourceRoot, initHud)
addEventHandler("onClientResourceStop", resourceRoot, termHud)

------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

function getMHudVisible()

	return drawData.showHud
end

function setMHudVisible(visible)

	visible = visible and true or false

	if drawData.showHud == visible then return false end
	drawData.showHud = visible

	return true
end

