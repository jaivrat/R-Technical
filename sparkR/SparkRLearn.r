# Databricks notebook source
# MAGIC %r
# MAGIC library(SparkR)

# COMMAND ----------

print(sparkR.session())
sparkR.conf()

# COMMAND ----------

data(faithful)

# COMMAND ----------

# MAGIC %md
# MAGIC 
# MAGIC ### Creating SparkDataFrames
# MAGIC 
# MAGIC #### From local data frames

# COMMAND ----------

# Create the SparkDataFrame
df <- as.DataFrame(faithful)
# Get basic information about the SparkDataFrame
df
## SparkDataFrame[eruptions:double, waiting:double]

# Select only the "eruptions" column
head(select(df, df$eruptions))
##  eruptions
##1     3.600
##2     1.800
##3     3.333

# You can also pass in column name as strings
head(select(df, "eruptions"))

# Filter the SparkDataFrame to only retain rows with wait times shorter than 50 mins
head(filter(df, df$waiting < 50))
##  eruptions waiting
##1     1.750      47
##2     1.750      47
##3     1.867      48

# COMMAND ----------

# MAGIC %md
# MAGIC 
# MAGIC #### Grouping, Aggregation

# COMMAND ----------

# We use the `n` operator to count the number of times each waiting time appears
head(summarize(groupBy(df, df$waiting), count = n(df$waiting)))
##  waiting count
##1      70     4
##2      67     1
##3      69     2

# We can also sort the output from the aggregation to get the most common waiting times
waiting_counts <- summarize(groupBy(df, df$waiting), count = n(df$waiting))
head(arrange(waiting_counts, desc(waiting_counts$count)))
##   waiting count
##1      78    15
##2      83    14
##3      81    13

# COMMAND ----------

head(df)

# COMMAND ----------

# Convert waiting time from hours to seconds.
# Note that we can assign this to a new column in the same SparkDataFrame
df$waiting_secs <- df$waiting * 60
head(df)
##  eruptions waiting waiting_secs
##1     3.600      79         4740
##2     1.800      54         3240
##3     3.333      74         4440

# COMMAND ----------

# Convert waiting time from hours to seconds.
# Note that we can apply UDF to DataFrame.
schema <- structType(structField("eruptions", "double"), structField("waiting", "double"),
                     structField("waiting_secs2", "double"))
df1 <- dapply(df, function(x) 
                  { 
                      x <- cbind(x, x$waiting * 60) 
                  }, schema)

##  eruptions waiting waiting_secs
##1     3.600      79         4740
##2     1.800      54         3240
##3     3.333      74         4440
##4     2.283      62         3720
##5     4.533      85         5100
##6     2.883      55         3300

# COMMAND ----------

?dapply

# COMMAND ----------

library(SparkR)
df1 <- dapply(df, function(x) { x }, schema(df))
collect(df1)



# COMMAND ----------


 # filter and add a column
df <- createDataFrame(
            list(list(1L, 1, "1"), list(2L, 2, "2"), list(3L, 3, "3")),
            c("a", "b", "c"))
schema <- structType(structField("a", "integer"), 
                     structField("b", "double"),
                     structField("c", "string"), 
                     structField("d", "integer"))

df1 <- dapply(df,
              function(x) {
                y <- x[x[1] > 1, ]
                y <- cbind(y, y[1] + 1L)
              },
              schema)

# COMMAND ----------

print(df1)
collect(df1)

# COMMAND ----------

ss <- collect(df1)
ss[1]

# COMMAND ----------

collected_df <- dapplyCollect(df,
              function(x) {
                y <- x[x[1] > 1, ]
                y <- cbind(y, y[1] + 1L)
              })
collected_df

# COMMAND ----------

# Convert waiting time from hours to seconds.
# Note that we can apply UDF to DataFrame and return a R's data.frame
ldf <- dapplyCollect(
         df,
         function(x) {
           x <- cbind(x, "waiting_secs" = x$waiting * 60)
         })
head(ldf, 3)
##  eruptions waiting waiting_secs
##1     3.600      79         4740
##2     1.800      54         3240
##3     3.333      74         4440

# COMMAND ----------

# MAGIC %md
# MAGIC 
# MAGIC ##### Run a given function on a large dataset grouping by input column(s) and using gapply or gapplyCollect
# MAGIC 
# MAGIC ###### gapply
# MAGIC Apply a function to each group of a SparkDataFrame. The function is to be applied to each group of the SparkDataFrame and should have only two parameters: grouping key and R data.frame corresponding to that key. The groups are chosen from SparkDataFrames column(s). The output of function should be a data.frame. Schema specifies the row format of the resulting SparkDataFrame. It must represent R function’s output schema on the basis of Spark data types. The column names of the returned data.frame are set by user.

# COMMAND ----------

df <- as.DataFrame(faithful)

# Determine six waiting times with the largest eruption time in minutes.
schema <- structType(structField("waiting", "double"), structField("max_eruption", "double"))
result <- gapply(
    df,
    "waiting",
    function(key, x) {
        y <- data.frame(key, max(x$eruptions))
    },
    schema)
head(collect(arrange(result, "max_eruption", decreasing = TRUE)))

##    waiting   max_eruption
##1      64       5.100
##2      69       5.067
##3      71       5.033
##4      87       5.000
##5      63       4.933
##6      89       4.900

# COMMAND ----------

print(dim(df))
head(collect(df))

# COMMAND ----------

# MAGIC %md
# MAGIC 
# MAGIC Let us try user defined function

# COMMAND ----------

mymean <- function(x)
{
  mean(x)
}


# Determine six waiting times with the largest eruption time in minutes.
schema <- structType(structField("waiting", "double"), structField("mean_eruption", "double"))
result <- gapply(
    df,
    "waiting",
    function(key, x) {
        y <- data.frame(key, mymean(x$eruptions))
    },
    schema)
head(collect(arrange(result, "mean_eruption", decreasing = TRUE)))