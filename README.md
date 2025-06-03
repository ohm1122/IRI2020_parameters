# IRI2020_parameters
Calculation and Visualization of Ionospheric Characteristic Parameters Based on the IRI2020 Model

# Calculation and Visualization of Ionospheric Characteristic Parameters Based on the IRI2020 Model

## 1. Research Background

The ionosphere is a crucial component of Earth's atmosphere, located approximately 60-1000 kilometers above the ground and containing a significant number of free electrons and ions. The ionosphere has important impacts on modern technological systems such as radio communications, satellite navigation, and space weather monitoring. The International Reference Ionosphere (IRI) model, jointly developed by the Committee on Space Research (COSPAR) and the International Union of Radio Science (URSI), is an empirical ionospheric model widely used in ionospheric research and engineering applications.

This article introduces a MATLAB-based method for calculating and visualizing ionospheric characteristic parameters using the IRI2020 Fortran program, which efficiently retrieves and displays key ionospheric parameters for specific geographic locations and time ranges.

## 2. Technical Principles

### 2.1 Overview of the IRI Model

IRI2020 is the latest version of the International Reference Ionosphere model. It is an empirical model based on global ionospheric observation data, including ground-based ionosondes and satellite measurements. The model can calculate ionospheric parameters such as electron density, electron temperature, ion temperature, and ion composition as functions of altitude, geographic location, time (diurnal and seasonal variations), and solar activity levels.

### 2.2 Key Ionospheric Parameters

The code calculates and visualizes the following important ionospheric parameters:

1. **Critical Frequencies**: foF2 (F2-layer critical frequency), foF1 (F1-layer critical frequency), foE (E-layer critical frequency), in MHz  
2. **Peak Heights**: hmF2 (F2-layer peak height), hmF1 (F1-layer peak height), hmE (E-layer peak height), in km  
3. **Thickness Parameters**: B0 (bottom thickness), B1 (top thickness), in km  
4. **Total Electron Content (TEC)**: Total number of electrons in a vertical column with a unit cross-sectional area, in TECU (1 TECU = 10¹⁶ electrons/m²)  
5. **Sporadic E-Layer Probability (Es_Prob)**: Probability of sporadic E-layer occurrence  
6. **Solar-Geomagnetic Indices**: F10.7 (solar radio flux index), Ap/Kp (geomagnetic activity indices)  

## 3. Technical Implementation

### 3.1 System Architecture

The system uses MATLAB as the main control platform, calling the IRI2020 Fortran executable for calculations, followed by post-processing and visualization of the results. The main workflow includes:

1. Parameter setting and input  
2. Fortran program call and execution  
3. Result file reading and parsing  
4. Data visualization and graphical output  

### 3.2 Core Code Analysis

```matlab
% Parameter settings
lat = 10.0;      % Latitude
lon = 30.0;     % Longitude
year = 2025;    % Year
month = 3;      % Month
day = 1;        % Day
hour = 0;       % Hour
iut = 0;        % Time type (0=local time, 1=UTC)
ndays = 1;      % Number of days to calculate
dt_min = 15;    % Time interval (minutes)

% Fortran program call
exe_path = 'IRI_site_switch.exe';
cmd = sprintf('%s %f %f %d %d %d %d %d %d %d %d %d', ...
    exe_path, lat, lon, year, month, day, hour, minute, second, iut, ndays, dt_min);
[status, result] = system(cmd);

% Data reading and processing
fid = fopen(output_file, 'r');
data = textscan(fid, '%d %d %d %d %d %d %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f', ...
    'CommentStyle', '%', 'HeaderLines', 4);
fclose(fid);
```

### 3.3 Visualization Implementation

The code implements four sets of subplots for visualization:

1. **Solar-Geomagnetic Indices**: Shows temporal variations of F10.7, Ap, and Kp indices  
2. **Critical Frequencies**: Shows temporal variations of foF2, foF1, and foE  
3. **Height/Thickness Parameters**: Shows hmF2, hmF1, hmE heights and B0, B1 thickness parameters  
4. **TEC and Es Probability**: Shows total electron content and sporadic E-layer probability  

```matlab
% Example visualization code (critical frequencies subplot)
subplot(4,1,2);
plot(time_datenum, foF2, 'r-', 'LineWidth', 2); hold on;
plot(time_datenum, foF1, 'b-', 'LineWidth', 2);
plot(time_datenum, foE, 'k-', 'LineWidth', 2);
ylabel('Frequency (MHz)');
legend('foF2', 'foF1', 'foE', 'Location', 'best');
grid on;
```
![Markdown Logo](https://github.com/ohm1122/IRI2020_parameters/blob/main/Ionosphere_Plot_20240701T0000.png "Markdown Logo")

![Markdown Logo](https://github.com/ohm1122/IRI2020_parameters/blob/main/Ionosphere_Plot_20240510T0000.png "Markdown Logo")
## 4. Applications and Results

### 4.1 Typical Output Results

Running this code generates a comprehensive chart containing four sets of subplots, displaying variations in ionospheric parameters for a specified geographic location (latitude 10°, longitude 30°) and time (March 1, 2025). The chart is saved as a PNG file with a filename containing the date and time information.

### 4.2 Application Scenarios

1. **Radio Communication Planning**: Predicting high-frequency communication link quality through critical frequencies and MUF (Maximum Usable Frequency)  
2. **Satellite Navigation Error Correction**: Improving ionospheric delay corrections for GNSS systems using TEC data  
3. **Space Weather Monitoring**: Monitoring the effects of space weather events through solar-geomagnetic indices and ionospheric parameters  
4. **Scientific Research**: Studying ionospheric dynamics and their correlation with solar and geomagnetic activities  

## 5. Technical Advantages and Extensions

### 5.1 Main Advantages

1. **Automated Workflow**: Fully automated from parameter setting to result visualization  
2. **Efficient Computation**: Uses Fortran programs for high-performance computing and MATLAB for convenient data processing and visualization  
3. **Flexible Parameter Configuration**: Easy modification of geographic location, time range, and calculation parameters  
4. **Intuitive Visualization**: Comprehensive display of multiple parameters for analyzing correlations between them  

### 5.2 Extension Directions

1. **Batch Processing**: Extend to batch calculations for multiple locations and time periods  
2. **3D Visualization**: Add electron density profile displays along the altitude dimension  
3. **Real-Time Data Assimilation**: Improve model predictions by incorporating real-time observation data  
4. **Machine Learning Interface**: Use IRI outputs as input features for machine learning models  

## 6. Conclusion

The MATLAB and IRI2020 Fortran-based ionospheric parameter calculation and visualization system introduced in this article provides an efficient and convenient method for analyzing ionospheric characteristics. The system is suitable not only for scientific research but also for providing important reference data for engineering applications such as radio communications and satellite navigation. With further functional extensions and performance optimizations, this system has the potential to become a powerful tool for ionospheric research and application development.
