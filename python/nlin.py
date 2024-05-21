import os
import pandas as pd
import numpy as np
#导入拟合函数least squares最小二乘
from scipy.optimize import least_squares
#导入模型评估函数
from sklearn.metrics import r2_score, mean_absolute_error, mean_squared_error
"""一、读入数据，并做预处理"""
data = pd.read_excel("F:/research data/jiangxi/PCA1andGPPWRA.xlsx")
#group
group_data = data[data['group'] == 1]
#1.1 提取因变量 =Y
Y= group_data.loc[:, "WRA"]
#Y= group_data.loc[:, "GPP"]
print(Y)
#1.2 GPP亚热带落叶阔叶林函数关系
print(group_data)
x1 = group_data.iloc[:, [2, 3, 4, 5, 6, 7]]
print(x1)
# 检查 x1 中每列的数据类型
print("数据类型:")
print(x1.dtypes)

# 检查 x1 中是否有非数值型的数据
def check_invalid_characters(val):
    try:
        float(val)
        return False
    except ValueError:
        return True

invalid_characters = x1.applymap(check_invalid_characters)
print("包含无效字符的位置:")
print(invalid_characters[invalid_characters].stack())
#1.3计算GPP二次项
x4 = pd.DataFrame()
for i in range(x1.shape[1]):
    # 提取“两尘四气"的第i列
    xi = x1.iloc[:, i]
    for j in range(i, x1.shape[1]):
        # 提取“两尘四气"的第j列
        xj = x1.iloc[:, j]
        # 计算xi*xj
        xixj = xi*xj
        # 定义xixj的列标签
        xixj.name = x1.columns[i] + 'x' + x1.columns[j]
        # 往x4里面添加列
        x4 = pd.concat((x4, xixj), axis=1)
#1.4合并X1和X4
df_list =[x1,x4]
X= pd.DataFrame()
for df in df_list:
    X = pd.concat((X, df), axis=1)
# 将X写入excel
X.to_excel("F:/research data/jiangxi/GPP亚热带落叶阔叶林完全二次矩阵.xlsx")

"""二、建模:用python来表达数学模型"""
#2.1非线性回归模型
# 建模函数 kouzhaoxiaoliang
def kouzhaoxiaoliang(beta, X):
    Yupper = beta[0] + np.dot(X, beta[1:28])
    #Ylower = 1 + np.dot(X, beta[28:55])  # 修正了这里的索引
    return Yupper

# 2.2 残差函数
def cancha_kouzhaoxiaoliang(beta, X, Y):
    err = Y - kouzhaoxiaoliang(beta, X)
    return err
"""三、参数估计"""
# 3.1 设定迭代初值
r = X.shape[1]  # 添加缺失的等号
b0 = np.ones(2*r+1)
# 3.2 参数估计
# 使用数据估计初始参数值
results = least_squares(cancha_kouzhaoxiaoliang, b0, args=(X, Y))  # 将 bo 改为 b0
# 3.3 提取参数
p = results.x
print("参数估计值".center(40, "*"), '\n', 'beta =', '\n', p)  # 将“参数传计值”改为“参数估计值”，修正逗号为句号


# 打印函数表达式
print("函数表达式:")
print("Y = {}".format(
    " + ".join(["{:.2f} * {}".format(coeff, feat) for coeff, feat in zip(p[1:28], X.columns)])
))

# 计算预测值
Y_pred = kouzhaoxiaoliang(p, X)

# 计算R2和REMS
r2 = r2_score(Y, Y_pred)
rems = np.sqrt(mean_squared_error(Y, Y_pred))

print("R2值:", r2)
print("REMS值:", rems)

