% --------------------------------------------------------------------
% 不同误差要求下的抽样下界
% --------------------------------------------------------------------

clear; % 清除工作区所有变量
close all; % 关闭所有的图形窗口
clc; % 清空命令行窗口

% 数据集根目录
root = "E:/BayesianDataset/";

% 保证参数gamma的置信系数
lambda_g = 0.95;
% 保证参数gamma的误差限
epsilon_g = 0.05;
% 保证参数theta的置信系数
lambda_t = 0.95;
% theta的阈值，不超过theta_threshold的全部丢弃
theta_threshold = 0.05;
% gamma的阈值，不超过gamma_threshold的全部丢弃
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

% 枚举数据集
for dne = 1:dn
    % 数据集
    dataset_name = dataset_name_set(dne);
    fn = result_dir + "ub_relative_" + dataset_name + ".txt";
    file_id = fopen(fn, 'w');
    fprintf("正在求解数据集%s的抽样上界\n", dataset_name);
    fprintf(file_id, "数据集%s：\n", dataset_name);
    % 变量存储文件
    var_file = root + dataset_name + "/" + dataset_name + ".mat";
    if exist(var_file) == 2
        load(var_file);
    else
        error("文件%s不存在！！！！", var_file);
    end
    % 全部gamma的抽样上界
    sub_num_g = get_ub_gamma_hoeffding_relative(...
            epsilon_g, lambda_g, gamma_threshold);
    % 存储结果
    theta_size = [];
    upper_boundary = [];
    % 枚举误差
    for ene = 1:en
        % 误差
        epsilon = epsilon_set(ene);
        fprintf("误差为%0.3f\n", epsilon);
        % 求解抽样上界
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

fprintf("程序结束!!!!!!!!!!!!!!!!!!!\n");









