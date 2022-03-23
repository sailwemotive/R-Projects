#NaiveBayes
library('e1071')

# Set current working directory.
setwd(getwd())

install.packages("readxl")

library("readxl")

passenger_dataset <- read_excel("C:\\Users\\skargutkar\\Downloads\\Cruise Director Analysis.xlsx")

#Save into a data frame and view it
passenger_df = as.data.frame(passenger_dataset)

plot(as.factor(passenger_df[,3]))
title(main="Economic class analysis", xlab="Economic class", ylab="Total passengers")

plot(as.factor(passenger_df[,10]))
title(main="Package purchsed by passengers", xlab="", ylab="Total passengers")

plot(as.factor(passenger_df[passenger_df$PurchasedPackage == 'Yes', 2]))
title(main='Package purchased by passengers', xlab='Ports', ylab='Total passengers')

plot(as.factor(passenger_df[passenger_df$PurchasedPackage == 'Yes', 3]))
title(main='Package purchased by passengers', xlab='Economic class', ylab='Total passengers')

plot(as.factor(passenger_df[passenger_df$PurchasedPackage == 'Yes', 4]))
title(main='Package purchased by passengers', xlab='Gender', ylab='Total passengers')

plot(as.factor(passenger_df[passenger_df$PurchasedPackage == 'Yes', 6]))
title(main='Package purchased by passengers', xlab='No of Siblings or Spouses on Board', ylab='Total passengers')

plot(as.factor(passenger_df[passenger_df$PurchasedPackage == 'Yes', 7]))
title(main='Package purchased by passengers', xlab='No of Parents or Children on Board', ylab='Total passengers')

passenger_df <- na.omit(passenger_df)

trainingdata <- head(passenger_df,400)
testdata<-head(passenger_df,-400)

table(passenger_df$PurchasedPackage)

table(trainingdata$PurchasedPackage)

table(testdata$PurchasedPackage)

nbmodel <- naiveBayes(PurchasedPackage ~ ., data = trainingdata)
nbmodel

nbresult <- predict(nbmodel, testdata)
nbresult

prop.table(table(nbresult))


library(lattice)
library(ggplot2)
install.packages('gmodels')
install.packages('caret')
library('caret')
library(gmodels)

nbcm<-confusionMatrix(nbresult, as.factor(testdata$PurchasedPackage))

str(nbcm)
nbcm

tab0<-table(nbresult,as.factor(testdata$PurchasedPackage))
tab0


# Decision tree
install.packages("party")
library(party)

# Give the chart file a name.
png(file = "C:\\Users\\skargutkar\\Downloads\\decision_tree.png")

economic_class <- as.factor(passenger_df$`Economic Class`)
gender <- as.factor(passenger_df$Sex)
age <- as.factor(passenger_df$Age)

# Create the tree.
output.tree <- ctree(
  as.factor(PurchasedPackage) ~ economic_class + gender + age, 
  data = passenger_df)

# Plot the tree.
plot(output.tree)

# Save the file.
dev.off()
