
#---------------------  GENERATING ERRORS --------------------------#

# stop() : 
# stopifnot() : takes a series of logical expressions as arguments and if any of them are 
#               false an error is generated specifying which expression is false
#

#stopifnot(2>1, 1>2)
#Error: 1 > 2 is not TRUE

#The warning() function creates a warning, and the function itself is very similar
#to the stop() function. Remember that a warning does not stop the execution of a 
#program (unlike an error.)

warning("Consider yourself warned!")

#Just like errors, a warning generated inside of a function will include the name 
# of the function it was generated in:

make_NA <- function(x)
{
  warning("Generating an NA.")
  NA
}

make_NA("Sodium")
#Warning in make_NA("Sodium"): Generating an NA.
#[1] NA

#Messages are simpler than errors or warnings, they just print strings to the R console.
#You can issue a message with themessage() function:
message("In a bottle.")


#------------------ WHEN TO GENERATE WARNINGS AND ERRORS ------------------------#

#Stopping the execution of your program with stop() should only happen in the event 
#of a catastrophe - meaning only if it is impossible for your program to continue. If 
#there are conditions that you can anticipate that would cause your program to create 
#an error then you should document those conditions so whoever uses your software is 
# aware. Common failure conditions like providing invalid arguments to a function 
# should be checked at the beginning of your program so that the user can quickly 
# realize something has gone wrong. This is case of checking function inputs is a typical 
# use of thestopifnot() function.

#You can think of a function as kind of contract between you and the user: if the 
#user provides specified arguments your program will provide predictable results. Of 
#course it's impossible for you to anticipate all of the potential uses of your program, 
#so the results of executing a function can only be predictable with regard to the type 
#of the result. It's appropriate to create a warning when this contract between you and 
#the user is violated. A perfect example of this situation is the result of 
#as.numeric(c("5", "6", "seven")) which we saw before. The user expects a vector of 
# numbers to be returned as the result of as.numeric() but "seven" is coerced into 
#being NA, which is not completely intuitive.

#R has largely been developed according to the Unix Philosophy 
# (which is further discussed in Chapter 3) which generally discourages printing text 
#to the console unless something unexpected has occurred. Languages than commonly run 
#on Unix systems like C, C++, and Go are rarely used interactively, meaning that they 
#usually underpin computer infrastructure (computers "talking" to other computers). 
#Messages printed to the console are therefore not very useful since nobody will ever 
# read them and it's not straightforward for other programs to capture and interpret 
# them. In contrast R code is frequently executed by human beings in the R console which 
# serves as an interactive environment between the computer and person at the keyboard. 
# If you think your program should produce a message, make sure that the output of the 
# message is primarily meant for a human to read. You should avoid signaling a condition 
# or the result of your program to another program by creating a message.


#---------------------- HANDLING ERRORS --------------------------------------#
#The tryCatch() function is the workhorse of handling errors and warnings in R. The 
#first argument of this function is any R expression, followed by conditions which 
#specify how to handle an error or a warning. The last argument finally specifies
#a function or expression that will be executed after the expression no matter what, 
#even in the event of an error or a warning


#This one catches errors and warnings gracefully:
beera <- function(expr){
	  tryCatch(expr,
            error = function(e){
	               message("An error occurred:\n", e)
	            },
            warning = function(w){
                 message("A warning occured:\n", w)
            },
            finally = {
                  message("Finally done!")
            })
         }


#This function takes an expression as an argument and tries to evaluate it. If the 
#expression can be evaluated without any errors or warnings then the result of the expression is returned and the message Finally done! is printed to the R console. If an error or warning is generated then the functions that are provided to the error or warning arguments are printed. Let's try this function out with a few examples.


beera({ 2 + 2 })

#Finally done!
#[1] 4

beera({"two" + 2})

#An error occurred:
#Error in "two" + 2: non-numeric argument to binary operator
#
#Finally done!

beera({ as.numeric(c(1, "two", 3)) })

#A warning occured:
#simpleWarning in doTryCatch(return(expr), name, parentenv, handler): NAs introduced by coercion

#Finally done!




#You can see that providing a string causes this function to raise an error. You could imagine though that you want to use this function across a list of different data types, and you only want to know which elements of that list are even numbers. You might think to write the following:

is_even_error <- function(n){
	  tryCatch(n %% 2 == 0,
                   error = function(e){
		               FALSE
		            }
		   )
}

is_even_error(714)
#[1] TRUE

is_even_error("eight")
#[1] FALSE


#This appears to be working the way you intended, however when applied to more data
#this function will be seriously slow compared to alternatives. For example I could
#do a check that n is numeric before treating n like a number:

is_even_check <- function(n)
{
  is.numeric(n) && n %% 2 == 0
}

is_even_check(1876)
#[1] TRUE

is_even_check("twelve")
#[1] FALSE


# Notice that by using `is.numeric()` before the "AND" operator (`&&`) the
# expression `n %% 2 == 0` is never evaluated. This is a programming language
# design feature called "short circuiting." The expression can never evaluate
# to `TRUE` if the left hand side of `&&` evaluates to `FALSE`, so the right
# hand side is ignored.

#To demonstrate the difference in the speed of the code we'll use the microbenchmark 
# package to measure how long it takes for each function to be applied to the same data.

library(microbenchmark)
microbenchmark(sapply(letters, is_even_check))

microbenchmark(sapply(letters, is_even_error))

#The error catching approach is nearly 15 times slower!
