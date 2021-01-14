library(dplyr)
library(ggplot2)

marsupials <- read.csv(file = "outputs/marsupial_df.csv", header = T)[-c(1)]

#boxplot
ggplot(marsupials, aes(x = h,
                       y = reorder(family, -h, FUN = "mean"))) +
  geom_boxplot(fill = "salmon") +
  geom_jitter(alpha = 0.5) +
  labs(x = "h-index",
       y = "Family",
       title = "h-index of Australasian marsupials by family") +
  theme(title = element_text(size = 16),
        axis.title.x = element_text(size = 14),
        axis.text.x = element_text(size = 11),
        axis.title.y = element_text(size = 14),
        axis.text.y = element_text(size = 11))

#removing layers from boxplot
ggplot(marsupials, aes(x = h,
                       y = reorder(family, -h, FUN = "mean"))) +
  geom_boxplot(fill = "salmon") +
  geom_jitter(alpha = 0.5) +
  theme(axis.title = element_blank(),
        axis.text = element_blank(),
        panel.background = element_blank())
