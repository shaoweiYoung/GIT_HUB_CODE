import os
import geopandas as gpd
from datetime import datetime

# 设置裁剪后的shp为面数据和EPSG:3857投影
output_crs = 'EPSG:3857'

# 输入裁剪源shp路径
source_shp = "F:/research data/studies of fagaceae/aok/fagaceae/oak/oak GISpro/the process date/pythgon fishnet/fishnetoakthreem/qiaodou_mercator_polygon.shp"

# 输入裁剪目标文件夹路径
target_folder = "F:/research data/studies of fagaceae/aok/Python"

# 输出裁剪后shp保存路径
output_folder = "F:/research data/studies of fagaceae/aok/clip fishnet"

# 创建输出文件夹
if not os.path.exists(output_folder):
    os.makedirs(output_folder)

# 读取裁剪源shp数据
source_gdf = gpd.read_file(source_shp)

# 遍历目标文件夹下所有shp文件，从第266个开始裁剪
clip_started = False
for root, dirs, files in os.walk(target_folder):
    for file in files:
        if file.endswith('.shp'):
            if file == 'fishnet_1187.shp':  # 设置从第266个文件开始裁剪
                clip_started = True

            if clip_started:
                target_shp = os.path.join(root, file)
                target_gdf = gpd.read_file(target_shp)  # 读取目标shp文件

                # 裁剪操作
                clipped_gdf = gpd.overlay(target_gdf, source_gdf, how='intersection')  # 进行裁剪

                # 设置投影并保存裁剪后的shp文件
                clipped_output = os.path.join(output_folder, file.replace(".shp", "_clip.shp"))
                clipped_gdf.to_crs(output_crs).to_file(clipped_output)  # 设置投影并保存

                # 打印每个shp数据的数量和保存时间
                num_features = len(clipped_gdf)
                save_time = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
                print(f"标题: {file}")
                print(f"裁剪后的数量: {num_features}")
                print(f"保存时间: {save_time}")
                print("------------------------------------")
