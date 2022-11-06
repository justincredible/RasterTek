#version 460 core

layout(location = 0) in vec3 position;
layout(location = 1) in vec2 texcoord;

out vec2 tex;
out vec4 depthpos;

uniform mat4 world;
uniform mat4 view;
uniform mat4 projection;

void main()
{
	gl_Position = projection*view*world*vec4(position, 1.0f);
	
	tex = texcoord;
	
	depthpos = gl_Position;
}