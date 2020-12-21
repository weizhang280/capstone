# Capstone Final Project - Next Word Prediction Model

This project is to build a language model which predicts the next word a user might use in a sentence.  

The model employs N-gram(a sequence of N words), Markov process(the next word only depends on the last few), and Stupid Back-Off(an inexpensive smoothing method on large data sets).     

The model is trained with a huge corpus of data to find the probability of the occurrence of a word in a sequence of words.  

The application is published to RStudio's shiny server at:    
https://wzhang2020.shinyapps.io/NexrWordPredictrion/ 

The presentation is published at  
https://rpubs.com/weiweiz/706459

Data Source:       
https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip  
en_US.news.txt  
en_US.blogs.txt  
en_US.twitter.txt 

Note:   
*Due to the 25mb size limit, 4-gram and 3-gram frequency data frame files cannot be uploaded to GitHub.  
*All n-gram freqency data frame fst files can be generated by BuildNgram.Rmd
