
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
irisnames <- c(names(iris[,-5]),'PC1','PC2')

shinyUI(
  navbarPage("Clustering Iris",
             tabPanel('Application', 
                      fluidPage(
                        
                        # Application title
                        titlePanel(h1("Clustering Iris")),
                        
                        # Sidebar with a slider input for number of bins
                        sidebarLayout(
                          sidebarPanel(
                            selectInput('xaxis', 'X axis', irisnames, selected = "Petal.Length"),
                            selectInput('yaxis', 'Y axis', irisnames, selected = "Petal.Width"),
                            selectInput('method', 'Clustering method', c('No method','kmeans','mclust')),
#                             checkboxInput("plotpca", label = "Plot principal components", value = FALSE),
                            conditionalPanel(condition = "input.method != 'No method'",
                                             sliderInput("nclust", "Number of clusters", 
                                                         min = 2, max = 5, value = 3, step= 1)),
#                                              numericInput('nclust', 'Number of clusters', 3,
#                                                           min = 2, max = 5)),
                            checkboxInput("usepca", label = "Use PCA before clustering", value = FALSE)
                            
                          ),
                          
                          # Show a plot of the generated distribution
                          mainPanel( 
                            # Print out the method
                            h4(textOutput('method')),
                            conditionalPanel(condition = 'input.usepca', p("Clustering on principal components")),
                            # Plot the data
                            plotOutput("distPlot"),
                            h5("Distribution of clusters over Species"),
                            tableOutput("classtab")
                          )
                        )
                      )
             ),
             tabPanel('About',includeMarkdown('clustdoc.Rmd'))
))