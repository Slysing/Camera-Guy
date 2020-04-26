// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ToonTear1"
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
		#include "UnityCG.cginc"
		#include "UnityShaderVariables.cginc"
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
		uniform sampler2D _Specularramp;
		uniform float _Gloss;
		uniform sampler2D _AntiSpecMap;
		uniform float4 _AntiSpecMap_ST;
		uniform float4 _SpecularityColor;
		uniform float _SpecIntensity;

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
			float2 temp_cast_2 = (saturate( (normal_lightdir9*_ShadowOffset + _ShadowOffset) )).xx;
			float4 Shadow17 = ( Albedo31 * tex2D( _ToonRamp, temp_cast_2 ) );
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
			float dotResult71 = dot( ( ase_worldViewDir + _WorldSpaceLightPos0.xyz ) , (WorldNormalVector( i , Normal23 )) );
			float smoothstepResult74 = smoothstep( 1.07 , 1.79 , pow( dotResult71 , _Gloss ));
			float2 temp_cast_4 = (smoothstepResult74).xx;
			float2 uv_AntiSpecMap = i.uv_texcoord * _AntiSpecMap_ST.xy + _AntiSpecMap_ST.zw;
			float4 Spec81 = ( ase_lightAtten * ( ( tex2D( _Specularramp, temp_cast_4 ) * ( ( 1.0 - tex2D( _AntiSpecMap, uv_AntiSpecMap ) ) * _SpecularityColor ) ) * _SpecIntensity ) );
			c.rgb = ( ( Lighting39 + ( saturate( ( ( ase_lightAtten * normal_lightdir9 ) * pow( ( 1.0 - saturate( ( normal_viewdir10 + _RimOffset ) ) ) , _RimPower ) ) ) * ( _RimColor * ase_lightColor ) ) ) + Spec81 ).rgb;
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
			float2 uv_Emission = i.uv_texcoord * _Emission_ST.xy + _Emission_ST.zw;
			float4 tex2DNode101 = tex2D( _Emission, uv_Emission );
			float4 Emission105 = tex2DNode101;
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
326;73;1316;515;3340.468;748.1277;5.03648;True;True
Node;AmplifyShaderEditor.CommentaryNode;45;-2734.699,172.4961;Inherit;False;578;280;Comment;2;22;23;Normal Map;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;22;-2684.699,222.4961;Inherit;True;Property;_NormalMap;Normal Map;9;0;Create;True;0;0;False;0;-1;None;c9a1daa61a9c521419e68e8063c897dd;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;23;-2380.699,230.4961;Inherit;False;Normal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;26;-2022.817,-17.84793;Inherit;False;23;Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;13;-1780.536,-64.31284;Inherit;False;655.2222;382.1494;;4;3;9;4;2;Normal.LightDir;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;4;-1726.026,134.8367;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldNormalVector;2;-1730.536,-14.31284;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DotProductOpNode;3;-1481.963,31.45884;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;27;-2012.498,392.4365;Inherit;False;23;Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;12;-1781.46,337.6487;Inherit;False;640.9408;400.906;;4;8;6;7;10;Normal.ViewDir;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;96;-1515.906,2159.233;Inherit;False;2423.643;554.0854;Comment;18;74;75;76;72;73;71;68;69;70;66;67;99;81;80;79;78;77;86;Specular;1,1,1,1;0;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;6;-1730.377,550.5546;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldNormalVector;8;-1731.46,387.6487;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RegisterLocalVarNode;9;-1349.313,85.10046;Inherit;False;normal_lightdir;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;32;-1083.679,-138.8427;Inherit;False;712;465;Comment;4;28;29;30;31;Albedo;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;24;-1076.267,525.1374;Inherit;False;1111.259;400.8853;;8;34;35;17;19;20;21;14;65;Shadow;1,1,1,1;0;0
Node;AmplifyShaderEditor.ColorNode;29;-970.6782,-88.84294;Inherit;False;Property;_AlbedoTint;Albedo Tint;14;1;[HDR];Create;True;0;0;False;0;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;21;-1000.726,680.1732;Inherit;False;Property;_ShadowOffset;Shadow Offset;4;0;Create;True;0;0;False;0;0;0.42;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;28;-1033.678,96.15681;Inherit;True;Property;_Albedo;Albedo;12;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;70;-1469.123,2500.354;Inherit;False;23;Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldSpaceLightPos;67;-1486.516,2375.813;Inherit;False;0;3;FLOAT4;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.DotProductOpNode;7;-1492.822,465.189;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;14;-1026.267,602.7084;Inherit;False;9;normal_lightdir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;66;-1420.516,2213.813;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;-736.6782,32.15677;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;10;-1364.519,455.8388;Inherit;False;normal_viewdir;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;48;-1493.197,1513.863;Inherit;False;1591.003;586.1711;;15;56;61;60;59;58;57;54;55;53;63;52;51;50;49;62;Rim Light;1,1,1,1;0;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;20;-825.0261,603.2731;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;69;-1267.729,2487.438;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;68;-1230.307,2294.819;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;62;-1447.529,1630.967;Inherit;False;10;normal_viewdir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;71;-1030.123,2417.354;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;47;-1122.713,970.759;Inherit;False;1184.867;526.6386;Comment;9;37;36;42;43;41;44;46;38;39;Attenuation and Ambient;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;73;-1072.841,2557.071;Inherit;False;Property;_Gloss;Gloss;17;0;Create;True;0;0;False;0;0.33;0.33;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;65;-762.3721,782.4862;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;49;-1473.814,1750.62;Float;False;Property;_RimOffset;Rim Offset;13;0;Create;True;0;0;False;0;0.63;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;97;-730.506,2792.573;Inherit;False;793.0237;844.9717;Comment;7;89;91;85;87;92;90;88;Specular colour and roughness;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;31;-595.6782,36.15678;Inherit;False;Albedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;19;-628.7829,717.2307;Inherit;True;Property;_ToonRamp;Toon Ramp;0;0;Create;True;0;0;False;0;-1;f662d9e61f860c7428cc30e072e1b6c4;14656c99dff77cb4ba68513ede2b1cb9;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;76;-798.0164,2597.319;Inherit;False;Constant;_max;max;12;0;Create;True;0;0;False;0;1.79;1.12;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;75;-802.1953,2520.104;Inherit;False;Constant;_min;min;9;0;Create;True;0;0;False;0;1.07;1.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;85;-583.5135,2845.275;Inherit;True;Property;_AntiSpecMap;Anti-Spec Map;16;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;44;-1072.713,1292.618;Inherit;False;23;Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;34;-505.2676,631.925;Inherit;False;31;Albedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;50;-1205.197,1673.863;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;72;-824.1228,2416.354;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.IndirectDiffuseLighting;41;-897.7579,1298.01;Inherit;False;Tangent;1;0;FLOAT3;0,0,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;88;-624.0684,3055.784;Inherit;False;Property;_SpecularityColor;Specularity Color;18;0;Create;True;0;0;False;0;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;87;-266.4998,2842.573;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;51;-1045.197,1673.863;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LightAttenuation;42;-881.1199,1386.397;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;74;-634.5532,2414.393;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;-319.3426,664.1503;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;43;-622.1936,1313.607;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;99;-416.353,2392.236;Inherit;True;Property;_Specularramp;Specular ramp;3;0;Create;True;0;0;False;0;-1;f662d9e61f860c7428cc30e072e1b6c4;f662d9e61f860c7428cc30e072e1b6c4;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;92;-99.48232,2884.312;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;52;-869.197,1673.863;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;17;-165.0458,672.5758;Inherit;False;Shadow;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;63;-924.0463,1578.756;Inherit;False;9;normal_lightdir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LightColorNode;37;-860.5242,1153.693;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;53;-981.1969,1801.863;Float;False;Property;_RimPower;Rim Power;11;0;Create;True;0;0;False;0;0.47;0;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;86;-85.70343,2409.813;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;36;-870.2253,1046.906;Inherit;False;17;Shadow;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;77;68.40207,2580.396;Inherit;False;Property;_SpecIntensity;Spec Intensity;15;0;Create;True;0;0;False;0;0.5352941;0.5117647;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;55;-693.197,1561.863;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;54;-677.197,1673.863;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;46;-463.0366,1191.738;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;78;337.868,2426.742;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;57;-517.1972,1785.863;Float;False;Property;_RimColor;Rim Color;7;1;[HDR];Create;True;0;0;False;0;0,1,0.8758622,0;0,0,0,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;58;-437.1968,1641.863;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;38;-303.8639,1107.857;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LightColorNode;56;-407.4414,1957.374;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.LightAttenuation;79;293.7867,2322.078;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;80;495.4758,2413.649;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;60;-245.1968,1641.863;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;106;-305.1224,-126.5737;Inherit;False;931.436;483.1525;Couldn't get light to diminish when texels not lit;7;108;102;105;101;111;112;113;Emission;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;39;-161.8463,1102.853;Inherit;False;Lighting;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;59;-213.1968,1769.863;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;101;-240,-80;Inherit;True;Property;_Emission;Emission;20;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;81;683.7366,2418.822;Inherit;False;Spec;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;40;152.6266,1330.531;Inherit;False;39;Lighting;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;61;-53.19688,1641.863;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;145;-410.7643,-1043.391;Inherit;False;1334.885;770.3864;Comment;10;164;163;159;158;157;154;151;150;149;146;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;105;432,-80;Inherit;False;Emission;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;115;-1488.021,-1588.183;Inherit;False;403.5017;264.0882;Comment;3;124;119;117;noise inputs;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;64;343.13,1425.497;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;83;300.5427,1598.564;Inherit;False;81;Spec;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;146;325.9127,-744.8998;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;135;-280.5743,-2070.399;Inherit;False;Constant;_Vector3;Vector 2;15;0;Create;True;0;0;False;0;3,1.8;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.NoiseGeneratorNode;144;80.72668,-2056.088;Inherit;True;Simple;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;143;79.12769,-1835.008;Inherit;True;Simple;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;142;83.42566,-2281.898;Inherit;True;Simple;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;147;399.4259,-2073.399;Inherit;True;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ColorNode;140;-72.64734,-1048.143;Inherit;False;Constant;_Color2;Color 1;3;0;Create;True;0;0;False;0;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;139;-102.5753,-2244.898;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;138;-95.27429,-2019.088;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SmoothstepOpNode;137;87.88074,-1434.469;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;136;-96.87231,-1899.008;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RelayNode;141;402.9872,-1434.017;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;128;-208.3363,-1558.149;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;153;881.9996,-1490.757;Inherit;True;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;150;484.4848,-740.5571;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RelayNode;134;-538.1183,-2041.152;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SmoothstepOpNode;152;580.6573,-1693.513;Inherit;True;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT4;1,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.StepOpNode;164;-88.93933,-861.9916;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;154;762.1219,-641.0046;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;155;1116.351,-1219.097;Inherit;True;2;2;0;FLOAT4;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;156;1275.529,-1441.208;Inherit;False;Void;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SamplerNode;157;-384.0353,-966.7947;Inherit;True;Property;_Emission1;Emission;1;0;Create;True;0;0;False;0;-1;220f8d46e4e5dc241b9b5323228dd6b7;220f8d46e4e5dc241b9b5323228dd6b7;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;158;471.8898,-387.8801;Inherit;True;Property;_TextureSample1;Texture Sample 0;6;0;Create;True;0;0;False;0;-1;14656c99dff77cb4ba68513ede2b1cb9;14656c99dff77cb4ba68513ede2b1cb9;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;159;-240.3513,-764.0621;Inherit;False;Constant;_Float2;Float 1;15;0;Create;True;0;0;False;0;0.01;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;161;559.9951,-1387.964;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;162;-534.4783,-1338.416;Inherit;True;Simple;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;148;341.4197,-1633.355;Inherit;False;Constant;_Vector2;Vector 1;15;0;Create;True;0;0;False;0;0.35,0.52;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.ColorNode;151;241.7808,-466.3987;Inherit;False;Constant;_Color1;Color 0;15;0;Create;True;0;0;False;0;0,0.3962264,0.02598071,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;133;-276.3013,-1298.856;Inherit;False;Property;_SmoothStepMax1;SmoothStep Max;8;0;Create;True;0;0;False;0;0.87;0.87;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;129;-288.8723,-1819.008;Inherit;False;Constant;_Pan1;Pan;15;0;Create;True;0;0;False;0;0,-1.2;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;131;-62.13928,-1479.857;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;149;126.4327,-861.9161;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;108;-93.55522,124.5051;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;113;-280.679,228.6018;Inherit;False;Property;_EmissionBrightness;Emission Brightness;22;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;111;139.6001,81.40002;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;112;23.20872,244.8605;Inherit;False;Property;_EmissionOffset;Emission Offset;21;0;Create;True;0;0;False;0;0.5;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;104;447.2572,1164.427;Inherit;False;105;Emission;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.LightColorNode;89;-576.539,3253.147;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;91;-680.506,3378.544;Inherit;True;Property;_LightColorSpecInfluence;Light Color Spec Influence;19;0;Create;True;0;0;False;0;0.4;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;33;448,1088;Inherit;False;31;Albedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;90;-363.4789,3132.549;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector2Node;132;-284.5743,-2233.399;Inherit;False;Constant;_Vector1;Vector 0;15;0;Create;True;0;0;False;0;2,-2.5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleAddOpNode;84;473.3699,1526.991;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;102;255.8042,-6.775561;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;160;-515.7953,-1752.928;Inherit;True;Simple;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;114;-1496.652,-2025.188;Inherit;False;Constant;_Tiling1;Tiling;15;0;Create;True;0;0;False;0;23.6;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;118;-996.7162,-1647.843;Inherit;False;Constant;_Vector4;Vector 3;1;0;Create;True;0;0;False;0;2,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;119;-1426.934,-1538.183;Inherit;False;Property;_noisescale1;noise scale;5;0;Create;True;0;0;False;0;1.38;1.38;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RelayNode;120;-954.1183,-2041.152;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;163;126.7277,-570.8284;Inherit;False;AntiVoidMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;122;-752.4164,-1664.085;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;123;-732.1044,-1364.895;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;124;-1236.52,-1459.094;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;125;-506.8953,-1531.787;Inherit;True;0;0;1;0;1;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;2;FLOAT;0;FLOAT;1
Node;AmplifyShaderEditor.VoronoiNode;126;-517.8423,-1247.181;Inherit;True;0;0;1;0;1;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;2;FLOAT;0;FLOAT;1
Node;AmplifyShaderEditor.OneMinusNode;127;-213.4852,-1219.653;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;130;-277.6633,-1372.478;Inherit;False;Property;_SmoothStepMin1;SmoothStep Min;10;0;Create;True;0;0;False;0;0.81;0.81;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;116;-1282.886,-2045.404;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;117;-1438.021,-1440.894;Inherit;False;Property;_offset1;offset;2;0;Create;True;0;0;False;0;0.34;0.34;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;121;-1009.641,-1357.594;Inherit;False;Constant;_Vector5;Vector 4;1;0;Create;True;0;0;False;0;1,2;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;624,1088;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;ToonTear1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0.014;0.245283,0.03818085,0.03818085,0;VertexOffset;False;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;23;0;22;0
WireConnection;2;0;26;0
WireConnection;3;0;2;0
WireConnection;3;1;4;0
WireConnection;8;0;27;0
WireConnection;9;0;3;0
WireConnection;7;0;8;0
WireConnection;7;1;6;0
WireConnection;30;0;29;0
WireConnection;30;1;28;0
WireConnection;10;0;7;0
WireConnection;20;0;14;0
WireConnection;20;1;21;0
WireConnection;20;2;21;0
WireConnection;69;0;70;0
WireConnection;68;0;66;0
WireConnection;68;1;67;1
WireConnection;71;0;68;0
WireConnection;71;1;69;0
WireConnection;65;0;20;0
WireConnection;31;0;30;0
WireConnection;19;1;65;0
WireConnection;50;0;62;0
WireConnection;50;1;49;0
WireConnection;72;0;71;0
WireConnection;72;1;73;0
WireConnection;41;0;44;0
WireConnection;87;0;85;0
WireConnection;51;0;50;0
WireConnection;74;0;72;0
WireConnection;74;1;75;0
WireConnection;74;2;76;0
WireConnection;35;0;34;0
WireConnection;35;1;19;0
WireConnection;43;0;41;0
WireConnection;43;1;42;0
WireConnection;99;1;74;0
WireConnection;92;0;87;0
WireConnection;92;1;88;0
WireConnection;52;0;51;0
WireConnection;17;0;35;0
WireConnection;86;0;99;0
WireConnection;86;1;92;0
WireConnection;55;0;42;0
WireConnection;55;1;63;0
WireConnection;54;0;52;0
WireConnection;54;1;53;0
WireConnection;46;0;37;0
WireConnection;46;1;43;0
WireConnection;78;0;86;0
WireConnection;78;1;77;0
WireConnection;58;0;55;0
WireConnection;58;1;54;0
WireConnection;38;0;36;0
WireConnection;38;1;46;0
WireConnection;80;0;79;0
WireConnection;80;1;78;0
WireConnection;60;0;58;0
WireConnection;39;0;38;0
WireConnection;59;0;57;0
WireConnection;59;1;56;0
WireConnection;81;0;80;0
WireConnection;61;0;60;0
WireConnection;61;1;59;0
WireConnection;105;0;101;0
WireConnection;64;0;40;0
WireConnection;64;1;61;0
WireConnection;146;0;141;0
WireConnection;144;0;138;0
WireConnection;144;1;119;0
WireConnection;143;0;136;0
WireConnection;143;1;119;0
WireConnection;142;0;139;0
WireConnection;142;1;119;0
WireConnection;147;0;142;0
WireConnection;147;1;144;0
WireConnection;147;2;143;0
WireConnection;139;0;134;0
WireConnection;139;2;132;0
WireConnection;138;0;134;0
WireConnection;138;2;135;0
WireConnection;137;0;131;0
WireConnection;137;1;130;0
WireConnection;137;2;133;0
WireConnection;136;0;134;0
WireConnection;136;2;129;0
WireConnection;141;0;137;0
WireConnection;128;0;125;0
WireConnection;153;0;152;0
WireConnection;153;1;141;0
WireConnection;150;0;146;0
WireConnection;150;1;149;0
WireConnection;134;0;120;0
WireConnection;152;0;147;0
WireConnection;152;1;148;1
WireConnection;152;2;148;2
WireConnection;164;0;157;3
WireConnection;164;1;159;0
WireConnection;154;0;150;0
WireConnection;154;1;151;0
WireConnection;155;0;153;0
WireConnection;155;1;154;0
WireConnection;156;0;155;0
WireConnection;161;0;141;0
WireConnection;161;1;149;0
WireConnection;162;0;123;0
WireConnection;162;1;124;0
WireConnection;131;0;128;0
WireConnection;131;1;127;0
WireConnection;149;0;140;0
WireConnection;108;1;113;0
WireConnection;111;0;108;0
WireConnection;111;1;112;0
WireConnection;90;0;88;0
WireConnection;90;1;89;0
WireConnection;90;2;91;0
WireConnection;84;0;64;0
WireConnection;84;1;83;0
WireConnection;102;0;101;0
WireConnection;102;1;111;0
WireConnection;160;0;122;0
WireConnection;160;1;119;0
WireConnection;120;0;116;0
WireConnection;163;0;164;0
WireConnection;122;0;120;0
WireConnection;122;2;118;0
WireConnection;123;0;120;0
WireConnection;123;2;121;0
WireConnection;124;0;119;0
WireConnection;124;1;117;0
WireConnection;125;0;122;0
WireConnection;125;2;119;0
WireConnection;126;0;123;0
WireConnection;126;2;124;0
WireConnection;127;0;126;0
WireConnection;116;0;114;0
WireConnection;0;0;33;0
WireConnection;0;2;104;0
WireConnection;0;13;84;0
ASEEND*/
//CHKSM=FF5BF73383C84354CFE8DB8D732F55F70DA5BE2B