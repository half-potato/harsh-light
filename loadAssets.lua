require 'render/AssetPackage'
gAssetPackage = AssetPackage.new{folder = "assets"}
--loadAssets(ENTITY_INDEX, "biome/Entity.png", "biome/Entity.lua", gAssetPackage)
loadAssets(GREEN_INDEX, "green/Green.png", "green/Green.lua", gAssetPackage)
loadAssets(STRUCT_INDEX, "struct/Struct.png", "struct/Struct.lua", gAssetPackage)
loadAssets(TILE_INDEX, "tile/Tile.png", "tile/Tile.lua", gAssetPackage)
loadEntityTable(ENTITY_INDEX, "entity", gAssetPackage)
