% --------------------------------------------------------------------
% ��1���������½磨�ȷֱ���ⱴҶ˹������ÿ�����ĳ��������½磬
%       Ȼ��ȡ�������ֵ��
% ��2���������
% ��3��ʹ��CVX���߰������Mosek��������������Թ滮����
% --------------------------------------------------------------------

clear; % ������������б���
close all; % �ر����е�ͼ�δ���
clc; % ��������д���

% ���ݼ���Ŀ¼
root = "E:/BayesianDataset/";

epsilon_set = 0.01:0.01:0.1;
epsilon_set = [epsilon_set, 0.15:0.05:0.95];
epsilon_set = epsilon_set';
% ["survey"; "insurance"; "hepar2"; "hailfinder"]
dataset_name_set = ["hepar2"];
en = size(epsilon_set, 1);
dn = size(dataset_name_set, 1);

% ������epsilon_min��theta(i,j,k)ȫ������
theta_min = 0.05;
% ָ��cvx�Ƿ������Ļ��Ϣ��true��ʾ�����
cvx_quiet true;

result_dir = root + "lb_abs_result/";
if exist(result_dir, "dir") ~= 7
   mkdir(result_dir);
end


% ö�����ݼ�
for dne = 1:dn
    % ���ݼ�
    dataset_name = dataset_name_set(dne);
    fprintf("����������ݼ�%s�ĳ����½�\n", dataset_name);
    % �����洢�ļ�
    var_file = root + dataset_name + "/" + dataset_name + ".mat";
    if exist(var_file) == 2
        load(var_file);
    else
        error("�ļ�%s�����ڣ�������", var_file);
    end
    % �洢�����½�
    lower_boundary = [];
    % ö�����
    for ene = 1:en
        % ���
        epsilon = epsilon_set(ene);
        [res, theta_cnt] = ...
                get_lb_absolute_cvx(epsilon, theta_min);
        fprintf("���Ϊ%0.3f, �½�Ϊ%d\n", epsilon, int32(max(res)));
        lower_boundary = [lower_boundary; int32(max(res))];
    end
    fn = result_dir + "lb_abs_" + dataset_name + ".txt";
    file_id = fopen(fn, 'w');
    fprintf(file_id, "���ݼ�%s��\n", dataset_name);
    fprintf(file_id, "%.3f ", epsilon_set);
    fprintf(file_id, "\n");
    fprintf(file_id, "%d ", lower_boundary);
    fclose(file_id);
end

fprintf("�������!!!!!!!!!!!!!!!!!!!\n");









