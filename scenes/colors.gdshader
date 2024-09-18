shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

uniform vec4 c1 = vec4(0, 0, 0, 1);
uniform vec4 c2 = vec4(0.25, 0.25, 0.25, 1);
uniform vec4 c3 = vec4(0.66, 0.66, 0.66, 1);
uniform vec4 c4 = vec4(1, 1, 1, 1);

void fragment() {
	vec4 c = textureLod(screen_texture, SCREEN_UV, 0.0);

	if (c.r > 0.7) {
		COLOR = c4;
	} else if (c.r > 0.5) {
		COLOR = c3;
	} else if (c.r > 0.3) {
		COLOR = c2;
	} else {
		COLOR = c1;
	}
}