function planet_data(){


globalvar PlanetTypeData;
PlanetTypeData = ds_map_create();

var planetType = function(tilesetArray) constructor {
	self.tileset = tilesetArray;
}

PlanetTypeData[? PLANET_TYPE.Arid] = new planetType(
	[
		TILE.Arid1,
	]
);

PlanetTypeData[? PLANET_TYPE.Rocky] = new planetType(
	[
	]
);

PlanetTypeData[? PLANET_TYPE.Icy] = new planetType(
	[
	]
);

PlanetTypeData[? PLANET_TYPE.Volcanic] = new planetType(
	[
	]
);

}