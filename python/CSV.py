import os
import pandas as pd
from tqdm import tqdm

# 设置文件夹路径
folder_path = r'F:/research data/studies of fagaceae/aok/the process/GEE table/totol'

# 获取文件夹下所有CSV文件的文件名
csv_files = [file for file in os.listdir(folder_path) if file.endswith('.csv')]
print(csv_files)

# 创建一个空的DataFrame用于存储所有CSV文件的数据
merged_df = pd.DataFrame()

# 循环读取并合并CSV文件
for file in tqdm(csv_files, desc="合并进度"):
    file_path = os.path.join(folder_path, file)
    # 读取CSV文件
    df = pd.read_csv(file_path)
    # 合并数据到总DataFrame中，根据ID列进行合并
    merged_df = pd.concat([merged_df, df], ignore_index=True)

# 定义保存合并后文件的路径
output_file_path = os.path.join(folder_path, 'merged_data.csv')

# 将合并后的数据保存到新的CSV文件中
merged_df.to_csv(output_file_path, index=False)

print("合并完成并保存到 merged_data.csv 文件中。")
