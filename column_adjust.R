#Nick Kaczmar
#This script adjusts our output from plotmap_attribute such that it is more appropriate for our field layouts

#
#drew
 map <- read.csv("2016_NYH2_Drew_NickPix_out.csv", header = TRUE) 
# map <- read.csv("2016_NYH2_Drew_Flyterra_out.csv", header = TRUE) X
# map <- read.csv("2016_NYH3_Drew_NickPix_out.csv", header = TRUE) X
# map <- read.csv("2016_NYH3_Drew_Flyterra_out.csv", header = TRUE) X

#brian
# map <- read.csv("2016_NYH2_Brian_NickPix_out.csv", header = TRUE) X
# map <- read.csv("2016_NYH2_Brian_Flyterra_out.csv", header = TRUE)X
# map <- read.csv("2016_NYH3_Brian_NickPix_out.csv", header = TRUE)X
 #map <- read.csv("2016_NYH3_Brian_Flyterra_out.csv", header = TRUE)X

# #ami
# map <- read.csv("2016_NYH2_Ami_NickPix_out.csv", header = TRUE)X
# map <- read.csv("2016_NYH2_Ami_Flyterra_out.csv", header = TRUE)X
# map <- read.csv("2016_NYH3_Ami_NickPix_out.csv", header = TRUE)X
#map <- read.csv("2016_NYH3_Ami_Flyterra_out.csv", header = TRUE)X

#read in our data to be adjusted
#map <- read.csv("2015_NYH2.csv", header = TRUE)
colnames(map) <- c("column", "row", "plot_num")

#changes order of columns
map4 <-map[c("row","column","plot_num")]

#add a 0 to any row under 10
for (i in (1:616)) {
  if (nchar(map4$row[i])==1) {
    map4$row[i] = paste("0",map4$row[i],sep="")
  }
}

#combines entrys to make plotID
map4$plotID <-paste("p",map4$row,"_",map4$column,sep="")

#add column called plotID
p2 = map4$plotID
plotID=p2

#proper plotID output -ex p01_25
for (i in range(636)){
  plotID <-paste("p",map4$row,"_",map4$column)
}

#add column w A15NYH2_0 prefix
p3 = map4$Plot_prefix
plot_prefix = p3

# 
# #add prefix
# prefix <- "A15NYH2_0"
# for (i in range(636)){
#   if (nchar(map4$plot_num[i])==1) {
#     map4$plot_prefix[i] = paste(prefix,"00",map4$plot_num[i])
#   } else{
#     if (nchar(map4$plot_num[i])==2) {
#       map4$plot_prefix[i] = paste(prefix,"0",map4$plot_num[i])
#     } else {
#       if (nchar(map4$plot_num[i])==3) {
#         map4$plot_prefix[i] = paste(prefix,"",map4$plot_num[i])
#       }
#     }
#   }
# }


#output
#write.csv(map4,file="2015_NYH2_out.csv",row.names=F)

#drew
write.csv(map4, file="2016_NYH2_Drew_NickPix_out_adj.csv") 
#write.csv(map4, file="2016_NYH2_Drew_Flyterra_out_adj.csv") X
# write.csv(map4, file="2016_NYH3_Drew_NickPix_out_adj.csv") X
#write.csv(map4, file="2016_NYH3_Drew_Flyterra_out_adj.csv") X

#brian
#write.csv(map4, file="2016_NYH2_Brian_NickPix_out_adj.csv") X
#write.csv(map4, file="2016_NYH2_Brian_Flyterra_out_adj.csv")X
#write.csv(map4, file="2016_NYH3_Brian_NickPix_out_adj.csv")X
#write.csv(map4, file="2016_NYH3_Brian_Flyterra_out_adj.csv")X

# #ami
#write.csv(map4, file="2016_NYH2_Ami_NickPix_out_adj.csv")X
#write.csv(map4, file="2016_NYH2_Ami_Flyterra_out_adj.csv")X
#write.csv(map4, file="2016_NYH3_Ami_NickPix_out_adj.csv")X
#write.csv(map4, file="2016_NYH3_Ami_Flyterra_out_adj.csv")
