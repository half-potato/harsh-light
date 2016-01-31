require 'render/AssetPackage'
gAssetPackage = AssetPackage.new("assets")
--loadAssets(BIOME_INDEX, "biome/Biome.png", "biome/Biome.lua", gAssetPackage)
loadAssets(GREEN_INDEX, "biome/Green.png", "biome/Green.lua", gAssetPackage)
loadAssets(STRUCT_INDEX, "biome/Struct.png", "biome/Struct.lua", gAssetPackage)
loadAssets(TILE_INDEX, "biome/Tile.png", "biome/Tile.lua", gAssetPackage)
loadAssets(ENTITY_INDEX, "biome/Entity.png", "biome/Entity.lua", gAssetPackage)
