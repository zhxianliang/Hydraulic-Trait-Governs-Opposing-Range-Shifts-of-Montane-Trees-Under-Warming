library(ggplot2)
library(readxl)
library(openxlsx)

rm(list = ls())

#-----------------------------#
# 1. 读入数据
#-----------------------------#
specode <- read.csv("D:/ITRDB_5000/Mountain_site/data/fig.S1.S2.S4.S5_Mountain site.csv", header = TRUE)

# 目标物种
spetar <- c(" FASY", " PCAB", " PCEN", " PSME", " JUOC",
            " LADE", " JUSP", " PINI", " AUCH")

# 仅保留目标物种
datatar <- specode[specode$specode %in% spetar, ]

# 输出路径
out_dir <- "D:/ITRDB_5000/Mountain_site/revise/"
if (!dir.exists(out_dir)) dir.create(out_dir, recursive = TRUE)

#-----------------------------#
# 2. 各物种筛选规则
#   按你原始代码逻辑保留
#-----------------------------#
filter_species_data <- function(df, sp){
  sub <- df[df$specode == sp, ]
  
  if (sp == " FASY") sub <- sub[sub$lat < 49, ]
  if (sp == " PCAB") sub <- sub[sub$lat < 55, ]
  if (sp == " PCEN") sub <- sub
  if (sp == " PSME") sub <- sub[sub$lon < 0, ]
  if (sp == " JUOC") sub <- sub[sub$lon > -115, ]
  if (sp == " LADE") sub <- sub[sub$lon > 0, ]
  if (sp == " JUSP") sub <- sub[sub$lon > 0, ]
  if (sp == " PINI") sub <- sub
  if (sp == " AUCH") sub <- sub
  
  sub
}

#-----------------------------#
# 3. P值格式化函数
#-----------------------------#
format_p <- function(p){
  if (is.na(p)) {
    return("P = NA")
  } else if (p < 0.001) {
    return("P < 0.001")
  } else {
    return(paste0("P = ", signif(p, 2)))
  }
}

#-----------------------------#
# 4. 单物种作图函数
#-----------------------------#
plot_species_ele_tem <- function(df, sp, out_dir){
  
  sub <- filter_species_data(df, sp)
  
  # 去除缺失值
  sub <- sub[!is.na(sub$elev) & !is.na(sub$temcr), ]
  
  # 至少需要3个点
  if (nrow(sub) < 3) {
    message(trimws(sp), ": not enough data after filtering.")
    return(NULL)
  }
  
  # 线性回归
  model <- lm(temcr ~ elev, data = sub)
  sm <- summary(model)
  
  r2 <- sm$r.squared
  p  <- sm$coefficients[2, 4]
  slope <- coef(model)[2]
  
  label_text <- paste0("R² = ", sprintf("%.2f", r2),
                       "\n", format_p(p))
  
  # 注释位置：右上角
  x_pos <- max(sub$elev, na.rm = TRUE)
  y_pos <- max(sub$temcr, na.rm = TRUE)
  
  p1 <- ggplot(sub, aes(x = elev, y = temcr)) +
    geom_point(size = 2.8, alpha = 0.9, na.rm = TRUE) +
    geom_smooth(method = "lm", se = TRUE, linewidth = 0.8, na.rm = TRUE) +
    annotate("text",
             x = x_pos, y = y_pos,
             label = label_text,
             hjust = 1, vjust = 1,
             size = 5) +
    labs(
      x = "Elevation (m)",
      y = "TEM-growth Correlation",
      title = trimws(sp)
    ) +
    theme_bw() +
    theme(
      panel.grid = element_blank(),
      axis.text = element_text(size = 14, color = "black"),
      axis.title = element_text(size = 15, color = "black"),
      plot.title = element_text(size = 15, hjust = 0.5, face = "italic"),
      plot.margin = margin(8, 8, 8, 8)
    )
  
  # 保存图片
  out_file <- paste0(out_dir, "fig_", trimws(sp), "_tem_11_22.tiff")
  ggsave(out_file, plot = p1, width = 6, height = 5, dpi = 300, compression = "lzw")
  
  # 返回统计结果
  data.frame(
    species = trimws(sp),
    n = nrow(sub),
    slope = slope,
    R2 = r2,
    P_value = p,
    stringsAsFactors = FALSE
  )
}

#-----------------------------#
# 5. 批量运行
#-----------------------------#
result_list <- lapply(spetar, function(sp){
  plot_species_ele_tem(datatar, sp, out_dir)
})

# 去掉 NULL
result_list <- result_list[!sapply(result_list, is.null)]

result_table <- do.call(rbind, result_list)

#-----------------------------#
# 6. 导出统计表
#-----------------------------#
write.xlsx(result_table,
           file = paste0(out_dir, "FigS5_regression_statistics_tem.xlsx"),
           rowNames = FALSE)

print(result_table)