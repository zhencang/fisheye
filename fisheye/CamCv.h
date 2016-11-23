#pragma once

//
// OpenCV ���g�����L���v�`��
//

// �J�����֘A�̏���
#include "Camera.h"

// OpenCV
#include <opencv2/highgui/highgui.hpp>

// OpenCV ���g���ăL���v�`������N���X
class CamCv
  : public Camera
{
  // OpenCV �̃L���v�`���f�o�C�X
  cv::VideoCapture camera;

  // OpenCV �̃L���v�`���f�o�C�X����擾�����摜
  cv::Mat frame;

  // �I�o�Ɨ���
  int exposure, gain;

  // �L���v�`���f�o�C�X������������
  bool init(int initial_width, int initial_height, int initial_fps)
  {
    // �J�����̉𑜓x��ݒ肷��
    if (initial_width > 0) camera.set(CV_CAP_PROP_FRAME_WIDTH, initial_width);
    if (initial_height > 0) camera.set(CV_CAP_PROP_FRAME_HEIGHT, initial_height);
    if (initial_fps > 0) camera.set(CV_CAP_PROP_FPS, initial_fps);

    // �J�������� 1 �t���[���L���v�`������
    if (camera.grab())
    {
      // �L���v�`�������摜�̃T�C�Y���擾����
      width = static_cast<GLsizei>(camera.get(CV_CAP_PROP_FRAME_WIDTH));
      height = static_cast<GLsizei>(camera.get(CV_CAP_PROP_FRAME_HEIGHT));

      // �J�����̗����ƘI�o���擾����
      gain = static_cast<GLsizei>(camera.get(CV_CAP_PROP_GAIN));
      exposure = static_cast<GLsizei>(camera.get(CV_CAP_PROP_EXPOSURE) * 10.0);

      // macOS ���Ƃ����Ăł��Ă� 0 ���Ԃ��Ă���H
      if (width == 0) width = initial_width;
      if (height == 0) height = initial_height;

      // �L���v�`�������摜�̃t�H�[�}�b�g��ݒ肷��
      format = GL_BGR;

      // �L���v�`���p�̃��������m�ۂ���
      frame.create(width, height, CV_8UC3);

      // �摜���L���v�`�����ꂽ���Ƃ��L�^����
      buffer = frame.data;
      return true;
    }

    return false;
  }

  // �t���[�����L���v�`������
  virtual void capture()
  {
    // �X���b�h�����s���̊�
    while (run)
    {
      // �L���v�`���f�o�C�X�����b�N����
      mtx.lock();

      // �o�b�t�@����łȂ�������
      if (buffer)
      {
        // ���b�N����������
        mtx.unlock();

        // �����҂�
        std::this_thread::sleep_for(std::chrono::milliseconds(10L));
      }
      else
      {
        // ���̃t���[�����������Ă�����
        if (camera.grab())
        {
          // �t���[����؂�o��
          camera.retrieve(frame, 3);

          // �摜���X�V����
          buffer = frame.data;
        }

        // �L���v�`���f�o�C�X���A�����b�N����
        mtx.unlock();
      }
    }
  }

public:

  // �R���X�g���N�^
  CamCv()
  {
  }

  // �f�X�g���N�^
  virtual ~CamCv()
  {
  }

  // �J����������͂���
  bool open(int device, int width = 0, int height = 0, int fps = 0)
  {
    // �J�������J��
    camera.open(device);

    // �J�������g����΃J����������������
    if (camera.isOpened() && init(width, height, fps)) return true;

    // �J�������g���Ȃ�
    return false;
  }

  // �t�@�C���^�l�b�g���[�N������͂���
  bool open(const std::string &file)
  {
    // �t�@�C���^�l�b�g���[�N���J��
    camera.open(file);

    // �t�@�C���^�l�b�g���[�N���g����Ώ���������
    if (camera.isOpened() && init(0, 0, 0)) return true;

    // �t�@�C���^�l�b�g���[�N���g���Ȃ�
    return false;
  }

  // �I�o���グ��
  virtual void increaseExposure()
  {
    if (camera.isOpened()) camera.set(CV_CAP_PROP_EXPOSURE, ++exposure * 0.1);
  }

  // �I�o��������
  virtual void decreaseExposure()
  {
    if (camera.isOpened()) camera.set(CV_CAP_PROP_EXPOSURE, --exposure * 0.1);
  }

  // �������グ��
  virtual void increaseGain()
  {
    if (camera.isOpened()) camera.set(CV_CAP_PROP_GAIN, ++gain);
  }

  // ������������
  virtual void decreaseGain()
  {
    if (camera.isOpened()) camera.set(CV_CAP_PROP_GAIN, --gain);
  }
};