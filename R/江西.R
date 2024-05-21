####加载江西数据####
library(readxl)
# 读取Excel文件中的数据（假设你想要读取名为"wine.class"的工作表）
data <- read_excel("F:/research data/jiangxi/fishnet_10km_points_TableToExcel2.0.xlsx")
data <- read_excel("F:/research data/jiangxi/RPCA1.0.xlsx")
data <- read_excel("F:/research data/jiangxi/PCA1andGPPWRA.xlsx")



library(zoo)
data2 <- na.aggregate(data2, FUN = mean)
GPP <- na.aggregate(GPP, FUN = mean)


####1.亚热带落叶阔叶林1-13行####
data1 <- data[1:13,]

# 提取降水数据5-12列
data2 <- data1[, 5:12]
# 加载所需的库
library(Rmisc)
library(corrplot)
library(RColorBrewer)
####降水mantel test相关性####
library(readxl)
# rm(list=ls())#好习惯，确保有干净的 R 环境
#相关包的载入：
library(linkET)
library(ggplot2)
library(ggtext)
library(dplyr)
#配色主题包载入：
library(cols4all)
c4a_gui()
addcol <- colorRampPalette(c("#33A02C","#FDBF6F","#E31A1C"))#选择颜色
cor2 <- correlate(data2)
# cor2 <-cor (TEM, method="pearson")#进行相关性分析
corr2 <- cor2 %>% as_md_tbl()
write.csv(corr2, file = "CKD_pearson_correlate(env&env).csv", row.names = TRUE)
head(corr2)
#mantel test:
mantel <- mantel_test(GPP, data2,
                      mantel_fun = 'mantel', #支持4种："mantel"使用vegan::mantel()；"mantel.randtest"使用ade4::mantel.randtest()；"mantel.rtest"使用ade4::mantel.rtest()；"mantel.partial"使用vegan::mantel.partial()
                      spec_select = list(GPP=1)) #这里分组为随机指定，具体实操需按自己的实际数据分组
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





####温度mantel test相关性####
data2 <- data1[, 13:23]
addcol <- colorRampPalette(c("#33A02C","#FDBF6F","#E31A1C"))#选择颜色
cor2 <- correlate(data2)
# cor2 <-cor (TEM, method="pearson")#进行相关性分析
corr2 <- cor2 %>% as_md_tbl()
write.csv(corr2, file = "CKD_pearson_correlate(env&env).csv", row.names = TRUE)
head(corr2)
#mantel test:
mantel <- mantel_test(GPP, data2,
                      mantel_fun = 'mantel', #支持4种："mantel"使用vegan::mantel()；"mantel.randtest"使用ade4::mantel.randtest()；"mantel.rtest"使用ade4::mantel.rtest()；"mantel.partial"使用vegan::mantel.partial()
                      spec_select = list(GPP=1)) #这里分组为随机指定，具体实操需按自己的实际数据分组
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







####林分mantel test相关性####
data2 <- data1[, 24:26]
# 处理可能存在的缺失值
library(zoo)
data2 <- na.aggregate(data2, FUN = mean)
addcol <- colorRampPalette(c("#33A02C","#FDBF6F","#E31A1C"))#选择颜色
cor2 <- correlate(data2)
# cor2 <-cor (TEM, method="pearson")#进行相关性分析
corr2 <- cor2 %>% as_md_tbl()
write.csv(corr2, file = "CKD_pearson_correlate(env&env).csv", row.names = TRUE)
head(corr2)
#mantel test:
mantel <- mantel_test(GPP, data2,
                      mantel_fun = 'mantel', #支持4种："mantel"使用vegan::mantel()；"mantel.randtest"使用ade4::mantel.randtest()；"mantel.rtest"使用ade4::mantel.rtest()；"mantel.partial"使用vegan::mantel.partial()
                      spec_select = list(GPP=1)) #这里分组为随机指定，具体实操需按自己的实际数据分组
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



####地形mantel test相关性####
# 提取地形数据27-29列
data2 <- data1[, 27:29]
addcol <- colorRampPalette(c("#33A02C","#FDBF6F","#E31A1C"))#选择颜色
cor2 <- correlate(data2)
# cor2 <-cor (TEM, method="pearson")#进行相关性分析
corr2 <- cor2 %>% as_md_tbl()
write.csv(corr2, file = "CKD_pearson_correlate(env&env).csv", row.names = TRUE)
head(corr2)
#mantel test:
mantel <- mantel_test(GPP, data2,
                      mantel_fun = 'mantel', #支持4种："mantel"使用vegan::mantel()；"mantel.randtest"使用ade4::mantel.randtest()；"mantel.rtest"使用ade4::mantel.rtest()；"mantel.partial"使用vegan::mantel.partial()
                      spec_select = list(GPP=1)) #这里分组为随机指定，具体实操需按自己的实际数据分组
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
  scale_fill_gradientn(colours = c4a('carto.tropic',1),
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
####土壤物理mantel test相关性####
# 提取土壤物理数据30-48列
data2 <- data1[, 30:48]
addcol <- colorRampPalette(c("#33A02C","#FDBF6F","#E31A1C"))#选择颜色
cor2 <- correlate(data2)
# cor2 <-cor (TEM, method="pearson")#进行相关性分析
corr2 <- cor2 %>% as_md_tbl()
write.csv(corr2, file = "CKD_pearson_correlate(env&env).csv", row.names = TRUE)
head(corr2)
#mantel test:
mantel <- mantel_test(GPP, data2,
                      mantel_fun = 'mantel', #支持4种："mantel"使用vegan::mantel()；"mantel.randtest"使用ade4::mantel.randtest()；"mantel.rtest"使用ade4::mantel.rtest()；"mantel.partial"使用vegan::mantel.partial()
                      spec_select = list(GPP=1)) #这里分组为随机指定，具体实操需按自己的实际数据分组
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
####土壤化学mantel test相关性####
# 提取土壤化学数据49-63列
data2 <- data1[, 49:63]
addcol <- colorRampPalette(c("#33A02C","#FDBF6F","#E31A1C"))#选择颜色
cor2 <- correlate(data2)
# cor2 <-cor (TEM, method="pearson")#进行相关性分析
corr2 <- cor2 %>% as_md_tbl()
write.csv(corr2, file = "CKD_pearson_correlate(env&env).csv", row.names = TRUE)
head(corr2)
#mantel test:
mantel <- mantel_test(GPP, data2,
                      mantel_fun = 'mantel', #支持4种："mantel"使用vegan::mantel()；"mantel.randtest"使用ade4::mantel.randtest()；"mantel.rtest"使用ade4::mantel.rtest()；"mantel.partial"使用vegan::mantel.partial()
                      spec_select = list(GPP=1)) #这里分组为随机指定，具体实操需按自己的实际数据分组
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


####2.亚热带落叶阔叶林1-13行####
# 提取14-312行的数据
data1 <- data[14:312,]
GPP<-data1[,4]
# 提取降水数据的5-12列
data2 <- data1[, 5:12]
library(zoo)
data2 <- na.aggregate(data2, FUN = mean)
# 加载所需的库
library(Rmisc)
library(corrplot)
library(RColorBrewer)
####降水mantel test相关性####
library(readxl)
# rm(list=ls())#好习惯，确保有干净的 R 环境
#相关包的载入：
library(linkET)
library(ggplot2)
library(ggtext)
library(dplyr)
#配色主题包载入：
library(cols4all)
c4a_gui()
library(zoo)
GPP <- na.aggregate(GPP, FUN = mean)
addcol <- colorRampPalette(c("#33A02C","#FDBF6F","#E31A1C"))#选择颜色
cor2 <- correlate(data2)
# cor2 <-cor (TEM, method="pearson")#进行相关性分析
corr2 <- cor2 %>% as_md_tbl()
write.csv(corr2, file = "CKD_pearson_correlate(env&env).csv", row.names = TRUE)
head(corr2)
#mantel test:
str(GPP)
mantel <- mantel_test(GPP, data2,
                      mantel_fun = 'mantel', #支持4种："mantel"使用vegan::mantel()；"mantel.randtest"使用ade4::mantel.randtest()；"mantel.rtest"使用ade4::mantel.rtest()；"mantel.partial"使用vegan::mantel.partial()
                      spec_select = list(GPP=1)) #这里分组为随机指定，具体实操需按自己的实际数据分组
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





####温度mantel test相关性####
data2 <- data1[, 13:23]
addcol <- colorRampPalette(c("#33A02C","#FDBF6F","#E31A1C"))#选择颜色
cor2 <- correlate(data2)
# cor2 <-cor (TEM, method="pearson")#进行相关性分析
corr2 <- cor2 %>% as_md_tbl()
write.csv(corr2, file = "CKD_pearson_correlate(env&env).csv", row.names = TRUE)
head(corr2)
#mantel test:
mantel <- mantel_test(GPP, data2,
                      mantel_fun = 'mantel', #支持4种："mantel"使用vegan::mantel()；"mantel.randtest"使用ade4::mantel.randtest()；"mantel.rtest"使用ade4::mantel.rtest()；"mantel.partial"使用vegan::mantel.partial()
                      spec_select = list(GPP=1)) #这里分组为随机指定，具体实操需按自己的实际数据分组
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









####3. 亚热带针叶林 313-889行####
data1 <- data[313:889,] 
### 降水 5-12 
data2 <- data1[,5:12] 
GPP<-data1[,4]


library("FactoMineR")
library("factoextra")
library(ggbiplot)



####降水PCA分组####
# 提取降水数据5-12列
library(zoo)
data <- na.aggregate(data, FUN = mean)
data <- na.omit(data)
data2 <- data[, c(5:12, 64)]




dfgroup<-data2$group

df<-  data2[, -which(names(data2) == "group")]
df<-data.matrix(df)


# 对数据进行主成分分析
df.pca <- prcomp(df, scale. = TRUE)


ggbiplot(df.pca, # PCA结果
         choices = c(1,2), # 主成分选择
         obs.scale = 1, # 标准化观测值
         var.scale = 1, # 标准化变量
         var.axes = TRUE, #为变量画箭头
         groups = dfgroup, 
         ellipse = TRUE, # 置信椭圆
         ellipse.prob = 0.68, # 置信区间，默认0.68
         circle = F) +  # 画相关圈(仅适用于当scale = TRUE和var.scale = 1时调用prcomp)
  
  theme_bw() +
  theme(legend.direction = 'horizontal', 
        legend.position = 'top',
        legend.text = element_text(size = 14),
        legend.title = element_text(size = 16))



















####温度PCA####
library(zoo)
data <- na.omit(data)
data2 <- data[, c(13:23, 64)]




dfgroup<-data2$group

df<-  data2[, -which(names(data2) == "group")]
df<-data.matrix(df)


# 对数据进行主成分分析
df.pca <- prcomp(df, scale. = TRUE)


ggbiplot(df.pca, # PCA结果
         choices = c(1,2), # 主成分选择
         obs.scale = 1, # 标准化观测值
         var.scale = 1, # 标准化变量
         var.axes = TRUE, #为变量画箭头
         groups = dfgroup, 
         ellipse = TRUE, # 置信椭圆
         ellipse.prob = 0.68, # 置信区间，默认0.68
         circle = F) +  # 画相关圈(仅适用于当scale = TRUE和var.scale = 1时调用prcomp)
  
  theme_bw() +
  theme(legend.direction = 'horizontal', 
        legend.position = 'top',
        legend.text = element_text(size = 14),
        legend.title = element_text(size = 16))



















####林分PCA####
library(zoo)
data <- na.aggregate(data, FUN = mean)
data <- na.omit(data)
data2 <- data[, c(24:26, 64)]




dfgroup<-data2$group

df<-  data2[, -which(names(data2) == "group")]
df<-data.matrix(df)


# 对数据进行主成分分析
df.pca <- prcomp(df, scale. = TRUE)


ggbiplot(df.pca, # PCA结果
         choices = c(1,2), # 主成分选择
         obs.scale = 1, # 标准化观测值
         var.scale = 1, # 标准化变量
         var.axes = TRUE, #为变量画箭头
         groups = dfgroup, 
         ellipse = TRUE, # 置信椭圆
         ellipse.prob = 0.68, # 置信区间，默认0.68
         circle = F) +  # 画相关圈(仅适用于当scale = TRUE和var.scale = 1时调用prcomp)
  
  theme_bw() +
  theme(legend.direction = 'horizontal', 
        legend.position = 'top',
        legend.text = element_text(size = 14),
        legend.title = element_text(size = 16))



















####地形PCA####
library(zoo)
data <- na.aggregate(data, FUN = mean)
data <- na.omit(data)
data2 <- data[, c(27:29, 64)]




dfgroup<-data2$group

df<-  data2[, -which(names(data2) == "group")]
df<-data.matrix(df)


# 对数据进行主成分分析
df.pca <- prcomp(df, scale. = TRUE)


ggbiplot(df.pca, # PCA结果
         choices = c(1,2), # 主成分选择
         obs.scale = 1, # 标准化观测值
         var.scale = 1, # 标准化变量
         var.axes = TRUE, #为变量画箭头
         groups = dfgroup, 
         ellipse = TRUE, # 置信椭圆
         ellipse.prob = 0.68, # 置信区间，默认0.68
         circle = F) +  # 画相关圈(仅适用于当scale = TRUE和var.scale = 1时调用prcomp)
  
  theme_bw() +
  theme(legend.direction = 'horizontal', 
        legend.position = 'top',
        legend.text = element_text(size = 14),
        legend.title = element_text(size = 16))



















####土壤物理PCA####
library(zoo)
data <- na.aggregate(data, FUN = mean)
data <- na.omit(data)
data2 <- data[, c(30:48, 64)]




dfgroup<-data2$group

df<-  data2[, -which(names(data2) == "group")]
df<-data.matrix(df)


# 对数据进行主成分分析
df.pca <- prcomp(df, scale. = TRUE)


ggbiplot(df.pca, # PCA结果
         choices = c(1,2), # 主成分选择
         obs.scale = 1, # 标准化观测值
         var.scale = 1, # 标准化变量
         var.axes = TRUE, #为变量画箭头
         groups = dfgroup, 
         ellipse = TRUE, # 置信椭圆
         ellipse.prob = 0.68, # 置信区间，默认0.68
         circle = F) +  # 画相关圈(仅适用于当scale = TRUE和var.scale = 1时调用prcomp)
  
  theme_bw() +
  theme(legend.direction = 'horizontal', 
        legend.position = 'top',
        legend.text = element_text(size = 14),
        legend.title = element_text(size = 16))


















####土壤化学PCA####
library(zoo)
data <- na.aggregate(data, FUN = mean)
data <- na.omit(data)
data2 <- data[, c(49:63, 64)]




dfgroup<-data2$group

df<-  data2[, -which(names(data2) == "group")]
df<-data.matrix(df)


# 对数据进行主成分分析
df.pca <- prcomp(df, scale. = TRUE)


ggbiplot(df.pca, # PCA结果
         choices = c(1,2), # 主成分选择
         obs.scale = 1, # 标准化观测值
         var.scale = 1, # 标准化变量
         var.axes = TRUE, #为变量画箭头
         groups = dfgroup, 
         ellipse = TRUE, # 置信椭圆
         ellipse.prob = 0.68, # 置信区间，默认0.68
         circle = F) +  # 画相关圈(仅适用于当scale = TRUE和var.scale = 1时调用prcomp)
  
  theme_bw() +
  theme(legend.direction = 'horizontal', 
        legend.position = 'top',
        legend.text = element_text(size = 14),
        legend.title = element_text(size = 16))





















library(randomForest)
####亚热带落叶阔叶林函数关系####
#GPP的函数关系
df<-data[,c(4,24,29,9,22,41,62)]
#WRA的函数关系
df<-data[,c(66,24,29,9,19,30,52)]
library(zoo)
df <- na.aggregate(df, FUN = mean)



# 假设trainData是训练数据集
rfModel <- randomForest(WRA ~ ., data=df, ntree=500, importance=TRUE)
importance(rfModel)  # 获取特征的重要性
varImpPlot(rfModel)  # 可视化特征的重要性



importanceScores <- importance(rfModel)
# Identify the names of the top five factors based on MeanDecreaseAccuracy or MeanDecreaseGini
topFactors <- sort(importanceScores[, 'IncNodePurity'], decreasing=TRUE)[1:6]
topFactorNames <- names(topFactors)


# 使用这些因子构建新的模型公式
formula <- as.formula(paste("WRA ~", paste(topFactorNames, collapse = " + ")))

# Now, construct your model using topFactorNames
formulaString <- paste("WRA ~", paste(topFactorNames, collapse=" + "))
model <- lm(as.formula(formulaString), data = df)
summary(model)


test_indices <- sample(1:nrow(df), size = 0.5 * nrow(df)) 
# 使用测试集的索引来提取测试集 
testData <- df[test_indices, ]

# 预测测试集
predictions <- predict(model, testData)

# 计算预测的准确性，例如使用RMSE
rmse <- sqrt(mean((predictions - testData$GPP)^2))
rmse <- sqrt(mean((predictions - testData$WRA)^2))
print(paste("RMSE:", rmse))

r_squared <- cor(testData$GPP, predictions)^2
r_squared <- cor(testData$WRA, predictions)^2
r_squared











####亚热带常绿阔叶林####
#GPP的函数关系
df<-data[,c(4,24,29,7,21,35,57)]
#WRA的函数关系
df<-data[,c(66,24,29,9,16,32,55)]
library(zoo)
df <- na.aggregate(df, FUN = mean)



# 假设trainData是训练数据集
rfModel <- randomForest(GPP ~ ., data=df, ntree=500, importance=TRUE)
importance(rfModel)  # 获取特征的重要性
varImpPlot(rfModel)  # 可视化特征的重要性



importanceScores <- importance(rfModel)
# Identify the names of the top five factors based on MeanDecreaseAccuracy or MeanDecreaseGini
topFactors <- sort(importanceScores[, 'IncNodePurity'], decreasing=TRUE)[1:6]
topFactorNames <- names(topFactors)


# 使用这些因子构建新的模型公式
formula <- as.formula(paste("GPP ~", paste(topFactorNames, collapse = " + ")))


# Now, construct your model using topFactorNames
formulaString <- paste("GPP ~", paste(topFactorNames, collapse=" + "))
model <- lm(as.formula(formulaString), data = df)
summary(model)

test_indices <- sample(1:nrow(df), size = 0.5 * nrow(df)) 
# 使用测试集的索引来提取测试集 
testData <- df[test_indices, ]

# 预测测试集
predictions <- predict(model, testData)

# 计算预测的准确性，例如使用RMSE
rmse <- sqrt(mean((predictions - testData$GPP)^2))
print(paste("RMSE:", rmse))

r_squared <- cor(testData$GPP, predictions)^2
r_squared



####亚热带针叶林####
#GPP的函数关系
df<-data[,c(4,24,29,7,21,30,57)]
#WRA的函数关系
df<-data[,c(66,24,29,9,16,31,52)]
library(zoo)
df <- na.aggregate(df, FUN = mean)



# 假设trainData是训练数据集
rfModel <- randomForest(GPP ~ ., data=df, ntree=500, importance=TRUE)
importance(rfModel)  # 获取特征的重要性
varImpPlot(rfModel)  # 可视化特征的重要性



importanceScores <- importance(rfModel)
# Identify the names of the top five factors based on MeanDecreaseAccuracy or MeanDecreaseGini
topFactors <- sort(importanceScores[, 'IncNodePurity'], decreasing=TRUE)[1:6]
topFactorNames <- names(topFactors)


# 使用这些因子构建新的模型公式
formula <- as.formula(paste("GPP ~", paste(topFactorNames, collapse = " + ")))


# Now, construct your model using topFactorNames
formulaString <- paste("GPP ~", paste(topFactorNames, collapse=" + "))
model <- lm(as.formula(formulaString), data = df)
summary(model)

test_indices <- sample(1:nrow(df), size = 0.5 * nrow(df)) 
# 使用测试集的索引来提取测试集 
testData <- df[test_indices, ]

# 预测测试集
predictions <- predict(model, testData)

# 计算预测的准确性，例如使用RMSE
rmse <- sqrt(mean((predictions - testData$GPP)^2))
print(paste("RMSE:", rmse))

r_squared <- cor(testData$GPP, predictions)^2
r_squared



####水源涵养函数####
#WRA的函数关系
df<-data[,c(66,24,29,9,19,30,52)]
df<-data[,c(66,24,29,9,16,32,55)]
df<-data[,c(66,24,29,9,16,31,52)]

library(zoo)
df <- na.aggregate(df, FUN = mean)



# 假设trainData是训练数据集
rfModel <- randomForest(WRA ~ ., data=df, ntree=500, importance=TRUE)
importance(rfModel)  # 获取特征的重要性
varImpPlot(rfModel)  # 可视化特征的重要性



importanceScores <- importance(rfModel)
# Identify the names of the top five factors based on MeanDecreaseAccuracy or MeanDecreaseGini
topFactors <- sort(importanceScores[, 'IncNodePurity'], decreasing=TRUE)[1:6]
topFactorNames <- names(topFactors)


# 使用这些因子构建新的模型公式
formula <- as.formula(paste("WRA ~", paste(topFactorNames, collapse = " + ")))

# Now, construct your model using topFactorNames
formulaString <- paste("WRA ~", paste(topFactorNames, collapse=" + "))
model <- lm(as.formula(formulaString), data = df)
summary(model)


test_indices <- sample(1:nrow(df), size = 0.5 * nrow(df)) 
# 使用测试集的索引来提取测试集 
testData <- df[test_indices, ]

# 预测测试集
predictions <- predict(model, testData)

# 计算预测的准确性，例如使用RMSE
rmse <- sqrt(mean((predictions - testData$WRA)^2))
print(paste("RMSE:", rmse))


r_squared <- cor(testData$WRA, predictions)^2
r_squared

####非线拟合函数-水源涵养函数####
#1.亚热带落叶阔叶林WRA的函数关系
library(randomForest)
data1 <- data[1:13,]
df<-data[,c(66,24,29,9,19,30,52)]
#2.亚热带常绿阔叶林WRA的函数关系
data1 <- data[14:312,]
df<-data1[,c(66,24,29,9,16,32,55)]
#3.亚热带针叶林WRA的函数关系
data1 <- data[313:889,] 
df<-data1[,c(66,24,29,9,16,31,52)]

library(ggplot2)

# 检查数据框的列数
ncol(df)

# 以data[,66]为y轴，分别绘制散点图
ggplot(df, aes(x = df[, 1], y = df[, c(2, 3, 4, 5, 6, 7)])) +
  geom_point() +
  labs(x = "X轴标签", y = "Y轴标签", title = "散点图示例")

library(zoo)
df <- na.aggregate(df, FUN = mean)
df[df == 0] <- 0.001 #0值替换为0.001

# 将数据整合到一个数据框中
data_combined <- data.frame(y = df[, 1], x1 = df[, 2], x2 = df[, 3], x3 = df[, 4], x4 = df[, 5], x5 = df[, 6], x6 = df[, 7])

# 定义一个多项式函数
poly_func <- function(x, a, b, c, d, e, f) {
  a * x[,1] + b * x[,2] + c * x[,3] + d * x[,4] + e * x[,5] + f * x[,6]
}

# 将数据整合到一个数据框中
data_combined <- data.frame(y = df[, 1], x1 = df[, 2], x2 = df[, 3], x3 = df[, 4], x4 = df[, 5], x5 = df[, 6], x6 = df[, 7])

# 使用nls()函数拟合非线性函数
fit <- nls(y ~ poly_func(data_combined[, 2:7], a, b, c, d, e, f), 
           data = data_combined,
           start = list(a = 1, b = 1, c = 1, d = 1, e = 1, f = 1))  # 初始参数值
# 查看拟合结果
summary(fit)
























##2.水源涵养-亚热带落叶阔叶林1-13行####
# 提取14-312行的数据
data1 <- data[14:312,]
WRA<- data1[,66]
# 提取降水数据5-12列
data2 <- data1[, 5:12]
#温度
data2 <- data1[, 13:23]
#林分mantel test相关性
data2 <- data1[, 24:26]
# 提取地形数据27-29列
data2 <- data1[, 27:29]
# 提取土壤物理数据30-48列
data2 <- data1[, 30:48]
# 提取土壤化学数据49-63列
data2 <- data1[, 49:63]




##3.水源涵养-亚热带针叶林 313-889行####
data1 <- data[313:889,] 
WRA<- data1[,66]
# 提取降水数据5-12列
data2 <- data1[, 5:12]
#温度
data2 <- data1[, 13:23]
#林分mantel test相关性
data2 <- data1[, 24:26]
# 提取地形数据27-29列
data2 <- data1[, 27:29]
# 提取土壤物理数据30-48列
data2 <- data1[, 30:48]
# 提取土壤化学数据49-63列
data2 <- data1[, 49:63]

library(zoo)
data2 <- na.aggregate(data2, FUN = mean)
WRA <- na.aggregate(WRA, FUN = mean)



# 加载所需的库
library(Rmisc)
library(corrplot)
library(RColorBrewer)
#降水mantel test相关性
library(readxl)
# rm(list=ls())#好习惯，确保有干净的 R 环境
#相关包的载入：
library(linkET)
library(ggplot2)
library(ggtext)
library(dplyr)
#配色主题包载入：
library(cols4all)
c4a_gui()
addcol <- colorRampPalette(c("#33A02C","#FDBF6F","#E31A1C"))#选择颜色
cor2 <- correlate(data2)
# cor2 <-cor (TEM, method="pearson")#进行相关性分析
corr2 <- cor2 %>% as_md_tbl()
write.csv(corr2, file = "CKD_pearson_correlate(env&env).csv", row.names = TRUE)
head(corr2)
#mantel test:
mantel <- mantel_test(WRA, data2,
                      mantel_fun = 'mantel', #支持4种："mantel"使用vegan::mantel()；"mantel.randtest"使用ade4::mantel.randtest()；"mantel.rtest"使用ade4::mantel.rtest()；"mantel.partial"使用vegan::mantel.partial()
                      spec_select = list(WRA=1)) #这里分组为随机指定，具体实操需按自己的实际数据分组
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









####一元非线性回归####
library(ISLR)
attach(data)
View(data)
#____________________________________________________
df<-data[,c(4,24,29,9,22,41,62)]
#____________________________________________________
#划分训练集和测试集
train = sample(1:nrow(df),nrow(df)*9/10)
train_set = df[train,]
test_set = df[-(train),]
plot(GPP,df,data =train_set)

#____________________________________________________
#多项式回归
fit=lm(GPP~poly(GPP,3,raw=T),data=train_set)#数字为几次多项式

#10-cv to choose tuning parameter(polynomial degree)
k=10
folds=sample(1:k,nrow(train_set),replace=TRUE)
out.cv = matrix(0, nrow = k, ncol = 8)
colnames(out.cv)=1:8

for (j in 1:k) {
  for (i in 1:8) {
    fit=lm(wGPP~poly(GPP,i,raw=T),data=train_set[folds!=j,])
    pred = predict(fit, train_set[folds == j, ])
    MSE = mean((train_set$GPP[folds == j] - pred)^2)
    out.cv[j, i] = MSE
  }
}
out.cv
cv.MSE = apply(out.cv, 2, mean)
plot(1:8,cv.MSE,xlab="Number of Predictors",
     ylab="10-fold Validation Set Error",type='b')
which.min(cv.MSE)

#anova method to choose tuning parameter
fit.1=lm(wGPP~GPP,data=train_set)
fit.2=lm(wGPP~poly(GPP,2,raw=T),data=train_set)
fit.3=lm(wGPP~poly(GPP,3,raw=T),data=train_set)
fit.4=lm(wGPP~poly(GPP,4,raw=T),data=train_set)
fit.5=lm(wGPP~poly(GPP,5,raw=T),data=train_set)
anova(fit.1,fit.2,fit.3,fit.4,fit.5)

#calculate test MSE
pred_y = predict(fit.4,test_set)
mean((test_set$wGPP - pred_y)^2)

#visualize the polynomial regression
plot(GPP,wGPP,data =train_set)

GPPlims=range(GPP)
GPPlims
GPP.grid=seq(from=GPPlims[1],to=GPPlims[2])
preds=predict(fit.4,newdata=list(GPP=GPP.grid),se=TRUE)
se.bands=cbind(preds$fit+2*preds$se.fit,preds$fit
               -2*preds$se.fit)

plot(GPP,wGPP,xlim=GPPlims,cex=.5,col="darkgrey")
title("Degree-4 Polynomial",outer=T)
lines(GPP.grid,preds$fit,lwd=2,col="blue")
matlines(GPP.grid,se.bands,lwd=1,col="blue",lty=3)

# _____________________________________________
#logistics多项式回归
fit=glm(I(wGPP>250)~poly(GPP,9),data=train_set,family=binomial)

#10-fold cv to choose tuning parameter
cv.error = rep(0,10)
for( i in 1:10 ){ 
  glm.fit = glm( wGPP ~ poly(GPP,i), data=train_set )
  cv.error[i] = cv.glm( train_set, glm.fit, K=10 )$delta[1]
}
which.min(cv.error)

#calculate test missclassification error rate
glm.probs = predict(fit, test_set,"response")
glm.pred <- ifelse(glm.probs>.5, TRUE,FALSE)
mean(I(test_set$wGPP>250)!=glm.pred)

#visualize
preds=predict(fit,newdata=list(GPP=GPP.grid),se=T)
pfit=exp(preds$fit)/(1+exp(preds$fit))
se.bands.logit = cbind(preds$fit+2*preds$se.fit, preds$fit-2*preds$se.fit)
se.bands = exp(se.bands.logit)/(1+exp(se.bands.logit))
preds=predict(fit,newdata=list(GPP=GPP.grid),type="response",se=T)
plot(GPP,I(wGPP>250),xlim=GPPlims,type="n",ylim=c(0,.2))
points(jitter(GPP), I((wGPP>250)/5),cex=.5,pch="|",col="darkgrey")
lines(GPP.grid,pfit,lwd=2, col="blue")
matlines(GPP.grid,se.bands,lwd=1,col="blue",lty=3)


#_______________________________________
#step function
table(cut(GPP,4))
fit=lm(wGPP~cut(GPP,3),data=train_set)

#calculate test MSE
pred = predict(fit,data=test_set)
mean((pred-test_set$wGPP)^2)

# visualize step function 
preds=predict(fit,newdata=list(GPP=GPP.grid),se=T)
se.bands=cbind(preds$fit+2*preds$se.fit,preds$fit
               -2*preds$se.fit)
plot(GPP,wGPP,xlim=GPPlims,data = train_set,cex=.5,col="darkgrey")
title("stepfunction",outer=T)
lines(GPP.grid,preds$fit,lwd=2,col="blue")
matlines(GPP.grid,se.bands,lwd=1,col="blue",lty=3)

#K-fold cv to choose optimal cut (cv.glm 没法用cut)
number_of_bins = c( 2, 3, 4, 5, 10 )
nc = length(number_of_bins)

k = 10
folds = sample( 1:k, nrow(train_set), replace=TRUE ) 
cv.errors = matrix( NA, k, nc )

GPP_range = range( train_set$GPP )
GPP_range[1] = GPP_range[1]-1
GPP_range[2] = GPP_range[2]+1

for( ci in 1:nc ){ # for each number of cuts to test
  nob = number_of_bins[ci] # n(umber) o(f) c(uts) 2, 3, 4 ...
  for( fi in 1:k ){ # for each fold
    fit = glm( wGPP ~ cut( GPP, breaks=seq( from=GPP_range[1], to=GPP_range[2], length.out=(nob+1) ) ), data=train_set[folds!=fi,] )
    y_hat = predict( fit, newdata=train_set[folds==fi,] )
    cv.errors[fi,ci] = mean( ( train_set[folds==fi,]$wGPP - y_hat )^2 ) 
  }
}
cv.errors.mean = apply(cv.errors,2,mean)
cv.errors.stderr = apply(cv.errors,2,sd)/sqrt(k)

min.cv.index = which.min( cv.errors.mean )
one_se_up_value = ( cv.errors.mean+cv.errors.stderr )[min.cv.index] 

min_lim=min( one_se_up_value, cv.errors.mean, cv.errors.mean-cv.errors.stderr, cv.errors.mean+cv.errors.stderr ) * 0.9
max_lim=max( one_se_up_value, cv.errors.mean, cv.errors.mean-cv.errors.stderr, cv.errors.mean+cv.errors.stderr ) * 1.1

plot( number_of_bins, cv.errors.mean, ylim=c(min_lim,max_lim), pch=19, type='b', xlab='number of cut bins', ylab='CV estimate of the prediction error' )
lines( number_of_bins, cv.errors.mean-cv.errors.stderr, lty='dashed' )
lines( number_of_bins, cv.errors.mean+cv.errors.stderr, lty='dashed' )
abline( h=one_se_up_value, col='red' )
grid()

#____________________________________
#spline
library(splines)
fit=lm(wGPP~ns(GPP,knots=c(25,40,60)),data=train_set)
# dim(bs(GPP,knots=c(25,40,60)))
# dim(bs(GPP ,df=6))
fit=lm(wGPP~ns(GPP,df=6),data=train_set)


#visualize the splines regression
pred=predict(fit,newdata=list(GPP=GPP.grid),se=T)
plot(GPP,wGPP,col="gray",data=train_set)
lines(GPP.grid,pred$fit,lwd=2)
lines(GPP.grid,pred$fit+2*pred$se,lty="dashed")
lines(GPP.grid,pred$fit-2*pred$se,lty="dashed")

#smoothing spline
plot(GPP,wGPP,xlim=GPPlims,cex=.5,col="darkgrey")
title("Smoothing Spline")
fit=smooth.spline(GPP,wGPP,df=16)
fit2=smooth.spline(GPP,wGPP,cv=TRUE)
fit2$df
lines(fit,col="red",lwd=2)
lines(fit2,col="blue",lwd=2)
legend("topright",legend=c("16 DF","6.8 DF"),col=c("red","blue"),
       lty=1,lwd=2,cex=.8)

#local regression
plot(GPP,wGPP,xlim=GPPlims,cex=.5,col="darkgrey")
title("Local Regression")
fit=loess(wGPP~GPP,span=.2,data=train_set)
fit2=loess(wGPP~GPP,span=.5,data=train_set)

GPPlims=range(GPP)
GPPlims
GPP.grid=seq(from=GPPlims[1],to=GPPlims[2])

lines(GPP.grid,predict(fit,data.frame(GPP=GPP.grid)),
      col="red",lwd=2)  
lines(GPP.grid,predict(fit2,data.frame(GPP=GPP.grid)),
      col="blue",lwd=2)
legend("topright",legend=c("Span=0.2","Span=0.5"),
       col=c("red","blue"), lty=1,lwd=2,cex=.8)

#calculate test MSE
mean((test_set$wGPP-predict(fit2,data = test_set))^2)



####提取PCA1主成分分析####
# 提取林分PCA1
df<-data[,24:26]
# 提取地形PCA1
df<-data[,27:29]
# 提取降水PCA1
df<-data[,13:23]
# 提取气温PCA1
df<-data[,5:12]
# 提取土壤物理性质PCA130:51
df<-data[,30:49]
# 提取土壤化学性质PCA1
df<-data[,52:66]


library(zoo)
df <- na.aggregate(df, FUN = mean)#补充空值

# 执行PCA
res.pca <- prcomp(df, scale. = TRUE)

# 提取PCA结果的前两个主成分
pca_df <- as.data.frame(pca_result$x[, 1:2])

library("FactoMineR")
library("factoextra")



#函数PCA ()的输出是一个列表，包括以下部分
print(res.pca)
#提取主成分 (PC) 保留的特征值和方差比例（即信息）
eig.val <- get_eigenvalue(res.pca)
eig.val
#生成碎石图
fviz_eig(res.pca, addlabels = TRUE, ylim = c(0, 50))
#提取变量结果
var <- get_pca_var(res.pca)
var
#绘制变量
fviz_pca_var(res.pca, col.var = "black")
#使用函数fviz_cos2()创建变量 cos2 的条形图
fviz_cos2(res.pca, choice = "var", axes = 1:2)
#根据变量的 cos2 值对变量进行着色col.var = "cos2"
#使用参数gradient.cols自定义颜色
fviz_pca_var(res.pca, col.var = "cos2",
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"), 
             repel = TRUE #允许文本标签自动调整位置以避免重叠
)




# 提取第一个主成分
PCA <- res.pca[["x"]]  # 提取第一个主成分的加载因子
PCA1 <- PCA[, 1]
# 将提取的列转换为矩阵
PCA1 <- as.matrix(PCA1)
# 重新命名矩阵的列名
colnames(PCA1) <- "stand"
# 重新命名矩阵的列名
colnames(PCA1) <- "topographic"
# 重新命名矩阵的列名
colnames(PCA1) <- "precipitation"
# 重新命名矩阵的列名
colnames(PCA1) <- "temperature"
# 重新命名矩阵的列名
colnames(PCA1) <- "soil1"
# 重新命名矩阵的列名
colnames(PCA1) <- "soil2"


# 保存结果到文件# 保存PCA1的结果
write.csv(PCA1, file = "F:/research data/jiangxi/林分PCA1_result.xlsx")
write.csv(PCA1, file = "F:/research data/jiangxi/地形PCA1_result.xlsx")
write.csv(PCA1, file = "F:/research data/jiangxi/降水PCA1_result.xlsx")
write.csv(PCA1, file = "F:/research data/jiangxi/气温PCA1_result.xlsx")
write.csv(PCA1, file = "F:/research data/jiangxi/土壤物理性质PCA1_result.xlsx")
write.csv(PCA1, file = "F:/research data/jiangxi/土壤化学性质PCA1_result.xlsx")
\



####GPP/WRA的mantel test相关性####
data2<-data[,3:8]
GPP<-data[,1]
library(zoo)
data2 <- na.aggregate(data2, FUN = mean)
GPP <- na.aggregate(GPP, FUN = mean)
# rm(list=ls())#好习惯，确保有干净的 R 环境
#相关包的载入：
library(linkET)
library(ggplot2)
library(ggtext)
library(dplyr)
#配色主题包载入：
library(cols4all)
c4a_gui()
addcol <- colorRampPalette(c("#33A02C","#FDBF6F","#E31A1C"))#选择颜色
cor2 <- correlate(data2)
# cor2 <-cor (TEM, method="pearson")#进行相关性分析
corr2 <- cor2 %>% as_md_tbl()
write.csv(corr2, file = "CKD_pearson_correlate(env&env).csv", row.names = TRUE)
head(corr2)
#mantel test:
mantel <- mantel_test(GPP, data2,
                      mantel_fun = 'mantel', #支持4种："mantel"使用vegan::mantel()；"mantel.randtest"使用ade4::mantel.randtest()；"mantel.rtest"使用ade4::mantel.rtest()；"mantel.partial"使用vegan::mantel.partial()
                      spec_select = list(GPP=1)) #这里分组为随机指定，具体实操需按自己的实际数据分组
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




