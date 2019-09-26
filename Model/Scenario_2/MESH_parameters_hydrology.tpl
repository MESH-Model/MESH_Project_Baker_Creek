1.1.a04:MESH Hydrology Parameters input file
##### Option Flags #####
----#
    0 # Number of option flags
##### River roughness factor (WF-R2) (5 classes maximum) ##
-----#-----#-----#-----#-----#
 _WF-R2_ 0.050 0.050 0.050 0.050
##### GRU class independent hydrologic parameters #####
-------#
       0 # Number of GRU independent hydrologic parameters
##### GRU class dependent hydrologic parameters #####
-------#
       6 #Number of GRUs (must match number in mesh_parameters_class.ini file)
       3 #Number of GRU dependent hydrologic parameters
---------#---------#---------#---------#---------#---------#---------#---------#-----
_ZSNL_      _ZSNL_      _ZSNL_      _ZSNL_      _ZSNL_      _ZSNL_      # ZSNL
_ZPLS_      _ZPLS_      _ZPLS_      _ZPLS_      _ZPLS_      _ZPLS_      # ZPLS
_ZPLG-NL_   _ZPLG-BL_   _ZPLG-WL_   _ZPLG-PL_   _ZPLG-W_   _ZPLG-BR_    # ZPLG
