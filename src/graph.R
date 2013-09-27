# Description: graph.R handles all plotting operations
# 
# TODO: implement auto print of plots successfully
#
# Author: knavero
###############################################################################

#Debug var
DEBUG = FALSE

#Bottom, Left, Top, Right margins
B = 9
L = 5
T = 2
R = 2

SIZE = 3
if (!DEBUG)
   SIZE = length(wdata)

#parse all columns and plot only those with pressure
for (i in 1:SIZE) {
   if(grepl("iwc", names(wdata[i]))) {
      print(paste("plotting", names(wdata[i])))
      
      #make temporary data frame to omit NA's
      df = na.omit(data.frame(wdata$index, wdata[i]))
      
      #set up device for plotting/writing to png, set up graphical param, 
      #plot to device, then disconnect from device
      
      if (!DEBUG)
         png(filename = paste("../output/", names(wdata[i]), ".png"), 
            width = 1600, height = 720)
               
      par(mfrow = c(1, 1), mar = c(B, L, T, R))
      plot(df[,1], df[,2], type = "l", col = "blue", 
            lwd = 3,
            ylim = c(0, 2), 
            main = names(wdata[i]),
            xlab = "",
            ylab = "inches WC",
            xaxt = "n",
            tck = 1)
      
      mtext("index", side = 1, line = 7)
      
      from = as.POSIXct(paste(format(head(df[,1], 1), "%Y-%m-%d"), "00:00:00"), 
            format = "%Y-%m-%d %H:%M:%S", tz = "GMT")
      to = as.POSIXct(paste(format(tail(df[,1], 1), "%Y-%m-%d"), "00:00:00"), 
            format = "%Y-%m-%d %H:%M:%S", tz = "GMT")
      
      axis.POSIXct(1, at = seq(from = from, to = to, by = "day"), 
         format = "%b %d %H:%M", 
         tck = 1, las = 2)
      
      if (!DEBUG)
         dev.off()
   }
   
   if(i %% 4 == 0) {
      #use this block to create new dev and set graphical parameters
      #if user decides to plot to window instead of file
   } 
}
