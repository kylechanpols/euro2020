
latent_quality <- function(mod,iter,data, para="theta",dict){
  # take data and generate a latent quality plot.
  # mod - a fitted bayesian model by Stan
  # iter - number of iterations
  # data - dataset.
  # para - name of latent quality parameter.
  # dict - a vector of named integers representing the corresponding team names by ID.
  Z <- matrix(nrow=iter, ncol=length(unique(data$home)), byrow=TRUE)
  
  for(i in 1:length(unique(data$home))){
    target_str <- paste0(para,"[",i,"]")
    #future development: consider loosening this iter parameter up. However, when i don't hard code it
    #it can't extract the last iter/2 samples. Strange and probably something going on with the rstan package.
    est <-  extract(mod, pars=target_str)[[1]]
    Z[,i] <- est[(iter+1):(iter*2)] # do not include burn-in period!
  }
  colnames(Z) = names(dict)
  Z = as.data.frame(Z)
  #names = rownames(flobusiness)
  mcmc_areas(Z)
}

predict_match <- function(mod_path,data,newdata,iter){
  # vectorized implementation of the prediction
  #mod_path - path to the .stan model
  #data - original data used to fit the model
  # newdata - new data you wish to make predictions on
  # iter - number of iterations
  
  data <- list(Nteams = length(unique(data$home)),
                        Ngames = nrow(data),
                        y_i = data$homescore,
                        y_j = data$awayscore,
                        pie = as.numeric(scale(uefa_team_coef$avg)),
                        I = recode(data$home, !!!dict),
                        J = recode(data$away, !!!dict),
                        df = 7,
                        df2 = 7,
                        Nnewgames = nrow(newdata),
                        I_new = as.array(recode(newdata$home, !!!dict)),
                        J_new = as.array(recode(newdata$away, !!!dict)))
  
  temp_mod <- stan(mod_path,
                   data = data,
                   seed=4321,
                   chains=4,
                   iter=iter)
  
  return(temp_mod)
}

acquire_ecdf_tabs <- function(mod, para="y_ij_hat",i,gd=3,plot=TRUE,teamA="Away Team", teamB="Home Team"){
  #A cleaned up func to acquire the empirical CDF function, then use that to generate predicted probabilities.
  
  #mod - a predictive model fitted with predict_match()
  # para - name of the prediction parameter (default is y_ij_hat)
  # i - which match should the func calculate predicted probabilities for?
  # gd - The maximum goal difference you wish the program to calculate (be default 3).
  # plot - By Default TRUE. Should the funx plot the posterior distribution of the predicted goal difference?
  # teamA - Team A label. - Usually the Away Team
  # teamB - Team B label. - Usually the Home Team
  
  Z <- extract(mod, pars=paste0(para,"[",i,"]"))[[1]][(mod@sim$iter +1): (mod@sim$iter *2)] # do not include burn-in period!
  cdf = ecdf(Z)
  z = seq(-gd,gd,by=1)
  
  intervals = NULL
  for(j in length(cdf(z)):1)
  {
    if(j == length(cdf(z))){
      intervals[j] =  1- cdf(z)[j]
      next
    }
    intervals[j] = cdf(z)[j+1] - cdf(z)[j]
  }
  
  preds <- data.frame(labels= z,
                      probs = cdf(z),
                      intervals = intervals)
  
  colnames(preds) <- c("Scenario","Cumulative Probability","Probability") 
  
  if(plot==TRUE){
    Z = as.data.frame(Z)
  #names = rownames(flobusiness)
  
    plt <- mcmc_areas(Z)
  
    plt <- plt+xlab(paste0("<----",teamA," Wins More Likely |",teamB," Wins More Likely ---->"))+ylab("Density")
    print(plt)
  }
  
  return(preds)
}
