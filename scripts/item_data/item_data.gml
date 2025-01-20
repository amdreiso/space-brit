

function item_data(){
	
	globalvar ItemData;
	ItemData = ds_map_create();
	
	var item = function(type, name, spr, componentVariables) constructor {
		self.type = type;
		self.name = name;
		self.sprite = spr;
		self.components = {};
		
		
		switch ( self.type ) {
			
			case ITEM_TYPE.Turret:
				
				self.components = {
					damage: 2,
					shootCooldown: 10,
					
					sprite: sTurret,
					spriteCooldown: sTurretCooldown,
				}
				
				break;
			
			case ITEM_TYPE.Propeller:
				
				self.components = {
					acceleration: 0.05,
					fuelConsumption: 0.1,
					
					flameColor: [c_yellow, c_red],
				}
				
				break;
			
			case ITEM_TYPE.Inventory:
				
				self.components = {
					capacity: 20,
				}
				
				break;
			
		}
		
		
		// Set components
		var names = struct_get_names(componentVariables);
		
		for (var i = 0; i < array_length(names); i++) {
			var val = variable_struct_get(componentVariables, names[i]);
			struct_set(self.components, names[i], val);
		}
	}
	
	var add = function(itemID, val) {
		ItemData[? itemID] = val;
	}
	
	
	add(ITEM.BasicPropeller,		new item(ITEM_TYPE.Propeller,			"basic propeller",			-1,				{}));
	add(ITEM.BasicTurret,				new item(ITEM_TYPE.Turret,				"basic turret",					-1,				{}));
	add(ITEM.BasicInventory,		new item(ITEM_TYPE.Inventory,			"basic inventory",			-1,				{}));
	
	add(ITEM.RawIron,						new item(ITEM_TYPE.Normal,				"raw iron",							-1,				{}));
	add(ITEM.Iron,							new item(ITEM_TYPE.Normal,				"iron",									-1,				{}));
	add(ITEM.Coal,							new item(ITEM_TYPE.Normal,				"coal",									sCoal,		{}));
	
}