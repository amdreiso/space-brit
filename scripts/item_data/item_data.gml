

function item_data(){
	
	globalvar ItemData;
	ItemData = ds_map_create();
	
	itemDefaultComponents = function(type) {
		switch ( type ) {
			case ITEM_TYPE.Turret:
				return {
					damage: 2,
					shootCooldown: 10,
					
					sprite: sTurret,
					spriteCooldown: sTurretCooldown,
					
					recoil: 0.3,
					
					shoot: function(obj) {
					}
				}
				
			case ITEM_TYPE.Propeller:
				return {
					acceleration: 0.05,
					fuelConsumption: 0.1,
					
					flameColor: [c_yellow, c_red],
				}
				
			case ITEM_TYPE.Inventory:
				return {
					capacity: 20,
				}
				
			case ITEM_TYPE.Radar:
				return {
					sprite: sBasicRadarMenu,
					
					radius: 200,
					track: [],
				}
				
			case ITEM_TYPE.Food:
				return {
					nutrition: 0,
				}
			
			case ITEM_TYPE.Fuel:
				return {
					fuel: 10,
				}
			
			default:
				return {};
		}
	}
	
	var item = function(type, name, spr, componentVariables) constructor {
		self.type = type;
		self.name = name;
		self.sprite = spr;
		self.components = other.itemDefaultComponents(self.type);
		
		// Set components
		if (componentVariables == undefined) return;
		
		var names = struct_get_names(componentVariables);
		
		for (var i = 0; i < array_length(names); i++) {
			var val = variable_struct_get(componentVariables, names[i]);
			struct_set(self.components, names[i], val);
		}
	}
	
	var add = function(itemID, val) {
		ItemData[? itemID] = val;
	}
	
	
	// Propellers
	add(ITEM.BasicPropeller,	new item(ITEM_TYPE.Propeller,			"basic propeller",			-1));
	
	// Turrets
	add(ITEM.BasicTurret,			new item(ITEM_TYPE.Turret,				"basic turret",					-1,						{
		shootCooldown: 15,
		
		shoot: function(obj) {
			with (obj) {
				var spaceBetween = 4;
				var offsetX = lengthdir_x(spaceBetween, direction + 90);
				var offsetY = lengthdir_y(spaceBetween, direction + 90);
							
				with (instance_create_depth(x - offsetX, y - offsetY, depth + 10, SpaceshipProjectile)) {
					self.sprite_index = sProjectile1;
					self.direction = other.turretAngle;
					self.speed = 9;
				}
							
				with (instance_create_depth(x + offsetX, y - offsetY, depth + 10, SpaceshipProjectile)) {
					self.sprite_index = sProjectile1;
					self.direction = other.turretAngle;
					self.speed = 9;
				}
			}
		}
	}));
	
	add(ITEM.AutomaticTurret,			new item(ITEM_TYPE.Turret,				"automatic turret",					-1,						{
		sprite: sAutomaticTurret,
		spriteCooldown: sAutomaticTurret,
		
		shootCooldown: 4,
		
		shoot: function(obj) {
			with (obj) {
				with (instance_create_depth(x, y, depth + 10, SpaceshipProjectile)) {
					self.sprite_index = sProjectile1;
					self.direction = other.turretAngle;
					self.speed = 6;
					
					self.image_xscale = .7;
					self.image_yscale = .7;
				}
			}
		}
	}));
	
	// Inventories
	add(ITEM.BasicInventory,	new item(ITEM_TYPE.Inventory,			"basic inventory",			-1,						{}));
	
	// Radars
	add(ITEM.BasicRadar,	new item(ITEM_TYPE.Radar,							"basic radar",					-1,
	{
		track: [
			{obj: Sun, color: c_yellow, size: 3},
			{obj: Planet, color: c_lime, size: 3},
			{obj: Enemy, color: c_red, size: 1},
		],
		radius: 500,
	}));
	
	
	// Blank items
	add(ITEM.RawIron,
			new item(ITEM_TYPE.Blank,				"iron ore",							sRawIron,			{}));
			
	add(ITEM.Iron,
			new item(ITEM_TYPE.Blank,				"iron ingot",						sIronIngot,		{}));
			
	add(ITEM.Coal,
			new item(ITEM_TYPE.Fuel,				"coal",									sCoal,				{}));
	
	
	print_ds_map(ItemData);
}