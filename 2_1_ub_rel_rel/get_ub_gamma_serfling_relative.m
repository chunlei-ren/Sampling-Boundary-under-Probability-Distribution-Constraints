% --------------------------------------------------------------------
% 1.函数功能：保证所有的gamma都在一定误差内的sample size
% 2.输入参数：
%   （1）epsilon：误差
%   （2）lambda：成功率
% 3.返回值
%   （1）size_gamma：所需的sample size
% --------------------------------------------------------------------
function size_gamma = get_ub_gamma_serfling_relative(epsilon, lambda)

% 全局参数
global sample_num node_num par_val_num gamma;

% 将参数gamma铺平，用于计算gamma相关的最小样本量
gamma_flat = [];
for i = 1:node_num
    for j = 1:par_val_num(i)
        % 遇到gamma为0或者1，直接跳过，不考虑
        if gamma(i, j) == 0 || gamma(i, j) == 1
            continue;
        end
        gamma_flat = [gamma_flat; gamma(i, j)];
    end
end

% 是否满足最小的误差epsilon要求
gamma_cnt = size(gamma_flat, 1);
t1 = log((1-lambda)/(2*gamma_cnt));
min_epsilon = sqrt(-t1/(2*sample_num^2));
if epsilon <= min_epsilon
    error("误差epsilon必须大于%f", min_epsilon);
end

% 计算维持gamma所需的样本量
syms x;
coe = -(sample_num * epsilon^2 * gamma_flat) ./ (2 * (1 - gamma_flat));
f = sum(exp(coe .* (x / (sample_num  - x + 1)))) - (1-lambda) / 2;

temp = vpasolve(f == 0);
if isempty(temp)
    error("所求方程无解！！！");
end
size_gamma = ceil(double(temp));

end

