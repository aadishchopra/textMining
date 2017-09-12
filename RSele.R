install.packages("RSelenium")
library("RSelenium")
# important because it downloads all the things(geckodriver,chrome driver,phantom js)

remDr<-rsDriver(port = 4444L,browser = "chrome",version = "latest",chromever = "latest",geckover = "latest",check = TRUE)
Client<-remDr$client
Client$open()

# list of different handles which you want to extract
Client$navigate("https://www.twitter.com/LaSalleCoHealth")

# escape is required to dismiss the login alert

Client$sendKeysToActiveElement(list(key="escape"))

for(i in 1:50)
{  
# required for getting tweets from the page which are not loaded
  Client$sendKeysToActiveElement(list(key = "end"))
Css<-Client$findElements(using = "css selector",value = ".tweet-text")
}
CSS_DATA_FRAME<- unlist(lapply(Css, function(x){x$getElementText()}))
CSS_DATA_FRAME<-as.data.frame(CSS_DATA_FRAME)
Client$close()





