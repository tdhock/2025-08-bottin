library(data.table)
parents_in <- fread("Correction.csv")
parents_long <- melt(
  parents_in[, ligne := 1:.N],
  measure.vars=measure(value.name, nombre, pattern="(.*) du parent ([0-9])"),
  id.vars="ligne"
)[!is.na(Nom)]

tel_ok <- melt(
  parents_long,
  measure.vars=measure(prefix, pattern="(.*)éléphone"),
  id.vars=c("Nom")
)[value!=""][, let(
  tel_numbers=sub("^([+]1|[^0-9]+)", "", gsub("[-. ()]", "", value))
)][, let(
  nchar=nchar(tel_numbers)
)]
tel_ok[nchar!=10]
tel_norm <- nc::capture_first_df(tel_ok, tel_numbers=list(
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

parents_info <- parents_long[, .(ligne, Nom, Courriel)][tel_norm[,.(Nom,Tél=norm_tel)],on="Nom"][order(ligne, Nom)]
parents_out <- parents_info[, .(ligne, parent=Nom, Tél, Courriel)]
fwrite(parents_out, "parents.csv")
