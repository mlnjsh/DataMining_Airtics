############################################################
#  EXPLORATORY DATA ANALYSIS  (EDA)
#  Task 1 data : Task1.csv     (32 cars, 11 numeric variables)
#  Task 2 data : crop_data.csv (96 plots, fertilizer x density)
#
#  Structure of the analysis for EACH data set
#    A. Data quality  : shape, types, missing values, duplicates
#    B. Univariate    : distribution of every variable, outliers
#    C. Bivariate     : correlations and group comparisons
#    D. Multivariate  : interactions between three variables
#  Findings and actionable insights are in EDA_Report.md
#
#  Run with the working directory set to this folder.
############################################################

plot_dir <- "plots"
if (!dir.exists(plot_dir)) dir.create(plot_dir)
save_png <- function(name, w = 900, h = 600) png(file.path(plot_dir, name), w, h, res = 110)
done <- function() invisible(dev.off())

# Helper : a compact descriptive table for numeric columns
describe <- function(df) {
  skew <- function(v) mean((v - mean(v))^3) / sd(v)^3
  out <- data.frame(
    n      = sapply(df, length),
    mean   = round(sapply(df, mean), 2),
    sd     = round(sapply(df, sd), 2),
    min    = sapply(df, min),
    Q1     = sapply(df, quantile, 0.25),
    median = sapply(df, median),
    Q3     = sapply(df, quantile, 0.75),
    max    = sapply(df, max),
    skew   = round(sapply(df, skew), 2),
    CV_pct = round(100 * sapply(df, sd) / sapply(df, mean), 1)
  )
  out
}

# Helper : count IQR outliers per column and name the rows
iqr_outliers <- function(df, labels) {
  res <- list()
  for (col in names(df)) {
    v  <- df[[col]]
    q  <- quantile(v, c(0.25, 0.75)); iqr <- q[2] - q[1]
    idx <- which(v < q[1] - 1.5 * iqr | v > q[2] + 1.5 * iqr)
    if (length(idx) > 0)
      res[[col]] <- paste0(labels[idx], " (", v[idx], ")", collapse = ", ")
  }
  if (length(res) == 0) cat("  none\n") else
    for (n in names(res)) cat("  ", n, ":", res[[n]], "\n")
}


############################################################
############################################################
#  PART 1 : TASK 1 DATA  (cars)
############################################################
############################################################

cars <- read.csv("../../1. Formative and Summative Assessment/S-Assignment Task 1/Task1.csv")

cat("##########################################################\n")
cat("#  TASK 1 : CARS DATA\n")
cat("##########################################################\n")

# ---------- A. Data quality ----------------------------------
cat("\n=== 1A. DATA QUALITY ===\n")
cat("Rows x columns :", dim(cars), "\n")
str(cars)
cat("\nMissing values per column :\n"); print(colSums(is.na(cars)))
cat("Duplicate rows :", sum(duplicated(cars)), "\n")
cat("Duplicate car names :", sum(duplicated(cars$model)), "\n")

# Which columns are really categorical even though stored as numbers ?
cat("\nDistinct values per column (small counts = categorical) :\n")
print(sapply(cars[, -1], function(x) length(unique(x))))
#  cyl (3), vs (2), am (2), gear (3), carb (6) are categorical.

num_vars <- c("mpg", "disp", "hp", "drat", "wt", "qsec")
cat_vars <- c("cyl", "vs", "am", "gear", "carb")

# ---------- B. Univariate ------------------------------------
cat("\n=== 1B. UNIVARIATE : CONTINUOUS VARIABLES ===\n")
print(describe(cars[, num_vars]))
cat("\nReading skew : > 0.5 right-skewed, < -0.5 left-skewed.\n")
cat("CV_pct = coefficient of variation = spread relative to the mean.\n")

save_png("t1_hist_all.png", 1100, 700)
par(mfrow = c(2, 3), mar = c(4, 4, 3, 1))
for (v in num_vars) {
  hist(cars[[v]], breaks = 8, col = "steelblue", border = "white",
       main = paste("Histogram of", v), xlab = v)
  abline(v = mean(cars[[v]]), col = "red", lwd = 2, lty = 2)
  abline(v = median(cars[[v]]), col = "darkgreen", lwd = 2, lty = 3)
}
par(mfrow = c(1, 1)); done()

save_png("t1_box_all.png", 1100, 700)
par(mfrow = c(2, 3), mar = c(3, 4, 3, 1))
for (v in num_vars) boxplot(cars[[v]], col = "lightblue", main = paste("Box plot of", v))
par(mfrow = c(1, 1)); done()

cat("\nOutliers by the 1.5 x IQR rule :\n")
iqr_outliers(cars[, num_vars], cars$model)

cat("\n=== 1B. UNIVARIATE : CATEGORICAL VARIABLES ===\n")
for (v in cat_vars) {
  cat("\n", v, ":\n")
  tb <- table(cars[[v]])
  print(rbind(count = tb, percent = round(100 * prop.table(tb), 1)))
}

save_png("t1_bar_all.png", 1100, 350)
par(mfrow = c(1, 5), mar = c(4, 4, 3, 1))
for (v in cat_vars) barplot(table(cars[[v]]), col = "tan", main = v, ylab = "cars")
par(mfrow = c(1, 1)); done()

# ---------- C. Bivariate -------------------------------------
cat("\n=== 1C. CORRELATION MATRIX (all numeric columns) ===\n")
cm <- cor(cars[, -1])
print(round(cm, 2))

cat("\nCorrelation of every variable with mpg, strongest first :\n")
print(round(sort(cm[, "mpg"], decreasing = TRUE), 3))

cat("\nStrongly correlated predictor PAIRS (|r| > 0.7, excluding mpg) :\n")
pred_cm <- cm[colnames(cm) != "mpg", colnames(cm) != "mpg"]
pairs_idx <- which(abs(pred_cm) > 0.7 & upper.tri(pred_cm), arr.ind = TRUE)
for (k in seq_len(nrow(pairs_idx)))
  cat("  ", rownames(pred_cm)[pairs_idx[k, 1]], "-", colnames(pred_cm)[pairs_idx[k, 2]],
      ": r =", round(pred_cm[pairs_idx[k, 1], pairs_idx[k, 2]], 2), "\n")

# Correlation heat map in base R
save_png("t1_corr_heatmap.png", 800, 750)
par(mar = c(5, 5, 3, 1))
n <- ncol(cm)
image(1:n, 1:n, cm[, n:1], col = colorRampPalette(c("#B2182B", "white", "#2166AC"))(50),
      zlim = c(-1, 1), axes = FALSE, xlab = "", ylab = "", main = "Correlation heat map")
axis(1, 1:n, colnames(cm), las = 2); axis(2, 1:n, rev(colnames(cm)), las = 1)
for (i in 1:n) for (j in 1:n) text(i, n + 1 - j, sprintf("%.2f", cm[i, j]), cex = 0.75)
done()

save_png("t1_pairs.png", 1000, 1000)
pairs(cars[, num_vars], pch = 16, col = ifelse(cars$am == 1, "#D0342C", "#2E5A88"),
      main = "Scatter plot matrix  (red = manual, blue = automatic)")
done()

cat("\n=== 1C. mpg BY EACH CATEGORICAL VARIABLE ===\n")
for (v in cat_vars) {
  cat("\nmpg by", v, ":\n")
  print(aggregate(mpg ~ get(v), data = cars,
                  FUN = function(x) round(c(mean = mean(x), sd = sd(x), n = length(x)), 2)))
}

save_png("t1_mpg_by_groups.png", 1100, 350)
par(mfrow = c(1, 5), mar = c(4, 4, 3, 1))
for (v in cat_vars)
  boxplot(cars$mpg ~ cars[[v]], col = "lightgreen", main = paste("mpg by", v), xlab = v, ylab = "mpg")
par(mfrow = c(1, 1)); done()

# Does the transmission difference survive after accounting for weight ?
cat("\nWeight by transmission (is 'am' confounded with weight ?) :\n")
print(aggregate(wt ~ am, data = cars, FUN = function(x) round(c(mean = mean(x), sd = sd(x)), 2)))
cat("t-test mpg ~ am : p =", format.pval(t.test(mpg ~ am, data = cars)$p.value, digits = 3), "\n")
cat("Same test after adjusting for weight (lm mpg ~ wt + am) : p for am =",
    format.pval(summary(lm(mpg ~ wt + am, data = cars))$coefficients["am", 4], digits = 3), "\n")

# ---------- D. Multivariate ----------------------------------
save_png("t1_mpg_wt_am.png", 900, 600)
par(mar = c(4.5, 4.5, 3, 1))
plot(cars$wt, cars$mpg, pch = 16, cex = 1.3,
     col = ifelse(cars$am == 1, "#D0342C", "#2E5A88"),
     xlab = "Weight (1000 lbs)", ylab = "mpg", main = "mpg vs weight, by transmission")
abline(lm(mpg ~ wt, data = cars[cars$am == 1, ]), col = "#D0342C", lwd = 2)
abline(lm(mpg ~ wt, data = cars[cars$am == 0, ]), col = "#2E5A88", lwd = 2)
legend("topright", c("manual", "automatic"), col = c("#D0342C", "#2E5A88"), pch = 16, bty = "n")
done()

save_png("t1_mpg_hp_cyl.png", 900, 600)
par(mar = c(4.5, 4.5, 3, 1))
cols <- c("4" = "#1B9E77", "6" = "#D95F02", "8" = "#7570B3")
plot(cars$hp, cars$mpg, pch = 16, cex = 1.3, col = cols[as.character(cars$cyl)],
     xlab = "Horsepower", ylab = "mpg", main = "mpg vs horsepower, by cylinders")
legend("topright", paste(names(cols), "cyl"), col = cols, pch = 16, bty = "n")
done()

cat("\nmpg by cyl x am (cell means and counts) :\n")
print(round(tapply(cars$mpg, list(cyl = cars$cyl, am = cars$am), mean), 1))
print(table(cyl = cars$cyl, am = cars$am))

cat("\nTop 5 and bottom 5 cars by mpg :\n")
print(head(cars[order(-cars$mpg), c("model", "mpg", "cyl", "wt", "hp", "am")], 5))
print(head(cars[order(cars$mpg),  c("model", "mpg", "cyl", "wt", "hp", "am")], 5))

# Power-to-weight as a derived feature
cars$hp_per_ton <- round(cars$hp / (cars$wt * 0.4536), 1)   # wt is in 1000 lbs
cat("\nCorrelation of mpg with hp per tonne :", round(cor(cars$mpg, cars$hp_per_ton), 3), "\n")


############################################################
############################################################
#  PART 2 : TASK 2 DATA  (crop yield)
############################################################
############################################################

crop <- read.csv("../../1. Formative and Summative Assessment/S-Assignment Task 2/crop_data.csv")

cat("\n\n##########################################################\n")
cat("#  TASK 2 : CROP YIELD DATA\n")
cat("##########################################################\n")

# ---------- A. Data quality ----------------------------------
cat("\n=== 2A. DATA QUALITY ===\n")
cat("Rows x columns :", dim(crop), "\n")
str(crop)
cat("\nMissing values per column :\n"); print(colSums(is.na(crop)))
cat("Duplicate rows :", sum(duplicated(crop)), "\n")

crop$fertilizer <- factor(crop$fertilizer, labels = c("F1", "F2", "F3"))
crop$density    <- factor(crop$density,    labels = c("Low", "High"))
crop$block      <- factor(crop$block)

cat("\nDesign balance (fertilizer x density) :\n"); print(table(crop$fertilizer, crop$density))
cat("\nDesign balance (block x density) :\n");      print(table(crop$block, crop$density))
cat("Note : block 1 and 3 only appear with Low density, block 2 and 4 only with High.\n")
cat("Block and density are therefore CONFOUNDED : we cannot separate their effects.\n")

# ---------- B. Univariate ------------------------------------
cat("\n=== 2B. UNIVARIATE : YIELD ===\n")
print(describe(crop["yield"]))
cat("Range of yield :", round(diff(range(crop$yield)), 2), "bushels / acre\n")
cat("Relative spread : SD is", round(100 * sd(crop$yield) / mean(crop$yield), 2), "% of the mean\n")

q <- quantile(crop$yield, c(0.25, 0.75)); iqr <- q[2] - q[1]
out_idx <- which(crop$yield < q[1] - 1.5 * iqr | crop$yield > q[2] + 1.5 * iqr)
cat("IQR outliers :", length(out_idx), "\n")
if (length(out_idx)) print(crop[out_idx, ])

cat("\nShapiro-Wilk normality of yield : p =",
    round(shapiro.test(crop$yield)$p.value, 3), "\n")

save_png("t2_yield_dist.png", 1000, 450)
par(mfrow = c(1, 2), mar = c(4.5, 4.5, 3, 1))
hist(crop$yield, breaks = 14, col = "wheat", border = "white", freq = FALSE,
     main = "Distribution of yield", xlab = "Yield (bushels / acre)")
curve(dnorm(x, mean(crop$yield), sd(crop$yield)), add = TRUE, col = "red", lwd = 2)
qqnorm(crop$yield, pch = 16, col = "steelblue", main = "Normal Q-Q plot of yield"); qqline(crop$yield, col = "red")
par(mfrow = c(1, 1)); done()

cat("\nCounts per factor level :\n")
print(sapply(crop[, c("fertilizer", "density", "block")], table))

# ---------- C. Bivariate -------------------------------------
cat("\n=== 2C. YIELD BY EACH FACTOR ===\n")
grp <- function(f) aggregate(yield ~ get(f), data = crop, FUN = function(x)
  round(c(mean = mean(x), sd = sd(x), min = min(x), max = max(x), n = length(x)), 3))
for (f in c("fertilizer", "density", "block")) { cat("\nyield by", f, ":\n"); print(grp(f)) }

# Effect sizes : difference in means as a % and relative to SD
m_f <- tapply(crop$yield, crop$fertilizer, mean)
m_d <- tapply(crop$yield, crop$density, mean)
s   <- sd(crop$yield)
cat("\nEffect sizes :\n")
cat("  F3 vs F1 : +", round(m_f["F3"] - m_f["F1"], 3), "bushels (",
    round(100 * (m_f["F3"] / m_f["F1"] - 1), 2), "% ),", round((m_f["F3"] - m_f["F1"]) / s, 2), "SD\n")
cat("  F3 vs F2 : +", round(m_f["F3"] - m_f["F2"], 3), "bushels (",
    round(100 * (m_f["F3"] / m_f["F2"] - 1), 2), "% ),", round((m_f["F3"] - m_f["F2"]) / s, 2), "SD\n")
cat("  F2 vs F1 : +", round(m_f["F2"] - m_f["F1"], 3), "bushels (",
    round(100 * (m_f["F2"] / m_f["F1"] - 1), 2), "% ),", round((m_f["F2"] - m_f["F1"]) / s, 2), "SD\n")
cat("  High vs Low density : +", round(m_d["High"] - m_d["Low"], 3), "bushels (",
    round(100 * (m_d["High"] / m_d["Low"] - 1), 2), "% ),", round((m_d["High"] - m_d["Low"]) / s, 2), "SD\n")

save_png("t2_box_by_factor.png", 1200, 420)
par(mfrow = c(1, 3), mar = c(4.5, 4.5, 3, 1))
boxplot(yield ~ fertilizer, data = crop, col = c("tan", "darkseagreen", "lightskyblue"), main = "Yield by fertilizer")
points(1:3, m_f, pch = 18, col = "red", cex = 1.8)
boxplot(yield ~ density, data = crop, col = c("khaki", "salmon"), main = "Yield by density")
points(1:2, m_d, pch = 18, col = "red", cex = 1.8)
boxplot(yield ~ block, data = crop, col = "lightgray", main = "Yield by block")
par(mfrow = c(1, 1)); done()

# Strip chart : every observation, to see overlap between groups
save_png("t2_strip.png", 900, 550)
par(mar = c(4.5, 4.5, 3, 1))
stripchart(yield ~ interaction(density, fertilizer), data = crop, vertical = TRUE,
           method = "jitter", pch = 16, col = rep(c("#2E5A88", "#D0342C"), 3),
           main = "All 96 observations by fertilizer and density", ylab = "Yield", las = 2)
done()

# ---------- D. Multivariate ----------------------------------
cat("\n=== 2D. FERTILIZER x DENSITY ===\n")
cell <- aggregate(yield ~ fertilizer + density, data = crop,
                  FUN = function(x) round(c(mean = mean(x), sd = sd(x)), 3))
print(cell)
cat("\nCell means as a table :\n")
print(round(tapply(crop$yield, list(crop$fertilizer, crop$density), mean), 2))

cat("\nDensity gain within each fertilizer (High - Low) :\n")
tm <- tapply(crop$yield, list(crop$fertilizer, crop$density), mean)
print(round(tm[, "High"] - tm[, "Low"], 3))
cat("Similar gains in every row  ->  no interaction.\n")

save_png("t2_interaction.png", 900, 550)
par(mar = c(4.5, 4.5, 3, 1))
interaction.plot(crop$fertilizer, crop$density, crop$yield, fun = mean, type = "b",
                 col = c("#2E5A88", "#D0342C"), pch = c(16, 17), lwd = 2,
                 xlab = "Fertilizer", ylab = "Mean yield", trace.label = "Density",
                 main = "Interaction plot : nearly parallel lines")
done()

cat("\nBest and worst combinations :\n")
cm2 <- aggregate(yield ~ fertilizer + density, data = crop, mean)
cm2 <- cm2[order(-cm2$yield), ]; cm2$yield <- round(cm2$yield, 2); print(cm2)
cat("Gap best - worst :", round(max(cm2$yield) - min(cm2$yield), 2), "bushels / acre (",
    round(100 * (max(cm2$yield) / min(cm2$yield) - 1), 2), "% )\n")

cat("\nVariance homogeneity (SD per cell) :\n")
print(round(tapply(crop$yield, list(crop$fertilizer, crop$density), sd), 3))
cat("Bartlett test p =", round(bartlett.test(yield ~ interaction(fertilizer, density), data = crop)$p.value, 3), "\n")

cat("\nEDA complete. Plots saved in", plot_dir, "\n")
