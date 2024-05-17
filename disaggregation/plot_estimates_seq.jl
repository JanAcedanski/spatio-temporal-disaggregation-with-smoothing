function plot_estimates_seq(Ye, Ye0, dgdp_woj, T, tq, pfolder, pname)

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

    for i=1:16

        p0 = plot(tq[1:4*T], Ye[:,i],
                  marker = :circle,
                  color = :blue,
                  lw = 3,
                  label = "Estim. smoothed",
                  ylabel = "[%]",
                  xlabel = "Period");

        tq_ = tq[4*(T-2):4*T]
        #println(size(tq_))
        #println(size(Ye0[:,i]))
        plot!(p0, tq_, Ye0[:,i],
                  seriestype = :line,
                  marker = :no,
                  color = :blue,
                  lw = 1,
                  label = "Estim. raw");

        tq_ = tq[2:4:2+4*(T-1)]
        plot!(p0, tq_, dgdp_woj[:,i],
              label = "Original annual data",
              marker = :square,
              color = :black,
              lw = 3,
              #legend = :no,
              title = regions[i]);

        fname = string(pfolder, pname, "seq_$i")
        if isfile(fname) == true
            rm(fname)
        end
        savefig(fname)
    end

end
