import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import tensorflow as tf
from sklearn.preprocessing import StandardScaler
from scipy.stats import zscore
from sklearn.metrics import r2_score

# 读取数据
file_path = r"E:/ecosystem service/forest ecosystem service/CODE DATA/forest age5.0.xlsx"
df = pd.read_excel(file_path)

# 提取特征和目标变量
x = df['Stand_age'].values.reshape(-1, 1)
y = df['Height'].values.reshape(-1, 1)

# 移除异常值
z_scores = np.abs(zscore(np.concatenate((x, y), axis=1)))
filtered_entries = (z_scores < 3).all(axis=1)
x_filtered = x[filtered_entries]
y_filtered = y[filtered_entries]

# 标准化数据
scaler_x = StandardScaler()
scaler_y = StandardScaler()
x_scaled = scaler_x.fit_transform(x_filtered)
y_scaled = scaler_y.fit_transform(y_filtered)

# 定义神经网络模型
model = tf.keras.Sequential([
    tf.keras.layers.Dense(64, activation='relu', input_shape=(1,)),
    tf.keras.layers.Dense(64, activation='relu'),
    tf.keras.layers.Dense(1)
])

# 编译模型
model.compile(optimizer='adam', loss='mse')

# 训练模型
history = model.fit(x_scaled, y_scaled, epochs=100, verbose=0)

# 绘制损失曲线
plt.plot(history.history['loss'])
plt.xlabel('Epochs')
plt.ylabel('Loss')
plt.title('Training Loss')
plt.show()

# 使用模型进行预测
y_pred_scaled = model.predict(x_scaled)
y_pred = scaler_y.inverse_transform(y_pred_scaled)

# 计算 R² 分数
r2 = r2_score(y_filtered, y_pred)

# 绘制原始数据和预测结果
plt.scatter(x_filtered, y_filtered, label='Original Data')
plt.plot(x_filtered, y_pred, color='red', label='Predicted Data')
plt.xlabel('Stand_age')
plt.ylabel('Height')
plt.title(f'Regression using Neural Network\nR² Score: {r2:.4f}')
plt.legend()
plt.show()
