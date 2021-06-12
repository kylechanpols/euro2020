# A simple Bayesian Model to predict EURO 2020 Results

This is a very simple Bayesian Model that predicts Results of EURO 2020 games that I wrote as a fun project in a day. You can find the technical writeup about this project on [my website](https://kylechanhy.netlify.app/post/euro2021)

## Description of files

## Datasets

`base_data.xlsx` - Basic tally and outcome matrices for the EURO 2020 Qualifiers. Data acquired from [this Wikipedia page](https://en.wikipedia.org/wiki/UEFA_Euro_2020_qualifying)

`qualifiers.csv` - Dyadic data of different teams during the qualifiers. Constructed by flattening the outcome matrices in `base_data.xlsx`.

`week1_games.xlsx` - Example of new data to be fed to the Bayesian model for predictions.

## Code

`flattenmatrix.R` - A simple R program to flatten a matrix.

`data_wrangling.R` - A sample R script to clean the data and construct `qualifiers.csv`.

`utils.R` - A script containing helper functions for the Bayesian Model

`euro2020_v2_predictive.stan` - Stan program for the prediction.
