install.packages("RSelenium")
library("RSelenium")
remDr<-rsDriver(port = 4444L,browser = "chrome",version = "latest",chromever = "latest",geckover = "latest",check = TRUE)
Client<-remDr$client
Client$open()
Client$navigate("https://www.twitter.com")


for(i in 1:1000)

{  
  
Css<-Client$findElements(using = "css selector",value = ".tweet-text")
CSS_Text_Headers<- unlist(lapply(Css, function(x){x$getElementText()}))
CSS_Text_Headers 
Client$sendKeysToActiveElement(list(key = "end"))
Css<-Client$findElements(using = "css selector",value = ".tweet-text")
CSS_Text_Headers<- unlist(lapply(Css, function(x){x$getElementText()}))
CSS_Text_Headers 

}
#Let's see if git catches this one 
# This is my first add through git terminal



