shader_type canvas_item;

uniform vec4 primary_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform vec4 secondary_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform vec4 tertiary_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform vec4 shade_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform vec4 outline_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);

void vertex() {
    // Vertex processing
}

void fragment() {
    vec4 color = texture(TEXTURE, UV);
	
	if (color.a > 0.0) {
		if (color.rgb == vec3(1.0,0.0,0.0)) {
			COLOR = primary_color;
		}
		else if (color.rgb == vec3(0.0,1.0,0.0)) {
			COLOR = secondary_color;
		}
		else if (color.rgb == vec3(0.0,0.0,1.0)) {
			COLOR = tertiary_color;
		}
		else if (color.rgb == vec3(1.0,1.0,1.0)) {
			COLOR = shade_color;
		}
		else if (color.rgb == vec3(0.0,0.0,0.0)){
			COLOR = outline_color;
		}
	} 
}