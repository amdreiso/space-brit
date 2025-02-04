
// Planet Creation
components = 0;
createPlanet = true;


generatePlanet = function() {
	if (!createPlanet || !is_struct(components)) return;
	
	var width = 20 * (components.scale * 0.25);
	
	// Create tiles
	for (var i = -floor(width/2); i < ceil(width/2); i++) {
		for (var j = -floor(width/2); j < ceil(width/2); j++) {
			var tile = instance_create_layer(x + i * TILE_SIZE, y + j * TILE_SIZE, "Tiles", Tile);
			var tileID = irandom(array_length(PlanetTypeData[? components.type].tileset) - 1);
			
			tile.tileID = tileID;
			tile.color = components.color;
		}
	}
	
	createPlanet = false;
}

