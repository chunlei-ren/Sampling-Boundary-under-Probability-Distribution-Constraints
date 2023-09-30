% --------------------------------------------------------------------
% ��1���������½磨�ȷֱ���ⱴҶ˹������ÿ�����ĳ��������½磬
%       Ȼ��ȡ�������ֵ��
% ��2��������
% ��3��ʹ��CVX���߰������Mosek��������������Թ滮����
% --------------------------------------------------------------------

clear all; % ������������б���
close all; % �ر����е�ͼ�δ���
clc; % ��������д���

% ���ݼ���Ŀ¼
root = "E:/BayesianDataset/";
% ���ݼ�����
% survey insurance hepar2 hailfinder
dataset_name = "hepar2";
% �����洢�ļ�
var_file = root + dataset_name + "/" + dataset_name + ".mat";
% ������ٷֱ�
percent = 0.1;

if exist(var_file) == 2
    load(var_file);
else
    error("�ļ�%s�����ڣ�������", var_file);
end

% ÿһ�����ĳ����½�
res = [];

% ����i�����ĳ����½�
for i = 1:node_num
    hash =zeros(size(theta));
    cnt = 0;
    for j = 1:par_val_num(i)
        for k = 1:val_num(i)
            cnt = cnt + 1;
            hash(i, j, k) = cnt;
        end % for
    end % for

    % ���½�Լ��
    lb = zeros(cnt, 1);
    ub = zeros(cnt, 1);
    for j = 1:par_val_num(i)
        for k = 1:val_num(i)
            ub(hash(i, j, k)) = M(i, j, k);
        end
    end

    % �ֲ�һ����Լ��
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

    % ��ĸm_{ij+}��Ϊ���Լ������
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
        error("δ������Exit Flag:%d", exitflag);
    end
    res = [res; fval];
    
end % for

fprintf("���ݼ���%s, �����%f, �����½磺%d\n", ...
    dataset_name, percent, int32(max(res)));











