import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from sklearn.ensemble import RandomForestRegressor
from sklearn.model_selection import train_test_split
from matplotlib.gridspec import GridSpec  # 确保导入 GridSpec
#————————————————————————————————————————————————————————————————————————————————————————————————————————————
# 加载数据
data = pd.read_csv("F:/research data/studies of fagaceae/oak_points_facture_attributes.csv")
#data = pd.read_csv("F:/research data/studies of fagaceae/add_forest0517_to_Drive.csv")
# 提取特定组的数据
#genus_data = data[data['genus'] == 1]#1为水青冈Fagus
#genus_data = data[data['genus'] == 2]#2为青冈Cyclobalanopsis
#genus_data = data[data['genus'] == 3]#3为栎属Quercus
#genus_data = data[data['genus'] == 4]#4为锥属Castanopsis
genus_data = data[data['genus'] == 5]#5为柯属Lithocarpus
#genus_data = data[data['genus'] == 6]#6为栗属Castanea
# 剔除空值
genus_data = genus_data.dropna()
#————————————————————————————————————————————————————————————————————————————————————————————————————————————
# 随机森林模型拟合
#X = genus_data[["Aspect", "DEM", "Slope"]]#地形
#X = genus_data[["Bio1", "Bio2", "Bio3", "Bio4", "Bio5", "Bio6", "Bio7", "Bio8", "Bio9", "Bio10", "Bio11"]]#气温
#X = genus_data[["Bio12", "Bio13",  "Bio14", "Bio15", "Bio16", "Bio17", "Bio18", "Bio19"]]#降水
#X = genus_data[["FCH", "Age",  "LAI"]]#林分
#X = genus_data[["AK", "AL", "AN", "AP", "CA", "CEC", "H", "K", "MG", "NA", "PH", "SOM", "TK", "TN", "TP"]]#土壤化学性质
X = genus_data[["BD", "C1", "CL", "CW1", "Dc", "Dh", "GRAV", "LDEP", "LNUM", "PDEP", "POR", "R", "RC", "RS", "S1", "SA",  "SI", "SW1", "Unc", "Unh", "Wc", "Wh"]]#土壤物理性质
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
# 创建图形和GridSpec对象
fig = plt.figure(figsize=(8.27, 11.69))
gs = GridSpec(2, 1, height_ratios=[1, 2])  # 定义高度比例为1:2

# 创建第一个子图
ax0 = fig.add_subplot(gs[0])
sns.barplot(y='Mean_Importance', x='Feature', data=importance_data, color='skyblue', edgecolor='black', ax=ax0)
ax0.set_title('Explained variation(%)', fontsize=16, loc='left', fontweight='bold')  # 将标题放在左上角并设置字体大小
ax0.tick_params(axis='y', labelsize=16, width=2)  # 设置 y 轴刻度的字体大小
ax0.spines['top'].set_visible(False)  # 去除顶部边框
ax0.spines['right'].set_visible(False)  # 去除右侧边框
ax0.spines['left'].set_linewidth(2)  # 设置左侧边框线宽
ax0.spines['bottom'].set_linewidth(2)  # 设置底部边框线宽
ax0.yaxis.set_major_formatter(plt.FuncFormatter(lambda x, _: f'{int(x)}%'))  # 设置 y 轴刻度显示百分比
# 移除 x 轴刻度标签
ax0.set_xticklabels([])

# 移除Mean_Importance和Feature字体
ax0.set_xlabel('')
ax0.set_ylabel('')


# 创建第二个子图
ax1 = fig.add_subplot(gs[1])
# 生成热力图左下角方框的mask
mask = np.triu(np.ones_like(X.corr(), dtype=bool))
# 绘制热力图
heatmap = sns.heatmap(X.corr(), annot=False, cmap='coolwarm', vmax=1, vmin=-1, mask=mask, square=True, fmt='.2f', linewidths=.5, linecolor='black', ax=ax1, cbar=False)  # 设置颜色映射范围为 -1 到 1，移除图例
# 添加右上角显示相关性数值和显著性
for i in range(len(X.columns)):
    for j in range(i + 1, len(X.columns)):
        corr_value = X.corr().iloc[i, j]
        ax1.text(j + 0.5, i + 0.5, f"{corr_value:.2f}***", ha='center', va='center', color='black', size=5,fontweight='bold')  # 添加显著性标记
# 添加内部边框和斜线
for _, spine in ax1.spines.items():
    spine.set_visible(True)
# 添加斜线
ax1.plot([0, len(X.columns)], [0, len(X.columns)], color='black', linewidth=1)  # 添加斜线

# 设置全部字体大小
for axis in [ax0, ax1]:
    axis.tick_params(axis='x', labelsize=16)
    axis.tick_params(axis='y', labelsize=16)
plt.tight_layout()  # 调整子图之间的间距
plt.savefig("F:/research data/studies of fagaceae/重要性+相关性/土壤物理性质-柯属519.PDF")
plt.show()