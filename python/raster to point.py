import gdal
import numpy as np
import geopandas as gpd
from osgeo import ogr

# 加载栅格数据
print("加载栅格数据")
raster_file = "E:/ecosystem service/forest ecosystem service/forest age/the first data/fch.tif"
ds = gdal.Open(raster_file)

# 读取栅格数据
print("读取栅格数据")
band = ds.GetRasterBand(1)
array = band.ReadAsArray()

# 获取栅格数据的坐标信息
print("获取栅格数据的坐标信息")
transform = ds.GetGeoTransform()
x_origin, pixel_width, _, y_origin, _, pixel_height = transform

# 将栅格数据转换为点
print(" 将栅格数据转换为点")
rows, cols = np.where(array > 0)  # 假设大于0的像素才转换为点
x_coords = x_origin + (cols * pixel_width)
y_coords = y_origin + (rows * pixel_height)

# 创建点的几何对象
print("创建点的几何对象")
points = []
for x, y in zip(x_coords, y_coords):
    point = ogr.Geometry(ogr.wkbPoint)
    point.AddPoint(x, y)
    points.append(point)

# 创建geopandas数据框
print("创建geopandas数据框")
gdf = gpd.GeoDataFrame(geometry=gpd.points_from_xy(x_coords, y_coords))

# 保存点数据
print("保存点数据")
output_file = "E:/ecosystem service/forest ecosystem service/forest age/the first data/fchpoint.shp"
gdf.to_file(output_file)