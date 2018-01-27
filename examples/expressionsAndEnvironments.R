#-----------------   EXPRESSIONS -----------------------------------#

#Expressions are encapsulated operations that can be executed by R. 
#This may sound complicated, but using expressions allows you manipulate 
#code with code! You can create an expression using the quote() function. 
#For that function’s argument, just type whatever you would normally type into the R console.
#For example:

two_plus_two <- quote(2 + 2)
two_plus_two

#You can execute this expressions using the eval() function:
eval(two_plus_two)



# You might encounter R code that is stored as a string that you want to 
# evaluate with eval(). You can use parse() to transform a string into an expression:

tpt_string <- "2 + 2"
tpt_expression <- parse(text = tpt_string)
eval(tpt_expression)


#Another example
s <- "mm <- function(a,b){ a + b}"
express <- parse(text = s)
eval(express)
jj <- eval(express)
jj(4,5)
#[1] 9
mm
#function(a,b){ a + b}
mm(6,9)
#[1] 15




#You can reverse this process and transform an expression into a string using deparse():
deparse(two_plus_two)
#[1] "2 + 2"


#One interesting feature about expressions is that you can access and 
#modify their contents like you a list(). This means that you can change the 
#values in an expression, or even the function being executed in the 
#expression before it is evaluated:
sum_expr <- quote(sum(1, 5))
eval(sum_expr)
#[1] 6
sum_expr[[1]]
#sum
sum_expr[[2]]
#[1] 1
sum_expr[[3]]
#[1] 5
sum_expr[[1]] <- quote(paste0)
sum_expr[[2]] <- quote(4)
sum_expr[[3]] <- quote(6)
eval(sum_expr)
#[1] "46"



#You can compose expressions using the call() function. The first 
# argument is a string containing the name of a function, followed by 
# the arguments that will be provided to that function.
sum_40_50_expr <- call("sum", 40, 50)
sum_40_50_expr
#sum(40, 50)
eval(sum_40_50_expr)
#[1] 90



#You can capture the the expression an R user typed into the R console 
# when they executed a function by including match.call() in the function 
# the user executed:

return_expression <- function(...)
{
  match.call()
}

return_expression(2, col = "blue", FALSE)
return_expression(2, col = "blue", FALSE)

#You could of course then manipulate this expression inside of the function 
# you’re writing. The example below first uses match.call()to capture the 
# expression that the user entered. The first argument of the function is
# then extracted and evaluated. If the first expressions is a number, then
# a string is returned describing the first argument, otherwise the string
# "The first argument is not numeric." is returned.

first_arg <- function(...){
  expr <- match.call()
  first_arg_expr <- expr[[2]]
  first_arg <- eval(first_arg_expr)
  if(is.numeric(first_arg)){
        paste("The first argument is", first_arg)
  } else {
        "The first argument is not numeric."
  }
}

first_arg(2, 4, "seven", FALSE)
#[1] "The first argument is 2"

first_arg("two", 4, "seven", FALSE)
#[1] "The first argument is not numeric."

#Expressions are a powerful tool for writing R programs that can manipulate
# other R programs.

