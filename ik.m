function [ ik ] = ik ( n0, gk, V1, ek )
ik = (n0 .^ 4) * gk * (V1 - ek);


end

