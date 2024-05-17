function calc_rol_stats(data)

    hor = size(data, 1)
    Nstat = size(data, 3)
    Nmod = size(data, 4)

    stat_rol_mat = fill(NaN, (hor,4,Nstat,Nmod))

    for i=1:Nmod
        for j=1:Nstat
            data_ = data[:,:,j,i]
            stat_rol_mat[:,:,j,i] = [mean(data_; dims=2) median(data_; dims=2) minimum(data_; dims=2) maximum(data_; dims=2)]
        end
    end

    return stat_rol_mat
end
