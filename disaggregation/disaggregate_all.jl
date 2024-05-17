####################################################################################
# This is the main file that disaggregates the annual regional GDP series into 
# quarterly series using either smoothing or regression-based approach.
# estim_type variable determines the method used:
# estim_type = "seq" - sequential smoothing
# estim_type = "one" - one-step smoothing
# estim_type = "regression" - regression-based method with auxiliary benchmark series
#
# The script accompanies the paper:
# Jan Acedański, "Disaggregation and nowcasting of regional GDP series with a simple 
# smoothing algorithm", Journal of Official Statistics, submitted
#
# Author: Jan Acedański, University of Economics in Katowice
# Date: 17/05/2024
####################################################################################

using FileIO, Statistics, LinearAlgebra, XLSX, Plots, Printf, StatsBase,
      StatsPlots, DataFrames, GLM, RowEchelon, JuMP, Ipopt

include("import_functions.jl")

data_type = "real" #real/nom
estim_type = "seq" #seq/one/regression
if data_type == "nom"
    period = "02_20"
else
    period = "03_20"
end

data_path = "D:/JULIA_Projects/regional GDP disaggregation and nowcasting/github files/disaggregation files/data_all_to_julia_rev.xlsx"

load_data_from_jld2 = 0 #0 - reading from Excel file; 1 - reading from jld2 file
just_final_plot = 0 #0 - perform full disaggregation; 1 - load the results and make plots only

fname_data = string("data_", data_type, "_", period, ".jld2")
fname_output = string("results_", data_type, "/res_", period, "_", estim_type, "_test.jld2")
fname_output_xlsx = string("results_", data_type, "/res_", period, "_", estim_type, "_test.xlsx")
fname_output_beta_xlsx = string("results_", data_type, "/res_", period, "_", estim_type, "_beta_test.xlsx")

pfolder = string("results_paper_", data_type, "/plots/") #path to plot folder
pname = string("plot_", period, "_", estim_type) #plot names

if load_data_from_jld2 == 0
    data_gdp, X = import_data(data_path, fname_data, data_type, estim_type)
else
    data_gdp = load(fname_data)
    if (estim_type == "regression")
        X = load("data_X_05_20rev.jld2")
        X = X["X"]
    end
end

gdp_reg, t, gdpq_country, tq = values(data_gdp)
#ttt = t
if (estim_type == "regression") #trimming longer GDP data to shorter benchmark series
    if data_type == "real"
        T_drop = 2
    else
        T_drop = 3
    end
    gdp_reg = gdp_reg[1+T_drop:end, :]
    t = t[1+T_drop:end]
    gdpq_country = gdpq_country[1+4*T_drop:end, :]
    tq = tq[1+4*T_drop:end]
end#

T = length(t) #number of years
N = size(gdp_reg,2) #number of regions

gdp_reg_a, gdpq_country_a = adjust_data(gdp_reg, gdpq_country)

if just_final_plot == 1
    A, Ye, b = values(load(fname_output))
else
    if estim_type == "seq"
        Ye = sequential_smoothing(gdp_reg_a, gdpq_country_a, t, N)
        A = []
        b = []
        beta = []
        beta_se = []
        u = []
    elseif estim_type == "one"
        A, b, Ye = onestep_smoothing(gdp_reg_a, gdpq_country_a, N)
        beta = []
        beta_se = []
        u = []
    else #estim_type == "regression"
        A, b, Ye, beta, beta_se, id_ye0, u = benchmarking_regression(gdp_reg_a, gdpq_country_a, X, N)
    end

    save(fname_output, Dict([("Ye",Ye), ("A",A), ("b",b), ("beta",beta), ("beta_se",beta_se)]))
end

dYe = 100*(Ye[5:end,:] ./ Ye[1:end-4,:] .- 1)
dgdp_reg = 100*(gdp_reg[2:end,:] ./ gdp_reg[1:end-1,:] .- 1)
dgdpq_country = 100*(gdpq_country[5:end] ./ gdpq_country[1:end-4] .- 1)
#plot_estimates_final(dYe, dgdp_reg, dgdpq_country, size(dgdp_reg,1), tq[5:end], pfolder, pname)
export_results(Ye, tq, fname_output_xlsx)
export_results_beta(beta, beta_se, u, fname_output_beta_xlsx)

#Yp_mat, Yp_true_mat, models = do_series_forec(dgdp_reg, dgdpq_country, gdp_reg_shares, exog_vars)
