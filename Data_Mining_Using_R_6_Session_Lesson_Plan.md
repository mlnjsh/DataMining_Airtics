# Data Mining Using R: Six-Session Lesson Plan

## Course Overview

| Item | Details |
|---|---|
| Total duration | 15 hours |
| Number of sessions | 6 |
| Duration per session | 2.5 hours |
| Teaching approach | Approximately 40% concepts and 60% hands-on practice in R |
| Major topics | Data handling, preprocessing, EDA, statistical inference, ANOVA, linear regression and logistic regression |

## Overall Course Learning Outcomes

By the end of the course, students will be able to:

1. Explain the purpose and basic process of data mining.
2. Import, inspect, clean and transform datasets in R.
3. Perform exploratory data analysis and create visualizations.
4. Apply basic statistical inference and ANOVA.
5. Build, interpret and evaluate linear regression models.
6. Build, interpret and evaluate binary logistic regression models.
7. Communicate analytical findings through an R Markdown or Quarto report.

---

## Session 1: Introduction to Data Mining and R

**Duration:** 2.5 hours

### Learning Outcomes

Students will be able to:

- Explain the purpose of data mining.
- Understand the CRISP-DM process.
- Use basic R data structures.
- Import and inspect datasets in R.

### Session Plan

| Time | Topic | Activity |
|---:|---|---|
| 20 min | Introduction to data mining | Discuss applications and examples |
| 20 min | Data mining, statistics and machine learning | Compare the three areas |
| 20 min | CRISP-DM process | Explain its stages using a business problem |
| 25 min | Introduction to R and RStudio | Explore the environment and basic syntax |
| 30 min | R data structures | Work with vectors, matrices, lists and data frames |
| 25 min | Importing data | Read CSV and Excel files |
| 20 min | Initial data inspection | Use `head()`, `str()`, `summary()` and `dim()` |
| 10 min | Review and assessment | Complete a short practical exercise |

### R Functions and Packages

```r
read.csv()
head()
tail()
str()
summary()
dim()
names()
class()
```

### Practical Exercise

Import a dataset and identify:

- Number of rows and columns
- Variable names and data types
- Missing values
- Numerical and categorical variables

---

## Session 2: Data Cleaning, Preprocessing and Exploratory Data Analysis

**Duration:** 2.5 hours

### Learning Outcomes

Students will be able to:

- Clean and transform data in R.
- Handle missing values and duplicate records.
- Detect potential outliers.
- Perform descriptive and exploratory analysis.
- Create visualizations using `ggplot2`.

### Session Plan

| Time | Topic | Activity |
|---:|---|---|
| 20 min | Introduction to data quality | Discuss common data problems |
| 30 min | Data manipulation with `dplyr` | Select, filter, arrange and mutate variables |
| 20 min | Missing values and duplicates | Detect and treat incomplete or repeated records |
| 20 min | Outlier detection | Apply the IQR method and use box plots |
| 20 min | Descriptive statistics | Calculate measures of central tendency and dispersion |
| 25 min | Univariate and bivariate analysis | Examine distributions and relationships |
| 25 min | Visualization with `ggplot2` | Create histograms, box plots and scatter plots |
| 10 min | Review and assessment | Interpret an EDA output |

### R Functions and Packages

```r
is.na()
complete.cases()
duplicated()
na.omit()
select()
filter()
arrange()
mutate()
group_by()
summarise()
ggplot()
```

### Practical Exercise

Clean a dataset and prepare a short EDA report containing:

- Missing-value summary
- Descriptive statistics
- Histogram
- Box plot
- Scatter plot
- Correlation matrix

---

## Session 3: Statistical Inference and ANOVA

**Duration:** 2.5 hours

### Learning Outcomes

Students will be able to:

- Formulate null and alternative hypotheses.
- Interpret p-values and confidence intervals.
- Perform basic hypothesis tests.
- Conduct and interpret one-way ANOVA.
- Apply an appropriate post-hoc test.

### Session Plan

| Time | Topic | Activity |
|---:|---|---|
| 20 min | Population, sample and sampling | Explain foundational concepts |
| 20 min | Hypothesis-testing framework | Define hypotheses and significance level |
| 20 min | Confidence intervals and p-values | Interpret results using examples |
| 25 min | One-sample, two-sample and paired tests | Demonstrate tests in R |
| 15 min | Chi-square test | Test association between categorical variables |
| 25 min | Introduction to ANOVA | Explain its purpose, F-statistic and ANOVA table |
| 15 min | ANOVA assumptions | Discuss normality, independence and equal variance |
| 10 min | Tukey's post-hoc test | Compare individual group means |
| 10 min | Review and assessment | Interpret statistical output |

### R Functions

```r
t.test()
chisq.test()
aov()
summary()
TukeyHSD()
shapiro.test()
bartlett.test()
```

### Practical Exercise

Determine whether the mean response differs across three or more groups:

1. Formulate the hypotheses.
2. Perform one-way ANOVA.
3. Check the assumptions.
4. Apply Tukey's HSD.
5. Write the final conclusion in simple language.

---

## Session 4: Simple and Multiple Linear Regression

**Duration:** 2.5 hours

### Learning Outcomes

Students will be able to:

- Explain the purpose of regression.
- Build simple and multiple linear regression models.
- Interpret regression coefficients.
- Interpret \(R^2\), adjusted \(R^2\) and p-values.
- Generate predictions using a fitted model.

### Session Plan

| Time | Topic | Activity |
|---:|---|---|
| 20 min | Introduction to regression | Identify response and predictor variables |
| 20 min | Simple linear regression | Explain the regression equation and intuition |
| 20 min | Ordinary least squares | Discuss residuals and the best-fitting line |
| 25 min | Building a model using `lm()` | Complete a hands-on demonstration |
| 25 min | Multiple linear regression | Work with multiple predictors |
| 20 min | Interpretation of model output | Interpret coefficients, p-values and confidence intervals |
| 10 min | Model goodness of fit | Interpret \(R^2\) and adjusted \(R^2\) |
| 10 min | Prediction | Generate confidence and prediction intervals |
| 10 min | Review and assessment | Interpret a regression output |

### R Functions

```r
lm()
summary()
coef()
confint()
predict()
anova()
```

### Practical Exercise

Build a regression model to predict a continuous outcome and answer:

- Which variables significantly affect the outcome?
- What does each coefficient mean?
- How much variation does the model explain?
- What is the predicted value for a new observation?

---

## Session 5: Regression Diagnostics and Model Improvement

**Duration:** 2.5 hours

### Learning Outcomes

Students will be able to:

- Check linear regression assumptions.
- Diagnose multicollinearity.
- Identify influential observations.
- Use categorical and interaction variables.
- Evaluate and compare regression models.

### Session Plan

| Time | Topic | Activity |
|---:|---|---|
| 20 min | Regression assumptions | Discuss linearity, independence, normality and constant variance |
| 30 min | Residual diagnostics | Interpret residual and Q-Q plots |
| 20 min | Multicollinearity | Use correlation and VIF |
| 15 min | Influential observations | Examine leverage and Cook's distance |
| 20 min | Categorical predictors | Use dummy variables in R |
| 15 min | Interaction and polynomial terms | Extend the regression model |
| 20 min | Model evaluation | Calculate MAE, MSE and RMSE |
| 10 min | Model comparison | Compare candidate models |
| 10 min | Review and assessment | Diagnose a problematic model |

### R Functions and Packages

```r
plot(model)
residuals()
fitted()
vif()
cooks.distance()
I()
predict()
```

### Practical Exercise

Diagnose and improve the model created in Session 4:

1. Check residual plots.
2. Check normality and constant variance.
3. Calculate VIF.
4. Identify influential observations.
5. Calculate MAE, MSE and RMSE.
6. Compare the original and improved models.

---

## Session 6: Logistic Regression and Model Validation

**Duration:** 2.5 hours

### Learning Outcomes

Students will be able to:

- Explain probability, odds and log-odds.
- Build a binary logistic regression model.
- Interpret coefficients and odds ratios.
- Generate predicted probabilities and classes.
- Evaluate classification performance.
- Present a complete data-mining workflow.

### Session Plan

| Time | Topic | Activity |
|---:|---|---|
| 20 min | Introduction to classification | Compare continuous and binary outcomes |
| 20 min | Probability, odds and log-odds | Work through numerical examples |
| 20 min | Logistic and sigmoid functions | Explain model intuition |
| 25 min | Building a model using `glm()` | Complete a hands-on demonstration |
| 20 min | Coefficients and odds ratios | Interpret the fitted model |
| 15 min | Probability and class prediction | Apply classification thresholds |
| 20 min | Confusion matrix and metrics | Calculate accuracy, precision, recall and F1-score |
| 10 min | ROC curve and AUC | Explain threshold-independent evaluation |
| 10 min | Cross-validation and overfitting | Introduce model validation |
| 10 min | Final review | Conduct a mini-project presentation or quiz |

### R Functions and Packages

```r
glm(family = binomial)
predict(type = "response")
exp(coef(model))
table()
confusionMatrix()
roc()
auc()
```

### Practical Exercise

Develop a binary classification model:

1. Split the data into training and testing sets.
2. Fit a logistic regression model.
3. Interpret coefficients and odds ratios.
4. Generate predicted probabilities.
5. Convert probabilities into predicted classes.
6. Create a confusion matrix.
7. Calculate evaluation metrics.
8. Plot the ROC curve and report AUC.

---

## Assessment Plan

| Assessment | Weight |
|---|---:|
| Session exercises and participation | 20% |
| Data cleaning and EDA assignment | 20% |
| ANOVA interpretation assignment | 15% |
| Linear regression assignment | 20% |
| Logistic regression mini-project | 25% |
| **Total** | **100%** |

## Recommended Datasets

| Topic | Suggested Dataset |
|---|---|
| Data handling and EDA | `airquality` |
| Statistical tests and ANOVA | `PlantGrowth` |
| Linear regression | `mtcars` |
| Multiple regression and diagnostics | `Boston` or `marketing` |
| Logistic regression | `PimaIndiansDiabetes2`, `Titanic` or `Default` |

## Expected Final Deliverable

Students submit an R Markdown or Quarto report containing:

1. Problem definition
2. Data description
3. Data cleaning
4. Exploratory data analysis
5. Appropriate ANOVA or statistical test
6. Linear or logistic regression model
7. Model diagnostics and evaluation
8. Interpretation of findings
9. Conclusion and recommendations

