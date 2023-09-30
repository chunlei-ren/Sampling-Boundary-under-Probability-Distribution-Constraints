% --------------------------------------------------------------------
% 1.函数功能：保证所有的theta都在一定误差之内的sample size
% 2.输入参数：
%   （1）epsilon：误差
%   （2）lambda：成功率
%   （3）epsilon_g：维持gamma时的误差
%   （4）gamma_min：不超过gamma_min的全部丢弃
%   （5）theta_min：不超过theta_min的全部丢弃
% 3.返回值
%   （1）size_theta：所需的sample size
%   （2）g_cnt：参与计算的gamma数量
%   （3）t_cnt：参与计算的theta数量
% --------------------------------------------------------------------
function [size_theta, g_cnt, t_cnt] = ...
    get_ub_theta_absolute(epsilon, lambda, epsilon_g, gamma_min, theta_min)

% 获取全局变量
global node_num val_num par_val_num gamma theta;

% 需要考虑的gamma(i, j)的数量
gamma_cnt = 0;
% 需要考虑的theta(i, j, k)的数量
theta_cnt = 0;

% 系数
coe = [];
 % 将系数转换为列向量
for i = 1:node_num
    for j = 1:par_val_num(i)
        % 不超过gamma_min的gamma(i, j)对应的theta(i, j, k)不需要考虑
        % 注意，gamma(i, j)为零时也不需要考虑
        if gamma(i, j) == 0 || gamma(i, j) <= gamma_min
            continue;
        end
        gamma_cnt = gamma_cnt + 1;
        % 固定i和j，若存在theta(i, j, k)为1，则不需要考虑结点(i, j)
        temp = squeeze(theta(i, j, 1:val_num(i)));
        temp1 = sum(temp == 1, "all");
        if temp1 == 1
            % 注意，虽然不参与计算，但也是有效的theta(i, j, k)
            theta_cnt = theta_cnt + 1;
            continue;
        end
        for k = 1:val_num(i)
            % 不考虑的theta(i, j, k)
            if theta(i, j, k) == 0 || theta(i, j, k) <= theta_min
                continue;
            end
            theta_cnt = theta_cnt + 1;
            coe = [coe; gamma(i, j) - epsilon_g];
        end % for
    end % for
end % for

% 计算抽样上界
syms x;
f = sum(exp(-2 .* coe .* epsilon^2 .* x)) - (1 - lambda) / 2;

temp = double(vpasolve(f == 0));
if isempty(temp)
    error("所求方程无解！！！");
end
% 在维持gamma的条件下，参数theta所需最小样本量
size_theta = ceil(temp);
g_cnt = gamma_cnt;
t_cnt = theta_cnt;

end

