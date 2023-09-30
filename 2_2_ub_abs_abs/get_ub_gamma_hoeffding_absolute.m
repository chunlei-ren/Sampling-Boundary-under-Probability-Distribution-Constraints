% --------------------------------------------------------------------
% 1.函数功能：保证所有的gamma都在一定误差内的sample size
%           绝对误差，Hoeffeding不等式
% 2.输入参数：
%   （1）epsilon：误差
%   （2）lambda：成功率
%   （3）gamma_min：不超过gamma_min的gamma(i, j)全部丢弃
% 3.返回值
%   （1）size_gamma：所需的sample size
% --------------------------------------------------------------------
function size_gamma = get_ub_gamma_hoeffding_absolute(...
       epsilon, lambda, gamma_min)

% 全局参数
global node_num par_val_num gamma;

% 统计参与计算的gamma数量
gamma_cnt = 0;
for i = 1:node_num
    for j = 1:par_val_num(i)
        % 遇到gamma为0或者1，直接跳过，不考虑
        if gamma(i, j) == 0 || gamma(i, j) == 1 ...
                || gamma(i, j) <= gamma_min
            continue;
        end
        gamma_cnt = gamma_cnt + 1;
    end
end

% 用于计算维持gamma所需的样本量
syms x; 
f = gamma_cnt * exp(-2 * x * epsilon^2) - (1-lambda) / 2;

temp = vpasolve(f == 0);
if isempty(temp)
    error("所求方程无解！！！");
end
size_gamma = ceil(double(temp));

end

