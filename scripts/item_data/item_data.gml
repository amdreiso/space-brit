

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
					
					recoil: 0.3,
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
			
			case ITEM_TYPE.Food:
				
				self.components = {
					nutrition: 0,
				}
				
				break;
			
			case ITEM_TYPE.LightSource:
				
				self.components = {
					range: 0,
					color: c_white,
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
	
	
	// Propellers
	add(ITEM.BasicPropeller,	new item(ITEM_TYPE.Propeller,			"basic propeller",			-1,						{}));
	
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
	new item(ITEM_TYPE.Blank,				"coal",									sCoal,				{}));
	
	

}