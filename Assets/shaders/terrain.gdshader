shader_type spatial;

// Height range uniforms
uniform float min_height : hint_range(-1, 1) = 0.0;
uniform float max_height : hint_range(-1, 1) = 1;

// Color uniforms for different height zones
uniform vec4 low_color : source_color = vec4(0.1, 0.3, 0.1, 1.0);      // Deep valleys - dark green
uniform vec4 mid_low_color : source_color = vec4(0.3, 0.6, 0.2, 1.0);  // Grass areas - green
uniform vec4 mid_high_color : source_color = vec4(0.5, 0.4, 0.3, 1.0); // Rocky areas - brown
uniform vec4 high_color : source_color = vec4(0.9, 0.9, 1.0, 1.0);     // Snow peaks - white

// Height thresholds (0.0 to 1.0 range)
uniform float threshold_1 : hint_range(0.0, 1.0) = 0.25;  // Low to mid-low
uniform float threshold_2 : hint_range(0.0, 1.0) = 0.5;   // Mid-low to mid-high
uniform float threshold_3 : hint_range(0.0, 1.0) = 0.75;  // Mid-high to high

// Transition smoothness
uniform float blend_sharpness : hint_range(0.01, 0.5) = 0.1;

// Optional: slope-based coloring
//uniform bool use_slope_coloring : hint_defa = false;
uniform vec4 steep_slope_color : source_color = vec4(0.4, 0.35, 0.3, 1.0);
uniform float slope_threshold : hint_range(0.0, 1.0) = 0.7;

// Optional: add some color variation
uniform float color_variation_strength : hint_range(0.0, 1.0) = 0.1;
uniform float variation_scale : hint_range(0.1, 10.0) = 2.0;

varying vec3 world_pos;

// Simple noise for color variation
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    f = f * f * (3.0 - 2.0 * f);

    return mix(
        mix(hash(i + vec2(0.0, 0.0)), hash(i + vec2(1.0, 0.0)), f.x),
        mix(hash(i + vec2(0.0, 1.0)), hash(i + vec2(1.0, 1.0)), f.x),
        f.y
    );
}

void vertex() {
    world_pos = VERTEX;
}

void fragment() {
    // Get the world Y position (height) of the current fragment
    float current_height = world_pos.y;

    // Normalize height to 0.0-1.0 range based on min/max height uniforms
    float normalized_height = clamp((current_height - min_height) / (max_height - min_height), 0.0, 1.0);

    vec4 final_color;

    // Blend colors based on height thresholds
    if (normalized_height < threshold_1) {
        // Below first threshold - use low color
        final_color = low_color;
    } else if (normalized_height < threshold_2) {
        // Between threshold 1 and 2 - blend low and mid-low
        float t = smoothstep(threshold_1 - blend_sharpness, threshold_1 + blend_sharpness, normalized_height);
        final_color = mix(low_color, mid_low_color, t);
    } else if (normalized_height < threshold_3) {
        // Between threshold 2 and 3 - blend mid-low and mid-high
        float t = smoothstep(threshold_2 - blend_sharpness, threshold_2 + blend_sharpness, normalized_height);
        final_color = mix(mid_low_color, mid_high_color, t);
    } else {
        // Above threshold 3 - blend mid-high and high
        float t = smoothstep(threshold_3 - blend_sharpness, threshold_3 + blend_sharpness, normalized_height);
        final_color = mix(mid_high_color, high_color, t);
    }

    //// Optional: Add slope-based coloring
    //if (use_slope_coloring) {
        //float slope = 1.0 - dot(NORMAL, vec3(0.0, 1.0, 0.0));
        //if (slope > slope_threshold) {
            //float slope_factor = (slope - slope_threshold) / (1.0 - slope_threshold);
            //final_color = mix(final_color, steep_slope_color, slope_factor * 0.6);
        //}
    //}

    // Optional: Add subtle color variation
    if (color_variation_strength > 0.0) {
        float variation = (noise(world_pos.xz * variation_scale) - 0.5) * 2.0;
        final_color.rgb += variation * color_variation_strength * 0.2;
    }

    ALBEDO = final_color.rgb;
    ROUGHNESS = 0.8;
    METALLIC = 0.0;
}