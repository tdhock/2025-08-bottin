library(data.table)
parents_in <- fread("Consentement à partager les coordonnées 25-26 - étudiants standardisés.csv")
##timestamp = horodotage
parents_in[, .(count=.N), by=.(Nom,Prénom)][count>1] #Nom,Prénom ok pour ID de parent.
grep("[^0-9]", parents_in$Téléphone, value=TRUE)
parents_in[, let(
  tel_numbers=gsub("[- ()]", "", parents_in$Téléphone),
  consentement=`Quelles informations consentez-vous à partager au bottin de la communauté?`
)]

dput(table(parents_in$Qu))
structure(c(`AUCUNE information ne doit être partagée avec la communauté de l'Écollectif.` = 1L, 
`Courriel et téléphone` = 85L, `Courriel uniquement` = 15L, 
`Téléphone uniquement` = 1L), dim = 4L, dimnames = structure(list(
    c("AUCUNE information ne doit être partagée avec la communauté de l'Écollectif.", 
    "Courriel et téléphone", "Courriel uniquement", "Téléphone uniquement"
    )), names = ""), class = "table")

parents_in[consentement=="Téléphone uniquement"]

tel_ok <- parents_in[, nc::capture_all_str(
  tel_numbers,
  type=".*?",
  tel="[0-9]+", function(x)sub("^1", "", x)
), by=.(Prénom, Nom, consentement)
][
  consentement %in% c("Courriel et téléphone", "Téléphone uniquement")
]
nc::capture_first_df(tel_ok, tel=list(
  "^",
  ## https://fr.wikipedia.org/wiki/Plan_de_num%C3%A9rotation_nord-am%C3%A9ricain
  ## préfixe local à trois chiffres (appelé indicatif régional
  area="[0-9]{3}",
  "[- ]*",
  ## https://en.wikipedia.org/wiki/North_American_Numbering_Plan#Modern_plan
  exchange="[0-9]{3}",
  "[- ]*",
  station="[0-9]{4}",
  "$"
))[, norm_tel := sprintf("%s %s-%s", area, exchange, station)]

courriel_ok <- parents_in[
, .(Prénom, Nom, consentement, Courriel)
][consentement %in% c("Courriel et téléphone", "Courriel uniquement")]

contact_ok <- rbind(
  tel_ok[, .(
    Prénom, Nom, variable="télephone", contact=ifelse(
      type=="", norm_tel, sprintf("%s:%s", type, norm_tel))
  )],
  courriel_ok[, .(
    Prénom, Nom, variable="courriel", contact=Courriel
  )]
)

fwrite(contact_ok, "parents.csv")
