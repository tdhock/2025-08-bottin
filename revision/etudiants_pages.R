tab_list <- tabulapdf::extract_tables("Listes classes FINALES.pdf", guess=FALSE)
library(data.table)

etudiants_pages <- data.table(page=1:length(tab_list))[, {
  nc::capture_first_vec(
    tab_list[[page]][[1]],
    id_étudiant="[0-9]{7}", as.integer,
    " *",
    nom=".*?",
    ", ",
    prénom=".*",
    nomatch.error=FALSE)[!is.na(nom)]
}, by=page] # grand total 132 ok.

etudiants_pages[page==1]

fwrite(etudiants_pages, "etudiants_pages.csv")
