tabulapdf::extract_tables("Listes classes 25-26.pdf", guess=TRUE)#nothing
if(FALSE){
  tabulapdf::locate_areas("Listes classes 25-26.pdf", pages = 1)
}
my.areas <- list(c(top = 141.97068771139, left = -8.2998872604283, bottom = 493.77226606539, right = 636.37204058625)) #not generic.

tab_list <- tabulapdf::extract_tables("Listes classes 25-26.pdf", guess=FALSE)
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
