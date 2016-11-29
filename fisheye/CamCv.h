#pragma once

//
// OpenCV を使ったキャプチャ
//

// カメラ関連の処理
#include "Camera.h"

// OpenCV
#include <opencv2/highgui/highgui.hpp>

// OpenCV を使ってキャプチャするクラス
class CamCv
  : public Camera
{
  // OpenCV のキャプチャデバイス
  cv::VideoCapture camera;

  // OpenCV のキャプチャデバイスから取得した画像
  cv::Mat frame;

  // 露出と利得
  int exposure, gain;

  // キャプチャデバイスを初期化する
  bool init(int initial_width, int initial_height, int initial_fps)
  {
    // カメラの解像度を設定する
    if (initial_width > 0) camera.set(CV_CAP_PROP_FRAME_WIDTH, initial_width);
    if (initial_height > 0) camera.set(CV_CAP_PROP_FRAME_HEIGHT, initial_height);
    if (initial_fps > 0) camera.set(CV_CAP_PROP_FPS, initial_fps);

    // カメラから 1 フレームキャプチャする
    if (camera.grab())
    {
      // キャプチャした画像のサイズを取得する
      width = static_cast<GLsizei>(camera.get(CV_CAP_PROP_FRAME_WIDTH));
      height = static_cast<GLsizei>(camera.get(CV_CAP_PROP_FRAME_HEIGHT));

      // カメラの利得と露出を取得する
      gain = static_cast<GLsizei>(camera.get(CV_CAP_PROP_GAIN));
      exposure = static_cast<GLsizei>(camera.get(CV_CAP_PROP_EXPOSURE) * 10.0);

      // macOS だとせってできても 0 が返ってくる？
      if (width == 0) width = initial_width;
      if (height == 0) height = initial_height;

      // キャプチャされる画像のフォーマットを設定する
      format = GL_BGR;

      // キャプチャ用のメモリを確保する
      frame.create(width, height, CV_8UC3);

      // 画像がキャプチャされたことを記録する
      buffer = frame.data;
      return true;
    }

    return false;
  }

  // フレームをキャプチャする
  virtual void capture()
  {
    for (;;)
    {
      // キャプチャデバイスをロックする
      mtx.lock();

      // スレッドが実行中
      if (run)
      {
        // バッファが空でなかったら
        if (buffer)
        {
          // ただちにロックを解除して
          mtx.unlock();

          // 少し待つ
          std::this_thread::sleep_for(std::chrono::milliseconds(10L));
        }
        else
        {
          // 次のフレームが到着していたら
          if (camera.grab())
          {
            // フレームを切り出して
            camera.retrieve(frame, 3);

            // 画像を更新する
            buffer = frame.data;
          }

          // ロックを解除する
          mtx.unlock();
        }
      }
      else
      {
        // ロックを解除して
        mtx.unlock();

        // スレッドを終了する
        break;
      }
    }
  }

public:

  // コンストラクタ
  CamCv()
  {
  }

  // デストラクタ
  virtual ~CamCv()
  {
  }

  // カメラから入力する
  bool open(int device, int width = 0, int height = 0, int fps = 0)
  {
    // カメラを開く
    camera.open(device);

    // カメラが使えればカメラを初期化する
    if (camera.isOpened() && init(width, height, fps)) return true;

    // カメラが使えない
    return false;
  }

  // ファイル／ネットワークから入力する
  bool open(const std::string &file)
  {
    // ファイル／ネットワークを開く
    camera.open(file);

    // ファイル／ネットワークが使えれば初期化する
    if (camera.isOpened() && init(0, 0, 0)) return true;

    // ファイル／ネットワークが使えない
    return false;
  }

  // 露出を上げる
  virtual void increaseExposure()
  {
    if (camera.isOpened()) camera.set(CV_CAP_PROP_EXPOSURE, ++exposure * 0.1);
  }

  // 露出を下げる
  virtual void decreaseExposure()
  {
    if (camera.isOpened()) camera.set(CV_CAP_PROP_EXPOSURE, --exposure * 0.1);
  }

  // 利得を上げる
  virtual void increaseGain()
  {
    if (camera.isOpened()) camera.set(CV_CAP_PROP_GAIN, ++gain);
  }

  // 利得を下げる
  virtual void decreaseGain()
  {
    if (camera.isOpened()) camera.set(CV_CAP_PROP_GAIN, --gain);
  }
};
