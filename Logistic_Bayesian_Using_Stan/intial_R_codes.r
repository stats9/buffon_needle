## for load rstan package
if (!require(rstan)) {
    install.packages("rstan", repos = c("https://mc-stan.org/r-packages/", getOption("repos")))
    library(rstan)
}

## for check package that good installed or not
# example(stan_model, package = "rstan", run.dontrun = TRUE)

## for parallel calculation 
options(mc.cores = parallel :: detectCores())

## for adjust run programming
rstan_options(auto_write = TRUE)


#################

## for load tidyverse packages, (manipulate data and use ggplot objects)
if (!require(tidyverse)) {
    chooseCRANmirror(graphics = FALSE, ind = 1)
    install.packages(tidyverse)
    library(tidyverse)
}


## for feature selection 

if(!require(mlbench)) {
    chooseCRANmirror(graphics = FALSE, ind = 1)
    install.packages("mlbench")
    library(mlbench)
}

if(!require(caret)) {
    chooseCRANmirror(graphics = FALSE, ind = 1)
    install.packages("caret")
    library(caret)
}


## load data
test_dat <- read.csv(file = "diabetes_binary_5050split_health_indicators_BRFSS2015.csv", header = TRUE)
train_dat <- read.csv("diabetes_binary_health_indicators_BRFSS2015.csv", header = TRUE)
dim(train_dat)
dim(test_dat)
names(train_dat)
set.seed(7) ## use seed for same result in sequance run 
## Feature Selection -------------

#### Method 1: Using Correlation Matrix--




## check data
glimpse(train_dat)

corr_mat <- cor(train_dat)
# library(httpgd); hgd(); hgd_browse()

## for make correlation plot

if (!require(corrplot)) {
    chooseCRANmirror(graphics = FALSE, ind = 1)
    install.packages("corrplot")
    library(corrplot)
}


corrplot(corr_mat, type = "full", hclust.method = "ward", method = "number", 
p.mat = corr_mat, insig = 'p-value', , sig.level = 1, col = c("blue", 
"red", "black"), cl.cex = 0.1, number.digits = 2, number.cex = 0.25)


high_correlated <- findCorrelation(corr_mat, cutoff = 0.5)
print(high_correlated)
temp1 <- corr_mat %>% .[-1, 1] 
(temp1 >= 0.5) %>% sum
(temp1 >= 0.25) %>% sum
varNames <- dimnames(corr_mat)[[1]][-1]
varNames[temp1 >= 0.25]
names(train_dat)
train_dat2 <- train_dat %>% 
mutate(Diabetes_binary = factor(Diabetes_binary))
init_model1 <- train(form = Diabetes_binary ~ ., 
data = train_dat2, trControl = trainControl(method = "cv", 
number = 5), method = "glm", family = "binomial")

importance <- varImp(init_model1, scale = FALSE)
print(importance)
plot(importance)

############# bayesian Model 1:
library(httpgd); hgd(); hgd_browse()
dat1 <- train_dat %>%
    dplyr :: select(c("HighBP", "BMI", "GenHlth"))


X_train <- model.matrix(~., data = dat1)[, -1] 


## test data

dat2 <- test_dat %>%
    dplyr :: select(c("HighBP", "BMI", "GenHlth"))

X_test <- model.matrix(~., data = dat2)[, -1] 

y <- train_dat$Diabetes_binary
stanFit1 <- stan(file = "model_1.stan", 
data = list(N = nrow(train_dat), L = nrow(dat2), X_test = X_test,
        k = ncol(dat1), y = y,  X_train = X), iter = 500, chains = 3)
plot(stanFit1)
# saveRDS(stanFit1, "mod2.RDS")

# mod1 <- readRDS("m1.rds")
mod1
stanFit1
plot(stanFit1)
plot(mod1, pars = c("alpha", "beta"))
traceplot(stanFit1, pars = c("alpha", "beta"))
ext_fit <- rstan :: extract(mod1)
ext_fit2 <- rstan :: extract(stanFit1)


# Accuracy
mean(apply(ext_fit2$y_test, 2, median) == test_dat$Diabetes_binary)


