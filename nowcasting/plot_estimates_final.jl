function plot_estimates_final(dYe, dgdp_woj, dgdpq_pol, T, tq, pfolder, pname)

    regions = ["Dolnośląskie"
               "Kujawsko-Pomorskie"
               "Lubelskie"
               "Lubuskie"
               "Łódzkie"
               "Małopolskie"
               "Mazowieckie"
               "Opolskie"
               "Podkarpackie"
               "Podlaskie"
               "Pomorskie"
               "Śląskie"
               "Świętokrzyskie"
               "Warmińsko-Mazurskie"
               "Wielkopolskie"
               "Zachodniopomorskie"]

    xt = []
    for i=1:T
        if rem(i,2)==0
            xt = [xt; ""]
        else
            xt = [xt; tq[1+4*(i-1)]]
        end
    end

    for i=1:16
        p0 = plot(2.5:4:2.5+4*(T-1), dgdp_woj[:,i],
                  label = "Annual regional GDP",
                  marker = :square,
                  markersize = 6,
                  color = :black,
                  lw = 3)

        plot!(p0, 1:4*T, [dgdpq_pol[1:4*T] dYe[:,i]],
                  marker = [:no :circle],
                  markersize = [6 6],
                  color = [:gray :blue],
                  lw = [3 4],
                  label = ["Quarterly Poland GDP" "Disaggregated"],
                  ylabel = "[%]",
                  xlabel = "Period",
                  #xtickfont = font(12),
                  #ytickfont = font(12),
                  #legend = (0.16, 0.24),
                  #legendfont = font(12),
                  title = regions[i],
                  ylims = (-15, 13.5),
                  xticks = (1:4:1+4*(T-1), xt),
                  yticks = -15:2.5:12.5);

        plot!(p0, 0:4*T+1, zeros(4*T+2),
                  color = :black,
                  lw = 3,
                  label = "",
                  xlims = (0, 4*T+1));

        if rem(i-1,3)>0
            plot!(p0, legend = :no)
        end

        fname = string(pfolder, pname, "_final_$i.pdf")
        if isfile(fname) == true
            rm(fname)
        end
        savefig(fname)
    end

    #boxplot
    p1 = boxplot(dYe', palette = :Blues_4,
                 #lw = 2,
                 linecolor = :black,
                 legend = :no,
                 xticks = (1:4:1+4*(T-1), xt),
                 ylabel = "[%]",
                 xlabel = "Period",
                 xtickfont = font(12),
                 ytickfont = font(12));

    plot!(p1, 0:4*T+1, zeros(4*T+2),
                color = :black,
                lw = 1,
                label = "",
                xlims = (0, 4*T+1));

    fname = string("plots/", pname, "_boxplot.pdf")
    savefig(fname)
    

    #heterogeneity measures
    sd = std(dYe; dims=2);
    iqr_ = zeros(4*T)
    for i=1:4*T
        iqr_[i] = iqr(dYe[i,:])
    end

    p2 = plot(1:4*T, [sd iqr_],
        color = [:blue :green],
        lw = [3 3],
        label = ["Standard deviation" "Interquartile range"],
        ylabel = "[%]",
        xlabel = "Period",
        title = "Real GDP",
        #xtickfont = font(12),
        #ytickfont = font(12),
        #legend = (0.16, 0.24),
        #legendfont = font(12),
        xticks = (1:4:1+4*(T-1), xt));

    fname = string(pfolder, pname, "_heter.pdf")
    savefig(fname)
end
