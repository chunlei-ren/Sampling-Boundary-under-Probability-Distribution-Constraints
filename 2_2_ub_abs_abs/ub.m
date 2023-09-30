% --------------------------------------------------------------------
% �����Ͻ�
%   ��1��gamma��������Serfling����ʽ
%   ��2��theta���������
% --------------------------------------------------------------------

clear; % ������������б���
close all; % �ر����е�ͼ�δ���
clc; % ��������д���

% ���ݼ���Ŀ¼
root = "E:/BayesianDataset/";
% ���ݼ�����
% survey insurance hepar2 hailfinder
dataset_name = "hailfinder";

% ��֤����gamma������ϵ��
lambda_g = 0.99;
% ��֤����gamma�������
epsilon_g = 0.01;
% ��������
drop_g = 2;
% ��֤����theta������ϵ��
lambda_t = 0.99;
% ��֤����theta�������
epsilon_t = 0.05;
% theta����ֵ��������theta_threshold��ȫ������
theta_threshold = 0;
% gamma����ֵ��������gamma_threshold��ȫ������
gamma_threshold = drop_g * epsilon_g;

% ���ر����ļ�
var_file = root + dataset_name + "/" + dataset_name + ".mat";
if exist(var_file) == 2
    load(var_file);
else
    error("�ļ�%s�����ڣ�������", var_file);
end

% ȷ�����ú��ַ������theta��gamma��Ӧ�ĳ����Ͻ�
% sub_num_g = get_ub_gamma_hoeffding_absolute(...
%     epsilon_g, lambda_g, gamma_threshold);
sub_num_g = get_ub_gamma_serfling_absolute(...
    epsilon_g, lambda_g, gamma_threshold);
[sub_num_t, gamma_cnt, theta_cnt] = ...
    get_ub_theta_absolute(epsilon_t, lambda_t, epsilon_g, ...
    gamma_threshold, theta_threshold);

fprintf("-----------------------------------------------\n");
fprintf("�������ã�\n");
fprintf("��1�����ݼ���%s\n", dataset_name);
fprintf("��2�����ݼ���С��%d\n", sample_num);
fprintf("��3��theta����%.3f\n��4��theta�����Ŷȣ�%.2f\n", ...
    epsilon_t, lambda_t);
fprintf("��5��gamma����%.3f\n��6��gamma�����Ŷȣ�%.2f\n", ...
    epsilon_g, lambda_g);
fprintf("��7��gamma������ֵ��%.3f\n", gamma_threshold);
fprintf("��8��theta������ֵ��%.3f\n", theta_threshold);
fprintf("-----------------------------------------------\n");
fprintf("ʵ������\n");
fprintf("��1��gamma�ĳ����Ͻ磺%d\n", sub_num_g);
fprintf("��2��theta�ĳ����Ͻ磺%d\n", sub_num_t);
fprintf("��3�������ݼ���СΪ���޵ĳ����Ͻ磺%d\n", ...
    min(sample_num, max(sub_num_g, sub_num_t)));
fprintf("��4�������ݼ���С�޹صĳ����Ͻ磺%d\n", max(sub_num_g, sub_num_t));
fprintf("-----------------------------------------------\n");
fprintf("ʵ��������������\n");
fprintf("��1��gamma��������%d\n",sum(gamma~= 0, "all"));
fprintf("��2����������gamma������%d\n",gamma_cnt);
fprintf("��3��theta��������%d\n",sum(theta~= 0, "all"));
fprintf("��4����������theta������%d\n",theta_cnt);
fprintf("��5���ֲ��ֽ�ǰ���Ϸֲ�ȡֵ������%d\n", prod(val_num, "all"));
fprintf("-----------------------------------------------\n");



















