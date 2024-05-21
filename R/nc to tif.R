install.packages("raster")
install.packages("ncdf4")

library(ncdf4)
library(raster)

# 设置输入文件夹路径和输出文件夹路径
input_folder <- "F:/the raw data/soil_nc"
output_folder <- "F:/the raw data"

# 获取输入文件夹中所有NC文件的路径
nc_files <- list.files(path = input_folder, pattern = ".nc", full.names = TRUE)

# 循环处理每个NC文件
for (nc_file in nc_files) {
  # 读取NC文件
  nc_data <- raster(nc_file)
  
  # 构建输出文件路径
  output_file <- file.path(output_folder, paste0("soil_", tools::file_path_sans_ext(basename(nc_file)), ".tif"))
  
  # 将NC文件转换为TIFF并保存
  writeRaster(nc_data, filename = output_file, format = "GTiff")
}

cat("转换完成！")