$input v_color0, v_texcoord0
#include "common.sh"

SAMPLER2D(s_color,  0);

void main()
{
	vec4 color = texture2D(s_color, v_texcoord0);
	gl_FragColor = vec4(color.xyz, 1);
}