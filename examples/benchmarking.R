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
old.plus <- `+`
`+` <- function(a,b){sum(a,b)}
compare <- microbenchmark(z <- old.plus(x,y), z <- x+y, times = 1000)

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


table(ceiling(runif(n = 10, min = 0, max = 20)))





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
  
  cnt = 0
  for( i in 1:N)
  {
    isAP <- experiment()
    if(isAP)
    {
      cnt = cnt + 1
    } 
  }
  return(cnt/N)
}


METHOD1()

#METHOD2 ======================================================================================
METHOD2 <- function(N=1000)
{
  experiment <- function(dummy)
  {
    x <- sort(sample(x = 1:20,size = 3,replace = FALSE)[1:3])
    x[2]-x[1] == x[3]-x[2]
  }
  
  mean(vapply(1:N,FUN = experiment,FUN.VALUE = 0))
}

METHOD3 <- function(N=1000)
{
  
  
  mean(vapply(1:N,FUN = function(dummy){
                          x <- sort(sample(x = 1:20,size = 3,replace = FALSE)[1:3])
                          x[2]-x[1] == x[3]-x[2]
                        },
              FUN.VALUE = 0))
}


compare <- microbenchmark(METHOD1(), METHOD2(), METHOD3(), times = 1000)







