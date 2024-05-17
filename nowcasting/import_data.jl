function import_data()

    fname = "D:/JULIA_Projects/regional GDP disaggregation and nowcasting/github files/nowcasting files/data_all_to_julia_rev.xlsx"

    #annual regional GDP
    gdp_woj = Float64.(XLSX.readdata(fname, "gdp_real", "C3:R19"))
    #quarterly country-level GDP
    gdpq_pol = Float64.(XLSX.readdata(fname, "gdp_real_pol_q", "B6:B73"))

    tq = Array(XLSX.readdata(fname, "gdp_real_pol_q", "A6:A73"))
    t = 2000 .+ [4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20]

    X_pp = Float64.(XLSX.readdata(fname, "pp", "C2:R65"))
    X_cpi = Float64.(XLSX.readdata(fname, "cpi", "C2:R65"))
    X_inv = Float64.(XLSX.readdata(fname, "inv", "C2:R65"))
    X_wag = Float64.(XLSX.readdata(fname, "wag", "C2:R65"))

    Xreg = zeros(64,4,16)
    for i in 1:16
        Xreg[:,1,i] = X_pp[:,i]
        Xreg[:,2,i] = X_cpi[:,i]
        Xreg[:,3,i] = X_inv[:,i]
        Xreg[:,4,i] = X_wag[:,i]
    end
    save("data_Xreg_1q05_4q20.jld2", Dict([("Xreg",Xreg)]))

    data_gdp = Dict([("gdp_woj", gdp_woj), ("gdpq_pol", gdpq_pol),
                 ("tq", tq), ("t", t)])
    save("data_gdp_1q04_4q20.jld2", data_gdp)

    return data_gdp, Xreg
end
