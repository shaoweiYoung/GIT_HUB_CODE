import pandas as pd
import numpy as np
from scipy.stats import pearsonr
from scipy.spatial.distance import pdist
from scipy.stats import mantel
import matplotlib.pyplot as plt
from matplotlib.font_manager import FontProperties
#________________________________________________________________________________________________________________________
#加载数据
data = pd.read_csv("F:/research data/studies of fagaceae/oak_points_facture_attributes.csv")
#________________________________________________________________________________________________________________________
# 提取各属数据
genus_data = data[data["genus"] == 1]  # 1为水青冈Fagus
# genus_data = data[data["genus"] == 2]  # 2为青冈Cyclobalanopsis
# genus_data = data[data["genus"] == 3]  # 3为栎属Quercus
# genus_data = data[data["genus"] == 4]  # 4为锥属Castanopsis
# genus_data_ = data[data["genus"] == 5]  # 5为柯属Lithocarpus
# genus_data = data[data["genus"] == 6]  # 6为栗属Castanea
#________________________________________________________________________________________________________________________
# 提取相关列
GPP = genus_data["GPP"]
data2 = genus_data[["Aspect", "DEM", "Slope"]]
#________________________________________________________________________________________________________________________
# 使用均值填充缺失值
data2.fillna(data2.mean(), inplace=True)
GPP.fillna(GPP.mean(), inplace=True)
#________________________________________________________________________________________________________________________
# 计算GPP和每个地形特征之间的Pearson相关系数
correlations = {}
for column in data2.columns:
    corr, _ = pearsonr(GPP, data2[column])
    correlations[column] = corr
# 输出Pearson相关系数
print("Pearson相关系数:")
for feature, corr in correlations.items():
    print(f"{feature}: {corr}")
#________________________________________________________________________________________________________________________
# 执行Mantel检验
mantel_corr, p_value = mantel(data2.corr(), pdist(np.array(GPP).reshape(-1, 1)))
#________________________________________________________________________________________________________________________
# 可视化Pearson相关系数
plt.bar(correlations.keys(), correlations.values())
plt.title('GPP与地形特征的Pearson相关性')
plt.xlabel('地形特征')
plt.ylabel('Pearson相关系数')
#________________________________________________________________________________________________________________________
# 中文显示
font = FontProperties(fname='/System/Library/Fonts/PingFang.ttc', size=12)  # 替换为你的中文字体路径
plt.xticks(fontproperties=font)
plt.yticks(fontproperties=font)
#________________________________________________________________________________________________________________________
plt.show()
#________________________________________________________________________________________________________________________
# 打印Mantel检验结果
print(f"Mantel相关系数: {mantel_corr}")
print(f"P值: {p_value}")
#________________________________________________________________________________________________________________________