// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Tear04"
{
	Properties
	{
		_Mask("Mask", 2D) = "black" {}
		_offset("offset", Float) = 0.34
		_noisescale("noise scale", Float) = 1.38
		_SmoothStepMax("SmoothStep Max", Range( 0 , 1)) = 0.2665786
		_SmoothStepMin("SmoothStep Min", Range( 0 , 1)) = 0.05271714
		_Albedo("Albedo", 2D) = "white" {}
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
		uniform sampler2D _Mask;
		uniform float4 _Mask_ST;
		uniform sampler2D _Albedo;
		uniform float4 _Albedo_ST;


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


		float2 voronoihash85( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi85( float2 v, float time, inout float2 id, float smoothness )
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
			 		float2 o = voronoihash85( n + g );
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
			float4 temp_cast_0 = (0.35).xxxx;
			float4 temp_cast_1 = (0.52).xxxx;
			float2 temp_cast_2 = (23.6).xx;
			float2 uv_TexCoord4 = i.uv_texcoord * temp_cast_2;
			float2 UVCoordinates107 = uv_TexCoord4;
			float2 panner12 = ( 1.0 * _Time.y * float2( 2,-2.5 ) + UVCoordinates107);
			float NoiseScale106 = _noisescale;
			float simpleNoise18 = SimpleNoise( panner12*NoiseScale106 );
			float2 panner13 = ( 1.0 * _Time.y * float2( 3,1.8 ) + UVCoordinates107);
			float simpleNoise20 = SimpleNoise( panner13*NoiseScale106 );
			float2 panner14 = ( 1.0 * _Time.y * float2( 0,-1.2 ) + UVCoordinates107);
			float simpleNoise16 = SimpleNoise( panner14*NoiseScale106 );
			float4 appendResult24 = (float4(simpleNoise18 , simpleNoise20 , simpleNoise16 , 0.0));
			float4 smoothstepResult33 = smoothstep( temp_cast_0 , temp_cast_1 , appendResult24);
			float4 ColorNoise129 = smoothstepResult33;
			float time69 = 0.0;
			float2 panner112 = ( 1.0 * _Time.y * float2( 2,1 ) + UVCoordinates107);
			float2 coords69 = panner112 * NoiseScale106;
			float2 id69 = 0;
			float voroi69 = voronoi69( coords69, time69,id69, 0 );
			float temp_output_71_0 = ( 1.0 - voroi69 );
			float temp_output_54_0 = ( _noisescale + _offset );
			float time68 = 0.0;
			float temp_output_95_0 = (_SinTime.w*0.5 + 0.5);
			float2 temp_cast_3 = (temp_output_95_0).xx;
			float2 panner57 = ( temp_output_95_0 * temp_cast_3 + UVCoordinates107);
			float2 coords68 = panner57 * temp_output_54_0;
			float2 id68 = 0;
			float voroi68 = voronoi68( coords68, time68,id68, 0 );
			float time85 = 0.0;
			float2 panner84 = ( 1.0 * _Time.y * float2( -0.3,-0.2 ) + UVCoordinates107);
			float2 coords85 = panner84 * ( temp_output_54_0 + _offset );
			float2 id85 = 0;
			float voroi85 = voronoi85( coords85, time85,id85, 0 );
			float clampResult91 = clamp( ( 1.0 - voroi85 ) , 0.0 , 1.0 );
			float NoiseMask124 = ( temp_output_71_0 * ( temp_output_71_0 + ( 1.0 - voroi68 ) ) * clampResult91 );
			float clampResult100 = clamp( NoiseMask124 , 0.0 , 1.0 );
			float smoothstepResult63 = smoothstep( _SmoothStepMin , _SmoothStepMax , ( 1.0 - clampResult100 ));
			float NoiseMaskStepped133 = smoothstepResult63;
			float2 uv_Mask = i.uv_texcoord * _Mask_ST.xy + _Mask_ST.zw;
			float2 uv_Albedo = i.uv_texcoord * _Albedo_ST.xy + _Albedo_ST.zw;
			float4 Albedo31 = ( ( ColorNoise129 * ( NoiseMaskStepped133 * tex2D( _Mask, uv_Mask ) ) ) + ( ( 1.0 - NoiseMaskStepped133 ) * tex2D( _Albedo, uv_Albedo ) ) );
			o.Albedo = Albedo31.xyz;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18000
292;73;1176;638;6443.016;2207.073;7.473696;True;True
Node;AmplifyShaderEditor.CommentaryNode;123;-3299.767,-604.8097;Inherit;False;758.759;211.5623;Comment;3;2;4;107;UV scale and Coords;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;58;-4055.809,189.329;Inherit;False;683.9546;409.1208;Comment;6;106;87;54;10;55;118;noise inputs;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;2;-3249.767,-532.0317;Inherit;False;Constant;_Tiling;Tiling;15;0;Create;True;0;0;False;0;23.6;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;55;-4007.81,349.3288;Inherit;False;Property;_offset;offset;1;0;Create;True;0;0;False;0;0.34;0.34;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;89;-3319.195,-348.6578;Inherit;False;1954.203;1012.36;Comment;24;52;90;91;93;96;119;117;95;114;57;70;68;116;86;115;83;84;85;61;113;112;71;69;124;Noise Mask;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-3991.811,237.3289;Inherit;False;Property;_noisescale;noise scale;2;0;Create;True;0;0;False;0;1.38;1.38;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;4;-3036.001,-552.2473;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RelayNode;118;-3766.456,473.4245;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinTimeNode;93;-3238.406,0.5767174;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;96;-3238.406,144.5769;Inherit;False;Constant;_sinscale;sin scale;5;0;Create;True;0;0;False;0;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;54;-3771.22,331.6288;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;107;-2767.009,-554.8096;Inherit;False;UVCoordinates;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;113;-3062.406,-255.4234;Inherit;False;107;UVCoordinates;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;115;-3048.571,352.5767;Inherit;False;107;UVCoordinates;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;87;-3618.515,449.2133;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;106;-3770.914,238.5135;Inherit;False;NoiseScale;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;95;-3051.018,92.10638;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;61;-3009.844,-178.6917;Inherit;False;Constant;_Vector3;Vector 3;1;0;Create;True;0;0;False;0;2,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.GetLocalVarNode;114;-3067.018,12.10638;Inherit;False;107;UVCoordinates;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;83;-3016.571,432.5768;Inherit;False;Constant;_Vector5;Vector 5;1;0;Create;True;0;0;False;0;-0.3,-0.2;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PannerNode;112;-2790.407,-255.4234;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;57;-2795.019,12.10638;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RelayNode;116;-3000.571,592.5766;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;84;-2792.571,352.5767;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;119;-2790.407,-127.4233;Inherit;False;106;NoiseScale;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RelayNode;117;-2992.491,237.6155;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;68;-2603.019,60.10638;Inherit;True;0;0;1;0;1;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;2;FLOAT;0;FLOAT;1
Node;AmplifyShaderEditor.VoronoiNode;69;-2598.407,-255.4234;Inherit;True;0;0;1;0;1;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;2;FLOAT;0;FLOAT;1
Node;AmplifyShaderEditor.VoronoiNode;85;-2600.572,416.5768;Inherit;True;0;0;1;0;1;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;2;FLOAT;0;FLOAT;1
Node;AmplifyShaderEditor.OneMinusNode;71;-2342.407,-255.4234;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;86;-2344.572,416.5768;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;70;-2347.019,60.10638;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;91;-2165.852,417.1149;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;90;-2145.102,-103.9522;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;52;-1921.692,-148.7986;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;128;-2009.718,-1238.013;Inherit;False;1514.79;789.356;Comment;20;126;127;33;122;121;120;5;110;6;3;12;111;109;13;14;20;16;18;24;129;Colour;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;124;-1681.58,-100.9786;Inherit;False;NoiseMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;132;-2428.108,709.7928;Inherit;False;1063.486;485.1113;Comment;7;133;63;98;82;81;100;125;Noise Mask Step;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;110;-1955.718,-947.6564;Inherit;False;107;UVCoordinates;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;109;-1959.718,-1187.657;Inherit;False;107;UVCoordinates;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;5;-1919.719,-628.6567;Inherit;False;Constant;_Pan;Pan;15;0;Create;True;0;0;False;0;0,-1.2;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.GetLocalVarNode;111;-1959.718,-707.6568;Inherit;False;107;UVCoordinates;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;3;-1921.738,-1107.657;Inherit;False;Constant;_Vector0;Vector 0;15;0;Create;True;0;0;False;0;2,-2.5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;6;-1913.719,-867.6567;Inherit;False;Constant;_Vector2;Vector 2;15;0;Create;True;0;0;False;0;3,1.8;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.GetLocalVarNode;125;-2378.108,837.1504;Inherit;False;124;NoiseMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;122;-1703.718,-1059.657;Inherit;False;106;NoiseScale;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;121;-1703.718,-819.6566;Inherit;False;106;NoiseScale;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;120;-1703.718,-579.6572;Inherit;False;106;NoiseScale;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;12;-1703.718,-1187.657;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;14;-1703.718,-707.6568;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ClampOpNode;100;-2180.492,840.193;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;13;-1703.718,-947.6564;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;18;-1507.026,-1188.013;Inherit;True;Simple;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;16;-1511.718,-707.6568;Inherit;True;Simple;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;81;-2125.298,971.0072;Inherit;False;Property;_SmoothStepMin;SmoothStep Min;4;0;Create;True;0;0;False;0;0.05271714;0.81;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;82;-2123.476,1059.313;Inherit;False;Property;_SmoothStepMax;SmoothStep Max;3;0;Create;True;0;0;False;0;0.2665786;0.87;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;98;-2026.391,759.7928;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;20;-1511.718,-947.6564;Inherit;True;Simple;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;63;-1823.12,909.2363;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;24;-1208.442,-987.8991;Inherit;True;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;126;-1222.47,-759.6423;Inherit;False;Constant;_ColorSmoothstepmin;Color Smoothstep min;5;0;Create;True;0;0;False;0;0.35;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;127;-1224.47,-679.6423;Inherit;False;Constant;_ColorSmoothstepmax;Color Smoothstep max;5;0;Create;True;0;0;False;0;0.52;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;133;-1582.01,920.6889;Inherit;False;NoiseMaskStepped;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;137;-1317.379,-353.9825;Inherit;False;855.11;465.9502;Comment;5;134;7;130;22;26;Void Mask;1,1,1,1;0;0
Node;AmplifyShaderEditor.SmoothstepOpNode;33;-962.2092,-849.8199;Inherit;True;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT4;1,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;136;-1313.445,161.6498;Inherit;False;856.3967;510.5915;Comment;4;135;17;131;27;Albedo;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;7;-1267.379,-135.9257;Inherit;True;Property;_Mask;Mask;0;0;Create;True;0;0;False;0;-1;64e7766099ad46747a07014e44d0aea1;220f8d46e4e5dc241b9b5323228dd6b7;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;135;-1263.445,213.8596;Inherit;False;133;NoiseMaskStepped;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;129;-700.3593,-810.3586;Inherit;False;ColorNoise;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;134;-1196.542,-228.8133;Inherit;False;133;NoiseMaskStepped;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;130;-917.2723,-303.9825;Inherit;False;129;ColorNoise;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-948.4733,-221.275;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;17;-1034.684,217.825;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;131;-1160.58,442.2409;Inherit;True;Property;_Albedo;Albedo;5;0;Create;True;0;0;False;0;-1;14656c99dff77cb4ba68513ede2b1cb9;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;-700.4675,211.6497;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;-672.0143,-142.0322;Inherit;True;2;2;0;FLOAT4;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;29;-350.1801,-23.3047;Inherit;True;2;2;0;FLOAT4;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;31;-101.9606,-18.16558;Inherit;False;Albedo;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;36;136.4726,-15.17425;Inherit;False;31;Albedo;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;343.1821,-9.031132;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Tear04;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;4;0;2;0
WireConnection;118;0;55;0
WireConnection;54;0;10;0
WireConnection;54;1;55;0
WireConnection;107;0;4;0
WireConnection;87;0;54;0
WireConnection;87;1;118;0
WireConnection;106;0;10;0
WireConnection;95;0;93;4
WireConnection;95;1;96;0
WireConnection;95;2;96;0
WireConnection;112;0;113;0
WireConnection;112;2;61;0
WireConnection;57;0;114;0
WireConnection;57;2;95;0
WireConnection;57;1;95;0
WireConnection;116;0;87;0
WireConnection;84;0;115;0
WireConnection;84;2;83;0
WireConnection;117;0;54;0
WireConnection;68;0;57;0
WireConnection;68;2;117;0
WireConnection;69;0;112;0
WireConnection;69;2;119;0
WireConnection;85;0;84;0
WireConnection;85;2;116;0
WireConnection;71;0;69;0
WireConnection;86;0;85;0
WireConnection;70;0;68;0
WireConnection;91;0;86;0
WireConnection;90;0;71;0
WireConnection;90;1;70;0
WireConnection;52;0;71;0
WireConnection;52;1;90;0
WireConnection;52;2;91;0
WireConnection;124;0;52;0
WireConnection;12;0;109;0
WireConnection;12;2;3;0
WireConnection;14;0;111;0
WireConnection;14;2;5;0
WireConnection;100;0;125;0
WireConnection;13;0;110;0
WireConnection;13;2;6;0
WireConnection;18;0;12;0
WireConnection;18;1;122;0
WireConnection;16;0;14;0
WireConnection;16;1;120;0
WireConnection;98;0;100;0
WireConnection;20;0;13;0
WireConnection;20;1;121;0
WireConnection;63;0;98;0
WireConnection;63;1;81;0
WireConnection;63;2;82;0
WireConnection;24;0;18;0
WireConnection;24;1;20;0
WireConnection;24;2;16;0
WireConnection;133;0;63;0
WireConnection;33;0;24;0
WireConnection;33;1;126;0
WireConnection;33;2;127;0
WireConnection;129;0;33;0
WireConnection;22;0;134;0
WireConnection;22;1;7;0
WireConnection;17;0;135;0
WireConnection;27;0;17;0
WireConnection;27;1;131;0
WireConnection;26;0;130;0
WireConnection;26;1;22;0
WireConnection;29;0;26;0
WireConnection;29;1;27;0
WireConnection;31;0;29;0
WireConnection;0;0;36;0
ASEEND*/
//CHKSM=8CABB72CA3C6D7C31572C47166810295B9E9CCCD