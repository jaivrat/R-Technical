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




