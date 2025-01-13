function draw_tip(str, color, color2, alpha){
	
	draw_set_font(fnt_mainTIP);
	
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	
	var xx = display_get_gui_width() / 2;
	var yy = display_get_gui_height() / 1.25;
	var offset = 1.5;
	
	draw_text_transformed_color(xx+offset, yy, str, 1, 1, 0, c_black, c_black, c_black, c_black, alpha);
	draw_text_transformed_color(xx, yy+offset, str, 1, 1, 0, c_black, c_black, c_black, c_black, alpha);
	draw_text_transformed_color(xx+offset, yy+offset, str, 1, 1, 0, c_black, c_black, c_black, c_black, alpha);
	
	draw_text_transformed_color(xx, yy, str, 1, 1, 0, color2, color2, color, color, alpha);
	
	draw_set_font(fnt_main);
	
}