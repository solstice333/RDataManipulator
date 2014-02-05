# TODO: Add comment
# 
# Author: knavero
###############################################################################
#Bottom, Left, Top, Right margins
B = 9
L = 5
T = 2
R = 2
ORIG_COLOR = "black"
REDUCED_COLOR = "darkgreen"

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
   name = paste("output/", names(wdata[min$id]), a, "-", endofweek, "reduced.png")
   png(filename = name, width = 1600, height = 720)
   
   #setup plot and draw line
   par(mfrow = c(1, 1), mar = c(B, L, T, R))
   plot(week_df$ts, week_df$data, type = "l", col = ORIG_COLOR, 
         lwd = 4,
         ylim = c(floor(min(df$data, na.rm = TRUE) / 0.1) * 0.1, max(df$data, na.rm = TRUE)), 
         main = paste(names(wdata[min$id]), a, "-", endofweek, "reduced"),
         xlab = "",
         ylab = "inches WC",
         xaxt = "n", yaxt = "n",
         tck = 1)
   
   lines(x = df$ts, y = df$reduced, type = "l", col = REDUCED_COLOR, lwd = 4)
   mtext("index", side = 1, line = 7)
   
   #dray y axis
   axis(side = 2, at = seq(from = floor(min(df[2], na.rm = TRUE) / 0.1) * 0.1, 
               to = max(df[2], na.rm = TRUE), by = 0.1), 
         tck = 1, las = 2, col = "grey")
   
   #draw x axis
   axis.POSIXct(1, at = seq(from = a, to = a + 7* 60 * 60 * 24, by = "day"), 
         format = "%b %d %H:%M", 
         tck = 1, las = 2, col = "grey")
   
   #create legend
   legendNames = c("original", "reduced by 0.5")
   legend("topleft", lty = "solid", lwd = 5, bty = "n", cex = 1.5, 
         legend = legendNames, col = c(ORIG_COLOR, REDUCED_COLOR))
   
   #close connection to device
   dev.off();
   
   #increment to next week
   a = a + 7*24*60*60
}

#daily reduction plots
i = min$id  # set i to min$id
df = data   # reset df to data

cat(paste("printing daily plots for", names(wdata[i]), '\n'))

# get start and end. Also get 'a' to iterate through each day
a = start = as.POSIXct(paste(format(head(df[,1], 1), "%Y-%m-%d"), "00:00:00"), 
      format = "%Y-%m-%d %H:%M:%S")
end = as.POSIXct(paste(format(tail(df[,1], 1), "%Y-%m-%d"), "00:00:00"),
      format = "%Y-%m-%d %H:%M:%S") + 60 * 60 * 24

while (a < end) {
   #take day subset
   day_df = subset(df, df[,1] >= a & df[,1] <= a + 60 * 60 * 24) 

   if (nrow(day_df) > 0) {
      cat(paste("printing daily plots for", names(wdata[i]), a, "reduction", '\n'))
   
      #open connection for png writing
      png(filename = paste("output/", names(wdata[i]), a, "reduced", ".png"), 
            width = 1600, height = 720)
      
      #setup plot and draw line
      par(mfrow = c(1, 1), mar = c(B, L, T, R))
      plot(day_df[,1], day_df[,2], type = "l", col = ORIG_COLOR, 
            lwd = 4,
            ylim = c(floor(min(df[2], na.rm = TRUE) / 0.1) * 0.1, max(df[2], na.rm = TRUE)), 
            main = paste(names(wdata[i]), "reduced", a),
            xlab = "",
            ylab = "inches WC",
            xaxt = "n", yaxt = "n",
            tck = 1)
      
      lines(x = df$ts, y = df$reduced, type = "l", col = REDUCED_COLOR, lwd = 4)
      mtext("index", side = 1, line = 7)
      
      #dray y axis
      axis(side = 2, at = seq(from = floor(min(df[2], na.rm = TRUE) / 0.1) * 0.1, 
                  to = max(df[2], na.rm = TRUE), by = 0.1), 
            tck = 1, las = 2, col = "grey")
      
      #draw x axis
      axis.POSIXct(1, at = seq(from = a, to = a + 60 * 60 * 24, by = "hour"), 
            format = "%b %d %H:%M", 
            tck = 1, las = 2, col = "grey")
      
      #create legend
      legendNames = c("original", "reduced by 0.5")
      legend("topleft", lty = "solid", lwd = 5, bty = "n", cex = 1.5, 
            legend = legendNames, col = c(ORIG_COLOR, REDUCED_COLOR))
      
      #close connection to device
      dev.off();
   }
   
   #increment to next day
   a = a + 60*60*24
}
