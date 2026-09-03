# 🧪 R Scripts

Seven self-contained, heavily commented scripts. Base R only, nothing to install. Run any of them with `Rscript <file>` or line by line in RStudio.

| # | File | Topics | Data |
|:-:|---|---|---|
| 00 | `00_R_Basics_Complete_Reference.R` | Arithmetic and maths functions, rounding, logic, vectors, matrices, lists, data frames, factors, NA handling, if/else, for/while/repeat, functions, apply family, strings, dates, packages, built-in datasets, file I/O, help, descriptive statistics, frequency tables, correlation, d/p/q/r distribution functions, sampling, all basic plots, and a map of statistical tests | `mtcars`, `iris` |
| 01 | `01_Hypothesis_Testing_One_Sample.R` | Hypothesis-testing recap, one-sample Z test, one-sample t test, one-sample proportion test (`prop.test`, `binom.test`) | hand-typed |
| 02 | `02_Hypothesis_Testing_Two_Sample.R` | F test for variances, two-sample Z test, pooled t test, Welch t test, paired t test, two-proportion test | hand-typed |
| 03 | `03_One_Way_ANOVA.R` | `aov()`, reading the ANOVA table, Tukey HSD, Shapiro-Wilk, Bartlett, Welch ANOVA, Kruskal-Wallis | `PlantGrowth` |
| 04 | `04_Two_Way_ANOVA.R` | Additive vs interaction models, interaction plot, Tukey on two factors, diagnostics | `ToothGrowth` |
| 05 | `05_Linear_Regression.R` | `lm()`, reading `summary()`, multiple regression, categorical predictors, adjusted R² and AIC, `plot(model)`, prediction and confidence intervals | `mtcars` |
| 06 | `06_Logistic_Regression.R` | `glm(family = binomial)`, odds ratios, train/test split, predicted probabilities, cut-off, confusion matrix, accuracy, sensitivity, specificity, likelihood-ratio test | Pima Indians Diabetes (downloaded, falls back to `mtcars` offline) |

## Conventions used in every file

- Each test states **H0** and **H1** in comments before any code.
- The statistic is computed **by hand from the formula** first, then with the built-in function, so the two can be compared.
- A helper `decide()` prints a plain **REJECT H0** / **DO NOT reject H0** line for every p-value.
- Every file ends with a **summary table** of the functions used and a pointer to the next file.

## Suggested order

```
00 basics  →  01 one-sample  →  02 two-sample  →  03 one-way ANOVA
           →  04 two-way ANOVA  →  05 linear regression  →  06 logistic regression
```
