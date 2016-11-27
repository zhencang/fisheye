#pragma once

//
// ���ʓW�J�Ɏg���V�F�[�_
//

// �V�F�[�_�̃Z�b�g�ƃp�����[�^
struct ExpansionShader
{
  // �o�[�e�b�N�X�V�F�[�_�̃\�[�X�v���O�����̃t�@�C����
  const char *vsrc;

  // �t���O�����g�V�F�[�_�̃\�[�X�v���O�����̃t�@�C����
  const char *fsrc;

  // �C���[�W�T�[�N���̔��a�ƒ��S�ʒu
  const float circle[4];
};

// �V�F�[�_�̎��
const ExpansionShader shader_type[] =
{
  // 0: �ʏ�̃J����
  { "fixed.vert",     "normal.frag", 1.0f, 1.0f, 0.0f, 0.0f },

  // 1: �ʏ�̃J�����Ŏ��_����]
  { "rectangle.vert", "normal.frag", 1.0f, 1.0f, 0.0f, 0.0f },

  // 2: �����~���}�@�̃p�m���}�摜
  { "panorama.vert",  "normal.frag", 1.0f, 1.0f, 0.0f, 0.0f },

  // 3: 180������J���� : 3.1415927 / 2 (�� 180��/ 2)
  { "fisheye.vert",   "normal.frag", 1.570796327f, 1.570796327f, 0.0f, 0.0f },

  // 4: 185������J���� (FUJINON FE185C046HA-1 + SENTECH STC-MCE132U3V) : 3.2288591 / 2 (�� 185��/ 2)
  { "fisheye.vert",   "normal.frag", 1.614429558f, 1.614429558f, 0.0f, 0.0f },

  // 5: 220������J���� (Kodak PIXPRO SP360 4K, ��U��␳����) : 3.8397243 / 2 (�� 220��/ 2)
  { "fisheye.vert",   "normal.frag", 1.919862177f, 1.919862177f, 0.0f, 0.0f },

  // 6: 235������J���� (Kodak PIXPRO SP360 4K, ��U��␳�Ȃ�) : 4.1015237 / 2 (�� 235��/ 2)
  { "fisheye.vert",   "normal.frag", 2.050761871f, 2.050761871f, 0.0f, 0.0f },

  // 7: RICHO THETA �̃��C�u�X�g���[�~���O�f��
  { "theta.vert",     "theta.frag",  0.25075f, 0.25075f, 0.0f, 0.0f }
};
