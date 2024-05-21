import pandas as pd
from scipy.optimize import curve_fit
import numpy as np
import matplotlib.pyplot as plt
from scipy.stats import zscore

# 读取Excel文件
file_path = r"E:/ecosystem service/forest ecosystem service/CODE DATA/forest age5.0.xlsx"
df = pd.read_excel(file_path)

# 提取需要的列
x = df['Stand_age'].values  # Now 'Stand_age' is assigned to y
y = df['Height'].values     # Now 'Height' is assigned to x

# 移除包含NaN或inf的行
mask = np.isfinite(x) & np.isfinite(y)
x_clean = x[mask]
y_clean = y[mask]

# 剔除异常值（使用z-score）
z_scores = np.abs(zscore(np.column_stack((x_clean, y_clean))))
filtered_entries = (z_scores < 3).all(axis=1)
x_filtered = x_clean[filtered_entries]
y_filtered = y_clean[filtered_entries]

# 定义Weibull函数
def weibull_function(x, A, B, C, D):
    return A - B * np.exp(-((x / C) ** D))

# 拟合Weibull函数到数据
p0 = [max(y_filtered), max(y_filtered) - min(y_filtered), np.median(x_filtered), 1]  # Initial guess for parameters
popt, pcov = curve_fit(weibull_function, x_filtered, y_filtered, p0=p0)

# 计算拟合值
y_fit = weibull_function(x_filtered, *popt)

# 计算R^2
ss_res = np.sum((y_filtered - y_fit) ** 2)
ss_tot = np.sum((y_filtered - np.mean(y_filtered)) ** 2)
r_squared = 1 - (ss_res / ss_tot)

# 打印拟合参数和R^2
print(f"Fitted parameters: A={popt[0]}, B={popt[1]}, C={popt[2]}, D={popt[3]}")
print(f"R^2: {r_squared}")

# 绘制数据点和拟合曲线
plt.scatter(x_filtered, y_filtered, label='Data')
x_fit = np.linspace(min(x_filtered), max(x_filtered), 100)
y_fit_curve = weibull_function(x_fit, *popt)
plt.plot(x_fit, y_fit_curve, color='red', label='Fitted Weibull function')

# 显示拟合函数表达式
func_text = f"Fitted function:\n$A - B \cdot e^{{-\\left(\\frac{{x}}{{C}}\\right)^D}}$\n"
func_text += f"$A={popt[0]:.3f}$\n$B={popt[1]:.3f}$\n$C={popt[2]:.3f}$\n$D={popt[3]:.3f}$\n$R^2={r_squared:.3f}$"
plt.text(0.05, 0.95, func_text, transform=plt.gca().transAxes, fontsize=10,
         verticalalignment='top', bbox=dict(boxstyle='round,pad=0.5', alpha=0.1))

plt.xlabel('Stand_age')  # Changed xlabel to ylabel
plt.ylabel('Height')     # Changed ylabel to xlabel
plt.legend()
plt.show()
