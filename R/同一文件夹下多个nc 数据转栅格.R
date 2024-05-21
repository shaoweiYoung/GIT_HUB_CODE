library(raster)

# 设置工作目录到包含 nc 文件的文件夹
setwd("I:/datasets/soil/soil data")

# 获取文件夹中的所有 nc 文件
nc_files <- list.files(pattern="\\.nc$", full.names=TRUE)

# 循环遍历每个 nc 文件，将其转换为栅格数据并保存为独立的文件
for (file in nc_files) {
  raster_data <- raster(file)  # 将 nc 文件转换为栅格数据
  basename <- tools::file_path_sans_ext(basename(file))  # 获取文件名
  output_filename <- paste0(basename, ".tif")  # 创建输出文件名
  writeRaster(raster_data, filename=output_filename, format="GTiff")  # 保存栅格数据为 GeoTIFF 文件
}