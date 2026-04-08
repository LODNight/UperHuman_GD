/// @description: Kiểm tra player có trong tầm hay ko
function enemy_check_vision() {
    if (!instance_exists(obj_player)) return false;

    var _dist = point_distance(x, y, obj_player.x, obj_player.y);
    var _dir = point_direction(x, y, obj_player.x, obj_player.y);

    var _view_distance = 400;
    var _fov = 90;

    var _angle_diff = abs(angle_difference(direction, _dir));

    // Trong tầm + trong góc
    if (_dist <= _view_distance && _angle_diff <= (_fov / 2)) {

        // Check bị tường che không
        if (!check_los_tilemap(x, y, obj_player.x, obj_player.y)) {
            return true;
        }
    }

    return false;
}

/// @description: Kiểm tra có trong tầm nhìn của Player hay ko, nếu có => Ko spawn
function can_player_see(_x, _y) {
    if (!instance_exists(obj_player)) return false;

    var _dist = point_distance(obj_player.x, obj_player.y, _x, _y);
    if (_dist > 400) return false;

    if (!check_los_tilemap(obj_player.x, obj_player.y, _x, _y)) {
        return true;
    }

    return false;
}