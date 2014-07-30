


OneForwardError<-function(form, nData){
  modelForm<-as.formula(form)
  model<-gls(modelForm, data=WTrendsLimited[1:nData,],na.action=na.omit,corAR1(form=~1))
  predict(model,WTrendsLimited[1+nData,])-WTrendsLimited[1+nData,as.character(modelForm[2])]
}

CVDropForward<-function(model){sd(unlist(lapply(20:(length(WTrendsLimited)-1), FUN= function(x) OneForwardError(model,x))))}

CompareSigmaCV<-function(x){
  SA<-CVDropForward(HourModelForecastCheck(x))  
  Google<-CVDropForward(HourModel(x))  
  
  (SA-Google)/(SA)
}

CVImprove<-lapply(1:24, FUN = CompareSigmaCV)
CVImprove
mean(unlist(CVImprove))

OneForwardError(HourModel(2),23)
HourModel(2)
lhs<-as.character(HourModel(2)[2])
WTrendsLimited[,lhs]

gls(HourModel(2), data=WTrendsLimited[1:23,],corAR1(form=~1),na.action=na.omit)
model<-gls(HourModel(2), data=WTrendsLimited[1:23,],corAR1(form=~1),na.action=na.omit)

predict(model,WTrendsLimited[1+23,])-WTrendsLimited[1+23,as.character(HourModel(2)[2])]
