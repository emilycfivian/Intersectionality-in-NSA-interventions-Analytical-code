*--------------------------------------------------------------------*
* INTERSECTIONALITY INVESTIGATION OF INEQUITIES IN NSA INTERVENTIONS
*--------------------------------------------------------------------*
* AUTHOR: 				Emily C Fivian
* OBJECTIVE: 			MASTER DO FILE FOR VARIABLE GENERATION & ANALYSIS
* LAST MODIFIED: 		24/08/2024
*--------------------------------------------------------------------*
// SET UP PROJECT
*--------------------------------------------------------------------*

clear all
set maxvar 10000
cd " " // FOLDER WITH MASTER DO FILES AND DO, DATA, OUTPUT SUB-FOLDERS.
use "data\UPAVAN_mother_anthro_indicators.dta" // DATA AVAILABLE FROM: https://doi.org/10.17037/DATA.00003642.

*--------------------------------------------------------------------*
// RUN ALL DO FILES
*--------------------------------------------------------------------*

do "do\UPAVAN_Intersectionality_VariableGeneration" // VARIABLE GENERATION
do "do\UPAVAN_Intersectionality_Descriptives" // DESCRIPTIVEs (TABLES 2 AND 3)
do "do\UPAVAN_Intersectionality_Decomposition_Analysis" // DECOMPISITION OF DIETARY INEQUALITIS BY NSA INTERVENTION PARTICIPATION (TABLE 4, 5 AND APPENDIX FIGURES)






