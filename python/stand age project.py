import numpy as np
import pandas as pd
import pymc3 as pm
import theano.tensor as tt
from sklearn.metrics import r2_score, mean_squared_error, mean_absolute_error

# 加载数据
df = pd.read_csv('F:/research data/forest age/the process data/project/project.csv')

# 获取变量
H = df.iloc[:, 8].values  # 树高
P = df.iloc[:, 1].values  # 降水量
TE = df.iloc[:, 2].values  # 温度
B = df.iloc[:, 3].values  # 生物量
T = df.iloc[:, 4].values  # 土壤温度
SP = df.iloc[:, 5].values  # 土壤pH
SC = df.iloc[:, 6].values  # 土壤碳含量
S = df.iloc[:, 7].values  # 遮荫
A_true = df.iloc[:, 0].values  # 真实的A值

# 使用PyMC3建模
with pm.Model() as model:
    # 定义先验分布
    a = pm.Normal('a', mu=1, sigma=1)
    b = pm.Normal('b', mu=0, sigma=1)
    c = pm.Normal('c', mu=0, sigma=1)
    d = pm.Normal('d', mu=0, sigma=1)
    f = pm.Normal('f', mu=0, sigma=1)
    g = pm.Normal('g', mu=0, sigma=1)
    h = pm.Normal('h', mu=0, sigma=1)
    i = pm.Normal('i', mu=0, sigma=1)

    # 定义模型
    power = (np.log(H) - tt.log(a)) / (b * TE + c * P + d * B + f * T + g * SP + h * SC + i * S)
    A = pm.Deterministic('A', tt.exp(power * np.log(np.e)))

    # 添加误差项
    sigma = pm.HalfNormal('sigma', sigma=1)
    likelihood = pm.Normal('likelihood', mu=A, sigma=sigma, observed=A_true)

    # 运行MCMC
    trace = pm.sample(1000, tune=1000, cores=2, return_inferencedata=False)

# 模型评估
predicted_A = np.exp((np.log(H) - np.log(trace['a'].mean())) / (
            trace['b'].mean() * TE + trace['c'].mean() * P + trace['d'].mean() * B + trace['f'].mean() * T + trace[
        'g'].mean() * SP + trace['h'].mean() * SC + trace['i'].mean() * S) * np.log(np.e))

# 计算评估指标
r2 = r2_score(A_true, predicted_A)
rmse = np.sqrt(mean_squared_error(A_true, predicted_A))
mae = mean_absolute_error(A_true, predicted_A)
me = np.mean(A_true - predicted_A)

# 打印结果
print('R²:', r2)
print('RMSE:', rmse)
print('MAE:', mae)
print('ME:', me)
