function export_heter_stats(het_stats, fname)

    T = size(het_stats, 1)
    years = [2006:1:2020;]
    titles1 = ["Full sample" "" "" "Last 5 samples"]
    titles2 = ["Chow-Lin" "Smoothing" "" "Chow-Lin" "Smoothing"]
    output_std = [years het_stats[:,1,1,1] het_stats[:,1,1,2] fill(NaN, (T,1)) het_stats[:,2,1,1] het_stats[:,2,1,2]]
    output_max_max = [het_stats[:,1,2,1] het_stats[:,1,2,2] fill(NaN, (T,1)) het_stats[:,2,2,1] het_stats[:,2,2,2]]
    output_mean_max = [het_stats[:,1,3,1] het_stats[:,1,3,2] fill(NaN, (T,1)) het_stats[:,2,3,1] het_stats[:,2,3,2]]

    XLSX.openxlsx(fname, mode="rw") do xf
        XLSX.addsheet!(xf, "heter stats")
        xf["heter stats"]["A3"] = "years"
        #xf["heter stats"]["A4"] = years
        xf["heter stats"]["B1"] = "Mean st. dev."
        xf["heter stats"]["B2"] = titles1
        xf["heter stats"]["B3"] = titles2
        xf["heter stats"]["A4"] = output_std

        xf["heter stats"]["H1"] = "Max. max. difference"
        xf["heter stats"]["H2"] = titles1
        xf["heter stats"]["H3"] = titles2
        xf["heter stats"]["H4"] = output_max_max

        xf["heter stats"]["N1"] = "Mean max. difference"
        xf["heter stats"]["N2"] = titles1
        xf["heter stats"]["N3"] = titles2
        xf["heter stats"]["N4"] = output_mean_max
    end
end
