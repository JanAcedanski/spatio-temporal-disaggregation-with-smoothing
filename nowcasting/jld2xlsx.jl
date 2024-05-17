function jld2xlsx(fname, shname)

    fname_jld2 = fname*".jld2"
    fname_xlsx = fname*".xlsx"
    data = values(load(fname_jld2, shname))

    XLSX.openxlsx(fname_xlsx, mode="w") do xf
        XLSX.rename!(xf[1], shname)
        xf[1]["B2"] = data
    end

end
