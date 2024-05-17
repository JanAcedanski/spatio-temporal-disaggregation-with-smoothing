function sequential_smoothing(gdp_reg, gdpq_country, t, N)

    T = size(gdp_reg,1)
    T_init = 4
    n = T - T_init + 2
    dgdp_reg = 100*(gdp_reg[2:end,:] ./ gdp_reg[1:end-1,:] .- 1)

    Ye = zeros(4*T, N)
    #Ye_init = reshape(Ye_init, 4*T, 16)

    ################ initial step ###############
    yo_country = gdpq_country[1:4*T_init]
    yo_reg = gdp_reg[1:T_init, :]
    w_ = sum(yo_reg; dims=1)/sum(yo_reg)
    #println(size(w_))

    #Ye_ = vec(Ye_init[1:4*T_init, :])
    A, b, A_short, b_short = sys_eq_matrices(yo_reg, yo_country, T_init, N)
    Ye_ = A_short\b_short

    silent = true

    Ye_1, fv, term_status = smooth_estimates(Ye_, A_short, b_short, T_init, w_, [], N, silent)
    if term_status == LOCALLY_SOLVED
        print("Initial step - done;  ")
    else
        println("")
        println("Initial step - opt status: $term_status")
    end
    #plot_estimates(Ye_1, Ye_0, yo_reg, yo_country, T_init, tq, "plot_seq_0")
    #save("results_nom_seq0.jld2", Dict([("Ye_1",Ye_1)]))

    Ye[1:4*T_init,:] = reshape(Ye_1, 4*T_init, N)

    ############### estimates for the subsequent periods ##############
    for l=(T_init-1):n

        if ndims(t)>1
            t0_ = t[1,l+1]
            t1_ = t[1,l+2]
        else
            t0_ = t[l+1]
            t1_ = t[l+2]
        end

        Ye0_ = Ye[4*(l-1):4*l,:] #initial 5 quarters of the sequence
        yo_country_ = gdpq_country[1+4*l:4*(l+2)] #subsequent 8 quarters (2 years)
        yo_reg_ = gdp_reg[l+1:l+2, :]
        w_ = sum(yo_reg_; dims=1)/sum(yo_reg_)
        #Ye_ = vec(Ye_init[1+4*l:4*(l+2),:])

        Ye0_ = reshape(Ye0_, 5, N)

        #smooth estimates
        A_, b_, A_short_, b_short_ = sys_eq_matrices(yo_reg_, yo_country_, 2, N)
        Ye_ = A_short_\b_short_
        
        silent = true

        Ye_1, fv, term_status = smooth_estimates(Ye_, A_short_, b_short_, 2, w_, Ye0_, N, silent)
        if term_status == LOCALLY_SOLVED
            print("Period $t0_-$t1_ - done;  ")
        else
            println("")
            println("Period $t0_-$t1_ - opt status: $term_status")
        end
        

        Ye[1+4*l:4*(l+2), :] = reshape(Ye_1, 4*2, N)

    end

    return Ye
end
