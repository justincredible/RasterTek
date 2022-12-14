#version 460 core

layout(location=0)in vec3 position;
layout(location=1)in vec3 colorv;

out vec3 colorp;

uniform mat4 world;
uniform mat4 view;
uniform mat4 projection;

void main()
{
	gl_Position = projection*view*world*vec4(position,1);
	
	colorp = colorv;
}
