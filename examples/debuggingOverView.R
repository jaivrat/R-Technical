
#This section describes the tools for debugging your software in R. R comes with a set of built-in
#tools for interactive debugging that can be useful for tracking down the source of problems. 
#These functions are

# browser(): an interactive debugging environment that allows you to step through code one expression at a time
# debug() / debugonce(): a function that initiates the browser within a function
# trace(): this function allows you to temporarily insert pieces of code into other functions to modify their behavior
# recover(): a function for navigating the function call stack after a function has thrown an error
# traceback(): prints out the function call stack after an error occurs; does nothing if there’s no error





#-------------------- traceback() -----------------------------#
check_n_value <- function(n) {
    if(n > 0) {
       stop("n should be <= 0")
    }
}

error_if_n_is_greater_than_zero <- function(n){
    check_n_value(n)
    n
}

#error_if_n_is_greater_than_zero(5)

# Running the traceback() function immediately after getting this error would give us
traceback()
# 3: stop("n should be <= 0") at #2
# 2: check_n_value(n) at #2
# 1: error_if_n_is_greater_than_zero(5)


# From the traceback, we can see that the error occurred in the check_n_value() function. 
# Put another way, the stop() function was called from within the check_n_value() function.






#-------------------- browser() -----------------------------#
#From the traceback output, it is often possible to determine in which function and 
#on which line of code an error occurs. If you are the author of the code in question, 
#one easy thing to do is to insert a call to the browser() function in the vicinity of
#the error (ideally, before the error occurs). The browser()function takes now arguments 
#and is just placed wherever you want in the function. Once it is called, you will be in 
#the browser environment, which is much like the regular R workspace environment except 
#that you are inside a function.

check_n_value <- function(n) {
    if(n > 0) {
         browser()  ## Error occurs around here
         stop("n should be <= 0")
     }
}

error_if_n_is_greater_than_zero(5)
#Called from: check_n_value(n)
#Browse[1]> 



#Now, when we call error_if_n_is_greater_than_zero(5), we will see the following.


#-------------------- debug() -----------------------------#



#-------------------- trace() -----------------------------#
abc <- function(a,b,c)
{
   a + b * c 
}

sapply(1:10, function(e) { e * abc(1,2,3)})
#[1]  7 14 21 28 35 42 49 56 63 70

trace("abc")

#abc function will be called 10 times
sapply(1:10, function(e) { e * abc(1,2,3)})
#trace: abc(1, 2, 3)
#trace: abc
#trace: abc
#trace: abc
#trace: abc
#trace: abc
#trace: abc
#trace: abc
#trace: abc
#trace: abc
# [1]  7 14 21 28 35 42 49 56 63 70

# But we can do more with trace(), such as inserting a call to browser() in a specific place, 
# such as right before the call tostop().

# We can obtain the expression numbers of each part of a function by calling as.list() on the 
# body()of a function.

as.list(body(check_n_value))
#[[1]]
#`{`
#
#[[2]]
#if (n > 0) {
#    stop("n should be <= 0")
#}

# Here, the if statement is the second expression in the function (the first “expression” being the very beginning of the function). We can further break down the second expression as follows.

as.list(body(check_n_value)[[2]])
#[[1]]
#`if`
#
#[[2]]
#n > 0
#
#[[3]]
#{
#   stop("n should be <= 0")
#}



#Now we can see the call to stop() is the third sub-expression within the second expression of the overall function. We can specify this to trace() by passing an integer vector wrapped in a list to the at argument.

#trace("check_n_value", browser, at = list(c(2, 3)))
#[1] "check_n_value"


#The trace() function has a side effect of modifying the function and converting into a new object of class “functionWithTrace”.

check_n_value
#Object with tracing code, class "functionWithTrace"
#Original definition: 
#function(n) {
#	        if(n > 0) {
#			                stop("n should be <= 0")
#        }
#}


body(check_n_value)
#{
#    if (n > 0) {
#        .doTrace(browser(), "step 2,3")
#        {
#         stop("n should be <= 0")
#        }
#    }
#}
#Here we can see that the code has been altered to add a call to browser() just before the call tostop().


#We can add more complex expressions to a function by wrapping them in a call to quote() within the 
#the trace() function. For example, we may only want to invoke certain behaviors depending on the i
#local conditions of the function.

trace("check_n_value", 
       quote({
	       if(n == 5) {
	             message("invoking the browser")
	             browser()
	        }}), 
      at = 2
      )
# [1] "check_n_value"
#


body(check_n_value)
{
    {
        .doTrace({
            if (n == 5) {
	        message("invoking the browser")
	        browser()
	    }
	}, "step 2")
        if (n > 0) {
	        stop("n should be <= 0")
	}
    }
}



#Debugging functions within a package is another key use case for trace(). For example, if we wanted 
#to insert tracing code into the glm() function within the stats package, the only addition to the 
#trace() call we would need is to provide the namespace information via the where argument.

trace("glm", browser, at = 4, where = asNamespace("stats"))
#Tracing function "glm" in package "namespace:stats"
.[1] "glm"

# Here we show the first few expressions of the modified glm() function.

body(stats::glm)[1:5]
#{
#    call <- match.call()
#    if (is.character(family)) 
#            family <- get(family, mode = "function", envir = parent.frame())
#    {
#        .doTrace(browser(), "step 4")
#        if (is.function(family)) 
#	            family <- family()
#    }
#    if (is.null(family$family)) {
#        print(family)
#        stop("'family' not recognized")
#    }
#}


#----------------------- debug()/debugonce() ---------------------------#

# The debug() and debugonce() functions can be called on other functions to turn on the “debugging state” 
#of a function. Calling debug() on a function makes it such that when that function is called, you 
# immediately enter a browser and can step through the code one expression at a time.

## Turn on debugging state for 'lm' function
debug(lm)


#A call to debug(f) where f is a function is basically equivalent totrace(f, browser) which will call 
#the browser() function upon entering the function.

#The debugging state is persistent, so once a function is flagged for debugging, it will remain flagged.
#Because it is easy to forget about the debugging state of a function, the debugonce() function turns on
#the debugging state the next time the function is called, but then turns it off after the browser is exited.




#---------------------- recover ------------------------------------#
#The recover() function is not often used but can be an essential tool when debugging complex code. 
#Typically, you do not call recover() directly, but rather set it as the function to invoke anytime
#an error occurs in code. This can be done via the options() function.

options(error = recover)


error_if_n_is_greater_than_zero(5)
#Error in check_n_value(n) : n should be <= 0
#
#Enter a frame number, or 0 to exit   
#
#1: error_if_n_is_greater_than_zero(5)
#2: #2: check_n_value(n)
#
#Selection:


#Selecting a number from this menu will bring you into that function on the call stack and you will be
#placed in a browser environment. You can exit the browser and then return to this menu to jump to 
#another function in the call stack.

#The recover() function is very useful if an error is deep inside a nested series of function calls 
#and it is difficult to pinpoint exactly where an error is occurring (so that you might use browser() 
#ortrace()). In such cases, the debug() function is often of little practical use because you may need 
#to step through many many expressions before the error actually occurs. Another scenario is when there 
#is a stochastic element to your code so that errors occur in an unpredictable way. Using recover() will 
#allow you to browse the function environment only when the error eventually does occur.























