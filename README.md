# mradar
Reengineered original GTA:SA radar for MTA:SA

## Features
- default blips and radar areas are supported
- default blips coloring
- artificial horizon and altimeter
- original textures set format
- modify-friendly
- no scaling-bugs
- new F11 map
- map legend
- map cursor moving

## Settings
You can configure radar with predefined global Lua variables. See `mradar_main_client.lua` script file. Some of important setting see below
- `RADAR_BLIP_COLOR_ENABLED` (**default is `false`**) - default blips color (usually blips have red or black color, u should always define blips color for use this feature) 

## Exported client-side functions
- `getMRadarVisible()`
- `setMRadarVisible(bool visible)`