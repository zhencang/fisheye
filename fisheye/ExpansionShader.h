#pragma once

//
// 平面展開に使うシェーダ
//

// シェーダのセットとパラメータ
struct ExpansionShader
{
  // バーテックスシェーダのソースプログラムのファイル名
  const char *vsrc;

  // フラグメントシェーダのソースプログラムのファイル名
  const char *fsrc;

  // イメージサークルの半径と中心位置
  const float circle[4];
};

// シェーダの種類
const ExpansionShader shader_type[] =
{
  // 0: 通常のカメラ
  { "fixed.vert",     "normal.frag", 1.0f, 1.0f, 0.0f, 0.0f },

  // 1: 通常のカメラで視点を回転
  { "rectangle.vert", "normal.frag", 1.0f, 1.0f, 0.0f, 0.0f },

  // 2: 正距円筒図法のパノラマ画像
  { "panorama.vert",  "normal.frag", 1.0f, 1.0f, 0.0f, 0.0f },

  // 3: 180°魚眼カメラ : 3.1415927 / 2 (≒ 180°/ 2)
  { "fisheye.vert",   "normal.frag", 1.570796327f, 1.570796327f, 0.0f, 0.0f },

  // 4: 185°魚眼カメラ (FUJINON FE185C046HA-1 + SENTECH STC-MCE132U3V) : 3.2288591 / 2 (≒ 185°/ 2)
  { "fisheye.vert",   "normal.frag", 1.614429558f, 1.614429558f, 0.0f, 0.0f },

  // 5: 220°魚眼カメラ (Kodak PIXPRO SP360 4K, 手振れ補正あり) : 3.8397243 / 2 (≒ 220°/ 2)
  { "fisheye.vert",   "normal.frag", 1.919862177f, 1.919862177f, 0.0f, 0.0f },

  // 6: 235°魚眼カメラ (Kodak PIXPRO SP360 4K, 手振れ補正なし) : 4.1015237 / 2 (≒ 235°/ 2)
  { "fisheye.vert",   "normal.frag", 2.050761871f, 2.050761871f, 0.0f, 0.0f },

  // 7: RICHO THETA のライブストリーミング映像
  { "theta.vert",     "theta.frag",  0.25075f, 0.25075f, 0.0f, 0.0f }
};
