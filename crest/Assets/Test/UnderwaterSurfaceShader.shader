Shader "Custom/UnderwaterSurfaceShader"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
    }
    SubShader
    {
        Tags { "Queue" = "Transparent" "RenderType"="Transparent" }
        LOD 200

        CGPROGRAM
        // NOTE: Consider adding nofog if object is always underwater.
        #pragma surface surf Standard fullforwardshadows alpha:fade
        #pragma target 3.0
        #pragma require 2darray

        #pragma multi_compile __ CREST_SUBSURFACESCATTERING_ON
        #pragma multi_compile __ CREST_SHADOWS_ON

        #include "UnityCG.cginc"

        #include "/Assets/Crest/Crest/Shaders/Underwater/UnderwaterEffectIncludes.hlsl"

        struct Input
        {
            float4 vertex: SV_POSITION;
            float3 worldPos;
            float4 positionCS;
            float4 screenPos;
        };

        half _Glossiness;
        half _Metallic;
        fixed4 _Color;

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 color = _Color;
            float2 screenUV = IN.screenPos.xy / IN.screenPos.w;
            if (IsUnderwater(screenUV))
            {
                color.rgb = ApplyUnderwaterFog(color.rgb, IN.vertex, IN.worldPos);
            }
            o.Albedo = color.rgb;
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = color.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
