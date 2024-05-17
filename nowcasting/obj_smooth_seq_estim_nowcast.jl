function obj_smooth_seq_estim_nowcast(Ye, w, Ye0, h, N)

    if length(Ye0)>0
        y = [Ye0; reshape(Ye, h, N)]
    else
        y = reshape(Ye, h, N)
    end

    dy = y[5:end,:] ./ y[1:end-4,:] #annual growth rates
    ddy = (dy[2:end,:] - dy[1:end-1,:]) #changes in the consecutive growth rates

    fv = 0.0
    for i=1:size(ddy,1)
        fv = fv + sum(transpose(ddy[i,:].^2) .* w)
    end

    return fv
end
