#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
#library(rattle)

#data(wine, package = 'rattle')

#as shinyapps.io cannot use rattle package so I need to download the wine dataset manually
if(!file.exists("wine.data"))
        download.file("http://archive.ics.uci.edu/ml/machine-learning-databases/wine/wine.data","wine.data")
wine <- read.table("wine.data",sep=",")
names(wine) <- c("Type","Alcohol","Malic","Ash","Alcalinity","Magnesium","Phenols","Flavanoids","Nonflavanoids","Proanthocyanins","Color","Hue","Dilution","Proline")
wine$Type <- as.factor(wine$Type)

shinyUI(fluidPage(# Application title
        sidebarLayout(
                sidebarPanel(
                        checkboxInput("eigenvectors", "Show eigenvectors", TRUE),
                        checkboxInput("showtext", "Show Actual VS Predicted Text", FALSE),
                        h4("Please select test record or manually adjust the slidebars"),
                        selectInput(
                                "testSelect",
                                "Select Test Record:",
                                c(
                                        "test1" = 1,
                                        "test2" = 2,
                                        "test3" = 3,
                                        "test4" = 4,
                                        "test5" = 5,
                                        "test6" = 6,
                                        "test7" = 7,
                                        "test8" = 8,
                                        "test9" = 9,
                                        "test10" = 10,
                                        "test11" = 11,
                                        "test12" = 12,
                                        "test13" = 13,
                                        "test14" = 14,
                                        "test15" = 15,
                                        "test16" = 16
                                )
                        ),
                        h4("Wine Data Slidebars"),
                        sliderInput(
                                "Color",
                                "Color",
                                min = min(wine$Color),
                                max = max(wine$Color),
                                value = wine$Color[1],
                                step = 0.01
                        ),
                        sliderInput(
                                "Flavanoids",
                                "Flavanoids",
                                min = min(wine$Flavanoids),
                                max = max(wine$Flavanoids),
                                value = wine$Flavanoids[1],
                                step = 0.01
                        ),
                        sliderInput(
                                "Proline",
                                "Proline",
                                min = min(wine$Proline),
                                max = max(wine$Proline),
                                value = wine$Proline[1],
                                step = 1
                        ),
                        sliderInput(
                                "Alcohol",
                                "Alcohol",
                                min = min(wine$Alcohol),
                                max = max(wine$Alcohol),
                                value = wine$Alcohol[1],
                                step = 0.01
                        ),
                        sliderInput(
                                "Dilution",
                                "Dilution",
                                min = min(wine$Dilution),
                                max = max(wine$Dilution),
                                value = wine$Dilution[1],
                                step = 0.01
                        ),
                        sliderInput(
                                "Hue",
                                "Hue",
                                min = min(wine$Hue),
                                max = max(wine$Hue),
                                value = wine$Hue[1],
                                step = 0.01
                        ),
                        sliderInput(
                                "Phenols",
                                "Phenols",
                                min = min(wine$Phenols),
                                max = max(wine$Phenols),
                                value = wine$Phenols[1],
                                step = 0.01
                        ),
                        sliderInput(
                                "Alcalinity",
                                "Alcalinity",
                                min = min(wine$Alcalinity),
                                max = max(wine$Alcalinity),
                                value = wine$Alcalinity[1],
                                step = 0.1
                        ),
                        sliderInput(
                                "Magnesium",
                                "Magnesium",
                                min = min(wine$Magnesium),
                                max = max(wine$Magnesium),
                                value = wine$Magnesium[1],
                                step = 1
                        ),
                        sliderInput(
                                "Malic",
                                "Malic",
                                min = min(wine$Malic),
                                max = max(wine$Malic),
                                value = wine$Malic[1],
                                step = 0.01
                        ),
                        sliderInput(
                                "Proanthocyanins",
                                "Proanthocyanins",
                                min = min(wine$Proanthocyanins),
                                max = max(wine$Proanthocyanins),
                                value = wine$Proanthocyanins[1],
                                step = 0.01
                        ),
                        sliderInput(
                                "Nonflavanoids",
                                "Nonflavanoids",
                                min = min(wine$Nonflavanoids),
                                max = max(wine$Nonflavanoids),
                                value = wine$Nonflavanoids[1],
                                step = 0.01
                        ),
                        sliderInput(
                                "Ash",
                                "Ash",
                                min = min(wine$Ash),
                                max = max(wine$Ash),
                                value = wine$Ash[1],
                                step = 0.01
                        )
                ),
                
                # Show a plot and prediction
                mainPanel(tabsetPanel(
                        tabPanel(
                                "Plot&Predict",
                                titlePanel("Principal Components Analysis (PCA) for Wine Dataset"),
                                plotOutput("pcaPlot"),
                                h1(textOutput("pred"))
                        ),
                        tabPanel(
                                "Data",
                                h2("Dataset"),
                                p(
                                        "Wine dataset has 13 predictors variables and 1 class variable
                                        which is 'Type'. There are 3 types of wine."
                                ),
                                p("Wine Dataset can be loaded in R using"),
                                p("data(wine, package='rattle')"),
                                p("See more information about the Wine dataset at"),
                                a(
                                        href = "https://archive.ics.uci.edu/ml/datasets/Wine",
                                        "https://archive.ics.uci.edu/ml/datasets/Wine",
                                        target = "_blank"
                                ),
                                tableOutput("Data")
                                ),
                        tabPanel(
                                "About",
                                h2("How to use this app"),
                                p(
                                        "This shiny app will predict types of wine. You can use slidebars
                                        to adjust predictors or select the pre-defined test records"
                                ),
                                h2("PCA Plot"),
                                p(
                                        "Principal component analysis (PCA) is a technique used to
                                        emphasize variation and bring out strong patterns in a dataset.
                                        It's often used to make data easy to explore and visualize"
                                ),
                                p(
                                        "In this project, I will use PCA in order to do data exploration
                                        for Wine Dataset."
                                ),
                                p(
                                        "Wine dataset is a Multivariate data which has 13 variables.
                                        PCA will be used to reduced these 13 variables to 2 PCA variables
                                        which are still enough to capture most of original data.
                                        After these, the 2 PCA variables can be used to do data exploration
                                        or to be used as predictors in classification algorithm."
                                ),
                                h2("Prediction Model"),
                                p(
                                        "The 2 PCA variables will be used as predictors in RandomForest to
                                        predict the types of wine."
                                ),
                                p(textOutput("trainAccuracy")),
                                p(textOutput("testAccuracy")),
                                p("Shiny App for this project is at"),
                                a(
                                        href = "https://suteak.shinyapps.io/dev_data_product/"
                                        ,
                                        "https://suteak.shinyapps.io/dev_data_product/",
                                        target = "_blank"
                                ),
                                p("Source code for this project are at"),
                                a(
                                        href = "https://github.com/eakalak-suthampan/dev_data_product"
                                        ,
                                        "https://github.com/eakalak-suthampan/dev_data_product",
                                        target = "_blank"
                                ),
                                p("Presentation for this project is at"),
                                a(
                                        href = "http://rpubs.com/suteak/253795"
                                        ,
                                        "http://rpubs.com/suteak/253795",
                                        target = "_blank"
                                )
                                )
                                ))
                )))
