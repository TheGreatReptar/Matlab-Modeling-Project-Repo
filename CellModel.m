function  CellModel( I, step, pulseorconstant,plotthis ) %I is a double single integer, step is the step size of time between data points, pulseorconstant is a string to tell if I is a pulse or constant
%input plotthis is either 'Voltage', 'gK', 'gL' or 'gNa' to choose which variable
%you want to have plotted
gk = 36;
gna = 120;
gl = 0.3;
ek = -12;
ena = 115;
el = 10.6;
V1 = -70; %membrane voltage
cm = 1;
V2 = []; %will be a vector of the membrane voltage of every loop of the system
t = 0; %initial time of zero
timevector = []; %vector of all recorded times for graphing
stepnum = 1;
 AM = am(V1); %AM through Vchange's lines are just given formulas in the form of functions so things are less messy
    BM = bm1(V1);
    AN = an(V1);
    BN = bn(V1);
    AH = ah(V1);
    BH= bh(V1);
M0 = m0(AM, BM);
N0 = n0(AN, BN);
H0 = h0(AH,BH);
Mvec = [];
Nvec = [];
Hvec = [];

if strcmp(pulseorconstant,'pulse') == 1 %pulse assumes shortest step size for the duration of the current
    totalsteps = ceil(100 / step);
    zerovector = zeros([1,totalsteps]);%make a vector of zeroes to be the values in every loop except the first
    I = [I,zerovector]; %concatenate to get a vector of the applied current for every loop
elseif strcmp(pulseorconstant,'constant') == 1
    I = I * ones([1,ceil(100/step)]); %I is constant for all loops
else 
    print( 'Please input either "pulse" or "constant"')
end

while t < 100 
    timevector = [timevector, t]; %put the time for this loop into timevector
   
    
    INA = ina(M0,gna,H0,V1,ena);
    IK = ik(N0,gk,V1,ek);
    IL = il(gl,V1,el);
    MChange = AM * (1 - M0) - BM * M0;
    M0 = M0 + step * MChange;
    
    IION = iion(I(stepnum),IK,INA,IL);
    
    MChange = AM * (1 - M0) - BM * M0; %given
    M0 = M0 + step * MChange;%euler's
    gn2 = 1/(M0 / INA); %solve for resistance
    Mvec = [Mvec, gn2]; %put this resistance into mvec
    NChange = AN * (1 - N0) - BN * N0;%the above 4 lines are repeated for N and H
    N0 = N0 + step * NChange;
    gk2 = 1/(N0 / IK);
    Nvec = [Nvec, gk2];
    HChange = AH * (1 - H0) - BH * H0;
    H0 = H0 + step * MChange;
    gh2 = 1/(H0 / IL);
    Hvec = [Hvec, gh2];
    
    VCHANGE = Vchange(IION,cm); 
    V1 = V1 + step * VCHANGE; %euler's to have the loop return what the voltage will be on the next loop
    V2 = [V2, V1] ;%add this new value to the V2 vector
    
    
    
    
    stepnum = stepnum + 1;%increases stepnum so the proper numbers are indexed out of certain vectors
    t = t + step; %add the step time to get the next 
end
   
if strcmp(plotthis,'Voltage') == 1
plot(timevector,V2)
xlabel('Time(ms)') 
ylabel('Voltage(mV)')
title('Membrane Potential')

elseif strcmp(plotthis,'gNa') == 1
    plot(timevector, Mvec)
xlabel('Time(ms)')
ylabel('Conductance(S/cm^2)')
title('gNA')

elseif strcmp(plotthis,'gK') == 1 
    plot(timevector, Nvec)
xlabel('Time(ms)')
ylabel('Conductance(S/cm^2)')
title('gK')

elseif strcmp(plotthis,'gL')==1
plot(timevector, Hvec)
xlabel('Time(ms)')
ylabel('Conductance(S/cm^2)')
title('gL')

else 
    Print('Please input either Voltage, gNa, gK, or gL for variable plotthis')


end

