# 加载必要的库
library(dplyr)
library(tidyr)

# 设置包含CSV文件的目录
setwd("F:/research data/studies of fagaceae/aok/the process/GEE table/add 37soil totol")

# 列出目录中的所有CSV文件
files <- list.files(pattern = "*.csv")

# 初始化一个空的数据框来存储合并后的数据
all_data <- NULL

# 遍历文件并逐个加载
for (file in files) {
  # 读取CSV文件
  temp_data <- read.csv(file)
  
  # 检查是否是第一个文件
  if (is.null(all_data)) {
    all_data <- temp_data
  } else {
    # 使用dplyr的full_join根据ID列合并数据
    all_data <- full_join(all_data, temp_data, by = "ID")
  }
}

# 查看合并后的数据框
print(all_data)


# 指定保存CSV文件的路径和文件名
output_file_path <- "F:/research data/studies of fagaceae/aok/the process/GEE table/soil boi stand topographic_merged_data.csv"

# 将数据框保存到CSV文件中
write.csv(topographic, output_file_path, row.names = FALSE)

# 打印消息确认保存完成
print(paste("数据已成功保存到", output_file_path))


# 构建一个包含所需列索引的向量：第2列以及3-93之间3的倍数的列
columns_to_select <- c(2, seq(3, 93, by = 3))

# 使用select函数根据列索引选择列
new_data <- select(all_data, columns_to_select)

# 查看新的数据框
print(new_data)



# 假设数据框名为data，我们想保存其第一列
first_column_data <- all_data[1,]  # 选择第一列数据

# 指定保存CSV文件的路径和文件名
output_file_path <- "F:/research data/studies of fagaceae/aok/the process/GEE table/totol/merged_data_head title.csv.csv"  # 替换为实际的文件路径和文件名

# 将第一列数据保存到CSV文件中
write.csv(first_column_data, output_file_path, row.names = FALSE)

# 打印消息确认保存完成
print(paste("第一列数据已成功保存到", output_file_path))


#缺失值补充,直接补充到原始表中
# 加载必要的库
library(dplyr)

# 对于第2到第32列的数值数据，使用列的平均值来填充缺失值
for(i in 2:32) {
  # 检查列是否为数值类型
  if(is.numeric(new_data[,i])) {
    # 使用该列的平均值填充缺失值
    new_data[,i] <- ifelse(is.na(new_data[,i]), mean(new_data[,i], na.rm = TRUE), new_data[,i])
  } else {
    # 如果列是分类数据，找出最常见的值
    most_common_value <- names(sort(table(new_data[,i]), decreasing = TRUE))[1]
    # 使用最常见的值填充缺失值
    new_data[,i] <- ifelse(is.na(new_data[,i]), most_common_value, new_data[,i])
  }
}

# 查看处理后的数据框
print(head(new_data))

# 创建X和Y矩阵
library(factoextra)
library(FactoMineR)
library(ggplot2)

X <- new_data[, c(2:24, 26:32)]  # 选择X变量列
Y <- new_data[, 25]  # 选择Y变量列
# 执行PCA分析
pca_res <- PCA(X, graph = FALSE)
# 可视化PCA结果
fviz_pca_ind(pca_res)


# 查看各个主成分的解释度（贡献率）
eigenvalues <- get_eigenvalue(pca_res)

# 打印前6个主成分的解释度和累计贡献率
print(eigenvalues[1:6, ])

# 可视化前6个主成分的贡献
fviz_eig(pca_res, addlabels = TRUE, ylim = c(0, 100), ncp = 6)

# 可视化PCA结果的前两个主成分，并突出前6个主成分
fviz_pca_ind(pca_res, col.ind = "cos2", gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
             select.ind = list(cos2 = 6))


# 前提是已加载FactoMineR和factoextra包，并且完成了PCA分析

# 选取PCA结果的前6个主成分进行群集分析
pc_data <- pca_res$ind$coord[, 1:5]

# 使用k-means方法进行群集分析，这里假设分为3个群集
set.seed(123)  # 设置种子以确保结果可重现
km_res <- kmeans(pc_data, centers = 3)

# 查看群集分析结果
print(km_res$size)  # 打印每个群集的大小
print(km_res$centers)  # 查看各群集中心

# 使用factoextra包可视化群集结果
fviz_cluster(km_res, data = pc_data)
