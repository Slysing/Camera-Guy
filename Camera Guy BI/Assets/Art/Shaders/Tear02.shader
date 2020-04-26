// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Tear02"
{
	Properties
	{
		_Emission("Emission", 2D) = "white" {}
		_FogIntensity("Fog Intensity", Range( 0 , 1)) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
			float4 screenPos;
		};

		uniform sampler2D _Emission;
		uniform float4 _Emission_ST;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _FogIntensity;


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


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 temp_cast_0 = (23.6).xx;
			float2 uv_TexCoord4 = i.uv_texcoord * temp_cast_0;
			float2 panner12 = ( 1.0 * _Time.y * float2( 2,-2.5 ) + uv_TexCoord4);
			float simplePerlin2D18 = snoise( panner12 );
			simplePerlin2D18 = simplePerlin2D18*0.5 + 0.5;
			float2 panner13 = ( 1.0 * _Time.y * float2( 3,1.8 ) + uv_TexCoord4);
			float simplePerlin2D20 = snoise( panner13 );
			simplePerlin2D20 = simplePerlin2D20*0.5 + 0.5;
			float2 panner14 = ( 1.0 * _Time.y * float2( 0,-1.2 ) + uv_TexCoord4);
			float simplePerlin2D16 = snoise( panner14 );
			simplePerlin2D16 = simplePerlin2D16*0.5 + 0.5;
			float4 appendResult24 = (float4(simplePerlin2D18 , simplePerlin2D20 , simplePerlin2D16 , 0.0));
			float2 temp_cast_1 = (65.4).xx;
			float2 break16_g6 = ( i.uv_texcoord * temp_cast_1 );
			float2 appendResult7_g6 = (float2(( break16_g6.x + ( 0.5 * step( 1.0 , ( break16_g6.y % 2.0 ) ) ) ) , ( break16_g6.y + ( 1.0 * step( 1.0 , ( break16_g6.x % 2.0 ) ) ) )));
			float temp_output_2_0_g6 = 0.41;
			float2 appendResult11_g7 = (float2(temp_output_2_0_g6 , temp_output_2_0_g6));
			float temp_output_17_0_g7 = length( ( (frac( appendResult7_g6 )*2.0 + -1.0) / appendResult11_g7 ) );
			float temp_output_11_0 = saturate( ( ( 1.0 - temp_output_17_0_g7 ) / fwidth( temp_output_17_0_g7 ) ) );
			float2 uv_Emission = i.uv_texcoord * _Emission_ST.xy + _Emission_ST.zw;
			float temp_output_15_0 = step( tex2D( _Emission, uv_Emission ).b , 0.01 );
			float temp_output_19_0 = ( 1.0 - temp_output_15_0 );
			float4 color23 = IsGammaSpace() ? float4(0.3679245,0.3679245,0.3679245,1) : float4(0.1114872,0.1114872,0.1114872,1);
			float4 Void31 = ( ( appendResult24 * ( temp_output_11_0 * temp_output_19_0 ) ) + ( ( ( 1.0 - temp_output_11_0 ) * temp_output_19_0 ) * color23 ) );
			o.Emission = Void31.xyz;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float eyeDepth28 = (SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPos.xy )*( _ProjectionParams.z - _ProjectionParams.y ));
			float clampResult42 = clamp( ( abs( ( eyeDepth28 - ase_screenPos.w ) ) * _FogIntensity ) , 0.0 , _FogIntensity );
			float AntiVoidMask21 = temp_output_15_0;
			float opacity37 = ( clampResult42 * AntiVoidMask21 );
			o.Alpha = opacity37;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard alpha:fade keepalpha fullforwardshadows 

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
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				float4 screenPos : TEXCOORD3;
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
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
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
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.screenPos = IN.screenPos;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
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
326;73;1316;655;2340.032;643.0073;2.345002;True;True
Node;AmplifyShaderEditor.CommentaryNode;1;-1904.517,-946.7463;Inherit;False;2054.163;1600.601;Comment;30;33;32;31;29;27;26;25;24;23;22;21;20;19;18;17;16;15;14;13;12;11;10;9;8;7;6;5;4;3;2;Void;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;2;-1842.556,-546.7719;Inherit;False;Constant;_Tiling;Tiling;15;0;Create;True;0;0;False;0;23.6;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;35;-856.9617,819.1564;Float;False;1;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;5;-1638.754,-433.8563;Inherit;False;Constant;_Pan;Pan;15;0;Create;True;0;0;False;0;0,-1.2;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;3;-1634.456,-848.2468;Inherit;False;Constant;_Vector0;Vector 0;15;0;Create;True;0;0;False;0;2,-2.5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;4;-1670.754,-545.8561;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenDepthNode;28;-634.6691,792.1622;Inherit;False;0;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;7;-1854.517,-66.53239;Inherit;True;Property;_Emission;Emission;0;0;Create;True;0;0;False;0;-1;220f8d46e4e5dc241b9b5323228dd6b7;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;8;-1773.754,-176.8563;Inherit;False;Constant;_Dotdistance;Dot distance;15;0;Create;True;0;0;False;0;65.4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-1692.754,-306.8563;Inherit;False;Constant;_Float2;Float 2;15;0;Create;True;0;0;False;0;0.41;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;6;-1630.456,-685.247;Inherit;False;Constant;_Vector2;Vector 2;15;0;Create;True;0;0;False;0;3,1.8;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;9;-1717.482,142.8493;Inherit;False;Constant;_Float1;Float 1;15;0;Create;True;0;0;False;0;0.01;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;12;-1452.457,-859.7466;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;11;-1491.356,-223.8719;Inherit;True;Dots Pattern;-1;;6;7d8d5e315fd9002418fb41741d3a59cb;1,22,0;5;21;FLOAT2;0,0;False;3;FLOAT2;8,8;False;2;FLOAT;0.9;False;4;FLOAT;0.5;False;5;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;15;-1552.579,108.0855;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;14;-1446.754,-513.8563;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;13;-1445.156,-633.9357;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;34;-418.5854,845.7756;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;17;-1151.218,225.1773;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;43;-510.4495,1067.948;Inherit;False;Property;_FogIntensity;Fog Intensity;1;0;Create;True;0;0;False;0;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;19;-1350.698,108.1611;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;18;-1266.456,-896.7466;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;40;-254.4494,789.9477;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;16;-1270.754,-449.8563;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;20;-1269.155,-670.9357;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;24;-950.4558,-688.247;Inherit;True;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;21;-1367.025,356.0302;Inherit;False;AntiVoidMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;-99.59581,888.872;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-1158.663,-105.9913;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;23;-989.6313,441.8543;Inherit;False;Constant;_Color0;Color 0;15;0;Create;True;0;0;False;0;0.3679245,0.3679245,0.3679245,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-992.6454,229.5201;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;46;52.94532,1210.194;Inherit;False;21;AntiVoidMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;42;42.55047,982.9477;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;-467.8821,-105.6047;Inherit;True;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;-731.631,285.8543;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;45;228.8462,998.8294;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;29;-233.5305,166.0544;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;31;-74.35248,-56.05629;Inherit;False;Void;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;37;297.3521,832.0637;Inherit;False;opacity;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;36;172.1794,-3.310126;Inherit;False;31;Void;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SmoothstepOpNode;33;-769.2244,-308.3615;Inherit;True;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT4;1,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.Vector2Node;32;-927.6248,-275.7615;Inherit;False;Constant;_Vector1;Vector 1;15;0;Create;True;0;0;False;0;0.1,0.9;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.GetLocalVarNode;38;179.8098,228.6463;Inherit;False;37;opacity;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;343.1821,-9.031132;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Tear02;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;4;0;2;0
WireConnection;28;0;35;0
WireConnection;12;0;4;0
WireConnection;12;2;3;0
WireConnection;11;3;8;0
WireConnection;11;2;10;0
WireConnection;15;0;7;3
WireConnection;15;1;9;0
WireConnection;14;0;4;0
WireConnection;14;2;5;0
WireConnection;13;0;4;0
WireConnection;13;2;6;0
WireConnection;34;0;28;0
WireConnection;34;1;35;4
WireConnection;17;0;11;0
WireConnection;19;0;15;0
WireConnection;18;0;12;0
WireConnection;40;0;34;0
WireConnection;16;0;14;0
WireConnection;20;0;13;0
WireConnection;24;0;18;0
WireConnection;24;1;20;0
WireConnection;24;2;16;0
WireConnection;21;0;15;0
WireConnection;39;0;40;0
WireConnection;39;1;43;0
WireConnection;22;0;11;0
WireConnection;22;1;19;0
WireConnection;25;0;17;0
WireConnection;25;1;19;0
WireConnection;42;0;39;0
WireConnection;42;2;43;0
WireConnection;26;0;24;0
WireConnection;26;1;22;0
WireConnection;27;0;25;0
WireConnection;27;1;23;0
WireConnection;45;0;42;0
WireConnection;45;1;46;0
WireConnection;29;0;26;0
WireConnection;29;1;27;0
WireConnection;31;0;29;0
WireConnection;37;0;45;0
WireConnection;33;0;24;0
WireConnection;33;1;32;1
WireConnection;33;2;32;2
WireConnection;0;2;36;0
WireConnection;0;9;38;0
ASEEND*/
//CHKSM=009BC061CE33268119C949E5AD30700DDA9274FB