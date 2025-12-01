function [c_data] = ISOMAP(datas, K)
    [NN, N] = size(datas);
    X2 = sum(datas.^2, 1);
    D = repmat(X2, N, 1) + repmat(X2', 1, N) - 2*datas'*datas;
    D = real(sqrt(D));

    INF = 1000*max(max(D))*N;
    [tmp, ind] = sort(D);
    for i=1:N
        D(i, ind((2+K):end, i)) = INF;
    end

    D = min(D, D');

    for k=1:N
        D = min(D, repmat(D(:,k), [1 N])+repmat(D(k,:), [N 1]));
    end

    B = -(D.^2-sum(D.^2)'*ones(1,N)/N + ones(N,1)*sum(D.^2)/N+sum(sum(D.^2))/(N^2))/2;
    
    [eig_vec, eig_val] = eig(B);
    [val, idx] = sort(diag(eig_val), 'descend');
    eig_val = diag(eig_val);
    eig_val = eig_val(idx);
    eig_vec = eig_vec(:, idx);
    for j=1:N
        for i=1:N
            c_data(j,i)=real(sqrt(eig_val(j))*eig_vec(i,j));
        end
    end
end

