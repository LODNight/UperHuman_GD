function enemy_check_vision() {
    if (!instance_exists(obj_player)) return false;

    var _dist = point_distance(x, y, obj_player.x, obj_player.y);
    var _dir = point_direction(x, y, obj_player.x, obj_player.y);

    var _view_distance = 300;
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