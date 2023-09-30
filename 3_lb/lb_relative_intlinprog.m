% --------------------------------------------------------------------
% （1）求解抽样下界（先分别求解贝叶斯网络中每个结点的抽样抽样下界，
%       然后取其中最大值）
% （2）相对误差
% （3）使用CVX工具包里面的Mosek算子求解整数线性规划问题
% --------------------------------------------------------------------

clear all; % 清除工作区所有变量
close all; % 关闭所有的图形窗口
clc; % 清空命令行窗口

% 数据集根目录
root = "E:/BayesianDataset/";
% 数据集名称
% survey insurance hepar2 hailfinder
dataset_name = "hepar2";
% 变量存储文件
var_file = root + dataset_name + "/" + dataset_name + ".mat";
% 相对误差，百分比
percent = 0.1;

if exist(var_file) == 2
    load(var_file);
else
    error("文件%s不存在！！！！", var_file);
end

% 每一个结点的抽样下界
res = [];

% 求解第i个结点的抽样下界
for i = 1:node_num
    hash =zeros(size(theta));
    cnt = 0;
    for j = 1:par_val_num(i)
        for k = 1:val_num(i)
            cnt = cnt + 1;
            hash(i, j, k) = cnt;
        end % for
    end % for

    % 上下界约束
    lb = zeros(cnt, 1);
    ub = zeros(cnt, 1);
    for j = 1:par_val_num(i)
        for k = 1:val_num(i)
            ub(hash(i, j, k)) = M(i, j, k);
        end
    end

    % 分布一致性约束
    A = [];
    b = [];
    for j = 1:par_val_num(i)
        for k1 = 1:val_num(i)
            if(theta(i, j, k1) == 0)
                continue;
            end
            a_tmp1 = zeros(1, cnt);
            a_tmp2 = zeros(1, cnt);
            a_tmp1(hash(i, j, k1)) = theta(i, j, k1) - ...
                percent*theta(i, j, k1) - 1;
            a_tmp2(hash(i, j, k1)) = 1 - theta(i, j, k1) - ...
                percent*theta(i, j, k1);
            for k2 = 1:val_num(i)
                if(k2 ~= k1) 
                     a_tmp1(hash(i, j, k2)) = theta(i, j, k1) - ...
                         percent*theta(i, j, k1);
                     a_tmp2(hash(i, j, k2)) = -theta(i, j, k1) - ...
                         percent*theta(i, j, k1);
                end % if
            end % for
            A = [A; a_tmp1; a_tmp2];
            b = [b; 0; 0];
        end % for
    end % for

    % 分母m_{ij+}不为零的约束条件
    for j = 1:par_val_num(i)
        if(gamma(i,j) == 0)
            continue;
        end
        a_tmp = zeros(1, cnt);
        for k = 1:val_num(i)
            a_tmp(hash(i, j, k)) = -1;
        end % for
        A = [A; a_tmp];
        b = [b; -1];
    end % for
    
    f = ones(cnt, 1);
    intcon = 1:cnt;
    [x, fval, exitflag, output] = ...
        intlinprog(f, intcon, A, b, [], [], lb, ub);
    if exitflag ~=1
        error("未收敛，Exit Flag:%d", exitflag);
    end
    res = [res; fval];
    
end % for

fprintf("数据集：%s, 相对误差：%f, 抽样下界：%d\n", ...
    dataset_name, percent, int32(max(res)));











