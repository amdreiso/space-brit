// THIS WAS MADE WITH CHAT GPT BECAUSE I WAS BORED AND DIDNT WANT TO WRITE IT MYSELF
// THIS IS JUST FOR DEBUG PURPOSES I DO NOT FUCKING CARE!!!!!!!
function print_ds_map(map) {
    var keys = ds_map_keys_to_array(map);
    for (var i = 0; i < array_length(keys); i++) {
        var key = keys[i];
        var value = map[? key];
        show_debug_message("Key: " + string(key) + ", Value: " + string(value));
    }
}