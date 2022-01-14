# -------- IMPORTANT --------- IMPORTANT --------- IMPORTANT
# If you are running this file first time, kindly uncomment below installation commands.
# For uncommenting the commands remove the # from beginning of the below commands.

# install.packages("pastecs")
# install.packages("stringr")
# install.packages("dplyr")
# install.packages("ggplot2")
# install.packages("GGally")
# install.packages("FactoMineR")


# All libraries that we required
library(pastecs)
library(stringr)
library(dplyr)
library(ggplot2)
library(GGally)
library(FactoMineR)


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
cols.num <- c("life_expectancy","adult_mortality","alcohol","percentage_expenditure","hepatitis_b","bmi","polio","total_expenditure","diphtheria","gdp","population","schooling")
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

# Removing year column, we dont need it for now
data_without_error = subset(data, select = -c(year))

# Average life expectancy of all over the worlds
mean(data_without_error$life_expectancy)

# Check the avg life expectancy by countries
# We can able to see that the life expectancy in developed countries is 20% greater than developing countries.
png(file="Rplot2.png")
data_without_error %>%
  group_by(status) %>%
  summarise(average_life_expectancy = mean(life_expectancy)) %>%
  ggplot(aes(x = status, y = average_life_expectancy, fill = status)) +
  geom_bar(stat = "identity") +
  theme_classic() +
  labs(
    x = "Status",
    y = "Average Life Expectancy",
    title = paste(
      "Analysing the life expectancy in developed and developing countries"
    )
  )
dev.off()
# ---------------*** Why life expectancy is greater in developed nations ***---------------
# Now on previous step we able to know that life expectancy in developed countries is 20% greater than developing countries.
# We have to check now WHY?

# Creating dataset for correlation
# We have to remove character datatype columns like country and status
cor_dataset <- data
cor_dataset = subset(cor_dataset, select = -c(country, status, year))

# Convert required columns into numerical format.
cor_dataset[cols.num] <- sapply(cor_dataset[cols.num],as.numeric)

# Printing correlation
round(cor(cor_dataset),
      digits = 2 # rounded to 2 decimals
)

whole_data <- data


# ---------------*** Feature Selection ***---------------

# Convert required columns into numerical format.
whole_data[cols.num] <- sapply(whole_data[cols.num],as.numeric)

# All countries need to reach ≥90% national coverage for all vaccines in the country’s routine immunization schedule by 2020. Based on that statement, we are going to mutate the Hepatitis.B, Polio, and Diphtheria into a categorical variable, with 2 value: “Under 90% Covered” and “Covered by 90% or More”. By doing this, hopefully we can get a better view on the immunization impact to Life.expectancy.
# Data Wrangling
life_selected <- whole_data %>%
  select(-whole_data$Country, -whole_data$Year) %>%
  mutate(Hepatitis.B = ifelse(whole_data$hepatitis_b < 90, "<90% Covered", ">=90% Covered"),
         Polio = ifelse(whole_data$polio < 90, "<90% Covered", ">=90% Covered"),
         Diphtheria = ifelse(whole_data$diphtheria < 90, "<90% Covered", ">=90% Covered"),
         Hepatitis.B = as.factor(whole_data$hepatitis_b),
         Polio = as.factor(whole_data$polio),
         Diphtheria = as.factor(whole_data$diphtheria))

str(life_selected)

# Mutate hepatitis_b:  Range between min value & the Quartile is very wide have to be manipulated.
# Mutate diphtheria -> Range between min value & the Quartile is very wide have to be manipulated.
# Mutate polio: Range between min value & the Quartile is very wide have to be manipulated.

# ---------------*** Correlations and Variances ***---------------

data_num <- life_selected %>%
  select_if(is.numeric)

# Looks like life_expectancy dependent variable strong positive with alcohol (0.36), polio (0.43), diphtheria (0.44), schooling (0.56)
png(file="Rplot3.png")
ggcorr(data_num,
       label = T,
       label_size = 2,
       label_round = 2,
       hjust = 1,
       size = 3,
       color = "royalblue",
       layout.exp = 5,
       low = "green3",
       mid = "gray95",
       high = "darkorange",
       name = "Correlation")

dev.off()
# Taking one developed country data
# We are going to take United Kingdom of Great Britain and Northern Ireland data
UK_data <- life_selected

# Filtering and taking only UK's data
UK_data <- subset( UK_data, country == "United Kingdom of Great Britain and Northern Ireland")

# Convert required columns into numerical format.
UK_data[cols.num] <- sapply(UK_data[cols.num],as.numeric)

# Here we can able to analysed that life expectancy is increasing till 2013 and suddenly it gets decreased.
# WHY suddenly it gets decreased after 2013
# Why its increasing till 2013
png(file="Rplot4.png")
ggplot(UK_data, aes(year, life_expectancy)) + geom_line() + scale_x_continuous(labels=UK_data$year,breaks=UK_data$year)
dev.off()

# Correlation graph
png(file="Rplot5.png")
ggcorr(UK_data,
       label = T,
       label_size = 2,
       label_round = 2,
       hjust = 1,
       size = 3,
       color = "royalblue",
       layout.exp = 5,
       low = "green3",
       mid = "gray95",
       high = "darkorange",
       name = "Correlation")
dev.off()
# Looks like the dependent variable life expectancy is strongly correlated with measles (0.89), polio (0.82), diphtheria (0.82)
# We can able to see dependent variable life expectancy is negatively correlated with adult_mortality, which is valid because if mortality rate of adults is high, then the life expectancy of people will be low.

# Now
# Taking one developing country data
# We are going to take Afghanistan data
Afghanistan_data <- life_selected

# Filtering and taking only UK's data
Afghanistan_data <- subset( Afghanistan_data, country == "Afghanistan")

# Convert required columns into numerical format.
Afghanistan_data[cols.num] <- sapply(Afghanistan_data[cols.num],as.numeric)

# Here we can able to analysed that life expectancy is increasing till 2013 and suddenly it gets decreased.
# WHY suddenly it gets increased after 2013
png(file="Rplot6.png")
ggplot(Afghanistan_data, aes(year, life_expectancy)) + geom_line() + scale_x_continuous(labels=Afghanistan_data$year,breaks=Afghanistan_data$year)
dev.off()

# Correlation graph
png(file="Rplot7.png")
ggcorr(Afghanistan_data,
       label = T,
       label_size = 2,
       label_round = 2,
       hjust = 1,
       size = 3,
       color = "royalblue",
       layout.exp = 5,
       low = "green3",
       mid = "gray95",
       high = "darkorange",
       name = "Correlation")

dev.off()
# Looks like the dependent variable life expectancy is strongly correlated with percentage_expenditure (0.89), gdp (0.68), diphtheria (0.81), schooling(0.84)
# We can able to see dependent variable life expectancy is negatively correlated with adult_mortality, which is valid because if mortality rate of adults is high, then the life expectancy of people will be low.




# ---------------*** Model Creation ***---------------
# we are going to predict the Life.expectancy by using Selected Variables. And this is the full linear prediction model.
life_model <- lm(life_selected$life_expectancy ~  life_selected$life_expectancy + life_selected$adult_mortality + life_selected$alcohol + life_selected$percentage_expenditure + life_selected$hepatitis_b + life_selected$bmi + life_selected$polio + life_selected$total_expenditure + life_selected$diphtheria + life_selected$gdp + life_selected$population + life_selected$schooling, data = life_selected)
summary(life_model)

# Coefficients interpretaions: Regarding Coefficients the interesting analysis is adult_mortality, total_expenditure, population may give negative effects, Indicating additional of these variables may lead to decrease the Life expectancy. gdp and hepatitis_b has a big positive effect on the Life expectancy.
# Adj. R-squared interpretation: Approximately 58.6% of the observed variation can be explained by the model’s inputs, this is a not better but we can say good result But still indicating that we are on the right path to create good linear model.
# Significancies of Predictors: adult_mortality, alcohol, polio, total_expenditure, diphtheria and schooling As seen on the p-value and this are the most significant Predictors.



# ---------------*** Checking the statistical significance ***---------------

life_full <- lm(formula = life_expectancy ~., data = life_selected)
life_none <- lm(formula = life_expectancy ~1, data = life_selected)
#Backward direction
model_backward <- step(life_full, direction = "backward")
summary(model_backward)

#Forward Direction
model_forward <- step(life_none, scope = list(lower = life_none, upper = life_full) ,direction = "forward")
summary(model_forward)

# Both Direction
model_both <- step(life_full, scope = list(lower = life_none, upper = life_full) ,direction = "both")
summary(model_both)



# ---------------*** checking assumption ***---------------
# Most of the Residuals seems distributed on the center, indicates they are distributed normally.
png(file="Rplot9.png")
hist(model_backward$residuals, breaks = 20)
dev.off

# Most of the residuals gathered on the center line, indicates they are distributed normally
png(file="Rplot10.png")
plot(model_backward, which = 2)
dev.off()

# Most of the residuals gathered on the center line, indicates they are distributed normally
png(file="Rplot11.png")
plot(model_both, which = 2)
dev.off()

# Based on Shapiro-Wilk normality test, the p-value < 0.05 implying that the distribution of the data are significantly different from normal distribution. Therefore, we need to do some adjustment to data.
shapiro.test(model_backward$residuals)

# Remove Outliers
# We will try to remove the Outliers that keeped on previous findings.
png(file="Rplot12.png")
boxplot(life_selected$life_expectancy, ylab = "Life Expectancy (Age)") # visual boxplot
dev.off()

outliers_out <- boxplot(life_selected$life_expectancy, plot = F)$out # untuk mendaptkan outlier
life_clean <- life_selected[-which(life_selected$life_expectancy %in% outliers_out), ] # remove outlier dari data

# Let us see the Boxplot after Outliers taken
png(file="Rplot13.png")
boxplot(life_clean$life_expectancy, ylab = "Life Expectancy (Age)") # visual boxplot
dev.off()

# Create Model Based on Selected Variables:
model_regs <- lm(formula = life_expectancy ~ adult_mortality + alcohol + percentage_expenditure + bmi + diphtheria + hiv_aids + schooling, data = life_selected)
summary(model_regs)

# RegBest (FactoMineR)
# We sould like to see, if we are only using numeric variables, which Variables that will come out as the best.
regMod <- RegBest(y=data_num[,1], x = data_num[ ,-1])
# regMod$best
# alcohol           -2.044e-01  2.225e-02   -9.189  < 2e-16 ***
#   hepatitis_b        3.874e-02  2.258e-03   17.162  < 2e-16 ***
#   polio             -1.129e-02  3.774e-03   -2.993  0.00278 **
#   total_expenditure -1.263e-01  2.934e-02   -4.303 1.74e-05 ***
#   hiv_aids          -6.467e-02  1.583e-02   -4.085 4.52e-05 ***
#   gdp                4.121e-05  6.536e-06    6.305 3.31e-10 ***
#   schooling          1.070e-01  2.210e-02    4.842 1.35e-06 ***

# Create Model Based on Selected Variables:
model_regMod <- lm(formula = life_expectancy ~ hiv_aids + schooling, data = life_selected)
summary(model_regMod)

# From the given Result, we will choose model forward as our model to predict the `Life.expectancy.
data.frame(model = c("model_backward","model_forward","model_both", "model_regs", "model_regMod"),
           AdjRsquare = c(summary(model_backward)$adj.r.square,
                          summary(model_forward)$adj.r.square,
                          summary(model_both)$adj.r.square,
                          summary(model_regs)$adj.r.square,
                          summary(model_regMod)$adj.r.square))
# model AdjRsquare
# 1 model_backward  0.9690188
# 2  model_forward  0.9690413
# 3     model_both  0.9690413
# 4     model_regs  0.6310699
# 5   model_regMod  0.4919425
