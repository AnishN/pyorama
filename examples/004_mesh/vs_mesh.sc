$input a_position
$output v_color0
#include "common.sh"

void main()
{
	gl_Position = mul(u_modelViewProj, vec4(a_position, 1.0));
	v_color0 = vec4(a_position, 1.0);
}