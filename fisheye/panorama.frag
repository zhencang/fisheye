#version 150 core
#extension GL_ARB_explicit_attrib_location : enable

//
// �����~���}�@�̃e�N�X�`�����T���v�����O
//

// �w�i�e�N�X�`���̔��a�ƒ��S�ʒu
uniform vec4 circle;

// �w�i�e�N�X�`��
uniform sampler2D image;

// �w�i�e�N�X�`���̃T�C�Y
vec2 size = textureSize(image, 0);

// �w�i�e�N�X�`���̃e�N�X�`����ԏ�̃X�P�[��
vec2 scale = vec2(0.15915494, -0.31830989) / circle.st;

// �w�i�e�N�X�`���̃e�N�X�`����ԏ�̒��S�ʒu
vec2 center = circle.pq + 0.5;

// �����x�N�g��
in vec4 vector;

// �t���O�����g�̐F
layout (location = 0) out vec4 fc;

void main(void)
{
  // �����x�N�g���𐳋K������
  vec4 v = normalize(vector);

  // �e�N�X�`�����W�����߂�
  vec2 texcoord = atan(v.xy, vec2(v.z, length(v.xz))) * scale + center;

  // ��f�̉A�e�����߂�
  fc = texture(image, texcoord);
}
