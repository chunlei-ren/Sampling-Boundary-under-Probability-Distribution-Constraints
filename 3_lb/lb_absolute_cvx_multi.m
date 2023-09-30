% --------------------------------------------------------------------
% （1）求解抽样下界（先分别求解贝叶斯网络中每个结点的抽样抽样下界，
%       然后取其中最大值）
% （2）绝对误差
% （3）使用CVX工具包里面的Mosek算子求解整数线性规划问题
% --------------------------------------------------------------------

clear; % 清除工作区所有变量
close all; % 关闭所有的图形窗口
clc; % 清空命令行窗口

% 数据集根目录
root = "E:/BayesianDataset/";

epsilon_set = 0.01:0.01:0.1;
epsilon_set = [epsilon_set, 0.15:0.05:0.95];
epsilon_set = epsilon_set';
% ["survey"; "insurance"; "hepar2"; "hailfinder"]
dataset_name_set = ["hepar2"];
en = size(epsilon_set, 1);
dn = size(dataset_name_set, 1);

% 不超过epsilon_min的theta(i,j,k)全部丢弃
theta_min = 0.05;
% 指明cvx是否输出屏幕信息，true表示不输出
cvx_quiet true;

result_dir = root + "lb_abs_result/";
if exist(result_dir, "dir") ~= 7
   mkdir(result_dir);
end


% 枚举数据集
for dne = 1:dn
    % 数据集
    dataset_name = dataset_name_set(dne);
    fprintf("正在求解数据集%s的抽样下界\n", dataset_name);
    % 变量存储文件
    var_file = root + dataset_name + "/" + dataset_name + ".mat";
    if exist(var_file) == 2
        load(var_file);
    else
        error("文件%s不存在！！！！", var_file);
    end
    % 存储抽样下界
    lower_boundary = [];
    % 枚举误差
    for ene = 1:en
        % 误差
        epsilon = epsilon_set(ene);
        [res, theta_cnt] = ...
                get_lb_absolute_cvx(epsilon, theta_min);
        fprintf("误差为%0.3f, 下界为%d\n", epsilon, int32(max(res)));
        lower_boundary = [lower_boundary; int32(max(res))];
    end
    fn = result_dir + "lb_abs_" + dataset_name + ".txt";
    file_id = fopen(fn, 'w');
    fprintf(file_id, "数据集%s：\n", dataset_name);
    fprintf(file_id, "%.3f ", epsilon_set);
    fprintf(file_id, "\n");
    fprintf(file_id, "%d ", lower_boundary);
    fclose(file_id);
end

fprintf("程序结束!!!!!!!!!!!!!!!!!!!\n");









