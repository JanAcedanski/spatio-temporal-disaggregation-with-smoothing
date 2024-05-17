function estim_regression_step_B(Ye, Ye0, X, w, T, N)

    if length(Ye0)>0
        Ye_ = [reshape(Ye0, 4, N); reshape(Ye, 4*(T-1), N)]
    end

    beta, beta_se = preestimate_beta(Ye_[:], X, T, N)

    Xbeta = Xbeta_obj_regression(X, beta, T, N);
    fvB = obj_regression(Ye, Xbeta, Ye0, w, T, N)
    #println("fvB: $fvB")

    return beta, fvB, beta_se

end
