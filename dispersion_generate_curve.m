function dispersion_generate_curve (npt,dt,C0,a,name)
close all
clc
% npt=2000;           % number of signal points
% dt = 3.3e-7;       % time interval of the signal
% C0=5000;    %   wave speed of the bar 
% a=10e-3;   %   radius of the bar
% name = 'name_of_the_mat_file.mat';

if exist('npt')==0
    npt=2000
end
if exist('dt')==0
    dt=3.3e-7
end
if exist('C0')==0
    C0=5000
end
if exist('a')==0
    a=10e-3
end
if exist('name')==0
    name='dispersion.mat'
end


t = 0:npt-1;
t=t*dt;

%%%%% check using a sine wave
% signal= sin(2*pi*10e3*t);

%%%%% check using a square wave
signal = t* 0;
nterms=10;
f_sq = 10e3;
omega = 2*pi*f_sq;
for i = 1:2:nterms
    signal=signal+sin(i*omega*t)/i;
end

dispersion_gen(signal, a,dt,C0,name)


subplot(2,2,1)
plot(t,signal)
xlabel('time')
ylabel('signal')
% 
subplot(2,2,2)
yL = get(gca,'YLim');
for i = 1:2:nterms
    line([f_sq f_sq]*i,yL,'Color','k');
end


end



function  dispersion_gen(signal, a,dt, C0,name_of_file)

 N = length(signal);

 x1 = signal;

 
 yp = fft(x1);
 yp = yp(1:length(x1)/2+1);
 f = (0:1/length(x1):1/2)/dt;  % frequencies
 for j = 1:N/2+1
    F=(f(j));
    myfun=@(x) fun(x,a,F,C0);
    Cn(j) = fzero(myfun,a);
 end
 
 subplot(2,2,2)
 semilogx(f, abs(yp),'r');
 xlabel('frequency (Hz)')
ylabel('magnitude ')

 subplot(2,2,3)
 plot(f,Cn/C0,'r');
 ylim([0 1])
 xlabel('frequency (Hz)')
ylabel('Cn/C0')

 save (name_of_file, 'f','Cn')
 disp('========================================================')
 disp('the dispersion curve has been saved in the file:' )
 name_of_file
 disp('========================================================')

end

function myfun =  fun(Cn,a,F,C0)

% global a F C0 lam
% C0=1;
%%%%%%%%%% change the coefficients for various Poisson's ratio
A=0.574;
B=0.426;
C=19.53;
D=19.70;
E=-7.00;
G=2.38;
lam = Cn/F;
lhs = (Cn/C0);
rhs = A+B/...
    (1+C*(a/lam)^4 +D*(a/lam)^3+E*(a/lam)^2+G*(a/lam)^1.5  );
if a/lam <= 0
    rhs=1;
end
myfun = lhs - rhs;
% 

% myfun = (Cn/C0)-(0.8-0.2*tanh(5*(a/lam-0.5)));
% 
% myfun = (Cn/C0)-1;

end
  
  

  
  
