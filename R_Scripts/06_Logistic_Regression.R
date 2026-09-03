############################################################
#  FILE 6 : LOGISTIC REGRESSION
#
#  Question answered :
#     "What is the PROBABILITY of a YES / NO outcome, given
#      some predictors ?"
#
#  Linear regression predicts a number.  Logistic regression
#  predicts a probability between 0 and 1, so it is the right
#  tool when the outcome is binary :
#     diseased / healthy,  bought / did not buy,  pass / fail
#
#  Topics
#    1. The data  (Pima Indians Diabetes, downloaded from web)
#    2. Explore the data
#    3. Split into training and test sets
#    4. Fit the logistic regression
#    5. Reading the output : log-odds and odds ratios
#    6. Predict probabilities and classes
#    7. Evaluate : confusion matrix, accuracy, sensitivity
#    8. Simpler model and comparison
############################################################


############################################################
#  1. THE DATA
############################################################
#
#  Pima Indians Diabetes data set : 768 women, 8 medical
#  measurements, and whether they developed diabetes.
#
#  The file has no header row, so we name the columns ourselves.
#  If you have no internet connection the script falls back
#  to the built-in mtcars data (predicting manual vs automatic).

url <- paste0("https://raw.githubusercontent.com/jbrownlee/Datasets/",
              "master/pima-indians-diabetes.data.csv")

col_names <- c("pregnancies", "glucose", "blood_pressure",
               "skin_thickness", "insulin", "bmi",
               "pedigree", "age", "diabetes")

diabetes_data <- tryCatch(
  {
    d <- read.csv(url, header = FALSE, col.names = col_names)
    cat("  Downloaded the Pima diabetes data set.\n")
    d
  },
  error = function(e) {
    cat("  Download failed - using built-in mtcars instead.\n")
    data("mtcars")
    data.frame(glucose = mtcars$hp,       # stand-ins so the
               bmi     = mtcars$wt,       # rest of the script
               age     = mtcars$qsec,     # still runs
               diabetes = mtcars$am)
  }
)

cat("=============================================\n")
cat(" 1. THE DATA\n")
cat("=============================================\n")
str(diabetes_data)

# The outcome must be a FACTOR with two levels for glm().
# 0 = no diabetes, 1 = diabetes
diabetes_data$diabetes <- factor(diabetes_data$diabetes,
                                 levels = c(0, 1),
                                 labels = c("No", "Yes"))


############################################################
#  2. EXPLORE THE DATA
############################################################

cat("\n=============================================\n")
cat(" 2. EXPLORE\n")
cat("=============================================\n")

# How balanced is the outcome ?
table(diabetes_data$diabetes)
round(prop.table(table(diabetes_data$diabetes)), 3)

# Do glucose levels differ between the two groups ?
boxplot(glucose ~ diabetes, data = diabetes_data,
        col  = c("lightgreen", "salmon"),
        main = "Glucose level by diabetes status",
        xlab = "Diabetes", ylab = "Glucose")

# Mean of each predictor in each group
aggregate(cbind(glucose, bmi, age) ~ diabetes,
          data = diabetes_data, FUN = mean)


############################################################
#  3. TRAIN / TEST SPLIT
############################################################
#
#  We fit the model on 70 % of the rows (training set) and
#  judge it on the other 30 % (test set) that the model has
#  never seen.  This gives an honest measure of performance.

cat("\n=============================================\n")
cat(" 3. TRAIN / TEST SPLIT\n")
cat("=============================================\n")

set.seed(123)                                 # makes the split repeatable
n_rows     <- nrow(diabetes_data)
train_rows <- sample(1:n_rows, size = round(0.7 * n_rows))

train <- diabetes_data[ train_rows, ]
test  <- diabetes_data[-train_rows, ]

cat("  Training rows :", nrow(train), "\n")
cat("  Test rows     :", nrow(test),  "\n")


############################################################
#  4. FIT THE LOGISTIC REGRESSION
############################################################
#
#  glm() = generalised linear model.
#  family = binomial  tells R this is logistic regression.
#
#  The model is
#     log( p / (1 - p) ) = b0 + b1*glucose + b2*bmi + b3*age
#
#  The left side is the LOG-ODDS (also called the logit).

cat("\n=============================================\n")
cat(" 4. FIT THE MODEL\n")
cat("=============================================\n")

model_logit <- glm(diabetes ~ glucose + bmi + age,
                   data   = train,
                   family = binomial)

summary(model_logit)


############################################################
#  5. READING THE OUTPUT
############################################################
#
#  Coefficients table
#     Estimate : change in LOG-ODDS for a one-unit increase
#                in the predictor.  Hard to read directly.
#     Pr(>|z|) : p-value.  Small  ->  predictor matters.
#
#  Deviance
#     Null deviance     : model with no predictors
#     Residual deviance : our model.  Big drop = good.
#     AIC               : lower is better (compare models).
#
#  ODDS RATIOS make the coefficients easier to talk about.
#     odds ratio = exp(coefficient)
#     OR = 1.04  ->  each extra unit multiplies the odds of
#                    diabetes by 1.04  (a 4 % increase)
#     OR < 1     ->  the predictor LOWERS the odds

cat("\n  Odds ratios with 95% confidence intervals :\n")
odds_ratios <- exp(cbind(OR = coef(model_logit),
                         confint.default(model_logit)))
print(round(odds_ratios, 3))

#  An odds ratio whose confidence interval contains 1 is NOT
#  significant (same idea as a CI containing 0 in linear
#  regression).


############################################################
#  6. PREDICT PROBABILITIES AND CLASSES
############################################################
#
#  type = "response"  gives probabilities (0 to 1).
#  Without it, predict() returns log-odds.

cat("\n=============================================\n")
cat(" 6. PREDICTIONS ON THE TEST SET\n")
cat("=============================================\n")

test$prob <- predict(model_logit, newdata = test, type = "response")

# Look at a few predicted probabilities
head(round(test$prob, 3))

# Turn probabilities into a YES / NO decision.
# 0.5 is the usual cut-off, but it can be changed.
cutoff <- 0.5
test$predicted <- factor(ifelse(test$prob > cutoff, "Yes", "No"),
                         levels = c("No", "Yes"))

# Predict for one brand-new patient
new_patient <- data.frame(glucose = 150, bmi = 33, age = 45)
p_new <- predict(model_logit, newdata = new_patient, type = "response")
cat("\n  New patient (glucose 150, bmi 33, age 45) :\n")
cat("  probability of diabetes =", round(p_new, 3), "\n")


############################################################
#  7. EVALUATE THE MODEL
############################################################
#
#  Confusion matrix : rows = actual, columns = predicted
#
#                    Predicted No   Predicted Yes
#     Actual No         TN              FP
#     Actual Yes        FN              TP
#
#  Accuracy    = (TP + TN) / total     overall correct rate
#  Sensitivity = TP / (TP + FN)        of the true YES, how
#                                      many did we catch ?
#  Specificity = TN / (TN + FP)        of the true NO, how
#                                      many did we get right ?

cat("\n=============================================\n")
cat(" 7. CONFUSION MATRIX AND ACCURACY\n")
cat("=============================================\n")

conf_matrix <- table(Actual = test$diabetes, Predicted = test$predicted)
print(conf_matrix)

TN <- conf_matrix["No",  "No"]
FP <- conf_matrix["No",  "Yes"]
FN <- conf_matrix["Yes", "No"]
TP <- conf_matrix["Yes", "Yes"]

accuracy    <- (TP + TN) / sum(conf_matrix)
sensitivity <- TP / (TP + FN)
specificity <- TN / (TN + FP)

cat("\n  Accuracy    =", round(accuracy,    3), "\n")
cat("  Sensitivity =", round(sensitivity, 3), "\n")
cat("  Specificity =", round(specificity, 3), "\n")

#  Trade-off : lowering the cut-off (say 0.3) catches more
#  true cases (higher sensitivity) but produces more false
#  alarms (lower specificity).  Try it :
#     test$predicted <- ifelse(test$prob > 0.3, "Yes", "No")


############################################################
#  8. A SIMPLER MODEL AND COMPARISON
############################################################
#
#  Is glucose alone almost as good ?  Compare with AIC and a
#  likelihood-ratio test (the logistic version of anova()).

cat("\n=============================================\n")
cat(" 8. MODEL COMPARISON\n")
cat("=============================================\n")

model_small <- glm(diabetes ~ glucose, data = train, family = binomial)

cat("  AIC full model  :", round(AIC(model_logit), 1), "\n")
cat("  AIC small model :", round(AIC(model_small), 1), "\n\n")

# Likelihood-ratio test.  H0 : bmi and age add nothing.
anova(model_small, model_logit, test = "Chisq")


############################################################
#  9. SUMMARY
############################################################
#
#  Task                   R code
#  ---------------------  ----------------------------------------
#  Fit                    m <- glm(y ~ x1 + x2, data = d,
#                                  family = binomial)
#  Results                summary(m)
#  Odds ratios            exp(coef(m))
#  Probabilities          predict(m, newdata, type = "response")
#  Classes                ifelse(prob > 0.5, "Yes", "No")
#  Confusion matrix       table(actual, predicted)
#  Compare models         anova(m1, m2, test = "Chisq"),  AIC()
#
#  Linear regression  -> numeric outcome   (FILE 5)
#  Logistic regression-> yes / no outcome  (this file)
############################################################
