#version 460 core

in vec2 tex;
in float clip;

out vec4 color;

uniform sampler2D ture;

void main()
{
	if (clip < 0) discard;
	
	color = texture(ture, tex);
}
