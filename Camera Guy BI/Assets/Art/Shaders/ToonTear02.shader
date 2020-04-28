// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ToonTear2"
{
	Properties
	{
		_ToonRamp("Toon Ramp", 2D) = "white" {}
		_VoidMask("Void Mask", 2D) = "black" {}
		_ShadowOffset("Shadow Offset", Range( 0 , 1)) = 0.42
		_Float1("Float 1", Float) = 1.38
		[HDR]_RimColor("Rim Color", Color) = (0,1,0.8758622,0)
		_NoiseMaskStepMax("Noise Mask Step Max", Range( 0 , 1)) = 0.2665786
		_NormalMap("Normal Map", 2D) = "bump" {}
		_NoiseMaskStepMin("Noise Mask Step Min", Range( 0 , 1)) = 0.05271714
		_RimPower("Rim Power", Range( 0 , 10)) = 0.47
		_Albedo("Albedo", 2D) = "white" {}
		_RimOffset("Rim Offset", Range( 0 , 1)) = 0.63
		[HDR]_AlbedoTint("Albedo Tint", Color) = (1,1,1,1)
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

		uniform float _Float1;
		uniform float _NoiseMaskStepMin;
		uniform float _NoiseMaskStepMax;
		uniform sampler2D _VoidMask;
		uniform float4 _VoidMask_ST;
		uniform float4 _AlbedoTint;
		uniform sampler2D _Albedo;
		uniform float4 _Albedo_ST;
		uniform sampler2D _Emission;
		uniform float4 _Emission_ST;
		uniform sampler2D _ToonRamp;
		uniform sampler2D _NormalMap;
		uniform float4 _NormalMap_ST;
		uniform float _ShadowOffset;
		uniform float _RimOffset;
		uniform float _RimPower;
		uniform float4 _RimColor;


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


		float2 voronoihash170( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi170( float2 v, float time, inout float2 id, float smoothness )
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
			 		float2 o = voronoihash170( n + g );
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


		float2 voronoihash169( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi169( float2 v, float time, inout float2 id, float smoothness )
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
			 		float2 o = voronoihash169( n + g );
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


		float2 voronoihash171( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi171( float2 v, float time, inout float2 id, float smoothness )
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
			 		float2 o = voronoihash171( n + g );
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
			float4 temp_cast_10 = (0.35).xxxx;
			float4 temp_cast_11 = (0.52).xxxx;
			float2 temp_cast_12 = (23.6).xx;
			float2 uv_TexCoord121 = i.uv_texcoord * temp_cast_12;
			float2 UVCoordinates122 = uv_TexCoord121;
			float2 panner133 = ( 1.0 * _Time.y * float2( 2,-2.5 ) + UVCoordinates122);
			float NoiseScale190 = _Float1;
			float simpleNoise136 = SimpleNoise( panner133*NoiseScale190 );
			float2 panner134 = ( 1.0 * _Time.y * float2( 3,1.8 ) + UVCoordinates122);
			float simpleNoise138 = SimpleNoise( panner134*NoiseScale190 );
			float2 panner135 = ( 1.0 * _Time.y * float2( 0,-1.2 ) + UVCoordinates122);
			float simpleNoise137 = SimpleNoise( panner135*NoiseScale190 );
			float4 appendResult139 = (float4(simpleNoise136 , simpleNoise138 , simpleNoise137 , 0.0));
			float4 smoothstepResult142 = smoothstep( temp_cast_10 , temp_cast_11 , appendResult139);
			float4 ColorNoise143 = smoothstepResult142;
			float time170 = 0.0;
			float2 panner167 = ( 1.0 * _Time.y * float2( 2,1 ) + UVCoordinates122);
			float2 coords170 = panner167 * NoiseScale190;
			float2 id170 = 0;
			float voroi170 = voronoi170( coords170, time170,id170, 0 );
			float temp_output_174_0 = ( 1.0 - voroi170 );
			float temp_output_187_0 = ( _Float1 + 0.0 );
			float time169 = 0.0;
			float temp_output_157_0 = (_SinTime.w*0.5 + 0.5);
			float2 temp_cast_13 = (temp_output_157_0).xx;
			float2 panner164 = ( temp_output_157_0 * temp_cast_13 + UVCoordinates122);
			float2 coords169 = panner164 * temp_output_187_0;
			float2 id169 = 0;
			float voroi169 = voronoi169( coords169, time169,id169, 0 );
			float time171 = 0.0;
			float2 panner166 = ( 1.0 * _Time.y * float2( -0.3,-0.2 ) + UVCoordinates122);
			float2 coords171 = panner166 * ( temp_output_187_0 + 0.0 );
			float2 id171 = 0;
			float voroi171 = voronoi171( coords171, time171,id171, 0 );
			float clampResult175 = clamp( ( 1.0 - voroi171 ) , 0.0 , 1.0 );
			float NoiseMask178 = ( temp_output_174_0 * ( temp_output_174_0 + ( 1.0 - voroi169 ) ) * clampResult175 );
			float clampResult180 = clamp( NoiseMask178 , 0.0 , 1.0 );
			float smoothstepResult184 = smoothstep( _NoiseMaskStepMin , _NoiseMaskStepMax , ( 1.0 - clampResult180 ));
			float NoiseMaskStepped185 = smoothstepResult184;
			float2 uv_VoidMask = i.uv_texcoord * _VoidMask_ST.xy + _VoidMask_ST.zw;
			float4 temp_output_151_0 = ( NoiseMaskStepped185 * tex2D( _VoidMask, uv_VoidMask ) );
			float4 Void198 = ( ColorNoise143 * temp_output_151_0 );
			float grayscale197 = Luminance(temp_output_151_0.rgb);
			float smoothstepResult194 = smoothstep( 0.0 , 0.2 , grayscale197);
			float2 uv_Albedo = i.uv_texcoord * _Albedo_ST.xy + _Albedo_ST.zw;
			float4 Albedo149 = ( Void198 + ( ( 1.0 - smoothstepResult194 ) * ( _AlbedoTint * tex2D( _Albedo, uv_Albedo ) ) ) );
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
			float4 Shadow17 = ( Albedo149 * tex2D( _ToonRamp, temp_cast_17 ) );
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
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float dotResult7 = dot( (WorldNormalVector( i , Normal23 )) , ase_worldViewDir );
			float normal_viewdir10 = dotResult7;
			c.rgb = ( Lighting39 + ( saturate( ( ( ase_lightAtten * normal_lightdir9 ) * pow( ( 1.0 - saturate( ( normal_viewdir10 + _RimOffset ) ) ) , _RimPower ) ) ) * ( _RimColor * ase_lightColor ) ) ).xyz;
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
			float4 temp_cast_0 = (0.35).xxxx;
			float4 temp_cast_1 = (0.52).xxxx;
			float2 temp_cast_2 = (23.6).xx;
			float2 uv_TexCoord121 = i.uv_texcoord * temp_cast_2;
			float2 UVCoordinates122 = uv_TexCoord121;
			float2 panner133 = ( 1.0 * _Time.y * float2( 2,-2.5 ) + UVCoordinates122);
			float NoiseScale190 = _Float1;
			float simpleNoise136 = SimpleNoise( panner133*NoiseScale190 );
			float2 panner134 = ( 1.0 * _Time.y * float2( 3,1.8 ) + UVCoordinates122);
			float simpleNoise138 = SimpleNoise( panner134*NoiseScale190 );
			float2 panner135 = ( 1.0 * _Time.y * float2( 0,-1.2 ) + UVCoordinates122);
			float simpleNoise137 = SimpleNoise( panner135*NoiseScale190 );
			float4 appendResult139 = (float4(simpleNoise136 , simpleNoise138 , simpleNoise137 , 0.0));
			float4 smoothstepResult142 = smoothstep( temp_cast_0 , temp_cast_1 , appendResult139);
			float4 ColorNoise143 = smoothstepResult142;
			float time170 = 0.0;
			float2 panner167 = ( 1.0 * _Time.y * float2( 2,1 ) + UVCoordinates122);
			float2 coords170 = panner167 * NoiseScale190;
			float2 id170 = 0;
			float voroi170 = voronoi170( coords170, time170,id170, 0 );
			float temp_output_174_0 = ( 1.0 - voroi170 );
			float temp_output_187_0 = ( _Float1 + 0.0 );
			float time169 = 0.0;
			float temp_output_157_0 = (_SinTime.w*0.5 + 0.5);
			float2 temp_cast_3 = (temp_output_157_0).xx;
			float2 panner164 = ( temp_output_157_0 * temp_cast_3 + UVCoordinates122);
			float2 coords169 = panner164 * temp_output_187_0;
			float2 id169 = 0;
			float voroi169 = voronoi169( coords169, time169,id169, 0 );
			float time171 = 0.0;
			float2 panner166 = ( 1.0 * _Time.y * float2( -0.3,-0.2 ) + UVCoordinates122);
			float2 coords171 = panner166 * ( temp_output_187_0 + 0.0 );
			float2 id171 = 0;
			float voroi171 = voronoi171( coords171, time171,id171, 0 );
			float clampResult175 = clamp( ( 1.0 - voroi171 ) , 0.0 , 1.0 );
			float NoiseMask178 = ( temp_output_174_0 * ( temp_output_174_0 + ( 1.0 - voroi169 ) ) * clampResult175 );
			float clampResult180 = clamp( NoiseMask178 , 0.0 , 1.0 );
			float smoothstepResult184 = smoothstep( _NoiseMaskStepMin , _NoiseMaskStepMax , ( 1.0 - clampResult180 ));
			float NoiseMaskStepped185 = smoothstepResult184;
			float2 uv_VoidMask = i.uv_texcoord * _VoidMask_ST.xy + _VoidMask_ST.zw;
			float4 temp_output_151_0 = ( NoiseMaskStepped185 * tex2D( _VoidMask, uv_VoidMask ) );
			float4 Void198 = ( ColorNoise143 * temp_output_151_0 );
			float grayscale197 = Luminance(temp_output_151_0.rgb);
			float smoothstepResult194 = smoothstep( 0.0 , 0.2 , grayscale197);
			float2 uv_Albedo = i.uv_texcoord * _Albedo_ST.xy + _Albedo_ST.zw;
			float4 Albedo149 = ( Void198 + ( ( 1.0 - smoothstepResult194 ) * ( _AlbedoTint * tex2D( _Albedo, uv_Albedo ) ) ) );
			o.Albedo = Albedo149.xyz;
			float2 uv_Emission = i.uv_texcoord * _Emission_ST.xy + _Emission_ST.zw;
			float4 tex2DNode101 = tex2D( _Emission, uv_Emission );
			float4 Emission105 = ( tex2DNode101 + Void198 );
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
292;73;1176;410;1317.973;-1733.857;2.294841;True;True
Node;AmplifyShaderEditor.CommentaryNode;191;-3622.482,-2005.477;Inherit;False;5063.92;2515.659;Comment;10;148;149;114;115;123;116;120;118;117;199;Void;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;117;-2816.44,-1322.273;Inherit;False;758.759;211.5623;Comment;3;122;121;119;UV scale and Coords;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;118;-3572.482,-528.1353;Inherit;False;683.9546;409.1208;Comment;5;190;189;188;187;186;noise inputs;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;119;-2766.44,-1249.495;Inherit;False;Constant;_Float0;Float 0;15;0;Create;True;0;0;False;0;23.6;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;120;-2835.868,-1066.121;Inherit;False;1954.203;1012.36;Comment;24;178;177;176;175;174;173;172;171;170;169;168;167;166;165;164;163;162;161;160;159;158;157;156;155;Noise Mask;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;121;-2552.675,-1269.711;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;186;-3508.484,-480.1356;Inherit;False;Property;_Float1;Float 1;3;0;Create;True;0;0;False;0;1.38;1.38;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;122;-2283.683,-1272.273;Inherit;False;UVCoordinates;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RelayNode;188;-3283.129,-244.0399;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;187;-3287.893,-385.8354;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;156;-2755.079,-572.8876;Inherit;False;Constant;_Float2;Float 2;5;0;Create;True;0;0;False;0;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SinTimeNode;155;-2755.079,-716.8879;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;159;-2565.245,-364.8876;Inherit;False;122;UVCoordinates;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;190;-3287.587,-478.951;Inherit;False;NoiseScale;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;157;-2567.692,-625.3581;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;160;-2579.08,-972.8871;Inherit;False;122;UVCoordinates;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;158;-2583.692,-705.3581;Inherit;False;122;UVCoordinates;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;189;-3135.188,-268.2511;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;162;-2533.245,-284.8876;Inherit;False;Constant;_Vector7;Vector 7;1;0;Create;True;0;0;False;0;-0.3,-0.2;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;161;-2526.518,-896.1558;Inherit;False;Constant;_Vector6;Vector 6;1;0;Create;True;0;0;False;0;2,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.GetLocalVarNode;168;-2307.081,-844.8876;Inherit;False;190;NoiseScale;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;164;-2311.693,-705.3581;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;167;-2307.081,-972.8871;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RelayNode;165;-2517.245,-124.8879;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;166;-2309.245,-364.8876;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RelayNode;163;-2509.165,-479.8489;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;170;-2115.081,-972.8871;Inherit;True;0;0;1;0;1;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;2;FLOAT;0;FLOAT;1
Node;AmplifyShaderEditor.VoronoiNode;171;-2117.246,-300.8876;Inherit;True;0;0;1;0;1;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;2;FLOAT;0;FLOAT;1
Node;AmplifyShaderEditor.VoronoiNode;169;-2119.693,-657.3581;Inherit;True;0;0;1;0;1;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;2;FLOAT;0;FLOAT;1
Node;AmplifyShaderEditor.OneMinusNode;174;-1859.081,-972.8871;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;173;-1863.693,-657.3581;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;172;-1861.246,-300.8876;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;176;-1661.775,-821.4164;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;175;-1682.526,-300.3495;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;177;-1438.365,-866.2628;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;178;-1198.253,-818.4427;Inherit;False;NoiseMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;116;-1944.782,-7.671892;Inherit;False;1063.486;485.1113;Comment;7;185;184;183;182;181;180;179;Noise Mask Step;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;123;-1526.391,-1955.476;Inherit;False;1514.79;789.356;Comment;20;143;142;141;140;139;138;137;136;135;134;133;132;131;130;129;128;127;126;125;124;Colour;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;179;-1894.782,119.6858;Inherit;False;178;NoiseMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;128;-1438.411,-1825.12;Inherit;False;Constant;_Vector1;Vector 1;15;0;Create;True;0;0;False;0;2,-2.5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;125;-1436.392,-1346.12;Inherit;False;Constant;_Vector8;Vector 8;15;0;Create;True;0;0;False;0;0,-1.2;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.GetLocalVarNode;124;-1476.391,-1905.12;Inherit;False;122;UVCoordinates;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;127;-1430.392,-1585.12;Inherit;False;Constant;_Vector4;Vector 4;15;0;Create;True;0;0;False;0;3,1.8;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.GetLocalVarNode;126;-1472.391,-1665.12;Inherit;False;122;UVCoordinates;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ClampOpNode;180;-1697.166,122.7284;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;129;-1476.391,-1425.12;Inherit;False;122;UVCoordinates;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;134;-1220.391,-1665.12;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;135;-1220.391,-1425.12;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;133;-1220.391,-1905.12;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;130;-1220.391,-1777.12;Inherit;False;190;NoiseScale;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;131;-1220.391,-1537.12;Inherit;False;190;NoiseScale;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;181;-1641.971,253.5425;Inherit;False;Property;_NoiseMaskStepMin;Noise Mask Step Min;7;0;Create;True;0;0;False;0;0.05271714;0.81;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;183;-1543.064,42.32813;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;182;-1640.149,341.8484;Inherit;False;Property;_NoiseMaskStepMax;Noise Mask Step Max;5;0;Create;True;0;0;False;0;0.2665786;0.87;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;132;-1220.391,-1297.121;Inherit;False;190;NoiseScale;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;136;-1023.699,-1905.476;Inherit;True;Simple;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;137;-1028.391,-1425.12;Inherit;True;Simple;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;138;-1028.391,-1665.12;Inherit;True;Simple;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;184;-1339.793,191.7717;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;45;-3204.567,1747.39;Inherit;False;578;280;Comment;2;22;23;Normal Map;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;22;-3156.567,1811.39;Inherit;True;Property;_NormalMap;Normal Map;6;0;Create;True;0;0;False;0;-1;None;c9a1daa61a9c521419e68e8063c897dd;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;141;-741.1434,-1397.106;Inherit;False;Constant;_Float6;Float 6;5;0;Create;True;0;0;False;0;0.52;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;185;-1098.683,203.2243;Inherit;False;NoiseMaskStepped;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;139;-725.1154,-1705.363;Inherit;True;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;114;-834.0524,-1071.446;Inherit;False;1203.177;458.7488;Comment;6;150;153;154;152;151;198;Void Mask;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;140;-739.1434,-1477.106;Inherit;False;Constant;_Float5;Float 5;5;0;Create;True;0;0;False;0;0.35;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;142;-478.8826,-1567.283;Inherit;True;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT4;1,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;13;-2516.567,1523.39;Inherit;False;914.7421;388.3284;;5;9;3;2;4;26;Normal.LightDir;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;23;-2852.567,1811.39;Inherit;False;Normal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;153;-792.0998,-814.3094;Inherit;True;Property;_VoidMask;Void Mask;1;0;Create;True;0;0;False;0;-1;220f8d46e4e5dc241b9b5323228dd6b7;220f8d46e4e5dc241b9b5323228dd6b7;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;154;-715.6703,-1003.969;Inherit;True;185;NoiseMaskStepped;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;115;-320.2249,-497.6689;Inherit;False;1246.671;815.6381;Comment;9;146;144;30;29;28;194;196;195;197;Albedo;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;143;-217.0328,-1527.822;Inherit;False;ColorNoise;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;26;-2484.567,1571.39;Inherit;False;23;Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;151;-465.1467,-938.7388;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCGrayscale;197;-174.8146,-456.6276;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;152;-433.9457,-1021.446;Inherit;False;143;ColorNoise;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;12;-2507.605,1923.39;Inherit;False;900.4607;403.9955;;5;10;7;8;6;27;Normal.ViewDir;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldNormalVector;2;-2196.567,1571.39;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;195;-282.2702,-368.5501;Inherit;False;Constant;_SmoothStepAlbedoMaskMin;SmoothStep Albedo Mask Min;15;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;4;-2196.567,1715.39;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;196;-280.4724,-296.6432;Inherit;False;Constant;_SmoothStepAlbedoMaskMax;SmoothStep Albedo Mask Max;15;0;Create;True;0;0;False;0;0.2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;194;32.77641,-448.7959;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;28;-268.8629,-3.463803;Inherit;True;Property;_Albedo;Albedo;9;0;Create;True;0;0;False;0;-1;64e7766099ad46747a07014e44d0aea1;64e7766099ad46747a07014e44d0aea1;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;29;-205.8633,-188.4636;Inherit;False;Property;_AlbedoTint;Albedo Tint;11;1;[HDR];Create;True;0;0;False;0;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DotProductOpNode;3;-1956.567,1619.39;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;27;-2475.605,1971.39;Inherit;False;23;Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;150;-144.8893,-945.8041;Inherit;True;2;2;0;FLOAT4;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;6;-2187.605,2131.391;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RegisterLocalVarNode;9;-1812.567,1667.39;Inherit;False;normal_lightdir;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;198;81.00063,-947.7772;Inherit;False;Void;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.OneMinusNode;146;253.628,-451.6761;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;107.238,-131.6;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WorldNormalVector;8;-2187.605,1971.39;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;24;-1178.529,550.7029;Inherit;False;1111.259;400.8853;;8;34;35;17;19;20;21;14;65;Shadow;1,1,1,1;0;0
Node;AmplifyShaderEditor.DotProductOpNode;7;-1947.604,2051.39;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;14;-1128.529,628.2739;Inherit;False;9;normal_lightdir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;21;-1211.988,706.7388;Inherit;False;Property;_ShadowOffset;Shadow Offset;2;0;Create;True;0;0;False;0;0.42;0.42;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;144;500.3718,-440.2541;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;199;589.8347,-812.0452;Inherit;False;198;Void;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;10;-1819.604,2035.39;Inherit;False;normal_viewdir;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;148;788.0864,-807.9766;Inherit;True;2;2;0;FLOAT4;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;20;-927.2884,628.8386;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;48;-1493.197,1513.863;Inherit;False;1591.003;586.1711;;15;56;61;60;59;58;57;54;55;53;63;52;51;50;49;62;Rim Light;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;47;-1184.801,970.759;Inherit;False;1184.867;526.6386;Comment;9;37;36;42;43;41;44;46;38;39;Attenuation and Ambient;1,1,1,1;0;0
Node;AmplifyShaderEditor.SaturateNode;65;-864.6343,808.0518;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;62;-1447.529,1630.967;Inherit;False;10;normal_viewdir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;149;1040.894,-793.6595;Inherit;False;Albedo;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;49;-1473.814,1750.62;Float;False;Property;_RimOffset;Rim Offset;10;0;Create;True;0;0;False;0;0.63;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;19;-731.0452,742.7963;Inherit;True;Property;_ToonRamp;Toon Ramp;0;0;Create;True;0;0;False;0;-1;14656c99dff77cb4ba68513ede2b1cb9;14656c99dff77cb4ba68513ede2b1cb9;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;44;-1134.801,1292.618;Inherit;False;23;Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;34;-609.5299,641.4211;Inherit;False;149;Albedo;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;50;-1205.197,1673.863;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LightAttenuation;42;-943.2075,1386.397;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;51;-1045.197,1673.863;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.IndirectDiffuseLighting;41;-959.8455,1298.01;Inherit;False;Tangent;1;0;FLOAT3;0,0,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;-421.6051,689.7159;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;17;-267.3083,698.1414;Inherit;False;Shadow;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;53;-981.1969,1801.863;Float;False;Property;_RimPower;Rim Power;8;0;Create;True;0;0;False;0;0.47;0;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.LightColorNode;37;-922.6119,1153.693;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.OneMinusNode;52;-869.197,1673.863;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;63;-924.0463,1578.756;Inherit;False;9;normal_lightdir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;43;-684.2814,1313.607;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;46;-525.1245,1191.738;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;36;-932.313,1046.906;Inherit;False;17;Shadow;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;55;-693.197,1561.863;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;54;-677.197,1673.863;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;106;-844.9777,2149.301;Inherit;False;1278.403;489.1693;Couldn't get light to diminish when texels not lit;9;102;111;108;112;113;105;101;201;202;Emission;1,1,1,1;0;0
Node;AmplifyShaderEditor.ColorNode;57;-517.1972,1785.863;Float;False;Property;_RimColor;Rim Color;4;1;[HDR];Create;True;0;0;False;0;0,1,0.8758622,0;0,0,0,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LightColorNode;56;-407.4414,1957.374;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;58;-437.1968,1641.863;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;38;-365.9515,1107.857;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SamplerNode;101;-779.8552,2195.875;Inherit;True;Property;_Emission;Emission;12;0;Create;True;0;0;False;0;-1;7a170cdb7cc88024cb628cfcdbb6705c;7a170cdb7cc88024cb628cfcdbb6705c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;201;-236.6369,2391.895;Inherit;False;198;Void;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;39;-223.9342,1102.853;Inherit;False;Lighting;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;202;-35.45647,2210.977;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;60;-245.1968,1641.863;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;59;-213.1968,1769.863;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;105;156.8829,2201.892;Inherit;False;Emission;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;40;125.9109,1363.926;Inherit;False;39;Lighting;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;61;-53.19688,1641.863;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;104;447.2572,1164.427;Inherit;False;105;Emission;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;112;-516.6464,2520.735;Inherit;False;Property;_EmissionOffset;Emission Offset;13;0;Create;True;0;0;False;0;0.5;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;64;343.13,1425.497;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;113;-820.5343,2504.477;Inherit;False;Property;_EmissionBrightness;Emission Brightness;14;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;102;-280.151,2275.599;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;33;385.7717,1069.479;Inherit;False;149;Albedo;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;108;-633.4104,2400.38;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;111;-400.2552,2357.275;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;624,1088;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;ToonTear2;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0.014;0.245283,0.03818085,0.03818085,0;VertexOffset;False;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;121;0;119;0
WireConnection;122;0;121;0
WireConnection;187;0;186;0
WireConnection;190;0;186;0
WireConnection;157;0;155;4
WireConnection;157;1;156;0
WireConnection;157;2;156;0
WireConnection;189;0;187;0
WireConnection;189;1;188;0
WireConnection;164;0;158;0
WireConnection;164;2;157;0
WireConnection;164;1;157;0
WireConnection;167;0;160;0
WireConnection;167;2;161;0
WireConnection;165;0;189;0
WireConnection;166;0;159;0
WireConnection;166;2;162;0
WireConnection;163;0;187;0
WireConnection;170;0;167;0
WireConnection;170;2;168;0
WireConnection;171;0;166;0
WireConnection;171;2;165;0
WireConnection;169;0;164;0
WireConnection;169;2;163;0
WireConnection;174;0;170;0
WireConnection;173;0;169;0
WireConnection;172;0;171;0
WireConnection;176;0;174;0
WireConnection;176;1;173;0
WireConnection;175;0;172;0
WireConnection;177;0;174;0
WireConnection;177;1;176;0
WireConnection;177;2;175;0
WireConnection;178;0;177;0
WireConnection;180;0;179;0
WireConnection;134;0;126;0
WireConnection;134;2;127;0
WireConnection;135;0;129;0
WireConnection;135;2;125;0
WireConnection;133;0;124;0
WireConnection;133;2;128;0
WireConnection;183;0;180;0
WireConnection;136;0;133;0
WireConnection;136;1;130;0
WireConnection;137;0;135;0
WireConnection;137;1;132;0
WireConnection;138;0;134;0
WireConnection;138;1;131;0
WireConnection;184;0;183;0
WireConnection;184;1;181;0
WireConnection;184;2;182;0
WireConnection;185;0;184;0
WireConnection;139;0;136;0
WireConnection;139;1;138;0
WireConnection;139;2;137;0
WireConnection;142;0;139;0
WireConnection;142;1;140;0
WireConnection;142;2;141;0
WireConnection;23;0;22;0
WireConnection;143;0;142;0
WireConnection;151;0;154;0
WireConnection;151;1;153;0
WireConnection;197;0;151;0
WireConnection;2;0;26;0
WireConnection;194;0;197;0
WireConnection;194;1;195;0
WireConnection;194;2;196;0
WireConnection;3;0;2;0
WireConnection;3;1;4;0
WireConnection;150;0;152;0
WireConnection;150;1;151;0
WireConnection;9;0;3;0
WireConnection;198;0;150;0
WireConnection;146;0;194;0
WireConnection;30;0;29;0
WireConnection;30;1;28;0
WireConnection;8;0;27;0
WireConnection;7;0;8;0
WireConnection;7;1;6;0
WireConnection;144;0;146;0
WireConnection;144;1;30;0
WireConnection;10;0;7;0
WireConnection;148;0;199;0
WireConnection;148;1;144;0
WireConnection;20;0;14;0
WireConnection;20;1;21;0
WireConnection;20;2;21;0
WireConnection;65;0;20;0
WireConnection;149;0;148;0
WireConnection;19;1;65;0
WireConnection;50;0;62;0
WireConnection;50;1;49;0
WireConnection;51;0;50;0
WireConnection;41;0;44;0
WireConnection;35;0;34;0
WireConnection;35;1;19;0
WireConnection;17;0;35;0
WireConnection;52;0;51;0
WireConnection;43;0;41;0
WireConnection;43;1;42;0
WireConnection;46;0;37;0
WireConnection;46;1;43;0
WireConnection;55;0;42;0
WireConnection;55;1;63;0
WireConnection;54;0;52;0
WireConnection;54;1;53;0
WireConnection;58;0;55;0
WireConnection;58;1;54;0
WireConnection;38;0;36;0
WireConnection;38;1;46;0
WireConnection;39;0;38;0
WireConnection;202;0;101;0
WireConnection;202;1;201;0
WireConnection;60;0;58;0
WireConnection;59;0;57;0
WireConnection;59;1;56;0
WireConnection;105;0;202;0
WireConnection;61;0;60;0
WireConnection;61;1;59;0
WireConnection;64;0;40;0
WireConnection;64;1;61;0
WireConnection;102;0;101;0
WireConnection;102;1;111;0
WireConnection;108;1;113;0
WireConnection;111;0;108;0
WireConnection;111;1;112;0
WireConnection;0;0;33;0
WireConnection;0;2;104;0
WireConnection;0;13;64;0
ASEEND*/
//CHKSM=2DA59D853258CB5C823C308D061BBCABEE01847E