import numpy as np
import matplotlib.pyplot as plt

# 生成数据
x = np.array([1, 2, 3, 4, 5])
z = np.array([3, 7, 12, 18, 25])

# 计算斜率s
s = np.diff(z) / np.diff(x)  # 计算斜率

# 计算斜率的x平均值
avg_x_for_s = (x[1:] + x[:-1]) / 2

# 绘制两个曲线图在一张图上显示
plt.figure(figsize=(8, 6))

# 绘制x-z曲线图
plt.plot(x, z, label='x-z curve', marker='o', linestyle='-')
plt.xlabel('x')
plt.ylabel('z')
plt.title('Plot of x and z')

# 绘制斜率s曲线图
plt.twinx()
plt.plot(avg_x_for_s, s, label='Slope (s)', marker='o', linestyle='-', color='r')
plt.ylabel('Slope (s)')
plt.title('Plot of Slope (s) with respect to average x')

plt.show()
