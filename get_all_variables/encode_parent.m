% --------------------------------------------------------------------
% 1.�������ã��Ը������ݼ�x��ÿ�����ĸ�������
% 2.���������
%   x�����ݼ�
% 3.����ֵ��
%   code��code(i, j)��ʾ���ݼ�x�е�i�����ݵĵ�j�����ĸ�����ȡֵ
% --------------------------------------------------------------------
function code = encode_parent(x)

% ����ȫ�ֱ���
global par_num parent val_num;
% ���ݼ�x��������
x_num = size(x, 1);
% ���ݼ�x�Ľ������
x_node = size(x, 2);
% ��ʼ������ֵ
code = zeros(x_num, x_node);
for r = 1:x_num
    for c = 1:x_node
        if par_num(c) == 0
            code(r, c) = -1;
        elseif par_num(c) == 1
            code(r, c) = x(r, parent(c, 1));
        else
            for h = 1:par_num(c)-1
                code(r, c) = code(r, c) + x(r, parent(c, h));
                code(r, c) = code(r, c) * val_num(parent(c, h+1));
            end % for
            code(r, c) = code(r, c) + x(r, parent(c, par_num(c)));
        end % if
    end % for
end % for

end % function