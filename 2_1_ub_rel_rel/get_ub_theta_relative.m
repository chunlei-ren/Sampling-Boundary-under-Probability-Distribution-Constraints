% --------------------------------------------------------------------
% 1.�������ܣ������Ͻ磬������
% 2.���������
%   ��1��epsilon�����
%   ��2��lambda���ɹ���
%   ��3��epsilon_g��ά��gammaʱ�����
%   ��5��gamma_min��������gamma_min������gammaȫ����������Ӧ��thetaҲ����
%   ��6��theta_min��������theta_min������thetaȫ������
% 3.����ֵ
%   ��1��size_theta�������sample size
%   ��2��g_cnt����������gamma������
%   ��3��t_cnt����������theta������
% --------------------------------------------------------------------
function [size_theta, g_cnt, t_cnt] = ...
    get_ub_theta_relative(epsilon, lambda, epsilon_g, gamma_min, theta_min)

% ��ȡȫ�ֱ���
global node_num val_num par_val_num gamma theta;

% �ж���gamma�������
gamma_cnt = 0;
% �ж���theta�������
theta_cnt = 0;
% ϵ��
coe = [];
 % ��ϵ��ת��Ϊ������
for i = 1:node_num
    for j = 1:par_val_num(i)
        % ����gammaС�ڻ����gamma_min��ֱ��������������
        % �ر�ע�⣬gamma(i,j)����0Ҳ�����ﱻ���˵���
        if gamma(i, j) <= gamma_min
            continue;
        end
        gamma_cnt = gamma_cnt + 1;
        % �̶�i��j��������theta(i, j, k)Ϊ1������Ҫ���ǽ��(i, j)
        temp = squeeze(theta(i, j, 1:val_num(i)));
        temp1 = sum(temp == 1, "all");
        if temp1 == 1
            continue;
        end
        for k = 1:val_num(i)
            % �ر�ע�⣬theta(i, j, k)����0Ҳ�����ﱻ���˵���
            if theta(i, j, k) <= theta_min
                continue;
            end
            theta_cnt = theta_cnt + 1;
            coe = [coe; gamma(i, j) * theta(i, j, k)^2];
        end % for
    end % for
end % for

% ��������Ͻ�
syms x;
f = sum(exp(-2 .* x .* (1 - epsilon_g) .* epsilon^2 .* coe)) ...
        - (1 - lambda) / 2;
temp = double(vpasolve(f == 0));
if isempty(temp)
    error("���󷽳��޽⣡����");
end

% ��ά��gamma�������£�����theta������С������
size_theta = ceil(temp);
g_cnt = gamma_cnt;
t_cnt = theta_cnt;
end

