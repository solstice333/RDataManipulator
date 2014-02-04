# TODO: Add comment
# 
# Author: knavero
###############################################################################
#Bottom, Left, Top, Right margins
B = 9
L = 5
T = 2
R = 2

#copy of the data
df = data

# get start and end and 'a' which traverses through the data each week
mon = subset(df, iswd == 1) #subset all the mondays to get the first monday
a = start = as.POSIXct(paste(format(head(mon[,1], 1), "%Y-%m-%d"), "00:00:00"), 
      format = "%Y-%m-%d %H:%M:%S")
end = as.POSIXct(paste(format(tail(df[,1], 1), "%Y-%m-%d"), "00:00:00"),
      format = "%Y-%m-%d %H:%M:%S") + 60 * 60 * 24
df = subset(df, df$ts >= start)

# iterate through each week
while (a < end) {
   cat(paste("printing weekly reduction plots for", names(wdata[min$id]), a, '\n'))
   
   #take week subset
   week_df = subset(df, df[,1] >= a & df[,1] <= a + 7 * 60 * 60 * 24)
   endofweek = tail(format(week_df$ts, "%Y-%m-%d"), 1)
   
   #open connection for png writing
   name = paste("output/", names(wdata[min$id]), a, "-", endofweek, "AC.png")
   png(filename = name, width = 1600, height = 720)
   
   #setup plot and draw line
   par(mfrow = c(1, 1), mar = c(B, L, T, R))
   plot(week_df$ts, week_df$data, type = "l", col = "black", 
         lwd = 1,
         ylim = c(floor(min(df$data, na.rm = TRUE) / 0.1) * 0.1, max(df$data, na.rm = TRUE)), 
         main = paste(names(wdata[min$id]), a, "-", endofweek, "AC"),
         xlab = "",
         ylab = "inches WC",
         xaxt = "n", yaxt = "n",
         tck = 1)
   
   lines(x = df$ts, y = df$reduced, type = "l", col = "blue", lwd = 1)
   mtext("index", side = 1, line = 7)
   
   #dray y axis
   axis(side = 2, at = seq(from = floor(min(df[2], na.rm = TRUE) / 0.1) * 0.1, 
               to = max(df[2], na.rm = TRUE), by = 0.1), 
         tck = 1, las = 2)
   
   #draw x axis
   axis.POSIXct(1, at = seq(from = a, to = a + 7* 60 * 60 * 24, by = "day"), 
         format = "%b %d %H:%M", 
         tck = 1, las = 2)
   
   #create legend
   legendNames = c("original", "reduced by 0.5")
   legend("topleft", lty = "solid", lwd = 5, bty = "n", cex = 1.5, 
         legend = legendNames, col = c("black", "blue"))
   
   #close connection to device
   dev.off();
   
   #increment to next week
   a = a + 7*24*60*60
}
