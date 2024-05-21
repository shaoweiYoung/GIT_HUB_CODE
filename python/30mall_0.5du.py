import geopandas as gpd
from shapely.geometry import Polygon
import time

# 读取原始数据
shapefile_path = 'F:/research data/studies of fagaceae/aco/fagaceae/oak/oak GISpro/the process date/pythgon fishnet/fishnetoakthreem/oak0.5out.shp'
gdf = gpd.read_file(shapefile_path)

# 创建并保存渔网
print("开始创建和保存30*30米的栅格...")
start_time = time.time()
grid_size = 30  # 网格大小

for index in range(999, 1000):  # 从第9个到第15个元素
    grid_start_time = time.time()  # 记录当前渔网的开始时间
    row = gdf.iloc[index]
    geometry = row['geometry']
    min_x, min_y, max_x, max_y = geometry.bounds
    polygons = []

    for i in range(int((max_y - min_y) / grid_size)):
        for j in range(int((max_x - min_x) / grid_size)):
            x = min_x + j * grid_size
            y = min_y + i * grid_size
            polygon = Polygon([(x, y), (x + grid_size, y), (x + grid_size, y + grid_size), (x, y + grid_size)])
            polygons.append(polygon)

            if len(polygons) % 1000000 == 0:
                elapsed_time = time.time() - start_time
                print(f"已创建{len(polygons)}个单元格，总用时{elapsed_time:.2f}秒")

    # 创建GeoDataFrame并设置坐标系为墨卡托投影
    fishnet_gdf = gpd.GeoDataFrame({'geometry': polygons})
    fishnet_gdf.crs = "EPSG:3857"  # 设置为墨卡托投影坐标系

    # 保存渔网
    output_path = (f'F:/research data/studies of fagaceae/aco/fagaceae/oak/oak GISpro/the process date/pythgon fishnet/30mall_0.51.0/fishnet_{index}.shp')
    fishnet_gdf.to_file(output_path)

    elapsed_time = time.time() - start_time
    grid_elapsed_time = time.time() - grid_start_time  # 当前渔网耗时
    print(
        f"已创建并保存第{index}个渔网，当前网格数：{len(polygons)}，用时{grid_elapsed_time:.2f}秒，总用时{elapsed_time:.2f}秒")

print('所有渔网已创建并保存。')
