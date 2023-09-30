% -----------------------------------------------------------------------
% 1.�������ã��������ݼ�data���õ���ֲ�����theta
% 2.���������
%   data_code����ԭ���ݼ��е��������
% 3.����ֵ��
%   theta�����ݼ�data�ķֲ�����theta��theta(i,j,k)��ʾ�ڵ�i�����ĸ����ȡ
%       ��j��ȡֵ�������£���i�����ȡ��k��ȡֵ�ĸ���
% -----------------------------------------------------------------------
function [data_m, theta] = pre_process(data_code)

% �������ݼ�data�ķֲ�����m
data_m = cal_m(data_code);
% �������ݼ�data�ķֲ�����theta
temp = sum(data_m, 3);
% temp��ȡֵΪ0�����⴦���������theta
temp(temp == 0) = 1;
temp = repmat(temp, [1 1 size(data_m, 3)]);
theta = data_m ./ temp;

end

