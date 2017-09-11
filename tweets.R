setwd("D:\\UIC\\MyResearch")
# install.packages("topicmodels")
library("topicmodels")
library("lda")
library(SnowballC)
library(tm)
library(dplyr)
library(readxl)
illinois_LHD_tweets <- read_excel("D:/UIC/MyResearch/illinois LHD tweets.xlsx")
tweets<-illinois_LHD_tweets


tbl_tweets<-tbl_df(tweets)
str(tbl_tweets)

# data cleaning starts
#it is important to clear the hyperlinks first because if we remove the 
#punctuation it will leave an empty space and the logic that URL's are tied
#together would fail


for(i in 1:nrow(tweets)){
  tbl_tweets[i,12]<-gsub(pattern = "http\\S+\\s",replacement = "",x = tbl_tweets[i,12])
}


# Making a document of all the tweets because that is the pith of
#LDA


#uncomment this to get the information about a particular handle


#tweetc<-filter(tbl_tweets,username=="@LaSalleCoHealth")

tweet<-select(tbl_tweets,tweets)
tweetc<-with(tweet,paste0(tweet))



#punctuation replacement
tweetc<-gsub(pattern = "\\W",replacement = " ",tweetc)

#digits replacement
tweetc<-gsub(pattern="\\d",replacement = "",tweetc)

# everything to lower match case
tweetc<-tolower(tweetc)


tweetc<-removeWords(tweetc,stopwords())

# to remove single characters such as "s"etc 

tweetc<-gsub(pattern="\\b[A-z]\\b{1}",replace="",tweetc)


# stemming is important since we want to get topic distributions
# Creating a corpus although it isnt necessary since we have a single corpus

tweetv<-Corpus(VectorSource(tweetc))%>%tm_map(stemDocument)

tweetv<-DocumentTermMatrix(x = tweetv)


word.frequency<-sort(colSums(as.matrix(tweetv)),decreasing = T)



#word distributions of the topic 


wordTable<-data.frame(word= names(word.frequency),
                      absolute.freqency=word.frequency,
                      relative.frequency=word.frequency/length(word.frequency))

write.csv(x = wordTable,file = "wordLaSalleTable.csv")


# to classify tweets we will sort the word frequency table 

top_words <- wordTable %>%
  filter(rank(desc(absolute.freqency))<=16)

# a try on latent dirichlet allocation
TopcModels<-LDA(x = tweetv,method = "VEM",k = 5)
terms(TopcModels)

# subsetting tweets by handles and then applying LDA so that we know what each handle usually talks about

out <- subset(tbl_tweets,username %in% Handles)



A<-lapply(unique(tbl_tweets$username), function(x) tbl_tweets[tbl_tweets$username == x,])


for(i in 1:length(A)){
assign(as.data.frame(unlist(A[[i]]$tweets)),Handles[i])
}


for(i in 1:4){
assign(paste("Handle",i,sep=""), tbl_tweets[i])               
}
                


# for creating bag of words, we have to manually inspect the tweets.This can be 
#intensive task.Therefore to make it less taxing we have automated the tweets
#and gave sufficient time between tweets on the console

##FUN TIP:Use earphones and some snacks to relax in between :)


for(i in 1501:2500){
  print(tweet[i:i+5,1])  
  flush.console()
  Sys.sleep(time = 5) 
  }


























