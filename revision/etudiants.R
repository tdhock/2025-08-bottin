library(data.table)
parents_in <- fread("Correction.csv")
etudiants_pages <- fread("etudiants_pages.csv")
etudiants_long <- melt(
  parents_in[, ligne := 1:.N],
  measure.vars=measure(value.name, nombre, pattern="(.*) de l'enfant ([0-9])"),
  id.vars="ligne"
)[!is.na(`Prénom et nom`) & `Prénom et nom`!=""]
grep(",", etudiants_long$Pr, value=TRUE)

etudiants_pages[, `Prénom et nom` := paste(prénom, nom)]
etudiants_long[!etudiants_pages, on="Prénom et nom"]#étudiant dans la correction, mais pas dans une classe

etudiants_info <- etudiants_long[etudiants_pages, on="Prénom et nom", nomatch=0L]
etudiants_out <- etudiants_info[, .(page, ligne, étudiant=`Prénom et nom`)]
fwrite(etudiants_out, "etudiants.csv")
