import natcap.invest.carbon
args = {
    'workspace_dir': 'path/to/workspace'
    # Other arguments, as needed for Carbon.
}

natcap.invest.carbon.execute(args)
参数
:
args [ 'workspace_dir' ] ( string ) – 在计算过程中写入输出和其他临时文件的目录路径。

args [ 'results_suffix' ] ( string ) – 附加到任何输出文件名。

args [ 'lulc_cur_path' ] ( string ) – 表示当前碳储量的栅格路径。

args [ 'calc_sequestration' ] ( bool ) – 如果为 true，则应计算隔离并应定义 'lulc_fut_path' 和 'do_redd'。

args [ 'lulc_fut_path' ] ( string ) – 代表未来土地覆盖场景的栅格路径。可选，但如果存在且定义明确，将触发隔离计算。

args [ 'do_redd' ] ( bool ) – 如果为 true，则应计算 REDD 分析并定义 'lulc_redd_path'

args [ 'lulc_redd_path' ] ( string ) – 表示替代 REDD 场景的栅格路径，只有当 args['lulc_fut_path'] 存在且定义良好时才可能实现。

args [ 'carbon_pools_path' ] ( string ) – CSV 路径或将碳存储密度索引为 lulc 代码的路径。 （如果“do_uncertainty”为 false，则为必需）

args [ 'lulc_cur_year' ] ( int/string ) – 一个整数，表示当args['do_valuation']为 True时使用的args[' lulc_cur_path']年份 。

args [ 'lulc_fut_year' ] ( int/string ) – 一个整数，表示评估中使用的args['lulc_fut_path']的年份（如果存在）。如果 args['do_valuation']为 True 并且 args['lulc_fut_path']存在且定义良好，则为必需。

args [ 'do_valuation' ] ( bool ) – 如果为 true，则对可用输出运行评估模型。计算未来场景或 REDD 场景的 NPV 并在最终 HTML 文档中报告。

args [ 'price_per_metric_ton_of_c' ] ( float ) – 每公吨碳的现值。如果args['do_valuation']存在并且为 True，则使用。

args [ 'discount_rate' ] ( float ) – 需要 NPV 计算时使用的折扣率。如果args['do_valuation']存在并且为 True，则使用。

args [ 'rate_change' ] ( float ) – 碳价格的年度变化率（百分比）。如果args['do_valuation']存在并且为 True，则使用。

args [ 'n_workers' ] ( int ) –（可选）用于处理此模型的工作进程数。如果省略，计算将在当前进程中进行。