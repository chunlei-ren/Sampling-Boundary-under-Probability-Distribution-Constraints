% --------------------------------------------------------------------
% 1.�������ܣ���֤���е�gamma����һ������ڵ�sample size
% 2.���������
%   ��1��epsilon�����
%   ��2��lambda���ɹ���
% 3.����ֵ
%   ��1��size_gamma�������sample size
% --------------------------------------------------------------------
function size_gamma = get_ub_gamma_serfling_relative(epsilon, lambda)

% ȫ�ֲ���
global sample_num node_num par_val_num gamma;

% ������gamma��ƽ�����ڼ���gamma��ص���С������
gamma_flat = [];
for i = 1:node_num
    for j = 1:par_val_num(i)
        % ����gammaΪ0����1��ֱ��������������
        if gamma(i, j) == 0 || gamma(i, j) == 1
            continue;
        end
        gamma_flat = [gamma_flat; gamma(i, j)];
    end
end

% �Ƿ�������С�����epsilonҪ��
gamma_cnt = size(gamma_flat, 1);
t1 = log((1-lambda)/(2*gamma_cnt));
min_epsilon = sqrt(-t1/(2*sample_num^2));
if epsilon <= min_epsilon
    error("���epsilon�������%f", min_epsilon);
end

% ����ά��gamma�����������
syms x;
coe = -(sample_num * epsilon^2 * gamma_flat) ./ (2 * (1 - gamma_flat));
f = sum(exp(coe .* (x / (sample_num  - x + 1)))) - (1-lambda) / 2;

temp = vpasolve(f == 0);
if isempty(temp)
    error("���󷽳��޽⣡����");
end
size_gamma = ceil(double(temp));

end

