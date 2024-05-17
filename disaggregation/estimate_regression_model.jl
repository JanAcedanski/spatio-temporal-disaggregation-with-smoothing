function estimate_regression_model(Ye_, beta_, A, b, X, T, w, N)
    #separates and iteratively estimates Ye and beta

    #Ye for the first year is fixed
    (id_ye, id_ye0) = gen_id(T)
    Ye0 = Ye_[id_ye0]
    Ye = Ye_[id_ye]
    A = A[:, id_ye]
    (mp, indep_rows) = rref_with_pivots(A')
    A = A[indep_rows,:]
    b = b[indep_rows]
    
    #Ye for the first year are optimized - difficult to solve
    #Ye = vec(Ye_)
    #Ye0 = []

    Xbeta_ = Xbeta_obj_regression(X, beta_, T, N);

    fv= obj_regression(Ye, Xbeta_, Ye0, w, T, N)

    println("Regression method - optimization")
    println("Initial value of the objective: $fv")

    tol_dfvB = 0.001
    stop_crit = 0
    i = 1
    fvB = 100
    #n_iter = 10
    beta = beta_
    beta_se = beta_

    while stop_crit==0
        Xbeta = Xbeta_obj_regression(X, beta, T, N);
        Ye_new, fvA, term_stat = estim_regression_step_A(Ye, Ye0, Xbeta, w, T, A, b, N)
        st = 1.0
        Ye = st*Ye_new + (1.0-st)*Ye
        fvB_old = fvB
        beta, fvB, beta_se_ = estim_regression_step_B(Ye, Ye0, X, w, T, N)
        beta_se = beta_se_

        if i==1
            dfvB = 1
        else
            dfvB = 100*(fvB_old-fvB)/fvB_old
        end

        if dfvB < tol_dfvB
            stop_crit = 1
        else
            i = i+1
        end

        println("Iter $(i-1): fvA: $fvA ($term_stat) fvB: $fvB   dfvB: $dfvB")
    end

    Xbeta = Xbeta_obj_regression(X, beta, T, N);

    fv, u = obj_regression_with_u(Ye, Xbeta, Ye0, w, T, N)
    
    println("")
    println("Final value of the objective in step A: $fv")

    Ye_ = [reshape(Ye0, 4, N); reshape(Ye, 4*(T-1), N)]
    Ye_ = Ye_[:]


    return Ye_, beta, beta_se, id_ye0, u

end
