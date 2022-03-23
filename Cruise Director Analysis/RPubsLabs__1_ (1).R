#NaiveBayes
install.packages('mlbench')
library('e1071')
library('mlbench')
data(HouseVotes84, package = "mlbench")
#data(Titanic)

table(HouseVotes84$Class)

plot(as.factor(HouseVotes84[,2]))
title(main="Total Vote cast for issue 1", xlab="vote", ylab="# reps")


plot(as.factor(HouseVotes84[HouseVotes84$Class=='republican', 2]))
title(main='Republican votes cast for issue 1', xlab='vote', ylab='#reps')


plot(as.factor(HouseVotes84[HouseVotes84$Class=='democrat', 2]))
title(main='Democrat votes cast for issue 1', xlab='vote', ylab='#reps')

na_by_col_class <- function (col, cls) {
  return(sum(is.na(HouseVotes84[,col]) & HouseVotes84$Class==cls))
}

trainingdata <- head(HouseVotes84,400)
testdata<-head(HouseVotes84,-400)

table(HouseVotes84$Class)

table(trainingdata$Class)

table(testdata$Class)


modelposteriorprob <- naiveBayes(Class ~ ., data = trainingdata, type = "raw")
modelposteriorprob


nbmodel <- naiveBayes(Class ~ ., data = trainingdata)
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

nbcm<-confusionMatrix(nbresult, testdata$Class)

str(nbcm)
nbcm

tab0<-table(nbresult,testdata$Class)
tab0



#K-Means
install.packages(c('cluster','cluster.datasets'))
library(cluster)
library(cluster.datasets)
data(birth.death.rates.1966)
birth.death = birth.death.rates.1966
head(birth.death)


bd = birth.death[,-1]
head(bd)

wss = kmeans(bd, centers=1)$tot.withinss

for (i in 2:15)
  wss[i] = kmeans(bd, centers=i)$tot.withinss

install.packages('ggvis')
library(ggvis)
sse = data.frame(c(1:15), c(wss))
names(sse)[1] = 'Clusters'
names(sse)[2] = 'SSE'
sse %>%
  ggvis(~Clusters, ~SSE) %>%
  layer_points(fill := 'blue') %>% 
  layer_lines() %>%
  set_options(height = 300, width = 400)


clusters = kmeans(bd, 6)
clusters

birth.death$Cluster = clusters$cluster
head(birth.death)


clusplot(bd, clusters$cluster, color=T, shade=F,labels=0,lines=0, main='k-Means Cluster Analysis')

#FPM Association Analysis

