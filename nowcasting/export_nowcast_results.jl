function export_nowcast_results(me_stats, mae_stats, rmse_stats, fname)
    XLSX.openxlsx(fname, mode="w") do xf
        XLSX.rename!(xf[1], "ME")
        xf[1]["B3"] = me_stats[:,:,1]
        xf[1]["G3"] = me_stats[:,:,2]
        xf[1]["L3"] = me_stats[:,:,3]
        xf[1]["Q3"] = me_stats[:,:,4]
        XLSX.addsheet!(xf, "MAE")
        xf[2]["B3"] = mae_stats[:,:,1]
        xf[2]["G3"] = mae_stats[:,:,2]
        xf[2]["L3"] = mae_stats[:,:,3]
        xf[2]["Q3"] = mae_stats[:,:,4]
        XLSX.addsheet!(xf, "RMSE")
        xf[3]["B3"] = rmse_stats[:,:,1]
        xf[3]["G3"] = rmse_stats[:,:,2]
        xf[3]["L3"] = rmse_stats[:,:,3]
        xf[3]["Q3"] = rmse_stats[:,:,4]

        for i=1:3
            xf[i]["B1"] = "Chow-Lin"
            xf[i]["G1"] = "Smoothing"
            xf[i]["L1"] = "Smoothing v2"
            xf[i]["Q1"] = "Smoothing v3"
            xf[i]["B2"] = ["mean" "median" "min" "max"]
            xf[i]["G2"] = ["mean" "median" "min" "max"]
            xf[i]["L2"] = ["mean" "median" "min" "max"]
            xf[i]["Q2"] = ["mean" "median" "min" "max"]
            xf[i]["A2"] = "Horizon"
            xf[i]["A3"] = 1
            xf[i]["A4"] = 2
            xf[i]["A5"] = 3
            xf[i]["A6"] = 4
            xf[i]["A7"] = 5
            xf[i]["A8"] = 6
            xf[i]["A9"] = 7
            xf[i]["A10"] = 8
        end
    end
end
