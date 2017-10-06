setwd("D:/UIC/MyResearch")

# bag of words created and put in different text files

library("topicmodels")
library("lda")
library(SnowballC)
library(tm)
library(dplyr)
library(readxl)
library(stringr)
illinois_LHD_tweets <- read_excel("D:/UIC/MyResearch/illinois LHD tweets.xlsx")
tweets<-illinois_LHD_tweets
tbl_tweets<-tbl_df(tweets)


# will match each tweet with bag of words to determine the affinity towards topics


# function to match to bag of words
matchtest<-function(teet){
  a<-unlist(str_split(teet,pattern="\\s+"))
  Health<-sum(!is.na(match(a,healthw)))
  Event<-sum(!is.na(match(a,event)))
  Job<-sum(!is.na(match(a,job)))
  Warning<-sum(!is.na(match(a,warning)))
  Wish<-sum(!is.na(match(a,wish)))
  df1<-as.data.frame(rbind(Health,Event,Job,Warning,Wish))
  categoryW<-rownames(df1)[which.max(df1$V1)]
  return(categoryW)
  }



healthw<-scan('health.txt',what ='character',comment.char = ';' )
event<-scan('event.txt',what ='character',comment.char = ';' )
job<-scan('job.txt',what ='character',comment.char = ';' )
warning<-scan('warning.txt',what ='character',comment.char = ';' )
wish<-scan('wish.txt',what ='character',comment.char = ';' )


# currently the complexity is O(5N).Now I am putting a single for loop and putting all functions in it so
# that the complexity goes down to O(N).I can also use %>% operator but I don't know how it calls
# so can't say about the complexity.Some people say that for the same array complexity doesn't increases
#I am not sure if R works the same way

for(i in 1:nrow(tweets)){
  tbl_tweets[i,12]<-gsub(pattern = "http\\S+\\s",replacement = "",x = tbl_tweets[i,12])
  tbl_tweets[i,12]<-gsub(pattern = "\\W",replacement = " ",x=tbl_tweets[i,12])
  tbl_tweets[i,12]<-gsub(pattern="\\d",replacement = "",x=tbl_tweets[i,12])
  tbl_tweets[i,12]<-removeWords(as.character(tbl_tweets[i,12]),stopwords())
  tbl_tweets[i,13]<-matchtest(tbl_tweets[i,12])
}
  
write.csv(tbl_tweets,file="Category of Tweets.csv") 



TEvent<-sum(tbl_tweets[13]=="Event")
THealth<-sum(tbl_tweets[13]=="Health")
TJob<-sum(tbl_tweets[13]=="Job")
TWish<-sum(tbl_tweets[13]=="Wish")
TWarning<-sum(tbl_tweets[13]=="Warning")

CategoryofTweets<-rbind(TEvent,THealth,TJob,TWish,TWarning)
colnames(CategoryofTweets)<-"Assignments"

CategoryofTweets<-as.data.frame(CategoryofTweets)
CategoryofTweets$Percentages<-with(CategoryofTweets,CategoryofTweets$Assignments/sum(CategoryofTweets$Assignments))

write.csv(CategoryofTweets,file="Summary of Tweets.csv") 



