
enum ITEM_TYPE {
	Normal,
	Propeller,
	Turret,
	Inventory,
}

function item_data(){
	
	globalvar ItemData;
	ItemData = [];
	
	var item = function(type, name, sprite, componentVariables) constructor {
		self.type = type;
		self.name = name;
		self.sprite = sprite;
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
	
	var add = function(val) {
		array_push(ItemData, val);
	}
	
	
	add(new item(ITEM_TYPE.Propeller,			"basic propeller",			-1,				{}));
	add(new item(ITEM_TYPE.Turret,				"basic turret",					-1,				{}));
	add(new item(ITEM_TYPE.Inventory,			"basic inventory",			-1,				{}));
	
	
}