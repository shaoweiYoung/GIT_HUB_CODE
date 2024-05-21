import geopandas as gpd
import numpy as np
# 通过指定Shapefile文件的完整路径来加载数据
file_path = 'E:/ecosystem service/forest ecosystem service/forest age/desktop/age desktop/highage.shp'
dataset = gpd.read_file(file_path)
# 确保数据中包含用于训练模型的特征列和目标列
# 选择特征列和目标列
y =  dataset.iloc[:, 4]
X = dataset.iloc[:, 6:11]

# 将数据分为训练集和测试集
from sklearn.model_selection import train_test_split

X_train, X_test, y_train, y_test = train_test_split(X,
                                                    y,
                                                    test_size=0.2,
                                                    random_state=0)

# 特征缩放，通常没必要
# 因为数据单位，自变量数值范围差距巨大，不缩放也没问题
from sklearn.preprocessing import StandardScaler

sc = StandardScaler()
X_train = sc.fit_transform(X_train)
X_test = sc.transform(X_test)

# 训练随机森林解决回归问题
from sklearn.ensemble import RandomForestRegressor

regressor = RandomForestRegressor(n_estimators=200, random_state=0)
regressor.fit(X_train, y_train)
y_pred = regressor.predict(X_test)

# 评估回归性能
from sklearn import metrics

print('Mean Absolute Error:', metrics.mean_absolute_error(y_test, y_pred))
print('Mean Squared Error:', metrics.mean_squared_error(y_test, y_pred))
print('Root Mean Squared Error:',
      np.sqrt(metrics.mean_squared_error(y_test, y_pred)))

import pandas as pd

# 加载新的xlsx数据
print("加载新的xlsx数据")
xlsx_file_path = 'C:/path_to_your_data/data.xlsx'
new_data = pd.read_excel(xlsx_file_path)

# 选择特征列（假设与训练时相同）
print("选择特征列（假设与训练时相同）")
X_new = new_data.iloc[:, 1:6]  # 假设索引1到5为特征列

# 特征缩放（如果在训练时做过缩放，需要使用同样的缩放器对象sc）
print("特征缩放（如果在训练时做过缩放，需要使用同样的缩放器对象sc")
X_new_scaled = sc.transform(X_new)  # 使用之前创建的缩放器对象sc对新数据进行缩放

# 使用模型进行预测
print("使用模型进行预测")
predicted_values_new = regressor.predict(X_new_scaled)
