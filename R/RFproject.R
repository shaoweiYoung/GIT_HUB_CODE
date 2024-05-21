#导入数据
setwd("I:/ecosystem service/forest ecosystem service/paper datas/cs")#设置工作路径
boston <- read.csv(file.choose())#加载数据
as.data.frame(boston)#查看数据
dat<-read.csv("I:/ecosystem service/forest ecosystem service/paper datas/cs/CRFPOP.CSV",header = T)#加载CSV数据
#划分训练、测试集
library(tibble)
trainlist<-createDataPartition(dat$人口密度.人.km2.,p=0.8,list=FALSE)
trainset<-iris[trainlist,]
testset<-iris[-trainlist,]