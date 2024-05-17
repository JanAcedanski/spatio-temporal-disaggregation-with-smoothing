function nowcasting_smoothing(Ye0, yo_country_nowc, w, N)

    hor = size(yo_country_nowc, 1)
    Ynowc_mat = fill(NaN, (hor, N, hor))

    #A, b = sys_eq_matrices_nowcast(yo_country_nowc)
    #Ynowc_init = A\b
    #Ynowc_init = reshape(Ynowc_init, hor, N)
    #println(size(A))
    #println(Ynowc_init)
    Ynowc_ = zeros(0,N)
    for h_=1:hor
        A_, b_ = sys_eq_matrices_nowcast(yo_country_nowc[1:h_], N)
        #A_ = A[1:h_,1:N*h_]
        #b_ = b[1:h_]
        #println(size(Ynowc_))
        #println(size(Ynowc_init[h_,:]))
        Ynowc_init_ = [Ynowc_; w*yo_country_nowc[h_]]
        #println(size(Ynowc_init_))
        silent = true
        Ynowc_, fv, term_status = smooth_estimates_nowcast(vec(Ynowc_init_), A_, b_, h_, w, Ye0, N, silent)
        print("h = $h_; opt status: $term_status    ")
        Ynowc_ = reshape(Ynowc_, h_, N)
        Ynowc_mat[1:h_, :, h_] = Ynowc_
    end
    print("\n")

    return Ynowc_mat

end
