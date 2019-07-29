function y = dispersion(signal,distance, dt, varargin)

    global  f_cutt   % cut-off frequency

%     check if a non-default file name is used for dispersion relation
    for i = 1:2:length(varargin)
    if strcmp(varargin{i},'disp_curv_file')%varargin{i}=={'disp_curv_file'}
        file = char(varargin(i+1));
        break
    end
    end

    % dt = 3.300000e-7;
    N = length(signal);

    f_cut_off = f_cutt;
    x1 = signal;

    %  find fft
    yp = fft(x1);
    yp = yp(1:length(x1)/2+1);

    f = (0:1/length(x1):1/2)/dt;  % frequencies

    %  Load the dispersion relation file
    if exist('file')==0
        load('dispersion.mat');
    else

     load(file)
    end

    %  Calculate delay time for each frequency
    Delay_time=distance./Cn; 

    %  Apply low pass filter
    yp = (f<f_cut_off).* yp;

    %  Use fourier shifting theorem
    yp = yp.*exp(-1i*2*pi*f.*Delay_time);

    %  Calculate the conjugates and append
    yp = [yp conj(fliplr(yp(2:end-1)))];

    %  Calculate ifft assuming the signal is symmetric
    y = ifft(yp,'symmetric');

end

  
  
  
  
  
  
  
  
