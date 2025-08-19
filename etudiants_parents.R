library(data.table)
parents_in <- fread("Consentement à partager les coordonnées 25-26 - étudiants standardisés.csv")
etudiants_pages <- fread("etudiants_pages.csv")
measure.vars <- which(names(parents_in)=="Prénom, Nom")
etudiants_sondage <- melt(
  parents_in,
  value.name="etudiant",
  measure.vars=measure.vars,
  id.vars=c("Prénom", "Nom")
)[etudiant != ""]
grep(" ", etudiants_sondage$etudiant, invert=TRUE, value=TRUE)
grep(",", etudiants_sondage$etudiant, invert=TRUE, value=TRUE)
grep(",[^ ]", etudiants_sondage$etudiant, value=TRUE)
nc::capture_first_df(etudiants_sondage[, let(
  pre_virgule_nom=ifelse(
    grepl(",", etudiant),
    etudiant,
    sub(" ", ", ", etudiant)
  )
)], pre_virgule_nom=list(
  prénom=".*?",
  ", ",
  nom=".*"
))
etudiants_sondage[!etudiants_pages, on=.(prénom,nom)][, .(
  etudiant=pre_virgule_nom,
  parent=sprintf("%s, %s", Prénom, Nom)
)] ## étudiant dans un sondage, mais pas dans une classe

etudiants_parents <- etudiants_sondage[, .(prénom,nom,Prénom,Nom)]
fwrite(etudiants_parents, "etudiants_parents.csv")
