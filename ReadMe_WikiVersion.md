*Note: the wiki includes a Page Template Wizard for the basin meta data*

# Baker Creek Watershed

## General information

Basin/Domain name: Baker Creek Watershed
Location: near Yellowknife, NWT
Steward: Haley Brauner
Last updated: August, 2019

## Basin Overview
The Baker Creek watershed is located in the Northwest Territories (NWT) of Canada, with the outlet defined by the Water Survey of Canada (WSC) hydrometric gauging station 07SB013 - Baker Creek at Outlet of Lower Martin Lake - located approximately 7 km north of the capital city of Yellowknife, NWT. The Baker Creek watershed is a sub-basin of the Great Slave Lake watershed and has a gross drainage area of approximately 155 km^2 (Spence et al., 2010). The basin is characterized by a number of large lakes drained by short streams with a highly variable flow regime due to the variability of storage capacity in the basin (Spence, 2006; Phillips, Spence, & Pomeroy, 2011). The basin is in an area of discontinuous permafrost, which also alters the runoff regime depending on the soil conditions (Kokelj, 2003; Guan, Spence, & Westbrook, 2010). The average streamflow at the basin outlet is 0.24 m^3 s^-1 and annual runoff ratio is 0.17; however, the runoff ratio has been observed to vary by up to three orders of magnitude, as observed by a runoff ratio of 0.005 in 2015 and 0.34 in 2001 (Spence & Hedstrom, 2018; Spence & Woo, 2002).

The Baker Creek watershed is largely undeveloped, and there are a number of research stations in the basin (Spence and Hedstrom, 2018). Research by the University of Saskatchewan and Carleton University has been occurring in the basin since 2004, with some water quality data available from 1995 (Changing Cold Regions Network (CCRN), 2019; Spence and Hedstrom, 2018). The basin is comprised of primarily exposed bedrock (39.9%) and water bodies (22.6%), with coniferous forest hillslopes and some deciduous forest comprising just over 21%, and peatlands and wetlands making up the remaining 16% (Spence and Hedstrom, 2018). The bedrock is moderately to highly fractured, and mineral soils (silty and sandy texture) are present in the fissures and valley from bedrock weathering and erosion (Phillips, Spence, & Pomeroy, 2011). Overburden thickness ranges from 1 m to more than 10 m (Spence & Hedstrom, 2018), and peat thickness ranges from a thin layer to about 1.2 m (Guan, Westbrook, & Spence, 2010). The area experiences a subarctic climate with short, cool summers and long, cold winters. The basin receives an average of 289 mm of precipitation annually, approximately 41% as snowfall (Environment and Climate Change Canada, 2019a).

***Add basin drainage and landcover figures here, or refer to the report (Brauner, 2019)***


## Hydrological Structures

### Outlet locations
Add outlets and/or hydrometric stations to the table. Include coordinates, an ID if available, if the station is active, if it contains streamflow and/or level data, length of record, if those data are suitable for calibration, etc.

| Name (ID) | Coordinates | Status | Record Length | Notes |
| -------- | ----------- | :----: | :-----------: | ----- |
|Baker Creek at the Outlet of Lower Martin Lake (07SB013) | 62.51356, -114.4098 | Active | 1983-2016 | WSC gauge |

### Reservoirs or large water bodies
There are no flow control structures in the basin, but there are a number of large lakes that have a significant influence on the flow regime. The largest and most hydrologically-significant of these lakes include Duckfish Lake (6.2 km2), Vital Lake (1.5 km2), Landing Lake (1.1 km2), and Martin Lake (3 km2) (Spence, 2006)

### Meteorological stations
The nearest long-term meteorological station is located at the Yellowknife Airport, approximately 7 km southeast of the basin outlet, with hourly data available from 1953 through 2019 (Environment and Climate Change Canada, 2019b). There are also two climate research towers located in the basin: Vital Tower and Landing Lake Tower (Spence and Hedstrom, 2018) with data available between 2005-2016.

## Available data
List all sources of information (whether or not they were used in the project), how they can be acquired and/or downloaded, if they've already been copied to a shared location, publication date, publication reference, and other information for such products as climate data, DEMs, land cover data, soils data, etc., in list or table format. If multiple sources exist, separate the data into sections, such as 'Climate Data', 'DEM', 'Land Cover', 'Soils', 'Measured Data', etc.

**Climate Data:**
- Vital Tower, located within the basin on exposed bedrock (Spence & Hedstrom, 2018)
    - Half-hourly rainfall, air temperature (2 heights), incoming shortwave and longwave radiation, wind speed (2 heights, air pressure, and relative humidity (2 heights))
    - 2005-2016 (except winter)
    - Location: 62.6042, -114.4475
    - Primary data source used in composite driving dataset
- Landing Lake tower, located within the basin over water (Landing Lake) (Spence & Hedstrom, 2018)
    - Half-hourly air temperature, incoming shortwave and longwave radiation, wind speed, and vapour pressure
    - 2008-2016 (except winter)
    - Location: 62.5593, -114.4117
    - Not used in the project driving dataset since sparser than Vital Tower data
- Environment and Climate Change Canada, Yellowknife A station (Environment and Climate Change Canada, 2019b)
    - Hourly air temperature, wind speed, air pressure, and RH (1953-present)
    - Daily precipitation (rainfall and snowfall), air temperature (min, max, average) (1942-present)
    - Location: 62.46, -114.44
    - Used in the composite driving datasets to gap-fill after the on-site tower data
- Environment and Climate Change Canada's Regional Deterministic Prediction System (RDPS), which is based on the GEM-NWP model (Mailhot et al., 2006).
    - Hourly air temperature, incoming shortwave and longwave radiation, wind speed, air pressure, and specific humidity
    - Location: the model grid containing the Vital Tower
    - 2004 onward used in the project (longer may be available)
    - Used to gap-fill where observed data is missing
- Precipitation data from the Canadian Precipitation Analysis (CaPA) dataset (Fortin et al., 2018)
    - 6-hourly precipitation data
    - Location: the model grid containing the Vital Tower
    - 2002 onward obtained for the project (longer may be available)
    - Used to gap-fill where observed data is missing

**Streamflow**
- WSC gauge 07SB013 Baker Creek at the outlet of Lower Martin Lake (basin outlet) (Water Survey of Canada, 2019)
    - Data available from 1983-2016 online at the time of the project
    - Used in the model for calibration
- Data from five hydrometric gauges within the basin is available in Spence & Hedstrom (2018) for varying durations between 2003-2016.
    - Not used in the project since correlating the model to within-basin streamflow was beyond the scope of the project.

**Spatial Data**
- DEM and landcover available in Spence & Hedstrom, 2018, were used for the project

**Soil Moisture and Temperature**
- Data from six ground temperature and/or soil moisture stations within the basin is available in Spence & Hedstrom, 2018
    - Soil moisture and temperature measurements were used to initialize the model

**Snow Course**
- Spring snow survey data from 2003-2016 (except 2006) is available in Spence & Hedstrom, 2018
    - Snow survey data was not used in the project; further assessment to compare the model results to the snow surveys could be completed

### Driving Data Preparation Methodology
- R was used to process the driving data
- General methodology:
  - Load and plot the data, comparing data from different sources
  - Adjust / filter out extraneous data
  - Convert units from source data to those required by MESH
  - Shift the timezone of the GEM and CaPA datasets from UTC to UTC-7
  - Interpolate data (from source timestep to half-hourly)
  - Shift the data from measurement height to 40 m height
  - Stitch data into one continuous set for the model duration; dataset priority:
    - Vital Tower
    - Yellowknife A
    - GEM/CaPA
- See the project report for more information (Brauner, 2019)

## Model Configurations

***Add in the configuration table from the report here***

- All configurations:
  - Soil layers: 4
  - LSS: CLASS
  - Uniform driving data over whole basin
  - Reservoirs: 0
  - Frozen soil infiltration: CLASS algorithm
  - SOILINIFLAG: 1 (soil percentage values read from CLASS.ini file, even if >100%)
  - Simulation start time: 2006-258-0-0
  - Simulation end time: 2016-258-0-0

- Calibration setup (all configurations):
  - Calibration program: Dynamically-Dimensioned Search (DDS)
  - Objective function algorithm: GCOP
  - Objective function: Nash-Sutcliffe Efficiency
  - Number of iterations: 1000
  - Number of trials (i.e. each with different seed number): 100


## References
### Project Report
***Add reference / link to project report here***

### Literature and Data Sources
Changing Cold Regions Network. (2019, August 13). 14. Baker Creek, NWT. Retrieved from http://ccrnetwork.ca/science/WECC/sub-arctic-lowlands/baker-creek.php

Environment and Climate Change Canada. (2019a, May). Historical Data. Retrieved from Government of Canada: http://climate.weather.gc.ca/historical_data/search_historic_data_e.html

Environment and Climate Change Canada. (2019b, August 13). Yellowknife A, Climate ID 2204100. Retrieved from Canadian Climate Normals 1981-2010 Station Data: http://climate.weather.gc.ca/climate_normals/index_e.html

Fortin, V., Roy, G., Stadnyk, T., Koenig, K., Gasset, N., & Mahidjiba, A. (2018). Ten Years of Science Based on the Canadian Precipitation Analysis: A CaPA System Overview and Literature Review†. Atmosphere - Ocean, 56(3), 178–196. https://doi.org/10.1080/07055900.2018.1474728

Guan, X. J., Spence, C., & Westbrook, C. J. (2010). Shallow soil moisture - Ground thaw interactions and controls - Part 2: Influences of water and energy fluxes. Hydrology and Earth System Sciences, 14(7), 1387–1400. https://doi.org/10.5194/hess-14-1387-2010

Guan, X. J., Westbrook, C. J., & Spence, C. (2010). Shallow soil moisture - Ground thaw interactions and controls - Part 1: Spatiotemporal patterns and correlations over a subarctic landscape. Hydrology and Earth System Sciences, 14(7), 1375–1386. https://doi.org/10.5194/hess-14-1375-2010

Kokelj, S. A. (2003). Hydrologic overview of the North and South Slave regions. Yellowknife, NWT, Canada.

Mailhot, J., Bélair, S., Lefaivre, L., Bilodeau, B., Desgagné, M., Girard, C., … Qaddouri, A. (2006). The 15-km version of the Canadian regional forecast system. Atmosphere - Ocean, 44(2), 133–149. https://doi.org/10.3137/ao.440202

Phillips, R. W., Spence, C., & Pomeroy, J. W. (2011). Connectivity and runoff dynamics in heterogeneous basins. Hydrological Processes, 25(19), 3061–3075. https://doi.org/10.1002/hyp.8123

Spence, C., & Woo, M. K. (2002). Hydrology of subarctic Canadian shield: Bedrock upland. Journal of Hydrology, 262(1–4), 111–127. https://doi.org/10.1016/S0022-1694(02)00010-0

Spence, C. (2006). Hydrological processes and streamflow in a lake dominated watercourse. Hydrological Processes, 20, 3665–3681. https://doi.org/10.1002/hyp

Spence, C., Guan, X. J., Phillips, R., Hedstrom, N., Granger, R., & Reid, B. (2010). Storage dynamics and streamflow in a catchment with a variable contributing area. Hydrological Processes, 24(16), 2209–2221. https://doi.org/10.1002/hyp.7492

Spence, C., & Hedstrom, N. (2018). Hydrometeorological data from Baker Creek Research Watershed, Northwest Territories, Canada. Earth System Science Data, 10(4), 1753–1767. https://doi.org/10.5194/essd-10-1753-2018

Water Survey of Canada. (2019, May 13). Historical Hydrometric Data Search. Retrieved from Government of Canada: https://wateroffice.ec.gc.ca/search/historical_e.html
