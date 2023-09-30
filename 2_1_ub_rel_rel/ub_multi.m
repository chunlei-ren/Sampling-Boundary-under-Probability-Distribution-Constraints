% --------------------------------------------------------------------
% ��ͬ���Ҫ���µĳ����½�
% --------------------------------------------------------------------

clear; % ������������б���
close all; % �ر����е�ͼ�δ���
clc; % ��������д���

% ���ݼ���Ŀ¼
root = "E:/BayesianDataset/";

% ��֤����gamma������ϵ��
lambda_g = 0.95;
% ��֤����gamma�������
epsilon_g = 0.05;
% ��֤����theta������ϵ��
lambda_t = 0.95;
% theta����ֵ��������theta_threshold��ȫ������
theta_threshold = 0.05;
% gamma����ֵ��������gamma_threshold��ȫ������
gamma_threshold = 0.05;

% survey child insurance hailfinder pigs
% ["survey"; "child"; "insurance"; "hailfinder"; "hepar2"]
dataset_name_set = ["survey"; "child"; "insurance"; "hailfinder"; "hepar2"];
epsilon_set = 0.01:0.01:0.1;
epsilon_set = [epsilon_set, 0.15:0.05:0.95];
epsilon_set = epsilon_set';
en = size(epsilon_set, 1);
dn = size(dataset_name_set, 1);

result_dir = root + "ub_result/";
if exist(result_dir, "dir") ~= 7
   mkdir(result_dir);
end

% ö�����ݼ�
for dne = 1:dn
    % ���ݼ�
    dataset_name = dataset_name_set(dne);
    fn = result_dir + "ub_relative_" + dataset_name + ".txt";
    file_id = fopen(fn, 'w');
    fprintf("����������ݼ�%s�ĳ����Ͻ�\n", dataset_name);
    fprintf(file_id, "���ݼ�%s��\n", dataset_name);
    % �����洢�ļ�
    var_file = root + dataset_name + "/" + dataset_name + ".mat";
    if exist(var_file) == 2
        load(var_file);
    else
        error("�ļ�%s�����ڣ�������", var_file);
    end
    % ȫ��gamma�ĳ����Ͻ�
    sub_num_g = get_ub_gamma_hoeffding_relative(...
            epsilon_g, lambda_g, gamma_threshold);
    % �洢���
    theta_size = [];
    upper_boundary = [];
    % ö�����
    for ene = 1:en
        % ���
        epsilon = epsilon_set(ene);
        fprintf("���Ϊ%0.3f\n", epsilon);
        % �������Ͻ�
        [sub_num_t, gamma_cnt, theta_cnt] = ...
            get_ub_theta_relative(epsilon, lambda_t, epsilon_g, ...
            gamma_threshold, theta_threshold);
        theta_size = [theta_size; sub_num_t];
        upper_boundary = [upper_boundary; max(sub_num_g, sub_num_t)];
    end
    fprintf(file_id, "%.3f\t\t", epsilon_set);
    fprintf(file_id, "\n");
    fprintf(file_id, "%d\t\t", sub_num_g);
    fprintf(file_id, "\n");
    fprintf(file_id, "%d\t\t", theta_size);
    fprintf(file_id, "\n");
    fprintf(file_id, "%d\t\t", upper_boundary);
    fclose(file_id);
end

fprintf("�������!!!!!!!!!!!!!!!!!!!\n");









