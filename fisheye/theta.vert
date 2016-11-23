#version 150 core

//
// RICOH THETA S のライブストリーミング映像の平面展開
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

// イメージサークルのアスペクト比と Y 方向のオフセット
float aspect = circle.t * size.x / size.y;
float offset = aspect + circle.q;

// 前後のイメージサークルの半径
vec2 radius_f = vec2( circle.s, aspect);
vec2 radius_b = vec2(-circle.s, aspect);

// 前後のイメージサークルの中心
vec2 center_f = vec2(0.75 + circle.p, offset);
vec2 center_b = vec2(0.25 - circle.p, offset);

// テクスチャ座標
out vec2 texcoord_f;
out vec2 texcoord_b;

// 前後のテクスチャの混合比
out float blend;

void main(void)
{
  // 頂点位置
  vec2 position = vec2(gl_VertexID >> 1, gl_InstanceID + 1 - (gl_VertexID & 1)) * gap - 1.0;

  // 視線ベクトル
  vec4 vector = normalize(rotation * vec4(position * screen.st + screen.pq, focal, 0.0));

  // この方向ベクトルの相対的な仰角 [-1, 1]
  float angle = acos(vector.z) * 0.63661977 - 1.0;

  // 前後のテクスチャの混合比
  blend = 0.5 - clamp(angle * 25.0, -0.5, 0.5);

  // この方向ベクトルの yx 上での方向ベクトル
  vec2 orientation = normalize(vector.yx) * 0.885;

  // 前後のテクスチャの色をサンプリングする
  texcoord_f = (1.0 - angle) * orientation * radius_f + center_f;
  texcoord_b = (1.0 + angle) * orientation * radius_b + center_b;
  
  // 頂点位置をそのままラスタライザに送ればクリッピング空間全面に描く
  gl_Position = vec4(position, 0.0, 1.0);
}
