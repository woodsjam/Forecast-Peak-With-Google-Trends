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


