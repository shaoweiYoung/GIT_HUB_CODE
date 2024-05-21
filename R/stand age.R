####Mental分析热图+网络图####
#安装并加载 readxl 包
# install.packages("readxl")
library(readxl)
rm(list=ls())#好习惯，确保有干净的 R 环境
#相关包的载入：
library(linkET)
library(ggplot2)
library(ggtext)
library(dplyr)
#配色主题包载入：
library(cols4all)
c4a_gui()
addcol <- colorRampPalette(c("#33A02C","#FDBF6F","#E31A1C"))#选择颜色
#组合网络热图绘制


# 设置文件路径
file_path <- "F:/research data/forest age/the process data/pearson/zuizhongR.xlsx"

# 读取 Excel 文件
data1 <- read_excel(file_path)

# 打印数据的前几行以检查内容
print(head(data))

# 使用列的平均值填充缺失值
data <- data1 %>%
  mutate(across(everything(), ~ifelse(is.na(.), mean(., na.rm = TRUE), .)))



#提取age出来为Y#
age<-data[,2]
TEM<-data[,c(4:10)]
PRE<-data[,c(11:18)]
TEM_PRE<-data[,c(19:22)]
Topographic<-data[,c(23:25)]
Wuli<-data[,c(26:32,35:46)]
Huaxue<-data[,c(47:61)]
Stand<-data[,62:63]
project<-data[,c(2,9,11,21,25,42,59,62,3)]



####保存数据####
# 保存 project 数据框为 CSV 文件
write.csv(project, "F:/research data/forest age/the process data/project/project.csv", row.names = FALSE)
# # 对选定的数据进行标准化处理
# normalize <- function(x) {
#   return((x - min(x)) / (max(x) - max(x)))
# }
# 
# # 应用归一化
# age <- normalize(age1)
# TEM <- normalize(TEM1)
# PRE <- normalize(PRE1)
# TEM_PRE <- normalize(TEM_PRE1)
# Topographic <- normalize(Topographic1)
# Wuli <- normalize(Wuli1)
# Huaxue <- normalize(Huaxue1)
# Stand <- normalize(Stand1)



####TEM和PRE交换名称####
####TEM####
#计算ImmuneScore与基因的相关性系数：
cor2 <- correlate(TEM)
# cor2 <-cor (TEM, method="pearson")#进行相关性分析
corr2 <- cor2 %>% as_md_tbl()
write.csv(corr2, file = "CKD_pearson_correlate(env&env).csv", row.names = TRUE)
head(corr2)
#mantel test:
mantel <- mantel_test(age, TEM,
                      mantel_fun = 'mantel', #支持4种："mantel"使用vegan::mantel()；"mantel.randtest"使用ade4::mantel.randtest()；"mantel.rtest"使用ade4::mantel.rtest()；"mantel.partial"使用vegan::mantel.partial()
                      spec_select = list(age=1)) #这里分组为随机指定，具体实操需按自己的实际数据分组
head(mantel)
write.csv(mantel, file = "CKD_mantel_result(bio&env).csv", row.names = TRUE)
#对mantel的r和P值重新赋值（设置绘图标签）：
mantel2 <- mantel %>%    
  mutate(r = cut(r, breaks = c(-Inf, 0.1, 0.2, 0.4, Inf),
                 labels = c("< 0.1", "0.1 - 0.2", "0.2 - 0.4", ">= 0.4")),
         p = cut(p, breaks = c(-Inf, 0.001, 0.01, 0.05, Inf),
                 labels = c("<0.001", "0.001-0.01", "0.01-0.05", ">= 0.05")))
head(mantel2)
#首先，绘制相关性热图(和上文相同):
p4 <- qcorrplot(cor2,
                grid_col = "grey50",
                grid_size = 0.2,
                type = "upper",
                diag = FALSE) +
  geom_square() +
  scale_fill_gradientn(colours = c4a('carto.tropic',30),
                       limits = c(-1, 1))
p4



#添加显著性标签：
p5 <- p4 +
  geom_mark(size = 4,
            only_mark = T,
            sig_level = c(0.05, 0.01, 0.001),
            sig_thres = 0.05,
            colour = 'white')
p5




#在相关性热图上添加mantel连线：
p6 <- p5 +
  geom_couple(data = mantel2,
              aes(colour = p, size = r),
              curvature = nice_curvature())
p6



#继续美化连线：
p7 <- p6 +
  scale_size_manual(values = c(1, 2, 3, 4)) + #连线粗细
  scale_colour_manual(values = c4a('hcl.set3',4)) + #连线配色
  #修改图例：
  guides(size = guide_legend(title = "Mantel's r",    
                             override.aes = list(colour = "grey35"),
                             order = 2),
         colour = guide_legend(title = "Mantel's p",
                               override.aes = list(size = 3),
                               order = 1),
         fill = guide_colorbar(title = "Pearson's r", order = 3))
p7





####PRE####
#计算ImmuneScore与基因的相关性系数：
cor2 <- correlate(PRE)
# cor2 <-cor (PRE, method="pearson")#进行相关性分析
corr2 <- cor2 %>% as_md_tbl()
write.csv(corr2, file = "CKD_pearson_correlate(env&env).csv", row.names = TRUE)
head(corr2)
#mantel test:
mantel <- mantel_test(age, PRE,
                      mantel_fun = 'mantel', #支持4种："mantel"使用vegan::mantel()；"mantel.randtest"使用ade4::mantel.randtest()；"mantel.rtest"使用ade4::mantel.rtest()；"mantel.partial"使用vegan::mantel.partial()
                      spec_select = list(age=1)) #这里分组为随机指定，具体实操需按自己的实际数据分组
head(mantel)
write.csv(mantel, file = "CKD_mantel_result(bio&env).csv", row.names = TRUE)
#对mantel的r和P值重新赋值（设置绘图标签）：
mantel2 <- mantel %>%    
  mutate(r = cut(r, breaks = c(-Inf, 0.1, 0.2, 0.4, Inf),
                 labels = c("< 0.1", "0.1 - 0.2", "0.2 - 0.4", ">= 0.4")),
         p = cut(p, breaks = c(-Inf, 0.001, 0.01, 0.05, Inf),
                 labels = c("<0.001", "0.001-0.01", "0.01-0.05", ">= 0.05")))
head(mantel2)
#首先，绘制相关性热图(和上文相同):
p4 <- qcorrplot(cor2,
                grid_col = "grey50",
                grid_size = 0.2,
                type = "upper",
                diag = FALSE) +
  geom_square() +
  scale_fill_gradientn(colours = c4a('carto.tropic',30),
                       limits = c(-1, 1))
p4



#添加显著性标签：
p5 <- p4 +
  geom_mark(size = 4,
            only_mark = T,
            sig_level = c(0.05, 0.01, 0.001),
            sig_thres = 0.05,
            colour = 'white')
p5




#在相关性热图上添加mantel连线：
p6 <- p5 +
  geom_couple(data = mantel2,
              aes(colour = p, size = r),
              curvature = nice_curvature())
p6



#继续美化连线：
p7 <- p6 +
  scale_size_manual(values = c(1, 2, 3, 4)) + #连线粗细
  scale_colour_manual(values = c4a('hcl.set3',4)) + #连线配色
  #修改图例：
  guides(size = guide_legend(title = "Mantel's r",    
                             override.aes = list(colour = "grey35"),
                             order = 2),
         colour = guide_legend(title = "Mantel's p",
                               override.aes = list(size = 3),
                               order = 1),
         fill = guide_colorbar(title = "Pearson's r", order = 3))
p7



####TEM_PRE####
#计算ImmuneScore与基因的相关性系数：
cor2 <- correlate(TEM_PRE)
# cor2 <-cor (TEM_PRE, method="pearson")#进行相关性分析
corr2 <- cor2 %>% as_md_tbl()
write.csv(corr2, file = "CKD_pearson_correlate(env&env).csv", row.names = TRUE)
head(corr2)
#mantel test:
mantel <- mantel_test(age, TEM_PRE,
                      mantel_fun = 'mantel', #支持4种："mantel"使用vegan::mantel()；"mantel.randtest"使用ade4::mantel.randtest()；"mantel.rtest"使用ade4::mantel.rtest()；"mantel.partial"使用vegan::mantel.partial()
                      spec_select = list(age=1)) #这里分组为随机指定，具体实操需按自己的实际数据分组
head(mantel)
write.csv(mantel, file = "CKD_mantel_result(bio&env).csv", row.names = TRUE)
#对mantel的r和P值重新赋值（设置绘图标签）：
mantel2 <- mantel %>%    
  mutate(r = cut(r, breaks = c(-Inf, 0.1, 0.2, 0.4, Inf),
                 labels = c("< 0.1", "0.1 - 0.2", "0.2 - 0.4", ">= 0.4")),
         p = cut(p, breaks = c(-Inf, 0.001, 0.01, 0.05, Inf),
                 labels = c("<0.001", "0.001-0.01", "0.01-0.05", ">= 0.05")))
head(mantel2)
#首先，绘制相关性热图(和上文相同):
p4 <- qcorrplot(cor2,
                grid_col = "grey50",
                grid_size = 0.2,
                type = "upper",
                diag = FALSE) +
  geom_square() +
  scale_fill_gradientn(colours = c4a('carto.tropic',30),
                       limits = c(-1, 1))
p4



#添加显著性标签：
p5 <- p4 +
  geom_mark(size = 4,
            only_mark = T,
            sig_level = c(0.05, 0.01, 0.001),
            sig_thres = 0.05,
            colour = 'white')
p5




#在相关性热图上添加mantel连线：
p6 <- p5 +
  geom_couple(data = mantel2,
              aes(colour = p, size = r),
              curvature = nice_curvature())
p6



#继续美化连线：
p7 <- p6 +
  scale_size_manual(values = c(1, 2, 3, 4)) + #连线粗细
  scale_colour_manual(values = c4a('hcl.set3',4)) + #连线配色
  #修改图例：
  guides(size = guide_legend(title = "Mantel's r",    
                             override.aes = list(colour = "grey35"),
                             order = 2),
         colour = guide_legend(title = "Mantel's p",
                               override.aes = list(size = 3),
                               order = 1),
         fill = guide_colorbar(title = "Pearson's r", order = 3))
p7





####Topographic####
#计算ImmuneScore与基因的相关性系数：
cor2 <- correlate(Topographic)
# cor2 <-cor (PRE, method="pearson")#进行相关性分析
corr2 <- cor2 %>% as_md_tbl()
write.csv(corr2, file = "CKD_pearson_correlate(env&env).csv", row.names = TRUE)
head(corr2)
#mantel test:
mantel <- mantel_test(age, Topographic,
                      mantel_fun = 'mantel', #支持4种："mantel"使用vegan::mantel()；"mantel.randtest"使用ade4::mantel.randtest()；"mantel.rtest"使用ade4::mantel.rtest()；"mantel.partial"使用vegan::mantel.partial()
                      spec_select = list(age=1)) #这里分组为随机指定，具体实操需按自己的实际数据分组
head(mantel)
write.csv(mantel, file = "CKD_mantel_result(bio&env).csv", row.names = TRUE)
#对mantel的r和P值重新赋值（设置绘图标签）：
mantel2 <- mantel %>%    
  mutate(r = cut(r, breaks = c(-Inf, 0.1, 0.2, 0.4, Inf),
                 labels = c("< 0.1", "0.1 - 0.2", "0.2 - 0.4", ">= 0.4")),
         p = cut(p, breaks = c(-Inf, 0.001, 0.01, 0.05, Inf),
                 labels = c("<0.001", "0.001-0.01", "0.01-0.05", ">= 0.05")))
head(mantel2)
#首先，绘制相关性热图(和上文相同):
p4 <- qcorrplot(cor2,
                grid_col = "grey50",
                grid_size = 0.2,
                type = "upper",
                diag = FALSE) +
  geom_square() +
  scale_fill_gradientn(colours = c4a('carto.tropic',30),
                       limits = c(-1, 1))
p4



#添加显著性标签：
p5 <- p4 +
  geom_mark(size = 4,
            only_mark = T,
            sig_level = c(0.05, 0.01, 0.001),
            sig_thres = 0.05,
            colour = 'white')
p5




#在相关性热图上添加mantel连线：
p6 <- p5 +
  geom_couple(data = mantel2,
              aes(colour = p, size = r),
              curvature = nice_curvature())
p6



#继续美化连线：
p7 <- p6 +
  scale_size_manual(values = c(1, 2, 3, 4)) + #连线粗细
  scale_colour_manual(values = c4a('hcl.set3',4)) + #连线配色
  #修改图例：
  guides(size = guide_legend(title = "Mantel's r",    
                             override.aes = list(colour = "grey35"),
                             order = 2),
         colour = guide_legend(title = "Mantel's p",
                               override.aes = list(size = 3),
                               order = 1),
         fill = guide_colorbar(title = "Pearson's r", order = 3))
p7




####Wuli####
#计算ImmuneScore与基因的相关性系数：
cor2 <- correlate(Wuli)
# cor2 <-cor (PRE, method="pearson")#进行相关性分析
corr2 <- cor2 %>% as_md_tbl()
write.csv(corr2, file = "CKD_pearson_correlate(env&env).csv", row.names = TRUE)
head(corr2)
#mantel test:
mantel <- mantel_test(age, Wuli,
                      mantel_fun = 'mantel', #支持4种："mantel"使用vegan::mantel()；"mantel.randtest"使用ade4::mantel.randtest()；"mantel.rtest"使用ade4::mantel.rtest()；"mantel.partial"使用vegan::mantel.partial()
                      spec_select = list(age=1)) #这里分组为随机指定，具体实操需按自己的实际数据分组
head(mantel)
write.csv(mantel, file = "CKD_mantel_result(bio&env).csv", row.names = TRUE)
#对mantel的r和P值重新赋值（设置绘图标签）：
mantel2 <- mantel %>%    
  mutate(r = cut(r, breaks = c(-Inf, 0.1, 0.2, 0.4, Inf),
                 labels = c("< 0.1", "0.1 - 0.2", "0.2 - 0.4", ">= 0.4")),
         p = cut(p, breaks = c(-Inf, 0.001, 0.01, 0.05, Inf),
                 labels = c("<0.001", "0.001-0.01", "0.01-0.05", ">= 0.05")))
head(mantel2)
#首先，绘制相关性热图(和上文相同):
p4 <- qcorrplot(cor2,
                grid_col = "grey50",
                grid_size = 0.2,
                type = "upper",
                diag = FALSE) +
  geom_square() +
  scale_fill_gradientn(colours = c4a('carto.tropic',30),
                       limits = c(-1, 1))
p4



#添加显著性标签：
p5 <- p4 +
  geom_mark(size = 4,
            only_mark = T,
            sig_level = c(0.05, 0.01, 0.001),
            sig_thres = 0.05,
            colour = 'black')
p5




#在相关性热图上添加mantel连线：
p6 <- p5 +
  geom_couple(data = mantel2,
              aes(colour = p, size = r),
              curvature = nice_curvature())
p6



#继续美化连线：
p7 <- p6 +
  scale_size_manual(values = c(1, 2, 3, 4)) + #连线粗细
  scale_colour_manual(values = c4a('hcl.set3',4)) + #连线配色
  #修改图例：
  guides(size = guide_legend(title = "Mantel's r",    
                             override.aes = list(colour = "grey35"),
                             order = 2),
         colour = guide_legend(title = "Mantel's p",
                               override.aes = list(size = 3),
                               order = 1),
         fill = guide_colorbar(title = "Pearson's r", order = 3))
p7





####Huaxue####
#计算ImmuneScore与基因的相关性系数：
cor2 <- correlate(Huaxue)
# cor2 <-cor (PRE, method="pearson")#进行相关性分析
corr2 <- cor2 %>% as_md_tbl()
write.csv(corr2, file = "CKD_pearson_correlate(env&env).csv", row.names = TRUE)
head(corr2)
#mantel test:
mantel <- mantel_test(age, Huaxue,
                      mantel_fun = 'mantel', #支持4种："mantel"使用vegan::mantel()；"mantel.randtest"使用ade4::mantel.randtest()；"mantel.rtest"使用ade4::mantel.rtest()；"mantel.partial"使用vegan::mantel.partial()
                      spec_select = list(age=1)) #这里分组为随机指定，具体实操需按自己的实际数据分组
head(mantel)
write.csv(mantel, file = "CKD_mantel_result(bio&env).csv", row.names = TRUE)
#对mantel的r和P值重新赋值（设置绘图标签）：
mantel2 <- mantel %>%    
  mutate(r = cut(r, breaks = c(-Inf, 0.1, 0.2, 0.4, Inf),
                 labels = c("< 0.1", "0.1 - 0.2", "0.2 - 0.4", ">= 0.4")),
         p = cut(p, breaks = c(-Inf, 0.001, 0.01, 0.05, Inf),
                 labels = c("<0.001", "0.001-0.01", "0.01-0.05", ">= 0.05")))
head(mantel2)
#首先，绘制相关性热图(和上文相同):
p4 <- qcorrplot(cor2,
                grid_col = "grey50",
                grid_size = 0.2,
                type = "upper",
                diag = FALSE) +
  geom_square() +
  scale_fill_gradientn(colours = c4a('carto.tropic',30),
                       limits = c(-1, 1))
p4



#添加显著性标签：
p5 <- p4 +
  geom_mark(size = 4,
            only_mark = T,
            sig_level = c(0.05, 0.01, 0.001),
            sig_thres = 0.05,
            colour = 'black')
p5




#在相关性热图上添加mantel连线：
p6 <- p5 +
  geom_couple(data = mantel2,
              aes(colour = p, size = r),
              curvature = nice_curvature())
p6



#继续美化连线：
p7 <- p6 +
  scale_size_manual(values = c(1, 2, 3, 4)) + #连线粗细
  scale_colour_manual(values = c4a('hcl.set3',4)) + #连线配色
  #修改图例：
  guides(size = guide_legend(title = "Mantel's r",    
                             override.aes = list(colour = "grey35"),
                             order = 2),
         colour = guide_legend(title = "Mantel's p",
                               override.aes = list(size = 3),
                               order = 1),
         fill = guide_colorbar(title = "Pearson's r", order = 3))
p7





####Stand####
#计算ImmuneScore与基因的相关性系数：
cor2 <- correlate(Stand)
# cor2 <-cor (PRE, method="pearson")#进行相关性分析
corr2 <- cor2 %>% as_md_tbl()
write.csv(corr2, file = "CKD_pearson_correlate(env&env).csv", row.names = TRUE)
head(corr2)
#mantel test:
mantel <- mantel_test(age, Stand,
                      mantel_fun = 'mantel', #支持4种："mantel"使用vegan::mantel()；"mantel.randtest"使用ade4::mantel.randtest()；"mantel.rtest"使用ade4::mantel.rtest()；"mantel.partial"使用vegan::mantel.partial()
                      spec_select = list(age=1)) #这里分组为随机指定，具体实操需按自己的实际数据分组
head(mantel)
write.csv(mantel, file = "CKD_mantel_result(bio&env).csv", row.names = TRUE)
#对mantel的r和P值重新赋值（设置绘图标签）：
mantel2 <- mantel %>%    
  mutate(r = cut(r, breaks = c(-Inf, 0.1, 0.2, 0.4, Inf),
                 labels = c("< 0.1", "0.1 - 0.2", "0.2 - 0.4", ">= 0.4")),
         p = cut(p, breaks = c(-Inf, 0.001, 0.01, 0.05, Inf),
                 labels = c("<0.001", "0.001-0.01", "0.01-0.05", ">= 0.05")))
head(mantel2)
#首先，绘制相关性热图(和上文相同):
p4 <- qcorrplot(cor2,
                grid_col = "grey50",
                grid_size = 0.2,
                type = "upper",
                diag = FALSE) +
  geom_square() +
  scale_fill_gradientn(colours = c4a('carto.tropic',30),
                       limits = c(-1, 1))
p4



#添加显著性标签：
p5 <- p4 +
  geom_mark(size = 4,
            only_mark = T,
            sig_level = c(0.05, 0.01, 0.001),
            sig_thres = 0.05,
            colour = 'white')
p5




#在相关性热图上添加mantel连线：
p6 <- p5 +
  geom_couple(data = mantel2,
              aes(colour = p, size = r),
              curvature = nice_curvature())
p6



#继续美化连线：
p7 <- p6 +
  scale_size_manual(values = c(1, 2, 3, 4)) + #连线粗细
  scale_colour_manual(values = c4a('hcl.set3',4)) + #连线配色
  #修改图例：
  guides(size = guide_legend(title = "Mantel's r",    
                             override.aes = list(colour = "grey35"),
                             order = 2),
         colour = guide_legend(title = "Mantel's p",
                               override.aes = list(size = 3),
                               order = 1),
         fill = guide_colorbar(title = "Pearson's r", order = 3))
p7




####贝叶斯优化调参####
# 加载所需的库
library(rstan)
library(dplyr)
library(readr)
library(caret)  # 用于数据分区

# 读取数据
df <- read_csv("F:/research data/forest age/the process data/project/project.csv")

# 分区数据
set.seed(123)  # 确保结果的可重复性
training_indices <- createDataPartition(df$A, p = 0.7, list = FALSE)
train_data <- df[training_indices, ]
test_data <- df[-training_indices, ]

# 提取训练和测试数据中的变量
variables <- c("H", "P", "TE", "B", "T", "SP", "SC", "S", "A")
train_data <- train_data[variables]
test_data <- test_data[variables]

# 定义Stan模型
stan_code <- '
data {
  int<lower=0> N;  // 数据点数量
  vector[N] H;
  vector[N] P;
  vector[N] TE;
  vector[N] B;
  vector[N] T;
  vector[N] SP;
  vector[N] SC;
  vector[N] S;
  vector[N] A;
}
parameters {
  real a;
  real b;
  real c;
  real d;
  real f;
  real g;
  real h;
  real i;
  real<lower=0> sigma;  // 误差项标准差
}
model {
  for (n in 1:N) {
    A[n] ~ normal(exp((log(H[n]) - log(a)) / (b*TE[n] + c*P[n] + d*B[n] + f*T[n] + g*SP[n] + h*SC[n] + i*S[n])), sigma);
  }
}
'

# 编译模型
stan_model <- stan_model(model_code = stan_code)

# 准备数据传递到Stan
stan_data_train <- list(N = nrow(train_data), H = train_data$H, P = train_data$P, TE = train_data$TE, B = train_data$B, T = train_data$T, SP = train_data$SP, SC = train_data$SC, S = train_data$S, A = train_data$A)

# 运行MCMC
# fit <- sampling(stan_model, data = stan_data_train, iter = 3000, chains = 4, cores = 2)
# 运行MCMC，增加迭代次数和调整参数
fit <- sampling(stan_model, 
                data = stan_data_train, 
                iter = 4000, 
                warmup = 2000, 
                chains = 4, 
                cores = 2, 
                control = list(adapt_delta = 0.95, max_treedepth = 15)
)
# 提取并计算预测值
posterior_samples <- extract(fit)
a_mean <- mean(posterior_samples$a)
b_mean <- mean(posterior_samples$b)
c_mean <- mean(posterior_samples$c)
d_mean <- mean(posterior_samples$d)
f_mean <- mean(posterior_samples$f)
g_mean <- mean(posterior_samples$g)
h_mean <- mean(posterior_samples$h)
i_mean <- mean(posterior_samples$i)
predicted_A <- exp((log(test_data$H) - log(a_mean)) / (b_mean*test_data$TE + c_mean*test_data$P + d_mean*test_data$B + f_mean*test_data$T + g_mean*test_data$SP + h_mean*test_data$SC + i_mean*test_data$S))

# 计算模型评估指标
r2 <- cor(test_data$A, predicted_A)^2
rmse <- sqrt(mean((test_data$A - predicted_A)^2))
mae <- mean(abs(test_data$A - predicted_A))
me <- mean(test_data$A - predicted_A)

# 打印结果
cat("R²:", r2, "\n")
cat("RMSE:", rmse, "\n")
cat("MAE:", mae, "\n")
cat("ME:", me, "\n")


####贝叶斯2####
library(rBayesianOptimization)
library(dplyr)
library(readr)
library(caret)  # 数据分割

# 读取数据
df <- read_csv("F:/research data/forest age/the process data/project/project.csv")

# 数据分割为训练集和测试集
set.seed(123)  # 确保可复现性
training_indices <- createDataPartition(df$A, p = 0.7, list = FALSE)
train_data <- df[training_indices, ]
test_data <- df[-training_indices, ]

# 提取训练和测试数据的相关变量
variables <- c("H", "P", "TE", "B", "T", "SP", "SC", "S", "A")
train_data <- train_data[variables]
test_data <- test_data[variables]

# 定义贝叶斯优化的目标函数
objective_function <- function(a, b, c, d, f, g, h, i) {
  if (any(c(a, b, c, d, f, g, h, i) <= 0)) return(list(Score = -Inf))  # 确保所有参数均为正数
  predictions <- exp((log(train_data$H) - log(a)) / (b * train_data$TE + c * train_data$P + d * train_data$B + f * train_data$T + g * train_data$SP + h * train_data$SC + i * train_data$S))
  mse <- mean((predictions - train_data$A)^2)
  return(list(Score = -mse))  # 只返回分数
}

# 参数界限设置
bounds <- list(a = c(0.1, 100), b = c(0.1, 100), c = c(0.1, 100), d = c(0.1, 100), f = c(0.1, 100), g = c(0.1, 100), h = c(0.1, 100), i = c(0.1, 100))

# 开始贝叶斯优化，包括循环处理
achieve_goal <- FALSE
n_init_points <- 50
n_iter <- 150
repeat {
  bayes_opt_result <- BayesianOptimization(
    objective_function,
    bounds = bounds,
    init_points = n_init_points,
    n_iter = n_iter,
    acq = "ucb",
    kappa = 2.576,
    verbose = TRUE
  )
  
  # 转换优化参数为数据框
  optimized_params <- as.data.frame(t(bayes_opt_result$Best_Par))
  
  # 使用优化后的参数进行测试集预测
  predicted_A <- exp((log(test_data$H) - log(optimized_params$a)) / (optimized_params$b * test_data$TE + optimized_params$c * test_data$P + optimized_params$d * test_data$B + optimized_params$f * test_data$T + optimized_params$g * test_data$SP + optimized_params$h * test_data$SC + optimized_params$i * test_data$S))
  
  # 计算模型评估指标
  r2 <- cor(test_data$A, predicted_A)^2
  rmse <- sqrt(mean((test_data$A - predicted_A)^2))
  mae <- mean(abs(test_data$A - predicted_A))
  me <- mean(test_data$A - predicted_A)
  
  if (r2 > 0.8) {
    achieve_goal <- TRUE
    break
  }
  
  # 调整初始点和迭代次数
  n_init_points <- 1
  n_iter <- 100
}

# 打印结果
cat("R²:", r2, "\n")
cat("RMSE:", rmse, "\n")
cat("MAE:", mae, "\n")
cat("ME:", me, "\n")
cat("Final optimized parameters:\n")





####梯度下降参数优化####
# 加载必要的库
library(dplyr)
library(ggplot2) # 如果需要进行数据可视化

# 读取数据
data <- read.csv("F:/research data/forest age/the process data/project/project.csv")

# 数据预处理：分割为训练集和测试集
set.seed(123)  # 设置随机种子以确保可重复性
train_indices <- sample(1:nrow(data), 0.7 * nrow(data))
train_data <- data[train_indices, ]
test_data <- data[-train_indices, ]

# 定义模型的损失函数
loss_function <- function(params, data) {
  a <- params[1]
  b <- params[2]
  c <- params[3]
  d <- params[4]
  f <- params[5]
  g <- params[6]
  h <- params[7]
  i <- params[8]
  
  predictions <- exp((log(data$H) - log(a)) / (b*data$TE + c*data$P + d*data$B + f*data$T + g*data$SP + h*data$SC + i*data$S))
  mean((predictions - data$A)^2)  # 平方误差损失
}

# 梯度下降算法
gradient_descent <- function(params, data, lr = 1e-3, max_iter = 1000, tolerance = 1e-6) {
  for (iter in 1:max_iter) {
    grads <- numeric(length(params))
    
    # 简单的数值梯度计算方法
    for (j in 1:length(params)) {
      # 微小的参数扰动
      perturb <- numeric(length(params))
      perturb[j] <- 1e-8
      
      loss1 <- loss_function(params - perturb, data)
      loss2 <- loss_function(params + perturb, data)
      
      # 计算梯度
      grads[j] <- (loss2 - loss1) / (2 * 1e-8)
    }
    
    # 更新参数
    params <- params - lr * grads
    
    # 检查收敛性
    if (max(abs(grads)) < tolerance) {
      break
    }
  }
  return(params)
}

# 初始化参数
initial_params <- rep(1, 8)

# 执行梯度下降优化
optimized_params <- gradient_descent(initial_params, train_data)

# 使用优化后的参数进行预测
predicted_values <- exp((log(test_data$H) - log(optimized_params[1])) / (optimized_params[2]*test_data$TE + optimized_params[3]*test_data$P + optimized_params[4]*test_data$B + optimized_params[5]*test_data$T + optimized_params[6]*test_data$SP + optimized_params[7]*test_data$SC + optimized_params[8]*test_data$S))

# 计算模型评估指标
r2_value <- cor(predicted_values, test_data$A)^2
rmse_value <- sqrt(mean((predicted_values - test_data$A)^2))
mae_value <- mean(abs(predicted_values - test_data$A))
me_value <- mean(predicted_values - test_data$A)

# 输出结果
cat("Optimized Parameters: ", optimized_params, "\n")
cat("R²: ", r2_value, "\n")
cat("RMSE: ", rmse_value, "\n")
cat("MAE: ", mae_value, "\n")
cat("ME: ", me_value, "\n")



####进化算法优化参数####
# 加载必要的库
library(GA)          # 用于实施遗传算法
library(data.table)  # 数据操作
library(Metrics)     # 性能评估指标
library(dplyr)       # 数据操作

# 读取数据
data <- fread("F:/research data/forest age/the process data/project/project.csv")

# 数据预处理：分割为训练集和测试集
set.seed(123)  # 设置种子以确保结果可重复性
training_ratio <- 0.7
train_indices <- sample(seq_len(nrow(data)), size = floor(training_ratio * nrow(data)))
train_data <- data[train_indices, ]
test_data <- data[-train_indices, ]

# 定义模型公式
exp_model <- function(params, data) {
  a <- params[1]
  b <- params[2]
  c <- params[3]
  d <- params[4]
  f <- params[5]
  g <- params[6]
  h <- params[7]
  i <- params[8]
  
  # 使用安全的指数计算，限制结果的范围，以防止溢出
  result <- a * pmin(exp(pmin(b*data$TE + c*data$P + d*data$B + f*data$T + g*data$SP + h*data$SC + i*data$S, 100)), 1e100)
  return(result)
}

# 定义损失函数
fitness_function <- function(params) {
  predicted_values <- exp_model(params, train_data)
  mse <- mean((predicted_values - train_data$A)^2)
  if (is.nan(mse) || is.infinite(mse)) {
    cat("Invalid MSE for params:", params, "\n")  # 日志输出问题参数
    return(-Inf)  # 返回极小值以避免无效计算影响遗传算法
  }
  return(-mse)  # 使用MSE作为损失函数
}

# 执行遗传算法
ga_result <- ga(type = "real-valued", 
                fitness = fitness_function, 
                popSize = 50,         # 种群大小
                maxiter = 100,        # 最大迭代次数
                run = 100,            # 运行次数
                lower = rep(0.1, 8),  # 参数最小值
                upper = rep(10, 8),   # 参数最大值
                monitor = function(obj) {
                  if (all(is.finite(obj@fitness))) {
                    plot(obj@fitness, type="l", main="Best Fitness", xlab="Generation", ylab="Fitness")
                  } else {
                    cat("Warning: Fitness values contain non-finite numbers.\n")
                  }
                })  # 监控

# 查看优化结果
cat("Best Parameters Found:\n")
print(ga_result@solution)

# 使用优化后的参数进行预测
optimized_params <- ga_result@solution

predicted_values <- exp_model(optimized_params, test_data)

# 检查预测值和实际值的标准差
sd_predicted <- sd(predicted_values)
sd_actual <- sd(test_data$A)

if (sd_predicted == 0 || sd_actual == 0) {
  cat("无法计算R²: 预测值或实际值的标准差为零。\n")
} else {
  # 计算相关系数和R²值
  r2_value <- cor(predicted_values, test_data$A)^2
  cat("R²: ", r2_value, "\n")
}

# 计算其他性能指标
rmse_value <- sqrt(mean((predicted_values - test_data$A)^2))
mae_value <- mean(abs(predicted_values - test_data$A))
me_value <- mean(predicted_values - test_data$A)

# 输出结果
cat("R²: ", r2_value, "\n")
cat("RMSE: ", rmse_value, "\n")
cat("MAE: ", mae_value, "\n")
cat("ME: ", me_value, "\n")

