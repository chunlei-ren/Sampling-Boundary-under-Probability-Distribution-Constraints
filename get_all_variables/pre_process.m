% -----------------------------------------------------------------------
% 1.函数作用：处理数据集data，得到其分布参数theta
% 2.输入参数：
%   data_code：在原数据集中的样本编号
% 3.返回值：
%   theta：数据集data的分布参数theta。theta(i,j,k)表示在第i个结点的父结点取
%       第j种取值的条件下，第i个结点取第k种取值的概率
% -----------------------------------------------------------------------
function [data_m, theta] = pre_process(data_code)

% 计算数据集data的分布参数m
data_m = cal_m(data_code);
% 计算数据集data的分布参数theta
temp = sum(data_m, 3);
% temp中取值为0的特殊处理，方便计算theta
temp(temp == 0) = 1;
temp = repmat(temp, [1 1 size(data_m, 3)]);
theta = data_m ./ temp;

end

