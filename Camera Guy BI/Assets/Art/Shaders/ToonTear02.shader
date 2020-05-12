// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Matt/ToonTear02"
{
	Properties
	{
		_VoidMask("VoidMask", 2D) = "white" {}
		_VoidNoiseScaleOffset("Void Noise Scale Offset", Float) = 0.34
		_ToonRamp("Toon Ramp", 2D) = "white" {}
		_VoidNoiseScale("Void Noise Scale", Float) = 1.38
		_Specularramp("Specular ramp", 2D) = "white" {}
		_ShadowOffset("Shadow Offset", Float) = 0
		_SmoothStepMax("SmoothStep Max", Range( 0 , 1)) = 0.2665786
		[HDR]_RimColor("Rim Color", Color) = (0,1,0.8758622,0)
		_SmoothStepMin("SmoothStep Min", Range( 0 , 1)) = 0.05271714
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

		uniform float _VoidNoiseScale;
		uniform float _SmoothStepMin;
		uniform float _SmoothStepMax;
		uniform float _VoidNoiseScaleOffset;
		uniform sampler2D _VoidMask;
		uniform float4 _VoidMask_ST;
		uniform float4 _AlbedoTint;
		uniform sampler2D _Albedo;
		uniform float4 _Albedo_ST;
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


		inline float noise_randomValue (float2 uv) { return frac(sin(dot(uv, float2(12.9898, 78.233)))*43758.5453); }

		inline float noise_interpolate (float a, float b, float t) { return (1.0-t)*a + (t*b); }

		inline float valueNoise (float2 uv)
		{
			float2 i = floor(uv);
			float2 f = frac( uv );
			f = f* f * (3.0 - 2.0 * f);
			uv = abs( frac(uv) - 0.5);
			float2 c0 = i + float2( 0.0, 0.0 );
			float2 c1 = i + float2( 1.0, 0.0 );
			float2 c2 = i + float2( 0.0, 1.0 );
			float2 c3 = i + float2( 1.0, 1.0 );
			float r0 = noise_randomValue( c0 );
			float r1 = noise_randomValue( c1 );
			float r2 = noise_randomValue( c2 );
			float r3 = noise_randomValue( c3 );
			float bottomOfGrid = noise_interpolate( r0, r1, f.x );
			float topOfGrid = noise_interpolate( r2, r3, f.x );
			float t = noise_interpolate( bottomOfGrid, topOfGrid, f.y );
			return t;
		}


		float SimpleNoise(float2 UV)
		{
			float t = 0.0;
			float freq = pow( 2.0, float( 0 ) );
			float amp = pow( 0.5, float( 3 - 0 ) );
			t += valueNoise( UV/freq )*amp;
			freq = pow(2.0, float(1));
			amp = pow(0.5, float(3-1));
			t += valueNoise( UV/freq )*amp;
			freq = pow(2.0, float(2));
			amp = pow(0.5, float(3-2));
			t += valueNoise( UV/freq )*amp;
			return t;
		}


		float2 voronoihash139( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi139( float2 v, float time, inout float2 id, float smoothness )
		{
			float2 n = floor( v );
			float2 f = frac( v );
			float F1 = 8.0;
			float F2 = 8.0; float2 mr = 0; float2 mg = 0;
			for ( int j = -1; j <= 1; j++ )
			{
				for ( int i = -1; i <= 1; i++ )
			 	{
			 		float2 g = float2( i, j );
			 		float2 o = voronoihash139( n + g );
					o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = g - f + o;
					float d = 0.5 * dot( r, r );
			 		if( d<F1 ) {
			 			F2 = F1;
			 			F1 = d; mg = g; mr = r; id = o;
			 		} else if( d<F2 ) {
			 			F2 = d;
			 		}
			 	}
			}
			return F1;
		}


		float2 voronoihash138( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi138( float2 v, float time, inout float2 id, float smoothness )
		{
			float2 n = floor( v );
			float2 f = frac( v );
			float F1 = 8.0;
			float F2 = 8.0; float2 mr = 0; float2 mg = 0;
			for ( int j = -1; j <= 1; j++ )
			{
				for ( int i = -1; i <= 1; i++ )
			 	{
			 		float2 g = float2( i, j );
			 		float2 o = voronoihash138( n + g );
					o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = g - f + o;
					float d = 0.5 * dot( r, r );
			 		if( d<F1 ) {
			 			F2 = F1;
			 			F1 = d; mg = g; mr = r; id = o;
			 		} else if( d<F2 ) {
			 			F2 = d;
			 		}
			 	}
			}
			return F1;
		}


		float2 voronoihash137( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi137( float2 v, float time, inout float2 id, float smoothness )
		{
			float2 n = floor( v );
			float2 f = frac( v );
			float F1 = 8.0;
			float F2 = 8.0; float2 mr = 0; float2 mg = 0;
			for ( int j = -1; j <= 1; j++ )
			{
				for ( int i = -1; i <= 1; i++ )
			 	{
			 		float2 g = float2( i, j );
			 		float2 o = voronoihash137( n + g );
					o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = g - f + o;
					float d = 0.5 * dot( r, r );
			 		if( d<F1 ) {
			 			F2 = F1;
			 			F1 = d; mg = g; mr = r; id = o;
			 		} else if( d<F2 ) {
			 			F2 = d;
			 		}
			 	}
			}
			return F1;
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
			float2 _Vector1 = float2(0.35,0.52);
			float4 temp_cast_10 = (_Vector1.x).xxxx;
			float4 temp_cast_11 = (_Vector1.y).xxxx;
			float2 temp_cast_12 = (23.6).xx;
			float2 uv_TexCoord118 = i.uv_texcoord * temp_cast_12;
			float2 UVCoordinates122 = uv_TexCoord118;
			float2 panner154 = ( 1.0 * _Time.y * float2( 2,-2.5 ) + UVCoordinates122);
			float NoiseScale125 = _VoidNoiseScale;
			float simpleNoise161 = SimpleNoise( panner154*NoiseScale125 );
			float2 panner160 = ( 1.0 * _Time.y * float2( 3,1.8 ) + UVCoordinates122);
			float simpleNoise162 = SimpleNoise( panner160*NoiseScale125 );
			float2 panner156 = ( 1.0 * _Time.y * float2( 0,-1.2 ) + UVCoordinates122);
			float simpleNoise166 = SimpleNoise( panner156*NoiseScale125 );
			float4 appendResult167 = (float4(simpleNoise161 , simpleNoise162 , simpleNoise166 , 0.0));
			float4 smoothstepResult170 = smoothstep( temp_cast_10 , temp_cast_11 , appendResult167);
			float4 VoidColor174 = smoothstepResult170;
			float time139 = 0.0;
			float2 panner132 = ( 1.0 * _Time.y * float2( 2,1 ) + UVCoordinates122);
			float2 coords139 = panner132 * NoiseScale125;
			float2 id139 = 0;
			float voroi139 = voronoi139( coords139, time139,id139, 0 );
			float temp_output_140_0 = ( 1.0 - voroi139 );
			float temp_output_119_0 = ( _VoidNoiseScale + _VoidNoiseScaleOffset );
			float time138 = 0.0;
			float temp_output_127_0 = (_SinTime.w*0.5 + 0.5);
			float2 temp_cast_13 = (temp_output_127_0).xx;
			float2 panner135 = ( temp_output_127_0 * temp_cast_13 + UVCoordinates122);
			float2 coords138 = panner135 * temp_output_119_0;
			float2 id138 = 0;
			float voroi138 = voronoi138( coords138, time138,id138, 0 );
			float time137 = 0.0;
			float2 panner136 = ( 1.0 * _Time.y * float2( -0.3,-0.2 ) + UVCoordinates122);
			float2 coords137 = panner136 * ( temp_output_119_0 + _VoidNoiseScaleOffset );
			float2 id137 = 0;
			float voroi137 = voronoi137( coords137, time137,id137, 0 );
			float clampResult144 = clamp( ( 1.0 - voroi137 ) , 0.0 , 1.0 );
			float clampResult159 = clamp( ( temp_output_140_0 * ( temp_output_140_0 + ( 1.0 - voroi138 ) ) * clampResult144 ) , 0.0 , 1.0 );
			float smoothstepResult169 = smoothstep( _SmoothStepMin , _SmoothStepMax , ( 1.0 - clampResult159 ));
			float NoiseMask172 = smoothstepResult169;
			float2 uv_VoidMask = i.uv_texcoord * _VoidMask_ST.xy + _VoidMask_ST.zw;
			float4 tex2DNode176 = tex2D( _VoidMask, uv_VoidMask );
			float4 temp_output_182_0 = ( VoidColor174 * NoiseMask172 * tex2DNode176 );
			float grayscale194 = Luminance(tex2DNode176.rgb);
			float clampResult192 = clamp( ( ( 1.0 - grayscale194 ) + ( 1.0 - NoiseMask172 ) ) , 0.0 , 1.0 );
			float2 uv_Albedo = i.uv_texcoord * _Albedo_ST.xy + _Albedo_ST.zw;
			float4 Albedo31 = ( _AlbedoTint * tex2D( _Albedo, uv_Albedo ) );
			float4 VoidAdded184 = ( temp_output_182_0 + ( clampResult192 * Albedo31 ) );
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
			float2 temp_cast_17 = (saturate( (normal_lightdir9*_ShadowOffset + _ShadowOffset) )).xx;
			float4 Shadow17 = ( VoidAdded184 * tex2D( _ToonRamp, temp_cast_17 ) );
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
			float2 temp_cast_23 = (smoothstepResult74).xx;
			float2 uv_AntiSpecMap = i.uv_texcoord * _AntiSpecMap_ST.xy + _AntiSpecMap_ST.zw;
			float4 Spec81 = ( ase_lightAtten * ( ( tex2D( _Specularramp, temp_cast_23 ) * ( ( 1.0 - tex2D( _AntiSpecMap, uv_AntiSpecMap ) ) * _SpecularityColor ) ) * _SpecIntensity ) );
			c.rgb = ( ( Lighting39 + ( saturate( ( temp_output_55_0 * pow( ( 1.0 - saturate( ( normal_viewdir10 + _RimOffset ) ) ) , _RimPower ) ) ) * ( _RimColor * ase_lightColor ) ) + ( ( tex2D( _Emission, uv_Emission ) + float4( 0,0,0,0 ) ) * (_Emission_Min + (saturate( QuestionableShadows220 ) - 0.0) * (_Emission_Max - _Emission_Min) / (0.1 - 0.0)) ) ) + Spec81 ).xyz;
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
			float2 _Vector1 = float2(0.35,0.52);
			float4 temp_cast_0 = (_Vector1.x).xxxx;
			float4 temp_cast_1 = (_Vector1.y).xxxx;
			float2 temp_cast_2 = (23.6).xx;
			float2 uv_TexCoord118 = i.uv_texcoord * temp_cast_2;
			float2 UVCoordinates122 = uv_TexCoord118;
			float2 panner154 = ( 1.0 * _Time.y * float2( 2,-2.5 ) + UVCoordinates122);
			float NoiseScale125 = _VoidNoiseScale;
			float simpleNoise161 = SimpleNoise( panner154*NoiseScale125 );
			float2 panner160 = ( 1.0 * _Time.y * float2( 3,1.8 ) + UVCoordinates122);
			float simpleNoise162 = SimpleNoise( panner160*NoiseScale125 );
			float2 panner156 = ( 1.0 * _Time.y * float2( 0,-1.2 ) + UVCoordinates122);
			float simpleNoise166 = SimpleNoise( panner156*NoiseScale125 );
			float4 appendResult167 = (float4(simpleNoise161 , simpleNoise162 , simpleNoise166 , 0.0));
			float4 smoothstepResult170 = smoothstep( temp_cast_0 , temp_cast_1 , appendResult167);
			float4 VoidColor174 = smoothstepResult170;
			float time139 = 0.0;
			float2 panner132 = ( 1.0 * _Time.y * float2( 2,1 ) + UVCoordinates122);
			float2 coords139 = panner132 * NoiseScale125;
			float2 id139 = 0;
			float voroi139 = voronoi139( coords139, time139,id139, 0 );
			float temp_output_140_0 = ( 1.0 - voroi139 );
			float temp_output_119_0 = ( _VoidNoiseScale + _VoidNoiseScaleOffset );
			float time138 = 0.0;
			float temp_output_127_0 = (_SinTime.w*0.5 + 0.5);
			float2 temp_cast_3 = (temp_output_127_0).xx;
			float2 panner135 = ( temp_output_127_0 * temp_cast_3 + UVCoordinates122);
			float2 coords138 = panner135 * temp_output_119_0;
			float2 id138 = 0;
			float voroi138 = voronoi138( coords138, time138,id138, 0 );
			float time137 = 0.0;
			float2 panner136 = ( 1.0 * _Time.y * float2( -0.3,-0.2 ) + UVCoordinates122);
			float2 coords137 = panner136 * ( temp_output_119_0 + _VoidNoiseScaleOffset );
			float2 id137 = 0;
			float voroi137 = voronoi137( coords137, time137,id137, 0 );
			float clampResult144 = clamp( ( 1.0 - voroi137 ) , 0.0 , 1.0 );
			float clampResult159 = clamp( ( temp_output_140_0 * ( temp_output_140_0 + ( 1.0 - voroi138 ) ) * clampResult144 ) , 0.0 , 1.0 );
			float smoothstepResult169 = smoothstep( _SmoothStepMin , _SmoothStepMax , ( 1.0 - clampResult159 ));
			float NoiseMask172 = smoothstepResult169;
			float2 uv_VoidMask = i.uv_texcoord * _VoidMask_ST.xy + _VoidMask_ST.zw;
			float4 tex2DNode176 = tex2D( _VoidMask, uv_VoidMask );
			float4 temp_output_182_0 = ( VoidColor174 * NoiseMask172 * tex2DNode176 );
			float grayscale194 = Luminance(tex2DNode176.rgb);
			float clampResult192 = clamp( ( ( 1.0 - grayscale194 ) + ( 1.0 - NoiseMask172 ) ) , 0.0 , 1.0 );
			float2 uv_Albedo = i.uv_texcoord * _Albedo_ST.xy + _Albedo_ST.zw;
			float4 Albedo31 = ( _AlbedoTint * tex2D( _Albedo, uv_Albedo ) );
			float4 VoidAdded184 = ( temp_output_182_0 + ( clampResult192 * Albedo31 ) );
			o.Albedo = VoidAdded184.xyz;
			float4 Voidsparkles196 = temp_output_182_0;
			float4 Emission105 = Voidsparkles196;
			o.Emission = Emission105.xyz;
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
296;73;1346;655;3453.533;609.0784;3.897907;True;True
Node;AmplifyShaderEditor.CommentaryNode;114;-1879.898,-1834.925;Inherit;False;660;209;Comment;3;122;118;116;UV coordinates;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;115;-2463.741,-1028.327;Inherit;False;539.5845;388.2603;Comment;5;126;125;119;187;188;noise inputs;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;116;-1828.195,-1779.642;Inherit;False;Constant;_VoidTiling;Void Tiling;15;0;Create;True;0;0;False;0;23.6;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;117;-1909.699,-1585.849;Inherit;False;1380.762;998.7076;Comment;23;148;144;143;142;141;140;139;138;137;136;135;134;133;132;131;130;129;128;127;124;123;121;120;Noise Mask;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;188;-2428.007,-822.1636;Inherit;False;Property;_VoidNoiseScaleOffset;Void Noise Scale Offset;1;0;Create;True;0;0;False;0;0.34;0.34;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;187;-2418.935,-978.2201;Inherit;False;Property;_VoidNoiseScale;Void Noise Scale;3;0;Create;True;0;0;False;0;1.38;1.38;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;118;-1662.368,-1784.925;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SinTimeNode;121;-1824.091,-1247.849;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;120;-1891.379,-1100.212;Inherit;False;Constant;_VoidNoisesinscale;Void Noise sin scale;5;0;Create;True;0;0;False;0;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;119;-2187.444,-899.0267;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;122;-1445.898,-1779.642;Inherit;False;UVCoordinates;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;124;-1680.091,-1215.849;Inherit;False;122;UVCoordinates;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;126;-2043.033,-826.7267;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;127;-1664.091,-1135.849;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;128;-1664.091,-1535.849;Inherit;False;122;UVCoordinates;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;130;-1652.536,-1458.886;Inherit;False;Constant;_VoidNoisePan1;Void Noise Pan 1;1;0;Create;True;0;0;False;0;2,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.GetLocalVarNode;123;-1680.091,-895.8489;Inherit;False;122;UVCoordinates;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;125;-2187.737,-980.8688;Inherit;False;NoiseScale;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;129;-1672.089,-815.849;Inherit;False;Constant;_VoidNoisePan2;Void Noise Pan 2;1;0;Create;True;0;0;False;0;-0.3,-0.2;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PannerNode;135;-1456.091,-1215.849;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;136;-1456.091,-895.8489;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RelayNode;131;-1600.091,-671.849;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;134;-1456.091,-1407.849;Inherit;False;125;NoiseScale;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;132;-1456.091,-1535.849;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RelayNode;133;-1600.091,-1007.849;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;139;-1264.091,-1535.849;Inherit;True;0;0;1;0;1;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;2;FLOAT;0;FLOAT;1
Node;AmplifyShaderEditor.VoronoiNode;138;-1264.091,-1215.849;Inherit;True;0;0;1;0;1;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;2;FLOAT;0;FLOAT;1
Node;AmplifyShaderEditor.VoronoiNode;137;-1264.091,-895.8489;Inherit;True;0;0;1;0;1;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;2;FLOAT;0;FLOAT;1
Node;AmplifyShaderEditor.OneMinusNode;141;-1008.091,-895.8489;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;140;-1008.091,-1535.849;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;142;-1008.091,-1215.849;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;143;-816.0906,-1375.849;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;144;-864.0906,-895.8489;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;148;-660.8896,-1439.849;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;147;-505.7686,-1583.76;Inherit;False;766.1311;377.041;Comment;6;172;169;165;164;163;159;Noise Mask Clamp;1,1,1,1;0;0
Node;AmplifyShaderEditor.ClampOpNode;159;-457.7686,-1519.76;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;145;-1180.689,-2452.084;Inherit;False;1434.828;809.0751;Comment;19;174;170;168;167;166;162;161;160;158;157;156;155;154;153;152;151;150;149;146;Color;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;45;-2734.699,172.4961;Inherit;False;578;280;Comment;2;22;23;Normal Map;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;152;-1114.689,-2401.728;Inherit;False;122;UVCoordinates;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;151;-1130.689,-1921.73;Inherit;False;122;UVCoordinates;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;164;-457.7686,-1391.76;Inherit;False;Property;_SmoothStepMin;SmoothStep Min;8;0;Create;True;0;0;False;0;0.05271714;0.81;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;163;-457.7686,-1311.76;Inherit;False;Property;_SmoothStepMax;SmoothStep Max;6;0;Create;True;0;0;False;0;0.2665786;0.87;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;165;-313.7689,-1519.76;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;150;-1130.689,-2161.729;Inherit;False;122;UVCoordinates;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;153;-1099.652,-2323.424;Inherit;False;Constant;_VoidColorPan1;Void Color Pan 1;15;0;Create;True;0;0;False;0;2,-2.5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;149;-1116.615,-2081.729;Inherit;False;Constant;_VoidColorPan2;Void Color Pan 2;15;0;Create;True;0;0;False;0;3,1.8;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;146;-1116.614,-1843.426;Inherit;False;Constant;_VoidColorPan3;Void Color Pan 3;15;0;Create;True;0;0;False;0;0,-1.2;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PannerNode;154;-917.9976,-2402.084;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;173;-480.3226,-1174.296;Inherit;False;857.8258;392.2974;Comment;5;182;177;178;176;196;Masked Color;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;158;-923.3516,-1797.788;Inherit;False;125;NoiseScale;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;157;-917.2766,-2277.61;Inherit;False;125;NoiseScale;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;160;-922.6886,-2161.729;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SmoothstepOpNode;169;-153.7688,-1519.76;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;155;-923.3516,-2037.787;Inherit;False;125;NoiseScale;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;22;-2684.699,222.4961;Inherit;True;Property;_NormalMap;Normal Map;9;0;Create;True;0;0;False;0;-1;None;c9a1daa61a9c521419e68e8063c897dd;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;156;-922.6886,-1921.73;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;162;-730.6896,-2113.729;Inherit;True;Simple;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;166;-730.6896,-1873.73;Inherit;True;Simple;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;161;-725.9976,-2354.084;Inherit;True;Simple;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;32;-1083.679,-138.8427;Inherit;False;712;465;Comment;4;28;29;30;31;Albedo;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;23;-2380.699,230.4961;Inherit;False;Normal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;176;-434.2227,-983.7966;Inherit;True;Property;_VoidMask;VoidMask;0;0;Create;True;0;0;False;0;-1;None;220f8d46e4e5dc241b9b5323228dd6b7;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;171;-485.7896,-763.0905;Inherit;False;1123.059;271.1945;Comment;8;189;192;191;190;179;175;181;194;Albedo;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;172;68.48369,-1519.979;Inherit;False;NoiseMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;29;-970.6782,-88.84294;Inherit;False;Property;_AlbedoTint;Albedo Tint;13;1;[HDR];Create;True;0;0;False;0;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;168;-412.0659,-1908.582;Inherit;False;Constant;_Vector1;Vector 1;15;0;Create;True;0;0;False;0;0.35,0.52;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.GetLocalVarNode;26;-1952,-16;Inherit;False;23;Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;175;-288,-640;Inherit;False;172;NoiseMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCGrayscale;194;-280.6366,-727.9471;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;167;-427.4116,-2153.971;Inherit;True;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SamplerNode;28;-1033.678,96.15681;Inherit;True;Property;_Albedo;Albedo;11;0;Create;True;0;0;False;0;-1;a9dc235eb515b1e42af9da219117b8ec;a9dc235eb515b1e42af9da219117b8ec;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;13;-1780.536,-64.31284;Inherit;False;655.2222;382.1494;;4;3;9;4;2;Normal.LightDir;1,1,1,1;0;0
Node;AmplifyShaderEditor.OneMinusNode;179;-81,-640;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;170;-164.0845,-2040.112;Inherit;True;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT4;1,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;4;-1726.026,134.8367;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.OneMinusNode;190;-80,-720;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;2;-1730.536,-14.31284;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;-736.6782,32.15677;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;174;57.27519,-2037.787;Inherit;False;VoidColor;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DotProductOpNode;3;-1481.963,31.45884;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;12;-1781.46,337.6487;Inherit;False;640.9408;400.906;;4;8;6;7;10;Normal.ViewDir;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;191;75,-720;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;27;-1952,384;Inherit;False;23;Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;31;-595.6782,36.15678;Inherit;False;Albedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;6;-1730.377,550.5546;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ClampOpNode;192;224,-721.6688;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;96;-1515.906,2159.233;Inherit;False;2423.643;554.0854;Comment;18;74;75;76;72;73;71;68;69;70;66;67;99;81;80;79;78;77;86;Specular;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldNormalVector;8;-1731.46,387.6487;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;24;-1076.267,525.1374;Inherit;False;1111.259;400.8853;;8;34;35;17;19;20;21;14;65;Shadow;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;177;-311.8226,-1135.996;Inherit;False;174;VoidColor;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;189;193.4389,-572.8879;Inherit;False;31;Albedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;178;-317.4977,-1059.897;Inherit;False;172;NoiseMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;9;-1349.313,85.10046;Inherit;False;normal_lightdir;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceLightPos;67;-1486.516,2375.813;Inherit;False;0;3;FLOAT4;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;182;-59.81258,-1010.179;Inherit;True;3;3;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;70;-1469.123,2500.354;Inherit;False;23;Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;181;419.1093,-718.6416;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;14;-1056.168,602.7084;Inherit;False;9;normal_lightdir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;7;-1492.822,465.189;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;66;-1420.516,2213.813;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;21;-1046.626,680.1732;Inherit;False;Property;_ShadowOffset;Shadow Offset;5;0;Create;True;0;0;False;0;0;0.42;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;10;-1365.547,464.0627;Inherit;False;normal_viewdir;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;48;-1493.197,1513.863;Inherit;False;1591.003;586.1711;;16;56;61;60;59;58;57;54;55;53;63;52;51;50;49;62;220;Rim Light;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldNormalVector;69;-1267.729,2487.438;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;183;676.9653,-1024.713;Inherit;True;2;2;0;FLOAT4;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;20;-854.9259,603.2731;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;47;-1122.713,970.759;Inherit;False;1184.867;526.6386;Comment;9;37;36;42;43;41;44;46;38;39;Attenuation and Ambient;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;68;-1230.307,2294.819;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LightAttenuation;42;-881.1199,1386.397;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;97;-730.506,2792.573;Inherit;False;793.0237;844.9717;Comment;7;89;91;85;87;92;90;88;Specular colour and roughness;1,1,1,1;0;0
Node;AmplifyShaderEditor.SaturateNode;65;-762.3721,782.4862;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;63;-888.0463,1577.756;Inherit;False;9;normal_lightdir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;73;-1072.841,2557.071;Inherit;False;Property;_Gloss;Gloss;16;0;Create;True;0;0;False;0;0.33;0.33;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;184;928.9974,-1023.514;Inherit;False;VoidAdded;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;49;-1473.814,1750.62;Float;False;Property;_RimOffset;Rim Offset;12;0;Create;True;0;0;False;0;0.63;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;71;-1030.123,2417.354;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;62;-1447.529,1630.967;Inherit;False;10;normal_viewdir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;19;-621.7829,717.2307;Inherit;True;Property;_ToonRamp;Toon Ramp;2;0;Create;True;0;0;False;0;-1;f662d9e61f860c7428cc30e072e1b6c4;14656c99dff77cb4ba68513ede2b1cb9;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;75;-802.1953,2520.104;Inherit;False;Constant;_min;min;9;0;Create;True;0;0;False;0;1.07;1.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;72;-824.1228,2416.354;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;34;-505.2676,631.925;Inherit;False;184;VoidAdded;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;44;-1072.713,1292.618;Inherit;False;23;Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;50;-1205.197,1673.863;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;55;-638.197,1559.863;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;85;-583.5135,2845.275;Inherit;True;Property;_AntiSpecMap;Anti-Spec Map;15;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;76;-798.0164,2597.319;Inherit;False;Constant;_max;max;12;0;Create;True;0;0;False;0;1.79;1.12;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;-330.8903,662.9952;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ColorNode;88;-624.0684,3055.784;Inherit;False;Property;_SpecularityColor;Specularity Color;17;0;Create;True;0;0;False;0;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.IndirectDiffuseLighting;41;-897.7579,1298.01;Inherit;False;Tangent;1;0;FLOAT3;0,0,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;51;-1045.197,1673.863;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;74;-634.5532,2414.393;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;87;-266.4998,2842.573;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;106;-325.7811,-126.5737;Inherit;False;1210.127;635.2936;Couldn't get light to diminish when texels not lit;12;199;207;206;204;205;105;198;197;101;214;219;223;Emission;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;220;-459.9244,1562.455;Inherit;False;QuestionableShadows;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;223;-293.1196,113.2091;Inherit;False;220;QuestionableShadows;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;52;-869.197,1673.863;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;53;-981.1969,1801.863;Float;False;Property;_RimPower;Rim Power;10;0;Create;True;0;0;False;0;0.47;0;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.LightColorNode;37;-860.5242,1153.693;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleAddOpNode;43;-622.1936,1313.607;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;99;-416.353,2392.236;Inherit;True;Property;_Specularramp;Specular ramp;4;0;Create;True;0;0;False;0;-1;f662d9e61f860c7428cc30e072e1b6c4;f662d9e61f860c7428cc30e072e1b6c4;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;17;-165.0458,672.5758;Inherit;False;Shadow;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;92;-99.48232,2884.312;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;77;68.40207,2580.396;Inherit;False;Property;_SpecIntensity;Spec Intensity;14;0;Create;True;0;0;False;0;0.5352941;0.5117647;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;36;-870.2253,1046.906;Inherit;False;17;Shadow;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SaturateNode;219;-43.89359,127.0807;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;54;-677.197,1673.863;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;86;-85.70343,2409.813;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;46;-463.0366,1191.738;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;205;-187.1535,401.6318;Inherit;False;Property;_Emission_Max;Emission_Max ;20;0;Create;True;0;0;False;0;10;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;207;-192.6198,188.5333;Inherit;False;Constant;_Float3;Float 3;20;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;204;-194.1535,329.6318;Inherit;False;Property;_Emission_Min;Emission_Min;21;0;Create;True;0;0;False;0;0.1;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;206;-190.6198,256.5333;Inherit;False;Constant;_Float2;Float 2;20;0;Create;True;0;0;False;0;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;101;-240,-80;Inherit;True;Property;_Emission;Emission;19;0;Create;True;0;0;False;0;-1;1ba1aba94964cd944b671df306b01e27;1ba1aba94964cd944b671df306b01e27;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LightAttenuation;79;293.7867,2322.078;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;78;337.868,2426.742;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;58;-437.1968,1641.863;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LightColorNode;56;-407.4414,1957.374;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;38;-303.8639,1107.857;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ColorNode;57;-517.1972,1785.863;Float;False;Property;_RimColor;Rim Color;7;1;[HDR];Create;True;0;0;False;0;0,1,0.8758622,0;0,0,0,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;198;275.1832,-61.04233;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCRemapNode;199;119.48,153.751;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;196;173.0141,-1064.942;Inherit;False;Voidsparkles;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;214;417.7694,28.85424;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;60;-245.1968,1641.863;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;39;-161.8463,1102.853;Inherit;False;Lighting;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;59;-213.1968,1769.863;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;80;495.4758,2413.649;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;197;414.49,-72.69002;Inherit;False;196;Voidsparkles;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;81;683.7366,2418.822;Inherit;False;Spec;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;40;152.6266,1330.531;Inherit;False;39;Lighting;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RelayNode;225;189.7224,1133.049;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;61;-53.19688,1641.863;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;64;343.13,1425.497;Inherit;False;3;3;0;FLOAT4;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;105;592,-73;Inherit;False;Emission;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;83;300.5427,1598.564;Inherit;False;81;Spec;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;91;-680.506,3378.544;Inherit;True;Property;_LightColorSpecInfluence;Light Color Spec Influence;18;0;Create;True;0;0;False;0;0.4;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LightColorNode;89;-576.539,3253.147;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleAddOpNode;84;473.3699,1526.991;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.LerpOp;90;-363.4789,3132.549;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;185;441.0261,1089.869;Inherit;False;184;VoidAdded;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;104;447.2572,1164.427;Inherit;False;105;Emission;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;624,1088;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;Matt/ToonTear02;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0.014;0.245283,0.03818085,0.03818085,0;VertexOffset;False;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;118;0;116;0
WireConnection;119;0;187;0
WireConnection;119;1;188;0
WireConnection;122;0;118;0
WireConnection;126;0;119;0
WireConnection;126;1;188;0
WireConnection;127;0;121;4
WireConnection;127;1;120;0
WireConnection;127;2;120;0
WireConnection;125;0;187;0
WireConnection;135;0;124;0
WireConnection;135;2;127;0
WireConnection;135;1;127;0
WireConnection;136;0;123;0
WireConnection;136;2;129;0
WireConnection;131;0;126;0
WireConnection;132;0;128;0
WireConnection;132;2;130;0
WireConnection;133;0;119;0
WireConnection;139;0;132;0
WireConnection;139;2;134;0
WireConnection;138;0;135;0
WireConnection;138;2;133;0
WireConnection;137;0;136;0
WireConnection;137;2;131;0
WireConnection;141;0;137;0
WireConnection;140;0;139;0
WireConnection;142;0;138;0
WireConnection;143;0;140;0
WireConnection;143;1;142;0
WireConnection;144;0;141;0
WireConnection;148;0;140;0
WireConnection;148;1;143;0
WireConnection;148;2;144;0
WireConnection;159;0;148;0
WireConnection;165;0;159;0
WireConnection;154;0;152;0
WireConnection;154;2;153;0
WireConnection;160;0;150;0
WireConnection;160;2;149;0
WireConnection;169;0;165;0
WireConnection;169;1;164;0
WireConnection;169;2;163;0
WireConnection;156;0;151;0
WireConnection;156;2;146;0
WireConnection;162;0;160;0
WireConnection;162;1;155;0
WireConnection;166;0;156;0
WireConnection;166;1;158;0
WireConnection;161;0;154;0
WireConnection;161;1;157;0
WireConnection;23;0;22;0
WireConnection;172;0;169;0
WireConnection;194;0;176;0
WireConnection;167;0;161;0
WireConnection;167;1;162;0
WireConnection;167;2;166;0
WireConnection;179;0;175;0
WireConnection;170;0;167;0
WireConnection;170;1;168;1
WireConnection;170;2;168;2
WireConnection;190;0;194;0
WireConnection;2;0;26;0
WireConnection;30;0;29;0
WireConnection;30;1;28;0
WireConnection;174;0;170;0
WireConnection;3;0;2;0
WireConnection;3;1;4;0
WireConnection;191;0;190;0
WireConnection;191;1;179;0
WireConnection;31;0;30;0
WireConnection;192;0;191;0
WireConnection;8;0;27;0
WireConnection;9;0;3;0
WireConnection;182;0;177;0
WireConnection;182;1;178;0
WireConnection;182;2;176;0
WireConnection;181;0;192;0
WireConnection;181;1;189;0
WireConnection;7;0;8;0
WireConnection;7;1;6;0
WireConnection;10;0;7;0
WireConnection;69;0;70;0
WireConnection;183;0;182;0
WireConnection;183;1;181;0
WireConnection;20;0;14;0
WireConnection;20;1;21;0
WireConnection;20;2;21;0
WireConnection;68;0;66;0
WireConnection;68;1;67;1
WireConnection;65;0;20;0
WireConnection;184;0;183;0
WireConnection;71;0;68;0
WireConnection;71;1;69;0
WireConnection;19;1;65;0
WireConnection;72;0;71;0
WireConnection;72;1;73;0
WireConnection;50;0;62;0
WireConnection;50;1;49;0
WireConnection;55;0;42;0
WireConnection;55;1;63;0
WireConnection;35;0;34;0
WireConnection;35;1;19;0
WireConnection;41;0;44;0
WireConnection;51;0;50;0
WireConnection;74;0;72;0
WireConnection;74;1;75;0
WireConnection;74;2;76;0
WireConnection;87;0;85;0
WireConnection;220;0;55;0
WireConnection;52;0;51;0
WireConnection;43;0;41;0
WireConnection;43;1;42;0
WireConnection;99;1;74;0
WireConnection;17;0;35;0
WireConnection;92;0;87;0
WireConnection;92;1;88;0
WireConnection;219;0;223;0
WireConnection;54;0;52;0
WireConnection;54;1;53;0
WireConnection;86;0;99;0
WireConnection;86;1;92;0
WireConnection;46;0;37;0
WireConnection;46;1;43;0
WireConnection;78;0;86;0
WireConnection;78;1;77;0
WireConnection;58;0;55;0
WireConnection;58;1;54;0
WireConnection;38;0;36;0
WireConnection;38;1;46;0
WireConnection;198;0;101;0
WireConnection;199;0;219;0
WireConnection;199;1;207;0
WireConnection;199;2;206;0
WireConnection;199;3;204;0
WireConnection;199;4;205;0
WireConnection;196;0;182;0
WireConnection;214;0;198;0
WireConnection;214;1;199;0
WireConnection;60;0;58;0
WireConnection;39;0;38;0
WireConnection;59;0;57;0
WireConnection;59;1;56;0
WireConnection;80;0;79;0
WireConnection;80;1;78;0
WireConnection;81;0;80;0
WireConnection;225;0;214;0
WireConnection;61;0;60;0
WireConnection;61;1;59;0
WireConnection;64;0;40;0
WireConnection;64;1;61;0
WireConnection;64;2;225;0
WireConnection;105;0;197;0
WireConnection;84;0;64;0
WireConnection;84;1;83;0
WireConnection;90;0;88;0
WireConnection;90;1;89;0
WireConnection;90;2;91;0
WireConnection;0;0;185;0
WireConnection;0;2;104;0
WireConnection;0;13;84;0
ASEEND*/
//CHKSM=A273C8F14F1E01A9393E7F5822C186537FC7EED1