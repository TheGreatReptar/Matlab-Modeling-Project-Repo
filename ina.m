function [ ina ] = ina( m0, gna, h0, V1, ena)
ina = (m0 .^ 3) * gna * h0 * (V1 - ena);


end

