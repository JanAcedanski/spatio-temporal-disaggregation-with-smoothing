function smooth_estimates(Ye, A, b, T, w, Ye0, N)

    println("Smoothing - optimization")
    println("")

    n = length(Ye)
    Ye_start = vec(Ye)

    mod_smooth = Model(Ipopt.Optimizer);
    @variable(mod_smooth, Yeopt[i=1:n], start = Ye_start[i]);
    @constraint(mod_smooth, con_matrix, A * Yeopt == b);
    @objective(mod_smooth, Min, obj_smooth_seq_estim(Yeopt, w, Ye0, T, N));
    JuMP.optimize!(mod_smooth)

    Ye1 = JuMP.value.(Yeopt);

    return Ye1
end
