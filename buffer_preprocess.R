#test script to properly format qgis geometry output to be run in buffer script

#change file name
data <- read.csv(file="flyterra_08072015_nodes.csv")

#drops the ID column, will remake
data$id <- NULL
#data$plots <- NULL
#count number of entries for plot
data$idNum <- NA
data$idCount <-NA

x<- 1
y <- nrow(data)
z<-0

#loop to properly format plot column from row/column

for (i in 1:y){
  if (nchar(data$row[i])==1){
    data$row[i]<-paste("0",data$row[i], sep="")
  } else {
    data$row[i]<-data$row[i]
  }
  data$plots2[i] <- paste("p",data$row[i],"_",data$column[i],sep="")
}
#loop to fill in id column and check that there are only 5 entries
for (i in 1:(y-1)) {
  if (data$plots[i] == data$plots[i+1]) { 
    data$idNum[i] <- x
    data$idCount[i] <- z+1
    z<-data$idCount[i]
  } else {
    data$idCount[i] <-z+1
    z<-data$idCount[i]
    data$idNum[i]<-x
    x<-x+1
    data$idNum[i+1]<-x
    z<-0
  }
}

#fill in last line
if (data$plots[y]==data$plots[y-1]){
  data$idNum[y]<-data$idNum[y-1]
  data$idCount[y]<-data$idCount[y]+1
}


#reorganize data columns
data$x <- data$xcoord
data$y <- data$ycoord
data$id <- data$idNum
data$plots <- data$plots2

#proper output format
#need to go into excel and make sure id count is max 5, not 4 or 6
data2 <- data[c('x','y','id','plots','xcoord', 'ycoord', 'idCount')]

#output file
write.csv(data2, file="flyterra_07202015_preprocess_out.csv", row.names= F)




