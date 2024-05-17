function sys_eq_matrices_nowcast(yo_country, N)

    hor = size(yo_country,1)
    #A
    A = zeros(hor, N*hor)
    for i=1:N
        for j=1:hor
            ir = j
            ic = j + hor*(i-1)
            A[ir,ic] = 1
        end
    end

    b = yo_country

    return A, b

end
