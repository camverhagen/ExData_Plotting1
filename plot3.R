library(data.table)

##Check for download directory
if(!file.exists("data")) {
  dir.create("data")
}
##Download data files
fileURL <- "http://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(fileURL, destfile="./data/UC Irvine ML.zip")
##Unzip download file
filePath <- "./data/UC Irvine ML.zip"
unzip(filePath, exdir="./data")
## Read Data
datafile <- "./data/household_power_consumption.txt"
DF1 <- fread(datafile, na.strings="?", colClasses="character")
##Convert Date Column to class "Date"
DF1$Date <- as.Date(DF1$Date, format="%d/%m/%Y")
##Subset data
DF2 <- subset(DF1, Date >= "2007-02-01" & Date <= "2007-02-02")
##Combine Date and Time columns
DateTime <- paste(DF2$Date, DF2$Time)
DF2 <- cbind(DF2, DateTime)
##Format Date/Time column as POSIXct
DF2$DateTime <- as.POSIXct(DF2$DateTime, format="%Y-%m-%d %H:%M:%S")
##Remove extra Date/Time columns
DF3 <- subset(DF2, select = -c(1,2))
##Convert to numeric values
DF3$Sub_metering_1 <- as.numeric(DF3$Sub_metering_1)
DF3$Sub_metering_2 <- as.numeric(DF3$Sub_metering_2)
DF3$Sub_metering_3 <- as.numeric(DF3$Sub_metering_3)
##Create Plot
png(filename = "plot3.png")
plot(DF3$DateTime, DF3$Sub_metering_1, xlab="", ylab="Energy sub metering", type="n")
lines(DF3$DateTime, DF3$Sub_metering_1, col="black")
lines(DF3$DateTime, DF3$Sub_metering_2, col="red")
lines(DF3$DateTime, DF3$Sub_metering_3, col="blue")
legend("topright", lwd=1, lty=1, col = c("black","red","blue"), legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))
dev.off()
