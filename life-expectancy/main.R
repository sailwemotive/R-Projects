# -------- IMPORTANT --------- IMPORTANT --------- IMPORTANT
# If you are running this file first time, kindly uncomment below installation commands.
# For uncommenting the commands remove the # from beginning of the below commands.

# install.packages("pastecs")
# install.packages("stringr")
# install.packages("dplyr")


# All libraried the we required
library(pastecs)
library(stringr)
library(dplyr)

# To hide all the unnecessary warnings
options(warn=-1)

# Set current working directory.
setwd(getwd())

# We have read and store the data from CSV to data variable
data <- read.csv("life_expectancy.csv", na.strings = "")
print(data)

# The first thing that we should do is check the class of your data frame
class(data)

# Next, we want to check the number of rows and columns the data frame has.
dim(data)

# We can view the summary statistics for all the columns of the data frame
summary(data)

# Using above summary we can able to find out is database having correct column type or not
# like above life_expectancy has type character that is why we have to convert that into numerical.
# Converting all character type columns as a numerical type.
cols.num <- c("life_expectancy","adult_mortality","alcohol","hepatitis_b","bmi","polio","total_expenditure","diphtheria","gdp","population","schooling")
data[cols.num] <- sapply(data[cols.num],as.numeric)

# ---------------*** Started data cleaning process ***---------------

# Trimming the whitespaces
data$life_expectancy<-str_trim(data$life_expectancy)
data$percentage_expenditure<-str_trim(data$percentage_expenditure)
data$hepatitis_b<-str_trim(data$hepatitis_b)

# Here our plan is to fill out all missing values with mean of respective column, that is why why we have to follow below 4 steps,

# |-----> STEP 1
# Checking if dataset has any NA value
any(is.na(data$he))

# |-----> STEP 2
# Replacing all na values with 0
data[is.na(data)] <- 0

# |-----> STEP 3
# Once again converting values into numeric
data[cols.num] <- sapply(data[cols.num],as.numeric)

# |-----> STEP 4
# Filling out all missing values with mean of respective column
# Note that we are performing this oly for columns those has numerical data, it will help us to get proper stats.
for(b in cols.num){ data$b <- replace(data$b, data$b == 0, mean(data$b)) }

# Now check if our dataset having any missing value or na value or not
any(is.na(data))


# ---------------*** Ended data cleaning process ***---------------



# ---------------*** Statistics on given data ***---------------

# Average life expectancy
mean(data$life_expectancy)

# total cases and max single day by country

