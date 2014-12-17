Working with the Long Data and heading to an AR model
=======================================================

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
LagFormData$DOW<-as.factor(weekdays(LagFormData$DateOnly))
LagFormData$DayType<-"MidWeek"
LagFormData$DayType[LagFormData$DOW=="Monday"| LagFormData$DOW=="Tuesday"]<-"EarlyWeek"
LagFormData$DayType[LagFormData$DOW=="Saturday"| LagFormData$DOW=="Sunday"]<-"Weekend"
LagFormData$DayType<-as.factor(LagFormData$DayType)
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
##         DOW           DayType    
##  Friday   :816   EarlyWeek:1584  
##  Monday   :768   MidWeek  :2448  
##  Saturday :816   Weekend  :1632  
##  Sunday   :816                   
##  Thursday :816                   
##  Tuesday  :816                   
##  Wednesday:816
```

```r
LagFormData<-sqldf("select * from LagFormData order by DateOnly,hour;")
ARbyHourDay<-gls(HE~-1+(hour+(F+LagHE+Weather+LagWeather):hour):DayType, data=LagFormData,corAR1(form=~1),na.action=na.omit)
summary(ARbyHourDay)$tTable
```

```
##                                         Value Std.Error  t-value
## hour1:DayTypeEarlyWeek              1.114e+04 3.087e+03  3.60793
## hour2:DayTypeEarlyWeek              1.980e+03 3.856e+03  0.51359
## hour3:DayTypeEarlyWeek             -2.143e+03 4.275e+03 -0.50132
## hour4:DayTypeEarlyWeek             -1.634e+03 4.700e+03 -0.34762
## hour5:DayTypeEarlyWeek             -8.675e+02 4.969e+03 -0.17457
## hour6:DayTypeEarlyWeek             -5.371e+02 5.178e+03 -0.10372
## hour7:DayTypeEarlyWeek             -1.754e+03 5.328e+03 -0.32928
## hour8:DayTypeEarlyWeek              5.442e+03 4.862e+03  1.11927
## hour9:DayTypeEarlyWeek              7.914e+03 3.857e+03  2.05176
## hour10:DayTypeEarlyWeek             2.001e+04 4.296e+03  4.65741
## hour11:DayTypeEarlyWeek             1.983e+04 4.358e+03  4.55175
## hour12:DayTypeEarlyWeek             1.918e+04 4.316e+03  4.44440
## hour13:DayTypeEarlyWeek             1.920e+04 4.268e+03  4.49985
## hour14:DayTypeEarlyWeek             1.918e+04 4.201e+03  4.56469
## hour15:DayTypeEarlyWeek             1.919e+04 4.131e+03  4.64568
## hour16:DayTypeEarlyWeek             2.052e+04 4.062e+03  5.05295
## hour17:DayTypeEarlyWeek             2.149e+04 3.965e+03  5.42014
## hour18:DayTypeEarlyWeek             2.050e+04 3.831e+03  5.35040
## hour19:DayTypeEarlyWeek             1.754e+04 3.646e+03  4.80954
## hour20:DayTypeEarlyWeek             1.206e+04 3.755e+03  3.21049
## hour21:DayTypeEarlyWeek             9.809e+03 4.318e+03  2.27196
## hour22:DayTypeEarlyWeek             1.623e+04 4.531e+03  3.58288
## hour23:DayTypeEarlyWeek             1.499e+04 4.446e+03  3.37091
## hour24:DayTypeEarlyWeek             1.049e+04 4.262e+03  2.46038
## hour1:DayTypeMidWeek                1.735e+03 3.229e+03  0.53725
## hour2:DayTypeMidWeek                2.245e+03 4.406e+03  0.50954
## hour3:DayTypeMidWeek                3.183e+03 4.760e+03  0.66868
## hour4:DayTypeMidWeek                2.593e+03 5.012e+03  0.51729
## hour5:DayTypeMidWeek                2.282e+03 5.170e+03  0.44142
## hour6:DayTypeMidWeek                4.054e+03 5.410e+03  0.74930
## hour7:DayTypeMidWeek                7.820e+03 5.583e+03  1.40058
## hour8:DayTypeMidWeek                1.837e+03 4.992e+03  0.36796
## hour9:DayTypeMidWeek                1.154e+03 4.099e+03  0.28146
## hour10:DayTypeMidWeek               1.452e+03 4.495e+03  0.32301
## hour11:DayTypeMidWeek               4.308e+02 4.635e+03  0.09294
## hour12:DayTypeMidWeek              -4.768e+02 4.650e+03 -0.10254
## hour13:DayTypeMidWeek               6.229e+02 4.661e+03  0.13365
## hour14:DayTypeMidWeek               2.932e+03 4.671e+03  0.62760
## hour15:DayTypeMidWeek               4.848e+03 4.652e+03  1.04214
## hour16:DayTypeMidWeek               6.178e+03 4.603e+03  1.34232
## hour17:DayTypeMidWeek               7.732e+03 4.557e+03  1.69659
## hour18:DayTypeMidWeek               9.127e+03 4.475e+03  2.03986
## hour19:DayTypeMidWeek               9.558e+03 4.332e+03  2.20637
## hour20:DayTypeMidWeek               1.025e+04 4.457e+03  2.30002
## hour21:DayTypeMidWeek               2.124e+04 5.143e+03  4.12913
## hour22:DayTypeMidWeek               2.337e+04 5.368e+03  4.35332
## hour23:DayTypeMidWeek               1.761e+04 5.287e+03  3.33099
## hour24:DayTypeMidWeek               1.497e+04 5.201e+03  2.87893
## hour1:DayTypeWeekend               -3.390e+03 3.477e+03 -0.97499
## hour2:DayTypeWeekend               -2.231e+04 4.345e+03 -5.13595
## hour3:DayTypeWeekend               -1.131e+04 5.093e+03 -2.22156
## hour4:DayTypeWeekend               -9.805e+03 5.783e+03 -1.69541
## hour5:DayTypeWeekend               -6.434e+03 6.203e+03 -1.03731
## hour6:DayTypeWeekend               -4.790e+03 6.295e+03 -0.76099
## hour7:DayTypeWeekend               -5.300e+03 5.859e+03 -0.90462
## hour8:DayTypeWeekend                7.818e+02 5.328e+03  0.14674
## hour9:DayTypeWeekend                7.176e+03 4.501e+03  1.59449
## hour10:DayTypeWeekend              -2.241e+03 4.529e+03 -0.49485
## hour11:DayTypeWeekend              -3.685e+03 4.581e+03 -0.80444
## hour12:DayTypeWeekend              -4.723e+03 4.545e+03 -1.03897
## hour13:DayTypeWeekend              -6.115e+03 4.466e+03 -1.36919
## hour14:DayTypeWeekend              -6.091e+03 4.356e+03 -1.39809
## hour15:DayTypeWeekend              -6.366e+03 4.208e+03 -1.51292
## hour16:DayTypeWeekend              -7.054e+03 4.036e+03 -1.74784
## hour17:DayTypeWeekend              -7.578e+03 3.858e+03 -1.96407
## hour18:DayTypeWeekend              -8.962e+03 3.659e+03 -2.44939
## hour19:DayTypeWeekend              -1.084e+04 3.393e+03 -3.19339
## hour20:DayTypeWeekend              -1.408e+04 3.479e+03 -4.04715
## hour21:DayTypeWeekend              -1.476e+04 4.186e+03 -3.52509
## hour22:DayTypeWeekend              -1.003e+04 4.427e+03 -2.26503
## hour23:DayTypeWeekend              -8.442e+03 4.346e+03 -1.94264
## hour24:DayTypeWeekend              -9.654e+03 4.178e+03 -2.31050
## hour1:F:DayTypeEarlyWeek            8.966e-01 3.170e-02 28.28174
## hour2:F:DayTypeEarlyWeek            1.133e+00 3.942e-02 28.74889
## hour3:F:DayTypeEarlyWeek            1.144e+00 5.055e-02 22.62142
## hour4:F:DayTypeEarlyWeek            1.103e+00 6.207e-02 17.77768
## hour5:F:DayTypeEarlyWeek            1.046e+00 6.682e-02 15.65306
## hour6:F:DayTypeEarlyWeek            9.938e-01 6.282e-02 15.81956
## hour7:F:DayTypeEarlyWeek            9.909e-01 5.050e-02 19.61956
## hour8:F:DayTypeEarlyWeek            9.803e-01 4.114e-02 23.82937
## hour9:F:DayTypeEarlyWeek            9.701e-01 3.277e-02 29.60028
## hour10:F:DayTypeEarlyWeek           9.287e-01 3.204e-02 28.98779
## hour11:F:DayTypeEarlyWeek           9.303e-01 3.257e-02 28.56657
## hour12:F:DayTypeEarlyWeek           9.428e-01 3.087e-02 30.54630
## hour13:F:DayTypeEarlyWeek           9.477e-01 2.881e-02 32.89584
## hour14:F:DayTypeEarlyWeek           9.478e-01 2.685e-02 35.30536
## hour15:F:DayTypeEarlyWeek           9.525e-01 2.507e-02 37.99538
## hour16:F:DayTypeEarlyWeek           9.576e-01 2.336e-02 41.00024
## hour17:F:DayTypeEarlyWeek           9.725e-01 2.167e-02 44.88082
## hour18:F:DayTypeEarlyWeek           1.000e+00 1.995e-02 50.12516
## hour19:F:DayTypeEarlyWeek           1.025e+00 1.749e-02 58.63121
## hour20:F:DayTypeEarlyWeek           1.057e+00 1.859e-02 56.84956
## hour21:F:DayTypeEarlyWeek           1.065e+00 2.399e-02 44.38664
## hour22:F:DayTypeEarlyWeek           1.038e+00 2.692e-02 38.54529
## hour23:F:DayTypeEarlyWeek           1.036e+00 2.854e-02 36.28602
## hour24:F:DayTypeEarlyWeek           1.049e+00 2.851e-02 36.79401
## hour1:F:DayTypeMidWeek              9.585e-01 2.727e-02 35.14514
## hour2:F:DayTypeMidWeek              1.199e+00 3.347e-02 35.82645
## hour3:F:DayTypeMidWeek              1.114e+00 4.114e-02 27.08371
## hour4:F:DayTypeMidWeek              1.093e+00 4.755e-02 22.99392
## hour5:F:DayTypeMidWeek              1.068e+00 5.121e-02 20.85227
## hour6:F:DayTypeMidWeek              1.033e+00 5.169e-02 19.98404
## hour7:F:DayTypeMidWeek              9.945e-01 4.860e-02 20.46458
## hour8:F:DayTypeMidWeek              1.026e+00 4.199e-02 24.44402
## hour9:F:DayTypeMidWeek              1.020e+00 3.265e-02 31.22917
## hour10:F:DayTypeMidWeek             9.921e-01 3.232e-02 30.69519
## hour11:F:DayTypeMidWeek             9.821e-01 3.206e-02 30.63122
## hour12:F:DayTypeMidWeek             9.646e-01 3.076e-02 31.35740
## hour13:F:DayTypeMidWeek             9.447e-01 2.945e-02 32.08046
## hour14:F:DayTypeMidWeek             9.260e-01 2.821e-02 32.82211
## hour15:F:DayTypeMidWeek             9.162e-01 2.721e-02 33.66822
## hour16:F:DayTypeMidWeek             9.201e-01 2.622e-02 35.09641
## hour17:F:DayTypeMidWeek             9.254e-01 2.519e-02 36.73452
## hour18:F:DayTypeMidWeek             9.415e-01 2.409e-02 39.08529
## hour19:F:DayTypeMidWeek             9.660e-01 2.245e-02 43.03134
## hour20:F:DayTypeMidWeek             9.945e-01 2.389e-02 41.62234
## hour21:F:DayTypeMidWeek             9.780e-01 2.886e-02 33.88970
## hour22:F:DayTypeMidWeek             9.776e-01 3.206e-02 30.49207
## hour23:F:DayTypeMidWeek             9.963e-01 3.493e-02 28.52307
## hour24:F:DayTypeMidWeek             1.006e+00 3.678e-02 27.34193
## hour1:F:DayTypeWeekend              1.030e+00 3.954e-02 26.05036
## hour2:F:DayTypeWeekend              1.239e+00 4.246e-02 29.19063
## hour3:F:DayTypeWeekend              1.180e+00 5.581e-02 21.15241
## hour4:F:DayTypeWeekend              1.167e+00 6.919e-02 16.86643
## hour5:F:DayTypeWeekend              1.140e+00 7.743e-02 14.72651
## hour6:F:DayTypeWeekend              1.128e+00 8.120e-02 13.89600
## hour7:F:DayTypeWeekend              1.156e+00 7.894e-02 14.64301
## hour8:F:DayTypeWeekend              1.112e+00 6.911e-02 16.09818
## hour9:F:DayTypeWeekend              1.065e+00 5.140e-02 20.72123
## hour10:F:DayTypeWeekend             1.104e+00 5.202e-02 21.23078
## hour11:F:DayTypeWeekend             1.090e+00 4.919e-02 22.15197
## hour12:F:DayTypeWeekend             1.074e+00 4.527e-02 23.71735
## hour13:F:DayTypeWeekend             1.070e+00 4.181e-02 25.58023
## hour14:F:DayTypeWeekend             1.062e+00 3.870e-02 27.43858
## hour15:F:DayTypeWeekend             1.057e+00 3.600e-02 29.35565
## hour16:F:DayTypeWeekend             1.046e+00 3.363e-02 31.08948
## hour17:F:DayTypeWeekend             1.036e+00 3.126e-02 33.14954
## hour18:F:DayTypeWeekend             1.032e+00 2.878e-02 35.84890
## hour19:F:DayTypeWeekend             1.045e+00 2.516e-02 41.52480
## hour20:F:DayTypeWeekend             1.077e+00 2.692e-02 40.00337
## hour21:F:DayTypeWeekend             1.097e+00 3.467e-02 31.63600
## hour22:F:DayTypeWeekend             1.068e+00 3.865e-02 27.63708
## hour23:F:DayTypeWeekend             1.071e+00 4.131e-02 25.93339
## hour24:F:DayTypeWeekend             1.091e+00 4.157e-02 26.23383
## hour1:LagHE:DayTypeEarlyWeek        4.866e-03 3.318e-02  0.14664
## hour2:LagHE:DayTypeEarlyWeek       -1.354e-01 3.563e-02 -3.80047
## hour3:LagHE:DayTypeEarlyWeek       -1.101e-01 4.628e-02 -2.37863
## hour4:LagHE:DayTypeEarlyWeek       -7.823e-02 5.960e-02 -1.31269
## hour5:LagHE:DayTypeEarlyWeek       -3.466e-02 6.564e-02 -0.52802
## hour6:LagHE:DayTypeEarlyWeek        9.501e-03 6.317e-02  0.15039
## hour7:LagHE:DayTypeEarlyWeek        2.872e-02 5.283e-02  0.54361
## hour8:LagHE:DayTypeEarlyWeek       -2.838e-02 4.430e-02 -0.64071
## hour9:LagHE:DayTypeEarlyWeek       -3.733e-02 3.377e-02 -1.10536
## hour10:LagHE:DayTypeEarlyWeek      -7.286e-02 3.459e-02 -2.10604
## hour11:LagHE:DayTypeEarlyWeek      -5.968e-02 3.382e-02 -1.76426
## hour12:LagHE:DayTypeEarlyWeek      -5.919e-02 3.125e-02 -1.89390
## hour13:LagHE:DayTypeEarlyWeek      -5.713e-02 2.884e-02 -1.98081
## hour14:LagHE:DayTypeEarlyWeek      -5.336e-02 2.670e-02 -1.99873
## hour15:LagHE:DayTypeEarlyWeek      -5.448e-02 2.474e-02 -2.20252
## hour16:LagHE:DayTypeEarlyWeek      -6.494e-02 2.296e-02 -2.82907
## hour17:LagHE:DayTypeEarlyWeek      -8.136e-02 2.110e-02 -3.85542
## hour18:LagHE:DayTypeEarlyWeek      -9.958e-02 1.906e-02 -5.22543
## hour19:LagHE:DayTypeEarlyWeek      -1.051e-01 1.626e-02 -6.46236
## hour20:LagHE:DayTypeEarlyWeek      -1.025e-01 1.700e-02 -6.03032
## hour21:LagHE:DayTypeEarlyWeek      -1.084e-01 2.251e-02 -4.81405
## hour22:LagHE:DayTypeEarlyWeek      -1.395e-01 2.559e-02 -5.45234
## hour23:LagHE:DayTypeEarlyWeek      -1.303e-01 2.685e-02 -4.85437
## hour24:LagHE:DayTypeEarlyWeek      -1.137e-01 2.604e-02 -4.36538
## hour1:LagHE:DayTypeMidWeek          1.275e-02 2.577e-02  0.49459
## hour2:LagHE:DayTypeMidWeek         -2.227e-01 2.895e-02 -7.69094
## hour3:LagHE:DayTypeMidWeek         -1.462e-01 3.641e-02 -4.01484
## hour4:LagHE:DayTypeMidWeek         -1.181e-01 4.373e-02 -2.70001
## hour5:LagHE:DayTypeMidWeek         -8.853e-02 4.797e-02 -1.84535
## hour6:LagHE:DayTypeMidWeek         -6.907e-02 4.942e-02 -1.39754
## hour7:LagHE:DayTypeMidWeek         -5.683e-02 4.666e-02 -1.21781
## hour8:LagHE:DayTypeMidWeek         -3.982e-02 3.901e-02 -1.02056
## hour9:LagHE:DayTypeMidWeek         -3.049e-02 3.026e-02 -1.00755
## hour10:LagHE:DayTypeMidWeek        -1.654e-02 3.031e-02 -0.54574
## hour11:LagHE:DayTypeMidWeek         2.721e-04 3.036e-02  0.00896
## hour12:LagHE:DayTypeMidWeek         2.335e-02 2.937e-02  0.79524
## hour13:LagHE:DayTypeMidWeek         3.730e-02 2.840e-02  1.31324
## hour14:LagHE:DayTypeMidWeek         4.197e-02 2.757e-02  1.52218
## hour15:LagHE:DayTypeMidWeek         4.193e-02 2.670e-02  1.57034
## hour16:LagHE:DayTypeMidWeek         3.169e-02 2.558e-02  1.23864
## hour17:LagHE:DayTypeMidWeek         1.463e-02 2.435e-02  0.60078
## hour18:LagHE:DayTypeMidWeek        -1.401e-02 2.280e-02 -0.61449
## hour19:LagHE:DayTypeMidWeek        -4.746e-02 2.035e-02 -2.33266
## hour20:LagHE:DayTypeMidWeek        -8.227e-02 2.125e-02 -3.87224
## hour21:LagHE:DayTypeMidWeek        -1.303e-01 2.741e-02 -4.75564
## hour22:LagHE:DayTypeMidWeek        -1.648e-01 3.087e-02 -5.33893
## hour23:LagHE:DayTypeMidWeek        -1.621e-01 3.282e-02 -4.93890
## hour24:LagHE:DayTypeMidWeek        -1.612e-01 3.325e-02 -4.84744
## hour1:LagHE:DayTypeWeekend          1.351e-02 3.816e-02  0.35401
## hour2:LagHE:DayTypeWeekend          4.010e-02 3.648e-02  1.09924
## hour3:LagHE:DayTypeWeekend         -2.261e-02 4.891e-02 -0.46237
## hour4:LagHE:DayTypeWeekend         -1.913e-02 6.149e-02 -0.31119
## hour5:LagHE:DayTypeWeekend         -3.300e-02 6.910e-02 -0.47752
## hour6:LagHE:DayTypeWeekend         -3.204e-02 7.120e-02 -0.45004
## hour7:LagHE:DayTypeWeekend         -2.624e-02 6.572e-02 -0.39918
## hour8:LagHE:DayTypeWeekend         -9.008e-02 5.902e-02 -1.52638
## hour9:LagHE:DayTypeWeekend         -1.358e-01 4.520e-02 -3.00381
## hour10:LagHE:DayTypeWeekend        -6.166e-02 4.871e-02 -1.26589
## hour11:LagHE:DayTypeWeekend        -4.007e-02 4.614e-02 -0.86832
## hour12:LagHE:DayTypeWeekend        -2.396e-02 4.285e-02 -0.55928
## hour13:LagHE:DayTypeWeekend        -1.508e-02 3.957e-02 -0.38106
## hour14:LagHE:DayTypeWeekend        -1.478e-02 3.692e-02 -0.40031
## hour15:LagHE:DayTypeWeekend        -1.519e-02 3.455e-02 -0.43960
## hour16:LagHE:DayTypeWeekend        -7.496e-03 3.232e-02 -0.23192
## hour17:LagHE:DayTypeWeekend        -6.556e-04 2.997e-02 -0.02188
## hour18:LagHE:DayTypeWeekend         8.911e-03 2.728e-02  0.32660
## hour19:LagHE:DayTypeWeekend         1.214e-02 2.300e-02  0.52780
## hour20:LagHE:DayTypeWeekend         2.206e-02 2.400e-02  0.91923
## hour21:LagHE:DayTypeWeekend         3.555e-02 3.151e-02  1.12841
## hour22:LagHE:DayTypeWeekend         1.320e-02 3.589e-02  0.36777
## hour23:LagHE:DayTypeWeekend        -5.441e-03 3.821e-02 -0.14238
## hour24:LagHE:DayTypeWeekend        -3.772e-03 3.722e-02 -0.10134
## hour1:Weather:DayTypeEarlyWeek     -6.739e+01 1.865e+01 -3.61281
## hour2:Weather:DayTypeEarlyWeek     -3.383e+01 3.630e+01 -0.93220
## hour3:Weather:DayTypeEarlyWeek     -1.723e+01 3.462e+01 -0.49769
## hour4:Weather:DayTypeEarlyWeek     -1.685e+01 3.382e+01 -0.49838
## hour5:Weather:DayTypeEarlyWeek     -1.391e+01 3.271e+01 -0.42536
## hour6:Weather:DayTypeEarlyWeek     -7.863e+00 3.112e+01 -0.25270
## hour7:Weather:DayTypeEarlyWeek     -6.359e+00 2.882e+01 -0.22067
## hour8:Weather:DayTypeEarlyWeek     -1.899e+01 2.538e+01 -0.74819
## hour9:Weather:DayTypeEarlyWeek     -2.992e+01 2.016e+01 -1.48392
## hour10:Weather:DayTypeEarlyWeek    -8.266e+01 2.442e+01 -3.38440
## hour11:Weather:DayTypeEarlyWeek    -9.685e+01 2.816e+01 -3.43888
## hour12:Weather:DayTypeEarlyWeek    -1.021e+02 3.071e+01 -3.32531
## hour13:Weather:DayTypeEarlyWeek    -1.108e+02 3.251e+01 -3.40691
## hour14:Weather:DayTypeEarlyWeek    -1.157e+02 3.386e+01 -3.41676
## hour15:Weather:DayTypeEarlyWeek    -1.306e+02 3.479e+01 -3.75431
## hour16:Weather:DayTypeEarlyWeek    -1.455e+02 3.546e+01 -4.10302
## hour17:Weather:DayTypeEarlyWeek    -1.586e+02 3.593e+01 -4.41299
## hour18:Weather:DayTypeEarlyWeek    -1.580e+02 3.622e+01 -4.36358
## hour19:Weather:DayTypeEarlyWeek    -1.537e+02 3.632e+01 -4.23221
## hour20:Weather:DayTypeEarlyWeek    -1.381e+02 3.643e+01 -3.79109
## hour21:Weather:DayTypeEarlyWeek    -1.036e+02 3.648e+01 -2.83873
## hour22:Weather:DayTypeEarlyWeek    -1.051e+02 3.635e+01 -2.89107
## hour23:Weather:DayTypeEarlyWeek    -1.151e+02 3.596e+01 -3.19987
## hour24:Weather:DayTypeEarlyWeek    -1.026e+02 3.535e+01 -2.90245
## hour1:Weather:DayTypeMidWeek       -2.862e+00 1.795e+01 -0.15947
## hour2:Weather:DayTypeMidWeek        1.827e+01 3.155e+01  0.57901
## hour3:Weather:DayTypeMidWeek       -9.839e+00 3.034e+01 -0.32428
## hour4:Weather:DayTypeMidWeek       -1.316e+01 2.970e+01 -0.44312
## hour5:Weather:DayTypeMidWeek       -1.832e+01 2.881e+01 -0.63603
## hour6:Weather:DayTypeMidWeek       -3.233e+01 2.762e+01 -1.17050
## hour7:Weather:DayTypeMidWeek       -6.182e+01 2.582e+01 -2.39398
## hour8:Weather:DayTypeMidWeek       -4.217e+01 2.331e+01 -1.80865
## hour9:Weather:DayTypeMidWeek       -3.819e+01 1.955e+01 -1.95317
## hour10:Weather:DayTypeMidWeek       4.652e+00 2.309e+01  0.20145
## hour11:Weather:DayTypeMidWeek       4.987e+00 2.656e+01  0.18778
## hour12:Weather:DayTypeMidWeek      -4.498e+00 2.906e+01 -0.15477
## hour13:Weather:DayTypeMidWeek      -2.335e+01 3.091e+01 -0.75543
## hour14:Weather:DayTypeMidWeek      -4.039e+01 3.228e+01 -1.25093
## hour15:Weather:DayTypeMidWeek      -5.384e+01 3.322e+01 -1.62051
## hour16:Weather:DayTypeMidWeek      -6.227e+01 3.377e+01 -1.84361
## hour17:Weather:DayTypeMidWeek      -6.282e+01 3.399e+01 -1.84804
## hour18:Weather:DayTypeMidWeek      -5.368e+01 3.386e+01 -1.58539
## hour19:Weather:DayTypeMidWeek      -3.916e+01 3.334e+01 -1.17441
## hour20:Weather:DayTypeMidWeek      -4.241e+01 3.325e+01 -1.27544
## hour21:Weather:DayTypeMidWeek      -9.634e+01 3.369e+01 -2.85928
## hour22:Weather:DayTypeMidWeek      -8.299e+01 3.357e+01 -2.47229
## hour23:Weather:DayTypeMidWeek      -4.409e+01 3.312e+01 -1.33105
## hour24:Weather:DayTypeMidWeek      -3.215e+01 3.240e+01 -0.99213
## hour1:Weather:DayTypeWeekend       -6.745e+01 1.811e+01 -3.72522
## hour2:Weather:DayTypeWeekend       -1.240e+01 2.918e+01 -0.42491
## hour3:Weather:DayTypeWeekend       -3.048e+01 2.811e+01 -1.08422
## hour4:Weather:DayTypeWeekend       -3.570e+01 2.767e+01 -1.29020
## hour5:Weather:DayTypeWeekend       -4.331e+01 2.674e+01 -1.61995
## hour6:Weather:DayTypeWeekend       -5.702e+01 2.521e+01 -2.26187
## hour7:Weather:DayTypeWeekend       -7.430e+01 2.295e+01 -3.23780
## hour8:Weather:DayTypeWeekend       -6.653e+01 2.036e+01 -3.26736
## hour9:Weather:DayTypeWeekend       -6.857e+01 1.661e+01 -4.12803
## hour10:Weather:DayTypeWeekend      -7.674e+01 2.194e+01 -3.49715
## hour11:Weather:DayTypeWeekend      -7.858e+01 2.491e+01 -3.15416
## hour12:Weather:DayTypeWeekend      -7.536e+01 2.707e+01 -2.78435
## hour13:Weather:DayTypeWeekend      -7.035e+01 2.859e+01 -2.46041
## hour14:Weather:DayTypeWeekend      -6.613e+01 2.959e+01 -2.23499
## hour15:Weather:DayTypeWeekend      -5.288e+01 3.014e+01 -1.75436
## hour16:Weather:DayTypeWeekend      -3.776e+01 3.038e+01 -1.24320
## hour17:Weather:DayTypeWeekend      -2.354e+01 3.035e+01 -0.77562
## hour18:Weather:DayTypeWeekend      -8.676e+00 3.013e+01 -0.28794
## hour19:Weather:DayTypeWeekend       2.914e+00 2.971e+01  0.09809
## hour20:Weather:DayTypeWeekend       3.660e+00 2.965e+01  0.12344
## hour21:Weather:DayTypeWeekend      -2.022e+01 3.005e+01 -0.67290
## hour22:Weather:DayTypeWeekend      -1.745e+01 2.998e+01 -0.58186
## hour23:Weather:DayTypeWeekend      -9.168e+00 2.961e+01 -0.30965
## hour24:Weather:DayTypeWeekend      -6.446e+00 2.898e+01 -0.22243
## hour1:LagWeather:DayTypeEarlyWeek  -2.568e+01 2.044e+01 -1.25625
## hour2:LagWeather:DayTypeEarlyWeek  -3.236e+01 3.758e+01 -0.86108
## hour3:LagWeather:DayTypeEarlyWeek  -1.449e+01 3.601e+01 -0.40232
## hour4:LagWeather:DayTypeEarlyWeek  -9.328e+00 3.542e+01 -0.26339
## hour5:LagWeather:DayTypeEarlyWeek  -3.773e+00 3.422e+01 -0.11024
## hour6:LagWeather:DayTypeEarlyWeek  -4.695e-01 3.232e+01 -0.01453
## hour7:LagWeather:DayTypeEarlyWeek  -5.968e+00 2.982e+01 -0.20017
## hour8:LagWeather:DayTypeEarlyWeek  -2.560e+01 2.658e+01 -0.96326
## hour9:LagWeather:DayTypeEarlyWeek  -2.384e+01 2.104e+01 -1.13320
## hour10:LagWeather:DayTypeEarlyWeek -6.207e+01 2.685e+01 -2.31198
## hour11:LagWeather:DayTypeEarlyWeek -6.061e+01 3.078e+01 -1.96878
## hour12:LagWeather:DayTypeEarlyWeek -5.729e+01 3.337e+01 -1.71683
## hour13:LagWeather:DayTypeEarlyWeek -5.720e+01 3.522e+01 -1.62425
## hour14:LagWeather:DayTypeEarlyWeek -5.625e+01 3.653e+01 -1.53993
## hour15:LagWeather:DayTypeEarlyWeek -4.673e+01 3.746e+01 -1.24723
## hour16:LagWeather:DayTypeEarlyWeek -4.479e+01 3.811e+01 -1.17524
## hour17:LagWeather:DayTypeEarlyWeek -4.684e+01 3.847e+01 -1.21767
## hour18:LagWeather:DayTypeEarlyWeek -4.886e+01 3.851e+01 -1.26865
## hour19:LagWeather:DayTypeEarlyWeek -4.371e+01 3.829e+01 -1.14162
## hour20:LagWeather:DayTypeEarlyWeek -3.209e+01 3.838e+01 -0.83613
## hour21:LagWeather:DayTypeEarlyWeek -2.636e+01 3.875e+01 -0.68019
## hour22:LagWeather:DayTypeEarlyWeek -3.032e+01 3.871e+01 -0.78344
## hour23:LagWeather:DayTypeEarlyWeek -3.003e+01 3.831e+01 -0.78398
## hour24:LagWeather:DayTypeEarlyWeek -2.377e+01 3.741e+01 -0.63528
## hour1:LagWeather:DayTypeMidWeek     4.356e+00 1.786e+01  0.24391
## hour2:LagWeather:DayTypeMidWeek    -4.582e+01 3.097e+01 -1.47977
## hour3:LagWeather:DayTypeMidWeek    -2.464e+01 2.980e+01 -0.82693
## hour4:LagWeather:DayTypeMidWeek    -2.038e+01 2.921e+01 -0.69766
## hour5:LagWeather:DayTypeMidWeek    -1.430e+01 2.832e+01 -0.50508
## hour6:LagWeather:DayTypeMidWeek    -1.238e+01 2.707e+01 -0.45742
## hour7:LagWeather:DayTypeMidWeek    -2.035e+01 2.511e+01 -0.81070
## hour8:LagWeather:DayTypeMidWeek     6.507e+00 2.250e+01  0.28922
## hour9:LagWeather:DayTypeMidWeek     1.853e+01 1.895e+01  0.97803
## hour10:LagWeather:DayTypeMidWeek   -2.434e+00 2.282e+01 -0.10663
## hour11:LagWeather:DayTypeMidWeek    7.901e+00 2.643e+01  0.29897
## hour12:LagWeather:DayTypeMidWeek    2.617e+01 2.909e+01  0.89944
## hour13:LagWeather:DayTypeMidWeek    3.453e+01 3.116e+01  1.10806
## hour14:LagWeather:DayTypeMidWeek    3.358e+01 3.273e+01  1.02602
## hour15:LagWeather:DayTypeMidWeek    2.871e+01 3.376e+01  0.85042
## hour16:LagWeather:DayTypeMidWeek    2.313e+01 3.430e+01  0.67445
## hour17:LagWeather:DayTypeMidWeek    1.724e+01 3.434e+01  0.50211
## hour18:LagWeather:DayTypeMidWeek    4.203e+00 3.390e+01  0.12399
## hour19:LagWeather:DayTypeMidWeek   -8.822e+00 3.301e+01 -0.26721
## hour20:LagWeather:DayTypeMidWeek   -2.238e+01 3.283e+01 -0.68159
## hour21:LagWeather:DayTypeMidWeek   -7.477e+01 3.376e+01 -2.21482
## hour22:LagWeather:DayTypeMidWeek   -6.179e+01 3.391e+01 -1.82220
## hour23:LagWeather:DayTypeMidWeek   -4.160e+01 3.311e+01 -1.25636
## hour24:LagWeather:DayTypeMidWeek   -4.150e+01 3.203e+01 -1.29538
## hour1:LagWeather:DayTypeWeekend     4.958e+01 1.868e+01  2.65382
## hour2:LagWeather:DayTypeWeekend     4.566e+01 2.982e+01  1.53129
## hour3:LagWeather:DayTypeWeekend     2.030e+01 2.902e+01  0.69942
## hour4:LagWeather:DayTypeWeekend     1.368e+01 2.897e+01  0.47229
## hour5:LagWeather:DayTypeWeekend     8.798e+00 2.829e+01  0.31094
## hour6:LagWeather:DayTypeWeekend     5.319e-01 2.713e+01  0.01960
## hour7:LagWeather:DayTypeWeekend    -2.262e+01 2.512e+01 -0.90045
## hour8:LagWeather:DayTypeWeekend    -8.276e+00 2.204e+01 -0.37546
## hour9:LagWeather:DayTypeWeekend     2.308e+00 1.765e+01  0.13076
## hour10:LagWeather:DayTypeWeekend    2.763e+01 2.352e+01  1.17507
## hour11:LagWeather:DayTypeWeekend    4.516e+01 2.687e+01  1.68056
## hour12:LagWeather:DayTypeWeekend    6.230e+01 2.913e+01  2.13849
## hour13:LagWeather:DayTypeWeekend    7.566e+01 3.057e+01  2.47465
## hour14:LagWeather:DayTypeWeekend    8.484e+01 3.145e+01  2.69759
## hour15:LagWeather:DayTypeWeekend    8.756e+01 3.170e+01  2.76208
## hour16:LagWeather:DayTypeWeekend    9.263e+01 3.159e+01  2.93215
## hour17:LagWeather:DayTypeWeekend    9.554e+01 3.124e+01  3.05797
## hour18:LagWeather:DayTypeWeekend    1.019e+02 3.071e+01  3.31775
## hour19:LagWeather:DayTypeWeekend    9.829e+01 3.001e+01  3.27541
## hour20:LagWeather:DayTypeWeekend    7.745e+01 2.996e+01  2.58478
## hour21:LagWeather:DayTypeWeekend    4.675e+01 3.072e+01  1.52204
## hour22:LagWeather:DayTypeWeekend    5.293e+01 3.066e+01  1.72640
## hour23:LagWeather:DayTypeWeekend    4.833e+01 3.017e+01  1.60217
## hour24:LagWeather:DayTypeWeekend    4.340e+01 2.933e+01  1.47979
##                                       p-value
## hour1:DayTypeEarlyWeek              3.145e-04
## hour2:DayTypeEarlyWeek              6.076e-01
## hour3:DayTypeEarlyWeek              6.162e-01
## hour4:DayTypeEarlyWeek              7.282e-01
## hour5:DayTypeEarlyWeek              8.614e-01
## hour6:DayTypeEarlyWeek              9.174e-01
## hour7:DayTypeEarlyWeek              7.420e-01
## hour8:DayTypeEarlyWeek              2.631e-01
## hour9:DayTypeEarlyWeek              4.029e-02
## hour10:DayTypeEarlyWeek             3.364e-06
## hour11:DayTypeEarlyWeek             5.566e-06
## hour12:DayTypeEarlyWeek             9.184e-06
## hour13:DayTypeEarlyWeek             7.100e-06
## hour14:DayTypeEarlyWeek             5.236e-06
## hour15:DayTypeEarlyWeek             3.559e-06
## hour16:DayTypeEarlyWeek             4.653e-07
## hour17:DayTypeEarlyWeek             6.504e-08
## hour18:DayTypeEarlyWeek             9.544e-08
## hour19:DayTypeEarlyWeek             1.599e-06
## hour20:DayTypeEarlyWeek             1.341e-03
## hour21:DayTypeEarlyWeek             2.317e-02
## hour22:DayTypeEarlyWeek             3.461e-04
## hour23:DayTypeEarlyWeek             7.602e-04
## hour24:DayTypeEarlyWeek             1.394e-02
## hour1:DayTypeMidWeek                5.911e-01
## hour2:DayTypeMidWeek                6.104e-01
## hour3:DayTypeMidWeek                5.038e-01
## hour4:DayTypeMidWeek                6.050e-01
## hour5:DayTypeMidWeek                6.589e-01
## hour6:DayTypeMidWeek                4.537e-01
## hour7:DayTypeMidWeek                1.615e-01
## hour8:DayTypeMidWeek                7.129e-01
## hour9:DayTypeMidWeek                7.784e-01
## hour10:DayTypeMidWeek               7.467e-01
## hour11:DayTypeMidWeek               9.260e-01
## hour12:DayTypeMidWeek               9.183e-01
## hour13:DayTypeMidWeek               8.937e-01
## hour14:DayTypeMidWeek               5.303e-01
## hour15:DayTypeMidWeek               2.974e-01
## hour16:DayTypeMidWeek               1.796e-01
## hour17:DayTypeMidWeek               8.989e-02
## hour18:DayTypeMidWeek               4.147e-02
## hour19:DayTypeMidWeek               2.745e-02
## hour20:DayTypeMidWeek               2.153e-02
## hour21:DayTypeMidWeek               3.757e-05
## hour22:DayTypeMidWeek               1.393e-05
## hour23:DayTypeMidWeek               8.775e-04
## hour24:DayTypeMidWeek               4.023e-03
## hour1:DayTypeWeekend                3.297e-01
## hour2:DayTypeWeekend                3.016e-07
## hour3:DayTypeWeekend                2.640e-02
## hour4:DayTypeWeekend                9.012e-02
## hour5:DayTypeWeekend                2.997e-01
## hour6:DayTypeWeekend                4.467e-01
## hour7:DayTypeWeekend                3.657e-01
## hour8:DayTypeWeekend                8.833e-01
## hour9:DayTypeWeekend                1.109e-01
## hour10:DayTypeWeekend               6.208e-01
## hour11:DayTypeWeekend               4.212e-01
## hour12:DayTypeWeekend               2.989e-01
## hour13:DayTypeWeekend               1.711e-01
## hour14:DayTypeWeekend               1.622e-01
## hour15:DayTypeWeekend               1.304e-01
## hour16:DayTypeWeekend               8.061e-02
## hour17:DayTypeWeekend               4.963e-02
## hour18:DayTypeWeekend               1.438e-02
## hour19:DayTypeWeekend               1.423e-03
## hour20:DayTypeWeekend               5.336e-05
## hour21:DayTypeWeekend               4.307e-04
## hour22:DayTypeWeekend               2.359e-02
## hour23:DayTypeWeekend               5.217e-02
## hour24:DayTypeWeekend               2.094e-02
## hour1:F:DayTypeEarlyWeek           1.356e-153
## hour2:F:DayTypeEarlyWeek           5.285e-158
## hour3:F:DayTypeEarlyWeek           1.497e-103
## hour4:F:DayTypeEarlyWeek            8.305e-67
## hour5:F:DayTypeEarlyWeek            7.705e-53
## hour6:F:DayTypeEarlyWeek            6.981e-54
## hour7:F:DayTypeEarlyWeek            5.076e-80
## hour8:F:DayTypeEarlyWeek           1.181e-113
## hour9:F:DayTypeEarlyWeek           3.919e-166
## hour10:F:DayTypeEarlyWeek          2.844e-160
## hour11:F:DayTypeEarlyWeek          2.808e-156
## hour12:F:DayTypeEarlyWeek          2.653e-175
## hour13:F:DayTypeEarlyWeek          1.230e-198
## hour14:F:DayTypeEarlyWeek          2.762e-223
## hour15:F:DayTypeEarlyWeek          1.679e-251
## hour16:F:DayTypeEarlyWeek          1.086e-283
## hour17:F:DayTypeEarlyWeek           0.000e+00
## hour18:F:DayTypeEarlyWeek           0.000e+00
## hour19:F:DayTypeEarlyWeek           0.000e+00
## hour20:F:DayTypeEarlyWeek           0.000e+00
## hour21:F:DayTypeEarlyWeek          1.451e-320
## hour22:F:DayTypeEarlyWeek          2.406e-257
## hour23:F:DayTypeEarlyWeek          1.705e-233
## hour24:F:DayTypeEarlyWeek          8.073e-239
## hour1:F:DayTypeMidWeek             1.259e-221
## hour2:F:DayTypeMidWeek             1.066e-228
## hour3:F:DayTypeMidWeek             1.830e-142
## hour4:F:DayTypeMidWeek             1.249e-106
## hour5:F:DayTypeMidWeek              2.129e-89
## hour6:F:DayTypeMidWeek              9.464e-83
## hour7:F:DayTypeMidWeek              2.098e-86
## hour8:F:DayTypeMidWeek             6.349e-119
## hour9:F:DayTypeMidWeek             5.262e-182
## hour10:F:DayTypeMidWeek            9.293e-177
## hour11:F:DayTypeMidWeek            3.927e-176
## hour12:F:DayTypeMidWeek            2.851e-183
## hour13:F:DayTypeMidWeek            1.874e-190
## hour14:F:DayTypeMidWeek            6.812e-198
## hour15:F:DayTypeMidWeek            1.825e-206
## hour16:F:DayTypeMidWeek            4.019e-221
## hour17:F:DayTypeMidWeek            3.403e-238
## hour18:F:DayTypeMidWeek            4.177e-263
## hour19:F:DayTypeMidWeek            9.532e-306
## hour20:F:DayTypeMidWeek            2.005e-290
## hour21:F:DayTypeMidWeek            1.008e-208
## hour22:F:DayTypeMidWeek            8.977e-175
## hour23:F:DayTypeMidWeek            7.230e-156
## hour24:F:DayTypeMidWeek            7.685e-145
## hour1:F:DayTypeWeekend             4.427e-133
## hour2:F:DayTypeWeekend             3.310e-162
## hour3:F:DayTypeWeekend              9.628e-92
## hour4:F:DayTypeWeekend              1.211e-60
## hour5:F:DayTypeWeekend              3.336e-47
## hour6:F:DayTypeWeekend              2.138e-42
## hour7:F:DayTypeWeekend              1.040e-46
## hour8:F:DayTypeWeekend              1.199e-55
## hour9:F:DayTypeWeekend              2.211e-88
## hour10:F:DayTypeWeekend             2.330e-92
## hour11:F:DayTypeWeekend             1.017e-99
## hour12:F:DayTypeWeekend            1.055e-112
## hour13:F:DayTypeWeekend            7.001e-129
## hour14:F:DayTypeWeekend            9.836e-146
## hour15:F:DayTypeWeekend            8.736e-164
## hour16:F:DayTypeWeekend            1.253e-180
## hour17:F:DayTypeWeekend            3.361e-201
## hour18:F:DayTypeWeekend            6.224e-229
## hour19:F:DayTypeWeekend            2.287e-289
## hour20:F:DayTypeWeekend            6.036e-273
## hour21:F:DayTypeWeekend            4.968e-186
## hour22:F:DayTypeWeekend            1.425e-147
## hour23:F:DayTypeWeekend            4.955e-132
## hour24:F:DayTypeWeekend            9.892e-135
## hour1:LagHE:DayTypeEarlyWeek        8.834e-01
## hour2:LagHE:DayTypeEarlyWeek        1.477e-04
## hour3:LagHE:DayTypeEarlyWeek        1.745e-02
## hour4:LagHE:DayTypeEarlyWeek        1.894e-01
## hour5:LagHE:DayTypeEarlyWeek        5.975e-01
## hour6:LagHE:DayTypeEarlyWeek        8.805e-01
## hour7:LagHE:DayTypeEarlyWeek        5.868e-01
## hour8:LagHE:DayTypeEarlyWeek        5.218e-01
## hour9:LagHE:DayTypeEarlyWeek        2.691e-01
## hour10:LagHE:DayTypeEarlyWeek       3.530e-02
## hour11:LagHE:DayTypeEarlyWeek       7.781e-02
## hour12:LagHE:DayTypeEarlyWeek       5.835e-02
## hour13:LagHE:DayTypeEarlyWeek       4.772e-02
## hour14:LagHE:DayTypeEarlyWeek       4.574e-02
## hour15:LagHE:DayTypeEarlyWeek       2.772e-02
## hour16:LagHE:DayTypeEarlyWeek       4.704e-03
## hour17:LagHE:DayTypeEarlyWeek       1.183e-04
## hour18:LagHE:DayTypeEarlyWeek       1.876e-07
## hour19:LagHE:DayTypeEarlyWeek       1.227e-10
## hour20:LagHE:DayTypeEarlyWeek       1.870e-09
## hour21:LagHE:DayTypeEarlyWeek       1.564e-06
## hour22:LagHE:DayTypeEarlyWeek       5.441e-08
## hour23:LagHE:DayTypeEarlyWeek       1.279e-06
## hour24:LagHE:DayTypeEarlyWeek       1.319e-05
## hour1:LagHE:DayTypeMidWeek          6.209e-01
## hour2:LagHE:DayTypeMidWeek          2.059e-14
## hour3:LagHE:DayTypeMidWeek          6.117e-05
## hour4:LagHE:DayTypeMidWeek          6.979e-03
## hour5:LagHE:DayTypeMidWeek          6.510e-02
## hour6:LagHE:DayTypeMidWeek          1.624e-01
## hour7:LagHE:DayTypeMidWeek          2.234e-01
## hour8:LagHE:DayTypeMidWeek          3.076e-01
## hour9:LagHE:DayTypeMidWeek          3.138e-01
## hour10:LagHE:DayTypeMidWeek         5.853e-01
## hour11:LagHE:DayTypeMidWeek         9.929e-01
## hour12:LagHE:DayTypeMidWeek         4.265e-01
## hour13:LagHE:DayTypeMidWeek         1.892e-01
## hour14:LagHE:DayTypeMidWeek         1.281e-01
## hour15:LagHE:DayTypeMidWeek         1.165e-01
## hour16:LagHE:DayTypeMidWeek         2.156e-01
## hour17:LagHE:DayTypeMidWeek         5.480e-01
## hour18:LagHE:DayTypeMidWeek         5.389e-01
## hour19:LagHE:DayTypeMidWeek         1.974e-02
## hour20:LagHE:DayTypeMidWeek         1.105e-04
## hour21:LagHE:DayTypeMidWeek         2.087e-06
## hour22:LagHE:DayTypeMidWeek         1.016e-07
## hour23:LagHE:DayTypeMidWeek         8.356e-07
## hour24:LagHE:DayTypeMidWeek         1.324e-06
## hour1:LagHE:DayTypeWeekend          7.234e-01
## hour2:LagHE:DayTypeWeekend          2.718e-01
## hour3:LagHE:DayTypeWeekend          6.439e-01
## hour4:LagHE:DayTypeWeekend          7.557e-01
## hour5:LagHE:DayTypeWeekend          6.330e-01
## hour6:LagHE:DayTypeWeekend          6.527e-01
## hour7:LagHE:DayTypeWeekend          6.898e-01
## hour8:LagHE:DayTypeWeekend          1.270e-01
## hour9:LagHE:DayTypeWeekend          2.692e-03
## hour10:LagHE:DayTypeWeekend         2.057e-01
## hour11:LagHE:DayTypeWeekend         3.853e-01
## hour12:LagHE:DayTypeWeekend         5.760e-01
## hour13:LagHE:DayTypeWeekend         7.032e-01
## hour14:LagHE:DayTypeWeekend         6.890e-01
## hour15:LagHE:DayTypeWeekend         6.603e-01
## hour16:LagHE:DayTypeWeekend         8.166e-01
## hour17:LagHE:DayTypeWeekend         9.825e-01
## hour18:LagHE:DayTypeWeekend         7.440e-01
## hour19:LagHE:DayTypeWeekend         5.977e-01
## hour20:LagHE:DayTypeWeekend         3.581e-01
## hour21:LagHE:DayTypeWeekend         2.593e-01
## hour22:LagHE:DayTypeWeekend         7.131e-01
## hour23:LagHE:DayTypeWeekend         8.868e-01
## hour24:LagHE:DayTypeWeekend         9.193e-01
## hour1:Weather:DayTypeEarlyWeek      3.087e-04
## hour2:Weather:DayTypeEarlyWeek      3.513e-01
## hour3:Weather:DayTypeEarlyWeek      6.187e-01
## hour4:Weather:DayTypeEarlyWeek      6.183e-01
## hour5:Weather:DayTypeEarlyWeek      6.706e-01
## hour6:Weather:DayTypeEarlyWeek      8.005e-01
## hour7:Weather:DayTypeEarlyWeek      8.254e-01
## hour8:Weather:DayTypeEarlyWeek      4.544e-01
## hour9:Weather:DayTypeEarlyWeek      1.380e-01
## hour10:Weather:DayTypeEarlyWeek     7.239e-04
## hour11:Weather:DayTypeEarlyWeek     5.934e-04
## hour12:Weather:DayTypeEarlyWeek     8.955e-04
## hour13:Weather:DayTypeEarlyWeek     6.671e-04
## hour14:Weather:DayTypeEarlyWeek     6.435e-04
## hour15:Weather:DayTypeEarlyWeek     1.776e-04
## hour16:Weather:DayTypeEarlyWeek     4.204e-05
## hour17:Weather:DayTypeEarlyWeek     1.061e-05
## hour18:Weather:DayTypeEarlyWeek     1.330e-05
## hour19:Weather:DayTypeEarlyWeek     2.395e-05
## hour20:Weather:DayTypeEarlyWeek     1.534e-04
## hour21:Weather:DayTypeEarlyWeek     4.565e-03
## hour22:Weather:DayTypeEarlyWeek     3.871e-03
## hour23:Weather:DayTypeEarlyWeek     1.391e-03
## hour24:Weather:DayTypeEarlyWeek     3.734e-03
## hour1:Weather:DayTypeMidWeek        8.733e-01
## hour2:Weather:DayTypeMidWeek        5.626e-01
## hour3:Weather:DayTypeMidWeek        7.458e-01
## hour4:Weather:DayTypeMidWeek        6.577e-01
## hour5:Weather:DayTypeMidWeek        5.248e-01
## hour6:Weather:DayTypeMidWeek        2.419e-01
## hour7:Weather:DayTypeMidWeek        1.674e-02
## hour8:Weather:DayTypeMidWeek        7.062e-02
## hour9:Weather:DayTypeMidWeek        5.091e-02
## hour10:Weather:DayTypeMidWeek       8.404e-01
## hour11:Weather:DayTypeMidWeek       8.511e-01
## hour12:Weather:DayTypeMidWeek       8.770e-01
## hour13:Weather:DayTypeMidWeek       4.501e-01
## hour14:Weather:DayTypeMidWeek       2.111e-01
## hour15:Weather:DayTypeMidWeek       1.052e-01
## hour16:Weather:DayTypeMidWeek       6.535e-02
## hour17:Weather:DayTypeMidWeek       6.471e-02
## hour18:Weather:DayTypeMidWeek       1.130e-01
## hour19:Weather:DayTypeMidWeek       2.403e-01
## hour20:Weather:DayTypeMidWeek       2.023e-01
## hour21:Weather:DayTypeMidWeek       4.280e-03
## hour22:Weather:DayTypeMidWeek       1.349e-02
## hour23:Weather:DayTypeMidWeek       1.833e-01
## hour24:Weather:DayTypeMidWeek       3.212e-01
## hour1:Weather:DayTypeWeekend        1.993e-04
## hour2:Weather:DayTypeWeekend        6.709e-01
## hour3:Weather:DayTypeWeekend        2.784e-01
## hour4:Weather:DayTypeWeekend        1.971e-01
## hour5:Weather:DayTypeWeekend        1.054e-01
## hour6:Weather:DayTypeWeekend        2.379e-02
## hour7:Weather:DayTypeWeekend        1.220e-03
## hour8:Weather:DayTypeWeekend        1.100e-03
## hour9:Weather:DayTypeWeekend        3.774e-05
## hour10:Weather:DayTypeWeekend       4.782e-04
## hour11:Weather:DayTypeWeekend       1.628e-03
## hour12:Weather:DayTypeWeekend       5.402e-03
## hour13:Weather:DayTypeWeekend       1.394e-02
## hour14:Weather:DayTypeWeekend       2.550e-02
## hour15:Weather:DayTypeWeekend       7.949e-02
## hour16:Weather:DayTypeWeekend       2.139e-01
## hour17:Weather:DayTypeWeekend       4.380e-01
## hour18:Weather:DayTypeWeekend       7.734e-01
## hour19:Weather:DayTypeWeekend       9.219e-01
## hour20:Weather:DayTypeWeekend       9.018e-01
## hour21:Weather:DayTypeWeekend       5.011e-01
## hour22:Weather:DayTypeWeekend       5.607e-01
## hour23:Weather:DayTypeWeekend       7.569e-01
## hour24:Weather:DayTypeWeekend       8.240e-01
## hour1:LagWeather:DayTypeEarlyWeek   2.091e-01
## hour2:LagWeather:DayTypeEarlyWeek   3.893e-01
## hour3:LagWeather:DayTypeEarlyWeek   6.875e-01
## hour4:LagWeather:DayTypeEarlyWeek   7.923e-01
## hour5:LagWeather:DayTypeEarlyWeek   9.122e-01
## hour6:LagWeather:DayTypeEarlyWeek   9.884e-01
## hour7:LagWeather:DayTypeEarlyWeek   8.414e-01
## hour8:LagWeather:DayTypeEarlyWeek   3.355e-01
## hour9:LagWeather:DayTypeEarlyWeek   2.572e-01
## hour10:LagWeather:DayTypeEarlyWeek  2.086e-02
## hour11:LagWeather:DayTypeEarlyWeek  4.909e-02
## hour12:LagWeather:DayTypeEarlyWeek  8.613e-02
## hour13:LagWeather:DayTypeEarlyWeek  1.044e-01
## hour14:LagWeather:DayTypeEarlyWeek  1.237e-01
## hour15:LagWeather:DayTypeEarlyWeek  2.124e-01
## hour16:LagWeather:DayTypeEarlyWeek  2.400e-01
## hour17:LagWeather:DayTypeEarlyWeek  2.235e-01
## hour18:LagWeather:DayTypeEarlyWeek  2.047e-01
## hour19:LagWeather:DayTypeEarlyWeek  2.537e-01
## hour20:LagWeather:DayTypeEarlyWeek  4.032e-01
## hour21:LagWeather:DayTypeEarlyWeek  4.964e-01
## hour22:LagWeather:DayTypeEarlyWeek  4.334e-01
## hour23:LagWeather:DayTypeEarlyWeek  4.331e-01
## hour24:LagWeather:DayTypeEarlyWeek  5.253e-01
## hour1:LagWeather:DayTypeMidWeek     8.073e-01
## hour2:LagWeather:DayTypeMidWeek     1.391e-01
## hour3:LagWeather:DayTypeMidWeek     4.084e-01
## hour4:LagWeather:DayTypeMidWeek     4.855e-01
## hour5:LagWeather:DayTypeMidWeek     6.135e-01
## hour6:LagWeather:DayTypeMidWeek     6.474e-01
## hour7:LagWeather:DayTypeMidWeek     4.176e-01
## hour8:LagWeather:DayTypeMidWeek     7.724e-01
## hour9:LagWeather:DayTypeMidWeek     3.282e-01
## hour10:LagWeather:DayTypeMidWeek    9.151e-01
## hour11:LagWeather:DayTypeMidWeek    7.650e-01
## hour12:LagWeather:DayTypeMidWeek    3.685e-01
## hour13:LagWeather:DayTypeMidWeek    2.679e-01
## hour14:LagWeather:DayTypeMidWeek    3.050e-01
## hour15:LagWeather:DayTypeMidWeek    3.952e-01
## hour16:LagWeather:DayTypeMidWeek    5.001e-01
## hour17:LagWeather:DayTypeMidWeek    6.156e-01
## hour18:LagWeather:DayTypeMidWeek    9.013e-01
## hour19:LagWeather:DayTypeMidWeek    7.893e-01
## hour20:LagWeather:DayTypeMidWeek    4.956e-01
## hour21:LagWeather:DayTypeMidWeek    2.686e-02
## hour22:LagWeather:DayTypeMidWeek    6.854e-02
## hour23:LagWeather:DayTypeMidWeek    2.091e-01
## hour24:LagWeather:DayTypeMidWeek    1.953e-01
## hour1:LagWeather:DayTypeWeekend     8.007e-03
## hour2:LagWeather:DayTypeWeekend     1.258e-01
## hour3:LagWeather:DayTypeWeekend     4.844e-01
## hour4:LagWeather:DayTypeWeekend     6.368e-01
## hour5:LagWeather:DayTypeWeekend     7.559e-01
## hour6:LagWeather:DayTypeWeekend     9.844e-01
## hour7:LagWeather:DayTypeWeekend     3.680e-01
## hour8:LagWeather:DayTypeWeekend     7.073e-01
## hour9:LagWeather:DayTypeWeekend     8.960e-01
## hour10:LagWeather:DayTypeWeekend    2.401e-01
## hour11:LagWeather:DayTypeWeekend    9.297e-02
## hour12:LagWeather:DayTypeWeekend    3.257e-02
## hour13:LagWeather:DayTypeWeekend    1.340e-02
## hour14:LagWeather:DayTypeWeekend    7.030e-03
## hour15:LagWeather:DayTypeWeekend    5.784e-03
## hour16:LagWeather:DayTypeWeekend    3.396e-03
## hour17:LagWeather:DayTypeWeekend    2.251e-03
## hour18:LagWeather:DayTypeWeekend    9.200e-04
## hour19:LagWeather:DayTypeWeekend    1.069e-03
## hour20:LagWeather:DayTypeWeekend    9.798e-03
## hour21:LagWeather:DayTypeWeekend    1.281e-01
## hour22:LagWeather:DayTypeWeekend    8.439e-02
## hour23:LagWeather:DayTypeWeekend    1.092e-01
## hour24:LagWeather:DayTypeWeekend    1.391e-01
```

```r
# 
# ARbyHourDay<-gls(HE~(hour+(F+LagHE+Weather+LagWeather):hour):weekdays(DateOnly), data=LagFormData,corAR1(form=~1),na.action=na.omit)
# summary(ARbyHourDay)$tTable
```

Try without lag of forecast


```r
LagFormData<-sqldf("select * from LagFormData order by DateOnly,hour;")
ARbyHourDayNoLagLoad<-gls(HE~-1+(hour+(F+Weather+LagWeather):hour):DayType, data=LagFormData,corAR1(form=~1),na.action=na.omit)
summary(ARbyHourDayNoLagLoad)$tTable
```

```
##                                         Value Std.Error  t-value
## hour1:DayTypeEarlyWeek              8.108e+03 2.649e+03  3.06122
## hour2:DayTypeEarlyWeek             -1.085e+04 3.517e+03 -3.08348
## hour3:DayTypeEarlyWeek             -1.038e+04 3.946e+03 -2.63070
## hour4:DayTypeEarlyWeek             -8.304e+03 4.353e+03 -1.90777
## hour5:DayTypeEarlyWeek             -5.686e+03 4.584e+03 -1.24033
## hour6:DayTypeEarlyWeek             -3.448e+03 4.672e+03 -0.73796
## hour7:DayTypeEarlyWeek             -3.107e+03 4.511e+03 -0.68890
## hour8:DayTypeEarlyWeek              1.640e+03 4.015e+03  0.40862
## hour9:DayTypeEarlyWeek              4.078e+03 3.259e+03  1.25158
## hour10:DayTypeEarlyWeek             1.311e+04 3.621e+03  3.62137
## hour11:DayTypeEarlyWeek             1.344e+04 3.837e+03  3.50280
## hour12:DayTypeEarlyWeek             1.264e+04 3.885e+03  3.25399
## hour13:DayTypeEarlyWeek             1.249e+04 3.873e+03  3.22459
## hour14:DayTypeEarlyWeek             1.239e+04 3.836e+03  3.23001
## hour15:DayTypeEarlyWeek             1.195e+04 3.774e+03  3.16718
## hour16:DayTypeEarlyWeek             1.209e+04 3.697e+03  3.27019
## hour17:DayTypeEarlyWeek             1.134e+04 3.596e+03  3.15283
## hour18:DayTypeEarlyWeek             8.443e+03 3.462e+03  2.43869
## hour19:DayTypeEarlyWeek             4.383e+03 3.252e+03  1.34793
## hour20:DayTypeEarlyWeek            -1.229e+03 3.315e+03 -0.37070
## hour21:DayTypeEarlyWeek            -3.681e+03 3.770e+03 -0.97650
## hour22:DayTypeEarlyWeek             9.529e+02 3.955e+03  0.24092
## hour23:DayTypeEarlyWeek             1.621e+03 3.891e+03  0.41646
## hour24:DayTypeEarlyWeek            -6.207e+02 3.701e+03 -0.16773
## hour1:DayTypeMidWeek                6.702e+02 2.705e+03  0.24779
## hour2:DayTypeMidWeek               -1.846e+04 3.548e+03 -5.20435
## hour3:DayTypeMidWeek               -1.033e+04 3.948e+03 -2.61642
## hour4:DayTypeMidWeek               -8.303e+03 4.229e+03 -1.96316
## hour5:DayTypeMidWeek               -6.238e+03 4.410e+03 -1.41458
## hour6:DayTypeMidWeek               -3.026e+03 4.563e+03 -0.66325
## hour7:DayTypeMidWeek                1.625e+03 4.568e+03  0.35567
## hour8:DayTypeMidWeek               -2.772e+03 4.182e+03 -0.66284
## hour9:DayTypeMidWeek               -2.546e+03 3.439e+03 -0.74045
## hour10:DayTypeMidWeek              -2.352e+03 3.778e+03 -0.62258
## hour11:DayTypeMidWeek              -2.439e+03 3.988e+03 -0.61146
## hour12:DayTypeMidWeek              -1.856e+03 4.052e+03 -0.45814
## hour13:DayTypeMidWeek               7.573e+01 4.074e+03  0.01859
## hour14:DayTypeMidWeek               2.444e+03 4.076e+03  0.59959
## hour15:DayTypeMidWeek               3.913e+03 4.058e+03  0.96413
## hour16:DayTypeMidWeek               3.833e+03 4.011e+03  0.95572
## hour17:DayTypeMidWeek               3.212e+03 3.949e+03  0.81337
## hour18:DayTypeMidWeek               1.232e+03 3.834e+03  0.32121
## hour19:DayTypeMidWeek              -2.322e+03 3.622e+03 -0.64112
## hour20:DayTypeMidWeek              -5.009e+03 3.686e+03 -1.35870
## hour21:DayTypeMidWeek               1.589e+03 4.159e+03  0.38211
## hour22:DayTypeMidWeek               1.579e+03 4.381e+03  0.36042
## hour23:DayTypeMidWeek              -1.847e+03 4.394e+03 -0.42035
## hour24:DayTypeMidWeek              -2.978e+03 4.283e+03 -0.69533
## hour1:DayTypeWeekend               -2.569e+03 3.165e+03 -0.81179
## hour2:DayTypeWeekend               -1.990e+04 3.855e+03 -5.16263
## hour3:DayTypeWeekend               -1.247e+04 4.504e+03 -2.76822
## hour4:DayTypeWeekend               -1.092e+04 5.139e+03 -2.12550
## hour5:DayTypeWeekend               -8.321e+03 5.516e+03 -1.50874
## hour6:DayTypeWeekend               -6.828e+03 5.639e+03 -1.21088
## hour7:DayTypeWeekend               -7.241e+03 5.350e+03 -1.35346
## hour8:DayTypeWeekend               -4.049e+03 4.832e+03 -0.83792
## hour9:DayTypeWeekend               -4.199e+02 3.971e+03 -0.10575
## hour10:DayTypeWeekend              -4.448e+03 4.174e+03 -1.06560
## hour11:DayTypeWeekend              -5.040e+03 4.251e+03 -1.18570
## hour12:DayTypeWeekend              -5.425e+03 4.214e+03 -1.28747
## hour13:DayTypeWeekend              -6.410e+03 4.147e+03 -1.54577
## hour14:DayTypeWeekend              -6.375e+03 4.040e+03 -1.57799
## hour15:DayTypeWeekend              -6.653e+03 3.909e+03 -1.70181
## hour16:DayTypeWeekend              -6.930e+03 3.768e+03 -1.83914
## hour17:DayTypeWeekend              -7.087e+03 3.615e+03 -1.96020
## hour18:DayTypeWeekend              -7.977e+03 3.440e+03 -2.31869
## hour19:DayTypeWeekend              -9.642e+03 3.189e+03 -3.02340
## hour20:DayTypeWeekend              -1.251e+04 3.276e+03 -3.81773
## hour21:DayTypeWeekend              -1.255e+04 3.880e+03 -3.23515
## hour22:DayTypeWeekend              -9.038e+03 4.099e+03 -2.20468
## hour23:DayTypeWeekend              -8.501e+03 4.057e+03 -2.09546
## hour24:DayTypeWeekend              -9.881e+03 3.894e+03 -2.53761
## hour1:F:DayTypeEarlyWeek            9.303e-01 2.613e-02 35.60065
## hour2:F:DayTypeEarlyWeek            1.148e+00 3.224e-02 35.59776
## hour3:F:DayTypeEarlyWeek            1.136e+00 4.091e-02 27.77258
## hour4:F:DayTypeEarlyWeek            1.111e+00 4.831e-02 22.99647
## hour5:F:DayTypeEarlyWeek            1.074e+00 5.210e-02 20.61349
## hour6:F:DayTypeEarlyWeek            1.040e+00 5.193e-02 20.03137
## hour7:F:DayTypeEarlyWeek            1.036e+00 4.728e-02 21.90885
## hour8:F:DayTypeEarlyWeek            9.942e-01 3.887e-02 25.57647
## hour9:F:DayTypeEarlyWeek            9.724e-01 2.964e-02 32.80881
## hour10:F:DayTypeEarlyWeek           9.153e-01 2.941e-02 31.12857
## hour11:F:DayTypeEarlyWeek           9.219e-01 2.853e-02 32.31011
## hour12:F:DayTypeEarlyWeek           9.334e-01 2.674e-02 34.91004
## hour13:F:DayTypeEarlyWeek           9.393e-01 2.498e-02 37.60648
## hour14:F:DayTypeEarlyWeek           9.421e-01 2.335e-02 40.34276
## hour15:F:DayTypeEarlyWeek           9.474e-01 2.198e-02 43.09389
## hour16:F:DayTypeEarlyWeek           9.490e-01 2.075e-02 45.73821
## hour17:F:DayTypeEarlyWeek           9.581e-01 1.955e-02 48.99433
## hour18:F:DayTypeEarlyWeek           9.802e-01 1.840e-02 53.26232
## hour19:F:DayTypeEarlyWeek           1.010e+00 1.694e-02 59.60536
## hour20:F:DayTypeEarlyWeek           1.049e+00 1.824e-02 57.47922
## hour21:F:DayTypeEarlyWeek           1.057e+00 2.332e-02 45.32499
## hour22:F:DayTypeEarlyWeek           1.015e+00 2.580e-02 39.33059
## hour23:F:DayTypeEarlyWeek           1.015e+00 2.732e-02 37.13868
## hour24:F:DayTypeEarlyWeek           1.036e+00 2.827e-02 36.64506
## hour1:F:DayTypeMidWeek              9.836e-01 2.642e-02 37.23084
## hour2:F:DayTypeMidWeek              1.202e+00 3.407e-02 35.27628
## hour3:F:DayTypeMidWeek              1.124e+00 4.147e-02 27.09356
## hour4:F:DayTypeMidWeek              1.106e+00 4.675e-02 23.64931
## hour5:F:DayTypeMidWeek              1.082e+00 4.958e-02 21.82641
## hour6:F:DayTypeMidWeek              1.047e+00 5.010e-02 20.89153
## hour7:F:DayTypeMidWeek              1.007e+00 4.785e-02 21.04016
## hour8:F:DayTypeMidWeek              1.035e+00 4.093e-02 25.29583
## hour9:F:DayTypeMidWeek              1.026e+00 3.112e-02 32.96334
## hour10:F:DayTypeMidWeek             1.010e+00 3.182e-02 31.74747
## hour11:F:DayTypeMidWeek             1.007e+00 3.089e-02 32.58647
## hour12:F:DayTypeMidWeek             9.991e-01 2.921e-02 34.20793
## hour13:F:DayTypeMidWeek             9.864e-01 2.770e-02 35.60920
## hour14:F:DayTypeMidWeek             9.716e-01 2.637e-02 36.84961
## hour15:F:DayTypeMidWeek             9.647e-01 2.530e-02 38.12544
## hour16:F:DayTypeMidWeek             9.675e-01 2.436e-02 39.71762
## hour17:F:DayTypeMidWeek             9.700e-01 2.355e-02 41.19845
## hour18:F:DayTypeMidWeek             9.803e-01 2.276e-02 43.06206
## hour19:F:DayTypeMidWeek             1.001e+00 2.180e-02 45.88711
## hour20:F:DayTypeMidWeek             1.023e+00 2.343e-02 43.65544
## hour21:F:DayTypeMidWeek             9.950e-01 2.834e-02 35.11474
## hour22:F:DayTypeMidWeek             9.818e-01 3.118e-02 31.49101
## hour23:F:DayTypeMidWeek             9.985e-01 3.385e-02 29.49326
## hour24:F:DayTypeMidWeek             1.011e+00 3.633e-02 27.83816
## hour1:F:DayTypeWeekend              1.036e+00 3.414e-02 30.32954
## hour2:F:DayTypeWeekend              1.251e+00 4.186e-02 29.89384
## hour3:F:DayTypeWeekend              1.171e+00 5.400e-02 21.69366
## hour4:F:DayTypeWeekend              1.161e+00 6.552e-02 17.72814
## hour5:F:DayTypeWeekend              1.131e+00 7.277e-02 15.54397
## hour6:F:DayTypeWeekend              1.122e+00 7.573e-02 14.81783
## hour7:F:DayTypeWeekend              1.154e+00 7.294e-02 15.82762
## hour8:F:DayTypeWeekend              1.083e+00 6.363e-02 17.01482
## hour9:F:DayTypeWeekend              1.017e+00 4.782e-02 21.27024
## hour10:F:DayTypeWeekend             1.066e+00 4.446e-02 23.97604
## hour11:F:DayTypeWeekend             1.062e+00 4.093e-02 25.95178
## hour12:F:DayTypeWeekend             1.056e+00 3.715e-02 28.41783
## hour13:F:DayTypeWeekend             1.057e+00 3.401e-02 31.07038
## hour14:F:DayTypeWeekend             1.049e+00 3.123e-02 33.58702
## hour15:F:DayTypeWeekend             1.043e+00 2.882e-02 36.20871
## hour16:F:DayTypeWeekend             1.037e+00 2.666e-02 38.90405
## hour17:F:DayTypeWeekend             1.032e+00 2.466e-02 41.83548
## hour18:F:DayTypeWeekend             1.033e+00 2.284e-02 45.25058
## hour19:F:DayTypeWeekend             1.048e+00 2.083e-02 50.31925
## hour20:F:DayTypeWeekend             1.087e+00 2.256e-02 48.17284
## hour21:F:DayTypeWeekend             1.115e+00 2.945e-02 37.87473
## hour22:F:DayTypeWeekend             1.073e+00 3.218e-02 33.34672
## hour23:F:DayTypeWeekend             1.066e+00 3.375e-02 31.59103
## hour24:F:DayTypeWeekend             1.089e+00 3.495e-02 31.14415
## hour1:Weather:DayTypeEarlyWeek     -6.183e+01 1.881e+01 -3.28702
## hour2:Weather:DayTypeEarlyWeek     -3.636e+01 3.663e+01 -0.99281
## hour3:Weather:DayTypeEarlyWeek     -2.366e+01 3.489e+01 -0.67799
## hour4:Weather:DayTypeEarlyWeek     -2.141e+01 3.400e+01 -0.62968
## hour5:Weather:DayTypeEarlyWeek     -1.658e+01 3.275e+01 -0.50624
## hour6:Weather:DayTypeEarlyWeek     -7.948e+00 3.101e+01 -0.25631
## hour7:Weather:DayTypeEarlyWeek     -4.791e+00 2.860e+01 -0.16753
## hour8:Weather:DayTypeEarlyWeek     -2.501e+01 2.523e+01 -0.99117
## hour9:Weather:DayTypeEarlyWeek     -3.725e+01 2.003e+01 -1.86033
## hour10:Weather:DayTypeEarlyWeek    -8.680e+01 2.468e+01 -3.51711
## hour11:Weather:DayTypeEarlyWeek    -9.908e+01 2.844e+01 -3.48319
## hour12:Weather:DayTypeEarlyWeek    -1.040e+02 3.105e+01 -3.35021
## hour13:Weather:DayTypeEarlyWeek    -1.116e+02 3.290e+01 -3.39160
## hour14:Weather:DayTypeEarlyWeek    -1.158e+02 3.425e+01 -3.37996
## hour15:Weather:DayTypeEarlyWeek    -1.296e+02 3.521e+01 -3.68032
## hour16:Weather:DayTypeEarlyWeek    -1.440e+02 3.591e+01 -4.00893
## hour17:Weather:DayTypeEarlyWeek    -1.575e+02 3.638e+01 -4.32840
## hour18:Weather:DayTypeEarlyWeek    -1.579e+02 3.667e+01 -4.30703
## hour19:Weather:DayTypeEarlyWeek    -1.539e+02 3.677e+01 -4.18586
## hour20:Weather:DayTypeEarlyWeek    -1.374e+02 3.688e+01 -3.72664
## hour21:Weather:DayTypeEarlyWeek    -1.044e+02 3.693e+01 -2.82766
## hour22:Weather:DayTypeEarlyWeek    -1.062e+02 3.680e+01 -2.88509
## hour23:Weather:DayTypeEarlyWeek    -1.157e+02 3.643e+01 -3.17711
## hour24:Weather:DayTypeEarlyWeek    -1.030e+02 3.585e+01 -2.87299
## hour1:Weather:DayTypeMidWeek       -2.187e-01 1.823e+01 -0.01199
## hour2:Weather:DayTypeMidWeek        3.078e+01 3.188e+01  0.96553
## hour3:Weather:DayTypeMidWeek       -1.235e+00 3.073e+01 -0.04017
## hour4:Weather:DayTypeMidWeek       -6.309e+00 3.011e+01 -0.20952
## hour5:Weather:DayTypeMidWeek       -1.343e+01 2.923e+01 -0.45945
## hour6:Weather:DayTypeMidWeek       -2.891e+01 2.803e+01 -1.03157
## hour7:Weather:DayTypeMidWeek       -6.035e+01 2.621e+01 -2.30287
## hour8:Weather:DayTypeMidWeek       -4.335e+01 2.359e+01 -1.83780
## hour9:Weather:DayTypeMidWeek       -4.018e+01 1.965e+01 -2.04514
## hour10:Weather:DayTypeMidWeek       7.723e+00 2.347e+01  0.32904
## hour11:Weather:DayTypeMidWeek       1.174e+01 2.689e+01  0.43668
## hour12:Weather:DayTypeMidWeek       7.837e+00 2.932e+01  0.26730
## hour13:Weather:DayTypeMidWeek      -5.819e+00 3.112e+01 -0.18697
## hour14:Weather:DayTypeMidWeek      -1.871e+01 3.245e+01 -0.57649
## hour15:Weather:DayTypeMidWeek      -2.880e+01 3.337e+01 -0.86303
## hour16:Weather:DayTypeMidWeek      -3.577e+01 3.390e+01 -1.05496
## hour17:Weather:DayTypeMidWeek      -3.611e+01 3.416e+01 -1.05716
## hour18:Weather:DayTypeMidWeek      -2.800e+01 3.408e+01 -0.82154
## hour19:Weather:DayTypeMidWeek      -1.318e+01 3.361e+01 -0.39207
## hour20:Weather:DayTypeMidWeek      -1.784e+01 3.352e+01 -0.53222
## hour21:Weather:DayTypeMidWeek      -7.252e+01 3.398e+01 -2.13447
## hour22:Weather:DayTypeMidWeek      -6.394e+01 3.387e+01 -1.88767
## hour23:Weather:DayTypeMidWeek      -3.004e+01 3.343e+01 -0.89862
## hour24:Weather:DayTypeMidWeek      -1.760e+01 3.274e+01 -0.53766
## hour1:Weather:DayTypeWeekend       -6.877e+01 1.829e+01 -3.76089
## hour2:Weather:DayTypeWeekend       -1.290e+01 2.955e+01 -0.43662
## hour3:Weather:DayTypeWeekend       -3.132e+01 2.854e+01 -1.09755
## hour4:Weather:DayTypeWeekend       -3.614e+01 2.810e+01 -1.28598
## hour5:Weather:DayTypeWeekend       -4.375e+01 2.717e+01 -1.61000
## hour6:Weather:DayTypeWeekend       -5.725e+01 2.563e+01 -2.23333
## hour7:Weather:DayTypeWeekend       -7.455e+01 2.333e+01 -3.19622
## hour8:Weather:DayTypeWeekend       -7.031e+01 2.055e+01 -3.42204
## hour9:Weather:DayTypeWeekend       -7.588e+01 1.670e+01 -4.54446
## hour10:Weather:DayTypeWeekend      -8.391e+01 2.196e+01 -3.82113
## hour11:Weather:DayTypeWeekend      -8.404e+01 2.503e+01 -3.35740
## hour12:Weather:DayTypeWeekend      -7.941e+01 2.730e+01 -2.90875
## hour13:Weather:DayTypeWeekend      -7.372e+01 2.889e+01 -2.55146
## hour14:Weather:DayTypeWeekend      -6.947e+01 2.994e+01 -2.32055
## hour15:Weather:DayTypeWeekend      -5.627e+01 3.051e+01 -1.84395
## hour16:Weather:DayTypeWeekend      -4.071e+01 3.074e+01 -1.32426
## hour17:Weather:DayTypeWeekend      -2.616e+01 3.072e+01 -0.85183
## hour18:Weather:DayTypeWeekend      -1.105e+01 3.049e+01 -0.36230
## hour19:Weather:DayTypeWeekend       3.321e-01 3.004e+01  0.01105
## hour20:Weather:DayTypeWeekend       1.373e+00 2.999e+01  0.04577
## hour21:Weather:DayTypeWeekend      -2.255e+01 3.041e+01 -0.74166
## hour22:Weather:DayTypeWeekend      -1.919e+01 3.036e+01 -0.63231
## hour23:Weather:DayTypeWeekend      -1.020e+01 2.999e+01 -0.34024
## hour24:Weather:DayTypeWeekend      -6.749e+00 2.935e+01 -0.22997
## hour1:LagWeather:DayTypeEarlyWeek  -1.823e+01 1.943e+01 -0.93838
## hour2:LagWeather:DayTypeEarlyWeek   7.969e+00 3.731e+01  0.21359
## hour3:LagWeather:DayTypeEarlyWeek   1.189e+01 3.553e+01  0.33467
## hour4:LagWeather:DayTypeEarlyWeek   9.069e+00 3.463e+01  0.26184
## hour5:LagWeather:DayTypeEarlyWeek   6.175e+00 3.336e+01  0.18510
## hour6:LagWeather:DayTypeEarlyWeek   2.163e+00 3.159e+01  0.06848
## hour7:LagWeather:DayTypeEarlyWeek  -7.300e+00 2.906e+01 -0.25117
## hour8:LagWeather:DayTypeEarlyWeek  -1.698e+01 2.556e+01 -0.66456
## hour9:LagWeather:DayTypeEarlyWeek  -1.216e+01 2.000e+01 -0.60785
## hour10:LagWeather:DayTypeEarlyWeek -3.420e+01 2.552e+01 -1.34037
## hour11:LagWeather:DayTypeEarlyWeek -3.292e+01 2.933e+01 -1.12233
## hour12:LagWeather:DayTypeEarlyWeek -2.693e+01 3.193e+01 -0.84317
## hour13:LagWeather:DayTypeEarlyWeek -2.483e+01 3.378e+01 -0.73501
## hour14:LagWeather:DayTypeEarlyWeek -2.298e+01 3.511e+01 -0.65436
## hour15:LagWeather:DayTypeEarlyWeek -1.047e+01 3.606e+01 -0.29037
## hour16:LagWeather:DayTypeEarlyWeek -8.763e-01 3.674e+01 -0.02385
## hour17:LagWeather:DayTypeEarlyWeek  8.269e+00 3.717e+01  0.22246
## hour18:LagWeather:DayTypeEarlyWeek  1.782e+01 3.740e+01  0.47656
## hour19:LagWeather:DayTypeEarlyWeek  2.683e+01 3.745e+01  0.71636
## hour20:LagWeather:DayTypeEarlyWeek  3.414e+01 3.751e+01  0.90999
## hour21:LagWeather:DayTypeEarlyWeek  3.557e+01 3.746e+01  0.94960
## hour22:LagWeather:DayTypeEarlyWeek  4.052e+01 3.729e+01  1.08657
## hour23:LagWeather:DayTypeEarlyWeek  3.246e+01 3.692e+01  0.87936
## hour24:LagWeather:DayTypeEarlyWeek  2.618e+01 3.631e+01  0.72118
## hour1:LagWeather:DayTypeMidWeek     4.306e+00 1.642e+01  0.26225
## hour2:LagWeather:DayTypeMidWeek     2.313e+01 3.003e+01  0.77042
## hour3:LagWeather:DayTypeMidWeek     1.595e+01 2.867e+01  0.55630
## hour4:LagWeather:DayTypeMidWeek     9.265e+00 2.795e+01  0.33145
## hour5:LagWeather:DayTypeMidWeek     7.074e+00 2.697e+01  0.26228
## hour6:LagWeather:DayTypeMidWeek     4.061e+00 2.561e+01  0.15858
## hour7:LagWeather:DayTypeMidWeek    -7.284e+00 2.370e+01 -0.30739
## hour8:LagWeather:DayTypeMidWeek     1.719e+01 2.110e+01  0.81453
## hour9:LagWeather:DayTypeMidWeek     2.959e+01 1.725e+01  1.71542
## hour10:LagWeather:DayTypeMidWeek    7.022e+00 2.066e+01  0.33980
## hour11:LagWeather:DayTypeMidWeek    1.200e+01 2.352e+01  0.51029
## hour12:LagWeather:DayTypeMidWeek    1.926e+01 2.553e+01  0.75427
## hour13:LagWeather:DayTypeMidWeek    1.862e+01 2.699e+01  0.68996
## hour14:LagWeather:DayTypeMidWeek    1.324e+01 2.806e+01  0.47192
## hour15:LagWeather:DayTypeMidWeek    7.586e+00 2.886e+01  0.26286
## hour16:LagWeather:DayTypeMidWeek    9.223e+00 2.945e+01  0.31322
## hour17:LagWeather:DayTypeMidWeek    1.683e+01 2.987e+01  0.56362
## hour18:LagWeather:DayTypeMidWeek    2.559e+01 3.013e+01  0.84914
## hour19:LagWeather:DayTypeMidWeek    3.516e+01 3.023e+01  1.16287
## hour20:LagWeather:DayTypeMidWeek    3.899e+01 3.027e+01  1.28792
## hour21:LagWeather:DayTypeMidWeek    7.634e+00 3.021e+01  0.25267
## hour22:LagWeather:DayTypeMidWeek    3.252e+01 3.012e+01  1.07963
## hour23:LagWeather:DayTypeMidWeek    3.983e+01 2.984e+01  1.33465
## hour24:LagWeather:DayTypeMidWeek    2.913e+01 2.941e+01  0.99057
## hour1:LagWeather:DayTypeWeekend     4.643e+01 1.661e+01  2.79556
## hour2:LagWeather:DayTypeWeekend     3.603e+01 2.873e+01  1.25402
## hour3:LagWeather:DayTypeWeekend     2.611e+01 2.726e+01  0.95785
## hour4:LagWeather:DayTypeWeekend     1.847e+01 2.652e+01  0.69656
## hour5:LagWeather:DayTypeWeekend     1.606e+01 2.552e+01  0.62953
## hour6:LagWeather:DayTypeWeekend     7.577e+00 2.416e+01  0.31369
## hour7:LagWeather:DayTypeWeekend    -1.662e+01 2.232e+01 -0.74464
## hour8:LagWeather:DayTypeWeekend     9.676e+00 1.964e+01  0.49267
## hour9:LagWeather:DayTypeWeekend     3.340e+01 1.537e+01  2.17244
## hour10:LagWeather:DayTypeWeekend    4.488e+01 2.031e+01  2.21008
## hour11:LagWeather:DayTypeWeekend    5.892e+01 2.280e+01  2.58458
## hour12:LagWeather:DayTypeWeekend    7.191e+01 2.458e+01  2.92587
## hour13:LagWeather:DayTypeWeekend    8.238e+01 2.589e+01  3.18269
## hour14:LagWeather:DayTypeWeekend    9.181e+01 2.686e+01  3.41816
## hour15:LagWeather:DayTypeWeekend    9.477e+01 2.758e+01  3.43651
## hour16:LagWeather:DayTypeWeekend    9.604e+01 2.810e+01  3.41790
## hour17:LagWeather:DayTypeWeekend    9.563e+01 2.848e+01  3.35807
## hour18:LagWeather:DayTypeWeekend    9.774e+01 2.873e+01  3.40249
## hour19:LagWeather:DayTypeWeekend    9.300e+01 2.883e+01  3.22553
## hour20:LagWeather:DayTypeWeekend    6.897e+01 2.887e+01  2.38929
## hour21:LagWeather:DayTypeWeekend    3.385e+01 2.879e+01  1.17582
## hour22:LagWeather:DayTypeWeekend    4.879e+01 2.866e+01  1.70265
## hour23:LagWeather:DayTypeWeekend    5.032e+01 2.838e+01  1.77287
## hour24:LagWeather:DayTypeWeekend    4.510e+01 2.796e+01  1.61324
##                                       p-value
## hour1:DayTypeEarlyWeek              2.226e-03
## hour2:DayTypeEarlyWeek              2.067e-03
## hour3:DayTypeEarlyWeek              8.570e-03
## hour4:DayTypeEarlyWeek              5.653e-02
## hour5:DayTypeEarlyWeek              2.150e-01
## hour6:DayTypeEarlyWeek              4.606e-01
## hour7:DayTypeEarlyWeek              4.909e-01
## hour8:DayTypeEarlyWeek              6.829e-01
## hour9:DayTypeEarlyWeek              2.108e-01
## hour10:DayTypeEarlyWeek             2.985e-04
## hour11:DayTypeEarlyWeek             4.680e-04
## hour12:DayTypeEarlyWeek             1.152e-03
## hour13:DayTypeEarlyWeek             1.277e-03
## hour14:DayTypeEarlyWeek             1.253e-03
## hour15:DayTypeEarlyWeek             1.557e-03
## hour16:DayTypeEarlyWeek             1.088e-03
## hour17:DayTypeEarlyWeek             1.635e-03
## hour18:DayTypeEarlyWeek             1.481e-02
## hour19:DayTypeEarlyWeek             1.778e-01
## hour20:DayTypeEarlyWeek             7.109e-01
## hour21:DayTypeEarlyWeek             3.289e-01
## hour22:DayTypeEarlyWeek             8.096e-01
## hour23:DayTypeEarlyWeek             6.771e-01
## hour24:DayTypeEarlyWeek             8.668e-01
## hour1:DayTypeMidWeek                8.043e-01
## hour2:DayTypeMidWeek                2.095e-07
## hour3:DayTypeMidWeek                8.936e-03
## hour4:DayTypeMidWeek                4.973e-02
## hour5:DayTypeMidWeek                1.573e-01
## hour6:DayTypeMidWeek                5.072e-01
## hour7:DayTypeMidWeek                7.221e-01
## hour8:DayTypeMidWeek                5.075e-01
## hour9:DayTypeMidWeek                4.591e-01
## hour10:DayTypeMidWeek               5.336e-01
## hour11:DayTypeMidWeek               5.409e-01
## hour12:DayTypeMidWeek               6.469e-01
## hour13:DayTypeMidWeek               9.852e-01
## hour14:DayTypeMidWeek               5.488e-01
## hour15:DayTypeMidWeek               3.351e-01
## hour16:DayTypeMidWeek               3.393e-01
## hour17:DayTypeMidWeek               4.161e-01
## hour18:DayTypeMidWeek               7.481e-01
## hour19:DayTypeMidWeek               5.215e-01
## hour20:DayTypeMidWeek               1.744e-01
## hour21:DayTypeMidWeek               7.024e-01
## hour22:DayTypeMidWeek               7.186e-01
## hour23:DayTypeMidWeek               6.743e-01
## hour24:DayTypeMidWeek               4.869e-01
## hour1:DayTypeWeekend                4.170e-01
## hour2:DayTypeWeekend                2.615e-07
## hour3:DayTypeWeekend                5.675e-03
## hour4:DayTypeWeekend                3.364e-02
## hour5:DayTypeWeekend                1.315e-01
## hour6:DayTypeWeekend                2.260e-01
## hour7:DayTypeWeekend                1.760e-01
## hour8:DayTypeWeekend                4.021e-01
## hour9:DayTypeWeekend                9.158e-01
## hour10:DayTypeWeekend               2.867e-01
## hour11:DayTypeWeekend               2.358e-01
## hour12:DayTypeWeekend               1.980e-01
## hour13:DayTypeWeekend               1.223e-01
## hour14:DayTypeWeekend               1.147e-01
## hour15:DayTypeWeekend               8.891e-02
## hour16:DayTypeWeekend               6.601e-02
## hour17:DayTypeWeekend               5.008e-02
## hour18:DayTypeWeekend               2.049e-02
## hour19:DayTypeWeekend               2.523e-03
## hour20:DayTypeWeekend               1.378e-04
## hour21:DayTypeWeekend               1.231e-03
## hour22:DayTypeWeekend               2.756e-02
## hour23:DayTypeWeekend               3.622e-02
## hour24:DayTypeWeekend               1.122e-02
## hour1:F:DayTypeEarlyWeek           2.034e-227
## hour2:F:DayTypeEarlyWeek           2.181e-227
## hour3:F:DayTypeEarlyWeek           2.611e-149
## hour4:F:DayTypeEarlyWeek           6.710e-107
## hour5:F:DayTypeEarlyWeek            1.020e-87
## hour6:F:DayTypeEarlyWeek            2.934e-83
## hour7:F:DayTypeEarlyWeek            5.776e-98
## hour8:F:DayTypeEarlyWeek           3.298e-129
## hour9:F:DayTypeEarlyWeek           1.384e-198
## hour10:F:DayTypeEarlyWeek          1.037e-181
## hour11:F:DayTypeEarlyWeek          1.550e-193
## hour12:F:DayTypeEarlyWeek          3.343e-220
## hour13:F:DayTypeEarlyWeek          1.201e-248
## hour14:F:DayTypeEarlyWeek          3.720e-278
## hour15:F:DayTypeEarlyWeek          2.575e-308
## hour16:F:DayTypeEarlyWeek           0.000e+00
## hour17:F:DayTypeEarlyWeek           0.000e+00
## hour18:F:DayTypeEarlyWeek           0.000e+00
## hour19:F:DayTypeEarlyWeek           0.000e+00
## hour20:F:DayTypeEarlyWeek           0.000e+00
## hour21:F:DayTypeEarlyWeek           0.000e+00
## hour22:F:DayTypeEarlyWeek          3.557e-267
## hour23:F:DayTypeEarlyWeek          1.159e-243
## hour24:F:DayTypeEarlyWeek          2.007e-238
## hour1:F:DayTypeMidWeek             1.213e-244
## hour2:F:DayTypeMidWeek             5.056e-224
## hour3:F:DayTypeMidWeek             5.407e-143
## hour4:F:DayTypeMidWeek             2.116e-112
## hour5:F:DayTypeMidWeek              2.672e-97
## hour6:F:DayTypeMidWeek              7.024e-90
## hour7:F:DayTypeMidWeek              4.812e-91
## hour8:F:DayTypeMidWeek             1.038e-126
## hour9:F:DayTypeMidWeek             3.715e-200
## hour10:F:DayTypeMidWeek            7.016e-188
## hour11:F:DayTypeMidWeek            2.491e-196
## hour12:F:DayTypeMidWeek            6.397e-213
## hour13:F:DayTypeMidWeek            1.654e-227
## hour14:F:DayTypeMidWeek            1.363e-240
## hour15:F:DayTypeMidWeek            3.370e-254
## hour16:F:DayTypeMidWeek            2.295e-271
## hour17:F:DayTypeMidWeek            1.719e-287
## hour18:F:DayTypeMidWeek            5.778e-308
## hour19:F:DayTypeMidWeek             0.000e+00
## hour20:F:DayTypeMidWeek            1.613e-314
## hour21:F:DayTypeMidWeek            2.458e-222
## hour22:F:DayTypeMidWeek            2.567e-185
## hour23:F:DayTypeMidWeek            1.091e-165
## hour24:F:DayTypeMidWeek            6.342e-150
## hour1:F:DayTypeWeekend             7.882e-174
## hour2:F:DayTypeWeekend             1.419e-169
## hour3:F:DayTypeWeekend              3.120e-96
## hour4:F:DayTypeWeekend              1.460e-66
## hour5:F:DayTypeWeekend              3.205e-52
## hour6:F:DayTypeWeekend              8.529e-48
## hour7:F:DayTypeWeekend              5.369e-54
## hour8:F:DayTypeWeekend              1.033e-61
## hour9:F:DayTypeWeekend              7.387e-93
## hour10:F:DayTypeWeekend            3.425e-115
## hour11:F:DayTypeWeekend            1.417e-132
## hour12:F:DayTypeWeekend            2.167e-155
## hour13:F:DayTypeWeekend            3.916e-181
## hour14:F:DayTypeWeekend            1.576e-206
## hour15:F:DayTypeWeekend            8.202e-234
## hour16:F:DayTypeWeekend            1.435e-262
## hour17:F:DayTypeWeekend            1.809e-294
## hour18:F:DayTypeWeekend             0.000e+00
## hour19:F:DayTypeWeekend             0.000e+00
## hour20:F:DayTypeWeekend             0.000e+00
## hour21:F:DayTypeWeekend            1.632e-251
## hour22:F:DayTypeWeekend            4.557e-204
## hour23:F:DayTypeWeekend            2.575e-186
## hour24:F:DayTypeWeekend            7.262e-182
## hour1:Weather:DayTypeEarlyWeek      1.026e-03
## hour2:Weather:DayTypeEarlyWeek      3.209e-01
## hour3:Weather:DayTypeEarlyWeek      4.978e-01
## hour4:Weather:DayTypeEarlyWeek      5.290e-01
## hour5:Weather:DayTypeEarlyWeek      6.127e-01
## hour6:Weather:DayTypeEarlyWeek      7.977e-01
## hour7:Weather:DayTypeEarlyWeek      8.670e-01
## hour8:Weather:DayTypeEarlyWeek      3.217e-01
## hour9:Weather:DayTypeEarlyWeek      6.295e-02
## hour10:Weather:DayTypeEarlyWeek     4.436e-04
## hour11:Weather:DayTypeEarlyWeek     5.035e-04
## hour12:Weather:DayTypeEarlyWeek     8.187e-04
## hour13:Weather:DayTypeEarlyWeek     7.050e-04
## hour14:Weather:DayTypeEarlyWeek     7.354e-04
## hour15:Weather:DayTypeEarlyWeek     2.376e-04
## hour16:Weather:DayTypeEarlyWeek     6.267e-05
## hour17:Weather:DayTypeEarlyWeek     1.557e-05
## hour18:Weather:DayTypeEarlyWeek     1.714e-05
## hour19:Weather:DayTypeEarlyWeek     2.933e-05
## hour20:Weather:DayTypeEarlyWeek     1.981e-04
## hour21:Weather:DayTypeEarlyWeek     4.724e-03
## hour22:Weather:DayTypeEarlyWeek     3.945e-03
## hour23:Weather:DayTypeEarlyWeek     1.505e-03
## hour24:Weather:DayTypeEarlyWeek     4.098e-03
## hour1:Weather:DayTypeMidWeek        9.904e-01
## hour2:Weather:DayTypeMidWeek        3.344e-01
## hour3:Weather:DayTypeMidWeek        9.680e-01
## hour4:Weather:DayTypeMidWeek        8.341e-01
## hour5:Weather:DayTypeMidWeek        6.459e-01
## hour6:Weather:DayTypeMidWeek        3.024e-01
## hour7:Weather:DayTypeMidWeek        2.136e-02
## hour8:Weather:DayTypeMidWeek        6.620e-02
## hour9:Weather:DayTypeMidWeek        4.094e-02
## hour10:Weather:DayTypeMidWeek       7.422e-01
## hour11:Weather:DayTypeMidWeek       6.624e-01
## hour12:Weather:DayTypeMidWeek       7.893e-01
## hour13:Weather:DayTypeMidWeek       8.517e-01
## hour14:Weather:DayTypeMidWeek       5.643e-01
## hour15:Weather:DayTypeMidWeek       3.882e-01
## hour16:Weather:DayTypeMidWeek       2.915e-01
## hour17:Weather:DayTypeMidWeek       2.905e-01
## hour18:Weather:DayTypeMidWeek       4.114e-01
## hour19:Weather:DayTypeMidWeek       6.950e-01
## hour20:Weather:DayTypeMidWeek       5.946e-01
## hour21:Weather:DayTypeMidWeek       3.290e-02
## hour22:Weather:DayTypeMidWeek       5.918e-02
## hour23:Weather:DayTypeMidWeek       3.689e-01
## hour24:Weather:DayTypeMidWeek       5.909e-01
## hour1:Weather:DayTypeWeekend        1.730e-04
## hour2:Weather:DayTypeWeekend        6.624e-01
## hour3:Weather:DayTypeWeekend        2.725e-01
## hour4:Weather:DayTypeWeekend        1.986e-01
## hour5:Weather:DayTypeWeekend        1.075e-01
## hour6:Weather:DayTypeWeekend        2.561e-02
## hour7:Weather:DayTypeWeekend        1.409e-03
## hour8:Weather:DayTypeWeekend        6.309e-04
## hour9:Weather:DayTypeWeekend        5.753e-06
## hour10:Weather:DayTypeWeekend       1.359e-04
## hour11:Weather:DayTypeWeekend       7.978e-04
## hour12:Weather:DayTypeWeekend       3.659e-03
## hour13:Weather:DayTypeWeekend       1.078e-02
## hour14:Weather:DayTypeWeekend       2.039e-02
## hour15:Weather:DayTypeWeekend       6.530e-02
## hour16:Weather:DayTypeWeekend       1.855e-01
## hour17:Weather:DayTypeWeekend       3.944e-01
## hour18:Weather:DayTypeWeekend       7.172e-01
## hour19:Weather:DayTypeWeekend       9.912e-01
## hour20:Weather:DayTypeWeekend       9.635e-01
## hour21:Weather:DayTypeWeekend       4.584e-01
## hour22:Weather:DayTypeWeekend       5.272e-01
## hour23:Weather:DayTypeWeekend       7.337e-01
## hour24:Weather:DayTypeWeekend       8.181e-01
## hour1:LagWeather:DayTypeEarlyWeek   3.481e-01
## hour2:LagWeather:DayTypeEarlyWeek   8.309e-01
## hour3:LagWeather:DayTypeEarlyWeek   7.379e-01
## hour4:LagWeather:DayTypeEarlyWeek   7.935e-01
## hour5:LagWeather:DayTypeEarlyWeek   8.532e-01
## hour6:LagWeather:DayTypeEarlyWeek   9.454e-01
## hour7:LagWeather:DayTypeEarlyWeek   8.017e-01
## hour8:LagWeather:DayTypeEarlyWeek   5.064e-01
## hour9:LagWeather:DayTypeEarlyWeek   5.433e-01
## hour10:LagWeather:DayTypeEarlyWeek  1.802e-01
## hour11:LagWeather:DayTypeEarlyWeek  2.618e-01
## hour12:LagWeather:DayTypeEarlyWeek  3.992e-01
## hour13:LagWeather:DayTypeEarlyWeek  4.624e-01
## hour14:LagWeather:DayTypeEarlyWeek  5.129e-01
## hour15:LagWeather:DayTypeEarlyWeek  7.716e-01
## hour16:LagWeather:DayTypeEarlyWeek  9.810e-01
## hour17:LagWeather:DayTypeEarlyWeek  8.240e-01
## hour18:LagWeather:DayTypeEarlyWeek  6.337e-01
## hour19:LagWeather:DayTypeEarlyWeek  4.738e-01
## hour20:LagWeather:DayTypeEarlyWeek  3.629e-01
## hour21:LagWeather:DayTypeEarlyWeek  3.424e-01
## hour22:LagWeather:DayTypeEarlyWeek  2.773e-01
## hour23:LagWeather:DayTypeEarlyWeek  3.793e-01
## hour24:LagWeather:DayTypeEarlyWeek  4.709e-01
## hour1:LagWeather:DayTypeMidWeek     7.931e-01
## hour2:LagWeather:DayTypeMidWeek     4.411e-01
## hour3:LagWeather:DayTypeMidWeek     5.780e-01
## hour4:LagWeather:DayTypeMidWeek     7.403e-01
## hour5:LagWeather:DayTypeMidWeek     7.931e-01
## hour6:LagWeather:DayTypeMidWeek     8.740e-01
## hour7:LagWeather:DayTypeMidWeek     7.586e-01
## hour8:LagWeather:DayTypeMidWeek     4.154e-01
## hour9:LagWeather:DayTypeMidWeek     8.638e-02
## hour10:LagWeather:DayTypeMidWeek    7.340e-01
## hour11:LagWeather:DayTypeMidWeek    6.099e-01
## hour12:LagWeather:DayTypeMidWeek    4.508e-01
## hour13:LagWeather:DayTypeMidWeek    4.903e-01
## hour14:LagWeather:DayTypeMidWeek    6.370e-01
## hour15:LagWeather:DayTypeMidWeek    7.927e-01
## hour16:LagWeather:DayTypeMidWeek    7.541e-01
## hour17:LagWeather:DayTypeMidWeek    5.731e-01
## hour18:LagWeather:DayTypeMidWeek    3.959e-01
## hour19:LagWeather:DayTypeMidWeek    2.450e-01
## hour20:LagWeather:DayTypeMidWeek    1.979e-01
## hour21:LagWeather:DayTypeMidWeek    8.005e-01
## hour22:LagWeather:DayTypeMidWeek    2.804e-01
## hour23:LagWeather:DayTypeMidWeek    1.821e-01
## hour24:LagWeather:DayTypeMidWeek    3.220e-01
## hour1:LagWeather:DayTypeWeekend     5.218e-03
## hour2:LagWeather:DayTypeWeekend     2.099e-01
## hour3:LagWeather:DayTypeWeekend     3.382e-01
## hour4:LagWeather:DayTypeWeekend     4.861e-01
## hour5:LagWeather:DayTypeWeekend     5.291e-01
## hour6:LagWeather:DayTypeWeekend     7.538e-01
## hour7:LagWeather:DayTypeWeekend     4.566e-01
## hour8:LagWeather:DayTypeWeekend     6.223e-01
## hour9:LagWeather:DayTypeWeekend     2.991e-02
## hour10:LagWeather:DayTypeWeekend    2.718e-02
## hour11:LagWeather:DayTypeWeekend    9.803e-03
## hour12:LagWeather:DayTypeWeekend    3.464e-03
## hour13:LagWeather:DayTypeWeekend    1.476e-03
## hour14:LagWeather:DayTypeWeekend    6.399e-04
## hour15:LagWeather:DayTypeWeekend    5.983e-04
## hour16:LagWeather:DayTypeWeekend    6.405e-04
## hour17:LagWeather:DayTypeWeekend    7.959e-04
## hour18:LagWeather:DayTypeWeekend    6.776e-04
## hour19:LagWeather:DayTypeWeekend    1.273e-03
## hour20:LagWeather:DayTypeWeekend    1.695e-02
## hour21:LagWeather:DayTypeWeekend    2.398e-01
## hour22:LagWeather:DayTypeWeekend    8.875e-02
## hour23:LagWeather:DayTypeWeekend    7.636e-02
## hour24:LagWeather:DayTypeWeekend    1.068e-01
```

We think that lag of actual is in the forecast.

No lag of actual but with lag forecast


```r
LagFormData<-sqldf("select * from LagFormData order by DateOnly,hour;")
ARbyHourDayLagF<-gls(HE~-1+(hour+(F+Weather+LagWeather+LagF):hour):DayType, data=LagFormData,corAR1(form=~1),na.action=na.omit)
summary(ARbyHourDayLagF)$tTable
```

```
##                                         Value Std.Error   t-value
## hour1:DayTypeEarlyWeek              1.202e+04 3.021e+03  3.978720
## hour2:DayTypeEarlyWeek              4.133e+03 3.910e+03  1.057103
## hour3:DayTypeEarlyWeek              4.951e+02 4.363e+03  0.113484
## hour4:DayTypeEarlyWeek              1.131e+03 4.748e+03  0.238128
## hour5:DayTypeEarlyWeek              2.040e+03 4.992e+03  0.408544
## hour6:DayTypeEarlyWeek              2.665e+03 5.170e+03  0.515555
## hour7:DayTypeEarlyWeek              1.847e+03 5.314e+03  0.347616
## hour8:DayTypeEarlyWeek              7.364e+03 4.730e+03  1.556626
## hour9:DayTypeEarlyWeek              8.717e+03 3.757e+03  2.320307
## hour10:DayTypeEarlyWeek             2.019e+04 4.089e+03  4.937468
## hour11:DayTypeEarlyWeek             2.009e+04 4.172e+03  4.816661
## hour12:DayTypeEarlyWeek             1.935e+04 4.156e+03  4.654976
## hour13:DayTypeEarlyWeek             1.932e+04 4.119e+03  4.691918
## hour14:DayTypeEarlyWeek             1.931e+04 4.068e+03  4.745078
## hour15:DayTypeEarlyWeek             1.923e+04 4.005e+03  4.800419
## hour16:DayTypeEarlyWeek             2.026e+04 3.930e+03  5.156158
## hour17:DayTypeEarlyWeek             2.095e+04 3.841e+03  5.453699
## hour18:DayTypeEarlyWeek             1.974e+04 3.729e+03  5.295509
## hour19:DayTypeEarlyWeek             1.695e+04 3.570e+03  4.748880
## hour20:DayTypeEarlyWeek             1.228e+04 3.701e+03  3.319466
## hour21:DayTypeEarlyWeek             1.070e+04 4.263e+03  2.509299
## hour22:DayTypeEarlyWeek             1.656e+04 4.419e+03  3.746598
## hour23:DayTypeEarlyWeek             1.577e+04 4.342e+03  3.631446
## hour24:DayTypeEarlyWeek             1.203e+04 4.221e+03  2.851242
## hour1:DayTypeMidWeek                2.183e+03 3.292e+03  0.663180
## hour2:DayTypeMidWeek               -1.563e+03 4.625e+03 -0.337990
## hour3:DayTypeMidWeek                4.425e+02 4.943e+03  0.089522
## hour4:DayTypeMidWeek                6.104e+02 5.189e+03  0.117629
## hour5:DayTypeMidWeek                9.995e+02 5.341e+03  0.187130
## hour6:DayTypeMidWeek                3.360e+03 5.535e+03  0.607008
## hour7:DayTypeMidWeek                7.753e+03 5.661e+03  1.369638
## hour8:DayTypeMidWeek                2.720e+03 5.179e+03  0.525111
## hour9:DayTypeMidWeek                2.163e+03 4.222e+03  0.512317
## hour10:DayTypeMidWeek               1.987e+03 4.643e+03  0.428044
## hour11:DayTypeMidWeek               7.216e+02 4.763e+03  0.151488
## hour12:DayTypeMidWeek              -3.720e+02 4.761e+03 -0.078126
## hour13:DayTypeMidWeek               5.675e+02 4.743e+03  0.119663
## hour14:DayTypeMidWeek               2.780e+03 4.719e+03  0.589027
## hour15:DayTypeMidWeek               4.560e+03 4.678e+03  0.974773
## hour16:DayTypeMidWeek               5.492e+03 4.614e+03  1.190331
## hour17:DayTypeMidWeek               6.307e+03 4.558e+03  1.383901
## hour18:DayTypeMidWeek               6.632e+03 4.477e+03  1.481262
## hour19:DayTypeMidWeek               5.793e+03 4.359e+03  1.328934
## hour20:DayTypeMidWeek               5.286e+03 4.484e+03  1.178770
## hour21:DayTypeMidWeek               1.469e+04 5.013e+03  2.930624
## hour22:DayTypeMidWeek               1.550e+04 5.197e+03  2.983281
## hour23:DayTypeMidWeek               1.112e+04 5.221e+03  2.128934
## hour24:DayTypeMidWeek               9.236e+03 5.200e+03  1.776324
## hour1:DayTypeWeekend               -3.019e+03 3.472e+03 -0.869321
## hour2:DayTypeWeekend               -2.334e+04 4.590e+03 -5.085036
## hour3:DayTypeWeekend               -1.153e+04 5.311e+03 -2.171571
## hour4:DayTypeWeekend               -9.699e+03 6.016e+03 -1.612217
## hour5:DayTypeWeekend               -5.987e+03 6.420e+03 -0.932585
## hour6:DayTypeWeekend               -3.845e+03 6.559e+03 -0.586268
## hour7:DayTypeWeekend               -4.193e+03 6.250e+03 -0.670761
## hour8:DayTypeWeekend                2.417e+03 5.568e+03  0.434021
## hour9:DayTypeWeekend                8.606e+03 4.596e+03  1.872605
## hour10:DayTypeWeekend              -2.264e+03 4.549e+03 -0.497724
## hour11:DayTypeWeekend              -4.005e+03 4.588e+03 -0.873008
## hour12:DayTypeWeekend              -5.225e+03 4.534e+03 -1.152301
## hour13:DayTypeWeekend              -6.689e+03 4.462e+03 -1.498887
## hour14:DayTypeWeekend              -6.715e+03 4.340e+03 -1.547158
## hour15:DayTypeWeekend              -6.997e+03 4.196e+03 -1.667678
## hour16:DayTypeWeekend              -7.548e+03 4.042e+03 -1.867247
## hour17:DayTypeWeekend              -8.011e+03 3.886e+03 -2.061631
## hour18:DayTypeWeekend              -9.334e+03 3.719e+03 -2.509373
## hour19:DayTypeWeekend              -1.129e+04 3.503e+03 -3.221449
## hour20:DayTypeWeekend              -1.481e+04 3.637e+03 -4.070336
## hour21:DayTypeWeekend              -1.582e+04 4.356e+03 -3.632840
## hour22:DayTypeWeekend              -1.083e+04 4.543e+03 -2.384681
## hour23:DayTypeWeekend              -9.148e+03 4.492e+03 -2.036302
## hour24:DayTypeWeekend              -1.052e+04 4.380e+03 -2.400874
## hour1:F:DayTypeEarlyWeek            9.059e-01 3.199e-02 28.318675
## hour2:F:DayTypeEarlyWeek            1.162e+00 3.986e-02 29.146155
## hour3:F:DayTypeEarlyWeek            1.143e+00 5.121e-02 22.313432
## hour4:F:DayTypeEarlyWeek            1.105e+00 6.234e-02 17.728299
## hour5:F:DayTypeEarlyWeek            1.050e+00 6.716e-02 15.636112
## hour6:F:DayTypeEarlyWeek            1.002e+00 6.398e-02 15.661815
## hour7:F:DayTypeEarlyWeek            9.990e-01 5.146e-02 19.411959
## hour8:F:DayTypeEarlyWeek            9.831e-01 4.210e-02 23.350723
## hour9:F:DayTypeEarlyWeek            9.685e-01 3.342e-02 28.980027
## hour10:F:DayTypeEarlyWeek           9.351e-01 3.284e-02 28.470673
## hour11:F:DayTypeEarlyWeek           9.374e-01 3.318e-02 28.250790
## hour12:F:DayTypeEarlyWeek           9.495e-01 3.143e-02 30.214837
## hour13:F:DayTypeEarlyWeek           9.542e-01 2.933e-02 32.529337
## hour14:F:DayTypeEarlyWeek           9.535e-01 2.729e-02 34.942719
## hour15:F:DayTypeEarlyWeek           9.574e-01 2.547e-02 37.586319
## hour16:F:DayTypeEarlyWeek           9.632e-01 2.383e-02 40.410135
## hour17:F:DayTypeEarlyWeek           9.799e-01 2.222e-02 44.103400
## hour18:F:DayTypeEarlyWeek           1.010e+00 2.055e-02 49.134970
## hour19:F:DayTypeEarlyWeek           1.037e+00 1.800e-02 57.617864
## hour20:F:DayTypeEarlyWeek           1.069e+00 1.898e-02 56.291676
## hour21:F:DayTypeEarlyWeek           1.076e+00 2.443e-02 44.054481
## hour22:F:DayTypeEarlyWeek           1.054e+00 2.761e-02 38.190692
## hour23:F:DayTypeEarlyWeek           1.052e+00 2.928e-02 35.930384
## hour24:F:DayTypeEarlyWeek           1.060e+00 2.908e-02 36.464883
## hour1:F:DayTypeMidWeek              9.600e-01 2.741e-02 35.027246
## hour2:F:DayTypeMidWeek              1.204e+00 3.357e-02 35.869942
## hour3:F:DayTypeMidWeek              1.126e+00 4.155e-02 27.110607
## hour4:F:DayTypeMidWeek              1.105e+00 4.765e-02 23.192043
## hour5:F:DayTypeMidWeek              1.079e+00 5.106e-02 21.139998
## hour6:F:DayTypeMidWeek              1.044e+00 5.155e-02 20.259592
## hour7:F:DayTypeMidWeek              1.005e+00 4.865e-02 20.664541
## hour8:F:DayTypeMidWeek              1.035e+00 4.194e-02 24.678838
## hour9:F:DayTypeMidWeek              1.026e+00 3.257e-02 31.490143
## hour10:F:DayTypeMidWeek             9.951e-01 3.261e-02 30.511054
## hour11:F:DayTypeMidWeek             9.862e-01 3.240e-02 30.442351
## hour12:F:DayTypeMidWeek             9.696e-01 3.111e-02 31.166337
## hour13:F:DayTypeMidWeek             9.500e-01 2.982e-02 31.858390
## hour14:F:DayTypeMidWeek             9.318e-01 2.862e-02 32.553892
## hour15:F:DayTypeMidWeek             9.224e-01 2.771e-02 33.290022
## hour16:F:DayTypeMidWeek             9.254e-01 2.691e-02 34.395691
## hour17:F:DayTypeMidWeek             9.293e-01 2.612e-02 35.579579
## hour18:F:DayTypeMidWeek             9.452e-01 2.518e-02 37.529121
## hour19:F:DayTypeMidWeek             9.715e-01 2.340e-02 41.520643
## hour20:F:DayTypeMidWeek             1.004e+00 2.485e-02 40.381410
## hour21:F:DayTypeMidWeek             9.962e-01 3.019e-02 33.003489
## hour22:F:DayTypeMidWeek             9.973e-01 3.398e-02 29.353638
## hour23:F:DayTypeMidWeek             1.012e+00 3.683e-02 27.476448
## hour24:F:DayTypeMidWeek             1.020e+00 3.839e-02 26.573630
## hour1:F:DayTypeWeekend              1.031e+00 4.058e-02 25.413364
## hour2:F:DayTypeWeekend              1.240e+00 4.269e-02 29.035774
## hour3:F:DayTypeWeekend              1.183e+00 5.645e-02 20.963248
## hour4:F:DayTypeWeekend              1.173e+00 7.018e-02 16.707823
## hour5:F:DayTypeWeekend              1.149e+00 7.908e-02 14.533979
## hour6:F:DayTypeWeekend              1.140e+00 8.269e-02 13.785928
## hour7:F:DayTypeWeekend              1.165e+00 7.921e-02 14.706287
## hour8:F:DayTypeWeekend              1.125e+00 7.067e-02 15.925262
## hour9:F:DayTypeWeekend              1.086e+00 5.350e-02 20.290956
## hour10:F:DayTypeWeekend             1.109e+00 5.524e-02 20.081659
## hour11:F:DayTypeWeekend             1.090e+00 5.216e-02 20.893205
## hour12:F:DayTypeWeekend             1.071e+00 4.774e-02 22.427561
## hour13:F:DayTypeWeekend             1.065e+00 4.378e-02 24.337275
## hour14:F:DayTypeWeekend             1.058e+00 4.043e-02 26.167745
## hour15:F:DayTypeWeekend             1.054e+00 3.750e-02 28.104278
## hour16:F:DayTypeWeekend             1.045e+00 3.482e-02 29.995526
## hour17:F:DayTypeWeekend             1.036e+00 3.221e-02 32.164242
## hour18:F:DayTypeWeekend             1.032e+00 2.950e-02 34.997262
## hour19:F:DayTypeWeekend             1.045e+00 2.553e-02 40.933411
## hour20:F:DayTypeWeekend             1.074e+00 2.692e-02 39.912560
## hour21:F:DayTypeWeekend             1.090e+00 3.507e-02 31.085811
## hour22:F:DayTypeWeekend             1.063e+00 3.997e-02 26.584916
## hour23:F:DayTypeWeekend             1.067e+00 4.233e-02 25.208137
## hour24:F:DayTypeWeekend             1.081e+00 4.199e-02 25.744515
## hour1:Weather:DayTypeEarlyWeek     -6.523e+01 1.873e+01 -3.482273
## hour2:Weather:DayTypeEarlyWeek     -2.547e+01 3.665e+01 -0.694836
## hour3:Weather:DayTypeEarlyWeek     -1.338e+01 3.499e+01 -0.382399
## hour4:Weather:DayTypeEarlyWeek     -1.237e+01 3.428e+01 -0.360832
## hour5:Weather:DayTypeEarlyWeek     -9.841e+00 3.319e+01 -0.296464
## hour6:Weather:DayTypeEarlyWeek     -3.271e+00 3.156e+01 -0.103636
## hour7:Weather:DayTypeEarlyWeek     -1.168e-01 2.918e+01 -0.004003
## hour8:Weather:DayTypeEarlyWeek     -1.464e+01 2.580e+01 -0.567393
## hour9:Weather:DayTypeEarlyWeek     -2.761e+01 2.051e+01 -1.345967
## hour10:Weather:DayTypeEarlyWeek    -7.717e+01 2.478e+01 -3.114784
## hour11:Weather:DayTypeEarlyWeek    -9.142e+01 2.855e+01 -3.201922
## hour12:Weather:DayTypeEarlyWeek    -9.659e+01 3.112e+01 -3.104078
## hour13:Weather:DayTypeEarlyWeek    -1.051e+02 3.292e+01 -3.192106
## hour14:Weather:DayTypeEarlyWeek    -1.108e+02 3.423e+01 -3.235890
## hour15:Weather:DayTypeEarlyWeek    -1.257e+02 3.516e+01 -3.574566
## hour16:Weather:DayTypeEarlyWeek    -1.396e+02 3.583e+01 -3.897460
## hour17:Weather:DayTypeEarlyWeek    -1.516e+02 3.628e+01 -4.178669
## hour18:Weather:DayTypeEarlyWeek    -1.500e+02 3.656e+01 -4.104095
## hour19:Weather:DayTypeEarlyWeek    -1.467e+02 3.662e+01 -4.007052
## hour20:Weather:DayTypeEarlyWeek    -1.309e+02 3.674e+01 -3.564032
## hour21:Weather:DayTypeEarlyWeek    -9.696e+01 3.681e+01 -2.634339
## hour22:Weather:DayTypeEarlyWeek    -9.519e+01 3.669e+01 -2.594490
## hour23:Weather:DayTypeEarlyWeek    -1.051e+02 3.630e+01 -2.893674
## hour24:Weather:DayTypeEarlyWeek    -9.492e+01 3.565e+01 -2.662287
## hour1:Weather:DayTypeMidWeek       -1.068e+00 1.808e+01 -0.059100
## hour2:Weather:DayTypeMidWeek        2.473e+01 3.177e+01  0.778442
## hour3:Weather:DayTypeMidWeek       -3.028e+00 3.053e+01 -0.099164
## hour4:Weather:DayTypeMidWeek       -7.184e+00 2.990e+01 -0.240251
## hour5:Weather:DayTypeMidWeek       -1.339e+01 2.901e+01 -0.461690
## hour6:Weather:DayTypeMidWeek       -2.757e+01 2.782e+01 -0.990974
## hour7:Weather:DayTypeMidWeek       -5.672e+01 2.605e+01 -2.176842
## hour8:Weather:DayTypeMidWeek       -3.900e+01 2.350e+01 -1.659197
## hour9:Weather:DayTypeMidWeek       -3.625e+01 1.968e+01 -1.842080
## hour10:Weather:DayTypeMidWeek       6.633e+00 2.322e+01  0.285696
## hour11:Weather:DayTypeMidWeek       7.650e+00 2.666e+01  0.287006
## hour12:Weather:DayTypeMidWeek      -3.667e-01 2.913e+01 -0.012591
## hour13:Weather:DayTypeMidWeek      -1.797e+01 3.097e+01 -0.580034
## hour14:Weather:DayTypeMidWeek      -3.422e+01 3.236e+01 -1.057443
## hour15:Weather:DayTypeMidWeek      -4.726e+01 3.334e+01 -1.417567
## hour16:Weather:DayTypeMidWeek      -5.598e+01 3.392e+01 -1.650530
## hour17:Weather:DayTypeMidWeek      -5.753e+01 3.419e+01 -1.682422
## hour18:Weather:DayTypeMidWeek      -4.906e+01 3.411e+01 -1.438239
## hour19:Weather:DayTypeMidWeek      -3.388e+01 3.359e+01 -1.008467
## hour20:Weather:DayTypeMidWeek      -3.527e+01 3.349e+01 -1.052920
## hour21:Weather:DayTypeMidWeek      -8.313e+01 3.394e+01 -2.449701
## hour22:Weather:DayTypeMidWeek      -7.131e+01 3.384e+01 -2.107331
## hour23:Weather:DayTypeMidWeek      -3.732e+01 3.338e+01 -1.118048
## hour24:Weather:DayTypeMidWeek      -2.528e+01 3.263e+01 -0.774631
## hour1:Weather:DayTypeWeekend       -6.619e+01 1.813e+01 -3.650688
## hour2:Weather:DayTypeWeekend       -1.070e+01 2.941e+01 -0.363986
## hour3:Weather:DayTypeWeekend       -2.978e+01 2.830e+01 -1.052526
## hour4:Weather:DayTypeWeekend       -3.479e+01 2.786e+01 -1.248732
## hour5:Weather:DayTypeWeekend       -4.207e+01 2.694e+01 -1.561470
## hour6:Weather:DayTypeWeekend       -5.529e+01 2.546e+01 -2.171684
## hour7:Weather:DayTypeWeekend       -7.206e+01 2.333e+01 -3.088196
## hour8:Weather:DayTypeWeekend       -6.403e+01 2.059e+01 -3.109756
## hour9:Weather:DayTypeWeekend       -6.882e+01 1.663e+01 -4.138008
## hour10:Weather:DayTypeWeekend      -7.677e+01 2.195e+01 -3.497423
## hour11:Weather:DayTypeWeekend      -7.837e+01 2.500e+01 -3.134711
## hour12:Weather:DayTypeWeekend      -7.497e+01 2.724e+01 -2.752031
## hour13:Weather:DayTypeWeekend      -6.992e+01 2.880e+01 -2.427448
## hour14:Weather:DayTypeWeekend      -6.545e+01 2.984e+01 -2.193397
## hour15:Weather:DayTypeWeekend      -5.193e+01 3.040e+01 -1.707990
## hour16:Weather:DayTypeWeekend      -3.660e+01 3.062e+01 -1.195277
## hour17:Weather:DayTypeWeekend      -2.226e+01 3.059e+01 -0.727857
## hour18:Weather:DayTypeWeekend      -7.331e+00 3.037e+01 -0.241436
## hour19:Weather:DayTypeWeekend       4.292e+00 2.994e+01  0.143355
## hour20:Weather:DayTypeWeekend       4.704e+00 2.989e+01  0.157396
## hour21:Weather:DayTypeWeekend      -2.004e+01 3.028e+01 -0.661915
## hour22:Weather:DayTypeWeekend      -1.659e+01 3.021e+01 -0.549029
## hour23:Weather:DayTypeWeekend      -8.115e+00 2.984e+01 -0.271977
## hour24:Weather:DayTypeWeekend      -5.710e+00 2.920e+01 -0.195578
## hour1:LagWeather:DayTypeEarlyWeek  -3.029e+01 1.998e+01 -1.515978
## hour2:LagWeather:DayTypeEarlyWeek  -3.276e+01 3.756e+01 -0.872153
## hour3:LagWeather:DayTypeEarlyWeek  -1.450e+01 3.582e+01 -0.404659
## hour4:LagWeather:DayTypeEarlyWeek  -1.104e+01 3.497e+01 -0.315800
## hour5:LagWeather:DayTypeEarlyWeek  -7.619e+00 3.367e+01 -0.226288
## hour6:LagWeather:DayTypeEarlyWeek  -6.390e+00 3.180e+01 -0.200929
## hour7:LagWeather:DayTypeEarlyWeek  -1.289e+01 2.922e+01 -0.441138
## hour8:LagWeather:DayTypeEarlyWeek  -2.580e+01 2.572e+01 -1.003284
## hour9:LagWeather:DayTypeEarlyWeek  -2.111e+01 2.025e+01 -1.042226
## hour10:LagWeather:DayTypeEarlyWeek -5.740e+01 2.589e+01 -2.217100
## hour11:LagWeather:DayTypeEarlyWeek -5.725e+01 2.974e+01 -1.925217
## hour12:LagWeather:DayTypeEarlyWeek -5.395e+01 3.242e+01 -1.663951
## hour13:LagWeather:DayTypeEarlyWeek -5.407e+01 3.435e+01 -1.574239
## hour14:LagWeather:DayTypeEarlyWeek -5.341e+01 3.574e+01 -1.494315
## hour15:LagWeather:DayTypeEarlyWeek -4.302e+01 3.672e+01 -1.171570
## hour16:LagWeather:DayTypeEarlyWeek -3.871e+01 3.740e+01 -1.035085
## hour17:LagWeather:DayTypeEarlyWeek -3.769e+01 3.783e+01 -0.996376
## hour18:LagWeather:DayTypeEarlyWeek -3.681e+01 3.803e+01 -0.968031
## hour19:LagWeather:DayTypeEarlyWeek -3.093e+01 3.799e+01 -0.814192
## hour20:LagWeather:DayTypeEarlyWeek -2.211e+01 3.808e+01 -0.580717
## hour21:LagWeather:DayTypeEarlyWeek -1.964e+01 3.829e+01 -0.513025
## hour22:LagWeather:DayTypeEarlyWeek -2.128e+01 3.815e+01 -0.557946
## hour23:LagWeather:DayTypeEarlyWeek -2.216e+01 3.768e+01 -0.588091
## hour24:LagWeather:DayTypeEarlyWeek -1.935e+01 3.699e+01 -0.523231
## hour1:LagWeather:DayTypeMidWeek     1.714e+00 1.808e+01  0.094770
## hour2:LagWeather:DayTypeMidWeek    -3.445e+01 3.162e+01 -1.089702
## hour3:LagWeather:DayTypeMidWeek    -1.853e+01 3.042e+01 -0.609110
## hour4:LagWeather:DayTypeMidWeek    -1.699e+01 2.975e+01 -0.570987
## hour5:LagWeather:DayTypeMidWeek    -1.283e+01 2.878e+01 -0.445797
## hour6:LagWeather:DayTypeMidWeek    -1.250e+01 2.741e+01 -0.456128
## hour7:LagWeather:DayTypeMidWeek    -2.154e+01 2.523e+01 -0.853818
## hour8:LagWeather:DayTypeMidWeek     3.130e+00 2.277e+01  0.137429
## hour9:LagWeather:DayTypeMidWeek     1.487e+01 1.904e+01  0.780983
## hour10:LagWeather:DayTypeMidWeek   -5.539e+00 2.325e+01 -0.238241
## hour11:LagWeather:DayTypeMidWeek    4.802e+00 2.688e+01  0.178652
## hour12:LagWeather:DayTypeMidWeek    2.282e+01 2.947e+01  0.774217
## hour13:LagWeather:DayTypeMidWeek    3.102e+01 3.139e+01  0.988147
## hour14:LagWeather:DayTypeMidWeek    2.991e+01 3.283e+01  0.911117
## hour15:LagWeather:DayTypeMidWeek    2.536e+01 3.381e+01  0.750176
## hour16:LagWeather:DayTypeMidWeek    2.241e+01 3.439e+01  0.651705
## hour17:LagWeather:DayTypeMidWeek    2.188e+01 3.462e+01  0.631844
## hour18:LagWeather:DayTypeMidWeek    1.526e+01 3.445e+01  0.443088
## hour19:LagWeather:DayTypeMidWeek    7.970e+00 3.382e+01  0.235687
## hour20:LagWeather:DayTypeMidWeek   -1.354e+00 3.361e+01 -0.040299
## hour21:LagWeather:DayTypeMidWeek   -4.947e+01 3.390e+01 -1.459444
## hour22:LagWeather:DayTypeMidWeek   -3.109e+01 3.397e+01 -0.915291
## hour23:LagWeather:DayTypeMidWeek   -1.717e+01 3.355e+01 -0.511729
## hour24:LagWeather:DayTypeMidWeek   -2.096e+01 3.266e+01 -0.641884
## hour1:LagWeather:DayTypeWeekend     4.836e+01 1.785e+01  2.709895
## hour2:LagWeather:DayTypeWeekend     4.636e+01 2.976e+01  1.557892
## hour3:LagWeather:DayTypeWeekend     2.227e+01 2.863e+01  0.777945
## hour4:LagWeather:DayTypeWeekend     1.451e+01 2.821e+01  0.514254
## hour5:LagWeather:DayTypeWeekend     9.523e+00 2.728e+01  0.349131
## hour6:LagWeather:DayTypeWeekend     7.054e-01 2.573e+01  0.027419
## hour7:LagWeather:DayTypeWeekend    -2.192e+01 2.345e+01 -0.934612
## hour8:LagWeather:DayTypeWeekend    -4.229e+00 2.077e+01 -0.203639
## hour9:LagWeather:DayTypeWeekend     8.475e+00 1.668e+01  0.508146
## hour10:LagWeather:DayTypeWeekend    3.219e+01 2.225e+01  1.446912
## hour11:LagWeather:DayTypeWeekend    4.977e+01 2.559e+01  1.944501
## hour12:LagWeather:DayTypeWeekend    6.704e+01 2.794e+01  2.398954
## hour13:LagWeather:DayTypeWeekend    8.054e+01 2.952e+01  2.728831
## hour14:LagWeather:DayTypeWeekend    8.990e+01 3.053e+01  2.944511
## hour15:LagWeather:DayTypeWeekend    9.232e+01 3.106e+01  2.972021
## hour16:LagWeather:DayTypeWeekend    9.572e+01 3.124e+01  3.063821
## hour17:LagWeather:DayTypeWeekend    9.775e+01 3.114e+01  3.139533
## hour18:LagWeather:DayTypeWeekend    1.032e+02 3.083e+01  3.348082
## hour19:LagWeather:DayTypeWeekend    9.990e+01 3.031e+01  3.295751
## hour20:LagWeather:DayTypeWeekend    8.019e+01 3.024e+01  2.651941
## hour21:LagWeather:DayTypeWeekend    4.988e+01 3.062e+01  1.629318
## hour22:LagWeather:DayTypeWeekend    5.639e+01 3.061e+01  1.842236
## hour23:LagWeather:DayTypeWeekend    5.201e+01 3.027e+01  1.718039
## hour24:LagWeather:DayTypeWeekend    4.834e+01 2.954e+01  1.636125
## hour1:LagF:DayTypeEarlyWeek        -1.382e-02 3.337e-02 -0.414121
## hour2:LagF:DayTypeEarlyWeek        -1.963e-01 3.824e-02 -5.133100
## hour3:LagF:DayTypeEarlyWeek        -1.469e-01 4.979e-02 -2.950227
## hour4:LagF:DayTypeEarlyWeek        -1.198e-01 6.195e-02 -1.934505
## hour5:LagF:DayTypeEarlyWeek        -7.942e-02 6.782e-02 -1.171086
## hour6:LagF:DayTypeEarlyWeek        -4.073e-02 6.606e-02 -0.616628
## hour7:LagF:DayTypeEarlyWeek        -2.353e-02 5.616e-02 -0.418956
## hour8:LagF:DayTypeEarlyWeek        -5.513e-02 4.578e-02 -1.204282
## hour9:LagF:DayTypeEarlyWeek        -4.667e-02 3.441e-02 -1.356263
## hour10:LagF:DayTypeEarlyWeek       -8.521e-02 3.426e-02 -2.487065
## hour11:LagF:DayTypeEarlyWeek       -7.267e-02 3.301e-02 -2.201494
## hour12:LagF:DayTypeEarlyWeek       -7.086e-02 3.050e-02 -2.322895
## hour13:LagF:DayTypeEarlyWeek       -6.813e-02 2.810e-02 -2.424609
## hour14:LagF:DayTypeEarlyWeek       -6.304e-02 2.588e-02 -2.435424
## hour15:LagF:DayTypeEarlyWeek       -6.291e-02 2.401e-02 -2.620585
## hour16:LagF:DayTypeEarlyWeek       -7.268e-02 2.235e-02 -3.251906
## hour17:LagF:DayTypeEarlyWeek       -9.017e-02 2.084e-02 -4.326452
## hour18:LagF:DayTypeEarlyWeek       -1.105e-01 1.936e-02 -5.705282
## hour19:LagF:DayTypeEarlyWeek       -1.192e-01 1.710e-02 -6.973255
## hour20:LagF:DayTypeEarlyWeek       -1.235e-01 1.818e-02 -6.793469
## hour21:LagF:DayTypeEarlyWeek       -1.331e-01 2.373e-02 -5.607670
## hour22:LagF:DayTypeEarlyWeek       -1.670e-01 2.643e-02 -6.318347
## hour23:LagF:DayTypeEarlyWeek       -1.624e-01 2.803e-02 -5.795870
## hour24:LagF:DayTypeEarlyWeek       -1.477e-01 2.830e-02 -5.220208
## hour1:LagF:DayTypeMidWeek           5.823e-03 2.698e-02  0.215807
## hour2:LagF:DayTypeMidWeek          -1.865e-01 3.382e-02 -5.514718
## hour3:LagF:DayTypeMidWeek          -1.275e-01 4.149e-02 -3.072714
## hour4:LagF:DayTypeMidWeek          -1.069e-01 4.733e-02 -2.257587
## hour5:LagF:DayTypeMidWeek          -8.539e-02 5.055e-02 -1.689331
## hour6:LagF:DayTypeMidWeek          -7.336e-02 5.096e-02 -1.439520
## hour7:LagF:DayTypeMidWeek          -6.820e-02 4.805e-02 -1.419481
## hour8:LagF:DayTypeMidWeek          -5.803e-02 4.150e-02 -1.398414
## hour9:LagF:DayTypeMidWeek          -4.661e-02 3.182e-02 -1.464882
## hour10:LagF:DayTypeMidWeek         -2.465e-02 3.267e-02 -0.754322
## hour11:LagF:DayTypeMidWeek         -6.769e-03 3.221e-02 -0.210128
## hour12:LagF:DayTypeMidWeek          1.667e-02 3.077e-02  0.541747
## hour13:LagF:DayTypeMidWeek          3.126e-02 2.937e-02  1.064445
## hour14:LagF:DayTypeMidWeek          3.609e-02 2.811e-02  1.283751
## hour15:LagF:DayTypeMidWeek          3.661e-02 2.713e-02  1.349649
## hour16:LagF:DayTypeMidWeek          2.990e-02 2.628e-02  1.137885
## hour17:LagF:DayTypeMidWeek          1.943e-02 2.551e-02  0.761567
## hour18:LagF:DayTypeMidWeek         -1.233e-03 2.470e-02 -0.049920
## hour19:LagF:DayTypeMidWeek         -2.655e-02 2.321e-02 -1.143949
## hour20:LagF:DayTypeMidWeek         -5.463e-02 2.485e-02 -2.198792
## hour21:LagF:DayTypeMidWeek         -9.946e-02 3.023e-02 -3.290380
## hour22:LagF:DayTypeMidWeek         -1.228e-01 3.378e-02 -3.634900
## hour23:LagF:DayTypeMidWeek         -1.212e-01 3.650e-02 -3.320012
## hour24:LagF:DayTypeMidWeek         -1.209e-01 3.815e-02 -3.170475
## hour1:LagF:DayTypeWeekend           6.954e-03 4.013e-02  0.173307
## hour2:LagF:DayTypeWeekend           5.257e-02 4.243e-02  1.238808
## hour3:LagF:DayTypeWeekend          -2.356e-02 5.632e-02 -0.418415
## hour4:LagF:DayTypeWeekend          -2.707e-02 7.019e-02 -0.385662
## hour5:LagF:DayTypeWeekend          -4.960e-02 7.937e-02 -0.624928
## hour6:LagF:DayTypeWeekend          -5.863e-02 8.348e-02 -0.702294
## hour7:LagF:DayTypeWeekend          -5.309e-02 8.044e-02 -0.659991
## hour8:LagF:DayTypeWeekend          -1.293e-01 7.075e-02 -1.827186
## hour9:LagF:DayTypeWeekend          -1.771e-01 5.314e-02 -3.332716
## hour10:LagF:DayTypeWeekend         -6.830e-02 5.494e-02 -1.243124
## hour11:LagF:DayTypeWeekend         -3.859e-02 5.135e-02 -0.751553
## hour12:LagF:DayTypeWeekend         -1.765e-02 4.673e-02 -0.377758
## hour13:LagF:DayTypeWeekend         -6.968e-03 4.276e-02 -0.162965
## hour14:LagF:DayTypeWeekend         -6.812e-03 3.941e-02 -0.172848
## hour15:LagF:DayTypeWeekend         -8.076e-03 3.653e-02 -0.221069
## hour16:LagF:DayTypeWeekend         -3.057e-03 3.393e-02 -0.090102
## hour17:LagF:DayTypeWeekend          2.548e-03 3.148e-02  0.080929
## hour18:LagF:DayTypeWeekend          1.087e-02 2.904e-02  0.374240
## hour19:LagF:DayTypeWeekend          1.513e-02 2.542e-02  0.595154
## hour20:LagF:DayTypeWeekend          3.042e-02 2.701e-02  1.126212
## hour21:LagF:DayTypeWeekend          5.202e-02 3.580e-02  1.453027
## hour22:LagF:DayTypeWeekend          2.548e-02 4.034e-02  0.631600
## hour23:LagF:DayTypeWeekend          4.786e-03 4.260e-02  0.112339
## hour24:LagF:DayTypeWeekend          1.358e-02 4.249e-02  0.319546
##                                       p-value
## hour1:DayTypeEarlyWeek              7.119e-05
## hour2:DayTypeEarlyWeek              2.906e-01
## hour3:DayTypeEarlyWeek              9.097e-01
## hour4:DayTypeEarlyWeek              8.118e-01
## hour5:DayTypeEarlyWeek              6.829e-01
## hour6:DayTypeEarlyWeek              6.062e-01
## hour7:DayTypeEarlyWeek              7.282e-01
## hour8:DayTypeEarlyWeek              1.197e-01
## hour9:DayTypeEarlyWeek              2.040e-02
## hour10:DayTypeEarlyWeek             8.417e-07
## hour11:DayTypeEarlyWeek             1.544e-06
## hour12:DayTypeEarlyWeek             3.403e-06
## hour13:DayTypeEarlyWeek             2.847e-06
## hour14:DayTypeEarlyWeek             2.197e-06
## hour15:DayTypeEarlyWeek             1.673e-06
## hour16:DayTypeEarlyWeek             2.711e-07
## hour17:DayTypeEarlyWeek             5.400e-08
## hour18:DayTypeEarlyWeek             1.286e-07
## hour19:DayTypeEarlyWeek             2.157e-06
## hour20:DayTypeEarlyWeek             9.144e-04
## hour21:DayTypeEarlyWeek             1.216e-02
## hour22:DayTypeEarlyWeek             1.832e-04
## hour23:DayTypeEarlyWeek             2.873e-04
## hour24:DayTypeEarlyWeek             4.389e-03
## hour1:DayTypeMidWeek                5.073e-01
## hour2:DayTypeMidWeek                7.354e-01
## hour3:DayTypeMidWeek                9.287e-01
## hour4:DayTypeMidWeek                9.064e-01
## hour5:DayTypeMidWeek                8.516e-01
## hour6:DayTypeMidWeek                5.439e-01
## hour7:DayTypeMidWeek                1.709e-01
## hour8:DayTypeMidWeek                5.996e-01
## hour9:DayTypeMidWeek                6.085e-01
## hour10:DayTypeMidWeek               6.687e-01
## hour11:DayTypeMidWeek               8.796e-01
## hour12:DayTypeMidWeek               9.377e-01
## hour13:DayTypeMidWeek               9.048e-01
## hour14:DayTypeMidWeek               5.559e-01
## hour15:DayTypeMidWeek               3.298e-01
## hour16:DayTypeMidWeek               2.340e-01
## hour17:DayTypeMidWeek               1.665e-01
## hour18:DayTypeMidWeek               1.387e-01
## hour19:DayTypeMidWeek               1.840e-01
## hour20:DayTypeMidWeek               2.386e-01
## hour21:DayTypeMidWeek               3.412e-03
## hour22:DayTypeMidWeek               2.878e-03
## hour23:DayTypeMidWeek               3.335e-02
## hour24:DayTypeMidWeek               7.580e-02
## hour1:DayTypeWeekend                3.848e-01
## hour2:DayTypeWeekend                3.938e-07
## hour3:DayTypeWeekend                2.998e-02
## hour4:DayTypeWeekend                1.070e-01
## hour5:DayTypeWeekend                3.511e-01
## hour6:DayTypeWeekend                5.577e-01
## hour7:DayTypeWeekend                5.024e-01
## hour8:DayTypeWeekend                6.643e-01
## hour9:DayTypeWeekend                6.124e-02
## hour10:DayTypeWeekend               6.187e-01
## hour11:DayTypeWeekend               3.827e-01
## hour12:DayTypeWeekend               2.493e-01
## hour13:DayTypeWeekend               1.340e-01
## hour14:DayTypeWeekend               1.219e-01
## hour15:DayTypeWeekend               9.550e-02
## hour16:DayTypeWeekend               6.198e-02
## hour17:DayTypeWeekend               3.934e-02
## hour18:DayTypeWeekend               1.216e-02
## hour19:DayTypeWeekend               1.291e-03
## hour20:DayTypeWeekend               4.835e-05
## hour21:DayTypeWeekend               2.858e-04
## hour22:DayTypeWeekend               1.717e-02
## hour23:DayTypeWeekend               4.182e-02
## hour24:DayTypeWeekend               1.643e-02
## hour1:F:DayTypeEarlyWeek           6.095e-154
## hour2:F:DayTypeEarlyWeek           8.800e-162
## hour3:F:DayTypeEarlyWeek           4.961e-101
## hour4:F:DayTypeEarlyWeek            1.819e-66
## hour5:F:DayTypeEarlyWeek            9.827e-53
## hour6:F:DayTypeEarlyWeek            6.795e-53
## hour7:F:DayTypeEarlyWeek            1.752e-78
## hour8:F:DayTypeEarlyWeek           1.307e-109
## hour9:F:DayTypeEarlyWeek           3.372e-160
## hour10:F:DayTypeEarlyWeek          2.257e-155
## hour11:F:DayTypeEarlyWeek          2.648e-153
## hour12:F:DayTypeEarlyWeek          4.490e-172
## hour13:F:DayTypeEarlyWeek          6.007e-195
## hour14:F:DayTypeEarlyWeek          1.556e-219
## hour15:F:DayTypeEarlyWeek          3.605e-247
## hour16:F:DayTypeEarlyWeek          2.533e-277
## hour17:F:DayTypeEarlyWeek          1.836e-317
## hour18:F:DayTypeEarlyWeek           0.000e+00
## hour19:F:DayTypeEarlyWeek           0.000e+00
## hour20:F:DayTypeEarlyWeek           0.000e+00
## hour21:F:DayTypeEarlyWeek          6.299e-317
## hour22:F:DayTypeEarlyWeek          1.420e-253
## hour23:F:DayTypeEarlyWeek          8.810e-230
## hour24:F:DayTypeEarlyWeek          2.289e-235
## hour1:F:DayTypeMidWeek             2.085e-220
## hour2:F:DayTypeMidWeek             3.757e-229
## hour3:F:DayTypeMidWeek             1.036e-142
## hour4:F:DayTypeMidWeek             2.789e-108
## hour5:F:DayTypeMidWeek              1.205e-91
## hour6:F:DayTypeMidWeek              7.732e-85
## hour7:F:DayTypeMidWeek              6.065e-88
## hour8:F:DayTypeMidWeek             5.855e-121
## hour9:F:DayTypeMidWeek             1.386e-184
## hour10:F:DayTypeMidWeek            5.859e-175
## hour11:F:DayTypeMidWeek            2.742e-174
## hour12:F:DayTypeMidWeek            2.191e-181
## hour13:F:DayTypeMidWeek            3.064e-188
## hour14:F:DayTypeMidWeek            3.404e-195
## hour15:F:DayTypeMidWeek            1.270e-202
## hour16:F:DayTypeMidWeek            6.665e-214
## hour17:F:DayTypeMidWeek            3.943e-226
## hour18:F:DayTypeMidWeek            1.450e-246
## hour19:F:DayTypeMidWeek            2.537e-289
## hour20:F:DayTypeMidWeek            5.164e-277
## hour21:F:DayTypeMidWeek            1.007e-199
## hour22:F:DayTypeMidWeek            9.132e-164
## hour23:F:DayTypeMidWeek            4.391e-146
## hour24:F:DayTypeMidWeek            8.324e-138
## hour1:F:DayTypeWeekend             2.112e-127
## hour2:F:DayTypeWeekend             9.932e-161
## hour3:F:DayTypeWeekend              2.911e-90
## hour4:F:DayTypeWeekend              1.349e-59
## hour5:F:DayTypeWeekend              4.554e-46
## hour6:F:DayTypeWeekend              8.896e-42
## hour7:F:DayTypeWeekend              4.396e-47
## hour8:F:DayTypeWeekend              1.504e-54
## hour9:F:DayTypeWeekend              4.460e-85
## hour10:F:DayTypeWeekend             1.733e-83
## hour11:F:DayTypeWeekend             1.023e-89
## hour12:F:DayTypeWeekend            5.812e-102
## hour13:F:DayTypeWeekend            5.296e-118
## hour14:F:DayTypeWeekend            3.897e-134
## hour15:F:DayTypeWeekend            6.269e-152
## hour16:F:DayTypeWeekend            6.013e-170
## hour17:F:DayTypeWeekend            2.729e-191
## hour18:F:DayTypeWeekend            4.254e-220
## hour19:F:DayTypeWeekend            5.729e-283
## hour20:F:DayTypeWeekend            5.708e-272
## hour21:F:DayTypeWeekend            1.361e-180
## hour22:F:DayTypeWeekend            6.574e-138
## hour23:F:DayTypeWeekend            1.369e-125
## hour24:F:DayTypeWeekend            2.415e-130
## hour1:Weather:DayTypeEarlyWeek      5.054e-04
## hour2:Weather:DayTypeEarlyWeek      4.872e-01
## hour3:Weather:DayTypeEarlyWeek      7.022e-01
## hour4:Weather:DayTypeEarlyWeek      7.183e-01
## hour5:Weather:DayTypeEarlyWeek      7.669e-01
## hour6:Weather:DayTypeEarlyWeek      9.175e-01
## hour7:Weather:DayTypeEarlyWeek      9.968e-01
## hour8:Weather:DayTypeEarlyWeek      5.705e-01
## hour9:Weather:DayTypeEarlyWeek      1.784e-01
## hour10:Weather:DayTypeEarlyWeek     1.861e-03
## hour11:Weather:DayTypeEarlyWeek     1.382e-03
## hour12:Weather:DayTypeEarlyWeek     1.929e-03
## hour13:Weather:DayTypeEarlyWeek     1.429e-03
## hour14:Weather:DayTypeEarlyWeek     1.228e-03
## hour15:Weather:DayTypeEarlyWeek     3.572e-04
## hour16:Weather:DayTypeEarlyWeek     9.967e-05
## hour17:Weather:DayTypeEarlyWeek     3.029e-05
## hour18:Weather:DayTypeEarlyWeek     4.184e-05
## hour19:Weather:DayTypeEarlyWeek     6.321e-05
## hour20:Weather:DayTypeEarlyWeek     3.718e-04
## hour21:Weather:DayTypeEarlyWeek     8.480e-03
## hour22:Weather:DayTypeEarlyWeek     9.527e-03
## hour23:Weather:DayTypeEarlyWeek     3.839e-03
## hour24:Weather:DayTypeEarlyWeek     7.809e-03
## hour1:Weather:DayTypeMidWeek        9.529e-01
## hour2:Weather:DayTypeMidWeek        4.364e-01
## hour3:Weather:DayTypeMidWeek        9.210e-01
## hour4:Weather:DayTypeMidWeek        8.102e-01
## hour5:Weather:DayTypeMidWeek        6.443e-01
## hour6:Weather:DayTypeMidWeek        3.218e-01
## hour7:Weather:DayTypeMidWeek        2.958e-02
## hour8:Weather:DayTypeMidWeek        9.720e-02
## hour9:Weather:DayTypeMidWeek        6.558e-02
## hour10:Weather:DayTypeMidWeek       7.751e-01
## hour11:Weather:DayTypeMidWeek       7.741e-01
## hour12:Weather:DayTypeMidWeek       9.900e-01
## hour13:Weather:DayTypeMidWeek       5.619e-01
## hour14:Weather:DayTypeMidWeek       2.904e-01
## hour15:Weather:DayTypeMidWeek       1.564e-01
## hour16:Weather:DayTypeMidWeek       9.896e-02
## hour17:Weather:DayTypeMidWeek       9.261e-02
## hour18:Weather:DayTypeMidWeek       1.505e-01
## hour19:Weather:DayTypeMidWeek       3.133e-01
## hour20:Weather:DayTypeMidWeek       2.925e-01
## hour21:Weather:DayTypeMidWeek       1.436e-02
## hour22:Weather:DayTypeMidWeek       3.518e-02
## hour23:Weather:DayTypeMidWeek       2.637e-01
## hour24:Weather:DayTypeMidWeek       4.386e-01
## hour1:Weather:DayTypeWeekend        2.667e-04
## hour2:Weather:DayTypeWeekend        7.159e-01
## hour3:Weather:DayTypeWeekend        2.927e-01
## hour4:Weather:DayTypeWeekend        2.119e-01
## hour5:Weather:DayTypeWeekend        1.185e-01
## hour6:Weather:DayTypeWeekend        2.997e-02
## hour7:Weather:DayTypeWeekend        2.035e-03
## hour8:Weather:DayTypeWeekend        1.893e-03
## hour9:Weather:DayTypeWeekend        3.615e-05
## hour10:Weather:DayTypeWeekend       4.777e-04
## hour11:Weather:DayTypeWeekend       1.739e-03
## hour12:Weather:DayTypeWeekend       5.964e-03
## hour13:Weather:DayTypeWeekend       1.527e-02
## hour14:Weather:DayTypeWeekend       2.837e-02
## hour15:Weather:DayTypeWeekend       8.776e-02
## hour16:Weather:DayTypeWeekend       2.321e-01
## hour17:Weather:DayTypeWeekend       4.668e-01
## hour18:Weather:DayTypeWeekend       8.092e-01
## hour19:Weather:DayTypeWeekend       8.860e-01
## hour20:Weather:DayTypeWeekend       8.749e-01
## hour21:Weather:DayTypeWeekend       5.081e-01
## hour22:Weather:DayTypeWeekend       5.830e-01
## hour23:Weather:DayTypeWeekend       7.857e-01
## hour24:Weather:DayTypeWeekend       8.450e-01
## hour1:LagWeather:DayTypeEarlyWeek   1.296e-01
## hour2:LagWeather:DayTypeEarlyWeek   3.832e-01
## hour3:LagWeather:DayTypeEarlyWeek   6.858e-01
## hour4:LagWeather:DayTypeEarlyWeek   7.522e-01
## hour5:LagWeather:DayTypeEarlyWeek   8.210e-01
## hour6:LagWeather:DayTypeEarlyWeek   8.408e-01
## hour7:LagWeather:DayTypeEarlyWeek   6.591e-01
## hour8:LagWeather:DayTypeEarlyWeek   3.158e-01
## hour9:LagWeather:DayTypeEarlyWeek   2.974e-01
## hour10:LagWeather:DayTypeEarlyWeek  2.670e-02
## hour11:LagWeather:DayTypeEarlyWeek  5.431e-02
## hour12:LagWeather:DayTypeEarlyWeek  9.624e-02
## hour13:LagWeather:DayTypeEarlyWeek  1.156e-01
## hour14:LagWeather:DayTypeEarlyWeek  1.352e-01
## hour15:LagWeather:DayTypeEarlyWeek  2.415e-01
## hour16:LagWeather:DayTypeEarlyWeek  3.007e-01
## hour17:LagWeather:DayTypeEarlyWeek  3.192e-01
## hour18:LagWeather:DayTypeEarlyWeek  3.331e-01
## hour19:LagWeather:DayTypeEarlyWeek  4.156e-01
## hour20:LagWeather:DayTypeEarlyWeek  5.615e-01
## hour21:LagWeather:DayTypeEarlyWeek  6.080e-01
## hour22:LagWeather:DayTypeEarlyWeek  5.769e-01
## hour23:LagWeather:DayTypeEarlyWeek  5.565e-01
## hour24:LagWeather:DayTypeEarlyWeek  6.009e-01
## hour1:LagWeather:DayTypeMidWeek     9.245e-01
## hour2:LagWeather:DayTypeMidWeek     2.759e-01
## hour3:LagWeather:DayTypeMidWeek     5.425e-01
## hour4:LagWeather:DayTypeMidWeek     5.681e-01
## hour5:LagWeather:DayTypeMidWeek     6.558e-01
## hour6:LagWeather:DayTypeMidWeek     6.483e-01
## hour7:LagWeather:DayTypeMidWeek     3.933e-01
## hour8:LagWeather:DayTypeMidWeek     8.907e-01
## hour9:LagWeather:DayTypeMidWeek     4.349e-01
## hour10:LagWeather:DayTypeMidWeek    8.117e-01
## hour11:LagWeather:DayTypeMidWeek    8.582e-01
## hour12:LagWeather:DayTypeMidWeek    4.389e-01
## hour13:LagWeather:DayTypeMidWeek    3.232e-01
## hour14:LagWeather:DayTypeMidWeek    3.623e-01
## hour15:LagWeather:DayTypeMidWeek    4.532e-01
## hour16:LagWeather:DayTypeMidWeek    5.146e-01
## hour17:LagWeather:DayTypeMidWeek    5.275e-01
## hour18:LagWeather:DayTypeMidWeek    6.577e-01
## hour19:LagWeather:DayTypeMidWeek    8.137e-01
## hour20:LagWeather:DayTypeMidWeek    9.679e-01
## hour21:LagWeather:DayTypeMidWeek    1.446e-01
## hour22:LagWeather:DayTypeMidWeek    3.601e-01
## hour23:LagWeather:DayTypeMidWeek    6.089e-01
## hour24:LagWeather:DayTypeMidWeek    5.210e-01
## hour1:LagWeather:DayTypeWeekend     6.775e-03
## hour2:LagWeather:DayTypeWeekend     1.194e-01
## hour3:LagWeather:DayTypeWeekend     4.367e-01
## hour4:LagWeather:DayTypeWeekend     6.071e-01
## hour5:LagWeather:DayTypeWeekend     7.270e-01
## hour6:LagWeather:DayTypeWeekend     9.781e-01
## hour7:LagWeather:DayTypeWeekend     3.501e-01
## hour8:LagWeather:DayTypeWeekend     8.387e-01
## hour9:LagWeather:DayTypeWeekend     6.114e-01
## hour10:LagWeather:DayTypeWeekend    1.480e-01
## hour11:LagWeather:DayTypeWeekend    5.194e-02
## hour12:LagWeather:DayTypeWeekend    1.651e-02
## hour13:LagWeather:DayTypeWeekend    6.399e-03
## hour14:LagWeather:DayTypeWeekend    3.263e-03
## hour15:LagWeather:DayTypeWeekend    2.986e-03
## hour16:LagWeather:DayTypeWeekend    2.208e-03
## hour17:LagWeather:DayTypeWeekend    1.711e-03
## hour18:LagWeather:DayTypeWeekend    8.254e-04
## hour19:LagWeather:DayTypeWeekend    9.948e-04
## hour20:LagWeather:DayTypeWeekend    8.052e-03
## hour21:LagWeather:DayTypeWeekend    1.034e-01
## hour22:LagWeather:DayTypeWeekend    6.555e-02
## hour23:LagWeather:DayTypeWeekend    8.591e-02
## hour24:LagWeather:DayTypeWeekend    1.019e-01
## hour1:LagF:DayTypeEarlyWeek         6.788e-01
## hour2:LagF:DayTypeEarlyWeek         3.061e-07
## hour3:LagF:DayTypeEarlyWeek         3.204e-03
## hour4:LagF:DayTypeEarlyWeek         5.316e-02
## hour5:LagF:DayTypeEarlyWeek         2.417e-01
## hour6:LagF:DayTypeEarlyWeek         5.375e-01
## hour7:LagF:DayTypeEarlyWeek         6.753e-01
## hour8:LagF:DayTypeEarlyWeek         2.286e-01
## hour9:LagF:DayTypeEarlyWeek         1.751e-01
## hour10:LagF:DayTypeEarlyWeek        1.294e-02
## hour11:LagF:DayTypeEarlyWeek        2.779e-02
## hour12:LagF:DayTypeEarlyWeek        2.026e-02
## hour13:LagF:DayTypeEarlyWeek        1.539e-02
## hour14:LagF:DayTypeEarlyWeek        1.494e-02
## hour15:LagF:DayTypeEarlyWeek        8.829e-03
## hour16:LagF:DayTypeEarlyWeek        1.161e-03
## hour17:LagF:DayTypeEarlyWeek        1.573e-05
## hour18:LagF:DayTypeEarlyWeek        1.293e-08
## hour19:LagF:DayTypeEarlyWeek        3.915e-12
## hour20:LagF:DayTypeEarlyWeek        1.353e-11
## hour21:LagF:DayTypeEarlyWeek        2.268e-08
## hour22:LagF:DayTypeEarlyWeek        3.102e-10
## hour23:LagF:DayTypeEarlyWeek        7.620e-09
## hour24:LagF:DayTypeEarlyWeek        1.929e-07
## hour1:LagF:DayTypeMidWeek           8.292e-01
## hour2:LagF:DayTypeMidWeek           3.839e-08
## hour3:LagF:DayTypeMidWeek           2.143e-03
## hour4:LagF:DayTypeMidWeek           2.405e-02
## hour5:LagF:DayTypeMidWeek           9.128e-02
## hour6:LagF:DayTypeMidWeek           1.501e-01
## hour7:LagF:DayTypeMidWeek           1.559e-01
## hour8:LagF:DayTypeMidWeek           1.621e-01
## hour9:LagF:DayTypeMidWeek           1.431e-01
## hour10:LagF:DayTypeMidWeek          4.507e-01
## hour11:LagF:DayTypeMidWeek          8.336e-01
## hour12:LagF:DayTypeMidWeek          5.880e-01
## hour13:LagF:DayTypeMidWeek          2.872e-01
## hour14:LagF:DayTypeMidWeek          1.993e-01
## hour15:LagF:DayTypeMidWeek          1.772e-01
## hour16:LagF:DayTypeMidWeek          2.553e-01
## hour17:LagF:DayTypeMidWeek          4.464e-01
## hour18:LagF:DayTypeMidWeek          9.602e-01
## hour19:LagF:DayTypeMidWeek          2.528e-01
## hour20:LagF:DayTypeMidWeek          2.798e-02
## hour21:LagF:DayTypeMidWeek          1.014e-03
## hour22:LagF:DayTypeMidWeek          2.835e-04
## hour23:LagF:DayTypeMidWeek          9.126e-04
## hour24:LagF:DayTypeMidWeek          1.540e-03
## hour1:LagF:DayTypeWeekend           8.624e-01
## hour2:LagF:DayTypeWeekend           2.155e-01
## hour3:LagF:DayTypeWeekend           6.757e-01
## hour4:LagF:DayTypeWeekend           6.998e-01
## hour5:LagF:DayTypeWeekend           5.321e-01
## hour6:LagF:DayTypeWeekend           4.826e-01
## hour7:LagF:DayTypeWeekend           5.093e-01
## hour8:LagF:DayTypeWeekend           6.779e-02
## hour9:LagF:DayTypeWeekend           8.721e-04
## hour10:LagF:DayTypeWeekend          2.139e-01
## hour11:LagF:DayTypeWeekend          4.524e-01
## hour12:LagF:DayTypeWeekend          7.056e-01
## hour13:LagF:DayTypeWeekend          8.706e-01
## hour14:LagF:DayTypeWeekend          8.628e-01
## hour15:LagF:DayTypeWeekend          8.251e-01
## hour16:LagF:DayTypeWeekend          9.282e-01
## hour17:LagF:DayTypeWeekend          9.355e-01
## hour18:LagF:DayTypeWeekend          7.083e-01
## hour19:LagF:DayTypeWeekend          5.518e-01
## hour20:LagF:DayTypeWeekend          2.602e-01
## hour21:LagF:DayTypeWeekend          1.463e-01
## hour22:LagF:DayTypeWeekend          5.277e-01
## hour23:LagF:DayTypeWeekend          9.106e-01
## hour24:LagF:DayTypeWeekend          7.493e-01
```
Lets stick with this model and call it an imperfect but informative way of adding intent to forecast models.



