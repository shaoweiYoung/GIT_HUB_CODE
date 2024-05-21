import geopandas as gpd
import fiona

# 设置裁剪目标和裁剪源的路径
target_shp_path = 'F:/research data/studies of fagaceae/aok/the process/fishnet_1kmclip/merged_wgs84.shp'
clip_shp_path = 'F:/research data/studies of fagaceae/genus/Castanea.shp'

# 读取目标和裁剪源的Shapefile
target_gdf = gpd.read_file(target_shp_path)
clip_gdf = gpd.read_file(clip_shp_path)

# 执行裁剪操作，保留所有类型的几何体
clipped_gdf = gpd.overlay(target_gdf, clip_gdf, how='intersection', keep_geom_type=False)

# 设置输出路径
output_path = 'F:/research data/studies of fagaceae/Clipped_Output.shp'

# 使用fiona.Env设置环境，强制使用UTF-8编码
with fiona.Env(OGR_ENABLE_PARTIAL_REPROJECTION=True, SHAPE_ENCODING="UTF-8"):
    # 保存裁剪后的shapefile
    clipped_gdf.to_file(output_path, driver='ESRI Shapefile', encoding='utf-8')

print("裁剪操作完成，结果已保存至：", output_path)
