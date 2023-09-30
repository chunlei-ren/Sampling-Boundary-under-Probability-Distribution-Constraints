% --------------------------------------------------------------------
% 1.�������ܣ���֤���е�gamma����һ������ڵ�sample size��
%           �����Hoeffding����ʽ���
% 2.���������
%   ��1��epsilon�����
%   ��2��lambda���ɹ���
%   ��3��gamma_min��������gamma_min������gammaȫ������
% 3.����ֵ
%   ��1��size_gamma�������sample size
% --------------------------------------------------------------------
function size_gamma = get_ub_gamma_hoeffding_relative(...
    epsilon, lambda, gamma_min)

% ȫ�ֲ���
global node_num par_val_num gamma;

% ͳ�Ʋ�������gamma����
gamma_flat = [];
for i = 1:node_num
    for j = 1:par_val_num(i)
        % ����gammaΪ0����1��ֱ��������������
        if gamma(i, j) == 0 || gamma(i, j) == 1
            continue;
        end
        if gamma(i, j) <= gamma_min
            continue;
        end
        gamma_flat = [gamma_flat; gamma(i, j)];
    end
end

% ���ڼ���ά��gamma�����������
syms x; 
f = sum(exp(-2 .* epsilon^2 .* gamma_flat.^2 .* x)) - (1-lambda) / 2;

temp = vpasolve(f == 0);
if isempty(temp)
    error("���󷽳��޽⣡����");
end
size_gamma = ceil(double(temp));

end

