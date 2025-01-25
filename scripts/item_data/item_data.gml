

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
				
			case ITEM_TYPE.Food:
				return {
					nutrition: 0,
				}
			
			case ITEM_TYPE.Fuel:
				return {
					fuel: 10,
				}
			
			case ITEM_TYPE.LightSource:
				return {
					range: 0,
					color: c_white,
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
	add(ITEM.BasicTurret,			new item(ITEM_TYPE.Turret,				"basic turret",					-1,						{}));
	
	// Inventories
	add(ITEM.BasicInventory,	new item(ITEM_TYPE.Inventory,			"basic inventory",			-1,						{}));
	
	
	// Blank items
	add(ITEM.RawIron,
			new item(ITEM_TYPE.Blank,				"iron ore",							sRawIron,			{}));
			
	add(ITEM.Iron,
			new item(ITEM_TYPE.Blank,				"iron ingot",						sIronIngot,		{}));
			
	add(ITEM.Coal,
			new item(ITEM_TYPE.Fuel,				"coal",									sCoal,				{}));
	
	
	print_ds_map(ItemData);
	
}