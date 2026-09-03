############################################################
#  FILE 2 : HYPOTHESIS TESTING - TWO SAMPLE TESTS
#
#  Topics covered in this file
#    1. F test         : are two variances equal ?
#    2. Difference between two MEANS
#         2a. Two sample Z test  (large samples / sigma known)
#         2b. Independent t test (equal variances)
#         2c. Welch t test       (unequal variances)
#         2d. Paired t test      (before / after data)
#    3. Difference between two PROPORTIONS
#
#  One sample tests are in FILE 1.
############################################################

# Same helper used in FILE 1
decide <- function(p_value, alpha = 0.05) {
  if (p_value < alpha) {
    cat("  p-value =", round(p_value, 4), "<", alpha,
        " ->  REJECT H0\n\n")
  } else {
    cat("  p-value =", round(p_value, 4), ">=", alpha,
        " ->  DO NOT reject H0\n\n")
  }
}


############################################################
#  THE DATA USED IN SECTIONS 1 AND 2
############################################################
#
#  Two teaching methods. Exam scores (out of 100) for two
#  independent groups of students.

method_A <- c(78, 85, 69, 91, 74, 88, 82, 77, 80, 86, 73, 79)
method_B <- c(72, 68, 75, 80, 66, 71, 78, 70, 74, 69, 77, 73)

cat("  Mean A =", mean(method_A), "  SD A =", round(sd(method_A), 2), "\n")
cat("  Mean B =", mean(method_B), "  SD B =", round(sd(method_B), 2), "\n\n")


############################################################
#  1. F TEST : ARE THE TWO VARIANCES EQUAL ?
############################################################
#
#  Why first ?  The choice between the "equal variance" t test
#  and the Welch t test depends on whether the two groups have
#  similar spread. The F test checks exactly that.
#
#  H0 : var_A  = var_B
#  H1 : var_A != var_B
#
#  Statistic :  F = s_A^2 / s_B^2
#  Degrees of freedom : (n_A - 1, n_B - 1)

cat("=============================================\n")
cat(" 1. F TEST FOR EQUALITY OF VARIANCES\n")
cat("=============================================\n")

# --- (a) by hand -------------------------------------------
F_stat <- var(method_A) / var(method_B)
df1 <- length(method_A) - 1
df2 <- length(method_B) - 1

# Two-sided p-value : take the smaller tail and double it
p_val_F <- 2 * min(pf(F_stat, df1, df2),
                   1 - pf(F_stat, df1, df2))

cat("  F statistic =", round(F_stat, 3),
    " (df =", df1, ",", df2, ")\n")
decide(p_val_F)

# --- (b) built-in : var.test() ------------------------------
var.test(method_A, method_B)

# Conclusion : if H0 is NOT rejected, variances are similar
#              -> we may use the equal-variance t test (2b).


############################################################
#  2a. TWO SAMPLE Z TEST FOR DIFFERENCE OF MEANS
############################################################
#
#  Use when : both population SDs are known, or both samples
#             are large (n > 30). Rare in practice, but part
#             of the syllabus so we show it by hand.
#
#  Example  : Factory 1 (sigma = 4) : n = 50, mean = 102
#             Factory 2 (sigma = 5) : n = 60, mean = 100
#
#  H0 : mu1 - mu2  = 0
#  H1 : mu1 - mu2 != 0
#
#  Z = (x1 - x2) / sqrt( sigma1^2/n1 + sigma2^2/n2 )

cat("=============================================\n")
cat(" 2a. TWO SAMPLE Z TEST (means, sigma known)\n")
cat("=============================================\n")

x1 <- 102; sigma1 <- 4; n1 <- 50
x2 <- 100; sigma2 <- 5; n2 <- 60

z_two <- (x1 - x2) / sqrt(sigma1^2 / n1 + sigma2^2 / n2)
p_val_z_two <- 2 * pnorm(-abs(z_two))

cat("  Z statistic =", round(z_two, 3), "\n")
decide(p_val_z_two)


############################################################
#  2b. INDEPENDENT t TEST  (equal variances assumed)
############################################################
#
#  Use when : two independent groups, sigma unknown,
#             and the F test said variances are similar.
#
#  H0 : mu_A  = mu_B
#  H1 : mu_A != mu_B

cat("=============================================\n")
cat(" 2b. INDEPENDENT t TEST (equal variances)\n")
cat("=============================================\n")

# var.equal = TRUE  ->  classic "pooled" t test
result_pooled <- t.test(method_A, method_B, var.equal = TRUE)
print(result_pooled)
decide(result_pooled$p.value)


############################################################
#  2c. WELCH t TEST  (unequal variances)
############################################################
#
#  This is the DEFAULT in R when you call t.test() on two
#  samples. It is safer when you are not sure the variances
#  are equal.

cat("=============================================\n")
cat(" 2c. WELCH t TEST (unequal variances)\n")
cat("=============================================\n")

result_welch <- t.test(method_A, method_B)   # var.equal = FALSE by default
print(result_welch)

# Notice the degrees of freedom are no longer a whole number.
cat("  Welch df =", round(result_welch$parameter, 2), "\n\n")

# One-sided example : "Method A gives HIGHER scores than B"
t.test(method_A, method_B, alternative = "greater")


############################################################
#  2d. PAIRED t TEST  (before / after on the SAME people)
############################################################
#
#  Use when : each observation in group 1 is naturally linked
#             to one observation in group 2 (same person,
#             same machine, same plot of land ...).
#
#  Example  : Blood pressure of 10 patients BEFORE and AFTER
#             taking a new drug.
#
#  H0 : mean difference  = 0   (drug does nothing)
#  H1 : mean difference != 0

cat("=============================================\n")
cat(" 2d. PAIRED t TEST\n")
cat("=============================================\n")

before <- c(150, 142, 160, 155, 148, 162, 158, 145, 152, 149)
after  <- c(142, 138, 152, 150, 145, 155, 150, 140, 148, 146)

# A paired test is really a ONE sample t test on the differences
differences <- before - after
cat("  Differences :", differences, "\n")
cat("  Mean difference =", mean(differences), "\n\n")

result_paired <- t.test(before, after, paired = TRUE)
print(result_paired)
decide(result_paired$p.value)

# Same thing, written as a one sample test on the differences:
# t.test(differences, mu = 0)


############################################################
#  3. DIFFERENCE BETWEEN TWO PROPORTIONS
############################################################
#
#  Example  : Two advertisements.
#             Ad 1 : 500 people saw it, 60 clicked.
#             Ad 2 : 450 people saw it, 36 clicked.
#             Is the click rate different ?
#
#  H0 : p1  = p2
#  H1 : p1 != p2
#
#  By hand, we use the POOLED proportion  p_pool
#  because H0 says both groups share the same p.
#
#  Z = (p1_hat - p2_hat) /
#      sqrt( p_pool (1 - p_pool) (1/n1 + 1/n2) )

cat("=============================================\n")
cat(" 3. TWO SAMPLE TEST FOR PROPORTIONS\n")
cat("=============================================\n")

clicks <- c(60, 36)
shown  <- c(500, 450)

# --- (a) by hand -------------------------------------------
p1_hat <- clicks[1] / shown[1]
p2_hat <- clicks[2] / shown[2]
p_pool <- sum(clicks) / sum(shown)

z_prop2 <- (p1_hat - p2_hat) /
  sqrt(p_pool * (1 - p_pool) * (1 / shown[1] + 1 / shown[2]))
p_val_prop2 <- 2 * pnorm(-abs(z_prop2))

cat("  p1_hat =", round(p1_hat, 3),
    "  p2_hat =", round(p2_hat, 3),
    "  pooled p =", round(p_pool, 3), "\n")
cat("  Z statistic =", round(z_prop2, 3), "\n")
decide(p_val_prop2)

# --- (b) built-in : prop.test() with two groups --------------
# Pass a vector of successes and a vector of trials.
prop.test(x = clicks, n = shown, correct = FALSE)


############################################################
#  4. SUMMARY TABLE
############################################################
#
#  Question                        | R function
#  --------------------------------|-------------------------------
#  Are two variances equal ?       | var.test(x, y)
#  Two means, sigma known          | by hand (pnorm)
#  Two means, equal variances      | t.test(x, y, var.equal = TRUE)
#  Two means, unequal variances    | t.test(x, y)          (Welch)
#  Before / after on same subjects | t.test(x, y, paired = TRUE)
#  Two proportions                 | prop.test(c(x1,x2), c(n1,n2))
#
#  Continue with FILE 3 for One Way ANOVA
#  (comparing MORE than two means).
############################################################
