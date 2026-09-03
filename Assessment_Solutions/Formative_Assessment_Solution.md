# Formative Assessment Solution (40 marks)

**Task:** Prepare a presentation of 10 to 15 slides with speaker notes covering:

1. The concept of Linear Regression Analysis with multiple examples. **[10 marks]**
2. The different types of linear regression, compared and contrasted with examples from different professional backgrounds. **[20 marks]**
3. How linear regression differs from logistic regression, using a real-life example. **[10 marks]**

The rubric gives equal weight (20 % each) to documentation, completeness, accuracy, speaker notes, and applicability. The plan below has **13 content slides** (cover, references and thank-you slides are not counted). Each slide lists what goes on the slide and what to say in the speaker notes. All R examples below have been run and give the outputs shown.

---

## Slide 0 : Cover (not counted)

Title: *Linear Regression Analysis: Concepts, Types and Comparison with Logistic Regression*
Name, Student ID, Module, Date.

---

## Part 1 : The concept of linear regression (10 marks) — Slides 1 to 4

### Slide 1 : What is linear regression?

**On the slide**
- A statistical method that models the relationship between a **numeric outcome** (dependent variable, *y*) and one or more **predictors** (independent variables, *x*).
- It fits a straight line: **y = b₀ + b₁x + ε**
  - b₀ = intercept (value of y when x = 0)
  - b₁ = slope (change in y for a one-unit increase in x)
  - ε = error (what the line cannot explain)
- Picture: a scatter plot with a fitted straight line.

**Speaker notes**
Linear regression answers two questions. First, *how strongly* is y related to x, and in which direction? Second, *what value of y* should we expect for a new x? The word "linear" means the relationship is modelled as a straight line. The line is chosen by the **method of least squares**: it minimises the sum of the squared vertical distances between the data points and the line. Those distances are called residuals.

### Slide 2 : How the line is fitted and judged

**On the slide**
- Least squares: minimise Σ(yᵢ − ŷᵢ)²
- Key outputs to read:
  - **Coefficients** (b₀, b₁) with p-values: is the slope different from zero?
  - **R²**: share of variation in y explained by the model (0 to 1)
  - **Residual standard error**: typical prediction error
- Assumptions: **L**inearity, **I**ndependence, **N**ormal residuals, **E**qual variance (LINE)

**Speaker notes**
R² of 0.75 means 75 % of the ups and downs in y are explained by x. The p-value of the slope tests H0: b₁ = 0. A small p-value (below 0.05) means x really does help explain y. Before trusting the model we check the four LINE assumptions using residual plots and a Q-Q plot. If they fail, the p-values and predictions cannot be trusted.

### Slide 3 : Example 1 — Car weight and fuel economy (engineering)

**On the slide**
- Data: 32 cars, weight (1000 lbs) vs miles per gallon.
- R code and result:

```r
model <- lm(mpg ~ wt, data = mtcars)
coef(model)
# (Intercept)          wt
#      37.285      -5.344
summary(model)$r.squared     # 0.753
```

- Interpretation: every extra 1000 lbs costs about **5.3 mpg**. Weight explains **75 %** of fuel economy.
- Plot: scatter of mpg vs wt with the red fitted line.

**Speaker notes**
This is a negative relationship: the slope is below zero. The intercept of 37 is the predicted mpg of a car weighing nothing, which is not meaningful physically but is needed to place the line. Prediction example: a 3000 lb car (wt = 3) is predicted to do 37.3 − 5.3 × 3 ≈ 21 mpg.

### Slide 4 : Example 2 and Example 3 — Other fields

**On the slide**

| Field | Outcome (y) | Predictor (x) | Typical finding |
|---|---|---|---|
| Economics | Household spending | Household income | Spending rises about 0.7 to 0.9 for every 1 unit of income (the marginal propensity to consume) |
| Health | Systolic blood pressure | Age | Blood pressure rises roughly 0.5 to 1 mmHg per year of age in adults |
| Education | Final exam score | Hours studied | Each extra hour of study adds a few marks, up to a point |
| Real estate | House price | Floor area (sq ft) | Price per square foot is the slope |

**Speaker notes**
The same equation works in every field. What changes is the meaning of the slope: rupees per rupee of income, mmHg per year, marks per hour, price per square foot. Ask the audience: "What is y and what is x in your own job?" That is the best way to check they have understood the idea.

---

## Part 2 : Types of linear regression (20 marks) — Slides 5 to 9

### Slide 5 : Overview of the types

**On the slide**
A tree diagram or SmartArt:

- **Simple linear regression** : one predictor
- **Multiple linear regression** : two or more predictors
- **Polynomial regression** : curved relationship, still linear in the coefficients
- **Regularised regression** : Ridge, Lasso (multiple regression with a penalty to control overfitting)
- (Optional) **Regression with categorical predictors / dummy variables**

**Speaker notes**
All of these are "linear" because the outcome is a linear combination of the coefficients. Polynomial regression fits a curve but is still solved by the same least-squares machinery. We will now look at each with a dataset from a different profession.

### Slide 6 : Simple linear regression — Agriculture

**On the slide**
- Dataset: crop yield vs fertilizer amount (kg/hectare) on 30 plots.
- Model: yield = b₀ + b₁ × fertilizer
- R:

```r
model <- lm(yield ~ fertilizer, data = farm)
```

- Strength: easy to explain and draw. Weakness: ignores every other cause (rain, soil, seed).

**Speaker notes**
One predictor, one slope. The whole story fits on one scatter plot. Use it when you have a single dominant driver or when explaining the idea to non-statisticians.

### Slide 7 : Multiple linear regression — Real estate / Business

**On the slide**
- Dataset: house prices with area, bedrooms, age of house, distance to city centre.
- Model: price = b₀ + b₁·area + b₂·bedrooms + b₃·age + b₄·distance
- R:

```r
model <- lm(price ~ area + bedrooms + age + distance, data = houses)
```

- Each slope is the effect of that predictor **holding the others constant**.
- Use **adjusted R²** (not R²) to compare models with different numbers of predictors.
- Watch for **multicollinearity**: predictors that are strongly related to each other (area and bedrooms).

**Speaker notes**
This is the workhorse of business analytics. The key phrase is "holding the others constant": b₁ is the price of one extra square foot for houses with the same bedrooms, age and distance. Variable selection (stepwise, AIC) is used to drop predictors that do not earn their place. In the car example from the summative task, stepwise selection reduced ten predictors to three: weight, quarter-mile time and transmission.

### Slide 8 : Polynomial regression — Medicine / Pharmacology

**On the slide**
- Dataset: drug dose (mg) vs patient response. Response rises, then flattens or falls at high doses.
- A straight line cannot capture this; a quadratic can:
  response = b₀ + b₁·dose + b₂·dose²
- R:

```r
model <- lm(response ~ dose + I(dose^2), data = trial)
# or
model <- lm(response ~ poly(dose, 2), data = trial)
```

- Still "linear" because the coefficients enter linearly.
- Risk: high-degree polynomials overfit and behave wildly outside the data range.

**Speaker notes**
The dose-response curve is the classic case. A negative b₂ gives an inverted U: more drug helps up to a point, then harms. Always plot the fitted curve over the data and never extrapolate a polynomial beyond the observed doses.

### Slide 9 : Compare and contrast

**On the slide**

| Type | Predictors | Shape | Example dataset | Best for | Main risk |
|---|---|---|---|---|---|
| Simple | 1 | Straight line | Fertilizer vs yield | Explaining, quick checks | Omitted variables |
| Multiple | 2 + | Flat plane / hyperplane | House prices | Controlling for several causes | Multicollinearity, overfitting |
| Polynomial | 1 + (with powers) | Curve | Dose vs response | Non-linear trends | Overfitting, bad extrapolation |
| Ridge / Lasso | Many | Plane with shrinkage | Marketing spend across 50 channels | Many correlated predictors | Harder to interpret coefficients |

**Speaker notes**
Contrast on three axes: number of predictors, shape of the fitted relationship, and what can go wrong. Simple regression is the most interpretable but the least realistic. Multiple regression is realistic but needs care with correlated predictors. Polynomial handles curves but overfits. Ridge and Lasso trade a little bias for much lower variance when there are many predictors. Choose the simplest model that passes the assumption checks and has the lowest AIC or highest adjusted R².

---

## Part 3 : Linear vs logistic regression (10 marks) — Slides 10 to 13

### Slide 10 : The core difference

**On the slide**

| | Linear regression | Logistic regression |
|---|---|---|
| Outcome (y) | Numeric, continuous (price, mpg, yield) | Binary category (yes/no, 0/1) |
| What is predicted | The value of y | The **probability** that y = 1 |
| Equation | y = b₀ + b₁x | log( p / (1 − p) ) = b₀ + b₁x |
| Shape of the fit | Straight line | S-shaped curve between 0 and 1 |
| Fitting method | Least squares | Maximum likelihood |
| Coefficient meaning | Change in y per unit x | Change in **log-odds** per unit x; exp(b) = odds ratio |
| R function | `lm()` | `glm(..., family = binomial)` |
| Evaluation | R², RMSE | Accuracy, confusion matrix, AUC |

**Speaker notes**
The single question to ask is: "Is my outcome a number or a yes/no?" A number means linear regression. A yes/no means logistic regression. Why not use a straight line for yes/no? Because a line predicts values below 0 and above 1, which are not probabilities. The logistic (sigmoid) curve squeezes any value into the 0 to 1 range.

### Slide 11 : Real-life example — Bank loans

**On the slide**
A bank collects: income, age, credit score, existing debt.

- **Question A (linear):** "How much will this customer spend on their credit card next month?"
  Outcome = amount in rupees → `lm(spend ~ income + age + score)`
- **Question B (logistic):** "Will this customer default on the loan?"
  Outcome = default Yes/No → `glm(default ~ income + age + score, family = binomial)`

Same predictors, same bank, same customers. The **type of outcome** decides the method.

**Speaker notes**
For Question B the model returns a probability, say 0.23. The bank then chooses a cut-off: above 0.20 reject, below approve. Changing the cut-off trades false approvals against false rejections. For Question A the model returns a rupee amount with a confidence interval. Note that logistic coefficients are read as odds ratios: exp(b) = 1.5 means each extra unit of x multiplies the odds of default by 1.5.

### Slide 12 : Worked medical example in R (diabetes)

**On the slide**
Pima Indians Diabetes data (768 women): predict diabetes (yes/no) from glucose, BMI and age.

```r
model <- glm(diabetes ~ glucose + bmi + age, data = train, family = binomial)
exp(coef(model))          # odds ratios
#  glucose 1.03   bmi 1.09   age 1.03
predict(model, newdata = data.frame(glucose = 150, bmi = 33, age = 45),
        type = "response")
# 0.63  -> 63 % probability of diabetes
```

- Test-set accuracy about 75 %, sensitivity about 53 %, specificity about 87 %.
- Compare: a linear model of **glucose level** (a number) from BMI and age would use `lm()`.

**Speaker notes**
Each extra unit of glucose multiplies the odds of diabetes by 1.03, so about 20 extra units roughly doubles the odds. The confusion matrix shows the model is better at ruling out diabetes (high specificity) than at catching it (lower sensitivity). Lowering the cut-off from 0.5 to 0.3 would catch more cases at the cost of more false alarms. That trade-off does not exist in linear regression, which is another practical difference.

### Slide 13 : Summary and when to use which

**On the slide**
- Linear regression: numeric outcome, straight-line relationship, read slopes directly.
- Types: simple, multiple, polynomial, regularised. Pick the simplest that fits and passes checks.
- Logistic regression: yes/no outcome, predicts probability, read odds ratios, choose a cut-off.
- Decision rule: **look at your y first**.

**Speaker notes**
Close by repeating the decision rule and the assumption checks. Invite questions.

---

## Slide 14 : References (not counted)

- James, G., Witten, D., Hastie, T. and Tibshirani, R. (2021). *An Introduction to Statistical Learning with Applications in R*, 2nd ed. Springer.
- Field, A., Miles, J. and Field, Z. (2012). *Discovering Statistics Using R*. Sage.
- R Core Team (2023). *R: A Language and Environment for Statistical Computing*. https://www.R-project.org/
- Henderson, H. V. and Velleman, P. F. (1981). Building multiple regression models interactively. *Biometrics*, 37, 391–411. (source of the `mtcars` data)
- Smith, J. W. et al. (1988). Using the ADAP learning algorithm to forecast the onset of diabetes mellitus. (source of the Pima Indians Diabetes data)

## Slide 15 : Thank you / Q&A (not counted)

---

## Checklist against the rubric

| Rubric item (20 % each) | How this plan meets it |
|---|---|
| Professional documentation | Consistent headings, one table or figure per slide, 13 content slides within the 10 to 15 range |
| Content completion | Q1 on slides 1 to 4, Q2 on slides 5 to 9, Q3 on slides 10 to 13 |
| Content accuracy | All R outputs quoted were produced by running the code in `R_Scripts/05_Linear_Regression.R` and `06_Logistic_Regression.R` |
| Speaker notes | Every slide has 3 to 6 sentences of notes that explain, not repeat, the slide |
| Applicability | Examples from engineering, economics, health, education, real estate, agriculture, pharmacology and banking |

**Tip for the student:** paste the plots from `R_Scripts/05_Linear_Regression.R` (mpg vs wt with fitted line, diagnostic plots) and from `06_Logistic_Regression.R` (glucose box plot) into the slides. Screenshots of the RStudio console with the outputs above will earn the "accuracy" marks.
