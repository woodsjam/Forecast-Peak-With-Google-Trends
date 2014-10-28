Working with the Long Data and heading to an AR model
========================================================

Load in data

```r
load("~/Forecast-Peak-With-Google-Trends/LongWtrends.RData")
summary(LongWtrends)
```

```
##       Date                          hour         DETrendsW    
##  Min.   :2014-01-01 08:00:00   Min.   : 1.00   Min.   : 14.0  
##  1st Qu.:2014-03-03 02:00:00   1st Qu.: 6.75   1st Qu.: 24.0  
##  Median :2014-05-03 19:00:00   Median :12.50   Median : 31.5  
##  Mean   :2014-05-03 12:35:24   Mean   :12.50   Mean   : 34.3  
##  3rd Qu.:2014-07-03 13:00:00   3rd Qu.:18.25   3rd Qu.: 40.0  
##  Max.   :2014-09-02 07:00:00   Max.   :24.00   Max.   :100.0  
##                                                NA's   :2736   
##    KYTrendsW       MDTrendsW       NJTrendsW       OHTrendsW    
##  Min.   : 17.0   Min.   : 21.0   Min.   : 26.0   Min.   : 23.0  
##  1st Qu.: 27.0   1st Qu.: 30.0   1st Qu.: 34.0   1st Qu.: 33.0  
##  Median : 34.5   Median : 39.0   Median : 42.0   Median : 41.0  
##  Mean   : 37.1   Mean   : 41.2   Mean   : 43.4   Mean   : 43.4  
##  3rd Qu.: 43.0   3rd Qu.: 50.0   3rd Qu.: 50.0   3rd Qu.: 51.0  
##  Max.   :100.0   Max.   :100.0   Max.   :100.0   Max.   :100.0  
##  NA's   :2736    NA's   :2736    NA's   :2736    NA's   :2736   
##    PATrendsW       VATrendsW       WVTrendsW          TrendDate   
##  Min.   : 33.0   Min.   : 17.0   Min.   : 15.0   2014-04-24:  24  
##  1st Qu.: 42.0   1st Qu.: 26.0   1st Qu.: 29.0   2014-04-25:  24  
##  Median : 53.5   Median : 33.0   Median : 41.5   2014-04-26:  24  
##  Mean   : 54.3   Mean   : 36.7   Mean   : 42.4   2014-04-27:  24  
##  3rd Qu.: 65.0   3rd Qu.: 43.0   3rd Qu.: 53.0   2014-04-28:  24  
##  Max.   :100.0   Max.   :100.0   Max.   :100.0   (Other)   :3000  
##  NA's   :2736    NA's   :2736    NA's   :2736    NA's      :2736  
##     Weather        weatherL7          F                HE        
##  Min.   :27.4   27.58884:  24   Min.   : 59314   Min.   : 57540  
##  1st Qu.:34.5   27.66288:  24   1st Qu.: 81505   1st Qu.: 80636  
##  Median :43.5   28.38560:  24   Median : 92993   Median : 92354  
##  Mean   :44.0   28.76009:  24   Mean   : 93999   Mean   : 93483  
##  3rd Qu.:50.5   28.85798:  24   3rd Qu.:106020   3rd Qu.:105946  
##  Max.   :81.9   (Other) :2832   Max.   :146930   Max.   :141674  
##  NA's   :2736   NA's    :2904   NA's   :1        NA's   :4
```

Data handling

```r
LongWtrends$hour<-as.factor(LongWtrends$hour)
```


