using FileIO, Statistics, LinearAlgebra, XLSX, NLopt, Plots, Printf, StatsBase,
      StatsPlots, DataFrames, GLM, RowEchelon, NaNStatistics, JuMP, Ipopt

include("import_functions.jl")

load_data_from_jld2 = 1 #0/1
load_true_vals = 0
load_simul_results = 0
#perform simulation exercise
Tmin = 7 #starting lenght of the sample
hor = 8 #nowcasting horizon in quarters
Nsam = 17 - (Tmin+1) - 1 #number of samples (windows)
Tstat = 4 #number of samples used to calculate rolling statistics

if load_data_from_jld2 == 0
    data_gdp, Xreg = import_data()
else
    data_gdp = load("data_gdp_1q04_4q20_rev.jld2")
    Xreg = load("data_Xreg_1q05_4q20_rev.jld2", "Xreg")
end

gdp_reg, t, gdpq_country, tq = values(data_gdp)
gdp_reg = gdp_reg[2:end,:]
gdpq_country = gdpq_country[5:end]
t = t[2:end]
tq = tq[5:end]
N = size(gdp_reg,2) #number of regions
gdp_reg_a, gdpq_country_a = adjust_data(gdp_reg, gdpq_country)

#true values
if load_true_vals == 0
    #true_vals_yearly = calc_gr(gdp_reg, 0)
    true_vals_yearly = gdp_reg
    save("true_vals_yearly_06_20.jld2", Dict([("true_vals_yearly", true_vals_yearly)]))

    println("=========== CALCULATING ''TRUE'' VALUES ==============")
    println("== ONE-STEP SMOOTHING ==")
    A, b, true_vals_smooth_ = onestep_smoothing(gdp_reg_a, gdpq_country_a, N)
    true_vals_smooth = true_vals_smooth_
    save("true_vals_smooth_1q06_4q20.jld2", Dict([("true_vals_smooth", true_vals_smooth)]))

    println("")
    println("== REGRESSION ==")
    A, b, true_vals_regress_, beta, beta_se, id_ye0, u = benchmarking_regression(gdp_reg_a, gdpq_country_a, Xreg, N)
    #true_vals_regress = calc_gr(true_vals_regress_, 1)
    true_vals_regress = true_vals_regress_
    save("true_vals_regress_1q06_4q20.jld2", Dict([("true_vals_regress", true_vals_regress)]))

else
    println("==================== LOADING ''TRUE'' VALUES ===============")
    true_vals_yearly = values(load("true_vals_yearly_06_20.jld2", "true_vals_yearly"))
    true_vals_smooth = values(load("true_vals_smooth_1q06_4q20.jld2", "true_vals_smooth"))
    true_vals_regress = values(load("true_vals_regress_1q06_4q20.jld2", "true_vals_regress"))
end

true_vals_mean = (true_vals_smooth + true_vals_regress) / 2


if load_simul_results == 0
    nowcast_smooth_mat = fill(NaN, (64,N,hor,Nsam))
    nowcast_regress_mat = fill(NaN, (64,N,Nsam))
    disagg_smooth_mat = fill(NaN, (64,N,Nsam))
    disagg_regress_mat = fill(NaN, (64,N,Nsam))
    beta_mat = fill(NaN, (5,N,Nsam))

    #Nsam=1
    tstart = time_ns()
    for i=1:Nsam
        #if i==4
        #    println("iter 4")
        #    [1, 2] ./ [1,2,3]
        #end
        t_ = t[Tmin+i-1+2]
        println("")
        println("===========================================================")
        println("=========== Iteration $i/$Nsam. Period 2005-$t_ ==============")
        tt = time_ns()
        elaps_time = (tt-tstart)/1.0e9
        @printf("============== Elapsed time: %.1f sec. =====================\n", elaps_time)
        #println("===========================================================")

        gdp_reg_ = gdp_reg_a[1:Tmin+i-1, :]
        gdpq_country_ = gdpq_country_a[1:4*(Tmin+i-1)]
        X_ = Xreg[1:4*(Tmin+i-1), :, :]
        gdpq_country_nowc_ = gdpq_country_a[4*(Tmin+i-1)+1:4*(Tmin+i-1)+hor]
        X_nowc_ = Xreg[4*(Tmin+i-2)+1:4*(Tmin+i-1)+hor, :, :]
        w_ = sum(gdp_reg_; dims=1)/sum(gdp_reg_)


        println("======================= SMOOTHING =======================")
        println("== DISAGGREGATION ==")
        Ye_smooth_seq_ = sequential_smoothing(gdp_reg_, gdpq_country_, t, N)
        disagg_smooth_mat[1:4*(Tmin+i-1), :, i] = Ye_smooth_seq_
        #println(Ye_smooth_seq_)

        println("")
        println("== NOWCASTING ==")
        Ynowc_sm_mat = nowcasting_smoothing(Ye_smooth_seq_[end-4:end,:], gdpq_country_nowc_, w_, N)
        nowcast_smooth_mat[4*(Tmin+i-1)+1:4*(Tmin+i-1)+hor, :, :, i] = Ynowc_sm_mat

        println("")
        println("====================== REGRESSION =====================")
        println("== DISAGGREGATION ==")
        A_, b_, Ye_regress_disagg_, beta_regress_, beta_se_regress_, id_ye0_ = benchmarking_regression(gdp_reg_, gdpq_country_, X_, N)
        disagg_regress_mat[1:4*(Tmin+i-1), :, i] = Ye_regress_disagg_
        #println(Ye_regress_disagg_)

        println("== NOWCASTING ==")
        Ynowc_regress_mat, fv, term_status = nowcasting_regression(beta_regress_, gdpq_country_nowc_, X_nowc_, w_, Ye_regress_disagg_[end-3:end,:], N)
        println("Horizons 1:$hor - opt status: $term_status")
        nowcast_regress_mat[4*(Tmin+i-1)+1:4*(Tmin+i-1)+hor, :, i] = Ynowc_regress_mat
        #println(Ynowc_mat)

    end

    save("results_smooth_full.jld2", Dict([("disagg_smooth_mat",disagg_smooth_mat), ("nowcast_smooth_mat",nowcast_smooth_mat)]))
    save("results_regress_full.jld2", Dict([("disagg_regress_mat",disagg_regress_mat), ("nowcast_regress_mat",nowcast_regress_mat)]))

else
    nowcast_smooth_mat = values(load("results_smooth_full.jld2", "nowcast_smooth_mat"))
    disagg_smooth_mat = values(load("results_smooth_full.jld2", "disagg_smooth_mat"))
    nowcast_regress_mat = values(load("results_regress_full.jld2", "nowcast_regress_mat"))
    disagg_regress_mat = values(load("results_regress_full.jld2", "disagg_regress_mat"))

end

true_vals = true_vals_smooth
me_stats, mae_stats, rmse_stats, me_rol_stats, mae_rol_stats, rmse_rol_stats, heter_stats = evaluate_results(true_vals, nowcast_smooth_mat, nowcast_regress_mat, disagg_smooth_mat, disagg_regress_mat, Tmin, hor, Tstat)

fname = "nowcast_results_vs_smooth_rev.xlsx"
export_nowcast_results(me_stats, mae_stats, rmse_stats, fname)
export_rolling_stats(me_rol_stats, mae_rol_stats, rmse_rol_stats, fname)
export_heter_stats(heter_stats, fname)

# Explanations: how growth rates for period t+h are calculated
# Smoothing baseline: y_s(t+h,hor)/y_s(t+h-4,hor) - gr calculated using the longest horizon estimates (h=8) only; unrealistic
# Smoothing 2: y_s(t+h,h)/y_s(t+h-4,h) - gr calculated using current estimates only; we update all the nowcasts
# Smoothing 3: y_s(t+h,h)/y_s(t+h-4,h-4) - gr calculated using current (numerator) and previous (denominator) estimates; we don't update previous nowcasts; just add the last one
