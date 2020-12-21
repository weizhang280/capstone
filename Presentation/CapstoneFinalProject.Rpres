Data Science Capstone
========================================================
<div align = center>
Next Word Prediction Model
<p>
Wei Zhang
<p>
12/20/2020  
</div>

Overview
========================================================

<font size="5">

This presentaion is to introduce a language model which predicts the next word a user might use in a sentence. <br>  
The model employs N-gram(a sequence of N words), Markov process(the next word only depends on the last few), and Stupid Back-Off(an inexpensive smoothing method on large data sets).   

The model is trained with a huge corpus of data to find the probability of the occurrence of a word in a sequence of words.

The application is published to RStudio's shiny server at:  
https://wzhang2020.shinyapps.io/NexrWordPredictrion/

Source code on github:    
https://github.com/weizhang280/capstone

Data Source:     
https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip  
en_US.news.txt  
en_US.blogs.txt  
en_US.twitter.txt  

</font>

Next Word Prediction Model UI
========================================================
<font size="5">
The prediction model is hosted on RStudio shinyapps.io server.  

To improve the model performance, N-gram frequency data frames are loaded at application level to be shared across all Shiny sessions. 
</font>

<img src="UI.png";>


Data Preparation
========================================================
<font size="5">

* The training data has 4,269,678 lines of text, 102,080,244 words from news, blogs 
and twitter. 10% of this source data has been randomly sampled to build the prediction model.

* Data cleaning includes the removal of: mentions, urls, emojis, hashtags, numbers, 
profane words, punctuations, newlines, leading and trailing whitespace, and extra whitespace.

* Building N-gram frequency data frame: quadgram, trigram, bigram and unigram. Each data frame contains the freqency of a sequence of N words from the sample data. The frequency is ranked descendingly. The previous N-1 words of a sequence of N words is added as an additional column to the data frame. 

* The N-gram frequency data frames are serialized as fst files to be used by the prediction model

* The huge size of the corpus data tremendously slows down the building and serializing of the N-gram frequency data frames. Packages like textcnt and fst prove to be the powerful tools for optimizing performance after much testing. They allow the sample to be much bigger, the tokenization, frequency generation, and serialization much faster.

</font>

Next Word Prediction Model
========================================================

<font size="5">

The prediction model loads the serialized N-gram frequency data frame files to initialize quadgram, trigram, bigram and unigram. It predicts the next could-be word by quering the highest frequency and use Stupid Back-off smoothig method to approximate the probability of an unseen N-gram by resorting to more frequent lower order N-grams.

* First, the user's input will go through the same data cleaning as the sample data has.

* Then the prediction model takes the last 3 words from the user's input and queries quadgram. If the input has 2 words, the model queries trigram, and bigram if only one word.

* Assuming the model gets the last 3 words from the user's input and queries quadgram, it searches column "pevious3" (preivious 3 words) and if a match is found, the corresponding 4 words will be picked as a candidate. When multiple 4 word candidates are found, the one with the highest frequency will be returned, and its last word will be the one the user might use next in the sentence.

* When no 4 word candidate is found, the model takes the last 2 words from the user's input and queries trigram using the same logic as above. When no candicate is found for 2 words, the very last word of the uesr's input will be used to query bigram. If no candicate found in bigram, the word with highest frequency in unigram will be chosen as the next could-be word.

</font>
