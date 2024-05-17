function preestimate_beta(Ye, X, T_init, N)

    Ye = reshape(Ye, 4*T_init, N)
    dy = Ye[5:end,:] ./ Ye[1:end-4,:]
    k = size(X, 2)
    beta_ = zeros(N, k+1)
    std_err_ = zeros(N, k+1)
    for j=1:N
        #data_ = zeros(4*(T_init-1), k+1)
        #data_[:,1] = dy[:,j]
        #data_[:,2:end] = X[5:end,:,j] ./ X[1:end-4,:,j]
        #data = DataFrame(data_, ["dyj", "x1", "x2", "x3", "x4"])
        #ols = lm(@formula(dyj ~ 1 + x1 + x2 + x3 + x4), data)
        #beta_[j,:] = coef(ols)
        #std_err_[j,:] = stderror(ols)
        dxj = [ones(4*(T_init-1),1) X[5:end,:,j] ./ X[1:end-4,:,j]]
        dyj = dy[:,j]
        beta_j = inv(dxj'*dxj)*(dxj'*dyj)
        beta_[j,:] = beta_j
        u = dyj - dxj*beta_j
        std_err_[j,:] = sqrt.(diag(u'*u/(4*(T_init-1)-k-1)*inv(dxj'*dxj)))
    end
    #println(std_err_)

    return beta_, std_err_
end
