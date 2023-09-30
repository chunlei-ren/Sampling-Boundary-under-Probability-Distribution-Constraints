% --------------------------------------------------------------------
% 1.函数作用：对给定数据集x中每个结点的父结点编码
% 2.输入参数：
%   x：数据集
% 3.返回值：
%   code：code(i, j)表示数据集x中第i个数据的第j个结点的父结点的取值
% --------------------------------------------------------------------
function code = encode_parent(x)

% 声明全局变量
global par_num parent val_num;
% 数据集x的数据量
x_num = size(x, 1);
% 数据集x的结点数量
x_node = size(x, 2);
% 初始化编码值
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