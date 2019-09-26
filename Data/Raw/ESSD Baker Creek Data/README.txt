This README.txt file was generated on <20180326> by <Christopher Spence, Environment and Climate Change Canada>

---------------------------------------------
FOLDER/FILE ORGANIZATION & NAMING CONVENTION
---------------------------------------------

1. Folder/File List
   A. Filename: StreamflowData.zip 
        i.  Filename: Baker streamflow v1.csv      
            Short description: Daily streamflow from five hydrometric gauges in the Baker Creek Research Watershed from 2003-2016.   
			 
   B. Filename: HydrometeorologicalData.zip
        i.  Filename: landing tower half hourly time series v1.csv      
            Short description: Half hourly meteorological and energy flux conditions at Landing Lake in the Baker Creek Research Watershed 2008-2016

        ii. Filename: vital tower half hourly time series v1.csv      
            Short description: Half hourly meteorological and energy flux conditions at a bedrock ridge in the Baker Creek Research Watershed 2005-2016
			
   C. Filename: SoilMoistureData.zip
        i.  Filename: soil moisture time series v1.csv      
            Short description: Half hourly near surface soil moisture time series from five hillslopes in the Baker Creek Research Watershed from 2003-2007

   D. Filename: GroundTemperatureData.zip   
        i.  Filename: exposed rock temperature time series v1.csv       
            Short description: Daily ground temperatures from a thermistor string drilled in a borehole in an exposed bedrock face in the Baker Creek Research Watershed from 2007-2016       

        ii. Filename: soil temperature time series v1.csv      
            Short description: Half hourly near surface soil temperature time series from five hillslopes in the Baker Creek Research Watershed from 2003-2007

   E. Filename: SnowData.zip
        i.  Filename: spring snow survey time series v1.csv      
            Short description: Annual spring maximum snowpack measured at snow courses across the Baker Creek Research Watershed 2004 - 2017.

   F. Filename: SpatialData.zip
        i.  Folder: spot land cover
            Short description: SPOT 5 derived land cover data at 10 m resolution in shapefile format with associated files.  

        ii. Folder: baker_10m_dem      
            Short description: ArcGrid file format folder containing LiDAR derived elevation data at 10 m resolution

--------------------------
METHODOLOGICAL INFORMATION
--------------------------

1. Description of methods used for collection/generation of data:
Methods are described in Spence et al. (2010) and Spence and Hedstrom (2018).

Spence, C., Guan, X.J., Phillips, R., Hedstrom, N., Granger, R., and Reid, B. (2010) Storage dynamics and streamflow in a catchment with a variable contributing area. Hydrological Processes 24: 2209–2221. https://doi.org/10.1002/hyp.7492 
Spence, C., and Hedstrom, N. (2018) Hydrometeorological Data from The Baker Creek Research Watershed, Northwest Territories, Canada. Manuscript in preparation.

2. Methods for processing the data: All time series data were imported into Excel to be collated, averaged to daily values when required, and QA/QC'd. 

3. Instrument- or software-specific information needed to interpret the data: Not applicable.

4. Standards and calibration information, if appropriate:  Streamflow data were collected and analyzed following Water Survey of Canada standards as close as possible.

5. Environmental/experimental conditions: Cold season conditions often compromised collection of streamflow and hydrometeorological data, and where this was considered problematic, data were removed.  

6. Describe any quality-assurance procedures performed on the data: These are summarized in the Spence et al. (2010) and Spence and Hedstrom (2018) papers noted above. 

-----------------------------------------
DATA-SPECIFIC INFORMATION FOR: Baker streamflow v1.csv
-----------------------------------------

1. Number of variables: 5

2. Measurement Information (Start and End Dates): April 30, 2003 to December 31, 2016

3. Missing data codes:
        Blank        Missing data

4. Variable List

    A. Name: Baker Creek at outlet of Landing Lake
       Description: Streamflow [m3/s]
                  
    B. Name: Baker Creek at Vital Narrows
       Description: Streamflow [m3/s]

    C. Name: Baker Creek above Vital Lake
       Description: Streamflow [m3/s]
                  
    D. Name: Moss Creek at outlet of Lake 690
       Description: Streamflow [m3/s]
                      
    E. Name: Baker Creek at outlet of Duckfish Lake
       Description: Streamflow [m3/s]

-----------------------------------------
DATA-SPECIFIC INFORMATION FOR: exposed rock temperature time series v1.csv
-----------------------------------------

1. Number of variables: 5

2. Measurement Information (Start and End Dates): April 22, 2007 to December 31, 2016

3. Missing data codes:
        9999        Missing data

4. Variable List

    A. Name: surface
       Description: temperature at ground surface [°C]
                  
    B. Name: 10 cm
       Description: temperature at 10 cm depth [°C]

    C. Name: 20 cm
       Description: temperature at 20 cm depth [°C]
                  
    D. Name: 30 cm
       Description: temperature at 30 cm depth [°C]
                      
    E. Name: 46 cm
       Description: temperature at 46 cm depth [°C]

-----------------------------------------
DATA-SPECIFIC INFORMATION FOR: landing tower half hourly time series v1.csv
-----------------------------------------

1. Number of variables: 10

2. Measurement Information (Start and End Dates): January 1, 2008 to December 31, 2016

3. Missing data codes:
        9999        Missing data

4. Variable List

    A. Name: wnd_spd_a (m/s)
       Description: horizontal wind speed at 1.1 m [m/s]
                  
    B. Name: compass_dir (°)
       Description: wind direction [°]

    C. Name: HMPTmploa (°C)
       Description: air temperature at 1.4 m [°C]
                  
    D. Name: HMP_e_loa (kPa)
       Description: vapour pressure at 1.4 m [kPa]
                      
    E. Name: Rn (W/m2)
       Description: net radiation [W/m2]

    F. Name: LI200Kin (W/m2)
       Description: incoming short wave radiation [W/m2]
                  
    G. Name: LI200Kout (W/m2)
       Description: outgoing short wave radiation [W/m2]

    H. Name: ApogeeTwater (°C)
       Description: surface water temperature [°C]
                  
    I. Name: latent heat (W/m2)
       Description: latent heat flux [W/m2]
                      
    J. Name: sensible heat (W/m2)
       Description: sensible heat flux [W/m2]

-----------------------------------------
DATA-SPECIFIC INFORMATION FOR: soil moisture time series v1.csv
-----------------------------------------

1. Number of variables: 10

2. Measurement Information (Start and End Dates): April 17, 2007 to December 31, 2016

3. Missing data codes:
        9999        Missing data

4. Variable List

    A. Name: wb surface
       Description: soil moisture at ground surface in Wetboot Peatland [%]
                  
    B. Name: wb 25 cm
       Description: soil moisture at 25 cm depth in Wetboot Peatland [%]

    C. Name: av surface
       Description: soil moisture at ground surface in wetland above Vital Lake [%]
                  
    D. Name: av 25 cm
       Description: soil moisture at 25 cm depth in wetland above Vital Lake [%]

    E. Name: lp surface
       Description: soil moisture at ground surface in hillslope at Landing Lake Portage [%]
                  
    F. Name: lp 25 cm
       Description: soil moisture at 25 cm depth in hillslope at Landing Lake Portage [%]

    G. Name: tp surface
       Description: soil moisture at ground surface in Tower Peatland [%]
                  
    H. Name: tp 25 cm
       Description: soil moisture at 25 cm depth in Tower Peatland [%]

    I. Name: cv surface
       Description: soil moisture at ground surface in hillslope in valley near Vital lake camp [%]
                  
    J. Name: cv 25 cm
       Description: soil moisture at 25 cm depth in hillslope in valley near Vital lake camp [%]

-----------------------------------------
DATA-SPECIFIC INFORMATION FOR: soil temperature time series v1.csv
-----------------------------------------

1. Number of variables: 10

2. Measurement Information (Start and End Dates): April 17, 2007 to December 31, 2016

3. Missing data codes:
        9999        Missing data

4. Variable List

    A. Name: wb surface
       Description: soil temperature at ground surface in Wetboot Peatland [°C]
                  
    B. Name: wb 25 cm
       Description: soil temperature at 25 cm depth in Wetboot Peatland [°C]

    C. Name: av surface
       Description: soil temperature at ground surface in wetland above Vital Lake [°C]
                  
    D. Name: av 25 cm
       Description: soil temperature at 25 cm depth in wetland above Vital Lake [°C]

    E. Name: lp surface
       Description: soil temperature at ground surface in hillslope at Landing Lake Portage [°C]
                  
    F. Name: lp 25 cm
       Description: soil temperature at 25 cm depth in hillslope at Landing Lake Portage [°C]

    G. Name: tp surface
       Description: soil temperature at ground surface in Tower Peatland [°C]
                  
    H. Name: tp 25 cm
       Description: soil temperature at 25 cm depth in Tower Peatland [°C]

    I. Name: cv surface
       Description: soil temperature at ground surface in hillslope in valley near Vital lake camp [°C]
                  
    J. Name: cv 25 cm
       Description: soil temperature at 25 cm depth in hillslope in valley near Vital lake camp [°C]

-----------------------------------------
DATA-SPECIFIC INFORMATION FOR: spring snow survey time series v1.csv
-----------------------------------------

1. Number of variables: 8

2. Measurement Information (Start and End Dates): 2004 to 2016

3. Missing data codes:
        9999        Missing data

4. Variable List

    A. Name: year
       Description: year of the spring snow survey
                  
    B. Name: trait
       Description: one of three traits of the spring snowpack; density, depth and snow water equivalent

    C. Name: coniferous
       Description: conditions on coniferous forested hillslopes 
                  
    D. Name: deciduous
       Description: conditions on deciduous forested hillslopes

    E. Name: lake
       Description: conditions on lakes
                  
    F. Name: rock
       Description: conditions on exposed bedrock ridges

    G. Name: wetland
       Description: conditions in peatlands and wetlands
                  
    H. Name: basin average
       Description: average basin conditions calculated by pro-rating by land cover fractions

-----------------------------------------
DATA-SPECIFIC INFORMATION FOR: vital tower half hourly time series v1.csv
-----------------------------------------

1. Number of variables: 14

2. Measurement Information (Start and End Dates): April 12, 2005 to December 31, 2016

3. Missing data codes:
        9999        Missing data

4. Variable List

    A. Name: pressure (kPa)
       Description: barometric pressure [kPa]
                  
    B. Name: K down (W m-2)
       Description: incoming short wave radiation [W m-2]

    C. Name: K up (W m-2)
       Description: outgoing  short wave radiation [W m-2]
                  
    D. Name: L down (W m-2)
       Description: incoming long wave radiation [W m-2]

    E. Name: L up (W m-2)
       Description: outgoing long wave radiation [W m-2]
                      
    F. Name: Q* (W m-2)
       Description: net radiation [W m-2]

    G. Name: high air temperature (°C)
       Description: air temperature at 4.4 m [°C]
                  
    H. Name: high RH (%)
       Description: relative humidity at 4.4 m [%]

    I. Name: low air temperature (°C)
       Description: air temperature at 2.8 m [°C]
                  
    J. Name: low RH (%)
       Description: relative humidity at 2.8 m [%]

    K. Name: u (m/s)
       Description: wind speed at 4.4 m [m/s]

    L. Name: rainfall (mm)
       Description: half hourly total rainfall [mm]
                  
    M. Name: Qe (W m-2)
       Description: latent heat flux [W m-2]
                      
    N. Name: Qh (W m-2)
       Description: sensible heat flux [W m-2]    
