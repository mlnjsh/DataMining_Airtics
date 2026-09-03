############################################################
#  FILE 4 : TWO WAY ANOVA
#
#  Question answered :
#     "How do TWO categorical factors affect a numeric
#      outcome, and do they INTERACT ?"
#
#  Three hypotheses are tested at once :
#     H0 (factor A)      : no effect of factor A
#     H0 (factor B)      : no effect of factor B
#     H0 (interaction)   : the effect of A does not depend
#                          on the level of B
#
#  Topics
#    1. The data  (built-in ToothGrowth data set)
#    2. Look at the data first
#    3. Two way ANOVA WITHOUT interaction
#    4. Two way ANOVA WITH interaction
#    5. Interaction plot
#    6. Post-hoc comparisons
#    7. Assumption checks
############################################################


############################################################
#  1. THE DATA
############################################################
#
#  ToothGrowth : 60 guinea pigs received vitamin C and the
#  length of their tooth cells was measured.
#
#     len  : tooth length            (numeric outcome)
#     supp : supplement type         factor A
#              OJ = orange juice,  VC = ascorbic acid
#     dose : daily dose in mg        factor B
#              0.5, 1.0, 2.0
#
#  dose is stored as a number. For ANOVA it must be a FACTOR,
#  otherwise R would treat it as a regression variable.

data("ToothGrowth")
teeth <- ToothGrowth
teeth$dose <- factor(teeth$dose)      # convert to categorical

cat("=============================================\n")
cat(" 1. THE DATA\n")
cat("=============================================\n")
str(teeth)

# How many observations in each combination ?
# A "balanced" design (equal counts) makes ANOVA simplest.
table(teeth$supp, teeth$dose)


############################################################
#  2. LOOK AT THE DATA FIRST
############################################################

cat("\n=============================================\n")
cat(" 2. DESCRIPTIVE STATISTICS\n")
cat("=============================================\n")

# Mean tooth length for every supp x dose combination
cell_means <- aggregate(len ~ supp + dose, data = teeth, FUN = mean)
print(cell_means)

# Side-by-side box plots
boxplot(len ~ supp * dose, data = teeth,
        col  = c("orange", "lightblue"),
        main = "Tooth length by supplement and dose",
        xlab = "Supplement . Dose", ylab = "Tooth length")


############################################################
#  3. TWO WAY ANOVA WITHOUT INTERACTION  (additive model)
############################################################
#
#  Formula :   len ~ supp + dose
#  The "+" means : each factor has its own separate effect.

cat("\n=============================================\n")
cat(" 3. ADDITIVE MODEL  (len ~ supp + dose)\n")
cat("=============================================\n")

model_add <- aov(len ~ supp + dose, data = teeth)
summary(model_add)

#  Read the table exactly like in one way ANOVA, but now
#  there is one row per factor.  A small Pr(>F) for a row
#  means that factor matters.


############################################################
#  4. TWO WAY ANOVA WITH INTERACTION
############################################################
#
#  Formula :   len ~ supp * dose
#  The "*" is shorthand for   supp + dose + supp:dose
#  The term  supp:dose  is the INTERACTION.
#
#  Interaction means : the effect of the supplement is
#  different at different doses.

cat("\n=============================================\n")
cat(" 4. INTERACTION MODEL  (len ~ supp * dose)\n")
cat("=============================================\n")

model_int <- aov(len ~ supp * dose, data = teeth)
anova_int <- summary(model_int)
print(anova_int)

# Pull out the three p-values and state the conclusions
p_vals <- anova_int[[1]][["Pr(>F)"]][1:3]
names(p_vals) <- c("supp", "dose", "supp:dose")

cat("\n  Conclusions at alpha = 0.05 :\n")
for (term in names(p_vals)) {
  verdict <- if (p_vals[term] < 0.05) "significant" else "NOT significant"
  cat("   ", format(term, width = 10), " p =",
      format(round(p_vals[term], 4), nsmall = 4), " ->", verdict, "\n")
}

#  Rule of thumb :
#    If the interaction IS significant, interpret the
#    interaction (look at the plot in section 5) rather than
#    the main effects alone.
#    If the interaction is NOT significant, the simpler
#    additive model from section 3 is fine.


############################################################
#  5. INTERACTION PLOT
############################################################
#
#  One line per supplement, dose on the x axis.
#    Parallel lines    ->  no interaction
#    Crossing / non-parallel lines  ->  interaction

cat("\n=============================================\n")
cat(" 5. INTERACTION PLOT\n")
cat("=============================================\n")

interaction.plot(x.factor     = teeth$dose,
                 trace.factor = teeth$supp,
                 response     = teeth$len,
                 fun   = mean,
                 type  = "b",           # both points and lines
                 col   = c("orange", "blue"),
                 pch   = c(16, 17),
                 xlab  = "Dose (mg)",
                 ylab  = "Mean tooth length",
                 trace.label = "Supplement",
                 main  = "Interaction plot : supp x dose")

cat("  Plot drawn. Lines converge at dose 2.0 : the advantage\n")
cat("  of orange juice disappears at the highest dose.\n")


############################################################
#  6. POST-HOC COMPARISONS
############################################################
#
#  Tukey HSD works for two way ANOVA too.  It gives pairwise
#  comparisons for each factor and for the interaction cells.

cat("\n=============================================\n")
cat(" 6. TUKEY POST-HOC TEST\n")
cat("=============================================\n")

tukey <- TukeyHSD(model_int)

# Only the dose comparisons (3 pairs) - easy to read
print(tukey$dose)

# The interaction cells give 15 pairwise comparisons.
# Uncomment to see all of them :
# print(tukey$`supp:dose`)


############################################################
#  7. ASSUMPTION CHECKS
############################################################
#
#  Same assumptions as one way ANOVA :
#    normal residuals, equal variances, independence.

cat("\n=============================================\n")
cat(" 7. ASSUMPTION CHECKS\n")
cat("=============================================\n")

# Normality of residuals  (want p > 0.05)
shapiro.test(residuals(model_int))

# Equal variances across all 6 cells  (want p > 0.05)
# interaction() builds one factor with 6 levels : OJ.0.5, VC.0.5 ...
bartlett.test(len ~ interaction(supp, dose), data = teeth)

# Standard diagnostic plots : residuals vs fitted and Q-Q plot
par(mfrow = c(1, 2))
plot(model_int, which = 1)     # residuals vs fitted : want no pattern
plot(model_int, which = 2)     # Q-Q plot : want points on the line
par(mfrow = c(1, 1))


############################################################
#  8. SUMMARY
############################################################
#
#  Model                 R code
#  --------------------  ----------------------------------------
#  Additive              aov(y ~ A + B, data = d)
#  With interaction      aov(y ~ A * B, data = d)
#  Interaction plot      interaction.plot(B, A, y)
#  Pairwise comparisons  TukeyHSD(model)
#
#  Continue with FILE 5 for Linear Regression.
############################################################
