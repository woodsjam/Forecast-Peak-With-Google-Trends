---
title: "ResearchNotes"
author: "James Woods"
date: "07/24/2014"
output: html_document
---
Read in the data file created by the data manipulation


```r
load("~/Research/Forecast-Peak-With-Google-Trends/DataManipulation/WTrends")
```

Replicate the hour 19 experiment from the proof of concept.  First how well do the forecasts work.

```r
summary(lm(HE19~F19,data=WTrends))
```

```
## 
## Call:
## lm(formula = HE19 ~ F19, data = WTrends)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
## -13897  -2304    332   2090   7744 
## 
## Coefficients:
##              Estimate Std. Error t value Pr(>|t|)    
## (Intercept) -3.41e+03   1.58e+03   -2.15    0.033 *  
## F19          1.03e+00   1.54e-02   66.90   <2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 3340 on 181 degrees of freedom
## Multiple R-squared:  0.961,	Adjusted R-squared:  0.961 
## F-statistic: 4.48e+03 on 1 and 181 DF,  p-value: <2e-16
```
Looks like they are a little high most of the times by 3,400 MW but they comove the right way.

Now to add just PA

```r
summary(lm(HE19~F19+PATrends,data=WTrends))
```

```
## 
## Call:
## lm(formula = HE19 ~ F19 + PATrends, data = WTrends)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
## -12590  -1954    279   2374   7314 
## 
## Coefficients:
##              Estimate Std. Error t value Pr(>|t|)    
## (Intercept)  1.39e+04   4.37e+03    3.18   0.0023 ** 
## F19          9.32e-01   2.79e-02   33.40   <2e-16 ***
## PATrends    -1.24e+02   4.07e+01   -3.05   0.0033 ** 
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 3460 on 65 degrees of freedom
##   (115 observations deleted due to missingness)
## Multiple R-squared:  0.96,	Adjusted R-squared:  0.959 
## F-statistic:  778 on 2 and 65 DF,  p-value: <2e-16
```
Try with something else


```r
summary(lm(HE19~F19+NewsTrends,data=WTrends))
```

```
## 
## Call:
## lm(formula = HE19 ~ F19 + NewsTrends, data = WTrends)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
## -11407  -2135    286   2152   7264 
## 
## Coefficients:
##              Estimate Std. Error t value Pr(>|t|)    
## (Intercept)  2.00e+04   6.92e+03    2.89   0.0052 ** 
## F19          9.45e-01   2.71e-02   34.91   <2e-16 ***
## NewsTrends  -2.06e+02   7.77e+01   -2.66   0.0099 ** 
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 3510 on 65 degrees of freedom
##   (115 observations deleted due to missingness)
## Multiple R-squared:  0.959,	Adjusted R-squared:  0.957 
## F-statistic:  754 on 2 and 65 DF,  p-value: <2e-16
```
Oh, that works too


```r
summary(lm(HE19~F19+GasTrends,data=WTrends))
```

```
## 
## Call:
## lm(formula = HE19 ~ F19 + GasTrends, data = WTrends)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
## -13066  -1849    -83   2794   7439 
## 
## Coefficients:
##              Estimate Std. Error t value Pr(>|t|)    
## (Intercept) -1.43e+03   1.39e+04   -0.10     0.92    
## F19          9.76e-01   2.89e-02   33.73   <2e-16 ***
## GasTrends    4.31e+01   1.35e+02    0.32     0.75    
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 3690 on 65 degrees of freedom
##   (115 observations deleted due to missingness)
## Multiple R-squared:  0.954,	Adjusted R-squared:  0.953 
## F-statistic:  678 on 2 and 65 DF,  p-value: <2e-16
```
Gas does not


```r
summary(lm(HE19~F19+TrafficTrends,data=WTrends))
```

```
## 
## Call:
## lm(formula = HE19 ~ F19 + TrafficTrends, data = WTrends)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
## -12949  -1801    -92   2531   7511 
## 
## Coefficients:
##                Estimate Std. Error t value Pr(>|t|)    
## (Intercept)   4752.1457  4555.8572    1.04     0.30    
## F19              0.9686     0.0272   35.66   <2e-16 ***
## TrafficTrends  -25.6546    51.9469   -0.49     0.62    
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 3690 on 65 degrees of freedom
##   (115 observations deleted due to missingness)
## Multiple R-squared:  0.954,	Adjusted R-squared:  0.953 
## F-statistic:  679 on 2 and 65 DF,  p-value: <2e-16
```
Traffic does not

```r
summary(lm(HE19~F19+RestaurantTrends,data=WTrends))
```

```
## 
## Call:
## lm(formula = HE19 ~ F19 + RestaurantTrends, data = WTrends)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
## -12260  -1834   -129   2415   6587 
## 
## Coefficients:
##                   Estimate Std. Error t value Pr(>|t|)    
## (Intercept)      -725.4665  3452.7626   -0.21     0.83    
## F19                 0.9642     0.0263   36.64   <2e-16 ***
## RestaurantTrends   66.5647    41.0595    1.62     0.11    
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 3620 on 65 degrees of freedom
##   (115 observations deleted due to missingness)
## Multiple R-squared:  0.956,	Adjusted R-squared:  0.955 
## F-statistic:  705 on 2 and 65 DF,  p-value: <2e-16
```
Restaurant does not

```r
summary(lm(HE19~F19+MovieTrends,data=WTrends))
```

```
## 
## Call:
## lm(formula = HE19 ~ F19 + MovieTrends, data = WTrends)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
## -11508  -2027   -447   1978   6322 
## 
## Coefficients:
##             Estimate Std. Error t value Pr(>|t|)    
## (Intercept) 1.22e+02   2.67e+03    0.05   0.9638    
## F19         9.41e-01   2.68e-02   35.11   <2e-16 ***
## MovieTrends 8.76e+01   2.90e+01    3.02   0.0037 ** 
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 3460 on 65 degrees of freedom
##   (115 observations deleted due to missingness)
## Multiple R-squared:  0.96,	Adjusted R-squared:  0.959 
## F-statistic:  776 on 2 and 65 DF,  p-value: <2e-16
```
Snort...Movie does.  Cool place to be.


Lets just check a few other hours


```r
summary(lm(HE11~F11+PATrends,data=WTrends))
```

```
## 
## Call:
## lm(formula = HE11 ~ F11 + PATrends, data = WTrends)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
##  -5854  -1031    -79   1107   4922 
## 
## Coefficients:
##              Estimate Std. Error t value Pr(>|t|)    
## (Intercept) 6889.9764  2591.5526    2.66   0.0099 ** 
## F11            0.9795     0.0203   48.26  < 2e-16 ***
## PATrends     -90.7788    21.3308   -4.26  6.8e-05 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 1900 on 65 degrees of freedom
##   (115 observations deleted due to missingness)
## Multiple R-squared:  0.978,	Adjusted R-squared:  0.978 
## F-statistic: 1.46e+03 on 2 and 65 DF,  p-value: <2e-16
```



```r
summary(lm(HE05~F05+PATrends,data=WTrends))
```

```
## 
## Call:
## lm(formula = HE05 ~ F05 + PATrends, data = WTrends)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
##  -3335   -749    213    714   2460 
## 
## Coefficients:
##              Estimate Std. Error t value Pr(>|t|)    
## (Intercept) 1463.3329  2079.9380     0.7   0.4842    
## F05            1.0006     0.0253    39.5   <2e-16 ***
## PATrends     -36.6313    12.6339    -2.9   0.0051 ** 
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 1150 on 65 degrees of freedom
##   (115 observations deleted due to missingness)
## Multiple R-squared:  0.966,	Adjusted R-squared:  0.965 
## F-statistic:  921 on 2 and 65 DF,  p-value: <2e-16
```
Small in absolute terms

# Weighting the search terms

I need to weight the state weather search terms by population. These population estimates are from  "Annual Estimates of the Resident Population for the United States, Regions, States, and Puerto Rico: April 1, 2010 to July 1, 2013" (CSV). 2013 Population Estimates. United States Census Bureau, Population Division. December 30, 2013. Retrieved December 30, 2013.


Here is where it gets strange.  I can't get count, just an index normalized by state.  This then is a population weighted value of indexes and not a population weighted index.


```r
# DE 925,749
# Maryland  5,928,814	
# New Jersey  8,899,339	
# Ohio  11,570,808
# Pennsylvania  12,773,801
# Virginia  8,260,405
# West Virginia  1,854,304
# Kentucky  4,395,295	


WTrends$Weather<-((925749*WTrends$DETrends)+(4395295*WTrends$KYTrends)+(5928814*WTrends$MDTrends)+(8899339*WTrends$NJTrends)+(11570808*WTrends$OHTrends)+(12773801*WTrends$PATrends)+(8260405*WTrends$VATrends)+(1854304*WTrends$WVTrends))/(925749+4395295+5928814+8899339+11570808+12773801+8260405+1854304)        
      
summary(WTrends$Weather)
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
##    28.8    39.5    46.4    46.9    53.6    68.7     115
```
Note that the index is now attenuated.


# Model all hours

```r
HourModel<-function(hour){
  Hour<-formatC(hour, width=2, flag="0")
  as.formula(paste("HE",Hour,"~ F",Hour,"+Weather",sep='' ))}


lapply(1:24, FUN = function(x)  summary(lm(HourModel(x), data=WTrends)))
```

```
## [[1]]
## 
## Call:
## lm(formula = HourModel(x), data = WTrends)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
##  -4119   -640    269    997   2265 
## 
## Coefficients:
##             Estimate Std. Error t value Pr(>|t|)    
## (Intercept) 2395.820   2275.007    1.05    0.296    
## F01            0.995      0.023   43.16   <2e-16 ***
## Weather      -50.116     19.288   -2.60    0.012 *  
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 1410 on 65 degrees of freedom
##   (115 observations deleted due to missingness)
## Multiple R-squared:  0.973,	Adjusted R-squared:  0.972 
## F-statistic: 1.18e+03 on 2 and 65 DF,  p-value: <2e-16
## 
## 
## [[2]]
## 
## Call:
## lm(formula = HourModel(x), data = WTrends)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
##  -3959   -606    280    926   2437 
## 
## Coefficients:
##              Estimate Std. Error t value Pr(>|t|)    
## (Intercept) 1796.7506  2239.2485    0.80    0.425    
## F02            0.9977     0.0245   40.72   <2e-16 ***
## Weather      -44.3312    18.0328   -2.46    0.017 *  
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 1330 on 65 degrees of freedom
##   (115 observations deleted due to missingness)
## Multiple R-squared:  0.97,	Adjusted R-squared:  0.969 
## F-statistic: 1.04e+03 on 2 and 65 DF,  p-value: <2e-16
## 
## 
## [[3]]
## 
## Call:
## lm(formula = HourModel(x), data = WTrends)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
##  -3565   -796    192    817   2575 
## 
## Coefficients:
##              Estimate Std. Error t value Pr(>|t|)    
## (Intercept) 1442.3662  2187.6053    0.66    0.512    
## F03            0.9996     0.0253   39.48   <2e-16 ***
## Weather      -41.2228    16.7416   -2.46    0.016 *  
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 1240 on 65 degrees of freedom
##   (115 observations deleted due to missingness)
## Multiple R-squared:  0.967,	Adjusted R-squared:  0.966 
## F-statistic:  964 on 2 and 65 DF,  p-value: <2e-16
## 
## 
## [[4]]
## 
## Call:
## lm(formula = HourModel(x), data = WTrends)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
##  -3615   -822    208    756   2388 
## 
## Coefficients:
##              Estimate Std. Error t value Pr(>|t|)    
## (Intercept)  684.1848  2206.0504    0.31    0.757    
## F04            1.0076     0.0265   38.04   <2e-16 ***
## Weather      -37.3691    16.1626   -2.31    0.024 *  
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 1200 on 65 degrees of freedom
##   (115 observations deleted due to missingness)
## Multiple R-squared:  0.964,	Adjusted R-squared:  0.963 
## F-statistic:  880 on 2 and 65 DF,  p-value: <2e-16
## 
## 
## [[5]]
## 
## Call:
## lm(formula = HourModel(x), data = WTrends)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
##  -3441   -873    151    758   2483 
## 
## Coefficients:
##              Estimate Std. Error t value Pr(>|t|)    
## (Intercept)  850.9572  2156.1115    0.39    0.694    
## F05            1.0038     0.0261   38.46   <2e-16 ***
## Weather      -35.6111    15.5922   -2.28    0.026 *  
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 1170 on 65 degrees of freedom
##   (115 observations deleted due to missingness)
## Multiple R-squared:  0.964,	Adjusted R-squared:  0.963 
## F-statistic:  880 on 2 and 65 DF,  p-value: <2e-16
## 
## 
## [[6]]
## 
## Call:
## lm(formula = HourModel(x), data = WTrends)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
##  -3003   -697    172    756   2740 
## 
## Coefficients:
##              Estimate Std. Error t value Pr(>|t|)    
## (Intercept)  685.5593  1950.7861    0.35    0.726    
## F06            1.0012     0.0227   44.11   <2e-16 ***
## Weather      -31.0744    15.0553   -2.06    0.043 *  
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 1150 on 65 degrees of freedom
##   (115 observations deleted due to missingness)
## Multiple R-squared:  0.971,	Adjusted R-squared:  0.97 
## F-statistic: 1.1e+03 on 2 and 65 DF,  p-value: <2e-16
## 
## 
## [[7]]
## 
## Call:
## lm(formula = HourModel(x), data = WTrends)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
##  -3371   -694     32    826   3393 
## 
## Coefficients:
##             Estimate Std. Error t value Pr(>|t|)    
## (Intercept)   539.29    1879.51    0.29    0.775    
## F07             1.00       0.02   50.12   <2e-16 ***
## Weather       -36.94      17.21   -2.15    0.036 *  
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 1350 on 65 degrees of freedom
##   (115 observations deleted due to missingness)
## Multiple R-squared:  0.976,	Adjusted R-squared:  0.976 
## F-statistic: 1.34e+03 on 2 and 65 DF,  p-value: <2e-16
## 
## 
## [[8]]
## 
## Call:
## lm(formula = HourModel(x), data = WTrends)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
##  -3684   -653     94    895   3098 
## 
## Coefficients:
##              Estimate Std. Error t value Pr(>|t|)    
## (Intercept) 1583.6483  1686.6442    0.94   0.3512    
## F08            0.9994     0.0164   61.03   <2e-16 ***
## Weather      -48.1108    16.4853   -2.92   0.0048 ** 
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 1290 on 65 degrees of freedom
##   (115 observations deleted due to missingness)
## Multiple R-squared:  0.984,	Adjusted R-squared:  0.984 
## F-statistic: 2e+03 on 2 and 65 DF,  p-value: <2e-16
## 
## 
## [[9]]
## 
## Call:
## lm(formula = HourModel(x), data = WTrends)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
##  -3810   -962    132    850   3267 
## 
## Coefficients:
##              Estimate Std. Error t value Pr(>|t|)    
## (Intercept) 3332.1675  1878.6439    1.77  0.08080 .  
## F09            0.9947     0.0171   58.33  < 2e-16 ***
## Weather      -69.0990    17.8134   -3.88  0.00025 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 1370 on 65 degrees of freedom
##   (115 observations deleted due to missingness)
## Multiple R-squared:  0.983,	Adjusted R-squared:  0.983 
## F-statistic: 1.92e+03 on 2 and 65 DF,  p-value: <2e-16
## 
## 
## [[10]]
## 
## Call:
## lm(formula = HourModel(x), data = WTrends)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
##  -4766  -1152    140    916   3605 
## 
## Coefficients:
##              Estimate Std. Error t value Pr(>|t|)    
## (Intercept) 4630.3982  2204.2776    2.10  0.03956 *  
## F10            0.9903     0.0186   53.18  < 2e-16 ***
## Weather      -84.3078    20.8021   -4.05  0.00014 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 1560 on 65 degrees of freedom
##   (115 observations deleted due to missingness)
## Multiple R-squared:  0.981,	Adjusted R-squared:  0.981 
## F-statistic: 1.7e+03 on 2 and 65 DF,  p-value: <2e-16
## 
## 
## [[11]]
## 
## Call:
## lm(formula = HourModel(x), data = WTrends)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
##  -6101  -1120    -13   1135   5150 
## 
## Coefficients:
##              Estimate Std. Error t value Pr(>|t|)    
## (Intercept) 6646.1990  2662.0074    2.50  0.01508 *  
## F11            0.9794     0.0208   47.18  < 2e-16 ***
## Weather     -103.8326    26.1086   -3.98  0.00018 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 1920 on 65 degrees of freedom
##   (115 observations deleted due to missingness)
## Multiple R-squared:  0.978,	Adjusted R-squared:  0.977 
## F-statistic: 1.42e+03 on 2 and 65 DF,  p-value: <2e-16
## 
## 
## [[12]]
## 
## Call:
## lm(formula = HourModel(x), data = WTrends)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
##  -7392  -1567   -136   1333   6486 
## 
## Coefficients:
##              Estimate Std. Error t value Pr(>|t|)    
## (Intercept) 8769.6186  3045.4753    2.88  0.00539 ** 
## F12            0.9664     0.0221   43.72  < 2e-16 ***
## Weather     -120.7339    31.2415   -3.86  0.00026 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 2260 on 65 degrees of freedom
##   (115 observations deleted due to missingness)
## Multiple R-squared:  0.975,	Adjusted R-squared:  0.974 
## F-statistic: 1.27e+03 on 2 and 65 DF,  p-value: <2e-16
## 
## 
## [[13]]
## 
## Call:
## lm(formula = HourModel(x), data = WTrends)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
##  -8235  -1744    137   1383   7283 
## 
## Coefficients:
##              Estimate Std. Error t value Pr(>|t|)    
## (Intercept)  1.06e+04   3.40e+03    3.13  0.00261 ** 
## F13          9.55e-01   2.32e-02   41.14  < 2e-16 ***
## Weather     -1.36e+02   3.61e+01   -3.76  0.00037 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 2570 on 65 degrees of freedom
##   (115 observations deleted due to missingness)
## Multiple R-squared:  0.973,	Adjusted R-squared:  0.972 
## F-statistic: 1.17e+03 on 2 and 65 DF,  p-value: <2e-16
## 
## 
## [[14]]
## 
## Call:
## lm(formula = HourModel(x), data = WTrends)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
##  -8588  -1866    176   1435   7819 
## 
## Coefficients:
##              Estimate Std. Error t value Pr(>|t|)    
## (Intercept)  1.27e+04   3.61e+03    3.52  0.00080 ***
## F14          9.40e-01   2.34e-02   40.13  < 2e-16 ***
## Weather     -1.47e+02   3.98e+01   -3.69  0.00046 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 2810 on 65 degrees of freedom
##   (115 observations deleted due to missingness)
## Multiple R-squared:  0.972,	Adjusted R-squared:  0.971 
## F-statistic: 1.14e+03 on 2 and 65 DF,  p-value: <2e-16
## 
## 
## [[15]]
## 
## Call:
## lm(formula = HourModel(x), data = WTrends)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
##  -9423  -2007     72   1763   8000 
## 
## Coefficients:
##              Estimate Std. Error t value Pr(>|t|)    
## (Intercept)  1.42e+04   3.77e+03    3.76  0.00036 ***
## F15          9.30e-01   2.36e-02   39.45  < 2e-16 ***
## Weather     -1.55e+02   4.25e+01   -3.65  0.00053 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 2970 on 65 degrees of freedom
##   (115 observations deleted due to missingness)
## Multiple R-squared:  0.972,	Adjusted R-squared:  0.971 
## F-statistic: 1.12e+03 on 2 and 65 DF,  p-value: <2e-16
## 
## 
## [[16]]
## 
## Call:
## lm(formula = HourModel(x), data = WTrends)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
## -10355  -1969    235   1960   8342 
## 
## Coefficients:
##              Estimate Std. Error t value Pr(>|t|)    
## (Intercept)  1.54e+04   4.04e+03    3.82  0.00030 ***
## F16          9.23e-01   2.47e-02   37.41  < 2e-16 ***
## Weather     -1.65e+02   4.61e+01   -3.59  0.00064 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 3200 on 65 degrees of freedom
##   (115 observations deleted due to missingness)
## Multiple R-squared:  0.969,	Adjusted R-squared:  0.969 
## F-statistic: 1.03e+03 on 2 and 65 DF,  p-value: <2e-16
## 
## 
## [[17]]
## 
## Call:
## lm(formula = HourModel(x), data = WTrends)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
## -11818  -1847    401   2203   8278 
## 
## Coefficients:
##              Estimate Std. Error t value Pr(>|t|)    
## (Intercept)  1.59e+04   4.29e+03    3.71  0.00044 ***
## F17          9.22e-01   2.59e-02   35.61  < 2e-16 ***
## Weather     -1.68e+02   4.89e+01   -3.43  0.00104 ** 
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 3370 on 65 degrees of freedom
##   (115 observations deleted due to missingness)
## Multiple R-squared:  0.967,	Adjusted R-squared:  0.966 
## F-statistic:  950 on 2 and 65 DF,  p-value: <2e-16
## 
## 
## [[18]]
## 
## Call:
## lm(formula = HourModel(x), data = WTrends)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
## -13015  -1859    372   1987   7544 
## 
## Coefficients:
##              Estimate Std. Error t value Pr(>|t|)    
## (Intercept)  1.57e+04   4.54e+03    3.47  0.00094 ***
## F18          9.23e-01   2.76e-02   33.47  < 2e-16 ***
## Weather     -1.65e+02   5.10e+01   -3.24  0.00188 ** 
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 3490 on 65 degrees of freedom
##   (115 observations deleted due to missingness)
## Multiple R-squared:  0.963,	Adjusted R-squared:  0.962 
## F-statistic:  851 on 2 and 65 DF,  p-value: <2e-16
## 
## 
## [[19]]
## 
## Call:
## lm(formula = HourModel(x), data = WTrends)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
## -12825  -2031    304   2115   6569 
## 
## Coefficients:
##              Estimate Std. Error t value Pr(>|t|)    
## (Intercept)  1.52e+04   4.60e+03    3.31   0.0015 ** 
## F19          9.24e-01   2.88e-02   32.04   <2e-16 ***
## Weather     -1.60e+02   5.04e+01   -3.18   0.0023 ** 
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 3440 on 65 degrees of freedom
##   (115 observations deleted due to missingness)
## Multiple R-squared:  0.96,	Adjusted R-squared:  0.959 
## F-statistic:  787 on 2 and 65 DF,  p-value: <2e-16
## 
## 
## [[20]]
## 
## Call:
## lm(formula = HourModel(x), data = WTrends)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
## -11921  -1954    251   2130   5928 
## 
## Coefficients:
##              Estimate Std. Error t value Pr(>|t|)    
## (Intercept)  1.25e+04   4.55e+03    2.76   0.0076 ** 
## F20          9.36e-01   3.01e-02   31.06   <2e-16 ***
## Weather     -1.43e+02   4.74e+01   -3.02   0.0036 ** 
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 3230 on 65 degrees of freedom
##   (115 observations deleted due to missingness)
## Multiple R-squared:  0.958,	Adjusted R-squared:  0.957 
## F-statistic:  739 on 2 and 65 DF,  p-value: <2e-16
## 
## 
## [[21]]
## 
## Call:
## lm(formula = HourModel(x), data = WTrends)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
## -11136  -1455     33   1786   5557 
## 
## Coefficients:
##              Estimate Std. Error t value Pr(>|t|)    
## (Intercept)  1.09e+04   4.27e+03    2.55   0.0133 *  
## F21          9.33e-01   2.99e-02   31.22   <2e-16 ***
## Weather     -1.13e+02   4.10e+01   -2.75   0.0077 ** 
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 2800 on 65 degrees of freedom
##   (115 observations deleted due to missingness)
## Multiple R-squared:  0.958,	Adjusted R-squared:  0.957 
## F-statistic:  742 on 2 and 65 DF,  p-value: <2e-16
## 
## 
## [[22]]
## 
## Call:
## lm(formula = HourModel(x), data = WTrends)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
##  -9405  -1383    372   1410   5153 
## 
## Coefficients:
##              Estimate Std. Error t value Pr(>|t|)    
## (Intercept)  1.21e+04   3.96e+03    3.05   0.0033 ** 
## F22          9.25e-01   2.87e-02   32.23   <2e-16 ***
## Weather     -1.12e+02   3.69e+01   -3.04   0.0034 ** 
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 2510 on 65 degrees of freedom
##   (115 observations deleted due to missingness)
## Multiple R-squared:  0.961,	Adjusted R-squared:  0.96 
## F-statistic:  799 on 2 and 65 DF,  p-value: <2e-16
## 
## 
## [[23]]
## 
## Call:
## lm(formula = HourModel(x), data = WTrends)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
##  -7954  -1622    -14   1282   5348 
## 
## Coefficients:
##              Estimate Std. Error t value Pr(>|t|)    
## (Intercept)  1.05e+04   3.78e+03    2.77   0.0072 ** 
## F23          9.35e-01   2.98e-02   31.36   <2e-16 ***
## Weather     -1.05e+02   3.44e+01   -3.04   0.0034 ** 
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 2350 on 65 degrees of freedom
##   (115 observations deleted due to missingness)
## Multiple R-squared:  0.959,	Adjusted R-squared:  0.957 
## F-statistic:  751 on 2 and 65 DF,  p-value: <2e-16
## 
## 
## [[24]]
## 
## Call:
## lm(formula = HourModel(x), data = WTrends)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
##  -6912  -1254    -30   1203   5077 
## 
## Coefficients:
##              Estimate Std. Error t value Pr(>|t|)    
## (Intercept) 8585.7271  3508.9163    2.45   0.0171 *  
## F24            0.9423     0.0308   30.61   <2e-16 ***
## Weather      -91.4383    30.6942   -2.98   0.0041 ** 
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 2110 on 65 degrees of freedom
##   (115 observations deleted due to missingness)
## Multiple R-squared:  0.956,	Adjusted R-squared:  0.955 
## F-statistic:  708 on 2 and 65 DF,  p-value: <2e-16
```

Quick summary is that google trends is helpful in all hours of the day. It also looks like the forecasts are usually off by a large amount.  I should look at those individually.


```r
HourModelForecastCheck<-function(hour){
  Hour<-formatC(hour, width=2, flag="0")
  as.formula(paste("HE",Hour,"~ F",Hour,sep='' ))}


lapply(1:24, FUN = function(x)  summary(lm(HourModelForecastCheck(x), data=WTrends)))
```

```
## [[1]]
## 
## Call:
## lm(formula = HourModelForecastCheck(x), data = WTrends)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
##  -6481  -1180     30   1086   5776 
## 
## Coefficients:
##              Estimate Std. Error t value Pr(>|t|)    
## (Intercept) -3.47e+03   8.73e+02   -3.98    1e-04 ***
## F01          1.04e+00   1.03e-02  100.14   <2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 1780 on 181 degrees of freedom
## Multiple R-squared:  0.982,	Adjusted R-squared:  0.982 
## F-statistic: 1e+04 on 1 and 181 DF,  p-value: <2e-16
## 
## 
## [[2]]
## 
## Call:
## lm(formula = HourModelForecastCheck(x), data = WTrends)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
##  -5587  -2172   -705   1057  64753 
## 
## Coefficients:
##             Estimate Std. Error t value Pr(>|t|)    
## (Intercept) 1.03e+04   2.32e+03    4.45  1.5e-05 ***
## F02         8.71e-01   2.85e-02   30.57  < 2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 5570 on 181 degrees of freedom
## Multiple R-squared:  0.838,	Adjusted R-squared:  0.837 
## F-statistic:  934 on 1 and 181 DF,  p-value: <2e-16
## 
## 
## [[3]]
## 
## Call:
## lm(formula = HourModelForecastCheck(x), data = WTrends)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
##  -6812  -1113    -67    982   5732 
## 
## Coefficients:
##              Estimate Std. Error t value Pr(>|t|)    
## (Intercept) -3.14e+03   7.56e+02   -4.16    5e-05 ***
## F03          1.03e+00   9.40e-03  110.07   <2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 1730 on 180 degrees of freedom
##   (1 observation deleted due to missingness)
## Multiple R-squared:  0.985,	Adjusted R-squared:  0.985 
## F-statistic: 1.21e+04 on 1 and 180 DF,  p-value: <2e-16
## 
## 
## [[4]]
## 
## Call:
## lm(formula = HourModelForecastCheck(x), data = WTrends)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
##  -6857  -1020    -15    942   5606 
## 
## Coefficients:
##              Estimate Std. Error t value Pr(>|t|)    
## (Intercept) -2.90e+03   7.35e+02   -3.94  0.00012 ***
## F04          1.03e+00   9.17e-03  112.47  < 2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 1750 on 181 degrees of freedom
## Multiple R-squared:  0.986,	Adjusted R-squared:  0.986 
## F-statistic: 1.26e+04 on 1 and 181 DF,  p-value: <2e-16
## 
## 
## [[5]]
## 
## Call:
## lm(formula = HourModelForecastCheck(x), data = WTrends)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
##  -6533  -1061     47    893   5637 
## 
## Coefficients:
##              Estimate Std. Error t value Pr(>|t|)    
## (Intercept) -2.65e+03   7.17e+02   -3.69  0.00029 ***
## F05          1.03e+00   8.81e-03  116.66  < 2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 1750 on 181 degrees of freedom
## Multiple R-squared:  0.987,	Adjusted R-squared:  0.987 
## F-statistic: 1.36e+04 on 1 and 181 DF,  p-value: <2e-16
## 
## 
## [[6]]
## 
## Call:
## lm(formula = HourModelForecastCheck(x), data = WTrends)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
##  -6123   -987     34    970   5555 
## 
## Coefficients:
##              Estimate Std. Error t value Pr(>|t|)    
## (Intercept) -2.52e+03   7.27e+02   -3.47  0.00065 ***
## F06          1.02e+00   8.53e-03  120.11  < 2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 1800 on 181 degrees of freedom
## Multiple R-squared:  0.988,	Adjusted R-squared:  0.988 
## F-statistic: 1.44e+04 on 1 and 181 DF,  p-value: <2e-16
## 
## 
## [[7]]
## 
## Call:
## lm(formula = HourModelForecastCheck(x), data = WTrends)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
##  -8492  -1088     55    994   5728 
## 
## Coefficients:
##              Estimate Std. Error t value Pr(>|t|)    
## (Intercept) -2.87e+03   8.21e+02    -3.5  0.00059 ***
## F07          1.03e+00   8.95e-03   114.5  < 2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 2070 on 181 degrees of freedom
## Multiple R-squared:  0.986,	Adjusted R-squared:  0.986 
## F-statistic: 1.31e+04 on 1 and 181 DF,  p-value: <2e-16
## 
## 
## [[8]]
## 
## Call:
## lm(formula = HourModelForecastCheck(x), data = WTrends)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
##  -9662  -1149    107   1329   6950 
## 
## Coefficients:
##              Estimate Std. Error t value Pr(>|t|)    
## (Intercept) -2.08e+03   9.00e+02   -2.31    0.022 *  
## F08          1.02e+00   9.34e-03  108.74   <2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 2210 on 181 degrees of freedom
## Multiple R-squared:  0.985,	Adjusted R-squared:  0.985 
## F-statistic: 1.18e+04 on 1 and 181 DF,  p-value: <2e-16
## 
## 
## [[9]]
## 
## Call:
## lm(formula = HourModelForecastCheck(x), data = WTrends)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
##  -7838  -1103    -77   1250   6958 
## 
## Coefficients:
##              Estimate Std. Error t value Pr(>|t|)    
## (Intercept) -1.94e+03   9.64e+02   -2.01    0.046 *  
## F09          1.02e+00   9.83e-03  103.34   <2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 2130 on 181 degrees of freedom
## Multiple R-squared:  0.983,	Adjusted R-squared:  0.983 
## F-statistic: 1.07e+04 on 1 and 181 DF,  p-value: <2e-16
## 
## 
## [[10]]
## 
## Call:
## lm(formula = HourModelForecastCheck(x), data = WTrends)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
##  -6799  -1207    -68   1246   6655 
## 
## Coefficients:
##              Estimate Std. Error t value Pr(>|t|)    
## (Intercept) -2.53e+03   1.05e+03    -2.4    0.017 *  
## F10          1.02e+00   1.07e-02    96.1   <2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 2080 on 181 degrees of freedom
## Multiple R-squared:  0.981,	Adjusted R-squared:  0.981 
## F-statistic: 9.23e+03 on 1 and 181 DF,  p-value: <2e-16
## 
## 
## [[11]]
## 
## Call:
## lm(formula = HourModelForecastCheck(x), data = WTrends)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
##  -7050  -1387    -14   1214   6415 
## 
## Coefficients:
##              Estimate Std. Error t value Pr(>|t|)    
## (Intercept) -3.05e+03   1.20e+03   -2.55    0.012 *  
## F11          1.03e+00   1.21e-02   85.30   <2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 2200 on 181 degrees of freedom
## Multiple R-squared:  0.976,	Adjusted R-squared:  0.976 
## F-statistic: 7.28e+03 on 1 and 181 DF,  p-value: <2e-16
## 
## 
## [[12]]
## 
## Call:
## lm(formula = HourModelForecastCheck(x), data = WTrends)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
##  -8251  -1457     39   1463   7657 
## 
## Coefficients:
##              Estimate Std. Error t value Pr(>|t|)    
## (Intercept) -3.41e+03   1.35e+03   -2.53    0.012 *  
## F12          1.03e+00   1.36e-02   76.08   <2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 2410 on 181 degrees of freedom
## Multiple R-squared:  0.97,	Adjusted R-squared:  0.97 
## F-statistic: 5.79e+03 on 1 and 181 DF,  p-value: <2e-16
## 
## 
## [[13]]
## 
## Call:
## lm(formula = HourModelForecastCheck(x), data = WTrends)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
##  -9477  -1517     43   1517   8396 
## 
## Coefficients:
##              Estimate Std. Error t value Pr(>|t|)    
## (Intercept) -3.09e+03   1.46e+03   -2.12    0.035 *  
## F13          1.03e+00   1.47e-02   70.06   <2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 2610 on 181 degrees of freedom
## Multiple R-squared:  0.964,	Adjusted R-squared:  0.964 
## F-statistic: 4.91e+03 on 1 and 181 DF,  p-value: <2e-16
## 
## 
## [[14]]
## 
## Call:
## lm(formula = HourModelForecastCheck(x), data = WTrends)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
## -10082  -1729     48   1518   8899 
## 
## Coefficients:
##              Estimate Std. Error t value Pr(>|t|)    
## (Intercept) -2.02e+03   1.50e+03   -1.35     0.18    
## F14          1.02e+00   1.52e-02   67.00   <2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 2790 on 181 degrees of freedom
## Multiple R-squared:  0.961,	Adjusted R-squared:  0.961 
## F-statistic: 4.49e+03 on 1 and 181 DF,  p-value: <2e-16
## 
## 
## [[15]]
## 
## Call:
## lm(formula = HourModelForecastCheck(x), data = WTrends)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
## -11028  -1810    165   1629   9112 
## 
## Coefficients:
##              Estimate Std. Error t value Pr(>|t|)    
## (Intercept) -1.19e+03   1.53e+03   -0.77     0.44    
## F15          1.01e+00   1.56e-02   65.03   <2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 2950 on 181 degrees of freedom
## Multiple R-squared:  0.959,	Adjusted R-squared:  0.959 
## F-statistic: 4.23e+03 on 1 and 181 DF,  p-value: <2e-16
## 
## 
## [[16]]
## 
## Call:
## lm(formula = HourModelForecastCheck(x), data = WTrends)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
## -11979  -1812     23   1876   9614 
## 
## Coefficients:
##              Estimate Std. Error t value Pr(>|t|)    
## (Intercept) -941.6266  1564.0355    -0.6     0.55    
## F16            1.0106     0.0159    63.5   <2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 3110 on 181 degrees of freedom
## Multiple R-squared:  0.957,	Adjusted R-squared:  0.957 
## F-statistic: 4.03e+03 on 1 and 181 DF,  p-value: <2e-16
## 
## 
## [[17]]
## 
## Call:
## lm(formula = HourModelForecastCheck(x), data = WTrends)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
## -13438  -1981    130   1857   9756 
## 
## Coefficients:
##              Estimate Std. Error t value Pr(>|t|)    
## (Intercept) -1.73e+03   1.63e+03   -1.06     0.29    
## F17          1.02e+00   1.64e-02   61.92   <2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 3290 on 181 degrees of freedom
## Multiple R-squared:  0.955,	Adjusted R-squared:  0.955 
## F-statistic: 3.83e+03 on 1 and 181 DF,  p-value: <2e-16
## 
## 
## [[18]]
## 
## Call:
## lm(formula = HourModelForecastCheck(x), data = WTrends)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
## -14233  -2444    126   2100   9510 
## 
## Coefficients:
##              Estimate Std. Error t value Pr(>|t|)    
## (Intercept) -2.91e+03   1.70e+03   -1.72    0.088 .  
## F18          1.02e+00   1.67e-02   61.39   <2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 3490 on 181 degrees of freedom
## Multiple R-squared:  0.954,	Adjusted R-squared:  0.954 
## F-statistic: 3.77e+03 on 1 and 181 DF,  p-value: <2e-16
## 
## 
## [[19]]
## 
## Call:
## lm(formula = HourModelForecastCheck(x), data = WTrends)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
## -13897  -2304    332   2090   7744 
## 
## Coefficients:
##              Estimate Std. Error t value Pr(>|t|)    
## (Intercept) -3.41e+03   1.58e+03   -2.15    0.033 *  
## F19          1.03e+00   1.54e-02   66.90   <2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 3340 on 181 degrees of freedom
## Multiple R-squared:  0.961,	Adjusted R-squared:  0.961 
## F-statistic: 4.48e+03 on 1 and 181 DF,  p-value: <2e-16
## 
## 
## [[20]]
## 
## Call:
## lm(formula = HourModelForecastCheck(x), data = WTrends)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
## -13134  -1848     97   1832   6747 
## 
## Coefficients:
##              Estimate Std. Error t value Pr(>|t|)    
## (Intercept) -4.30e+03   1.47e+03   -2.92   0.0039 ** 
## F20          1.04e+00   1.43e-02   72.37   <2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 2940 on 181 degrees of freedom
## Multiple R-squared:  0.967,	Adjusted R-squared:  0.966 
## F-statistic: 5.24e+03 on 1 and 181 DF,  p-value: <2e-16
## 
## 
## [[21]]
## 
## Call:
## lm(formula = HourModelForecastCheck(x), data = WTrends)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
## -12840  -1396     54   1566   5543 
## 
## Coefficients:
##              Estimate Std. Error t value Pr(>|t|)    
## (Intercept) -3.56e+03   1.40e+03   -2.54    0.012 *  
## F21          1.03e+00   1.37e-02   75.26   <2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 2540 on 181 degrees of freedom
## Multiple R-squared:  0.969,	Adjusted R-squared:  0.969 
## F-statistic: 5.66e+03 on 1 and 181 DF,  p-value: <2e-16
## 
## 
## [[22]]
## 
## Call:
## lm(formula = HourModelForecastCheck(x), data = WTrends)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
## -10605  -1500    187   1366   5509 
## 
## Coefficients:
##              Estimate Std. Error t value Pr(>|t|)    
## (Intercept) -2.44e+03   1.34e+03   -1.82     0.07 .  
## F22          1.02e+00   1.34e-02   76.48   <2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 2350 on 181 degrees of freedom
## Multiple R-squared:  0.97,	Adjusted R-squared:  0.97 
## F-statistic: 5.85e+03 on 1 and 181 DF,  p-value: <2e-16
## 
## 
## [[23]]
## 
## Call:
## lm(formula = HourModelForecastCheck(x), data = WTrends)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
##  -8781  -1408    -30   1266   5912 
## 
## Coefficients:
##              Estimate Std. Error t value Pr(>|t|)    
## (Intercept) -3.03e+03   1.26e+03    -2.4    0.018 *  
## F23          1.03e+00   1.33e-02    77.2   <2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 2260 on 181 degrees of freedom
## Multiple R-squared:  0.97,	Adjusted R-squared:  0.97 
## F-statistic: 5.95e+03 on 1 and 181 DF,  p-value: <2e-16
## 
## 
## [[24]]
## 
## Call:
## lm(formula = HourModelForecastCheck(x), data = WTrends)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
##  -7758  -1284    -19   1188   6464 
## 
## Coefficients:
##              Estimate Std. Error t value Pr(>|t|)    
## (Intercept) -3.83e+03   1.17e+03   -3.27   0.0013 ** 
## F24          1.04e+00   1.32e-02   78.99   <2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 2200 on 181 degrees of freedom
## Multiple R-squared:  0.972,	Adjusted R-squared:  0.972 
## F-statistic: 6.24e+03 on 1 and 181 DF,  p-value: <2e-16
```
The intercept terms are almost all negative and almost all significant.  That means that they are forecasting high consistently.

Checking if the forecasts comove well, i.e., confidence interval contains 1.


```r
HourModelForecastCheck<-function(hour){
  Hour<-formatC(hour, width=2, flag="0")
  as.formula(paste("HE",Hour,"~ F",Hour,sep='' ))}


lapply(1:24, FUN = function(x)  confint(lm(HourModelForecastCheck(x), data=WTrends)))
```

```
## [[1]]
##                 2.5 %    97.5 %
## (Intercept) -5194.727 -1750.026
## F01             1.016     1.057
## 
## [[2]]
##                 2.5 %    97.5 %
## (Intercept) 5749.3985 1.491e+04
## F02            0.8149 9.274e-01
## 
## [[3]]
##                 2.5 %    97.5 %
## (Intercept) -4632.588 -1650.321
## F03             1.016     1.053
## 
## [[4]]
##                 2.5 %    97.5 %
## (Intercept) -4344.706 -1445.628
## F04             1.013     1.049
## 
## [[5]]
##                2.5 %    97.5 %
## (Intercept) -4058.89 -1231.352
## F05             1.01     1.045
## 
## [[6]]
##                 2.5 %    97.5 %
## (Intercept) -3955.809 -1087.866
## F06             1.008     1.041
## 
## [[7]]
##                 2.5 %    97.5 %
## (Intercept) -4490.223 -1250.124
## F07             1.007     1.043
## 
## [[8]]
##                 2.5 %   97.5 %
## (Intercept) -3856.589 -303.114
## F08             0.997    1.034
## 
## [[9]]
##                  2.5 %  97.5 %
## (Intercept) -3840.5763 -37.458
## F09             0.9963   1.035
## 
## [[10]]
##                 2.5 %   97.5 %
## (Intercept) -4604.174 -453.271
## F10             1.002    1.044
## 
## [[11]]
##                 2.5 %   97.5 %
## (Intercept) -5411.834 -685.394
## F11             1.006    1.054
## 
## [[12]]
##                 2.5 %   97.5 %
## (Intercept) -6074.536 -753.594
## F12             1.008    1.062
## 
## [[13]]
##                 2.5 %   97.5 %
## (Intercept) -5963.771 -215.717
## F13             1.003    1.061
## 
## [[14]]
##                  2.5 %  97.5 %
## (Intercept) -4993.5140 944.294
## F14             0.9915   1.052
## 
## [[15]]
##                  2.5 %   97.5 %
## (Intercept) -4209.8536 1835.482
## F15             0.9825    1.044
## 
## [[16]]
##                  2.5 %   97.5 %
## (Intercept) -4027.7143 2144.461
## F16             0.9792    1.042
## 
## [[17]]
##                  2.5 %  97.5 %
## (Intercept) -4951.1355 1482.34
## F17             0.9848    1.05
## 
## [[18]]
##                  2.5 %  97.5 %
## (Intercept) -6252.4539 436.772
## F18             0.9915   1.057
## 
## [[19]]
##                  2.5 %   97.5 %
## (Intercept) -6528.4706 -286.892
## F19             0.9979    1.059
## 
## [[20]]
##                 2.5 %    97.5 %
## (Intercept) -7208.571 -1397.373
## F20             1.008     1.065
## 
## [[21]]
##                 2.5 %   97.5 %
## (Intercept) -6326.161 -789.525
## F21             1.003    1.057
## 
## [[22]]
##                  2.5 %  97.5 %
## (Intercept) -5075.6206 198.556
## F22             0.9955   1.048
## 
## [[23]]
##                 2.5 %   97.5 %
## (Intercept) -5524.218 -536.416
## F23             1.003    1.056
## 
## [[24]]
##                 2.5 %    97.5 %
## (Intercept) -6135.072 -1520.843
## F24             1.014     1.066
```

Looks like it comoves well during peak hours but over corrects, greater than 1 in the other hours.


