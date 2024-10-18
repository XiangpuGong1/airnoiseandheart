

*===============================================================*
* This is the supplemental Stata code used to:
* 1. Identify Major Adverse Cardiovascular Events (MACE)
* 2. Identify cardiovascular disease (CVD)
* 3. Identify heart failure
* 4. Manipulate data for analyses
* 5. Create cardiovascular MRI outcomes
* 6. Conduct regressions
*
* The UK Biobank dataset is stored as HearMRIdata.dta
*
* Note: The directory is set as XXX. Readers can change this 
* to their own directory path before running the script.
*===============================================================*


clear


* Identify MACE events

* Inpatient data

* Load the original dataset
use "XXX\inpatients.dta"

* Generate and save datasets for each disease category

* Reload the original dataset
use "XXX\inpatients.dta", clear

* Ischaemic heart diseases (I20-I25)
gen ischaemic_heart_disease = regexm(ICD10_3, "^(I2[0-5])")
label variable ischaemic_heart_disease "Ischaemic heart diseases (I20-I25)"
keep if ischaemic_heart_disease == 1
by n_eid ischaemic_heart_disease (date_inpatient), sort: gen first_occurrence = _n == 1
keep if first_occurrence
drop first_occurrence
gen ischaemic_heart_disease_year = year(date_inpatient)
drop date_inpatient
label variable ischaemic_heart_disease_year "Ischaemic heart diseases inpatient year"
save "XXX\ischaemic_heart_disease.dta", replace

* Reload the original dataset
use "XXX\inpatients.dta", clear

* Cerebrovascular diseases (I60-I69)
gen cerebrovascular_disease = regexm(ICD10_3, "^(I6[0-9])")
label variable cerebrovascular_disease "Cerebrovascular diseases (I60-I69)"
keep if cerebrovascular_disease == 1
by n_eid cerebrovascular_disease (date_inpatient), sort: gen first_occurrence = _n == 1
keep if first_occurrence
drop first_occurrence
gen cerebrovascular_disease_year = year(date_inpatient)
drop date_inpatient
label variable cerebrovascular_disease_year "Cerebrovascular diseases inpatient year"
save "XXX\cerebrovascular_disease.dta", replace

* Reload the original dataset
use "XXX\inpatients.dta", clear

* Paroxysmal tachycardia (I47)
gen paroxysmal_tachycardia = regexm(ICD10_3, "^(I47)")
label variable paroxysmal_tachycardia "Paroxysmal tachycardia (I47)"
keep if paroxysmal_tachycardia == 1
by n_eid paroxysmal_tachycardia (date_inpatient), sort: gen first_occurrence = _n == 1
keep if first_occurrence
drop first_occurrence
gen paroxysmal_tachycardia_year = year(date_inpatient)
drop date_inpatient
label variable paroxysmal_tachycardia_year "Paroxysmal tachycardia inpatient year"
save "XXX\paroxysmal_tachycardia.dta", replace

* Reload the original dataset
use "XXX\inpatients.dta", clear

* Atrial fibrillation and flutter (I48)
gen atrial_fibrillation_flutter = regexm(ICD10_3, "^(I48)")
label variable atrial_fibrillation_flutter "Atrial fibrillation and flutter (I48)"
keep if atrial_fibrillation_flutter == 1
by n_eid atrial_fibrillation_flutter (date_inpatient), sort: gen first_occurrence = _n == 1
keep if first_occurrence
drop first_occurrence
gen atrial_fibrillation_year = year(date_inpatient)
drop date_inpatient
label variable atrial_fibrillation_year "Atrial fibrillation and flutter inpatient year"
save "XXX\atrial_fibrillation_flutter.dta", replace

* Reload the original dataset
use "XXX\inpatients.dta", clear

* Ventricular fibrillation and flutter (I49.0)
gen ventricular_fibrillation_flutter = regexm(ICD10_3, "^(I49)")
label variable ventricular_fibrillation_flutter "Ventricular fibrillation and flutter (I49)"
keep if ventricular_fibrillation_flutter == 1
by n_eid ventricular_fibrillation_flutter (date_inpatient), sort: gen first_occurrence = _n == 1
keep if first_occurrence
drop first_occurrence
gen ventricular_fibrillation_year = year(date_inpatient)
drop date_inpatient
label variable ventricular_fibrillation_year "Ventricular fibrillation and flutter inpatient year"
save "XXX\ventricular_fibrillation_flutter.dta", replace

* Reload the original dataset
use "XXX\inpatients.dta", clear

* Heart failure (I50)
gen heart_failure = regexm(ICD10_3, "^(I50)")
label variable heart_failure "Heart failure (I50)"
keep if heart_failure == 1
by n_eid heart_failure (date_inpatient), sort: gen first_occurrence = _n == 1
keep if first_occurrence
drop first_occurrence
gen heart_failure_year = year(date_inpatient)
drop date_inpatient
label variable heart_failure_year "Heart failure inpatient year"
save "XXX\heart_failure.dta", replace

* Reload the original dataset
use "XXX\inpatients.dta", clear

* Hypertensive diseases (I10-I15)
gen hypertensive_disease = regexm(ICD10_3, "^(I1[0-5])")
label variable hypertensive_disease "Hypertensive diseases (I10-I15)"
keep if hypertensive_disease == 1
by n_eid hypertensive_disease (date_inpatient), sort: gen first_occurrence = _n == 1
keep if first_occurrence
drop first_occurrence
gen hypertensive_disease_year = year(date_inpatient)
drop date_inpatient
label variable hypertensive_disease_year "Hypertensive diseases inpatient year"
save "XXX\hypertensive_disease.dta", replace



* Merge datasets by n_eid
use "XXX\ischaemic_heart_disease.dta", clear

merge 1:1 n_eid using "XXX\cerebrovascular_disease.dta", keep(master match) nogenerate

merge 1:1 n_eid using "XXX\paroxysmal_tachycardia.dta", keep(master match) nogenerate

merge 1:1 n_eid using "XXX\atrial_fibrillation_flutter.dta", keep(master match) nogenerate

merge 1:1 n_eid using "XXX\ventricular_fibrillation_flutter.dta", keep(master match) nogenerate

merge 1:1 n_eid using "XXX\heart_failure.dta", keep(master match) nogenerate

merge 1:1 n_eid using "XXX\hypertensive_disease.dta", keep(master match) nogenerate

save "XXX\final_inpatient.dta", replace


* deaths 

* Load the death dataset
use "XXX\death.dta", clear

* Generate and save datasets for each disease category based on cause of death

* Ischaemic heart diseases (I20-I25)
gen ischaemic_heart_disease_death = regexm(causedeath, "^(I2[0-5])")
label variable ischaemic_heart_disease_death "Ischaemic heart diseases (I20-I25)"
keep if ischaemic_heart_disease_death == 1
drop if missing(deathyear)
gen ischaemic_heart_death_year = deathyear
label variable ischaemic_heart_death_year "Ischaemic heart diseases death year"
save "XXX\ischaemic_heart_disease_death.dta", replace

* Reload the death dataset
use "XXX\death.dta", clear

* Cerebrovascular diseases (I60-I69)
gen cerebrovascular_disease_death = regexm(causedeath, "^(I6[0-9])")
label variable cerebrovascular_disease_death "Cerebrovascular diseases (I60-I69)"
keep if cerebrovascular_disease_death == 1
drop if missing(deathyear)
gen cerebrovascular_death_year = deathyear
label variable cerebrovascular_death_year "Cerebrovascular diseases death year"
save "XXX\cerebrovascular_disease_death.dta", replace

* Reload the death dataset
use "XXX\death.dta", clear

* Paroxysmal tachycardia (I47)
gen paroxysmal_tachycardia_death = regexm(causedeath, "^(I47)")
label variable paroxysmal_tachycardia_death "Paroxysmal tachycardia (I47)"
keep if paroxysmal_tachycardia_death == 1
drop if missing(deathyear)
gen paroxysmal_death_year = deathyear
label variable paroxysmal_death_year "Paroxysmal tachycardia death year"
save "XXX\paroxysmal_tachycardia_death.dta", replace

* Reload the death dataset
use "XXX\death.dta", clear

* Atrial fibrillation and flutter (I48)
gen atrial_fib_death = regexm(causedeath, "^(I48)")
label variable atrial_fib_death "Atrial fibrillation and flutter (I48)"
keep if atrial_fib_death == 1
drop if missing(deathyear)
gen atrial_fib_death_year = deathyear
label variable atrial_fib_death_year "Atrial fibrillation and flutter death year"
save "XXX\atrial_fib_death.dta", replace

* Reload the death dataset
use "XXX\death.dta", clear

* Ventricular fibrillation and flutter (I49.0)
gen ventricular_fib_death = regexm(causedeath, "^(I49\.0)")
label variable ventricular_fib_death "Ventricular fibrillation and flutter (I49.0)"
keep if ventricular_fib_death == 1
drop if missing(deathyear)
gen ventricular_fib_death_year = deathyear
label variable ventricular_fib_death_year "Ventricular fibrillation and flutter death year"
save "XXX\ventricular_fib_death.dta", replace

* Reload the death dataset
use "XXX\death.dta", clear

* Heart failure (I50)
gen heart_failure_death = regexm(causedeath, "^(I50)")
label variable heart_failure_death "Heart failure (I50)"
keep if heart_failure_death == 1
drop if missing(deathyear)
gen heart_failure_death_year = deathyear
label variable heart_failure_death_year "Heart failure death year"
save "XXX\heart_failure_death.dta", replace

* Reload the death dataset
use "XXX\death.dta", clear

* Hypertensive diseases (I10-I15)
gen hypertensive_disease_death = regexm(causedeath, "^(I1[0-5])")
label variable hypertensive_disease_death "Hypertensive diseases (I10-I15)"
keep if hypertensive_disease_death == 1
drop if missing(deathyear)
gen hypertensive_disease_death_year = deathyear
label variable hypertensive_disease_death_year "Hypertensive diseases death year"
save "XXX\hypertensive_disease_death.dta", replace


* Merge death datasets by n_eid
* Start with the first dataset
use "XXX\ischaemic_heart_disease_death.dta", clear

merge 1:1 n_eid using "XXX\cerebrovascular_disease_death.dta", keep(master match) nogenerate

merge 1:1 n_eid using "XXX\paroxysmal_tachycardia_death.dta", keep(master match) nogenerate

merge 1:1 n_eid using "XXX\atrial_fib_death.dta", keep(master match) nogenerate

merge 1:1 n_eid using "XXX\ventricular_fib_death.dta", keep(master match) nogenerate

merge 1:1 n_eid using "XXX\heart_failure_death.dta", keep(master match) nogenerate

merge 1:1 n_eid using "XXX\hypertensive_disease_death.dta", keep(master match) nogenerate


save "XXX\final_death.dta", replace

* reload inpatient data

clear
use "XXX\final_inpatient.dta"
merge 1:1 n_eid using "XXX\final_death.dta", keep(master match) nogenerate

* Create MACE variable
gen MACE = (ischaemic_heart_disease == 1 | ischaemic_heart_disease_death == 1 | cerebrovascular_disease == 1 | cerebrovascular_disease_death == 1 | paroxysmal_tachycardia == 1 | paroxysmal_tachycardia_death == 1 | atrial_fibrillation_flutter == 1 | atrial_fib_death == 1 | ventricular_fibrillation_flutter == 1 | ventricular_fib_death == 1 | heart_failure == 1 | heart_failure_death == 1 )

label variable MACE "Major Adverse Cardiovascular Event (MACE)"


* Combine all dates into a single variable
egen earliest_mace_year = rowmin(ischaemic_heart_disease_year ischaemic_heart_death_year cerebrovascular_disease_year cerebrovascular_death_year paroxysmal_tachycardia_year paroxysmal_death_year atrial_fibrillation_year atrial_fib_death_year ventricular_fibrillation_year ventricular_fib_death_year heart_failure_year heart_failure_death_year)

 label variable earliest_mace_year "Earliest MACE event year"

 save "XXX\final.dta", replace
 

 * Main dataset handling
 
* Load main data

clear

use "XXX\HearMRIdata.dta"

* merge MACE and CVD data 

merge 1:1 n_eid using "XXX\final.dta", keep(master match) nogenerate

* Create CVD and heart failure before 2014 

* CVD 

* A) baseline medical records:
* 1) Age angina diagnosed (data field 3627)
* 2) Age heart attack diagnosed (data field 3894)
* 3) Age stroke diagnosed (data field 4056)
 
* B) inpatient medical records
* 1) Chapter IX Diseases of the circulatory system => I20-I25 Ischaemic heart diseases
* 2) Chapter IX Diseases of the circulatory system => I60-I69 Cerebrovascular diseases

gen CVD = 0

* Baseline medical records
replace CVD = 1 if (n_3627_0_0 > 0 & n_3627_0_0<=100 | n_3894_0_0 > 0 & n_3894_0_0<=100 | n_4056_0_0 > 0 & n_4056_0_0<=100)

* Inpatient medical records for ischaemic heart diseases before 2014
replace CVD = 1 if (ischaemic_heart_disease == 1 & ischaemic_heart_disease_year <= 2014)

* Inpatient medical records for cerebrovascular diseases before 2014
replace CVD = 1 if (cerebrovascular_disease == 1 & cerebrovascular_disease_year <= 2014)

label variable CVD "Cardiovascular Disease (CVD) Diagnosis"

tab CVD


* Heart failure


gen heart_failure_2014 = 0
replace heart_failure_2014 = 1 if (heart_failure == 1 & heart_failure_year <= 2014)
label variable heart_failure_2014 "Heart Failure Inpatient Before 2014"
tab heart_failure_2014


* create hypertension, diabetes and high cholesterol

* Create a new variable 'hypertension_combined' and set it to 1 if any of the conditions are true
gen hypertension_combined = 1 if  hypertension_dd_0 == 1 | hypertension_measured_0 == 1 | hypertension_meds_0==1

* Replace missing values (i.e., cases where none of the conditions are true) with 0
replace hypertension_combined = 0 if hypertension_combined == .

* Create a new variable 'diabetes' and set it to 1 if 'n_2443' is equal to 1
gen diabetes = 1 if n_2443 == 1

* Replace missing values with 0 if 'n_2443' is not equal to 1
replace diabetes = 0 if diabetes == .




* High cholesterol

gen high_cholesterol = 0

replace high_cholesterol = 1 if n_30690 >= 6.2 

label variable high_cholesterol "High Cholesterol: Cholesterol >=6.2"

tab high_cholesterol


* create outcomes
* Generate height in meters based on the n_50 variable, n_50 represents height in centimeters.
gen height = n_50 / 100
label variable height "Standing height in metres"

* Create Left Ventricular Myocardial Mass Index (Lvmassindex) by normalizing left ventricular mass (lvmg) to height raised to the power of 1.7.
gen Lvmassindex = lvmg / height^(1.7)
label variable Lvmassindex "Left ventricular myocardial mass"

* Create Left Ventricular End-Diastolic Volume Index (LVEDVindex) by normalizing left ventricular end-diastolic volume (lvedvml) to height raised to the power of 1.7.
gen LVEDVindex = lvedvml / height^(1.7)
label variable LVEDVindex "Left ventricular end diastolic volume index"

* Create Left Ventricular End-Systolic Volume Index (LVESVindex) by normalizing left ventricular end-systolic volume (lvesvml) to height raised to the power of 1.7.
gen LVESVindex = lvesvml / height^(1.7)
label variable LVESVindex "Left ventricular end-systolic volume index"

* Calculate Myocardial Volume (Myovolume) by dividing left ventricular mass (lvmg) by a constant (1.05).
gen Myovolume = lvmg / 1.05
label variable Myovolume "Myocardial volume"

* Create Myocardial Contraction Fraction (MCF) by dividing left ventricular stroke volume (lvsvml) by myocardial volume (Myovolume).
gen MCF = lvsvml / Myovolume
label variable MCF "Myocardial contraction fraction"

* Calculate Interventricular Septal Thickness (IVS) as the mean of wall thickness measurements in specific segments (2, 3, 8, 9, 14).
egen IVS = rowmean(wt_aha_2mm wt_aha_3mm wt_aha_8mm wt_aha_9mm wt_aha_14mm)
label variable IVS "Interventricular septal thickness"

* Calculate Lateral Wall Thickness (PWT) as the mean of wall thickness measurements in specific segments (5, 6, 11, 12, 16).
egen PWT = rowmean(wt_aha_5mm wt_aha_6mm wt_aha_11mm wt_aha_12mm wt_aha_16mm)
label variable PWT "Lateral wall thickness"

* Calculate the Septal/Lateral Wall Ratio (seplatwr) by dividing interventricular septal thickness (IVS) by lateral wall thickness (PWT).
gen seplatwr = IVS / PWT
label variable seplatwr "Septal/lateral wall ratio"

* Calculate Relative Wall Mass (relwallmass) by dividing left ventricular mass (lvmg) by left ventricular end-diastolic volume (lvedvml).
gen relwallmass = lvmg / lvedvml
label variable relwallmass "Relative wall mass"

* Calculate Mean Wall Thickness (meanwt) as the average of wall thickness measurements across all 16 segments.
egen meanwt = rowmean(wt_aha_1mm wt_aha_2mm wt_aha_3mm wt_aha_4mm wt_aha_5mm wt_aha_6mm wt_aha_7mm wt_aha_8mm wt_aha_9mm wt_aha_10mm wt_aha_11mm wt_aha_12mm wt_aha_13mm wt_aha_14mm wt_aha_15mm wt_aha_16mm)
label variable meanwt "Mean wall thickness"

* Calculate Maximum Wall Thickness (maxwt) by finding the maximum value among wall thickness measurements across all 16 segments.
egen maxwt = rowmax(wt_aha_1mm wt_aha_2mm wt_aha_3mm wt_aha_4mm wt_aha_5mm wt_aha_6mm wt_aha_7mm wt_aha_8mm wt_aha_9mm wt_aha_10mm wt_aha_11mm wt_aha_12mm wt_aha_13mm wt_aha_14mm wt_aha_15mm wt_aha_16mm)
label variable maxwt "Maximum wall thickness"

* Strain Variables:
* Left Ventricle Radial Strain (global): Assign the global radial strain value (err_global) to the variable.
gen radialstrainglobal = err_global
label variable radialstrainglobal "Left ventricle radial strain global"

* Left Ventricle Circumferential Strain (global): Multiply the global circumferential strain value (ecc_global) by -1 to convert to a positive value for analysis.
gen circumstrainglobal = ecc_global * (-1)
label variable circumstrainglobal "LV circumferential strain global"

* Left Ventricle Longitudinal Strain (global): Multiply the global longitudinal strain value (ell_global) by -1 to convert to a positive value for analysis.
gen longistrainglobal = ell_global * (-1)
label variable longistrainglobal "LV longitudinal strain global"

* Calculate Radial Strain Basal (radialstrainbasal) as the mean of radial strain measurements across basal segments (1-6).
egen radialstrainbasal = rowmean(err_aha_1 err_aha_2 err_aha_3 err_aha_4 err_aha_5 err_aha_6)
label variable radialstrainbasal "LV radial strain basal"

* Calculate Radial Strain Mid (radialstrainmid) as the mean of radial strain measurements across mid segments (7-12).
egen radialstrainmid = rowmean(err_aha_7 err_aha_8 err_aha_9 err_aha_10 err_aha_11 err_aha_12)
label variable radialstrainmid "LV radial strain mid"

* Calculate Radial Strain Apical (radialstrainapical) as the mean of radial strain measurements across apical segments (13-16).
egen radialstrainapical = rowmean(err_aha_13 err_aha_14 err_aha_15 err_aha_16)
label variable radialstrainapical "LV radial strain apical"

* Calculate Circumferential Strain Basal (circumstrainbasal1) as the mean of circumferential strain measurements across basal segments (1-6).
egen circumstrainbasal1 = rowmean(ecc_aha_1 ecc_aha_2 ecc_aha_3 ecc_aha_4 ecc_aha_5 ecc_aha_6)
* Convert circumferential strain basal values to positive by multiplying by -1 for analysis.
gen circumstrainbasal = circumstrainbasal1 * (-1)

* Calculate Circumferential Strain Mid (circumstrainmid1) as the mean of circumferential strain measurements across mid segments (7-12).
egen circumstrainmid1 = rowmean(ecc_aha_7 ecc_aha_8 ecc_aha_9 ecc_aha_10 ecc_aha_11 ecc_aha_12)
* Convert circumferential strain mid values to positive by multiplying by -1 for analysis.
gen circumstrainmid = circumstrainmid1 * (-1)

* Calculate Circumferential Strain Apical (circumstrainapical1) as the mean of circumferential strain measurements across apical segments (13-16).
egen circumstrainapical1 = rowmean(ecc_aha_13 ecc_aha_14 ecc_aha_15 ecc_aha_16)
* Convert circumferential strain apical values to positive by multiplying by -1 for analysis.
gen circumstrainapica = circumstrainapical1 * (-1)

* Drop the intermediate variables used to calculate strain values.
drop circumstrainmid1 
drop circumstrainbasal1 
drop circumstrainapical1 

* Calculate Longitudinal Strain Basal (longistrainbasal1) as the mean of longitudinal strain measurements across basal segments (1-6).
egen longistrainbasal1 = rowmean(ell_1 ell_2 ell_3 ell_4 ell_5 ell_6)
* Convert longitudinal strain basal values to positive by multiplying by -1 for analysis.
gen longistrainbasal = longistrainbasal1 * (-1)
* Drop the intermediate variable used to calculate longitudinal strain basal.
drop longistrainbasal1 

* Create index variables for strain values normalized to Left Ventricular Myocardial Mass Index (Lvmassindex).
gen radialsgi = radialstrainglobal / Lvmassindex
gen circumsgi = circumstrainglobal / Lvmassindex
gen longisgi = longistrainglobal / Lvmassindex
gen radialsbi = radialstrainbasal / Lvmassindex
gen radialsmi = radialstrainmid / Lvmassindex
gen radialsai = radialstrainapical / Lvmassindex
gen circumsbi = circumstrainbasal / Lvmassindex
gen circumsmi = circumstrainmid / Lvmassindex
gen circumsai = circumstrainapica / Lvmassindex
gen longisbi = longistrainbasal / Lvmassindex

* Label the index variables.
label variable radialsgi "Radial strain global index"
label variable circumsgi "Circumferential strain global index"
label variable longisgi "Longitudinal strain global index"
label variable radialsbi "Radial strain basal index"
label variable radialsmi "Radial strain mid index"
label variable radialsai "Radial strain apical index"
label variable circumsbi "Circumferential strain basal index"
label variable circumsmi "Circumferential strain mid index"
label variable circumsai "Circumferential strain apical index"
label variable longisbi "Longitudinal strain basal index"





* Table 1. Characteristics of participants who lived near one of the four UK airports, had CMR imaging, and reported no hearing difficulties.

* Count missing values across heart MRI outcomes


egen nmis=rmiss(Lvmassindex LVEDVindex LVESVindex Myovolume MCF IVS PWT seplatwr relwallmass meanwt maxwt radialstrainglobal circumstrainglobal longistrainglobal radialstrainbasal radialstrainmid radialstrainapical circumstrainbasal circumstrainmid circumstrainapica longistrainbasal radialsgi circumsgi longisgi radialsbi radialsmi radialsai circumsbi circumsmi circumsai longisbi)

* Drop observations with all missing

drop if nmis==31


* Drop observations where air_lnight_2cat2011 is missing

drop if air_lnight_2cat2011 == .


* Drop observations where air_lnight_2cat2011 is missing


* Keep observations where hearing difficulty was not reported 

replace MACE=0 if MACE==.

keep if hearingdif==0

gen MACEbf2014 = MACE


replace MACEbf2014 = 0 if earliest_mace_year>2014





*lnight

dtable, define(iqi = q1 q3, delimiter(" - ")) sformat("(%s)" iqi) nformat(%9.2f mean sd median q1 q3) continuous(age n_189 daysofphyact n_24006_all total_no2_09_all n_102 n_21001 n_30690 LVEDVindex LVESVindex Lvmassindex Myovolume meanwt maxwt IVS PWT seplatwr relwallmass MCF lvef circumsgi circumsbi circumsmi circumsai radialsgi radialsbi radialsmi radialsai longisgi longisbi, statistics(median iqi)) factor(i.sex i.ethnic_background_cat i.household_income i.smoking i.alcohol i.road_lnight_2cat i.rail_lnight_2cat i.hypertension_combined i.diabetes i.high_cholesterol i.MACEbf2014 i.CVD i.heart_failure_2014) ,, by(air_lnight_2cat2011, nototals tests) varlabel fvlabel export("table1lnight", as(docx) replace)

* lden 


dtable, define(iqi = q1 q3, delimiter(" - ")) sformat("(%s)" iqi) nformat(%9.2f mean sd median q1 q3) continuous(age n_189 daysofphyact n_24006_all total_no2_09_all n_102 n_21001 n_30690 LVEDVindex LVESVindex Lvmassindex Myovolume meanwt maxwt IVS PWT seplatwr relwallmass MCF lvef circumsgi circumsbi circumsmi circumsai radialsgi radialsbi radialsmi radialsai longisgi longisbi, statistics(median iqi)) factor(i.sex i.ethnic_background_cat i.household_income i.smoking i.alcohol i.road_lden_2cat i.rail_lden_2cat i.hypertension_combined i.diabetes i.high_cholesterol i.MACEbf2014 i.CVD i.heart_failure_2014) ,, by(air_lden_2cat2011, nototals tests) varlabel fvlabel export("table1lden", as(docx) replace)


* Calculate MACE, events/1000 person-years


* Generate the time-to-event variable; MRIyear = instance 2 visit year
gen time_to_MACEevent = earliest_mace_year - MRIyear

* Replace missing time_to_MACEevent with 2021 - MRIyear; 2021 is the end point
replace time_to_MACEevent = 2021 - MRIyear if missing(time_to_MACEevent)

* This ensures that individuals who didn't experience MACE are censored at the endpoint (2021).

* Generate the MACEcoxID variable from MACE
gen MACEcoxID = MACE

* Set MACEcoxID to 0 for censored cases and to missing if time_to_MACEevent is negative
replace MACEcoxID=0 if MACEcoxID==.
replace MACEcoxID = . if time_to_MACEevent < 0

* Set time_to_MACEevent to missing if MACEcoxID is missing
replace time_to_MACEevent = . if MACEcoxID == .


stset time_to_MACEevent, id(n_eid) failure(MACEcoxID==1) scale(1)

stptime, per(1000) by( air_lnight_2cat2011 )

stptime, per(1000) by( air_lden_2cat2011 )



* Table 2 main results

local outcomes LVEDVindex LVESVindex Myovolume Lvmassindex meanwt maxwt IVS PWT seplatwr relwallmass lvef MCF 

local first = 1

foreach outcome in `outcomes' {
    glm `outcome' i.air_lnight_2cat2011 sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address daysofphyact i.n_54 i.road_lnight_2cat i.rail_lnight_2cat n_24006_all total_no2_09_all, vce(cluster airportid) family(gamma) link(log)
    
    if `first' {
        outreg2 using table2lnight.rtf, replace dec(2) pdec(3) ststr(replace coef=coef+"%" if coef~="") stnum(replace coef=(exp(coef)-1)*100, replace ci_low=((exp(ci_low)-1)*100), replace ci_high=((exp(ci_high)-1)*100)) level(95) noaster stats(coef ci pval) keep(i.air_lnight_2cat2011) nocon
        local first = 0
    }
    else {
        outreg2 using table2lnight.rtf, append dec(2) pdec(3) ststr(replace coef=coef+"%" if coef~="") stnum(replace coef=(exp(coef)-1)*100, replace ci_low=((exp(ci_low)-1)*100), replace ci_high=((exp(ci_high)-1)*100)) level(95) noaster stats(coef ci pval) keep(i.air_lnight_2cat2011) nocon
    }
}

local outcomes LVEDVindex LVESVindex Myovolume Lvmassindex meanwt maxwt IVS PWT seplatwr relwallmass lvef MCF 

local first = 1

foreach outcome in `outcomes' {
    glm `outcome' i.air_lden_2cat2011 sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address daysofphyact i.n_54 i.road_lden_2cat i.rail_lden_2cat n_24006_all total_no2_09_all, vce(cluster airportid) family(gamma) link(log)
    
    if `first' {
        outreg2 using table2lden.rtf, replace dec(2) pdec(3) ststr(replace coef=coef+"%" if coef~="") stnum(replace coef=(exp(coef)-1)*100, replace ci_low=((exp(ci_low)-1)*100), replace ci_high=((exp(ci_high)-1)*100)) level(95) noaster stats(coef ci pval) keep(i.air_lden_2cat2011) nocon
        local first = 0
    }
    else {
        outreg2 using table2lden.rtf, append dec(2) pdec(3) ststr(replace coef=coef+"%" if coef~="") stnum(replace coef=(exp(coef)-1)*100, replace ci_low=((exp(ci_low)-1)*100), replace ci_high=((exp(ci_high)-1)*100)) level(95) noaster stats(coef ci pval) keep(i.air_lden_2cat2011) nocon
    }
}



local outcomes circumsgi circumsbi circumsmi circumsai radialsgi radialsbi radialsmi radialsai longisgi longisbi

local first = 1

foreach outcome in `outcomes' {
    glm `outcome' i.air_lnight_2cat2011 sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address daysofphyact i.hypertension_meds_0 i.n_54 i.road_lnight_2cat i.rail_lnight_2cat n_24006_all total_no2_09_all, vce(cluster airportid) family(gamma) link(log)
    
    if `first' {
        outreg2 using table2strainlnight.rtf, replace dec(2) pdec(3) ststr(replace coef=coef+"%" if coef~="") stnum(replace coef=(exp(coef)-1)*100, replace ci_low=((exp(ci_low)-1)*100), replace ci_high=((exp(ci_high)-1)*100)) level(95) noaster stats(coef ci pval) keep(i.air_lnight_2cat2011) nocon
        local first = 0
    }
    else {
        outreg2 using table2strainlnight.rtf, append dec(2) pdec(3) ststr(replace coef=coef+"%" if coef~="") stnum(replace coef=(exp(coef)-1)*100, replace ci_low=((exp(ci_low)-1)*100), replace ci_high=((exp(ci_high)-1)*100)) level(95) noaster stats(coef ci pval) keep(i.air_lnight_2cat2011) nocon
    }
}

local outcomes circumsgi circumsbi circumsmi circumsai radialsgi radialsbi radialsmi radialsai longisgi longisbi

local first = 1

foreach outcome in `outcomes' {
    glm `outcome' i.air_lden_2cat2011 sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address daysofphyact i.hypertension_meds_0 i.n_54 i.road_lden_2cat i.rail_lden_2cat n_24006_all total_no2_09_all, vce(cluster airportid) family(gamma) link(log)
    
    if `first' {
        outreg2 using table2strainlden.rtf, replace dec(2) pdec(3) ststr(replace coef=coef+"%" if coef~="") stnum(replace coef=(exp(coef)-1)*100, replace ci_low=((exp(ci_low)-1)*100), replace ci_high=((exp(ci_high)-1)*100)) level(95) noaster stats(coef ci pval) keep(i.air_lden_2cat2011) nocon
        local first = 0
    }
    else {
        outreg2 using table2strainlden.rtf, append dec(2) pdec(3) ststr(replace coef=coef+"%" if coef~="") stnum(replace coef=(exp(coef)-1)*100, replace ci_low=((exp(ci_low)-1)*100), replace ci_high=((exp(ci_high)-1)*100)) level(95) noaster stats(coef ci pval) keep(i.air_lden_2cat2011) nocon
    }
}








* Table 4: Mediation analysis for body mass index.



* lnight 


local variables "LVEDVindex LVESVindex Myovolume Lvmassindex meanwt maxwt IVS PWT lvef MCF "

foreach var of local variables {
    * Perform the mediation analysis
    mediate (`var' sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address  daysofphyact   i.n_54   i.road_lnight_2cat i.rail_lnight_2cat n_24006_all total_no2_09_all, expmean) ( n_21001 sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address  daysofphyact    i.n_54  i.road_lnight_2cat i.rail_lnight_2cat n_24006_all total_no2_09_all, linear) (air_lnight_2cat2011) , vce(cluster airportid)

    * Save the coefficients to Excel
    putexcel set mediate_coeflnightbmi.xlsx, sheet("`var'") modify
    putexcel A1=matrix(r(table))

    * Calculate and save the proportion mediated
    estat proportion, force
    putexcel set mediate_prolnightbmi.xlsx, sheet("`var'") modify
    putexcel A1=matrix(r(table))
}


local variables "circumsgi radialsgi longisgi"

foreach var of local variables {
    * Perform the mediation analysis
    mediate (`var' sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address  daysofphyact  i.hypertension_meds_0  i.n_54   i.road_lnight_2cat i.rail_lnight_2cat n_24006_all total_no2_09_all, expmean) ( n_21001 sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address  daysofphyact i.hypertension_meds_0    i.n_54  i.road_lnight_2cat i.rail_lnight_2cat n_24006_all total_no2_09_all, linear) (air_lnight_2cat2011) , vce(cluster airportid)

    * Save the coefficients to Excel
    putexcel set mediate_coeflnightbmi.xlsx, sheet("`var'") modify
    putexcel A1=matrix(r(table))

    * Calculate and save the proportion mediated
    estat proportion, force
    putexcel set mediate_prolnightbmi.xlsx, sheet("`var'") modify
    putexcel A1=matrix(r(table))
}




* lden 


local variables "LVEDVindex LVESVindex Myovolume Lvmassindex meanwt maxwt IVS PWT lvef MCF"

foreach var of local variables {
    * Perform the mediation analysis
    mediate (`var' sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address  daysofphyact  i.n_54   i.road_lden_2cat i.rail_lden_2cat n_24006_all total_no2_09_all, expmean) ( n_21001 sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address  daysofphyact   i.n_54  i.road_lden_2cat i.rail_lden_2cat n_24006_all total_no2_09_all, linear) (air_lden_2cat2011) , vce(cluster airportid)
   

    * Save the coefficients to Excel
    putexcel set mediate_coefldenbmi.xlsx, sheet("`var'") modify
    putexcel A1=matrix(r(table))

    * Calculate and save the proportion mediated
    estat proportion, force
    putexcel set mediate_proldenbmi.xlsx, sheet("`var'") modify
    putexcel A1=matrix(r(table))
}




local variables "circumsgi radialsgi longisgi"

foreach var of local variables {
    * Perform the mediation analysis
    mediate (`var' sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address  daysofphyact i.hypertension_meds_0  i.n_54   i.road_lden_2cat i.rail_lden_2cat n_24006_all total_no2_09_all, expmean) ( n_21001 sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address  daysofphyact i.hypertension_meds_0  i.n_54  i.road_lden_2cat i.rail_lden_2cat n_24006_all total_no2_09_all, linear) (air_lden_2cat2011) , vce(cluster airportid)
   

    * Save the coefficients to Excel
    putexcel set mediate_coefldenbmi.xlsx, sheet("`var'") modify
    putexcel A1=matrix(r(table))

    * Calculate and save the proportion mediated
    estat proportion, force
    putexcel set mediate_proldenbmi.xlsx, sheet("`var'") modify
    putexcel A1=matrix(r(table))
}




* Supplementary Table S4. Absolute differences in CMR strain metrics between those exposed and unexposed to higher aircraft noise levels.





* lnight

local outcomes LVEDVindex LVESVindex Myovolume Lvmassindex meanwt maxwt IVS PWT seplatwr relwallmass lvef MCF 

local first = 1

foreach outcome in `outcomes' {
    glm `outcome' i.air_lnight_2cat2011 sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address daysofphyact i.n_54 i.road_lnight_2cat i.rail_lnight_2cat n_24006_all total_no2_09_all, vce(cluster airportid) family(gamma) link(identity)
    
    if `first' {
        outreg2 using tables4lnight.rtf, replace dec(2) pdec(3)  level(95) noaster stats(coef ci pval) keep(i.air_lnight_2cat2011) nocon
        local first = 0
    }
    else {
        outreg2 using tables4lnight.rtf, append dec(2) pdec(3)  level(95) noaster stats(coef ci pval) keep(i.air_lnight_2cat2011) nocon
    }
}


* lden 

local outcomes LVEDVindex LVESVindex Myovolume Lvmassindex meanwt maxwt IVS PWT seplatwr relwallmass lvef MCF 

local first = 1

foreach outcome in `outcomes' {
    glm `outcome' i.air_lden_2cat2011 sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address daysofphyact i.n_54 i.road_lden_2cat i.rail_lden_2cat n_24006_all total_no2_09_all, vce(cluster airportid) family(gamma) link(identity)
    
    if `first' {
        outreg2 using tables4lden.rtf, replace dec(2) pdec(3)  level(95) noaster stats(coef ci pval) keep(i.air_lden_2cat2011) nocon
        local first = 0
    }
    else {
        outreg2 using tables4lden.rtf, append dec(2) pdec(3)  level(95) noaster stats(coef ci pval) keep(i.air_lden_2cat2011) nocon
    }
}





* lnight

local outcomes circumsgi circumsbi circumsmi circumsai radialsgi radialsbi radialsmi radialsai longisgi longisbi

local first = 1

foreach outcome in `outcomes' {
    glm `outcome' i.air_lnight_2cat2011 sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address daysofphyact i.hypertension_meds_0  i.n_54 i.road_lnight_2cat i.rail_lnight_2cat n_24006_all total_no2_09_all, vce(cluster airportid) family(gamma) link(identity)
    
    if `first' {
        outreg2 using tables4strainlnight.rtf, replace dec(2) pdec(3)  level(95) noaster stats(coef ci pval) keep(i.air_lnight_2cat2011) nocon
        local first = 0
    }
    else {
        outreg2 using tables4strainlnight.rtf, append dec(2) pdec(3)  level(95) noaster stats(coef ci pval) keep(i.air_lnight_2cat2011) nocon
    }
}


* lden 

local outcomes circumsgi circumsbi circumsmi circumsai radialsgi radialsbi radialsmi radialsai longisgi longisbi 

local first = 1

foreach outcome in `outcomes' {
    glm `outcome' i.air_lden_2cat2011 sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address daysofphyact i.hypertension_meds_0  i.n_54 i.road_lden_2cat i.rail_lden_2cat n_24006_all total_no2_09_all, vce(cluster airportid) family(gamma) link(identity)
    
    if `first' {
        outreg2 using tables4strainlden.rtf, replace dec(2) pdec(3)  level(95) noaster stats(coef ci pval) keep(i.air_lden_2cat2011) nocon
        local first = 0
    }
    else {
        outreg2 using tables4strainlden.rtf, append dec(2) pdec(3)  level(95) noaster stats(coef ci pval) keep(i.air_lden_2cat2011) nocon
    }
}




















* Supplementary Table S5. Percentage differences in CMR strain metrics between those exposed and unexposed to higher aircraft noise levels using regressions weighted based on propensity match scores. 



* Lnight 

* Perform PSM and generate weights for LVEDVindex
psmatch2 air_lnight_2cat2011 (sex age ethnic_background_cat n_189 non_mover household_income smoking alcohol time_at_address daysofphyact n_54 road_lnight_2cat rail_lnight_2cat n_24006_all total_no2_09_all) if hearingdif==0, out(LVEDVindex) neighbor(2)
* Generate weights for LVEDVindex
gen w_LVEDVindex = _weight
* Run the weighted regression for LVEDVindex
glm LVEDVindex air_lnight_2cat2011 sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address daysofphyact i.n_54 i.road_lnight_2cat i.rail_lnight_2cat n_24006_all total_no2_09_all [pw=w_LVEDVindex] if hearingdif==0, vce(cluster airportid) family(gamma) link(log)
* Export regression results for LVEDVindex
outreg2 using tables5lnight.rtf, replace dec(2) pdec(3) ststr(replace coef=coef+"%" if coef~="") stnum(replace coef=(exp(coef)-1)*100, replace ci_low=((exp(ci_low)-1)*100), replace ci_high=((exp(ci_high)-1)*100)) level(95) noaster stats(coef ci pval) keep(air_lnight_2cat2011) nocon

* Perform PSM and generate weights for LVESVindex
psmatch2 air_lnight_2cat2011 (sex age ethnic_background_cat n_189 non_mover household_income smoking alcohol time_at_address daysofphyact n_54 road_lnight_2cat rail_lnight_2cat n_24006_all total_no2_09_all) if hearingdif==0, out(LVESVindex) neighbor(2)
* Generate weights for LVESVindex
gen w_LVESVindex = _weight
* Run the weighted regression for LVESVindex
glm LVESVindex air_lnight_2cat2011 sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address daysofphyact i.n_54 i.road_lnight_2cat i.rail_lnight_2cat n_24006_all total_no2_09_all [pw=w_LVESVindex] if hearingdif==0, vce(cluster airportid) family(gamma) link(log)
* Export regression results for LVESVindex
outreg2 using tables5lnight.rtf, append dec(2) pdec(3) ststr(replace coef=coef+"%" if coef~="") stnum(replace coef=(exp(coef)-1)*100, replace ci_low=((exp(ci_low)-1)*100), replace ci_high=((exp(ci_high)-1)*100)) level(95) noaster stats(coef ci pval) keep(air_lnight_2cat2011) nocon

* Perform PSM and generate weights for Myovolume
psmatch2 air_lnight_2cat2011 (sex age ethnic_background_cat n_189 non_mover household_income smoking alcohol time_at_address daysofphyact n_54 road_lnight_2cat rail_lnight_2cat n_24006_all total_no2_09_all) if hearingdif==0, out(Myovolume) neighbor(2)
* Generate weights for Myovolume
gen w_Myovolume = _weight
* Run the weighted regression for Myovolume
glm Myovolume air_lnight_2cat2011 sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address daysofphyact i.n_54 i.road_lnight_2cat i.rail_lnight_2cat n_24006_all total_no2_09_all [pw=w_Myovolume] if hearingdif==0, vce(cluster airportid) family(gamma) link(log)
* Export regression results for Myovolume
outreg2 using tables5lnight.rtf, append dec(2) pdec(3) ststr(replace coef=coef+"%" if coef~="") stnum(replace coef=(exp(coef)-1)*100, replace ci_low=((exp(ci_low)-1)*100), replace ci_high=((exp(ci_high)-1)*100)) level(95) noaster stats(coef ci pval) keep(air_lnight_2cat2011) nocon

* Perform PSM and generate weights for Lvmassindex
psmatch2 air_lnight_2cat2011 (sex age ethnic_background_cat n_189 non_mover household_income smoking alcohol time_at_address daysofphyact n_54 road_lnight_2cat rail_lnight_2cat n_24006_all total_no2_09_all) if hearingdif==0, out(Lvmassindex) neighbor(2)
* Generate weights for Lvmassindex
gen w_Lvmassindex = _weight
* Run the weighted regression for Lvmassindex
glm Lvmassindex air_lnight_2cat2011 sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address daysofphyact i.n_54 i.road_lnight_2cat i.rail_lnight_2cat n_24006_all total_no2_09_all [pw=w_Lvmassindex] if hearingdif==0, vce(cluster airportid) family(gamma) link(log)
* Export regression results for Lvmassindex
outreg2 using tables5lnight.rtf, append dec(2) pdec(3) ststr(replace coef=coef+"%" if coef~="") stnum(replace coef=(exp(coef)-1)*100, replace ci_low=((exp(ci_low)-1)*100), replace ci_high=((exp(ci_high)-1)*100)) level(95) noaster stats(coef ci pval) keep(air_lnight_2cat2011) nocon

* Perform PSM and generate weights for meanwt
psmatch2 air_lnight_2cat2011 (sex age ethnic_background_cat n_189 non_mover household_income smoking alcohol time_at_address daysofphyact n_54 road_lnight_2cat rail_lnight_2cat n_24006_all total_no2_09_all) if hearingdif==0, out(meanwt) neighbor(2)
* Generate weights for meanwt
gen w_meanwt = _weight
* Run the weighted regression for meanwt
glm meanwt air_lnight_2cat2011 sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address daysofphyact i.n_54 i.road_lnight_2cat i.rail_lnight_2cat n_24006_all total_no2_09_all [pw=w_meanwt] if hearingdif==0, vce(cluster airportid) family(gamma) link(log)
* Export regression results for meanwt
outreg2 using tables5lnight.rtf, append dec(2) pdec(3) ststr(replace coef=coef+"%" if coef~="") stnum(replace coef=(exp(coef)-1)*100, replace ci_low=((exp(ci_low)-1)*100), replace ci_high=((exp(ci_high)-1)*100)) level(95) noaster stats(coef ci pval) keep(air_lnight_2cat2011) nocon

* Perform PSM and generate weights for maxwt
psmatch2 air_lnight_2cat2011 (sex age ethnic_background_cat n_189 non_mover household_income smoking alcohol time_at_address daysofphyact n_54 road_lnight_2cat rail_lnight_2cat n_24006_all total_no2_09_all) if hearingdif==0, out(maxwt) neighbor(2)
* Generate weights for maxwt
gen w_maxwt = _weight
* Run the weighted regression for maxwt
glm maxwt air_lnight_2cat2011 sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address daysofphyact i.n_54 i.road_lnight_2cat i.rail_lnight_2cat n_24006_all total_no2_09_all [pw=w_maxwt] if hearingdif==0, vce(cluster airportid) family(gamma) link(log)
* Export regression results for maxwt
outreg2 using tables5lnight.rtf, append dec(2) pdec(3) ststr(replace coef=coef+"%" if coef~="") stnum(replace coef=(exp(coef)-1)*100, replace ci_low=((exp(ci_low)-1)*100), replace ci_high=((exp(ci_high)-1)*100)) level(95) noaster stats(coef ci pval) keep(air_lnight_2cat2011) nocon

* Perform PSM and generate weights for IVS
psmatch2 air_lnight_2cat2011 (sex age ethnic_background_cat n_189 non_mover household_income smoking alcohol time_at_address daysofphyact n_54 road_lnight_2cat rail_lnight_2cat n_24006_all total_no2_09_all) if hearingdif==0, out(IVS) neighbor(2)
* Generate weights for IVS
gen w_IVS = _weight
* Run the weighted regression for IVS
glm IVS air_lnight_2cat2011 sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address daysofphyact i.n_54 i.road_lnight_2cat i.rail_lnight_2cat n_24006_all total_no2_09_all [pw=w_IVS] if hearingdif==0, vce(cluster airportid) family(gamma) link(log)
* Export regression results for IVS
outreg2 using tables5lnight.rtf, append dec(2) pdec(3) ststr(replace coef=coef+"%" if coef~="") stnum(replace coef=(exp(coef)-1)*100, replace ci_low=((exp(ci_low)-1)*100), replace ci_high=((exp(ci_high)-1)*100)) level(95) noaster stats(coef ci pval) keep(air_lnight_2cat2011) nocon

* Perform PSM and generate weights for PWT
psmatch2 air_lnight_2cat2011 (sex age ethnic_background_cat n_189 non_mover household_income smoking alcohol time_at_address daysofphyact n_54 road_lnight_2cat rail_lnight_2cat n_24006_all total_no2_09_all) if hearingdif==0, out(PWT) neighbor(2)
* Generate weights for PWT
gen w_PWT = _weight
* Run the weighted regression for PWT
glm PWT air_lnight_2cat2011 sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address daysofphyact i.n_54 i.road_lnight_2cat i.rail_lnight_2cat n_24006_all total_no2_09_all [pw=w_PWT] if hearingdif==0, vce(cluster airportid) family(gamma) link(log)
* Export regression results for PWT
outreg2 using tables5lnight.rtf, append dec(2) pdec(3) ststr(replace coef=coef+"%" if coef~="") stnum(replace coef=(exp(coef)-1)*100, replace ci_low=((exp(ci_low)-1)*100), replace ci_high=((exp(ci_high)-1)*100)) level(95) noaster stats(coef ci pval) keep(air_lnight_2cat2011) nocon

* Perform PSM and generate weights for seplatwr
psmatch2 air_lnight_2cat2011 (sex age ethnic_background_cat n_189 non_mover household_income smoking alcohol time_at_address daysofphyact n_54 road_lnight_2cat rail_lnight_2cat n_24006_all total_no2_09_all) if hearingdif==0, out(seplatwr) neighbor(2)
* Generate weights for seplatwr
gen w_seplatwr = _weight
* Run the weighted regression for seplatwr
glm seplatwr air_lnight_2cat2011 sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address daysofphyact i.n_54 i.road_lnight_2cat i.rail_lnight_2cat n_24006_all total_no2_09_all [pw=w_seplatwr] if hearingdif==0, vce(cluster airportid) family(gamma) link(log)
* Export regression results for seplatwr
outreg2 using tables5lnight.rtf, append dec(2) pdec(3) ststr(replace coef=coef+"%" if coef~="") stnum(replace coef=(exp(coef)-1)*100, replace ci_low=((exp(ci_low)-1)*100), replace ci_high=((exp(ci_high)-1)*100)) level(95) noaster stats(coef ci pval) keep(air_lnight_2cat2011) nocon

* Perform PSM and generate weights for relwallmass
psmatch2 air_lnight_2cat2011 (sex age ethnic_background_cat n_189 non_mover household_income smoking alcohol time_at_address daysofphyact n_54 road_lnight_2cat rail_lnight_2cat n_24006_all total_no2_09_all) if hearingdif==0, out(relwallmass) neighbor(2)
* Generate weights for relwallmass
gen w_relwallmass = _weight
* Run the weighted regression for relwallmass
glm relwallmass air_lnight_2cat2011 sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address daysofphyact i.n_54 i.road_lnight_2cat i.rail_lnight_2cat n_24006_all total_no2_09_all [pw=w_relwallmass] if hearingdif==0, vce(cluster airportid) family(gamma) link(log)
* Export regression results for relwallmass
outreg2 using tables5lnight.rtf, append dec(2) pdec(3) ststr(replace coef=coef+"%" if coef~="") stnum(replace coef=(exp(coef)-1)*100, replace ci_low=((exp(ci_low)-1)*100), replace ci_high=((exp(ci_high)-1)*100)) level(95) noaster stats(coef ci pval) keep(air_lnight_2cat2011) nocon

* Perform PSM and generate weights for lvef
psmatch2 air_lnight_2cat2011 (sex age ethnic_background_cat n_189 non_mover household_income smoking alcohol time_at_address daysofphyact n_54 road_lnight_2cat rail_lnight_2cat n_24006_all total_no2_09_all) if hearingdif==0, out(lvef) neighbor(2)
* Generate weights for lvef
gen w_lvef = _weight
* Run the weighted regression for lvef
glm lvef air_lnight_2cat2011 sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address daysofphyact i.n_54 i.road_lnight_2cat i.rail_lnight_2cat n_24006_all total_no2_09_all [pw=w_lvef] if hearingdif==0, vce(cluster airportid) family(gamma) link(log)
* Export regression results for lvef
outreg2 using tables5lnight.rtf, append dec(2) pdec(3) ststr(replace coef=coef+"%" if coef~="") stnum(replace coef=(exp(coef)-1)*100, replace ci_low=((exp(ci_low)-1)*100), replace ci_high=((exp(ci_high)-1)*100)) level(95) noaster stats(coef ci pval) keep(air_lnight_2cat2011) nocon

* Perform PSM and generate weights for MCF
psmatch2 air_lnight_2cat2011 (sex age ethnic_background_cat n_189 non_mover household_income smoking alcohol time_at_address daysofphyact  n_54 road_lnight_2cat rail_lnight_2cat n_24006_all total_no2_09_all) if hearingdif==0, out(MCF) neighbor(2)
* Generate weights for MCF
gen w_MCF = _weight
* Run the weighted regression for MCF
glm MCF air_lnight_2cat2011 sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address daysofphyact i.n_54 i.road_lnight_2cat i.rail_lnight_2cat n_24006_all total_no2_09_all [pw=w_MCF] if hearingdif==0, vce(cluster airportid) family(gamma) link(log)
* Export regression results for MCF
outreg2 using tables5lnight.rtf, append dec(2) pdec(3) ststr(replace coef=coef+"%" if coef~="") stnum(replace coef=(exp(coef)-1)*100, replace ci_low=((exp(ci_low)-1)*100), replace ci_high=((exp(ci_high)-1)*100)) level(95) noaster stats(coef ci pval) keep(air_lnight_2cat2011) nocon

* Perform PSM and generate weights for circumsgi
psmatch2 air_lnight_2cat2011 (sex age ethnic_background_cat n_189 non_mover household_income smoking alcohol time_at_address daysofphyact i.hypertension_meds_0   n_54 road_lnight_2cat rail_lnight_2cat n_24006_all total_no2_09_all) if hearingdif==0, out(circumsgi) neighbor(2)
* Generate weights for circumsgi
gen w_circumsgi = _weight
* Run the weighted regression for circumsgi
glm circumsgi air_lnight_2cat2011 sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address daysofphyact i.hypertension_meds_0   i.n_54 i.road_lnight_2cat i.rail_lnight_2cat n_24006_all total_no2_09_all [pw=w_circumsgi] if hearingdif==0, vce(cluster airportid) family(gamma) link(log)
* Export regression results for circumsgi
outreg2 using tables5lnight.rtf, append dec(2) pdec(3) ststr(replace coef=coef+"%" if coef~="") stnum(replace coef=(exp(coef)-1)*100, replace ci_low=((exp(ci_low)-1)*100), replace ci_high=((exp(ci_high)-1)*100)) level(95) noaster stats(coef ci pval) keep(air_lnight_2cat2011) nocon

* Perform PSM and generate weights for circumsbi
psmatch2 air_lnight_2cat2011 (sex age ethnic_background_cat n_189 non_mover household_income smoking alcohol time_at_address daysofphyact n_54 road_lnight_2cat rail_lnight_2cat n_24006_all total_no2_09_all) if hearingdif==0, out(circumsbi) neighbor(2)
* Generate weights for circumsbi
gen w_circumsbi = _weight
* Run the weighted regression for circumsbi
glm circumsbi air_lnight_2cat2011 sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address daysofphyact i.hypertension_meds_0   i.n_54 i.road_lnight_2cat i.rail_lnight_2cat n_24006_all total_no2_09_all [pw=w_circumsbi] if hearingdif==0, vce(cluster airportid) family(gamma) link(log)
* Export regression results for circumsbi
outreg2 using tables5lnight.rtf, append dec(2) pdec(3) ststr(replace coef=coef+"%" if coef~="") stnum(replace coef=(exp(coef)-1)*100, replace ci_low=((exp(ci_low)-1)*100), replace ci_high=((exp(ci_high)-1)*100)) level(95) noaster stats(coef ci pval) keep(air_lnight_2cat2011) nocon

* Perform PSM and generate weights for circumsmi
psmatch2 air_lnight_2cat2011 (sex age ethnic_background_cat n_189 non_mover household_income smoking alcohol time_at_address daysofphyact i.hypertension_meds_0   n_54 road_lnight_2cat rail_lnight_2cat n_24006_all total_no2_09_all) if hearingdif==0, out(circumsmi) neighbor(2)
* Generate weights for circumsmi
gen w_circumsmi = _weight
* Run the weighted regression for circumsmi
glm circumsmi air_lnight_2cat2011 sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address daysofphyact i.hypertension_meds_0   i.n_54 i.road_lnight_2cat i.rail_lnight_2cat n_24006_all total_no2_09_all [pw=w_circumsmi] if hearingdif==0, vce(cluster airportid) family(gamma) link(log)
* Export regression results for circumsmi
outreg2 using tables5lnight.rtf, append dec(2) pdec(3) ststr(replace coef=coef+"%" if coef~="") stnum(replace coef=(exp(coef)-1)*100, replace ci_low=((exp(ci_low)-1)*100), replace ci_high=((exp(ci_high)-1)*100)) level(95) noaster stats(coef ci pval) keep(air_lnight_2cat2011) nocon

* Perform PSM and generate weights for circumsai
psmatch2 air_lnight_2cat2011 (sex age ethnic_background_cat n_189 non_mover household_income smoking alcohol time_at_address daysofphyact i.hypertension_meds_0   n_54 road_lnight_2cat rail_lnight_2cat n_24006_all total_no2_09_all) if hearingdif==0, out(circumsai) neighbor(2)
* Generate weights for circumsai
gen w_circumsai = _weight
* Run the weighted regression for circumsai
glm circumsai air_lnight_2cat2011 sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address daysofphyact i.hypertension_meds_0   i.n_54 i.road_lnight_2cat i.rail_lnight_2cat n_24006_all total_no2_09_all [pw=w_circumsai] if hearingdif==0, vce(cluster airportid) family(gamma) link(log)
* Export regression results for circumsai
outreg2 using tables5lnight.rtf, append dec(2) pdec(3) ststr(replace coef=coef+"%" if coef~="") stnum(replace coef=(exp(coef)-1)*100, replace ci_low=((exp(ci_low)-1)*100), replace ci_high=((exp(ci_high)-1)*100)) level(95) noaster stats(coef ci pval) keep(air_lnight_2cat2011) nocon

* Perform PSM and generate weights for radialsgi
psmatch2 air_lnight_2cat2011 (sex age ethnic_background_cat n_189 non_mover household_income smoking alcohol time_at_address daysofphyact i.hypertension_meds_0   n_54 road_lnight_2cat rail_lnight_2cat n_24006_all total_no2_09_all) if hearingdif==0, out(radialsgi) neighbor(2)
* Generate weights for radialsgi
gen w_radialsgi = _weight
* Run the weighted regression for radialsgi
glm radialsgi air_lnight_2cat2011 sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address daysofphyact i.hypertension_meds_0   i.n_54 i.road_lnight_2cat i.rail_lnight_2cat n_24006_all total_no2_09_all [pw=w_radialsgi] if hearingdif==0, vce(cluster airportid) family(gamma) link(log)
* Export regression results for radialsgi
outreg2 using tables5lnight.rtf, append dec(2) pdec(3) ststr(replace coef=coef+"%" if coef~="") stnum(replace coef=(exp(coef)-1)*100, replace ci_low=((exp(ci_low)-1)*100), replace ci_high=((exp(ci_high)-1)*100)) level(95) noaster stats(coef ci pval) keep(air_lnight_2cat2011) nocon

* Perform PSM and generate weights for radialsbi
psmatch2 air_lnight_2cat2011 (sex age ethnic_background_cat n_189 non_mover household_income smoking alcohol time_at_address daysofphyact i.hypertension_meds_0   n_54 road_lnight_2cat rail_lnight_2cat n_24006_all total_no2_09_all) if hearingdif==0, out(radialsbi) neighbor(2)
* Generate weights for radialsbi
gen w_radialsbi = _weight
* Run the weighted regression for radialsbi
glm radialsbi air_lnight_2cat2011 sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address daysofphyact i.hypertension_meds_0   i.n_54 i.road_lnight_2cat i.rail_lnight_2cat n_24006_all total_no2_09_all [pw=w_radialsbi] if hearingdif==0, vce(cluster airportid) family(gamma) link(log)
* Export regression results for radialsbi
outreg2 using tables5lnight.rtf, append dec(2) pdec(3) ststr(replace coef=coef+"%" if coef~="") stnum(replace coef=(exp(coef)-1)*100, replace ci_low=((exp(ci_low)-1)*100), replace ci_high=((exp(ci_high)-1)*100)) level(95) noaster stats(coef ci pval) keep(air_lnight_2cat2011) nocon

* Perform PSM and generate weights for radialsmi
psmatch2 air_lnight_2cat2011 (sex age ethnic_background_cat n_189 non_mover household_income smoking alcohol time_at_address daysofphyact i.hypertension_meds_0   n_54 road_lnight_2cat rail_lnight_2cat n_24006_all total_no2_09_all) if hearingdif==0, out(radialsmi) neighbor(2)
* Generate weights for radialsmi
gen w_radialsmi = _weight
* Run the weighted regression for radialsmi
glm radialsmi air_lnight_2cat2011 sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address daysofphyact i.hypertension_meds_0   i.n_54 i.road_lnight_2cat i.rail_lnight_2cat n_24006_all total_no2_09_all [pw=w_radialsmi] if hearingdif==0, vce(cluster airportid) family(gamma) link(log)
* Export regression results for radialsmi
outreg2 using tables5lnight.rtf, append dec(2) pdec(3) ststr(replace coef=coef+"%" if coef~="") stnum(replace coef=(exp(coef)-1)*100, replace ci_low=((exp(ci_low)-1)*100), replace ci_high=((exp(ci_high)-1)*100)) level(95) noaster stats(coef ci pval) keep(air_lnight_2cat2011) nocon

* Perform PSM and generate weights for radialsai
psmatch2 air_lnight_2cat2011 (sex age ethnic_background_cat n_189 non_mover household_income smoking alcohol time_at_address daysofphyact i.hypertension_meds_0   n_54 road_lnight_2cat rail_lnight_2cat n_24006_all total_no2_09_all) if hearingdif==0, out(radialsai) neighbor(2)
* Generate weights for radialsai
gen w_radialsai = _weight
* Run the weighted regression for radialsai
glm radialsai air_lnight_2cat2011 sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address daysofphyact i.hypertension_meds_0   i.n_54 i.road_lnight_2cat i.rail_lnight_2cat n_24006_all total_no2_09_all [pw=w_radialsai] if hearingdif==0, vce(cluster airportid) family(gamma) link(log)
* Export regression results for radialsai
outreg2 using tables5lnight.rtf, append dec(2) pdec(3) ststr(replace coef=coef+"%" if coef~="") stnum(replace coef=(exp(coef)-1)*100, replace ci_low=((exp(ci_low)-1)*100), replace ci_high=((exp(ci_high)-1)*100)) level(95) noaster stats(coef ci pval) keep(air_lnight_2cat2011) nocon

* Perform PSM and generate weights for longisgi
psmatch2 air_lnight_2cat2011 (sex age ethnic_background_cat n_189 non_mover household_income smoking alcohol time_at_address daysofphyact i.hypertension_meds_0   n_54 road_lnight_2cat rail_lnight_2cat n_24006_all total_no2_09_all) if hearingdif==0, out(longisgi) neighbor(2)
* Generate weights for longisgi
gen w_longisgi = _weight
* Run the weighted regression for longisgi
glm longisgi air_lnight_2cat2011 sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address daysofphyact i.hypertension_meds_0   i.n_54 i.road_lnight_2cat i.rail_lnight_2cat n_24006_all total_no2_09_all [pw=w_longisgi] if hearingdif==0, vce(cluster airportid) family(gamma) link(log)
* Export regression results for longisgi
outreg2 using tables5lnight.rtf, append dec(2) pdec(3) ststr(replace coef=coef+"%" if coef~="") stnum(replace coef=(exp(coef)-1)*100, replace ci_low=((exp(ci_low)-1)*100), replace ci_high=((exp(ci_high)-1)*100)) level(95) noaster stats(coef ci pval) keep(air_lnight_2cat2011) nocon

* Perform PSM and generate weights for longisbi
psmatch2 air_lnight_2cat2011 (sex age ethnic_background_cat n_189 non_mover household_income smoking alcohol time_at_address daysofphyact i.hypertension_meds_0   n_54 road_lnight_2cat rail_lnight_2cat n_24006_all total_no2_09_all) if hearingdif==0, out(longisbi) neighbor(2)
* Generate weights for longisbi
gen w_longisbi = _weight
* Run the weighted regression for longisbi
glm longisbi air_lnight_2cat2011 sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address daysofphyact i.hypertension_meds_0   i.n_54 i.road_lnight_2cat i.rail_lnight_2cat n_24006_all total_no2_09_all [pw=w_longisbi] if hearingdif==0, vce(cluster airportid) family(gamma) link(log)
* Export regression results for longisbi
outreg2 using tables5lnight.rtf, append dec(2) pdec(3) ststr(replace coef=coef+"%" if coef~="") stnum(replace coef=(exp(coef)-1)*100, replace ci_low=((exp(ci_low)-1)*100), replace ci_high=((exp(ci_high)-1)*100)) level(95) noaster stats(coef ci pval) keep(air_lnight_2cat2011) nocon


* Lden

drop w_LVEDVindex w_LVESVindex w_Myovolume w_Lvmassindex w_meanwt w_maxwt w_IVS w_PWT w_seplatwr w_relwallmass w_lvef w_MCF w_circumsgi w_circumsbi w_circumsmi w_circumsai w_radialsgi w_radialsbi w_radialsmi w_radialsai w_longisgi w_longisbi 

* Perform PSM and generate weights for LVEDVindex
psmatch2 air_lden_2cat2011 (sex age ethnic_background_cat n_189 non_mover household_income smoking alcohol time_at_address daysofphyact n_54 road_lden_2cat rail_lden_2cat n_24006_all total_no2_09_all) if hearingdif==0, out(LVEDVindex) neighbor(2)
* Generate weights for LVEDVindex
gen w_LVEDVindex = _weight
* Run the weighted regression for LVEDVindex
glm LVEDVindex air_lden_2cat2011 sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address daysofphyact i.n_54 i.road_lden_2cat i.rail_lden_2cat n_24006_all total_no2_09_all [pw=w_LVEDVindex] if hearingdif==0, vce(cluster airportid) family(gamma) link(log)
* Export regression results for LVEDVindex
outreg2 using tables5lden.rtf, replace dec(2) pdec(3) ststr(replace coef=coef+"%" if coef~="") stnum(replace coef=(exp(coef)-1)*100, replace ci_low=((exp(ci_low)-1)*100), replace ci_high=((exp(ci_high)-1)*100)) level(95) noaster stats(coef ci pval) keep(air_lden_2cat2011) nocon

* Perform PSM and generate weights for LVESVindex
psmatch2 air_lden_2cat2011 (sex age ethnic_background_cat n_189 non_mover household_income smoking alcohol time_at_address daysofphyact n_54 road_lden_2cat rail_lden_2cat n_24006_all total_no2_09_all) if hearingdif==0, out(LVESVindex) neighbor(2)
* Generate weights for LVESVindex
gen w_LVESVindex = _weight
* Run the weighted regression for LVESVindex
glm LVESVindex air_lden_2cat2011 sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address daysofphyact i.n_54 i.road_lden_2cat i.rail_lden_2cat n_24006_all total_no2_09_all [pw=w_LVESVindex] if hearingdif==0, vce(cluster airportid) family(gamma) link(log)
* Export regression results for LVESVindex
outreg2 using tables5lden.rtf, append dec(2) pdec(3) ststr(replace coef=coef+"%" if coef~="") stnum(replace coef=(exp(coef)-1)*100, replace ci_low=((exp(ci_low)-1)*100), replace ci_high=((exp(ci_high)-1)*100)) level(95) noaster stats(coef ci pval) keep(air_lden_2cat2011) nocon

* Perform PSM and generate weights for Myovolume
psmatch2 air_lden_2cat2011 (sex age ethnic_background_cat n_189 non_mover household_income smoking alcohol time_at_address daysofphyact n_54 road_lden_2cat rail_lden_2cat n_24006_all total_no2_09_all) if hearingdif==0, out(Myovolume) neighbor(2)
* Generate weights for Myovolume
gen w_Myovolume = _weight
* Run the weighted regression for Myovolume
glm Myovolume air_lden_2cat2011 sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address daysofphyact i.n_54 i.road_lden_2cat i.rail_lden_2cat n_24006_all total_no2_09_all [pw=w_Myovolume] if hearingdif==0, vce(cluster airportid) family(gamma) link(log)
* Export regression results for Myovolume
outreg2 using tables5lden.rtf, append dec(2) pdec(3) ststr(replace coef=coef+"%" if coef~="") stnum(replace coef=(exp(coef)-1)*100, replace ci_low=((exp(ci_low)-1)*100), replace ci_high=((exp(ci_high)-1)*100)) level(95) noaster stats(coef ci pval) keep(air_lden_2cat2011) nocon

* Perform PSM and generate weights for Lvmassindex
psmatch2 air_lden_2cat2011 (sex age ethnic_background_cat n_189 non_mover household_income smoking alcohol time_at_address daysofphyact n_54 road_lden_2cat rail_lden_2cat n_24006_all total_no2_09_all) if hearingdif==0, out(Lvmassindex) neighbor(2)
* Generate weights for Lvmassindex
gen w_Lvmassindex = _weight
* Run the weighted regression for Lvmassindex
glm Lvmassindex air_lden_2cat2011 sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address daysofphyact i.n_54 i.road_lden_2cat i.rail_lden_2cat n_24006_all total_no2_09_all [pw=w_Lvmassindex] if hearingdif==0, vce(cluster airportid) family(gamma) link(log)
* Export regression results for Lvmassindex
outreg2 using tables5lden.rtf, append dec(2) pdec(3) ststr(replace coef=coef+"%" if coef~="") stnum(replace coef=(exp(coef)-1)*100, replace ci_low=((exp(ci_low)-1)*100), replace ci_high=((exp(ci_high)-1)*100)) level(95) noaster stats(coef ci pval) keep(air_lden_2cat2011) nocon

* Perform PSM and generate weights for meanwt
psmatch2 air_lden_2cat2011 (sex age ethnic_background_cat n_189 non_mover household_income smoking alcohol time_at_address daysofphyact n_54 road_lden_2cat rail_lden_2cat n_24006_all total_no2_09_all) if hearingdif==0, out(meanwt) neighbor(2)
* Generate weights for meanwt
gen w_meanwt = _weight
* Run the weighted regression for meanwt
glm meanwt air_lden_2cat2011 sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address daysofphyact i.n_54 i.road_lden_2cat i.rail_lden_2cat n_24006_all total_no2_09_all [pw=w_meanwt] if hearingdif==0, vce(cluster airportid) family(gamma) link(log)
* Export regression results for meanwt
outreg2 using tables5lden.rtf, append dec(2) pdec(3) ststr(replace coef=coef+"%" if coef~="") stnum(replace coef=(exp(coef)-1)*100, replace ci_low=((exp(ci_low)-1)*100), replace ci_high=((exp(ci_high)-1)*100)) level(95) noaster stats(coef ci pval) keep(air_lden_2cat2011) nocon

* Perform PSM and generate weights for maxwt
psmatch2 air_lden_2cat2011 (sex age ethnic_background_cat n_189 non_mover household_income smoking alcohol time_at_address daysofphyact n_54 road_lden_2cat rail_lden_2cat n_24006_all total_no2_09_all) if hearingdif==0, out(maxwt) neighbor(2)
* Generate weights for maxwt
gen w_maxwt = _weight
* Run the weighted regression for maxwt
glm maxwt air_lden_2cat2011 sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address daysofphyact i.n_54 i.road_lden_2cat i.rail_lden_2cat n_24006_all total_no2_09_all [pw=w_maxwt] if hearingdif==0, vce(cluster airportid) family(gamma) link(log)
* Export regression results for maxwt
outreg2 using tables5lden.rtf, append dec(2) pdec(3) ststr(replace coef=coef+"%" if coef~="") stnum(replace coef=(exp(coef)-1)*100, replace ci_low=((exp(ci_low)-1)*100), replace ci_high=((exp(ci_high)-1)*100)) level(95) noaster stats(coef ci pval) keep(air_lden_2cat2011) nocon

* Perform PSM and generate weights for IVS
psmatch2 air_lden_2cat2011 (sex age ethnic_background_cat n_189 non_mover household_income smoking alcohol time_at_address daysofphyact n_54 road_lden_2cat rail_lden_2cat n_24006_all total_no2_09_all) if hearingdif==0, out(IVS) neighbor(2)
* Generate weights for IVS
gen w_IVS = _weight
* Run the weighted regression for IVS
glm IVS air_lden_2cat2011 sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address daysofphyact i.n_54 i.road_lden_2cat i.rail_lden_2cat n_24006_all total_no2_09_all [pw=w_IVS] if hearingdif==0, vce(cluster airportid) family(gamma) link(log)
* Export regression results for IVS
outreg2 using tables5lden.rtf, append dec(2) pdec(3) ststr(replace coef=coef+"%" if coef~="") stnum(replace coef=(exp(coef)-1)*100, replace ci_low=((exp(ci_low)-1)*100), replace ci_high=((exp(ci_high)-1)*100)) level(95) noaster stats(coef ci pval) keep(air_lden_2cat2011) nocon

* Perform PSM and generate weights for PWT
psmatch2 air_lden_2cat2011 (sex age ethnic_background_cat n_189 non_mover household_income smoking alcohol time_at_address daysofphyact n_54 road_lden_2cat rail_lden_2cat n_24006_all total_no2_09_all) if hearingdif==0, out(PWT) neighbor(2)
* Generate weights for PWT
gen w_PWT = _weight
* Run the weighted regression for PWT
glm PWT air_lden_2cat2011 sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address daysofphyact i.n_54 i.road_lden_2cat i.rail_lden_2cat n_24006_all total_no2_09_all [pw=w_PWT] if hearingdif==0, vce(cluster airportid) family(gamma) link(log)
* Export regression results for PWT
outreg2 using tables5lden.rtf, append dec(2) pdec(3) ststr(replace coef=coef+"%" if coef~="") stnum(replace coef=(exp(coef)-1)*100, replace ci_low=((exp(ci_low)-1)*100), replace ci_high=((exp(ci_high)-1)*100)) level(95) noaster stats(coef ci pval) keep(air_lden_2cat2011) nocon

* Perform PSM and generate weights for seplatwr
psmatch2 air_lden_2cat2011 (sex age ethnic_background_cat n_189 non_mover household_income smoking alcohol time_at_address daysofphyact n_54 road_lden_2cat rail_lden_2cat n_24006_all total_no2_09_all) if hearingdif==0, out(seplatwr) neighbor(2)
* Generate weights for seplatwr
gen w_seplatwr = _weight
* Run the weighted regression for seplatwr
glm seplatwr air_lden_2cat2011 sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address daysofphyact i.n_54 i.road_lden_2cat i.rail_lden_2cat n_24006_all total_no2_09_all [pw=w_seplatwr] if hearingdif==0, vce(cluster airportid) family(gamma) link(log)
* Export regression results for seplatwr
outreg2 using tables5lden.rtf, append dec(2) pdec(3) ststr(replace coef=coef+"%" if coef~="") stnum(replace coef=(exp(coef)-1)*100, replace ci_low=((exp(ci_low)-1)*100), replace ci_high=((exp(ci_high)-1)*100)) level(95) noaster stats(coef ci pval) keep(air_lden_2cat2011) nocon

* Perform PSM and generate weights for relwallmass
psmatch2 air_lden_2cat2011 (sex age ethnic_background_cat n_189 non_mover household_income smoking alcohol time_at_address daysofphyact n_54 road_lden_2cat rail_lden_2cat n_24006_all total_no2_09_all) if hearingdif==0, out(relwallmass) neighbor(2)
* Generate weights for relwallmass
gen w_relwallmass = _weight
* Run the weighted regression for relwallmass
glm relwallmass air_lden_2cat2011 sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address daysofphyact i.n_54 i.road_lden_2cat i.rail_lden_2cat n_24006_all total_no2_09_all [pw=w_relwallmass] if hearingdif==0, vce(cluster airportid) family(gamma) link(log)
* Export regression results for relwallmass
outreg2 using tables5lden.rtf, append dec(2) pdec(3) ststr(replace coef=coef+"%" if coef~="") stnum(replace coef=(exp(coef)-1)*100, replace ci_low=((exp(ci_low)-1)*100), replace ci_high=((exp(ci_high)-1)*100)) level(95) noaster stats(coef ci pval) keep(air_lden_2cat2011) nocon

* Perform PSM and generate weights for lvef
psmatch2 air_lden_2cat2011 (sex age ethnic_background_cat n_189 non_mover household_income smoking alcohol time_at_address daysofphyact n_54 road_lden_2cat rail_lden_2cat n_24006_all total_no2_09_all) if hearingdif==0, out(lvef) neighbor(2)
* Generate weights for lvef
gen w_lvef = _weight
* Run the weighted regression for lvef
glm lvef air_lden_2cat2011 sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address daysofphyact i.n_54 i.road_lden_2cat i.rail_lden_2cat n_24006_all total_no2_09_all [pw=w_lvef] if hearingdif==0, vce(cluster airportid) family(gamma) link(log)
* Export regression results for lvef
outreg2 using tables5lden.rtf, append dec(2) pdec(3) ststr(replace coef=coef+"%" if coef~="") stnum(replace coef=(exp(coef)-1)*100, replace ci_low=((exp(ci_low)-1)*100), replace ci_high=((exp(ci_high)-1)*100)) level(95) noaster stats(coef ci pval) keep(air_lden_2cat2011) nocon

* Perform PSM and generate weights for MCF
psmatch2 air_lden_2cat2011 (sex age ethnic_background_cat n_189 non_mover household_income smoking alcohol time_at_address daysofphyact n_54 road_lden_2cat rail_lden_2cat n_24006_all total_no2_09_all) if hearingdif==0, out(MCF) neighbor(2)
* Generate weights for MCF
gen w_MCF = _weight
* Run the weighted regression for MCF
glm MCF air_lden_2cat2011 sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address daysofphyact i.n_54 i.road_lden_2cat i.rail_lden_2cat n_24006_all total_no2_09_all [pw=w_MCF] if hearingdif==0, vce(cluster airportid) family(gamma) link(log)
* Export regression results for MCF
outreg2 using tables5lden.rtf, append dec(2) pdec(3) ststr(replace coef=coef+"%" if coef~="") stnum(replace coef=(exp(coef)-1)*100, replace ci_low=((exp(ci_low)-1)*100), replace ci_high=((exp(ci_high)-1)*100)) level(95) noaster stats(coef ci pval) keep(air_lden_2cat2011) nocon

* Perform PSM and generate weights for circumsgi
psmatch2 air_lden_2cat2011 (sex age ethnic_background_cat n_189 non_mover household_income smoking alcohol time_at_address daysofphyact i.hypertension_meds_0   n_54 road_lden_2cat rail_lden_2cat n_24006_all total_no2_09_all) if hearingdif==0, out(circumsgi) neighbor(2)
* Generate weights for circumsgi
gen w_circumsgi = _weight
* Run the weighted regression for circumsgi
glm circumsgi air_lden_2cat2011 sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address daysofphyact i.hypertension_meds_0   i.n_54 i.road_lden_2cat i.rail_lden_2cat n_24006_all total_no2_09_all [pw=w_circumsgi] if hearingdif==0, vce(cluster airportid) family(gamma) link(log)
* Export regression results for circumsgi
outreg2 using tables5lden.rtf, append dec(2) pdec(3) ststr(replace coef=coef+"%" if coef~="") stnum(replace coef=(exp(coef)-1)*100, replace ci_low=((exp(ci_low)-1)*100), replace ci_high=((exp(ci_high)-1)*100)) level(95) noaster stats(coef ci pval) keep(air_lden_2cat2011) nocon

* Perform PSM and generate weights for circumsbi
psmatch2 air_lden_2cat2011 (sex age ethnic_background_cat n_189 non_mover household_income smoking alcohol time_at_address daysofphyact i.hypertension_meds_0   n_54 road_lden_2cat rail_lden_2cat n_24006_all total_no2_09_all) if hearingdif==0, out(circumsbi) neighbor(2)
* Generate weights for circumsbi
gen w_circumsbi = _weight
* Run the weighted regression for circumsbi
glm circumsbi air_lden_2cat2011 sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address daysofphyact i.hypertension_meds_0   i.n_54 i.road_lden_2cat i.rail_lden_2cat n_24006_all total_no2_09_all [pw=w_circumsbi] if hearingdif==0, vce(cluster airportid) family(gamma) link(log)
* Export regression results for circumsbi
outreg2 using tables5lden.rtf, append dec(2) pdec(3) ststr(replace coef=coef+"%" if coef~="") stnum(replace coef=(exp(coef)-1)*100, replace ci_low=((exp(ci_low)-1)*100), replace ci_high=((exp(ci_high)-1)*100)) level(95) noaster stats(coef ci pval) keep(air_lden_2cat2011) nocon

* Perform PSM and generate weights for circumsmi
psmatch2 air_lden_2cat2011 (sex age ethnic_background_cat n_189 non_mover household_income smoking alcohol time_at_address daysofphyact i.hypertension_meds_0   n_54 road_lden_2cat rail_lden_2cat n_24006_all total_no2_09_all) if hearingdif==0, out(circumsmi) neighbor(2)
* Generate weights for circumsmi
gen w_circumsmi = _weight
* Run the weighted regression for circumsmi
glm circumsmi air_lden_2cat2011 sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address daysofphyact i.hypertension_meds_0   i.n_54 i.road_lden_2cat i.rail_lden_2cat n_24006_all total_no2_09_all [pw=w_circumsmi] if hearingdif==0, vce(cluster airportid) family(gamma) link(log)
* Export regression results for circumsmi
outreg2 using tables5lden.rtf, append dec(2) pdec(3) ststr(replace coef=coef+"%" if coef~="") stnum(replace coef=(exp(coef)-1)*100, replace ci_low=((exp(ci_low)-1)*100), replace ci_high=((exp(ci_high)-1)*100)) level(95) noaster stats(coef ci pval) keep(air_lden_2cat2011) nocon

* Perform PSM and generate weights for circumsai
psmatch2 air_lden_2cat2011 (sex age ethnic_background_cat n_189 non_mover household_income smoking alcohol time_at_address daysofphyact i.hypertension_meds_0   n_54 road_lden_2cat rail_lden_2cat n_24006_all total_no2_09_all) if hearingdif==0, out(circumsai) neighbor(2)
* Generate weights for circumsai
gen w_circumsai = _weight
* Run the weighted regression for circumsai
glm circumsai air_lden_2cat2011 sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address daysofphyact i.hypertension_meds_0   i.n_54 i.road_lden_2cat i.rail_lden_2cat n_24006_all total_no2_09_all [pw=w_circumsai] if hearingdif==0, vce(cluster airportid) family(gamma) link(log)
* Export regression results for circumsai
outreg2 using tables5lden.rtf, append dec(2) pdec(3) ststr(replace coef=coef+"%" if coef~="") stnum(replace coef=(exp(coef)-1)*100, replace ci_low=((exp(ci_low)-1)*100), replace ci_high=((exp(ci_high)-1)*100)) level(95) noaster stats(coef ci pval) keep(air_lden_2cat2011) nocon

* Perform PSM and generate weights for radialsgi
psmatch2 air_lden_2cat2011 (sex age ethnic_background_cat n_189 non_mover household_income smoking alcohol time_at_address daysofphyact i.hypertension_meds_0   n_54 road_lden_2cat rail_lden_2cat n_24006_all total_no2_09_all) if hearingdif==0, out(radialsgi) neighbor(2)
* Generate weights for radialsgi
gen w_radialsgi = _weight
* Run the weighted regression for radialsgi
glm radialsgi air_lden_2cat2011 sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address daysofphyact i.hypertension_meds_0   i.n_54 i.road_lden_2cat i.rail_lden_2cat n_24006_all total_no2_09_all [pw=w_radialsgi] if hearingdif==0, vce(cluster airportid) family(gamma) link(log)
* Export regression results for radialsgi
outreg2 using tables5lden.rtf, append dec(2) pdec(3) ststr(replace coef=coef+"%" if coef~="") stnum(replace coef=(exp(coef)-1)*100, replace ci_low=((exp(ci_low)-1)*100), replace ci_high=((exp(ci_high)-1)*100)) level(95) noaster stats(coef ci pval) keep(air_lden_2cat2011) nocon

* Perform PSM and generate weights for radialsbi
psmatch2 air_lden_2cat2011 (sex age ethnic_background_cat n_189 non_mover household_income smoking alcohol time_at_address daysofphyact i.hypertension_meds_0   n_54 road_lden_2cat rail_lden_2cat n_24006_all total_no2_09_all) if hearingdif==0, out(radialsbi) neighbor(2)
* Generate weights for radialsbi
gen w_radialsbi = _weight
* Run the weighted regression for radialsbi
glm radialsbi air_lden_2cat2011 sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address daysofphyact i.hypertension_meds_0   i.n_54 i.road_lden_2cat i.rail_lden_2cat n_24006_all total_no2_09_all [pw=w_radialsbi] if hearingdif==0, vce(cluster airportid) family(gamma) link(log)
* Export regression results for radialsbi
outreg2 using tables5lden.rtf, append dec(2) pdec(3) ststr(replace coef=coef+"%" if coef~="") stnum(replace coef=(exp(coef)-1)*100, replace ci_low=((exp(ci_low)-1)*100), replace ci_high=((exp(ci_high)-1)*100)) level(95) noaster stats(coef ci pval) keep(air_lden_2cat2011) nocon

* Perform PSM and generate weights for radialsmi
psmatch2 air_lden_2cat2011 (sex age ethnic_background_cat n_189 non_mover household_income smoking alcohol time_at_address daysofphyact i.hypertension_meds_0   n_54 road_lden_2cat rail_lden_2cat n_24006_all total_no2_09_all) if hearingdif==0, out(radialsmi) neighbor(2)
* Generate weights for radialsmi
gen w_radialsmi = _weight
* Run the weighted regression for radialsmi
glm radialsmi air_lden_2cat2011 sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address daysofphyact i.hypertension_meds_0   i.n_54 i.road_lden_2cat i.rail_lden_2cat n_24006_all total_no2_09_all [pw=w_radialsmi] if hearingdif==0, vce(cluster airportid) family(gamma) link(log)
* Export regression results for radialsmi
outreg2 using tables5lden.rtf, append dec(2) pdec(3) ststr(replace coef=coef+"%" if coef~="") stnum(replace coef=(exp(coef)-1)*100, replace ci_low=((exp(ci_low)-1)*100), replace ci_high=((exp(ci_high)-1)*100)) level(95) noaster stats(coef ci pval) keep(air_lden_2cat2011) nocon

* Perform PSM and generate weights for radialsai
psmatch2 air_lden_2cat2011 (sex age ethnic_background_cat n_189 non_mover household_income smoking alcohol time_at_address daysofphyact i.hypertension_meds_0   n_54 road_lden_2cat rail_lden_2cat n_24006_all total_no2_09_all) if hearingdif==0, out(radialsai) neighbor(2)
* Generate weights for radialsai
gen w_radialsai = _weight
* Run the weighted regression for radialsai
glm radialsai air_lden_2cat2011 sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address daysofphyact i.hypertension_meds_0   i.n_54 i.road_lden_2cat i.rail_lden_2cat n_24006_all total_no2_09_all [pw=w_radialsai] if hearingdif==0, vce(cluster airportid) family(gamma) link(log)
* Export regression results for radialsai
outreg2 using tables5lden.rtf, append dec(2) pdec(3) ststr(replace coef=coef+"%" if coef~="") stnum(replace coef=(exp(coef)-1)*100, replace ci_low=((exp(ci_low)-1)*100), replace ci_high=((exp(ci_high)-1)*100)) level(95) noaster stats(coef ci pval) keep(air_lden_2cat2011) nocon

* Perform PSM and generate weights for longisgi
psmatch2 air_lden_2cat2011 (sex age ethnic_background_cat n_189 non_mover household_income smoking alcohol time_at_address daysofphyact i.hypertension_meds_0   n_54 road_lden_2cat rail_lden_2cat n_24006_all total_no2_09_all) if hearingdif==0, out(longisgi) neighbor(2)
* Generate weights for longisgi
gen w_longisgi = _weight
* Run the weighted regression for longisgi
glm longisgi air_lden_2cat2011 sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address daysofphyact i.hypertension_meds_0  i.n_54 i.road_lden_2cat i.rail_lden_2cat n_24006_all total_no2_09_all [pw=w_longisgi] if hearingdif==0, vce(cluster airportid) family(gamma) link(log)
* Export regression results for longisgi
outreg2 using tables5lden.rtf, append dec(2) pdec(3) ststr(replace coef=coef+"%" if coef~="") stnum(replace coef=(exp(coef)-1)*100, replace ci_low=((exp(ci_low)-1)*100), replace ci_high=((exp(ci_high)-1)*100)) level(95) noaster stats(coef ci pval) keep(air_lden_2cat2011) nocon

* Perform PSM and generate weights for longisbi
psmatch2 air_lden_2cat2011 (sex age ethnic_background_cat n_189 non_mover household_income smoking alcohol time_at_address daysofphyact i.hypertension_meds_0   n_54 road_lden_2cat rail_lden_2cat n_24006_all total_no2_09_all) if hearingdif==0, out(longisbi) neighbor(2)
* Generate weights for longisbi
gen w_longisbi = _weight
* Run the weighted regression for longisbi
glm longisbi air_lden_2cat2011 sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address daysofphyact i.hypertension_meds_0  i.n_54 i.road_lden_2cat i.rail_lden_2cat n_24006_all total_no2_09_all [pw=w_longisbi] if hearingdif==0, vce(cluster airportid) family(gamma) link(log)
* Export regression results for longisbi
outreg2 using tables5lden.rtf, append dec(2) pdec(3) ststr(replace coef=coef+"%" if coef~="") stnum(replace coef=(exp(coef)-1)*100, replace ci_low=((exp(ci_low)-1)*100), replace ci_high=((exp(ci_high)-1)*100)) level(95) noaster stats(coef ci pval) keep(air_lden_2cat2011) nocon


* Supplementary Table S6-S10



* Table S6 (Abdominal subcutaneous adipose tissue volume (ASAT))




* lnight 


local variables "LVEDVindex LVESVindex Myovolume Lvmassindex meanwt maxwt IVS PWT lvef MCF "

foreach var of local variables {
    * Perform the mediation analysis
    mediate (`var' sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address  daysofphyact   i.n_54   i.road_lnight_2cat i.rail_lnight_2cat n_24006_all total_no2_09_all, expmean) ( n_22408_2_0 sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address  daysofphyact    i.n_54  i.road_lnight_2cat i.rail_lnight_2cat n_24006_all total_no2_09_all, linear) (air_lnight_2cat2011) , vce(cluster airportid)

    * Save the coefficients to Excel
    putexcel set mediate_coeflnightasat.xlsx, sheet("`var'") modify
    putexcel A1=matrix(r(table))

    * Calculate and save the proportion mediated
    estat proportion, force
    putexcel set mediate_prolnightasat.xlsx, sheet("`var'") modify
    putexcel A1=matrix(r(table))
}


local variables "circumsgi radialsgi longisgi"

foreach var of local variables {
    * Perform the mediation analysis
    mediate (`var' sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address  daysofphyact  i.hypertension_meds_0  i.n_54   i.road_lnight_2cat i.rail_lnight_2cat n_24006_all total_no2_09_all, expmean) ( n_22408_2_0 sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address  daysofphyact i.hypertension_meds_0    i.n_54  i.road_lnight_2cat i.rail_lnight_2cat n_24006_all total_no2_09_all, linear) (air_lnight_2cat2011) , vce(cluster airportid)

    * Save the coefficients to Excel
    putexcel set mediate_coeflnightasat.xlsx, sheet("`var'") modify
    putexcel A1=matrix(r(table))

    * Calculate and save the proportion mediated
    estat proportion, force
    putexcel set mediate_prolnightasat.xlsx, sheet("`var'") modify
    putexcel A1=matrix(r(table))
}




* lden 


local variables "LVEDVindex LVESVindex Myovolume Lvmassindex meanwt maxwt IVS PWT lvef MCF"

foreach var of local variables {
    * Perform the mediation analysis
    mediate (`var' sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address  daysofphyact  i.n_54   i.road_lden_2cat i.rail_lden_2cat n_24006_all total_no2_09_all, expmean) ( n_22408_2_0 sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address  daysofphyact   i.n_54  i.road_lden_2cat i.rail_lden_2cat n_24006_all total_no2_09_all, linear) (air_lden_2cat2011) , vce(cluster airportid)
   

    * Save the coefficients to Excel
    putexcel set mediate_coefldenasat.xlsx, sheet("`var'") modify
    putexcel A1=matrix(r(table))

    * Calculate and save the proportion mediated
    estat proportion, force
    putexcel set mediate_proldenasat.xlsx, sheet("`var'") modify
    putexcel A1=matrix(r(table))
}




local variables "circumsgi radialsgi longisgi"

foreach var of local variables {
    * Perform the mediation analysis
    mediate (`var' sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address  daysofphyact i.hypertension_meds_0  i.n_54   i.road_lden_2cat i.rail_lden_2cat n_24006_all total_no2_09_all, expmean) ( n_22408_2_0 sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address  daysofphyact i.hypertension_meds_0  i.n_54  i.road_lden_2cat i.rail_lden_2cat n_24006_all total_no2_09_all, linear) (air_lden_2cat2011) , vce(cluster airportid)
   

    * Save the coefficients to Excel
    putexcel set mediate_coefldenasat.xlsx, sheet("`var'") modify
    putexcel A1=matrix(r(table))

    * Calculate and save the proportion mediated
    estat proportion, force
    putexcel set mediate_proldenasat.xlsx, sheet("`var'") modify
    putexcel A1=matrix(r(table))
}




* Table S7 (Total trunk fat volume)




* lnight 


local variables "LVEDVindex LVESVindex Myovolume Lvmassindex meanwt maxwt IVS PWT lvef MCF "

foreach var of local variables {
    * Perform the mediation analysis
    mediate (`var' sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address  daysofphyact   i.n_54   i.road_lnight_2cat i.rail_lnight_2cat n_24006_all total_no2_09_all, expmean) ( n_22410_2_0 sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address  daysofphyact    i.n_54  i.road_lnight_2cat i.rail_lnight_2cat n_24006_all total_no2_09_all, linear) (air_lnight_2cat2011) , vce(cluster airportid)

    * Save the coefficients to Excel
    putexcel set mediate_coeflnighttruck.xlsx, sheet("`var'") modify
    putexcel A1=matrix(r(table))

    * Calculate and save the proportion mediated
    estat proportion, force
    putexcel set mediate_prolnighttruck.xlsx, sheet("`var'") modify
    putexcel A1=matrix(r(table))
}


local variables "circumsgi radialsgi longisgi"

foreach var of local variables {
    * Perform the mediation analysis
    mediate (`var' sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address  daysofphyact  i.hypertension_meds_0  i.n_54   i.road_lnight_2cat i.rail_lnight_2cat n_24006_all total_no2_09_all, expmean) ( n_22410_2_0 sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address  daysofphyact i.hypertension_meds_0    i.n_54  i.road_lnight_2cat i.rail_lnight_2cat n_24006_all total_no2_09_all, linear) (air_lnight_2cat2011) , vce(cluster airportid)

    * Save the coefficients to Excel
    putexcel set mediate_coeflnighttruck.xlsx, sheet("`var'") modify
    putexcel A1=matrix(r(table))

    * Calculate and save the proportion mediated
    estat proportion, force
    putexcel set mediate_prolnighttruck.xlsx, sheet("`var'") modify
    putexcel A1=matrix(r(table))
}




* lden 


local variables "LVEDVindex LVESVindex Myovolume Lvmassindex meanwt maxwt IVS PWT lvef MCF"

foreach var of local variables {
    * Perform the mediation analysis
    mediate (`var' sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address  daysofphyact  i.n_54   i.road_lden_2cat i.rail_lden_2cat n_24006_all total_no2_09_all, expmean) ( n_22410_2_0 sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address  daysofphyact   i.n_54  i.road_lden_2cat i.rail_lden_2cat n_24006_all total_no2_09_all, linear) (air_lden_2cat2011) , vce(cluster airportid)
   

    * Save the coefficients to Excel
    putexcel set mediate_coefldentruck.xlsx, sheet("`var'") modify
    putexcel A1=matrix(r(table))

    * Calculate and save the proportion mediated
    estat proportion, force
    putexcel set mediate_proldentruck.xlsx, sheet("`var'") modify
    putexcel A1=matrix(r(table))
}




local variables "circumsgi radialsgi longisgi"

foreach var of local variables {
    * Perform the mediation analysis
    mediate (`var' sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address  daysofphyact i.hypertension_meds_0  i.n_54   i.road_lden_2cat i.rail_lden_2cat n_24006_all total_no2_09_all, expmean) ( n_22410_2_0 sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address  daysofphyact i.hypertension_meds_0  i.n_54  i.road_lden_2cat i.rail_lden_2cat n_24006_all total_no2_09_all, linear) (air_lden_2cat2011) , vce(cluster airportid)
   

    * Save the coefficients to Excel
    putexcel set mediate_coefldentruck.xlsx, sheet("`var'") modify
    putexcel A1=matrix(r(table))

    * Calculate and save the proportion mediated
    estat proportion, force
    putexcel set mediate_proldentruck.xlsx, sheet("`var'") modify
    putexcel A1=matrix(r(table))
}





* Table S8 (Visceral adipose tissue volume (VAT))




* lnight 


local variables "LVEDVindex LVESVindex Myovolume Lvmassindex meanwt maxwt IVS PWT lvef MCF "

foreach var of local variables {
    * Perform the mediation analysis
    mediate (`var' sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address  daysofphyact   i.n_54   i.road_lnight_2cat i.rail_lnight_2cat n_24006_all total_no2_09_all, expmean) ( n_22407_2_0 sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address  daysofphyact    i.n_54  i.road_lnight_2cat i.rail_lnight_2cat n_24006_all total_no2_09_all, linear) (air_lnight_2cat2011) , vce(cluster airportid)

    * Save the coefficients to Excel
    putexcel set mediate_coeflnightvat.xlsx, sheet("`var'") modify
    putexcel A1=matrix(r(table))

    * Calculate and save the proportion mediated
    estat proportion, force
    putexcel set mediate_prolnightvat.xlsx, sheet("`var'") modify
    putexcel A1=matrix(r(table))
}


local variables "circumsgi radialsgi longisgi"

foreach var of local variables {
    * Perform the mediation analysis
    mediate (`var' sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address  daysofphyact  i.hypertension_meds_0  i.n_54   i.road_lnight_2cat i.rail_lnight_2cat n_24006_all total_no2_09_all, expmean) ( n_22407_2_0 sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address  daysofphyact i.hypertension_meds_0    i.n_54  i.road_lnight_2cat i.rail_lnight_2cat n_24006_all total_no2_09_all, linear) (air_lnight_2cat2011) , vce(cluster airportid)

    * Save the coefficients to Excel
    putexcel set mediate_coeflnightvat.xlsx, sheet("`var'") modify
    putexcel A1=matrix(r(table))

    * Calculate and save the proportion mediated
    estat proportion, force
    putexcel set mediate_prolnightvat.xlsx, sheet("`var'") modify
    putexcel A1=matrix(r(table))
}




* lden 


local variables "LVEDVindex LVESVindex Myovolume Lvmassindex meanwt maxwt IVS PWT lvef MCF"

foreach var of local variables {
    * Perform the mediation analysis
    mediate (`var' sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address  daysofphyact  i.n_54   i.road_lden_2cat i.rail_lden_2cat n_24006_all total_no2_09_all, expmean) ( n_22407_2_0 sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address  daysofphyact   i.n_54  i.road_lden_2cat i.rail_lden_2cat n_24006_all total_no2_09_all, linear) (air_lden_2cat2011) , vce(cluster airportid)
   

    * Save the coefficients to Excel
    putexcel set mediate_coefldenvat.xlsx, sheet("`var'") modify
    putexcel A1=matrix(r(table))

    * Calculate and save the proportion mediated
    estat proportion, force
    putexcel set mediate_proldenvat.xlsx, sheet("`var'") modify
    putexcel A1=matrix(r(table))
}




local variables "circumsgi radialsgi longisgi"

foreach var of local variables {
    * Perform the mediation analysis
    mediate (`var' sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address  daysofphyact i.hypertension_meds_0  i.n_54   i.road_lden_2cat i.rail_lden_2cat n_24006_all total_no2_09_all, expmean) ( n_22407_2_0 sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address  daysofphyact i.hypertension_meds_0  i.n_54  i.road_lden_2cat i.rail_lden_2cat n_24006_all total_no2_09_all, linear) (air_lden_2cat2011) , vce(cluster airportid)
   

    * Save the coefficients to Excel
    putexcel set mediate_coefldenvat.xlsx, sheet("`var'") modify
    putexcel A1=matrix(r(table))

    * Calculate and save the proportion mediated
    estat proportion, force
    putexcel set mediate_proldenvat.xlsx, sheet("`var'") modify
    putexcel A1=matrix(r(table))
}



* Table S9 (Hypertension)




* lnight 


local variables "LVEDVindex LVESVindex Myovolume Lvmassindex meanwt maxwt IVS PWT lvef MCF "

foreach var of local variables {
    * Perform the mediation analysis
    mediate (`var' sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address  daysofphyact   i.n_54   i.road_lnight_2cat i.rail_lnight_2cat n_24006_all total_no2_09_all, expmean) ( hypertension_combined sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address  daysofphyact    i.n_54  i.road_lnight_2cat i.rail_lnight_2cat n_24006_all total_no2_09_all, linear) (air_lnight_2cat2011) , vce(cluster airportid)

    * Save the coefficients to Excel
    putexcel set mediate_coeflnighthyper.xlsx, sheet("`var'") modify
    putexcel A1=matrix(r(table))

    * Calculate and save the proportion mediated
    estat proportion, force
    putexcel set mediate_prolnighthyper.xlsx, sheet("`var'") modify
    putexcel A1=matrix(r(table))
}


local variables "circumsgi radialsgi longisgi"

foreach var of local variables {
    * Perform the mediation analysis
    mediate (`var' sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address  daysofphyact  i.hypertension_meds_0  i.n_54   i.road_lnight_2cat i.rail_lnight_2cat n_24006_all total_no2_09_all, expmean) ( hypertension_combined sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address  daysofphyact i.hypertension_meds_0    i.n_54  i.road_lnight_2cat i.rail_lnight_2cat n_24006_all total_no2_09_all, linear) (air_lnight_2cat2011) , vce(cluster airportid)

    * Save the coefficients to Excel
    putexcel set mediate_coeflnighthyper.xlsx, sheet("`var'") modify
    putexcel A1=matrix(r(table))

    * Calculate and save the proportion mediated
    estat proportion, force
    putexcel set mediate_prolnighthyper.xlsx, sheet("`var'") modify
    putexcel A1=matrix(r(table))
}




* lden 


local variables "LVEDVindex LVESVindex Myovolume Lvmassindex meanwt maxwt IVS PWT lvef MCF"

foreach var of local variables {
    * Perform the mediation analysis
    mediate (`var' sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address  daysofphyact  i.n_54   i.road_lden_2cat i.rail_lden_2cat n_24006_all total_no2_09_all, expmean) ( hypertension_combined sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address  daysofphyact   i.n_54  i.road_lden_2cat i.rail_lden_2cat n_24006_all total_no2_09_all, linear) (air_lden_2cat2011) , vce(cluster airportid)
   

    * Save the coefficients to Excel
    putexcel set mediate_coefldenhyper.xlsx, sheet("`var'") modify
    putexcel A1=matrix(r(table))

    * Calculate and save the proportion mediated
    estat proportion, force
    putexcel set mediate_proldenhyper.xlsx, sheet("`var'") modify
    putexcel A1=matrix(r(table))
}




local variables "circumsgi radialsgi longisgi"

foreach var of local variables {
    * Perform the mediation analysis
    mediate (`var' sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address  daysofphyact i.hypertension_meds_0  i.n_54   i.road_lden_2cat i.rail_lden_2cat n_24006_all total_no2_09_all, expmean) ( hypertension_combined sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address  daysofphyact i.hypertension_meds_0  i.n_54  i.road_lden_2cat i.rail_lden_2cat n_24006_all total_no2_09_all, linear) (air_lden_2cat2011) , vce(cluster airportid)
   

    * Save the coefficients to Excel
    putexcel set mediate_coefldenhyper.xlsx, sheet("`var'") modify
    putexcel A1=matrix(r(table))

    * Calculate and save the proportion mediated
    estat proportion, force
    putexcel set mediate_proldenhyper.xlsx, sheet("`var'") modify
    putexcel A1=matrix(r(table))
}



* Table S10 (High cholesterol)


* lnight 




* lnight 


local variables "LVEDVindex LVESVindex Myovolume Lvmassindex meanwt maxwt IVS PWT lvef MCF "

foreach var of local variables {
    * Perform the mediation analysis
    mediate (`var' sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address  daysofphyact   i.n_54   i.road_lnight_2cat i.rail_lnight_2cat n_24006_all total_no2_09_all, expmean) ( high_cholesterol sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address  daysofphyact    i.n_54  i.road_lnight_2cat i.rail_lnight_2cat n_24006_all total_no2_09_all, linear) (air_lnight_2cat2011) , vce(cluster airportid)

    * Save the coefficients to Excel
    putexcel se-+t mediate_coeflnightcho.xlsx, sheet("`var'") modify
    putexcel A1=matrix(r(table))

    * Calculate and save the proportion mediated
    estat proportion, force
    putexcel set mediate_prolnightcho.xlsx, sheet("`var'") modify
    putexcel A1=matrix(r(table))
}


local variables "circumsgi radialsgi longisgi"

foreach var of local variables {
    * Perform the mediation analysis
    mediate (`var' sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address  daysofphyact  i.hypertension_meds_0  i.n_54   i.road_lnight_2cat i.rail_lnight_2cat n_24006_all total_no2_09_all, expmean) ( high_cholesterol sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address  daysofphyact i.hypertension_meds_0    i.n_54  i.road_lnight_2cat i.rail_lnight_2cat n_24006_all total_no2_09_all, linear) (air_lnight_2cat2011) , vce(cluster airportid)

    * Save the coefficients to Excel
    putexcel set mediate_coeflnightcho.xlsx, sheet("`var'") modify
    putexcel A1=matrix(r(table))

    * Calculate and save the proportion mediated
    estat proportion, force
    putexcel set mediate_prolnightcho.xlsx, sheet("`var'") modify
    putexcel A1=matrix(r(table))
}




* lden 


local variables "LVEDVindex LVESVindex Myovolume Lvmassindex meanwt maxwt IVS PWT lvef MCF"

foreach var of local variables {
    * Perform the mediation analysis
    mediate (`var' sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address  daysofphyact  i.n_54   i.road_lden_2cat i.rail_lden_2cat n_24006_all total_no2_09_all, expmean) ( high_cholesterol sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address  daysofphyact   i.n_54  i.road_lden_2cat i.rail_lden_2cat n_24006_all total_no2_09_all, linear) (air_lden_2cat2011) , vce(cluster airportid)
   

    * Save the coefficients to Excel
    putexcel set mediate_coefldencho.xlsx, sheet("`var'") modify
    putexcel A1=matrix(r(table))

    * Calculate and save the proportion mediated
    estat proportion, force
    putexcel set mediate_proldencho.xlsx, sheet("`var'") modify
    putexcel A1=matrix(r(table))
}




local variables "circumsgi radialsgi longisgi"

foreach var of local variables {
    * Perform the mediation analysis
    mediate (`var' sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address  daysofphyact i.hypertension_meds_0  i.n_54   i.road_lden_2cat i.rail_lden_2cat n_24006_all total_no2_09_all, expmean) ( high_cholesterol sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address  daysofphyact i.hypertension_meds_0  i.n_54  i.road_lden_2cat i.rail_lden_2cat n_24006_all total_no2_09_all, linear) (air_lden_2cat2011) , vce(cluster airportid)
   

    * Save the coefficients to Excel
    putexcel set mediate_coefldencho.xlsx, sheet("`var'") modify
    putexcel A1=matrix(r(table))

    * Calculate and save the proportion mediated
    estat proportion, force
    putexcel set mediate_proldencho.xlsx, sheet("`var'") modify
    putexcel A1=matrix(r(table))
}




* Supplementary Table S11 . Percentage differences in CMR strain metrics between those exposed and unexposed to higher aircraft noise levels.

* Model 2 (Model 2 was additionally adjusted for the presence of diabetes (beyond model 1))





local outcomes LVEDVindex LVESVindex Myovolume Lvmassindex meanwt maxwt IVS PWT seplatwr relwallmass lvef MCF 

local first = 1

foreach outcome in `outcomes' {
    glm `outcome' i.air_lnight_2cat2011 sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address daysofphyact i.diabetes i.n_54 i.road_lnight_2cat i.rail_lnight_2cat n_24006_all total_no2_09_all, vce(cluster airportid) family(gamma) link(log)
    
    if `first' {
        outreg2 using tables11m2lnight.rtf, replace dec(2) pdec(3) ststr(replace coef=coef+"%" if coef~="") stnum(replace coef=(exp(coef)-1)*100, replace ci_low=((exp(ci_low)-1)*100), replace ci_high=((exp(ci_high)-1)*100)) level(95) noaster stats(coef ci pval) keep(i.air_lnight_2cat2011) nocon
        local first = 0
    }
    else {
        outreg2 using tables11m2lnight.rtf, append dec(2) pdec(3) ststr(replace coef=coef+"%" if coef~="") stnum(replace coef=(exp(coef)-1)*100, replace ci_low=((exp(ci_low)-1)*100), replace ci_high=((exp(ci_high)-1)*100)) level(95) noaster stats(coef ci pval) keep(i.air_lnight_2cat2011) nocon
    }
}

local outcomes LVEDVindex LVESVindex Myovolume Lvmassindex meanwt maxwt IVS PWT seplatwr relwallmass lvef MCF 

local first = 1

foreach outcome in `outcomes' {
    glm `outcome' i.air_lden_2cat2011 sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address daysofphyact i.diabetes i.n_54 i.road_lden_2cat i.rail_lden_2cat n_24006_all total_no2_09_all, vce(cluster airportid) family(gamma) link(log)
    
    if `first' {
        outreg2 using tables11m2lden.rtf, replace dec(2) pdec(3) ststr(replace coef=coef+"%" if coef~="") stnum(replace coef=(exp(coef)-1)*100, replace ci_low=((exp(ci_low)-1)*100), replace ci_high=((exp(ci_high)-1)*100)) level(95) noaster stats(coef ci pval) keep(i.air_lden_2cat2011) nocon
        local first = 0
    }
    else {
        outreg2 using tables11m2lden.rtf, append dec(2) pdec(3) ststr(replace coef=coef+"%" if coef~="") stnum(replace coef=(exp(coef)-1)*100, replace ci_low=((exp(ci_low)-1)*100), replace ci_high=((exp(ci_high)-1)*100)) level(95) noaster stats(coef ci pval) keep(i.air_lden_2cat2011) nocon
    }
}



local outcomes circumsgi circumsbi circumsmi circumsai radialsgi radialsbi radialsmi radialsai longisgi longisbi

local first = 1

foreach outcome in `outcomes' {
    glm `outcome' i.air_lnight_2cat2011 sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address daysofphyact i.diabetes i.hypertension_meds_0 i.n_54 i.road_lnight_2cat i.rail_lnight_2cat n_24006_all total_no2_09_all, vce(cluster airportid) family(gamma) link(log)
    
    if `first' {
        outreg2 using tables11m2strainlnight.rtf, replace dec(2) pdec(3) ststr(replace coef=coef+"%" if coef~="") stnum(replace coef=(exp(coef)-1)*100, replace ci_low=((exp(ci_low)-1)*100), replace ci_high=((exp(ci_high)-1)*100)) level(95) noaster stats(coef ci pval) keep(i.air_lnight_2cat2011) nocon
        local first = 0
    }
    else {
        outreg2 using tables11m2strainlnight.rtf, append dec(2) pdec(3) ststr(replace coef=coef+"%" if coef~="") stnum(replace coef=(exp(coef)-1)*100, replace ci_low=((exp(ci_low)-1)*100), replace ci_high=((exp(ci_high)-1)*100)) level(95) noaster stats(coef ci pval) keep(i.air_lnight_2cat2011) nocon
    }
}

local outcomes circumsgi circumsbi circumsmi circumsai radialsgi radialsbi radialsmi radialsai longisgi longisbi

local first = 1

foreach outcome in `outcomes' {
    glm `outcome' i.air_lden_2cat2011 sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address daysofphyact i.diabetes i.hypertension_meds_0 i.n_54 i.road_lden_2cat i.rail_lden_2cat n_24006_all total_no2_09_all, vce(cluster airportid) family(gamma) link(log)
    
    if `first' {
        outreg2 using tables11m2strainlden.rtf, replace dec(2) pdec(3) ststr(replace coef=coef+"%" if coef~="") stnum(replace coef=(exp(coef)-1)*100, replace ci_low=((exp(ci_low)-1)*100), replace ci_high=((exp(ci_high)-1)*100)) level(95) noaster stats(coef ci pval) keep(i.air_lden_2cat2011) nocon
        local first = 0
    }
    else {
        outreg2 using tables11m2strainlden.rtf, append dec(2) pdec(3) ststr(replace coef=coef+"%" if coef~="") stnum(replace coef=(exp(coef)-1)*100, replace ci_low=((exp(ci_low)-1)*100), replace ci_high=((exp(ci_high)-1)*100)) level(95) noaster stats(coef ci pval) keep(i.air_lden_2cat2011) nocon
    }
}




* Model 3 (Model 3 was additionally adjusted for the presence of cardiovascular disease (beyond model 1))



local outcomes LVEDVindex LVESVindex Myovolume Lvmassindex meanwt maxwt IVS PWT seplatwr relwallmass lvef MCF

local first = 1

foreach outcome in `outcomes' {
    glm `outcome' i.air_lnight_2cat2011 sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address daysofphyact i.CVD i.n_54 i.road_lnight_2cat i.rail_lnight_2cat n_24006_all total_no2_09_all, vce(cluster airportid) family(gamma) link(log)
   
    if `first' {
        outreg2 using tables11m3lnight.rtf, replace dec(2) pdec(3) ststr(replace coef=coef+"%" if coef~="") stnum(replace coef=(exp(coef)-1)*100, replace ci_low=((exp(ci_low)-1)*100), replace ci_high=((exp(ci_high)-1)*100)) level(95) noaster stats(coef ci pval) keep(i.air_lnight_2cat2011) nocon
        local first = 0
    }
    else {
        outreg2 using tables11m3lnight.rtf, append dec(2) pdec(3) ststr(replace coef=coef+"%" if coef~="") stnum(replace coef=(exp(coef)-1)*100, replace ci_low=((exp(ci_low)-1)*100), replace ci_high=((exp(ci_high)-1)*100)) level(95) noaster stats(coef ci pval) keep(i.air_lnight_2cat2011) nocon
    }
}

local outcomes LVEDVindex LVESVindex Myovolume Lvmassindex meanwt maxwt IVS PWT seplatwr relwallmass lvef MCF

local first = 1

foreach outcome in `outcomes' {
    glm `outcome' i.air_lden_2cat2011 sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address daysofphyact i.CVD i.n_54 i.road_lden_2cat i.rail_lden_2cat n_24006_all total_no2_09_all, vce(cluster airportid) family(gamma) link(log)
   
    if `first' {
        outreg2 using tables11m3lden.rtf, replace dec(2) pdec(3) ststr(replace coef=coef+"%" if coef~="") stnum(replace coef=(exp(coef)-1)*100, replace ci_low=((exp(ci_low)-1)*100), replace ci_high=((exp(ci_high)-1)*100)) level(95) noaster stats(coef ci pval) keep(i.air_lden_2cat2011) nocon
        local first = 0
    }
    else {
        outreg2 using tables11m3lden.rtf, append dec(2) pdec(3) ststr(replace coef=coef+"%" if coef~="") stnum(replace coef=(exp(coef)-1)*100, replace ci_low=((exp(ci_low)-1)*100), replace ci_high=((exp(ci_high)-1)*100)) level(95) noaster stats(coef ci pval) keep(i.air_lden_2cat2011) nocon
    }
}



local outcomes circumsgi circumsbi circumsmi circumsai radialsgi radialsbi radialsmi radialsai longisgi longisbi

local first = 1

foreach outcome in `outcomes' {
    glm `outcome' i.air_lnight_2cat2011 sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address daysofphyact i.CVD i.hypertension_meds_0 i.n_54 i.road_lnight_2cat i.rail_lnight_2cat n_24006_all total_no2_09_all, vce(cluster airportid) family(gamma) link(log)
   
    if `first' {
        outreg2 using tables11m3strainlnight.rtf, replace dec(2) pdec(3) ststr(replace coef=coef+"%" if coef~="") stnum(replace coef=(exp(coef)-1)*100, replace ci_low=((exp(ci_low)-1)*100), replace ci_high=((exp(ci_high)-1)*100)) level(95) noaster stats(coef ci pval) keep(i.air_lnight_2cat2011) nocon
        local first = 0
    }
    else {
        outreg2 using tables11m3strainlnight.rtf, append dec(2) pdec(3) ststr(replace coef=coef+"%" if coef~="") stnum(replace coef=(exp(coef)-1)*100, replace ci_low=((exp(ci_low)-1)*100), replace ci_high=((exp(ci_high)-1)*100)) level(95) noaster stats(coef ci pval) keep(i.air_lnight_2cat2011) nocon
    }
}

local outcomes circumsgi circumsbi circumsmi circumsai radialsgi radialsbi radialsmi radialsai longisgi longisbi

local first = 1

foreach outcome in `outcomes' {
    glm `outcome' i.air_lden_2cat2011 sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address daysofphyact i.CVD i.hypertension_meds_0 i.n_54 i.road_lden_2cat i.rail_lden_2cat n_24006_all total_no2_09_all, vce(cluster airportid) family(gamma) link(log)
   
    if `first' {
        outreg2 using tables11m3strainlden.rtf, replace dec(2) pdec(3) ststr(replace coef=coef+"%" if coef~="") stnum(replace coef=(exp(coef)-1)*100, replace ci_low=((exp(ci_low)-1)*100), replace ci_high=((exp(ci_high)-1)*100)) level(95) noaster stats(coef ci pval) keep(i.air_lden_2cat2011) nocon
        local first = 0
    }
    else {
        outreg2 using tables11m3strainlden.rtf, append dec(2) pdec(3) ststr(replace coef=coef+"%" if coef~="") stnum(replace coef=(exp(coef)-1)*100, replace ci_low=((exp(ci_low)-1)*100), replace ci_high=((exp(ci_high)-1)*100)) level(95) noaster stats(coef ci pval) keep(i.air_lden_2cat2011) nocon
    }
}




* Supplementary Table S12. Characteristics of participants who lived near one of the four UK airports and had CMR imaging and had not moved home since recruitment.


dtable, define(iqi = q1 q3, delimiter(" - ")) sformat("(%s)" iqi) nformat(%9.2f mean sd median q1 q3) continuous(age n_189 daysofphyact n_24006_all total_no2_09_all n_102 n_21001 n_30690 LVEDVindex LVESVindex Myovolume Lvmassindex meanwt maxwt IVS PWT seplatwr relwallmass lvef MCF circumsgi circumsbi circumsmi circumsai radialsgi radialsbi radialsmi radialsai longisgi longisbi, statistics(median iqi)) factor(  i.sex i.ethnic_background_cat i.household_income i.smoking i.alcohol i.air_lnight_2cat2011 i.air_lden_2cat2011 i.road_lnight_2cat i.road_lden_2cat i.rail_lnight_2cat i.rail_lden_2cat i.hypertension_combined i.diabetes i.high_cholesterol i.CVD i.heart_failure_2014) ,, by(non_mover, nototals tests) varlabel fvlabel export("tables12", as(docx) replace)



* Supplementary Table S13. Differences in CMR structure and function (including strain) metrics between those exposed and unexposed to higher aircraft noise levels in those who did not move home during follow-up.






local outcomes LVEDVindex LVESVindex Myovolume Lvmassindex meanwt maxwt IVS PWT seplatwr relwallmass lvef MCF 

local first = 1

foreach outcome in `outcomes' {
    glm `outcome' i.air_lnight_2cat2011 sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address daysofphyact  i.n_54 i.road_lnight_2cat i.rail_lnight_2cat n_24006_all total_no2_09_all if non_mover==1 , vce(cluster airportid) family(gamma) link(log)
    
    if `first' {
        outreg2 using tables13lnight.rtf, replace dec(2) pdec(3) ststr(replace coef=coef+"%" if coef~="") stnum(replace coef=(exp(coef)-1)*100, replace ci_low=((exp(ci_low)-1)*100), replace ci_high=((exp(ci_high)-1)*100)) level(95) noaster stats(coef ci pval) keep(i.air_lnight_2cat2011) nocon
        local first = 0
    }
    else {
        outreg2 using tables13lnight.rtf, append dec(2) pdec(3) ststr(replace coef=coef+"%" if coef~="") stnum(replace coef=(exp(coef)-1)*100, replace ci_low=((exp(ci_low)-1)*100), replace ci_high=((exp(ci_high)-1)*100)) level(95) noaster stats(coef ci pval) keep(i.air_lnight_2cat2011) nocon
    }
}

local outcomes LVEDVindex LVESVindex Myovolume Lvmassindex meanwt maxwt IVS PWT seplatwr relwallmass lvef MCF 

local first = 1

foreach outcome in `outcomes' {
    glm `outcome' i.air_lden_2cat2011 sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address daysofphyact  i.n_54 i.road_lden_2cat i.rail_lden_2cat n_24006_all total_no2_09_all if non_mover==1, vce(cluster airportid) family(gamma) link(log)
    
    if `first' {
        outreg2 using tables13lden.rtf, replace dec(2) pdec(3) ststr(replace coef=coef+"%" if coef~="") stnum(replace coef=(exp(coef)-1)*100, replace ci_low=((exp(ci_low)-1)*100), replace ci_high=((exp(ci_high)-1)*100)) level(95) noaster stats(coef ci pval) keep(i.air_lden_2cat2011) nocon
        local first = 0
    }
    else {
        outreg2 using tables13lden.rtf, append dec(2) pdec(3) ststr(replace coef=coef+"%" if coef~="") stnum(replace coef=(exp(coef)-1)*100, replace ci_low=((exp(ci_low)-1)*100), replace ci_high=((exp(ci_high)-1)*100)) level(95) noaster stats(coef ci pval) keep(i.air_lden_2cat2011) nocon
    }
}



local outcomes circumsgi circumsbi circumsmi circumsai radialsgi radialsbi radialsmi radialsai longisgi longisbi

local first = 1

foreach outcome in `outcomes' {
    glm `outcome' i.air_lnight_2cat2011 sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address daysofphyact  i.hypertension_meds_0 i.n_54 i.road_lnight_2cat i.rail_lnight_2cat n_24006_all total_no2_09_all if non_mover==1, vce(cluster airportid) family(gamma) link(log)
    
    if `first' {
        outreg2 using tables13strainlnight.rtf, replace dec(2) pdec(3) ststr(replace coef=coef+"%" if coef~="") stnum(replace coef=(exp(coef)-1)*100, replace ci_low=((exp(ci_low)-1)*100), replace ci_high=((exp(ci_high)-1)*100)) level(95) noaster stats(coef ci pval) keep(i.air_lnight_2cat2011) nocon
        local first = 0
    }
    else {
        outreg2 using tables13strainlnight.rtf, append dec(2) pdec(3) ststr(replace coef=coef+"%" if coef~="") stnum(replace coef=(exp(coef)-1)*100, replace ci_low=((exp(ci_low)-1)*100), replace ci_high=((exp(ci_high)-1)*100)) level(95) noaster stats(coef ci pval) keep(i.air_lnight_2cat2011) nocon
    }
}

local outcomes circumsgi circumsbi circumsmi circumsai radialsgi radialsbi radialsmi radialsai longisgi longisbi

local first = 1

foreach outcome in `outcomes' {
    glm `outcome' i.air_lden_2cat2011 sex age i.ethnic_background_cat n_189 non_mover i.household_income i.smoking i.alcohol time_at_address daysofphyact  i.hypertension_meds_0 i.n_54 i.road_lden_2cat i.rail_lden_2cat n_24006_all total_no2_09_all if non_mover==1, vce(cluster airportid) family(gamma) link(log)
    
    if `first' {
        outreg2 using tables13strainlden.rtf, replace dec(2) pdec(3) ststr(replace coef=coef+"%" if coef~="") stnum(replace coef=(exp(coef)-1)*100, replace ci_low=((exp(ci_low)-1)*100), replace ci_high=((exp(ci_high)-1)*100)) level(95) noaster stats(coef ci pval) keep(i.air_lden_2cat2011) nocon
        local first = 0
    }
    else {
        outreg2 using tables13strainlden.rtf, append dec(2) pdec(3) ststr(replace coef=coef+"%" if coef~="") stnum(replace coef=(exp(coef)-1)*100, replace ci_low=((exp(ci_low)-1)*100), replace ci_high=((exp(ci_high)-1)*100)) level(95) noaster stats(coef ci pval) keep(i.air_lden_2cat2011) nocon
    }
}








* Supplementary Review Table 1. Differences between participants who reported versus those who did not report hearing difficulties, among those who lived near one of the four UK airports and had CMR imaging.

clear 

use "XXX\HearMRIdata.dta"


merge 1:1 n_eid using "XXX\final.dta", keep(master match) nogenerate

* Create CVD and heart failure before 2014 

* CVD 

* A) baseline medical records:
* 1) Age angina diagnosed (data field 3627)
* 2) Age heart attack diagnosed (data field 3894)
* 3) Age stroke diagnosed (data field 4056)
 
* B) inpatient medical records
* 1) Chapter IX Diseases of the circulatory system => I20-I25 Ischaemic heart diseases
* 2) Chapter IX Diseases of the circulatory system => I60-I69 Cerebrovascular diseases

gen CVD = 0

* Baseline medical records
replace CVD = 1 if (n_3627_0_0 > 0 & n_3627_0_0<=100 | n_3894_0_0 > 0 & n_3894_0_0<=100 | n_4056_0_0 > 0 & n_4056_0_0<=100)

* Inpatient medical records for ischaemic heart diseases before 2014
replace CVD = 1 if (ischaemic_heart_disease == 1 & ischaemic_heart_disease_year <= 2014)

* Inpatient medical records for cerebrovascular diseases before 2014
replace CVD = 1 if (cerebrovascular_disease == 1 & cerebrovascular_disease_year <= 2014)

label variable CVD "Cardiovascular Disease (CVD) Diagnosis"

tab CVD


* Heart failure


gen heart_failure_2014 = 0
replace heart_failure_2014 = 1 if (heart_failure == 1 & heart_failure_year <= 2014)
label variable heart_failure_2014 "Heart Failure Inpatient Before 2014"
tab heart_failure_2014


* create hypertension, diabetes and high cholesterol

* Create a new variable 'hypertension_combined' and set it to 1 if any of the conditions are true
gen hypertension_combined = 1 if  hypertension_dd_0 == 1 | hypertension_measured_0 == 1 | hypertension_meds_0==1

* Replace missing values (i.e., cases where none of the conditions are true) with 0
replace hypertension_combined = 0 if hypertension_combined == .

* Create a new variable 'diabetes' and set it to 1 if 'n_2443' is equal to 1
gen diabetes = 1 if n_2443 == 1

* Replace missing values with 0 if 'n_2443' is not equal to 1
replace diabetes = 0 if diabetes == .




* High cholesterol

gen high_cholesterol = 0

replace high_cholesterol = 1 if n_30690 >= 6.2 

label variable high_cholesterol "High Cholesterol: Cholesterol >=6.2"

tab high_cholesterol


* create outcomes
* Generate height in meters based on the n_50 variable, n_50 represents height in centimeters.
gen height = n_50 / 100
label variable height "Standing height in metres"

* Create Left Ventricular Myocardial Mass Index (Lvmassindex) by normalizing left ventricular mass (lvmg) to height raised to the power of 1.7.
gen Lvmassindex = lvmg / height^(1.7)
label variable Lvmassindex "Left ventricular myocardial mass"

* Create Left Ventricular End-Diastolic Volume Index (LVEDVindex) by normalizing left ventricular end-diastolic volume (lvedvml) to height raised to the power of 1.7.
gen LVEDVindex = lvedvml / height^(1.7)
label variable LVEDVindex "Left ventricular end diastolic volume index"

* Create Left Ventricular End-Systolic Volume Index (LVESVindex) by normalizing left ventricular end-systolic volume (lvesvml) to height raised to the power of 1.7.
gen LVESVindex = lvesvml / height^(1.7)
label variable LVESVindex "Left ventricular end-systolic volume index"

* Calculate Myocardial Volume (Myovolume) by dividing left ventricular mass (lvmg) by a constant (1.05).
gen Myovolume = lvmg / 1.05
label variable Myovolume "Myocardial volume"

* Create Myocardial Contraction Fraction (MCF) by dividing left ventricular stroke volume (lvsvml) by myocardial volume (Myovolume).
gen MCF = lvsvml / Myovolume
label variable MCF "Myocardial contraction fraction"

* Calculate Interventricular Septal Thickness (IVS) as the mean of wall thickness measurements in specific segments (2, 3, 8, 9, 14).
egen IVS = rowmean(wt_aha_2mm wt_aha_3mm wt_aha_8mm wt_aha_9mm wt_aha_14mm)
label variable IVS "Interventricular septal thickness"

* Calculate Lateral Wall Thickness (PWT) as the mean of wall thickness measurements in specific segments (5, 6, 11, 12, 16).
egen PWT = rowmean(wt_aha_5mm wt_aha_6mm wt_aha_11mm wt_aha_12mm wt_aha_16mm)
label variable PWT "Lateral wall thickness"

* Calculate the Septal/Lateral Wall Ratio (seplatwr) by dividing interventricular septal thickness (IVS) by lateral wall thickness (PWT).
gen seplatwr = IVS / PWT
label variable seplatwr "Septal/lateral wall ratio"

* Calculate Relative Wall Mass (relwallmass) by dividing left ventricular mass (lvmg) by left ventricular end-diastolic volume (lvedvml).
gen relwallmass = lvmg / lvedvml
label variable relwallmass "Relative wall mass"

* Calculate Mean Wall Thickness (meanwt) as the average of wall thickness measurements across all 16 segments.
egen meanwt = rowmean(wt_aha_1mm wt_aha_2mm wt_aha_3mm wt_aha_4mm wt_aha_5mm wt_aha_6mm wt_aha_7mm wt_aha_8mm wt_aha_9mm wt_aha_10mm wt_aha_11mm wt_aha_12mm wt_aha_13mm wt_aha_14mm wt_aha_15mm wt_aha_16mm)
label variable meanwt "Mean wall thickness"

* Calculate Maximum Wall Thickness (maxwt) by finding the maximum value among wall thickness measurements across all 16 segments.
egen maxwt = rowmax(wt_aha_1mm wt_aha_2mm wt_aha_3mm wt_aha_4mm wt_aha_5mm wt_aha_6mm wt_aha_7mm wt_aha_8mm wt_aha_9mm wt_aha_10mm wt_aha_11mm wt_aha_12mm wt_aha_13mm wt_aha_14mm wt_aha_15mm wt_aha_16mm)
label variable maxwt "Maximum wall thickness"

* Strain Variables:
* Left Ventricle Radial Strain (global): Assign the global radial strain value (err_global) to the variable.
gen radialstrainglobal = err_global
label variable radialstrainglobal "Left ventricle radial strain global"

* Left Ventricle Circumferential Strain (global): Multiply the global circumferential strain value (ecc_global) by -1 to convert to a positive value for analysis.
gen circumstrainglobal = ecc_global * (-1)
label variable circumstrainglobal "LV circumferential strain global"

* Left Ventricle Longitudinal Strain (global): Multiply the global longitudinal strain value (ell_global) by -1 to convert to a positive value for analysis.
gen longistrainglobal = ell_global * (-1)
label variable longistrainglobal "LV longitudinal strain global"

* Calculate Radial Strain Basal (radialstrainbasal) as the mean of radial strain measurements across basal segments (1-6).
egen radialstrainbasal = rowmean(err_aha_1 err_aha_2 err_aha_3 err_aha_4 err_aha_5 err_aha_6)
label variable radialstrainbasal "LV radial strain basal"

* Calculate Radial Strain Mid (radialstrainmid) as the mean of radial strain measurements across mid segments (7-12).
egen radialstrainmid = rowmean(err_aha_7 err_aha_8 err_aha_9 err_aha_10 err_aha_11 err_aha_12)
label variable radialstrainmid "LV radial strain mid"

* Calculate Radial Strain Apical (radialstrainapical) as the mean of radial strain measurements across apical segments (13-16).
egen radialstrainapical = rowmean(err_aha_13 err_aha_14 err_aha_15 err_aha_16)
label variable radialstrainapical "LV radial strain apical"

* Calculate Circumferential Strain Basal (circumstrainbasal1) as the mean of circumferential strain measurements across basal segments (1-6).
egen circumstrainbasal1 = rowmean(ecc_aha_1 ecc_aha_2 ecc_aha_3 ecc_aha_4 ecc_aha_5 ecc_aha_6)
* Convert circumferential strain basal values to positive by multiplying by -1 for analysis.
gen circumstrainbasal = circumstrainbasal1 * (-1)

* Calculate Circumferential Strain Mid (circumstrainmid1) as the mean of circumferential strain measurements across mid segments (7-12).
egen circumstrainmid1 = rowmean(ecc_aha_7 ecc_aha_8 ecc_aha_9 ecc_aha_10 ecc_aha_11 ecc_aha_12)
* Convert circumferential strain mid values to positive by multiplying by -1 for analysis.
gen circumstrainmid = circumstrainmid1 * (-1)

* Calculate Circumferential Strain Apical (circumstrainapical1) as the mean of circumferential strain measurements across apical segments (13-16).
egen circumstrainapical1 = rowmean(ecc_aha_13 ecc_aha_14 ecc_aha_15 ecc_aha_16)
* Convert circumferential strain apical values to positive by multiplying by -1 for analysis.
gen circumstrainapica = circumstrainapical1 * (-1)

* Drop the intermediate variables used to calculate strain values.
drop circumstrainmid1 
drop circumstrainbasal1 
drop circumstrainapical1 

* Calculate Longitudinal Strain Basal (longistrainbasal1) as the mean of longitudinal strain measurements across basal segments (1-6).
egen longistrainbasal1 = rowmean(ell_1 ell_2 ell_3 ell_4 ell_5 ell_6)
* Convert longitudinal strain basal values to positive by multiplying by -1 for analysis.
gen longistrainbasal = longistrainbasal1 * (-1)
* Drop the intermediate variable used to calculate longitudinal strain basal.
drop longistrainbasal1 

* Create index variables for strain values normalized to Left Ventricular Myocardial Mass Index (Lvmassindex).
gen radialsgi = radialstrainglobal / Lvmassindex
gen circumsgi = circumstrainglobal / Lvmassindex
gen longisgi = longistrainglobal / Lvmassindex
gen radialsbi = radialstrainbasal / Lvmassindex
gen radialsmi = radialstrainmid / Lvmassindex
gen radialsai = radialstrainapical / Lvmassindex
gen circumsbi = circumstrainbasal / Lvmassindex
gen circumsmi = circumstrainmid / Lvmassindex
gen circumsai = circumstrainapica / Lvmassindex
gen longisbi = longistrainbasal / Lvmassindex


* Label the index variables.
label variable radialsgi "Radial strain global index"
label variable circumsgi "Circumferential strain global index"
label variable longisgi "Longitudinal strain global index"
label variable radialsbi "Radial strain basal index"
label variable radialsmi "Radial strain mid index"
label variable radialsai "Radial strain apical index"
label variable circumsbi "Circumferential strain basal index"
label variable circumsmi "Circumferential strain mid index"
label variable circumsai "Circumferential strain apical index"
label variable longisbi "Longitudinal strain basal index"



egen nmis=rmiss(Lvmassindex LVEDVindex LVESVindex Myovolume MCF IVS PWT seplatwr relwallmass meanwt maxwt radialstrainglobal circumstrainglobal longistrainglobal radialstrainbasal radialstrainmid radialstrainapical circumstrainbasal circumstrainmid circumstrainapica longistrainbasal radialsgi circumsgi longisgi radialsbi radialsmi radialsai circumsbi circumsmi circumsai longisbi)
drop if nmis==31
drop if air_lnight_2cat2011==.

dtable, define(iqi = q1 q3, delimiter(" - ")) sformat("(%s)" iqi) nformat(%9.2f mean sd median q1 q3) continuous(age n_189 daysofphyact n_24006_all total_no2_09_all n_102 n_21001 n_30690 LVEDVindex LVESVindex Myovolume Lvmassindex meanwt maxwt IVS PWT seplatwr relwallmass lvef MCF circumsgi circumsbi circumsmi circumsai radialsgi radialsbi radialsmi radialsai longisgi longisbi, statistics(median iqi)) factor(  i.sex i.ethnic_background_cat i.household_income i.smoking i.alcohol i.air_lnight_2cat2011 i.air_lden_2cat2011 i.road_lnight_2cat i.road_lden_2cat i.rail_lnight_2cat i.rail_lden_2cat i.hypertension_combined i.diabetes i.high_cholesterol i.CVD i.heart_failure_2014) ,, by( hearingdif , nototals tests) varlabel fvlabel export("tables14", as(docx) replace)


* Supplementary Review Table 2. Differences in CMR metrics between who reported versus who did not report hearing difficulties among those exposed to higher aircraft noise levels. 


dtable, define(iqi = q1 q3, delimiter(" - ")) sformat("(%s)" iqi) nformat(%9.2f mean sd median q1 q3) continuous(age n_189 daysofphyact n_24006_all total_no2_09_all n_102 n_21001 n_30690 LVEDVindex LVESVindex Myovolume Lvmassindex meanwt maxwt IVS PWT seplatwr relwallmass lvef MCF circumsgi circumsbi circumsmi circumsai radialsgi radialsbi radialsmi radialsai longisgi longisbi, statistics(median iqi)) factor(  i.sex i.ethnic_background_cat i.household_income i.smoking i.alcohol i.air_lnight_2cat2011 i.air_lden_2cat2011 i.road_lnight_2cat i.road_lden_2cat i.rail_lnight_2cat i.rail_lden_2cat i.hypertension_combined i.diabetes i.high_cholesterol i.CVD i.heart_failure_2014) , if air_lnight_2cat2011==1, by( hearingdif , nototals tests) varlabel fvlabel export("tables15lnight", as(docx) replace)


dtable, define(iqi = q1 q3, delimiter(" - ")) sformat("(%s)" iqi) nformat(%9.2f mean sd median q1 q3) continuous(age n_189 daysofphyact n_24006_all total_no2_09_all n_102 n_21001 n_30690 LVEDVindex LVESVindex Myovolume Lvmassindex meanwt maxwt IVS PWT seplatwr relwallmass lvef MCF circumsgi circumsbi circumsmi circumsai radialsgi radialsbi radialsmi radialsai longisgi longisbi, statistics(median iqi)) factor(  i.sex i.ethnic_background_cat i.household_income i.smoking i.alcohol i.air_lnight_2cat2011 i.air_lden_2cat2011 i.road_lnight_2cat i.road_lden_2cat i.rail_lnight_2cat i.rail_lden_2cat i.hypertension_combined i.diabetes i.high_cholesterol i.CVD i.heart_failure_2014) , if air_lden_2cat2011==1, by( hearingdif , nototals tests) varlabel fvlabel export("tables15lden", as(docx) replace)


* Table 3: Associations between CMR metrics and MACE.

clear 

use "XXX\HearMRIdata.dta"


merge 1:1 n_eid using "XXX\final.dta", keep(master match) nogenerate

* Create CVD and heart failure before 2014 

* CVD 

* A) baseline medical records:
* 1) Age angina diagnosed (data field 3627)
* 2) Age heart attack diagnosed (data field 3894)
* 3) Age stroke diagnosed (data field 4056)
 
* B) inpatient medical records
* 1) Chapter IX Diseases of the circulatory system => I20-I25 Ischaemic heart diseases
* 2) Chapter IX Diseases of the circulatory system => I60-I69 Cerebrovascular diseases

gen CVD = 0

* Baseline medical records
replace CVD = 1 if (n_3627_0_0 > 0 & n_3627_0_0<=100 | n_3894_0_0 > 0 & n_3894_0_0<=100 | n_4056_0_0 > 0 & n_4056_0_0<=100)

* Inpatient medical records for ischaemic heart diseases before 2014
replace CVD = 1 if (ischaemic_heart_disease == 1 & ischaemic_heart_disease_year <= 2014)

* Inpatient medical records for cerebrovascular diseases before 2014
replace CVD = 1 if (cerebrovascular_disease == 1 & cerebrovascular_disease_year <= 2014)

label variable CVD "Cardiovascular Disease (CVD) Diagnosis"

tab CVD


* Heart failure


gen heart_failure_2014 = 0
replace heart_failure_2014 = 1 if (heart_failure == 1 & heart_failure_year <= 2014)
label variable heart_failure_2014 "Heart Failure Inpatient Before 2014"
tab heart_failure_2014


* create hypertension, diabetes and high cholesterol

* Create a new variable 'hypertension_combined' and set it to 1 if any of the conditions are true
gen hypertension_combined = 1 if  hypertension_dd_0 == 1 | hypertension_measured_0 == 1 | hypertension_meds_0==1

* Replace missing values (i.e., cases where none of the conditions are true) with 0
replace hypertension_combined = 0 if hypertension_combined == .

* Create a new variable 'diabetes' and set it to 1 if 'n_2443' is equal to 1
gen diabetes = 1 if n_2443 == 1

* Replace missing values with 0 if 'n_2443' is not equal to 1
replace diabetes = 0 if diabetes == .




* High cholesterol

gen high_cholesterol = 0

replace high_cholesterol = 1 if n_30690 >= 6.2 

label variable high_cholesterol "High Cholesterol: Cholesterol >=6.2"

tab high_cholesterol


* create outcomes
* Generate height in meters based on the n_50 variable, n_50 represents height in centimeters.
gen height = n_50 / 100
label variable height "Standing height in metres"

* Create Left Ventricular Myocardial Mass Index (Lvmassindex) by normalizing left ventricular mass (lvmg) to height raised to the power of 1.7.
gen Lvmassindex = lvmg / height^(1.7)
label variable Lvmassindex "Left ventricular myocardial mass"

* Create Left Ventricular End-Diastolic Volume Index (LVEDVindex) by normalizing left ventricular end-diastolic volume (lvedvml) to height raised to the power of 1.7.
gen LVEDVindex = lvedvml / height^(1.7)
label variable LVEDVindex "Left ventricular end diastolic volume index"

* Create Left Ventricular End-Systolic Volume Index (LVESVindex) by normalizing left ventricular end-systolic volume (lvesvml) to height raised to the power of 1.7.
gen LVESVindex = lvesvml / height^(1.7)
label variable LVESVindex "Left ventricular end-systolic volume index"

* Calculate Myocardial Volume (Myovolume) by dividing left ventricular mass (lvmg) by a constant (1.05).
gen Myovolume = lvmg / 1.05
label variable Myovolume "Myocardial volume"

* Create Myocardial Contraction Fraction (MCF) by dividing left ventricular stroke volume (lvsvml) by myocardial volume (Myovolume).
gen MCF = lvsvml / Myovolume
label variable MCF "Myocardial contraction fraction"

* Calculate Interventricular Septal Thickness (IVS) as the mean of wall thickness measurements in specific segments (2, 3, 8, 9, 14).
egen IVS = rowmean(wt_aha_2mm wt_aha_3mm wt_aha_8mm wt_aha_9mm wt_aha_14mm)
label variable IVS "Interventricular septal thickness"

* Calculate Lateral Wall Thickness (PWT) as the mean of wall thickness measurements in specific segments (5, 6, 11, 12, 16).
egen PWT = rowmean(wt_aha_5mm wt_aha_6mm wt_aha_11mm wt_aha_12mm wt_aha_16mm)
label variable PWT "Lateral wall thickness"

* Calculate the Septal/Lateral Wall Ratio (seplatwr) by dividing interventricular septal thickness (IVS) by lateral wall thickness (PWT).
gen seplatwr = IVS / PWT
label variable seplatwr "Septal/lateral wall ratio"

* Calculate Relative Wall Mass (relwallmass) by dividing left ventricular mass (lvmg) by left ventricular end-diastolic volume (lvedvml).
gen relwallmass = lvmg / lvedvml
label variable relwallmass "Relative wall mass"

* Calculate Mean Wall Thickness (meanwt) as the average of wall thickness measurements across all 16 segments.
egen meanwt = rowmean(wt_aha_1mm wt_aha_2mm wt_aha_3mm wt_aha_4mm wt_aha_5mm wt_aha_6mm wt_aha_7mm wt_aha_8mm wt_aha_9mm wt_aha_10mm wt_aha_11mm wt_aha_12mm wt_aha_13mm wt_aha_14mm wt_aha_15mm wt_aha_16mm)
label variable meanwt "Mean wall thickness"

* Calculate Maximum Wall Thickness (maxwt) by finding the maximum value among wall thickness measurements across all 16 segments.
egen maxwt = rowmax(wt_aha_1mm wt_aha_2mm wt_aha_3mm wt_aha_4mm wt_aha_5mm wt_aha_6mm wt_aha_7mm wt_aha_8mm wt_aha_9mm wt_aha_10mm wt_aha_11mm wt_aha_12mm wt_aha_13mm wt_aha_14mm wt_aha_15mm wt_aha_16mm)
label variable maxwt "Maximum wall thickness"

* Strain Variables:
* Left Ventricle Radial Strain (global): Assign the global radial strain value (err_global) to the variable.
gen radialstrainglobal = err_global
label variable radialstrainglobal "Left ventricle radial strain global"

* Left Ventricle Circumferential Strain (global): Multiply the global circumferential strain value (ecc_global) by -1 to convert to a positive value for analysis.
gen circumstrainglobal = ecc_global * (-1)
label variable circumstrainglobal "LV circumferential strain global"

* Left Ventricle Longitudinal Strain (global): Multiply the global longitudinal strain value (ell_global) by -1 to convert to a positive value for analysis.
gen longistrainglobal = ell_global * (-1)
label variable longistrainglobal "LV longitudinal strain global"

* Calculate Radial Strain Basal (radialstrainbasal) as the mean of radial strain measurements across basal segments (1-6).
egen radialstrainbasal = rowmean(err_aha_1 err_aha_2 err_aha_3 err_aha_4 err_aha_5 err_aha_6)
label variable radialstrainbasal "LV radial strain basal"

* Calculate Radial Strain Mid (radialstrainmid) as the mean of radial strain measurements across mid segments (7-12).
egen radialstrainmid = rowmean(err_aha_7 err_aha_8 err_aha_9 err_aha_10 err_aha_11 err_aha_12)
label variable radialstrainmid "LV radial strain mid"

* Calculate Radial Strain Apical (radialstrainapical) as the mean of radial strain measurements across apical segments (13-16).
egen radialstrainapical = rowmean(err_aha_13 err_aha_14 err_aha_15 err_aha_16)
label variable radialstrainapical "LV radial strain apical"

* Calculate Circumferential Strain Basal (circumstrainbasal1) as the mean of circumferential strain measurements across basal segments (1-6).
egen circumstrainbasal1 = rowmean(ecc_aha_1 ecc_aha_2 ecc_aha_3 ecc_aha_4 ecc_aha_5 ecc_aha_6)
* Convert circumferential strain basal values to positive by multiplying by -1 for analysis.
gen circumstrainbasal = circumstrainbasal1 * (-1)

* Calculate Circumferential Strain Mid (circumstrainmid1) as the mean of circumferential strain measurements across mid segments (7-12).
egen circumstrainmid1 = rowmean(ecc_aha_7 ecc_aha_8 ecc_aha_9 ecc_aha_10 ecc_aha_11 ecc_aha_12)
* Convert circumferential strain mid values to positive by multiplying by -1 for analysis.
gen circumstrainmid = circumstrainmid1 * (-1)

* Calculate Circumferential Strain Apical (circumstrainapical1) as the mean of circumferential strain measurements across apical segments (13-16).
egen circumstrainapical1 = rowmean(ecc_aha_13 ecc_aha_14 ecc_aha_15 ecc_aha_16)
* Convert circumferential strain apical values to positive by multiplying by -1 for analysis.
gen circumstrainapica = circumstrainapical1 * (-1)

* Drop the intermediate variables used to calculate strain values.
drop circumstrainmid1 
drop circumstrainbasal1 
drop circumstrainapical1 

* Calculate Longitudinal Strain Basal (longistrainbasal1) as the mean of longitudinal strain measurements across basal segments (1-6).
egen longistrainbasal1 = rowmean(ell_1 ell_2 ell_3 ell_4 ell_5 ell_6)
* Convert longitudinal strain basal values to positive by multiplying by -1 for analysis.
gen longistrainbasal = longistrainbasal1 * (-1)
* Drop the intermediate variable used to calculate longitudinal strain basal.
drop longistrainbasal1 

* Create index variables for strain values normalized to Left Ventricular Myocardial Mass Index (Lvmassindex).
gen radialsgi = radialstrainglobal / Lvmassindex
gen circumsgi = circumstrainglobal / Lvmassindex
gen longisgi = longistrainglobal / Lvmassindex
gen radialsbi = radialstrainbasal / Lvmassindex
gen radialsmi = radialstrainmid / Lvmassindex
gen radialsai = radialstrainapical / Lvmassindex
gen circumsbi = circumstrainbasal / Lvmassindex
gen circumsmi = circumstrainmid / Lvmassindex
gen circumsai = circumstrainapica / Lvmassindex
gen longisbi = longistrainbasal / Lvmassindex


* Label the index variables.
label variable radialsgi "Radial strain global index"
label variable circumsgi "Circumferential strain global index"
label variable longisgi "Longitudinal strain global index"
label variable radialsbi "Radial strain basal index"
label variable radialsmi "Radial strain mid index"
label variable radialsai "Radial strain apical index"
label variable circumsbi "Circumferential strain basal index"
label variable circumsmi "Circumferential strain mid index"
label variable circumsai "Circumferential strain apical index"
label variable longisbi "Longitudinal strain basal index"





* standardise CMR variables 


foreach var in LVEDVindex LVESVindex Lvmassindex Myovolume meanwt maxwt IVS PWT seplatwr relwallmass MCF lvef radialsgi radialsbi radialsmi radialsai circumsgi circumsbi circumsmi circumsai longisgi longisbi {
    * Calculate the min and max
    summarize `var', detail
    local min = r(min)
    local max = r(max)

    * Generate a new standardized variable
    generate std_`var' = ((`var' - `min') / (`max' - `min')) * 100
}


* Survival analyses

* Calculate the number of missing values for the specified variables in each observation
egen nmis = rmiss(Lvmassindex LVEDVindex LVESVindex Myovolume MCF IVS PWT seplatwr relwallmass meanwt maxwt radialstrainglobal circumstrainglobal longistrainglobal radialstrainbasal radialstrainmid radialstrainapical circumstrainbasal circumstrainmid circumstrainapica longistrainbasal radialsgi circumsgi longisgi radialsbi radialsmi radialsai circumsbi circumsmi circumsai longisbi)

* Drop observations where all of the specified variables are missing (i.e., nmis equals 31)
drop if nmis == 31




* Survival analysis 

* Generate the time-to-event variable; MRIyear = instance 2 visit year
gen time_to_MACEevent = earliest_mace_year - MRIyear

* Replace missing time_to_MACEevent with 2021 - MRIyear; 2021 is the end point
replace time_to_MACEevent = 2021 - MRIyear if missing(time_to_MACEevent)

* This ensures that individuals who didn't experience MACE are censored at the endpoint (2021).

* Generate the MACEcoxID variable from MACE
gen MACEcoxID = MACE

* Set MACEcoxID to 0 for censored cases and to missing if time_to_MACEevent is negative
replace MACEcoxID=0 if MACEcoxID==.
replace MACEcoxID = . if time_to_MACEevent < 0

* Set time_to_MACEevent to missing if MACEcoxID is missing
replace time_to_MACEevent = . if MACEcoxID == .

* Set both MACEcoxID and time_to_MACEevent to missing if air_lnight_2cat2011 is not missing
replace MACEcoxID = . if air_lnight_2cat2011 != .
replace time_to_MACEevent = . if air_lnight_2cat2011 != .


* Model 1 


stset time_to_MACEevent, failure(MACEcoxID==1) scale(1)

stcox std_LVEDVindex sex age i.ethnic_background_cat  n_189 non_mover i.household_income i.smoking i.alcohol  daysofphyact
outreg2 using tables3m1.xls, replace ctitle(LVEDVindex) dec(2) pdec(3) level(95) noaster stats(coef ci pval) eform
stcox std_LVESVindex sex age i.ethnic_background_cat  n_189 non_mover i.household_income i.smoking i.alcohol  daysofphyact 
outreg2 using tables3m1.xls, append ctitle(LVESVindex) dec(2) pdec(3) level(95) noaster stats(coef ci pval) eform
stcox std_Myovolume sex age i.ethnic_background_cat  n_189 non_mover i.household_income i.smoking i.alcohol  daysofphyact 
outreg2 using tables3m1.xls, append ctitle(Myocardial volume) dec(2) pdec(3) level(95) noaster stats(coef ci pval) eform
stcox std_Lvmassindex sex age i.ethnic_background_cat  n_189 non_mover i.household_income i.smoking i.alcohol  daysofphyact 
outreg2 using tables3m1.xls, append ctitle(Lvmassindex) dec(2) pdec(3) level(95) noaster stats(coef ci pval) eform
stcox std_meanwt sex age i.ethnic_background_cat  n_189 non_mover i.household_income i.smoking i.alcohol  daysofphyact 
outreg2 using tables3m1.xls, append ctitle(Mean wall thickness) dec(2) pdec(3) level(95) noaster stats(coef ci pval) eform
stcox std_maxwt sex age i.ethnic_background_cat  n_189 non_mover i.household_income i.smoking i.alcohol  daysofphyact 
outreg2 using tables3m1.xls, append ctitle(Maximum wall thickness) dec(2) pdec(3) level(95) noaster stats(coef ci pval) eform
stcox std_IVS sex age i.ethnic_background_cat  n_189 non_mover i.household_income i.smoking i.alcohol  daysofphyact 
outreg2 using tables3m1.xls, append ctitle(Interventricular septal thickness) dec(2) pdec(3) level(95) noaster stats(coef ci pval) eform
stcox std_PWT sex age i.ethnic_background_cat  n_189 non_mover i.household_income i.smoking i.alcohol  daysofphyact 
outreg2 using tables3m1.xls, append ctitle(Lateral wall thickness) dec(2) pdec(3) level(95) noaster stats(coef ci pval) eform
stcox std_lvef sex age i.ethnic_background_cat  n_189 non_mover i.household_income i.smoking i.alcohol  daysofphyact 
outreg2 using tables3m1.xls, append ctitle(LVEF) dec(2) pdec(3) level(95) noaster stats(coef ci pval) eform
stcox std_MCF sex age i.ethnic_background_cat  n_189 non_mover i.household_income i.smoking i.alcohol  daysofphyact 
outreg2 using tables3m1.xls, append ctitle(MCF) dec(2) pdec(3) level(95) noaster stats(coef ci pval) eform
stcox std_circumsgi sex age i.ethnic_background_cat  n_189 non_mover i.household_income i.smoking i.alcohol  daysofphyact 
outreg2 using tables3m1.xls, append ctitle(LV circumferential strain global index) dec(2) pdec(3) level(95) noaster stats(coef ci pval) eform
stcox std_radialsgi sex age i.ethnic_background_cat  n_189 non_mover i.household_income i.smoking i.alcohol  daysofphyact 
outreg2 using tables3m1.xls, append ctitle(LV radial strain global index) dec(2) pdec(3) level(95) noaster stats(coef ci pval) eform
stcox std_longisgi sex age i.ethnic_background_cat  n_189 non_mover i.household_income i.smoking i.alcohol  daysofphyact 
outreg2 using tables3m1.xls, append ctitle(LV longitudinal strain global index) dec(2) pdec(3) level(95) noaster stats(coef ci pval) eform


* Model 2


stcox std_LVEDVindex sex age i.ethnic_background_cat  n_189 non_mover i.household_income i.smoking i.alcohol  daysofphyact n_21001 i.hypertension_combined i.diabetes i.high_cholesterol i.CVD 
outreg2 using tables3m2.xls, replace ctitle(LVEDVindex) dec(2) pdec(3) level(95) noaster stats(coef ci pval) eform
stcox std_LVESVindex sex age i.ethnic_background_cat  n_189 non_mover i.household_income i.smoking i.alcohol  daysofphyact n_21001 i.hypertension_combined i.diabetes i.high_cholesterol i.CVD 
outreg2 using tables3m2.xls, append ctitle(LVESVindex) dec(2) pdec(3) level(95) noaster stats(coef ci pval) eform
stcox std_Myovolume sex age i.ethnic_background_cat  n_189 non_mover i.household_income i.smoking i.alcohol  daysofphyact n_21001 i.hypertension_combined i.diabetes i.high_cholesterol i.CVD 
outreg2 using tables3m2.xls, append ctitle(Myocardial volume) dec(2) pdec(3) level(95) noaster stats(coef ci pval) eform
stcox std_Lvmassindex sex age i.ethnic_background_cat  n_189 non_mover i.household_income i.smoking i.alcohol  daysofphyact n_21001 i.hypertension_combined i.diabetes i.high_cholesterol i.CVD 
outreg2 using tables3m2.xls, append ctitle(Lvmassindex) dec(2) pdec(3) level(95) noaster stats(coef ci pval) eform
stcox std_meanwt sex age i.ethnic_background_cat  n_189 non_mover i.household_income i.smoking i.alcohol  daysofphyact n_21001 i.hypertension_combined i.diabetes i.high_cholesterol i.CVD 
outreg2 using tables3m2.xls, append ctitle(Mean wall thickness) dec(2) pdec(3) level(95) noaster stats(coef ci pval) eform
stcox std_maxwt sex age i.ethnic_background_cat  n_189 non_mover i.household_income i.smoking i.alcohol  daysofphyact n_21001 i.hypertension_combined i.diabetes i.high_cholesterol i.CVD 
outreg2 using tables3m2.xls, append ctitle(Maximum wall thickness) dec(2) pdec(3) level(95) noaster stats(coef ci pval) eform
stcox std_IVS sex age i.ethnic_background_cat  n_189 non_mover i.household_income i.smoking i.alcohol  daysofphyact n_21001 i.hypertension_combined i.diabetes i.high_cholesterol i.CVD 
outreg2 using tables3m2.xls, append ctitle(Interventricular septal thickness) dec(2) pdec(3) level(95) noaster stats(coef ci pval) eform
stcox std_PWT sex age i.ethnic_background_cat  n_189 non_mover i.household_income i.smoking i.alcohol  daysofphyact n_21001 i.hypertension_combined i.diabetes i.high_cholesterol i.CVD 
outreg2 using tables3m2.xls, append ctitle(Lateral wall thickness) dec(2) pdec(3) level(95) noaster stats(coef ci pval) eform
stcox std_lvef sex age i.ethnic_background_cat  n_189 non_mover i.household_income i.smoking i.alcohol  daysofphyact n_21001 i.hypertension_combined i.diabetes i.high_cholesterol i.CVD 
outreg2 using tables3m2.xls, append ctitle(LVEF) dec(2) pdec(3) level(95) noaster stats(coef ci pval) eform
stcox std_MCF sex age i.ethnic_background_cat  n_189 non_mover i.household_income i.smoking i.alcohol  daysofphyact n_21001 i.hypertension_combined i.diabetes i.high_cholesterol i.CVD 
outreg2 using tables3m2.xls, append ctitle(MCF) dec(2) pdec(3) level(95) noaster stats(coef ci pval) eform
stcox std_circumsgi sex age i.ethnic_background_cat  n_189 non_mover i.household_income i.smoking i.alcohol  daysofphyact n_21001 i.hypertension_combined i.diabetes i.high_cholesterol i.CVD 
outreg2 using tables3m2.xls, append ctitle(LV circumferential strain global index) dec(2) pdec(3) level(95) noaster stats(coef ci pval) eform
stcox std_radialsgi sex age i.ethnic_background_cat  n_189 non_mover i.household_income i.smoking i.alcohol  daysofphyact n_21001 i.hypertension_combined i.diabetes i.high_cholesterol i.CVD 
outreg2 using tables3m2.xls, append ctitle(LV radial strain global index) dec(2) pdec(3) level(95) noaster stats(coef ci pval) eform
stcox std_longisgi sex age i.ethnic_background_cat  n_189 non_mover i.household_income i.smoking i.alcohol  daysofphyact n_21001 i.hypertension_combined i.diabetes i.high_cholesterol i.CVD 
outreg2 using tables3m2.xls, append ctitle(LV longitudinal strain global index) dec(2) pdec(3) level(95) noaster stats(coef ci pval) eform




* Supplementary Table S3. Characteristics of participants who had CMR imaging and MACE outcome data.


dtable, define(iqi = q1 q3, delimiter(" - ")) sformat("(%s)" iqi) nformat(%9.2f mean sd median q1 q3) continuous(age n_189 daysofphyact total_no2_09_all n_24006_all n_102 n_21001 n_30690 LVEDVindex LVESVindex Lvmassindex Myovolume meanwt maxwt IVS PWT seplatwr relwallmass MCF lvef circumsgi circumsbi circumsmi circumsai radialsgi radialsbi radialsmi radialsai longisgi longisbi, statistics(median iqi)) factor(  i.sex i.ethnic_background_cat i.household_income i.smoking i.alcohol i.air_lnight_2cat2011 i.air_lden_2cat2011 i.road_lnight_2cat i.road_lden_2cat i.rail_lnight_2cat i.rail_lden_2cat i.hypertension_combined i.diabetes i.high_cholesterol i.CVD i.heart_failure_2014) ,, by(MACEcoxID, nototals tests) varlabel fvlabel export("tables3", as(docx) replace)

