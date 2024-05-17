function smooth_estimates_nowcast(Ye, A, b, h, w, Ye0, N, silent)

    #println("")
    #println("Smoothing - optimization")

    #fv = obj_smooth_seq_estim_nowcast(Ye, zeros(length(Ye)), w, Ye0, h)
    #r, grad_con = con_smooth_seq_estim(A*Ye-b, Ye, zeros(size(A')), A, b)
    #println("Initial value of the smoothing objective: $fv")
    #println(r)
    #println(size(grad_con))
    #println("Optimization algorithm: SLSQP")
    #println("Optimization algorithm: AUGLAG_BFGS")
    #println("")
    #n = length(Ye)
    #opt = Opt(:AUGLAG, n)
    #local_opt = Opt(:LD_LBFGS, n)
    #opt = Opt(:LD_SLSQP, n)
    #opt.lower_bounds = 0.97*Ye
    #opt.upper_bounds = 1.03*Ye
    #opt.xtol_rel = 1e-3

    #println(Ye0[:,1:2])
    #println(Ye[1:2])
    #println(w[1:2])
    #println(h)
    #println(size(A))
    #println(size(b))
    #min_objective!(opt, (y, grad) -> obj_smooth_seq_estim_nowcast(y, grad, w, Ye0, h))
    #equality_constraint!(opt, (r, y, grad) -> con_smooth_seq_estim(r, y, grad, A, b), 1e-2*ones(length(b)))
    #opt.local_optimizer = local_opt

    #@time begin
    #    (minf,Ye1,ret) = optimize(opt, Ye)
    #    numevals = opt.numevals # the number of function evaluations
    #    println("got $minf after $numevals iterations (returned $ret)")
    #end

    n = length(Ye)
    Ye_start = vec(Ye)

    mod_smooth_nowc = Model(Ipopt.Optimizer);
    if silent
        set_silent(mod_smooth_nowc)
    end
    @variable(mod_smooth_nowc, Yeopt[i=1:n], start = Ye_start[i]);
    @constraint(mod_smooth_nowc, con_matrix, A * Yeopt == b);
    @objective(mod_smooth_nowc, Min, obj_smooth_seq_estim_nowcast(Yeopt, w, Ye0, h, N));
    JuMP.optimize!(mod_smooth_nowc)

    Ye1 = JuMP.value.(Yeopt);
    fv = JuMP.objective_value(mod_smooth_nowc);
    term_status = JuMP.termination_status(mod_smooth_nowc);

    return Ye1, fv, term_status
end
