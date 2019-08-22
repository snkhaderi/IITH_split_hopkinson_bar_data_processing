function [Dispersed_signal,stressin,stressout,erate,strain] = SHPB_process(q,distance_in,distance_ref,distance_out, C0,a,amp,Ebar,Values,f_cutt)

% % q is the array containing signals
% % first coulmn time
% % second column input signal
% % third column output signal
    time = q(:,1);
    q(:,2) = q(:,2)-mean(q(1:100,2));
    q(:,3) = q(:,3)-mean(q(1:100,3));   
    incident1 = dispersion(q(:,2)',distance_in, C0,a);      % may need to modify                            
    reflected1 = dispersion(q(:,2)',distance_ref, C0,a);    % may need to modify
    transmitted1 = dispersion(q(:,3)',distance_out, C0,a);  % may need to modify

    Abar=Values(1);     %area of bar
    Asample=Values(2);     %area of sample
    Lsample=Values(3);      %length of sample

%     eps/signal = (1/amp/1.07/V_app)
    cal = 1/amp*1000/3.5*940*1e-6;  % may need to modify



    time = q(:,1);
    incident = incident1*cal;   % calculate strains from signals
    reflected = reflected1*cal;   % calculate strains from signals
    transmitted = transmitted1*cal;   % calculate strains from signals
    %
    figure (1)
    clf(1)
    plot(incident1,'r')
    hold on 
    plot(-reflected1,'k')
    plot(transmitted1,'b-')
    pause(0.00001)
    dt=time(2)-time(1);

    signal_start = 500;                              % may need to modify depending on the signal location
    signal_end = 900 ;                               % may need to modify depending on the signal location


size(incident)
    m=signal_end-signal_start;
    incident = (incident(signal_start:signal_end));
    % incident = incident - mean(incident(1:40));
    reflected = (reflected(signal_start:signal_end));
    % reflected = reflected - mean(reflected(1:40));
    transmitted = (transmitted(signal_start:signal_end));
    % transmitted = transmitted - mean(transmitted(1:40));

size(incident)
    Dispersed_signal(:,1)=incident;
    Dispersed_signal(:,2)=reflected;
    Dispersed_signal(:,3)=transmitted;

    stressout = transmitted *Ebar*Abar/Asample;
    stressin = (incident+reflected) *Ebar*Abar/Asample;

    erate = (incident-reflected - transmitted)/Lsample*C0;

    for i = (1:length(erate))
       strain(i) = trapz(erate(1:i))*dt; 
    end



end
