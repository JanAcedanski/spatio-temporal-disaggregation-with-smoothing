function onestep_smoothing(gdp_reg, gdpq_country, N)

    T = size(gdp_reg,1)
    T_init = T

    yo_country = gdpq_country[1:4*T_init]
    yo_reg = gdp_reg[1:T_init, :]

    w = sum(yo_reg; dims=1)/sum(yo_reg)

    A, b, A_short, b_short = sys_eq_matrices(yo_reg, yo_country, T_init, N)
    Ye_ = A_short\b_short
    
    silent = false
    Ye, fv, term_status = smooth_estimates(Ye_, A_short, b_short, T_init, w, [], N, silent)

    #Ye[1:4*T_init,:] = reshape(Ye_1, 4*T_init, 16)
    Ye = reshape(Ye, 4*T_init, 16)

    return A_short, b_short, Ye
end
