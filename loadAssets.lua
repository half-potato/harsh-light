require 'render/AssetPackage'
ASSET_PACKAGE = AssetPackage.new{folder = "assets"}
--loadAssets(ENTITY_INDEX, "biome/Entity.png", "biome/Entity.lua", ASSET_PACKAGE)
loadAssets(GREEN_INDEX, "green/Green.png", "green/Green.lua", ASSET_PACKAGE)
loadAssets(STRUCT_INDEX, "struct/Struct.png", "struct/Struct.lua", ASSET_PACKAGE)
loadAssets(TILE_INDEX, "tile/Tile.png", "tile/Tile.lua", ASSET_PACKAGE)
loadEntityTable(ENTITY_INDEX, "entities", ASSET_PACKAGE)
