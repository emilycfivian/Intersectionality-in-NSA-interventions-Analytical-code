*--------------------------------------------------------------------*
* INTERSECTIONALITY INVESTIGATION OF INEQUITIES IN NSA INTERVENTIONS
*--------------------------------------------------------------------*
* AUTHOR: 				Emily C Fivian
* OBJECTIVE: 			Variable generation
* LAST MODIFIED: 		24/08/2024
*--------------------------------------------------------------------*

drop if time==0 // REMOVE BASELINE
rename mother_dds_5plus_groups mother_dds_bin

*--------------------------------------------------------------------*
// GENERATE SINGLE SOCIAL GROUP COMPARISON VARIABLES
*--------------------------------------------------------------------*

// SCHEDULED TRIBE (ST) VERSUS NON-ST

gen caste_bin=1 if caste==2 
replace caste_bin=0 if  caste==3 | caste==4  | caste==1
label def ST 1 "ST" 0 "non-ST"
lab val caste_bin ST
lab var caste_bin "ST/non-ST: binary indicator"

// WEALTH SCORE

gen improved_water=0 if watersource_hh!=.
recode improved_water 0=1 if watersource_hh==1 | watersource_hh==2 | watersource_hh==3 | ///
watersource_hh==4 | watersource_hh==5 | watersource_hh==7 | watersource_hh==9 | watersource_hh==10 // INCLUDE BOTTLE WATER IN 'IMPROVED CATEGORY' AS LIKELY A SIGN OF WEALTH
lab var improved_water "Improved water source MDG critera - WHO/UNICEF (2016)" 
pca dummy_nonag_land dummy_land improved_toilet fuel2 wall2 roof2 floor2 improved_water weai_asset_livestockl weai_asset_livestocks weai_asset_mechanised weai_asset_nonmechanised weai_asset_business weai_asset_highcost weai_asset_jewellery weai_asset_phone 
predict wealth_pca
xtile wealth_bin = wealth_pca, nq(2)
recode wealth_bin 2=0
lab def wealth_bin 0 "High wealth" 1 "Low wealth"
lab val wealth_bin wealth
lab var wealth_bin "Wealth: binary indicator"

// EDUCATION

gen ed=1 if mother_edulevel<5 // LESS THAN LOWER PIMRARY SCHOOL IN INDIA
replace ed=0 if mother_edulevel>=5 & mother_edulevel!=. 
lab def ed 0 ">=5 years schooling" 1 "<5 years schooling"
lab val ed ed
lab var ed "Education: binary indicator"

*--------------------------------------------------------------------*
// GEN BINARY INTERSECTIONAL GROUP COMPARISONS (ST/NON-ST BY EDUCATION)
*--------------------------------------------------------------------*

gen a =1 if caste_bin==1 & ed==0
gen b =1 if caste_bin==0 & ed==1
gen c =1 if caste_bin==0 & ed==0

foreach var in a b c  {
	replace `var' =0 if caste_bin==1 & ed==1
	}

gen d = 0 if caste_bin==1 & ed==0
gen e = 0 if caste_bin==0 & ed==1
gen f = 0 if caste_bin==0 & ed==1
replace f = 1 if caste_bin==1 & ed==0

foreach var in d e {
	replace `var'=1 if caste_bin==0 & ed==0
	}

lab var a "ST high ed v ST low ed"
lab var b " Non-ST low ed v ST low ed"
lab var c "Non-ST high ed v ST low ed"
lab var d "Non-ST high ed v ST high ed"
lab var e "Non-ST high ed v non-ST low ed"
lab var f "ST high ed vs non-ST low ed"

*--------------------------------------------------------------------*
// GEN BINARY INTERSECTIONAL GROUP COMPARISON (ST/NON-ST BY WEALTH)
*--------------------------------------------------------------------*

gen one =1 if caste_bin==1 & wealth_bin==0
gen two =1 if caste_bin==0 & wealth_bin==1
gen three =1 if caste_bin==0 & wealth_bin==0

foreach var in one two three  {
	replace `var' =0 if caste_bin==1 & wealth_bin==1
	}

gen four = 0 if caste_bin==1 & wealth_bin==0
gen five = 0 if caste_bin==0 & wealth_bin==1
gen six = 0 if caste_bin==0 & wealth_bin==1
replace six = 1 if caste_bin==1 & wealth_bin==0

foreach var in four five {
	replace `var'=1 if caste_bin==0 & wealth_bin==0
	}

lab var one "ST high wealth v ST low wealth"
lab var two " Non-ST low wealth v ST low wealth"
lab var three "Non-ST high wealth v ST low wealth"
lab var four "Non-ST high wealth v ST high wealth"
lab var five "Non-ST high wealth v non-ST low wealth"
lab var six "ST high wealth v non-ST low wealth"

*--------------------------------------------------------------------*
// GENERATE CATEGORICAL INTERSECTIONAL GROUP VARIABLES
*--------------------------------------------------------------------*

gen caste_ed = 3 if caste_bin==0 & ed==0
replace caste_ed = 2 if caste_bin==1 & ed==0
replace caste_ed =1 if caste_bin==0 & ed==1
replace caste_ed =0 if caste_bin==1 & ed==1
lab def caste_ed 0 "ST low ed" 1 "Non-ST low ed" 2 "ST high ed" 3 "Non-ST high ed"
lab val caste_ed caste_ed
lab var caste_ed "ST/Non-ST by education: categorical indicator"

gen caste_wealth = 3 if caste_bin==0 & wealth_bin==0
replace caste_wealth = 2 if caste_bin==1 & wealth_bin==0
replace caste_wealth =1 if caste_bin==0 & wealth_bin==1
replace caste_wealth =0 if caste_bin==1 & wealth_bin==1
lab def caste_wealth 0 " ST low wealth" 1 "Non-ST low wealth" 2 "ST high wealth" 3 "Non-ST high wealth"
lab var caste_wealth "ST/non-ST by wealth: categoricial indicator"

*--------------------------------------------------------------------*
// GENERATE MEDIATOR VARIALBLE: UPAVAN INTERVENTION PARTICIPATION
*--------------------------------------------------------------------*

bysort arm: tab exposure_vidag_any 
forval var = 1(1)17 {
	replace video`var'_view =0 if video`var'_view ==98
	}

foreach var of varlist pla_meeting2_present pla_meeting5_present pla_meeting6_present{
	replace `var'=0 if `var'==98
	}

foreach var of varlist pla_meeting2_present pla_meeting5_present pla_meeting6_present{
	replace `var'=0 if `var'==.
	}

// GENERATE NEW VARIABLE FOR TOTAL AMOUNT OF VIDEOS SEEN
egen total_videos = rowtotal(video1_view video2_view video3_view video4_view video5_view video6_view ///
video7_view video8_view video9_view video10_view video11_view video12_view video13_view video14_view ///
video15_view video16_view video17_view pla_meeting2_present pla_meeting5_present pla_meeting6_present)

sum total_videos

// SOME PEOPLE CLAIMING TO HAVE SEEN MORE THAN 11 VIDEOS. CAP AT 11 FOR CONTROL, ARM 1 AND ARM 2. CAPT AT 8 FOR ARM 3. 
foreach x in 0 1 2  {
	replace total_videos=11 if total_videos>11 & arm==`x'
	}
replace total_videos=8 if total_videos>8 & arm==3


// % OF RESPONDENTS ATTEND A PLA MEETING
replace exposure_pla_any=0 if exposure_pla_any==98 // cleaning
bysort arm: tab exposure_pla_any 

// PLA MEETINGS TOTAL (EXCLUDING VIDEOS)
foreach var of varlist pla_meeting1_present  pla_meeting3_present  pla_meeting4_present { // cleaning
	replace `var'=0 if `var'==98
	}
foreach var of varlist pla_meeting1_present pla_meeting3_present pla_meeting4_present {
	replace `var'=0 if `var'==.
	}
gen pla_total = pla_meeting1_present + pla_meeting3_present + pla_meeting4_present

gen expo_all =1 if arm==3 & ((pla_total>0 & pla_total!=.) | (total_videos>0 & total_videos!=.)) // AGRI-NUT+PLA
replace expo_all =1 if (arm==1 | arm==2) & (total_videos>0 & total_videos!=.) // AGRI & AGRI-NUT
recode expo_all .=0

// SHG MEMBER
gen active_shg =1 if weai_groups_g_member==1 
replace active_shg =0 if active_shg==.

// SHG MEMBER & PARTICIPATED IN THE INTERVENTION AT LEAST ONCE IN PAST 6 MONTHS
gen p = 1 if expo_all==1 & active_shg==1 
recode p .=0 
lab def p 0 "Non-participant" 1 "Participant"
lab val p p
lab var p "NSA participation in past 6 months & SHG member: binary indicator"

*--------------------------------------------------------------------*
// DIETARY INEQUALITIES IN UPAVAN CONTROL ARM
*--------------------------------------------------------------------*

preserve
keep if arm==0

log using "outputs\Control_arm_ERR"

foreach var in wealth_bin ed caste_bin  {
	
	glm mother_dds_bin ib1.`var', fam(bin) link(log) nolog eform
}


foreach var in a b c d e f {
	
	display "`:variable label `var''"
	glm mother_dds_bin i.`var', fam(bin) link(log) nolog eform
}

foreach var in one two three four five six  {
	
	display "`:variable label `var''"
	glm mother_dds_bin i.`var', fam(bin) link(log) nolog eform
}
log close
restore

*--------------------------------------------------------------------*
// MERGE INTERVENTION ARMS AND CREATE OTHER VARIABLES NEEDED
*--------------------------------------------------------------------*

drop if arm==0
replace arm =12 if arm==1 | arm==2
lab def arm1 12 "AGRI & AGRI-NUT" 3 "AGRI-NUT+PLA"
lab val arm arm1
lab var arm "Intervention group"

gen land_size_bin =0 if land_size<2.5
replace land_size_bin=1 if land_size>=2.5 & land_size!=.
lab def land_size_bin 0 "<2.5 acres of land" 1 ">=2.5 acres of land"
lab val land_size_bin land_size_bin


save "data\Analysis_dataset", replace



