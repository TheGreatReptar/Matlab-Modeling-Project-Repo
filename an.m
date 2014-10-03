function [ an ] = an( V1 ) %given gating variable equation
an = .01 * ((10-V1)/(exp((10-V1)/10)-1));


end

