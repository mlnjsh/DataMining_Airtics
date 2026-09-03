############################################################
#  FILE 1 : HYPOTHESIS TESTING - ONE SAMPLE TESTS
#
#  Topics covered in this file
#    1. What is a hypothesis test?  (short recap)
#    2. One sample Z test   (mean, population SD known)
#    3. One sample t test   (mean, population SD unknown)
#    4. One sample test for a proportion
#
#  Two sample tests (F test, difference of means,
#  difference of proportions) are in FILE 2.
#
#  How to run : open in RStudio and run line by line,
#               or  Rscript 01_Hypothesis_Testing_One_Sample.R
############################################################


############################################################
#  1. QUICK RECAP : HOW A HYPOTHESIS TEST WORKS
############################################################
#
#  Step 1  Write the null hypothesis  H0  (the "no change" claim)
#          and the alternative hypothesis H1 (what we suspect).
#
#  Step 2  Choose the significance level  alpha  (usually 0.05).
#
#  Step 3  Calculate a test statistic from the sample
#          (Z, t, F, chi-square ...).
#
#  Step 4  Find the p-value : the probability of getting a
#          result at least this extreme IF H0 were true.
#
#  Step 5  Decide :
#            p-value <  alpha  ->  Reject H0
#            p-value >= alpha  ->  Do NOT reject H0
#
#  A small helper so we do not repeat the decision rule
#  in every section.

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
#  2. ONE SAMPLE Z TEST FOR A MEAN
############################################################
#
#  Use when : the population standard deviation (sigma) is
#             KNOWN, or the sample is large (n > 30).
#
#  Example  : A cereal box should contain 500 g on average.
#             The filling machine is known to have sigma = 10 g.
#             We weigh 36 boxes and get a mean of 496 g.
#             Is the machine under-filling?
#
#  H0 : mu  = 500      (machine is fine)
#  H1 : mu != 500      (two-sided test)
#
#  Base R has no built-in z.test(), so we compute it by hand.
#  The formula is
#          Z = (x_bar - mu0) / (sigma / sqrt(n))

cat("=============================================\n")
cat(" 2. ONE SAMPLE Z TEST FOR A MEAN\n")
cat("=============================================\n")

x_bar <- 496     # sample mean
mu0   <- 500     # value claimed in H0
sigma <- 10      # known population SD
n     <- 36      # sample size

z_stat <- (x_bar - mu0) / (sigma / sqrt(n))

# Two-sided p-value : area in BOTH tails of the standard normal
p_val_z <- 2 * pnorm(-abs(z_stat))

cat("  Z statistic =", round(z_stat, 3), "\n")
decide(p_val_z)

# 95 % confidence interval for the true mean
z_crit <- qnorm(0.975)                 # 1.96
ci_z   <- x_bar + c(-1, 1) * z_crit * sigma / sqrt(n)
cat("  95% CI for mean :", round(ci_z, 2), "\n\n")

# One-sided version (is the machine UNDER-filling?)
#   H1 : mu < 500   ->  use only the LEFT tail
p_val_left <- pnorm(z_stat)
cat("  One-sided (mu < 500) p-value =", round(p_val_left, 4), "\n\n")


############################################################
#  3. ONE SAMPLE t TEST FOR A MEAN
############################################################
#
#  Use when : sigma is UNKNOWN (the usual real-life case).
#             We estimate it with the sample SD  s.
#             The statistic follows a t distribution with
#             n - 1 degrees of freedom.
#
#  Example  : A teacher claims students sleep 7 hours a night.
#             We ask 15 students. Test at alpha = 0.05.
#
#  H0 : mu  = 7
#  H1 : mu != 7

cat("=============================================\n")
cat(" 3. ONE SAMPLE t TEST FOR A MEAN\n")
cat("=============================================\n")

sleep_hours <- c(6.5, 7.2, 5.8, 6.9, 7.5, 6.1, 6.8, 7.0,
                 5.9, 6.4, 7.1, 6.6, 6.2, 6.7, 6.3)

# --- (a) by hand, to see the formula ------------------------
n     <- length(sleep_hours)
x_bar <- mean(sleep_hours)
s     <- sd(sleep_hours)
t_stat <- (x_bar - 7) / (s / sqrt(n))
p_val_t <- 2 * pt(-abs(t_stat), df = n - 1)

cat("  Sample mean  =", round(x_bar, 3), "\n")
cat("  Sample SD    =", round(s, 3), "\n")
cat("  t statistic  =", round(t_stat, 3), " (df =", n - 1, ")\n")
decide(p_val_t)

# --- (b) the built-in way : t.test() -----------------------
# This is what you would normally use.
result_t <- t.test(sleep_hours, mu = 7)
print(result_t)

# Useful pieces of the result object
cat("  t.test p-value :", round(result_t$p.value, 4), "\n")
cat("  95% CI         :", round(result_t$conf.int, 3), "\n\n")

# One-sided alternative : "students sleep LESS than 7 hours"
t.test(sleep_hours, mu = 7, alternative = "less")


############################################################
#  4. ONE SAMPLE TEST FOR A PROPORTION
############################################################
#
#  Use when : the data are counts of successes / failures
#             and we want to test a claimed proportion p0.
#
#  Example  : A company says 60 % of customers are satisfied.
#             In a survey of 200 customers, 105 are satisfied.
#             Is the true proportion different from 0.60 ?
#
#  H0 : p  = 0.60
#  H1 : p != 0.60

cat("=============================================\n")
cat(" 4. ONE SAMPLE TEST FOR A PROPORTION\n")
cat("=============================================\n")

successes <- 105
n         <- 200
p0        <- 0.60
p_hat     <- successes / n

# --- (a) Z test for a proportion, by hand ------------------
#      Z = (p_hat - p0) / sqrt( p0 (1 - p0) / n )
z_prop <- (p_hat - p0) / sqrt(p0 * (1 - p0) / n)
p_val_prop <- 2 * pnorm(-abs(z_prop))

cat("  Sample proportion =", round(p_hat, 3), "\n")
cat("  Z statistic       =", round(z_prop, 3), "\n")
decide(p_val_prop)

# --- (b) built-in : prop.test() ----------------------------
# prop.test() uses a chi-square statistic which is simply Z^2.
# correct = FALSE gives exactly the same answer as our Z above.
prop.test(x = successes, n = n, p = p0, correct = FALSE)

# --- (c) exact test : binom.test() -------------------------
# Works for ANY sample size (no normal approximation needed).
binom.test(x = successes, n = n, p = p0)


############################################################
#  5. SUMMARY TABLE
############################################################
#
#  Test                 | R function            | When to use
#  ---------------------|-----------------------|---------------------------
#  One sample Z (mean)  | by hand (pnorm)       | sigma known, or n large
#  One sample t (mean)  | t.test(x, mu = )      | sigma unknown
#  One sample proportion| prop.test() or        | success / failure counts
#                       | binom.test()          |
#
#  Continue with FILE 2 for two-sample tests.
############################################################
