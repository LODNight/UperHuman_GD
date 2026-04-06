
function src_inventory_init(){
	global.inventory = array_create(20); // 20 slot

	for (var i = 0; i < array_length(global.inventory); i++) {
	    global.inventory[i] = -1; // slot trống
	}
}

function scr_inventory_add(_id, _amount) {

    // 1. Stack nếu đã có
    for (var i = 0; i < array_length(global.inventory); i++) {
        var slot = global.inventory[i];

        if (is_struct(slot) && slot.id == _id) {
            slot.stack += _amount;
            return true;
        }
    }

    // 2. Tìm slot trống
    for (var i = 0; i < array_length(global.inventory); i++) {
        if (global.inventory[i] == -1) {
            global.inventory[i] = {
                id: _id,
                stack: _amount
            };
            return true;
        }
    }

    return false; // full inventory
}

function scr_inventory_remove(_id, _amount) {
    for (var i = 0; i < array_length(global.inventory); i++) {
        var slot = global.inventory[i];

        if (is_struct(slot) && slot.id == _id) {
            slot.stack -= _amount;

            if (slot.stack <= 0) {
                global.inventory[i] = -1;
            }

            return true;
        }
    }

    return false;
}