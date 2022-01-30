$input v_color0, v_texcoord0
#include "common.sh"

SAMPLER2D(s_color,  0);

vec4 unpack_color(float f_color)
{
	uint i_color = floatBitsToUint(f_color);
	uint a = i_color / 16777216;
	uint b = (i_color - (16777216 * a)) / 65536;
	uint g = (i_color - (16777216 * a) - (65536 * b)) / 256;
	uint r = (i_color - (16777216 * a) - (65536 * b) - (256 * g));
	vec4 color = vec4(r, g, b, a);
	return color / 256.0;
}

void main()
{
	vec4 color = texture2D(s_color, v_texcoord0);
	vec4 tint_alpha = unpack_color(v_color0.x);
	vec3 tint = tint_alpha.xyz;
	float alpha = tint_alpha.w;
	gl_FragColor = color * vec4(tint, 1.0) * alpha;
}