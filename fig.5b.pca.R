#library(ggplot2)
#library(ggrepel)


# 加载包
library(FactoMineR)  # PCA分析
library(factoextra)   # 可视化
library(ggplot2)      # 绘图
#library(readxl)       # 读取Excel文件
library(ggrepel)      # 避免标签重叠
library(openxlsx)

# 读取数据（替换为你的文件路径）
data<-read.xlsx("D:\\ITRDB_5000\\Mountain_site\\PCA-traits.xlsx",sheet=1)
data <- as.data.frame(data)
data<-na.omit(data)
# 处理缺失值（此处用列均值填充）
#data <- as.data.frame(lapply(data, function(x) ifelse(is.na(x), mean(x, na.rm = TRUE), x)))

# 标准化数据（PCA默认会中心化，但scale=TRUE会标准化）
pca_result <- PCA(data, scale.unit = TRUE, graph = FALSE)

# 绘制变量分类图（载荷图）
fviz_pca_var(
  pca_result,
  col.var = "contrib",          # 颜色表示变量对主成分的贡献度
  gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"), # 颜色渐变
  repel = TRUE,                 # 避免标签重叠
  arrowsize = 1.5)+              # 箭头大小
#  labelsize = 5,                # 标签大小
#  title = "PCA Variable Classification Plot") +
  theme_minimal()
ggsave("D:\\ITRDB_5000\\Mountain_site\\PCA-traits-4-7.tiff",width = 6, height = 6,dpi = 300)
