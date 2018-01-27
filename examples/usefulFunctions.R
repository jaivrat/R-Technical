#The map family of functions applies a function to the elements of a data structure, usually a list or a vector. The function is evaluated once for each element of the vector with the vector element as the first argument to the function. The return value is the same kind if data structure (a list or vector) but with every element replaced by the result of the function being evaluated with the corresponding element as the argument to the function. In the purrr package the map() function returns a list , while the map_lgl(), map_chr(), and map_dbl()functions return vectors of logical values, strings, or numbers respectively. Let’s take a look at a few examples: 

library(purrr)

print("HELLO")




map_chr(c(5, 4, 3, 2, 1), function(x)
	                  {
                             c("one", "two", "three", "four", "five")[x]
                          })

map_lgl(c(1, 2, 3, 4, 5), function(x){ x > 3})

map_dbl(c(1, 2, 3, 4, 5), function(x){x*10})


#Think about evaluating each function above with just one of the arguments in the specified numeric vector, and then combining all of those function results into one vector.

#The map_if() function takes as its arguments a list or vector containing data, a predicate function, and then a function to be applied. A predicate function is a function that returns TRUE orFALSE for each element in the provided list or vector. In the case ofmap_if(): if the predicate functions evaluates to TRUE, then the function is applied to the corresponding vector element, however if the predicate function evaluates to FALSE then the function is not applied. The map_if() function always returns a list, so I’m piping the result of map_if() to unlist() so it look prettier:

map_if(1:5, function(x){
                     x %% 2 == 0
            },
            function(y){
                    y^2
            }) %>% unlist()

#Notice how only the even numbers are squared, while the odd numbers are left alone.

#The map_at() function only applies the provided function to elements of a vector specified by their indexes. map_at() always returns a list so like before I’m piping the result to unlist():

map_at(seq(100, 500, 100), c(1, 3, 5), function(x){
	         x - 10
	    }) %>% unlist()


#Like we expected to happen the providied function is only applied to the first, third, and fifth element of the vector provided.

#In each of the examples above we have only been mapping a function over one data structure, however you can map a function over two data structures with the map2() family of functions. The first two arguments should be two vectors of the same length, followed by a function which will be evaluated with an element of the first vector as the first argument and an element of the second vector as the second argument. For example:


map2_chr(letters, 1:26, paste)


#The pmap() family of functions is similar to map2(), however instead of mapping across two vectors or lists, you can map across any number of lists. The list argument is a list of lists that the function will map over, followed by the function that will applied:

pmap_chr(list(
           list(1, 2, 3),
	   list("one", "two", "three"),
	   list("uno", "dos", "tres")
	 ), 
	 paste)

# Mapping is a powerful technique for thinking about how to apply computational operations to your data.


##----------------------  REDUCE ---------------------- ##
#List or vector reduction iteratively combines the first element of a vector with the second element of a vector, then that combined result is combined with the third element of the vector, and so on until the end of the vector is reached. The function to be applied should take at least two arguments. Where mapping returns a vector or a list, reducing should return a single value. Some examples usingreduce() are illustrated below:

reduce(c(1, 3, 5, 7), function(x, y)
                      {
	               message("x is ", x)
		       message("y is ", y)
		       message("")
		       x + y
	              })

#On the first iteration x has the value 1 and y has the value 3, then the two values are combined (they’re added together). On the second iteration x has the value of the result from the first iteration (4) and y has the value of the third element in the provided numeric vector (5). This process is repeated for each iteration. Here’s a similar example using string data:


reduce(letters[1:4], function(x, y){
	         message("x is ", x)
		   message("y is ", y)
		   message("")
		     paste0(x, y)
		      })


#By default reduce() starts with the first element of a vector and then the second element and so on. In contrast the reduce_right()function starts with the last element of a vector and then proceeds to the second to last element of a vector and so on:

reduce_right(letters[1:4], function(x, y){
		       message("x is ", x)
		         message("y is ", y)
		         message("")
			   paste0(x, y)
		      })



##----------------------  SEARCH  ---------------------- ##

#You can search for specific elements of a vector using the contains() and detect() functions. contains() will returnTRUE if a specified element is present in a vector, otherwise it returnsFALSE:

purrr::has_element(letters, 'a')

purrr::has_element(letters, "A")

#The detect() function takes a vector and a predicate function as arguments and it returns the first element of the vector for which the predicate function returns TRUE:

detect(20:40, function(x){
	         x > 22 && x %% 2 == 0
		      })



#The detect_index() function takes the same arguments, however it returns the index of the provided vector which contains the first element that satisfies the predicate function:

detect_index(20:40, function(x)
	            {
		       x > 22 && x %% 2 == 0
		    })



##----------------------  FILTER  ---------------------- ##

#The group of functions that includes keep(), discard(), every(), and some() are known as filter functions. Each of these functions takes a vector and a predicate function. For keep() only the elements of the vector that satisfy the predicate function are returned while all other elements are removed:

keep(1:20, function(x){
	       x %% 2 == 0
		    })



# The discard() function works similarly, it only returns elements that don’t satisfy the predicate function:

discard(1:20, function(x){
		  x %% 2 == 0
		    })

# The every() function returns TRUE only if every element in the vector satisfies the predicate function, while the some() function returns TRUE if at least one element in the vector satisfies the predicate function:

every(1:20, function(x){
	        x %% 2 == 0
		    })

some(1:20, function(x){
	       x %% 2 == 0
		    })




##----------------------  COMPOSE  ---------------------- ##

# Finally, the compose() function combines any number of functions into one function:

n_unique <- compose(length, unique)

# The composition above is the same as:
# n_unique <- function(x){
#   length(unique(x))
# }

rep(1:5, 1:5)

n_unique(rep(1:5, 1:5))



##----------------------  PARTIAL APPLICATION  ---------------------- ##
#Partial application of functions can allow functions to behave a little like data structures. Using the partial() function from the purrrpackage you can specify some of the arguments of a function, and then partial() will return a function that only takes the unspecified arguments. Let’s take a look at a simple example:

mult_three_n <- function(x, y, z){
	  x * y * z
}

mult_by_15 <- partial(mult_three_n, x = 3, y = 5)

mult_by_15(z = 4)


#By using partial application you can bind some data to the arguments of a function before using that function elsewhere.









##---------------------- SIDE EFFECTS   ---------------------- ##
#Side effects of functions occur whenever a function interacts with the “outside world” – reading or writing data, printing to the console, and displaying a graph are all side effects. The results of side effects are one of the main motivations for writing code in the first place! Side effects can be tricky to handle though, since the order in which functions with side effects are executed often matters and there are variables that are external to the program (the relative location of some data). If you want to evaluate a function across a data structure you should use the walk() function from purrr. Here’s a simple example:

walk(c("Friends, Romans, countrymen,",
       "lend me your ears;",
       "I come to bury Caesar,", 
       "not to praise him."), message)




##---------------------- Recursion  ---------------------- ##
#Recursion is very powerful tool, both mentally and in software development, for solving problems. Recursive functions have two main parts: a few easy to solve problems called “base cases,” and then a case for more complicated problems where the function is called inside of itself. The central philosophy of recursive programming is that problems can be broken down into simpler parts, and then combining those simple answers results in the answer to a complex problem.

#Imagine you wanted to write a function that adds together all of the numbers in a vector. You could of course accomplish this with a loop:

vector_sum_loop <- function(v){
  result <- 0
  for(i in v){
    result <- result + i
  }
  result
}

vector_sum_loop(c(5, 40, 91))

#Recursive version:

vector_sum_rec <- function(v){
  if(length(v) == 1){
    v
  } else {
    v[1] + vector_sum_rec(v[-1])
  }
}

vector_sum_rec(c(5, 40, 91))

#fibonacci

fib <- function(n){
  stopifnot(n > 0)
  if(n == 1){
     0
  } else if(n == 2){
     1
  } else {
     fib(n - 1) + fib(n - 2)
  }
}

map_dbl(1:12, fib)

#memoized fibinacci
fib_tbl <- c(0, 1, rep(NA, 23))
fib_mem <- function(n){
  stopifnot(n > 0)
  if(!is.na(fib_tbl[n])){
      fib_tbl[n]
  } else {
      fib_tbl[n - 1] <<- fib_mem(n - 1)
      fib_tbl[n - 2] <<- fib_mem(n - 2)
      fib_tbl[n - 1] + fib_tbl[n - 2]
  }
}

map_dbl(1:12, fib_mem)

#It works! But is it any faster than the original fib()? Below I’m going to use the microbenchmark package in order assess whether fib()or fib_mem() is faster:


library(purrr)
library(microbenchmark)
library(tidyr)
library(magrittr)
library(dplyr)

fib_data <- map(1:10, function(x){microbenchmark(fib(x), times = 100)$time})
names(fib_data) <- paste0(letters[1:10], 1:10)
fib_data <- as.data.frame(fib_data)

fib_data %<>%
gather(num, time) %>%
group_by(num) %>%
summarise(med_time = median(time))

memo_data <- map(1:10, function(x){microbenchmark(fib_mem(x))$time})
names(memo_data) <- paste0(letters[1:10], 1:10)
memo_data <- as.data.frame(memo_data)

memo_data %<>%
gather(num, time) %>%
group_by(num) %>%
summarise(med_time = median(time))

plot(1:10, fib_data$med_time, xlab = "Fibonacci Number", ylab = "Median Time (Nanoseconds)",
		      pch = 18, bty = "n", xaxt = "n", yaxt = "n")
axis(1, at = 1:10)
axis(2, at = seq(0, 350000, by = 50000))
points(1:10 + .1, memo_data$med_time, col = "blue", pch = 18)
legend(1, 300000, c("Not Memorized", "Memoized"), pch = 18, 
       col = c("black", "blue"), bty = "n", cex = 1, y.intersp = 1.5)

