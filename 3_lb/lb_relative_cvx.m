% --------------------------------------------------------------------
% ��1���������½磨�ȷֱ���ⱴҶ˹������ÿ�����ĳ��������½磬
%       Ȼ��ȡ�������ֵ��
% ��2��������
% ��3��ʹ��CVX���߰������Mosek��������������Թ滮����
% --------------------------------------------------------------------

clear; % ������������б���
close all; % �ر����е�ͼ�δ���
clc; % ��������д���

% ���ݼ���Ŀ¼
root = "E:/BayesianDataset/";
% ���ݼ�����
% survey insurance hepar2 hailfinder
dataset_name = "survey";
% ���
epsilon = 0.05;
% ������epsilon_min��theta(i,j,k)ȫ������
theta_min = 0.05;
% ָ��cvx�Ƿ������Ļ��Ϣ��false��ʾ�����true��ʾ�����
cvx_quiet false;

% �����洢�ļ�
var_file = root + dataset_name + "/" + dataset_name + ".mat";
% ���ظ��ֱ���
if exist(var_file) == 2
    load(var_file);
else
    error("�ļ�%s�����ڣ�������", var_file);
end


% ���
[res, theta_cnt] = ...
    get_lb_relative_cvx(epsilon, theta_min)








