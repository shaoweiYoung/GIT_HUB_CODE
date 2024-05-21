# 导入模块
 import ee

# 进行身份确认
ee.Initialize()

# 创建影像对象
image = ee.Image('srtm90_v4')

# 打印影像信息，这个和JavaScript不一样，需要get.getinfo
print(image.getInfo())geeup cookie_setup
geeup getmeta --input "F:\ZYM_GEE\RGB\RGB_0.9_masked\ceshi" --metadata "F:\ZYM_GEE\RGB\RGB_0.9_masked\ceshi\rgb.csv"，
F:/the raw data/the araw tif/bioclip
F:/the raw data/the araw tif/gppclip
geeup getmeta --input "F:/the raw data/the araw tif/bioclip" --metadata "F:/the raw data/the araw tif/bioclip/rgb.csv"
geeup getmeta --input "F:/the raw data/the araw tif/gppclip" --metadata "F:/the raw data/the araw tif/gppclip/rgb.csv"

2..上传数据至GEE的Asserts
执行命令：geeup upload --source "F:\ZYM_GEE\RGB\RGB_0.9_masked\ceshi/" --metadata
"F:\ZYM_GEE\RGB\RGB_0.9_masked\ceshi\rgb.csv" --dest "users/fgbf/ceshi" --user "GEE账号（邮箱）" --nodata 0 --pyramids MODE
用法：geeup upload [-h] --source SOURCE --dest DEST -m METADATA [--nodata NODATA] [--pyramids
PYRAMIDS] [-u USER]
####上传栅格数据####
geeup upload --source "F:/the raw data/the araw tif/bioclip/" --metadata "F:/the raw data/the araw tif/bioclip/rgb.csv" --dest "users/glmweiyu/bio2010" --user "glmweiyu@gmail.com" --nodata 0 --pyramids MODE

geeup upload --source "F:/the raw data/the araw tif/gppclip/" --metadata "F:/the raw data/the araw tif/gppclip/rgb.csv" --dest "users/glmweiyu/GeoSIF_GPP" --user "glmweiyu@gmail.com" --nodata 0 --pyramids MODE