% -------------------------------------------------------------------
%   1.�������ܣ�
%   2.���������
%   3.���������
% -------------------------------------------------------------------
function get_global_variables(root, dataset_name)

global sample parent val_num;
global M theta gamma;
global sample_num node_num;
global par_val_num par_num;
global max_t max_n;
global code;

% �����洢�ļ�
var_file = root + dataset_name + "/" + dataset_name + ".mat";
% �����ļ�
parent_file = root + dataset_name + "/parent.txt";
node_value_num_file = root + dataset_name + "/nodeValueNum.txt";
data_file = root + dataset_name + "/" + dataset_name + "_p.txt";

% ���ݼ�����ά����
sample = textread(data_file);
% ÿ�����ĸ���㣬��ά����
% ��parent(i,j) ~= 0�����parent(i,j)������ǵ�i�����ĸ����
parent = textread(parent_file);
% ÿ������ȡֵ�����У�������
val_num = textread(node_value_num_file);
% ������ݼ���С
sample_num = size(sample, 1);
% �������
node_num = size(sample, 2);
% ÿ�����ĸ����������������
par_num = sum(parent ~= 0, 2)';
% ÿ�����ĸ����ȡֵ������������
par_val_num = get_par_val_num();
% ��par_val_num���⴦��
for i = 1:node_num
if par_val_num(i) == 0
   par_val_num(i) = par_val_num(i) + 1;
end % if
end % for
% par_val_num�е����ֵ
max_t = max(par_val_num);
% val_num�е����ֵ
max_n = max(val_num);
code = encode_parent(sample);
% �����ʼ���ݼ�sample�ķֲ�����theta��eta
[M, theta] = pre_process(1:sample_num);
MS = sum(M, 3);
gamma = MS / sample_num;
% ���湤�����ı���
save(var_file);


end


