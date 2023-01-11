# prompt user to select directory
setwd(choose.dir(default = "E:\tall-movie-Analysis", caption = "Select folder"))

# make a new data frame, 3 columns and n rows per # files
# first count # log files
files = list.files()
nfiles = length(files)
df = as.data.frame(matrix(data=NA, nrow = nfiles, ncol = 7))
# name columns
colnames(df) = c("FileName","CellLine","PC","MM.G.over.R","MM.R.over.G","MMthresh.G.over.R","MMthresh.R.over.G")

# loop thru file list and extract information
for (i in 1:nfiles) {
  # find and save colocalization values from log file
  df[i,1] <- files[i]
  df[i,2] <- unlist(strsplit(df[i,1],split = "_"))[2]
  log <- readLines(files[i])
  cline <- grep("=",log, value=TRUE)
  df[i,3] <- as.numeric(unlist(strsplit(cline[1],split = "="))[2])
  df[i,4] <- unlist(strsplit(cline[2],split = "="))[2]
  df[i,5] <- unlist(strsplit(cline[3],split = "="))[2]
  df[i,6] <- unlist(strsplit(cline[4],split = "="))[2]
  df[i,7] <- unlist(strsplit(cline[5],split = "="))[2]
}

# save output in csv
write.csv(df,"jacop-output.csv")


