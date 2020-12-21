library(shiny)

require(dplyr)
require(ngram)
require(stringr)
require(tm)
require(fst)


freq.unigram <- read.fst("1gram.fst")
freq.bigram <- read.fst("2gram.fst")
freq.trigram <- read.fst("3gram.fst")
freq.quadgram <- read.fst("4gram.fst")

badwords.file <- "list.txt"
profanity <- readLines(badwords.file, encoding = "UTF-8", skipNul = TRUE)
profanity <- iconv(profanity, "latin1", "ASCII", sub = "")

cleanText <- function(text) {
        # Set the text to lowercase
        text <- tolower(text)
        # Remove mentions, urls, emojis, hashtags, numbers
        text <- gsub("@\\w+", " ", text)
        text <- gsub("https?://.+", " ", text)
        text <- gsub("\\d+\\w*\\d*", " ", text)
        text <- gsub("#\\w+", " ", text)
        text <- gsub("[^\x01-\x7F]", " ", text)
        # remove profane words
        text <- removeWords(text, profanity)
        # remove punctuations except apostrophes
        text <- gsub("[^'[:^punct:]]", " ", text, perl=T)
        # remove newlines
        text <- gsub("\n", " ", text)
        # remove leading and trailing whitespace
        text <- gsub("^\\s+|\\s+$", "", text)
        # remove extra space
        text <- stripWhitespace(text)
        text
}

predict <- function(input) {
        
        clean.input <- cleanText(input)
        numword <- wordcount(clean.input)
        # take the last 3 words of the input when the number of words is more than 3
        if (numword > 3 ) clean.input <- word(clean.input, numword-2, -1)
        
        ngram <- 1
        if (wordcount(clean.input) == 1) ngram <- 2
        if (wordcount(clean.input) == 2) ngram <- 3
        if (wordcount(clean.input) == 3) ngram <- 4
        
        suggested.word <- ""
        
        # predict with the last 3 words of the input
        if (ngram == 4) {
                found <- freq.quadgram %>% filter(previous3 == clean.input)
                if (nrow(found) > 0) {
                        suggested.word <- word(found$word, -1)[1]
                } else {
                        # take the last 2 words to predict with trigram if nothing returns from quadgram
                        clean.input <- word(clean.input, 2, -1)
                        ngram <- 3
                }    
        }
        
        # predict with the last 2 words of the input
        if (ngram == 3) {
                found <- freq.trigram %>% filter(previous2 == clean.input)
                if (nrow(found) > 0) {
                        suggested.word <- word(found$word, -1)[1]
                } else {
                        # take the last word to predict with bigram if nothing returns from trigram
                        clean.input <- word(clean.input, -1)
                        ngram <- 2
                }
        }
        
        # predict with the last word of the input
        if (ngram == 2) {
                found <- freq.bigram %>% filter(previous1 == clean.input)
                if (nrow(found) > 0) {
                        suggested.word <- word(found$word, -1)[1]
                } else {
                        # Pick top one from unigram if nothing returns from bigram
                        suggested.word <- freq.unigram$word[1]
                }
                
        }
        
        suggested.word
}

ui <- fluidPage(
        
        titlePanel("Next Word Prediction"),
        br(),
        sidebarPanel(
                
                textInput("userInput",
                          "Enter a word or phrase:",
                          value =  "",
                          placeholder = "Enter text here"),
        ),
        
        mainPanel(
                h5(strong("The next word might be:")),
                textOutput("nextword"),
                br(),
                h5(strong("Souce code:")),
                HTML("<a href='https://github.com/weizhang280/capstone/'>https://github.com/weizhang280/capstone/</a>")
        )
        
)

server <- function(input, output) {
        
        output$userInput <- renderText({input$userInput
        })             
        
        output$nextword <- renderText({
                input <- input$userInput
                predict(input)
        })
}

shinyApp(ui, server)