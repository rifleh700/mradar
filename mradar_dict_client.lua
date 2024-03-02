-- Radar.h: eRadarSprite
RADAR_SPRITE = {
	PLAYER_INTEREST = -5,
	THREAT = -4,
	FRIEND = -3,
	OBJECT = -2,
	DESTINATION = -1,
	NONE = 0, -- trace blip (player marker)
	WHITE = 1,
	CENTRE = 2,
	MAP_HERE = 3,
	NORTH = 4,
	AIRYARD = 5,
	AMMUGUN = 6,
	BARBERS = 7,
	BIGSMOKE = 8,
	BOATYARD = 9,
	BURGERSHOT = 10,
	BULLDOZER = 11,
	CATALINAPINK = 12,
	CESARVIAPANDO = 13,
	CHICKEN = 14,
	CJ = 15,
	CRASH1 = 16,
	DINER = 17,
	EMMETGUN = 18,
	ENEMYATTACK = 19,
	FIRE = 20,
	GIRLFRIEND = 21,
	HOSTPITAL = 22,
	LOGOSYNDICATE = 23,
	MADDOG = 24,
	MAFIACASINO = 25,
	MCSTRAP = 26,
	MODGARAGE = 27,
	OGLOC = 28,
	PIZZA = 29,
	POLICE = 30,
	PROPERTYG = 31,
	PROPERTYR = 32,
	RACE = 33,
	RYDER = 34,
	SAVEGAME = 35,
	SCHOOL = 36,
	QMARK = 37,
	SWEET = 38,
	TATTOO = 39,
	THETRUTH = 40,
	WAYPOINT = 41,
	TORENORANCH = 42,
	TRIADS = 43,
	TRIADSCASINO = 44,
	TSHIRT = 45,
	WOOZIE = 46,
	ZERO = 47,
	DATEDISCO = 48,
	DATEDRINK = 49,
	DATEFOOD = 50,
	TRUCK = 51,
	CASH = 52,
	FLAG = 53,
	GYM = 54,
	IMPOUND = 55,
	LIGHT = 56,
	RUNWAY = 57,
	GANGB = 58,
	GANGP = 59,
	GANGY = 60,
	GANGN = 61,
	GANGG = 62,
	SPRAY = 63,
	TORENO = 64,
}

RADAR_SPRITE_TEXTURE_NAMES = {
	[RADAR_SPRITE.NONE] = nil,
	[RADAR_SPRITE.WHITE] = nil,
	[RADAR_SPRITE.CENTRE] = "radar_centre",
	[RADAR_SPRITE.MAP_HERE] = "arrow",
	[RADAR_SPRITE.NORTH] = "radar_north",
	[RADAR_SPRITE.AIRYARD] = "radar_airYard",
	[RADAR_SPRITE.AMMUGUN] = "radar_ammugun",
	[RADAR_SPRITE.BARBERS] = "radar_barbers",
	[RADAR_SPRITE.BIGSMOKE] = "radar_BIGSMOKE",
	[RADAR_SPRITE.BOATYARD] = "radar_boatyard",
	[RADAR_SPRITE.BURGERSHOT] = "radar_burgerShot",
	[RADAR_SPRITE.BULLDOZER] = "radar_bulldozer",
	[RADAR_SPRITE.CATALINAPINK] = "radar_CATALINAPINK",
	[RADAR_SPRITE.CESARVIAPANDO] = "radar_CESARVIAPANDO",
	[RADAR_SPRITE.CHICKEN] = "radar_chicken",
	[RADAR_SPRITE.CJ] = "radar_CJ",
	[RADAR_SPRITE.CRASH1] = "radar_CRASH1",
	[RADAR_SPRITE.DINER] = "radar_diner",
	[RADAR_SPRITE.EMMETGUN] = "radar_emmetGun",
	[RADAR_SPRITE.ENEMYATTACK] = "radar_enemyAttack",
	[RADAR_SPRITE.FIRE] = "radar_fire",
	[RADAR_SPRITE.GIRLFRIEND] = "radar_girlfriend",
	[RADAR_SPRITE.HOSTPITAL] = "radar_hostpitaL",
	[RADAR_SPRITE.LOGOSYNDICATE] = "radar_LocoSyndicate",
	[RADAR_SPRITE.MADDOG] = "radar_MADDOG",
	[RADAR_SPRITE.MAFIACASINO] = "radar_mafiaCasino",
	[RADAR_SPRITE.MCSTRAP] = "radar_MCSTRAP",
	[RADAR_SPRITE.MODGARAGE] = "radar_modGarage",
	[RADAR_SPRITE.OGLOC] = "radar_OGLOC",
	[RADAR_SPRITE.PIZZA] = "radar_pizza",
	[RADAR_SPRITE.POLICE] = "radar_police",
	[RADAR_SPRITE.PROPERTYG] = "radar_propertyG",
	[RADAR_SPRITE.PROPERTYR] = "radar_propertyR",
	[RADAR_SPRITE.RACE] = "radar_race",
	[RADAR_SPRITE.RYDER] = "radar_RYDER",
	[RADAR_SPRITE.SAVEGAME] = "radar_saveGame",
	[RADAR_SPRITE.SCHOOL] = "radar_school",
	[RADAR_SPRITE.QMARK] = "radar_qmark",
	[RADAR_SPRITE.SWEET] = "radar_SWEET",
	[RADAR_SPRITE.TATTOO] = "radar_tattoo",
	[RADAR_SPRITE.THETRUTH] = "radar_THETRUTH",
	[RADAR_SPRITE.WAYPOINT] = "radar_waypoint",
	[RADAR_SPRITE.TORENORANCH] = "radar_TorenoRanch",
	[RADAR_SPRITE.TRIADS] = "radar_triads",
	[RADAR_SPRITE.TRIADSCASINO] = "radar_triadsCasino",
	[RADAR_SPRITE.TSHIRT] = "radar_tshirt",
	[RADAR_SPRITE.WOOZIE] = "radar_WOOZIE",
	[RADAR_SPRITE.ZERO] = "radar_ZERO",
	[RADAR_SPRITE.DATEDISCO] = "radar_dateDisco",
	[RADAR_SPRITE.DATEDRINK] = "radar_dateDrink",
	[RADAR_SPRITE.DATEFOOD] = "radar_dateFood",
	[RADAR_SPRITE.TRUCK] = "radar_truck",
	[RADAR_SPRITE.CASH] = "radar_cash",
	[RADAR_SPRITE.FLAG] = "radar_flag",
	[RADAR_SPRITE.GYM] = "radar_gym",
	[RADAR_SPRITE.IMPOUND] = "radar_impound",
	[RADAR_SPRITE.LIGHT] = "radar_light",
	[RADAR_SPRITE.RUNWAY] = "radar_runway",
	[RADAR_SPRITE.GANGB] = "radar_gangB",
	[RADAR_SPRITE.GANGP] = "radar_gangP",
	[RADAR_SPRITE.GANGY] = "radar_gangY",
	[RADAR_SPRITE.GANGN] = "radar_gangN",
	[RADAR_SPRITE.GANGG] = "radar_gangG",
	[RADAR_SPRITE.SPRAY] = "radar_spray",
}

-- eHud.h: eHudSprite
HUD_SPRITE = {
	FIST = 0,
	SITE_M16 = 1,
	SITE_ROCKET = 2,
	RADAR_DISC = 3,
	RADAR_RING_PLANE = 4,
	SKIP_ICON = 5,
};

HUD_SPRITE_TEXTURE_NAMES = {
	--[HUD_SPRITE.FIST] 				= "fist",
	--[HUD_SPRITE.SITE_M16] 			= "siteM16",
	--[HUD_SPRITE.SITE_ROCKET] 		= "siterocket",
	[HUD_SPRITE.RADAR_DISC] = "radardisc",
	[HUD_SPRITE.RADAR_RING_PLANE] = "radarRingPlane",
	--[HUD_SPRITE.SKIP_ICON] 			= "SkipIcon"
}

-- Radar.h: eAirstripLocation
AIRSTRIP = {
	LS_AIRPORT = 0,
	SF_AIRPORT = 1,
	LV_AIRPORT = 2,
	VERDANT_MEADOWS = 3
}

-- Radar.cpp: std::array<airstrip_info, NUM_AIRSTRIPS> airstrip_table
AIRSTRIP_LOCATIONS = {
	[AIRSTRIP.LS_AIRPORT] = { { 1750.0, 2494.0 }, 180.0, 1000.0 }, -- position, direction (angle), radius
	[AIRSTRIP.SF_AIRPORT] = { { -1373.0, 120.00 }, 315.0, 1500.0 },
	[AIRSTRIP.LV_AIRPORT] = { { 1478.0, 1461.0 }, 90.0, 1200.0 },
	[AIRSTRIP.VERDANT_MEADOWS] = { { 175.0, 2502.0 }, 180.0, 1000.0 }
}

-- Radar.h: eRadarTraceHeight
RADAR_TRACE = {
	LOW = 0, -- Up-pointing Triangle △
	HIGH = 1, -- Down-pointing Triangle ▽
	NORMAL = 2 -- Box □
}

RADAR_TRACE_TEXTURE_NAMES = {
	[RADAR_TRACE.LOW] = "radar_trace_low",
	[RADAR_TRACE.HIGH] = "radar_trace_high",
	[RADAR_TRACE.NORMAL] = "radar_trace_normal"
}

VEHICLE_REAL_TYPE = {
	AUTOMOBILE = "Automobile",
	PLANE = "Plane",
	BIKE = "Bike",
	HELICOPTER = "Helicopter",
	BOAT = "Boat",
	TRAIN = "Train",
	TRAILER = "Trailer",
	BMX = "BMX",
	MONSTER_TRUCK = "Monster Truck",
	QUAD = "Quad",
	HOVERCRAFT = "Hovercraft" -- custom type (original type is "Plane")
}

