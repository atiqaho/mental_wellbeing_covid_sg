library(fpp3)
library(tidyverse)
library(readxl)

mw_data <- read_excel("mw data - for brandon - non normalized.xlsx", 
                      col_types = c("date", "numeric", "numeric", 
                                    "numeric", "numeric", "numeric", 
                                    "numeric", "numeric", "numeric", 
                                    "numeric", "numeric", "numeric", 
                                    "numeric", "numeric", "numeric", 
                                    "numeric", "numeric", "numeric", 
                                    "numeric", "numeric", "numeric", 
                                    "numeric", "numeric", "numeric", 
                                    "numeric", "numeric", "numeric", 
                                    "numeric", "numeric", "numeric", 
                                    "numeric", "numeric", "numeric", 
                                    "numeric"))

mw_data<-mw_data |>
  mutate(date = as.Date(date))|>
  as_tsibble()



period<-.99
train_n <- round(period*nrow(mw_data))

train <- mw_data |>
  slice(1:train_n)

val <- mw_data |>
  slice(train_n+1:nrow(mw_data))

fit_imh <- train |> 
  model(
    ar1 = ARIMA(imh_visits~1+lag(imh_visits,1)),
    ar1_tweetjoyintensity = ARIMA(
      imh_visits~1+lag(imh_visits,1)+lag(tweet_joy_intensity,1)
    ),
    ar2 = ARIMA(
      imh_visits~1+lag(imh_visits,1)+lag(imh_visits,2)
    ),
    ar2_announce = ARIMA(
      imh_visits~1+ lag(imh_visits,1)+lag(imh_visits,2) +
        lag(announcement_count,1)+lag(announcement_count,2)
    ),
    ar2_tweetcount = ARIMA(
      imh_visits~1+ lag(imh_visits,1)+lag(imh_visits,2) +
        lag(tweet_count,1)+lag(tweet_count,2)
    ),
    ar3 = ARIMA(
      imh_visits~1+lag(imh_visits,1)+lag(imh_visits,2)+lag(imh_visits,3)
    ),
    ar3_newcase = ARIMA(
      imh_visits~1+lag(imh_visits,1)+lag(imh_visits,2)+lag(imh_visits,3)+
        lag(new_cases,1)+lag(new_cases)+lag(new_cases,3)
    ),
    ar4 = ARIMA(
      imh_visits~1+lag(imh_visits,1)+lag(imh_visits,2)+lag(imh_visits,3)+lag(imh_visits,4)
    ),
    ar4_fbsadcount = ARIMA(
      imh_visits~1+lag(imh_visits,1)+lag(imh_visits,2)+lag(imh_visits,3)+lag(imh_visits,4)+
        lag(fb_sadness_count,1)+lag(fb_sadness_count,2)+lag(fb_sadness_count,3)+lag(fb_sadness_count,4)
    ),
    ar4_fbangercount = ARIMA(
      imh_visits~1+lag(imh_visits,1)+lag(imh_visits,2)+lag(imh_visits,3)+lag(imh_visits,4)+
        lag(fb_anger_count,1)+lag(fb_anger_count,2)+lag(fb_anger_count,3)+lag(fb_anger_count,4)
    ),
    ar4_fbjoycount = ARIMA(
      imh_visits~1+lag(imh_visits,1)+lag(imh_visits,2)+lag(imh_visits,3)+lag(imh_visits,4)+
        lag(fb_joy_count,1)+lag(fb_joy_count,2)+lag(fb_joy_count,3)+lag(fb_joy_count,4)
    ),
    ar4_fbcount = ARIMA(
      imh_visits~1+lag(imh_visits,1)+lag(imh_visits,2)+lag(imh_visits,3)+lag(imh_visits,4)+
        lag(fb_count,1)+lag(fb_count,2)+lag(fb_count,3)+lag(fb_count,4)
    ),
    ar4_tweetangercount = ARIMA(
      imh_visits~1+lag(imh_visits,1)+lag(imh_visits,2)+lag(imh_visits,3)+lag(imh_visits,4)+
        lag(tweet_anger_count,1)+lag(tweet_anger_count,2)+lag(tweet_anger_count,3)+lag(tweet_anger_count,4)
    )
  )

fc_imh <- fit_imh |> forecast(val)

# Extract unique model names from the fc_imh object
unique_models <- unique(fc_imh$.model)

# Loop over each unique model
for (model_name in unique_models) {
  # Filter fc_imh for the current model
  model_data <- filter(fc_imh, .model == model_name)
  
  # Create the plot for the current model
  model_plot <- autoplot(model_data, level = NULL, color = 'blue') +
    autolayer(train %>% select(imh_visits), linetype = 'dashed', alpha = .4) +
    autolayer(val %>% select(imh_visits), linetype = 'dashed', alpha = .4) 
  
  # Define the file name for the plot
  file_name <- paste0("figures/period_",period,"_model_", model_name, ".png")
  
  # Save the plot to the current working directory
  ggsave(file_name, plot = model_plot, width = 10, height = 6, dpi = 300)
}

fc_imh |>filter(.model=='ar4_tweetangercount')|>autoplot(level = NULL,color='blue') + 
  autolayer(train |> select(imh_visits),linetype='dashed',alpha=.4) +
  autolayer(val |> select(imh_visits),linetype='dashed',alpha=.4)

res_imh<-fc_imh |> accuracy(val) |>select(.model,RMSE,MAE,MAPE) |> arrange(.model,MAE)
write.csv(res_imh,file = sprintf("results/results_imh_period_%s.csv",period))

fit_ml <- train |>
  model(
    ar1=ARIMA(mindline_crisis_new_users~1+lag(mindline_crisis_new_users)),
    ar1_sadcount=ARIMA(mindline_crisis_new_users~1+lag(mindline_crisis_new_users)+lag(tweet_sadness_count)),
    ar1_tweetangercount=ARIMA(mindline_crisis_new_users~1+lag(mindline_crisis_new_users)+lag(tweet_anger_count)),
    ar1_tweetjoyintens=ARIMA(mindline_crisis_new_users~1+lag(mindline_crisis_new_users)+lag(tweet_joy_intensity)),
    ar3 = ARIMA(
      mindline_crisis_new_users~1+lag(mindline_crisis_new_users,1)+lag(mindline_crisis_new_users,2)+
        lag(mindline_crisis_new_users,3)
    ),
    ar3_tweetcount = ARIMA(
      mindline_crisis_new_users~1+lag(mindline_crisis_new_users,1)+lag(mindline_crisis_new_users,2)+
        lag(mindline_crisis_new_users,3)+lag(tweet_count,1)+lag(tweet_count,2)+lag(tweet_count,3)
    ),
    ar5 = ARIMA(
      mindline_crisis_new_users~1+lag(mindline_crisis_new_users,1)+lag(mindline_crisis_new_users,2)+
        lag(mindline_crisis_new_users,3)+lag(mindline_crisis_new_users,4)+ lag(mindline_crisis_new_users,5)
    ),
    ar5_tweetjoycount5 = ARIMA(
      mindline_crisis_new_users~1+lag(mindline_crisis_new_users,1)+lag(mindline_crisis_new_users,2)+
        lag(mindline_crisis_new_users,3)+lag(mindline_crisis_new_users,4)+lag(mindline_crisis_new_users,5)+
        lag(tweet_joy_count,1)+lag(tweet_joy_count,2)+lag(tweet_joy_count,3)+lag(tweet_joy_count,4)+lag(tweet_joy_count,5)
    )
  )



fc_ml <- fit_ml |> forecast(val)
res_ml<-fc_ml |> accuracy(val) |>select(.model,RMSE,MAE,MAPE) |> arrange(.model,MAE)
write.csv(res_ml,file = sprintf("results/results_ml_period_%s.csv",period))

# Extract unique model names from the fc_imh object
unique_models <- unique(fc_ml$.model)

# Loop over each unique model
for (model_name in unique_models) {
  # Filter fc_ml for the current model
  model_data <- filter(fc_ml, .model == model_name)
  
  # Create the plot for the current model
  model_plot <- autoplot(model_data, level = NULL, color = 'blue') +
    autolayer(train %>% select(mindline_crisis_new_users), linetype = 'dashed', alpha = .4) +
    autolayer(val %>% select(mindline_crisis_new_users), linetype = 'dashed', alpha = .4) 
  
  # Define the file name for the plot
  file_name <- paste0("figures_ml/period_",period,"_model_", model_name, ".png")
  
  # Save the plot to the current working directory
  ggsave(file_name, plot = model_plot, width = 10, height = 6, dpi = 300)
}
