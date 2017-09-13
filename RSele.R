install.packages("RSelenium")
library("RSelenium")
# important because it downloads all the things(geckodriver,chrome driver,phantom js)

remDr<-rsDriver(port = 4444L,browser = "chrome",version = "latest",chromever = "latest",geckover = "latest",check = TRUE)
Client<-remDr$client

#list of different handles which you want to extract
setwd("D:/UIC/MyResearch")

for(i in 1:nrow(namesUnique)){
Client$open()

#different handles   
  
Client$navigate(paste0("https://www.twitter.com/",gsub("@",replacement = "",x = namesUnique[i,1])))

# escape is required to dismiss the login alert

Client$sendKeysToActiveElement(list(key="escape"))

for(j in 1:40)
{  
# required for getting tweets from the page which are not loaded
Client$sendKeysToActiveElement(list(key = "end"))
Css<-Client$findElements(using = "css selector",value = ".tweet-text")
}

CSS_DATA_FRAME<- unlist(lapply(Css, function(x){x$getElementText()}))
CSS_DATA_FRAME<-as.data.frame(CSS_DATA_FRAME)
Client$close()


write.csv(x = CSS_DATA_FRAME,file = paste0(gsub("@",replacement="",x=namesUnique[i,1]),".csv"))
}










