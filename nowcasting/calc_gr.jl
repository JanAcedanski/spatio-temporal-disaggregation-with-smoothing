function calc_gr(y, q_data)

    if q_data == 1 #calculate y-o-y growth rates for quarterly data
        y_gr = 100*((y[5:end,:] - y[1:end-4,:]) ./ y[1:end-4,:])
    else #for annual data
        y_gr = 100*((y[2:end,:] - y[1:end-1,:]) ./ y[1:end-1,:])
    end

    return y_gr
end
