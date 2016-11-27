#version 150 core

//
// RICOH THETA S �̃��C�u�X�g���[�~���O�f���̕��ʓW�J
//

// �X�N���[���̊i�q�Ԋu
uniform vec2 gap;

// �X�N���[���̑傫���ƒ��S�ʒu
uniform vec4 screen;

// �X�N���[���܂ł̏œ_����
uniform float focal;

// �X�N���[������]����ϊ��s��
uniform mat4 rotation;

// �C���[�W�T�[�N���̔��a�ƒ��S�ʒu
uniform vec4 circle;

// �e�N�X�`��
uniform sampler2D image;

// �e�N�X�`���̃T�C�Y
vec2 size = textureSize(image, 0);

// �C���[�W�T�[�N���̃A�X�y�N�g��� Y �����̃I�t�Z�b�g
float aspect = circle.t * size.x / size.y;
float offset = aspect + circle.q;

// �O��̃C���[�W�T�[�N���̔��a
vec2 radius_f = vec2( circle.s, aspect);
vec2 radius_b = vec2(-circle.s, aspect);

// �O��̃C���[�W�T�[�N���̒��S
vec2 center_f = vec2(0.75 + circle.p, offset);
vec2 center_b = vec2(0.25 - circle.p, offset);

// �e�N�X�`�����W
out vec2 texcoord_f;
out vec2 texcoord_b;

// �O��̃e�N�X�`���̍�����
out float blend;

void main(void)
{
  // ���_�ʒu
  vec2 position = vec2(gl_VertexID >> 1, gl_InstanceID + 1 - (gl_VertexID & 1)) * gap - 1.0;

  // �����x�N�g��
  vec4 vector = normalize(rotation * vec4(position * screen.st + screen.pq, focal, 0.0));

  // ���̕����x�N�g���̑��ΓI�ȋp [-1, 1]
  float angle = acos(vector.z) * 0.63661977 - 1.0;

  // �O��̃e�N�X�`���̍�����
  blend = 0.5 - clamp(angle * 25.0, -0.5, 0.5);

  // ���̕����x�N�g���� yx ��ł̕����x�N�g��
  vec2 orientation = normalize(vector.yx) * 0.885;

  // �O��̃e�N�X�`���̐F���T���v�����O����
  texcoord_f = (1.0 - angle) * orientation * radius_f + center_f;
  texcoord_b = (1.0 + angle) * orientation * radius_b + center_b;
  
  // ���_�ʒu�����̂܂܃��X�^���C�U�ɑ���΃N���b�s���O��ԑS�ʂɕ`��
  gl_Position = vec4(position, 0.0, 1.0);
}
