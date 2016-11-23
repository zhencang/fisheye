#version 150 core

//
// �����̉�]���s��Ȃ�
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

// �C���[�W�T�[�N���̃e�N�X�`����ԏ�̃X�P�[��
vec2 scale = vec2(0.5 *  size.y / size.x, -0.5) / circle.st;

// �C���[�W�T�[�N���̃e�N�X�`����ԏ�̒��S�ʒu
vec2 center = circle.pq + 0.5;

// �e�N�X�`�����W
out vec2 texcoord;

void main(void)
{
  // ���_�ʒu
  vec2 position = vec2(gl_VertexID >> 1, gl_InstanceID + 1 - (gl_VertexID & 1)) * gap - 1.0;

  // �����x�N�g��
  vec4 vector = vec4(position * screen.st + screen.pq, 0.0, 0.0);
  
  // �e�N�X�`�����W
  texcoord = vector.xy * scale + center;
  
  // ���_�ʒu�����̂܂܃��X�^���C�U�ɑ���΃N���b�s���O��ԑS�ʂɕ`��
  gl_Position = vec4(position, 0.0, 1.0);
}