import geopandas as gpd

# 读取原始shp文件
data = gpd.read_file("F:/research data/studies of fagaceae/aok/fagaceae/oak/oak GISpro/the process date/pythgon fishnet/fishnetoakthreem/qiaodou.shp")

# 设置为墨卡托投影 EPSG:3857
data_mercator = data.to_crs("EPSG:3857")

# 创建一个只包含几何对象的新GeoDataFrame
data_mercator_polygon = gpd.GeoDataFrame(geometry=data_mercator['geometry'])

# 保存为新的面数据shp文件
output_path = "F:/research data/studies of fagaceae/aok/fagaceae/oak/oak GISpro/the process date/pythgon fishnet/fishnetoakthreem/qiaodou_mercator_polygon.shp"
data_mercator_polygon.to_file(output_path)

print(f"数据已转换为墨卡托投影并保存为面数据：{output_path}")
