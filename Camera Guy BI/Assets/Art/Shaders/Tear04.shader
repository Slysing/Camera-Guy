// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Tear04"
{
	Properties
	{
		_offset("offset", Float) = 0.34
		_noisescale("noise scale", Float) = 1.38
		_SmoothStepMax("SmoothStep Max", Range( 0 , 1)) = 0.2665786
		_SmoothStepMin("SmoothStep Min", Range( 0 , 1)) = 0.05271714
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
			float time85 = 0.0;
			float2 panner84 = ( 1.0 * _Time.y * float2( -0.3,-0.2 ) + uv_TexCoord4);
			float2 coords85 = panner84 * ( temp_output_54_0 + _offset );
			float2 id85 = 0;
			float voroi85 = voronoi85( coords85, time85,id85, 0 );
			float clampResult91 = clamp( ( 1.0 - voroi85 ) , 0.0 , 1.0 );
			float clampResult100 = clamp( ( temp_output_71_0 * ( temp_output_71_0 + ( 1.0 - voroi68 ) ) * clampResult91 ) , 0.0 , 1.0 );
			float smoothstepResult63 = smoothstep( _SmoothStepMin , _SmoothStepMax , ( 1.0 - clampResult100 ));
			float4 color79 = IsGammaSpace() ? float4(0,0,0,0) : float4(0,0,0,0);
			float4 temp_output_19_0 = ( 1.0 - color79 );
			float4 color23 = IsGammaSpace() ? float4(0,0.3962264,0.02598071,1) : float4(0,0.130239,0.002010891,1);
			float4 Void31 = ( saturate( ( smoothstepResult33 * smoothstepResult63 * ( smoothstepResult63 * temp_output_19_0 ) ) ) + ( ( ( 1.0 - smoothstepResult63 ) * temp_output_19_0 ) * color23 ) );
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
326;73;1317;655;2119.652;-520.9865;1;True;True
Node;AmplifyShaderEditor.CommentaryNode;89;-3584.789,-317.2344;Inherit;False;2061.558;882.0482;Comment;15;90;91;71;70;86;85;69;68;84;57;56;95;61;83;93;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;58;-4453.297,-143.8845;Inherit;False;468.2869;391.6342;Comment;5;54;10;55;87;106;noise inputs;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;2;-4046.236,-609.0671;Inherit;False;Constant;_Tiling;Tiling;15;0;Create;True;0;0;False;0;23.6;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;4;-3832.47,-629.2827;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SinTimeNode;93;-3568,-48;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;96;-3712,64;Inherit;False;Constant;_sinscale;sin scale;5;0;Create;True;0;0;False;0;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;55;-4405.297,16.11549;Inherit;False;Property;_offset;offset;1;0;Create;True;0;0;False;0;0.34;0.34;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-4389.297,-95.88451;Inherit;False;Property;_noisescale;noise scale;2;0;Create;True;0;0;False;0;1.38;1.38;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;54;-4197.298,-15.88452;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RelayNode;49;-3339.784,-633.509;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;95;-3360,32;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;61;-3318.581,-251.2344;Inherit;False;Constant;_Vector3;Vector 3;1;0;Create;True;0;0;False;0;2,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;83;-3478.581,260.7656;Inherit;False;Constant;_Vector5;Vector 5;1;0;Create;True;0;0;False;0;-0.3,-0.2;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PannerNode;56;-3056,-272;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;84;-3056,224;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;87;-4101.298,96.11549;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;57;-3056,-16;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.VoronoiNode;69;-2864,-224;Inherit;True;0;0;1;0;1;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;2;FLOAT;0;FLOAT;1
Node;AmplifyShaderEditor.VoronoiNode;85;-2864,288;Inherit;True;0;0;1;0;1;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;2;FLOAT;0;FLOAT;1
Node;AmplifyShaderEditor.VoronoiNode;68;-2864,32;Inherit;True;0;0;1;0;1;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;2;FLOAT;0;FLOAT;1
Node;AmplifyShaderEditor.OneMinusNode;71;-2608,-224;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;70;-2608,32;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;86;-2608,288;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;91;-2431.444,136.2074;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;90;-2442.782,-63.97193;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;1;-2329.828,-1226.742;Inherit;False;2356.02;1281.301;Comment;25;22;31;29;26;33;24;32;16;47;18;20;14;13;12;63;81;6;5;3;98;65;82;100;52;104;Void;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;52;-2327.926,-380.8682;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RelayNode;65;-2406.504,-938.2534;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ClampOpNode;100;-2164.315,-404.4807;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;3;-2016,-1136;Inherit;False;Constant;_Vector0;Vector 0;15;0;Create;True;0;0;False;0;2,-2.5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;5;-2016,-656;Inherit;False;Constant;_Pan;Pan;15;0;Create;True;0;0;False;0;0,-1.2;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;6;-2016,-896;Inherit;False;Constant;_Vector2;Vector 2;15;0;Create;True;0;0;False;0;3,1.8;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PannerNode;12;-1851.308,-1216.356;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;81;-2109.121,-273.6665;Inherit;False;Property;_SmoothStepMin;SmoothStep Min;4;0;Create;True;0;0;False;0;0.05271714;0.81;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;82;-2107.299,-185.361;Inherit;False;Property;_SmoothStepMax;SmoothStep Max;3;0;Create;True;0;0;False;0;0.2665786;0.87;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;98;-2010.214,-484.8808;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;50;-2099.992,760.8358;Inherit;False;1334.885;770.3864;Comment;10;23;27;21;25;19;17;15;9;7;79;;1,1,1,1;0;0
Node;AmplifyShaderEditor.PannerNode;13;-1856,-976;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;14;-1856,-736;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;79;-1763.992,760.8358;Inherit;False;Constant;_Color1;Color 1;3;0;Create;True;0;0;False;0;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NoiseGeneratorNode;20;-1664,-928;Inherit;True;Simple;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;63;-1806.943,-335.4373;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;18;-1659.308,-1168.356;Inherit;True;Simple;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;16;-1664,-688;Inherit;True;Simple;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RelayNode;47;-1352.574,-331.3361;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;19;-1555.991,952.8359;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector2Node;32;-1400.528,-528.1993;Inherit;False;Constant;_Vector1;Vector 1;15;0;Create;True;0;0;False;0;0.35,0.52;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.DynamicAppendNode;24;-1360.722,-968.2426;Inherit;True;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.OneMinusNode;17;-1363.991,1064.836;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;33;-1161.291,-588.3572;Inherit;True;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT4;1,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-1181.954,-282.808;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-1203.991,1064.836;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;23;-1443.991,1336.836;Inherit;False;Constant;_Color0;Color 0;15;0;Create;True;0;0;False;0;0,0.3962264,0.02598071,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;-859.9489,-385.6003;Inherit;True;3;3;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;-931.9915,1176.836;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;104;-616.8155,-350.3453;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;29;-467.324,-226.0808;Inherit;True;2;2;0;FLOAT4;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;31;-236.5785,-298.2131;Inherit;False;Void;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;106;-4209.292,-96.4266;Inherit;False;NoiseScale;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;21;-1555.991,1240.836;Inherit;False;AntiVoidMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-1923.992,1048.836;Inherit;False;Constant;_Float1;Float 1;15;0;Create;True;0;0;False;0;0.01;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;7;-2067.992,840.8358;Inherit;True;Property;_Emission;Emission;0;0;Create;True;0;0;False;0;-1;220f8d46e4e5dc241b9b5323228dd6b7;220f8d46e4e5dc241b9b5323228dd6b7;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StepOpNode;15;-1779.992,952.8359;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;107;-3559.477,-683.845;Inherit;False;myVarName107;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;36;136.4726,-15.17425;Inherit;False;31;Void;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;343.1821,-9.031132;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Tear04;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;4;0;2;0
WireConnection;54;0;10;0
WireConnection;54;1;55;0
WireConnection;49;0;4;0
WireConnection;95;0;93;4
WireConnection;95;1;96;0
WireConnection;95;2;96;0
WireConnection;56;0;49;0
WireConnection;56;2;61;0
WireConnection;84;0;49;0
WireConnection;84;2;83;0
WireConnection;87;0;54;0
WireConnection;87;1;55;0
WireConnection;57;0;49;0
WireConnection;57;2;95;0
WireConnection;57;1;95;0
WireConnection;69;0;56;0
WireConnection;69;2;10;0
WireConnection;85;0;84;0
WireConnection;85;2;87;0
WireConnection;68;0;57;0
WireConnection;68;2;54;0
WireConnection;71;0;69;0
WireConnection;70;0;68;0
WireConnection;86;0;85;0
WireConnection;91;0;86;0
WireConnection;90;0;71;0
WireConnection;90;1;70;0
WireConnection;52;0;71;0
WireConnection;52;1;90;0
WireConnection;52;2;91;0
WireConnection;65;0;49;0
WireConnection;100;0;52;0
WireConnection;12;0;65;0
WireConnection;12;2;3;0
WireConnection;98;0;100;0
WireConnection;13;0;65;0
WireConnection;13;2;6;0
WireConnection;14;0;65;0
WireConnection;14;2;5;0
WireConnection;20;0;13;0
WireConnection;20;1;10;0
WireConnection;63;0;98;0
WireConnection;63;1;81;0
WireConnection;63;2;82;0
WireConnection;18;0;12;0
WireConnection;18;1;10;0
WireConnection;16;0;14;0
WireConnection;16;1;10;0
WireConnection;47;0;63;0
WireConnection;19;0;79;0
WireConnection;24;0;18;0
WireConnection;24;1;20;0
WireConnection;24;2;16;0
WireConnection;17;0;47;0
WireConnection;33;0;24;0
WireConnection;33;1;32;1
WireConnection;33;2;32;2
WireConnection;22;0;47;0
WireConnection;22;1;19;0
WireConnection;25;0;17;0
WireConnection;25;1;19;0
WireConnection;26;0;33;0
WireConnection;26;1;47;0
WireConnection;26;2;22;0
WireConnection;27;0;25;0
WireConnection;27;1;23;0
WireConnection;104;0;26;0
WireConnection;29;0;104;0
WireConnection;29;1;27;0
WireConnection;31;0;29;0
WireConnection;106;0;10;0
WireConnection;21;0;15;0
WireConnection;15;0;7;3
WireConnection;15;1;9;0
WireConnection;0;0;36;0
ASEEND*/
//CHKSM=0CC8CD598F85163E91398234CC4C30DB585FDB61