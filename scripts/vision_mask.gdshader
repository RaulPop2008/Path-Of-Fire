shader_type canvas_item;

uniform vec2 player_screen_pos = vec2(0.5, 0.5);

uniform float radius : hint_range(0.0, 1.0) = 0.15;

// Cât de moale e marginea cercului (0 = tăiere dură, 0.1 = tranziție lină)
uniform float edge_softness : hint_range(0.0, 0.3) = 0.05;

// Aspect ratio-ul ecranului, ca cercul să nu fie oval
uniform float aspect_ratio = 1.7777; // 16:9, schimbă dacă ai alt raport

void fragment() {
	vec2 uv = UV;
	uv.x *= aspect_ratio;

	vec2 center = player_screen_pos;
	center.x *= aspect_ratio;

	float dist = distance(uv, center);

	// 0.0 = complet vizibil (în cerc), 1.0 = complet negru
	float darkness = smoothstep(radius - edge_softness, radius, dist);

	COLOR = vec4(0.0, 0.0, 0.0, darkness);
}
