local camera = getCamera()

local MATH_PI = math.pi
local MATH_TWO_PI = math.pi * 2

local SCREEN_WIDTH, SCREEN_HEIGHT = guiGetScreenSize()
local TEXTURE_QUALITY_FORMAT = "dxt3"
local TEXTURE_FILE_FORMAT = ".png"
local TEXTURE_PATH = "txd/"

local MAP_WORLD_SIZE = 6000
local MAP_WORLD_SIZE_HALF = MAP_WORLD_SIZE / 2
local MAP_TILES_SIZE = 12;
local MAP_TILES_SIZE_HALF = MAP_TILES_SIZE / 2
local MAP_TILE_WORLD_SIZE = MAP_WORLD_SIZE / MAP_TILES_SIZE
local MAP_TILE_COLOR = tocolor(255, 255, 255, 255)
local MAP_TILE_SEA_COLOR = tocolor(104, 136, 168, 255)
local MAP_TILE_BLANK_COLOR = tocolor(204, 204, 204, 255)                            -- for interiors
local MAP_TILE_TEXTURES_PATH = TEXTURE_PATH .. "radar/"

-- Here are GTA:IV sizes
local RADAR_SIZE = SCREEN_HEIGHT / 5
local RADAR_SIZE_HALF = RADAR_SIZE / 2
local RADAR_BOTTOM_OFFSET = SCREEN_HEIGHT / 20
local RADAR_LEFT_OFFSET = RADAR_BOTTOM_OFFSET * (11 / 6)
local RADAR_SCREEN_X = RADAR_LEFT_OFFSET
local RADAR_SCREEN_Y = SCREEN_HEIGHT - RADAR_BOTTOM_OFFSET - RADAR_SIZE
local RADAR_BORDER_WIDTH = RADAR_SIZE_HALF / 8                                -- depends on radar disc texture
local RADAR_BORDER_MARGIN = RADAR_BORDER_WIDTH / 8                            -- depends on radar disc texture
local RADAR_BORDER_COLOR = tocolor(0, 0, 0, 255)
local RADAR_SPRITE_TEXTURES_PATH = TEXTURE_PATH .. "hud/"

local RADAR_MAP_MASK_RADIUS = RADAR_SIZE_HALF - RADAR_BORDER_WIDTH + (RADAR_BORDER_MARGIN * 2)
local RADAR_MAP_DRAW_TILES_RADIUS = 1
local RADAR_MAP_MIN_RANGE = 180.0                                            -- Radar.cpp: RADAR_MIN_RANGE
local RADAR_MAP_MAX_RANGE = 350.0                                            -- Radar.cpp: RADAR_MAX_RANGE
local RADAR_MAP_MIN_RANGE_SPEED = 0.3                                        -- Radar.cpp: RADAR_MIN_SPEED
local RADAR_MAP_MAX_RANGE_SPEED = 0.9                                        -- Radar.cpp: RADAR_MAX_SPEED
local RADAR_MAP_SHOW_IN_INTERIOR = false

local RING_PLANE_SPRITE_COLOR = tocolor(255, 255, 255, 255)
local ARTIFICIAL_HORIZON_SKY_COLOR = tocolor(0, 0, 0, 0)
local ARTIFICIAL_HORIZON_GROUND_COLOR = tocolor(20, 175, 20, 200)
local ALTIMETER_BG_COLOR = tocolor(10, 10, 10, 100)
local ALTIMETER_BG_WIDTH = RADAR_SIZE / 16
local ALTIMETER_BG_HEIGHT = RADAR_SIZE - (RADAR_BORDER_WIDTH * 2)
local ALTIMETER_BG_SCREEN_X = RADAR_SCREEN_X + RADAR_SIZE + (ALTIMETER_BG_WIDTH * 2)
local ALTIMETER_BG_SCREEN_Y = RADAR_SCREEN_Y + (RADAR_SIZE / 2) - (ALTIMETER_BG_HEIGHT / 2)
local ALTIMETER_COLOR = tocolor(200, 200, 200, 255)
local ALTIMETER_WIDTH = ALTIMETER_BG_WIDTH * 2
local ALTIMETER_HEIGHT = ALTIMETER_WIDTH / 16
local ALTIMETER_SCREEN_X = ALTIMETER_BG_SCREEN_X + (ALTIMETER_BG_WIDTH / 2) - (ALTIMETER_WIDTH / 2)
local ALTIMETER_WORLD_HEIGHT_MAX = 950
local ALTIMETER_WORLD_HEIGHT_LOW = 200

local RADAR_BLIP_SIZE = RADAR_SIZE / 8
local RADAR_BLIP_SIZE_GTASA_DEFAULT = 2
local RADAR_BLIP_ALPHA_MULTIPLIER = 1
local RADAR_BLIP_VECTOR_MAX_LENGTH = 1 - (RADAR_BORDER_WIDTH / 2 / RADAR_SIZE_HALF)
local RADAR_BLIP_SHOW_OTHER_INTERIOR = false
local RADAR_BLIP_TRACE_TEXTURES_PATH = TEXTURE_PATH .. "trace/"
local RADAR_BLIP_NORTH_COLOR = tocolor(255, 255, 255, 255)
local RADAR_BLIP_NORTH_SIZE_MULTIPLIER = 1
local RADAR_BLIP_CENTRE_COLOR = tocolor(255, 255, 255, 255)
local RADAR_BLIP_CENTRE_SIZE_MULTIPLIER = 1
local RADAR_BLIP_TRACE_SIZE_MULTIPLIER = 0.6
local RADAR_BLIP_TRACE_LOW_HEIGHT_DIFF = -4.0
local RADAR_BLIP_TRACE_HIGH_HEIGHT_DIFF = 2

------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

local drawData = {}

drawData.mapTileTextures = {}                    -- Radar.cpp: std::array<std::array<int32, MAX_RADAR_WIDTH_TILES>, MAX_RADAR_HEIGHT_TILES>& gRadarTextures
drawData.hudSpriteTextures = {}                  -- Hud.h: CSprite2d (&Sprites)[6]
drawData.radarSpriteTextures = {}                -- Radar.h: std::array<CSprite2d, MAX_RADAR_SPRITES>& RadarBlipSprites
drawData.radarSpriteBlipTraceTextures = {}       -- custom textures (instead of drawing polygons)
drawData.radarMaskTexture = {}

drawData.areRenderTargetsReady = false
drawData.radarMaskShader = dxCreateShader("radar.fx")
drawData.radarMapMaskRt = dxCreateRenderTarget(RADAR_SIZE, RADAR_SIZE, true)
drawData.radarBorderRt = dxCreateRenderTarget(RADAR_SIZE, RADAR_SIZE, true)
drawData.radarMapTilesRt = dxCreateRenderTarget(RADAR_SIZE, RADAR_SIZE, true)
drawData.radarOverlayRt = dxCreateRenderTarget(RADAR_SIZE, RADAR_SIZE, true)

drawData.playerElement = nil
drawData.playerElementMatrix = nil

drawData.radarMapRange = nil                     -- Radar.h: float& m_radarRange
drawData.radarMapPosition = nil                  -- Radar.h: CVector2D& vec2DRadarOrigin
drawData.radarMapAngle = nil                     -- Radar.h: float& m_fRadarOrientation
drawData.radarMapAngleMatrix = nil               -- Radar.h: float& cachedCos; float& cachedSin
drawData.radarInterior = nil
drawData.radarDimension = nil
drawData.flashingRadarAreaAlphaMultiplier = nil

function math.clamp(value, min, max)

	return value < min and min or value > max and max or value
end


------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

local function getVehicleRealType(vehicle)

	-- defines "Vortex" model as custom "Hovercraft" type (instead of "Plane" type)
	if getElementModel(vehicle) == 539 then
		return VEHICLE_REAL_TYPE.HOVERCRAFT
	end

	return getVehicleType(vehicle)
end

local function transformWorldToRadarRelativePosition(x, y)

	return
	(x - drawData.radarMapPosition[1]) / drawData.radarMapRange,
	(y - drawData.radarMapPosition[2]) / drawData.radarMapRange
end

local function rotateRadarRelativePosition(x, y)

	local m = drawData.radarMapAngleMatrix
	return
	x * m[1][1] + y * m[2][1],
	x * m[1][2] + y * m[2][2]
end

local function transformRadarRelativeToAbsolutePosition(x, y)

	return
	RADAR_SIZE_HALF + (RADAR_SIZE_HALF * x),
	RADAR_SIZE_HALF - (RADAR_SIZE_HALF * y)
end

local function transformRadarToScreenPosition(x, y)

	return
		RADAR_SCREEN_X + x,
		RADAR_SCREEN_Y + y
end

-- CRadar::TransformRadarPointToScreenSpace(CVector2D& out, const CVector2D& in) // 0x583480
local function transformWorldToRadarPosition(x, y)

	x, y = transformWorldToRadarRelativePosition(x, y)
	x, y = transformRadarRelativeToAbsolutePosition(x, y)
	return x, y
end

-- Radar.cpp: CRadar::LoadTextures() // 0x5827D0
-- Hud.cpp: CHud::Initialise() // 0x5BA850
local function loadTextures()

	for id, name in pairs(RADAR_SPRITE_TEXTURE_NAMES) do
		drawData.radarSpriteTextures[id] = dxCreateTexture(
			RADAR_SPRITE_TEXTURES_PATH .. name .. TEXTURE_FILE_FORMAT,
			TEXTURE_QUALITY_FORMAT,
			true,
			"clamp"
		)
	end

	for id, name in pairs(RADAR_TRACE_TEXTURE_NAMES) do
		drawData.radarSpriteBlipTraceTextures[id] = dxCreateTexture(
			RADAR_BLIP_TRACE_TEXTURES_PATH .. name .. TEXTURE_FILE_FORMAT,
			TEXTURE_QUALITY_FORMAT,
			true,
			"clamp"
		)
	end

	for id, name in pairs(HUD_SPRITE_TEXTURE_NAMES) do
		drawData.hudSpriteTextures[id] = dxCreateTexture(
			RADAR_SPRITE_TEXTURES_PATH .. name .. TEXTURE_FILE_FORMAT,
			TEXTURE_QUALITY_FORMAT,
			true,
			"clamp"
		)
	end

	for y = 0, MAP_TILES_SIZE - 1 do
		drawData.mapTileTextures[y] = {}
		for x = 0, MAP_TILES_SIZE - 1 do
			drawData.mapTileTextures[y][x] = dxCreateTexture(
				MAP_TILE_TEXTURES_PATH .. "radar" .. string.format("%02d", (y * MAP_TILES_SIZE + x)) .. TEXTURE_FILE_FORMAT,
				TEXTURE_QUALITY_FORMAT,
				true,
				"clamp"
			)
		end
	end

	-- custom texture
	drawData.radarMaskTexture = dxCreateTexture(
		RADAR_SPRITE_TEXTURES_PATH .. HUD_SPRITE_TEXTURE_NAMES[HUD_SPRITE.RADAR_DISC] .. "_mask" .. TEXTURE_FILE_FORMAT,
		TEXTURE_QUALITY_FORMAT,
		true,
		"clamp"
	)

	return true
end

-- Radar.cpp: CRadar::Initialise() // 0x587FB0
local function init()

	loadTextures()

	return true
end


-- Radar.cpp: CRadar::DrawMap() // 0x586B00
local function calcRadarMapRange(element, matrix)

	if getElementType(element) ~= "vehicle" then

		return RADAR_MAP_MIN_RANGE
	end

	if getVehicleRealType(element) == VEHICLE_REAL_TYPE.PLANE then

		local heightLowRatio = matrix[4][3] / ALTIMETER_WORLD_HEIGHT_LOW
		if heightLowRatio < RADAR_MAP_MIN_RANGE_SPEED then
			return RADAR_MAP_MAX_RANGE - 10.0
		end
		if heightLowRatio >= RADAR_MAP_MAX_RANGE_SPEED then
			return RADAR_MAP_MAX_RANGE
		end
		return (heightLowRatio - RADAR_MAP_MIN_RANGE_SPEED) / 60.0 + (RADAR_MAP_MAX_RANGE - 10.0)
	end

	local vx, vy, vz = getElementVelocity(element)
	local speed = getDistanceBetweenPoints3D(0, 0, 0, vx, vy, vz)

	if speed < RADAR_MAP_MIN_RANGE_SPEED then
		return RADAR_MAP_MIN_RANGE
	end
	if speed >= RADAR_MAP_MAX_RANGE_SPEED then
		return RADAR_MAP_MAX_RANGE
	end
	return (speed - RADAR_MAP_MIN_RANGE_SPEED) * (850.0 / (RADAR_MAP_MIN_RANGE_SPEED * 10.0)) + RADAR_MAP_MIN_RANGE
end

-- Radar.h: CachedRotateClockwise(const CVector2D& point)
local function getAngleMatrix(angle)

	local cos = math.cos(angle)
	local sin = math.sin(angle)

	return {
		{ cos, -sin },
		{ sin, cos }
	}
end

local function prepareRadarMaskRt()

	dxSetRenderTarget(drawData.radarMapMaskRt, true)

	local offset = RADAR_SIZE_HALF - RADAR_MAP_MASK_RADIUS
	for y = 0, 1 do
		for x = 0, 1 do
			dxDrawImage(
				offset + RADAR_MAP_MASK_RADIUS * x,
				offset + RADAR_MAP_MASK_RADIUS * y,
				RADAR_MAP_MASK_RADIUS,
				RADAR_MAP_MASK_RADIUS,
				drawData.radarMaskTexture,
				(-2 * x * y + x - y) * 90, 0, 0
			)
		end
	end

	dxSetRenderTarget()

	dxSetShaderValue(drawData.radarMaskShader, "sMaskTexture", drawData.radarMapMaskRt)

	return true
end

local function prepareRadarBorderRt()

	dxSetRenderTarget(drawData.radarBorderRt, true)
	dxSetBlendMode("overwrite")
	local texture = drawData.hudSpriteTextures[HUD_SPRITE.RADAR_DISC]
	for y = 0, 1 do
		for x = 0, 1 do
			dxDrawImage(
				RADAR_SIZE_HALF * x,
				RADAR_SIZE_HALF * y,
				RADAR_SIZE / 2,
				RADAR_SIZE / 2,
				texture,
				(-2 * x * y + x - y) * 90, 0, 0
			)
		end
	end
	dxSetBlendMode("blend")
	dxSetRenderTarget()

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
	local rtx, rty = transformWorldToRadarPosition(wx, wy)
	local rtx2, rty2 = transformWorldToRadarPosition(wx + MAP_TILE_WORLD_SIZE, wy - MAP_TILE_WORLD_SIZE)

	if RADAR_MAP_SHOW_IN_INTERIOR or drawData.radarInterior == 0 then

		if isMapTileInBounds(tx, ty) then

			dxDrawImage(
				rtx, rty,
				rtx2 - rtx, rty2 - rty,
				drawData.mapTileTextures[ty][tx],
				0, 0, 0,
				MAP_TILE_COLOR
			)
		else

			dxDrawRectangle(
				rtx, rty,
				rtx2 - rtx, rty2 - rty,
				MAP_TILE_SEA_COLOR,
				false,
				true
			)
		end

	else

		dxDrawRectangle(
			rtx, rty,
			rtx2 - rtx, rty2 - rty,
			MAP_TILE_BLANK_COLOR,
			false,
			true
		)
	end

	return true
end

local function drawRadarMapTiles()

	local x = math.floor((drawData.radarMapPosition[1] + MAP_WORLD_SIZE_HALF) / MAP_TILE_WORLD_SIZE)
	local y = math.ceil(MAP_TILES_SIZE - 1 - (drawData.radarMapPosition[2] + MAP_WORLD_SIZE_HALF) / MAP_TILE_WORLD_SIZE)

	dxSetRenderTarget(drawData.radarMapTilesRt)
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

	return (math.sin((getTickCount() % 1024) / (1024 / MATH_TWO_PI)) + 1.0) / 2.0
end

-- Radar.cpp: CRadar::DrawRadarGangOverlay(bool inMenu) // 0x586650
local function drawRadarAreas()

	dxSetRenderTarget(drawData.radarMapTilesRt)
	dxSetBlendMode("modulate_add")

	for i, area in ipairs(getElementsByType("radararea")) do

		local x, y, _ = getElementPosition(area)
		local width, height = getRadarAreaSize(area)

		-- TODO: check if in currrent tiles

		local x1, y1 = transformWorldToRadarPosition(x, y + height)
		local x2, y2 = transformWorldToRadarPosition(x + width, y)
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

	end

	dxSetBlendMode("blend")
	dxSetRenderTarget()

	return true
end

local function drawArtificialHorizon()

	if getElementType(drawData.playerElement) ~= "vehicle" then
		return false
	end
	if getVehicleRealType(drawData.playerElement) ~= VEHICLE_REAL_TYPE.PLANE then
		return false
	end

	dxSetRenderTarget(drawData.radarOverlayRt)
	dxSetBlendMode("modulate_add")

	local pitch = math.atan2(-drawData.playerElementMatrix[2][3], drawData.playerElementMatrix[3][3]);
	local horizon = RADAR_SIZE_HALF - (RADAR_SIZE_HALF * (pitch / MATH_PI))
	dxDrawRectangle(
		0, 0,
		RADAR_SIZE, horizon,
		ARTIFICIAL_HORIZON_SKY_COLOR,
		false,
		true
	)
	dxDrawRectangle(
		0, horizon,
		RADAR_SIZE, RADAR_SIZE,
		ARTIFICIAL_HORIZON_GROUND_COLOR,
		false,
		true
	)

	local roll = math.atan2(-drawData.playerElementMatrix[1][3], drawData.playerElementMatrix[3][3])
	dxDrawImage(
		0, 0,
		RADAR_SIZE, RADAR_SIZE,
		drawData.hudSpriteTextures[HUD_SPRITE.RADAR_RING_PLANE],
		math.deg(roll), 0, 0,
		RING_PLANE_SPRITE_COLOR
	)

	dxSetBlendMode("blend")
	dxSetRenderTarget()

	return true
end

local function drawAltimeter()

	if getElementType(drawData.playerElement) ~= "vehicle" then
		return true
	end

	local vehicleRealType = getVehicleRealType(drawData.playerElement)
	if not (vehicleRealType == VEHICLE_REAL_TYPE.PLANE or vehicleRealType == VEHICLE_REAL_TYPE.HELICOPTER) then
		return true
	end

	dxDrawRectangle(
		ALTIMETER_BG_SCREEN_X, ALTIMETER_BG_SCREEN_Y,
		ALTIMETER_BG_WIDTH, ALTIMETER_BG_HEIGHT,
		ALTIMETER_BG_COLOR
	)

	local height = drawData.radarMapPosition[3]
	local limit = ALTIMETER_WORLD_HEIGHT_MAX
	if height <= ALTIMETER_WORLD_HEIGHT_LOW then
		limit = ALTIMETER_WORLD_HEIGHT_LOW;
	end

	dxDrawRectangle(
		ALTIMETER_SCREEN_X,
		ALTIMETER_BG_SCREEN_Y + ALTIMETER_BG_HEIGHT * (math.clamp(1 - height / limit, 0, 1)),
		ALTIMETER_WIDTH,
		ALTIMETER_HEIGHT,
		ALTIMETER_COLOR,
		false,
		true
	)

	return true
end

local function drawRadarMaskShader()

	dxSetShaderValue(drawData.radarMaskShader, "sMapTexture", drawData.radarMapTilesRt)
	dxSetShaderValue(drawData.radarMaskShader, "sOverlayTexture", drawData.radarOverlayRt)
	dxSetShaderValue(drawData.radarMaskShader, "sMaskTexture", drawData.radarMapMaskRt)

	dxSetShaderValue(drawData.radarMaskShader, "gUVRotAngle", -drawData.radarMapAngle)

	dxDrawImage(RADAR_SCREEN_X, RADAR_SCREEN_Y, RADAR_SIZE, RADAR_SIZE, drawData.radarMaskShader)

	return true
end

local function drawRadarBorder()

	dxDrawImage(
		RADAR_SCREEN_X, RADAR_SCREEN_Y,
		RADAR_SIZE, RADAR_SIZE,
		drawData.radarBorderRt,
		0, 0, 0,
		RADAR_BORDER_COLOR
	)

	return true
end

-- Radar.cpp: CRadar::LimitRadarPoint(CVector2D& point) // 0x5832F0
local function limitVectorLength(x, y, limit)

	local length = getDistanceBetweenPoints2D(0, 0, x, y)
	if length > limit then
		local k = limit / length
		x, y = x * k, y * k
	end

	return x, y
end

-- Radar.cpp: GetRadarAndScreenPos(float* radarPointDist)
local function transformWorldToScreenPositionBlip(x, y)

	x, y = transformWorldToRadarRelativePosition(x, y)
	x, y = rotateRadarRelativePosition(x, y)
	x, y = limitVectorLength(x, y, RADAR_BLIP_VECTOR_MAX_LENGTH)
	x, y = transformRadarRelativeToAbsolutePosition(x, y)
	x, y = transformRadarToScreenPosition(x, y)

	return x, y
end

-- Radar.cpp: CRadar::DrawRadarSprite(eRadarSprite spriteId, float x, float y, uint8 alpha) // 0x585FF0
local function drawRadarSprite(spriteId, x, y, z, color, size, rot)

	x, y = transformWorldToScreenPositionBlip(x, y)
	size = RADAR_BLIP_SIZE * (size / RADAR_BLIP_SIZE_GTASA_DEFAULT)

	local texture = drawData.radarSpriteTextures[spriteId]

	if spriteId == RADAR_SPRITE.NONE then

		size = size * RADAR_BLIP_TRACE_SIZE_MULTIPLIER
		local trace = RADAR_TRACE.NORMAL

		local diff = z - drawData.radarMapPosition[3]
		if diff > RADAR_BLIP_TRACE_HIGH_HEIGHT_DIFF then
			trace = RADAR_TRACE.HIGH
		end
		if diff < RADAR_BLIP_TRACE_LOW_HEIGHT_DIFF then
			trace = RADAR_TRACE.LOW;
		end

		texture = drawData.radarSpriteBlipTraceTextures[trace]
	end

	dxDrawImage(
		x - size / 2, y - size / 2, size, size,
		texture,
		rot or 0, 0, 0,
		color
	)

	return true
end

-- Radar.cpp: CRadar::DrawCoordBlip(int32 blipIndex, bool isSprite) // 0x586D60
local function drawBlip(blip)

	local dim = getElementDimension(blip)
	if dim ~= drawData.radarDimension then
		return false
	end

	local int = getElementInterior(blip)
	if (not RADAR_BLIP_SHOW_OTHER_INTERIOR) and int ~= drawData.radarInterior then
		return false
	end

	local x, y, z = getElementPosition(blip)
	local size = getBlipSize(blip)

	local dis = getDistanceBetweenPoints3D(
		drawData.radarMapPosition[1], drawData.radarMapPosition[2], drawData.radarMapPosition[3],
		x, y, z
	)
	if dis > getBlipVisibleDistance(blip) then
		return false
	end

	local r, g, b, a = getBlipColor(blip)
	a = a * RADAR_BLIP_ALPHA_MULTIPLIER

	drawRadarSprite(getBlipIcon(blip), x, y, z, tocolor(r, g, b, a), size);

	return true
end

-- Radar.cpp: CRadar::DrawBlips() // 0x588050
local function drawBlips()

	drawRadarSprite(
		RADAR_SPRITE.NORTH,
		drawData.radarMapPosition[1],
		drawData.radarMapPosition[2] + MAP_WORLD_SIZE,
		drawData.radarMapPosition[3],
		RADAR_BLIP_NORTH_COLOR,
		RADAR_BLIP_SIZE_GTASA_DEFAULT * RADAR_BLIP_NORTH_SIZE_MULTIPLIER)

	local blips = getElementsByType("blip")
	table.sort(blips, function(a, b)
		return getBlipOrdering(a) < getBlipOrdering(b)
	end)
	for i, blip in ipairs(blips) do
		drawBlip(blip)
	end

	if not (getElementType(drawData.playerElement) == "vehicle" and getVehicleRealType(drawData.playerElement) == VEHICLE_REAL_TYPE.PLANE) then

		local heading = math.atan2(-drawData.playerElementMatrix[2][1], drawData.playerElementMatrix[2][2])
		local angle = heading - drawData.radarMapAngle - math.rad(180.0)
		drawRadarSprite(
			RADAR_SPRITE.CENTRE,
			drawData.radarMapPosition[1],
			drawData.radarMapPosition[2],
			drawData.radarMapPosition[3],
			RADAR_BLIP_CENTRE_COLOR,
			RADAR_BLIP_SIZE_GTASA_DEFAULT * RADAR_BLIP_CENTRE_SIZE_MULTIPLIER,
			180 - math.deg(angle)
		)
	end

	return true
end

-- Hud.cpp: CHud::DrawRadar() // 0x58A330
function draw()

	drawData.playerElement = getPedOccupiedVehicle(localPlayer) or localPlayer
	drawData.playerElementMatrix = getElementMatrix(drawData.playerElement)

	drawData.radarMapRange = calcRadarMapRange(drawData.playerElement, drawData.playerElementMatrix)
	drawData.radarMapPosition = drawData.playerElementMatrix[4]
	drawData.radarMapAngle = math.rad(({ getElementRotation(camera) })[3])
	drawData.radarMapAngleMatrix = getAngleMatrix(drawData.radarMapAngle)
	drawData.radarInterior = getElementInterior(localPlayer)
	drawData.radarDimension = getElementDimension(localPlayer)
	drawData.flashingRadarAreaAlphaMultiplier = calcFlashingRadarAreaAlphaMultiplier()

	-- reset RT
	dxSetRenderTarget(drawData.radarMapTilesRt, true)
	dxSetRenderTarget(drawData.radarOverlayRt, true)
	dxSetRenderTarget()

	if not drawData.areRenderTargetsReady then
		prepareRadarMaskRt()
		prepareRadarBorderRt()
		drawData.areRenderTargetsReady = true
	end

	drawRadarMapTiles()
	drawRadarAreas()
	drawArtificialHorizon()
	drawAltimeter()
	drawRadarMaskShader()
	drawRadarBorder()
	drawBlips()

	return true
end

init()

addEventHandler("onClientRestore", root,
	function(didClearRenderTargets)
		if not didClearRenderTargets then
			return
		end
		drawData.areRenderTargetsReady = false
	end
)

addEventHandler("onClientRender", root,
	function()
		draw()
	end
)

setPlayerHudComponentVisible("radar", false)
addEventHandler("onClientResourceStop", resourceRoot,
	function()
		setPlayerHudComponentVisible("radar", true)
	end
)
