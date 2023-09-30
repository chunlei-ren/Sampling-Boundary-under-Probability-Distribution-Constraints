% --------------------------------------------------------------------
% 1.函数功能：计算数据集x的分布参数m
% 2.输入参数：
%   x_code：在原数据集中的样本编号
% 3.返回值：
%   mx：数据集x的分布参数m。m(i,j,k)表示数据集x中第i个结点取第k种取值，且
%       其父结点取第j种取值的数量
% --------------------------------------------------------------------
function mx = cal_m(x_code)

% 获取全局变量
global sample code;
global max_t max_n;
x = sample(x_code, :);
% 对数据集x编码，方便快速访问
temp_code = code(x_code, :);
% 数据集x的数据量
x_num = size(x, 1);
% 结点数量
x_node = size(x, 2);
% 因为code的编码值从0开始，而matlab下标从1开始
temp_code = temp_code + 1;
% 同code
x = x + 1;
% 初始化mx
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