*--------------------------------------------------------------------*
* INTERSECTIONALITY INVESTIGATION OF INEQUITIES IN NSA INTERVENTIONS
*--------------------------------------------------------------------*
* AUTHOR: 				Emily C Fivian
* OBJECTIVE: 			DESCRIPTIVE TABLES 1 & 2 
* LAST MODIFIED: 		24/08/2024

log using "outputs\Table 2 and 3", replace

*--------------------------------------------------------------------*
// TABLE 2: PARTICIPANTS CHARACTERISTICS
*--------------------------------------------------------------------*

count if arm==12
count if arm==3

foreach var in land_size_bin caste_bin ed wealth_bin caste_ed caste_wealth p mother_dds_bin {
	
	tab `var' if arm==12
	tab `var' if arm==3
	}

foreach a in 12 3 { 
	tab caste if caste_bin==0 & arm==`a'
	}

foreach var in mother_edulevel { // MOTHER AGE NOT IN USING DATA TO PROTECT RESPONDENT ANONYMITY
	tabstat `var' if arm==12, st(mean sd) 
	tabstat `var' if arm==3, st(mean sd) 	
	}

*--------------------------------------------------------------------*
// TABLE 3: PARTICIATION RATES AND % ACHIEVING MIN DDS BY PARTICIPATION
*--------------------------------------------------------------------*	
	
// PARTICIPATION RATES BY ARM

foreach var in caste_bin ed wealth_bin caste_ed caste_wealth {
	
	tab p `var' if arm==12, col // AGRI & AGRI-NUT
	tab p `var' if arm==3, col // AGRI-NUT+PLA
	}

// % ACHIEVING MIN DDS BY PARTICIPATION

foreach var in caste_bin ed wealth_bin caste_ed caste_wealth {
	
	tab mother_dds_bin `var' if arm==12 & p==0, col // NON-PARTICIPANTS IN AGRI & AGR-NUT
	tab mother_dds_bin `var' if arm==12 & p==1, col // PARTICIPANTS IN AGRI & AGRI-NUT
	tab mother_dds_bin `var' if arm==3 & p==0, col // NON-PARTICIPANTS IN AGRI-NUT+PLA
	tab mother_dds_bin `var' if arm==3 & p==1, col // PARTICIPANTS IN AGRI-NUT+PLA
	}
	
log close
