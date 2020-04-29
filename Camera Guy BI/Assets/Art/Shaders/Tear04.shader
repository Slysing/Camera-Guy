// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Tear04"
{
	Properties
	{
		_VoidMask("VoidMask", 2D) = "white" {}
		_VoidNoiseScaleOffset("Void Noise Scale Offset", Float) = 0.34
		_VoidNoiseScale("Void Noise Scale", Float) = 1.38
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

		uniform float _VoidNoiseScale;
		uniform float _SmoothStepMin;
		uniform float _SmoothStepMax;
		uniform float _VoidNoiseScaleOffset;
		uniform sampler2D _VoidMask;
		uniform float4 _VoidMask_ST;
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
			float2 _Vector1 = float2(0.35,0.52);
			float4 temp_cast_0 = (_Vector1.x).xxxx;
			float4 temp_cast_1 = (_Vector1.y).xxxx;
			float2 temp_cast_2 = (23.6).xx;
			float2 uv_TexCoord4 = i.uv_texcoord * temp_cast_2;
			float2 UVCoordinates107 = uv_TexCoord4;
			float2 panner12 = ( 1.0 * _Time.y * float2( 2,-2.5 ) + UVCoordinates107);
			float NoiseScale106 = _VoidNoiseScale;
			float simpleNoise18 = SimpleNoise( panner12*NoiseScale106 );
			float2 panner13 = ( 1.0 * _Time.y * float2( 3,1.8 ) + UVCoordinates107);
			float simpleNoise20 = SimpleNoise( panner13*NoiseScale106 );
			float2 panner14 = ( 1.0 * _Time.y * float2( 0,-1.2 ) + UVCoordinates107);
			float simpleNoise16 = SimpleNoise( panner14*NoiseScale106 );
			float4 appendResult24 = (float4(simpleNoise18 , simpleNoise20 , simpleNoise16 , 0.0));
			float4 smoothstepResult33 = smoothstep( temp_cast_0 , temp_cast_1 , appendResult24);
			float4 VoidColor127 = smoothstepResult33;
			float time69 = 0.0;
			float2 panner56 = ( 1.0 * _Time.y * float2( 2,1 ) + UVCoordinates107);
			float2 coords69 = panner56 * NoiseScale106;
			float2 id69 = 0;
			float voroi69 = voronoi69( coords69, time69,id69, 0 );
			float temp_output_71_0 = ( 1.0 - voroi69 );
			float temp_output_54_0 = ( _VoidNoiseScale + _VoidNoiseScaleOffset );
			float time68 = 0.0;
			float temp_output_95_0 = (_SinTime.w*0.5 + 0.5);
			float2 temp_cast_3 = (temp_output_95_0).xx;
			float2 panner57 = ( temp_output_95_0 * temp_cast_3 + UVCoordinates107);
			float2 coords68 = panner57 * temp_output_54_0;
			float2 id68 = 0;
			float voroi68 = voronoi68( coords68, time68,id68, 0 );
			float time85 = 0.0;
			float2 panner84 = ( 1.0 * _Time.y * float2( -0.3,-0.2 ) + UVCoordinates107);
			float2 coords85 = panner84 * ( temp_output_54_0 + _VoidNoiseScaleOffset );
			float2 id85 = 0;
			float voroi85 = voronoi85( coords85, time85,id85, 0 );
			float clampResult91 = clamp( ( 1.0 - voroi85 ) , 0.0 , 1.0 );
			float clampResult100 = clamp( ( temp_output_71_0 * ( temp_output_71_0 + ( 1.0 - voroi68 ) ) * clampResult91 ) , 0.0 , 1.0 );
			float smoothstepResult63 = smoothstep( _SmoothStepMin , _SmoothStepMax , ( 1.0 - clampResult100 ));
			float NoiseMask125 = smoothstepResult63;
			float2 uv_VoidMask = i.uv_texcoord * _VoidMask_ST.xy + _VoidMask_ST.zw;
			float2 uv_Albedo = i.uv_texcoord * _Albedo_ST.xy + _Albedo_ST.zw;
			float4 Void31 = ( ( VoidColor127 * NoiseMask125 * tex2D( _VoidMask, uv_VoidMask ) ) + ( ( 1.0 - NoiseMask125 ) * tex2D( _Albedo, uv_Albedo ) ) );
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
345;73;1107;586;4846.746;1952.574;6.261215;True;True
Node;AmplifyShaderEditor.CommentaryNode;124;-2441.48,-989.1621;Inherit;False;660;209;Comment;3;4;107;2;UV coordinates;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;58;-3025.324,-182.5635;Inherit;False;539.5845;388.2603;Comment;5;87;54;55;106;10;noise inputs;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;2;-2389.777,-933.8794;Inherit;False;Constant;_VoidTiling;Void Tiling;15;0;Create;True;0;0;False;0;23.6;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;122;-2471.281,-740.0858;Inherit;False;1380.762;998.7076;Comment;23;52;90;91;86;70;71;69;68;85;121;116;56;117;57;84;119;118;95;120;61;83;96;93;Noise Mask;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;55;-3010.624,37.33651;Inherit;False;Property;_VoidNoiseScaleOffset;Void Noise Scale Offset;1;0;Create;True;0;0;False;0;0.34;0.34;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-2968.324,-134.5635;Inherit;False;Property;_VoidNoiseScale;Void Noise Scale;2;0;Create;True;0;0;False;0;1.38;1.38;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;4;-2223.95,-939.1621;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;54;-2749.026,-53.26351;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;96;-2452.961,-254.4486;Inherit;False;Constant;_VoidNoisesinscale;Void Noise sin scale;5;0;Create;True;0;0;False;0;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SinTimeNode;93;-2385.673,-402.0858;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;107;-2007.48,-933.8794;Inherit;False;UVCoordinates;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;120;-2241.673,-50.08572;Inherit;False;107;UVCoordinates;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;119;-2241.673,-370.0858;Inherit;False;107;UVCoordinates;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;106;-2749.319,-135.1056;Inherit;False;NoiseScale;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;87;-2604.615,19.03652;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;95;-2225.673,-290.0858;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;118;-2225.673,-690.0858;Inherit;False;107;UVCoordinates;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;83;-2233.671,29.91424;Inherit;False;Constant;_VoidNoisePan2;Void Noise Pan 2;1;0;Create;True;0;0;False;0;-0.3,-0.2;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;61;-2214.118,-613.1229;Inherit;False;Constant;_VoidNoisePan1;Void Noise Pan 1;1;0;Create;True;0;0;False;0;2,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RelayNode;116;-2161.673,173.9142;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;56;-2017.673,-690.0858;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RelayNode;117;-2161.673,-162.0858;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;121;-2017.673,-562.0858;Inherit;False;106;NoiseScale;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;57;-2017.673,-370.0858;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;84;-2017.673,-50.08572;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.VoronoiNode;85;-1825.673,-50.08572;Inherit;True;0;0;1;0;1;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;2;FLOAT;0;FLOAT;1
Node;AmplifyShaderEditor.VoronoiNode;68;-1825.673,-370.0858;Inherit;True;0;0;1;0;1;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;2;FLOAT;0;FLOAT;1
Node;AmplifyShaderEditor.VoronoiNode;69;-1825.673,-690.0858;Inherit;True;0;0;1;0;1;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;2;FLOAT;0;FLOAT;1
Node;AmplifyShaderEditor.OneMinusNode;71;-1569.673,-690.0858;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;86;-1569.673,-50.08572;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;70;-1569.673,-370.0858;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;90;-1377.673,-530.0858;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;91;-1425.673,-50.08572;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;112;-1742.271,-1606.322;Inherit;False;1434.828;809.0751;Comment;19;127;33;24;32;16;20;18;115;14;113;114;12;13;109;110;6;5;108;3;Color;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector2Node;5;-1678.196,-997.663;Inherit;False;Constant;_VoidColorPan3;Void Color Pan 3;15;0;Create;True;0;0;False;0;0,-1.2;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.CommentaryNode;123;-1067.351,-737.9971;Inherit;False;766.1311;377.041;Comment;6;63;81;98;82;100;125;Noise Mask Clamp;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;52;-1222.472,-594.0858;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;6;-1678.197,-1235.967;Inherit;False;Constant;_VoidColorPan2;Void Color Pan 2;15;0;Create;True;0;0;False;0;3,1.8;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.GetLocalVarNode;109;-1692.271,-1315.967;Inherit;False;107;UVCoordinates;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;110;-1692.271,-1075.967;Inherit;False;107;UVCoordinates;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;108;-1676.271,-1555.966;Inherit;False;107;UVCoordinates;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;3;-1661.234,-1477.662;Inherit;False;Constant;_VoidColorPan1;Void Color Pan 1;15;0;Create;True;0;0;False;0;2,-2.5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PannerNode;12;-1479.58,-1556.322;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;114;-1484.934,-1192.025;Inherit;False;106;NoiseScale;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;14;-1484.271,-1075.967;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;115;-1478.859,-1431.848;Inherit;False;106;NoiseScale;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;113;-1484.934,-952.0251;Inherit;False;106;NoiseScale;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;100;-1019.351,-673.9971;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;13;-1484.271,-1315.967;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;18;-1287.58,-1508.322;Inherit;True;Simple;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;20;-1292.272,-1267.967;Inherit;True;Simple;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;82;-1019.351,-465.9969;Inherit;False;Property;_SmoothStepMax;SmoothStep Max;3;0;Create;True;0;0;False;0;0.2665786;0.87;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;81;-1019.351,-545.9969;Inherit;False;Property;_SmoothStepMin;SmoothStep Min;4;0;Create;True;0;0;False;0;0.05271714;0.81;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;98;-875.3512,-673.9971;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;16;-1292.272,-1027.967;Inherit;True;Simple;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;24;-988.994,-1308.209;Inherit;True;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.Vector2Node;32;-973.6483,-1062.82;Inherit;False;Constant;_Vector1;Vector 1;15;0;Create;True;0;0;False;0;0.35,0.52;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SmoothstepOpNode;63;-715.3512,-673.9971;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;33;-725.6669,-1194.35;Inherit;True;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT4;1,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;50;-1047.372,82.6727;Inherit;False;642.1324;350.4435;Comment;4;129;111;130;27;Albedo;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;125;-493.0987,-674.2159;Inherit;False;NoiseMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;132;-1041.905,-328.5335;Inherit;False;633.0978;395.9815;Comment;4;128;126;7;26;Masked Color;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;127;-504.3072,-1192.025;Inherit;False;VoidColor;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;129;-1011.681,131.5697;Inherit;False;125;NoiseMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;7;-995.8051,-138.0334;Inherit;True;Property;_VoidMask;VoidMask;0;0;Create;True;0;0;False;0;-1;0fdcc6c12f052274396a7dc221c5128e;220f8d46e4e5dc241b9b5323228dd6b7;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;128;-873.4049,-290.2334;Inherit;False;127;VoidColor;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;126;-879.08,-214.1335;Inherit;False;125;NoiseMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;130;-835.6808,131.5697;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;111;-979.6815,211.5697;Inherit;True;Property;_Albedo;Albedo;5;0;Create;True;0;0;False;0;-1;14656c99dff77cb4ba68513ede2b1cb9;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;-635.883,136.6078;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;-639.905,-150.5334;Inherit;True;3;3;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;29;-374.5517,-145.9209;Inherit;True;2;2;0;FLOAT4;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;31;-146.2629,-150.4987;Inherit;False;Void;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;36;136.4726,-15.17425;Inherit;False;31;Void;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;343.1821,-9.031132;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Tear04;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;4;0;2;0
WireConnection;54;0;10;0
WireConnection;54;1;55;0
WireConnection;107;0;4;0
WireConnection;106;0;10;0
WireConnection;87;0;54;0
WireConnection;87;1;55;0
WireConnection;95;0;93;4
WireConnection;95;1;96;0
WireConnection;95;2;96;0
WireConnection;116;0;87;0
WireConnection;56;0;118;0
WireConnection;56;2;61;0
WireConnection;117;0;54;0
WireConnection;57;0;119;0
WireConnection;57;2;95;0
WireConnection;57;1;95;0
WireConnection;84;0;120;0
WireConnection;84;2;83;0
WireConnection;85;0;84;0
WireConnection;85;2;116;0
WireConnection;68;0;57;0
WireConnection;68;2;117;0
WireConnection;69;0;56;0
WireConnection;69;2;121;0
WireConnection;71;0;69;0
WireConnection;86;0;85;0
WireConnection;70;0;68;0
WireConnection;90;0;71;0
WireConnection;90;1;70;0
WireConnection;91;0;86;0
WireConnection;52;0;71;0
WireConnection;52;1;90;0
WireConnection;52;2;91;0
WireConnection;12;0;108;0
WireConnection;12;2;3;0
WireConnection;14;0;110;0
WireConnection;14;2;5;0
WireConnection;100;0;52;0
WireConnection;13;0;109;0
WireConnection;13;2;6;0
WireConnection;18;0;12;0
WireConnection;18;1;115;0
WireConnection;20;0;13;0
WireConnection;20;1;114;0
WireConnection;98;0;100;0
WireConnection;16;0;14;0
WireConnection;16;1;113;0
WireConnection;24;0;18;0
WireConnection;24;1;20;0
WireConnection;24;2;16;0
WireConnection;63;0;98;0
WireConnection;63;1;81;0
WireConnection;63;2;82;0
WireConnection;33;0;24;0
WireConnection;33;1;32;1
WireConnection;33;2;32;2
WireConnection;125;0;63;0
WireConnection;127;0;33;0
WireConnection;130;0;129;0
WireConnection;27;0;130;0
WireConnection;27;1;111;0
WireConnection;26;0;128;0
WireConnection;26;1;126;0
WireConnection;26;2;7;0
WireConnection;29;0;26;0
WireConnection;29;1;27;0
WireConnection;31;0;29;0
WireConnection;0;0;36;0
ASEEND*/
//CHKSM=35F3E514723FA129951B5E5F5270508392D3CFA3