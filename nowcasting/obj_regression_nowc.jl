function obj_regression_nowc(Ye_, Xbeta_, Ye0, w, Tq, N)

    if length(Ye0)>0
        y = [reshape(Ye0, 4, N); reshape(Ye_, Tq, N)]
    else
        y = reshape(Ye_, Tq, N)
    end

    u = y[5:end,:]./y[1:end-4,:] .- Xbeta_

    fv = 0.0
    for i in axes(u,1)
        fv = fv + sum(transpose((u[i,:]).^2) .* w)
    end

    return fv
end
