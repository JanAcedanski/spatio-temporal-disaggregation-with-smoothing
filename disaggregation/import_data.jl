function import_data(data_path, fname_data, data_type, estim_type)

    #data_path = "D:/JULIA_Projects/regional GDP disaggregation and nowcasting/github files/disaggregation files/data_all_to_julia_rev.xlsx"

    if data_type == "nom"
        #annual regional GDP
        gdp_reg = Float64.(XLSX.readdata(data_path, "gdp_nominal", "C2:R20"))
        #quarterly country-level GDP
        gdpq_country = Float64.(XLSX.readdata(data_path, "gdp_nominal_pol_q", "B2:B80"))

        tq = Array(XLSX.readdata(data_path, "gdp_nominal_pol_q", "A2:A76"))
        t = 2002:2020
    else
        #annual regional GDP
        gdp_reg = Float64.(XLSX.readdata(data_path, "gdp_real", "C2:R19"))
        #quarterly country-level GDP
        gdpq_country = Float64.(XLSX.readdata(data_path, "gdp_real_pol_q", "B2:B76"))

        tq = Array(XLSX.readdata(data_path, "gdp_real_pol_q", "A2:A76"))
        t = 2003:2020
    end

    if (estim_type == "regression")
        X_pp = Float64.(XLSX.readdata(data_path, "pp", "C2:R65"))
        X_cpi = Float64.(XLSX.readdata(data_path, "cpi", "C2:R65"))
        X_inv = Float64.(XLSX.readdata(data_path, "inv", "C2:R65"))
        X_wag = Float64.(XLSX.readdata(data_path, "wag", "C2:R65"))

        X = zeros(64,4,16)
        for i in 1:16
            X[:,1,i] = X_pp[:,i]
            X[:,2,i] = X_cpi[:,i]
            X[:,3,i] = X_inv[:,i]
            X[:,4,i] = X_wag[:,i]
        end
        save("data_X_05_20rev.jld2", Dict([("X",X)]))

    else
        X=[]
    end

    data_gdp = Dict([("gdp_reg", gdp_reg), ("gdpq_country", gdpq_country),
                 ("tq", tq), ("t", t)])

    save(fname_data, data_gdp)

    return data_gdp, X
end
