#this script links our plotID w our field map

#input csv of fieldmap
map <- read.csv("Y_fieldmap.csv", header = FALSE)

#change all of these values
#
#set for first column
first_col <- 54
#set for last column
last_col<- 1
#set for number of rows
num_rows <- 12
#first_row
first_row <- 1
last_row <-12

#sets first number of first column
x <- as.data.frame(rep(first_col,times=num_rows))


#sequence 
for (i in seq(first_col-1, last_col)){
  temp <- as.data.frame(rep(i,times=num_rows))
  x <- as.data.frame(cbind(x,temp))
}

y <- as.data.frame(seq(first_row,last_row))

for (i in seq(first_col-1, last_col)){
  temp <- as.data.frame(seq(first_row,last_row))
  y <- as.data.frame(cbind(y,temp))
}

map3 <- as.data.frame(cbind(as.character(x[,1]),as.character(y[,1]),as.character(map[,1])))

for(i in 2:ncol(map)){
  temp <- as.data.frame(cbind(as.character(x[,i]),as.character(y[,i]),as.character(map[,i])))
  map3 <- as.data.frame(rbind(map3,temp))
}

colnames(map3) <- c("column", "row", "plot_num")
map4 <-map3[c("row","column","plot_num")]

#change name of output file
write.csv(map3,file="2015_NYH2.csv",row.names=F)


