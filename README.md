# DataMining_Airtics

Teaching materials for the *Data Mining Using R* course.

## Contents

| File / Folder | Description |
|---|---|
| `BasicsOfR_Interactive_Slides.html` | Interactive HTML slides covering the basics of R |
| `Data_Mining_Using_R_6_Session_Lesson_Plan.md` | Six-session lesson plan for the course |
| `datamining-lect1.pptx` | Lecture 1 slides: introduction to data mining |
| `1. Formative and Summative Assessment/` | Formative and summative assessment documents plus the CSV datasets for the summative assignment tasks |

## R Scripts

Six commented, beginner-friendly R scripts in the `R_Scripts/` folder. Each file runs on its own with `Rscript <file>` or line by line in RStudio. Only base R is needed (no extra packages).

| File | Topic | Data used |
|---|---|---|
| `01_Hypothesis_Testing_One_Sample.R` | Z test, t test and proportion test for one sample | Small hand-typed examples |
| `02_Hypothesis_Testing_Two_Sample.R` | F test for variances, two-sample Z and t tests, paired t test, two-proportion test | Small hand-typed examples |
| `03_One_Way_ANOVA.R` | Comparing three or more means, Tukey post-hoc, assumption checks | Built-in `PlantGrowth` |
| `04_Two_Way_ANOVA.R` | Two factors, interaction effect, interaction plot | Built-in `ToothGrowth` |
| `05_Linear_Regression.R` | Simple and multiple regression, model comparison, diagnostics, prediction | Built-in `mtcars` |
| `06_Logistic_Regression.R` | Binary outcome, odds ratios, train/test split, confusion matrix | Pima Indians Diabetes (downloaded from the web, falls back to `mtcars` if offline) |
