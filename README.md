## Bottin

- étape 1 : [etudiants_pages.R](etudiants_pages.R) lit [Liste classes](Liste classes 25-26.pdf) et écrit [etudiants_pages.csv](etudiants_pages.csv).
- étape 2 : [parents.R](parents.R) lit [Parents sondage CSV](Consentement à partager les coordonnées 25-26 - étudiants standardisés.csv) et écrit [parents.csv](parents.csv) avec les contacts consentis pour chaque parent.
- étape 3 : [etudiants_parents.R](parents.R) lit [Parents sondage CSV](Consentement à partager les coordonnées 25-26 - étudiants standardisés.csv) et écrit [etudiants_parents.csv](etudiants_parents.csv) avec les parent(s) pour chaque étudiants.
- étape 4 : [quarto bottin](bottin.qmd) lit les CSV et produit un DOCX.
