% --------------------------------------------------------------------
% 1.�������ܣ���֤���е�theta����һ�����֮�ڵ�sample size
% 2.���������
%   ��1��epsilon�����
%   ��2��lambda���ɹ���
%   ��3��epsilon_g��ά��gammaʱ�����
%   ��4��gamma_min��������gamma_min��ȫ������
%   ��5��theta_min��������theta_min��ȫ������
% 3.����ֵ
%   ��1��size_theta�������sample size
%   ��2��g_cnt����������gamma����
%   ��3��t_cnt����������theta����
% --------------------------------------------------------------------
function [size_theta, g_cnt, t_cnt] = ...
    get_ub_theta_absolute(epsilon, lambda, epsilon_g, gamma_min, theta_min)

% ��ȡȫ�ֱ���
global node_num val_num par_val_num gamma theta;

% ��Ҫ���ǵ�gamma(i, j)������
gamma_cnt = 0;
% ��Ҫ���ǵ�theta(i, j, k)������
theta_cnt = 0;

% ϵ��
coe = [];
 % ��ϵ��ת��Ϊ������
for i = 1:node_num
    for j = 1:par_val_num(i)
        % ������gamma_min��gamma(i, j)��Ӧ��theta(i, j, k)����Ҫ����
        % ע�⣬gamma(i, j)Ϊ��ʱҲ����Ҫ����
        if gamma(i, j) == 0 || gamma(i, j) <= gamma_min
            continue;
        end
        gamma_cnt = gamma_cnt + 1;
        % �̶�i��j��������theta(i, j, k)Ϊ1������Ҫ���ǽ��(i, j)
        temp = squeeze(theta(i, j, 1:val_num(i)));
        temp1 = sum(temp == 1, "all");
        if temp1 == 1
            % ע�⣬��Ȼ��������㣬��Ҳ����Ч��theta(i, j, k)
            theta_cnt = theta_cnt + 1;
            continue;
        end
        for k = 1:val_num(i)
            % �����ǵ�theta(i, j, k)
            if theta(i, j, k) == 0 || theta(i, j, k) <= theta_min
                continue;
            end
            theta_cnt = theta_cnt + 1;
            coe = [coe; gamma(i, j) - epsilon_g];
        end % for
    end % for
end % for

% ��������Ͻ�
syms x;
f = sum(exp(-2 .* coe .* epsilon^2 .* x)) - (1 - lambda) / 2;

temp = double(vpasolve(f == 0));
if isempty(temp)
    error("���󷽳��޽⣡����");
end
% ��ά��gamma�������£�����theta������С������
size_theta = ceil(temp);
g_cnt = gamma_cnt;
t_cnt = theta_cnt;

end

