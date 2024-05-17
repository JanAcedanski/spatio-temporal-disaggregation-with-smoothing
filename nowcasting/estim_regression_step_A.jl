function estim_regression_step_A(Ye, Ye0, Xbeta, w, T, A, b, N)

    n = length(Ye)
    Ye_start = vec(Ye)

    mod_reg = Model(Ipopt.Optimizer);
    set_silent(mod_reg);
    set_attribute(mod_reg, "tol", 1e-8)
    @variable(mod_reg, Yeopt[i=1:n], start = Ye_start[i]);
    @constraint(mod_reg, con_matrix, A * Yeopt == b);
    @objective(mod_reg, Min, obj_regression(Yeopt, Xbeta, Ye0, w, T, N));
    JuMP.optimize!(mod_reg);

    Ye = JuMP.value.(Yeopt);
    fvA = JuMP.objective_value(mod_reg);
    term_stat = JuMP.termination_status(mod_reg);

    return Ye, fvA, term_stat

end
