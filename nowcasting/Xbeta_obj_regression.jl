function Xbeta_obj_regression(X, beta, T, N)

    k = size(X, 2) + 1

    Xbeta = zeros(4*(T-1),N)

    for j=1:N
        x = X[:, :, j]
        x_ = ones(4*(T-1), k)
        x_[:, 2:end] = x[5:end,:] ./ x[1:end-4,:]
        Xbeta[:, j] = x_ * beta[j,:]
    end

    return Xbeta
end