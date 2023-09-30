% --------------------------------------------------------------------
% （1）求解抽样下界（先分别求解贝叶斯网络中每个结点的抽样抽样下界，
%       然后取其中最大值）
% （2）相对误差
% （3）使用CVX工具包里面的Mosek算子求解整数线性规划问题
% --------------------------------------------------------------------

clear; % 清除工作区所有变量
close all; % 关闭所有的图形窗口
clc; % 清空命令行窗口

% 数据集根目录
root = "E:/BayesianDataset/";
% 数据集名称
% survey insurance hepar2 hailfinder
dataset_name = "survey";
% 误差
epsilon = 0.05;
% 不超过epsilon_min的theta(i,j,k)全部丢弃
theta_min = 0.05;
% 指明cvx是否输出屏幕信息，false表示输出，true表示不输出
cvx_quiet false;

% 变量存储文件
var_file = root + dataset_name + "/" + dataset_name + ".mat";
% 加载各种变量
if exist(var_file) == 2
    load(var_file);
else
    error("文件%s不存在！！！！", var_file);
end


% 求解
[res, theta_cnt] = ...
    get_lb_relative_cvx(epsilon, theta_min)








