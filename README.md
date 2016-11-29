# FlightGear-Space-Shuttle-Simulation
MATLAB / Simulink and FlightGear based Space Shuttle launch simulation based on real thrust data.

This is a simulation of the NASA Space Shuttle launch to a height of 80 km. It has been written in MATLAB and FlightGear

In order to view the simulation, you will need:

MATLAB (preferably R2014 or newer).
FlightGear (Version 3.0 preferred), this can be changed within the 'FlightGear Preconfigured 6DOF Animation', within the slx file.
Simulink 
Microsoft Excel

To run the simulation, navigate to your folder where you have installed the files.

Open MATLAB
Run the file 'runfirst.m'. This scans the trajectory from the 'outputs.xlsx' file into Simulink
The raw simulation code is in the file 'shuttle_model.m'. Here you can make changes to the equations and code.
The equations were obtained from Chapter 11 from the book: ORBITAL MECHANICS FOR ENGINEERING STUDENTS (Howard Curtis).
They are solved with the generic Euler method (0.2s step size).
