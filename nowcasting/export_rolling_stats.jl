function export_rolling_stats(me_rol_stats, mae_rol_stats, rmse_rol_stats, fname)

    me_rol_stats = permutedims(me_rol_stats, (3,2,1,4))
    mae_rol_stats = permutedims(mae_rol_stats, (3,2,1,4))
    rmse_rol_stats = permutedims(rmse_rol_stats, (3,2,1,4))

    Nstat = size(me_rol_stats, 1)
    hor = size(me_rol_stats, 3)

    output = fill(NaN, (Nstat,5*hor,12))
    hor_labels = fill("", (1,5*hor))
    stat_labels = fill("", (1,5*hor))
    for i=1:hor
        output[:, 1+5*(i-1):5*i-1, 1] = me_rol_stats[:,:,i,1] #ME for cl
        output[:, 1+5*(i-1):5*i-1, 2] = me_rol_stats[:,:,i,2] #ME for sm
        output[:, 1+5*(i-1):5*i-1, 3] = me_rol_stats[:,:,i,3] #ME for sm2
        output[:, 1+5*(i-1):5*i-1, 4] = me_rol_stats[:,:,i,4] #ME for nc_sm3_gr_mat
        output[:, 1+5*(i-1):5*i-1, 5] = mae_rol_stats[:,:,i,1] #MAE for cl
        output[:, 1+5*(i-1):5*i-1, 6] = mae_rol_stats[:,:,i,2] #MAE for sm
        output[:, 1+5*(i-1):5*i-1, 7] = mae_rol_stats[:,:,i,3] #MAE for sm2
        output[:, 1+5*(i-1):5*i-1, 8] = mae_rol_stats[:,:,i,4] #MAE for sm3
        output[:, 1+5*(i-1):5*i-1, 9] = rmse_rol_stats[:,:,i,1] #RMSE for cl
        output[:, 1+5*(i-1):5*i-1, 10] = rmse_rol_stats[:,:,i,2] #RMSE for sm
        output[:, 1+5*(i-1):5*i-1, 11] = rmse_rol_stats[:,:,i,3] #RMSE for sm2
        output[:, 1+5*(i-1):5*i-1, 12] = rmse_rol_stats[:,:,i,4] #RMSE for sm3
        stat_labels[1+5*(i-1):5*i-1] = ["mean" "median" "min" "max"]
        hor_labels[1+5*(i-1)] = "h=" * string(i)
    end

    #println(size(output))

    sh_names = ["rolling ME" "rolling MAE" "rolling RMSE"]

    XLSX.openxlsx(fname, mode="rw") do xf
        XLSX.addsheet!(xf, "rolling ME")
        XLSX.addsheet!(xf, "rolling MAE")
        XLSX.addsheet!(xf, "rolling RMSE")
        xf["rolling ME"]["B4"] = output[:,:,1]
        xf["rolling ME"]["B15"] = output[:,:,2]
        xf["rolling ME"]["B26"] = output[:,:,3]
        xf["rolling ME"]["B37"] = output[:,:,4]
        xf["rolling MAE"]["B4"] = output[:,:,5]
        xf["rolling MAE"]["B15"] = output[:,:,6]
        xf["rolling MAE"]["B26"] = output[:,:,7]
        xf["rolling MAE"]["B37"] = output[:,:,8]
        xf["rolling RMSE"]["B4"] = output[:,:,9]
        xf["rolling RMSE"]["B15"] = output[:,:,10]
        xf["rolling RMSE"]["B26"] = output[:,:,11]
        xf["rolling RMSE"]["B37"] = output[:,:,12]

        for sh in sh_names
            xf[sh]["B1"] = hor_labels
            xf[sh]["B2"] = "Chow-Lin"
            xf[sh]["B3"] = stat_labels
            xf[sh]["A3"] = "Window id"
            xf[sh]["B13"] = "Smoothing"
            xf[sh]["B14"] = stat_labels
            xf[sh]["B24"] = "Smoothing v2"
            xf[sh]["B25"] = stat_labels
            xf[sh]["B35"] = "Smoothing v3"
            xf[sh]["B36"] = stat_labels
        end

    end
end
