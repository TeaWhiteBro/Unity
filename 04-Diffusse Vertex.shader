// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

shader "TeaWhite/04-Diffuse Vertex "
{
    SubShader
    {
        Pass
        {
            Tags{"LightMode" = "ForwardBase"}
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            //取得第一个直射光的颜色
            #include "Lighting.cginc" 
            //application to vertex
            struct a2v
            {
                float4 vertex:POSITION;//将模型空间的顶点坐标填充给vertex
                float3 normal:NORMAL;
            };
            //vertex to fragment
            struct v2f
            {
                float4 position:SV_POSITION;
                fixed3 color:COLOR;
            };

            v2f vert(a2v v)
            {
                v2f f;
                f.position = UnityObjectToClipPos(v.vertex);
                fixed3 normalDir = normalize(mul(v.normal,(float3x3)unity_WorldToObject));
                fixed3 lightDir = normalize(_WorldSpaceLightPos0.xyz);//因为是平行光，光的位置就是光的方向
                fixed3 Diffuse = _LightColor0.rgb * max(0,dot(normalDir,lightDir));//取得漫反射的颜色
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.rgb;
                f.color = Diffuse + ambient;            
                return f;
            }

            fixed4 frag(v2f f):SV_TARGET
            {
                return fixed4(f.color,1);
            }
            ENDCG

        }
    
    }
}