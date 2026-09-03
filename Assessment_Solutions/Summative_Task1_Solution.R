############################################################
#  SUMMATIVE ASSIGNMENT - TASK 1  (25 marks)
#  Data : Task1.csv  (32 cars, 11 numeric variables)
#
#  Part (a)  Histogram using a function with two parameters
#            with labels and colours                 [10 marks]
#  Part (b)  Linear regression : initial data analysis,
#            variable selection, best model          [15 marks]
#
#  BEFORE RUNNING : set data_path to the folder that holds
#  Task1.csv, or use  setwd()  in RStudio.
############################################################

data_path <- "../1. Formative and Summative Assessment/S-Assignment Task 1/Task1.csv"

# Where plots are saved (set to NULL to show on screen instead)
plot_dir <- "plots"
if (!is.null(plot_dir) && !dir.exists(plot_dir)) dir.create(plot_dir)


############################################################
#  STEP 1 : LOAD AND INSPECT THE DATA
############################################################

cars <- read.csv(data_path)

cat("=============================================\n")
cat(" STEP 1 : LOAD AND INSPECT\n")
cat("=============================================\n")

dim(cars)              # 32 rows, 12 columns
str(cars)              # data types
head(cars)             # first 6 rows

# Variable meanings (this is the classic mtcars data set)
#   mpg  : miles per gallon   (fuel economy)   <- our OUTCOME
#   cyl  : number of cylinders
#   disp : engine displacement (cubic inches)
#   hp   : horsepower
#   drat : rear axle ratio
#   wt   : weight (1000 lbs)
#   qsec : quarter-mile time (seconds)
#   vs   : engine shape   (0 = V-shaped, 1 = straight)
#   am   : transmission   (0 = automatic, 1 = manual)
#   gear : number of forward gears
#   carb : number of carburettors

# Check for missing values
cat("\nMissing values per column :\n")
print(colSums(is.na(cars)))


############################################################
#  PART (a) : HISTOGRAM USING A FUNCTION       [10 marks]
############################################################
#
#  The task asks for a FUNCTION that takes values and plots a
#  histogram with TWO parameters.  Our function takes :
#     values  : the numeric vector to plot
#     n_bins  : how many bars (breaks) to use
#  Two optional extras add a label and a colour.

cat("\n=============================================\n")
cat(" PART (a) : HISTOGRAM FUNCTION\n")
cat("=============================================\n")

draw_histogram <- function(values, n_bins,
                           label  = "Value",
                           colour = "steelblue") {

  hist(values,
       breaks = n_bins,                     # number of bars
       col    = colour,                     # bar colour
       border = "white",
       main   = paste("Histogram of", label),
       xlab   = label,
       ylab   = "Number of cars",
       labels = TRUE)                       # count on top of each bar

  # add a dashed line at the mean
  abline(v = mean(values), col = "red", lwd = 2, lty = 2)
  legend("topright", legend = paste("Mean =", round(mean(values), 2)),
         col = "red", lty = 2, lwd = 2, bty = "n")
}

# --- Call the function with different values and parameters ---
if (!is.null(plot_dir)) png(file.path(plot_dir, "task1_hist_mpg.png"), 700, 500)
draw_histogram(cars$mpg, n_bins = 8, label = "Miles per gallon (mpg)",
               colour = "steelblue")
if (!is.null(plot_dir)) invisible(dev.off())

if (!is.null(plot_dir)) png(file.path(plot_dir, "task1_hist_hp.png"), 700, 500)
draw_histogram(cars$hp, n_bins = 10, label = "Horsepower (hp)",
               colour = "darkorange")
if (!is.null(plot_dir)) invisible(dev.off())

if (!is.null(plot_dir)) png(file.path(plot_dir, "task1_hist_wt.png"), 700, 500)
draw_histogram(cars$wt, n_bins = 6, label = "Weight (1000 lbs)",
               colour = "seagreen")
if (!is.null(plot_dir)) invisible(dev.off())

# Quick numeric description to go with the histograms
cat("\nSummary of mpg :\n"); print(summary(cars$mpg))
cat("Summary of hp  :\n"); print(summary(cars$hp))
cat("Summary of wt  :\n"); print(summary(cars$wt))

cat("\nHistograms saved. mpg is slightly right-skewed (a few very\n")
cat("economical cars), hp is strongly right-skewed (a few very\n")
cat("powerful cars), wt is roughly symmetric.\n")


############################################################
#  PART (b) : LINEAR REGRESSION               [15 marks]
############################################################

############################################################
#  STEP 2 : INITIAL DATA ANALYSIS - NUMERICAL
############################################################

cat("\n=============================================\n")
cat(" STEP 2 : NUMERICAL EXPLORATION\n")
cat("=============================================\n")

# Drop the car name column : it is text, not a predictor
num_cars <- cars[, -1]

# Five-number summary of every variable
print(summary(num_cars))

# Correlation of every variable with mpg, sorted
cor_with_mpg <- sort(cor(num_cars)[, "mpg"], decreasing = TRUE)
cat("\nCorrelation with mpg :\n")
print(round(cor_with_mpg, 3))

# Full correlation matrix (rounded)
cat("\nCorrelation matrix :\n")
print(round(cor(num_cars), 2))

cat("\nReading : wt, cyl, disp and hp have strong NEGATIVE\n")
cat("correlation with mpg. Heavier, bigger, more powerful cars\n")
cat("use more fuel. drat, vs and am are positively related.\n")
cat("Note that wt, disp, cyl and hp are also strongly related to\n")
cat("EACH OTHER (multicollinearity) - we should not use them all.\n")


############################################################
#  STEP 3 : INITIAL DATA ANALYSIS - GRAPHICAL
############################################################

cat("\n=============================================\n")
cat(" STEP 3 : GRAPHICAL EXPLORATION\n")
cat("=============================================\n")

# Scatter plot matrix of the most relevant variables
if (!is.null(plot_dir)) png(file.path(plot_dir, "task1_pairs.png"), 900, 900)
pairs(num_cars[, c("mpg", "wt", "hp", "disp", "qsec")],
      pch = 16, col = "steelblue",
      main = "Scatter plot matrix")
if (!is.null(plot_dir)) invisible(dev.off())

# Box plots of mpg against the categorical-like variables
if (!is.null(plot_dir)) png(file.path(plot_dir, "task1_boxplots.png"), 900, 350)
par(mfrow = c(1, 3))
boxplot(mpg ~ cyl, data = cars, col = "lightblue",
        main = "mpg by cylinders", xlab = "cyl")
boxplot(mpg ~ am,  data = cars, col = "lightgreen",
        main = "mpg by transmission", xlab = "am (0 = auto, 1 = manual)")
boxplot(mpg ~ gear, data = cars, col = "lightyellow",
        main = "mpg by gears", xlab = "gear")
par(mfrow = c(1, 1))
if (!is.null(plot_dir)) invisible(dev.off())

# Scatter of mpg vs wt with a fitted line
if (!is.null(plot_dir)) png(file.path(plot_dir, "task1_mpg_vs_wt.png"), 700, 500)
plot(cars$wt, cars$mpg, pch = 16, col = "steelblue",
     xlab = "Weight (1000 lbs)", ylab = "mpg",
     main = "mpg vs weight")
abline(lm(mpg ~ wt, data = cars), col = "red", lwd = 2)
if (!is.null(plot_dir)) invisible(dev.off())

cat("Plots saved : pairs, box plots, mpg vs wt.\n")


############################################################
#  STEP 4 : SIMPLE LINEAR REGRESSION  (starting point)
############################################################

cat("\n=============================================\n")
cat(" STEP 4 : SIMPLE MODEL  mpg ~ wt\n")
cat("=============================================\n")

model_simple <- lm(mpg ~ wt, data = cars)
print(summary(model_simple))

cat("Reading : every extra 1000 lbs lowers mpg by about",
    round(abs(coef(model_simple)[2]), 2), "\n")
cat("R-squared =", round(summary(model_simple)$r.squared, 3),
    ": weight alone explains about",
    round(100 * summary(model_simple)$r.squared), "% of mpg.\n")


############################################################
#  STEP 5 : FULL MODEL WITH ALL PREDICTORS
############################################################

cat("\n=============================================\n")
cat(" STEP 5 : FULL MODEL  mpg ~ everything\n")
cat("=============================================\n")

model_full <- lm(mpg ~ ., data = num_cars)   # "." = all other columns
print(summary(model_full))

cat("Reading : R-squared is high but NO single predictor is\n")
cat("significant at 5%. That is the classic sign of\n")
cat("multicollinearity - the predictors overlap so much that\n")
cat("the model cannot tell which one deserves the credit.\n")
cat("We need variable selection.\n")


############################################################
#  STEP 6 : VARIABLE SELECTION  (backward stepwise by AIC)
############################################################
#
#  step() starts from the full model and removes one variable
#  at a time as long as AIC (a penalised fit measure) improves.
#  Lower AIC = better.

cat("\n=============================================\n")
cat(" STEP 6 : STEPWISE VARIABLE SELECTION\n")
cat("=============================================\n")

model_step <- step(model_full, direction = "backward", trace = 1)

cat("\nSelected model :\n")
print(formula(model_step))
print(summary(model_step))


############################################################
#  STEP 7 : COMPARE CANDIDATE MODELS
############################################################

cat("\n=============================================\n")
cat(" STEP 7 : MODEL COMPARISON\n")
cat("=============================================\n")

# A few sensible alternatives chosen from the exploration
model_wt_hp <- lm(mpg ~ wt + hp,        data = cars)
model_wt_am <- lm(mpg ~ wt + am,        data = cars)

candidates <- list("mpg ~ wt"                = model_simple,
                   "mpg ~ wt + hp"           = model_wt_hp,
                   "mpg ~ wt + am"           = model_wt_am,
                   "stepwise: mpg ~ wt + qsec + am" = model_step,
                   "full model"              = model_full)

comparison <- data.frame(
  Model  = names(candidates),
  Adj_R2 = sapply(candidates, function(m) round(summary(m)$adj.r.squared, 3)),
  AIC    = sapply(candidates, function(m) round(AIC(m), 1)),
  row.names = NULL
)
print(comparison)

cat("\nThe stepwise model has the highest adjusted R-squared AND\n")
cat("the lowest AIC, so it is the best model.\n")

# Formal check : does the full model add anything over stepwise ?
# H0 : the dropped variables contribute nothing.
print(anova(model_step, model_full))
cat("Large p-value -> the dropped variables were not needed.\n")


############################################################
#  STEP 8 : INTERPRET THE BEST MODEL
############################################################

cat("\n=============================================\n")
cat(" STEP 8 : INTERPRETATION OF  mpg ~ wt + qsec + am\n")
cat("=============================================\n")

best <- model_step
print(round(coef(best), 3))
print(round(confint(best), 3))

cat("\n  wt   : each extra 1000 lbs  ->  about",
    round(coef(best)["wt"], 2), "mpg (holding qsec, am fixed)\n")
cat("  qsec : each extra second of quarter-mile time  ->  about +",
    round(coef(best)["qsec"], 2), "mpg (slower cars = less powerful = more economical)\n")
cat("  am   : a manual car gets about +",
    round(coef(best)["am"], 2), "mpg more than an automatic of the same wt and qsec\n")
cat("  Adjusted R-squared =", round(summary(best)$adj.r.squared, 3),
    "-> the model explains about",
    round(100 * summary(best)$adj.r.squared), "% of the variation in mpg.\n")


############################################################
#  STEP 9 : CHECK THE MODEL ASSUMPTIONS
############################################################

cat("\n=============================================\n")
cat(" STEP 9 : DIAGNOSTICS\n")
cat("=============================================\n")

if (!is.null(plot_dir)) png(file.path(plot_dir, "task1_diagnostics.png"), 900, 900)
par(mfrow = c(2, 2))
plot(best)
par(mfrow = c(1, 1))
if (!is.null(plot_dir)) invisible(dev.off())

# Normality of residuals : want p > 0.05
print(shapiro.test(residuals(best)))

# Multicollinearity among the chosen predictors : want low values
cat("Correlation among chosen predictors :\n")
print(round(cor(cars[, c("wt", "qsec", "am")]), 2))

cat("\nResiduals are approximately normal, no strong pattern in the\n")
cat("residual plot, and the chosen predictors are not highly\n")
cat("correlated with each other. The model is valid.\n")


############################################################
#  STEP 10 : USE THE MODEL TO PREDICT
############################################################

cat("\n=============================================\n")
cat(" STEP 10 : PREDICTION\n")
cat("=============================================\n")

new_cars <- data.frame(wt = c(2.5, 3.5), qsec = c(18, 16), am = c(1, 0))
print(cbind(new_cars,
            predicted_mpg = round(predict(best, newdata = new_cars), 2)))

cat("\nDone.\n")
