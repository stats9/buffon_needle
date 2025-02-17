BioStatistics Sums
================
habib Ezatabadi

``` r
library(tidyverse)
library(grid)
library(png)
"patchwork" |> library()
```

------------------------------------------------------------------------

``` r
set.seed(769534)                              # Create example data
f1 <- function(x) 1/64* (x + 20)**2 
f2 <- function(x) 1/64 * x**2 
f3 <- function(x) 1/64 * (x ****- 20)**2 

seq1 <- f1((-20):(-11))
seq2 <- f2((-10):(9))
seq3 <- f3(10:20)
x1 <- c(-20:20); y1 <- c(seq1, seq2, seq3); 
Group <- paste0("line:", (-20):20)
dat <- data.frame(x = x1, xend = x1, y = rep(-.5, 41), yend = y1, Group = Group)
my_plot <- ggplot() + 
stat_function(fun = f1, xlim = c(-20, -10), linewidth = 1.5, 
colour = "#0a6d17") +
stat_function(fun = f2, xlim = c(-10, 10), linewidth = 1.5, 
colour = "#0a6d17") + 
stat_function(fun = f3, xlim = c(10, 20), linewidth = 1.5, 
colour = "#0a6d17") + 
  theme(
    panel.border = element_blank(),
    axis.text = element_blank(),
    panel.grid = element_blank(),
    axis.ticks = element_blank(), 
    panel.background = element_rect(fill = "white")
  ) + 
  coord_cartesian(x = c(-20, 20), y = c(-1, 2)) +
  geom_segment(data = dat, aes(x = x, xend = xend, y = y, 
  yend = yend, group = Group), colour = "#0a6d17") +
  annotate(geom = "text", label = "Bridging", angle = -60, x = -5, 
  y = f2(-5) + 0.35, colour = "black", size = 10, family = "serif") + 
    annotate(geom = "text", label = "The", angle = 0, x = 0, 
  y = f2(0) + 0.15, colour = "black", size = 10, family = "serif") +
    annotate(geom = "text", label = "Sciences", angle = 62.5, x = 5, 
  y = f2(5) + 0.3, colour = "black", size = 10, family = "serif") + 
  annotate(geom = "text", label = "Departement of Biostatistics 
  Shiraz University of Medical Sciences", 
  x = 0, y = -.75, colour = "black", family = "serif", 
  size = 5) + 
  labs(x = "", y = "") + 
  annotate(geom = "segment", x = c(-20, -10, 10), 
  xend = c(20, -10, 10), y = rep(-0.5, 3), yend = 
  c(-0.5, f2(-10), f2(10)), linewidth = 1.5, 
  colour = "#0a6d17")
```

------------------------------------------------------------------------

``` r
my_image1 <- readPNG(file.choose())
```

------------------------------------------------------------------------

``` r
g <- rasterGrob(my_image1, interpolate=TRUE)
Final_Plot <- my_plot +
  annotation_custom(g, xmin = -4, xmax = 4, ymin = 0.5, ymax = 2) 
```

------------------------------------------------------------------------

``` r
Final_Plot
```

![](Create_a_log_for_biostatistics_for_sums_files/figure-gfm/unnamed-chunk-5-1.png)<!-- -->
