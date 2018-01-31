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

ss <- collect(df1)
ss[1]

# COMMAND ----------

library(SparkR)
head(collect(df1))

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

