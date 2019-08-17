

function err = SHPB_opt(x)
    global signal  distance_in distance_ref distance_out C0 a amp Ebar Values Asample f_cutt v iter

    x
    distance_in = x(1);
    distance_ref = -x(1);
    distance_out = -x(2);
    [Dispersed_signal,stress_in,stress_out,e_rate,strain] = ...
        SHPB_process(signal,distance_in,distance_ref,distance_out,C0,a,amp,Ebar,Values,f_cutt);
    is = 1;                             % we can play with this parameter to enforce where to see eqbm
    ie = length(e_rate)*1;              % we can play with this parameter to enforce where to see eqbm
    err = norm(stress_in-stress_out);   % use this error measure for optimization

end
