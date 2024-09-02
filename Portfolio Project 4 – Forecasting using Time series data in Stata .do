clear 
ssc install outreg2 
capture log close
use "/Users/chiammy/Documents/Stata/oecd_phillips_assignment.dta"

***
*** Part 1 
***

*Summary Statistics
sum dinf_JPN dunemp_JPN
list dinf_JPN dunemp_JPN

*time series graph
twoway (tsline dinf_JPN) 	(tsline dunemp_JPN), ///
scheme(s2color) graphregion(color(blue%10))
*Both variable tend to return 0, assume stationarity


corrgram dinf_JPN, lags(20)
*Statistically significant autocorrelation and partial autocorrelation

*ACF & PACF
ac dunemp_JPN, lags(20)
*Correlogram provides evidence for autocorrelation at lags 1, 2, 3, 5 and 8
pac dunemp_JPN, lags(20)
**Correlogram provides evidence for partial autocorrelation at lags 1, 2, 3, 8, 9, 10

*generate a dummy var for out-sample-period
gen osp = (year>=2016 & year<=2019) 
tab osp


***
*** Part 2 
***

*ARDL Models + AIC
*Reject the null of no autocorrelation at the 5% level if serial correlation p value<0.05

*ARDL (1,1) – p=0.0706, Do not reject the null  
regress dunemp_JPN l(1).dunemp_JPN l(1).dinf_JP if osp == 0
estat bgodfrey, lag(4)
estat ic
*ARDL (1,2) – p=0.0683, Do not reject the null 
regress dunemp_JPN l(1).dunemp_JPN l(1/2).dinf_JP if osp == 0
estat bgodfrey, lag(4)
estat ic
*ARDL (1,3) – Reject the null 
regress dunemp_JPN l(1).dunemp_JPN l(1/3).dinf_JP if osp == 0
estat bgodfrey, lag(4)
estat ic
*ARDL (1,4) – p=0.1007, Do not reject the null 
regress dunemp_JPN l(1).dunemp_JPN l(1/4).dinf_JP if osp == 0
estat bgodfrey, lag(4)
estat ic


*ARDL (2,1) – p=0.3223, Do not reject the null 
regress dunemp_JPN l(1/2).dunemp_JPN l(1).dinf_JP if osp == 0
estat bgodfrey, lag(4)
estat ic
*ARDL (2,2) – p=0.3223, Do reject the null 
regress dunemp_JPN l(1/2).dunemp_JPN l(1/2).dinf_JP if osp == 0
estat bgodfrey, lag(4)
estat ic
*ARDL (2,3) – reject the null 
regress dunemp_JPN l(1/2).dunemp_JPN l(1/3).dinf_JP if osp == 0
estat bgodfrey, lag(4)
estat ic
*ARDL (2,4) – p=0.2643, Do not reject the null 
regress dunemp_JPN l(1/2).dunemp_JPN l(1/4).dinf_JP if osp == 0
estat bgodfrey, lag(4)
estat ic


*ARDL (3,1) – p=0.9495, Do not reject the null 
regress dunemp_JPN l(1/3).dunemp_JPN l(1).dinf_JP if osp == 0
estat bgodfrey, lag(4)
estat ic
*ARDL (3,2) – p=0.9684, Do not reject the null
regress dunemp_JPN l(1/3).dunemp_JPN l(1/2).dinf_JP if osp == 0
estat bgodfrey, lag(4)
estat ic
*ARDL (3,3) – p=0.3279, Do not reject the null 
regress dunemp_JPN l(1/3).dunemp_JPN l(1/3).dinf_JP if osp == 0
estat bgodfrey, lag(4)
estat ic
*ARDL (3,4) – p=0.5992, Do not reject the null 
regress dunemp_JPN l(1/3).dunemp_JPN l(1/4).dinf_JP if osp == 0
estat bgodfrey, lag(4)
estat ic


*ARDL (4,1) – p=0.9661, Do not reject the null 
regress dunemp_JPN l(1/4).dunemp_JPN l(1).dinf_JP if osp == 0
estat bgodfrey, lag(4)
estat ic
*ARDL (4,2) – p=0.9155, Do not reject the null 
regress dunemp_JPN l(1/4).dunemp_JPN l(1/2).dinf_JP if osp == 0
estat bgodfrey, lag(4)
estat ic
*ARDL (4,3) – p=0.1616, Do not reject the null 
regress dunemp_JPN l(1/4).dunemp_JPN l(1/3).dinf_JP if osp == 0
estat bgodfrey, lag(4)
estat ic
*ARDL (4,4) – p=0.6160, Do not reject the null 
regress dunemp_JPN l(1/4).dunemp_JPN l(1/4).dinf_JP if osp == 0
estat bgodfrey, lag(4)
estat ic


*AR Models + AIC
*Reject the null of no autocorrelation at the 5% level if serial correlation p value<0.05

*AR(1) – Reject the null 
regress dunemp_JPN l(1/1).dunemp_JPN if osp == 0
estat bgodfrey, lag(4)
estat ic
*AR(2) – p=0.1441, Do not reject the null 
regress dunemp_JPN l(1/2).dunemp_JPN if osp == 0
estat bgodfrey, lag(4)
estat ic
*AR – Reject the null 
regress dunemp_JPN l(1/3).dunemp_JPN if osp == 0
estat bgodfrey, lag(4)
estat ic
*AR – Reject the null 
regress dunemp_JPN l(1/4).dunemp_JPN if osp == 0
estat bgodfrey, lag(4)
estat ic

*From the models that passed the Breusch-Godfrey Test for serial correlation, the 2 best models based on their AIC values are ARDL(3,1) and ARDL(4,1).
*As well as that, we will use the model AR(2). It's a model that passed the Breusch-Godfrey Test but is a Autoregressive model instead of a Autoregressive Distributed Lag model

***
*** Part 3
***

*Predicting the 3 selected models as well as generating the error values and the standard errors 

*Preferred model 1: ARDL(3,1)
regress dunemp_JPN l(1/3).dunemp_JPN l(1).dinf_JP if osp == 0
predict f1
gen u1 = dunemp_JPN - f1
predict sef1, stdp
gen u1_sqr = u1^2
gen abu1 = abs(u1)
gen lowf1 = f1-2.37*sef1
gen highf1 = f1+2.37*sef1 
list qdate  dunemp_JPN lowf1 highf1 u1 u1_sqr abu1 if qdate >= tq(2016q1)

*Preferred model 2: ARDL (4,1)
regress dunemp_JPN l(1/4).dunemp_JPN l(1).dinf_JP if osp == 0
predict f2
gen u2 = dunemp_JPN - f2
predict sef2, stdp
gen u2_sqr = u2^2
gen abu2 = abs(u2)
gen lowf2 = f2-2.37*sef2
gen highf2 = f2+2.37*sef2
list qdate  dunemp_JPN lowf2 highf2 u2 u2_sqr abu2 if qdate >= tq(2016q1)

*Random model: AR(2)
regress dunemp_JPN l(1/2).dunemp_JPN if osp == 0
predict f3
gen u3 = dunemp_JPN - f3
predict sef3, stdp
gen u3_sqr = u3^2
gen abu3= abs(u3)
gen lowf3 = f3-2.37*sef3
gen highf3 = f3+2.37*sef3
list qdate  dunemp_JPN lowf3 highf3 u3 u3_sqr abu3 if qdate >= tq(2016q1)


*Point and 90% interval forecasts of ARDL(3,1)
twoway (tsline dunemp_JPN if qdate >= tq(2016q1) & qdate <= tq(2019q4), lw(.8)) ///
	(rarea lowf1 highf1 qdate if qdate >= tq(2016q1), lcolor(pink*1.5) fcolor(pink*1.5%30) lpattern(solid) lw(.2)) ///
	(tsline f1 if qdate >= tq(2016q1) & qdate <= tq(2019q4), lcolor(pink*1.5) lpattern(solid) lw(.8)), ///
	scheme(s2mono) graphregion(color(white)) ///
	ysize(6) xsize(15) ylabel(, grid glc(black) glw(.2) glp(shortdash)) ///
	legend(rows(1) order(1 "dunemp_JPN 2016-19" 2 "90% Interval forecast" 3 "Point forecast")) ///
	ytitle("Unemployment Rate (in percent)", size(normal)) xtitle("Quarter", size(normal))
	
*Point and 90% interval forecasts of ARDL(4,1)
twoway (tsline dunemp_JPN if qdate >= tq(2016q1) & qdate <= tq(2019q4), lw(.8)) ///
	(rarea lowf2 highf2 qdate if qdate >= tq(2016q1), lcolor(green*1.5) fcolor(green*1.5%30) lpattern(solid) lw(.2)) ///
	(tsline f2 if qdate >= tq(2016q1) & qdate <= tq(2019q4), lcolor(green*1.5) lpattern(solid) lw(.8)), ///
	ysize(6) xsize(15) ylabel(, grid glc(black) glw(.2) glp(shortdash)) ///
	scheme(s2mono) graphregion(color(white)) ///
	legend(rows(1) order(1 "dunemp_JPN 2016-19" 2 "90% Interval forecast" 3 "Point Forecast")) ///
	ytitle("Unemployment Rate (in percent)", size(normal)) xtitle("Quarter", size(normal))

*Point and 90% interval forecasts of AR(2)
twoway (tsline dunemp_JPN if qdate >= tq(2016q1) & qdate <= tq(2019q4), lw(.8)) ///
	(rarea lowf3 highf3 qdate if qdate >= tq(2016q1), lcolor(midblue*1.5) fcolor(midblue*1.5%30) lpattern(solid) lw(.2)) ///
	(tsline f3 if qdate >= tq(2016q1) & qdate <= tq(2019q4), lcolor(midblue*1.5) lpattern(solid) lw(.8)), ///
	scheme(s2mono) graphregion(color(white)) ///
	ysize(6) xsize(15) ylabel(, grid glc(black) glw(.2) glp(shortdash)) ///
	legend(rows(1) order(1 "dunemp_JPN (2016-19)" 2 "90% Interval forecast" 3 "Point forecast")) ///
	ytitle("Unemployment Rate (in percent)", size(normal)) xtitle("Quarter", size(normal))
	

***
*** Part 4
***

*Listing the error values for the out-of-sample period 
list qdate f1 lowf1 highf1 u1 u1_sqr abu1 if qdate >= tq(2016q1)
list qdate f2 lowf2 highf2 u2 u2_sqr abu2 if qdate >= tq(2016q1)
list qdate f3 lowf3 highf3 u3 u3_sqr abu3 if qdate >= tq(2016q1)

*Table of the absolute value of the errors and errors squared of all three forecasts 
tabstat abu1 abu2 abu3 u1_sqr u2_sqr u3_sqr if qdate >= tq(2016q1), stat(mean)

*To figure out the most accurate model, calculating the Root Mean Squared Error of the forecasts
*Based on the RMSE the most accurate model is the AR(2) model
