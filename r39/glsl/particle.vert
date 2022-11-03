#version 460 core

layout(location = 0) in vec3 position;
layout(location = 1) in vec2 texcoord;
layout(location = 2) in vec4 colour;

out vec2 tex;
out vec4 clr;

uniform mat4 world;
uniform mat4 view;
uniform mat4 projection;

void main()
{
	gl_Position = world*vec4(position, 1.0f);
	gl_Position = view*gl_Position;
	gl_Position = projection*gl_Position;
	
	tex = texcoord;
	clr = colour;
}