$input v_texcoord0
#include "common.sh"

SAMPLER2D(s_tex0,  0);

void main()
{
	gl_FragColor = texture2D(s_tex0, v_texcoord0);
}
