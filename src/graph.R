# Description: graph.R handles all plotting operations
#
# Author: knavero
###############################################################################
#Debug var
DEBUG = FALSE

#Width and height multipliers
WIDTH_MULTIPLIER = 3
HEIGHT_MULTIPLIER = 3

#Bottom, Left, Top, Right margins
B = 9
L = 5
T = 2
R = 2

SIZE = length(wdata)
if (DEBUG)
   SIZE = 2

#parse all columns and plot only those with pressure
for (i in 2:SIZE) {
   cat(paste("plotting", names(wdata[i]), '\n'))
   
   #make temporary data frame to omit NA's
   df = na.omit(data.frame(wdata[,1], wdata[i]))
   
   #BEGIN printing plot for each daily sensor across the whole time span here
   #set up device for plotting/writing to png, set up graphical param, 
   #plot to device, then disconnect from device
   png(filename = paste("../output/", names(wdata[i]), ".png"), 
      width = 1600 * WIDTH_MULTIPLIER, height = 720 * HEIGHT_MULTIPLIER)
            
   par(mfrow = c(1, 1), mar = c(B, L, T, R))
   plot(df[,1], df[,2], type = "l", col = "blue", 
         lwd = 7,
         ylim = c(floor(min(df[2], na.rm = TRUE) / 0.1) * 0.1, max(df[2], na.rm = TRUE)), 
         main = names(wdata[i]),
         xlab = "",
         ylab = "inches WC",
         xaxt = "n", yaxt = "n",
         tck = 1)
   
   mtext("index", side = 1, line = 7)
   
   #dray y axis
   axis(side = 2, at = seq(from = floor(min(df[2], na.rm = TRUE) / 0.1) * 0.1, 
      to = max(df[2], na.rm = TRUE), by = 0.1), 
      tck = 1, las = 2)
   
   #draw x axis
   from = as.POSIXct(paste(format(head(df[,1], 1), "%Y-%m-%d"), "00:00:00"), 
         format = "%Y-%m-%d %H:%M:%S")
   to = as.POSIXct(paste(format(tail(df[,1], 1), "%Y-%m-%d"), "00:00:00"), 
         format = "%Y-%m-%d %H:%M:%S") + 60 * 60 * 24
   
   axis.POSIXct(1, at = seq(from = from, to = to, by = "hour"), 
      format = "%b %d %H:%M", 
      tck = 1, las = 2)
   
   dev.off()
   
   #BEGIN printing daily plots for each sensor here
   cat(paste("printing daily plots for", names(wdata[i]), '\n'))
   
   a = start = as.POSIXct(paste(format(head(df[,1], 1), "%Y-%m-%d"), "00:00:00"), 
         format = "%Y-%m-%d %H:%M:%S")
   end = as.POSIXct(paste(format(tail(df[,1], 1), "%Y-%m-%d"), "00:00:00"),
         format = "%Y-%m-%d %H:%M:%S") + 60 * 60 * 24
   
   while (a < end) {
      cat(paste("printing daily plots for", names(wdata[i]), a, '\n'))
      
      #take day subset
      day_df = subset(df, df[,1] >= a & df[,1] <= a + 60 * 60 * 24) 

      #open connection for png writing
      png(filename = paste("../output/", names(wdata[i]), a, ".png"), 
            width = 1600, height = 720)
      
      #setup plot and draw line
      par(mfrow = c(1, 1), mar = c(B, L, T, R))
      plot(day_df[,1], day_df[,2], type = "l", col = "blue", 
            lwd = 7,
            ylim = c(floor(min(df[2], na.rm = TRUE) / 0.1) * 0.1, max(df[2], na.rm = TRUE)), 
            main = paste(names(wdata[i]), " ", a),
            xlab = "",
            ylab = "inches WC",
            xaxt = "n", yaxt = "n",
            tck = 1)
      
      mtext("index", side = 1, line = 7)
      
      #dray y axis
      axis(side = 2, at = seq(from = floor(min(df[2], na.rm = TRUE) / 0.1) * 0.1, 
         to = max(df[2], na.rm = TRUE), by = 0.1), 
         tck = 1, las = 2)
      
      #draw x axis
      axis.POSIXct(1, at = seq(from = a, to = a + 60 * 60 * 24, by = "hour"), 
            format = "%b %d %H:%M", 
            tck = 1, las = 2)
      
      #close connection to device
      dev.off();
      
      #increment to next day
      a = a + 60*60*24
   }
}

#BEGIN plotting overlay for all sensors across entire time span here
cat("Printing overlay...\n")

#open png device connection
png(filename = paste("../output/overlay.png"), 
     width = 1600 * WIDTH_MULTIPLIER, height = 720 * HEIGHT_MULTIPLIER)

#color vector
colors = c("black", "red", "blue", "green4", "purple", "orange", "yellow3", "skyblue", "tan", "brown")

#error checking for if there is enough colors for the lines
EnoughColors = TRUE
if (SIZE - 1 > length(colors)) {
   cat("Error: Not enough colors! Exiting...\n")
   EnoughColors = FALSE
}

if (EnoughColors) {
   #numerical values only in nframe (used to calculate for the max)
   nframe = wdata
   nframe[1] = NULL
   
   #set up plot and plot draw lines
   par(mfrow = c(1, 1), mar = c(B, L, T, R))
   plot(x = wdata[,1], y = wdata[,2], type = "p", col = colors[1], 
         lwd = 0.5,
         ylim = c(floor(min(nframe, na.rm = TRUE) / 0.1) * 0.1, max(nframe, na.rm = TRUE)), 
         main = "overlay",
         xlab = "",
         ylab = "inches WC",
         xaxt = "n", yaxt = "n",
         tck = 1)
   colorsUsed = colors[1]
   mtext("index", side = 1, line = 7)
   
   SIZE = length(wdata)
   for (i in 3:SIZE) {
      lines(x = wdata[,1], y = wdata[,i], type = "p", col = colors[i - 1], lwd = 0.5)
      colorsUsed = c(colorsUsed, colors[i - 1])
   }
   
   #dray y axis
   axis(side = 2, at = seq(from = floor(min(nframe, na.rm = TRUE) / 0.1) * 0.1, 
      to = max(nframe, na.rm = TRUE), by = 0.1), 
      tck = 1, las = 2)
   
   #draw x axis
   from = as.POSIXct(paste(format(head(wdata[,1], 1), "%Y-%m-%d"), "00:00:00"), 
         format = "%Y-%m-%d %H:%M:%S")
   to = as.POSIXct(paste(format(tail(wdata[,1], 1), "%Y-%m-%d"), "00:00:00"), 
         format = "%Y-%m-%d %H:%M:%S") + 60 * 60 * 24
   
   axis.POSIXct(1, at = seq(from = from, to = to, by = "day"), 
         format = "%b %d %H:%M", 
         tck = 1, las = 2)
   
   #create legend
   legendNames = vector(mode = "character")
   for(i in 2:SIZE) {
      legendNames = c(legendNames, names(wdata[i]))
   }
   
   legend("topleft", lty = rep("solid", SIZE - 1), lwd = 5, bty = "n", cex = 1.5, 
      legend = legendNames, col = colorsUsed)
   
   #disconnect device
   dev.off()
   
   #BEGIN daily plotting overlay for all sensors here
   a = start = as.POSIXct(paste(format(head(wdata[,1], 1), "%Y-%m-%d"), "00:00:00"), 
         format = "%Y-%m-%d %H:%M:%S")
   end = as.POSIXct(paste(format(tail(wdata[,1], 1), "%Y-%m-%d"), "00:00:00"),
         format = "%Y-%m-%d %H:%M:%S") + 60 * 60 * 24
   
   cat("Plotting daily overlay plots...\n")
   
   while (a < end) {
      cat(paste("Plotting daily overlay plots for", a, '\n'))
      
      #take day subset and numerical frame to extract max value from
      day_df = subset(wdata, wdata[,1] >= a & wdata[,1] <= a + 60 * 60 * 24)
      nframe = day_df
      nframe[1] = NULL
      
      #open connection for png writing
      png(filename = paste("../output/", a, ".png"), 
            width = 1600, height = 720)
      
      #setup plot and draw line
      par(mfrow = c(1, 1), mar = c(B, L, T, R))
      plot(x = day_df[,1], y = day_df[,2], type = "p", col = colors[1], 
            lwd = 0.5,
            ylim = c(floor(min(nframe, na.rm = TRUE) / 0.1) * 0.1, 1.5 * max(nframe, na.rm = TRUE)), 
            main = paste(a, "overlay"),
            xlab = "",
            ylab = "inches WC",
            xaxt = "n", yaxt = "n",
            tck = 1)
      colorsUsed = colors[1]
      mtext("index", side = 1, line = 7)
      
      SIZE = length(wdata)
      for (i in 3:SIZE) {
         lines(x = day_df[,1], y = day_df[,i], type = "p", col = colors[i - 1], lwd = 0.5)
         colorsUsed = c(colorsUsed, colors[i - 1])
      }
      
      #dray y axis
      axis(side = 2, at = seq(from = floor(min(nframe, na.rm = TRUE) / 0.1) * 0.1, 
         to = max(nframe, na.rm = TRUE), by = 0.1), 
         tck = 1, las = 2)
      
      #draw x axis
      axis.POSIXct(1, at = seq(from = a, to = a + 60 * 60 * 24, by = "hour"), 
            format = "%b %d %H:%M", 
            tck = 1, las = 2)
      
      #create legend
      legendNames = vector(mode = "character")
      for(i in 2:SIZE) {
         legendNames = c(legendNames, names(day_df[i]))
      }
      
      legend("topleft", lty = rep("solid", SIZE - 1), lwd = 5, bty = "n", cex = 1.25, 
            legend = legendNames, col = colorsUsed)
      
      #close connection to device
      dev.off();
      
      #increment to next day
      a = a + 60*60*24
   }
}

cat("Done plotting graphs!\n")
