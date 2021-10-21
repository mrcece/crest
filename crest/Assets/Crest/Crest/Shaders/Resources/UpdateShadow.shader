// Crest Ocean System

// This file is subject to the MIT License as seen in the root of this folder structure (LICENSE)

Shader "Hidden/Crest/Simulation/Update Shadow"
{
	SubShader
	{
		Pass
		{
			HLSLPROGRAM
			#pragma vertex Vert
			#pragma fragment Frag

			#pragma multi_compile_shadowcollector

			// #pragma enable_d3d11_debug_symbols

			#define CREST_SAMPLE_SHADOW_HARD

			#include "UnityCG.cginc"

			#include "../Helpers/BIRP/ScreenSpaceShadows.hlsl"
			#include "../ShaderLibrary/UpdateShadow.hlsl"

			half CrestSampleShadows(const float4 i_positionWS)
			{
				float4 shadowCoord = GET_SHADOW_COORDINATES(i_positionWS);
				half shadows = UNITY_SAMPLE_SHADOW(_ShadowMapTexture, shadowCoord);
				shadows = lerp(_LightShadowData.r, 1.0, shadows);
				return shadows;
			}

			Varyings Vert(Attributes input)
			{
				Varyings output;

				output.positionCS = UnityObjectToClipPos(input.positionOS);

				// World position from [0,1] quad.
				output.positionWS.xyz = float3(input.positionOS.x - 0.5, 0.0, input.positionOS.y - 0.5) * _Scale * 4.0 + _CenterPos;
				output.positionWS.y = _OceanCenterPosWorld.y;

				return output;
			}

			ENDHLSL
		}
	}
}
