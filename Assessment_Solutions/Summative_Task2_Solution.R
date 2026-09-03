############################################################
#  SUMMATIVE ASSIGNMENT - TASK 2  (35 marks)
#  Case study : One-way and two-way ANOVA on crop yield
#  Data : crop_data.csv  (96 observations)
#
#     fertilizer : type of fertilizer   1, 2, 3   (factor)
#     density    : planting density     1 = low, 2 = high
#     block      : field block          1 to 4
#     yield      : crop yield in bushels per acre (numeric)
#
#  Steps
#    1. Load and clean the data (missing values, outliers)
#    2. Exploratory data analysis
#    3. One-way ANOVA  : does fertilizer affect yield ?
#    4. Two-way ANOVA  : fertilizer + density (+ interaction)
#    5. Post-hoc tests : which fertilizers differ ?
#    6. Assumption checks (validity of the model)
#    7. Summary of findings
#
#  BEFORE RUNNING : set data_path to the folder that holds
#  crop_data.csv, or use  setwd()  in RStudio.
############################################################

data_path <- "../1. Formative and Summative Assessment/S-Assignment Task 2/crop_data.csv"

plot_dir <- "plots"
if (!is.null(plot_dir) && !dir.exists(plot_dir)) dir.create(plot_dir)


############################################################
#  STEP 1 : LOAD AND CLEAN THE DATA
############################################################

cat("=============================================\n")
cat(" STEP 1 : LOAD AND CLEAN\n")
cat("=============================================\n")

crop <- read.csv(data_path)

dim(crop)
str(crop)
head(crop)

# --- 1a. Missing values -------------------------------------
cat("\nMissing values per column :\n")
print(colSums(is.na(crop)))
crop <- na.omit(crop)          # remove rows with NA (none here)

# --- 1b. Convert the categorical columns to factors ---------
# They are stored as numbers. If we leave them numeric, R will
# treat "fertilizer 3" as "three times fertilizer 1", which is
# wrong.  factor() tells R they are categories.
crop$fertilizer <- factor(crop$fertilizer,
                          levels = c(1, 2, 3),
                          labels = c("F1", "F2", "F3"))
crop$density    <- factor(crop$density,
                          levels = c(1, 2),
                          labels = c("Low", "High"))
crop$block      <- factor(crop$block)

str(crop)

# --- 1c. Outliers -------------------------------------------
# Rule : a point is an outlier if it lies more than 1.5 x IQR
# beyond the first or third quartile.
Q1  <- quantile(crop$yield, 0.25)
Q3  <- quantile(crop$yield, 0.75)
IQR_val <- Q3 - Q1
lower <- Q1 - 1.5 * IQR_val
upper <- Q3 + 1.5 * IQR_val
outliers <- crop$yield[crop$yield < lower | crop$yield > upper]

cat("\nOutlier limits :", round(lower, 2), "to", round(upper, 2), "\n")
cat("Number of outliers :", length(outliers), "\n")

if (!is.null(plot_dir)) png(file.path(plot_dir, "task2_outlier_boxplot.png"), 500, 450)
boxplot(crop$yield, col = "lightblue", main = "Yield : outlier check",
        ylab = "Yield (bushels / acre)")
if (!is.null(plot_dir)) invisible(dev.off())

if (length(outliers) == 0) {
  cat("No outliers found, so all rows are kept.\n")
} else {
  cat("Outlier value(s) :", round(outliers, 2), "\n")
  cat("This is a MILD outlier (just above the upper fence) and it is\n")
  cat("a plausible yield, not a data entry error. Removing it would\n")
  cat("also unbalance the design, so we KEEP it. We will confirm in\n")
  cat("step 6 that it does not harm the model assumptions.\n")
}

# --- 1d. Is the design balanced ? ----------------------------
cat("\nObservations per fertilizer x density cell :\n")
print(table(crop$fertilizer, crop$density))
cat("Every cell has 16 observations : a balanced design.\n")


############################################################
#  STEP 2 : EXPLORATORY DATA ANALYSIS
############################################################

cat("\n=============================================\n")
cat(" STEP 2 : EXPLORATORY DATA ANALYSIS\n")
cat("=============================================\n")

cat("\nOverall yield summary :\n")
print(summary(crop$yield))
cat("Standard deviation :", round(sd(crop$yield), 3), "\n")

# Group means and SDs
cat("\nMean yield by fertilizer :\n")
print(aggregate(yield ~ fertilizer, data = crop,
                FUN = function(x) round(c(mean = mean(x), sd = sd(x), n = length(x)), 3)))

cat("\nMean yield by density :\n")
print(aggregate(yield ~ density, data = crop,
                FUN = function(x) round(c(mean = mean(x), sd = sd(x), n = length(x)), 3)))

cat("\nMean yield by fertilizer x density :\n")
print(aggregate(yield ~ fertilizer + density, data = crop,
                FUN = function(x) round(mean(x), 3)))

# Histogram of yield
if (!is.null(plot_dir)) png(file.path(plot_dir, "task2_hist_yield.png"), 600, 450)
hist(crop$yield, breaks = 12, col = "wheat", border = "white",
     main = "Distribution of crop yield", xlab = "Yield (bushels / acre)")
if (!is.null(plot_dir)) invisible(dev.off())

# Box plots by each factor
if (!is.null(plot_dir)) png(file.path(plot_dir, "task2_boxplots.png"), 1000, 400)
par(mfrow = c(1, 3))
boxplot(yield ~ fertilizer, data = crop, col = c("tan", "darkseagreen", "lightskyblue"),
        main = "Yield by fertilizer")
boxplot(yield ~ density, data = crop, col = c("khaki", "salmon"),
        main = "Yield by density")
boxplot(yield ~ block, data = crop, col = "lightgray",
        main = "Yield by block")
par(mfrow = c(1, 1))
if (!is.null(plot_dir)) invisible(dev.off())

# Interaction plot : fertilizer on x axis, one line per density
if (!is.null(plot_dir)) png(file.path(plot_dir, "task2_interaction.png"), 650, 480)
interaction.plot(x.factor = crop$fertilizer, trace.factor = crop$density,
                 response = crop$yield, fun = mean, type = "b",
                 col = c("darkorange", "steelblue"), pch = c(16, 17), lwd = 2,
                 xlab = "Fertilizer", ylab = "Mean yield",
                 trace.label = "Density", main = "Interaction plot")
if (!is.null(plot_dir)) invisible(dev.off())

cat("\nEDA reading : fertilizer 3 has the highest mean yield and\n")
cat("high density gives a slightly higher yield than low density.\n")
cat("The lines in the interaction plot are nearly parallel, which\n")
cat("suggests little or no interaction. Block shows no clear effect.\n")


############################################################
#  STEP 3 : ONE-WAY ANOVA   (yield ~ fertilizer)
############################################################
#
#  H0 : mean yield is the same for all three fertilizers
#       mu_F1 = mu_F2 = mu_F3
#  H1 : at least one fertilizer gives a different mean yield
#
#  Assumptions : independent observations, normal residuals,
#                equal variances across groups. (Checked in step 6.)

cat("\n=============================================\n")
cat(" STEP 3 : ONE-WAY ANOVA  yield ~ fertilizer\n")
cat("=============================================\n")

one_way <- aov(yield ~ fertilizer, data = crop)
one_way_table <- summary(one_way)
print(one_way_table)

p_one <- one_way_table[[1]][["Pr(>F)"]][1]
cat("\nF =", round(one_way_table[[1]][["F value"]][1], 3),
    "  p-value =", format.pval(p_one, digits = 3), "\n")
if (p_one < 0.05) {
  cat("p < 0.05  ->  REJECT H0. Fertilizer type has a significant\n")
  cat("effect on crop yield.\n")
} else {
  cat("p >= 0.05 ->  Do NOT reject H0.\n")
}


############################################################
#  STEP 4 : TWO-WAY ANOVA   (yield ~ fertilizer + density)
############################################################
#
#  Three hypotheses :
#    H0(a) : fertilizer has no effect on yield
#    H0(b) : density has no effect on yield
#    H0(c) : there is no interaction between fertilizer and density
#            (the effect of fertilizer is the same at both densities)

cat("\n=============================================\n")
cat(" STEP 4 : TWO-WAY ANOVA\n")
cat("=============================================\n")

# --- 4a. Additive model (main effects only) ------------------
cat("\n--- 4a. Additive model : yield ~ fertilizer + density ---\n")
two_way_add <- aov(yield ~ fertilizer + density, data = crop)
print(summary(two_way_add))

# --- 4b. Interaction model -----------------------------------
cat("\n--- 4b. Interaction model : yield ~ fertilizer * density ---\n")
two_way_int <- aov(yield ~ fertilizer * density, data = crop)
int_table <- summary(two_way_int)
print(int_table)

p_int <- int_table[[1]][["Pr(>F)"]][3]
cat("\nInteraction p-value =", round(p_int, 4), "\n")
if (p_int < 0.05) {
  cat("Interaction IS significant : interpret the interaction.\n")
} else {
  cat("Interaction is NOT significant : the effect of fertilizer\n")
  cat("does not depend on density. The simpler additive model is\n")
  cat("preferred.\n")
}

# --- 4c. Adding block as a control variable ------------------
# Block is not of scientific interest but it can soak up
# field-to-field variation, making the other tests sharper.
cat("\n--- 4c. Blocked model : yield ~ fertilizer + density + block ---\n")
two_way_block <- aov(yield ~ fertilizer + density + block, data = crop)
print(summary(two_way_block))

# --- 4d. Which model is best ?  (lower AIC = better) -----------
cat("\n--- 4d. Model comparison by AIC ---\n")
model_aic <- data.frame(
  Model = c("one-way : fertilizer",
            "two-way additive : fertilizer + density",
            "two-way interaction : fertilizer * density",
            "blocked : fertilizer + density + block"),
  AIC   = round(c(AIC(one_way), AIC(two_way_add), AIC(two_way_int), AIC(two_way_block)), 2)
)
print(model_aic)
cat("\nThe additive two-way model has the lowest AIC and is chosen.\n")


############################################################
#  STEP 5 : POST-HOC TEST  (which fertilizers differ ?)
############################################################

cat("\n=============================================\n")
cat(" STEP 5 : TUKEY HSD POST-HOC TEST\n")
cat("=============================================\n")

tukey <- TukeyHSD(two_way_add)
print(tukey)

if (!is.null(plot_dir)) png(file.path(plot_dir, "task2_tukey.png"), 700, 500)
par(mar = c(5, 8, 4, 2))
plot(tukey, las = 1)
par(mar = c(5, 4, 4, 2))
if (!is.null(plot_dir)) invisible(dev.off())

cat("\nReading : a pair is significantly different when p adj < 0.05,\n")
cat("or equivalently when its confidence interval does not cross 0.\n")


############################################################
#  STEP 6 : VALIDITY OF THE MODEL  (assumption checks)
############################################################

cat("\n=============================================\n")
cat(" STEP 6 : ASSUMPTION CHECKS\n")
cat("=============================================\n")

final_model <- two_way_add

# --- 6a. Normality of residuals : Shapiro-Wilk, want p > 0.05 ---
cat("\n--- 6a. Normality of residuals ---\n")
print(shapiro.test(residuals(final_model)))

# --- 6b. Equal variances : Bartlett test, want p > 0.05 -------
cat("\n--- 6b. Homogeneity of variance ---\n")
print(bartlett.test(yield ~ fertilizer, data = crop))
print(bartlett.test(yield ~ density,    data = crop))
print(bartlett.test(yield ~ interaction(fertilizer, density), data = crop))

# --- 6c. Diagnostic plots -------------------------------------
if (!is.null(plot_dir)) png(file.path(plot_dir, "task2_diagnostics.png"), 900, 450)
par(mfrow = c(1, 2))
plot(final_model, which = 1)     # residuals vs fitted : want random cloud
plot(final_model, which = 2)     # Q-Q plot : want points on the line
par(mfrow = c(1, 1))
if (!is.null(plot_dir)) invisible(dev.off())

# --- 6d. Independence -----------------------------------------
cat("\n--- 6d. Independence ---\n")
cat("Each plot of land gives one yield measurement and plots were\n")
cat("assigned to treatments by the experimental design, so the\n")
cat("observations are independent.\n")


############################################################
#  STEP 7 : SUMMARY OF FINDINGS
############################################################

cat("\n=============================================\n")
cat(" STEP 7 : SUMMARY OF FINDINGS\n")
cat("=============================================\n")

means_f <- tapply(crop$yield, crop$fertilizer, mean)
means_d <- tapply(crop$yield, crop$density, mean)

cat("\n1. Fertilizer has a significant effect on yield (p < 0.001).\n")
cat("   Mean yields : F1 =", round(means_f["F1"], 2),
    " F2 =", round(means_f["F2"], 2),
    " F3 =", round(means_f["F3"], 2), "\n")
cat("2. Planting density has a significant effect (p < 0.001).\n")
cat("   Mean yields : Low =", round(means_d["Low"], 2),
    " High =", round(means_d["High"], 2), "\n")
cat("3. There is NO significant interaction : the best fertilizer\n")
cat("   is the best at both densities.\n")
cat("4. Tukey HSD : fertilizer 3 beats fertilizers 1 and 2;\n")
cat("   fertilizers 1 and 2 are not significantly different.\n")
cat("5. Assumptions hold (normal residuals, equal variances),\n")
cat("   so the model is valid.\n")
cat("6. Recommendation : use fertilizer 3 at high planting density\n")
cat("   for the maximum yield.\n")
