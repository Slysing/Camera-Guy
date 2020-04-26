// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Tear01"
{
	Properties
	{
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
			float4 screenPos;
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

		uniform float4 _AlbedoTint;
		uniform sampler2D _Albedo;
		uniform float4 _Albedo_ST;
		uniform sampler2D _Emission;
		uniform float4 _Emission_ST;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform sampler2D _ToonRamp;
		uniform sampler2D _NormalMap;
		uniform float4 _NormalMap_ST;
		uniform float _ShadowOffset;
		uniform float _RimOffset;
		uniform float _RimPower;
		uniform float4 _RimColor;
		uniform sampler2D _Specularramp;
		uniform float _Gloss;
		uniform sampler2D _AntiSpecMap;
		uniform float4 _AntiSpecMap_ST;
		uniform float4 _SpecularityColor;
		uniform float _SpecIntensity;


		float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }

		float snoise( float2 v )
		{
			const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
			float2 i = floor( v + dot( v, C.yy ) );
			float2 x0 = v - i + dot( i, C.xx );
			float2 i1;
			i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
			float4 x12 = x0.xyxy + C.xxzz;
			x12.xy -= i1;
			i = mod2D289( i );
			float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
			float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
			m = m * m;
			m = m * m;
			float3 x = 2.0 * frac( p * C.www ) - 1.0;
			float3 h = abs( x ) - 0.5;
			float3 ox = floor( x + 0.5 );
			float3 a0 = x - ox;
			m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
			float3 g;
			g.x = a0.x * x0.x + h.x * x0.y;
			g.yz = a0.yz * x12.xz + h.yz * x12.yw;
			return 130.0 * dot( m, g );
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
			float2 uv_Albedo = i.uv_texcoord * _Albedo_ST.xy + _Albedo_ST.zw;
			float4 Albedo31 = ( _AlbedoTint * tex2D( _Albedo, uv_Albedo ) );
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
			float2 temp_cast_5 = (saturate( (normal_lightdir9*_ShadowOffset + _ShadowOffset) )).xx;
			float4 Shadow17 = ( Albedo31 * tex2D( _ToonRamp, temp_cast_5 ) );
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
			float2 uv_Emission = i.uv_texcoord * _Emission_ST.xy + _Emission_ST.zw;
			float temp_output_116_0 = step( tex2D( _Emission, uv_Emission ).b , 0.01 );
			float AntiVoidMask174 = temp_output_116_0;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float dotResult7 = dot( (WorldNormalVector( i , Normal23 )) , ase_worldViewDir );
			float normal_viewdir10 = dotResult7;
			float4 RimLight176 = ( AntiVoidMask174 * ( saturate( ( ( ase_lightAtten * normal_lightdir9 ) * pow( ( 1.0 - saturate( ( normal_viewdir10 + _RimOffset ) ) ) , _RimPower ) ) ) * ( _RimColor * ase_lightColor ) ) );
			float dotResult71 = dot( ( ase_worldViewDir + _WorldSpaceLightPos0.xyz ) , (WorldNormalVector( i , Normal23 )) );
			float smoothstepResult74 = smoothstep( 1.07 , 1.79 , pow( dotResult71 , _Gloss ));
			float2 temp_cast_7 = (smoothstepResult74).xx;
			float2 uv_AntiSpecMap = i.uv_texcoord * _AntiSpecMap_ST.xy + _AntiSpecMap_ST.zw;
			float4 Spec81 = ( ase_lightAtten * ( ( tex2D( _Specularramp, temp_cast_7 ) * ( ( 1.0 - tex2D( _AntiSpecMap, uv_AntiSpecMap ) ) * _SpecularityColor ) ) * _SpecIntensity ) );
			c.rgb = ( ( Lighting39 + RimLight176 ) + Spec81 ).rgb;
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
			float2 uv_Albedo = i.uv_texcoord * _Albedo_ST.xy + _Albedo_ST.zw;
			float4 Albedo31 = ( _AlbedoTint * tex2D( _Albedo, uv_Albedo ) );
			o.Albedo = Albedo31.rgb;
			float2 temp_cast_1 = (23.6).xx;
			float2 uv_TexCoord136 = i.uv_texcoord * temp_cast_1;
			float2 panner163 = ( 1.0 * _Time.y * float2( 2,-2.5 ) + uv_TexCoord136);
			float simplePerlin2D162 = snoise( panner163 );
			simplePerlin2D162 = simplePerlin2D162*0.5 + 0.5;
			float2 panner159 = ( 1.0 * _Time.y * float2( 3,1.8 ) + uv_TexCoord136);
			float simplePerlin2D158 = snoise( panner159 );
			simplePerlin2D158 = simplePerlin2D158*0.5 + 0.5;
			float2 panner140 = ( 1.0 * _Time.y * float2( 0,-1.2 ) + uv_TexCoord136);
			float simplePerlin2D137 = snoise( panner140 );
			simplePerlin2D137 = simplePerlin2D137*0.5 + 0.5;
			float4 appendResult170 = (float4(simplePerlin2D162 , simplePerlin2D158 , simplePerlin2D137 , 0.0));
			float2 temp_cast_2 = (65.4).xx;
			float2 break16_g6 = ( i.uv_texcoord * temp_cast_2 );
			float2 appendResult7_g6 = (float2(( break16_g6.x + ( 0.5 * step( 1.0 , ( break16_g6.y % 2.0 ) ) ) ) , ( break16_g6.y + ( 1.0 * step( 1.0 , ( break16_g6.x % 2.0 ) ) ) )));
			float temp_output_2_0_g6 = 0.41;
			float2 appendResult11_g7 = (float2(temp_output_2_0_g6 , temp_output_2_0_g6));
			float temp_output_17_0_g7 = length( ( (frac( appendResult7_g6 )*2.0 + -1.0) / appendResult11_g7 ) );
			float temp_output_123_0 = saturate( ( ( 1.0 - temp_output_17_0_g7 ) / fwidth( temp_output_17_0_g7 ) ) );
			float2 uv_Emission = i.uv_texcoord * _Emission_ST.xy + _Emission_ST.zw;
			float temp_output_116_0 = step( tex2D( _Emission, uv_Emission ).b , 0.01 );
			float temp_output_118_0 = ( 1.0 - temp_output_116_0 );
			float4 color151 = IsGammaSpace() ? float4(0.3679245,0.3679245,0.3679245,1) : float4(0.1114872,0.1114872,0.1114872,1);
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float eyeDepth171 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPos.xy ));
			float4 Void114 = ( ( ( appendResult170 * ( temp_output_123_0 * temp_output_118_0 ) ) + ( ( ( 1.0 - temp_output_123_0 ) * temp_output_118_0 ) * color151 ) ) * ( eyeDepth171 - ase_screenPos.w ) );
			o.Emission = Void114.xyz;
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
				float4 screenPos : TEXCOORD2;
				float4 tSpace0 : TEXCOORD3;
				float4 tSpace1 : TEXCOORD4;
				float4 tSpace2 : TEXCOORD5;
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
				o.screenPos = ComputeScreenPos( o.pos );
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
				surfIN.screenPos = IN.screenPos;
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
1922;4;1277;960;1383.776;1644.777;1.913782;True;True
Node;AmplifyShaderEditor.CommentaryNode;45;-2734.699,172.4961;Inherit;False;578;280;Comment;2;22;23;Normal Map;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;22;-2684.699,222.4961;Inherit;True;Property;_NormalMap;Normal Map;4;0;Create;True;0;0;False;0;-1;None;c9a1daa61a9c521419e68e8063c897dd;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;23;-2380.699,230.4961;Inherit;False;Normal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;27;-2012.498,392.4365;Inherit;False;23;Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;12;-1781.46,337.6487;Inherit;False;640.9408;400.906;;4;8;6;7;10;Normal.ViewDir;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;26;-2022.817,-17.84793;Inherit;False;23;Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;13;-1780.536,-64.31284;Inherit;False;655.2222;382.1494;;4;3;9;4;2;Normal.LightDir;1,1,1,1;0;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;6;-1730.377,550.5546;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldNormalVector;8;-1731.46,387.6487;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldNormalVector;2;-1730.536,-14.31284;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;4;-1726.026,134.8367;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DotProductOpNode;7;-1492.822,465.189;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;3;-1481.963,31.45884;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;48;-2551.076,1567.351;Inherit;False;2107.604;586.853;;18;176;173;175;61;60;59;57;56;58;55;54;63;53;52;51;50;49;62;Rim Light;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;10;-1364.519,455.8388;Inherit;False;normal_viewdir;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;32;-1106.325,565.7111;Inherit;False;712;465;Comment;4;28;29;30;31;Albedo;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;62;-2505.408,1684.455;Inherit;False;10;normal_viewdir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;49;-2531.693,1804.108;Float;False;Property;_RimOffset;Rim Offset;7;0;Create;True;0;0;False;0;0.63;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;96;-2621.33,2224.607;Inherit;False;2423.643;554.0854;Comment;18;74;75;76;72;73;71;68;69;70;66;67;99;81;80;79;78;77;86;Specular;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;24;-1141.69,1113.942;Inherit;False;1111.259;400.8853;;8;34;35;17;19;20;21;14;65;Shadow;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;9;-1349.313,85.10046;Inherit;False;normal_lightdir;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceLightPos;67;-2591.94,2441.187;Inherit;False;0;3;FLOAT4;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;21;-1066.149,1268.978;Inherit;False;Property;_ShadowOffset;Shadow Offset;2;0;Create;True;0;0;False;0;0;0.42;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;28;-1056.324,800.7104;Inherit;True;Property;_Albedo;Albedo;6;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;70;-2574.547,2565.728;Inherit;False;23;Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;29;-993.3246,615.7107;Inherit;False;Property;_AlbedoTint;Albedo Tint;8;1;[HDR];Create;True;0;0;False;0;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;14;-1091.69,1191.513;Inherit;False;9;normal_lightdir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;66;-2525.939,2279.187;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;50;-2263.076,1727.351;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;172;-324.4421,-666.8578;Inherit;False;2054.163;1600.601;Comment;34;139;124;117;125;136;160;143;164;101;140;163;159;116;123;118;149;137;162;158;150;134;151;170;152;148;153;114;154;157;171;174;180;181;182;Void;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldNormalVector;69;-2373.153,2552.812;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;47;-2362.946,993.5452;Inherit;False;1184.867;526.6386;Comment;9;37;36;42;43;41;44;46;38;39;Attenuation and Ambient;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;-759.3246,736.7104;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;20;-890.4493,1192.078;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;51;-2103.076,1727.351;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;68;-2335.731,2360.193;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;53;-2039.075,1855.351;Float;False;Property;_RimPower;Rim Power;5;0;Create;True;0;0;False;0;0.47;0;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;65;-827.7952,1371.291;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;52;-1927.076,1727.351;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;63;-1981.925,1632.244;Inherit;False;9;normal_lightdir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;73;-2178.265,2622.445;Inherit;False;Property;_Gloss;Gloss;11;0;Create;True;0;0;False;0;0.33;0.33;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;71;-2135.547,2482.728;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;31;-618.3246,740.7105;Inherit;False;Albedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LightAttenuation;42;-2121.352,1409.184;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;97;-1984.508,2869.833;Inherit;False;793.0237;844.9717;Comment;7;89;91;85;87;92;90;88;Specular colour and roughness;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;139;-262.4813,-266.8827;Inherit;False;Constant;_Tiling;Tiling;15;0;Create;True;0;0;False;0;23.6;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;136;-90.6797,-265.967;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;164;-54.38203,-568.3578;Inherit;False;Constant;_Vector2;Vector 2;15;0;Create;True;0;0;False;0;2,-2.5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;124;-112.6797,-26.96704;Inherit;False;Constant;_Float2;Float 2;15;0;Create;True;0;0;False;0;0.41;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;117;-137.4073,422.7385;Inherit;False;Constant;_Float0;Float 0;15;0;Create;True;0;0;False;0;0.01;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;125;-193.6797,103.0329;Inherit;False;Constant;_Dotdistance;Dot distance;15;0;Create;True;0;0;False;0;65.4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;75;-1907.619,2585.478;Inherit;False;Constant;_min;min;9;0;Create;True;0;0;False;0;1.07;1.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;160;-50.38203,-405.3578;Inherit;False;Constant;_Vector1;Vector 1;15;0;Create;True;0;0;False;0;3,1.8;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;143;-58.6797,-153.9671;Inherit;False;Constant;_Pan;Pan;15;0;Create;True;0;0;False;0;0,-1.2;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;76;-1903.44,2662.693;Inherit;False;Constant;_max;max;12;0;Create;True;0;0;False;0;1.79;1.12;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;55;-1751.076,1615.351;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;72;-1929.546,2481.728;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;54;-1735.076,1727.351;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;44;-2312.946,1315.405;Inherit;False;23;Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;19;-694.206,1306.035;Inherit;True;Property;_ToonRamp;Toon Ramp;0;0;Create;True;0;0;False;0;-1;f662d9e61f860c7428cc30e072e1b6c4;14656c99dff77cb4ba68513ede2b1cb9;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;34;-570.6906,1220.73;Inherit;False;31;Albedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;85;-1837.516,2922.535;Inherit;True;Property;_AntiSpecMap;Anti-Spec Map;10;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;101;-274.4421,213.3568;Inherit;True;Property;_Emission;Emission;14;0;Create;True;0;0;False;0;-1;220f8d46e4e5dc241b9b5323228dd6b7;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StepOpNode;116;27.49545,387.9746;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;140;133.3203,-233.9671;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SmoothstepOpNode;74;-1739.977,2479.767;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;163;127.6179,-579.8578;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;159;134.9189,-354.0466;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;-384.7655,1252.955;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;58;-1495.076,1695.351;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;88;-1878.071,3133.044;Inherit;False;Property;_SpecularityColor;Specularity Color;12;0;Create;True;0;0;False;0;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.IndirectDiffuseLighting;41;-2137.99,1320.797;Inherit;False;Tangent;1;0;FLOAT3;0,0,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;57;-1552.076,1825.351;Float;False;Property;_RimColor;Rim Color;3;1;[HDR];Create;True;0;0;False;0;0,1,0.8758622,0;0,0,0,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LightColorNode;56;-1498.32,2003.862;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.OneMinusNode;87;-1520.502,2919.833;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;123;88.71873,56.01732;Inherit;True;Dots Pattern;-1;;6;7d8d5e315fd9002418fb41741d3a59cb;1,22,0;5;21;FLOAT2;0,0;False;3;FLOAT2;8,8;False;2;FLOAT;0.9;False;4;FLOAT;0.5;False;5;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;43;-1862.427,1336.394;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.OneMinusNode;149;428.8561,505.0665;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;162;313.6179,-616.8578;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;118;229.3766,388.0503;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;158;310.9189,-391.0466;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;137;309.3203,-169.9671;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;99;-1521.777,2457.61;Inherit;True;Property;_Specularramp;Specular ramp;1;0;Create;True;0;0;False;0;-1;f662d9e61f860c7428cc30e072e1b6c4;f662d9e61f860c7428cc30e072e1b6c4;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;59;-1271.075,1823.351;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;60;-1303.075,1695.351;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LightColorNode;37;-2100.757,1176.48;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.RegisterLocalVarNode;17;-230.4687,1261.38;Inherit;False;Shadow;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;92;-1353.484,2961.573;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;174;213.0496,635.9194;Inherit;False;AntiVoidMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;151;590.4427,721.7435;Inherit;False;Constant;_Color0;Color 0;15;0;Create;True;0;0;False;0;0.3679245,0.3679245,0.3679245,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;134;421.4115,173.8979;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;150;587.4286,509.4093;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;170;629.6179,-408.3578;Inherit;True;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;181;813.6719,801.9547;Float;False;1;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;46;-1703.27,1214.525;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;86;-1191.127,2475.187;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;77;-1037.022,2645.77;Inherit;False;Property;_SpecIntensity;Spec Intensity;9;0;Create;True;0;0;False;0;0.5352941;0.5117647;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;36;-2110.458,1069.693;Inherit;False;17;Shadow;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;61;-1111.076,1695.351;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;175;-1030.129,1620.615;Inherit;False;174;AntiVoidMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LightAttenuation;79;-811.6366,2387.452;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;78;-767.5554,2492.116;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;173;-832,1648;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ScreenDepthNode;171;1035.964,774.9605;Inherit;False;0;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;152;848.4427,565.7435;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;148;1112.191,174.2845;Inherit;True;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;38;-1544.097,1130.644;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;39;-1402.079,1125.64;Inherit;False;Lighting;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;182;1252.048,828.574;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;176;-688,1648;Inherit;False;RimLight;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;153;1346.543,445.9435;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;80;-609.9474,2479.023;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;180;1512.015,665.7791;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;177;148.0345,1469.816;Inherit;False;176;RimLight;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;40;152.6266,1330.531;Inherit;False;39;Lighting;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;81;-421.6867,2484.196;Inherit;False;Spec;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;64;343.13,1425.497;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;114;1505.721,223.8329;Inherit;False;Void;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;83;300.5427,1598.564;Inherit;False;81;Spec;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;91;-1934.508,3455.804;Inherit;True;Property;_LightColorSpecInfluence;Light Color Spec Influence;13;0;Create;True;0;0;False;0;0.4;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;115;413.1001,1171.25;Inherit;False;114;Void;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;84;473.3699,1526.991;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;154;810.8494,-28.47231;Inherit;True;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT4;1,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.Vector2Node;157;652.449,4.127748;Inherit;False;Constant;_Vector0;Vector 0;15;0;Create;True;0;0;False;0;0.1,0.9;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.LightColorNode;89;-1830.541,3330.407;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.GetLocalVarNode;33;448,1088;Inherit;False;31;Albedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;90;-1617.481,3209.81;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;624,1088;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;Tear01;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0.014;0.245283,0.03818085,0.03818085,0;VertexOffset;False;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;23;0;22;0
WireConnection;8;0;27;0
WireConnection;2;0;26;0
WireConnection;7;0;8;0
WireConnection;7;1;6;0
WireConnection;3;0;2;0
WireConnection;3;1;4;0
WireConnection;10;0;7;0
WireConnection;9;0;3;0
WireConnection;50;0;62;0
WireConnection;50;1;49;0
WireConnection;69;0;70;0
WireConnection;30;0;29;0
WireConnection;30;1;28;0
WireConnection;20;0;14;0
WireConnection;20;1;21;0
WireConnection;20;2;21;0
WireConnection;51;0;50;0
WireConnection;68;0;66;0
WireConnection;68;1;67;1
WireConnection;65;0;20;0
WireConnection;52;0;51;0
WireConnection;71;0;68;0
WireConnection;71;1;69;0
WireConnection;31;0;30;0
WireConnection;136;0;139;0
WireConnection;55;0;42;0
WireConnection;55;1;63;0
WireConnection;72;0;71;0
WireConnection;72;1;73;0
WireConnection;54;0;52;0
WireConnection;54;1;53;0
WireConnection;19;1;65;0
WireConnection;116;0;101;3
WireConnection;116;1;117;0
WireConnection;140;0;136;0
WireConnection;140;2;143;0
WireConnection;74;0;72;0
WireConnection;74;1;75;0
WireConnection;74;2;76;0
WireConnection;163;0;136;0
WireConnection;163;2;164;0
WireConnection;159;0;136;0
WireConnection;159;2;160;0
WireConnection;35;0;34;0
WireConnection;35;1;19;0
WireConnection;58;0;55;0
WireConnection;58;1;54;0
WireConnection;41;0;44;0
WireConnection;87;0;85;0
WireConnection;123;3;125;0
WireConnection;123;2;124;0
WireConnection;43;0;41;0
WireConnection;43;1;42;0
WireConnection;149;0;123;0
WireConnection;162;0;163;0
WireConnection;118;0;116;0
WireConnection;158;0;159;0
WireConnection;137;0;140;0
WireConnection;99;1;74;0
WireConnection;59;0;57;0
WireConnection;59;1;56;0
WireConnection;60;0;58;0
WireConnection;17;0;35;0
WireConnection;92;0;87;0
WireConnection;92;1;88;0
WireConnection;174;0;116;0
WireConnection;134;0;123;0
WireConnection;134;1;118;0
WireConnection;150;0;149;0
WireConnection;150;1;118;0
WireConnection;170;0;162;0
WireConnection;170;1;158;0
WireConnection;170;2;137;0
WireConnection;46;0;37;0
WireConnection;46;1;43;0
WireConnection;86;0;99;0
WireConnection;86;1;92;0
WireConnection;61;0;60;0
WireConnection;61;1;59;0
WireConnection;78;0;86;0
WireConnection;78;1;77;0
WireConnection;173;0;175;0
WireConnection;173;1;61;0
WireConnection;171;0;181;0
WireConnection;152;0;150;0
WireConnection;152;1;151;0
WireConnection;148;0;170;0
WireConnection;148;1;134;0
WireConnection;38;0;36;0
WireConnection;38;1;46;0
WireConnection;39;0;38;0
WireConnection;182;0;171;0
WireConnection;182;1;181;4
WireConnection;176;0;173;0
WireConnection;153;0;148;0
WireConnection;153;1;152;0
WireConnection;80;0;79;0
WireConnection;80;1;78;0
WireConnection;180;0;153;0
WireConnection;180;1;182;0
WireConnection;81;0;80;0
WireConnection;64;0;40;0
WireConnection;64;1;177;0
WireConnection;114;0;180;0
WireConnection;84;0;64;0
WireConnection;84;1;83;0
WireConnection;154;0;170;0
WireConnection;154;1;157;1
WireConnection;154;2;157;2
WireConnection;90;0;88;0
WireConnection;90;1;89;0
WireConnection;90;2;91;0
WireConnection;0;0;33;0
WireConnection;0;2;115;0
WireConnection;0;13;84;0
ASEEND*/
//CHKSM=3DFAC7C8AB9D963285DDB3410FE4D8B07397EA1C