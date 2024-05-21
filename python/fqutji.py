import os
import geopandas as gpd
import rasterio
from rasterio.mask import mask

# 设置PROJ_LIB环境变量为proj的数据文件路径
os.environ['PROJ_LIB'] = 'C:/path/to/proj/data/files'

# 加载矢量文件
shapefile_path = 'F:/research data/studies of fagaceae/aok/the process/fishnet_1kmclip/merged_wgs84.shp'
gdf = gpd.read_file(shapefile_path)

# 栅格文件夹路径
raster_folder = 'F:/the raw data/tif/'

# 保存结果文件夹路径
output_folder = 'F:/research data/studies of fagaceae/aok/the process/'

# 遍历每个栅格文件进行分区统计
for root, dirs, files in os.walk(raster_folder):
    for file in files:
        if file.endswith('.tif'):
            raster_path = os.path.join(root, file)
            with rasterio.open(raster_path) as src:
                for index, row in gdf.iterrows():
                    geom = row['geometry']
                    try:
                        # 尝试执行蒙版处理
                        value, _ = mask(src, [geom], crop=True, nodata=src.nodata, indexes=1, all_touched=True, filled=False)
                        mean_value = value.mean()
                        gdf.loc[index, file] = mean_value
                    except Exception as e:
                        print(f"Error processing {file} for geometry at index {index}: {e}")

# 将结果保存为CSV文件
output_file = os.path.join(output_folder, 'result.csv')
gdf.to_csv(output_file, index=False)
