function obj_smooth_seq_estim(Ye, w, Ye0, T, N)

    #println(typeof(Ye))

    if length(Ye0)>0
        y = [Ye0; reshape(Ye, 4*T, N)]
    else
        y = reshape(Ye, 4*T, N)
    end

    dy = y[5:end,:] ./ y[1:end-4,:] #annual growth rates
    ddy = (dy[2:end,:] - dy[1:end-1,:]) #changes in the consecutive growth rates
    #println(typeof(dy))
    fv = 0.0
    for i in axes(ddy,1)
        fv = fv + sum(transpose(ddy[i,:].^2) .* w)
    end

    return fv
end
