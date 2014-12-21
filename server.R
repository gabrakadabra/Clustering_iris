
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(lattice)
library(mclust)
library(ggplot2)
library(dplyr)

# iris without Species
iri <- subset(iris, select = -Species)
iri.pc <- as.data.frame(prcomp(iri, scale. = T)$x)[,c(1,2)]
iri.all <- cbind(iri, iri.pc)

shinyServer(function(input, output) {
  AD <- reactive({
    # set data
    if(input$usepca){
      cdata <-  as.data.frame(iri.pc)
    }else{
      cdata <- iri
    }

    # Cluster analysis
    if(input$method == 'mclust'){
      class <- factor(Mclust(cdata, G = input$nclust)$classification)
    } else if(input$method == 'kmeans'){
      class <- factor(kmeans(cdata, input$nclust)$cluster)
    } else {
      class <- iris$Species
    }
    
    class
  })
  
  # show the name of the method
  output$method <- renderText({paste('Clustering using', input$method)})  
  
  # pca or not
  output$usepca <- renderText({ input$usepca })
  
  # classification table
  output$classtab <- renderTable(xtabs(~iris$Species + AD()), digits = 0)
    
  # Plot the outcome
  output$distPlot <- renderPlot({
    # create a GGplot
    iri.all$class <- AD()
    
    # if plotpca plot principal components
      p <- iri.all %>% ggplot() + geom_point(aes_string(x = input$xaxis, y = input$yaxis, 
                                                        shape = 'iris$Species',
                                                       colour = 'class')) + 
      scale_shape('Species') + scale_color_brewer('Classification',palette = 'Set1') + theme_classic()
    
    p
    
  })
  
})
