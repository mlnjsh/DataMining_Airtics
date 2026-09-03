############################################################
#  FILE 5 : LINEAR REGRESSION
#
#  Question answered :
#     "How does a NUMERIC outcome change when one or more
#      predictors change, and can we PREDICT it ?"
#
#  Topics
#    1. The data  (mtcars : 32 cars from a 1974 magazine)
#    2. Explore : correlation and scatter plot
#    3. Simple linear regression   (one predictor)
#    4. Reading the summary() output
#    5. Multiple linear regression (several predictors)
#    6. Comparing models
#    7. Checking the assumptions
#    8. Making predictions
############################################################


############################################################
#  1. THE DATA
############################################################
#
#  mtcars ships with R.  We will predict fuel economy.
#
#     mpg  : miles per gallon         <- OUTCOME (y)
#     wt   : weight in 1000 lbs       <- predictor
#     hp   : horsepower               <- predictor
#     qsec : quarter-mile time (sec)  <- predictor
#     am   : transmission (0 = automatic, 1 = manual)

data("mtcars")
cars <- mtcars

cat("=============================================\n")
cat(" 1. THE DATA\n")
cat("=============================================\n")
head(cars[, c("mpg", "wt", "hp", "qsec", "am")])
summary(cars[, c("mpg", "wt", "hp", "qsec")])


############################################################
#  2. EXPLORE THE RELATIONSHIP
############################################################

cat("\n=============================================\n")
cat(" 2. CORRELATION AND SCATTER PLOT\n")
cat("=============================================\n")

# Correlation matrix : values close to +1 or -1 = strong
# linear relationship.  Note mpg vs wt is strongly negative.
round(cor(cars[, c("mpg", "wt", "hp", "qsec")]), 2)

# Scatter plot of mpg against weight
plot(cars$wt, cars$mpg,
     pch  = 16, col = "steelblue",
     xlab = "Weight (1000 lbs)", ylab = "Miles per gallon",
     main = "Heavier cars use more fuel")


############################################################
#  3. SIMPLE LINEAR REGRESSION  (one predictor)
############################################################
#
#  Model :   mpg = b0 + b1 * wt + error
#
#     b0 = intercept  : predicted mpg when wt = 0
#     b1 = slope      : change in mpg for each extra 1000 lbs
#
#  lm() = "linear model".  Formula reads  y ~ x.

cat("\n=============================================\n")
cat(" 3. SIMPLE LINEAR REGRESSION  (mpg ~ wt)\n")
cat("=============================================\n")

model_simple <- lm(mpg ~ wt, data = cars)

# Just the coefficients
coef(model_simple)

# Add the fitted line to the scatter plot
abline(model_simple, col = "red", lwd = 2)

# Full output
summary(model_simple)


############################################################
#  4. HOW TO READ summary(model)
############################################################
#
#  Coefficients table
#     Estimate    : the fitted b0 and b1
#     Std. Error  : uncertainty of each estimate
#     t value     : Estimate / Std. Error
#     Pr(>|t|)    : p-value.  H0 : this coefficient = 0
#                   small p  ->  the predictor matters
#
#  Residual standard error : typical size of a prediction error
#
#  Multiple R-squared : share of the variation in y explained
#                       by the model (0 = none, 1 = all)
#  Adjusted R-squared : R-squared with a penalty for extra
#                       predictors.  Use this to compare models.
#
#  F-statistic : tests whether the model as a whole is better
#                than just using the mean of y.

s <- summary(model_simple)
cat("\n  Slope (wt)        =", round(coef(model_simple)[2], 3), "\n")
cat("  -> every extra 1000 lbs costs about",
    round(abs(coef(model_simple)[2]), 1), "mpg\n")
cat("  R-squared         =", round(s$r.squared, 3), "\n")
cat("  p-value of slope  =", format.pval(s$coefficients[2, 4], digits = 3), "\n")

# 95 % confidence intervals for the coefficients
confint(model_simple)


############################################################
#  5. MULTIPLE LINEAR REGRESSION  (several predictors)
############################################################
#
#  Model :   mpg = b0 + b1*wt + b2*hp + b3*qsec + error
#
#  Each slope is now the effect of that predictor
#  HOLDING THE OTHERS CONSTANT.

cat("\n=============================================\n")
cat(" 5. MULTIPLE LINEAR REGRESSION\n")
cat("=============================================\n")

model_multi <- lm(mpg ~ wt + hp + qsec, data = cars)
summary(model_multi)

#  A categorical predictor works too.  am is 0/1 so we wrap it
#  in factor() so R treats it as a category, not a number.
model_cat <- lm(mpg ~ wt + hp + factor(am), data = cars)
summary(model_cat)$coefficients

#  The coefficient  factor(am)1  is the extra mpg a MANUAL car
#  gets compared to an automatic car of the same wt and hp.


############################################################
#  6. COMPARING MODELS
############################################################
#
#  Two common tools :
#    Adjusted R-squared : higher is better
#    AIC                : lower is better (penalises complexity)

cat("\n=============================================\n")
cat(" 6. MODEL COMPARISON\n")
cat("=============================================\n")

comparison <- data.frame(
  model      = c("mpg ~ wt", "mpg ~ wt + hp + qsec", "mpg ~ wt + hp + am"),
  adj_r2     = c(summary(model_simple)$adj.r.squared,
                 summary(model_multi)$adj.r.squared,
                 summary(model_cat)$adj.r.squared),
  AIC        = c(AIC(model_simple), AIC(model_multi), AIC(model_cat))
)
comparison$adj_r2 <- round(comparison$adj_r2, 3)
comparison$AIC    <- round(comparison$AIC, 1)
print(comparison)

# Formal test : is the bigger model significantly better ?
# H0 : the extra predictors add nothing.
anova(model_simple, model_multi)


############################################################
#  7. CHECKING THE ASSUMPTIONS
############################################################
#
#  Linear regression assumes :
#    (a) Linear relationship
#    (b) Residuals have constant spread (homoscedasticity)
#    (c) Residuals are roughly normal
#    (d) No extreme influential points
#
#  plot(model) gives four diagnostic plots that check these.

cat("\n=============================================\n")
cat(" 7. DIAGNOSTIC PLOTS\n")
cat("=============================================\n")

par(mfrow = c(2, 2))
plot(model_multi)
par(mfrow = c(1, 1))

#  Plot 1  Residuals vs Fitted : want a flat, random cloud
#  Plot 2  Q-Q plot            : want points on the line
#  Plot 3  Scale-Location      : want a flat line (constant spread)
#  Plot 4  Residuals vs Leverage : points outside the dashed
#          Cook's distance lines are influential

# Numeric normality check of residuals  (want p > 0.05)
shapiro.test(residuals(model_multi))

# Multicollinearity : are predictors too correlated with
# each other ?  A quick check without extra packages :
round(cor(cars[, c("wt", "hp", "qsec")]), 2)
# Rule of thumb : correlations above 0.8 between predictors
# are a warning sign.


############################################################
#  8. MAKING PREDICTIONS
############################################################

cat("\n=============================================\n")
cat(" 8. PREDICTIONS\n")
cat("=============================================\n")

# New cars we want to predict mpg for
new_cars <- data.frame(wt   = c(2.5, 3.5),
                       hp   = c(110, 200),
                       qsec = c(18, 16))

# Point prediction
predict(model_multi, newdata = new_cars)

# With a 95 % PREDICTION interval (range for a single new car)
predict(model_multi, newdata = new_cars, interval = "prediction")

# With a 95 % CONFIDENCE interval (range for the AVERAGE car
# with these values). Always narrower than the prediction interval.
predict(model_multi, newdata = new_cars, interval = "confidence")


############################################################
#  9. SUMMARY
############################################################
#
#  Task                   R code
#  ---------------------  --------------------------------------
#  Fit a model            m <- lm(y ~ x1 + x2, data = d)
#  See results            summary(m)
#  Coefficients           coef(m),  confint(m)
#  Compare models         AIC(m1, m2),  anova(m1, m2)
#  Diagnostics            plot(m)
#  Predict                predict(m, newdata = new_d,
#                                 interval = "prediction")
#
#  Continue with FILE 6 for Logistic Regression
#  (when the outcome is YES / NO).
############################################################
