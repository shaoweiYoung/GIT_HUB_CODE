# #install.packages("dplyr")  # 如果你还没有安装dplyr包，请先安装
# library(dplyr)             # 加载dplyr包
# 
# # 用你CSV文件的实际路径替换'<path_to_file>'
# gosif_data <- read.csv("F:/research data/studies of fagaceae/aok/the process/GEE table/totol/GOSIF_GPP_2020_500_Mean.csv")
# bio_data <- read.csv("F:/research data/studies of fagaceae/aok/the process/GEE table/add 37soil totol/bio_merged_data.csv")
# soil_data<- read.csv("F:/research data/studies of fagaceae/aok/the process/GEE table/add 37soil totol/soil_merged_data.csv")
# stand_data<- read.csv("F:/research data/studies of fagaceae/aok/the process/GEE table/add 37soil totol/stand_merged_data.csv")
# topographic_data<- read.csv("F:/research data/studies of fagaceae/aok/the process/GEE table/add 37soil totol/topographic_merged_data.csv")
# # 用你数据集中实际的ID列的名称替换'ID'



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



 scale_color_manual(values = c("#fb9b8e",'#00ac4c','#70abd8'))+










# merged_data1 <- full_join(gosif_data, bio_data, by = "ID")
# merged_data2 <- full_join(gosif_data, soil_data, by = "ID")
# merged_data3 <- full_join(gosif_data, stand_data, by = "ID")
# merged_data4 <- full_join(gosif_data, topographic_data, by = "ID")
# head(merged_data)  # 查看合并后数据集的前几行
# 
# boi<-merged_data1[,c(2:3,5:27)]
# soil<-merged_data2[,c(2:3,seq(6,115, by = 3))]
# new_column_names <- c("AK", "AL", "AN", "AP", "BD", "C1", "CA", "CEC", "CL", "CW1", "Dc", "Dh", "GRAV", "H", "K", "LDEP", "LNUM", "MG", "NA", "PDEP", "PH", "POR", "R", "RC", "RS", "S1", "SA", "SI", "SOM", "SW1", "TK", "TN", "TP", "Unc", "Unh", "Wc", "Wh")
# # 确保新列名的数量与你想更改的列的数量相匹配
# if(length(new_column_names) == 37) {
#   # 将数据框your_dataframe的第3到第39列的列名称更改为new_column_names中的名称
#   colnames(soil)[3:39] <- new_column_names
# } else {
#   print("新列名的数量与需要更改的列的数量不匹配")
# }
# 
# stand<-merged_data3[,c(2:3,5:7)]
# topographic<-merged_data4[,c(2:3,5:7)]
####加载数据####
bio_sif <- read.csv("F:/research data/studies of fagaceae/aok/the process/GEE table/bio soil stand and topographic sif/bio_sif.csv")
soil_sif <- read.csv("F:/research data/studies of fagaceae/aok/the process/GEE table/bio soil stand and topographic sif/soil_sif.csv")
stand_sif <- read.csv("F:/research data/studies of fagaceae/aok/the process/GEE table/bio soil stand and topographic sif/stand_sif.csv")
topographic_sif <- read.csv("F:/research data/studies of fagaceae/aok/the process/GEE table/bio soil stand and topographic sif/topographic_sif.csv")


# 补充每个数据集的缺失值
datasets <- list(bio_sif, soil_sif, stand_sif, topographic_sif)  # 假设这些数据框已经被正确加载
datasets_filled <- lapply(datasets, function(df) {
  na_columns <- sapply(df, is.numeric)  # 选择数值型列
  df[na_columns] <- lapply(df[na_columns], function(x) ifelse(is.na(x), mean(x, na.rm = TRUE), x))
  return(df)
})

# 分别命名补充后的数据集，以便后续操作
bio_sif_filled <- datasets_filled[[1]]
soil_sif_filled <- datasets_filled[[2]]
stand_sif_filled <- datasets_filled[[3]]
topographic_sif_filled <- datasets_filled[[4]]

library(Rmisc) 
library(corrplot)
library(ggcorrplot)
library(RColorBrewer)
library(grDevices)
library(extrafont)
library(extrafontdb)
library(Rttf2pt1)



# # 计算bio_sif_filled相关性矩阵和显著性
# cor_signif_bio_sif <- rcorr(as.matrix(bio_sif_filled[, sapply(bio_sif_filled, is.numeric)]), type="pearson")
# cor_matrix_bio_sif <- cor_signif_bio_sif$r # 相关性矩阵
# p_matrix_bio_sif <- cor_signif_bio_sif$P # 显著性矩阵（P值）
# # 打印相关性矩阵
# print("bio_sif相关性矩阵:")
# print(cor_matrix_bio_sif)
# # 打印显著性矩阵（P值）
# print("bio_sif显著性矩阵（P值）:")
# print(p_matrix_bio_sif)
# write.csv(cor_matrix_bio_sif, "F:/research data/studies of fagaceae/aok/the process/GEE table/pearson/cor_matrix_bio_sif.csv")
# write.csv(p_matrix_bio_sif, "F:/research data/studies of fagaceae/aok/the process/GEE table/pearson/p_matrix_bio_sif.csv")
# 
# 
# 
# 
# 
# 
# # 计算soil_sif_filled数据集的相关性
# cor_signif_soil_sif <- rcorr(as.matrix(soil_sif_filled[, sapply(soil_sif_filled, is.numeric)]), type="pearson")
# cor_matrix_soil_sif <- cor_signif_soil_sif$r # 相关性矩阵
# p_matrix_soil_sif <- cor_signif_soil_sif$P # 显著性矩阵
# # 打印相关性矩阵
# print("soil_sif相关性矩阵:")
# print(cor_matrix_soil_sif)
# # 打印显著性矩阵（P值）
# print("soil_sif显著性矩阵（P值）:")
# print(p_matrix_soil_sif)
# write.csv(cor_matrix_soil_sif, file="F:/research data/studies of fagaceae/aok/the process/GEE table/pearson/cor_matrix_soil_sif.csv")
# write.csv(p_matrix_soil_sif, file="F:/research data/studies of fagaceae/aok/the process/GEE table/pearson/p_matrix_soil_sif.csv")
# 
# 
# 
# # 计算stand_sif_filled数据集的相关性
# # 计算相关性矩阵
# cor_signif_stand_sif <- rcorr(as.matrix(stand_sif_filled[, sapply(stand_sif_filled, is.numeric)]), type="pearson")
# cor_matrix_stand_sif <- cor_signif_stand_sif$r # 相关性矩阵
# p_matrix_stand_sif <- cor_signif_stand_sif$P # 显著性矩阵
# # 打印相关性矩阵
# print("stand_sif相关性矩阵:")
# print(cor_matrix_stand_sif)
# # 打印显著性矩阵（P值）
# print("stand_sif显著性矩阵（P值）:")
# print(p_matrix_stand_sif)
# write.csv(correlation_matrix_stand_sif, "F:/research data/studies of fagaceae/aok/the process/GEE table/pearson/cor_matrix_stand_sif.csv")
# # 假设你已有或已计算出显著性矩阵p_matrix_stand_sif
# write.csv(p_matrix_stand_sif, "F:/research data/studies of fagaceae/aok/the process/GEE table/pearson/p_matrix_stand_sif.csv")
# 
# 
# 
# 
# # 计算topographic_sif_filled数据集的相关性
# # 计算相关性矩阵
# cor_signif_topographic_sif <- rcorr(as.matrix(topographic_sif_filled[, sapply(topographic_sif_filled, is.numeric)]), type="pearson")
# cor_matrix_topographic_sif <- cor_signif_topographic_sif$r # 相关性矩阵
# p_matrix_topographic_sif <- cor_signif_topographic_sif$P # 显著性矩阵
# # 打印相关性矩阵
# print("topographic_sif相关性矩阵:")
# print(cor_matrix_topographic_sif)
# # 打印显著性矩阵（P值）
# print("topographic_sif显著性矩阵（P值）:")
# print(p_matrix_topographic_sif)
# write.csv(correlation_matrix_topographic_sif, "F:/research data/studies of fagaceae/aok/the process/GEE table/pearson/cor_matrix_topographic_sif.csv")
# # 假设你已有或已计算出显著性矩阵p_matrix_topographic_sif
# write.csv(p_matrix_topographic_sif, "F:/research data/studies of fagaceae/aok/the process/GEE table/pearson/p_matrix_topographic_sif.csv")







####选择所需数据####
stand<-stand_sif_filled[,2:5]
# 重新命名列
colnames(stand) <- c("GPP", "Age", "FCH", "LAI")

topographic<-topographic_sif_filled[,2:5]
# 重新命名列
colnames(topographic) <- c("GPP", "Aspect", "DEM", "Slope")

TEM <- bio_sif_filled[, c(2,3, 15, 17, 16, 20, 21, 4, 5)]
# 重新命名列
colnames(TEM) <- c("GPP", "BIO1", "BIO3","BIO5","BIO6","BIO8","BIO9","BIO10","BIO11")


PRE<-bio_sif_filled[, c(2,6:8,10:13)]
# 重新命名列
colnames(PRE) <- c("GPP", "BIO12", "BIO13","BIO14","BIO16","BIO17","BIO18","BIO19")

PRE_TEM<-bio_sif_filled[, c(2,14,16,19,9)]
# 重新命名列
colnames(PRE_TEM) <- c("GPP", "BIO2", "BIO4","BIO7","BIO15")

soil1<-soil_sif_filled[, c(2,3:6, 9, 10, 16, 17, 20, 21, 23,31,33:35)]
# 重新命名列
colnames(soil1) <- c("GPP", "AK", "AL", "AN", "AP", "CA", "CEC", "H", "K", "MG", "NA", "PH", "SOM", "TK", "TN", "TP")


# 创建一个新的数据框，排除上述列
soil2 <- soil_sif_filled[, c(2, 7,8,11:15,18,19,22,24:29,30,32,36:39)]
# 重新命名列
colnames(soil2) <- c("GPP", "BD", "C1", "CL", "CW1", "Dc", "Dh", "GRAV", "LDEP", "LNUM", "PDEP", "POR", "R", "RC", "RS", "S1", "SA",  "SI", "SW1", "Unc", "Unh", "Wc", "Wh")




# soil1<-soil_sif_filled[, c(2,3:6, 9, 10, 16, 17, 20, 21, 23,30,31,33:35)]
# # 重新命名列
# colnames(soil1) <- c("GPP", "AK", "AL", "AN", "AP", "CA", "CEC", "H", "K", "MG", "NA", "PH", "SI", "SOM", "TK", "TN", "TP")
# # 从soil数据框中选择指定的列
# soil1 <- soil %>% 
#   select(AK, AL, AN, AP, CA, CEC, H, K, MG, NA, PH, SI, SOM, TK, TN, TP)
# 
# 
# # 创建一个新的数据框，排除上述列
# soil2 <- soil_sif_filled[, c(2, 7,8,11:15,18,19,22,24:29,32,36:39)]
# # 重新命名列
# colnames(soil2) <- c("GPP", "BD", "C1", "CL", "CW1", "Dc", "Dh", "GRAV", "LDEP", "LNUM", "PDEP", "POR", "R", "RC", "RS", "S1", "SA",  "SW1", "Unc", "Unh", "Wc", "Wh")


soil2 <- scale(soil2)


####求相关性，制作热力图####
tdc1 = cor (stand, method="pearson")#进行相关性分析
tdc1 = cor (topographic, method="pearson")#进行相关性分析
tdc1 = cor (TEM, method="pearson")#进行相关性分析
tdc1 = cor (PRE, method="pearson")#进行相关性分析
tdc1 = cor (PRE_TEM, method="pearson")#进行相关性分析
tdc1 = cor (soil1, method="pearson")#进行相关性分析
tdc1 = cor (soil2, method="pearson")#进行相关性分析

##热力图
addcol <- colorRampPalette(c("#33A02C","#FDBF6F","#E31A1C"))#选择颜色
testRes = cor.mtest(soil2, menthod = "pearson", conf.level = 0.99)
testRes$uppCI
par(mar = c(16, 5, 5, 2))  # 调整边距
corrplot(tdc1, method = "circle", #形状是圈
         type="lower",#位置是左下
         col = addcol(100), #选择颜色
         tl.col = "black", #
         tl.cex = 1.6, #坐标轴上字体大小
         tl.srt = 90,
         #tl.pos = "lt",#图注位置
         cl.pos = "r",#颜色图例
         cl.cex = 2,#图例大小
         p.mat = testRes$p, #p值显示
         diag = F,#自相关去除
         sig.level = c(0.001, 0.01, 0.05), #显著水平
         pch.cex =0.5,#显著字体大小
         insig = 'label_sig',#不显著的标识
         family="serif")#字体

corrplot(tdc1, method = "circle", col = addcol(100), 
         tl.col = "black", tl.cex =1.6, tl.srt = 90,tl.pos = "lt", cl.cex = 1.5,#图例大小,
         p.mat = testRes$p, diag = T, type = 'lower',
         sig.level = c(0.001, 0.01, 0.05), pch.cex = 1.6,
         insig = 'label_sig', pch.col = 'black', order = 'original')
corrplot(tdc1, method = "number", type = "upper",col = addcol(100),  cl.cex = 0.1,#图例大小,
         tl.col = "n", tl.cex = 0.1,cl.pos = 'n', tl.pos = "n",order = 'original',
         add =T,insig='blank') # 不显著留空；add = T表示在原有的图中增加




# stand.cor <- round(cor(stand, method = "pearson"),2) #2为小数点后2为
# stand.p <-round(cor_pmat(stand,method = "pearson"),2) 
# col1=colorRampPalette(colors =c("red","white","darkgreen"),space="Lab") 
# col2 = colorRampPalette(c('#7F0000', 'red', '#FF7F00', 'yellow', 'white',
#                           tdc1 = cor (stand, method="pearson")#进行相关性分
# par(no.readonly = TRUE) 
# par(mfrow=c(2,2)) 
# par(family= "Times New Roman") 
# pdf(file = "heatmap.pdf",width = 5,height = 5, family = 'Times')
# corrplot(corr =stand.cor, p.mat = stand.p,method = "circle",
#          type="upper",
#          tl.pos="lt", tl.cex=1, tl.col="black",
#          insig="label_sig",sig.level = c(.01, .05),
#          pch.cex = 0.8,pch.col = "black",col = col1(10), order = "AOE") # 选择10个颜色
# corrplot(corr =stand.cor,method = "number",
#          type="lower",add = TRUE,
#          tl.pos="n",cl.pos = "n",diag = FALSE,
#          col = "black",number.cex = 0.7) # 设置相关性数值为黑色
# 
# dev.off()



####mantel test相关性####
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
GPP<--soil_sif_filled[, 2]
soil1<-soil_sif_filled[, c(3:6, 9, 10, 16, 17, 20, 21, 23,31,33:35)]
# 重新命名列
colnames(soil1) <- c( "AK", "AL", "AN", "AP", "CA", "CEC", "H", "K", "MG", "NA", "PH", "SOM", "TK", "TN", "TP")

#计算ImmuneScore与基因的相关性系数：
cor2 <- correlate(soil1)
# cor2 <-cor (TEM, method="pearson")#进行相关性分析
corr2 <- cor2 %>% as_md_tbl()
write.csv(corr2, file = "CKD_pearson_correlate(env&env).csv", row.names = TRUE)
head(corr2)
#mantel test:
mantel <- mantel_test(GPP, soil1,
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



