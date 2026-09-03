############################################################
#  FILE 0 : R BASICS - COMPLETE REFERENCE IN ONE FILE
#
#  Everything a beginner needs before the six topic files :
#
#    PART A  R AS A CALCULATOR AND BASIC MATHS
#      1. Arithmetic            2. Maths functions
#      3. Rounding              4. Comparison and logic
#
#    PART B  DATA STRUCTURES
#      5. Variables and types   6. Vectors
#      7. Sequences and repeat  8. Matrices
#      9. Lists                10. Data frames
#     11. Factors              12. Missing values (NA)
#
#    PART C  PROGRAMMING
#     13. if / else            14. for loops
#     15. while and repeat     16. Writing functions
#     17. apply family         18. Strings
#     19. Dates
#
#    PART D  PACKAGES, DATA SETS AND FILES
#     20. Packages             21. Built-in data sets
#     22. Reading and writing files
#     23. Getting help
#
#    PART E  STATISTICS
#     24. Descriptive statistics  25. Frequency tables
#     26. Correlation and covariance
#     27. Probability distributions
#     28. Random sampling
#     29. Basic plots
#     30. Statistical tests (quick map to files 1 to 6)
#
#  Run it line by line in RStudio. Every section is
#  independent, so you can jump to what you need.
############################################################


############################################################
#  PART A : R AS A CALCULATOR AND BASIC MATHS
############################################################

# ---- 1. Arithmetic ---------------------------------------
2 + 3          # addition        5
7 - 4          # subtraction     3
6 * 8          # multiplication  48
9 / 2          # division        4.5
2 ^ 10         # power           1024   (2 ** 10 also works)
17 %% 5        # remainder       2      (modulo)
17 %/% 5       # integer division 3

# Order of operations is the usual BODMAS
(2 + 3) * 4    # 20
2 + 3 * 4      # 14

# ---- 2. Maths functions ----------------------------------
sqrt(144)      # square root    12
abs(-7.5)      # absolute value 7.5
exp(1)         # e^1            2.718282
log(100)       # NATURAL log    4.60517
log10(100)     # log base 10    2
log2(8)        # log base 2     3
log(8, base = 2)   # same        3
factorial(5)   # 5! = 120
choose(5, 2)   # combinations 5C2 = 10
pi             # 3.141593
sin(pi / 2)    # 1   (angles are in RADIANS)
cos(0)         # 1
tan(pi / 4)    # 1
1e6            # scientific notation : 1,000,000
5 / 0          # Inf
-5 / 0         # -Inf
0 / 0          # NaN  (not a number)

# ---- 3. Rounding -----------------------------------------
round(3.14159, 2)   # 3.14
signif(123456, 2)   # 120000  (2 significant figures)
ceiling(3.2)        # 4  (round up)
floor(3.8)          # 3  (round down)
trunc(-3.8)         # -3 (cut off decimals)

# ---- 4. Comparison and logic -----------------------------
5 > 3          # TRUE
5 == 5         # TRUE   (two equals signs test equality)
5 != 3         # TRUE   (not equal)
5 >= 5         # TRUE
TRUE & FALSE   # AND -> FALSE
TRUE | FALSE   # OR  -> TRUE
!TRUE          # NOT -> FALSE
xor(TRUE, TRUE)  # exclusive or -> FALSE
# TRUE counts as 1 and FALSE as 0 when you do maths with them
sum(c(TRUE, TRUE, FALSE))   # 2


############################################################
#  PART B : DATA STRUCTURES
############################################################

# ---- 5. Variables and data types -------------------------
# Assign with  <-  (preferred) or  =
x <- 10
name <- "Milan"
is_ok <- TRUE

class(x)       # "numeric"
class(name)    # "character"
class(is_ok)   # "logical"
class(5L)      # "integer"  (the L makes it an integer)
class(2 + 3i)  # "complex"

# Converting between types
as.numeric("3.5")     # 3.5
as.character(42)      # "42"
as.integer(3.9)       # 3  (truncates)
as.logical("TRUE")    # TRUE
as.numeric("abc")     # NA with a warning : cannot convert

# See what is in memory
ls()
rm(x)          # remove a variable

# ---- 6. Vectors ------------------------------------------
# A vector is an ordered set of values of ONE type.
v <- c(4, 8, 15, 16, 23, 42)      # c() = combine
length(v)      # 6
v[1]           # first element  -> 4   (R counts from 1, not 0)
v[2:4]         # elements 2 to 4
v[-1]          # everything EXCEPT the first
v[c(1, 6)]     # first and last
v[v > 10]      # elements greater than 10  (logical indexing)
which(v > 10)  # POSITIONS of elements greater than 10

# Vector arithmetic works element by element
v * 2
v + c(1, 2, 3, 4, 5, 6)
sum(v); mean(v); max(v); min(v); range(v)
cumsum(v)      # running total
rev(v)         # reverse
sort(v, decreasing = TRUE)
order(v)       # positions that would sort it

# Named vectors
ages <- c(Ana = 25, Ben = 32, Cid = 41)
ages["Ben"]
names(ages)

# ---- 7. Sequences and repeats ----------------------------
1:10                       # 1 2 3 ... 10
seq(0, 1, by = 0.25)       # 0 0.25 0.5 0.75 1
seq(1, 100, length.out = 5)
rep("A", times = 3)        # "A" "A" "A"
rep(c(1, 2), times = 3)    # 1 2 1 2 1 2
rep(c(1, 2), each = 3)     # 1 1 1 2 2 2

# ---- 8. Matrices -----------------------------------------
# A matrix is a 2-D table of ONE type.
m <- matrix(1:6, nrow = 2, ncol = 3)      # fills column by column
m
matrix(1:6, nrow = 2, byrow = TRUE)       # fills row by row
dim(m)         # 2 3
m[1, 2]        # row 1, column 2
m[1, ]         # whole row 1
m[, 2]         # whole column 2
t(m)           # transpose
m * 2          # element-wise
m %*% t(m)     # MATRIX multiplication
rowSums(m); colSums(m); rowMeans(m); colMeans(m)
rbind(m, c(7, 8, 9))     # add a row
cbind(m, c(7, 8))        # add a column

# Solving a linear system  A x = b
A <- matrix(c(2, 1, 1, 3), nrow = 2)
b <- c(5, 10)
solve(A, b)              # x
solve(A)                 # inverse of A
det(A)                   # determinant

# ---- 9. Lists --------------------------------------------
# A list can hold DIFFERENT types and even other lists.
person <- list(name = "Ana", age = 25, scores = c(90, 85, 77))
person$name
person[["age"]]
person$scores[2]
length(person)
str(person)              # structure : the best way to look inside a list

# ---- 10. Data frames -------------------------------------
# The most important structure : a table where each column
# can have a different type. This is what read.csv() gives you.
students <- data.frame(
  name   = c("Ana", "Ben", "Cid", "Dee"),
  age    = c(25, 32, 41, 29),
  score  = c(90, 72, 85, 60),
  passed = c(TRUE, TRUE, TRUE, FALSE)
)
students
str(students)
summary(students)
nrow(students); ncol(students); dim(students)
names(students)          # column names
head(students, 2)        # first 2 rows
tail(students, 2)        # last 2 rows

# Picking columns
students$score
students[, "score"]
students[, c("name", "score")]

# Picking rows
students[2, ]                        # row 2
students[students$score > 80, ]      # rows where score > 80
subset(students, age < 35, select = c(name, age))

# Adding and changing columns
students$grade <- ifelse(students$score >= 80, "A", "B")
students$age_in_months <- students$age * 12
students

# Sorting
students[order(students$score, decreasing = TRUE), ]

# Group summaries
aggregate(score ~ grade, data = students, FUN = mean)
tapply(students$score, students$grade, mean)

# Joining two data frames on a common column
extra <- data.frame(name = c("Ana", "Ben"), city = c("Pune", "Delhi"))
merge(students, extra, by = "name")               # inner join
merge(students, extra, by = "name", all.x = TRUE) # left join

# ---- 11. Factors -----------------------------------------
# A factor is a categorical variable with fixed levels.
# Statistical functions (ANOVA, regression) need factors.
size <- factor(c("small", "large", "medium", "small"),
               levels = c("small", "medium", "large"))   # set the order
size
levels(size)
table(size)              # counts per level
as.integer(size)         # the underlying codes 1 2 3
# Convert a number column to a factor
students$passed_f <- factor(students$passed, labels = c("No", "Yes"))

# ---- 12. Missing values (NA) -----------------------------
y <- c(3, NA, 7, NA, 10)
is.na(y)                 # TRUE where missing
sum(is.na(y))            # how many missing : 2
mean(y)                  # NA  (any NA poisons the result)
mean(y, na.rm = TRUE)    # 6.667  (remove NA first)
y[!is.na(y)]             # drop the NAs
na.omit(y)
# In a data frame :
df_na <- data.frame(a = c(1, NA, 3), b = c("x", "y", NA))
colSums(is.na(df_na))    # missing per column
complete.cases(df_na)    # rows with no NA
na.omit(df_na)           # keep only complete rows


############################################################
#  PART C : PROGRAMMING
############################################################

# ---- 13. if / else ---------------------------------------
marks <- 67
if (marks >= 80) {
  cat("Grade A\n")
} else if (marks >= 60) {
  cat("Grade B\n")
} else {
  cat("Grade C\n")
}

# ifelse() is the VECTOR version : works on a whole column at once
scores <- c(45, 88, 62, 91)
ifelse(scores >= 60, "pass", "fail")

# switch() for many fixed choices
day <- "tue"
switch(day, mon = "Monday", tue = "Tuesday", "Other day")

# ---- 14. for loops ---------------------------------------
# Repeat a block once for each element.
for (i in 1:5) {
  cat("Square of", i, "is", i^2, "\n")
}

# Loop over a vector of names
fruits <- c("apple", "banana", "cherry")
for (f in fruits) {
  cat("I like", f, "\n")
}

# Loop with an index and store results
squares <- numeric(5)           # empty vector of length 5
for (i in 1:5) {
  squares[i] <- i^2
}
squares

# Loop over the columns of a data frame
for (col in names(students)) {
  cat(col, ":", class(students[[col]]), "\n")
}

# Nested loop : multiplication table
for (i in 1:3) {
  for (j in 1:3) {
    cat(i * j, "\t")
  }
  cat("\n")
}

# ---- 15. while and repeat --------------------------------
# while : keep going as long as the condition is TRUE
n <- 1
while (n < 100) {
  n <- n * 2
}
n                       # 128

# repeat : loop forever until break
count <- 0
repeat {
  count <- count + 1
  if (count == 3) break       # break = leave the loop
}
count

# next = skip the rest of THIS iteration
for (i in 1:6) {
  if (i %% 2 == 0) next       # skip even numbers
  cat(i, "is odd\n")
}

# NOTE : in R, most loops can be replaced by vectorised code.
#   for (i in 1:5) squares[i] <- i^2      is the same as
#   squares <- (1:5)^2                    which is faster and shorter.

# ---- 16. Writing functions -------------------------------
# function(arguments) { body ; return(value) }
add_two <- function(a, b) {
  result <- a + b
  return(result)
}
add_two(3, 4)

# Default argument values
greet <- function(name, greeting = "Hello") {
  paste(greeting, name)
}
greet("Ana")
greet("Ana", greeting = "Namaste")

# The last expression is returned automatically
bmi <- function(weight_kg, height_m) weight_kg / height_m^2
bmi(70, 1.75)

# A function that returns several things : use a list
describe <- function(x) {
  list(mean = mean(x), sd = sd(x), n = length(x))
}
describe(c(5, 7, 9, 11))

# Functions can take other functions as arguments
apply_twice <- function(f, x) f(f(x))
apply_twice(sqrt, 81)           # sqrt(sqrt(81)) = 3

# Variable scope : a variable made inside a function
# does not exist outside it
scope_demo <- function() { inside <- 1; inside }
scope_demo()
# exists("inside")   -> FALSE

# ---- 17. The apply family (loops without loops) ----------
m <- matrix(1:6, nrow = 2)
apply(m, 1, sum)          # apply to each ROW    (1 = rows)
apply(m, 2, sum)          # apply to each COLUMN (2 = columns)

lst <- list(a = 1:5, b = 10:20)
lapply(lst, mean)         # returns a LIST
sapply(lst, mean)         # returns a VECTOR (simplified)

sapply(students[, c("age", "score")], mean)   # column means

# mapply : apply over several vectors in parallel
mapply(function(x, y) x + y, 1:3, 4:6)

# tapply : apply per group
tapply(students$score, students$grade, mean)

# ---- 18. Strings -----------------------------------------
s <- "Data Mining"
nchar(s)                        # number of characters 11
toupper(s); tolower(s)
substr(s, 1, 4)                 # "Data"
paste("a", "b", "c")            # "a b c"
paste0("a", "b", "c")           # "abc"  (no separator)
paste("x", 1:3, sep = "_")      # "x_1" "x_2" "x_3"
strsplit("a,b,c", ",")          # split into pieces
gsub("Mining", "Science", s)    # replace text
grepl("Min", s)                 # TRUE if pattern is found
sprintf("Mean = %.2f", 3.14159) # formatted : "Mean = 3.14"
trimws("  hi  ")                # remove surrounding spaces
format(1234567.891, big.mark = ",")   # "1,234,568"

# ---- 19. Dates -------------------------------------------
today <- Sys.Date()
today
class(today)                    # "Date"
d <- as.Date("2026-09-03")
d + 30                          # 30 days later
format(d, "%d %B %Y")           # "03 September 2026"
weekdays(d)
months(d)
difftime(as.Date("2026-12-31"), d, units = "days")
seq(d, by = "month", length.out = 3)
as.Date("03/09/2026", format = "%d/%m/%Y")   # parse other formats
Sys.time()                      # date AND time


############################################################
#  PART D : PACKAGES, DATA SETS AND FILES
############################################################

# ---- 20. Packages ----------------------------------------
# A package is a collection of extra functions.
# Install ONCE (needs internet), load EVERY session.
#
#   install.packages("ggplot2")      # install (run once)
#   library(ggplot2)                 # load (every session)
#
# Check if a package is installed before loading it :
if (requireNamespace("ggplot2", quietly = TRUE)) {
  library(ggplot2)
  cat("ggplot2 is available\n")
} else {
  cat("ggplot2 is not installed. Run install.packages('ggplot2')\n")
}

# Popular packages and what they do
#   ggplot2    : beautiful plots
#   dplyr      : data manipulation (filter, select, mutate, group_by)
#   tidyr      : reshaping data (wide <-> long)
#   readr      : fast reading of csv files
#   readxl     : reading Excel files
#   stringr    : string handling
#   lubridate  : dates
#   car        : Levene test, VIF for regression
#   MASS       : extra statistical functions and data sets
#   caret      : machine learning workflow
#   randomForest, rpart : tree models
#   tidyverse  : installs ggplot2, dplyr, tidyr, readr and more together

# Useful package commands
# installed.packages()[, "Package"]   # what is installed
# packageVersion("stats")             # version of a package
# update.packages()                   # update everything
# detach("package:ggplot2")           # unload

# ---- 21. Built-in data sets ------------------------------
# R ships with many data sets for practice.  data() lists them.
# data()                       # opens the full list

data("mtcars")      # 32 cars, fuel economy and engine specs
data("iris")        # 150 flowers, 4 measurements, 3 species
data("ToothGrowth") # guinea pig tooth growth (two way ANOVA)
data("PlantGrowth") # plant weight in 3 groups (one way ANOVA)
data("airquality")  # daily air quality in New York (has NAs)
data("women")       # height and weight of 15 women
data("faithful")    # Old Faithful geyser eruptions
data("ChickWeight") # chick weights over time
data("Titanic")     # survival counts (a table)

head(iris)
str(mtcars)
?iris               # documentation of a data set

# ---- 22. Reading and writing files -----------------------
# Where am I ?  Which folder does R read from ?
getwd()
# setwd("C:/Users/YourName/Documents")     # change the folder

# Write a data frame to a csv file
write.csv(students, "students.csv", row.names = FALSE)

# Read it back
students2 <- read.csv("students.csv")
head(students2)

# Other formats
# read.csv("file.csv", sep = ";")            # semicolon separated
# read.table("file.txt", header = TRUE)      # space / tab separated
# read.delim("file.tsv")                     # tab separated
# readxl::read_excel("file.xlsx")            # Excel (needs readxl)
# readRDS("file.rds") / saveRDS(obj, "file.rds")   # R's own format
# read.csv("https://example.com/data.csv")   # straight from the web

# List files in the current folder
list.files()
file.exists("students.csv")
file.remove("students.csv")     # tidy up

# ---- 23. Getting help ------------------------------------
?mean                 # help page for a function
help(mean)            # same
example(mean)         # run the examples from the help page
args(round)           # the arguments of a function
??regression          # search all help pages for a word
# apropos("test")     # every function whose name contains "test"


############################################################
#  PART E : STATISTICS
############################################################

# ---- 24. Descriptive statistics --------------------------
x <- c(12, 15, 11, 18, 20, 15, 22, 15, 17, 14)

# Measures of centre
mean(x)                       # average
median(x)                     # middle value
# R has no built-in mode function, so we write one
get_mode <- function(v) {
  counts <- table(v)
  as.numeric(names(counts)[counts == max(counts)])
}
get_mode(x)                   # 15

# Measures of spread
range(x)                      # min and max
diff(range(x))                # max - min
var(x)                        # sample variance   (divides by n - 1)
sd(x)                         # sample standard deviation
IQR(x)                        # inter-quartile range Q3 - Q1
quantile(x)                   # 0 % 25 % 50 % 75 % 100 %
quantile(x, c(0.1, 0.9))      # 10th and 90th percentile
mad(x)                        # median absolute deviation (robust)
sd(x) / mean(x) * 100         # coefficient of variation in %

# Shape
# Skewness and kurtosis are not in base R.  By hand :
skewness <- function(v) mean((v - mean(v))^3) / sd(v)^3
kurtosis <- function(v) mean((v - mean(v))^4) / sd(v)^4 - 3
skewness(x)                   # > 0 : right tail, < 0 : left tail
kurtosis(x)                   # > 0 : heavier tails than normal

# All at once
summary(x)
# Standardise (z-scores) : mean 0, sd 1
scale(x)[, 1]

# Descriptives for every column of a data frame
summary(mtcars[, 1:4])
sapply(mtcars[, 1:4], sd)
colMeans(mtcars[, 1:4])

# Weighted mean
weighted.mean(c(80, 90, 70), w = c(1, 2, 1))

# ---- 25. Frequency tables --------------------------------
table(mtcars$cyl)                        # counts
prop.table(table(mtcars$cyl))            # proportions
round(100 * prop.table(table(mtcars$cyl)), 1)   # percentages

# Two-way (cross) table
table(mtcars$cyl, mtcars$am)
xtabs(~ cyl + am, data = mtcars)         # same, with labels
addmargins(table(mtcars$cyl, mtcars$am)) # with row and column totals

# Binning a numeric variable into classes
cut(mtcars$mpg, breaks = c(10, 15, 20, 25, 35))
table(cut(mtcars$mpg, breaks = c(10, 15, 20, 25, 35)))

# ---- 26. Correlation and covariance ----------------------
cov(mtcars$mpg, mtcars$wt)               # covariance
cor(mtcars$mpg, mtcars$wt)               # Pearson correlation  -0.87
cor(mtcars$mpg, mtcars$wt, method = "spearman")  # rank based
cor(mtcars[, c("mpg", "wt", "hp")])      # correlation matrix
cor.test(mtcars$mpg, mtcars$wt)          # is the correlation significant ?

# ---- 27. Probability distributions -----------------------
# Every distribution has 4 functions with a prefix :
#   d = density / probability   (height of the curve at x)
#   p = cumulative probability  P(X <= x)
#   q = quantile                (inverse of p)
#   r = random numbers

# NORMAL  (mean, sd)
dnorm(0)                      # density at 0 : 0.399
pnorm(1.96)                   # P(Z <= 1.96) = 0.975
pnorm(1.96, lower.tail = FALSE)   # P(Z > 1.96) = 0.025
qnorm(0.975)                  # 1.96  (the 97.5th percentile)
pnorm(70, mean = 60, sd = 10) # P(X <= 70) for N(60, 10)
rnorm(5, mean = 60, sd = 10)  # 5 random values

# BINOMIAL  (size = number of trials, prob = success probability)
dbinom(3, size = 10, prob = 0.5)     # P(exactly 3 heads in 10 tosses)
pbinom(3, size = 10, prob = 0.5)     # P(3 or fewer heads)
qbinom(0.5, size = 10, prob = 0.5)   # median number of heads
rbinom(5, size = 10, prob = 0.5)

# POISSON  (lambda = average rate)
dpois(2, lambda = 3)          # P(exactly 2 events) when average is 3
ppois(2, lambda = 3)          # P(2 or fewer)

# UNIFORM
runif(5, min = 0, max = 1)
punif(0.3)

# EXPONENTIAL
pexp(2, rate = 0.5)

# t, CHI-SQUARE and F  (used in hypothesis tests)
qt(0.975, df = 10)            # critical t value, 10 df : 2.228
pt(2.5, df = 10)              # P(t <= 2.5)
qchisq(0.95, df = 3)          # critical chi-square : 7.815
qf(0.95, df1 = 2, df2 = 27)   # critical F value

# ---- 28. Random sampling ---------------------------------
set.seed(42)                  # makes random results REPEATABLE
sample(1:10, 3)               # 3 numbers from 1 to 10, no repeats
sample(1:6, 10, replace = TRUE)      # 10 dice rolls
sample(c("H", "T"), 5, replace = TRUE)   # coin flips
sample(nrow(mtcars), 5)       # 5 random row numbers
mtcars[sample(nrow(mtcars), 5), ]    # 5 random rows

# Simulate the Central Limit Theorem : means of samples are normal
sample_means <- replicate(1000, mean(runif(30)))
hist(sample_means, col = "lightblue", main = "Means of 1000 samples")

# ---- 29. Basic plots -------------------------------------
# Histogram
hist(mtcars$mpg, breaks = 8, col = "steelblue",
     main = "Histogram of mpg", xlab = "mpg")

# Box plot (single and by group)
boxplot(mtcars$mpg, main = "Box plot of mpg")
boxplot(mpg ~ cyl, data = mtcars, col = "lightgreen",
        main = "mpg by cylinders")

# Scatter plot with a fitted line
plot(mtcars$wt, mtcars$mpg, pch = 16, col = "darkblue",
     xlab = "Weight", ylab = "mpg", main = "mpg vs weight")
abline(lm(mpg ~ wt, data = mtcars), col = "red", lwd = 2)

# Bar chart
barplot(table(mtcars$cyl), col = c("tan", "orange", "brown"),
        main = "Number of cars by cylinders")

# Pie chart
pie(table(mtcars$gear), main = "Cars by gears")

# Line chart
plot(1:10, (1:10)^2, type = "l", lwd = 2, col = "purple",
     main = "Line plot")
# type = "p" points, "l" line, "b" both, "h" bars from zero

# Several plots in one window
par(mfrow = c(1, 2))
hist(mtcars$hp, main = "hp")
boxplot(mtcars$hp, main = "hp")
par(mfrow = c(1, 1))         # back to one plot

# Scatter plot matrix
pairs(mtcars[, c("mpg", "wt", "hp")])

# Save a plot to a file
# png("myplot.png", width = 700, height = 500)
# plot(...)
# dev.off()

# Common plot arguments
#   main = title      xlab / ylab = axis labels
#   col  = colour     pch = point shape (16 = filled circle)
#   lwd  = line width lty = line type (1 solid, 2 dashed)
#   xlim / ylim = axis ranges       cex = size
#   legend("topright", legend = c(...), col = c(...), pch = 16)

# ---- 30. Statistical tests : quick map -------------------
# The details are in the six topic files. Here is the index.
#
#  Question                                 Function            File
#  ---------------------------------------  ------------------  ----
#  Is one mean equal to a value ?           t.test(x, mu = )     1
#  Is one proportion equal to a value ?     prop.test / binom.test 1
#  Are two variances equal ?                var.test(x, y)       2
#  Are two means equal ?                    t.test(x, y)         2
#  Before / after on same subjects ?        t.test(paired = TRUE) 2
#  Are two proportions equal ?              prop.test(c(),c())   2
#  Are 3+ means equal ? (one factor)        aov(y ~ g)           3
#  Two factors and interaction ?            aov(y ~ A * B)       4
#  Predict a number ?                       lm(y ~ x)            5
#  Predict yes / no ?                       glm(family=binomial) 6
#  Is a variable normal ?                   shapiro.test(x)      3
#  Are two categorical variables related ?  chisq.test(table)    -
#  Non-parametric two groups ?              wilcox.test(x, y)    -
#  Non-parametric 3+ groups ?               kruskal.test(y ~ g)  3
#  Is a correlation significant ?           cor.test(x, y)       here

# Two tests not covered elsewhere, shown quickly :
chisq.test(table(mtcars$cyl, mtcars$am))          # independence
wilcox.test(mpg ~ am, data = mtcars)              # non-parametric t

cat("\nEnd of the R basics reference. Continue with FILE 1.\n")
