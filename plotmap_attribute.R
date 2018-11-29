#this script links our plotID w our field map

#input csv of fieldmap
map <- read.csv("2016_NYH2_map1.csv", header = FALSE)

#change all of these values
#
#set for first column
first_col <- 28
#set for last column
last_col<- 1
#set for number of rows
num_rows <- 22
#first_row
first_row <- 24
last_row <-45

#sets first number of first column
x <- as.data.frame(rep(first_col,times=num_rows))


#sequence 
for (i in seq(first_col-1, last_col)){ #change +/1 depending on col order
  temp <- as.data.frame(rep(i,times=num_rows))
  x <- as.data.frame(cbind(x,temp))
}

y <- as.data.frame(seq(first_row,last_row))

for (i in seq(first_col-1, last_col)){ #change +/1 depending on col order
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

#make plotID

#add prefix


#change name of output file
write.csv(map3,file="2016_NYH2_Drew_NickPix_out.csv",row.names=F)


