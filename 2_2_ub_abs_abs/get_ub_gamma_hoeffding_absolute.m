% --------------------------------------------------------------------
% 1.�������ܣ���֤���е�gamma����һ������ڵ�sample size
%           ������Hoeffeding����ʽ
% 2.���������
%   ��1��epsilon�����
%   ��2��lambda���ɹ���
%   ��3��gamma_min��������gamma_min��gamma(i, j)ȫ������
% 3.����ֵ
%   ��1��size_gamma�������sample size
% --------------------------------------------------------------------
function size_gamma = get_ub_gamma_hoeffding_absolute(...
       epsilon, lambda, gamma_min)

% ȫ�ֲ���
global node_num par_val_num gamma;

% ͳ�Ʋ�������gamma����
gamma_cnt = 0;
for i = 1:node_num
    for j = 1:par_val_num(i)
        % ����gammaΪ0����1��ֱ��������������
        if gamma(i, j) == 0 || gamma(i, j) == 1 ...
                || gamma(i, j) <= gamma_min
            continue;
        end
        gamma_cnt = gamma_cnt + 1;
    end
end

% ���ڼ���ά��gamma�����������
syms x; 
f = gamma_cnt * exp(-2 * x * epsilon^2) - (1-lambda) / 2;

temp = vpasolve(f == 0);
if isempty(temp)
    error("���󷽳��޽⣡����");
end
size_gamma = ceil(double(temp));

end

