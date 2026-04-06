var cols = 5;
var size = 64;


for (var i = 0; i < array_length(global.inventory); i++) {

    var x_pos = 50 + (i mod cols) * size;
    var y_pos = 50 + floor(i / cols) * size;

    // Vẽ ô
    draw_rectangle(x_pos, y_pos, x_pos + size, y_pos + size, false);

    var slot = global.inventory[i];

    if (is_struct(slot)) {

        if (variable_struct_exists(global.item_db, slot.id)) {
		    var item = global.item_db[$ slot.id];

		    draw_sprite(item.sprite, 0, x_pos + size/2, y_pos + size/2);
		}

        draw_sprite_ext(
		    item.sprite,
		    0,
		    x_pos + size/2,
		    y_pos + size/2,
		    0.8, 0.8,
		    0,
		    c_white,
		    1
		);

        draw_text(x_pos + 5, y_pos + 40, string(slot.stack));
    }
}