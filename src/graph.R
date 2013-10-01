# Description: graph.R handles all plotting operations
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
      cat(paste("plotting", names(wdata[i]), '\n'))
      
      #make temporary data frame to omit NA's
      df = na.omit(data.frame(wdata[,1], wdata[i]))
      
      #set up device for plotting/writing to png, set up graphical param, 
      #plot to device, then disconnect from device
      if (!DEBUG)
         png(filename = paste("../output/", names(wdata[i]), ".png"), 
            width = 4800, height = 2160)
               
      par(mfrow = c(1, 1), mar = c(B, L, T, R))
      plot(df[,1], df[,2], type = "l", col = "blue", 
            lwd = 7,
            ylim = c(0, max(df[2])), 
            main = names(wdata[i]),
            xlab = "",
            ylab = "inches WC",
            xaxt = "n", yaxt = "n",
            tck = 1)
      
      mtext("index", side = 1, line = 7)
      
      #dray y axis
      axis(side = 2, at = seq(from = 0, to = max(df[2]), by = 0.1), 
            tck = 1, las = 2)
      
      #draw x axis
      from = as.POSIXct(paste(format(head(df[,1], 1), "%Y-%m-%d"), "00:00:00"), 
            format = "%Y-%m-%d %H:%M:%S", tz = "GMT")
      to = as.POSIXct(paste(format(tail(df[,1], 1), "%Y-%m-%d"), "00:00:00"), 
            format = "%Y-%m-%d %H:%M:%S", tz = "GMT")
      
      axis.POSIXct(1, at = seq(from = from, to = to, by = "hour"), 
         format = "%b %d %H:%M", 
         tck = 1, las = 2)
      
      if (!DEBUG)
         dev.off()
   }
}
