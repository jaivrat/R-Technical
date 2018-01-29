#Some of the R code that you write will be slow. Slow code often isn’t worth fixing in a script that you 
#will only evaluate a few times, as the time it will take to optimize the code will probably exceed the 
#time it takes the computer to run it. However, if you are writing functions that will be used repeatedly, 
#it is often worthwhile to identify slow sections of the code so you can try to improve speed in those sections.

#In this section, we will introduce the basics of profiling R code, using functions from two packages,
# microbenchmark and profvis. The profvis package is fairly new and requires recent versions of both R 
#(version 3.0 or higher) and RStudio. If you are having problems running either package, you should try 
#updating both R and RStudio (the Preview version of RStudio, which will provide full functionality 
# for profvis, is available for download 


#Pckages : microbenchmark, profvis




#The microbenchmark package is useful for running small sections of code to assess performance, as well as for comparing the speed of several functions that do the same thing. The microbenchmarkfunction from this package will run code multiple times (100 times is the default) and provide summary statistics describing how long the code took to run across those iterations. The process of timing a function takes a certain amount of time itself. The microbenchmarkfunction adjusts for this overhead time by running a certain number of “warm-up” iterations before running the iterations used to time the code.

#You can use the times argument in microbenchmark to customize how many iterations are used. For example, if you are working with a function that is a bit slow, you might want to run the code fewer times when benchmarking (although with slower or more complex code, it likely will make more sense to use a different tool for profiling, likeprofvis).

#You can include multiple lines of code within a single call to microbenchmark. However, to get separate benchmarks of line of code, you must separate each line by a comma:

library(microbenchmark)
microbenchmark(a <- rnorm(1000), 
                b <- mean(rnorm(1000)))
#Unit: microseconds
#                         expr    min      lq     mean median      uq     max neval
#             a <- rnorm(1000) 60.237 63.3700 68.65189 66.509 71.9920 136.785   100
#       b <- mean(rnorm(1000)) 64.838 69.3085 74.79522 71.616 77.6335 197.993   100
# 


#The microbenchmark function returns an object of the “microbenchmark” class. 
#This class has two methods for plotting results, ** autoplot.microbenchmark ** and 
# ** boxplot.microbenchmark ** . To use the autoplot method, you will need to have 
# ggplot2 loaded in your R session.

# autoplot 
# boxplot.microbenchmark


library(profvis)
example <- function(from, to)
{
   vals <- seq(from, to)
   sm   <- sum(vals)
   mu   <- sm/length(vals)
   return(mu)
}



profvis ({
	from = 0
	to = 10000000
	ans <- example(from, to)
})


profvis ({
	x <- rnorm(10)
	x <- rnorm(100)
	x <- rnorm(10000)
	x <- rnorm(100000)
	x <- rnorm(1000000)
})

#Documentation here:  https://rstudio.github.io/profvis/index.html

