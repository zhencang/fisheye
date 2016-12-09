#version 150 core
#extension GL_ARB_explicit_attrib_location : enable

//
// 正距円筒図法のテクスチャをサンプリング
//

// イメージサークルの半径と中心位置
uniform vec4 circle;

// テクスチャ
uniform sampler2D image;

// テクスチャのサイズ
vec2 size = textureSize(image, 0);

// イメージサークルのテクスチャ空間上のスケール
vec2 scale = vec2(0.15915494, -0.31830989) / circle.st;

// イメージサークルのテクスチャ空間上の中心位置
vec2 center = circle.pq + 0.5;

// 視線ベクトル
in vec4 vector;

// フラグメントの色
layout (location = 0) out vec4 fc;

void main(void)
{
  // 視線ベクトルを正規化する
  vec4 v = normalize(vector);

  // テクスチャ座標を求める
  vec2 texcoord = atan(v.xy, vec2(v.z, length(v.xz))) * scale + center;

  // 画素の陰影を求める
  fc = texture(image, texcoord);
}
