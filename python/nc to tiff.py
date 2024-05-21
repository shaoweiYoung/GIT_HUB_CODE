import os
import rasterio
import matplotlib.pyplot as plt

# 设置输入文件夹路径
input_folder = r"F:/the raw data/soil_nc"

# 遍历文件夹中的所有TIFF文件
for root, dirs, files in os.walk(input_folder):
    for file in files:
        if file.endswith(".tif"):
            tiff_file = os.path.join(root, file)

            # 读取TIFF文件
            data = rasterio.open(tiff_file)
            raster_data = data.read(1)  # 读取第一个波段的数据

            # 可视化数据
            plt.figure(figsize=(8, 8))
            plt.imshow(raster_data, cmap='viridis')  # 使用viridis colormap显示数据
            plt.colorbar()
            plt.title(f"Soil Data - {file}")
            plt.show()