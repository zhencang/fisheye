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

// 背景テクスチャの半径と中心位置
uniform vec4 circle;

// 背景テクスチャ
uniform sampler2D image;

// 背景テクスチャのサイズ
vec2 size = textureSize(image, 0);

// 背景テクスチャのテクスチャ空間上の半径と中心
vec2 radius = circle.st * vec2(0.25, 0.25 * size.x / size.y);
vec2 center = vec2(radius.s - circle.p, radius.t - circle.q);

// 前後の背景テクスチャのテクスチャ空間上の半径
vec2 radius_f = vec2(-radius.s, radius.t);
vec2 radius_b = vec2( radius.s, radius.t);

// 前後の背景テクスチャのテクスチャ空間上の中心
vec2 center_f = vec2(0.5 - center.s, center.t);
vec2 center_b = vec2(0.5 + center.s, center.t);

// テクスチャ座標
out vec2 texcoord_f;
out vec2 texcoord_b;

// 前後のテクスチャの混合比
out float blend;

void main(void)
{
  // 頂点位置
  //   各頂点において gl_VertexID が 0, 1, 2, 3, ... のように割り当てられるから、
  //     x = gl_VertexID >> 1      = 0, 0, 1, 1, 2, 2, 3, 3, ...
  //     y = 1 - (gl_VertexID & 1) = 1, 0, 1, 0, 1, 0, 1, 0, ...
  //   のように GL_TRIANGLE_STRIP 向けの頂点座標値が得られる。
  //   y に gl_InstaceID を足せば glDrawArrayInstanced() のインスタンスごとに y が変化する。
  //   これに格子の間隔 gap をかけて 1 を引けば縦横 [-1, 1] の範囲の点群 position が得られる。
  int x = gl_VertexID >> 1;
  int y = gl_InstanceID + 1 - (gl_VertexID & 1);
  vec2 position = vec2(x, y) * gap - 1.0;

  // 視線ベクトル
  //   position にスクリーンの大きさ screen.st をかけて中心位置 screen.pq を足せば、
  //   スクリーン上の点の位置が得られるから、原点にある視点からこの点に向かう視線は、
  //   焦点距離 focal を Z 座標に用いて (position, focal) となる。
  //   これを回転したあと正規化してその方向の視線単位ベクトルを得る。
  vec4 vector = normalize(rotation * vec4(position * screen.st + screen.pq, focal, 0.0));

  // この方向ベクトルの相対的な仰角
  //   acos(vector.z) * 2 / π - 1 → [-1, 1]
  float angle = acos(vector.z) * 0.63661977 - 1.0;

  // 前後のテクスチャの混合比
  blend = smoothstep(0.02, -0.02, angle);

  // この方向ベクトルの yx 上での方向ベクトル
  vec2 orientation = normalize(vector.yx) * 0.885;

  // 前後のテクスチャの色をサンプリングする
  texcoord_f = (1.0 - angle) * orientation * radius_f + center_f;
  texcoord_b = (1.0 + angle) * orientation * radius_b + center_b;

  // 頂点位置をそのままラスタライザに送ればクリッピング空間全面に描く
  gl_Position = vec4(position, 0.0, 1.0);
}
