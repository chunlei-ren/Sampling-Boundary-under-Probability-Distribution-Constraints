function [sample_size, t_cnt] = ...
        get_lb_absolute_cvx(epsilon, theta_min)

global theta gamma node_num par_val_num val_num M;

% 每一个结点的抽样下界
res = [];
% 统计参与计算的theta数量
t_cnt = 0;

% 求解第i个结点的抽样下界
for i = 1:node_num
    hash =zeros(size(theta));
    cnt = 0; % 统计第i个结点的参数数量，即theta(i,:,:)的数量
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
            if (theta(i, j, k1) == 0) || ...
                    (theta(i, j, k1) <= theta_min)
                continue;
            end
            t_cnt = t_cnt + 1;
            a_tmp1 = zeros(1, cnt);
            a_tmp2 = zeros(1, cnt);
            a_tmp1(hash(i, j, k1)) = theta(i, j, k1) - epsilon - 1;
            a_tmp2(hash(i, j, k1)) = 1 - theta(i, j, k1) - epsilon;
            for k2 = 1:val_num(i)
                if(k2 ~= k1) 
                     a_tmp1(hash(i, j, k2)) = theta(i, j, k1) - epsilon;
                     a_tmp2(hash(i, j, k2)) = -theta(i, j, k1) - epsilon;
                end % if
            end % for
            A = [A; a_tmp1; a_tmp2];
            b = [b; 0; 0];
        end % for
    end % for
    
    % 分母m_{ij+}不为零的约束条件
    for j = 1:par_val_num(i)
        if gamma(i,j) == 0
            continue;
        end
        a_tmp = zeros(1, cnt);
        for k = 1:val_num(i)
            a_tmp(hash(i, j, k)) = -1;
        end % for
        A = [A; a_tmp];
        b = [b; -1];
    end % for
    
    % 使用CVX工具包中的Mosek算子求解整数线性规划
    cvx_solver mosek;
    cvx_begin
        variable x(cnt) integer
        minimize(sum(x))
        subject to
            A * x <= b
            -x <= lb
            x <= ub
    cvx_end
    
    if cvx_status ~= "Solved"
        error("EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEError!");
    end
    
    res = [res; cvx_optval];
    
end % for

sample_size = max(res);

end

