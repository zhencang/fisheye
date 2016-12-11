#version 150 core
#extension GL_ARB_explicit_attrib_location : enable

//
// simple.vert
//
//   単純な陰影付けを行ってオブジェクトを描画するシェーダ
//

// 光源
uniform vec4 lamb;                                  // 環境光成分
uniform vec4 ldiff;                                 // 拡散反射光成分
uniform vec4 lspec;                                 // 鏡面反射光成分
uniform vec4 pl;                                    // 位置

// 材質
uniform vec4 kamb;                                  // 環境光の反射係数
uniform vec4 kdiff;                                 // 拡散反射係数
uniform vec4 kspec;                                 // 鏡面反射係数
uniform float kshi;                                 // 輝き係数

// 変換行列
uniform mat4 mw;                                    // 視点座標系への変換行列
uniform mat4 mc;                                    // クリッピング座標系への変換行列
uniform mat4 mg;                                    // 法線ベクトルの変換行列

// 頂点属性
layout (location = 0) in vec4 pv;                   // ローカル座標系の頂点位置
layout (location = 1) in vec4 nv;                   // 頂点の法線ベクトル

// ラスタライザに送る頂点属性
out vec4 idiff;                                     // 拡散反射光強度
out vec4 ispec;                                     // 鏡面反射光強度

void main(void)
{
  gl_Position = mc * pv;

  // 陰影
  vec4 p = mw * pv;                                 // 視点座標系の頂点の位置
  vec4 q = pl;                                      // 視点座標系の光源の位置
  vec3 v = normalize(p.xyz / p.w);                  // 視線ベクトル
  vec3 l = normalize((q * p.w - p * q.w).xyz);      // 光線ベクトル
  vec3 n = normalize((mg * nv).xyz);                // 法線ベクトル
  vec3 h = normalize(l - v);                        // 中間ベクトル

  // 拡散反射光成分
  idiff = max(dot(n, l), 0.0) * kdiff * ldiff + kamb * lamb;

  // 鏡面反射光成分
  ispec = pow(max(dot(n, h), 0.0), kshi) * kspec * lspec;
}
