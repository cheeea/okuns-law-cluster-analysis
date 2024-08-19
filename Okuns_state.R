rm(list = ls())
gc()

setwd("your path")
library(dplyr)
library(fredr)
library(purrr)
fredr_set_key("get API key from https://fred.stlouisfed.org/docs/api/api_key.html")

# create inputs
identifiers <- list("RGSP","UR")

make_vec_prefix <- function(id){
  output <- c(rep(0, length(state.abb)))
  
  for(i in 1:length(state.abb)){
    output[i] <- paste(state.abb[i], id, sep = "")
  }
  return(output)
}

all_ids <- map(identifiers, make_vec_prefix)
names(all_ids) <- c("rgdp", "unrate")
listbound <- do.call(c, all_ids)

# extract data 
extract <- function(ids){
  dfs <- list()
  for(i in 1:length(ids)){
    try(
      dfs[[i]] <- fredr(series_id = ids[i], frequency = "a", aggregation_method = "avg"), silent = T)
  }
  return(dfs)
}

all_dfs <- map(all_ids, extract)

# join each 2 data frames 
rgdp <- all_dfs[[1]]
unrate <- all_dfs[[2]]

joined <- map2(unrate, rgdp, ~ inner_join(.x, .y, join_by(date)))

# clean each data frame 
clean <- function(df){
  df <- df %>%
    mutate(urate_change = value.x - lag(value.x), 
           rgdp_perchange = 100*(log(value.y) - log(lag(value.y)))) %>%
    select(date, urate_change, rgdp_perchange, series_id.x)
}

cleaned <- map(joined, clean)
names(cleaned) <- state.abb

# fit okuns law regression for each data frame (each state)
fit <- function(df){
  lm <- lm(df$rgdp_perchange ~ df$urate_change, data = df)
  fitted <- lm[["fitted.values"]]
  coeffs <- lm[["coefficients"]]
  return(list(fitted, coeffs))
}

outputs <- map(cleaned, fit)

# fit rmse for each regression model 
rmse <- list()
for(i in 1:length(state.abb)){
  rmse[i] <- map((outputs[[i]][[1]] - cleaned[[i]]["rgdp_perchange"])^2, ~ mean(.x, na.rm = T))

}
rmse <- do.call(c, rmse)
rmse_df <- data.frame(state.name, rmse)

# extract covariate data for each state 

# create input vectors for rest of covariates 
# (need to make more helper functions to accomodate different string structures)
make_vec_suffix <- function(id){
  output <- c(rep(0, length(state.abb)))
  
  for(i in 1:length(state.abb)){
    output[i] <- paste(id, state.abb[i], sep = "")
  }
  return(output)
}

make_vec_mid <- function(id1, id2){
  output <- c(rep(0, length(state.abb)))
  
  for(i in 1:length(state.abb)){
    output[i] <- paste(id1, state.abb[i], id2, sep = "")
  }
  return(output)
}

covar_prefix_ids <- list("POP", "PCELRPTSLSGSNPIS")
covar_ids <- c(map(covar_prefix_ids, make_vec_prefix), 
               map("GCT1502", make_vec_suffix), 
               pmap(list("MEHOINUS", "A672N"), make_vec_mid))

covar_names <- c("pop", "pce", "bach", "inc")
names(covar_ids) <- covar_names

all_covars <- map(covar_ids, extract)

clean_covars <- function(dfs, names) {
  if(names != "bach"){
    map(dfs, function(df) {
      df %>%
        mutate(perchange = 100 * (log(value) - log(lag(value)))) %>%
        summarize(mean_gr = mean(perchange, na.rm = TRUE))
    })
  } else {
    map(dfs, function(df) {
      df %>%
        summarize(med = median(value, na.rm = TRUE))
    })
  }
}

cleaned_covars <- pmap(list(all_covars, covar_names), clean_covars)

bound_covars <- map(cleaned_covars, bind_rows)
df_bound_covars <- do.call(cbind, bound_covars)

# create final dataframe 
final <- rmse_df %>% 
  cbind(df_bound_covars)
colnames(final) <- c("states", "rmse", "avg_pop_gr", "avg_pce_gr", "med_bach%", "avg_rmedinc_gr")
final <- mutate(final, state.abb = state.abb)

write.csv(final, "state_okuns_rates.csv")
final




