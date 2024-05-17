function sys_eq_matrices(yo_reg, yo_country, T, N)

    Tq = 4*T
    #A
    A = zeros(N*T+Tq, N*Tq)
    for i=1:N
        for j=1:T
            ir = j + T*(i-1)
            ic = 4*(j-1) + Tq*(i-1)
            j_ = 4*(j-1)
            A[ir,ic+1:ic+4] = ones(4,1) #annual regional growth rates
        end

        for j=1:Tq
            ir = N*T + j
            ic = j + Tq*(i-1)
            A[ir,ic] = 1
        end
    end

    b = zeros(N*T+Tq)
    b[1:N*T] = vec(yo_reg)
    b[N*T+1:end] = yo_country

    #removing reduntant (linearly dependent) rows
    #to facilitate optimization
    (mp, id_rows) = rref_with_pivots(A')
    A_short = A[id_rows,:]
    b_short = b[id_rows]

    return A, b, A_short, b_short

end
