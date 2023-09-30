% -------------------------------------------------------------------
%   1.函数功能：
%   2.输入参数：
%   3.输出参数：
% -------------------------------------------------------------------
function get_global_variables(root, dataset_name)

global sample parent val_num;
global M theta gamma;
global sample_num node_num;
global par_val_num par_num;
global max_t max_n;
global code;

% 变量存储文件
var_file = root + dataset_name + "/" + dataset_name + ".mat";
% 配置文件
parent_file = root + dataset_name + "/parent.txt";
node_value_num_file = root + dataset_name + "/nodeValueNum.txt";
data_file = root + dataset_name + "/" + dataset_name + "_p.txt";

% 数据集，二维矩阵
sample = textread(data_file);
% 每个结点的父结点，二维矩阵
% 若parent(i,j) ~= 0，则第parent(i,j)个结点是第i个结点的父结点
parent = textread(parent_file);
% 每个结点的取值数量行，行向量
val_num = textread(node_value_num_file);
% 最初数据集大小
sample_num = size(sample, 1);
% 结点数量
node_num = size(sample, 2);
% 每个结点的父结点数量，行向量
par_num = sum(parent ~= 0, 2)';
% 每个结点的父结点取值数量，行向量
par_val_num = get_par_val_num();
% 对par_val_num特殊处理
for i = 1:node_num
if par_val_num(i) == 0
   par_val_num(i) = par_val_num(i) + 1;
end % if
end % for
% par_val_num中的最大值
max_t = max(par_val_num);
% val_num中的最大值
max_n = max(val_num);
code = encode_parent(sample);
% 计算初始数据集sample的分布参数theta和eta
[M, theta] = pre_process(1:sample_num);
MS = sum(M, 3);
gamma = MS / sample_num;
% 保存工作区的变量
save(var_file);


end


