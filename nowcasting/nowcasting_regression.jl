function nowcasting_regression(beta, yo_country_nowc, X_nc, w, Ye0, N)

    Tq = size(yo_country_nowc, 1)
    #T = Tq/4
    #Tb = size(Ye0, 1)
    A_, b_ = sys_eq_matrices_nowcast(yo_country_nowc, N)
    Ynowc_init = zeros(Tq, N)
    for i=1:Tq
        Ynowc_init[i,:] = w*yo_country_nowc[i]
    end
    Ye_start = vec(Ynowc_init)
    n = length(Ye_start)

    Xbeta_nc = Xbeta_obj_regression_nowc(X_nc, beta, N);

    mod_reg_nc = Model(Ipopt.Optimizer);
    set_silent(mod_reg_nc);
    @variable(mod_reg_nc, Yeopt[i=1:n], start = Ye_start[i]);
    @constraint(mod_reg_nc, con_matrix, A_ * Yeopt == b_);
    @objective(mod_reg_nc, Min, obj_regression_nowc(Yeopt, Xbeta_nc, Ye0, w, Tq, N));
    JuMP.optimize!(mod_reg_nc);

    Ye1 = JuMP.value.(Yeopt);
    fv = JuMP.objective_value(mod_reg_nc);
    term_status = JuMP.termination_status(mod_reg_nc);

    #fv = obj_chow_lin_nowcast(Ye, zeros(length(Ynowc_init)), beta, X_nc, w, Ye0, Tq)
    #println("Chow-Lin nowcasting - optimization")
    #println("Initial value of the objective: $fv")

    #n = length(Ye)
    #opt = Opt(:AUGLAG, n)
    #opt.local_optimizer = Opt(:LD_LBFGS, n)
    #opt.xtol_rel = 1e-3

    #min_objective!(opt, (y, grad) -> obj_chow_lin_nowcast(y, grad, beta, X_nc, w, Ye0, Tq))
    #equality_constraint!(opt, (r, y, grad) -> con_chow_lin_nowcast(r, y, grad, A_, b_), 1e-2*ones(length(b_)))

    #@time begin
    #    (minf,Ye1,ret) = optimize(opt, Ye)
    #    numevals = opt.numevals # the number of function evaluations
    #    println("got $minf after $numevals iterations (returned $ret)")
    #end

    Ye = reshape(Ye1, Tq, N)

    return Ye, fv, term_status

end
