import pandas as pd
import numpy as np
from matplotlib import pyplot as plt
from sklearn.ensemble import RandomForestRegressor
from sklearn.model_selection import train_test_split
from sklearn.metrics import mean_squared_error, r2_score
from pyswarm import pso
import rasterio
# import pydot
import numpy as np
import pandas as pd
import scipy.stats as stats
from pprint import pprint
from sklearn import metrics
from sklearn.model_selection import GridSearchCV
from sklearn.model_selection import RandomizedSearchCV
from joblib import dump
# 读取Excel表格数据
data = pd.read_csv(r'E:\Sentinel12\yangben\建模\jianmo.csv' )
y = data.iloc[:, 0].values  # SIG-GPP
X = data.iloc[:, 1:].values  # 指标变量
df = pd.DataFrame(data)
random_seed=44
random_forest_seed=np.random.randint(low=1,high=230)
# 分割数据集为训练集和测试集
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.3, random_state=42)
# Search optimal hyperparameter
#对六种超参数划定了一个范围，然后将其分别存入了一个超参数范围字典random_forest_hp_range
n_estimators_range=[int(x) for x in np.linspace(start=50,stop=3000,num=60)]
max_features_range=['sqrt','log2',None]
max_depth_range=[int(x) for x in np.linspace(10,500,num=50)]
max_depth_range.append(None)
min_samples_split_range=[2,5,10]
min_samples_leaf_range=[1,2,4,8]

random_forest_hp_range={'n_estimators':n_estimators_range,
                        'max_features':max_features_range,
                        'max_depth':max_depth_range,
                        'min_samples_split':min_samples_split_range,
                        'min_samples_leaf':min_samples_leaf_range
                        }
random_forest_model_test_base=RandomForestRegressor()
random_forest_model_test_random=RandomizedSearchCV(estimator=random_forest_model_test_base,
                                                   param_distributions=random_forest_hp_range,
                                                   n_iter=200,
                                                   n_jobs=-1,
                                                   cv=3,
                                                   verbose=1,
                                                   random_state=random_forest_seed
                                                   )

best_hp_now=random_forest_model_test_random.best_params_
# Build RF regression model with optimal hyperparameters
random_forest_model_final=random_forest_model_test_random.best_estimator_
print(best_hp_now)
# Predict test set data
random_forest_predict = random_forest_model_test_random.predict(X_test)
random_forest_error = random_forest_predict - y_test

plt.figure(1)
plt.clf()
plt.hist(random_forest_error)
plt.xlabel('Prediction Error')
plt.ylabel('Count')
plt.grid(False)
plt.show()
# 计算特征重要性
random_forest_importance = list(random_forest_model_final.feature_importances_)
random_forest_feature_importance = [(feature, round(importance, 8))
                                    for feature, importance in zip(df.columns[4:], random_forest_importance)]
random_forest_feature_importance = sorted(random_forest_feature_importance, key=lambda x:x[1], reverse=True)

# 将特征重要性转换为Pyecharts所需的格式
x_data = [item[0] for item in random_forest_feature_importance]
y_data = [item[1] for item in random_forest_feature_importance]

# 绘制柱状图
bar = (
    Bar()
    .add_xaxis(x_data)
    .add_yaxis("", y_data)
    .reversal_axis()
    .set_series_opts(label_opts=opts.LabelOpts(position="right"))
    .set_global_opts(
        title_opts=opts.TitleOpts(title="Variable Importances"),
        xaxis_opts=opts.AxisOpts(name="Importance",axislabel_opts=opts.LabelOpts(rotate=-45, font_size=10)),
        yaxis_opts=opts.AxisOpts(name_gap=30, axisline_opts=opts.AxisLineOpts(is_show=False)),
        tooltip_opts=opts.TooltipOpts(trigger="axis", axis_pointer_type="shadow")
    )
)

bar.render_notebook()

import numpy as np
import rasterio
from tqdm import tqdm

# 读取五个栅格指标变量数据并整合为一个矩阵
with rasterio.open(r'E:\Sentinel12\yangben\建模\result\nodata\podu.tif') as src:
    data1 = src.read(1)
    meta = src.meta
with rasterio.open(r'E:\Sentinel12\yangben\建模\result\nodata\dem.tif') as src:
    data2 = src.read(1)
with rasterio.open(r'E:\Sentinel12\yangben\建模\result\nodata\lai.tif') as src:
    data3 = src.read(1)
with rasterio.open(r'E:\Sentinel12\yangben\建模\result\nodata\ndvi.tif') as src:
    data4 = src.read(1)
with rasterio.open(r'E:\Sentinel12\yangben\建模\result\nodata\pvi.tif') as src:
    data5 = src.read(1)

X = np.stack((data1, data2, data3, data4, data5), axis=-1)

# 清洗输入数据
X_2d = X.reshape(-1, X.shape[-1])
# 检查数据中是否存在 NaN 值
print(np.isnan(X_2d).any())  # True

# 将 nodata 值替换为0
X_2d[np.isnan(X_2d)] = 0

# 使用已经训练好的随机森林模型对整合后的栅格指标变量数据进行生物量的预测
y_pred = []
for i in tqdm(range(0, X_2d.shape[0], 10000)):
    y_pred_chunk = random_forest_model_test_random.predict(X_2d[i:i+10000])
    y_pred.append(y_pred_chunk)
y_pred = np.concatenate(y_pred)

# 将预测结果保存为一个新的栅格数据
with rasterio.open(r'E:\Sentinel12\yangben\建模\result\biomass_v5.tif', 'w', **meta) as dst:
    dst.write(y_pred.reshape(X.shape[:-1]), 1)
print("预测结束")
