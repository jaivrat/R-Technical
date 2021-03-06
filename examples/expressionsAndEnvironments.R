#-----------------   EXPRESSIONS ----------------------#

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


#--------------------------------------------------------#
#-----------------   ENVIRONMENTS  ----------------------#
#--------------------------------------------------------#

#Environments are data structures in R that have special properties with regard 
#to their role in how R code is executed and how memory in R is organized. You 
#may not realize it but you’re probably already familiar with one environment 
#called the global environment. Environments formalize relationships between 
#variable names and values. When you enter x <- 55 into the R console what you’re
#saying is: assign the value of 55 to a variable called x, and store this assignment 
#in the global environment. The global environment is therefore where most R users 
#do most of their programming and analysis.


#You can create a new environment using new.env(). You can assign variables in 
#that environment in a similar way to assigning a named element of a list, or 
#you can use assign(). You can retrieve the value of a variable just like you 
#would retrieve the named element of a list, or you can use get(). 
#Notice that assign() and get() are opposites:

my_new_env <- new.env()
my_new_env$x <- 4
my_new_env$x
#[1] 4

assign("y", 9, envir = my_new_env)
get("y", envir = my_new_env)
#[1] 9
my_new_env$y
#[1] 9


#You can get all of the variable names that have been assigned in an environment 
# using ls(), you can remove an association between a variable name and a value 
# using rm(), and you can check if a variable name has been assigned in an environment
# using exists():

ls(my_new_env)
#[1] "x" "y"
rm(y, envir = my_new_env)
exists("y", envir = my_new_env)
#[1] TRUE
exists("x", envir = my_new_env)
#[1] TRUE
my_new_env$x
#[1] 4
my_new_env$y
#NULL


# Environments are organized in parent/child relationships such that every 
# environment keeps track of its parent, but parents are unaware of which 
# environments are their children. Usually the relationships between environments 
# is not something you should try to directly control. You can see the parents 
# of the global environment using the search() function:

search()

#Note: .GlobalEnv is child of all loaded libraries. Last loaded library is 
#the parent of .GlobalEnv






#-----------------   EXECUTION ENVIRONMENTS ----------------------#

x <- 10
my_func <- function(){
  x <- 5
  return(x)
}

my_func()


##So what exactly is happening above? First the name x is being assigned the 
# value 10 in the global environment. Then the name my_func is being assigned the 
# value of the function function(){x <- 5};return(x)} in the global environment. 
#When my_func() is executed, a new environment is created called the execution 
# environment which only exists while my_func() is running. Inside of the execution 
# environment the name x is assigned the value 5. When return() is executed it looks 
# first in the execution environment for a value that is assigned to x. 
#Then the value 5 is returned. In contrast to the situation above, take a look at 
# this variation:

x <- 10

another_func <- function(){
	  return(x)
}

another_func()
#[1] 10


## After seeing the cases above you may be curious if it’s possible for an execution 
#  environment to manipulate the global environment. You’re already familiar with the 
#  assignment operator <-, however you should also be aware that there’s another 
#  assignment operator called the complex assignment operator which looks like <<-. 
## You can use the complex assignment operator to re-assign or even create name-value 
#  bindings in the global environment from within an execution environment. In this 
#  first example, the function assign1() will change the value associated with the name x:

x <- 10
x
#[1] 10

assign1 <- function(){
  x <<- "Wow!"
}

assign1()
x
#[1] "Wow!"




##You can see that the value associated with x has been changed from 10 to "Wow!" in 
# the global environment. You can also use <<- to assign names to values that have 
# not been yet been defined in the global environment from inside a function:

#a_variable_name
#Error in eval(expr, envir, enclos): object 'a_variable_name' not found
exists("a_variable_name")
#[1] FALSE

assign2 <- function(){
  a_variable_name <<- "Magic!"
}

assign2()
exists("a_variable_name")
#[1] TRUE
a_variable_name
#[1] "Magic!"

#If you want to see a case for using <<- in action, see the section of this book 
#about functional programming and the discussion there about memoization.





