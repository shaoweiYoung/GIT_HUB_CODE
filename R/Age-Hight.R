####加载数据####
library(readxl)
data <- read_excel("E:/ecosystem service/forest ecosystem service/代码数据/forest age5.0(导入GIS PRO 最终).xlsx")
#_______________________________________________________________________________
####提取各属数据####
df<-data[,12:13]
df <- df[complete.cases(df), ]#除去空值
