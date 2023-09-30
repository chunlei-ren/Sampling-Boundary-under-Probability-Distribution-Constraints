function [sample_size, t_cnt] = ...
        get_lb_absolute_cvx(epsilon, theta_min)

global theta gamma node_num par_val_num val_num M;

% ÿһ�����ĳ����½�
res = [];
% ͳ�Ʋ�������theta����
t_cnt = 0;

% ����i�����ĳ����½�
for i = 1:node_num
    hash =zeros(size(theta));
    cnt = 0; % ͳ�Ƶ�i�����Ĳ�����������theta(i,:,:)������
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
    
    % ��ĸm_{ij+}��Ϊ���Լ������
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
    
    % ʹ��CVX���߰��е�Mosek��������������Թ滮
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

