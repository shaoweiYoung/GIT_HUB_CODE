import geopandas as gpd
import pandas as pd
import os

# 设置文件夹路径
folder_path = 'F:/research data/studies of fagaceae/aok/fishnet_1kmclip'

# 获取 shp 文件列表
shp_files = [filename for filename in os.listdir(folder_path) if filename.endswith('.shp')]

# 创建一个空的 GeoDataFrame 存储所有数据
merged_gdf = gpd.GeoDataFrame()

# 遍历指定文件夹下的所有 shp 文件
for i, filename in enumerate(shp_files):
    shp_path = os.path.join(folder_path, filename)
    gdf = gpd.read_file(shp_path)

    merged_gdf = gpd.GeoDataFrame(pd.concat([merged_gdf, gdf], ignore_index=True))

    # 显示合并进度
    print(f'Merging {filename} ({i + 1}/{len(shp_files)})')

# 合并后的数据保存为一个新的 shp 文件
output_file = os.path.join(folder_path, 'merged.shp')
merged_gdf.to_file(output_file)
