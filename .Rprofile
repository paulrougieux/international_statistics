

options(rstudio.markdownToHTML = 
  function(inputFile, outputFile) {      
    require(markdown)
    htmlOptions <- markdownHTMLOptions(defaults=TRUE)
    htmlOptions <- c(htmlOptions, "toc")
    markdownToHTML(inputFile, outputFile, options = htmlOptions) 
  }
) 