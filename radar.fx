
#include "transform.fx"

texture sMapTexture;
texture sOverlayTexture;
texture sMaskTexture;

float2 gUVPrePosition = float2( 0, 0 );
float2 gUVScale = float2(1, 1);
float2 gUVScaleCenter = float2( 0.5, 0.5 );
float gUVRotAngle = float(0);
float2 gUVRotCenter = float2( 0.5, 0.5 );
float2 gUVPosition = float2(0, 0 );


float3x3 getTextureTransform()
{
    return makeTextureTransform( gUVPrePosition, gUVScale, gUVScaleCenter, gUVRotAngle, gUVRotCenter, gUVPosition );
}

technique radar
{
    pass P0
    {

        Texture[0] = sMapTexture;
        TextureTransform[0] = getTextureTransform();
        TextureTransformFlags[0] = Count2;
        AddressU[0] = Clamp;
        AddressV[0] = Clamp;
        ColorOp[0] = Modulate;
        ColorArg1[0] = Texture;
        ColorArg2[0] = Diffuse;
        AlphaOp[0] = Modulate;
        AlphaArg1[0] = Texture;
        AlphaArg2[0] = Diffuse;

        Texture[1] = sOverlayTexture;
        TexCoordIndex[1] = 0;
        AddressU[1] = Clamp;
        AddressV[1] = Clamp;
        ColorOp[1] = ModulateInvAlpha_AddColor;
        ColorArg1[1] = Texture;
        ColorArg2[1] = Current;
        AlphaOp[1] = Add;
        AlphaArg1[1] = Texture;
        AlphaArg2[1] = Current;

        Texture[2] = sMaskTexture;
        TexCoordIndex[2] = 0;
        ColorOp[2] = SelectArg1;
        ColorArg1[2] = Current;
        AlphaOp[2] = Modulate;
        AlphaArg1[2] = Current;
        AlphaArg2[2] = Texture;
    }
}
