function export_results_beta(beta, beta_se, u, fname)
    XLSX.openxlsx(fname, mode="w") do xf
        sheet = xf[1]
        sheet["A2"] = beta
        sheet["G2"] = beta_se
        sheet["M2"] = u
    end
end
