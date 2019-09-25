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


## Basin Meta-data
*Include a link to the MESH Wiki "Basin Meta-data" page, if created. Otherwise, link to a "Basin_Metadata.md" file in the "Site" folder*

[Basin Meta-data on MESH Wiki Page](https://wiki.usask.ca/display/MESH/Basin+Meta-data) *Not completed*

See here for basin meta-data    
    [Basin Meta-data File](./Site)

## Progress / Conclusion
*Include periodic updates on the modelling progress here, or even just "in progress"*  
*Include the main findings of the modelling, and further recommendations*

## References
- List any scripts, packages, etc. used
- Related research papers and other information (theory, parameter selection, etc.); could include a copy in Model>Justification folder
- Manuals (ex. CLASS, Ostrich, MESH Wiki, other)

___
___
## Folder Structure

### Code
*Includes pre- and post-processing scripts used in the project*

### Data

#### Driving
Raw
- Met data, streamflow, station metadata, soil moisture/temp, etc.
- Subfolder for each type/source

Spatial
- Green Kenue files
- GIS files

Validation
- ex. streamflow

### Model
*Include model notes in this main "Model" folder, as available*

MESH_Code
- Holds the MESH code used for running the mode; use a new folder for each version (include the version as a suffix)
- If any modification of the code were made, or more than one version was used, include a text file listing the MESH code versions, the main differences and reason for use, and details of the modifications

ConfigurationX
*Include 1 folder for each configuration, with input and output sub-folders*

- Input *(Includes the MESH inputs files, driving data, and scripts for the model configuration)*

- Output *(Includes the output files for the model configuration / each run)*

Justification
*Includes files related to scenario configuration choice, parameter selection, initial conditions, etc.*

Superceded
*Include previous versions of certain files only if relevant to the project*

Presentations
*Contains powerpoint (or similar), poster, or other presentations or reports related to the project (formal or otherwise)*

### Site
- Maps
- PhotosVideos
- Reports
- Site Meta-data
