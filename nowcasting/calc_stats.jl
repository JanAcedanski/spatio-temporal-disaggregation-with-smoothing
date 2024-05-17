function calc_stats(data)

    hor = size(data, 1)
    Nmod = size(data, 3)
    stat_mat = fill(NaN, (hor,4,Nmod))

    for i=1:Nmod
        data_ = data[:,:,i]
        stat_mat[:,:,i] = [mean(data_; dims=2) median(data_; dims=2) minimum(data_; dims=2) maximum(data_; dims=2)]
    end

    return stat_mat
end
