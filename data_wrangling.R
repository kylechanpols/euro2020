source("flattenmatrix.R")

group_A <- flatten(read_excel("base_data.xlsx",sheet = "Group A Matrix"))
group_B <- flatten(read_excel("base_data.xlsx",sheet = "Group B Matrix"))
group_C <- flatten(read_excel("base_data.xlsx",sheet = "Group C Matrix"))
group_D <- flatten(read_excel("base_data.xlsx",sheet = "Group D Matrix"))
group_E <- flatten(read_excel("base_data.xlsx",sheet = "Group E Matrix"))
group_F <- flatten(read_excel("base_data.xlsx",sheet = "Group F Matrix"))
group_G <- flatten(read_excel("base_data.xlsx",sheet = "Group G Matrix"))
group_H <- flatten(read_excel("base_data.xlsx",sheet = "Group H Matrix"))
group_I <- flatten(read_excel("base_data.xlsx",sheet = "Group I Matrix"))
group_J <- flatten(read_excel("base_data.xlsx",sheet = "Group J Matrix"))

qualifying <- rbind(group_A,group_B,group_C,group_D,group_E,group_F,group_G,group_H,group_I,group_J)
qualifying$mtype <- "Qualifying Group Stage"

##############################################################################
#add back playoffs:

playoffs <- read_excel("playoffs.xlsx")

qualifying <- rbind(qualifying, playoffs)

write.csv(qualifying, "qualifiers.csv")


