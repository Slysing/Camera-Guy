// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Tear04"
{
	Properties
	{
		_offset("offset", Float) = 0.34
		_noisescale("noise scale", Float) = 1.38
		_SmoothStepMax("SmoothStep Max", Range( 0 , 1)) = 0.87
		_SmoothStepMin("SmoothStep Min", Range( 0 , 1)) = 0.81
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IgnoreProjector" = "True" }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float _noisescale;
		uniform float _SmoothStepMin;
		uniform float _SmoothStepMax;
		uniform float _offset;


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


		float2 voronoihash69( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi69( float2 v, float time, inout float2 id, float smoothness )
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
			 		float2 o = voronoihash69( n + g );
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


		float2 voronoihash68( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi68( float2 v, float time, inout float2 id, float smoothness )
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
			 		float2 o = voronoihash68( n + g );
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


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 _Vector1 = float2(0.35,0.52);
			float4 temp_cast_0 = (_Vector1.x).xxxx;
			float4 temp_cast_1 = (_Vector1.y).xxxx;
			float2 temp_cast_2 = (23.6).xx;
			float2 uv_TexCoord4 = i.uv_texcoord * temp_cast_2;
			float2 panner12 = ( 1.0 * _Time.y * float2( 2,-2.5 ) + uv_TexCoord4);
			float simpleNoise18 = SimpleNoise( panner12*_noisescale );
			float2 panner13 = ( 1.0 * _Time.y * float2( 3,1.8 ) + uv_TexCoord4);
			float simpleNoise20 = SimpleNoise( panner13*_noisescale );
			float2 panner14 = ( 1.0 * _Time.y * float2( 0,-1.2 ) + uv_TexCoord4);
			float simpleNoise16 = SimpleNoise( panner14*_noisescale );
			float4 appendResult24 = (float4(simpleNoise18 , simpleNoise20 , simpleNoise16 , 0.0));
			float4 smoothstepResult33 = smoothstep( temp_cast_0 , temp_cast_1 , appendResult24);
			float time69 = 0.0;
			float2 panner56 = ( 1.0 * _Time.y * float2( 2,1 ) + uv_TexCoord4);
			float2 coords69 = panner56 * _noisescale;
			float2 id69 = 0;
			float voroi69 = voronoi69( coords69, time69,id69, 0 );
			float temp_output_54_0 = ( _noisescale + _offset );
			float time68 = 0.0;
			float2 panner57 = ( 1.0 * _Time.y * float2( 1,2 ) + uv_TexCoord4);
			float2 coords68 = panner57 * temp_output_54_0;
			float2 id68 = 0;
			float voroi68 = voronoi68( coords68, time68,id68, 0 );
			float smoothstepResult63 = smoothstep( _SmoothStepMin , _SmoothStepMax , ( ( 1.0 - voroi69 ) * ( 1.0 - voroi68 ) ));
			float4 color79 = IsGammaSpace() ? float4(0,0,0,0) : float4(0,0,0,0);
			float4 temp_output_19_0 = ( 1.0 - color79 );
			float4 color23 = IsGammaSpace() ? float4(0,0.3962264,0.02598071,1) : float4(0,0.130239,0.002010891,1);
			float4 Void31 = ( ( smoothstepResult33 * smoothstepResult63 ) + ( ( ( 1.0 - smoothstepResult63 ) * temp_output_19_0 ) * color23 ) );
			o.Albedo = Void31.xyz;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18000
326;73;1316;515;4901.961;1229.59;5.588175;True;True
Node;AmplifyShaderEditor.RangedFloatNode;2;-2846.534,-640.0366;Inherit;False;Constant;_Tiling;Tiling;15;0;Create;True;0;0;False;0;23.6;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;58;-2837.903,-203.0309;Inherit;False;403.5017;264.0882;Comment;3;54;55;10;noise inputs;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;4;-2632.768,-660.2521;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;1;-1937.762,-946.7463;Inherit;False;2087.408;1234.904;Comment;29;22;48;47;16;32;33;31;29;26;24;20;18;13;14;12;3;6;5;51;52;57;63;65;68;69;70;71;81;82;Void;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector2Node;62;-2359.523,27.55793;Inherit;False;Constant;_Vector4;Vector 4;1;0;Create;True;0;0;False;0;1,2;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;55;-2787.903,-55.74256;Inherit;False;Property;_offset;offset;1;0;Create;True;0;0;False;0;0.34;0.34;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;61;-2346.598,-262.6907;Inherit;False;Constant;_Vector3;Vector 3;1;0;Create;True;0;0;False;0;2,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;10;-2776.816,-153.0308;Inherit;False;Property;_noisescale;noise scale;2;0;Create;True;0;0;False;0;1.38;1.38;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RelayNode;49;-2304,-656;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;54;-2586.402,-73.94263;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;57;-2081.986,20.25649;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;56;-2102.298,-278.9336;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.VoronoiNode;69;-1856.777,-146.635;Inherit;True;0;0;1;0;1;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;2;FLOAT;0;FLOAT;1
Node;AmplifyShaderEditor.VoronoiNode;68;-1867.724,137.9706;Inherit;True;0;0;1;0;1;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;2;FLOAT;0;FLOAT;1
Node;AmplifyShaderEditor.OneMinusNode;70;-1563.367,165.4986;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;71;-1558.218,-172.9974;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RelayNode;65;-1888,-656;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;5;-1638.754,-433.8563;Inherit;False;Constant;_Pan;Pan;15;0;Create;True;0;0;False;0;0,-1.2;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;81;-1627.545,12.6742;Inherit;False;Property;_SmoothStepMin;SmoothStep Min;5;0;Create;True;0;0;False;0;0.81;0.81;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;52;-1412.021,-94.70494;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;3;-1634.456,-848.2468;Inherit;False;Constant;_Vector0;Vector 0;15;0;Create;True;0;0;False;0;2,-2.5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;82;-1626.183,86.29585;Inherit;False;Property;_SmoothStepMax;SmoothStep Max;4;0;Create;True;0;0;False;0;0.87;0.87;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;6;-1630.456,-685.247;Inherit;False;Constant;_Vector2;Vector 2;15;0;Create;True;0;0;False;0;3,1.8;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PannerNode;13;-1445.156,-633.9357;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;12;-1452.457,-859.7466;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SmoothstepOpNode;63;-1262.001,-49.31764;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;14;-1446.754,-513.8563;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;50;-1760.646,341.7609;Inherit;False;1334.885;770.3864;Comment;10;23;27;21;25;19;17;15;9;7;80;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ColorNode;79;-1422.529,337.0089;Inherit;False;Constant;_Color1;Color 1;3;0;Create;True;0;0;False;0;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RelayNode;47;-946.8945,-48.86523;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;18;-1266.456,-896.7466;Inherit;True;Simple;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;16;-1270.754,-449.8563;Inherit;True;Simple;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;20;-1269.155,-670.9357;Inherit;True;Simple;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;32;-1008.462,-248.2036;Inherit;False;Constant;_Vector1;Vector 1;15;0;Create;True;0;0;False;0;0.35,0.52;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.OneMinusNode;17;-1023.969,640.252;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;24;-950.4558,-688.247;Inherit;True;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.OneMinusNode;19;-1223.449,523.2358;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;33;-769.2244,-308.3615;Inherit;True;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT4;1,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-865.3969,644.5947;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;23;-1108.101,918.7531;Inherit;False;Constant;_Color0;Color 0;15;0;Create;True;0;0;False;0;0,0.3962264,0.02598071,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;-467.8821,-105.6047;Inherit;True;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;-587.7598,744.1473;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;29;-233.5305,166.0544;Inherit;True;2;2;0;FLOAT4;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;31;-74.35248,-56.05629;Inherit;False;Void;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-789.8866,-2.812297;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;51;-1884.36,46.7362;Inherit;True;Simple;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;48;-1865.677,-367.7762;Inherit;True;Simple;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-1590.233,621.0898;Inherit;False;Constant;_Float1;Float 1;15;0;Create;True;0;0;False;0;0.01;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;15;-1438.821,523.1603;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;7;-1733.917,418.3572;Inherit;True;Property;_Emission;Emission;0;0;Create;True;0;0;False;0;-1;220f8d46e4e5dc241b9b5323228dd6b7;220f8d46e4e5dc241b9b5323228dd6b7;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;21;-1223.154,814.3234;Inherit;False;AntiVoidMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;36;172.1794,-3.310126;Inherit;False;31;Void;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SamplerNode;80;-877.9919,997.2717;Inherit;True;Property;_TextureSample0;Texture Sample 0;3;0;Create;True;0;0;False;0;-1;14656c99dff77cb4ba68513ede2b1cb9;14656c99dff77cb4ba68513ede2b1cb9;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;343.1821,-9.031132;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Tear04;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;4;0;2;0
WireConnection;49;0;4;0
WireConnection;54;0;10;0
WireConnection;54;1;55;0
WireConnection;57;0;49;0
WireConnection;57;2;62;0
WireConnection;56;0;49;0
WireConnection;56;2;61;0
WireConnection;69;0;56;0
WireConnection;69;2;10;0
WireConnection;68;0;57;0
WireConnection;68;2;54;0
WireConnection;70;0;68;0
WireConnection;71;0;69;0
WireConnection;65;0;49;0
WireConnection;52;0;71;0
WireConnection;52;1;70;0
WireConnection;13;0;65;0
WireConnection;13;2;6;0
WireConnection;12;0;65;0
WireConnection;12;2;3;0
WireConnection;63;0;52;0
WireConnection;63;1;81;0
WireConnection;63;2;82;0
WireConnection;14;0;65;0
WireConnection;14;2;5;0
WireConnection;47;0;63;0
WireConnection;18;0;12;0
WireConnection;18;1;10;0
WireConnection;16;0;14;0
WireConnection;16;1;10;0
WireConnection;20;0;13;0
WireConnection;20;1;10;0
WireConnection;17;0;47;0
WireConnection;24;0;18;0
WireConnection;24;1;20;0
WireConnection;24;2;16;0
WireConnection;19;0;79;0
WireConnection;33;0;24;0
WireConnection;33;1;32;1
WireConnection;33;2;32;2
WireConnection;25;0;17;0
WireConnection;25;1;19;0
WireConnection;26;0;33;0
WireConnection;26;1;47;0
WireConnection;27;0;25;0
WireConnection;27;1;23;0
WireConnection;29;0;26;0
WireConnection;29;1;27;0
WireConnection;31;0;29;0
WireConnection;22;0;47;0
WireConnection;22;1;19;0
WireConnection;51;0;57;0
WireConnection;51;1;54;0
WireConnection;48;0;56;0
WireConnection;48;1;10;0
WireConnection;15;0;7;3
WireConnection;15;1;9;0
WireConnection;21;0;15;0
WireConnection;0;0;36;0
ASEEND*/
//CHKSM=9D60A6F0AFBD47027B95C0525E932FC18DA8695C