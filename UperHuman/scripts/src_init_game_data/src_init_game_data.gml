/// @function init_weapon_database():
/// @description Khởi tạo dữ liệu toàn cục cho game (Chỉ gọi 1 lần duy nhất)
function init_weapon_database() {
    global.weapons = [
        {}, // [0] Bỏ trống
        
        {   // [1] Súng lục
            name: "Pistol",
            rate: 35, 
            obj: obj_ammo_1, 
            spd: 12,
            damage: 10,
            sound: snd_pistol
        },
        
        {   // [2] Súng máy
            name: "SMG",
            rate: 5, 
            obj: obj_ammo_1, 
            spd: 15,
            damage: 5,
            sound: snd_smg
        }
        // Kéo dài bao nhiêu cũng được, code rất dễ nhìn
    ];
}