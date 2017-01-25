library(ggplot2)
source("helper.R", local = T)

downsample_0.5 <- read.csv("data/virat_s_000003.gpu.0.5.txt", header = F)
downsample_0.5$label <- 0.5
downsample_0.5$resolution <- "960×540"

downsample_0.6 <- read.csv("data/virat_s_000003.gpu.0.6.txt", header = F)
downsample_0.6$label <- 0.6
downsample_0.6$resolution <- "1152×648"

downsample_0.7 <- read.csv("data/virat_s_000003.gpu.0.7.txt", header = F)
downsample_0.7$label <- 0.7
downsample_0.7$resolution <- "1344×756"

downsample_0.8 <- read.csv("data/virat_s_000003.gpu.0.8.txt", header = F)
downsample_0.8$label <- 0.8
downsample_0.8$resolution <- "1536×864"

downsample_0.9 <- read.csv("data/virat_s_000003.gpu.0.9.txt", header = F)
downsample_0.9$label <- 0.9
downsample_0.9$resolution <- "1728x972"

downsample_1.0 <- read.csv("data/virat_s_000003.gpu.1.0.txt", header = F)
downsample_1.0$label <- 1.0
downsample_1.0$resolution <- "1920×1080"

all <- rbind(downsample_0.5,
             downsample_0.6,
             downsample_0.7,
             downsample_0.8,
             downsample_0.9,
             downsample_1.0);
names(all) <- c("frame", "detect", "time", "label", "resolution")

groundtruth <- c(rep(7, (47 - 0) * 29.9),
                 rep(6, (58 - 47) * 29.9),
                 rep(5, (72 - 58) * 29.9),
                 rep(4, (127 - 72) * 29.9),
                 rep(5, (176 - 127) * 29.9),
                 rep(6, (195 - 176) * 29.9),
                 rep(4, (202 - 195) * 29.9),
                 rep(3, (205 - 202) * 29.9),
                 rep(2, (250 - 205) * 29.9),
                 rep(3, (260 - 250) * 29.9),
                 rep(4, (265 - 260) * 29.9),
                 rep(5, (280 - 265) * 29.9),
                 rep(4, (296 - 280) * 29.9),
                 rep(3, (343 - 296) * 29.9),
                 rep(5, (349 - 343) * 29.9),
                 rep(6, (409 - 349) * 29.9),
                 rep(7, (437 - 409) * 29.9),
                 rep(6, (443 - 437) * 29.9),
                 rep(5, (531 - 443) * 29.9),
                 rep(6, (572 - 531) * 29.9),
                 rep(7, (596 - 572) * 29.9),
                 rep(6, (605 - 596) * 29.9),
                 rep(5, (607 - 605) * 29.9),
                 rep(7, (637 - 607) * 29.9),
                 rep(8, (641 - 637) * 29.9),
                 rep(7, (642 - 641) * 29.9),
                 rep(6, (679 - 642) * 29.9),
                 rep(5, (678 - 673) * 29.9),
                 rep(6, (694 - 678) * 29.9))
last <- rep(7, 20940 - length(groundtruth))
groundtruth <- c(groundtruth, last)

all$error <- abs(all$detect - groundtruth) * 1.0 / groundtruth * 100

## Draw bar plot of time distribution
time_se <- summarySE(all, measurevar="time", groupvars=c("label"))

time_bar <- ggplot(time_se, aes(x=as.factor(label), y=time)) +
    geom_bar(position=position_dodge(),
             stat="identity", colour="black", size=0.3, width=.7) +
    geom_errorbar(aes(ymin=time-sd, ymax=time+sd), width = .2) +
    ylab("Time (ms)") +
    xlab("Frame Resolution") +
    theme_bw() +
    scale_x_discrete(labels = c("960×540",
                                "1152×648",
                                "1344×756",
                                "1536×864",
                                "1728x972",
                                "1920×1080")) +
    theme(text = element_text(size=18),
          axis.text.x = element_text(angle = 45, hjust = 1))

## ## CDF of time
## cbPalette <- c("#999999", "#E69F00", "#56B4E9", "#009E73",
##                "#F0E442", "#0072B2", "#D55E00", "#CC79A7")
## cdf <- ggplot(all, aes(time, colour = label)) +
##     stat_ecdf(linetype="dashed",
##               size = 1) +
##     xlab("Processing Time (ms)") +
##     ylab("Cumulative Distribution") +
##     xlim(0, 380) +
##     theme_bw() +
##     custom_theme() +
##     theme(legend.position = c(.8, .25),
##           legend.background = element_rect(colour = "black")) +
##     scale_colour_manual(values=cbPalette)
## ggsave("downsample-time.pdf", plot = cdf, width = 5, height = 5)

## Draw bar plot of error
error_se <- summarySE(all, measurevar="error", groupvars=c("label"))
error_bar <- ggplot(error_se, aes(x=as.factor(label), y=error)) +
    geom_bar(position=position_dodge(),
             stat="identity", colour="black", size=0.3, width=.7) +
    geom_errorbar(aes(ymin=error-se, ymax=error+se), width = .2) +
    ylab("Error") +
    xlab("Frame Resolution") +
    ylim(0, 100) +
    theme_bw() +
    theme(axis.title.y = element_text(margin=margin(0, 10, 0, 0))) +
    theme(axis.title.x = element_text(margin=margin(10, 0, 0, 0))) +
    theme(axis.title.x = element_blank(),
          axis.text.x = element_blank(),
          axis.title.y = element_text(margin=margin(0, 10, 0, 0))) +
    theme(text = element_text(size=18))

library(grid)
pdf("accuracy-performance.pdf", width = 5, height = 5)
grid.newpage()
grid.draw(rbind(ggplotGrob(error_bar), ggplotGrob(time_bar), size = "last"))
dev.off()

#############################################################
library(TTR)


downsample_0.5 <- read.csv("data/virat_s_000003.gpu.0.5.txt", header = F)
downsample_0.5$label <- 0.5
downsample_0.5$resolution <- "960×540"
downsample_0.5$smoothed <- TTR::EMA(downsample_0.5$V2, n = 10, ratio=0.1)

downsample_0.6 <- read.csv("data/virat_s_000003.gpu.0.6.txt", header = F)
downsample_0.6$label <- 0.6
downsample_0.6$resolution <- "1152×648"
downsample_0.6$smoothed <- TTR::EMA(downsample_0.6$V2, n = 10, ratio=0.1)

downsample_0.7 <- read.csv("data/virat_s_000003.gpu.0.7.txt", header = F)
downsample_0.7$label <- 0.7
downsample_0.7$resolution <- "1344×756"
downsample_0.7$smoothed <- TTR::EMA(downsample_0.7$V2, n = 10, ratio=0.1)

downsample_0.8 <- read.csv("data/virat_s_000003.gpu.0.8.txt", header = F)
downsample_0.8$label <- 0.8
downsample_0.8$resolution <- "1536×864"
downsample_0.8$smoothed <- TTR::EMA(downsample_0.8$V2, n = 10, ratio=0.1)

downsample_0.9 <- read.csv("data/virat_s_000003.gpu.0.9.txt", header = F)
downsample_0.9$label <- 0.9
downsample_0.9$resolution <- "1728x972"
downsample_0.9$smoothed <- TTR::EMA(downsample_0.9$V2, n = 10, ratio=0.1)

downsample_1.0 <- read.csv("data/virat_s_000003.gpu.1.0.txt", header = F)
downsample_1.0$label <- 1.0
downsample_1.0$resolution <- "1920×1080"
downsample_1.0$smoothed <- TTR::EMA(downsample_1.0$V2, n = 10, ratio=0.1)

all <- rbind(na.omit(downsample_0.5),
             na.omit(downsample_0.6),
             na.omit(downsample_0.7),
             na.omit(downsample_0.8),
             na.omit(downsample_0.9),
             na.omit(downsample_1.0));
names(all) <- c("frame", "detect", "time", "label", "resolution", "smoothed")
all$size <- .8

frame <- seq(1, 20940)
gt <- data.frame(frame)
gt$detect <- groundtruth
gt$time <- 0
gt$label <- 100
gt$resolution <- 0
gt$smoothed <- groundtruth
gt$size <- 1

all2 <- rbind(all, gt)

subset <- all2[all2$frame < 10000,]

ts_plot <- ggplot(subset, aes(x=frame,
                              y=as.integer(smoothed),
                              colour=as.factor(label),
                              size=size)) +
    geom_line() +
    scale_size(range = c(0.5, 3)) +
    custom_theme() +
    scale_colour_discrete(name = "Resolution",
                          labels = c("960×540",
                                     "1152×648",
                                     "1344×756",
                                     "1536×864",
                                     "1728x972",
                                     "1920×1080",
                                     "groundtruth")) +
    guides(size=FALSE, col = guide_legend(ncol = 3)) +
    theme(legend.position = c(.65, .79),
          legend.background = element_rect(colour = "black")) +
    xlab("Frame") + ylab("Detected Number of People") +
    theme(text = element_text(size=18))
ggsave("time-series.pdf", plot = ts_plot, width = 7, height = 5)
