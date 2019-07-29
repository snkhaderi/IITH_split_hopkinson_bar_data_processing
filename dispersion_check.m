clc
clear all
close all
global  f_cutt

a=10e-3;
C0=5357;
f_cutt = 300e3;


% file containing the signals
% first coulmn time
% second column input signal
% third column output signal
q = csvread('21-02-2019_velocity_25p83_trial.dat',23);   

% Generate the dispersion curves
dispersion_generate_curve (length(q),q(2,1)-q(1,1),C0,a,'dispersion.mat')

distance_in = (0.589+0.589)*1;   %Distance by which the input signal has to be shifted
distance_ref = -distance_in;   %Distance by which the reflected signal has to be shifted
distance_out = -(0.589+0.589)*0;  %Distance by which the Output signal has to be shifted




figure
t = 1:length(q);
y_1 = dispersion((q(:,2))',0,t(2)-t(1),'disp_curv_file','dispersion.mat');
y_2 = dispersion((q(:,3))',0,t(2)-t(1));

subplot(2,1,1)
plot(t,y_1,'r',t,y_2,'k')
legend('input','transmitted')
ylabel ('signal')
xlabel ('time')

y_1 = dispersion((q(:,2))',distance_in, t(2)-t(1));
y_2 = dispersion((q(:,3))',distance_out,t(2)-t(1));

subplot(2,1,2)
plot(t,y_1,'r',t,y_2,'k')
legend('calculated transmitted','transmitted')
ylabel ('signal')
xlabel ('time')
