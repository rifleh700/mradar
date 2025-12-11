local camera = getCamera()


------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------


local SCREEN_WIDTH, SCREEN_HEIGHT = guiGetScreenSize()
local TEXTURE_QUALITY_FORMAT = "dxt3"
local TEXTURE_FILE_FORMAT = ".png"
local TEXTURE_MIPMAPS = false
local TEXTURE_EDGE = "clamp"
local TEXTURE_PATH = "txd/"
local FONT_PATH = "font/"
local FONT_QUALITY = "antialiased"

local MAP_WORLD_SIZE = 6000
local MAP_WORLD_SIZE_HALF = MAP_WORLD_SIZE / 2
local MAP_TILES_SIZE = 12;
local MAP_TILES_SIZE_HALF = MAP_TILES_SIZE / 2
local MAP_TILE_WORLD_SIZE = MAP_WORLD_SIZE / MAP_TILES_SIZE
local MAP_TILE_COLOR = tocolor(255, 255, 255, 255)
local MAP_TILE_INTERIOR_COLOR = tocolor(0, 0, 0, 0)
local MAP_TILE_TEXTURES_PATH = TEXTURE_PATH .. "radar/"

local RADAR_RECTANGLE = false
local RADAR_HEIGHT = (math.min(SCREEN_WIDTH, SCREEN_HEIGHT)) * 0.2           -- WideScreenFix uses 0.1875 (too small I think)
local RADAR_WIDTH = RADAR_RECTANGLE and RADAR_HEIGHT * (3 / 2) or RADAR_HEIGHT
local RADAR_TILES_RT_SIZE = RADAR_RECTANGLE and getDistanceBetweenPoints2D(0, 0, RADAR_WIDTH, RADAR_HEIGHT) or RADAR_HEIGHT
local RADAR_BOTTOM_OFFSET = RADAR_HEIGHT / 4
local RADAR_LEFT_OFFSET = RADAR_BOTTOM_OFFSET * (11 / 6)
local RADAR_SCREEN_X = RADAR_LEFT_OFFSET
local RADAR_SCREEN_Y = SCREEN_HEIGHT - RADAR_BOTTOM_OFFSET - RADAR_HEIGHT
local RADAR_COLOR = tocolor(255, 255, 255, 255)
local RADAR_BORDER_WIDTH = RADAR_HEIGHT / 20
local RADAR_BORDER_FADING = 2
local RADAR_BORDER_COLOR = tocolor(0, 0, 0, 255)
local RADAR_SPRITE_TEXTURES_PATH = TEXTURE_PATH .. "hud/"

local RADAR_MAP_MASK_OFFSET = RADAR_BORDER_WIDTH
local RADAR_MAP_MASK_FADING = 2
-- world radius (or height) of radar
local RADAR_MAP_MIN_RANGE = 180.0                                            -- Radar.cpp: RADAR_MIN_RANGE
local RADAR_MAP_MAX_RANGE = 350.0                                            -- Radar.cpp: RADAR_MAX_RANGE
local RADAR_MAP_MIN_RANGE_SPEED = 0.3                                        -- Radar.cpp: RADAR_MIN_SPEED
local RADAR_MAP_MAX_RANGE_SPEED = 0.9                                        -- Radar.cpp: RADAR_MAX_SPEED
local RADAR_MAP_DRAW_TILES_RADIUS = math.ceil(RADAR_MAP_MAX_RANGE * (RADAR_TILES_RT_SIZE/RADAR_HEIGHT) / MAP_TILE_WORLD_SIZE)
local RADAR_MAP_SHOW_IN_INTERIOR = false

local RING_PLANE_SPRITE_SCALE = 0.8
local ARTIFICIAL_HORIZON_SKY_COLOR = tocolor(0, 0, 0, 0)
local ARTIFICIAL_HORIZON_GROUND_COLOR = tocolor(20, 175, 20, 200)
local ALTIMETER_BG_COLOR = tocolor(10, 10, 10, 100)
local ALTIMETER_BG_WIDTH = RADAR_HEIGHT / 16
local ALTIMETER_BG_HEIGHT = RADAR_HEIGHT - (RADAR_BORDER_WIDTH * 2)
local ALTIMETER_BG_SCREEN_X = RADAR_SCREEN_X - (ALTIMETER_BG_WIDTH * 3)
local ALTIMETER_BG_SCREEN_Y = RADAR_SCREEN_Y + (RADAR_HEIGHT - ALTIMETER_BG_HEIGHT) / 2
local ALTIMETER_COLOR = tocolor(200, 200, 200, 255)
local ALTIMETER_WIDTH = ALTIMETER_BG_WIDTH * 2
local ALTIMETER_HEIGHT = ALTIMETER_WIDTH / 16
local ALTIMETER_SCREEN_X = ALTIMETER_BG_SCREEN_X + (ALTIMETER_BG_WIDTH / 2) - (ALTIMETER_WIDTH / 2)
local ALTIMETER_WORLD_HEIGHT_MAX = 950
local ALTIMETER_WORLD_HEIGHT_LOW = 200

local RADAR_BLIP_COLOR_ENABLED = false
local RADAR_BLIP_SIZE = RADAR_HEIGHT * 0.15
local RADAR_BLIP_SIZE_GTASA_DEFAULT = 2
local RADAR_BLIP_ALPHA_MULTIPLIER = 1
local RADAR_BLIP_VECTOR_OFFSET = RADAR_BORDER_WIDTH / 2
local RADAR_BLIP_TRACE_TEXTURES_PATH = TEXTURE_PATH .. "trace/"
local RADAR_BLIP_CENTRE_SIZE_MULTIPLIER = 0.9
local RADAR_BLIP_TRACE_SIZE_MULTIPLIER = 0.5
local RADAR_BLIP_TRACE_LOW_HEIGHT_DIFF = -4.0
local RADAR_BLIP_TRACE_HIGH_HEIGHT_DIFF = 2

-- F11 map
local BIGMAP_CURSOR_ENABLED = false
local BIGMAP_ATTACH_TO_PLAYER = true
local BIGMAP_HIDE_CHAT = true
local BIGMAP_POST_GUI = false
local BIGMAP_SIZE = math.max(SCREEN_WIDTH, SCREEN_HEIGHT)
local BIGMAP_ZOOM_SCALE_MAX = 4
local BIGMAP_ZOOM_SCALE_MIN = 0.9
local BIGMAP_ZOOM_SCALE_STEP = 0.05
local BIGMAP_ZOOM_SCALE_DEFAULT = 1
local BIGMAP_CHANGE_OPACITY_STEP = 0.05
local BIGMAP_OPACITY_DEFAULT = 0.6
local BIGMAP_MOVE_STEP = math.min(SCREEN_WIDTH, SCREEN_HEIGHT) / 20
local BIGMAP_BLIP_HERE_SIZE = 6

local BIGMAP_TEXT_WINDOW_BG_COLOR = tocolor(0, 0, 0, 190)
local BIGMAP_TEXT_WINDOW_CONTENT_MARGIN = 10

local BIGMAP_HELP_TEXT_COLOR = tocolor(241, 241, 241, 255)
local BIGMAP_HELP_TEXT_FONT = dxCreateFont(FONT_PATH .. "sabankgothic.ttf", 14, false, FONT_QUALITY)

local BIGMAP_LEGEND_ENABLED = true
local BIGMAP_LEGEND_COLUMNS = 3
local BIGMAP_LEGEND_TEXT_COLOR = tocolor(172, 203, 241, 255)
local BIGMAP_LEGEND_TEXT_FONT = dxCreateFont(FONT_PATH .. "sabankgothic.ttf", 16, false, FONT_QUALITY)

local BIGMAP_SWITCH_COMMAND = "radar"
local BIGMAP_ZOOM_IN_COMMAND = "radar_zoom_in"
local BIGMAP_ZOOM_OUT_COMMAND = "radar_zoom_out"
local BIGMAP_OPACITY_UP_COMMAND = "radar_opacity_up"
local BIGMAP_OPACITY_DOWN_COMMAND = "radar_opacity_down"
local BIGMAP_MOVE_NORTH_COMMAND = "radar_move_north"
local BIGMAP_MOVE_SOUTH_COMMAND = "radar_move_south"
local BIGMAP_MOVE_EAST_COMMAND = "radar_move_east"
local BIGMAP_MOVE_WEST_COMMAND = "radar_move_west"
local BIGMAP_SWITCH_HELP_COMMAND = "radar_help"
local BIGMAP_SWITCH_LEGEND_KEY = "l"
local BIGMAP_MOVE_MOUSE_KEY = "mouse1"


------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------


local drawData = {}

drawData.mapTileTextures = {}                    -- Radar.cpp: std::array<std::array<int32, MAX_RADAR_WIDTH_TILES>, MAX_RADAR_HEIGHT_TILES>& gRadarTextures
drawData.hudSpriteTextures = {}                  -- Hud.h: CSprite2d (&Sprites)[6]
drawData.radarSpriteTextures = {}                -- Radar.h: std::array<CSprite2d, MAX_RADAR_SPRITES>& RadarBlipSprites
drawData.radarSpriteBlipTraceTextures = {}       -- custom textures (instead of drawing polygons)

drawData.areRenderTargetsReady = false
drawData.radarCircleShader = dxCreateShader("circle.fx")
drawData.radarShader = dxCreateShader("radar.fx")
drawData.radarMapTilesRt = dxCreateRenderTarget(RADAR_TILES_RT_SIZE, RADAR_TILES_RT_SIZE, true)
drawData.radarArtificialHorizonRt = dxCreateRenderTarget(RADAR_WIDTH, RADAR_HEIGHT, true)
drawData.radarMapMaskRt = dxCreateRenderTarget(RADAR_WIDTH, RADAR_HEIGHT, true, "a8") -- alpha only
drawData.radarBorderRt = dxCreateRenderTarget(RADAR_WIDTH, RADAR_HEIGHT, true)

drawData.cursorPrevPos = { 0, 0 }
drawData.cursorCurrPos = { 0, 0 }
drawData.cursorOnGui = false

drawData.playerElement = nil
drawData.playerElementMatrix = nil                -- Radar.h: CVector2D& vec2DRadarOrigin
drawData.playerCameraAngle = 0                    -- Radar.h: float& m_fRadarOrientation
drawData.playerInterior = nil
drawData.playerDimension = nil
drawData.flashingRadarAreaAlphaMultiplier = 0

drawData.showRadar = true
drawData.radarMapRtView = nil
drawData.radarMapRtRotView = nil                  -- Radar.h: float& cachedCos; float& cachedSin

drawData.showBigMap = false
drawData.showBigMapHelp = true
drawData.showBigMapLegend = false
drawData.bigMapWasMoved = false
drawData.bigMapAlphaMultiplier = BIGMAP_OPACITY_DEFAULT
drawData.bigMapDrawnSprites = {}
drawData.bigMapScreenViewTransform = transform2.scale(BIGMAP_ZOOM_SCALE_DEFAULT, BIGMAP_ZOOM_SCALE_DEFAULT)
drawData.bigMapScreenViewResult = transform2.move(0, 0)


------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------


local function math_clamp(value, min, max)

	return value < min and min or value > max and max or value
end

local function fromcolor(color)

	return
	bitExtract(color, 16, 8),
	bitExtract(color, 8, 8),
	bitExtract(color, 0, 8),
	bitExtract(color, 24, 8)
end

-- same as matrix multiplication but ignoring result rotation
local function getPositionFromMatrixOffset2D(m, x, y)

	local m1 = m[1]
	local m2 = m[2]
	local m3 = m[3]

	return
	x * m1[1] + y * m2[1] + m3[1],
	x * m1[2] + y * m2[2] + m3[2]
end

local function getDistanceBetweenPoints3D(x1, y1, z1, x2, y2, z2)

	local dx = x2 - x1
	local dy = y2 - y1
	local dz = z2 - z1

	return math.sqrt(dx * dx + dy * dy + dz * dz)
end

local function getDistanceBetweenPoints2D(x1, y1, x2, y2)

	local dx = x2 - x1
	local dy = y2 - y1

	return math.sqrt(dx * dx + dy * dy)
end

local function getCursorAbsolutePosition()

	local cx, cy = getCursorPosition()
	return cx and (SCREEN_WIDTH * cx), cy and (SCREEN_HEIGHT * cy)
end

local function getVehicleRealType(vehicle)

	-- defines "Vortex" model as custom "Hovercraft" type (instead of "Plane" type)
	if getElementModel(vehicle) == 539 then
		return VEHICLE_REAL_TYPE.HOVERCRAFT
	end

	return getVehicleType(vehicle)
end

local function getBlipsByInteriorDimensionOrdered(int, dim)

	local orderings = {}
	local blips = {}
	local number = 0

	for _, blip in ipairs(getElementsByType("blip")) do

		if getElementInterior(blip) == int and getElementDimension(blip) == dim then

			number = number + 1
			blips[number] = blip
			orderings[blip] = getBlipOrdering(blip)
		end
	end

	if number <= 1 then return blips end

	table.sort(blips, function(a, b) return orderings[a] < orderings[b] end)

	return blips
end

function dxDrawTextWithShadow(text, x, y, rightX, bottomY, color, scaleXY, scaleY, font, ...)

	x = math.floor(x)
	y = math.floor(y)

	local off = math.floor(dxGetFontHeight(scaleY or scaleXY, font) / 1.75 / 6)
	dxDrawText(text, x + off, y + off, rightX, bottomY, tocolor(0, 0, 0, 255), scaleXY, scaleY, font, ...)
	dxDrawText(text, x, y, rightX, bottomY, color, scaleXY, scaleY, font, ...)
end

local function dxDrawCircle(x, y, size, innerRadius, outerRadius, innerFading, outerFading, color)

	innerRadius = innerRadius or 0
	outerRadius = outerRadius or size / 2
	innerFading = math.max(innerFading or 2, 2)
	outerFading = math.max(outerFading or 2, 2)
	color = color or tocolor(255, 255, 255, 255)

	if innerRadius >= outerRadius then return false end

	dxSetShaderValue(drawData.radarCircleShader, "fInnerRadius", innerRadius / size)
	dxSetShaderValue(drawData.radarCircleShader, "fOuterRadius", outerRadius / size)
	dxSetShaderValue(drawData.radarCircleShader, "fInnerFading", innerFading / size)
	dxSetShaderValue(drawData.radarCircleShader, "fOuterFading", outerFading / size)

	return dxDrawImage(
		x,
		y,
		size,
		size,
		drawData.radarCircleShader,
		0, 0, 0,
		color
	)
end

local function dxDrawRectangleBorder(x, y, width, height, border, color)

	dxDrawRectangle(
		x, y,
		width, border,
		color
	)
	dxDrawRectangle(
		x, y + height - border,
		width, border,
		color
	)
	dxDrawRectangle(
		x, y + border,
		border, height - (border * 2),
		color
	)
	dxDrawRectangle(
		x + width - border, y + border,
		border, height - (border * 2),
		color
	)
	return true
end

------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------


-- CRadar::TransformRadarPointToScreenSpace(CVector2D& out, const CVector2D& in) // 0x583480
local function transformWorldToRadarMapRtView(x, y)

	return getPositionFromMatrixOffset2D(drawData.radarMapRtView, x, y)
end

-- Radar.cpp: CRadar::LoadTextures() // 0x5827D0
-- Hud.cpp: CHud::Initialise() // 0x5BA850
local function loadTextures()

	for id, name in pairs(RADAR_SPRITE_TEXTURE_NAMES) do
		drawData.radarSpriteTextures[id] = dxCreateTexture(
			RADAR_SPRITE_TEXTURES_PATH .. name .. TEXTURE_FILE_FORMAT,
			TEXTURE_QUALITY_FORMAT,
			TEXTURE_MIPMAPS,
			TEXTURE_EDGE
		)
	end

	for id, name in pairs(RADAR_TRACE_TEXTURE_NAMES) do
		drawData.radarSpriteBlipTraceTextures[id] = dxCreateTexture(
			RADAR_BLIP_TRACE_TEXTURES_PATH .. name .. TEXTURE_FILE_FORMAT,
			TEXTURE_QUALITY_FORMAT,
			TEXTURE_MIPMAPS,
			TEXTURE_EDGE
		)
	end

	for id, name in pairs(HUD_SPRITE_TEXTURE_NAMES) do
		drawData.hudSpriteTextures[id] = dxCreateTexture(
			RADAR_SPRITE_TEXTURES_PATH .. name .. TEXTURE_FILE_FORMAT,
			TEXTURE_QUALITY_FORMAT,
			TEXTURE_MIPMAPS,
			TEXTURE_EDGE
		)
	end

	for y = 0, MAP_TILES_SIZE - 1 do
		drawData.mapTileTextures[y] = {}
		for x = 0, MAP_TILES_SIZE - 1 do
			drawData.mapTileTextures[y][x] = dxCreateTexture(
				MAP_TILE_TEXTURES_PATH .. "radar" .. string.format("%02d", (y * MAP_TILES_SIZE + x)) .. TEXTURE_FILE_FORMAT,
				TEXTURE_QUALITY_FORMAT,
				TEXTURE_MIPMAPS,
				TEXTURE_EDGE
			)
		end
	end

	return true
end

-- Radar.cpp: CRadar::Initialise() // 0x587FB0
local function init()

	loadTextures()

	setPlayerHudComponentVisible("radar", false)
	toggleControl("radar", false)
	toggleControl("radar_zoom_in", false)
	toggleControl("radar_zoom_out", false)
	toggleControl("radar_move_north", false)
	toggleControl("radar_move_south", false)
	toggleControl("radar_move_east", false)
	toggleControl("radar_move_west", false)
	toggleControl("radar_opacity_down", false)
	toggleControl("radar_opacity_up", false)
	toggleControl("radar_help", false)

	return true
end

local function term()

	setPlayerHudComponentVisible("radar", true)
	toggleControl("radar", true)
	toggleControl("radar_zoom_in", true)
	toggleControl("radar_zoom_out", true)
	toggleControl("radar_move_north", true)
	toggleControl("radar_move_south", true)
	toggleControl("radar_move_east", true)
	toggleControl("radar_move_west", true)
	toggleControl("radar_opacity_down", true)
	toggleControl("radar_opacity_up", true)
	toggleControl("radar_help", true)

	return true
end

-- Radar.cpp: CRadar::DrawMap() // 0x586B00
local function calcRadarMapRange(element, matrix)

	if getElementType(element) ~= "vehicle" then return RADAR_MAP_MIN_RANGE end

	local speed = 0
	if getVehicleRealType(element) == VEHICLE_REAL_TYPE.PLANE then
		-- actually this is height ratio, not speed
		speed = matrix[4][3] / ALTIMETER_WORLD_HEIGHT_LOW
	else
		local vx, vy, vz = getElementVelocity(element)
		speed = getDistanceBetweenPoints3D(0, 0, 0, vx, vy, vz)
	end

	if speed < RADAR_MAP_MIN_RANGE_SPEED then
		return RADAR_MAP_MIN_RANGE -- original plane's min range value is (RADAR_MAX_RANGE - 10.0)
	end
	if speed >= RADAR_MAP_MAX_RANGE_SPEED then
		return RADAR_MAP_MAX_RANGE
	end

	return (speed - RADAR_MAP_MIN_RANGE_SPEED)
		/ (RADAR_MAP_MAX_RANGE_SPEED - RADAR_MAP_MIN_RANGE_SPEED)
		* (RADAR_MAP_MAX_RANGE - RADAR_MAP_MIN_RANGE)
		+ RADAR_MAP_MIN_RANGE
end

local function prepareRadarMaskRt()

	dxSetRenderTarget(drawData.radarMapMaskRt, true)
	dxSetBlendMode("overwrite")

	if RADAR_RECTANGLE then

		dxDrawRectangle(
			RADAR_MAP_MASK_OFFSET,
			RADAR_MAP_MASK_OFFSET,
			RADAR_WIDTH - RADAR_MAP_MASK_OFFSET * 2,
			RADAR_HEIGHT - RADAR_MAP_MASK_OFFSET * 2,
			tocolor(255, 255, 255, 255)
		)

	else

		dxDrawCircle(
			0,
			0,
			RADAR_HEIGHT,
			0,
			RADAR_HEIGHT / 2 - RADAR_MAP_MASK_OFFSET,
			0,
			RADAR_MAP_MASK_FADING,
			tocolor(255, 255, 255, 255))
	end

	dxSetRenderTarget()
	dxSetBlendMode("blend")

	dxSetShaderValue(drawData.radarShader, "gMaskTexture", drawData.radarMapMaskRt)

	return true
end

local function prepareRadarBorderRt()

	dxSetRenderTarget(drawData.radarBorderRt, true)
	dxSetBlendMode("overwrite")

	if RADAR_RECTANGLE then
		dxDrawRectangleBorder(
			0,
			0,
			RADAR_WIDTH,
			RADAR_HEIGHT,
			RADAR_BORDER_WIDTH,
			RADAR_BORDER_COLOR)

	else
		dxDrawCircle(
			0, 0,
			RADAR_HEIGHT,
			RADAR_HEIGHT / 2 - RADAR_BORDER_WIDTH,
			RADAR_HEIGHT / 2,
			RADAR_BORDER_FADING,
			0,
			RADAR_BORDER_COLOR)
	end

	dxSetRenderTarget()
	dxSetBlendMode("blend")

	dxSetShaderValue(drawData.radarShader, "gBorderTexture", drawData.radarBorderRt)

	return true
end

-- Radar.h: IsMapSectionInBounds(int32 x, int32 y)
local function isMapTileInBounds(x, y)

	return x >= 0 and x < MAP_TILES_SIZE and y >= 0 and y < MAP_TILES_SIZE;
end

-- Radar.cpp: CRadar::DrawRadarSection(int32 x, int32 y) // 0x586110
local function drawRadarMapTile(tx, ty)

	-- Radar.cpp: GetTextureCorners(int32 x, int32 y, CVector2D* corners) // 0x584D90
	-- Top left tile world corner
	local wx = MAP_TILE_WORLD_SIZE * (tx - MAP_TILES_SIZE_HALF)
	local wy = MAP_TILE_WORLD_SIZE * (MAP_TILES_SIZE_HALF - ty)

	-- Move by player position and scale
	local rtx, rty = transformWorldToRadarMapRtView(wx, wy)
	local rtx2, rty2 = transformWorldToRadarMapRtView(wx + MAP_TILE_WORLD_SIZE, wy - MAP_TILE_WORLD_SIZE)

	if RADAR_MAP_SHOW_IN_INTERIOR or drawData.playerInterior == 0 then

		if isMapTileInBounds(tx, ty) then

			dxDrawImage(
				rtx, rty,
				rtx2 - rtx, rty2 - rty,
				drawData.mapTileTextures[ty][tx],
				0, 0, 0,
				MAP_TILE_COLOR
			)
		else

			-- as sea draws first pixel of top left tile
			dxDrawImageSection(
				rtx, rty,
				rtx2 - rtx, rty2 - rty,
				0, 0, 1, 1,
				drawData.mapTileTextures[0][0],
				0, 0, 0,
				MAP_TILE_COLOR
			)
		end

	else

		dxDrawRectangle(
			rtx, rty,
			rtx2 - rtx, rty2 - rty,
			MAP_TILE_INTERIOR_COLOR,
			false,
			true
		)
	end

	return true
end

local function drawRadarMapTiles()

	local x = math.floor((drawData.playerElementMatrix[4][1] + MAP_WORLD_SIZE_HALF) / MAP_TILE_WORLD_SIZE)
	local y = math.ceil(MAP_TILES_SIZE - 1 - (drawData.playerElementMatrix[4][2] + MAP_WORLD_SIZE_HALF) / MAP_TILE_WORLD_SIZE)

	dxSetRenderTarget(drawData.radarMapTilesRt, true)
	dxSetBlendMode("modulate_add")

	for dy = -RADAR_MAP_DRAW_TILES_RADIUS, RADAR_MAP_DRAW_TILES_RADIUS do
		for dx = -RADAR_MAP_DRAW_TILES_RADIUS, RADAR_MAP_DRAW_TILES_RADIUS do
			drawRadarMapTile(x + dx, y + dy);
		end
	end

	dxSetBlendMode("blend")
	dxSetRenderTarget()

	return true
end

local function calcFlashingRadarAreaAlphaMultiplier()

	return (math.sin((getTickCount() % 1024) / (1024 / (math.pi * 2))) + 1.0) / 2.0
end

local function drawRadarArea(area)

	local dim = getElementDimension(area)
	if dim ~= drawData.playerDimension then return false end

	local int = getElementInterior(area)
	if int ~= drawData.playerInterior then return false end

	local x, y, _ = getElementPosition(area)
	local px, py = drawData.playerElementMatrix[4][1], drawData.playerElementMatrix[4][2]
	if x > px + RADAR_MAP_MAX_RANGE then return false end
	if y > py + RADAR_MAP_MAX_RANGE then return false end

	local width, height = getRadarAreaSize(area)
	if x + width < px - RADAR_MAP_MAX_RANGE then return false end
	if y + height < py - RADAR_MAP_MAX_RANGE then return false end

	local x1, y1 = transformWorldToRadarMapRtView(x, y + height)
	local x2, y2 = transformWorldToRadarMapRtView(x + width, y)
	local r, g, b, a = getRadarAreaColor(area)
	if isRadarAreaFlashing(area) then
		a = a * drawData.flashingRadarAreaAlphaMultiplier
	end

	dxDrawRectangle(
		x1, y1,
		x2 - x1, y2 - y1,
		tocolor(r, g, b, a),
		false,
		true
	)

	return true
end

-- Radar.cpp: CRadar::DrawRadarGangOverlay(bool inMenu) // 0x586650
local function drawRadarAreas()

	dxSetRenderTarget(drawData.radarMapTilesRt)
	dxSetBlendMode("modulate_add")

	for i, area in ipairs(getElementsByType("radararea")) do
		drawRadarArea(area)
	end

	dxSetBlendMode("blend")
	dxSetRenderTarget()

	return true
end

local function drawArtificialHorizon()

	dxSetRenderTarget(drawData.radarArtificialHorizonRt, true)
	dxSetBlendMode("overwrite")

	dxDrawRectangle(
		0, 0,
		RADAR_WIDTH, RADAR_HEIGHT / 2,
		ARTIFICIAL_HORIZON_SKY_COLOR,
		false,
		true
	)
	dxDrawRectangle(
		0, RADAR_HEIGHT / 2,
		RADAR_WIDTH, RADAR_HEIGHT / 2,
		ARTIFICIAL_HORIZON_GROUND_COLOR,
		false,
		true
	)

	dxSetRenderTarget()
	dxSetBlendMode("blend")

	dxSetShaderValue(drawData.radarShader, "gArtificialHorizonTexture", drawData.radarArtificialHorizonRt)

	return true
end

local function drawAltimeter()

	if getElementType(drawData.playerElement) ~= "vehicle" then return true end

	local vehicleRealType = getVehicleRealType(drawData.playerElement)
	if not (vehicleRealType == VEHICLE_REAL_TYPE.PLANE or vehicleRealType == VEHICLE_REAL_TYPE.HELICOPTER) then return true end

	dxDrawRectangle(
		ALTIMETER_BG_SCREEN_X, ALTIMETER_BG_SCREEN_Y,
		ALTIMETER_BG_WIDTH, ALTIMETER_BG_HEIGHT,
		ALTIMETER_BG_COLOR,
		false,
		true
	)

	local height = drawData.playerElementMatrix[4][3]
	local limit = ALTIMETER_WORLD_HEIGHT_MAX
	if height <= ALTIMETER_WORLD_HEIGHT_LOW then
		limit = ALTIMETER_WORLD_HEIGHT_LOW
	end

	dxDrawRectangle(
		ALTIMETER_SCREEN_X,
		ALTIMETER_BG_SCREEN_Y + ALTIMETER_BG_HEIGHT * (math_clamp(1 - height / limit, 0, 1)),
		ALTIMETER_WIDTH,
		ALTIMETER_HEIGHT,
		ALTIMETER_COLOR,
		false,
		true
	)

	return true
end

local function drawRadarShader()

	-- TODO: move scaling by speed into shader (?)
	dxSetShaderValue(drawData.radarShader, "gTilesTexture", drawData.radarMapTilesRt)
	dxSetShaderValue(drawData.radarShader, "gTilesRot", -drawData.playerCameraAngle)

	dxSetShaderValue(drawData.radarShader, "gPlane", drawData.playerInPlane)
	if drawData.playerInPlane then
		-- TODO: move matrix into shader (?)
		dxSetShaderValue(drawData.radarShader, "gRingPlaneRot", math.atan2(drawData.playerElementMatrix[1][3], drawData.playerElementMatrix[3][3]))
		dxSetShaderValue(drawData.radarShader, "gArtificialHorizonRatio", math.atan2(drawData.playerElementMatrix[2][3], drawData.playerElementMatrix[3][3]) / math.pi / 2)
	end

	return dxDrawImage(
		RADAR_SCREEN_X,
		RADAR_SCREEN_Y,
		RADAR_WIDTH,
		RADAR_HEIGHT,
		drawData.radarShader,
		0, 0, 0,
		RADAR_COLOR
	)
end

-- Radar.cpp: CRadar::LimitRadarPoint(CVector2D& point) // 0x5832F0
local function limitVectorLength(x1, y1, x2, y2, limit)

	local length = getDistanceBetweenPoints2D(x1, y1, x2, y2)
	if length > limit then
		local k = limit / length
		x2, y2 = (x2 - x1) * k + x1, (y2 - y1) * k + y1
	end

	return x2, y2
end

local function limitVectorLengthRectangle(x1, y1, x2, y2, xl, yl)

	local x = x2 - x1
	local y = y2 - y1

	-- Avoid division by zero when vector components are zero
	local kx = (x ~= 0) and math.min(1, math.abs(xl / x)) or 1
	local ky = (y ~= 0) and math.min(1, math.abs(yl / y)) or 1
	local k = math.min(kx, ky)

	return x * k + x1, y * k + y1
end

-- Radar.cpp: GetRadarAndScreenPos(float* radarPointDist)
-- Radar.h: CachedRotateClockwise(const CVector2D& point)
local function transformWorldToRadarMapBlipView(x, y)

	x, y = getPositionFromMatrixOffset2D(drawData.radarMapRtRotView, x, y)

	if RADAR_RECTANGLE then
		return limitVectorLengthRectangle(
			RADAR_WIDTH / 2,
			RADAR_HEIGHT / 2,
			x,
			y,
			RADAR_WIDTH / 2 - RADAR_BLIP_VECTOR_OFFSET,
			RADAR_HEIGHT / 2 - RADAR_BLIP_VECTOR_OFFSET) end

	return limitVectorLength(
		RADAR_HEIGHT / 2,
		RADAR_HEIGHT / 2,
		x,
		y,
		RADAR_HEIGHT / 2 - RADAR_BLIP_VECTOR_OFFSET)
end

local function getRadarSpriteBlipTraceFromHeight(z)

	local diff = z - drawData.playerElementMatrix[4][3]
	if diff > RADAR_BLIP_TRACE_HIGH_HEIGHT_DIFF then return RADAR_TRACE.HIGH end
	if diff < RADAR_BLIP_TRACE_LOW_HEIGHT_DIFF then return RADAR_TRACE.LOW; end
	return RADAR_TRACE.NORMAL
end

local function getRadarSpriteBlipSize(spriteId, size)

	size = size / RADAR_BLIP_SIZE_GTASA_DEFAULT * RADAR_BLIP_SIZE

	if spriteId == RADAR_SPRITE.CENTRE then return size * RADAR_BLIP_CENTRE_SIZE_MULTIPLIER end
	if spriteId == RADAR_SPRITE.NONE then return size * RADAR_BLIP_TRACE_SIZE_MULTIPLIER end
	return size
end

-- Radar.cpp: CRadar::DrawRadarSprite(eRadarSprite spriteId, float x, float y, uint8 alpha) // 0x585FF0
local function drawRadarSprite(spriteId, x, y, z, r, g, b, a, size, rot)

	x, y = transformWorldToRadarMapBlipView(x, y)
	rot = rot and (math.deg(drawData.playerCameraAngle) - rot) or 0
	size = getRadarSpriteBlipSize(spriteId, size)
	a = a * RADAR_BLIP_ALPHA_MULTIPLIER

	local texture = drawData.radarSpriteTextures[spriteId]
	if spriteId == RADAR_SPRITE.NONE then
		texture = drawData.radarSpriteBlipTraceTextures[getRadarSpriteBlipTraceFromHeight(z)]
	end
	if not texture then return false end

	-- for CENTRE blip center is [0.5, 2/3]
	if spriteId == RADAR_SPRITE.CENTRE then

		dxDrawImage(
			RADAR_SCREEN_X + x - (size / 2), RADAR_SCREEN_Y + y - (size * 2 / 3),
			math.floor(size), math.floor(size),
			texture,
			rot, 0, size * 1 / 6,
			tocolor(r, g, b, a)
		)
	else

		dxDrawImage(
			RADAR_SCREEN_X + x - (size / 2), RADAR_SCREEN_Y + y - (size / 2),
			math.floor(size), math.floor(size),
			texture,
			rot, 0, 0,
			tocolor(r, g, b, a)
		)
	end

	return true
end

-- Radar.cpp: CRadar::DrawCoordBlip(int32 blipIndex, bool isSprite) // 0x586D60
local function drawRadarBlip(blip)

	local x, y, z = getElementPosition(blip)
	local limit = getBlipVisibleDistance(blip)

	if limit <= 0 then return false end
	if limit < MAP_WORLD_SIZE then
		local dis = getDistanceBetweenPoints2D(
			drawData.playerElementMatrix[4][1], drawData.playerElementMatrix[4][2],
			x, y)
		if dis > limit then return false end
	end

	local icon = getBlipIcon(blip)
	local r, g, b, a = getBlipColor(blip)
	if (not RADAR_BLIP_COLOR_ENABLED) and (icon ~= RADAR_SPRITE.NONE) then
		r, g, b = 255, 255, 255
	end

	drawRadarSprite(icon, x, y, z, r, g, b, a, getBlipSize(blip));

	return true
end

-- Radar.cpp: CRadar::DrawBlips() // 0x588050
local function drawRadarBlips()

	drawRadarSprite(
		RADAR_SPRITE.NORTH,
		drawData.playerElementMatrix[4][1],
		drawData.playerElementMatrix[4][2] + MAP_WORLD_SIZE,
		drawData.playerElementMatrix[4][3],
		255, 255, 255, 255,
		RADAR_BLIP_SIZE_GTASA_DEFAULT)

	for _, blip in ipairs(getBlipsByInteriorDimensionOrdered(drawData.playerInterior, drawData.playerDimension)) do
		drawRadarBlip(blip)
	end

	if not (getElementType(drawData.playerElement) == "vehicle" and getVehicleRealType(drawData.playerElement) == VEHICLE_REAL_TYPE.PLANE) then

		drawRadarSprite(
			RADAR_SPRITE.CENTRE,
			drawData.playerElementMatrix[4][1],
			drawData.playerElementMatrix[4][2],
			drawData.playerElementMatrix[4][3],
			255, 255, 255, 255,
			RADAR_BLIP_SIZE_GTASA_DEFAULT,
			math.deg(math.atan2(-drawData.playerElementMatrix[2][1], drawData.playerElementMatrix[2][2]))
		)
	end

	return true
end

local function updateRadarMapRtViews()

	-- Radar.h: float& m_radarRange (radar world radius)
	local radarMapRange = calcRadarMapRange(drawData.playerElement, drawData.playerElementMatrix)

	local worldToRtRelView = transform2.mul(
		transform2.move(-drawData.playerElementMatrix[4][1], -drawData.playerElementMatrix[4][2]),
		transform2.scale(1 / radarMapRange, -1 / radarMapRange))

	drawData.radarMapRtView = transform2.mul(
		worldToRtRelView,
		transform2.mul(transform2.mul(
			transform2.move(1, 1),
			transform2.scale(RADAR_HEIGHT / 2, RADAR_HEIGHT / 2)),
			transform2.move((RADAR_TILES_RT_SIZE - RADAR_HEIGHT) / 2, (RADAR_TILES_RT_SIZE - RADAR_HEIGHT) / 2)))

	drawData.radarMapRtRotView = transform2.mul(transform2.mul(
		worldToRtRelView,
		transform2.rotate(drawData.playerCameraAngle)),
		transform2.mul(transform2.mul(
			transform2.move(1, 1),
			transform2.scale(RADAR_HEIGHT / 2, RADAR_HEIGHT / 2)),
			transform2.move((RADAR_WIDTH - RADAR_HEIGHT) / 2, 0)))

	return true
end

-- Hud.cpp: CHud::DrawRadar() // 0x58A330
local function drawRadar()

	setPlayerHudComponentVisible("radar", false)

	if not drawData.showRadar then return true end
	if drawData.showBigMap then return true end

	updateRadarMapRtViews()

	if not drawData.areRenderTargetsReady then
		prepareRadarMaskRt()
		prepareRadarBorderRt()
		drawArtificialHorizon()
		dxSetShaderValue(drawData.radarShader, "gTilesScale", RADAR_WIDTH / RADAR_TILES_RT_SIZE, RADAR_HEIGHT / RADAR_TILES_RT_SIZE)
		dxSetShaderValue(drawData.radarShader, "gRingPlaneTexture", drawData.hudSpriteTextures[HUD_SPRITE.RADAR_RING_PLANE])
		dxSetShaderValue(drawData.radarShader, "gRingPlaneScale", 1 / RING_PLANE_SPRITE_SCALE)
		drawData.areRenderTargetsReady = true
	end

	drawRadarMapTiles()
	drawRadarAreas()
	drawAltimeter()
	drawRadarShader()
	drawRadarBlips()

	return true
end

local function transformWorldToBigMapScreenView(x, y)

	return getPositionFromMatrixOffset2D(drawData.bigMapScreenViewResult, x, y)
end

local function moveBigMap(x, y)

	drawData.bigMapScreenViewTransform = transform2.mul(
		drawData.bigMapScreenViewTransform,
		transform2.move(x, y))

	-- TODO: refactor
	local scale = drawData.bigMapScreenViewTransform[1][1]
	local bigMapSize = BIGMAP_SIZE * scale
	local bigMapSizeBordered = bigMapSize / BIGMAP_ZOOM_SCALE_MIN

	local x0 = (SCREEN_WIDTH - bigMapSize) / 2
	local y0 = (SCREEN_HEIGHT - bigMapSize) / 2

	local dx = math.max(0, (bigMapSizeBordered - SCREEN_WIDTH) / 2)
	local dy = math.max(0, (bigMapSizeBordered - SCREEN_HEIGHT) / 2)

	drawData.bigMapScreenViewTransform[3][1] = math_clamp(drawData.bigMapScreenViewTransform[3][1], x0 - dx, x0 + dx)
	drawData.bigMapScreenViewTransform[3][2] = math_clamp(drawData.bigMapScreenViewTransform[3][2], y0 - dy, y0 + dy)

	return true
end

local function updateBigMapCursorMoving()

	if not BIGMAP_CURSOR_ENABLED then return end
	if not drawData.showBigMap then return end
	if not isCursorShowing() then return end
	if not getKeyState(BIGMAP_MOVE_MOUSE_KEY) then return end
	if guiGetInputEnabled() then return end
	if isMTAWindowActive() then return end
	if (not BIGMAP_POST_GUI) and drawData.cursorOnGui then return end

	drawData.bigMapWasMoved = true

	moveBigMap(
		drawData.cursorCurrPos[1] - drawData.cursorPrevPos[1],
		drawData.cursorCurrPos[2] - drawData.cursorPrevPos[2])

	return true
end

local function updateBigMapPlayerMoving()

	if not BIGMAP_ATTACH_TO_PLAYER then return end
	if not drawData.showBigMap then return end
	if drawData.bigMapWasMoved then return end

	local x, y = transformWorldToBigMapScreenView(drawData.playerElementMatrix[4][1], drawData.playerElementMatrix[4][2])
	moveBigMap(-x + SCREEN_WIDTH / 2, -y + SCREEN_HEIGHT / 2)

	return true
end

local function updateBigMapScreenView()

	drawData.bigMapScreenViewResult = transform2.mul(transform2.mul(transform2.mul(
		transform2.scale(1 / MAP_WORLD_SIZE, -1 / MAP_WORLD_SIZE),
		transform2.move(0.5, 0.5)),
		transform2.scale(BIGMAP_SIZE, BIGMAP_SIZE)),
		drawData.bigMapScreenViewTransform)

	return true
end

local function drawBigMapTiles()

	local sx1, sy1 = transformWorldToBigMapScreenView(-MAP_WORLD_SIZE_HALF, MAP_WORLD_SIZE_HALF)
	local sx2, sy2 = transformWorldToBigMapScreenView(MAP_WORLD_SIZE_HALF, -MAP_WORLD_SIZE_HALF)
	local size = (sx2 - sx1) / MAP_TILES_SIZE

	local r, g, b, a = fromcolor(MAP_TILE_COLOR)
	a = a * drawData.bigMapAlphaMultiplier
	local color = tocolor(r, g, b, a)

	for ty = 0, MAP_TILES_SIZE - 1 do
		for tx = 0, MAP_TILES_SIZE - 1 do

			dxDrawImage(
				sx1 + (tx * size), sy1 + (ty * size),
				size, size,
				drawData.mapTileTextures[ty][tx],
				0, 0, 0,
				color,
				BIGMAP_POST_GUI
			)
		end
	end

	-- draws sea background
	dxDrawImageSection(
		0, 0,
		sx1, SCREEN_HEIGHT,
		0, 0, 1, 1,
		drawData.mapTileTextures[0][0],
		0, 0, 0,
		color,
		BIGMAP_POST_GUI
	)
	dxDrawImageSection(
		sx2, 0,
		SCREEN_WIDTH - sx2, SCREEN_HEIGHT,
		0, 0, 1, 1,
		drawData.mapTileTextures[0][0],
		0, 0, 0,
		color,
		BIGMAP_POST_GUI
	)
	dxDrawImageSection(
		sx1, 0,
		sx2 - sx1, sy1,
		0, 0, 1, 1,
		drawData.mapTileTextures[0][0],
		0, 0, 0,
		color,
		BIGMAP_POST_GUI
	)
	dxDrawImageSection(
		sx1, sy2,
		sx2 - sx1, SCREEN_HEIGHT - sy2,
		0, 0, 1, 1,
		drawData.mapTileTextures[0][0],
		0, 0, 0,
		color,
		BIGMAP_POST_GUI
	)

	return true
end

local function drawBigMapRadarArea(area)

	local dim = getElementDimension(area)
	if dim ~= drawData.playerDimension then return false end

	local int = getElementInterior(area)
	if int ~= drawData.playerInterior then return false end

	local x, y, _ = getElementPosition(area)
	local width, height = getRadarAreaSize(area)

	local x1, y1 = transformWorldToBigMapScreenView(x, y + height)
	local x2, y2 = transformWorldToBigMapScreenView(x + width, y)
	local r, g, b, a = getRadarAreaColor(area)
	a = a * drawData.bigMapAlphaMultiplier
	if isRadarAreaFlashing(area) then
		a = a * drawData.flashingRadarAreaAlphaMultiplier
	end

	dxDrawRectangle(
		x1, y1,
		x2 - x1, y2 - y1,
		tocolor(r, g, b, a),
		BIGMAP_POST_GUI,
		true
	)

	return true
end

local function drawBigMapRadarAreas()

	for i, area in ipairs(getElementsByType("radararea")) do
		drawBigMapRadarArea(area)
	end

	return true
end

local function drawBigMapSprite(spriteId, x, y, z, r, g, b, a, size, rot)

	x, y = transformWorldToBigMapScreenView(x, y)
	rot = rot and (-rot) or 0
	size = getRadarSpriteBlipSize(spriteId, size)
	a = a * drawData.bigMapAlphaMultiplier

	local texture = drawData.radarSpriteTextures[spriteId]
	if spriteId == RADAR_SPRITE.NONE then
		texture = drawData.radarSpriteBlipTraceTextures[getRadarSpriteBlipTraceFromHeight(z)]
	end
	if not texture then return false end

	-- for MAP_HERE blip center is [0.5, 0.0]
	if spriteId == RADAR_SPRITE.MAP_HERE then

		dxDrawImage(
			x - (size / 2), y,
			size, size,
			texture,
			rot, 0, -size / 2,
			tocolor(r, g, b, a),
			BIGMAP_POST_GUI
		)
	else

		dxDrawImage(
			x - (size / 2), y - (size / 2),
			size, size,
			texture,
			rot, 0, 0,
			tocolor(r, g, b, a),
			BIGMAP_POST_GUI
		)
	end

	drawData.bigMapDrawnSprites[spriteId] = true

	return true
end

local function drawBigMapBlip(blip)

	local x, y, z = getElementPosition(blip)

	local icon = getBlipIcon(blip)
	local r, g, b, a = getBlipColor(blip)
	if (not RADAR_BLIP_COLOR_ENABLED) and (icon ~= RADAR_SPRITE.NONE) then
		r, g, b = 255, 255, 255
	end

	drawBigMapSprite(icon, x, y, z, r, g, b, a, getBlipSize(blip));

	return true
end

local function drawBigMapBlips()

	for _, blip in ipairs(getBlipsByInteriorDimensionOrdered(drawData.playerInterior, drawData.playerDimension)) do
		drawBigMapBlip(blip)
	end

	drawBigMapSprite(
		RADAR_SPRITE.MAP_HERE,
		drawData.playerElementMatrix[4][1],
		drawData.playerElementMatrix[4][2],
		drawData.playerElementMatrix[4][3],
		255, 255, 255, 255 * (getTickCount() % 1000 < 700 and 1 or 0),
		BIGMAP_BLIP_HERE_SIZE,
		math.deg(math.atan2(-drawData.playerElementMatrix[2][1], drawData.playerElementMatrix[2][2]))
	)

	return true
end

local function getControlsKeys(controls)

	local keys = {}

	for i, control in ipairs(controls) do
		local t = getBoundKeys(control)
		if t then
			for key, state in pairs(t) do
				table.insert(keys, key)
			end
		end
	end

	table.sort(keys)

	return keys
end

local function drawBigMapHelp()

	if not drawData.showBigMapHelp then return false end

	local rows = {
		{ "help", table.concat(getControlsKeys({ BIGMAP_SWITCH_HELP_COMMAND }), " / ") },
		{ "legend", BIGMAP_SWITCH_LEGEND_KEY },
		{ "zoom", table.concat(getControlsKeys({ BIGMAP_ZOOM_IN_COMMAND, BIGMAP_ZOOM_OUT_COMMAND }), " / ") },
		{ "move", (BIGMAP_CURSOR_ENABLED and "mouse1 / " or "") .. table.concat(getControlsKeys({ BIGMAP_MOVE_NORTH_COMMAND, BIGMAP_MOVE_SOUTH_COMMAND, BIGMAP_MOVE_EAST_COMMAND, BIGMAP_MOVE_WEST_COMMAND }), " / ") },
		{ "opacity", table.concat(getControlsKeys({ BIGMAP_OPACITY_UP_COMMAND, BIGMAP_OPACITY_DOWN_COMMAND }), " / ") }
	}

	local actionTextWidth = 0
	local keysTextWidth = 0
	for i, row in ipairs(rows) do
		row[1] = row[1]
		row[2] = row[2]
		actionTextWidth = math.max(actionTextWidth, dxGetTextWidth(row[1], 1, BIGMAP_HELP_TEXT_FONT))
		keysTextWidth = math.max(keysTextWidth, dxGetTextWidth(row[2], 1, BIGMAP_HELP_TEXT_FONT))
	end

	local textHeight = dxGetFontHeight(1, BIGMAP_HELP_TEXT_FONT)
	local bgWidth = math.floor(actionTextWidth + BIGMAP_TEXT_WINDOW_CONTENT_MARGIN * 2 + keysTextWidth + (BIGMAP_TEXT_WINDOW_CONTENT_MARGIN * 2))
	local bgHeight = math.floor(textHeight * #rows + (BIGMAP_TEXT_WINDOW_CONTENT_MARGIN * 2))
	local bgX = math.floor((SCREEN_WIDTH - bgWidth) / 2)
	local bgY = math.floor(SCREEN_HEIGHT - bgHeight - BIGMAP_TEXT_WINDOW_CONTENT_MARGIN)

	dxDrawRectangle(
		bgX, bgY,
		bgWidth, bgHeight,
		BIGMAP_TEXT_WINDOW_BG_COLOR,
		BIGMAP_POST_GUI,
		false
	)

	for i, row in ipairs(rows) do

		local x = bgX + BIGMAP_TEXT_WINDOW_CONTENT_MARGIN
		local y = bgY + BIGMAP_TEXT_WINDOW_CONTENT_MARGIN + ((i - 1) * textHeight)
		dxDrawTextWithShadow(
			row[1],
			x, y, nil, nil,
			BIGMAP_HELP_TEXT_COLOR,
			1, 1,
			BIGMAP_HELP_TEXT_FONT,
			nil,
			nil,
			nil,
			nil,
			BIGMAP_POST_GUI
		)

		x = x + actionTextWidth + BIGMAP_TEXT_WINDOW_CONTENT_MARGIN * 2
		dxDrawTextWithShadow(
			row[2], x, y, nil, nil,
			BIGMAP_HELP_TEXT_COLOR,
			1, 1,
			BIGMAP_HELP_TEXT_FONT,
			nil,
			nil,
			nil,
			nil,
			BIGMAP_POST_GUI
		)
	end

	return true
end

local function collectBigMapLegendItems()

	local items = {}

	local icons = {}
	for icon, _ in pairs(drawData.bigMapDrawnSprites) do
		table.insert(icons, icon)
	end
	table.sort(icons)

	for _, icon in ipairs(icons) do
		local texture = drawData.radarSpriteTextures[icon]
		local name = RADAR_SPRITE_NAMES[icon]
		if name and texture then
			table.insert(items, { texture, name })
		end
	end

	return items
end

local function drawBigMapLegend()

	if not BIGMAP_LEGEND_ENABLED then return false end
	if not drawData.showBigMapLegend then return false end

	local items = collectBigMapLegendItems()

	local columns = math.min(BIGMAP_LEGEND_COLUMNS, #items)
	local textWidth, textHeight = dxGetTextSize(string.rep("W", 15), 0, 1, 1, BIGMAP_LEGEND_TEXT_FONT)
	local itemHeight = textHeight + 5
	local iconSize = textHeight
	local itemWidth = iconSize + BIGMAP_TEXT_WINDOW_CONTENT_MARGIN + textWidth

	local bgWidth = math.floor((columns * itemWidth) + (columns * BIGMAP_TEXT_WINDOW_CONTENT_MARGIN) + BIGMAP_TEXT_WINDOW_CONTENT_MARGIN)
	local bgHeight = math.floor(itemHeight * math.ceil(#items / columns) + (BIGMAP_TEXT_WINDOW_CONTENT_MARGIN * 2))
	local bgX = math.floor((SCREEN_WIDTH - bgWidth) / 2)
	local bgY = math.min(bgX, math.floor((SCREEN_HEIGHT - bgHeight) / 2))

	dxDrawRectangle(
		bgX, bgY,
		bgWidth, bgHeight,
		BIGMAP_TEXT_WINDOW_BG_COLOR,
		BIGMAP_POST_GUI,
		false
	)

	for i, item in ipairs(items) do

		local column = (i - 1) % BIGMAP_LEGEND_COLUMNS + 1
		local row = math.ceil(i / BIGMAP_LEGEND_COLUMNS)

		local x = bgX + BIGMAP_TEXT_WINDOW_CONTENT_MARGIN + ((column - 1) * (itemWidth + BIGMAP_TEXT_WINDOW_CONTENT_MARGIN))
		local y = bgY + BIGMAP_TEXT_WINDOW_CONTENT_MARGIN + ((row - 1) * itemHeight)

		dxDrawImage(
			x, y,
			iconSize, iconSize,
			item[1],
			0, 0, 0,
			tocolor(255, 255, 255, 255),
			BIGMAP_POST_GUI
		)

		x = x + iconSize + BIGMAP_TEXT_WINDOW_CONTENT_MARGIN
		dxDrawTextWithShadow(
			item[2],
			x, y,
			nil, nil,
			BIGMAP_LEGEND_TEXT_COLOR,
			1, 1,
			BIGMAP_LEGEND_TEXT_FONT,
			nil,
			nil,
			nil,
			nil,
			BIGMAP_POST_GUI)
	end

	return true
end

local function drawBigMap()

	if not drawData.showBigMap then return true end

	drawData.bigMapDrawnSprites = {}

	updateBigMapCursorMoving()
	updateBigMapPlayerMoving()
	updateBigMapScreenView()

	drawBigMapTiles()
	drawBigMapRadarAreas()
	drawBigMapBlips()
	drawBigMapHelp()
	drawBigMapLegend()

	return true
end

local function switchBigMap()

	drawData.showBigMap = not drawData.showBigMap
	showCursor(BIGMAP_CURSOR_ENABLED and drawData.showBigMap)

	if drawData.showBigMap then

		drawData.bigMapWasMoved = false

		if BIGMAP_HIDE_CHAT then
			drawData.bigMapSwitchChatWasVisible = isChatVisible()
			if drawData.bigMapSwitchChatWasVisible then
				showChat(false)
			end
		end

	else
		if drawData.bigMapSwitchChatWasVisible then
			showChat(true)
		end
	end
	return drawData.showBigMap
end

local function switchBigMapHelp()

	if not drawData.showBigMap then return false end

	drawData.showBigMapHelp = not drawData.showBigMapHelp

	return drawData.showBigMapHelp
end

local function switchBigMapLegend()

	if not drawData.showBigMap then return false end

	drawData.showBigMapLegend = not drawData.showBigMapLegend

	return drawData.showBigMapLegend
end

local function zoomBigMap(step)

	if not drawData.showBigMap then return false end

	local cx, cy = drawData.cursorCurrPos[1], drawData.cursorCurrPos[2]
	cx, cy = cx or SCREEN_WIDTH / 2, cy or SCREEN_HEIGHT / 2

	local scale = 1 + step

	drawData.bigMapScreenViewTransform = transform2.mul(transform2.mul(
		drawData.bigMapScreenViewTransform,
		transform2.move(-cx, -cy)),
		transform2.scale(scale, scale))

	drawData.bigMapScreenViewTransform = transform2.mul(transform2.mul(
		drawData.bigMapScreenViewTransform,
		transform2.scale(
			math_clamp(drawData.bigMapScreenViewTransform[1][1], BIGMAP_ZOOM_SCALE_MIN, BIGMAP_ZOOM_SCALE_MAX) / drawData.bigMapScreenViewTransform[1][1],
			math_clamp(drawData.bigMapScreenViewTransform[2][2], BIGMAP_ZOOM_SCALE_MIN, BIGMAP_ZOOM_SCALE_MAX) / drawData.bigMapScreenViewTransform[2][2])),
		transform2.move(cx, cy))

	-- clamps offset
	moveBigMap(0, 0)
	updateBigMapScreenView()

	return true
end

local function changeBigMapOpacity(step)

	if not drawData.showBigMap then return false end

	drawData.bigMapAlphaMultiplier = math_clamp(
		drawData.bigMapAlphaMultiplier + step, 0.25, 1)

	return true
end

local function draw()

	drawData.cursorPrevPos = drawData.cursorCurrPos
	drawData.cursorCurrPos = { getCursorAbsolutePosition() }

	drawData.playerElement = getPedOccupiedVehicle(localPlayer) or localPlayer
	drawData.playerElementMatrix = getElementMatrix(drawData.playerElement)
	drawData.playerCameraAngle = math.rad(({ getElementRotation(camera) })[3])
	drawData.playerInterior = getElementInterior(localPlayer)
	drawData.playerDimension = getElementDimension(localPlayer)
	drawData.flashingRadarAreaAlphaMultiplier = calcFlashingRadarAreaAlphaMultiplier()

	drawData.playerInPlane = getElementType(drawData.playerElement) == "vehicle" and
		getVehicleRealType(drawData.playerElement) == VEHICLE_REAL_TYPE.PLANE

	drawRadar()
	drawBigMap()

	return true
end


------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------


init()
addEventHandler("onClientResourceStop", resourceRoot, term)

addEventHandler("onClientRestore", root, function() drawData.areRenderTargetsReady = false end)
addEventHandler("onClientRender", root, draw)

bindKey(BIGMAP_SWITCH_LEGEND_KEY, "down", switchBigMapLegend)
addCommandHandler(BIGMAP_SWITCH_COMMAND, switchBigMap)
addCommandHandler(BIGMAP_SWITCH_HELP_COMMAND, switchBigMapHelp)
addCommandHandler(BIGMAP_ZOOM_IN_COMMAND, function() zoomBigMap(BIGMAP_ZOOM_SCALE_STEP) end)
addCommandHandler(BIGMAP_ZOOM_OUT_COMMAND, function() zoomBigMap(-BIGMAP_ZOOM_SCALE_STEP) end)
addCommandHandler(BIGMAP_OPACITY_UP_COMMAND, function() changeBigMapOpacity(BIGMAP_CHANGE_OPACITY_STEP) end)
addCommandHandler(BIGMAP_OPACITY_DOWN_COMMAND, function() changeBigMapOpacity(-BIGMAP_CHANGE_OPACITY_STEP) end)
addCommandHandler(BIGMAP_MOVE_NORTH_COMMAND, function()
	drawData.bigMapWasMoved = true
	moveBigMap(0, BIGMAP_MOVE_STEP)
end)
addCommandHandler(BIGMAP_MOVE_SOUTH_COMMAND, function()
	drawData.bigMapWasMoved = true
	moveBigMap(0, -BIGMAP_MOVE_STEP)
end)
addCommandHandler(BIGMAP_MOVE_WEST_COMMAND, function()
	drawData.bigMapWasMoved = true
	moveBigMap(BIGMAP_MOVE_STEP, 0)
end)
addCommandHandler(BIGMAP_MOVE_EAST_COMMAND, function()
	drawData.bigMapWasMoved = true
	moveBigMap(-BIGMAP_MOVE_STEP, 0)
end)

addEventHandler("onClientMouseEnter", root, function() drawData.cursorOnGui = true end)
addEventHandler("onClientMouseMove", root, function() drawData.cursorOnGui = true end)
addEventHandler("onClientMouseLeave", root, function(_, _, enteredGui) drawData.cursorOnGui = enteredGui ~= nil end)


------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

function getMRadarVisible()

	return drawData.showRadar
end

function setMRadarVisible(visible)
	if type(visible) ~= "boolean" then error("bad argument #1 'visible' to 'setMRadarVisible' (boolean expected)", 1) end

	if drawData.showRadar == visible then return false end
	drawData.showRadar = visible

	return true
end