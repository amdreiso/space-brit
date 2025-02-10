
if (room != rmOuterSpace) return;


// Check if spaceship is USABLE
busy = (Paused || Console || dead);


// Health
if (hitCooldown > 0) hitCooldown -= GameSpeed;


// Movement
handleMovement();


// Attack
handleAttack();


// Audio
audio_listener_position(x, y, 0);


if (keyboard_check(ord("F"))) {
	inventoryAdd(irandom(ITEM.Count - 1));
}


// Camera
camera_set_target(Spaceship, true);


