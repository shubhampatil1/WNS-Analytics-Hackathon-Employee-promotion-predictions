#importing data files to R 
setwd('E://data science//R for analytics//hack')
test=read.csv("test_2umaH9m.csv")
train=read.csv("train_LZdllcl.csv")
library(caret)
library(gains)
library(irr)
library(e1071)
library(dplyr)
library(car)

#Basic data explorations & manupulations
summary(train)
str(train)
train$previous_year_rating=as.factor(train$previous_year_rating)

#NA values imputation based other factors 
ind=which(is.na(train$previous_year_rating))
mean(train[ind,"avg_training_score"])
tapply(train$avg_training_score,train$previous_year_rating,mean)
train[ind,'previous_year_rating']<-5
train%>%filter(education=="")%>%nrow()->ind2
mean(train[ind2,"avg_training_score"])
tapply(train$length_of_service,train$education,mean)
tapply(train$avg_training_score,train$education,mean)
train$education<-ifelse(train$education=='',"Bachelor's",as.character(train$education))
train$education<-as.factor(train$education)

#spliting data into test and train for validation of model
set.seed(100)
ind3=sample(nrow(train),nrow(train)*0.70,replace = F)
tr=train[ind3,]
ts=train[-ind3,]
dim(tr)

#model building by considering all the independent variables
mod1=glm(is_promoted~.,family = "binomial",data = tr)
summary(mod1)
#model buiding using significant  independent variables
mod2=glm(formula = is_promoted ~ department + region + education + 
      recruitment_channel + no_of_trainings + age + previous_year_rating + 
      length_of_service + KPIs_met..80. + awards_won. + avg_training_score, 
    family = "binomial", data = tr)
summary(mod2)
#dummy imputation to remove insignificant variables
dummy<-function(x){
x$region_1<-ifelse(x$region=="region_1",1,0)
x$region_10<-ifelse(x$region=="region_10",1,0)
x$region_17<-ifelse(x$region=="region_17",1,0)
x$region_22<-ifelse(x$region=="region_22",1,0)
x$region_23<-ifelse(x$region=="region_23",1,0)
x$region_25<-ifelse(x$region=="region_25",1,0)
x$region_28<-ifelse(x$region=="region_28",1,0)
x$region_30<-ifelse(x$region=="region_30",1,0)
x$region_4<-ifelse(x$region=="region_4",1,0)
x$region_7<-ifelse(x$region=="region_7",1,0)
x$region_9<-ifelse(x$region=="region_9",1,0)
x$education_BE<-ifelse(x$education=="Bachelor's",1,0)
x$education_below<-ifelse(x$education=="Below Secondary",1,0)
x$education_master<-ifelse(x$education=="Master's & above",1,0)
x$recruitment_channel_other<-ifelse(x$recruitment_channel=="other",1,0)
x$recruitment_channel_referred<-ifelse(x$recruitment_channel=="referred",1,0)
x=x[,c(-3,-4,-5,-6)]}
tr<-dummy(tr)
mod2=glm(is_promoted~tr$department+tr$no_of_trainings+tr$age+tr$previous_year_rating+tr$length_of_service+tr$KPIs_met..80.+tr$awards_won.+tr$avg_training_score+tr$region_1+tr$region_10+tr$region_17+tr$region_22+tr$region_23+tr$region_25+tr$region_28+tr$region_30+tr$region_4+tr$region_7+tr$region_9+tr$education_below+tr$education_master+tr$recruitment_channel_other+tr$recruitment_channel_referred,family = "binomial",data = tr)
summary(mod2)
mod3=glm(is_promoted~tr$department+tr$no_of_trainings+tr$age+tr$previous_year_rating+tr$length_of_service+tr$KPIs_met..80.+tr$awards_won.+tr$avg_training_score+tr$region_17+tr$region_22+tr$region_23+tr$region_25+tr$region_28+tr$region_30+tr$region_4+tr$region_7+tr$region_9+tr$education_master,family = "binomial",data = tr)
summary(mod3)
#final model with all significant variables
mod4=glm(formula = is_promoted ~ department + no_of_trainings + 
      age + previous_year_rating + length_of_service + 
      KPIs_met..80. + awards_won. + avg_training_score + 
      region_17 + region_22 + region_23 + 
      region_25 + region_28 + region_30 + region_4 + 
      region_7 + region_9 + education_master, family = "binomial", 
    data = tr)
summary(mod4)
#dummy imputaion for test data for checking an accuracy
ts<-dummy(ts)
pred<-predict(mod4,type="response",newdata = ts)
length(pred)
table(train$is_promoted)/nrow(train)
pred2<-ifelse(pred>=0.39,1,0)
pred2<-as.factor(pred2)
ts$is_promoted<-as.factor(ts$is_promoted)
kappa2(data.frame(ts$is_promoted,pred2))
#confusion matric for accuracy check
confusionMatrix(pred2,ts$is_promoted,positive="1")
#colinearity check
vif(mod4)

#applying model on main test data set
summary(test)
test$previous_year_rating=as.factor(test$previous_year_rating)
ind=which(is.na(test$previous_year_rating))
mean(test[ind,"avg_training_score"])
tapply(test$avg_training_score,test$previous_year_rating,mean)
test[ind,'previous_year_rating']<-5
test%>%filter(education=="")%>%nrow()->ind2
mean(test[ind2,"avg_training_score"])
tapply(test$length_of_service,test$education,mean)
tapply(test$avg_training_score,test$education,mean)
test$education<-ifelse(test$education=='',"Bachelor's",as.character(test$education))
test$education<-as.factor(test$education)
test<-dummy(test)
pred<-predict(mod4,type="response",newdata = test)
table(train$is_promoted)/nrow(train)
pred2<-ifelse(pred>=0.4,1,0)


