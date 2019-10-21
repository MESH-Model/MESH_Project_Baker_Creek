# Representation of Spatial Heterogeneity in the MESH Model - Baker Creek, NWT

## Team
  **Primary modeller:** Haley Brauner
  **MESH training and support:** Dan Princz, ECCC
  **Advisors:** Bruce Davison, ECCC and Andrew Ireson, GIWS

## Date
May-August, 2019

## Purpose
  This project was completed as the Capstone Project for the Masters of Water Security (MWS) program at the University of Saskatchewan in partnership with Environment and Climate Change Canada (ECCC). The project replicated the methodology of a project conducted in the White Gull Creek watershed (SK) in 2017 by a previous MWS student, Herbert Mkandla, and aimed to explore the effects of various representations of sub-grid spatial heterogeneity on model performance. The project also compared the WATROF and PDMROF algorithms.

## Objectives and Main Tasks
1.	In the Baker Creek Watershed (NWT), replicate the methodology used by Mkandla (2017) in the Whitegull Creek Watershed (SK) to evaluate the effect of complexity in the representation of spatial heterogeneity in the MESH model on model performance; and
2.	Take the work further and explore additional model configuration options - including more than one grid in the basin, and using PDMROF instead of WATROF - to explore their effects on model performance.

Scenario 1 considered the basin to contain one GRU - meaning that the entire watershed is assumed to behave hydrologically similar. This GRU contained five landcover types based on the CLASS parameterization (Verseghy, 2012). The land cover types defined in Spence and Hedstrom (2018) were used, with the CLASS landcover type "grass" being used to define wetlands and peatlands, and the "barren land" type being used to define open water and exposed bedrock areas.

In Scenario 2, the basin was divided into 6 GRUs defined by landcover type, with the vegetation, surface, hydrology, and soils parameterized individually for each GRU.

In Scenario 3, the parameterization was the same as for Scenario 2 but the watershed was divided into five grid cells with tiles in each cell representing the a portion of each GRU. This configuration was chosen as it was the next logical step in increasing the complexity of the model configuration.

Scenarios 1-P and 2-P were parameterized the same as Scenarios 1 and 2, respectively, except that parameters for WATROF were replaced with those for PDMROF (Mekonnen et al., 2014; University of Saskatchewan, 2019a). It was hypothesized that due to the large number of lakes, dominance of large lakes, and fill-and-spill nature of the basin, PDMROF may improve the predictive power of the model.


## Basin Meta-data
Meta-data for the basin is included on the MESH Wiki website:

[Basin Meta-data on MESH Wiki Page](https://wiki.usask.ca/display/MESH/Basin+Meta-data) *To be completed*

## Progress / Conclusion
The modelling project for the purpose of the MWS Capstone Project is complete, though more work could be done to the model of the Baker Creek watershed to get better performance results.

In summary:
- The performance in terms of Nash-Sutcliffe Efficiency (NSE) when calibrating to streamflow were very poor
  - The best performance for the calibration periods of Scenarios 1, 2, 3, 1-P, and 2-P were -0.082, 0.027, 0.051, 0.140, and 0.169, respectively.
  - With added complexity between Scenarios 1, 2, and 3, performance improved slightly
  - The configurations using PDFMROF performed better than those using WATROF (all other setting the same)
- The model under-estimated most peak flows during the wet period (2008-2012) and over-estimated peak flows during the dry period (2013 onward)

Some recommendations for future improvements / assessments are:
- Revisit the parameter selection and initial conditions to ensure they are reasonable
- Configure the model using LATFLOW (which combines WATROF and PDMROF) and compare to Scenarios 1/1-P and 2/2-P
- Try calibrating to log-NSE instead of NSE (or a combination of NSE and log-NSE) to place more emphasis on low flows
- Try calibrating the model to the wet period only, since there is little streamflow at the outlet during the dry period
- Calibrate to evapotranspiration instead of streamflow, since it is a much more dominant process in the basin
- Configure GRUs based on hydrological behavior in the watershed (i.e. upland areas vs. receiving areas) instead of by landcover type, since the same landcover in different areas of the basin can respond differently
- Consider adding a reservoir(s) to represent the behavior of the large lakes in the basin
- Perform a sensitivity analysis to hone in on the most sensitive parameters and potentially reduce the number of calibrated parameters. This could allow for more calibration iterations in the same run time.
- Calibrate to spring peaks or fall peaks only to glean information about key parameters for the behavior of the basin during those times.
- Iteratively spin-up the model to initialize the soil moisture and temperature conditions

## References
See the [Basin Meta-data Page](https://wiki.usask.ca/display/MESH/Basin+Meta-data) and the project report for a list of references.
