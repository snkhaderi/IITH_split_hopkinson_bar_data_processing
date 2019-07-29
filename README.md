# dispersion_curves
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
