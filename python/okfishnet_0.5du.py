import geopandas as gpd
from shapely.geometry import Polygon
import pyproj

# 读取shapefile文件
shp = gpd.read_file('E:/ecosystem service/fagaceae/oak/oak GISpro/oak/pythonshp/qiaodou.shp')

# 获取shapefile的范围
minx, miny, maxx, maxy = shp.total_bounds

# 创建网格顶点
polygons = []
for i in range(int((maxy - miny) / 0.5)):
    for j in range(int((maxx - minx) / 0.5)):
        polygon = Polygon([
            (minx + j * 0.5, miny + i * 0.5),
            (minx + (j + 1) * 0.5, miny + i * 0.5),
            (minx + (j + 1) * 0.5, miny + (i + 1) * 0.5),
            (minx + j * 0.5, miny + (i + 1) * 0.5)
        ])
        polygons.append(polygon)

# 创建GeoDataFrame
grid_gdf = gpd.GeoDataFrame({'geometry': polygons}, crs='EPSG:4326')

import pyproj

# 定义墨卡托投影的参数
crs_mercator = '+proj=merc +lon_0=0 +k=1 +x_0=0 +y_0=0 +a=6378137 +b=6378137 +units=m +no_defs'
mercator_proj = pyproj.Proj(crs_mercator)

# 将网格数据转换为墨卡托投影
grid_gdf_mercator = grid_gdf.to_crs(crs=crs_mercator)

# 保存为shapefile
grid_gdf_mercator .to_file("E:/ecosystem service/fagaceae/oak/oak GISpro/the process date/pythgon fishnet/fishnetoakthreem/oak_0.5du.shp")
