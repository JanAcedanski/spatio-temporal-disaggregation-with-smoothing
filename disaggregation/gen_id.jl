function gen_id(T)

    Tq = 4*T

    id_ye = []
    id_ye0 = []

    for i=0:15
        id_ye = [id_ye; 5+Tq*i:1:Tq*(i+1)]
        id_ye0 = [id_ye0; 1+Tq*i:1:4+Tq*i]
    end

    return id_ye, id_ye0

end
