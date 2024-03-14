clear
*directory nayeem 
*cd "F:\ResearchProject\Jamal Sir\Rashed\Bangladesh MICS6 SPSS Datasets"

*directory baker chowdhury
cd "E:\Cloud Drive\Dropbox (UFL)\RESEARCH-Chowdhury\Research Projects\projects-ongoing\2020-00-14-MICS CDI\1-data\2019"


******************************************************************************** 
*2019
********************************************************************************

*get women data 
importsav wm.sav
rename *, lower
sort hh1 hh2 ln
save "wm" , replace

*get household 
importsav hh.sav
rename *, lower
sort hh1 hh2
save "hh" , replace

*get children data
importsav ch.sav
rename *, lower
sort hh1 hh2 ln
save "ch" , replace


merge m:1 hh1 hh2 ln using wm.dta
keep if _merge == 1
save "ch" , replace
drop _merge

merge m:1 hh1 hh2 using hh.dta
keep if _merge == 3
save "ch" , replace
drop _merge


/******************************************************************************** 
*data merge 
********************************************************************************
use "wm" , clear
sort hh1 hh2 ln
save "wm" , replace

use "hh" , clear
sort hh1 hh2
save "hh" , replace

*load 2019 mics data
use "ch" , clear
sort hh1 hh2 ln
save "ch" , replace

merge m:1 hh1 hh2 ln using wm.dta
keep if _merge == 1
save "ch" , replace
drop _merge

merge m:1 hh1 hh2 using hh.dta
keep if _merge == 3
save "ch" , replace
drop _merge
*/
********************************************************************************
*weight, strata, cluster variable for the appended data
********************************************************************************
gen wgt=chweight
svyset [pw=wgt],psu(hh1) strata(stratum)

********************************************************************************
*inclusion and exclusion
********************************************************************************
*keep only 3 and 4 years of children (exclude children under 3 years)
keep if ub2>=3
svy: tab ub2

********************************************************************************
*checking information with report
********************************************************************************

*edci
*child identifies at least ten letters of the alphabet.
svy: tab ec6
gen identifies_alphabet1=ec6
recode identifies_alphabet1 1=1
recode identifies_alphabet1 2=0
*recode identifies_alphabet1 8=.
*recode identifies_alphabet1 9=.
recode identifies_alphabet1 3/4=.

svy: tab identifies_alphabet1
label define identifies_alphabet1  1 "yes" 0 "no"
label values identifies_alphabet identifies_alphabet1
svy: tab identifies_alphabet

*child reads at least four simple, popular words.
svy: tab ec7
gen reads_words1=ec7
recode reads_words1 1=1
recode reads_words1 2=0
recode reads_words1 8=.
recode reads_words1 9=.
recode reads_words1 3/4=.

svy: tab reads_words1
label define reads_words1  1 "yes" 0 "no"
label values reads_words reads_words1
svy: tab reads_words

*child knows name and recognizes symbol of all numbers from 1-10.
svy: tab ec8
gen recognizes_symbol1=ec8
recode recognizes_symbol1 1=1
recode recognizes_symbol1 2=0
recode recognizes_symbol1 8=.
recode recognizes_symbol1 9=.
svy: tab recognizes_symbol1
recode recognizes_symbol1 3/4=.

label define recognizes_symbol1  1 "yes" 0 "no"
label values recognizes_symbol recognizes_symbol1
svy: tab recognizes_symbol

*literacy-numeracy.
gen literacy_numeracy = identifies_alphabet+reads_words+recognizes_symbol
svy: tab literacy_numeracy

generate literacy_numeracy_score1=literacy_numeracy
recode literacy_numeracy_score1 0/1=0
recode literacy_numeracy_score1 2/3=1
label define literacy_numeracy_score1  1 "yes" 0 "no"
label values literacy_numeracy_score literacy_numeracy_score1
svy: tab literacy_numeracy_score

*child able to pick up small object with 2 fingers.pick_object
svy: tab ec9
gen pick_object1=ec9
recode pick_object1 1=1
recode pick_object1 2=0
recode pick_object1 8=.
recode pick_object1 9=.
recode pick_object1 3/4=.

svy: tab pick_object1
label define pick_object1  1 "yes" 0 "no"
label values pick_object pick_object1
svy: tab pick_object

*child sometimes too sick to play.
svy: tab ec10
gen sick_to_play1=ec10
recode sick_to_play1 1=0
recode sick_to_play1 2=1
recode sick_to_play1 8=.
recode sick_to_play1 9=.
recode sick_to_play1 3/4=.

svy: tab sick_to_play1
label define sick_to_play1  1 "yes" 0 "no"
label values sick_to_play sick_to_play1
svy: tab sick_to_play

*physical
gen physical = pick_object+sick_to_play
svy: tab physical

generate physical_score1=physical
recode physical_score1 0=0
recode physical_score1 1/2=1
label define physical_score1  1 "yes" 0 "no"
label values physical_score physical_score1
svy: tab physical_score

*child follows simple directions.
svy: tab ec11
gen simple_directions1=ec11
recode simple_directions1 1=1
recode simple_directions1 2=0
recode simple_directions1 8=.
recode simple_directions1 9=.
svy: tab simple_directions1
recode simple_directions1 3/4=.

label define simple_directions1  1 "yes" 0 "no"
label values simple_directions simple_directions1
svy: tab simple_directions

*child able to do something independently.do_something
svy: tab ec12
gen do_something1=ec12
recode do_something1 1=1
recode do_something1 2=0
recode do_something1 8=.
recode do_something1 9=.
recode do_something1 3=.

svy: tab do_something1
label define do_something1  1 "yes" 0 "no"
label values do_something do_something1
svy: tab do_something

*learning
gen learning = simple_directions  + do_something
svy: tab learning

generate learning_score1=learning
recode learning_score1 0=0
recode learning_score1 1/2=1
label define learning_score1  1 "yes" 0 "no"
label values learning_score learning_score1
svy: tab learning_score

*child gets along well with other children.
svy: tab ec13
gen well_with_children1=ec13
recode well_with_children1 1=1
recode well_with_children1 2=0
recode well_with_children1 8=.
recode well_with_children1 9=.
svy: tab identifies_alphabet1
label define well_with_children1  1 "yes" 0 "no"
label values well_with_children well_with_children1
svy: tab well_with_children

*child kicks, bites or hits other children or adults.hits_children
svy: tab ec14
gen hits_children1=ec14
recode hits_children1 1=0
recode hits_children1 2=1
recode hits_children1 8=.
recode hits_children1 9=.
recode hits_children1 3=.

svy: tab hits_children1
label define hits_children1  1 "yes" 0 "no"
label values hits_children hits_children1
svy: tab hits_children

*child gets distracted easily.
svy: tab ec15
gen distracted_easily1=ec15
recode distracted_easily1 1=0
recode distracted_easily1 2=1
recode distracted_easily1 8=.
recode distracted_easily1 9=.
recode distracted_easily1 3/4=.

svy: tab distracted_easily1
label define distracted_easily1  1 "yes" 0 "no"
label values distracted_easily distracted_easily1
svy: tab distracted_easily


*social_emotional
gen social_emotional = well_with_children  + hits_children + distracted_easily
svy: tab social_emotional

generate social_emotional_score1=social_emotional
recode social_emotional_score1 0/1=0
recode social_emotional_score1 2/3=1
label define social_emotional_score1  1 "yes" 0 "no"
label values social_emotional_score social_emotional_score1
svy: tab social_emotional_score

*social_emotional
gen ecdi = literacy_numeracy_score + physical_score + learning_score + social_emotional_score
svy: tab ecdi

generate ecdi_score1=ecdi
recode ecdi_score1 0/2=0
recode ecdi_score1 3/4=1
label define ecdi_score1  1 "yes" 0 "no"
label values ecdi_score ecdi_score1
svy: tab ecdi_score

*age.
svy: tab ub2
svy: tab ub2 ecdi_score, row

*residence.
svy: tab hh6
gen area1=hh6
recode area1 1=1
recode area1 2/4=2
recode area1 5=3
label define area1  1 "rural" 2 "urban" 3 "tribal"
label values area area1
svy: tab area
svy: tab area ecdi_score, row

*division.
svy: tab hh7
svy: tab hh7 ecdi_score, row

*education.
svy: tab melevel
recode melevel 9=.
svy: tab melevel
svy: tab melevel ecdi_score, row

*weakth status.
svy: tab windex5
recode windex5 0=.
svy: tab windex5 ecdi_score, row

*religion.
svy: tab hc1a
gen religion1=hc1a
recode religion1 1=1
recode religion1 2/7=2
recode religion1 9=.
label define religion1 1 "islam" 2 "others"
label values religion religion1
svy: tab religion
svy: tab religion ecdi_score, row

*household sex.
svy: tab hhsex
svy: tab hhsex ecdi_score, row

*ethnicity.
svy: tab ethnicity
svy: tab ethnicity ecdi_score, row

*child sex.
svy: tab hl4
svy: tab hl4 ecdi_score, row



********************************************************************************
**logistic regression
********************************************************************************
*univariate logistic regression 


*multivariable logistuic regeression 
svy: logit ecdi_score i.ub2 i.area i.hh7 i.melevel i.windex5 i.religion i.hhsex i.ethnicity,or





******************************************************************************** 
*2012
********************************************************************************

clear
*directory
cd "f:\researchproject\jamal sir\rashed\bangladesh mics 2012-13 spss datasets"

*directory baker chowdhury
cd "E:\Cloud Drive\Dropbox (UFL)\RESEARCH-Chowdhury\Research Projects\projects-ongoing\2020-00-14-MICS CDI\1-data\2012"

******************************************************************************** 
*data merge 
********************************************************************************

*get women data 
importsav wm.sav
rename *, lower
sort hh1 hh2 ln
save "wm" , replace

*get household 
importsav hh.sav
rename *, lower
sort hh1 hh2
save "hh" , replace

*get children data
importsav ch.sav
rename *, lower
sort hh1 hh2 ln
save "ch" , replace

merge m:1 hh1 hh2 ln using wm.dta
keep if _merge == 1
save "ch" , replace
drop _merge

merge m:1 hh1 hh2 using hh.dta
keep if _merge == 3
save "ch" , replace
drop _merge


********************************************************************************
*weight, strata, cluster variable for the appended data
********************************************************************************
gen wgt=chweight
svyset [pw=wgt],psu(hh1) strata(strata)

********************************************************************************
*inclusion and exclusion
********************************************************************************
*keep only 3 and 4 years of children (exclude children under 3 years)
keep if ag2>=3
svy: tab ag2

********************************************************************************
*checking information with report
********************************************************************************

*edci
*child identifies at least ten letters of the alphabet.
svy: tab ec8
gen identifies_alphabet1=ec8
recode identifies_alphabet1 1=1
recode identifies_alphabet1 2=0
recode identifies_alphabet1 8=.
recode identifies_alphabet1 9=.
recode identifies_alphabet1 3/4=.
svy: tab identifies_alphabet1
label define identifies_alphabet1  1 "yes" 0 "no"
label values identifies_alphabet identifies_alphabet1
svy: tab identifies_alphabet

*child reads at least four simple, popular words.
svy: tab ec9
gen reads_words1=ec9
recode reads_words1 1=1
recode reads_words1 2=0
recode reads_words1 8=.
recode reads_words1 9=.
recode reads_words1 3/4=.
svy: tab reads_words1
label define reads_words1  1 "yes" 0 "no"
label values reads_words reads_words1
svy: tab reads_words

*child knows name and recognizes symbol of all numbers from 1-10.
svy: tab ec10
gen recognizes_symbol1=ec10
recode recognizes_symbol1 1=1
recode recognizes_symbol1 2=0
recode recognizes_symbol1 8=.
recode recognizes_symbol1 9=.
recode recognizes_symbol1 3/4=.

svy: tab recognizes_symbol1

label define recognizes_symbol1  1 "yes" 0 "no"
label values recognizes_symbol recognizes_symbol1
svy: tab recognizes_symbol

*literacy-numeracy.
gen literacy_numeracy = identifies_alphabet  + reads_words + recognizes_symbol
svy: tab literacy_numeracy

generate literacy_numeracy_score1=literacy_numeracy
recode literacy_numeracy_score1 0/1=0
recode literacy_numeracy_score1 2/3=1
label define literacy_numeracy_score1  1 "yes" 0 "no"
label values literacy_numeracy_score literacy_numeracy_score1
svy: tab literacy_numeracy_score

*child able to pick up small object with 2 fingers.pick_object
svy: tab ec11
gen pick_object1=ec11
recode pick_object1 1=1
recode pick_object1 2=0
recode pick_object1 8=.
recode pick_object1 9=.
svy: tab pick_object1
recode pick_object1 3/4=.

label define pick_object1  1 "yes" 0 "no"
label values pick_object pick_object1
svy: tab pick_object

*child sometimes too sick to play.
svy: tab ec12
gen sick_to_play1=ec12
recode sick_to_play1 1=0
recode sick_to_play1 2=1
recode sick_to_play1 8=.
recode sick_to_play1 9=.
recode sick_to_play1 3/4=.

svy: tab sick_to_play1
label define sick_to_play1  1 "yes" 0 "no"
label values sick_to_play sick_to_play1
svy: tab sick_to_play

*physical
gen physical = pick_object  + sick_to_play
svy: tab physical

generate physical_score1=physical
recode physical_score1 0=0
recode physical_score1 1/2=1
label define physical_score1  1 "yes" 0 "no"
label values physical_score physical_score1
svy: tab physical_score

*child follows simple directions.
svy: tab ec13
gen simple_directions1=ec13
recode simple_directions1 1=1
recode simple_directions1 2=0
recode simple_directions1 8=.
recode simple_directions1 9=.
recode simple_directions1 3/4=.

svy: tab simple_directions1
label define simple_directions1  1 "yes" 0 "no"
label values simple_directions simple_directions1
svy: tab simple_directions

*child able to do something independently.do_something
svy: tab ec14
gen do_something1=ec14
recode do_something1 1=1
recode do_something1 2=0
recode do_something1 8=.
recode do_something1 9=.
recode do_something1 3/4=.

svy: tab do_something1
label define do_something1  1 "yes" 0 "no"
label values do_something do_something1
svy: tab do_something1

*learning
gen learning = simple_directions  + do_something
svy: tab learning

generate learning_score1=learning
recode learning_score1 0=0
recode learning_score1 1/2=1
label define learning_score1  1 "yes" 0 "no"
label values learning_score learning_score1
svy: tab learning_score

*child gets along well with other children.
svy: tab ec15
gen well_with_children1=ec15
recode well_with_children1 1=1
recode well_with_children1 2=0
recode well_with_children1 8=.
recode well_with_children1 9=.
recode well_with_children1 3/4=.

svy: tab identifies_alphabet1
label define well_with_children1  1 "yes" 0 "no"
label values well_with_children well_with_children1
svy: tab well_with_children

*child kicks, bites or hits other children or adults.hits_children
svy: tab ec16
gen hits_children1=ec16
recode hits_children1 1=0
recode hits_children1 2=1
recode hits_children1 8=.
recode hits_children1 9=.
svy: tab hits_children1
recode hits_children1 3/4=.

label define hits_children1  1 "yes" 0 "no"
label values hits_children hits_children1
svy: tab hits_children

*child gets distracted easily.
svy: tab ec17
gen distracted_easily1=ec17
recode distracted_easily1 1=0
recode distracted_easily1 2=1
recode distracted_easily1 8=.
recode distracted_easily1 9=.
recode distracted_easily1 3/4=.

svy: tab distracted_easily1
label define distracted_easily1  1 "yes" 0 "no"
label values distracted_easily distracted_easily1
svy: tab distracted_easily


*social_emotional
gen social_emotional = well_with_children  + hits_children + distracted_easily
svy: tab social_emotional

generate social_emotional_score1=social_emotional
recode social_emotional_score1 0/1=0
recode social_emotional_score1 2/3=1
label define social_emotional_score1  1 "yes" 0 "no"
label values social_emotional_score social_emotional_score1
svy: tab social_emotional_score

*ecdi
gen ecdi = literacy_numeracy_score + physical_score + learning_score + social_emotional_score
svy: tab ecdi

generate ecdi_score1=ecdi
recode ecdi_score1 0/2=0
recode ecdi_score1 3/4=1
label define ecdi_score1  1 "yes" 0 "no"
label values ecdi_score ecdi_score1
svy: tab ecdi_score

*age.
svy: tab ag2
svy: tab ag2 ecdi_score, row

*residence.
svy: tab hh6
gen area1=hh6
recode area1 1=1
recode area1 2/4=2
recode area1 5=3
label define area1  1 "rural" 2 "urban" 3 "tribal"
label values area area1
svy: tab area
svy: tab area ecdi_score, row

*division.
svy: tab hh7
svy: tab hh7 ecdi_score, row

*education.
svy: tab melevel
recode melevel 9=.
svy: tab melevel
svy: tab melevel ecdi_score, row

*weakth status.
svy: tab windex5
recode windex5 0=.
svy: tab windex5 ecdi_score, row

*religion.
svy: tab hc1a
gen religion1=hc1a
recode religion1 1=1
recode religion1 2/7=2
recode religion1 9=.
label define religion1 1 "islam" 2 "others"
label values religion religion1
svy: tab religion
svy: tab religion ecdi_score, row

*household sex.
svy: tab hhsex
svy: tab hhsex ecdi_score, row

*ethnicity.
svy: tab ethnicity
svy: tab ethnicity ecdi_score, row

*child sex.
svy: tab hl4
svy: tab hl4 ecdi_score, row


********************************************************************************
**logistic regression
********************************************************************************

svy: logit ecdi_score i.ag2 i.area i.hh7 i.melevel i.windex5 i.religion i.hhsex i.ethnicity,or

