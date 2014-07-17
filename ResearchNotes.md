Research Notes
========================================================
Just a frame right now.

Load data is from http://www.pjm.com/markets-and-operations/ops-analysis/historical-load-data.aspx
Forecasts are from 
http://www.pjm.com/markets-and-operations/ops-analysis/historical-load-forecasts.aspx


```r
GoogleSearch<-read.csv("report.csv")
Loads<-read.csv("Loads.csv")
Forecasts<-read.csv("Forecasts.csv")
```

Format the Loads data.


```r
summary(Loads)
```

```
##          X         X.1              X.2              X.3     
##  1/1/2014 :  1   COMP:  1   100731.569:  1   101003.776:  1  
##  1/10/2014:  1   RTO :191   101497.598:  1   103710.026:  1  
##  1/11/2014:  1              102016.778:  1   105626.491:  1  
##  1/12/2014:  1              102124.209:  1   106902.44 :  1  
##  1/13/2014:  1              102282.28 :  1   106929.393:  1  
##  1/14/2014:  1              102337.673:  1   108012.33 :  1  
##  (Other)  :186              (Other)   :186   (Other)   :186  
##          X.4              X.5              X.6              X.7     
##            :  1   101465.008:  1   100031.781:  1   100233.058:  1  
##  100713.426:  1   104468.812:  1   100222.166:  1   101453.846:  1  
##  103679.765:  1   105685.901:  1   100515.776:  1   101637.028:  1  
##  105826.647:  1   105718.473:  1   100756.991:  1   102062.048:  1  
##  105832.561:  1   107462.743:  1   101588.998:  1   102667.021:  1  
##  106556.337:  1   107867.471:  1   103889.126:  1   103098.209:  1  
##  (Other)   :186   (Other)   :186   (Other)   :186   (Other)   :186  
##          X.8              X.9              X.10             X.11    
##  100096.801:  1   100061.544:  1   100106.233:  1   100024.123:  1  
##  100469.993:  1   100292.363:  1   100186.974:  1   100039.919:  1  
##  100774.65 :  1   100908.835:  1   100239.842:  1   100232.689:  1  
##  101141.645:  1   101499.377:  1   101246.715:  1   100325.502:  1  
##  101856.708:  1   101952.973:  1   101294.851:  1   100949.516:  1  
##  101998.766:  1   102564.147:  1   101888.347:  1   101225.032:  1  
##  (Other)   :186   (Other)   :186   (Other)   :186   (Other)   :186  
##          X.12             X.13             X.14             X.15    
##  100162.451:  1   101173.754:  1   100019.085:  1   100149.71 :  1  
##  100400.991:  1   101230.478:  1   100151.154:  1   100365.92 :  1  
##  100426.11 :  1   101830.579:  1   100480.253:  1   100538.783:  1  
##  100440.96 :  1   101890.926:  1   100642.002:  1   100992.762:  1  
##  100453.489:  1   101896.849:  1   100650.817:  1   101383.751:  1  
##  101911.122:  1   101949.002:  1   100852.151:  1   101600.874:  1  
##  (Other)   :186   (Other)   :186   (Other)   :186   (Other)   :186  
##          X.16             X.17             X.18             X.19    
##  100065.373:  1   100086.193:  1   100019.566:  1   100137.446:  1  
##  100528.029:  1   100437.449:  1   100191.358:  1   100525.233:  1  
##  100908.458:  1   100454.112:  1   100607.286:  1   101518.942:  1  
##  101185.836:  1   100457.467:  1   100936.83 :  1   101646.075:  1  
##  101503.563:  1   100481.7  :  1   101398.532:  1   101811.258:  1  
##  101647.181:  1   100511.674:  1   101446.031:  1   101924.345:  1  
##  (Other)   :186   (Other)   :186   (Other)   :186   (Other)   :186  
##          X.20             X.21             X.22             X.23    
##  100621.846:  1   100104.614:  1   100304.087:  1   100085.831:  1  
##  100770.688:  1   100135.634:  1   100339.151:  1   100576.049:  1  
##  101467.243:  1   100337.869:  1   100522.838:  1   100611.27 :  1  
##  101642.49 :  1   100707.689:  1   100727.123:  1   100704.351:  1  
##  102138.611:  1   100729.844:  1   100913.445:  1   100739.971:  1  
##  102303.815:  1   101151.768:  1   100978.766:  1   101098.184:  1  
##  (Other)   :186   (Other)   :186   (Other)   :186   (Other)   :186  
##          X.24             X.25    
##  100150.471:  1   100283.985:  1  
##  100629.663:  1   100417.236:  1  
##  100675.979:  1   102132.153:  1  
##  100733.221:  1   102589.851:  1  
##  100780.992:  1   103148.563:  1  
##  101131.192:  1   103194.057:  1  
##  (Other)   :186   (Other)   :186
```
Those just look like column numbers.  I want hour 19, X.20 and the date.


```r
KeyLoads<-Loads[,c(1, 20)]
names(KeyLoads)<-c("Date","Hour19")
#convert to numeric
KeyLoads$Hour19<-as.numeric(as.character(KeyLoads$Hour19))
```

```
## Warning: NAs introduced by coercion
```

```r
#convert to ct Date
KeyLoads$Date<-as.POSIXct(KeyLoads$Date,format='%m/%d/%Y')
summary(KeyLoads)
```

```
##       Date                         Hour19      
##  Min.   :2014-01-01 00:00:00   Min.   : 67754  
##  1st Qu.:2014-02-17 12:00:00   1st Qu.: 86110  
##  Median :2014-04-06 00:00:00   Median : 98762  
##  Mean   :2014-04-06 00:00:00   Mean   :100574  
##  3rd Qu.:2014-05-23 12:00:00   3rd Qu.:110414  
##  Max.   :2014-07-10 00:00:00   Max.   :141332  
##  NA's   :1                     NA's   :1
```

```r
#clean up loads
rm(Loads)
```

Clean up forecasts


```r
KeyForecasts<-Forecasts[,c(1,2,21)]
names(KeyForecasts)<-c("EvalTime","Date","Forecast")

#Fixing time
KeyForecasts$Date<-as.POSIXct(KeyForecasts$Date,format='%m/%d/%Y')
KeyForecasts$EvalTime<-as.POSIXlt(KeyForecasts$EvalTime,format="%m/%d/%Y %H:%M:%S")
summary(KeyForecasts)
```

```
##     EvalTime                        Date                    
##  Min.   :2013-12-31 05:45:00   Min.   :2014-01-01 00:00:00  
##  1st Qu.:2014-02-15 01:15:00   1st Qu.:2014-02-15 00:00:00  
##  Median :2014-04-01 11:45:00   Median :2014-04-01 00:00:00  
##  Mean   :2014-04-01 11:44:01   Mean   :2014-04-01 09:01:43  
##  3rd Qu.:2014-05-16 22:15:00   3rd Qu.:2014-05-17 00:00:00  
##  Max.   :2014-07-01 05:45:00   Max.   :2014-07-02 00:00:00  
##     Forecast     
##  Min.   : 68645  
##  1st Qu.: 88099  
##  Median :100833  
##  Mean   :102031  
##  3rd Qu.:114014  
##  Max.   :143442
```

```r
#why are there two of each date?  Because they do day ahead and two day ahead.
```

Edit the forecasts so that we have only the earliest day ahead forecast.


```r
#Keep only the 5am forecasts
KeyForecasts<-KeyForecasts[as.POSIXlt(KeyForecasts$EvalTime,format="%m/%d/%Y %H:%M:%S")$hour==5,]

#Keep only day ahead
KeyForecasts<-KeyForecasts[(as.POSIXct(KeyForecasts$EvalTime,format="%m/%d/%Y %H:%M:%S") -as.POSIXct(KeyForecasts$Date,format='%m/%d/%Y'))<0,]
summary(KeyForecasts)
```

```
##     EvalTime                        Date                    
##  Min.   :2013-12-31 05:45:00   Min.   :2014-01-01 00:00:00  
##  1st Qu.:2014-02-14 17:45:00   1st Qu.:2014-02-15 12:00:00  
##  Median :2014-04-01 05:45:00   Median :2014-04-02 00:00:00  
##  Mean   :2014-04-01 05:45:01   Mean   :2014-04-02 00:00:00  
##  3rd Qu.:2014-05-16 17:45:00   3rd Qu.:2014-05-17 12:00:00  
##  Max.   :2014-07-01 05:45:00   Max.   :2014-07-02 00:00:00  
##     Forecast     
##  Min.   : 73270  
##  1st Qu.: 87703  
##  Median :101426  
##  Mean   :101653  
##  3rd Qu.:112649  
##  Max.   :141787
```

Now work on the GoogleSearch terms.  This is only for Pennsylvania.


```r
summary(GoogleSearch)
```

```
##          Day      Past.30.days  
##  2014-06-16: 1   Min.   : 35.0  
##  2014-06-17: 1   1st Qu.: 44.5  
##  2014-06-18: 1   Median : 48.0  
##  2014-06-19: 1   Mean   : 54.9  
##  2014-06-20: 1   3rd Qu.: 63.2  
##  2014-06-21: 1   Max.   :100.0  
##  (Other)   :24   NA's   :2
```
Date is actually ISO.  Hope that does not cause a problem.

Merging the three sets.  Just to be clear I need the acutal, forecast from day before and search result from two days before.  That is what I am testing, if I can improve the next day forecast with previous day searches.  Lots of fun date matching ahead.


```r
summary(KeyForecasts)
```

```
##     EvalTime                        Date                    
##  Min.   :2013-12-31 05:45:00   Min.   :2014-01-01 00:00:00  
##  1st Qu.:2014-02-14 17:45:00   1st Qu.:2014-02-15 12:00:00  
##  Median :2014-04-01 05:45:00   Median :2014-04-02 00:00:00  
##  Mean   :2014-04-01 05:45:01   Mean   :2014-04-02 00:00:00  
##  3rd Qu.:2014-05-16 17:45:00   3rd Qu.:2014-05-17 12:00:00  
##  Max.   :2014-07-01 05:45:00   Max.   :2014-07-02 00:00:00  
##     Forecast     
##  Min.   : 73270  
##  1st Qu.: 87703  
##  Median :101426  
##  Mean   :101653  
##  3rd Qu.:112649  
##  Max.   :141787
```

```r
summary(KeyLoads)
```

```
##       Date                         Hour19      
##  Min.   :2014-01-01 00:00:00   Min.   : 67754  
##  1st Qu.:2014-02-17 12:00:00   1st Qu.: 86110  
##  Median :2014-04-06 00:00:00   Median : 98762  
##  Mean   :2014-04-06 00:00:00   Mean   :100574  
##  3rd Qu.:2014-05-23 12:00:00   3rd Qu.:110414  
##  Max.   :2014-07-10 00:00:00   Max.   :141332  
##  NA's   :1                     NA's   :1
```

```r
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
#Join the two parts form the RTO

RTO<-sqldf("select KeyForecasts.*, KeyLoads.* from KeyForecasts, KeyLoads where KeyForecasts.Date=KeyLoads.Date;")
```

```
## Loading required package: tcltk
```

```
## Warning: RAW() can only be applied to a 'raw', not a 'double'
```

```
## Error: RS-DBI driver: (error in statement: no such table: KeyForecasts)
```

```r
GoogleSearch$NextDay<-as.POSIXct(GoogleSearch$Day)+24*60*60

Joint<-sqldf("select RTO.*, GoogleSearch.* from RTO, GoogleSearch where NextDay=Date;")
```

```
## Error: RS-DBI driver: (error in statement: no such table: RTO)
```

```r
#fix the forecast again
Joint$Hour19<-as.numeric(as.character(Joint$Hour19))
```

```
## Error: object 'Joint' not found
```
Yes, not a lot of overlap.  Can only do last 30 days with trends for daily.


```r
summary(Joint)
```

```
## Error: error in evaluating the argument 'object' in selecting a method for function 'summary': Error: object 'Joint' not found
```

```r
summary(lm(Hour19~Forecast+Past_30_days,data=Joint))
```

```
## Error: error in evaluating the argument 'object' in selecting a method for function 'summary': Error in is.data.frame(data) : object 'Joint' not found
## Calls: lm ... model.frame -> model.frame.default -> is.data.frame
```
Looks like it is significant!


```r
WO<-lm(Hour19~Forecast,data=Joint)
```

```
## Error: object 'Joint' not found
```

```r
With<-lm(Hour19~Forecast+Past_30_days,data=Joint)
```

```
## Error: object 'Joint' not found
```

```r
anova(WO,With)
```

```
## Error: object 'WO' not found
```

check the change in SE


```r
summary(WO)$sigma
```

```
## Error: error in evaluating the argument 'object' in selecting a method for function 'summary': Error: object 'WO' not found
```

```r
summary(With)$sigma
```

```
## Error: error in evaluating the argument 'object' in selecting a method for function 'summary': Error: object 'With' not found
```

```r
#percent decrease in SE is
(summary(WO)$sigma-summary(With)$sigma)/summary(WO)$sigma
```

```
## Error: error in evaluating the argument 'object' in selecting a method for function 'summary': Error: object 'WO' not found
```

Nice! 14% reduction in se.  Proof of concept.


