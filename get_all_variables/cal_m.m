% --------------------------------------------------------------------
% 1.�������ܣ��������ݼ�x�ķֲ�����m
% 2.���������
%   x_code����ԭ���ݼ��е��������
% 3.����ֵ��
%   mx�����ݼ�x�ķֲ�����m��m(i,j,k)��ʾ���ݼ�x�е�i�����ȡ��k��ȡֵ����
%       �丸���ȡ��j��ȡֵ������
% --------------------------------------------------------------------
function mx = cal_m(x_code)

% ��ȡȫ�ֱ���
global sample code;
global max_t max_n;
x = sample(x_code, :);
% �����ݼ�x���룬������ٷ���
temp_code = code(x_code, :);
% ���ݼ�x��������
x_num = size(x, 1);
% �������
x_node = size(x, 2);
% ��Ϊcode�ı���ֵ��0��ʼ����matlab�±��1��ʼ
temp_code = temp_code + 1;
% ͬcode
x = x + 1;
% ��ʼ��mx
mx = zeros(x_node, max_t, max_n);
for r = 1:x_num
    for c = 1:x_node
        if temp_code(r, c) ~= 0
            mx(c, temp_code(r, c), x(r, c)) = mx(c, temp_code(r, c), x(r, c)) + 1;
        else
            mx(c, 1, x(r, c)) = mx(c, 1, x(r, c)) + 1;
        end % if
    end % for
end % for