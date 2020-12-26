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
