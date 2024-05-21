import pandas as pd
from matplotlib.lines import Line2D
import pandas as pd
from matplotlib.patches import Rectangle
import seaborn as sns
import matplotlib.pyplot as plt
import numpy as np
from biokit.viz import corrplot
from matplotlib.lines import Line2D
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from sklearn.ensemble import RandomForestRegressor
from sklearn.model_selection import train_test_split
#————————————————————————————————————————————————————————————————————————————————————————————————————————————
# 加载数据
data = pd.read_csv("F:/research data/studies of fagaceae/oak_points_facture_attributes.csv")
# 提取特定组的数据
genus_data = data[data['genus'] == 1]#1为水青冈Fagus
# 剔除空值
genus_data = genus_data.dropna()
#————————————————————————————————————————————————————————————————————————————————————————————————————————————
# 随机森林模型拟合
X = genus_data[["Aspect", "DEM", "Slope"]]
y = genus_data['GPP']  # 目标变量
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

rf_model = RandomForestRegressor(n_estimators=100, random_state=1)
rf_model.fit(X_train, y_train)

# 特征重要性
importance_data = pd.DataFrame({
    'Feature': X.columns,
    'Mean_Importance': rf_model.feature_importances_
})
#----------------------------------------------------------------------------
# 将特征重要性转换为百分比
importance_data['Mean_Importance'] *= 100
# 可视化特征重要性
plt.figure(figsize=(10, 6))
sns.barplot(y='Mean_Importance', x='Feature', data=importance_data,  color='skyblue', edgecolor='black')
plt.title('Explained variation(%)', fontsize=16, loc='left', fontweight='bold')  # 将标题放在左上角并设置字体大小
plt.xticks(rotation=45, fontsize=10, fontweight='bold')  # 旋转 x 轴标签以防止重叠，并设置字体大小
plt.yticks(fontsize=16, fontweight='bold')  # 设置 y 轴刻度的字体大小
plt.gca().spines['top'].set_visible(False)  # 去除顶部边框
plt.gca().spines['right'].set_visible(False)  # 去除右侧边框
plt.gca().spines['left'].set_linewidth(2)  # 设置左侧边框线宽
plt.gca().spines['bottom'].set_linewidth(2)  # 设置底部边框线宽
plt.gca().yaxis.set_major_formatter(plt.FuncFormatter(lambda x, _: f'{int(x)}%'))  # 设置 y 轴刻度显示百分比
plt.show()
#----------------------------------------------------------------------------
# 生成热力图左下角方框的mask
mask = np.triu(np.ones_like(X.corr(), dtype=bool))
# 绘制热力图
plt.figure(figsize=(10, 8))
heatmap = sns.heatmap(X.corr(), annot=False, cmap='coolwarm', vmax=1, vmin=-1, mask=mask, square=True, fmt='.2f', linewidths=.5, linecolor='black')  # 设置颜色映射范围为 -1 到 1
# 添加右上角显示相关性数值和显著性
for i in range(len(X.columns)):
    for j in range(i+1, len(X.columns)):
        corr_value = X.corr().iloc[i, j]
        plt.text(j + 0.5, i + 0.5, f"{corr_value:.2f}***", ha='center', va='center', color='black', size=16)  # 添加显著性标记
# 添加内部边框和斜线
ax = plt.gca()
for _, spine in ax.spines.items():
    spine.set_visible(True)
# 添加斜线
ax.plot([0, len(X.columns)], [0, len(X.columns)], color='black', linewidth=1)  # 添加斜线
# 添加图例名称
cbar = heatmap.collections[0].colorbar
cbar.set_ticks([-1, -0.5, 0, 0.5, 1])
cbar.ax.yaxis.set_tick_params(labelsize=16)
# 设置标题在顶部
plt.title('Correlation', fontsize=16, loc='right', pad=20)
# 设置全部字体大小
plt.xticks(fontsize=16)
plt.yticks(fontsize=16)
plt.show()
