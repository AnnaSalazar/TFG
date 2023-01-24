# Càrrega de paquets
x <- c("bigrquery", "kableExtra", "DBI", "knitr", "dplyr", "VIM",
       "tidyverse", "summarytools", "reshape2", "ggplot2", "devtools",
       "naniar", "forcats", "sqldf", "factoextra")
lapply(x, require, character.only = TRUE)

# Connexió al nostre conjunt de dades

projecte <- "[nom_projecte]"

dades <- dbConnect(
  bigrquery::bigquery(),
  project = projecte,
  dataset = "[nom_base_de_dades]",
  billing = projecte
)

# Lectura de les taules
A <- data.frame(dbGetQuery(dades,
     "SELECT * FROM `[nom_projecte].[nom_base_de_dades].accident`"))
B <- data.frame(dbGetQuery(dades,
     "SELECT * FROM `[nom_projecte].[nom_base_de_dades].person`"))
C <- data.frame(dbGetQuery(dades,
     "SELECT * FROM `[nom_projecte].[nom_base_de_dades].vehicle`"))


C$HIT_RUN[C$HIT_RUN==9] <- 0 # A la categoria "Desconegut" li adjudiquem 0
B$MORT == 0 # Creem una nova variable
B$MORT[B$DOA==7 | B$DOA==8 ] <- 1 # Els codis 7 i 8 de la variable DOA indiquen que la persona ha mort

########################
# Lectura de les dades #
########################

# Nombre de persones per accident
query11 <- sqldf("SELECT DISTINCT A.ST_CASE, DAY, HOUR, MINUTE, RUR_URB, DAY_WEEK,
                         FATALS, DRUNK_DR, COUNT(B.ST_CASE) AS NO_PER, SUM(MORT) AS MORTS
                  FROM B INNER JOIN  A
                  ON A.ST_CASE = B.ST_CASE
                  GROUP BY A.ST_CASE, DAY, HOUR, MINUTE, RUR_URB, DAY_WEEK,
                           FATALS, DRUNK_DR")

query11$MORTS[is.na(query11$MORTS)] <- 0

# Nombre de vehicles per accident
query12 <- sqldf("SELECT DISTINCT A.ST_CASE, DAY, HOUR, MINUTE, RUR_URB, DAY_WEEK,
                         FATALS, DRUNK_DR, COUNT(C.ST_CASE) AS NO_VEHICLE
                  FROM C INNER JOIN  A
                  ON A.ST_CASE = C.ST_CASE
                   GROUP BY A.ST_CASE, DAY, HOUR, MINUTE, RUR_URB, DAY_WEEK,
                            FATALS, DRUNK_DR")


# Ajuntem l'accident amb el nombre de persones i el nombre de vehicles
accidents <- sqldf("SELECT query11.*, NO_VEHICLE
                    FROM query11 INNER JOIN  query12
                    ON query11.ST_CASE = query12.ST_CASE")
accident <- accidents[,-1] # Eliminem l'identificador per l'anàlisi

# Creació de la variable HIHAMORTS
accident$HIHAMORTS = 0
accident$HIHAMORTS[accidents$MORTS>0] <- 1

# Passem les variables categòriques a factors
accident <- data.frame(accident)
for(i in c(1, 4, 5, 11)) {
  accident[,i]<-as.factor(accident[,i])
}

# Ajuntem l'accident amb els vehicles
query3 <- sqldf("SELECT accidents.*, SUM(HIT_RUN) AS NO_FUGITS
                        FROM accidents INNER JOIN  C
                        ON accidents.ST_CASE = C.ST_CASE
                GROUP BY accidents.ST_CASE, DAY, HOUR, MINUTE, RUR_URB, DAY_WEEK,
                                 FATALS, DRUNK_DR
                HAVING HIT_RUN <> 9")

# Ajuntem l'accident amb les persones
query4 <- sqldf("SELECT query3.*, AGE, SEX, PER_TYP, DOA
                        FROM query3 INNER JOIN  B
                        ON query3.ST_CASE = B.ST_CASE")
persones <- query4[,-1] # Eliminem l'identificador per l'anàlisi
n <- nrow(persones)

# Passem les variables categòriques a factors
persones <- data.frame(persones)
for(i in c(1, 4, 5, 13, 14, 15)) {
  persones[,i]<-as.factor(persones[,i])
}

