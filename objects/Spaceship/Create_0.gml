
// Sleep
busy = false;


// Health
maxHp = 1000;
hp = maxHp;
isHit = false;
hitCooldown = 0;
hitAlpha = 0;

dead = false;
deadMenuAlpha = 0;

hit = function(damage, obj, recoil = 0, spin = 0) {
	if (hitCooldown > 0) return;
	
	isHit = true;
	hp -= damage;
	
	hitCooldown = 10;
	hitAlpha = 0.3;
	
	dead = (hp <= 0);
	
	if (dead) audio_stop_all();
	
	// THE ART OF CAMERA SHAKE TAUGHT ME THIS SHAKE THAT THING
	sound3D(emitter, x, y, snd_hit1, false, 0.24 * get_volume(AUDIO.Effects), random_range(0.85, 1.00));
	camera_shake(17, 1);
	
	// Spin LMAO
	spinForce = spin;
	
	// Recoil
	var dir = point_direction(x, y, obj.x, obj.y);
	force.x -= lengthdir_x(recoil, dir);
	force.y -= lengthdir_y(recoil, dir);
	
	// Play malfunction sfx
	if (irandom(10) > 8) 
		audio_play_sound(snd_death1, 0, false, 0.15 * get_volume(AUDIO.Effects), 0, 0.70);
}

drawDeadMenu = function() {
	if (!dead) return;
	
	var w = window_get_width();
	var h = window_get_height();
	
	
	deadMenuAlpha = lerp(deadMenuAlpha, 0.95, 0.01);
	
	
	draw_set_alpha(deadMenuAlpha);
	
	draw_rectangle_color(
		0, 0, w, h,
		c_black, c_black, c_black, c_black, false
	);
	
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	
	draw_set_font(fnt_mainTIP);
	draw_text(w/2, h/2, ts(23));
	
	draw_set_font(fnt_main);
	
	var buttonOffset = 250;
	var buttonWidth = 60;
	var buttonHeight = 20;
	var buttonY = (h / 1.75);
	
	gp_menu(0, 1);
	
	// Restart	
	button_gui((w/2) - buttonOffset, buttonY, buttonWidth, buttonHeight, ts(24), 0, true, $181818, c_ltgray, 0.5, deadMenuAlpha, function(){
		if (Keymap.select) {
			game_restart();
		}
	}, BUTTON_ORIGIN.MiddleCenter);
	
	// Quit
	button_gui((w/2) + buttonOffset, buttonY, buttonWidth, buttonHeight, ts(25), 1, true, $181818, c_ltgray, 0.5, deadMenuAlpha, function(){
		if (Keymap.select) {
			game_end();
		}
	}, BUTTON_ORIGIN.MiddleCenter);
	
	draw_set_alpha(1);
}


// Components
propellerID					= ITEM.BasicPropeller;
turretID						= ITEM.AutomaticTurret;
inventoryID					= ITEM.BasicInventory;
radarID							= ITEM.BasicRadar;


// Movement
spd = 0;
hsp = 0;
vsp = 0;

force = vec2();
spinForce = 0;

turn = 0;
turnForce = 10;
angle = irandom(360);

maxSpeed = 2.5 * 1;
acceleration = 0.05;

turnPrecision = 0.25;
turnSpeed = 0.2;

mouseAngle = 0;

maxFuel = 1000;
fuel = maxFuel;

distanceToSun = 0;
distanceToSunOffset = 0;
inSunRadius = false;


handleMovement = function() {
	if (busy) return;
	
	x += hsp + force.x;
	y += vsp + force.y;
	
	hsp = lengthdir_x(spd, direction);
	vsp = lengthdir_y(spd, direction);

	force.x = lerp(force.x, 0, 0.02);
	force.y = lerp(force.y, 0, 0.02);
	spinForce = lerp(spinForce, 0, 0.08);

	// Mouse angle wow
	mouseAngle = point_direction(x, y, mouse_x, mouse_y);

	var minSpeedTurn = spd / turnForce;
	var maxTurnSpeed = 5;
	
	var map = get_keymap();
	
	// Turn sideways
	if (map.left) {
		
		turn -= (turnSpeed * minSpeedTurn);
		
	} else if (map.right) {
		
		turn += (turnSpeed * minSpeedTurn);
		
	} else {
		
		turn = lerp(turn, 0, 0.1);
		
	}
	
	turn += spinForce;
	
	turn = clamp(turn, -maxTurnSpeed, maxTurnSpeed);
	
	// Move Forward
	if (map.forward && fuel > 0) {
		var propeller = ItemData[? propellerID];
		
		fuel -= propeller.components.fuelConsumption;
		
		spd += propeller.components.acceleration;
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
				self.move = function(value) {
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


calculateSunProximity = function() {
	if (busy) return;
	
	var sun = instance_nearest(x, y, Sun);
	
	// If spaceship is in suns radius
	inSunRadius = (distanceToSun < distanceToSunOffset);
	
	if (instance_exists(sun)) {
		var disOffset = (sprite_get_width(sun.sprite) * sun.scale) / 2;
	  var dir = point_direction(sun.x, sun.y, x, y);
    
	  var xx = lengthdir_x(disOffset, dir);
	  var yy = lengthdir_y(disOffset, dir);
    
	  var edgeX = sun.x + xx;
	  var edgeY = sun.y + yy;
		
	  distanceToSun = point_distance(x, y, edgeX, edgeY);
		var divider = 1000;
		var maxDistance = sprite_get_width(sun.sprite) * sun.scale;
		
		// beep sfx
		distanceToSunOffset = disOffset * 2;
		
		
		// Check if the spaceship is in the sun radius, and if the prox. alert is true, it will beep every few seconds
		// and it will get faster the closer you are to the sun
		if (!inSunRadius || !menuSettings.sunProximityAlert) return;
		
		var beepDis = distanceToSun / distanceToSunOffset;
		var beepGain = abs(0.25 / (beepDis * 2));
		beepGain = clamp(beepGain, 0, 0.60);
		
		var minFreq = 100;
		var maxFreq = 1000;
		
		var freq = clamp(minFreq + (maxFreq - minFreq) * (distanceToSun / maxDistance), minFreq, maxFreq);
		
		beepInterval += GameSpeed;
		
		if (beepInterval > freq / (15) && !Paused) {
			beepInterval = 0;
			audio_play_sound(snd_alert1, 0, false, beepGain * get_volume(AUDIO.Effects));
		}
	}
}


// Attacking
turretAngle = 0;
shootingCooldown = 0;

handleAttack = function() {
	if (busy) return;
	
	var map = get_keymap();
	
	if (map.attack && shootingCooldown == 0) {
		var turret = ItemData[? turretID];
		
		var spaceBetween = 4;
		
		turret.components.shoot(self);
		
		camera_shake(0.75);
		shootingCooldown = turret.components.shootCooldown;
		
		audio_play_sound(snd_shoot, 0, false, 0.10 * get_volume(AUDIO.Effects), 0);
		
		// Recoil
		var recoil = turret.components.recoil;
		force.x -= lengthdir_x(recoil, turretAngle);
		force.y -= lengthdir_y(recoil, turretAngle);
	}

	if (shootingCooldown > 0) shootingCooldown -= GameSpeed;
}



// States
inBattle = false;


// Sound
emitter = audio_emitter_create();
propellantSound = -1;


// Tips
tipAlpha = 0;


// GUI
sunAlpha = 0;
beepInterval = 0;




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
spaceshipSprite = sSpaceship;
turretSprite = sTurret;

draw = function() {
	var s = 1;
	var turret = ItemData[? turretID];
	
	if (shootingCooldown > 0) {
		turretSprite = turret.components.spriteCooldown;
	} else {
		turretSprite = turret.components.sprite;
	}
	
	// turret points to cursor
	if (Controller == CONTROLLER.Keyboard) {
		
		turretAngle = mouseAngle;
		
	// turret points to analog
	} else if (Controller == CONTROLLER.Gamepad) {
		
		var xaxis = gamepad_axis_value(Gamepad, gp_axisrh);
		var yaxis = gamepad_axis_value(Gamepad, gp_axisrv);
		
		var dir = point_direction(x, y, xaxis, yaxis);
		
		var tolerance = 0.35;
		
		if (abs(xaxis) > tolerance || abs(yaxis) > tolerance) {
			turretAngle = radtodeg(arctan2(xaxis, yaxis)) - 90;
		}
		
	}
	
	draw_3d(s, x, y+3, turretSprite, s, s, turretAngle - 90, c_white, 1, true, 100, 10);
	draw_3d(s, x, y, spaceshipSprite, s, s, direction - 90);
}


// Spaceship menu
enum SPACESHIP_MENU_PAGE {
	Home,
	Build,
	Inventory,
	Health,
	Settings,
}

menu = false;
menuPage = 0;
menuAlpha = 0;
menuModelTheta = irandom(360);
menuModelThetaForce = 0;
menuLastItem = -1;

menuSize = new dim(500, 600);

menuSettings = {
	sunProximityAlert: true,
}


menuDrawReturnButton = function(x, y, width) {
	button_gui(
		x, y, width / 1.5, 28, ts(9), 0,
		true, $FF181818, c_ltgray, 0.10, menuAlpha,
		function(){
			
			if (Keymap.select) {
				menuPage = SPACESHIP_MENU_PAGE.Home;
				GamepadMenuIndex = 0;
				inventoryButtonClick();
			}
					
			window_set_cursor(cr_handpoint);
					
		}, BUTTON_ORIGIN.MiddleCenter
	);
}


radarZoom = 1;

drawMenu = function() {
	var map = get_keymap();
	
	if (map.menu && !busy) {
		menu = !menu;
		GamepadMenuIndex = 0;
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
	
	if (Keymap.start) {
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
	rect(xx, yy, ww, hh, c0, false, menuAlpha);
	rect(xx, yy, ww, hh, c1, true, menuAlpha);
	
	draw_set_valign(fa_top);
	draw_set_halign(fa_center);
	
	// Draw title
	var titlePadding = 10;
	draw_text(xx, (yy - hh / 2) + titlePadding, ts(1));
	
	var top = (yy - hh / 2) + titlePadding * 2 + 14;
	
	
	switch (menuPage) {
		
		case SPACESHIP_MENU_PAGE.Home:
			
			gp_menu(0, 5);
			
			var modelScale = 3;
			var modelY = top + 70;
			var modelAngle = point_direction(xx, modelY, window_mouse_get_x(), window_mouse_get_y());
			
			menuModelTheta -= 0.08 + menuModelThetaForce;
			menuModelThetaForce = lerp(menuModelThetaForce, 0, 0.1);
			
			draw_3d(modelScale, xx, modelY + 3, turretSprite, modelScale, modelScale, modelAngle - 90, c_white, menuAlpha, true, 100, 10);
			draw_3d(modelScale, xx, modelY, sSpaceship, modelScale, modelScale, menuModelTheta-90, c_white, menuAlpha);
			
			button_gui(xx, modelY, 80, 80, "", -1, false, 0, 0, 0, menuAlpha, function(){
				if (Keymap.select) {
					menuModelThetaForce = random(20.0);
				}
			}, BUTTON_ORIGIN.MiddleCenter);
			
			var buttonY = modelY + 75;
			var buttonHeight = 28;
			var buttonSep = 28 * 1.25;
			
			button_gui(
				xx, buttonY, ww/1.5, buttonHeight, ts(2), 0,
				true, $FF181818, c_ltgray, 0.10, menuAlpha,
				function(){
					
					if (Keymap.select) {
						menuPage = SPACESHIP_MENU_PAGE.Build;
						GamepadMenuIndex = 0;
						
						inventoryButtonClick();
					}
					
					window_set_cursor(cr_handpoint);
					
				}, BUTTON_ORIGIN.MiddleCenter
			);
			
			button_gui(
				xx, buttonY + 1 * buttonSep, ww/1.5, buttonHeight, ts(3), 1,
				true, $FF181818, c_ltgray, 0.10, menuAlpha,
				function(){
					
					if (Keymap.select) {
						menuPage = SPACESHIP_MENU_PAGE.Inventory;
						GamepadMenuIndex = 0;
						
						inventoryButtonClick();
					}
					
					window_set_cursor(cr_handpoint);
					
				}, BUTTON_ORIGIN.MiddleCenter
			);
			
			button_gui(
				xx, buttonY + 2 * buttonSep, ww/1.5, buttonHeight, ts(4), 2,
				true, $FF181818, c_ltgray, 0.10, menuAlpha,
				function(){
					
					if (Keymap.select) {
						menuPage = SPACESHIP_MENU_PAGE.Health;
						GamepadMenuIndex = 0;
						
						inventoryButtonClick();
					}
					
					window_set_cursor(cr_handpoint);
					
				}, BUTTON_ORIGIN.MiddleCenter
			);
			
			button_gui(
				xx, buttonY + 3 * buttonSep, ww/1.5, buttonHeight, ts(5), 3,
				true, $FF181818, c_ltgray, 0.10, menuAlpha,
				function(){
					
					if (Keymap.select) {
						menuPage = SPACESHIP_MENU_PAGE.Settings;
						GamepadMenuIndex = 0;
						
						inventoryButtonClick();
					}
					
					window_set_cursor(cr_handpoint);
					
				}, BUTTON_ORIGIN.MiddleCenter
			);
			
			
			// Draw radar
			var radar = ItemData[? radarID];
			var radarSize = 1.25;
			var radarX = xx;
			var radarY = yy + menuSize.height / 4;
			var radarRadius = radar.components.radius / radarZoom;
			var radarSprite = radar.components.sprite;
			
			draw_sprite_ext(radarSprite, 0, radarX, radarY, radarSize, radarSize, 0, c_white, menuAlpha);
			
			// Draw dots
			for (var i = 0; i < array_length(radar.components.track); i++) {
				var track = radar.components.track[i];
				
				// Iterate through every object in the track array and draw them on the radar
				for (var j = 0; j < instance_number(track.obj); j++) {
					var inst = instance_find(track.obj, j);
					var distance = distance_to_object(inst);
					
					// hardcoded garbage. works tho
					if (distance < (15500) * (radarRadius / (200))) {
						var divider = sprite_get_width(radar.components.sprite) * radarSize;
						var pos = vec2(
							inst.x / radarRadius - x / radarRadius,
							inst.y / radarRadius - y / radarRadius
						);
						
						var color = track.color;
						
						draw_set_alpha(menuAlpha);
						
						draw_circle_color(
							radarX + pos.x, radarY + pos.y, 3 - (radarZoom / 2),
							color, color, false
						);	
					}	
				}
			}
			
			var radarButtonOffset = sprite_get_width(radarSprite) / 1.25;
			var radarButtonSize = 16;
			
			button_gui(
				radarX - radarButtonOffset, radarY, radarButtonSize, radarButtonSize, "<", 4, true, $181818, c_ltgray, 0.5, menuAlpha, function(){
					if (Keymap.selectHeld && radarZoom < 15) {
						radarZoom += 0.1;
					}
				}, BUTTON_ORIGIN.MiddleCenter
			);
			
			button_gui(
				radarX + radarButtonOffset, radarY, radarButtonSize, radarButtonSize, ">", 5, true, $181818, c_ltgray, 0.5, menuAlpha, function(){
					if (Keymap.selectHeld && radarZoom > 1) {
						radarZoom -= 0.1;
					}
				}, BUTTON_ORIGIN.MiddleCenter
			);
			
			draw_set_halign(fa_center);
			
			draw_text_color(radarX, radarY + 100, $"zoom: {radarZoom}x", c_white, c_white, c_white, c_white, menuAlpha);
			
			draw_circle_color(
				radarX, radarY, 2,
				c_white, c_white, false
			);
			
			draw_set_alpha(1);
			
			break;
		
		case SPACESHIP_MENU_PAGE.Build:
			
			menuDrawReturnButton(xx, top + 14, ww);
			
			
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
				buttonX, buttonY, buttonSize, buttonSize, "", 1,
				true, $FF181818, c_ltgray, 0.10, menuAlpha,
				function(){
					
					if (Keymap.select) {
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
			
			// Quantity of buttons
			gp_menu(0, array_length(inventory) + 1);
			
			menuDrawReturnButton(xx, top + 14, ww);
			
			
			// Draw every inventory slot
			selectedSlot = -1;
			var itemName = ts(10);			
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
					
					if (ItemData[? itemID].sprite == -1) itemSpr = sDefault;
					
					var sprScale = 1.5;
					draw_sprite_ext(itemSpr, -1, slotX, slotY, sprScale, sprScale, 0, c_white, menuAlpha);
				}
				
				if (selectedSlot != -1 && inventory[selectedSlot].itemID != -1) {
					itemName = ItemData[? inventory[selectedSlot].itemID].name;
				}
				
				button_gui(slotX, slotY, slotSize, slotSize, "", i + 1, true, $181818, c_ltgray, 0.1, menuAlpha, function(){
					
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
								
								if (inventory[selectedSlot].amount >= ITEM_MAX_STACK) return;
								
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
				var offset = vec2(20, -10);
				var shadowOffset = vec2(-1.5, 1.5);
				
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
		
		case SPACESHIP_MENU_PAGE.Health:
			
			// Quantity of buttons
			gp_menu(0, 0);
			
			menuDrawReturnButton(xx, top + 14, ww);
			
			var meterWidth = 18;
			var meterHeight = 200;
			
			var values = [
				{
					min: other.hp,
					max: other.maxHp,
					minColor: c_red,
					maxColor: c_green,
				},
				{
					min: other.fuel,
					max: other.maxFuel,
					minColor: c_red,
					maxColor: c_dkgray,
				},
			];
			
			draw_set_alpha(menuAlpha);
			
			for (var i = 0; i < array_length(values); i++) {
				var meter = (values[i].min / values[i].max) * 100;
				var meterX = (xx + (i-i/2) * (meterWidth * 2.5));
				
				draw_healthbar(meterX - meterWidth/2, yy - meterHeight/2, meterX + meterWidth/2, yy + meterHeight/2, meter, c_black, values[i].minColor, values[i].maxColor, 3, true, true);
			}
			
			draw_set_alpha(1);
			
			break;
		
		case SPACESHIP_MENU_PAGE.Settings:
			
			// Quantity of buttons
			gp_menu(0, 1);
			
			menuDrawReturnButton(xx, top + 14, ww);
			
			// Draw options
			
			var sttButtonHeight = 28;
			var sttButtonY = top + 18 + sttButtonHeight * 1.5;
			
			button_gui(xx, sttButtonY, menuSize.width / 1.5, sttButtonHeight, ts(8)+": "+str_bool(menuSettings.sunProximityAlert), 1, true, $181818, c_ltgray, 0.25, menuAlpha, function(){
				if (Keymap.select) {
					menuSettings.sunProximityAlert = !menuSettings.sunProximityAlert;
					
					inventoryButtonClick();
				}
				
				window_set_cursor(cr_handpoint);
			}, BUTTON_ORIGIN.MiddleCenter);
			
			break;
		
	}
	
	draw_set_alpha(1);
}



// Doodles
// shows important stuff on the hud

doodles = [
	{
		description: "Careful, you're flying too close to the sun!",
		sprite: sDanger,
		fn: function() {
			return Spaceship.inSunRadius;
		}
	},
	{
		description: "Low health!",
		sprite: sDanger,
		fn: function() {
			return (Spaceship.hp < 500);
		}
	},
];

selectedDoodle = 0;
doodleButtonSize = 32;
doodleButtonPadding = 1.9;

drawDoodles = function() {
	
	for (var i = 0; i < array_length(doodles); i++) {
		var windowOffset = 32;
		var xx = (window_get_width() - windowOffset) - i * (doodleButtonSize * doodleButtonPadding);
		var yy = window_get_height() - windowOffset;
		var size = doodleButtonSize;
		
		selectedDoodle = doodles[i];
		
		if (selectedDoodle.fn()) {
			button_gui(xx, yy, size, size, "", -1, false, 0, 0, 0, 1, function(){
				
				draw_set_halign(fa_right);
				draw_set_valign(fa_bottom);
				
				draw_text_ext(W_MOUSE.x, W_MOUSE.y - 20, selectedDoodle.description, 14, 200);
				
				draw_set_halign(fa_center);
				draw_set_valign(fa_middle);
				
			}, BUTTON_ORIGIN.MiddleCenter);
		
			draw_sprite(selectedDoodle.sprite, 0, xx, yy);
		}
	}
	
}

