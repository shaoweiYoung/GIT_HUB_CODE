####加载数据####
data <- read.csv("F:/research data/studies of fagaceae/oak_points_facture_attributes.csv")
#_______________________________________________________________________________
####提取各属数据####
genus_data <- subset(data, genus == 1)#1为水青冈Fagus
genus_data <- subset(data, genus == 2)#2为青冈Cyclobalanopsis
genus_data <- subset(data, genus == 3)#3为栎属Quercus
genus_data <- subset(data, genus == 4)#4为锥属Castanopsis
genus_data <- subset(data, genus == 5)#5为柯属Lithocarpus
genus_data <- subset(data, genus == 6)#6为栗属Castanea
#____________________________________________________________________
########删除genus_data数据框中的缺失值####
genus_data <- na.omit(genus_data)
#_______________________________________________________________________________
####提取GPP和各因子的数据####
GPP<-genus_data[,c("GPP")]
####Topographic feacture####
data2<- genus_data[, c("Aspect", "DEM", "Slope")]
####Temperature feacture####
data2 <- genus_data[, c("Bio1", "Bio2", "Bio3", "Bio4", "Bio5", "Bio6", "Bio7", "Bio8", "Bio9", "Bio10", "Bio11")]

#_______________________________________________________________________________
####缺失值补充####
library(zoo)
GPP <- na.aggregate(GPP, FUN = mean)
data2 <- na.aggregate(data2, FUN = mean)
#_______________________________________________________________________________
####删除GPP和data2 数据框中的缺失值####
GPP <- na.omit(GPP)
data2 <- na.omit(data2)
#_______________________________________________________________
####查看电脑R语言存放R的library文件夹####
.libPaths()
#[1] "C:/Users/shaowei/AppData/Local/R/win-library/4.3" "C:/Program Files/R/R-4.3.2/library"    
#安装devtools
install.packages("devtools")
#安装ggcor
#devtools::install_local("#安装devtools
#install.packages("devtools")
#安装ggcor
#devtools::install_local("C:/Program Files/R/R-4.3.2/library/ggcor_master.zip")
# install.packages("devtools")
#devtools::install_git("https://gitee.com/dr_yingli/ggcor")
#_______________________________________________________________

####热力图####
suppressWarnings(suppressMessages(library("ggcor")))
## 导入相关的包 
library(ggcorrplot) 
library(shinyjs)
library(colorblindcheck)
library(kableExtra)
library(linkET)
library(ggplot2) 
library(ggcor)
library(cols4all)
library(dplyr)
c4a_gui()
#配色
library(RColorBrewer)
#col_fun <- colorRampPalette(c("steelblue3","deepskyblue3","grey90","tomato3","#A13D3B"))(100) #设置渐变色

col_fun <- colorRampPalette(rev(brewer.pal(n=9, name="YlGnBu")))(100)
#_______________________________________________________________
####颜色1####
quickcor(data2, cor.test = TRUE) +
  geom_square(data = get_data(type = "lower", show.diag = FALSE)) +
  geom_mark(data = get_data(type = "upper", show.diag = FALSE), size = 6) +
  geom_abline(slope = -1, intercept = 4) +
  scale_fill_gradient2(limits = c(-1, 1)) +  # 设置填充颜色的值范围
  theme(legend.text = element_text(size = 12),  # 设置图例文字大小
        axis.text.x = element_text(size = 12),  # 设置 x 轴标签文字大小
        axis.text.y = element_text(size = 12))  # 设置 y 轴标签文字大小
#_______________________________________________________________
####颜色2####
quickcor(data2, cor.test = TRUE) +
  geom_square(data = get_data(type = "lower", show.diag = FALSE)) +
  geom_mark(data = get_data(type = "upper", show.diag = FALSE), size = 6) +
  geom_abline(slope = -1, intercept = 4) +
  scale_fill_gradient2(limits = c(-1, 1), low = "blue", high = "red") +  # 设置填充颜色的值范围和渐变色
  theme(legend.text = element_text(size = 12),  # 设置图例文字大小
        axis.text.x = element_text(size = 12),  # 设置 x 轴标签文字大小
        axis.text.y = element_text(size = 12))  # 设置 y 轴标签文字大小
#_______________________________________________________________
####颜色3####
p1 <- quickcor(data2, cor.test = TRUE) +
  geom_square(data = get_data(type = "lower", show.diag = FALSE)) +
  geom_mark(data = get_data(type = "upper", show.diag = FALSE), size = 6) +
  geom_abline(slope = -1, intercept = 4) +
  scale_fill_gradientn(colours = col_fun, limits = c(-1, 1)) +  # 设置填充颜色的值范围和配色方案
  theme(
    legend.text = element_text(size = 20),  # 设置图例文字大小
    legend.spacing.y = unit(20, "cm"),     # 设置图例标签的垂直距离为0.5厘米
    axis.text.x = element_text(size = 20),  # 设置 x 轴标签文字大小
    axis.text.y = element_text(size = 20)   # 设置 y 轴标签文字大小
  ) +
  labs(fill = "Correlation",size = 40)  # 设置图例标签

p1
#_______________________________________________________________
####随机森林####
library(randomForest)
library(rfPermute)
set.seed(1)#设置种子，确保结果一致
RF<- randomForest(GPP~., data2, importance = T)
RFs<- rfPermute(GPP~., data2, nperm=5, ntree=10);RFs#nperm = 9 指定了排列次数，ntree = 100 指定了每棵树的数量。
RF;importance(RFs)
#_______________________________________________________________
library(ggplot2)

# 提取特征重要性数据
importance_data <- data.frame(
  Feature = rownames(importance(RFs)),
  Mean_Importance = importance(RFs)[, 1]
)

p2 <- ggplot(importance_data, aes(x = Feature, y = Mean_Importance)) +
  geom_bar(stat = "identity", fill = "skyblue", color = "black") +  # 添加黑色边框
  labs(x = NULL, y = NULL) +  # 去除 x 轴和 y 轴标题
  theme_minimal() +  # 使用简约的主题
  theme(axis.text.x = element_text(angle = 45, hjust = 1, size = 0),  # 调整 x 轴文字角度、位置和大小
        axis.text.y = element_text(color = "black",size = 20),  # 设置 y 轴文字大小
        axis.ticks.y = element_line(color = "black", size = 1),  # 设置 y 轴刻度线颜色
        panel.border = element_blank(),  # 去除外边框
        panel.grid.major = element_blank(),  # 去除主要网格线
        panel.grid.minor = element_blank(),  # 去除次要网格线
        axis.line.x = element_line(color = "black", size = 1),  # 设置 x 轴线条颜色
        axis.line.y = element_line(color = "black", size = 1),  # 设置 y 轴线条颜色
        plot.title = element_text(hjust = 0, size = 20),  # 设置标题居中对齐和大小
        axis.title.y = element_text(vjust = 0)) +  # 设置 y 轴标题与条形图的距离为0
  scale_y_continuous(expand = c(0, 0)) +  # 控制 y 轴坐标的扩展范围
  ggtitle("Explained variation(%)")  # 设置图表标题

p2


#__________________________
####P1和p2进行拼接####
library(cowplot)  # 导入 cowplot 包
library(patchwork)
library(officer)
# 将 p2 和 p1 进行拼接，p2 在上面，p1 在下面，并为整个图形添加背景颜色
combined_plot <- p2 + p1 +
  plot_layout(ncol = 1, heights = c(3, 10)) +
  theme(plot.background = element_rect(fill = "white"))
print(combined_plot)
# 设置图片宽度和高度
combined_plot <- combined_plot + plot_layout(widths = c(500), heights = c(700))

# 保存图形为 EPS 文件
ggsave("F:/research data/studies of fagaceae/重要性+相关性/地形-青冈.eps", combined_plot, device = "eps")
#_______________________________________________________________





blankPlot <- ggplot()+geom_blank(aes(1,1))+ theme_void()

#使用gridExtra包进行拼图；

library("gridExtra")

#gridExtra包的拼图效果非常好，格子线完全是对齐的；
grid.arrange( blankPlot, p2,blankPlot, blankPlot,p1,
              ncol=3, nrow=2)
#___________________________________________________________
####ABG-AGE####
# 加载 readxl 包
library(readxl)
# 读取 Excel 文件
data <- read_excel("F:/research data/map/oak_area picture/ABG_points_TableToExcel.xlsx")
#___________________________________________________________________
####提取各属数据####
data1<- data[, c("age", "AGBt")]
data2<-data[, c("Stand_origin")]
data2<-data[, c("land_type")]
stand_origin <- subset(data, Stand_origin == "Planted")#为人工
stand_origin <- subset(data, !(Stand_origin == "Planted"))#为天然
df<-data[,c(1,8,18,23:26,28)]
#____________________________________________________________________
####缺失值补充####
library(zoo)
df<- na.aggregate(df, FUN = mean)
data1 <- na.aggregate(data1, FUN = mean)
# 合并两个数据框
data <- cbind(data1, data2)
#____________________________________________________________________
####筛选变量-剔除异常值####
data <- subset(data, AGBt < 500)
#____________________________________________________________________
####AGBt-AGE制图
library(ggplot2)
library("rlang")
library(ggpmisc)

p1library(ggplot2)

p1 <- ggplot(data, aes(x = age , y = AGBt, color = Stand_origin)) +
  geom_point() +
  stat_smooth(method = "lm", se = FALSE, formula = y ~ x, aes(group = Stand_origin)) +
  stat_poly_eq(formula = y ~ x, 
               aes(label = paste(..eq.label.., " (p = ", formatC(..p.value.., digits = 2, format = "fg", flag = "#"), ")", sep = ""), 
                   color = Stand_origin), 
               parse = TRUE,
               size = 8) +
  theme_bw() +
  theme(legend.title = element_text(size = 20),
        legend.text = element_text(size = 20),  # 设置图例文字大小为10
        axis.title = element_text(size = 20),   # 设置坐标轴标题大小为10
        axis.text = element_text(size = 20),
        panel.grid = element_blank()) +  # 去除网格线
  labs(x = "林龄", y = "地上生物量", color = "Stand Origin") 

p1


p2 <- ggplot(data, aes(x = age , y = AGBt, color = land_type)) +
  geom_point() +
  stat_smooth(method = "lm", se = FALSE, formula = y ~ x, aes(group = land_type)) +
  stat_poly_eq(formula = y ~ x, 
               aes(label = paste(..eq.label.., " (p = ", formatC(..p.value.., digits = 2, format = "fg", flag = "#"), ")", sep = ""), 
                   color = land_type), 
               parse = TRUE,
               size = 10) +
  theme_bw() +
  labs(x = "林龄", y = "地上生物量", color = "森林类型") +  # 修改颜色图例的名称为 "森林类型"
  theme(legend.title = element_text(size = 20),      # 设置图例标题字体大小为 10
        legend.text = element_text(size = 20),       # 设置图例文字大小为 10
        axis.title = element_text(size = 20),        # 设置坐标轴标题大小为 10
        axis.text = element_text(size = 20))        # 设置坐标轴刻度标签大小为 10

p2


library("gridExtra")

#gridExtra包的拼图效果非常好，格子线完全是对齐的；
grid.arrange( p1,p2,   ncol=2, nrow=1)

####相关性####
# 计算相关性矩阵
cor_matrix <- cor(df, use = "pairwise.complete.obs")
#__________________________________________________________________
####随机森林求重要值####
library(randomForest)
rfModel <- randomForest(AGBt ~ ., data=df, ntree=500, importance=TRUE)
importance(rfModel)  # 获取特征的重要性
varImpPlot(rfModel,type=1,main='环境变量对地上生物量的相对重要值')  # 可视化特征的重要性
#___________________________________________________________________
####偏依赖图####
#install.packages("pdp")
library(ggplot2)
library(pdp)
#____________________________________________________________________
# 计算变量 "age_1km" 的偏依赖值
partial_age <- partial(rfModel, pred.var = "age")
partial_age<-partial_age[-c(45:51),]

# 创建数据框
df <- data.frame(x = seq(125, 150, by = 1), y = rep(175, times = 26))

# 打印数据框
print(df)
colnames(df)<-colnames(partial_age)

partial_age<-rbind(partial_age,df)










# 绘制变量 "age_1km" 的偏依赖图
autoplot(partial_age, plot = TRUE,color="white") +
  labs(title = "          地上生物量对林龄的偏依赖图", x = "林龄", y = "地上生物量")+
  theme_bw()+
  theme(panel.background = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),text=element_text(size=15,  family="serif"))+
  geom_smooth(method = "loess", se = FALSE, color = "black", linetype = "solid")
