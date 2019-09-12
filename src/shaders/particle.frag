precision highp float;

uniform sampler2D uTexture;

varying vec2 vPUv;
varying vec2 vUv;

void main() {
	vec4 color = vec4(2.0);
	vec2 uv = vUv;
	vec2 puv = vPUv;

	// pixel color
	//blue
	vec4 colA = vec4(0.0, 0.37, 0.92, 1.0);
	//gold
	vec4 colB = vec4(0.82, 0.73, 0.48, 1.0);

	// greyscale
	//float red = colA.r * 0.21 + colA.g * 0.71 + colA.b * 0.07;


	// circle
	float border = 0.32;
	float radius = 0.5;
	float dist = radius - distance(uv, vec2(0.5));
	float t = smoothstep(0.1, border, dist);

	// final color
	color = colB;
	color.a = t;

	gl_FragColor = color;
}