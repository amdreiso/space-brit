function tile_data(){

globalvar TileData;
TileData = ds_map_create();

var tile = function(type, sprite) constructor {
	self.type = type;
	self.sprite = sprite;
}

var add = function(key, val) {
	TileData[? key] = val;
}


add(TILE.Arid1, new tile(TILE_TYPE.Solid, sArid1));


}