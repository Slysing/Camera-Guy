// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Matt/ToonTear_Face"
{
	Properties
	{
		_TimeScale("TimeScale", Float) = 0.2
		_VoidMask("VoidMask", 2D) = "white" {}
		_ToonRamp("Toon Ramp", 2D) = "white" {}
		_Specularramp("Specular ramp", 2D) = "white" {}
		_ShadowOffset("Shadow Offset", Float) = 0
		[HDR]_RimColor("Rim Color", Color) = (0,1,0.8758622,0)
		_NormalMap("Normal Map", 2D) = "bump" {}
		_RimPower("Rim Power", Range( 0 , 10)) = 0.47
		_Albedo("Albedo", 2D) = "white" {}
		_RimOffset("Rim Offset", Range( 0 , 1)) = 0.63
		[HDR]_AlbedoTint("Albedo Tint", Color) = (1,1,1,1)
		_SpecIntensity("Spec Intensity", Range( 0 , 1)) = 0.5352941
		_AntiSpecMap("Anti-Spec Map", 2D) = "white" {}
		_Gloss("Gloss", Range( 0 , 1)) = 0.33
		_SpecularityColor("Specularity Color", Color) = (1,1,1,0)
		_Emission("Emission", 2D) = "white" {}
		_Emission_Max("Emission_Max ", Float) = 10
		_Emission_Min("Emission_Min", Float) = 0.1
		_EmojiFace("EmojiFace", 2D) = "white" {}
		_EmissionScale("Emission Scale", Range( 0 , 2)) = 1
		_EmissionFaceScale("Emission Face Scale", Range( 0 , 2)) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float2 uv_texcoord;
			float3 worldNormal;
			INTERNAL_DATA
			float3 worldPos;
		};

		struct SurfaceOutputCustomLightingCustom
		{
			half3 Albedo;
			half3 Normal;
			half3 Emission;
			half Metallic;
			half Smoothness;
			half Occlusion;
			half Alpha;
			Input SurfInput;
			UnityGIInput GIData;
		};

		uniform float _TimeScale;
		uniform sampler2D _VoidMask;
		uniform float4 _VoidMask_ST;
		uniform float4 _AlbedoTint;
		uniform sampler2D _EmojiFace;
		uniform float4 _EmojiFace_ST;
		uniform sampler2D _Albedo;
		uniform float4 _Albedo_ST;
		uniform float _EmissionScale;
		uniform float _EmissionFaceScale;
		uniform sampler2D _ToonRamp;
		uniform sampler2D _NormalMap;
		uniform float4 _NormalMap_ST;
		uniform float _ShadowOffset;
		uniform float _RimOffset;
		uniform float _RimPower;
		uniform float4 _RimColor;
		uniform sampler2D _Emission;
		uniform float4 _Emission_ST;
		uniform float _Emission_Min;
		uniform float _Emission_Max;
		uniform sampler2D _Specularramp;
		uniform float _Gloss;
		uniform sampler2D _AntiSpecMap;
		uniform float4 _AntiSpecMap_ST;
		uniform float4 _SpecularityColor;
		uniform float _SpecIntensity;


		struct Gradient
		{
			int type;
			int colorsLength;
			int alphasLength;
			float4 colors[8];
			float2 alphas[8];
		};


		Gradient NewGradient(int type, int colorsLength, int alphasLength, 
		float4 colors0, float4 colors1, float4 colors2, float4 colors3, float4 colors4, float4 colors5, float4 colors6, float4 colors7,
		float2 alphas0, float2 alphas1, float2 alphas2, float2 alphas3, float2 alphas4, float2 alphas5, float2 alphas6, float2 alphas7)
		{
			Gradient g;
			g.type = type;
			g.colorsLength = colorsLength;
			g.alphasLength = alphasLength;
			g.colors[ 0 ] = colors0;
			g.colors[ 1 ] = colors1;
			g.colors[ 2 ] = colors2;
			g.colors[ 3 ] = colors3;
			g.colors[ 4 ] = colors4;
			g.colors[ 5 ] = colors5;
			g.colors[ 6 ] = colors6;
			g.colors[ 7 ] = colors7;
			g.alphas[ 0 ] = alphas0;
			g.alphas[ 1 ] = alphas1;
			g.alphas[ 2 ] = alphas2;
			g.alphas[ 3 ] = alphas3;
			g.alphas[ 4 ] = alphas4;
			g.alphas[ 5 ] = alphas5;
			g.alphas[ 6 ] = alphas6;
			g.alphas[ 7 ] = alphas7;
			return g;
		}


		float4 SampleGradient( Gradient gradient, float time )
		{
			float3 color = gradient.colors[0].rgb;
			UNITY_UNROLL
			for (int c = 1; c < 8; c++)
			{
			float colorPos = saturate((time - gradient.colors[c-1].w) / (gradient.colors[c].w - gradient.colors[c-1].w)) * step(c, (float)gradient.colorsLength-1);
			color = lerp(color, gradient.colors[c].rgb, lerp(colorPos, step(0.01, colorPos), gradient.type));
			}
			#ifndef UNITY_COLORSPACE_GAMMA
			color = half3(GammaToLinearSpaceExact(color.r), GammaToLinearSpaceExact(color.g), GammaToLinearSpaceExact(color.b));
			#endif
			float alpha = gradient.alphas[0].x;
			UNITY_UNROLL
			for (int a = 1; a < 8; a++)
			{
			float alphaPos = saturate((time - gradient.alphas[a-1].y) / (gradient.alphas[a].y - gradient.alphas[a-1].y)) * step(a, (float)gradient.alphasLength-1);
			alpha = lerp(alpha, gradient.alphas[a].x, lerp(alphaPos, step(0.01, alphaPos), gradient.type));
			}
			return float4(color, alpha);
		}


		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			#ifdef UNITY_PASS_FORWARDBASE
			float ase_lightAtten = data.atten;
			if( _LightColor0.a == 0)
			ase_lightAtten = 0;
			#else
			float3 ase_lightAttenRGB = gi.light.color / ( ( _LightColor0.rgb ) + 0.000001 );
			float ase_lightAtten = max( max( ase_lightAttenRGB.r, ase_lightAttenRGB.g ), ase_lightAttenRGB.b );
			#endif
			#if defined(HANDLE_SHADOWS_BLENDING_IN_GI)
			half bakedAtten = UnitySampleBakedOcclusion(data.lightmapUV.xy, data.worldPos);
			float zDist = dot(_WorldSpaceCameraPos - data.worldPos, UNITY_MATRIX_V[2].xyz);
			float fadeDist = UnityComputeShadowFadeDistance(data.worldPos, zDist);
			ase_lightAtten = UnityMixRealtimeAndBakedShadows(data.atten, bakedAtten, UnityComputeShadowFade(fadeDist));
			#endif
			Gradient gradient231 = NewGradient( 0, 4, 2, float4( 0.8666667, 0.7375554, 0.2886, 0 ), float4( 0.309738, 0.858, 0.8237337, 0.3300069 ), float4( 0.879, 0.610905, 0.8481572, 0.6599985 ), float4( 0.8666667, 0.7372549, 0.2901961, 1 ), 0, 0, 0, 0, float2( 1, 0 ), float2( 1, 1 ), 0, 0, 0, 0, 0, 0 );
			float mulTime228 = _Time.y * _TimeScale;
			float4 VoidColor174 = SampleGradient( gradient231, ( mulTime228 % 1.0 ) );
			float2 uv_VoidMask = i.uv_texcoord * _VoidMask_ST.xy + _VoidMask_ST.zw;
			float4 tex2DNode176 = tex2D( _VoidMask, uv_VoidMask );
			float4 temp_output_182_0 = ( VoidColor174 * tex2DNode176 );
			float2 uv_EmojiFace = i.uv_texcoord * _EmojiFace_ST.xy + _EmojiFace_ST.zw;
			float4 tex2DNode233 = tex2D( _EmojiFace, uv_EmojiFace );
			float grayscale238 = Luminance(tex2DNode233.rgb);
			float smoothstepResult234 = smoothstep( 0.0 , 0.01 , grayscale238);
			float4 temp_output_243_0 = ( tex2DNode233 * smoothstepResult234 );
			float2 uv_Albedo = i.uv_texcoord * _Albedo_ST.xy + _Albedo_ST.zw;
			float4 temp_output_240_0 = ( ( 1.0 - smoothstepResult234 ) * tex2D( _Albedo, uv_Albedo ) );
			float4 Albedo31 = ( _AlbedoTint * ( temp_output_243_0 + temp_output_240_0 ) );
			float4 VoidAdded184 = ( temp_output_182_0 + ( ( 1.0 - tex2DNode176 ) * Albedo31 ) );
			float2 uv_NormalMap = i.uv_texcoord * _NormalMap_ST.xy + _NormalMap_ST.zw;
			float3 Normal23 = UnpackNormal( tex2D( _NormalMap, uv_NormalMap ) );
			float3 ase_worldPos = i.worldPos;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float dotResult3 = dot( (WorldNormalVector( i , Normal23 )) , ase_worldlightDir );
			float normal_lightdir9 = dotResult3;
			float2 temp_cast_4 = (saturate( (normal_lightdir9*_ShadowOffset + _ShadowOffset) )).xx;
			float4 Shadow17 = ( VoidAdded184 * tex2D( _ToonRamp, temp_cast_4 ) );
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			UnityGI gi41 = gi;
			float3 diffNorm41 = WorldNormalVector( i , Normal23 );
			gi41 = UnityGI_Base( data, 1, diffNorm41 );
			float3 indirectDiffuse41 = gi41.indirect.diffuse + diffNorm41 * 0.0001;
			float4 Lighting39 = ( Shadow17 * ( ase_lightColor * float4( ( indirectDiffuse41 + ase_lightAtten ) , 0.0 ) ) );
			float temp_output_55_0 = ( ase_lightAtten * normal_lightdir9 );
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float dotResult7 = dot( (WorldNormalVector( i , Normal23 )) , ase_worldViewDir );
			float normal_viewdir10 = dotResult7;
			float2 uv_Emission = i.uv_texcoord * _Emission_ST.xy + _Emission_ST.zw;
			float QuestionableShadows220 = temp_output_55_0;
			float dotResult71 = dot( ( ase_worldViewDir + _WorldSpaceLightPos0.xyz ) , (WorldNormalVector( i , Normal23 )) );
			float smoothstepResult74 = smoothstep( 1.07 , 1.79 , pow( dotResult71 , _Gloss ));
			float2 temp_cast_6 = (smoothstepResult74).xx;
			float2 uv_AntiSpecMap = i.uv_texcoord * _AntiSpecMap_ST.xy + _AntiSpecMap_ST.zw;
			float4 Spec81 = ( ase_lightAtten * ( ( tex2D( _Specularramp, temp_cast_6 ) * ( ( 1.0 - tex2D( _AntiSpecMap, uv_AntiSpecMap ) ) * _SpecularityColor ) ) * _SpecIntensity ) );
			c.rgb = ( ( Lighting39 + ( saturate( ( temp_output_55_0 * pow( ( 1.0 - saturate( ( normal_viewdir10 + _RimOffset ) ) ) , _RimPower ) ) ) * ( _RimColor * ase_lightColor ) ) + ( ( tex2D( _Emission, uv_Emission ) + float4( 0,0,0,0 ) ) * (_Emission_Min + (saturate( QuestionableShadows220 ) - 0.0) * (_Emission_Max - _Emission_Min) / (0.1 - 0.0)) ) ) + Spec81 ).rgb;
			c.a = 1;
			return c;
		}

		inline void LightingStandardCustomLighting_GI( inout SurfaceOutputCustomLightingCustom s, UnityGIInput data, inout UnityGI gi )
		{
			s.GIData = data;
		}

		void surf( Input i , inout SurfaceOutputCustomLightingCustom o )
		{
			o.SurfInput = i;
			o.Normal = float3(0,0,1);
			Gradient gradient231 = NewGradient( 0, 4, 2, float4( 0.8666667, 0.7375554, 0.2886, 0 ), float4( 0.309738, 0.858, 0.8237337, 0.3300069 ), float4( 0.879, 0.610905, 0.8481572, 0.6599985 ), float4( 0.8666667, 0.7372549, 0.2901961, 1 ), 0, 0, 0, 0, float2( 1, 0 ), float2( 1, 1 ), 0, 0, 0, 0, 0, 0 );
			float mulTime228 = _Time.y * _TimeScale;
			float4 VoidColor174 = SampleGradient( gradient231, ( mulTime228 % 1.0 ) );
			float2 uv_VoidMask = i.uv_texcoord * _VoidMask_ST.xy + _VoidMask_ST.zw;
			float4 tex2DNode176 = tex2D( _VoidMask, uv_VoidMask );
			float4 temp_output_182_0 = ( VoidColor174 * tex2DNode176 );
			float2 uv_EmojiFace = i.uv_texcoord * _EmojiFace_ST.xy + _EmojiFace_ST.zw;
			float4 tex2DNode233 = tex2D( _EmojiFace, uv_EmojiFace );
			float grayscale238 = Luminance(tex2DNode233.rgb);
			float smoothstepResult234 = smoothstep( 0.0 , 0.01 , grayscale238);
			float4 temp_output_243_0 = ( tex2DNode233 * smoothstepResult234 );
			float2 uv_Albedo = i.uv_texcoord * _Albedo_ST.xy + _Albedo_ST.zw;
			float4 temp_output_240_0 = ( ( 1.0 - smoothstepResult234 ) * tex2D( _Albedo, uv_Albedo ) );
			float4 Albedo31 = ( _AlbedoTint * ( temp_output_243_0 + temp_output_240_0 ) );
			float4 VoidAdded184 = ( temp_output_182_0 + ( ( 1.0 - tex2DNode176 ) * Albedo31 ) );
			o.Albedo = VoidAdded184.rgb;
			float4 Voidsparkles196 = temp_output_182_0;
			float4 BackgroundforEmission257 = temp_output_240_0;
			float4 FaceforEmission256 = ( temp_output_243_0 * _EmissionFaceScale );
			float4 Emission105 = ( _EmissionScale * ( Voidsparkles196 + BackgroundforEmission257 + FaceforEmission256 ) );
			o.Emission = Emission105.rgb;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardCustomLighting keepalpha fullforwardshadows exclude_path:deferred 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				SurfaceOutputCustomLightingCustom o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputCustomLightingCustom, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18000
337;73;1008;535;3271.648;862.9362;2.203245;True;True
Node;AmplifyShaderEditor.CommentaryNode;32;-2260.487,-981.2759;Inherit;False;1578.145;807.217;Comment;14;30;31;241;238;240;28;234;29;242;245;254;255;256;257;Albedo;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;233;-2605.775,-719.8476;Inherit;True;Property;_EmojiFace;EmojiFace;19;0;Create;True;0;0;False;0;-1;50202b09911adaa459b163a1b5a44ae0;50202b09911adaa459b163a1b5a44ae0;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;235;-2477.775,-527.8476;Inherit;False;Constant;_Float1;Float 1;20;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCGrayscale;238;-2301.775,-623.8476;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;236;-2477.775,-451.8474;Inherit;False;Constant;_Float4;Float 4;20;0;Create;True;0;0;False;0;0.01;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;226;-456.4161,-1548.302;Inherit;False;582;248;;4;230;229;228;227;Mod Time;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;45;-2734.699,172.4961;Inherit;False;578;280;Comment;2;22;23;Normal Map;1,1,1,1;0;0
Node;AmplifyShaderEditor.SmoothstepOpNode;234;-2125.776,-623.8476;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;28;-1714.585,-387.6591;Inherit;True;Property;_Albedo;Albedo;8;0;Create;True;0;0;False;0;-1;3a52d5572e05c5d40bd9b7a8213e17bf;a9dc235eb515b1e42af9da219117b8ec;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;242;-1520.025,-582.0002;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;227;-406.4162,-1495.302;Inherit;False;Property;_TimeScale;TimeScale;0;0;Create;True;0;0;False;0;0.2;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;22;-2684.699,222.4961;Inherit;True;Property;_NormalMap;Normal Map;6;0;Create;True;0;0;False;0;-1;None;c9a1daa61a9c521419e68e8063c897dd;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;228;-247.4156,-1494.302;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;243;-1508.023,-676.6659;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;240;-1424.48,-502.9188;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;23;-2380.699,230.4961;Inherit;False;Normal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;229;-223.4156,-1416.302;Inherit;False;Constant;_Float0;Float 0;0;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;29;-1470.293,-854.1182;Inherit;False;Property;_AlbedoTint;Albedo Tint;10;1;[HDR];Create;True;0;0;False;0;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;241;-1228.161,-691.5133;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GradientNode;231;-67.01871,-1634.748;Inherit;False;0;4;2;0.8666667,0.7375554,0.2886,0;0.309738,0.858,0.8237337,0.3300069;0.879,0.610905,0.8481572,0.6599985;0.8666667,0.7372549,0.2901961,1;1,0;1,1;0;1;OBJECT;0
Node;AmplifyShaderEditor.CommentaryNode;13;-1780.536,-64.31284;Inherit;False;655.2222;382.1494;;4;3;9;4;2;Normal.LightDir;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleRemainderNode;230;-53.41599,-1498.302;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;26;-1952,-16;Inherit;False;23;Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;173;-647.3226,-1174.296;Inherit;False;1025.826;393.2974;Comment;4;176;177;196;182;Masked Color;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;4;-1726.026,134.8367;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldNormalVector;2;-1730.536,-14.31284;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GradientSampleNode;232;184.3164,-1639.825;Inherit;True;2;0;OBJECT;;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;-1017.258,-785.7762;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;31;-884.0581,-776.5763;Inherit;False;Albedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;176;-442.2227,-980.7966;Inherit;True;Property;_VoidMask;VoidMask;1;0;Create;True;0;0;False;0;-1;0fdcc6c12f052274396a7dc221c5128e;220f8d46e4e5dc241b9b5323228dd6b7;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DotProductOpNode;3;-1481.963,31.45884;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;174;601.147,-1612.451;Inherit;False;VoidColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;27;-1952,384;Inherit;False;23;Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;171;-485.7896,-763.0905;Inherit;False;858.6914;265.5294;Comment;3;189;181;190;Albedo;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;12;-1781.46,337.6487;Inherit;False;640.9408;400.906;;4;8;6;7;10;Normal.ViewDir;1,1,1,1;0;0
Node;AmplifyShaderEditor.OneMinusNode;190;-97,-723;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;24;-1076.267,525.1374;Inherit;False;1111.259;400.8853;;8;34;35;17;19;20;21;14;65;Shadow;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;177;-311.3557,-1063.797;Inherit;False;174;VoidColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;189;-46.73666,-582.4948;Inherit;False;31;Albedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;9;-1349.313,85.10046;Inherit;False;normal_lightdir;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;6;-1730.377,550.5546;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldNormalVector;8;-1731.46,387.6487;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;96;-1515.906,2159.233;Inherit;False;2423.643;554.0854;Comment;18;74;75;76;72;73;71;68;69;70;66;67;99;81;80;79;78;77;86;Specular;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldSpaceLightPos;67;-1486.516,2375.813;Inherit;False;0;3;FLOAT4;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;181;133.3001,-723.4448;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;14;-1056.168,602.7084;Inherit;False;9;normal_lightdir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;21;-1046.626,680.1732;Inherit;False;Property;_ShadowOffset;Shadow Offset;4;0;Create;True;0;0;False;0;0;0.42;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;66;-1420.516,2213.813;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;70;-1469.123,2500.354;Inherit;False;23;Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DotProductOpNode;7;-1492.822,465.189;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;182;-58.81258,-1010.179;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;48;-1493.197,1513.863;Inherit;False;1591.003;586.1711;;16;56;61;60;59;58;57;54;55;53;63;52;51;50;49;62;220;Rim Light;1,1,1,1;0;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;20;-854.9259,603.2731;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;69;-1267.729,2487.438;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;47;-1122.713,970.759;Inherit;False;1184.867;526.6386;Comment;9;37;36;42;43;41;44;46;38;39;Attenuation and Ambient;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;10;-1365.547,464.0627;Inherit;False;normal_viewdir;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;183;411.4575,-1012.566;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;68;-1230.307,2294.819;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LightAttenuation;42;-881.1199,1386.397;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;184;663.4897,-1011.367;Inherit;False;VoidAdded;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;62;-1447.529,1630.967;Inherit;False;10;normal_viewdir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;71;-1030.123,2417.354;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;63;-888.0463,1577.756;Inherit;False;9;normal_lightdir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;97;-730.506,2792.573;Inherit;False;793.0237;844.9717;Comment;7;89;91;85;87;92;90;88;Specular colour and roughness;1,1,1,1;0;0
Node;AmplifyShaderEditor.SaturateNode;65;-762.3721,782.4862;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;73;-1072.841,2557.071;Inherit;False;Property;_Gloss;Gloss;13;0;Create;True;0;0;False;0;0.33;0.33;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;49;-1473.814,1750.62;Float;False;Property;_RimOffset;Rim Offset;9;0;Create;True;0;0;False;0;0.63;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;76;-798.0164,2597.319;Inherit;False;Constant;_max;max;12;0;Create;True;0;0;False;0;1.79;1.12;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;85;-583.5135,2845.275;Inherit;True;Property;_AntiSpecMap;Anti-Spec Map;12;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;34;-505.2676,631.925;Inherit;False;184;VoidAdded;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;55;-638.197,1559.863;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;44;-1072.713,1292.618;Inherit;False;23;Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;19;-621.7829,717.2307;Inherit;True;Property;_ToonRamp;Toon Ramp;2;0;Create;True;0;0;False;0;-1;f662d9e61f860c7428cc30e072e1b6c4;14656c99dff77cb4ba68513ede2b1cb9;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;75;-802.1953,2520.104;Inherit;False;Constant;_min;min;9;0;Create;True;0;0;False;0;1.07;1.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;50;-1205.197,1673.863;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;72;-824.1228,2416.354;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;254;-1359.807,-287.7383;Inherit;False;Property;_EmissionFaceScale;Emission Face Scale;21;0;Create;True;0;0;False;0;1;1;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;87;-266.4998,2842.573;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;51;-1045.197,1673.863;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;220;-459.9244,1562.455;Inherit;False;QuestionableShadows;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;106;-336.2318,-204.9541;Inherit;False;1681.45;683.6086;Couldn't get light to diminish when texels not lit;17;105;250;197;214;199;198;206;219;101;205;207;204;223;251;252;258;259;Emission;1,1,1,1;0;0
Node;AmplifyShaderEditor.IndirectDiffuseLighting;41;-897.7579,1298.01;Inherit;False;Tangent;1;0;FLOAT3;0,0,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;88;-624.0684,3055.784;Inherit;False;Property;_SpecularityColor;Specularity Color;14;0;Create;True;0;0;False;0;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;-330.8903,662.9952;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;74;-634.5532,2414.393;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;43;-622.1936,1313.607;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;92;-99.48232,2884.312;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;17;-165.0458,672.5758;Inherit;False;Shadow;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LightColorNode;37;-860.5242,1153.693;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.GetLocalVarNode;223;-303.5703,34.82874;Inherit;False;220;QuestionableShadows;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;52;-869.197,1673.863;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;255;-1076.927,-326.4405;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;99;-416.353,2392.236;Inherit;True;Property;_Specularramp;Specular ramp;3;0;Create;True;0;0;False;0;-1;f662d9e61f860c7428cc30e072e1b6c4;f662d9e61f860c7428cc30e072e1b6c4;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;53;-981.1969,1801.863;Float;False;Property;_RimPower;Rim Power;7;0;Create;True;0;0;False;0;0.47;0;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;219;-54.3443,48.70035;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;205;-197.6042,323.2513;Inherit;False;Property;_Emission_Max;Emission_Max ;17;0;Create;True;0;0;False;0;10;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;101;-250.4507,-158.3804;Inherit;True;Property;_Emission;Emission;16;0;Create;True;0;0;False;0;-1;7a170cdb7cc88024cb628cfcdbb6705c;1ba1aba94964cd944b671df306b01e27;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;46;-463.0366,1191.738;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;204;-204.6042,251.2514;Inherit;False;Property;_Emission_Min;Emission_Min;18;0;Create;True;0;0;False;0;0.1;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;207;-203.0705,110.1529;Inherit;False;Constant;_Float3;Float 3;20;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;77;68.40207,2580.396;Inherit;False;Property;_SpecIntensity;Spec Intensity;11;0;Create;True;0;0;False;0;0.5352941;0.5117647;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;86;-85.70343,2409.813;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;196;174.0141,-1064.942;Inherit;False;Voidsparkles;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;206;-201.0705,178.1529;Inherit;False;Constant;_Float2;Float 2;20;0;Create;True;0;0;False;0;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;54;-677.197,1673.863;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;257;-945.9454,-447.088;Inherit;False;BackgroundforEmission;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;256;-906.1539,-342.1249;Inherit;False;FaceforEmission;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;36;-870.2253,1046.906;Inherit;False;17;Shadow;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;258;557.4852,10.78236;Inherit;False;257;BackgroundforEmission;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.LightAttenuation;79;293.7867,2322.078;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;259;594.9462,85.14518;Inherit;False;256;FaceforEmission;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;198;264.7325,-139.4227;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;38;-303.8639,1107.857;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LightColorNode;56;-407.4414,1957.374;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;78;337.868,2426.742;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;58;-437.1968,1641.863;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;199;109.0293,75.37065;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;197;555.3558,-67.22987;Inherit;False;196;Voidsparkles;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;57;-517.1972,1785.863;Float;False;Property;_RimColor;Rim Color;5;1;[HDR];Create;True;0;0;False;0;0,1,0.8758622,0;0,0,0,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;251;694.1057,-161.7105;Inherit;False;Property;_EmissionScale;Emission Scale;20;0;Create;True;0;0;False;0;1;1;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;80;495.4758,2413.649;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;59;-213.1968,1769.863;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;39;-161.8463,1102.853;Inherit;False;Lighting;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;60;-245.1968,1641.863;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;214;407.3187,-49.52613;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;250;856.98,-66.29052;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;40;152.6266,1330.531;Inherit;False;39;Lighting;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RelayNode;225;189.7224,1133.049;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;61;-53.19688,1641.863;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;252;1013.006,-90.51047;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;81;683.7366,2418.822;Inherit;False;Spec;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;105;1156.511,-95.77919;Inherit;False;Emission;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;83;300.5427,1598.564;Inherit;False;81;Spec;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;64;343.13,1425.497;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;90;-363.4789,3132.549;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;104;447.2572,1164.427;Inherit;False;105;Emission;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;91;-680.506,3378.544;Inherit;True;Property;_LightColorSpecInfluence;Light Color Spec Influence;15;0;Create;True;0;0;False;0;0.4;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;246;-2450.638,-259.8144;Inherit;False;Constant;_Float5;Float 5;20;0;Create;True;0;0;False;0;0.7;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LightColorNode;89;-576.539,3253.147;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleAddOpNode;84;473.3699,1526.991;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;185;441.0261,1089.869;Inherit;False;184;VoidAdded;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;247;-2450.638,-335.8145;Inherit;False;Constant;_Float6;Float 6;20;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;245;-2126.578,-399.3795;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;624,1088;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;Matt/ToonTear_Face;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0.014;0.245283,0.03818085,0.03818085,0;VertexOffset;False;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;238;0;233;0
WireConnection;234;0;238;0
WireConnection;234;1;235;0
WireConnection;234;2;236;0
WireConnection;242;0;234;0
WireConnection;228;0;227;0
WireConnection;243;0;233;0
WireConnection;243;1;234;0
WireConnection;240;0;242;0
WireConnection;240;1;28;0
WireConnection;23;0;22;0
WireConnection;241;0;243;0
WireConnection;241;1;240;0
WireConnection;230;0;228;0
WireConnection;230;1;229;0
WireConnection;2;0;26;0
WireConnection;232;0;231;0
WireConnection;232;1;230;0
WireConnection;30;0;29;0
WireConnection;30;1;241;0
WireConnection;31;0;30;0
WireConnection;3;0;2;0
WireConnection;3;1;4;0
WireConnection;174;0;232;0
WireConnection;190;0;176;0
WireConnection;9;0;3;0
WireConnection;8;0;27;0
WireConnection;181;0;190;0
WireConnection;181;1;189;0
WireConnection;7;0;8;0
WireConnection;7;1;6;0
WireConnection;182;0;177;0
WireConnection;182;1;176;0
WireConnection;20;0;14;0
WireConnection;20;1;21;0
WireConnection;20;2;21;0
WireConnection;69;0;70;0
WireConnection;10;0;7;0
WireConnection;183;0;182;0
WireConnection;183;1;181;0
WireConnection;68;0;66;0
WireConnection;68;1;67;1
WireConnection;184;0;183;0
WireConnection;71;0;68;0
WireConnection;71;1;69;0
WireConnection;65;0;20;0
WireConnection;55;0;42;0
WireConnection;55;1;63;0
WireConnection;19;1;65;0
WireConnection;50;0;62;0
WireConnection;50;1;49;0
WireConnection;72;0;71;0
WireConnection;72;1;73;0
WireConnection;87;0;85;0
WireConnection;51;0;50;0
WireConnection;220;0;55;0
WireConnection;41;0;44;0
WireConnection;35;0;34;0
WireConnection;35;1;19;0
WireConnection;74;0;72;0
WireConnection;74;1;75;0
WireConnection;74;2;76;0
WireConnection;43;0;41;0
WireConnection;43;1;42;0
WireConnection;92;0;87;0
WireConnection;92;1;88;0
WireConnection;17;0;35;0
WireConnection;52;0;51;0
WireConnection;255;0;243;0
WireConnection;255;1;254;0
WireConnection;99;1;74;0
WireConnection;219;0;223;0
WireConnection;46;0;37;0
WireConnection;46;1;43;0
WireConnection;86;0;99;0
WireConnection;86;1;92;0
WireConnection;196;0;182;0
WireConnection;54;0;52;0
WireConnection;54;1;53;0
WireConnection;257;0;240;0
WireConnection;256;0;255;0
WireConnection;198;0;101;0
WireConnection;38;0;36;0
WireConnection;38;1;46;0
WireConnection;78;0;86;0
WireConnection;78;1;77;0
WireConnection;58;0;55;0
WireConnection;58;1;54;0
WireConnection;199;0;219;0
WireConnection;199;1;207;0
WireConnection;199;2;206;0
WireConnection;199;3;204;0
WireConnection;199;4;205;0
WireConnection;80;0;79;0
WireConnection;80;1;78;0
WireConnection;59;0;57;0
WireConnection;59;1;56;0
WireConnection;39;0;38;0
WireConnection;60;0;58;0
WireConnection;214;0;198;0
WireConnection;214;1;199;0
WireConnection;250;0;197;0
WireConnection;250;1;258;0
WireConnection;250;2;259;0
WireConnection;225;0;214;0
WireConnection;61;0;60;0
WireConnection;61;1;59;0
WireConnection;252;0;251;0
WireConnection;252;1;250;0
WireConnection;81;0;80;0
WireConnection;105;0;252;0
WireConnection;64;0;40;0
WireConnection;64;1;61;0
WireConnection;64;2;225;0
WireConnection;90;0;88;0
WireConnection;90;1;89;0
WireConnection;90;2;91;0
WireConnection;84;0;64;0
WireConnection;84;1;83;0
WireConnection;245;0;238;0
WireConnection;245;1;246;0
WireConnection;245;2;247;0
WireConnection;0;0;185;0
WireConnection;0;2;104;0
WireConnection;0;13;84;0
ASEEND*/
//CHKSM=2D41647B005BE97214BFF42F4056BFE0760A929D