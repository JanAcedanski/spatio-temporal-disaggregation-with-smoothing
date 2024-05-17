function benchmarking_regression(gdp_reg, gdpq_country, X, N)

    T = size(gdp_reg,1)
    T_init = T

    yo_country = gdpq_country[1:4*T_init]
    yo_reg = gdp_reg[1:T_init, :]
    #x = X[1:4*T_init, :]
    w = sum(yo_reg; dims=1)/sum(yo_reg)

    A, b, A_short, b_short = sys_eq_matrices(yo_reg, yo_country, T_init, N)
    Ye_ = A_short\b_short

    #println("Regression method - preliminary smoothing step")
    #Ye_ = smooth_estimates(Ye_, A_short, b_short, T_init, w, [])
    beta_, beta_se_ = preestimate_beta(Ye_, X, T_init, N)
    Ye_1, beta, beta_se, id_ye0, u = estimate_regression_model(Ye_, beta_, A, b, X, T_init, w, N)
    Ye = reshape(Ye_1, 4*T_init, N)

    return A_short, b_short, Ye, beta, beta_se, id_ye0, u
end
