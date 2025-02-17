# calculate Median of beta Distribution

## code

``` r
Get_median_and_max_Beta <- function(shape1 = 2.7, shape2 = 6.3) {
    f <- function(x) pbeta(x, shape1 = shape1, shape2 = shape2)
    temp_fun <- function(x) (f(x) - 1/2) ** 2
    res <- optimize(temp_fun, interval = c(0, 1))
    f2 <- function(x) dbeta(x, shape1 = shape1, shape2 = shape2)
    res2 <- optimize(f2, interval = c(0, 1), maximum = TRUE)$objective
    return(list(Median = res$minimum, maximum = res2))
}

result <- Get_median_and_max_Beta()

Med <- result$Median
maxx <- result$maximum

ff <- function(x) dbeta(x, shape1 = 2.7, shape2 = 6.3)
xx <- seq(0, 1, len = 1e+4)
yy <- ff(xx) 

plot(x = xx, y = yy, type = "l", lwd = 2, xlim = c(0, 1), ylim = c(0, 3), 
frame = FALSE, xaxt = "n", yaxt = "n", xlab = "x", ylab = "y")
abline(h = maxx, lwd = 2, col = "darkblue")
lines(x = c(Med, Med), y = c(0, ff(Med)), col = "red", lwd = 2)
text(x = 0.8, y = maxx + 0.075, label = bquote("Maximum "==.(round(maxx, 4))))
axis(1, at = seq(0, 1, by = 0.2), labels = seq(0, 1, by = 0.2), padj = 0, line = -0.75)
axis(2, at = seq(0, 3, by = 1), labels = seq(0, 3, by = 1), padj = 0, line = -1.5)
x2 <- seq(0, Med, len = 1e+4)
y2 <- ff(x2)
polygon(x = c(x2, rev(x2)), y = c(y2, rep(0, length(x2))), col = "black")
```

![](calculate_Median_of_Beta_dist_files/figure-commonmark/unnamed-chunk-1-1.png)
