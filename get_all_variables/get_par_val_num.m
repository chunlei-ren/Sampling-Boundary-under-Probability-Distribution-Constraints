function ret = get_par_val_num()

% ����ȫ�ֱ���
global parent par_num val_num node_num;
ret = ones(1, node_num);
% �������
for i = 1:node_num
    if par_num(i) == 0
        ret(i) = 0;
    else
        for j = 1:par_num(i)
            ret(i) = ret(i) * val_num(parent(i, j));
        end % for
    end % if
end % for

end % function