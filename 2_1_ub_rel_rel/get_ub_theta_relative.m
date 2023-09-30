% --------------------------------------------------------------------
% 1.函数功能：抽样上界，相对误差
% 2.输入参数：
%   （1）epsilon：误差
%   （2）lambda：成功率
%   （3）epsilon_g：维持gamma时的误差
%   （5）gamma_min：不超过gamma_min的所有gamma全部丢弃，对应的theta也丢弃
%   （6）theta_min：不超过theta_min的所有theta全部丢弃
% 3.返回值
%   （1）size_theta：所需的sample size
%   （2）g_cnt：参与计算的gamma的数量
%   （3）t_cnt：参与计算的theta的数量
% --------------------------------------------------------------------
function [size_theta, g_cnt, t_cnt] = ...
    get_ub_theta_relative(epsilon, lambda, epsilon_g, gamma_min, theta_min)

% 获取全局变量
global node_num val_num par_val_num gamma theta;

% 有多少gamma参与计算
gamma_cnt = 0;
% 有多少theta参与计算
theta_cnt = 0;
% 系数
coe = [];
 % 将系数转换为列向量
for i = 1:node_num
    for j = 1:par_val_num(i)
        % 遇到gamma小于或等于gamma_min，直接跳过，不考虑
        % 特别注意，gamma(i,j)等于0也在这里被过滤掉了
        if gamma(i, j) <= gamma_min
            continue;
        end
        gamma_cnt = gamma_cnt + 1;
        % 固定i和j，若存在theta(i, j, k)为1，则不需要考虑结点(i, j)
        temp = squeeze(theta(i, j, 1:val_num(i)));
        temp1 = sum(temp == 1, "all");
        if temp1 == 1
            continue;
        end
        for k = 1:val_num(i)
            % 特别注意，theta(i, j, k)等于0也在这里被过滤掉了
            if theta(i, j, k) <= theta_min
                continue;
            end
            theta_cnt = theta_cnt + 1;
            coe = [coe; gamma(i, j) * theta(i, j, k)^2];
        end % for
    end % for
end % for

% 计算抽样上界
syms x;
f = sum(exp(-2 .* x .* (1 - epsilon_g) .* epsilon^2 .* coe)) ...
        - (1 - lambda) / 2;
temp = double(vpasolve(f == 0));
if isempty(temp)
    error("所求方程无解！！！");
end

% 在维持gamma的条件下，参数theta所需最小样本量
size_theta = ceil(temp);
g_cnt = gamma_cnt;
t_cnt = theta_cnt;
end

