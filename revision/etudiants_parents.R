library(data.table)
parents <- fread("parents.csv")
etudiants <- fread("etudiants.csv")
join_dt <- parents[etudiants, on="ligne"][order(page, étudiant, parent)]
(etudiants_parents <- join_dt[, .(page, étudiant, parent, Tél, Courriel)])
fwrite(etudiants_parents, "etudiants_parents.csv")
