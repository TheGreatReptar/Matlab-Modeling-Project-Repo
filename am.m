function [ am ] = am( V1 ) %given gating variable equation
am = 0.1 .* ((25-V1)/(exp((25-V1)/10)-1));



end

