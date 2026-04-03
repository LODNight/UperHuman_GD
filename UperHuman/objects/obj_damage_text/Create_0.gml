damage = 0;       // Giá trị máu bị trừ (sẽ được truyền vào sau)
alpha = 1;        // Độ mờ của chữ (1 là rõ nhất, 0 là tàng hình)
vspeed = -0.7;      // Tốc độ bay lên (số âm để đi ngược lên trên)
y -= 20;          // Dịch vị trí lên một chút để xuất hiện trên đầu enemy

// Độ lệch khi rớt
x += random_range(-10, 10);
