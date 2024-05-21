import geopandas as gpd
from shapely.geometry import Polygon
import time

# 读取现有的shapefile
print("Reading input shapefile...")
input_shapefile = r'E:/ecosystem service/fagaceae/oak/oak GISpro/the process date/pythgon fishnet/fishnetoakthreem/oak0.5out.shp'
gdf = gpd.read_file(input_shapefile)

# 选择 F_ID 为 1 的数据
print("Selecting data with OBJECTID=1...")
selected_data = gdf[gdf['OBJECTID'] == 1]

# 获取选定数据的范围
minx, miny, maxx, maxy = selected_data.total_bounds

# 设置每个格网的大小
grid_size = 30

# 创建 30*30 米的网格
print("Creating and saving 30*30 meter grids...")
start_time = time.time()  # 记录开始时间
polygons = []
for i in range(int((maxy - miny) / grid_size)):
    for j in range(int((maxx - minx) / grid_size)):
        x = minx + j * grid_size
        y = miny + i * grid_size
        polygons.append(Polygon([(x, y), (x + grid_size, y), (x + grid_size, y + grid_size), (x, y + grid_size)]))
        if len(polygons) % 1000 == 0:
            elapsed_time = time.time() - start_time
            print(f"已创建{len(polygons)}个单元格，总用时{elapsed_time:.2f}秒")

# 创建新的 GeoDataFrame
print("Creating GeoDataFrame...")
grid_gdf = gpd.GeoDataFrame({'geometry': polygons}, crs=gdf.crs)  # 使用原始数据的坐标系

# 保存为 shapefile，并指定输出文件路径
print("Saving the grid to a shapefile...")
output_file = r'E:/ecosystem service/fagaceae/oak/oak GISpro/the process date/pythgon fishnet/fishnetoakthreem/oakfishnet_0.5du_30m_ID1.shp'
grid_gdf.to_file(output_file)

print("Grid creation and saving complete.")
