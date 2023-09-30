function ret = get_par_val_num()

% 声明全局变量
global parent par_num val_num node_num;
ret = ones(1, node_num);
% 计算过程
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