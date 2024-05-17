function calc_heter_stats(data, T)

    std_mat = nanstd(data; dims=3)
    max_diff_mat = nanmaximum(data; dims=3) - nanminimum(data; dims=3)
    std_mat_last5 = nanstd(data[:,:,end-4:end]; dims=3)
    max_diff_mat_last5 = nanmaximum(data[:,:,end-4:end]; dims=3) - nanminimum(data[:,:,end-4:end]; dims=3)
    mean_std = nanmean(std_mat; dims=2)
    max_max_diff = nanmaximum(max_diff_mat; dims=2)
    mean_max_diff = nanmean(max_diff_mat; dims=2)
    mean_std_last5 = nanmean(std_mat_last5; dims=2)
    max_max_diff_last5 = nanmaximum(max_diff_mat_last5; dims=2)
    mean_max_diff_last5 = nanmean(max_diff_mat_last5; dims=2)

    res = fill(NaN, (T,2,3))
    for i=1:T
        #mean std
        res[i,:,1] = [mean(mean_std[1+4*(i-1):4*i]) mean(mean_std_last5[1+4*(i-1):4*i])]
        #max max
        res[i,:,2] = [maximum(max_max_diff[1+4*(i-1):4*i]) maximum(max_max_diff_last5[1+4*(i-1):4*i])]
        #mean max
        res[i,:,3] = [mean(mean_max_diff[1+4*(i-1):4*i]) mean(mean_max_diff_last5[1+4*(i-1):4*i])]
    end

    return res

end
