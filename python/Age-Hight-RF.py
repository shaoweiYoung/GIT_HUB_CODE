import pandas as pd
from sklearn.ensemble import RandomForestRegressor
from sklearn.metrics import r2_score
import numpy as np
import matplotlib.pyplot as plt
from scipy.stats import zscore

# 读取Excel文件
file_path = r"E:/ecosystem service/forest ecosystem service/CODE DATA/forest age5.0.xlsx"
df = pd.read_excel(file_path)

# 提取需要的列
x = df['Stand_age'].values.reshape(-1, 1)
y = df['Height'].values

# 移除包含NaN或inf的行
mask = np.isfinite(x).flatten() & np.isfinite(y)
x_clean = x[mask]
y_clean = y[mask]

# 剔除异常值（使用z-score）
z_scores = np.abs(zscore(np.hstack((x_clean, y_clean.reshape(-1, 1)))))
filtered_entries = (z_scores < 3).all(axis=1)
x_filtered = x_clean[filtered_entries]
y_filtered = y_clean[filtered_entries]

# 定义随机森林回归模型
model = RandomForestRegressor(n_estimators=100, random_state=42)

# 拟合模型到数据
model.fit(x_filtered, y_filtered)

# 计算拟合值
y_fit = model.predict(x_filtered)

# 计算R^2
r_squared = r2_score(y_filtered, y_fit)

# 打印R^2
print(f"R^2: {r_squared}")

# 绘制数据点和拟合曲线
plt.scatter(x_filtered, y_filtered, label='Data')
x_fit = np.linspace(min(x_filtered), max(x_filtered), 100).reshape(-1, 1)
y_fit_curve = model.predict(x_fit)
plt.plot(x_fit, y_fit_curve, color='red', label='Fitted Random Forest')

# 显示拟合函数表达式
func_text = f"Random Forest Regressor\n"
func_text += f"$R^2={r_squared:.3f}$"
plt.text(0.05, 0.95, func_text, transform=plt.gca().transAxes, fontsize=10,
         verticalalignment='top', bbox=dict(boxstyle='round,pad=0.5', alpha=0.1))

plt.xlabel('Stand_age')
plt.ylabel('Height')
plt.legend()
plt.show()
