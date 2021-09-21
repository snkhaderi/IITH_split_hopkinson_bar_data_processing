# SHPB post-processing
======================================
dispersion_generate_curve.m
======================================
This code generates the dispersion relations, which can be used using dispersion correction
The Output is stored as wave speed vs frequency in a .mat file, which is given as an input in the main function. 
This code has to be run first.


======================================
dispersion.m
======================================
This code does the dispersion correction. i.e., push forward and pull back. 

It needs the following input: dispersion relation data generated from the above code, signal, distance and time increment. 
The fourier time-shifted signal is given as output.
The default ispersion relation data file name is dispersion.mat. Alternative names can also be optionally given.


======================================
SHPB_main.m
======================================
1. Calculates the dispersion relations
2. Loads the data file. data_dir is the location of the dat and vel is the name of the data file. The data file should be a csv file with three coulmns (time, input signal and output signal). 
3. Checks for equilibrium using SHPB_opt.m and SHPB_process.m.
4. Calculates the stress, strain and strate rate for a material using SHPB_process.m 
5. The output is stored as a .out file in the 'out' folder in the data_dir. 


======================================
SHPB_process.m
======================================
This file calculates the stress, strain and strate rate for a material. It needs the driver SHPB_main.m
The signal_start and signal_end variables have to be adjusted to match the waves overlap.


======================================
SHPB_opt.m
======================================
This file calculates the error for the optimizer.


==========================================
GENERAL PROCEDURE
==========================================
1. Set the direcrectory where the data resides using the variable data_dir 
2. Give the file name using the variable vel.
3. Input/verify the below variables
  E = 6;               % voltage of the wheatstone brige
  amp = 100;             % amplification used
  a=6e-3;               % bar radius
  Ebar = 210e9;          % Young's modulus of bar
  C0=5100;               % wave speed of bar
  f_cutt = 100e3;        % cutt-off frequency of the amplifier
  %%%%%%%%%%%%%%%%%%%%%
  Dsample=6e-3;
  Lsample = 2.5e-3;
  % %%%%%%%%%%%%%%%%%%%%
4. Carefully look at the structure of the input file. It will be usually a csv file. Find which columns correspond to which signal. 
5. The variable signal is a column matrix. The first column is the time. The second is the input bar signal. The third is the output bar signal.
Very carefully allocate these variables.
6. Make sure that the variable signal has even number of rows.
7. Set the values of x0 to be approximate locations of the incident and transmission gauges from the sample.
8. Make sure that the variable cal in the file SHPB_process is set properly.
9. You have to set the index at which the signal starts at the sample via the variable signal_start in the file SHPB_process. This is simply set by signal_start = ind_1+x0(1)/C0/dt, where ind_1 is the index at which the signal starts in the oscilloscope
10. You have to set the index at which the signal ends at the sample via the variable signal_end in the file SHPB_process. This is signal_start + 2*l_st/C0/dt, where l_st is the striker length. 

Now return to the code SHPB_main.m and run it. The output should be in the out folder within the directory dir.
