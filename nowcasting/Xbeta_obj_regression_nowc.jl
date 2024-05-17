function Xbeta_obj_regression_nowc(X, beta, N)

    k = size(X, 2) + 1
    T_Xb = size(X,1)
    Xbeta = zeros(T_Xb-4,N)

    for j=1:N
        x = X[:, :, j]
        x_ = ones(T_Xb-4, k)
        x_[:, 2:end] = x[5:end,:] ./ x[1:end-4,:]
        Xbeta[:, j] = x_ * beta[j,:]
    end

    return Xbeta
end