import os
import glob
import geopandas as gpd
from rasterio.mask import mask
from rasterio import open as rio_open
from shapely.geometry import box
from pyproj import CRS
from datetime import datetime

# 设置裁剪后的栅格投影
output_crs = CRS.from_epsg(4326)  # WGS 1984

# 输入裁剪源shp路径
source_shp = "F:/the raw data/china project/china project.shp"

# 输入裁剪目标文件夹路径
target_folder = "F:/the raw data/the araw tif/biogpp/"

# 输出裁剪后文件夹路径
output_folder = "F:/the raw data/the araw tif/biogppclip/"

# 创建输出文件夹
if not os.path.exists(output_folder):
    os.makedirs(output_folder)

try:
    # 读取裁剪源shp数据
    source_gdf = gpd.read_file(source_shp)
except Exception as e:
    print(f"无法读取源 shapefile: {source_shp}, 错误信息: {str(e)}")
    exit()

# 遍历目标文件夹下所有tif文件
for tif_file in glob.glob(os.path.join(target_folder, "*.tif")):
    try:
        # 读取tif文件
        with rio_open(tif_file) as src:
            # 裁剪
            out_image, out_transform = mask(src, source_gdf.geometry, crop=True)
            out_meta = src.meta.copy()

        # 更新裁剪后图像的元数据
        out_meta.update({"driver": "GTiff",
                         "height": out_image.shape[1],
                         "width": out_image.shape[2],
                         "transform": out_transform,
                         "crs": output_crs})

        # 构建输出文件路径
        output_file = os.path.join(output_folder, os.path.basename(tif_file))

        # 保存裁剪后的tif文件
        with rio_open(output_file, "w", **out_meta) as dest:
            dest.write(out_image)

        # 打印保存信息
        save_time = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        print(f"文件名: {os.path.basename(tif_file)}")
        print(f"保存时间: {save_time}")
        print("------------------------------------")
    except Exception as e:
        print(f"处理文件 {tif_file} 时发生错误: {str(e)}")
