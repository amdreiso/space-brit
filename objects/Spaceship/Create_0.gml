
// Sleep
busy = false;


// Health
hp = 1000;


// Components
propellerID					= ITEM.BasicPropeller;
turretID						= ITEM.BasicTurret;
inventoryID					= ITEM.BasicInventory;


// Movement
spd = 0;
hsp = 0;
vsp = 0;

force = new vec2();

turn = 0;
turnForce = 10;
angle = irandom(360);

maxSpeed = 2.5;
acceleration = 0.05;

turnPrecision = 0.25;
turnSpeed = 0.2;

mouseAngle = 0;

fuel = 1;


handleMovement = function() {
	if (busy) return;
	
	x += hsp + force.x;
	y += vsp + force.y;
	
	hsp = lengthdir_x(spd, direction);
	vsp = lengthdir_y(spd, direction);

	force.x = lerp(force.x, 0, 0.02);
	force.y = lerp(force.y, 0, 0.02);

	// Mouse angle wow
	mouseAngle = point_direction(x, y, mouse_x, mouse_y);

	var minSpeedTurn = spd / turnForce;
	var maxTurnSpeed = 5;

	if (keyboard_check(ord("A"))) {
		
		turn -= turnSpeed * minSpeedTurn;
		
	} else if (keyboard_check(ord("D"))) {
		
		turn += turnSpeed * minSpeedTurn;
		
	} else {
		turn = lerp(turn, 0, 0.1);
	}


	turn = clamp(turn, -maxTurnSpeed, maxTurnSpeed);


	// Move Forward
	if (keyboard_check(ord("W"))) {
		
		spd += acceleration;
		spd = clamp(spd, 0, maxSpeed);
		var offset = 10;
		var range = 4;
		
		var xx = x - lengthdir_x(offset, direction) + irandom_range(-range, range);
		var yy = y - lengthdir_y(offset, direction) + irandom_range(-range, range);
		
		// Fire Particles
		repeat (opt(10, fps)) {
			with (instance_create_layer(round(xx), round(yy), "Glowing_Particles", Particle)) {
				self.sprite_index = sPixel_particle;
				self.image_speed = 0;
				self.image_index = irandom(sprite_get_number(self.sprite_index)-1);
				
				var ton = irandom_range(0, 5);
				var black = make_color_rgb(ton, ton, ton);
				
				self.spd = irandom(3) + 1;
				self.move = function(value){
					x += irandom_range(-value, value);
					y += irandom_range(-value, value);
				
					self.spd += 1;
				};
				
				self.step = irandom_range(10, 20);
				
				var colorArray = ItemData[? other.propellerID].components.flameColor;
				var colorIndex = irandom(array_length(colorArray)-1);
				
				self.color = [colorArray[colorIndex], black, random_range(0.01, 0.05)];
				self.destroyTime = (irandom(2) + 1) * 30;
				self.scale = 1;
				
				self.fadeOut = true;
				self.fadeTime = 0.05;
			}
		}
		
		// SFX
		if (!audio_is_playing(snd_propellant)) {
			propellantSound = sound3D(emitter, xx, yy, snd_propellant, false, 0, 1);
		}
		
		audio_sound_gain(propellantSound, 0.03 * Settings.volume.effects * Settings.volume.master, 300);
		audio_emitter_position(emitter, xx, yy, 0);
		
	} else {
		spd = lerp(spd, 0, 0.05);
		turn = lerp(turn, 0, 0.1);
		
		if (propellantSound != -1) {
			audio_sound_gain(propellantSound, 0, 300);
		}
	}
	
	angle += turn;
	direction = angle;
}


// Attacking
shootingCooldown = 0;

handleAttack = function() {
	if (busy) return;
	
	if (keyboard_check_pressed(vk_space) && shootingCooldown == 0) {
		var turret = ItemData[? turretID];
		
		var spaceBetween = 4;
		
		var offset_x = lengthdir_x(spaceBetween, direction + 90);
		var offset_y = lengthdir_y(spaceBetween, direction + 90);
		
		
		with (instance_create_depth(x + offset_x, y + offset_y, depth+10, SpaceshipProjectile)) {
			self.sprite_index = sProjectile1;
			self.direction = other.mouseAngle;
			self.speed = 9;
		}
		
		with (instance_create_depth(x - offset_x, y - offset_y, depth+10, SpaceshipProjectile)) {
			self.sprite_index = sProjectile1;
			self.direction = other.mouseAngle;
			self.speed = 9;
		}
		
		camera_shake(0.75);
		shootingCooldown = 10;
		
		audio_play_sound(snd_shoot, 0, false, 0.10 * get_volume(AUDIO.Effects), 0);
		
		// Recoil
		var recoil = turret.components.recoil;
		force.x -= lengthdir_x(recoil, mouseAngle);
		force.y -= lengthdir_y(recoil, mouseAngle);
	}

	if (shootingCooldown > 0) shootingCooldown -= GameSpeed;
}



// Camera
cam = instance_create_depth(x, y, depth, Camera);
with (cam) {
	self.target = other;
}


// States
inBattle = false;


// Sound
emitter = audio_emitter_create();
propellantSound = -1;


// Tips
tipAlpha = 0;


// Inventory
inventorySlot = function(_itemID, _amount) {
	return {
		itemID: _itemID,
		amount: _amount,
	}
}

inventory = [];
inventoryGrab = {
	itemID: -1,
	amount: 0,
	pos: -1,
};

repeat (ItemData[? inventoryID].components.capacity) {
	array_push(inventory, inventorySlot(-1, 0));
}

inventoryAdd = function(itemID) {
	for (var i = 0; i < array_length(inventory) - 1; i++) {
		var slot = inventory[i];
		
		if (slot.itemID == itemID && slot.amount < ITEM_MAX_STACK) {
			
			slot.amount ++;
			break;
			
		} else if (slot.itemID == -1) {
			
			slot.itemID = itemID;
			slot.amount = 1;
			
			break;
			
		}
	}
}

inventoryButtonClick = function() {
	audio_play_sound(snd_select, 0, false, get_volume(AUDIO.Effects), 0, random_range(0.95, 1.00));
}


// Draw
turretSprite = sTurret;

drawSpaceship = function() {
	var s = 1;

	if (shootingCooldown > 0) {
		turretSprite = sTurretCooldown;
	} else {
		turretSprite = sTurret;
	}

	draw_3d(s, x, y+3, turretSprite, s, s, mouseAngle - 90, c_white, 1, true, 100, 10);
	draw_3d(s, x, y, sSpaceship, s, s, direction-90);
}


// Spaceship menu
enum SPACESHIP_MENU_PAGE {
	Home,
	Build,
	Inventory,
}

menu = false;
menuPage = 0;
menuAlpha = 0;
menuModelTheta = irandom(360);
menuModelThetaForce = 0;
menuLastItem = -1;

menuSize = new dim(500, 600);

drawMenu = function() {
	if (keyboard_check_pressed(ord("E")) && !Paused) {
		menu = !menu;
	}
	
	if (menu) {
		menuAlpha = lerp(menuAlpha, 1, 0.25);
	} else {
		menuAlpha = lerp(menuAlpha, 0, 0.25);
	}
	
	
	if (menuAlpha < 0.05) {
		menuPage = SPACESHIP_MENU_PAGE.Home;
		return;
	}
	
	if (keyboard_check_pressed(vk_escape)) {
		menu = false;
	}
	
	// Draw menu
	var c0 = $FF080808, c1 = $FF181818;
	var xx = window_get_width() / 4;
	var yy = window_get_height() / 2;
	var ww = menuSize.width;
	var hh = menuSize.height;
	
	draw_set_alpha(menuAlpha);
	
	// Draw background
	rect(xx, yy, ww, hh, c0, false);
	rect(xx, yy, ww, hh, c1, true);
	
	draw_set_valign(fa_top);
	draw_set_halign(fa_center);
	
	// Draw title
	var titlePadding = 10;
	draw_text(xx, (yy - hh / 2) + titlePadding, "Spaceship Menu");
	
	var top = (yy - hh / 2) + titlePadding * 2 + 14;
	
	
	switch (menuPage) {
		
		case SPACESHIP_MENU_PAGE.Home:
			
			var modelScale = 3;
			var modelY = top + 70;
			var modelAngle = point_direction(xx, modelY, window_mouse_get_x(), window_mouse_get_y());
			
			menuModelTheta -= 0.08 + menuModelThetaForce;
			menuModelThetaForce = lerp(menuModelThetaForce, 0, 0.1);
			
			draw_3d(modelScale, xx, modelY + 3, turretSprite, modelScale, modelScale, modelAngle - 90, c_white, menuAlpha, true, 100, 10);
			draw_3d(modelScale, xx, modelY, sSpaceship, modelScale, modelScale, menuModelTheta-90, c_white, menuAlpha);
			
			button_gui(xx, modelY, 80, 80, "", false, 0, 0, 0, menuAlpha, function(){
				if (mouse_check_button_pressed(mb_left)) {
					menuModelThetaForce = random(20.0);
				}
			}, BUTTON_ORIGIN.MiddleCenter);
			
			var buttonY = modelY + 75;
			var buttonHeight = 28;
			var buttonSep = 28 * 1.25;
			
			button_gui(
				xx, buttonY, ww/1.5, buttonHeight, "Components",
				true, $FF181818, c_ltgray, 0.10, menuAlpha,
				function(){
					
					if (mouse_check_button_pressed(mb_left)) {
						menuPage = SPACESHIP_MENU_PAGE.Build;
						
						inventoryButtonClick();
					}
					
					window_set_cursor(cr_handpoint);
					
				}, BUTTON_ORIGIN.MiddleCenter
			);
			
			button_gui(
				xx, buttonY + 1 * buttonSep, ww/1.5, buttonHeight, "Inventory",
				true, $FF181818, c_ltgray, 0.10, menuAlpha,
				function(){
					
					if (mouse_check_button_pressed(mb_left)) {
						menuPage = SPACESHIP_MENU_PAGE.Inventory;
						
						inventoryButtonClick();
					}
					
					window_set_cursor(cr_handpoint);
					
				}, BUTTON_ORIGIN.MiddleCenter
			);
			
			break;
		
		case SPACESHIP_MENU_PAGE.Build:
			
			button_gui(
				xx, top + 14, ww / 1.5, 28, "Go Back",
				true, $FF181818, c_ltgray, 0.10, menuAlpha,
				function(){
					
					if (mouse_check_button_pressed(mb_left)) {
						menuPage = SPACESHIP_MENU_PAGE.Home;
						
						inventoryButtonClick();
					}
					
					window_set_cursor(cr_handpoint);
					
				}, BUTTON_ORIGIN.MiddleCenter
			);
			
			
			var modelScale = 5;
			var modelY = hh / 2;
			var modelAngle = point_direction(xx, modelY, window_mouse_get_x(), window_mouse_get_y());
			
			menuModelTheta -= 0.08;
			
			draw_3d(modelScale, xx, modelY + 3, turretSprite, modelScale, modelScale, modelAngle - 90, c_white, menuAlpha, true, 100, 10);
			draw_3d(modelScale, xx, modelY, sSpaceship, modelScale, modelScale, menuModelTheta-90, c_white, menuAlpha);
			
			var buttonSize = 35;
			var buttonOffsetX = 25;
			var buttonX = (xx - ww / 2) + buttonOffsetX + buttonSize / 2;
			var buttonY = modelY + 100;
			
			draw_set_alpha(menuAlpha);
			
			button_gui(
				buttonX, buttonY, buttonSize, buttonSize, "",
				true, $FF181818, c_ltgray, 0.10, menuAlpha,
				function(){
					
					if (mouse_check_button_pressed(mb_left)) {
						inventoryButtonClick();
					}
					
					window_set_cursor(cr_handpoint);
					
				}, BUTTON_ORIGIN.MiddleCenter
			);
			
			
			draw_set_halign(fa_left);
			draw_set_valign(fa_middle);
			
			draw_text_color(buttonX + buttonSize, buttonY, "placeholder for item's name", c_white, c_white, c_white, c_white, menuAlpha);
			
			
			draw_set_halign(fa_center);
			
			break;
		
		case SPACESHIP_MENU_PAGE.Inventory:
			
			button_gui(
				xx, top + 14, ww / 1.5, 28, "Go Back",
				true, $FF181818, c_ltgray, 0.10, menuAlpha,
				function(){
					
					if (mouse_check_button_pressed(mb_left)) {
						menuPage = SPACESHIP_MENU_PAGE.Home;
						
						inventoryButtonClick();
					}
					
					window_set_cursor(cr_handpoint);
					
				}, BUTTON_ORIGIN.MiddleCenter
			);
			
			
			// Draw every inventory slot
			selectedSlot = -1;
			var itemName = "empty";			
			var itemSpr = -1;			

			for (var i = 0; i < array_length(inventory) - 1; i++) {
				var maxRows = 7;
				var slotSize = 48;
				var slotPadding = slotSize * 1.25;
				
				var yIndent = i div maxRows;
				
				var slotX = (((xx + i * (slotPadding)) - maxRows / 2 * slotSize) - (yIndent * maxRows) * slotPadding) - slotSize / 4;
				var slotY = (top + 18 + slotSize) + (yIndent * (slotPadding));
				
				if (i % 5 == true) {
					yIndent ++;
				}
				
				ii = i;
				
				var itemID = inventory[i].itemID;
				
				if (itemID != -1) {
					itemSpr = ItemData[? itemID].sprite;
					
					if (itemSpr != -1) {
						var sprScale = 1.5;
						draw_sprite_ext(itemSpr, -1, slotX, slotY, sprScale, sprScale, 0, c_white, menuAlpha);
					}
				}
				
				if (selectedSlot != -1 && inventory[selectedSlot].itemID != -1) {
					itemName = ItemData[? inventory[selectedSlot].itemID].name;
				}
				
				button_gui(slotX, slotY, slotSize, slotSize, "", true, $181818, c_ltgray, 0.1, menuAlpha, function(){
					
					selectedSlot = ii;
					
					if (mouse_check_button_pressed(mb_left)) {
						if (selectedSlot == -1) return;
						
						if (inventoryGrab.itemID == -1) {
							
							// Pass item to inventoryGrab
							inventoryGrab.itemID			= inventory[selectedSlot].itemID;
							inventoryGrab.amount			= inventory[selectedSlot].amount;
							inventoryGrab.pos					= ii;
							
							// Empty slot you took the item from
							inventory[selectedSlot] = inventorySlot(-1, 0);
							
						} else {
							
							// If the slot you're putting the item in is empty
							if (inventory[selectedSlot].itemID == -1) {
								
								// Set slot
								inventory[selectedSlot].itemID = inventoryGrab.itemID;
								inventory[selectedSlot].amount = inventoryGrab.amount;
								
								// Reset grabbed item
								inventoryGrab.itemID		= -1;
								inventoryGrab.amount		= 0;
								inventoryGrab.pos				= -1;
								
							} else 
							
							// If the slot has the same item
							if (inventory[selectedSlot].itemID == inventoryGrab.itemID) {
								
								// If the sum of both item's amount is less than a stack, add them
								if (inventory[selectedSlot].amount + inventoryGrab.amount < ITEM_MAX_STACK + 1) {
									
									inventory[selectedSlot].amount += inventoryGrab.amount;
									
									// Reset grabbed item
									inventoryGrab.itemID		= -1;
									inventoryGrab.amount		= 0;
									inventoryGrab.pos				= -1;
									
								} else {
									
									var val = ITEM_MAX_STACK - inventory[selectedSlot].amount;
									
									inventoryGrab.amount -= val;
									
									inventory[selectedSlot].amount = ITEM_MAX_STACK;
									
								}
								
							} else {
								
								inventoryGrab.itemID ^= inventory[selectedSlot].itemID;
								inventoryGrab.amount ^= inventory[selectedSlot].amount;
								
								inventory[selectedSlot].itemID ^= inventoryGrab.itemID;
								inventory[selectedSlot].amount ^= inventoryGrab.amount;
								
								inventoryGrab.itemID ^= inventory[selectedSlot].itemID;
								inventoryGrab.amount ^= inventory[selectedSlot].amount;
								
								
							}
							
						}
						
					}
					
					
					if (mouse_check_button_pressed(mb_right)) {
						if (selectedSlot == -1) return;
						
						if (inventoryGrab.itemID == -1) {
							
							// Grab half of the items
							if (inventory[selectedSlot].itemID != -1 && inventory[selectedSlot].amount > 1) {
								
								inventoryGrab.amount += ceil(inventory[selectedSlot].amount / 2);
								inventoryGrab.itemID = inventory[selectedSlot].itemID;
								inventoryGrab.pos = ii;
								
								inventory[selectedSlot].amount = floor(inventory[selectedSlot].amount / 2);
								
							}
							
						} else {
							
							if (inventory[selectedSlot].itemID == -1 || inventory[selectedSlot].itemID == inventoryGrab.itemID) {
								
								inventoryGrab.amount --;
								
								inventory[selectedSlot].itemID = inventoryGrab.itemID;
								inventory[selectedSlot].amount ++;
								
								if (inventoryGrab.amount <= 0) {
									inventoryGrab.itemID = -1;
									inventoryGrab.amount = 0;
									inventoryGrab.pos = -1;
								}
								
							}
							
						}
					}
					
					
					window_set_cursor(cr_handpoint);
					
				}, BUTTON_ORIGIN.MiddleCenter);
				
				if (inventory[i].amount > 1) {
					var d = 3.5;
					draw_text_color(slotX + slotSize / d, slotY + slotSize / d, inventory[i].amount, c_white, c_white, c_white, c_white, menuAlpha);
				}
			}
			
			if (selectedSlot != -1 && inventoryGrab.itemID == -1) {
				var offset = new vec2(20, -10);
				var shadowOffset = new vec2(-1.5, 1.5);
				
				draw_text_color(
					window_mouse_get_x() + offset.x + shadowOffset.x,
					window_mouse_get_y() + offset.y + shadowOffset.y,
					itemName,
					c_black, c_black, c_black, c_black, 1
				);
				
				draw_text(
					window_mouse_get_x() + offset.x,
					window_mouse_get_y() + offset.y,
					itemName
				);
			}
			
			if (inventoryGrab.itemID != -1) {
				var item = ItemData[? inventoryGrab.itemID];
				
				if (item.sprite == -1) return;
				
				draw_sprite_ext(item.sprite, 0, window_mouse_get_x(), window_mouse_get_y(), 1.90, 1.90, 0, c_white, 1);
			}
			
			break;
		
	}
	
	draw_set_alpha(1);
}


