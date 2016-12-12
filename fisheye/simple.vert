#version 150 core
#extension GL_ARB_explicit_attrib_location : enable

//
// simple.vert
//
//   �P���ȉA�e�t�����s���ăI�u�W�F�N�g��`�悷��V�F�[�_
//

// ����
uniform vec4 lamb;                                  // ��������
uniform vec4 ldiff;                                 // �g�U���ˌ�����
uniform vec4 lspec;                                 // ���ʔ��ˌ�����
uniform vec4 pl;                                    // �ʒu

// �ގ�
uniform vec4 kamb;                                  // �����̔��ˌW��
uniform vec4 kdiff;                                 // �g�U���ˌW��
uniform vec4 kspec;                                 // ���ʔ��ˌW��
uniform float kshi;                                 // �P���W��

// �ϊ��s��
uniform mat4 mw;                                    // ���_���W�n�ւ̕ϊ��s��
uniform mat4 mc;                                    // �N���b�s���O���W�n�ւ̕ϊ��s��
uniform mat4 mg;                                    // �@���x�N�g���̕ϊ��s��

// ���_����
layout (location = 0) in vec4 pv;                   // ���[�J�����W�n�̒��_�ʒu
layout (location = 1) in vec4 nv;                   // ���_�̖@���x�N�g��

// ���X�^���C�U�ɑ��钸�_����
out vec4 idiff;                                     // �g�U���ˌ����x
out vec4 ispec;                                     // ���ʔ��ˌ����x

void main(void)
{
  gl_Position = mc * pv;

  // �A�e
  vec4 p = mw * pv;                                 // ���_���W�n�̒��_�̈ʒu
  vec4 q = pl;                                      // ���_���W�n�̌����̈ʒu
  vec3 v = normalize(p.xyz / p.w);                  // �����x�N�g��
  vec3 l = normalize((q * p.w - p * q.w).xyz);      // �����x�N�g��
  vec3 n = normalize((mg * nv).xyz);                // �@���x�N�g��
  vec3 h = normalize(l - v);                        // ���ԃx�N�g��

  // �g�U���ˌ�����
  idiff = max(dot(n, l), 0.0) * kdiff * ldiff + kamb * lamb;

  // ���ʔ��ˌ�����
  ispec = pow(max(dot(n, h), 0.0), kshi) * kspec * lspec;
}
