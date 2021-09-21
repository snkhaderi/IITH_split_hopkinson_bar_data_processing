% function [strain, stress_out, stress_in, e_rate] = SHPB_main
clc
clear all
close all
hold on

global signal  distance_in distance_ref distance_out C0 a amp Ebar Values Asample f_cutt v iter


data_dir = './';
vel = 'sample_data.dat';

E = 3.5;               % voltage of the wheatstone brige
amp = 100;             % amplification used
a=10e-3;               % bar radius
Ebar = 217e9;          % Young's modulus of bar
C0=5100;               % wave speed of bar
f_cutt = 300e3;        % cutt-off frequency of the amplifier
%%%%%%%%%%%%%%%%%%%%%
Dsample=6e-3;
Asample =  pi/4*(Dsample)^2;
Lsample = 4e-3;
% %%%%%%%%%%%%%%%%%%%%





mkdir([data_dir  'out'])
fout=[data_dir '/out/' vel '.out'];


d_bar = 2*a;
Abar = pi/4*(d_bar)^2;
Values(1)=Abar;
Values(2)=Asample;
Values(3)=Lsample;



% read the signal
signal= dlmread([ data_dir vel],',',23,0);
% get the dispersion relation
dispersion_generate_curve (length(signal),signal(2,1)-signal(1,1),C0,a,'dispersion.mat')




% % % % % using optimization for finding the locations, 
% % % % % % % % % assuming equibrium holds
options = optimset('TolFun',1e3,'TolX',1e3);
x0 = [0.5 0.5 ];
x = fminsearch(@SHPB_opt,x0,options);
distance_in = x(1);
distance_ref = -x(1);
distance_out = -x(2);
% % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % 
% comment the optimizer and uncomment the below if manual processing is
% preferred
% distance_in = 0.63;   
% distance_ref = -0.63;
% distance_out = -0.63;
% % % % % post process with the optimized distances or manual distance  %  
[Dispersed_signal,stress_in,stress_out,e_rate,strain] = ...
    SHPB_process(signal,distance_in,distance_ref,distance_out,C0,a,amp,Ebar,Values,f_cutt);

% ===================================================================
% ================ Plotting begins ==================================
% ===================================================================

dis_in=Dispersed_signal(:,1);
dis_ref=Dispersed_signal(:,2);
dis_tra=Dispersed_signal(:,3);


dt=signal(2,1)-signal(1,1);
N=length(dis_in);
time=dt*(1:1:N);

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(2)
p=length(dis_in)
plot((1:p)*dt*1e6,dis_in)
hold on
plot((1:p)*dt*1e6,-dis_ref)
hold on
plot((1:p)*dt*1e6,dis_tra)


figure(3)
clf()
plot(time*1e6,stress_out*Asample/1000,'LineWidth',2)

set(gca,'fontsize',14)
hold on
plot(time*1e6,stress_in*Asample/1000,'LineWidth',2)

set(gca,'fontsize',14)
% ylim([-20 200])
xlabel('Time (Microseconds)','FontSize', 14); ylabel('Force (kN)','FontSize', 14)
lgd = legend('Output force','Input force','location','northwest');
lgd.FontSize = 10.5;
% title(lgd,'Velocity 32.36 m/s','FontSize', 10.5)
rect = [0.1, 0.1, .1, .1];

% return
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure (4)
% % subplot(1,2,1)
% plot(-str,stress_jc,'--m','LineWidth',2)
% hold on
plot(-log(1-strain),(stress_out).*(1-strain)/1e6,'LineWidth',2)   %%%%%%%%%% stress-strain by output signal%%%%%%%%%%
% hold on
% plot(m(:,2)/5,m(:,5),'m','LineWidth',2)
xlabel('Engineering strain'); ylabel('Engineering stress (MPa)')
xlim([0 inf]);
ylim([0 2000]);

figure(5)
plot(time*1e6,e_rate,'LineWidth',2)
xlabel('Time (Microseconds)'); ylabel('Strain rate (1/s)')

% fout=[data_dir vel '.out']
fp=fopen(fout,'w');
fprintf (fp,'strain, stress out MPa, stress in MPa, strain rate 1/s\n');
fclose(fp)

stress_out=(stress_out).*(1-strain)/1e6;
stress_in=(stress_in).*(1-strain)/1e6;
% e_rate = -log(1-strain);
% strain
strain = -log(1-strain);
% strain
dlmwrite(fout,[strain' stress_out' stress_in' e_rate' dis_in dis_ref dis_tra],'-append','delimiter',',')

strain = strain' ;
stress_out = stress_out';
stress_in = stress_in';
e_rate = e_rate';

close(v)
% end


