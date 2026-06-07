local SCREEN_WIDTH, SCREEN_HEIGHT = guiGetScreenSize()

local TEXTURE_QUALITY_FORMAT = "dxt3"
local TEXTURE_FILE_FORMAT = ".png"
local TEXTURE_MIPMAPS = false
local TEXTURE_EDGE = "clamp"
local TEXTURE_PATH = "txd/crosshair/"

local CROSSHAIR_SHADER_NAME = "crosshair.fx"

local CROSSHAIR_REGULAR_ENABLED = true
local CROSSHAIR_REGULAR_TEXTURE_NAME = "sitem16"
local CROSSHAIR_REGULAR_TEXTURE = dxCreateTexture(
	TEXTURE_PATH .. CROSSHAIR_REGULAR_TEXTURE_NAME .. TEXTURE_FILE_FORMAT,
	TEXTURE_QUALITY_FORMAT,
	true,
	TEXTURE_EDGE)

local CROSSHAIR_CAMERA_ENABLED = true
local CROSSHAIR_CAMERA_SIZE = SCREEN_HEIGHT
local CROSSHAIR_CAMERA_COLOR = tocolor(255, 255, 255, 127)
local CROSSHAIR_CAMERA_TEXTURE_NAME = "cameracrosshair"
local CROSSHAIR_CAMERA_TEXTURE = dxCreateTexture(
	TEXTURE_PATH .. CROSSHAIR_CAMERA_TEXTURE_NAME .. TEXTURE_FILE_FORMAT,
	TEXTURE_QUALITY_FORMAT,
	TEXTURE_MIPMAPS,
	TEXTURE_EDGE)

local CROSSHAIR_ROCKET_ENABLED = true
local CROSSHAIR_ROCKET_SIZE = SCREEN_HEIGHT / 10
local CROSSHAIR_ROCKET_SIZE_OFFSET = CROSSHAIR_ROCKET_SIZE / 4
local CROSSHAIR_ROCKET_COLOR = tocolor(255, 255, 255, 255)
local CROSSHAIR_ROCKET_TEXTURE_NAME = "siterocket"
local CROSSHAIR_ROCKET_TEXTURE = dxCreateTexture(
	TEXTURE_PATH .. CROSSHAIR_ROCKET_TEXTURE_NAME .. TEXTURE_FILE_FORMAT,
	TEXTURE_QUALITY_FORMAT,
	TEXTURE_MIPMAPS,
	TEXTURE_EDGE)

local CROSSHAIR_SNIPER_ENABLED = true
local CROSSHAIR_SNIPER_SIZE = SCREEN_HEIGHT * 5/6
local CROSSHAIR_SNIPER_COLOR = tocolor(255, 255, 255, 255)
local CROSSHAIR_SNIPER_TEXTURE_NAME = "snipercrosshair"
local CROSSHAIR_SNIPER_TEXTURE = dxCreateTexture(
	TEXTURE_PATH .. CROSSHAIR_SNIPER_TEXTURE_NAME .. TEXTURE_FILE_FORMAT,
	TEXTURE_QUALITY_FORMAT,
	TEXTURE_MIPMAPS,
	TEXTURE_EDGE)



local dxDrawImage = dxDrawImage
local dxDrawImageSection = dxDrawImageSection


------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------


local function dxDrawImageQuad(x, y, width, height, image, rot, rotX, rotY, color, postGUI, offset)

	offset = offset or 0

	local off2 = offset * 2
	local w2 = (width - offset) / 2
	local h2 = (height - offset) / 2

	dxDrawImage(x, y, w2, h2, image, rot, rotX, rotY, color, postGUI)
	dxDrawImage(x + w2 + w2 + off2, y, -w2, h2, image, rot, rotX, rotY, color, postGUI)
	dxDrawImage(x + w2 + w2 + off2, y + h2 + h2 + off2, -w2, -h2, image, rot, rotX, rotY, color, postGUI)
	dxDrawImage(x, y + h2 + h2 + off2, w2, -h2, image, rot, rotX, rotY, color, postGUI)

	return true
end

local function dxGetHudFixRatio()

	if dxGetStatus().SettingHUDMatchAspectRatio then return {1, 1/(4/3 * 448/640)} end
	return {SCREEN_WIDTH/SCREEN_HEIGHT * 448/640, 1}
end

local function initCrosshairRegular()

	if not CROSSHAIR_REGULAR_ENABLED then return false end

	local shader = dxCreateShader(CROSSHAIR_SHADER_NAME, 0, 0, false, "world,other")

	dxSetShaderValue(shader, "gTexture", CROSSHAIR_REGULAR_TEXTURE)
	dxSetShaderValue(shader, "fViewportRatio", dxGetHudFixRatio())
	engineApplyShaderToWorldTexture(shader, CROSSHAIR_REGULAR_TEXTURE_NAME)

	return true
end

local function drawCrosshairSniper()

	if not CROSSHAIR_SNIPER_ENABLED then return true end

	setPlayerHudComponentVisible("crosshair", false)

	local x = (SCREEN_WIDTH - CROSSHAIR_SNIPER_SIZE) / 2
	local y = (SCREEN_HEIGHT - CROSSHAIR_SNIPER_SIZE) / 2

	-- background
	dxDrawImageSection(
		0, 0,
		SCREEN_WIDTH, y,
		0, 0, 1, 1,
		CROSSHAIR_SNIPER_TEXTURE,
		0, 0, 0,
		CROSSHAIR_SNIPER_COLOR)
	dxDrawImageSection(
		0, SCREEN_HEIGHT - y,
		SCREEN_WIDTH, y,
		0, 0, 1, 1,
		CROSSHAIR_SNIPER_TEXTURE,
		0, 0, 0,
		CROSSHAIR_SNIPER_COLOR)

	dxDrawImageSection(
		0, y,
		x, SCREEN_HEIGHT - (y * 2),
		0, 0, 1, 1,
		CROSSHAIR_SNIPER_TEXTURE,
		0, 0, 0,
		CROSSHAIR_SNIPER_COLOR)
	dxDrawImageSection(
		SCREEN_WIDTH - x, y,
		x, SCREEN_HEIGHT - (y * 2),
		0, 0, 1, 1,
		CROSSHAIR_SNIPER_TEXTURE,
		0, 0, 0,
		CROSSHAIR_SNIPER_COLOR)


	return dxDrawImageQuad(
		x, y,
		CROSSHAIR_SNIPER_SIZE, CROSSHAIR_SNIPER_SIZE,
		CROSSHAIR_SNIPER_TEXTURE,
		0,
		0,
		0,
		CROSSHAIR_SNIPER_COLOR)
end

local function drawCrosshairCamera()

	if not CROSSHAIR_CAMERA_ENABLED then return true end

	setPlayerHudComponentVisible("crosshair", false)

	return dxDrawImageQuad(
		(SCREEN_WIDTH - CROSSHAIR_CAMERA_SIZE) / 2,
		(SCREEN_HEIGHT - CROSSHAIR_CAMERA_SIZE) / 2,
		CROSSHAIR_CAMERA_SIZE,
		CROSSHAIR_CAMERA_SIZE,
		CROSSHAIR_CAMERA_TEXTURE,
		0,
		0,
		0,
		CROSSHAIR_CAMERA_COLOR)
end

local function drawCrosshairRocket()

	if not CROSSHAIR_ROCKET_ENABLED then return true end

	setPlayerHudComponentVisible("crosshair", false)

	return dxDrawImageQuad(
		(SCREEN_WIDTH - CROSSHAIR_ROCKET_SIZE) / 2,
		(SCREEN_HEIGHT - CROSSHAIR_ROCKET_SIZE) / 2,
		CROSSHAIR_ROCKET_SIZE,
		CROSSHAIR_ROCKET_SIZE,
		CROSSHAIR_ROCKET_TEXTURE,
		0,
		0,
		0,
		CROSSHAIR_ROCKET_COLOR,
		false,
		CROSSHAIR_ROCKET_SIZE_OFFSET)
end

local function drawCrosshairRegular()

	if not CROSSHAIR_REGULAR_ENABLED then return true end

	setPlayerHudComponentVisible("crosshair", true)

	return true
end

local function drawCrosshair()

	if not isPlayerCrosshairVisible() then return true end

	local weapon = getPedWeapon(localPlayer)

	if weapon == 34 then return drawCrosshairSniper() end
	if weapon == 35 or weapon == 36 then return drawCrosshairRocket() end
	if weapon == 43 then return drawCrosshairCamera() end
	return drawCrosshairRegular()
end


------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

local function initCrosshair()

	initCrosshairRegular()

	addEventHandler("onClientHUDRender", root, drawCrosshair)

	return true
end

local function termCrosshair()

	setPlayerHudComponentVisible("crosshair", true)

	return true
end

addEventHandler("onClientResourceStart", resourceRoot, initCrosshair)
addEventHandler("onClientResourceStop", resourceRoot, termCrosshair)

