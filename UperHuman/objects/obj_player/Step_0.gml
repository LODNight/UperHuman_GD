player_switch_weapon()

player_movement();
player_shoot();

if (keyboard_check_pressed(ord("E"))) {
    scr_inventory_add("wood", 1);
}

if (keyboard_check_pressed(ord("Q"))) {
    scr_inventory_remove("wood", 1);
}