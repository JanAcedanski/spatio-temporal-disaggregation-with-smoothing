function evaluate_results(tvals, nc_sm_mat, nc_regr_mat, da_sm_mat, da_regr_mat, Tmin, hor, Tstat)

    ############# nowcasting results ##############
    Nsam = size(nc_regr_mat, 3)
    T = floor(Int, (size(tvals,1)-4)/4)

    #Tstat = 5 #number of simulations used to calculate rolling accuracy statistics
    Nstat = Nsam - Tstat + 1
    #println([Nsam Nstat])

    nc_regr_gr_mat = fill(NaN, (hor,16,Nsam))
    nc_sm_gr_mat = fill(NaN, (hor,16,Nsam))
    nc_sm2_gr_mat = fill(NaN, (hor,16,Nsam))
    nc_sm3_gr_mat = fill(NaN, (hor,16,Nsam))
    tv_gr_mat = fill(NaN, (hor,16,Nsam))

    for i=1:Nsam
        ycl = [da_regr_mat[4*(Tmin+i-2)+1:4*(Tmin+i-1),:,i]; nc_regr_mat[4*(Tmin+i-1)+1:4*(Tmin+i-1)+hor,:,i]]
        ysm = [da_sm_mat[4*(Tmin+i-2)+1:4*(Tmin+i-1),:,i]; nc_sm_mat[4*(Tmin+i-1)+1:4*(Tmin+i-1)+hor,:,hor,i]]
        ytr = tvals[4*(Tmin+i-2)+1:4*(Tmin+i-1)+hor,:]

        nc_regr_gr_mat[:,:,i] = calc_gr(ycl, 1)
        nc_sm_gr_mat[:,:,i] = calc_gr(ysm, 1)
        tv_gr_mat[:,:,i] = calc_gr(ytr, 1)

        for h=1:8
            if h<=4
                nc_sm2_gr_mat[h,:,i] = 100*(nc_sm_mat[4*(Tmin+i-1)+h,:,h,i] ./ da_sm_mat[4*(Tmin+i-2)+h,:,i] .- 1)
                nc_sm3_gr_mat[h,:,i] = nc_sm2_gr_mat[h,:,i]
            else
                nc_sm2_gr_mat[h,:,i] = 100*(nc_sm_mat[4*(Tmin+i-1)+h,:,h,i] ./ nc_sm_mat[4*(Tmin+i-2)+h,:,h,i] .- 1)
                nc_sm3_gr_mat[h,:,i] = 100*(nc_sm_mat[4*(Tmin+i-1)+h,:,h,i] ./ nc_sm_mat[4*(Tmin+i-2)+h,:,h-4,i] .- 1)
            end
        end
    end

    #println(nc_regr_gr_mat[:,1:2,1])
    #println(nc_sm_gr_mat[:,1:2,1])
    #println(tv_gr_mat[:,1:2,1])

    me_mat = fill(NaN, (hor,16,4))
    mae_mat = me_mat
    rmse_mat = me_mat
    diff_mat_cl = nc_regr_gr_mat - tv_gr_mat
    diff_mat_sm = nc_sm_gr_mat - tv_gr_mat
    diff_mat_sm2 = nc_sm2_gr_mat - tv_gr_mat
    diff_mat_sm3 = nc_sm3_gr_mat - tv_gr_mat
    #println(diff_mat_cl[:,1:2,1])
    #println(diff_mat_sm[:,1:2,1])

    me_mat[:,:,1] = nanmean(diff_mat_cl; dims=3)
    me_mat[:,:,2] = nanmean(diff_mat_sm; dims=3)
    me_mat[:,:,3] = nanmean(diff_mat_sm2; dims=3)
    me_mat[:,:,4] = nanmean(diff_mat_sm3; dims=3)
    me_stats = calc_stats(me_mat)

    mae_mat[:,:,1] = nanmean(abs.(diff_mat_cl); dims=3)
    mae_mat[:,:,2] = nanmean(abs.(diff_mat_sm); dims=3)
    mae_mat[:,:,3] = nanmean(abs.(diff_mat_sm2); dims=3)
    mae_mat[:,:,4] = nanmean(abs.(diff_mat_sm3); dims=3)
    mae_stats = calc_stats(me_mat)

    rmse_mat[:,:,1] = (nanmean(diff_mat_cl.^2; dims=3)).^0.5
    rmse_mat[:,:,2] = (nanmean(diff_mat_sm.^2; dims=3)).^0.5
    rmse_mat[:,:,3] = (nanmean(diff_mat_sm2.^2; dims=3)).^0.5
    rmse_mat[:,:,4] = (nanmean(diff_mat_sm3.^2; dims=3)).^0.5
    rmse_stats = calc_stats(rmse_mat)

    me_rol_mat = fill(NaN, (hor,16,Nstat,4))
    mae_rol_mat = fill(NaN, (hor,16,Nstat,4))
    rmse_rol_mat = fill(NaN, (hor,16,Nstat,4))

    for i=1:Nstat
        me_rol_mat[:,:,i,1] = nanmean(diff_mat_cl[:,:,i:i+Tstat-1]; dims=3)
        me_rol_mat[:,:,i,2] = nanmean(diff_mat_sm[:,:,i:i+Tstat-1]; dims=3)
        me_rol_mat[:,:,i,3] = nanmean(diff_mat_sm2[:,:,i:i+Tstat-1]; dims=3)
        me_rol_mat[:,:,i,4] = nanmean(diff_mat_sm3[:,:,i:i+Tstat-1]; dims=3)
        mae_rol_mat[:,:,i,1] = nanmean(abs.(diff_mat_cl[:,:,i:i+Tstat-1]); dims=3)
        mae_rol_mat[:,:,i,2] = nanmean(abs.(diff_mat_sm[:,:,i:i+Tstat-1]); dims=3)
        mae_rol_mat[:,:,i,3] = nanmean(abs.(diff_mat_sm2[:,:,i:i+Tstat-1]); dims=3)
        mae_rol_mat[:,:,i,4] = nanmean(abs.(diff_mat_sm3[:,:,i:i+Tstat-1]); dims=3)
        rmse_rol_mat[:,:,i,1] = (nanmean(diff_mat_cl[:,:,i:i+Tstat-1].^2; dims=3)).^0.5
        rmse_rol_mat[:,:,i,2] = (nanmean(diff_mat_sm[:,:,i:i+Tstat-1].^2; dims=3)).^0.5
        rmse_rol_mat[:,:,i,3] = (nanmean(diff_mat_sm2[:,:,i:i+Tstat-1].^2; dims=3)).^0.5
        rmse_rol_mat[:,:,i,4] = (nanmean(diff_mat_sm3[:,:,i:i+Tstat-1].^2; dims=3)).^0.5
    end

    me_rol_stats = calc_rol_stats(me_rol_mat)
    mae_rol_stats = calc_rol_stats(mae_rol_mat)
    rmse_rol_stats = calc_rol_stats(rmse_rol_mat)


    ############## disaggregation results ############
    da_regr_gr_mat = fill(NaN, (60,16,Nsam))
    da_sm_gr_mat = fill(NaN, (60,16,Nsam))

    for i=1:Nsam
        da_regr_gr_mat[:,:,i] = calc_gr(da_regr_mat[:,:,i], 1)
        da_sm_gr_mat[:,:,i] = calc_gr(da_sm_mat[:,:,i], 1)
    end

    heter_stats = fill(NaN, (T,2,3,2))
    heter_stats[:,:,:,1] = calc_heter_stats(da_regr_gr_mat, T)
    heter_stats[:,:,:,2] = calc_heter_stats(da_sm_gr_mat, T)

    return me_stats, mae_stats, rmse_stats, me_rol_stats, mae_rol_stats, rmse_rol_stats, heter_stats
end
