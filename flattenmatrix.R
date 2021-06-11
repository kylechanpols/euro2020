library(readxl)
library(stringr)

#read matrix
#qual_A <- read_excel("C:/Users/Kyle/Google Drive/DS projects/euro2020/base_data.xlsx",sheet = "Group A Matrix")

#focus only on the matrix:
#qual_A <- as.matrix(qual_A[,2:ncol(qual_A)])

#clean up the matrix:
#rownames(qual_A) = colnames(qual_A)

#flatten matrix. Go through each row. Rows represent results from a home team i against away team j in the columns

flatten <- function(m,cleanup=TRUE){
  
if(cleanup == TRUE){
  m<- as.matrix(m[,2:ncol(m)])
  #clean up the matrix:
  rownames(m) = colnames(m)
}
  
home = list()
away = list()
home_score = list()
away_score =list()

for(i in 1:nrow(m)){
  for(j in 1:ncol(m)){
  if (m[i,j] == "NA" || is.na(m[i,j]))
    next #do not record "matches against self"


    home = append(home,rownames(m)[i]) #record host team
    away = append(away,colnames(m)[j]) #record away team
    #string split the scores:
    home_score = append(home_score , str_split(m[i,j], ",")[[1]][1])
    away_score = append(away_score,str_split(m[i,j], ",")[[1]][2])
  }
}

out = data.frame(home=as.character(home),
                 away=as.character(away),
                 homescore = as.numeric(home_score),
                 awayscore = as.numeric(away_score))

return(out)
}  

