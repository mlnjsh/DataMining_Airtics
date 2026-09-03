############################################################
#  FILE 3 : ONE WAY ANOVA  (Analysis of Variance)
#
#  Question answered :
#     "Do THREE or more groups have the same mean ?"
#
#  Why not just run many t tests ?
#     With 3 groups you would need 3 t tests, with 5 groups
#     10 tests. Every extra test raises the chance of a
#     false positive. ANOVA tests all groups at once.
#
#  Topics
#    1. The data  (built-in PlantGrowth data set)
#    2. Look at the data first
#    3. Run the ANOVA
#    4. Understand the ANOVA table
#    5. Which groups differ ?  (Tukey post-hoc test)
#    6. Check the assumptions
############################################################


############################################################
#  1. THE DATA
############################################################
#
#  PlantGrowth ships with R. 30 plants were grown under
#  three conditions and their dry weight was measured.
#
#     weight : dry weight of the plant  (numeric)
#     group  : ctrl  = control
#              trt1  = treatment 1
#              trt2  = treatment 2
#
#  H0 : mean_ctrl = mean_trt1 = mean_trt2
#  H1 : at least ONE group mean is different

data("PlantGrowth")
plants <- PlantGrowth

cat("=============================================\n")
cat(" 1. THE DATA\n")
cat("=============================================\n")
str(plants)
head(plants)


############################################################
#  2. LOOK AT THE DATA FIRST
############################################################
#
#  Always look before you test. A box plot and the group
#  means already tell most of the story.

cat("\n=============================================\n")
cat(" 2. DESCRIPTIVE STATISTICS\n")
cat("=============================================\n")

# Mean, SD and count for each group
group_summary <- aggregate(weight ~ group, data = plants,
                           FUN = function(x) c(mean = mean(x),
                                               sd   = sd(x),
                                               n    = length(x)))
print(group_summary)

# Box plot : one box per group
boxplot(weight ~ group, data = plants,
        col  = c("lightgray", "lightblue", "lightgreen"),
        main = "Plant weight by treatment group",
        xlab = "Group", ylab = "Dry weight")


############################################################
#  3. RUN THE ANOVA
############################################################
#
#  aov() fits the model.  The formula reads
#       weight  ~  group
#  "explain weight by group".

cat("\n=============================================\n")
cat(" 3. ONE WAY ANOVA\n")
cat("=============================================\n")

model_anova <- aov(weight ~ group, data = plants)

# summary() prints the ANOVA table
anova_table <- summary(model_anova)
print(anova_table)


############################################################
#  4. HOW TO READ THE ANOVA TABLE
############################################################
#
#  Column     Meaning
#  --------   ------------------------------------------------
#  Df         degrees of freedom
#               group     : k - 1  (k = number of groups)
#               Residuals : N - k  (N = total observations)
#  Sum Sq     sum of squares
#               group     : variation BETWEEN group means
#               Residuals : variation WITHIN groups (noise)
#  Mean Sq    Sum Sq / Df
#  F value    Mean Sq(group) / Mean Sq(Residuals)
#               large F  ->  between-group differences are big
#                            compared to the noise
#  Pr(>F)     the p-value
#
#  Let us pull the p-value out and decide.

p_value <- anova_table[[1]][["Pr(>F)"]][1]
cat("\n  F statistic =", round(anova_table[[1]][["F value"]][1], 3), "\n")
cat("  p-value     =", round(p_value, 4), "\n")

if (p_value < 0.05) {
  cat("  -> REJECT H0 : at least one group mean is different.\n")
} else {
  cat("  -> Do NOT reject H0 : no evidence of a difference.\n")
}


############################################################
#  5. WHICH GROUPS DIFFER ?  (post-hoc test)
############################################################
#
#  ANOVA only says "SOMETHING is different". It does not say
#  WHICH pairs differ. For that we use a post-hoc test.
#
#  Tukey HSD (Honest Significant Difference) compares every
#  pair of groups and adjusts the p-values so that the overall
#  false-positive rate stays at 5 %.

cat("\n=============================================\n")
cat(" 5. TUKEY POST-HOC TEST\n")
cat("=============================================\n")

tukey <- TukeyHSD(model_anova)
print(tukey)

#  How to read it :
#    diff   : difference between the two group means
#    lwr/upr: 95 % confidence interval for that difference
#    p adj  : adjusted p-value.  < 0.05  ->  the pair differs
#
#  If the confidence interval contains 0, the pair is NOT
#  significantly different.

# Visual version : intervals that do not cross the dashed
# zero line are significant.
plot(tukey, las = 1)


############################################################
#  6. CHECK THE ASSUMPTIONS
############################################################
#
#  ANOVA assumes :
#    (a) the residuals are roughly normal
#    (b) each group has roughly the same variance
#    (c) observations are independent (design issue, not
#        something we can test here)

cat("\n=============================================\n")
cat(" 6. ASSUMPTION CHECKS\n")
cat("=============================================\n")

# --- (a) Normality of residuals ----------------------------
#  Shapiro-Wilk test.  H0 : residuals are normal.
#  A p-value ABOVE 0.05 is what we want here.
shapiro_result <- shapiro.test(residuals(model_anova))
print(shapiro_result)

# Q-Q plot : points should lie close to the straight line
qqnorm(residuals(model_anova), main = "Q-Q plot of residuals")
qqline(residuals(model_anova), col = "red")

# --- (b) Equal variances -----------------------------------
#  Bartlett test.  H0 : all group variances are equal.
#  Again a p-value ABOVE 0.05 is good news.
bartlett_result <- bartlett.test(weight ~ group, data = plants)
print(bartlett_result)

# If variances are NOT equal, use Welch ANOVA instead :
oneway.test(weight ~ group, data = plants, var.equal = FALSE)

# If residuals are NOT normal, use the Kruskal-Wallis test,
# a non-parametric alternative to one way ANOVA :
kruskal.test(weight ~ group, data = plants)


############################################################
#  7. SUMMARY
############################################################
#
#  Step                       R code
#  -------------------------  ----------------------------------
#  Fit the model              m <- aov(y ~ group, data = d)
#  ANOVA table                summary(m)
#  Which pairs differ         TukeyHSD(m)
#  Normality of residuals     shapiro.test(residuals(m))
#  Equal variances            bartlett.test(y ~ group, data = d)
#  Unequal variances          oneway.test(..., var.equal = FALSE)
#  Non-parametric             kruskal.test(y ~ group, data = d)
#
#  Continue with FILE 4 for Two Way ANOVA (two factors).
############################################################
