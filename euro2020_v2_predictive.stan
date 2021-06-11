
data {
  int<lower=1> Nteams;
  int<lower=1> Ngames;
  vector[Ngames] y_i; // Home Score
  vector[Ngames] y_j; // Away Score
  vector[Nteams] pie; // Prior (UEFA National Team Coefficient)
  int I[Ngames]; // home team ID
  int J[Ngames]; // away team ID
  real df; // Degrees of Freedom for the student T
  real df2;
  int<lower=1> Nnewgames;
  int<lower=1> I_new[Nnewgames];
  int<lower=1> J_new[Nnewgames];
}

transformed data{
  vector[Ngames] y_ij = y_i - y_j; // Goal Difference
}

parameters {
  vector[Nteams] theta; // latent quality.
  real beta; // latent coefficient controlling quality.
  //real theta_j; // latent quality for team j.
  real<lower=0> sigma_ij;
  real<lower=0> sigma_theta;
}

model {
  theta ~ normal(beta*pie, sigma_theta);
  y_ij ~ student_t(df, theta[I] - theta[J], sigma_ij); // element-wise multiplication. Does that work?
}

generated quantities {
  vector[Nnewgames] y_ij_hat;
  
  for (n in 1:Nnewgames)
    y_ij_hat[n] = student_t_rng(df2, theta[I_new[n]] - theta[J_new[n]], sigma_ij);
}
