rm(list=ls(all.names=TRUE))
library(XML)
library(RCurl)
library(httr)

urlPath <- "https://www.ptt.cc/bbs/movie/index.html"
temp    <- getURL(urlPath, encoding = "big5")
xmldoc  <- htmlParse(temp)
title   <- xpathSApply(xmldoc, "//div[@class=\"title\"]", xmlValue)
title   <- gsub("\n", "", title)
title   <- gsub("\t", "", title)
emptyId <- which(title == "(本文已被刪除) [brukling]")
title   <- title[-emptyId]
author  <- xpathSApply(xmldoc, "//div[@class='author']", xmlValue)
empty   <- author == "-"
author  <- author[!empty]
date    <- xpathSApply(xmldoc, "//div[@class='date']", xmlValue)
date    <- date[-emptyId]
response<- xpathSApply(xmldoc, "//div[@class='nrec']", xmlValue)
response<- response[-emptyId]
path    <- xpathSApply(xmldoc, "//div[@class='title']/a//@href")
alldata <- data.frame(title, author, path, date, response)

write.table(alldata, "pttmovie.csv")