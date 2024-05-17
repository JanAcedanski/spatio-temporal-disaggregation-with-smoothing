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

    tol_dfvB = 1e-4
    tol_fvB = 1e-6
    stop_crit = 0
    i = 1
    fvB = 100
    #n_iter = 10
    beta = beta_
    beta_se = beta_

    while stop_crit==0
        Xbeta = Xbeta_obj_regression(X, beta, T, N);
        Ye_new, fvA, term_stat = estim_regression_step_A(Ye, Ye0, Xbeta, w, T, A, b, N)
        dYe = norm(Ye-Ye_new)
        st = 1
        Ye = st*Ye_new + (1.0-st)*Ye
        fvB_old = fvB
        beta_new, fvB, beta_se_ = estim_regression_step_B(Ye, Ye0, X, w, T, N)
        dbeta = norm(beta-beta_new)
        st_beta = 1
        beta = st_beta*beta_new + (1.0-st_beta)*beta
        beta_se = beta_se_

        if i==1
            dfvB = 1
        else
            dfvB = 100*(fvB_old-fvB)/fvB_old
        end

        if ((dfvB < tol_dfvB) | (fvB < tol_fvB))
            stop_crit = 1
        end

        i = i+1

        #println("Iter $(i-1): fvA: $fvA ($term_stat)  dYe: $dYe    fvB: $fvB  dbeta: $dbeta   dfvB: $dfvB\n")
        println("Iter $(i-1): fvA: $fvA ($term_stat)    fvB: $fvB    dfvB: $dfvB")
    end

    Xbeta = Xbeta_obj_regression(X, beta, T, N);

    fv, u = obj_regression_with_u(Ye, Xbeta, Ye0, w, T, N)
    
    println("")
    println("Final value of the objective in step A: $fv")

    Ye_ = [reshape(Ye0, 4, N); reshape(Ye, 4*(T-1), N)]
    Ye_ = Ye_[:]


    return Ye_, beta, beta_se, id_ye0, u

end
