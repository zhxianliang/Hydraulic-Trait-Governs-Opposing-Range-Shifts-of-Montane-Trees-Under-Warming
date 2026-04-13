library(ggplot2)
library(reshape2)
library(openxlsx)
library(readxl)
library(plantlist)

rm(list = ls())

specode <- read.csv("D:/ITRDB_5000/Mountain_site/data/fig.S1.S2.S4.S5_Mountain site.csv", header = TRUE)

spee <- unique(specode$specode)
idx <- specode$elev

for (i in 1:226) {
  speee <- spee[i]
  sss <- which(specode$specode == speee)
  len <- length(sss)
  if (len < 20) {
    idx[sss] <- NA
  }
}

idxx <- na.omit(idx)

non_na_indexes <- which(!is.na(idx))
sped <- specode[non_na_indexes, ]

# 物种排序
speorder0 <- levels(as.factor(sped$species))
speorder <- TPL(speorder0)
speorder <- speorder[order(speorder$GROUP), ]

# 提取 species 和 specode 对应关系
speok <- sped[, 6:7]
speok <- speok[!duplicated(speok$species), ]

# 合并分类信息
speorder <- merge(speorder, speok, by.x = "YOUR_SEARCH", by.y = "species")
speorder <- speorder[order(speorder$GROUP), ]

# 给 sped 加入 GROUP 信息
groupinfo <- speorder[, c("specode", "GROUP")]
sped <- merge(sped, groupinfo, by = "specode", all.x = TRUE)

# 保持物种顺序
sped$specode <- factor(sped$specode, levels = speorder$specode)

# 统一组别名称顺序
sped$GROUP <- factor(sped$GROUP, levels = c("Gymnosperms", "Angiosperms"))

# 自定义颜色
group_cols <- c("Gymnosperms" = "#1b9e77","Angiosperms" = "#d95f02")

# -------- boxplot: 海拔 --------
p1 <- ggplot(sped, aes(specode, elev, group = specode, fill = GROUP), na.rm = TRUE) +
  geom_boxplot(na.rm = TRUE, notch = FALSE) +
  scale_fill_manual(values = group_cols) +
  ylab("Elevation (m)") +
  xlab("Species") +
  labs(fill = "Group") +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 90))

p1

ggsave("D:/ITRDB_5000/Mountain_site/fig_2026_4_5/fig_species_elev_treering.tiff",
       plot = p1, width = 12, height = 4, dpi = 300)
