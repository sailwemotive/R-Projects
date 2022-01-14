# Required packages (Uncomment below 3 line if your are running first time)
# install.packages("dplyr")
# install.packages("fastDummies")
# install.packages("ggplot2")

# Required Libraries 
library(ggplot2) # Visualizations
library(dplyr) # Data Preprocessing
library(fastDummies) # Converting categorical data into one hot encoding

plot_color <- theme(
  panel.background = element_rect(fill = "sky blue", colour = "sky blue", size = 0.5, linetype = "solid"),
  panel.grid.major = element_line(colour = "blue", size = 0.5, linetype = 'solid'), 
  panel.grid.minor = element_line(colour = "blue", size = 0.25, linetype = 'solid')
)

# Loading raw data from provided link
ice_cream_data <- "https://raw.githubusercontent.com/sedaerdem/Statistics/master/data/icecream.csv"
main_dataframe <- read.csv(ice_cream_data, sep = "," , stringsAsFactors = F)

# Now we are going to analyze the distribution of sales, countries, price & Income over Seasons


# --------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------

# A. Exploratory data analysis (EDA):

# --------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------


# ----------------------
#  Scatter Plot
# ----------------------

# Sales Vs Income
# We are going to analyse if the income has any effect over sales
ggplot(data = main_dataframe, aes(x = icecream_sales, y = income)) + geom_point() + plot_color

# Sales Vs Income over each country
# We are going to analyse their distribution separately
ggplot(data = main_dataframe, aes(x = icecream_sales, y = income, color = country)) + geom_point() + facet_wrap(~country) + plot_color

# Sales Vs Income over seasons
# We are going to analyse if the income has any effect over ice cream sales
ggplot(data = main_dataframe, aes(x = icecream_sales, y = income, color = seasons)) + geom_point() + facet_wrap(~seasons) + plot_color

# Sales Vs Average price over seasons & country
ggplot(data = main_dataframe, aes(x = icecream_sales, y = income, color = seasons)) + geom_point() + facet_wrap(country~seasons) + plot_color



# ----------------------
#  Jitter Plot
# ----------------------

# Sales over country
ggplot(data = main_dataframe, aes(x = country, y = icecream_sales, color = country)) + geom_boxplot() + geom_jitter() + plot_color

# Sales over Seasons
ggplot(data = main_dataframe, aes(x = seasons, y = icecream_sales, color = seasons)) + geom_boxplot() + geom_jitter() + plot_color

# Sales over country & seasons
ggplot(data = main_dataframe, aes(x = country, y = icecream_sales, color = country)) + geom_boxplot() + geom_jitter() + facet_wrap(~seasons,ncol = 3) + plot_color

# Average Price Over Country
ggplot(data = main_dataframe, aes(x = country, y = price, color = country)) + geom_boxplot() + geom_jitter() + plot_color

# Average Price Over Seasons
ggplot(data = main_dataframe, aes(x = seasons, y = price, color = seasons)) + geom_boxplot() + geom_jitter() + plot_color

# Average Price Over Country & Seasons
ggplot(data = main_dataframe, aes(x = country, y = price, color = country)) + geom_boxplot() + geom_jitter() + facet_wrap(~seasons,ncol = 3) + plot_color

# ----------------------
#  Density Plot
# ----------------------

# Sales over country 
ggplot(main_dataframe, aes(x = icecream_sales, color = country)) + geom_density() + plot_color

# Sales over seasons 
ggplot(main_dataframe, aes(x = icecream_sales, color = seasons)) + geom_density() + plot_color

# Sales over country & seasons 
ggplot(main_dataframe, aes(x = icecream_sales, color = country)) + geom_density()  + facet_wrap(~seasons,ncol = 3) + plot_color

# Average price over country 
ggplot(main_dataframe, aes(x = price, color = country)) + geom_density() + plot_color

# Average price over seasons
ggplot(main_dataframe, aes(x = price, color = seasons)) + geom_density() + plot_color

# Average price over country & seasons 
ggplot(main_dataframe, aes(x = price, color = country)) + geom_density()  + facet_wrap(~seasons,ncol = 3) + plot_color



# --------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------

# C: Modelling

# --------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------

# Here we are going to apply multi linear regression model

# Here in this step we are going to convert categorical country & season into one hot encoding 
main_dataframe <- main_dataframe %>% select(-ShopID)
ice_dataframe <- dummy_cols(main_dataframe) 

# Here in this step we are going to remove
ice_dataframe <- ice_dataframe %>% select(-country, -seasons)

# Dependent (target) variable
# icecream_sales

# Independent (target) variable used in multi-linear regression
# income price temperature  country_A  country_B   seasons_Autumn seasons_Spring seasons_Summer seasons_Winter

# Now we are going to build multi-linear regression model for predict sales

# Here in this step we are going to train the model on given data 
linear_regression_model <- lm(icecream_sales~., data =  ice_dataframe)
summary(linear_regression_model)

# Confidence intervals of regression coefficients at 90% confidence level
confint(linear_regression_model)


# ----------------------
# Q8. Test and explain if your data meets the regression conditions.
# ----------------------

# Here we are going to analyse whether data follows regression conditions
plot (linear_regression_model)



# ----------------------
# D. 
# Prediction: 
#       What is the predicted value of ice cream sales in a
#   location in Country A where the average income of residents is £30,000, the
#   temperature is 23 degrees in Spring, and average price per serving of ice cream is
#   £3? Also, quantify the uncertainty around this prediction using an appropriate interval
#   at 95% confidence interval.
# ----------------------

# Data prepartion as per given
new_IceCream_data = list()


new_IceCream_data$income <- 30000
new_IceCream_data$temperature <- 23
new_IceCream_data$seasons_Winter <- 0
new_IceCream_data$seasons_Autumn <- 0
new_IceCream_data$seasons_Spring <- 1
new_IceCream_data$seasons_Summer <- 0
new_IceCream_data$country_B <- 0
new_IceCream_data$country_A <- 1
new_IceCream_data$price <- 3

new_IceCream_data_df <- data.frame(
  t(
    sapply(new_IceCream_data, c)
    )
  )

# Here in this step we are going to use linear regression model to predict the sales
predict(linear_regression_model, newdata = new_IceCream_data_df)

# Here in this step we are going to predict and calculate the confidence interval of 95% confidence level
predict(linear_regression_model, newdata = new_IceCream_data_df, interval = "confidence", level = 0.95)

# fit      lwr      upr
# 1 766.6907 716.1015 817.2799




# --------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------

# B. Hypothesis testing:

# --------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------


# Here in this step we are going to check sales density distribution plot for each country 

#  Density Plot
ggplot(data = main_dataframe, aes(x = icecream_sales, color = country)) + geom_density() + plot_color

#  Box Plot
ggplot(data = main_dataframe, aes(x = icecream_sales, color = country)) + geom_boxplot() + plot_color


# Here in this step we are going to calculate variance of sales of across each country
main_dataframe %>% group_by(country) %>% summarise(variance_country = var(icecream_sales)) %>% data.frame(stringsAsFactors = F)

# Below are the values for country => variance_country => Sales
# country variance_country
#       A         90843.14
#       B        105541.91

### Looking at the values we can say variance across the sales is almost equal 

# Here in this step we are going to filter out the country A & B sales
country_A_sales <- main_dataframe$icecream_sales[main_dataframe$country == "A"]
country_B_sales <- main_dataframe$icecream_sales[main_dataframe$country == "B"]

# Before we are going to check existence of differences across their sales means,
# First ensure that data should pass a test of homoscedasticity - are sales variances same  
# We do this in R using Fisher's F-test

# H0: No difference in their sales in variance between 2 countries.
# H1: Difference exists in variance of saless between 2 countries.
var_temp_p_value <-  var.test(country_A_sales, country_B_sales)$p.value

ifelse(var_temp_p_value > 0.05,
       ("There is no difference in their sales in variance between 2 countries - Null Hypothesis"),
       ("There is difference exists in variance of saless between 2 countries - Alternate Hypothesis")
)

# In the above case if p > 0.05, then we can assume that the variances of sales's of both countries are homogeneous. 
# In this case, we run a classic Student's two-sample t-test by setting the parameter var.equal = TRUE

# H0: No difference in average of sales between 2 countries.
# H1: Difference exists in average of sales between 2 countries.
test_p_value <- t.test(country_A_sales, country_B_sales, var.equal = TRUE)$p.value

ifelse(test_p_value > 0.05,
       ("There is no difference in average of sales between 2 countries - Null Hypothesis"),
       ("There is difference exists in average of sales between 2 countries - Alternate Hypothesis")
)