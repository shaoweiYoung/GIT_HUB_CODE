####模型构建数据准备####
# 设置工作目录到CSV文件所在的文件夹（可选）
# setwd("F:/research data/studies of fagaceae/aok/PYX")

# # 读取CSV文件
# data1 <- read.csv("GPP.csv", header = TRUE)
# data2 <- read.csv("PRE_pc1.csv", header = TRUE)
# data3 <- read.csv("PRE_TEM_pc1.csv", header = TRUE)
# data4 <- read.csv("soil1_pc1.csv", header = TRUE)
# data5 <- read.csv("soil2_pc1.csv", header = TRUE)
# data6 <- read.csv("stand_pc1.csv", header = TRUE)
# data7 <- read.csv("TEM_pc1.csv", header = TRUE)
# data8 <- read.csv("topographic_pc1.csv", header = TRUE)
# YX <- read.csv("YX.csv", header = TRUE)

# # 重新命名列
# colnames(data1) <- c( "X", "GPP")
# colnames(data2) <- c( "X", "PRE_pc1")
# colnames(data3) <- c( "X", "PRE_TEM_pc1")
# colnames(data4) <- c( "X", "soil1_pc1")
# colnames(data5) <- c( "X", "soil2_pc1")
# colnames(data6) <- c( "X", "stand_pc1")
# colnames(data7) <- c( "X", "TEM_pc1")
# colnames(data8) <- c( "X", "topographic_pc1")
# #矩阵
# data <- cbind(data1, data2, data3, data4, data5, data6, data7, data8)
# #提取x和Y数据
# YX1<-data[,c(2,4,6,8,10,12,14,16)]
# # 重新命名列
# colnames(YX1) <- c( "Y", "x1","x2","x3","x4","x5","x6","x7")
# 
# # 步骤1: 标准化YX1数据
# YX_scaled <- scale(YX1)
# 
# # 步骤2: 将矩阵转换为data.frame
# YX <- as.data.frame(YX_scaled)

# # 步骤3: 确保列名正确
# colnames(YX) <- colnames(YX1)  # 保持和YX1相同的列名
# # 指定保存CSV文件的路径和文件名
# output_file_path <- "F:/research data/studies of fagaceae/aok/PCA/YX.csv"
# 
# # 将数据框保存到CSV文件中
# write.csv(YX, output_file_path, row.names = FALSE)



####线性回归模型####
# 加载caret包
# library(caret)
# partition <- createDataPartition(YX[, 1], p=0.7, list=FALSE)
# trainData <- YX[partition, ]
# testData <- YX[-partition, ]
# linear_model <- lm(Y ~ x1 + x2 + x3+ x4+x5+x6+x7, data = trainData)
# print(linear_model)
# summary(linear_model)
# 
# predictions <- predict(linear_model, newdata = testData)
# 
# # 计算R^2
# R2 <- cor(predictions, testData$Y)^2
# 
# # 计算RMSE
# RMSE <- sqrt(mean((predictions - testData$Y)^2))
# 
# # 计算MAE
# MAE <- mean(abs(predictions - testData$Y))
# 
# # 计算ME
# ME <- mean(predictions - testData$Y)
# 
# # 打印性能评估指标
# cat("R^2: ", R2, "\n",
#     "RMSE: ", RMSE, "\n",
#     "MAE: ", MAE, "\n",
#     "ME: ", ME, "\n")










####随机森林模型构建加上10折交叉验证####
#修改后的构建和评估随机森林模型的函数，加入参数优化####
# build_and_evaluate_rf_model_with_optimization <- function(YX) {
#   # 加载必要的库
#   if (!requireNamespace("randomForest", quietly = TRUE)) {
#     install.packages("randomForest")
#   }
#   library(randomForest)
# 
#   if (!requireNamespace("caret", quietly = TRUE)) {
#     install.packages("caret")
#   }
#   library(caret)
# 
#   # 分割数据为训练集和测试集
#   set.seed(123) # 保证结果可重复
#   partition <- createDataPartition(YX[, 1], p=0.8, list=FALSE)
#   trainingData <- YX[partition, ]
#   testData <- YX[-partition, ]
#   
#   # 定义参数网格
#   tuneGrid <- expand.grid(.mtry = c(2, 3, 4, 5, 6)) # 示例中包含了mtry的几个可能值
# 
#   # 训练控制
#   control <- trainControl(method = "cv", number = 10) # 10折交叉验证
# 
#   # 使用caret包进行模型训练和参数优化
#   randomForest_optimized_model <- train(x = trainingData[, -1], y = trainingData[, 1],
#                                         method = "rf",
#                                         tuneGrid = tuneGrid,
#                                         trControl = control)
# 
#   # 使用测试集进行预测
#   predictions <- predict(randomForest_optimized_model, newdata = testData[, -1])
# 
#   # 计算评估指标
#   R2 <- cor(predictions, testData[, 1])^2
#   RMSE <- sqrt(mean((predictions - testData[, 1])^2))
#   MAE <- mean(abs(predictions - testData[, 1]))
#   ME <- mean(predictions - testData[, 1])
# 
#   # 返回一个包含所有评估指标的列表
#   return(list(R2 = R2, RMSE = RMSE, MAE = MAE, ME = ME))
# }
# build_and_evaluate_rf_model_with_optimization(YX)



####安装github里面的R包####
library(devtools)
devtools::install_github(repo="edwindj/ffbase")
install_github("edwindj/ffbase")
install.packages(c("tidyverse", "sf", "emo", "janitor", "palmerpenguins", "usethis", "lubridate"))
install_github("edwindj/ffbase", subdir="pkg")


####随机森林无10折交叉验证####
library(ffbase)
library(randomForest)
library(caret)
library(Metrics)  # 用于计算 MAE, RMSE 和 ME

# 设置文件路径
filePath <- "F:/research data/studies of fagaceae/aok/PCA/YX.csv"

# 使用 read.csv.ffdf 从 CSV 文件中读取数据
YX_ffdf <- read.csv.ffdf(file = filePath)
# 尝试将 ffdf 数据转换为 data.frame
YX_df <- as.data.frame(YX_ffdf)

set.seed(123) # 确保可重复性
trainingIndex <- createDataPartition(YX_df$Y, p=0.7, list=FALSE)

# 分割数据为训练集和测试集
trainData <- YX_df[trainingIndex, ]
testData <- YX_df[-trainingIndex, ]

# 训练随机森林模型
rfModel <- randomForest(Y ~ ., data=trainData, ntree=5)

# 使用测试集评估模型
testPredict <- predict(rfModel, newdata=testData)

# 计算模型的性能指标
r2_score <- cor(testData$Y, testPredict)^2
rmse_score <- rmse(testData$Y, testPredict)
mae_score <- mae(testData$Y, testPredict)
me_score <- mean(testPredict - testData$Y)

# 输出性能指标
print(paste("R^2:", r2_score))
print(paste("RMSE:", rmse_score))
print(paste("MAE:", mae_score))
print(paste("ME:", me_score))

# 输出模型摘要
print(summary(rfModel))
summary(rfModel)





####SVM模型####
library(caret)  # 加载 caret 包进行模型训练和评估
library(e1071)  # 加载 e1071 包，包含 SVM 训练的函数
library(ffbase)
library(randomForest)
library(caret)
library(Metrics)  # 用于计算 MAE, RMSE 和 ME

# 数据准备
filePath <- "F:/research data/studies of fagaceae/aok/PCA/YX.csv"
YX_ffdf <- read.csv.ffdf(file = filePath)
YX_df <- as.data.frame(YX_ffdf)  # 将数据转换为数据框格式

# 创建训练集和测试集
set.seed(123)  # 设置随机种子以确保结果可重现
trainingIndex <- createDataPartition(YX_df$Y, p=0.7, list=FALSE)  # 70% 数据用于训练
trainData <- YX_df[trainingIndex, ]
testData <- YX_df[-trainingIndex, ]

# 训练 SVM 模型，此处不使用交叉验证
svmModel <- train(Y ~ ., data=trainData, method="svmRadial")  # 预处理包括数据标准化

# 使用测试集进行模型评估
testPredict <- predict(svmModel, newdata=testData)

# 计算模型性能指标
r2_score <- cor(testData$Y, testPredict)^2  # 计算 R^2 值
rmse_score <- Metrics::rmse(testData$Y, testPredict)  # 计算 RMSE 值
mae_score <- Metrics::mae(testData$Y, testPredict)  # 计算 MAE 值
me_score <- mean(testPredict - testData$Y)  # 计算平均误差

# 输出模型性能指标
print(paste("R^2:", r2_score))
print(paste("RMSE:", rmse_score))
print(paste("MAE:", mae_score))
print(paste("ME:", me_score))

# 输出模型摘要
print(summary(svmModel))





####gbm模型构建####
library(caret)
library(ffbase)
library(randomForest)
library(gbm)
library(e1071) # SVM
library(Metrics)
# 数据准备
filePath <- "F:/research data/studies of fagaceae/aok/PCA/YX.csv"
YX_ffdf <- read.csv.ffdf(file = filePath)
YX_df <- as.data.frame(YX_ffdf)

# 创建训练集和测试集
set.seed(123)
trainingIndex <- createDataPartition(YX_df$Y, p=0.7, list=FALSE)
trainData <- YX_df[trainingIndex, ]
testData <- YX_df[-trainingIndex, ]

# 单独使用GBM模型训练和评估
fit_gbm <- train(Y ~ ., data=trainData, method="gbm", trControl=trainControl(method="cv", number=10), verbose=FALSE)
predictions_gbm <- predict(fit_gbm, newdata=testData)
r2_score_gbm <- cor(testData$Y, predictions_gbm)^2
rmse_score_gbm <- rmse(testData$Y, predictions_gbm)
mae_score_gbm <- mae(testData$Y, predictions_gbm)
me_score_gbm <- mean(predictions_gbm - testData$Y)

# 输出GBM模型的性能指标
print(paste("GBM R^2:", r2_score_gbm))
print(paste("GBM RMSE:", rmse_score_gbm))
print(paste("GBM MAE:", mae_score_gbm))
print(paste("GBM ME:", me_score_gbm))
# 输出模型摘要
print(summary(fit_gbm))  # 显示模型的详细摘要





####CatBoost模型####
# 加载必要的库
# install.packages('devtools')
# devtools::install_url('https://github.com/catboost/catboost/releases/download/v1.1.1/catboost-R-Windows-1.1.1.tgz', INSTALL_opts = c("--no-multiarch", "--no-test-load"))
# devtools::install_url('https://github.com/catboost/catboost/releases/download/v1.1.1/catboost-R-Windows-1.1.1.tgz')
# devtools::install_url('https://github.com/catboost/catboost/releases/download/v1.1.1/catboost-R-Windows-1.1.1.tgz', quiet = FALSE)

# 加载库
library(catboost)
library(caret)  # 用于数据分割和模型训练
library(Metrics)  # 用于性能指标
library(data.table)  # 高效数据处理
library(ffbase)

# 读取数据
filePath <- "F:/research data/studies of fagaceae/aok/PCA/YX.csv"
YX_df <- fread(filePath)

# 数据分割
set.seed(123)  # 设置随机种子以确保结果可复现
trainingIndex <- createDataPartition(YX_df$Y, p = 0.7, list = FALSE)
trainData <- YX_df[trainingIndex, ]
testData <- YX_df[-trainingIndex, ]

# 定义 CatBoost 模型的参数
params <- list(
  iterations = 1000,
  learning_rate = 0.03,
  depth = 6,
  loss_function = 'RMSE',
  eval_metric = 'RMSE',
  random_seed = 42,
  od_type = 'Iter',
  od_wait = 20
)

# 训练模型
train_pool <- catboost.load_pool(data = trainData[, -which(names(trainData) == "Y"), with = FALSE], label = trainData$Y)
test_pool <- catboost.load_pool(data = testData[, -which(names(testData) == "Y"), with = FALSE], label = testData$Y)
fit_catboost <- catboost.train(learn_pool = train_pool, test_pool = test_pool, params = params)

# 使用 catboost.predict 进行预测
predictions_catboost <- catboost.predict(fit_catboost, test_pool)

# 计算性能指标
r2_score_catboost <- cor(testData$Y, predictions_catboost)^2
rmse_score_catboost <- sqrt(mean((testData$Y - predictions_catboost)^2))
mae_score_catboost <- mean(abs(testData$Y - predictions_catboost))
me_score_catboost <- mean(testData$Y - predictions_catboost)

# 输出模型的性能指标
cat("CatBoost R^2:", r2_score_catboost, "\n")
cat("CatBoost RMSE:", rmse_score_catboost, "\n")
cat("CatBoost MAE:", mae_score_catboost, "\n")
cat("CatBoost ME:", me_score_catboost, "\n")




####LightGBM训练模型####
library(data.table)
library(caret)
library(lightgbm)
library(Metrics)  # For calculating RMSE and MAE
library(performance)  # For calculating R^2

# Read the data
filePath <- "F:/research data/studies of fagaceae/aok/PCA/YX.csv"
YX_df <- fread(filePath)

# Create training and test sets
set.seed(123)
trainingIndex <- createDataPartition(YX_df$Y, p=0.7, list=FALSE)
trainData <- YX_df[trainingIndex, ]
testData <- YX_df[-trainingIndex, ]

# Prepare data for LightGBM
train_features <- trainData[, -which(names(trainData) == "Y"), with = FALSE]
test_features <- testData[, -which(names(testData) == "Y"), with = FALSE]

dtrain <- lgb.Dataset(data = as.matrix(train_features), label = trainData$Y)
dtest <- lgb.Dataset(data = as.matrix(test_features), label = testData$Y)

# Define LightGBM model parameters
params <- list(
  objective = "regression",
  metric = "rmse",
  num_leaves = 31,
  learning_rate = 0.05,
  num_iterations = 100
)

# Train the model
fit_lgbm <- lgb.train(
  params = params,
  data = dtrain,
  valids = list(test = dtest),
  nrounds = 100,
  verbose = 0
)

# Make predictions
predictions <- predict(fit_lgbm, as.matrix(test_features))

# 手动计算残差
residuals <- testData$Y - predictions

# 使用残差计算 RMSE
test_rmse <- sqrt(mean(residuals^2))
test_mae <- mean(abs(residuals))
test_me <- mean(residuals)

# 计算 R^2
test_r2 <- cor(testData$Y, predictions)^2

# 打印指标
cat("Test RMSE:", test_rmse, "\n")
cat("Test MAE:", test_mae, "\n")
cat("Test ME:", test_me, "\n")
cat("Test R^2:", test_r2, "\n")

# Visualize the prediction results vs actual results
plot(testData$Y, predictions, main = "Actual vs Predicted", xlab = "Actual", ylab = "Predicted", pch = 19)
abline(a = 0, b = 1, col = "red")






####XGBoost 模型####
# 加载必要的库
library(xgboost)
library(caret)  # 用于数据分割和模型训练
library(data.table)  # 高效数据处理

# 读取数据
filePath <- "F:/research data/studies of fagaceae/aok/PCA/YX.csv"
YX_df <- fread(filePath)

# 数据分割
set.seed(123)  # 设置随机种子以确保结果可复现
trainingIndex <- createDataPartition(YX_df$Y, p = 0.75, list = FALSE)
trainData <- YX_df[trainingIndex, ]
testData <- YX_df[-trainingIndex, ]

# 转换数据为 XGBoost 可用的矩阵格式
train_matrix <- xgb.DMatrix(data = as.matrix(trainData[, -which(names(trainData) == "Y"), with = FALSE]), label = trainData$Y)
test_matrix <- xgb.DMatrix(data = as.matrix(testData[, -which(names(testData) == "Y"), with = FALSE]), label = testData$Y)

# 定义 XGBoost 模型的参数
params <- list(
  booster = "gbtree",
  objective = "reg:squarederror",
  eta = 0.1,
  gamma = 0,
  max_depth = 6,
  min_child_weight = 1,
  subsample = 0.8,
  colsample_bytree = 0.8
)

# 训练模型
xgb_model <- xgb.train(params = params, data = train_matrix, nrounds = 100, watchlist = list(eval = test_matrix, train = train_matrix), print_every_n = 10)

# 进行预测
predictions_xgb <- predict(xgb_model, test_matrix)

# 计算性能指标
r2_score_xgb <- cor(testData$Y, predictions_xgb)^2
rmse_score_xgb <- sqrt(mean((testData$Y - predictions_xgb)^2))
mae_score_xgb <- mean(abs(testData$Y - predictions_xgb))
me_score_xgb <- mean(testData$Y - predictions_xgb)  # 计算平均误差 ME

# 输出模型的性能指标
cat("XGBoost R^2:", r2_score_xgb, "\n")
cat("XGBoost RMSE:", rmse_score_xgb, "\n")
cat("XGBoost MAE:", mae_score_xgb, "\n")
cat("XGBoost ME:", me_score_xgb, "\n")  # 输出 ME




####模型堆叠####
library(caret)
library(randomForest)
library(gbm)
library(e1071) # SVM
library(ffbase)

# 数据准备
filePath <- "F:/research data/studies of fagaceae/aok/PCA/YX.csv"
YX_ffdf <- read.csv.ffdf(file = filePath)
YX_df <- as.data.frame(YX_ffdf)

# 创建训练集和测试集
set.seed(123)
trainingIndex <- createDataPartition(YX_df$Y, p=0.7, list=FALSE)
trainData <- YX_df[trainingIndex, ]
testData <- YX_df[-trainingIndex, ]

# 训练不同的模型
set.seed(123)
fit_rf <- train(Y ~ ., data=trainData, method="rf", trControl=trainControl(method="cv", number=10))
fit_svm <- train(Y ~ ., data=trainData, method="svmRadial", trControl=trainControl(method="cv", number=10))
fit_gbm <- train(Y ~ ., data=trainData, method="gbm", trControl=trainControl(method="cv", number=10), verbose=FALSE)

# 堆叠模型
model_list <- list(rf = fit_rf, svm = fit_svm, gbm = fit_gbm)
stack_control <- trainControl(method="cv", number=10)
stacked_model <- caretStack(model_list, method="glm", trControl=stack_control)

# 使用堆叠模型对测试数据进行预测
predictions <- predict(stacked_model, newdata=testData)

# 评估模型
r2_score <- cor(testData$Y, predictions)^2
rmse_score <- rmse(testData$Y, predictions)
mae_score <- mae(testData$Y, predictions)
me_score <- mean(predictions - testData$Y)

# 输出性能指标
print(paste("R^2:", r2_score))
print(paste("RMSE:", rmse_score))
print(paste("MAE:", mae_score))
print(paste("ME:", me_score))

# 输出堆叠模型的摘要
print(summary(stacked_model))





####数据检查####
# data9 <- read.csv("F:/research data/studies of fagaceae/aok/the process/GEE table/add 37soil totol/soil_merged_data.csv", header = TRUE)
# data10 <- read.csv("F:/research data/studies of fagaceae/aok/the process/GEE table/add 37soil totol/stand_merged_data.csv", header = TRUE)
# 假设data9和data10都有一个名为'ID'的列，我们根据这个列来合并它们
# merged_data <- merge(data9, data10, by = "ID")
# 
# # 查看合并后的数据
# head(merged_data)
# soil<-merged_data[,c(seq(3,112, by = 3))]
# new_column_names <- c("AK", "AL", "AN", "AP", "BD", "C1", "CA", "CEC", "CL", "CW1", "Dc", "Dh", "GRAV", "H", "K", "LDEP", "LNUM", "MG", "NA", "PDEP", "PH", "POR", "R", "RC", "RS", "S1", "SA", "SI", "SOM", "SW1", "TK", "TN", "TP", "Unc", "Unh", "Wc", "Wh")
