% --------------------------------------------------------------------
% 抽样上界
%   （1）gamma采用相对误差，并且使用Hoeffding不等式求解
%   （2）theta采用相对误差
% --------------------------------------------------------------------

clear; % 清除工作区所有变量
close all; % 关闭所有的图形窗口
clc; % 清空命令行窗口

% 数据集根目录
root = "E:/BayesianDataset/";
% 数据集名称
% survey child insurance hailfinder pigs hepar2
dataset_name = "survey";

% 保证参数gamma的置信系数
lambda_g = 0.99;
% 保证参数gamma的误差限
epsilon_g = 0.05;
% 保证参数theta的置信系数
lambda_t = 0.99;
% 保证参数theta的误差限
epsilon_t = 0.05;
% theta的阈值，不超过theta_threshold的全部丢弃
theta_threshold = 0.05;
% gamma的阈值，不超过gamma_threshold的全部丢弃
gamma_threshold = 0.05;

% 加载变量文件
var_file = root + dataset_name + "/" + dataset_name + ".mat";
if exist(var_file) == 2
    fprintf("加载数据集%s的配置文件\n", dataset_name);
    load(var_file);
else
    error("文件%s不存在！！！！", var_file);
end

% 确定采用何种方法求解theta和gamma对应的抽样上界
sub_num_g = get_ub_gamma_hoeffding_relative(...
    epsilon_g, lambda_g, gamma_threshold);
[sub_num_t, gamma_cnt, theta_cnt] = ...
    get_ub_theta_relative(epsilon_t, lambda_t, epsilon_g, ...
    gamma_threshold, theta_threshold);

fprintf("-----------------------------------------------\n");
fprintf("参数配置：\n");
fprintf("（1）数据集：%s\n", dataset_name);
fprintf("（2）数据集大小：%d\n", sample_num);
fprintf("（3）theta的误差：%.3f\n（4）theta的置信度：%.2f\n", ...
    epsilon_t, lambda_t);
fprintf("（5）gamma的误差：%.3f\n（6）gamma的置信度：%.2f\n", ...
    epsilon_g, lambda_g);
fprintf("（7）gamma丢弃阈值：%.3f\n", gamma_threshold);
fprintf("（8）theta丢弃阈值：%.3f\n", theta_threshold);
fprintf("-----------------------------------------------\n");
fprintf("实验结果：\n");
fprintf("（1）gamma的抽样上界：%d\n", sub_num_g);
fprintf("（2）theta的抽样上界：%d\n", sub_num_t);
fprintf("（3）以数据集大小为上限的抽样上界：%d\n", ...
    min(sample_num, max(sub_num_g, sub_num_t)));
fprintf("（4）与数据集大小无关的抽样上界：%d\n", max(sub_num_g, sub_num_t));
fprintf("-----------------------------------------------\n");
fprintf("实验结果辅助参数：\n");
fprintf("（1）gamma总数量：%d\n",sum(gamma~= 0, "all"));
fprintf("（2）参与计算的gamma数量：%d\n",gamma_cnt);
fprintf("（3）theta总数量：%d\n",sum(theta~= 0, "all"));
fprintf("（4）参与计算的theta数量：%d\n",theta_cnt);
fprintf("（5）分布分解前联合分布取值数量：%d\n", prod(val_num, "all"));
fprintf("-----------------------------------------------\n");















