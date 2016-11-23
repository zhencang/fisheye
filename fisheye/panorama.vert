#version 150 core

//
// 正距円筒図法のパノラマ画像の平面展開
//

// スクリーンの格子間隔
uniform vec2 gap;

// スクリーンの大きさと中心位置
uniform vec4 screen;

// スクリーンまでの焦点距離
uniform float focal;

// スクリーンを回転する変換行列
uniform mat4 rotation;

// イメージサークルの半径と中心位置
uniform vec4 circle;

// テクスチャ
uniform sampler2D image;

// テクスチャのサイズ
vec2 size = textureSize(image, 0);

// イメージサークルのテクスチャ空間上のスケール
vec2 scale = vec2(-0.15915494, -0.31830989) * circle.st;

// イメージサークルのテクスチャ空間上の中心位置
vec2 center = circle.pq + 0.5;

// テクスチャ座標
out vec2 texcoord;

void main(void)
{
  // 頂点位置
  vec2 position = vec2(gl_VertexID >> 1, gl_InstanceID + 1 - (gl_VertexID & 1)) * gap - 1.0;

  // 視線ベクトル
  vec4 vector = rotation * vec4(position * screen.st + screen.pq, focal, 0.0);
  
  // テクスチャ座標
  texcoord = atan(vector.xy, vec2(vector.z, length(vector.xz))) * scale + center;
  
  // 頂点位置をそのままラスタライザに送ればクリッピング空間全面に描く
  gl_Position = vec4(position, 0.0, 1.0);
}
