// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Tear04"
{
	Properties
	{
		_Emission("Emission", 2D) = "white" {}
		_offset("offset", Float) = 0.34
		_noisescale("noise scale", Float) = 1.38
		_SmoothStepMax("SmoothStep Max", Range( 0 , 1)) = 0.06316511
		_SmoothStepMin("SmoothStep Min", Range( 0 , 1)) = 0
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
		uniform sampler2D _Emission;
		uniform float4 _Emission_ST;


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
			float temp_output_71_0 = ( 1.0 - voroi69 );
			float temp_output_54_0 = ( _noisescale + _offset );
			float time68 = 0.0;
			float temp_output_95_0 = (_SinTime.w*0.5 + 0.5);
			float2 temp_cast_3 = (temp_output_95_0).xx;
			float2 panner57 = ( temp_output_95_0 * temp_cast_3 + uv_TexCoord4);
			float2 coords68 = panner57 * temp_output_54_0;
			float2 id68 = 0;
			float voroi68 = voronoi68( coords68, time68,id68, 0 );
			float clampResult100 = clamp( ( temp_output_71_0 * ( temp_output_71_0 + ( 1.0 - voroi68 ) ) ) , 0.0 , 1.0 );
			float smoothstepResult63 = smoothstep( _SmoothStepMin , _SmoothStepMax , ( 1.0 - clampResult100 ));
			float2 uv_Emission = i.uv_texcoord * _Emission_ST.xy + _Emission_ST.zw;
			float temp_output_15_0 = step( tex2D( _Emission, uv_Emission ).b , 0.01 );
			float temp_output_19_0 = ( 1.0 - temp_output_15_0 );
			float4 color23 = IsGammaSpace() ? float4(0,0.3962264,0.02598071,1) : float4(0,0.130239,0.002010891,1);
			float4 Void31 = ( ( smoothstepResult33 * smoothstepResult63 * smoothstepResult63 ) + ( ( ( 1.0 - smoothstepResult63 ) * temp_output_19_0 ) * color23 ) );
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
326;73;1316;515;2519.39;270.1395;3.04356;True;True
Node;AmplifyShaderEditor.CommentaryNode;89;-3521.817,-325.5945;Inherit;False;2341.35;873.5695;Comment;18;71;70;86;69;85;68;56;57;84;83;62;61;58;90;91;93;96;95;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;2;-2846.534,-640.0366;Inherit;False;Constant;_Tiling;Tiling;15;0;Create;True;0;0;False;0;23.6;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;96;-2980.313,161.1462;Inherit;False;Constant;_Float0;Float 0;5;0;Create;True;0;0;False;0;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;4;-2632.768,-660.2521;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SinTimeNode;93;-3011.329,-152.1027;Inherit;True;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;58;-3471.817,-211.5945;Inherit;False;468.2869;391.6342;Comment;4;54;10;55;87;noise inputs;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;55;-3423.817,-51.59447;Inherit;False;Property;_offset;offset;1;0;Create;True;0;0;False;0;0.34;0.34;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;95;-2906.218,114.4562;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RelayNode;49;-2304,-656;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;61;-2975.817,-259.5945;Inherit;False;Constant;_Vector3;Vector 3;1;0;Create;True;0;0;False;0;2,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;10;-3407.817,-163.5945;Inherit;False;Property;_noisescale;noise scale;2;0;Create;True;0;0;False;0;1.38;1.38;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;57;-2719.817,12.40552;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;56;-2735.817,-275.5945;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;54;-3215.817,-83.59447;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;68;-2511.817,28.40552;Inherit;True;0;0;1;0;1;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;2;FLOAT;0;FLOAT;1
Node;AmplifyShaderEditor.VoronoiNode;69;-2511.817,-243.5945;Inherit;True;0;0;1;0;1;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;2;FLOAT;0;FLOAT;1
Node;AmplifyShaderEditor.OneMinusNode;70;-2259.986,7.892108;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;71;-2255.614,-179.5945;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;90;-2071.918,-56.53285;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;1;-1975.756,-946.7462;Inherit;False;2087.408;1234.904;Comment;24;22;47;16;32;33;31;29;26;24;20;18;13;14;12;3;6;5;52;63;65;81;82;98;100;Void;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;52;-1973.854,-100.8726;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;100;-1810.243,-124.4851;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;82;-1753.227,94.63474;Inherit;False;Property;_SmoothStepMax;SmoothStep Max;3;0;Create;True;0;0;False;0;0.06316511;0.87;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RelayNode;65;-1925.994,-655.9999;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;50;-1757.228,752.4757;Inherit;False;1334.885;770.3864;Comment;10;23;27;21;25;19;17;15;9;7;79;;1,1,1,1;0;0
Node;AmplifyShaderEditor.OneMinusNode;98;-1656.142,-204.8851;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;3;-1672.45,-848.2468;Inherit;False;Constant;_Vector0;Vector 0;15;0;Create;True;0;0;False;0;2,-2.5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;5;-1669.994,-432;Inherit;False;Constant;_Pan;Pan;15;0;Create;True;0;0;False;0;0,-1.2;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;6;-1668.45,-685.2469;Inherit;False;Constant;_Vector2;Vector 2;15;0;Create;True;0;0;False;0;3,1.8;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;81;-1755.049,6.329125;Inherit;False;Property;_SmoothStepMin;SmoothStep Min;4;0;Create;True;0;0;False;0;0;0.81;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;63;-1452.871,-55.44168;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;12;-1490.451,-859.7465;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-1581.228,1040.476;Inherit;False;Constant;_Float1;Float 1;15;0;Create;True;0;0;False;0;0.01;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;14;-1484.748,-513.8563;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;13;-1483.15,-633.9357;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;7;-1725.228,832.4757;Inherit;True;Property;_Emission;Emission;0;0;Create;True;0;0;False;0;-1;220f8d46e4e5dc241b9b5323228dd6b7;220f8d46e4e5dc241b9b5323228dd6b7;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NoiseGeneratorNode;20;-1307.149,-670.9357;Inherit;True;Simple;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;18;-1304.45,-896.7465;Inherit;True;Simple;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;15;-1437.228,944.4758;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RelayNode;47;-984.8893,-48.86523;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;16;-1301.994,-448;Inherit;True;Simple;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;32;-1046.456,-248.2036;Inherit;False;Constant;_Vector1;Vector 1;15;0;Create;True;0;0;False;0;0.35,0.52;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.OneMinusNode;19;-1213.227,944.4758;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;17;-1021.227,1056.476;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;24;-1006.65,-688.2469;Inherit;True;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-861.2274,1056.476;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;33;-807.2193,-308.3615;Inherit;True;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT4;1,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ColorNode;23;-1101.227,1328.476;Inherit;False;Constant;_Color0;Color 0;15;0;Create;True;0;0;False;0;0,0.3962264,0.02598071,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;-589.2275,1168.476;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;-505.8769,-105.6047;Inherit;True;3;3;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;29;-287.7549,55.15253;Inherit;True;2;2;0;FLOAT4;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;31;-112.3472,-56.05629;Inherit;False;Void;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;36;172.1794,-3.310126;Inherit;False;31;Void;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.Vector2Node;62;-2991.817,28.40552;Inherit;False;Constant;_Vector4;Vector 4;1;0;Create;True;0;0;False;0;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.OneMinusNode;86;-2303.817,268.4055;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;85;-2639.817,252.4055;Inherit;True;0;0;1;0;1;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;2;FLOAT;0;FLOAT;1
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-827.8815,-2.812299;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;84;-2863.817,252.4055;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ClampOpNode;91;-2088.68,127.8473;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;83;-3135.817,252.4055;Inherit;False;Constant;_Vector5;Vector 5;1;0;Create;True;0;0;False;0;-0.3,-0.2;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RegisterLocalVarNode;21;-1213.227,1232.476;Inherit;False;AntiVoidMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;79;-1421.228,752.4757;Inherit;False;Constant;_Color1;Color 1;3;0;Create;True;0;0;False;0;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;87;-3119.817,28.40552;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;343.1821,-9.031132;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Tear04;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;4;0;2;0
WireConnection;95;0;93;4
WireConnection;95;1;96;0
WireConnection;95;2;96;0
WireConnection;49;0;4;0
WireConnection;57;0;49;0
WireConnection;57;2;95;0
WireConnection;57;1;95;0
WireConnection;56;0;49;0
WireConnection;56;2;61;0
WireConnection;54;0;10;0
WireConnection;54;1;55;0
WireConnection;68;0;57;0
WireConnection;68;2;54;0
WireConnection;69;0;56;0
WireConnection;69;2;10;0
WireConnection;70;0;68;0
WireConnection;71;0;69;0
WireConnection;90;0;71;0
WireConnection;90;1;70;0
WireConnection;52;0;71;0
WireConnection;52;1;90;0
WireConnection;100;0;52;0
WireConnection;65;0;49;0
WireConnection;98;0;100;0
WireConnection;63;0;98;0
WireConnection;63;1;81;0
WireConnection;63;2;82;0
WireConnection;12;0;65;0
WireConnection;12;2;3;0
WireConnection;14;0;65;0
WireConnection;14;2;5;0
WireConnection;13;0;65;0
WireConnection;13;2;6;0
WireConnection;20;0;13;0
WireConnection;20;1;10;0
WireConnection;18;0;12;0
WireConnection;18;1;10;0
WireConnection;15;0;7;3
WireConnection;15;1;9;0
WireConnection;47;0;63;0
WireConnection;16;0;14;0
WireConnection;16;1;10;0
WireConnection;19;0;15;0
WireConnection;17;0;47;0
WireConnection;24;0;18;0
WireConnection;24;1;20;0
WireConnection;24;2;16;0
WireConnection;25;0;17;0
WireConnection;25;1;19;0
WireConnection;33;0;24;0
WireConnection;33;1;32;1
WireConnection;33;2;32;2
WireConnection;27;0;25;0
WireConnection;27;1;23;0
WireConnection;26;0;33;0
WireConnection;26;1;47;0
WireConnection;26;2;63;0
WireConnection;29;0;26;0
WireConnection;29;1;27;0
WireConnection;31;0;29;0
WireConnection;86;0;85;0
WireConnection;85;0;84;0
WireConnection;85;2;87;0
WireConnection;22;0;47;0
WireConnection;22;1;19;0
WireConnection;84;0;49;0
WireConnection;84;2;83;0
WireConnection;21;0;15;0
WireConnection;87;0;54;0
WireConnection;87;1;55;0
WireConnection;0;0;36;0
ASEEND*/
//CHKSM=91B49B1055A5A0A9E8F77CA3DEF3EAC6C2946E56