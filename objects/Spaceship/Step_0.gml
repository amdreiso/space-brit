
// Check if player is USABLE
busy = (Paused);


// Movement
handleMovement();


// Attack
handleAttack();


// Audio
audio_listener_position(x, y, 0);


if (keyboard_check(ord("F"))) {
	inventoryAdd(choose(ITEM.Coal, ITEM.RawIron, ITEM.Iron));
}

