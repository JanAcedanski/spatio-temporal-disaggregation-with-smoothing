function plot_results2(disagg_cl_mat, nowcast_cl_mat)

    Nsam = size(disagg_cl_mat, 3)
    y = disagg_cl_mat[:,1,1]
    y_gr = calc_gr(y, 1)
    p0 = plot(1:12, y_gr[1:12], color = :blue, lw = 3);

    y_ = [y[1:16]; nowcast_cl_mat[17:24,1,1]]
    y_gr_ = calc_gr(y_, 1)
    plot!(p0, 12:20, y_gr_[12:20], color = :green, lw = 1);

    return p0

end
