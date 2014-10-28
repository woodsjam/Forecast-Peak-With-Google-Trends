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

#create a date only variable not date time
LongWtrends$DateOnly<-as.Date(LongWtrends$Date)

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
#used to merge on the lagged values
CopyLong<-LongWtrends

LagFormData<-sqldf("select  LongWtrends.DateOnly, LongWtrends.hour, LongWtrends.F, LongWtrends.HE, CopyLong.F as LagF, CopyLong.HE as LagHE, LongWtrends.Weather, CopyLong.Weather as LagWeather  from LongWtrends,CopyLong where LongWtrends.DateOnly=(CopyLong.DateOnly+7) and LongWtrends.hour=CopyLong.hour;   ")
```

```
## Loading required package: tcltk
```

```r
summary(LagFormData)
```

```
##     DateOnly               hour            F                HE        
##  Min.   :2014-01-08   1      : 236   Min.   : 59314   Min.   : 57540  
##  1st Qu.:2014-03-07   2      : 236   1st Qu.: 80947   1st Qu.: 80126  
##  Median :2014-05-07   3      : 236   Median : 92445   Median : 91822  
##  Mean   :2014-05-06   4      : 236   Mean   : 93630   Mean   : 93022  
##  3rd Qu.:2014-07-05   5      : 236   3rd Qu.:105746   3rd Qu.:105452  
##  Max.   :2014-09-02   6      : 236   Max.   :146930   Max.   :141674  
##                       (Other):4248   NA's   :1        NA's   :4       
##       LagF            LagHE           Weather       LagWeather  
##  Min.   : 59314   Min.   : 57540   Min.   :27.4   Min.   :27.6  
##  1st Qu.: 81384   1st Qu.: 80575   1st Qu.:34.5   1st Qu.:35.0  
##  Median : 92712   Median : 92060   Median :43.5   Median :43.9  
##  Mean   : 93761   Mean   : 93231   Mean   :44.0   Mean   :44.5  
##  3rd Qu.:105584   3rd Qu.:105596   3rd Qu.:50.5   3rd Qu.:51.0  
##  Max.   :146930   Max.   :141674   Max.   :81.9   Max.   :81.9  
##  NA's   :1        NA's   :4        NA's   :2544   NA's   :2712
```

First test regression for hour 19


```r
summary(lm(HE~F+LagHE+Weather+LagWeather,data=LagFormData[LagFormData$hour=='19',]   ))
```

```
## 
## Call:
## lm(formula = HE ~ F + LagHE + Weather + LagWeather, data = LagFormData[LagFormData$hour == 
##     "19", ])
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
## -12374  -1595    220   1937   8178 
## 
## Coefficients:
##              Estimate Std. Error t value Pr(>|t|)    
## (Intercept) 3955.5588  3847.0121    1.03    0.306    
## F              0.9603     0.0288   33.30   <2e-16 ***
## LagHE          0.0100     0.0283    0.35    0.724    
## Weather      -74.1232    29.5653   -2.51    0.014 *  
## LagWeather    39.4274    30.8760    1.28    0.204    
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 3280 on 118 degrees of freedom
##   (113 observations deleted due to missingness)
## Multiple R-squared:  0.954,	Adjusted R-squared:  0.952 
## F-statistic:  609 on 4 and 118 DF,  p-value: <2e-16
```

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
dwtest(HE~F+LagHE+Weather+LagWeather,data=LagFormData[LagFormData$hour=='19',])
```

```
## 
## 	Durbin-Watson test
## 
## data:  HE ~ F + LagHE + Weather + LagWeather
## DW = 1.038, p-value = 1.137e-08
## alternative hypothesis: true autocorrelation is greater than 0
```

Looks nice.  Lets do AR

```r
library(nlme)
summary(gls(HE~F+LagHE+Weather+LagWeather, data=LagFormData[LagFormData$hour=='19',],corAR1(form=~1),na.action=na.omit))
```

```
## Generalized least squares fit by REML
##   Model: HE ~ F + LagHE + Weather + LagWeather 
##   Data: LagFormData[LagFormData$hour == "19", ] 
##    AIC  BIC logLik
##   2293 2313  -1140
## 
## Correlation Structure: AR(1)
##  Formula: ~1 
##  Parameter estimate(s):
##    Phi 
## 0.5405 
## 
## Coefficients:
##              Value Std.Error t-value p-value
## (Intercept) 2784.9      4321   0.645  0.5205
## F              1.0         0  29.573  0.0000
## LagHE          0.0         0  -0.678  0.4993
## Weather      -38.4        30  -1.276  0.2046
## LagWeather    -0.4        30  -0.012  0.9907
## 
##  Correlation: 
##            (Intr) F      LagHE  Weathr
## F          -0.447                     
## LagHE      -0.393 -0.569              
## Weather    -0.469  0.304 -0.106       
## LagWeather -0.485 -0.129  0.363 -0.022
## 
## Standardized residuals:
##      Min       Q1      Med       Q3      Max 
## -3.88007 -0.43828 -0.02362  0.56706  2.21040 
## 
## Residual standard error: 3376 
## Degrees of freedom: 123 total; 118 residual
```

So the action goes away.  Lets assume AR structure is with previous previous day within hour.  This will take a while to run.  There are a lot of parameters.



```r
LagFormData<-sqldf("select * from LagFormData order by hour, DateOnly;")

summary(gls(HE~hour+(F+LagHE+Weather+LagWeather):hour, data=LagFormData,corAR1(form=~1),na.action=na.omit))$tTable
```

```
##                        Value Std.Error   t-value    p-value
## (Intercept)        2.058e+02 4.002e+03  0.051422  9.590e-01
## hour2              3.642e+02 5.765e+03  0.063175  9.496e-01
## hour3              6.202e+02 5.866e+03  0.105730  9.158e-01
## hour4             -4.030e+01 5.909e+03 -0.006820  9.946e-01
## hour5              8.951e+01 5.765e+03  0.015525  9.876e-01
## hour6             -1.324e+02 5.288e+03 -0.025037  9.800e-01
## hour7              1.301e+03 4.808e+03  0.270565  7.867e-01
## hour8              8.803e+02 4.686e+03  0.187839  8.510e-01
## hour9             -1.630e+01 4.756e+03 -0.003428  9.973e-01
## hour10            -3.044e+02 4.869e+03 -0.062513  9.502e-01
## hour11            -6.425e+02 4.873e+03 -0.131849  8.951e-01
## hour12            -6.770e+02 4.884e+03 -0.138625  8.898e-01
## hour13            -4.079e+02 4.885e+03 -0.083493  9.335e-01
## hour14             7.408e+02 4.864e+03  0.152321  8.789e-01
## hour15             1.725e+03 4.857e+03  0.355277  7.224e-01
## hour16             2.499e+03 4.868e+03  0.513381  6.077e-01
## hour17             3.061e+03 4.895e+03  0.625301  5.318e-01
## hour18             3.005e+03 4.943e+03  0.608036  5.432e-01
## hour19             3.260e+03 5.013e+03  0.650173  5.156e-01
## hour20             1.324e+03 5.112e+03  0.259001  7.957e-01
## hour21             2.371e+03 5.262e+03  0.450481  6.524e-01
## hour22             4.879e+03 5.399e+03  0.903668  3.662e-01
## hour23             5.515e+03 5.542e+03  0.995238  3.197e-01
## hour24             5.238e+03 5.705e+03  0.918181  3.586e-01
## hour1:F            9.888e-01 4.452e-02 22.211050 6.843e-101
## hour2:F            9.876e-01 4.929e-02 20.036416  1.268e-83
## hour3:F            9.884e-01 5.373e-02 18.395366  1.774e-71
## hour4:F            9.919e-01 5.727e-02 17.319084  5.942e-64
## hour5:F            9.914e-01 5.826e-02 17.017146  6.604e-62
## hour6:F            9.923e-01 5.390e-02 18.408753  1.423e-71
## hour7:F            9.849e-01 4.398e-02 22.392467 2.176e-102
## hour8:F            1.008e+00 3.838e-02 26.276347 2.299e-136
## hour9:F            1.024e+00 3.686e-02 27.784833 1.850e-150
## hour10:F           1.023e+00 3.448e-02 29.685052 7.722e-169
## hour11:F           1.005e+00 3.122e-02 32.190932 5.058e-194
## hour12:F           9.913e-01 2.825e-02 35.091909 2.540e-224
## hour13:F           9.814e-01 2.595e-02 37.820749 9.661e-254
## hour14:F           9.669e-01 2.422e-02 39.918837 7.531e-277
## hour15:F           9.640e-01 2.315e-02 41.642202 4.337e-296
## hour16:F           9.664e-01 2.256e-02 42.830474 1.809e-309
## hour17:F           9.724e-01 2.237e-02 43.474582 9.354e-317
## hour18:F           9.832e-01 2.277e-02 43.189910 1.563e-313
## hour19:F           9.939e-01 2.378e-02 41.800664 7.210e-298
## hour20:F           1.018e+00 2.581e-02 39.464739 8.123e-272
## hour21:F           1.031e+00 2.832e-02 36.424442 1.373e-238
## hour22:F           1.027e+00 3.063e-02 33.514833 1.036e-207
## hour23:F           1.017e+00 3.420e-02 29.740555 2.193e-169
## hour24:F           1.010e+00 3.889e-02 25.968740 1.506e-133
## hour1:LagHE        9.453e-03 4.313e-02  0.219169  8.265e-01
## hour2:LagHE        1.050e-02 4.808e-02  0.218389  8.271e-01
## hour3:LagHE        7.612e-03 5.250e-02  0.144988  8.847e-01
## hour4:LagHE        1.339e-02 5.611e-02  0.238624  8.114e-01
## hour5:LagHE        1.311e-02 5.750e-02  0.227970  8.197e-01
## hour6:LagHE        1.857e-02 5.345e-02  0.347389  7.283e-01
## hour7:LagHE        1.799e-02 4.411e-02  0.407863  6.834e-01
## hour8:LagHE       -4.959e-03 3.848e-02 -0.128869  8.975e-01
## hour9:LagHE       -1.290e-02 3.660e-02 -0.352409  7.246e-01
## hour10:LagHE      -1.103e-02 3.407e-02 -0.323751  7.462e-01
## hour11:LagHE       9.010e-03 3.078e-02  0.292716  7.698e-01
## hour12:LagHE       2.096e-02 2.779e-02  0.754351  4.507e-01
## hour13:LagHE       2.831e-02 2.551e-02  1.109999  2.671e-01
## hour14:LagHE       3.409e-02 2.397e-02  1.422307  1.550e-01
## hour15:LagHE       3.080e-02 2.295e-02  1.341866  1.797e-01
## hour16:LagHE       2.381e-02 2.231e-02  1.067411  2.859e-01
## hour17:LagHE       1.201e-02 2.201e-02  0.545655  5.853e-01
## hour18:LagHE      -2.647e-03 2.223e-02 -0.119076  9.052e-01
## hour19:LagHE      -1.765e-02 2.309e-02 -0.764530  4.446e-01
## hour20:LagHE      -2.697e-02 2.483e-02 -1.086183  2.775e-01
## hour21:LagHE      -4.093e-02 2.737e-02 -1.495489  1.349e-01
## hour22:LagHE      -6.234e-02 2.968e-02 -2.100205  3.580e-02
## hour23:LagHE      -6.495e-02 3.311e-02 -1.961663  4.990e-02
## hour24:LagHE      -5.957e-02 3.764e-02 -1.582807  1.136e-01
## hour1:Weather     -4.016e+01 2.212e+01 -1.815356  6.957e-02
## hour2:Weather     -3.934e+01 2.201e+01 -1.786847  7.407e-02
## hour3:Weather     -3.870e+01 2.193e+01 -1.764684  7.772e-02
## hour4:Weather     -3.605e+01 2.182e+01 -1.652637  9.852e-02
## hour5:Weather     -3.584e+01 2.174e+01 -1.648696  9.932e-02
## hour6:Weather     -3.850e+01 2.157e+01 -1.784962  7.437e-02
## hour7:Weather     -4.885e+01 2.138e+01 -2.285137  2.238e-02
## hour8:Weather     -4.664e+01 2.142e+01 -2.176904  2.957e-02
## hour9:Weather     -4.924e+01 2.171e+01 -2.268487  2.337e-02
## hour10:Weather    -4.826e+01 2.182e+01 -2.212085  2.704e-02
## hour11:Weather    -5.679e+01 2.195e+01 -2.587725  9.711e-03
## hour12:Weather    -6.304e+01 2.202e+01 -2.863094  4.226e-03
## hour13:Weather    -6.922e+01 2.202e+01 -3.143381  1.687e-03
## hour14:Weather    -7.518e+01 2.201e+01 -3.415191  6.463e-04
## hour15:Weather    -7.702e+01 2.194e+01 -3.510006  4.551e-04
## hour16:Weather    -7.515e+01 2.187e+01 -3.436609  5.975e-04
## hour17:Weather    -6.621e+01 2.180e+01 -3.036875  2.412e-03
## hour18:Weather    -5.221e+01 2.176e+01 -2.399602  1.648e-02
## hour19:Weather    -4.477e+01 2.173e+01 -2.060635  3.943e-02
## hour20:Weather    -3.602e+01 2.172e+01 -1.658639  9.730e-02
## hour21:Weather    -4.292e+01 2.174e+01 -1.974732  4.840e-02
## hour22:Weather    -4.116e+01 2.174e+01 -1.893251  5.843e-02
## hour23:Weather    -3.907e+01 2.179e+01 -1.792746  7.312e-02
## hour24:Weather    -3.994e+01 2.184e+01 -1.828838  6.753e-02
## hour1:LagWeather   2.117e+01 2.254e+01  0.939472  3.476e-01
## hour2:LagWeather   1.344e+01 2.256e+01  0.595900  5.513e-01
## hour3:LagWeather   1.005e+01 2.252e+01  0.446456  6.553e-01
## hour4:LagWeather   7.416e+00 2.240e+01  0.331015  7.407e-01
## hour5:LagWeather   5.975e+00 2.225e+01  0.268582  7.883e-01
## hour6:LagWeather   3.644e+00 2.188e+01  0.166570  8.677e-01
## hour7:LagWeather  -7.792e+00 2.150e+01 -0.362516  7.170e-01
## hour8:LagWeather  -3.383e+00 2.135e+01 -0.158450  8.741e-01
## hour9:LagWeather   4.755e+00 2.162e+01  0.219934  8.259e-01
## hour10:LagWeather  9.640e+00 2.186e+01  0.440987  6.593e-01
## hour11:LagWeather  2.132e+01 2.212e+01  0.963794  3.352e-01
## hour12:LagWeather  3.255e+01 2.230e+01  1.459941  1.444e-01
## hour13:LagWeather  3.786e+01 2.241e+01  1.689022  9.133e-02
## hour14:LagWeather  3.762e+01 2.248e+01  1.673317  9.438e-02
## hour15:LagWeather  3.169e+01 2.248e+01  1.409493  1.588e-01
## hour16:LagWeather  2.292e+01 2.244e+01  1.021109  3.073e-01
## hour17:LagWeather  1.546e+01 2.235e+01  0.691604  4.892e-01
## hour18:LagWeather  1.206e+01 2.224e+01  0.542340  5.876e-01
## hour19:LagWeather  5.575e+00 2.220e+01  0.251111  8.017e-01
## hour20:LagWeather -3.749e+00 2.220e+01 -0.168907  8.659e-01
## hour21:LagWeather -2.151e+01 2.234e+01 -0.963032  3.356e-01
## hour22:LagWeather -1.843e+01 2.233e+01 -0.825300  4.093e-01
## hour23:LagWeather -1.481e+01 2.238e+01 -0.661737  5.082e-01
## hour24:LagWeather -1.307e+01 2.247e+01 -0.581419  5.610e-01
```
Sweet works except hours 1-5

Now go by hour within day


```r
LagFormData<-sqldf("select * from LagFormData order by DateOnly,hour;")
ARbyHour<-gls(HE~hour+(F+LagHE+Weather+LagWeather):hour, data=LagFormData,corAR1(form=~1),na.action=na.omit)
summary(ARbyHour)$tTable
```

```
##                        Value Std.Error   t-value    p-value
## (Intercept)       -5.074e+02 1.622e+03 -0.312806  7.545e-01
## hour2             -1.604e+04 2.587e+03 -6.198779  6.518e-10
## hour3             -1.019e+04 2.752e+03 -3.703664  2.166e-04
## hour4             -8.312e+03 2.852e+03 -2.914167  3.594e-03
## hour5             -5.842e+03 2.783e+03 -2.099314  3.588e-02
## hour6             -3.308e+03 2.489e+03 -1.329238  1.839e-01
## hour7              2.227e+02 2.097e+03  0.106200  9.154e-01
## hour8              4.364e+02 1.848e+03  0.236196  8.133e-01
## hour9             -5.102e+01 1.561e+03 -0.032689  9.739e-01
## hour10             1.271e+03 1.404e+03  0.905351  3.654e-01
## hour11             4.694e+02 1.814e+03  0.258798  7.958e-01
## hour12            -4.360e+02 2.064e+03 -0.211221  8.327e-01
## hour13            -7.598e+02 2.228e+03 -0.341027  7.331e-01
## hour14            -4.422e+02 2.323e+03 -0.190355  8.490e-01
## hour15            -5.310e+02 2.385e+03 -0.222617  8.238e-01
## hour16            -9.419e+02 2.425e+03 -0.388382  6.978e-01
## hour17            -1.398e+03 2.442e+03 -0.572203  5.672e-01
## hour18            -2.721e+03 2.432e+03 -1.118968  2.632e-01
## hour19            -4.762e+03 2.380e+03 -2.000673  4.552e-02
## hour20            -7.233e+03 2.443e+03 -2.961231  3.090e-03
## hour21            -4.618e+03 2.663e+03 -1.733721  8.308e-02
## hour22            -1.374e+03 2.781e+03 -0.493971  6.214e-01
## hour23            -1.793e+03 2.799e+03 -0.640691  5.218e-01
## hour24            -3.362e+03 2.745e+03 -1.224889  2.207e-01
## hour1:F            9.588e-01 1.786e-02 53.697005  0.000e+00
## hour2:F            1.287e+00 1.986e-02 64.836225  0.000e+00
## hour3:F            1.189e+00 2.556e-02 46.503799  0.000e+00
## hour4:F            1.149e+00 3.091e-02 37.159745 1.523e-246
## hour5:F            1.098e+00 3.331e-02 32.961757 5.806e-202
## hour6:F            1.047e+00 3.221e-02 32.500269 3.371e-197
## hour7:F            1.008e+00 2.748e-02 36.703055 1.349e-241
## hour8:F            1.014e+00 2.327e-02 43.603797 3.211e-318
## hour9:F            1.010e+00 1.855e-02 54.427738  0.000e+00
## hour10:F           1.003e+00 1.888e-02 53.126982  0.000e+00
## hour11:F           9.995e-01 1.925e-02 51.915160  0.000e+00
## hour12:F           9.961e-01 1.855e-02 53.688929  0.000e+00
## hour13:F           9.925e-01 1.764e-02 56.249511  0.000e+00
## hour14:F           9.870e-01 1.668e-02 59.186549  0.000e+00
## hour15:F           9.880e-01 1.580e-02 62.537237  0.000e+00
## hour16:F           9.957e-01 1.493e-02 66.704150  0.000e+00
## hour17:F           1.008e+00 1.399e-02 72.051363  0.000e+00
## hour18:F           1.031e+00 1.295e-02 79.621049  0.000e+00
## hour19:F           1.059e+00 1.134e-02 93.421819  0.000e+00
## hour20:F           1.092e+00 1.193e-02 91.541023  0.000e+00
## hour21:F           1.097e+00 1.516e-02 72.364678  0.000e+00
## hour22:F           1.086e+00 1.717e-02 63.242163  0.000e+00
## hour23:F           1.087e+00 1.859e-02 58.453718  0.000e+00
## hour24:F           1.096e+00 1.886e-02 58.123912  0.000e+00
## hour1:LagHE        5.012e-02 1.784e-02  2.809379  4.998e-03
## hour2:LagHE       -8.836e-02 1.762e-02 -5.014292  5.651e-07
## hour3:LagHE       -5.041e-02 2.315e-02 -2.177744  2.951e-02
## hour4:LagHE       -2.791e-02 2.913e-02 -0.958164  3.381e-01
## hour5:LagHE       -7.487e-03 3.209e-02 -0.233330  8.155e-01
## hour6:LagHE        1.472e-02 3.149e-02  0.467428  6.402e-01
## hour7:LagHE        2.296e-02 2.724e-02  0.842768  3.994e-01
## hour8:LagHE        2.377e-03 2.318e-02  0.102546  9.183e-01
## hour9:LagHE        5.290e-03 1.848e-02  0.286287  7.747e-01
## hour10:LagHE       9.191e-04 1.873e-02  0.049059  9.609e-01
## hour11:LagHE       9.266e-03 1.896e-02  0.488828  6.250e-01
## hour12:LagHE       1.680e-02 1.818e-02  0.923863  3.556e-01
## hour13:LagHE       2.175e-02 1.728e-02  1.258531  2.083e-01
## hour14:LagHE       2.298e-02 1.639e-02  1.401633  1.611e-01
## hour15:LagHE       2.140e-02 1.552e-02  1.378876  1.680e-01
## hour16:LagHE       1.522e-02 1.460e-02  1.042730  2.972e-01
## hour17:LagHE       4.059e-03 1.359e-02  0.298760  7.651e-01
## hour18:LagHE      -1.170e-02 1.238e-02 -0.944349  3.451e-01
## hour19:LagHE      -2.485e-02 1.050e-02 -2.365846  1.806e-02
## hour20:LagHE      -3.297e-02 1.089e-02 -3.026492  2.496e-03
## hour21:LagHE      -4.197e-02 1.436e-02 -2.922382  3.501e-03
## hour22:LagHE      -6.629e-02 1.646e-02 -4.028387  5.764e-05
## hour23:LagHE      -6.822e-02 1.757e-02 -3.882670  1.057e-04
## hour24:LagHE      -5.967e-02 1.719e-02 -3.472116  5.241e-04
## hour1:Weather     -4.951e+01 1.082e+01 -4.575252  4.961e-06
## hour2:Weather      8.952e+00 1.917e+01  0.466892  6.406e-01
## hour3:Weather     -1.028e+01 1.835e+01 -0.560269  5.753e-01
## hour4:Weather     -1.672e+01 1.794e+01 -0.931743  3.515e-01
## hour5:Weather     -2.340e+01 1.733e+01 -1.350352  1.770e-01
## hour6:Weather     -3.445e+01 1.643e+01 -2.096773  3.610e-02
## hour7:Weather     -5.407e+01 1.521e+01 -3.554157  3.854e-04
## hour8:Weather     -4.846e+01 1.369e+01 -3.540631  4.056e-04
## hour9:Weather     -4.926e+01 1.137e+01 -4.331495  1.532e-05
## hour10:Weather    -5.507e+01 1.351e+01 -4.076600  4.696e-05
## hour11:Weather    -5.816e+01 1.542e+01 -3.771505  1.656e-04
## hour12:Weather    -5.915e+01 1.680e+01 -3.521336  4.362e-04
## hour13:Weather    -6.349e+01 1.779e+01 -3.567854  3.659e-04
## hour14:Weather    -6.605e+01 1.851e+01 -3.567932  3.658e-04
## hour15:Weather    -6.519e+01 1.900e+01 -3.430790  6.104e-04
## hour16:Weather    -6.101e+01 1.932e+01 -3.157741  1.607e-03
## hour17:Weather    -5.341e+01 1.949e+01 -2.739981  6.183e-03
## hour18:Weather    -3.959e+01 1.953e+01 -2.027052  4.275e-02
## hour19:Weather    -2.719e+01 1.942e+01 -1.400173  1.616e-01
## hour20:Weather    -2.515e+01 1.943e+01 -1.294138  1.957e-01
## hour21:Weather    -4.636e+01 1.953e+01 -2.373161  1.770e-02
## hour22:Weather    -4.037e+01 1.949e+01 -2.071068  3.844e-02
## hour23:Weather    -2.950e+01 1.931e+01 -1.527629  1.267e-01
## hour24:Weather    -2.373e+01 1.896e+01 -1.251650  2.108e-01
## hour1:LagWeather   2.957e+01 1.116e+01  2.648512  8.130e-03
## hour2:LagWeather   7.617e+00 1.925e+01  0.395688  6.924e-01
## hour3:LagWeather   7.961e+00 1.850e+01  0.430434  6.669e-01
## hour4:LagWeather   5.945e+00 1.820e+01  0.326571  7.440e-01
## hour5:LagWeather   6.061e+00 1.761e+01  0.344147  7.308e-01
## hour6:LagWeather   3.294e+00 1.667e+01  0.197587  8.434e-01
## hour7:LagWeather  -1.254e+01 1.536e+01 -0.816304  4.144e-01
## hour8:LagWeather   2.568e-02 1.367e+01  0.001878  9.985e-01
## hour9:LagWeather   1.530e+01 1.124e+01  1.360375  1.738e-01
## hour10:LagWeather  1.441e+01 1.378e+01  1.045272  2.960e-01
## hour11:LagWeather  2.575e+01 1.584e+01  1.626050  1.041e-01
## hour12:LagWeather  3.835e+01 1.730e+01  2.216274  2.675e-02
## hour13:LagWeather  4.594e+01 1.838e+01  2.499017  1.251e-02
## hour14:LagWeather  4.978e+01 1.913e+01  2.601960  9.318e-03
## hour15:LagWeather  5.138e+01 1.961e+01  2.620661  8.823e-03
## hour16:LagWeather  5.166e+01 1.987e+01  2.599401  9.387e-03
## hour17:LagWeather  5.029e+01 1.995e+01  2.520974  1.176e-02
## hour18:LagWeather  4.776e+01 1.986e+01  2.405227  1.623e-02
## hour19:LagWeather  4.429e+01 1.960e+01  2.259744  2.391e-02
## hour20:LagWeather  3.377e+01 1.960e+01  1.722602  8.507e-02
## hour21:LagWeather  4.360e+00 1.991e+01  0.218973  8.267e-01
## hour22:LagWeather  1.188e+01 1.993e+01  0.596284  5.510e-01
## hour23:LagWeather  1.528e+01 1.967e+01  0.776669  4.374e-01
## hour24:LagWeather  1.306e+01 1.918e+01  0.680868  4.960e-01
```

and the results are different.  Now we have to figure out which is right, or perhaps both.  The likelyhood suggests hour within day, i.e., the worse one.

Lets get into the day of week effects and see if it is still there.  There was a Monday and Tuesday problem


```r
# LagFormData<-sqldf("select * from LagFormData order by DateOnly,hour;")
# LagFormData$MorT<-weekdays(DateOnly)=="Monday"||weekdays(DateOnly)=="Tuesday"
# 
# ARbyHourDay<-gls(HE~(hour+(F+LagHE+Weather+LagWeather):hour):weekdays(DateOnly), data=LagFormData,corAR1(form=~1),na.action=na.omit)
# summary(ARbyHourDay)$tTable
```





