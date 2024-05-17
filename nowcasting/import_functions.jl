# define functions
include("import_data.jl")
include("adjust_data.jl")
include("calc_gr.jl")
include("sys_eq_matrices.jl")
include("sys_eq_matrices_nowcast.jl")
include("onestep_smoothing.jl")
include("sequential_smoothing.jl")
include("nowcasting_smoothing.jl")
include("nowcasting_regression.jl")
include("benchmarking_regression.jl")
include("smooth_estimates.jl")
include("smooth_estimates_nowcast.jl")
include("estimate_regression_model.jl")
include("estim_regression_step_A.jl")
include("estim_regression_step_B.jl")
include("obj_smooth_seq_estim.jl")
include("obj_smooth_seq_estim_nowcast.jl")
include("obj_regression.jl")
include("obj_regression_with_u.jl")
include("obj_regression_nowc.jl")
include("Xbeta_obj_regression.jl")
include("Xbeta_obj_regression_nowc.jl")
include("preestimate_beta.jl")
include("gen_id.jl")
include("plot_results2.jl")
include("evaluate_results.jl")
include("calc_stats.jl")
include("calc_rol_stats.jl")
include("calc_heter_stats.jl")
include("export_nowcast_results.jl")
include("export_rolling_stats.jl")
include("export_heter_stats.jl")
