---
title: "PrepCAISOData"
author: "James Woods"
date: "12/15/2014"
output: html_document
---

Read in the data from the CAISO


```r
OldWD<-getwd()
setwd("/home/woodsj/Forecast-Peak-With-Google-Trends/CAData/CAISO")
# Get the files names
files <- list.files(pattern="*.csv")

# First apply read.csv, then rbind
CAISORaw<- do.call("rbind", lapply(files, function(x) read.csv(x, stringsAsFactors = FALSE)))
```
Editing of data types.  Remember that most everything gets imported as a string.


```r
CAISORaw$MARKET_RUN_ID<-as.factor(CAISORaw$MARKET_RUN_ID)
CAISORaw$TAC_AREA_NAME<-as.factor(CAISORaw$TAC_AREA_NAME)
CAISORaw$StartTimeGMT<-as.POSIXct(CAISORaw$INTERVALSTARTTIME_GMT)
```
Now trim off all but the full ISO area


```r
CAISOWorking<-CAISORaw[CAISORaw$TAC_AREA_NAME=='CA ISO-TAC',]
save(CAISOWorking,file="CAISOWorking.Rdata")
```

Now lets sort out how the 7day ahead market is related to the actual


```r
CAISOWorking$Hour<-as.factor(CAISOWorking$OPR_HR)
CAISOWorking$Date<-as.Date(CAISOWorking$OPR_DT)
#line up actual and 7day with the time in the line

Forecast<-CAISOWorking[CAISOWorking$MARKET_RUN_ID=="7DA",]
Actual<-CAISOWorking[CAISOWorking$MARKET_RUN_ID=="ACTUAL",]

library(sqldf)
```

```
## Loading required package: gsubfn
## Loading required package: proto
## Loading required namespace: tcltk
```

```
## Warning: couldn't connect to display ":0"
```

```
## Loading required package: RSQLite
## Loading required package: DBI
## Loading required package: RSQLite.extfuns
```

```r
Current<-sqldf("select Actual.Hour, Actual.Date, Actual.MW as Actual, Forecast.MW as Forecast from Forecast, Actual where Actual.Hour=Forecast.Hour and Actual.Date=Forecast.Date;")
```

```
## Loading required package: tcltk
```

```r
Lag<-sqldf("select Actual.Hour, Actual.Date, Actual.MW as Actual, Forecast.MW as Forecast from Forecast, Actual where Actual.Hour=Forecast.Hour and Actual.Date=(Forecast.Date+7);")

summary(lm(Actual~Forecast,data=Current))
```

```
## 
## Call:
## lm(formula = Actual ~ Forecast, data = Current)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
##  -5878   -656   -198    339  27905 
## 
## Coefficients:
##             Estimate Std. Error t value Pr(>|t|)    
## (Intercept) 2.66e+03   4.99e+01    53.2   <2e-16 ***
## Forecast    9.07e-01   1.89e-03   480.4   <2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 1590 on 31410 degrees of freedom
## Multiple R-squared:  0.88,	Adjusted R-squared:  0.88 
## F-statistic: 2.31e+05 on 1 and 31410 DF,  p-value: <2e-16
```

```r
summary(lm(Actual~Forecast,data=Lag))
```

```
## 
## Call:
## lm(formula = Actual ~ Forecast, data = Lag)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
## -10299   -984   -291    547  27222 
## 
## Coefficients:
##             Estimate Std. Error t value Pr(>|t|)    
## (Intercept) 4.12e+03   6.99e+01    58.9   <2e-16 ***
## Forecast    8.51e-01   2.64e-03   322.1   <2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 2200 on 30536 degrees of freedom
## Multiple R-squared:  0.773,	Adjusted R-squared:  0.773 
## F-statistic: 1.04e+05 on 1 and 30536 DF,  p-value: <2e-16
```
Looks like they report what the 7day ahead forecast was rather than what it is.  In other words Jan 1 shows what they had forecasted seven days ago not what they expect on the 8th.

Now lets deal with why there are different numbers on the match.  Here is a table of the number of observations in each day.


```r
table(table(Current$Date))
```

```
## 
##  23  24  25  92  96 216 
##   2 984   2   1  41  17
```

That is an interesting pattern.  Guessing there were dups.  Checking the Working and Raw


```r
table(table(CAISOWorking$OPR_DT))
```

```
## 
##  46  48  49  50  92  96 144 
##   2 983   1   2   1  41  17
```

```r
table(table(CAISORaw$OPR_DT))
```

```
## 
## 184 192 200 216 230 240 245 288 300 460 480 720 
##   1 365   1   6   1 573   1  39   1   1  41  17
```
Looks like we need a unique or something.


```r
table(table(unique(CAISOWorking)$OPR_DT))
```

```
## 
##   46   48   49   50   96 
##    3 1024    1    2   17
```

```r
table(table(CAISOWorking$OPR_DT))
```

```
## 
##  46  48  49  50  92  96 144 
##   2 983   1   2   1  41  17
```

```r
table(table(CAISORaw$OPR_DT))
```

```
## 
## 184 192 200 216 230 240 245 288 300 460 480 720 
##   1 365   1   6   1 573   1  39   1   1  41  17
```

```r
table(table(unique(CAISORaw)$OPR_DT))
```

```
## 
## 184 192 200 216 230 240 245 288 300 480 
##   1 365   1   6   2 614   1  39   1  17
```

Decide to only use the days with 48 obs.


```r
GoodDays<-names(table(CAISOWorking$OPR_DT)  )[table(CAISOWorking$OPR_DT)==48]
RevisedWorking<-CAISOWorking[is.element(CAISOWorking$OPR_DT,GoodDays),]
table(table(RevisedWorking$OPR_DT))
```

```
## 
##  48 
## 983
```

```r
Forecast<-RevisedWorking[RevisedWorking$MARKET_RUN_ID=="7DA",]
Actual<-RevisedWorking[RevisedWorking$MARKET_RUN_ID=="ACTUAL",]


Current<-sqldf("select Actual.Hour, Actual.Date, Actual.MW as Actual, Forecast.MW as Forecast from Forecast, Actual where Actual.Hour=Forecast.Hour and Actual.Date=Forecast.Date;")
save(Current,file="Current.Rdata")
```

Now get the google trends data in and attached.


```r
Trends<- read.csv("~/Forecast-Peak-With-Google-Trends/CAData/TrendsCAWeeklyEdited.csv")

#Extract the end of week.
library(stringr)
Trends$EndDate<-as.Date(str_sub(Trends$Week,14))
summary(Trends)
```

```
##                       Week        weather         traffic     
##  2004-01-04 - 2004-01-10:  1   Min.   : 16.0   Min.   : 3.00  
##  2004-01-11 - 2004-01-17:  1   1st Qu.: 30.0   1st Qu.: 5.00  
##  2004-01-18 - 2004-01-24:  1   Median : 39.0   Median : 6.00  
##  2004-01-25 - 2004-01-31:  1   Mean   : 40.9   Mean   : 6.27  
##  2004-02-01 - 2004-02-07:  1   3rd Qu.: 49.0   3rd Qu.: 7.00  
##  2004-02-08 - 2004-02-14:  1   Max.   :100.0   Max.   :15.00  
##  (Other)                :564                                  
##   restaurants        gas           movies        EndDate          
##  Min.   : 5.0   Min.   : 5.0   Min.   :19.0   Min.   :2004-01-10  
##  1st Qu.: 8.0   1st Qu.: 8.0   1st Qu.:24.0   1st Qu.:2006-10-01  
##  Median :10.0   Median : 9.0   Median :26.0   Median :2009-06-23  
##  Mean   :10.1   Mean   : 9.6   Mean   :26.4   Mean   :2009-06-23  
##  3rd Qu.:12.0   3rd Qu.:11.0   3rd Qu.:29.0   3rd Qu.:2012-03-15  
##  Max.   :18.0   Max.   :25.0   Max.   :44.0   Max.   :2014-12-06  
## 
```

Now lets hook this to the load and forecast data.


```r
library(sqldf)
Trends$LastDate<-Trends$EndDate+7

WTrends<-sqldf("select Current.*, Trends.* from Current, Trends where Current.Date>Trends.EndDate and Current.Date<=Trends.LastDate;   ")

summary(WTrends)
```

```
##       Hour            Date                Actual         Forecast    
##  1      :  983   Min.   :2012-01-01   Min.   :18035   Min.   :   64  
##  2      :  983   1st Qu.:2012-09-04   1st Qu.:23214   1st Qu.:22853  
##  3      :  983   Median :2013-07-07   Median :26363   Median :26310  
##  4      :  983   Mean   :2013-06-15   Mean   :26909   Mean   :26638  
##  5      :  983   3rd Qu.:2014-03-12   3rd Qu.:29357   3rd Qu.:29392  
##  6      :  983   Max.   :2014-11-30   Max.   :46682   Max.   :45635  
##  (Other):17694                                                       
##                       Week          weather        traffic    
##  2011-12-25 - 2011-12-31:  168   Min.   :32.0   Min.   :5.00  
##  2012-01-01 - 2012-01-07:  168   1st Qu.:43.0   1st Qu.:5.00  
##  2012-01-08 - 2012-01-14:  168   Median :49.0   Median :6.00  
##  2012-01-15 - 2012-01-21:  168   Mean   :51.9   Mean   :5.96  
##  2012-01-29 - 2012-02-04:  168   3rd Qu.:60.0   3rd Qu.:6.00  
##  2012-02-05 - 2012-02-11:  168   Max.   :98.0   Max.   :8.00  
##  (Other)                :22584                                
##   restaurants        gas           movies        EndDate          
##  Min.   :10.0   Min.   :10.0   Min.   :24.0   Min.   :2011-12-31  
##  1st Qu.:12.0   1st Qu.:11.0   1st Qu.:27.0   1st Qu.:2012-09-01  
##  Median :13.0   Median :11.0   Median :29.0   Median :2013-07-06  
##  Mean   :13.1   Mean   :11.4   Mean   :29.3   Mean   :2013-06-11  
##  3rd Qu.:14.0   3rd Qu.:12.0   3rd Qu.:31.0   3rd Qu.:2014-03-08  
##  Max.   :18.0   Max.   :20.0   Max.   :44.0   Max.   :2014-11-29  
##                                                                   
##     LastDate         
##  Min.   :2012-01-07  
##  1st Qu.:2012-09-08  
##  Median :2013-07-13  
##  Mean   :2013-06-18  
##  3rd Qu.:2014-03-15  
##  Max.   :2014-12-06  
## 
```

On to the modeling


```r
Base<-lm(Actual~Forecast,data=WTrends)
summary(Base)
```

```
## 
## Call:
## lm(formula = Actual ~ Forecast, data = WTrends)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
##  -5746   -777   -244    370  27371 
## 
## Coefficients:
##             Estimate Std. Error t value Pr(>|t|)    
## (Intercept) 3.19e+03   6.22e+01    51.3   <2e-16 ***
## Forecast    8.90e-01   2.29e-03   388.0   <2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 1800 on 23590 degrees of freedom
## Multiple R-squared:  0.865,	Adjusted R-squared:  0.865 
## F-statistic: 1.51e+05 on 1 and 23590 DF,  p-value: <2e-16
```

```r
WWeather<-lm(Actual~Forecast+weather,data=WTrends)
summary(WWeather)
```

```
## 
## Call:
## lm(formula = Actual ~ Forecast + weather, data = WTrends)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
##  -5772   -775   -239    374  27423 
## 
## Coefficients:
##              Estimate Std. Error t value Pr(>|t|)    
## (Intercept)  3.62e+03   9.24e+01   39.13  < 2e-16 ***
## Forecast     8.86e-01   2.38e-03  372.75  < 2e-16 ***
## weather     -6.19e+00   9.95e-01   -6.22  5.1e-10 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 1800 on 23589 degrees of freedom
## Multiple R-squared:  0.865,	Adjusted R-squared:  0.865 
## F-statistic: 7.54e+04 on 2 and 23589 DF,  p-value: <2e-16
```

```r
anova(Base,WWeather)
```

```
## Analysis of Variance Table
## 
## Model 1: Actual ~ Forecast
## Model 2: Actual ~ Forecast + weather
##   Res.Df      RSS Df Sum of Sq    F  Pr(>F)    
## 1  23590 7.63e+10                              
## 2  23589 7.62e+10  1  1.25e+08 38.7 5.1e-10 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

Concept proved.

Try counterfactuals


```r
summary(lm(Actual~Forecast+traffic,data=WTrends))
```

```
## 
## Call:
## lm(formula = Actual ~ Forecast + traffic, data = WTrends)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
##  -6088   -794   -181    486  25538 
## 
## Coefficients:
##             Estimate Std. Error t value Pr(>|t|)    
## (Intercept) 1.05e+02   9.73e+01    1.08     0.28    
## Forecast    8.69e-01   2.28e-03  380.29   <2e-16 ***
## traffic     6.15e+02   1.53e+01   40.35   <2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 1740 on 23589 degrees of freedom
## Multiple R-squared:  0.873,	Adjusted R-squared:  0.873 
## F-statistic: 8.13e+04 on 2 and 23589 DF,  p-value: <2e-16
```

```r
summary(lm(Actual~Forecast+restaurants,data=WTrends))
```

```
## 
## Call:
## lm(formula = Actual ~ Forecast + restaurants, data = WTrends)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
##  -5662   -778   -200    420  25905 
## 
## Coefficients:
##              Estimate Std. Error t value Pr(>|t|)    
## (Intercept) -2.58e+02   1.06e+02   -2.44    0.015 *  
## Forecast     8.86e-01   2.23e-03  397.98   <2e-16 ***
## restaurants  2.73e+02   6.87e+00   39.73   <2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 1740 on 23589 degrees of freedom
## Multiple R-squared:  0.873,	Adjusted R-squared:  0.873 
## F-statistic: 8.11e+04 on 2 and 23589 DF,  p-value: <2e-16
```

```r
summary(lm(Actual~Forecast+gas,data=WTrends))
```

```
## 
## Call:
## lm(formula = Actual ~ Forecast + gas, data = WTrends)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
##  -5829   -789   -238    389  27248 
## 
## Coefficients:
##              Estimate Std. Error t value Pr(>|t|)    
## (Intercept) 4008.1982   122.1007   32.83  < 2e-16 ***
## Forecast       0.8894     0.0023  387.42  < 2e-16 ***
## gas          -69.2703     8.9132   -7.77  8.1e-15 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 1800 on 23589 degrees of freedom
## Multiple R-squared:  0.865,	Adjusted R-squared:  0.865 
## F-statistic: 7.55e+04 on 2 and 23589 DF,  p-value: <2e-16
```

```r
summary(lm(Actual~Forecast+movies,data=WTrends))
```

```
## 
## Call:
## lm(formula = Actual ~ Forecast + movies, data = WTrends)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
##  -5922   -792   -234    393  26693 
## 
## Coefficients:
##             Estimate Std. Error t value Pr(>|t|)    
## (Intercept) 1.99e+03   1.06e+02    18.8   <2e-16 ***
## Forecast    8.89e-01   2.29e-03   388.1   <2e-16 ***
## movies      4.28e+01   3.06e+00    14.0   <2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 1790 on 23589 degrees of freedom
## Multiple R-squared:  0.866,	Adjusted R-squared:  0.866 
## F-statistic: 7.6e+04 on 2 and 23589 DF,  p-value: <2e-16
```
Well that sucks.  All the counterfactuals work too.  Check F test


```r
anova(Base,lm(Actual~Forecast+traffic,data=WTrends))
```

```
## Analysis of Variance Table
## 
## Model 1: Actual ~ Forecast
## Model 2: Actual ~ Forecast + traffic
##   Res.Df      RSS Df Sum of Sq    F Pr(>F)    
## 1  23590 7.63e+10                             
## 2  23589 7.14e+10  1  4.93e+09 1628 <2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

```r
anova(Base,lm(Actual~Forecast+restaurants,data=WTrends))
```

```
## Analysis of Variance Table
## 
## Model 1: Actual ~ Forecast
## Model 2: Actual ~ Forecast + restaurants
##   Res.Df      RSS Df Sum of Sq    F Pr(>F)    
## 1  23590 7.63e+10                             
## 2  23589 7.15e+10  1  4.79e+09 1579 <2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

```r
anova(Base,lm(Actual~Forecast+gas,data=WTrends))
```

```
## Analysis of Variance Table
## 
## Model 1: Actual ~ Forecast
## Model 2: Actual ~ Forecast + gas
##   Res.Df      RSS Df Sum of Sq    F  Pr(>F)    
## 1  23590 7.63e+10                              
## 2  23589 7.61e+10  1  1.95e+08 60.4 8.1e-15 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

```r
anova(Base,lm(Actual~Forecast+movies,data=WTrends))
```

```
## Analysis of Variance Table
## 
## Model 1: Actual ~ Forecast
## Model 2: Actual ~ Forecast + movies
##   Res.Df      RSS Df Sum of Sq   F Pr(>F)    
## 1  23590 7.63e+10                            
## 2  23589 7.57e+10  1  6.27e+08 196 <2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```
Now that is an interesting puzzel. 


```r
library(lmtest)
```

```
## Loading required package: zoo
## 
## Attaching package: 'zoo'
## 
## The following object is masked from 'package:base':
## 
##     as.Date, as.Date.numeric
```

```r
dwtest(Base)
```

```
## 
## 	Durbin-Watson test
## 
## data:  Base
## DW = 0.3341, p-value < 2.2e-16
## alternative hypothesis: true autocorrelation is greater than 0
```
There is autocorrelation


```r
dwtest(lm(Actual~Forecast+traffic,data=WTrends))
```

```
## 
## 	Durbin-Watson test
## 
## data:  lm(Actual ~ Forecast + traffic, data = WTrends)
## DW = 0.3858, p-value < 2.2e-16
## alternative hypothesis: true autocorrelation is greater than 0
```

```r
dwtest(lm(Actual~Forecast+restaurants,data=WTrends))
```

```
## 
## 	Durbin-Watson test
## 
## data:  lm(Actual ~ Forecast + restaurants, data = WTrends)
## DW = 0.3621, p-value < 2.2e-16
## alternative hypothesis: true autocorrelation is greater than 0
```

```r
dwtest(lm(Actual~Forecast+gas,data=WTrends))
```

```
## 
## 	Durbin-Watson test
## 
## data:  lm(Actual ~ Forecast + gas, data = WTrends)
## DW = 0.336, p-value < 2.2e-16
## alternative hypothesis: true autocorrelation is greater than 0
```

```r
dwtest(lm(Actual~Forecast+movies,data=WTrends))
```

```
## 
## 	Durbin-Watson test
## 
## data:  lm(Actual ~ Forecast + movies, data = WTrends)
## DW = 0.3389, p-value < 2.2e-16
## alternative hypothesis: true autocorrelation is greater than 0
```

Autocorreleation in everything.

Moving to a lag formulation like in the day ahead model.
Add the lags to dataset

```r
CopyWTrends<-WTrends
library(sqldf)

WLags<-sqldf("select WTrends.*, CopyWTrends.Actual as LActual, CopyWTrends.Forecast LForecast, CopyWTrends.weather as LWeather, CopyWTrends.traffic as LTraffic,CopyWTrends.gas as LGas, CopyWTrends.movies as LMovies from WTrends, CopyWTrends  where WTrends.Hour=CopyWTrends.Hour and WTrends.Date=(CopyWTrends.Date-7) ")

summary(WLags)
```

```
##       Hour            Date                Actual         Forecast    
##  1      :  956   Min.   :2012-01-01   Min.   :18446   Min.   :   64  
##  2      :  956   1st Qu.:2012-08-30   1st Qu.:23249   1st Qu.:22879  
##  3      :  956   Median :2013-07-03   Median :26390   Median :26332  
##  4      :  956   Mean   :2013-06-09   Mean   :26944   Mean   :26660  
##  5      :  956   3rd Qu.:2014-03-01   3rd Qu.:29401   3rd Qu.:29420  
##  6      :  956   Max.   :2014-11-23   Max.   :46682   Max.   :45635  
##  (Other):17208                                                       
##                       Week          weather        traffic    
##  2011-12-25 - 2011-12-31:  168   Min.   :32.0   Min.   :5.00  
##  2012-01-01 - 2012-01-07:  168   1st Qu.:43.0   1st Qu.:5.00  
##  2012-01-08 - 2012-01-14:  168   Median :49.0   Median :6.00  
##  2012-01-29 - 2012-02-04:  168   Mean   :51.6   Mean   :5.96  
##  2012-02-05 - 2012-02-11:  168   3rd Qu.:59.2   3rd Qu.:6.00  
##  2012-02-12 - 2012-02-18:  168   Max.   :98.0   Max.   :8.00  
##  (Other)                :21936                                
##   restaurants        gas           movies        EndDate          
##  Min.   :10.0   Min.   :10.0   Min.   :24.0   Min.   :2011-12-31  
##  1st Qu.:12.0   1st Qu.:11.0   1st Qu.:27.0   1st Qu.:2012-08-25  
##  Median :13.0   Median :11.0   Median :28.0   Median :2013-06-29  
##  Mean   :13.1   Mean   :11.4   Mean   :29.3   Mean   :2013-06-05  
##  3rd Qu.:14.0   3rd Qu.:12.0   3rd Qu.:31.0   3rd Qu.:2014-02-23  
##  Max.   :18.0   Max.   :20.0   Max.   :44.0   Max.   :2014-11-22  
##                                                                   
##     LastDate             LActual        LForecast        LWeather 
##  Min.   :2012-01-07   Min.   :18035   Min.   :   64   Min.   :32  
##  1st Qu.:2012-09-01   1st Qu.:23254   1st Qu.:22896   1st Qu.:43  
##  Median :2013-07-06   Median :26386   Median :26343   Median :49  
##  Mean   :2013-06-12   Mean   :26946   Mean   :26685   Mean   :52  
##  3rd Qu.:2014-03-02   3rd Qu.:29406   3rd Qu.:29444   3rd Qu.:60  
##  Max.   :2014-11-29   Max.   :46682   Max.   :45635   Max.   :98  
##                                                                   
##     LTraffic         LGas         LMovies    
##  Min.   :5.00   Min.   :10.0   Min.   :24.0  
##  1st Qu.:5.00   1st Qu.:11.0   1st Qu.:27.0  
##  Median :6.00   Median :11.0   Median :29.0  
##  Mean   :5.96   Mean   :11.4   Mean   :29.2  
##  3rd Qu.:6.00   3rd Qu.:12.0   3rd Qu.:31.0  
##  Max.   :8.00   Max.   :20.0   Max.   :44.0  
## 
```



```r
Base<-lm(Actual~-1 +(LActual+weather+LWeather)*Hour, data=WLags)

summary(Base)
```

```
## 
## Call:
## lm(formula = Actual ~ -1 + (LActual + weather + LWeather) * Hour, 
##     data = WLags)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
## -12092   -957   -184    775  12728 
## 
## Coefficients:
##                  Estimate Std. Error t value Pr(>|t|)    
## LActual          8.00e-01   3.53e-02   22.67  < 2e-16 ***
## weather         -4.42e+00   6.65e+00   -0.66  0.50676    
## LWeather        -7.46e+00   6.48e+00   -1.15  0.25007    
## Hour1            5.28e+03   1.10e+03    4.81  1.5e-06 ***
## Hour2            4.69e+03   1.17e+03    4.03  5.7e-05 ***
## Hour3            4.98e+03   1.22e+03    4.10  4.2e-05 ***
## Hour4            4.77e+03   1.27e+03    3.74  0.00018 ***
## Hour5            5.59e+03   1.29e+03    4.34  1.4e-05 ***
## Hour6            4.99e+03   1.27e+03    3.93  8.7e-05 ***
## Hour7            4.53e+03   1.07e+03    4.24  2.3e-05 ***
## Hour8            4.33e+03   9.43e+02    4.59  4.6e-06 ***
## Hour9            4.53e+03   9.69e+02    4.67  3.0e-06 ***
## Hour10           4.85e+03   9.66e+02    5.02  5.2e-07 ***
## Hour11           5.37e+03   9.19e+02    5.84  5.4e-09 ***
## Hour12           6.20e+03   8.68e+02    7.14  9.4e-13 ***
## Hour13           7.16e+03   8.22e+02    8.71  < 2e-16 ***
## Hour14           7.89e+03   7.75e+02   10.18  < 2e-16 ***
## Hour15           8.47e+03   7.45e+02   11.37  < 2e-16 ***
## Hour16           9.09e+03   7.30e+02   12.46  < 2e-16 ***
## Hour17           9.88e+03   7.35e+02   13.45  < 2e-16 ***
## Hour18           1.19e+04   7.84e+02   15.24  < 2e-16 ***
## Hour19           1.25e+04   8.54e+02   14.62  < 2e-16 ***
## Hour20           1.16e+04   9.07e+02   12.74  < 2e-16 ***
## Hour21           9.82e+03   9.23e+02   10.64  < 2e-16 ***
## Hour22           8.48e+03   9.39e+02    9.03  < 2e-16 ***
## Hour23           7.23e+03   9.78e+02    7.39  1.5e-13 ***
## Hour24           6.15e+03   1.03e+03    5.96  2.5e-09 ***
## LActual:Hour2    1.29e-02   5.32e-02    0.24  0.80873    
## LActual:Hour3   -3.67e-03   5.59e-02   -0.07  0.94758    
## LActual:Hour4    1.21e-03   5.85e-02    0.02  0.98351    
## LActual:Hour5   -3.18e-02   5.90e-02   -0.54  0.59065    
## LActual:Hour6   -6.56e-03   5.77e-02   -0.11  0.90953    
## LActual:Hour7    4.63e-03   5.10e-02    0.09  0.92771    
## LActual:Hour8    1.96e-02   4.65e-02    0.42  0.67399    
## LActual:Hour9    2.42e-02   4.58e-02    0.53  0.59703    
## LActual:Hour10   2.27e-02   4.45e-02    0.51  0.60910    
## LActual:Hour11   1.67e-02   4.26e-02    0.39  0.69477    
## LActual:Hour12   2.71e-03   4.11e-02    0.07  0.94739    
## LActual:Hour13  -1.41e-02   4.00e-02   -0.35  0.72372    
## LActual:Hour14  -2.16e-02   3.90e-02   -0.56  0.57881    
## LActual:Hour15  -2.40e-02   3.84e-02   -0.63  0.53162    
## LActual:Hour16  -2.93e-02   3.81e-02   -0.77  0.44119    
## LActual:Hour17  -4.37e-02   3.81e-02   -1.15  0.25043    
## LActual:Hour18  -9.74e-02   3.87e-02   -2.52  0.01184 *  
## LActual:Hour19  -1.29e-01   3.98e-02   -3.23  0.00123 ** 
## LActual:Hour20  -1.21e-01   4.09e-02   -2.96  0.00307 ** 
## LActual:Hour21  -7.45e-02   4.13e-02   -1.81  0.07105 .  
## LActual:Hour22  -4.27e-02   4.19e-02   -1.02  0.30802    
## LActual:Hour23  -2.51e-02   4.38e-02   -0.57  0.56630    
## LActual:Hour24  -1.18e-02   4.66e-02   -0.25  0.80091    
## weather:Hour2    6.71e-01   9.41e+00    0.07  0.94320    
## weather:Hour3    6.27e-01   9.41e+00    0.07  0.94684    
## weather:Hour4    1.18e+00   9.41e+00    0.13  0.89984    
## weather:Hour5    1.23e-01   9.39e+00    0.01  0.98956    
## weather:Hour6    1.08e+00   9.35e+00    0.12  0.90772    
## weather:Hour7    1.20e+00   9.23e+00    0.13  0.89633    
## weather:Hour8   -6.25e-01   9.20e+00   -0.07  0.94580    
## weather:Hour9   -2.89e+00   9.23e+00   -0.31  0.75447    
## weather:Hour10  -5.57e+00   9.28e+00   -0.60  0.54803    
## weather:Hour11  -8.55e+00   9.31e+00   -0.92  0.35854    
## weather:Hour12  -1.18e+01   9.34e+00   -1.26  0.20755    
## weather:Hour13  -1.60e+01   9.35e+00   -1.71  0.08750 .  
## weather:Hour14  -1.91e+01   9.35e+00   -2.04  0.04139 *  
## weather:Hour15  -2.16e+01   9.36e+00   -2.31  0.02101 *  
## weather:Hour16  -2.44e+01   9.36e+00   -2.60  0.00920 ** 
## weather:Hour17  -2.83e+01   9.37e+00   -3.03  0.00249 ** 
## weather:Hour18  -3.13e+01   9.37e+00   -3.34  0.00084 ***
## weather:Hour19  -2.79e+01   9.39e+00   -2.97  0.00295 ** 
## weather:Hour20  -2.43e+01   9.37e+00   -2.60  0.00941 ** 
## weather:Hour21  -2.06e+01   9.34e+00   -2.21  0.02724 *  
## weather:Hour22  -1.82e+01   9.34e+00   -1.94  0.05199 .  
## weather:Hour23  -1.29e+01   9.35e+00   -1.38  0.16663    
## weather:Hour24  -7.85e+00   9.37e+00   -0.84  0.40214    
## LWeather:Hour2   1.26e+00   9.19e+00    0.14  0.89107    
## LWeather:Hour3   5.87e-01   9.18e+00    0.06  0.94906    
## LWeather:Hour4   1.05e+00   9.19e+00    0.11  0.90878    
## LWeather:Hour5   9.15e-01   9.16e+00    0.10  0.92049    
## LWeather:Hour6   4.46e+00   9.12e+00    0.49  0.62493    
## LWeather:Hour7   1.37e+01   9.03e+00    1.52  0.12914    
## LWeather:Hour8   1.70e+01   9.02e+00    1.88  0.05952 .  
## LWeather:Hour9   1.66e+01   9.05e+00    1.83  0.06653 .  
## LWeather:Hour10  1.69e+01   9.09e+00    1.86  0.06305 .  
## LWeather:Hour11  1.59e+01   9.12e+00    1.74  0.08117 .  
## LWeather:Hour12  1.28e+01   9.14e+00    1.40  0.16167    
## LWeather:Hour13  9.16e+00   9.15e+00    1.00  0.31669    
## LWeather:Hour14  4.44e+00   9.16e+00    0.48  0.62781    
## LWeather:Hour15 -1.20e+00   9.16e+00   -0.13  0.89585    
## LWeather:Hour16 -5.91e+00   9.17e+00   -0.64  0.51906    
## LWeather:Hour17 -7.15e+00   9.18e+00   -0.78  0.43592    
## LWeather:Hour18 -9.08e+00   9.16e+00   -0.99  0.32176    
## LWeather:Hour19 -4.02e+00   9.14e+00   -0.44  0.66050    
## LWeather:Hour20  4.97e+00   9.13e+00    0.54  0.58655    
## LWeather:Hour21  5.80e+00   9.15e+00    0.63  0.52606    
## LWeather:Hour22  4.31e+00   9.18e+00    0.47  0.63894    
## LWeather:Hour23  3.46e+00   9.18e+00    0.38  0.70616    
## LWeather:Hour24  2.88e+00   9.19e+00    0.31  0.75429    
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 2150 on 22848 degrees of freedom
## Multiple R-squared:  0.994,	Adjusted R-squared:  0.994 
## F-statistic: 3.85e+04 on 96 and 22848 DF,  p-value: <2e-16
```

```r
dwtest(Base)
```

```
## 
## 	Durbin-Watson test
## 
## data:  Base
## DW = 0.5058, p-value < 2.2e-16
## alternative hypothesis: true autocorrelation is greater than 0
```

Buahhahah  It works better for the peak hours.  There is still AR


```r
library(nlme)
#ARbyHourDay<-gls(Actual~-1 +(LActual+weather+LWeather), data=WLags,corAR1(form=~1),na.action=na.omit)
```
Gona need a bigger boat.  3.9Gb.
