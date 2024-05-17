####################################################################################
# The script loads the functions used by the procedure.
#
# The script accompanies the paper:
# Jan Acedański, "Disaggregation and nowcasting of regional GDP series with a simple 
# smoothing algorithm", Journal of Official Statistics, submitted
#
# Author: Jan Acedański, University of Economics in Katowice
# Date: 17/05/2024
####################################################################################

include("import_data.jl")
include("adjust_data.jl")
include("sys_eq_matrices.jl")
include("onestep_smoothing.jl")
include("sequential_smoothing.jl")
include("benchmarking_regression.jl")
include("smooth_estimates.jl")
include("estimate_regression_model.jl")
include("estim_regression_step_A.jl")
include("estim_regression_step_B.jl")
include("obj_smooth_seq_estim.jl")
include("obj_regression.jl")
include("obj_regression_with_u.jl")
include("preestimate_beta.jl")
include("gen_id.jl")
include("plot_estimates_seq.jl")
include("plot_estimates_final.jl")
include("export_results.jl")
include("export_results_beta.jl")
include("Xbeta_obj_regression.jl")
