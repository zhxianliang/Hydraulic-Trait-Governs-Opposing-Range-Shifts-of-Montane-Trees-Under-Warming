library(ggplot2)
library(readxl)
library(plantlist)
library(patchwork)

rm(list = ls())

# 读取物种代码和物种名
specode <- read_excel("D:/ITRDB_5000/Mountain_site/data/Fig.S6_TableS1back.xlsx")[, 1:2]

# 标准化物种名并获取分类信息
spec <- TPL(specode$Species)
spec <- merge(spec, specode, by.x = "YOUR_SEARCH", by.y = "Species")

# 按植物类群排序
spec <- spec[order(spec$GROUP), ]

# 读取作图数据
plotdata <- read_excel("D:/ITRDB_5000/Mountain_site/data/fig.S6_data_shift.xlsx", sheet = "Sheet1")

plotdata$ele <- as.numeric(plotdata$ele)
plotdata$ele[is.nan(plotdata$ele)] <- NA

# 设置物种顺序
plotdata$species <- factor(plotdata$species, levels = spec$Code)

# 把 GROUP 信息合并到 plotdata
groupinfo <- spec[, c("Code", "GROUP")]
plotdata <- merge(plotdata, groupinfo, by.x = "species", by.y = "Code", all.x = TRUE)

# 保持原来的物种顺序
plotdata$species <- factor(plotdata$species, levels = spec$Code)

# 若有缺失分组，可手动指定
# plotdata$GROUP[is.na(plotdata$GROUP)] <- "Angiosperms"

# 统一分组顺序
plotdata$GROUP <- factor(plotdata$GROUP, levels = c("Gymnosperms", "Angiosperms"))

# 自定义颜色
group_cols <- c("Gymnosperms" = "#1b9e77","Angiosperms" = "#d95f02")

# 上图：海拔
p1 <- ggplot(plotdata, aes(x = species, y = ele, fill = GROUP)) +
  geom_boxplot() +
  scale_fill_manual(values = group_cols) +
  theme_bw()+
  ylab("Elevation(m)")+
  theme(axis.text.x = element_text(angle =90),
        axis.text.y = element_text(angle =90))


# 下图：迁移速率

p2 <- ggplot(plotdata, aes(x = species, y = shift, fill = GROUP)) +
  geom_boxplot() +
  scale_fill_manual(values = group_cols) +
  theme_bw()+
  Xlab('Species')+
  ylab(expression("Shift rate"~(m~year^{-1})))+
  theme(axis.text.x = element_text(angle =90),
        axis.text.y = element_text(angle =90))

library(patchwork)
p1 <- (p1+theme(axis.title.x =element_blank(),
                axis.text.x = element_blank(),
                axis.ticks.x = element_blank(),
                plot.margin =unit(c(0,0,0,0),"cm")))


p2 <- (p2+theme(plot.margin =unit(c(0,0,0,0),"cm")))

# 合并图形
p1 / p2

# 保存
ggsave("D:/ITRDB_5000/Mountain_site/fig_2026_4_5/fig_shift_rate.48.tiff",
       width = 14, height = 7, dpi = 300)
