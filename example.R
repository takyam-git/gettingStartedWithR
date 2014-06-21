library('reshape2');
library('ggplot2');
library('plyr');
Sys.setlocale("LC_TIME", "C");
logData <- read.table(file = "httpd.log", sep = " ", nrows = -1, header = F, col.names = c(
	"IP", "0", "1", "dateTime", "timezone", "request", "responseCode", "bytes", "referrer", "UA"
));
logData$time <- strptime(paste(logData$dateTime, logData$timezone), "[%d/%b/%Y:%H:%M:%S %z]");
logData$method <- c();
logData$path <- c();
for ( i in 1:nrow(logData) ) {
  reqData <- strsplit(as.character(logData$request[[i]]), " ")[[1]];
  logData$method[[i]] <- reqData[[1]];
  logData$path[[i]] <- strsplit(reqData[[2]], "/")[[1]][[2]];
  reqData <- NULL;
}

logData$IP <- NULL;
logData$X0 <- NULL;
logData$X1 <- NULL;
logData$dateTime <- NULL;
logData$timezone <- NULL;
logData$request <- NULL;
logData$referrer <- NULL;
logData$UA <- NULL;

logData <- subset(logData, responseCode == 200 & method == "GET", select = c("time", "path", "bytes"));

boxPlot1 <- ggplot(logData, aes(x = path, y = bytes, fill = path)) + geom_boxplot();