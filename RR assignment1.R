temp<-tempfile()
url<-"https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2Factivity.zip"
url2<-download.file(url,temp, method='curl')
data<-read.csv(unz(temp,"activity.csv" ), stringsAsFactors=F)
unlink(temp)

test<-data

data$steps<-sapply(data$steps, as.numeric)
data$interval<-sapply(data$interval, as.numeric)
data$date<-as.Date(data$date)

stepday<-aggregate(data$steps, list(day=data$date), mean)

stepinterval<-aggregate(data$steps, list(interval=data$interval), mean, na.rm=T)
colnames(stepinterval)<-c("interval","meanforinterval")
qplot(stepinterval$interval, stepinterval$meanforinterval)

a<-max(stepinterval$meanforinterval)
b<-subset(stepinterval, meanforinterval==a, select='interval')
c<-b[,1]
print(paste("the interval ",b," has the maximum steps", "(",a,")", sep=""))

x<-sum(is.na(data))
paste("there are ",x, " NAs in the dataset", sep="")

data$id<-1:length(data$steps)
temp<-merge(data, stepinterval)
data<-temp[order(temp$id),]
data<-data[,c(1,2,3,5)]
row.names(data)<-NULL
for (i in length(data$steps)){
        if (is.na (data$steps[i])){data$steps[i]<-data$meanforinterval[i]}
}

