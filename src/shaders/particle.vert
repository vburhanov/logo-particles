precision highp float;

attribute float pindex;
attribute vec3 position;
attribute vec3 offset;
attribute vec2 uv;
attribute float angle;

uniform mat4 modelViewMatrix;
uniform mat4 projectionMatrix;

uniform float uTime;
uniform float uRandom;
uniform float uDepth;
uniform float uSize;
uniform vec2 uTextureSize;
uniform sampler2D uTexture;
uniform sampler2D uTouch;

varying vec2 vPUv;
varying vec2 vUv;

#pragma glslify: snoise2 = require(glsl-noise/simplex/2d)

float random(float n) {
	return fract(sin(n) * 43758.5453123);
}

void main() {
	vUv = uv;

	// particle uv
	vec2 puv = offset.xy / uTextureSize;
	vPUv = puv;

	// pixel color
	vec4 colC = texture2D(uTexture, puv);
	vec4 colA = vec4(0.0, 0.37, 0.92, 1.0);
	float grey = colA.r  + colA.g  + colA.b;

	// displacement
	vec3 displaced = offset;
	// randomise
	displaced.xy += vec2(random(pindex) - 2.0, random(offset.x + pindex) - 0.8) * uRandom;
	float rndz = (random(pindex) + snoise_1_2(vec2(pindex * 1.8, uTime * 0.5)));
	displaced.z += rndz * (random(pindex) * 0.8 * uDepth);
	// center
	displaced.xy -= uTextureSize * 0.5;

	// touch
	float t = texture2D(uTouch, puv).r;
	displaced.z += t * 100.0 * rndz;
	displaced.x += cos(angle) * t * 50.0 * rndz;
	displaced.y += sin(angle) * t * 80.0 * rndz;

	// particle size
	float psize = (snoise_1_2(vec2(uTime, 0.7) * 0.2) + 1.3);
	// psize *= max(colC,0.2);
	psize *= uSize;

	// final position
	vec4 mvPosition = modelViewMatrix * vec4(displaced, 1.0);
	mvPosition.xyz += position * psize;
	vec4 finalPosition = projectionMatrix * mvPosition;

	gl_Position = finalPosition;
}
