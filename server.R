#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
#library(rattle)
library(ggfortify)
library(caret)
library(randomForest)
library(e1071)

#data(wine, package = 'rattle')

#as shinyapps.io cannot use rattle package so I need to download the wine dataset manually
if(!file.exists("wine.data"))
        download.file("http://archive.ics.uci.edu/ml/machine-learning-databases/wine/wine.data","wine.data")
wine <- read.table("wine.data",sep=",")
names(wine) <- c("Type","Alcohol","Malic","Ash","Alcalinity","Magnesium","Phenols","Flavanoids","Nonflavanoids","Proanthocyanins","Color","Hue","Dilution","Proline")
wine$Type <- as.factor(wine$Type)

set.seed(555)
inTrain <- createDataPartition(y = wine$Type, p = 0.9, list = FALSE)
testing <- wine[-inTrain, ]
training <- wine[inTrain, ]

pca.train <- prcomp(training[, -1], center = TRUE, scale. = TRUE)
pca.train.df <-
        data.frame(training$Type, pca.train$x[, 1], pca.train$x[, 2])
names(pca.train.df) <- c("Type", "PC1", "PC2")

rfFit <- randomForest(Type ~ ., data = pca.train.df)

pca.all <- prcomp(wine[, -1], center = TRUE, scale. = TRUE)

shinyServer(function(input, output, clientData, session) {
        activeInput <- reactive({
                tmpData <-
                        data.frame(
                                input$Alcohol,
                                input$Malic,
                                input$Ash,
                                input$Alcalinity,
                                input$Magnesium,
                                input$Phenols,
                                input$Flavanoids,
                                input$Nonflavanoids,
                                input$Proanthocyanins,
                                input$Color,
                                input$Hue,
                                input$Dilution,
                                input$Proline
                        )
                names(tmpData) <- names(wine[, -1])
                tmpData
        })
        output$pcaPlot <- renderPlot({
                inputDF <- activeInput()
                p1 <- predict(pca.train, inputDF)
                p2 <- predict(pca.train, testing[, -1])
                p2 <- as.data.frame(p2)
                p2 <- p2[, 1:2]
                p2$Type <- testing$Type
                p3 <- as.data.frame(pca.all$x[-inTrain, 1:2])
                g <-
                        autoplot(
                                pca.all,
                                data = wine,
                                colour = 'Type',
                                frame = TRUE,
                                frame.type = 't',
                                frame.colour = 'Type',
                                scale = 0,
                                loadings = input$eigenvectors,
                                loadings.colour = 'blue',
                                loadings.label = input$eigenvectors,
                                loadings.label.size = 5
                        ) +
                        geom_point(
                                x = p1[1],
                                y = p1[2],
                                color = 'black',
                                size = 5,
                                pch = 2
                        ) +
                        geom_point(data = p2,
                                   aes(
                                           x = PC1,
                                           y = PC2,
                                           shape = "predicted point \nfor test record"
                                   ))
                if (input$showtext) {
                        g <-
                                g + geom_text(
                                        data = p3,
                                        aes(
                                                x = PC1,
                                                y = PC2,
                                                label = "Actual test"
                                        ),
                                        hjust = 0,
                                        vjust = 0
                                ) +
                                geom_text(
                                        data = p2,
                                        aes(
                                                x = PC1,
                                                y = PC2,
                                                label = "Predicted test"
                                        ),
                                        hjust = 0,
                                        vjust = 0
                                )
                }
                g
        })
        output$pred <- renderText({
                inputDF <- activeInput()
                p1 <- predict(pca.train, inputDF)
                pca.test <- data.frame(p1[, 1], p1[, 2])
                names(pca.test) <- c("PC1", "PC2")
                paste("Predicted Wine Type is",
                      predict(rfFit, pca.test))
        })
        observe({
                testSelect <- input$testSelect
                testSelect <- as.integer(testSelect)
                updateSliderInput(session, "Alcohol", value = testing[testSelect, c("Alcohol")])
                updateSliderInput(session, "Malic", value = testing[testSelect, c("Malic")])
                updateSliderInput(session, "Ash", value = testing[testSelect, c("Ash")])
                updateSliderInput(session, "Alcalinity", value = testing[testSelect, c("Alcalinity")])
                updateSliderInput(session, "Magnesium", value = testing[testSelect, c("Magnesium")])
                updateSliderInput(session, "Phenols", value = testing[testSelect, c("Phenols")])
                updateSliderInput(session, "Flavanoids", value = testing[testSelect, c("Flavanoids")])
                updateSliderInput(session, "Nonflavanoids", value = testing[testSelect, c("Nonflavanoids")])
                updateSliderInput(session, "Proanthocyanins", value = testing[testSelect, c("Proanthocyanins")])
                updateSliderInput(session, "Color", value = testing[testSelect, c("Color")])
                updateSliderInput(session, "Hue", value = testing[testSelect, c("Hue")])
                updateSliderInput(session, "Dilution", value = testing[testSelect, c("Dilution")])
                updateSliderInput(session, "Proline", value = testing[testSelect, c("Proline")])
        })
        output$Data <- renderTable(wine)
        output$trainAccuracy <- renderText(paste(
                "training accuracy is",
                round(
                        confusionMatrix(training$Type,
                                        predict(rfFit))$overall[1] * 100,
                        2
                ),
                "%"
        ))
        output$testAccuracy <- renderText({
                pred <- predict(pca.train, testing[, -1])
                pred <- as.data.frame(pred)
                pred <- pred[, 1:2]
                pred$Type <- testing$Type
                paste(
                        "testing accuracy is",
                        round(
                                confusionMatrix(testing$Type,
                                                predict(rfFit, pred))$overall[1] * 100,
                                2
                        ),
                        "% (just 16 test records)"
                )
        })
        
})