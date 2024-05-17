function adjust_data(gdp_reg, gdpq_country)
    T = size(gdp_reg,1)

    gdp_reg = round.(gdp_reg; digits=0)
    gdpq_country = round.(gdpq_country; digits=1)

    for i=1:T
        gdp_country = sum(gdpq_country[1+4*(i-1):4*i])
        gdp_country_w = sum(gdp_reg[i,:])
        gdp_reg[i,:] = gdp_reg[i,:] .* gdp_country/gdp_country_w
    end

    return gdp_reg, gdpq_country
end
