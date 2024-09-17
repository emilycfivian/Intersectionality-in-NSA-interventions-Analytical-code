*--------------------------------------------------------------------*
* INTERSECTIONALITY INVESTIGATION OF INEQUITIES IN NSA INTERVENTIONS
*--------------------------------------------------------------------*
* AUTHOR: 			Emily C Fivian
* OBJECTIVE: 		DECOMPOSING DIET INEQUALITIES BY NSA INTERVENTION PARTICIPATION
* LAST MODIFIED: 	24/08/2024
*--------------------------------------------------------------------*
// TABLE 4 & 5: DIET INEQUALITIES BY SINGLE SOCIAL CHARACTERISTICS
*--------------------------------------------------------------------*

log using "outputs\decomp_single", replace

foreach var in wealth_bin ed caste_bin  {
	
	foreach n in 12 3 {
	
		med4way mother_dds_bin `var' p  if arm==`n' , bootstrap reps(1000) seed(12345678) a0(1) a1(0) m(0) yreg(logbinomial) mreg(logistic)  mregoptions(or) yregoptions(eform) 
		estat bootstrap, all
		}
	}
log close

*--------------------------------------------------------------------*
// TABLE 4: DIET INEQUALITIES BY ST/NON-ST AND EDUCATION INTERSECTIONS
*--------------------------------------------------------------------*

log using "outputs\decomp_st_ed", replace

foreach var in a b c d e f {
	display "`:variable label `var''"
		
	foreach n in 12 3 {
	
		med4way mother_dds_bin `var' p  if arm==`n'  , bootstrap reps(1000) seed(12345678) a0(0) a1(1) m(0) yreg(logbinomial) mreg(logistic)  mregoptions(or) yregoptions(eform) 
		estat bootstrap, all
		}
	}
log close

*--------------------------------------------------------------------*
// TABLE 5: DIET INEQUALITIES BY ST/NON-ST AND WEALTH INTERSECTIONS
*--------------------------------------------------------------------*

log using "outputs\decomp_st_wealth", replace

foreach var in one two three four five six {
	display "`:variable label `var''"
	
	foreach n in 12 3 {
	
		med4way mother_dds_bin `var' p  if arm==`n'  , bootstrap reps(1000) seed(12345678) a0(0) a1(1) m(0) yreg(logbinomial) mreg(logistic)  mregoptions(or) yregoptions(eform)
		estat bootstrap, all
		}		
	}
log close

*--------------------------------------------------------------------*
// APPENDIX FIGURES: CONTROLLED DIET EFFECTS AT VARYING PARTICIPATION %
*--------------------------------------------------------------------*

// SINGLE SOCIAL CHARACTERISTICS

log using "outputs\decomp_cde_single", replace


foreach var in wealth_bin ed caste_bin  {
	
	foreach n in 12 3 {
	
		foreach  in 0 .25 .5 .75 1 {
	
			med4way mother_dds_bin `var' p  if arm==`n' , bootstrap reps(1000) seed(12345678) a0(1) a1(0) m(`p') yreg(logbinomial) mreg(logistic)  mregoptions(or) yregoptions(eform)
			estat bootstrap, all
			}
		}
	}
log close

// INTERSECTION SOCIAL CHARACTERISTICS: ST/NON-ST BY EDUCATION

log using "outputs\decomp_cde_st_ed"

foreach var in a b c d e f {
	display "`:variable label `var''"
		
	foreach n in 12 3 {
	
		foreach p in 0 .25 .5 .75 1 {
	
			med4way mother_dds_bin `var' p  if arm==`n'  , bootstrap reps(1000) seed(12345678) a0(0) a1(1) m(`p') yreg(logbinomial) mreg(logistic)  mregoptions(or) yregoptions(eform) 
			estat bootstrap, all
			}
		}
	}

log close

// INTERSECTIONAL SOCIAL CHARACTERISTICS: ST/NOT-ST BY WEALTH

log using "outputs\decomp_cde_st_wealth"

foreach var in one two three four five six {
	display "`:variable label `var''"

	foreach n in 12 3 {
	
		foreach p in 0 0.25 .5 .75 1 {
	
			med4way mother_dds_bin `var' p  if arm==`n'  , bootstrap reps(1000) seed(12345678) a0(0) a1(1) m(`p') yreg(logbinomial) mreg(logistic)  mregoptions(or) yregoptions(eform)
			estat bootstrap, all
			}
		}
	}

log close





