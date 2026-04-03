draw_set_alpha(alpha);
draw_set_font(fnd_text_small)
draw_set_color(c_white);

	draw_set_halign(fa_center);       // Căn giữa chữ theo chiều ngang
	draw_set_valign(fa_middle);       // Căn giữa chữ theo chiều dọc


draw_text(x, y, "-" +string(damage));
draw_set_alpha(1);
draw_set_font(-1)