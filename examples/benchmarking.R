library(microbenchmark)

df <- data.frame(a = runif(1), b = runif(1))
sl <- function(t)
{
  Sys.sleep(t)
  0
}

sl(3)

t <- system.time(x <- sl(3));

x <- runif(1000); y <- runif(1000)
library(microbenchmark)

N = 500
df <- data.frame(teams = sample(LETTERS[1:3],size = N,replace = TRUE), score = runif(N))

finalResult = c()
for(team in unique(df$teams))
{
  scoreset <- df[df$teams == team, "score"]
  res = 0
  for(s in scoreset)
  {
    res = res + s
  }
  finalResult <- c(finalResult, res)
}
setNames(finalResult, unique(df$teams))


tapply(df$score, df$teams,sum)


test2 <- function()
{
  finalResult = c()
  for(team in unique(df$teams))
  {
    scoreset <- df[df$teams == team, "score"]
    res = 0
    for(s in scoreset)
    {
      res = res + s
    }
    finalResult <- c(finalResult, res)
  }
  finalResult <- setNames(finalResult, unique(df$teams))
  finalResult
}

compare <- microbenchmark(z <- tapply(df$score, df$teams,sum), z <- test2(), times = 1000)


#=================================================================================================
library(foreach)

#=================================================================================================

METHOD1 <- function(N=1000)
{
  experiment <- function()
  {
    #generate three distinct numbers between 1 and 20
    generated = FALSE
    x <- NULL
    while(!generated)
    {
      x <- ceiling(runif(3, min = 0, max = 20))
      if(any(x==0) || (x[1] == x[2] || x[2] == x[3] || x[3] == x[1]))
      {
        next
      } else {
        generated = TRUE
      }
    }
    minx <- min(x)
    maxx <- max(x)
    midx <- x[x != minx & x!= maxx]
    
    return(maxx - midx == midx - minx)
  }
  

  trials = NULL
  #initialize
  i = 1
  while(i <= N)
  {
	trials <- c(trials, TRUE)
	i = i + 1
  }
  
  i=1
  while(i <= N)
  {
    isAP <- experiment()
	if(!isAP)
    {
      trials[i] = FALSE
    }
    i = i + 1
  }
  
  count = 0
  for( i in 1:N)
  {
    if(trials[i] == TRUE){
		count = count + 1
	}
  }
  
  return(count/N)
}




#-----------------------------------METHOD 2 ------------------------------------------------------#
METHOD2 <- function(N=1000)
{
  experiment <- function()
  {
    #generate three distinct numbers between 1 and 20
    generated = FALSE
    x <- NULL
    while(!generated)
    {
      x <- ceiling(runif(3, min = 0, max = 20))
      if(any(x==0) || (x[1] == x[2] || x[2] == x[3] || x[3] == x[1]))
      {
        next
      } else {
        generated = TRUE
      }
    }
    minx <- min(x)
    maxx <- max(x)
    midx <- x[x != minx & x!= maxx]
    
    return(maxx - midx == midx - minx)
  }
  

  trials = rep( TRUE, N)
  
  i=1
  while(i <= N)
  {
    isAP <- experiment()
	if(!isAP)
    {
      trials[i] = FALSE
    }
    i = i + 1
  }
  
  count = 0
  for( i in 1:N)
  {
    if(trials[i] == TRUE){
		count = count + 1
	}
  }
  
  return(count/N)
}



#-----------------------------------METHOD 3 ------------------------------------------------------#
METHOD3 <- function(N=1000)
{
  experiment <- function()
  {
    #generate three distinct numbers between 1 and 20
    generated = FALSE
    x <- NULL
    while(!generated)
    {
      x <- ceiling(runif(3, min = 0, max = 20))
      if(any(x==0) || (x[1] == x[2] || x[2] == x[3] || x[3] == x[1]))
      {
        next
      } else {
        generated = TRUE
      }
    }
    minx <- min(x)
    maxx <- max(x)
    midx <- x[x != minx & x!= maxx]
    
    return(maxx - midx == midx - minx)
  }
  
  count = 0
  for( i in 1:N)
  {
    isAP <- experiment()
	if(isAP)
	{
		count  = count + 1
	}
  }
  
  return(count/N)
}



#-----------------------------------METHOD 4 ------------------------------------------------------#
METHOD4 <- function(N=1000)
{
  experiment <- function()
  {
    #generate three distinct numbers between 1 and 20
    generated = FALSE
    x <- NULL
    while(!generated)
    {
      x <- ceiling(runif(3, min = 0, max = 20))
      if(any(x==0) || (x[1] == x[2] || x[2] == x[3] || x[3] == x[1]))
      {
        next
      } else {
        generated = TRUE
      }
    }
    minx <- min(x)
    maxx <- max(x)
    midx <- x[x != minx & x!= maxx]
    
    return(maxx - midx == midx - minx)
  }
  
  res <- replicate(N, experiment())
  
  return(sum(res)/N)
}




#-------------------------------- METHOD5 ---------------------------------------------------------------------#
METHOD5 <- function(N=1000)
{
  experiment <- function()
  {
    #generate three distinct numbers between 1 and 20
    generated = FALSE
    x <- sample(x = 1:20,size = 3,replace = FALSE)[1:3]
    minx <- min(x)
    maxx <- max(x)
    midx <- x[x != minx & x!= maxx]
    
    return(maxx - midx == midx - minx)
  }
  
  res <- replicate(N, experiment())
  
  return(sum(res)/N)
}




#-------------------------------- METHOD6 ---------------------------------------------------------------------#
METHOD6 <- function(N=1000)
{
  experiment <- function()
  {
    #generate three distinct numbers between 1 and 20
    generated = FALSE
    x <- sample.int(20, 3, replace= FALSE)
    minx <- min(x)
    maxx <- max(x)
    midx <- x[x != minx & x!= maxx]
    
    return(maxx - midx == midx - minx)
  }
  
  res <- replicate(N, experiment())
  
  return(sum(res)/N)
}


#-------------------------------- METHOD7 ---------------------------------------------------------------------#
METHOD7 <- function(N=1000)
{
  experiment <- function()
  {
    #generate three distinct numbers between 1 and 20
    x <- sort(sample.int(20, 3, replace= FALSE))
    minx <- x[1]
    maxx <- x[3]
    midx <- x[2]
    
    return(maxx - midx == midx - minx)
  }
  
  res <- replicate(N, experiment())
  
  return(sum(res)/N)
}




#-------------------------------- METHOD8 ---------------------------------------------------------------------#
METHOD8 <- function(N=1000)
{
  experiment <- function()
  {
    #generate three distinct numbers between 1 and 20
    x <- sample.int(20, 3, replace= FALSE)
	minx <- min(x)
	maxx <- max(x)
	midx <- x[x != minx & x!= maxx]
    return(maxx - midx == midx - minx)
  }
  
  mean(replicate(N, experiment()))
}

microbenchmark(METHOD1(), METHOD2(), METHOD3(), METHOD4(), METHOD5(), METHOD6(), METHOD7(), METHOD8(), times=100)



library(foreach)


#-------------------------------- METHOD9 ---------------------------------------------------------------------#
METHOD9 <- function(N=1000)
{
  experiment <- function()
  {
    #generate three distinct numbers between 1 and 20
    x <- sample.int(20, 3, replace= FALSE)
	minx <- min(x)
	maxx <- max(x)
	midx <- x[x != minx & x!= maxx]
    return(maxx - midx == midx - minx)
  }
  
  res <- foreach(i=1:N, .combine='c') %do% experiment()
  mean(res)
}


#-------------------------------- METHOD10 ---------------------------------------------------------------------#
METHOD10 <- function(N=1000)
{
  experiment <- function()
  {
    #generate three distinct numbers between 1 and 20
    x <- sample.int(20, 3, replace= FALSE)
	minx <- min(x)
	maxx <- max(x)
	midx <- x[x != minx & x!= maxx]
    return(maxx - midx == midx - minx)
  }
  
  res <- foreach(i=1:N, .combine='c') %dopar% experiment()
  mean(res)
}

microbenchmark(METHOD1(), METHOD2(), METHOD3(), METHOD4(), METHOD5(), METHOD6(), METHOD7(), METHOD8(), METHOD9(), METHOD10(), times=100)


microbenchmark(METHOD1(10000), METHOD8(10000), times=100)


The warning gives us pause for thought: maybe it was not quite that simple? Yes, indeed, there are additional requirements. You need first to choose a parallel backend. And here, again, there are a few options. We will start with the most accessible, which is the multicore backend.



#--------------------------- One Liner ------------------------------------#
METHOD11 <- function(N=1000)
{
  mean(sapply(1:N, function(i) {
							x <- sample.int(20, 3, replace= FALSE)
							minx <- min(x)
							maxx <- max(x)
							midx <- x[x != minx & x!= maxx]				
							maxx - midx == midx - minx}))
}

microbenchmark(METHOD1(), METHOD2(), METHOD3(), METHOD4(), METHOD5(), METHOD6(), METHOD7(), METHOD8(), METHOD9(), METHOD10(), METHOD11(), times=100)


#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

