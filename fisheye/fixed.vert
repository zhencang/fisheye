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
vec2 scale = vec2(0.5 * size.y / size.x, -0.5) * screen.st / circle.st;

// �C���[�W�T�[�N���̃e�N�X�`����ԏ�̒��S�ʒu
vec2 center = circle.pq + 0.5;

// �e�N�X�`�����W
out vec2 texcoord;

void main(void)
{
  // ���_�ʒu
  //   �e���_�ɂ����� gl_VertexID �� 0, 1, 2, 3, ... �̂悤�Ɋ��蓖�Ă��邩��A
  //     x = gl_VertexID >> 1      = 0, 0, 1, 1, 2, 2, 3, 3, ...
  //     y = 1 - (gl_VertexID & 1) = 1, 0, 1, 0, 1, 0, 1, 0, ...
  //   �̂悤�� GL_TRIANGLE_STRIP �����̒��_���W�l��������B
  //   y �� gl_InstaceID �𑫂��� glDrawArrayInstanced() �̃C���X�^���X���Ƃ� y ���ω�����B
  //   ����Ɋi�q�̊Ԋu gap �������� 1 �������Ώc�� [-1, 1] �͈̔͂̓_�Q��������B
  //   ����ɁA����ɃX�N���[���̑傫�� screen.st �������Ē��S�ʒu screen.pq �𑫂��΁A
  //   �X�N���[����̒��_�ʒu position ��������B
  int x = gl_VertexID >> 1;
  int y = gl_InstanceID + 1 - (gl_VertexID & 1);
  vec2 position = (vec2(x, y) * gap - 1.0) * screen.st + screen.pq;

  // �����x�N�g��
  //   ���_�����_�Ƃ���Ύ����x�N�g���͏œ_���� focal �� Z ���W�ɗp���� (position, focal)�B
  vec4 vector = vec4(position, focal, 0.0);

  // �e�N�X�`�����W
  texcoord = vector.xy * scale + center;

  // ���_�ʒu�����̂܂܃��X�^���C�U�ɑ���΃N���b�s���O��ԑS�ʂɕ`��
  gl_Position = vec4(position, 0.0, 1.0);
}
