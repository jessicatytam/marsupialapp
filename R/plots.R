library(dplyr)
library(ggplot2)

marsupials <- read.csv(file = "outputs/marsupial_df.csv", header = T)[-c(1)]

#violin plot
ggplot(marsupials, aes(x = family,
                       y = h,
                       fill = family)) +
  geom_violin() +
  labs(x = "Family",
       y = "h-index") +
  theme(axis.title.x = element_text(size = 16),
        axis.text.x = element_text(size = 12,
                                   angle = 90),
        axis.title.y = element_text(size = 16),
        axis.text.y = element_text(size = 12),
        legend.position = "none")

#violin plot (count)
ggplot(marsupials, aes(x = family,
                       y = h,
                       fill = family)) +
  geom_violin(scale = "count") +
  labs(x = "Family",
       y = "h-index") +
  theme(axis.title.x = element_text(size = 16),
        axis.text.x = element_text(size = 12,
                                   angle = 90),
        axis.title.y = element_text(size = 16),
        axis.text.y = element_text(size = 12),
        legend.position = "none")

#violin plot (width)
ggplot(marsupials, aes(x = family,
                       y = h,
                       fill = family)) +
  geom_violin(scale = "width") +
  labs(x = "Family",
       y = "h-index") +
  theme(axis.title.x = element_text(size = 16),
        axis.text.x = element_text(size = 12,
                                   angle = 90),
        axis.title.y = element_text(size = 16),
        axis.text.y = element_text(size = 12),
        legend.position = "none")
