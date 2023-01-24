#############
## Missings #
#############

# Variable AGE
persones <- persones %>% replace_with_na(replace = list(AGE = c(998, 999)))

# Variable MINUTE
persones <- persones %>% replace_with_na(replace = list(MINUTE = c(99)))
accident <- accident %>% replace_with_na(replace = list(MINUTE = c(99)))

# Variable HOUR
persones <- persones %>% replace_with_na(replace = list(HOUR = c(98, 99)))
accident <- accident %>% replace_with_na(replace = list(HOUR = c(98, 99)))


############################################
# Funció pel tant per cent de dades mancants

propmiss <- function(dataframe) lapply(dataframe,
                                       function(x) data.frame(na = sum(is.na(x)),
                                                                        n = length(x),
                                                              propNA = round(sum(is.na(x))/length(x),4) * 100))
# Taula accident
missingsa <- propmiss(accident)
missingsa <- do.call(rbind.data.frame, missingsa)
missingsa <- missingsa[,-2]
colnames(missingsa) <- c("NA","Percentatge de NA")

# Taula persones
missingsp <- propmiss(persones)
missingsp <- do.call(rbind.data.frame, missingsp)
missingsp <- missingsp[,-2]
colnames(missingsp) <- c("NA","Percentatge de NA")

knitr::kables(
  list(
    knitr::kable(missingsa),
    knitr::kable(missingsp)),
  caption = "Percentatge de missings per variable", format="latex")


######
# KNN

# Taula accident
library(class)
fullVariables<-c(6,7,8,9,10)
aux<-accident[,fullVariables]
var_num_incompletes <- c(2,3)
for (k in var_num_incompletes){
  aux1 <- aux[!is.na(accident[,k]),]
  dim(aux1)
  aux2 <- aux[is.na(accident[,k]),]
  dim(aux2)

  RefValues<- accident[!is.na(accident[,k]),k]

  knn.values = knn(aux1,aux2,RefValues)
  accident[is.na(accident[,k]),k] = as.numeric(as.character(knn.values))
  fullVariables<-c(fullVariables, k)
  aux<-accident[,fullVariables]
}

# Taula persones
library(class)
fullVariables<-c(6,7,8,9,10,11)
aux<-persones[,fullVariables]
var_num_incompletes <- c(2,3,12)
for (k in var_num_incompletes){
  aux1 <- aux[!is.na(persones[,k]),]
  dim(aux1)
  aux2 <- aux[is.na(persones[,k]),]
  dim(aux2)

  RefValues<- persones[!is.na(persones[,k]),k]

  knn.values = knn(aux1,aux2,RefValues)
  persones[is.na(persones[,k]),k] = as.numeric(as.character(knn.values))
  fullVariables<-c(fullVariables, k)
  aux<-persones[,fullVariables]
}

############################################
# Dades mancants després del preprocessament

# Taula accident
missingsa <- propmiss(accident[,c(2,3)])
missingsa <- do.call(rbind.data.frame, missingsa)
missingsa <- missingsa[,-2]
colnames(missingsa) <- c("NA","Percentatge de NA")

# Taula persones
missingsp <- propmiss(persones[c(2,3,12)])
missingsp <- do.call(rbind.data.frame, missingsp)
missingsp <- missingsp[,-2]
colnames(missingsp) <- c("NA","Percentatge de NA")

knitr::kables(
  list(
    knitr::kable(
      missingsa),
    knitr::kable(
      missingsp)
  ),
  caption = "Percentatge de missings per variable després del KNN", format="latex") %>%
  kable_styling(latex_options = "HOLD_position")




#############
## Outliers #
#############


descriptiva <- function(X, nom,dades){
  if (!(is.numeric(X) || class(X) == "Date")){
    frecs <- table(as.factor(X), useNA = "no"); proportions <- frecs/n
    dataf <- data.frame(x = levels(as.factor(X)), y = frecs)
    par(mfrow=c(1,2))
    print(ggplot(dataf, aes(x = "", y = frecs, fill = x)) +
            geom_bar(stat = "identity", width = 1) +
            scale_y_continuous(expand = c(0,0)) + coord_polar("y", start = 0) +
            scale_fill_brewer(palette = "YlGnBu") +
            theme_minimal())
    print(ggplot(dataf, aes(x = x, y=frecs)) + geom_bar(stat = "identity",
                                                        color = "#1d91c0", fill = "#1d91c0") +
            scale_y_continuous(expand = c(0,0)) + theme_void())
    x <- data.frame(X)
    colnames(x) <- nom
    st_options(plain.ascii  = FALSE,  headings = FALSE, footnote = NA,
               style = 'grid', dfSummary.varnumbers = FALSE,
               dfSummary.valid.col = FALSE, tmp.img.dir  = "img", round.digits = 3,
               dfSummary.silent = TRUE, dfSummary.graph.col= FALSE)
    dfSummary(x)

  }else{
    par(mfrow=c(1,2))
    print(ggplot(dades, aes(x = X)) + geom_bar(col = "#1d91c0", fill =
                                                 "#1d91c0") + theme_minimal())
    a <- descr(X, transpose = TRUE, stats = c("N.Valid", "min", "q1", "med",
                                              "mean", "sd", "q3", "max", "iqr"), style = "rmarkdown", justify
               = "center")
    rownames(a) <- NULL
    kable(a, caption = paste("Resum numèric de la variable", nom),
          format = "latex", position = "h!")
  }
}


# Variable Resposta
descriptiva(persones[,8], "Nombre de persones", dades = persones)

# Eliminació d'observacions atípiques
persones <- persones[persones[,8] != 53,]
accident <- accident[accident[,8] != 53,]

# Variable Resposta sense observacions atípiques
descriptiva(persones[,8], "Nombre de persones", dades = persones)






#################
## Categoritzar #
#################

# **PER_TYP**: Tipus de persona (1 = conductor, 2 = ocupant, resta de codis = altres).
persones$PER_TYP <- as.factor(persones$PER_TYP)
levels(persones$PER_TYP) <- c("Conductor", "Ocupant", "Altres", "Altres", "Altres",
                              "Altres", "Altres", "Altres")

# **DAY_WEEK**: Dia de la setmana (1 = Diumenge, 2 = Dilluns, . . . , 7 = Dissabte).
persones$DAY_WEEK <- as.factor(persones$DAY_WEEK)
levels(persones$DAY_WEEK) <- c("Diumenge", "Dilluns", "Dimarts", "Dimecres", "Dijous",
                               "Divendres", "Dissabte")

accident$DAY_WEEK <- as.factor(accident$DAY_WEEK)
levels(accident$DAY_WEEK) <- c("Diumenge", "Dilluns", "Dimarts", "Dimecres", "Dijous",
                               "Divendres", "Dissabte")

# **SEX**: Sexe de la persona (1 = home, 2 = dona, 8 = No registrat, 9 = Desconegut).
persones$SEX <- as.factor(persones$SEX)
levels(persones$SEX) <- c("Home", "Dona", "Desconegut", "Desconegut")

persones <- persones[persones$SEX != "Desconegut",] # Eliminem el nivell "Desconegut"
persones$SEX <- droplevels(persones$SEX)

# **RUR_URB**: Informació sobre la localització (1 = Rural, 2 = Urbà, 6 = Via no classificada, 8 = No registrat, 9 = Desconegut).
persones$RUR_URB <- as.factor(persones$RUR_URB)
accident$RUR_URB <- as.factor(accident$RUR_URB)
levels(persones$RUR_URB) <- c("Rural", "Urbà", "Desconegut",
                              "Desconegut", "Desconegut")
levels(accident$RUR_URB) <- c("Rural", "Urbà", "Desconegut",
                              "Desconegut", "Desconegut")


# **HI HA MORTS**: Variable identificadora dels accidents mortals (0: no hi ha morts en l'accident, 1: hi ha morts en l'accident).
accident$HIHAMORTS <- as.factor(accident$HIHAMORTS)
levels(accident$HIHAMORTS) <- c("No", "Sí")

# **DOA**: Tipus de víctima (0 = sobreviu, 7 = mort a l’accident, 8 = mort al trasllat, 9 = Desconegut)
persones$DOA <- as.factor(persones$DOA)
levels(persones$DOA) <- c("Sobreviu", "Mor", "Mor", "Desconegut")

persones <- persones[persones$DOA != "Desconegut",] # Eliminem el nivell "Desconegut"
persones$DOA <- droplevels(persones$DOA)

# **DAY**
lev <- c("1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13",
         "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25",
         "26", "27", "28", "29", "30", "31")
persones$DAY <- factor(persones$DAY, levels = lev)
accident$DAY <- factor(accident$DAY, levels = lev)

# **HOURS_agrupat**
accident$HOUR_agrupat<- as.factor(accident$HOUR)

levels(accident$HOUR_agrupat) <- c("Matinada","Matinada","Matinada", "Matinada",
                                   "Matinada", "Matinada", "Matí", "Matí", "Matí",
                                   "Matí", "Matí", "Matí", "Migdia", "Migdia",
                                   "Migdia","Tarda","Tarda","Tarda","Tarda","Tarda",
                                   "Nit", "Nit", "Nit", "Nit", "Nit")

persones$HOUR_agrupat <- as.factor(persones$HOUR)
levels(persones$HOUR_agrupat) <- c("Matinada","Matinada","Matinada", "Matinada",
                                   "Matinada", "Matinada", "Matí", "Matí", "Matí",
                                   "Matí", "Matí", "Matí", "Migdia", "Migdia",
                                   "Migdia","Tarda","Tarda","Tarda","Tarda","Tarda",
                                   "Nit", "Nit", "Nit", "Nit", "Nit")

# **SETMANA**
accident$SETMANA <- accident$DAY
levels(accident$SETMANA) <- c("Setmana 1", "Setmana 1", "Setmana 1", "Setmana 1",
                              "Setmana 1", "Setmana 1", "Setmana 2", "Setmana 2",
                              "Setmana 2", "Setmana 2", "Setmana 2", "Setmana 2",
                              "Setmana 2", "Setmana 3", "Setmana 3", "Setmana 3",
                              "Setmana 3", "Setmana 3", "Setmana 3", "Setmana 3",
                              "Setmana 4", "Setmana 4", "Setmana 4", "Setmana 4",
                              "Setmana 4", "Setmana 4", "Setmana 4", "Setmana 5",
                              "Setmana 5", "Setmana 5", "Setmana 5")

persones$SETMANA <- persones$DAY
levels(persones$SETMANA) <- c("Setmana 1", "Setmana 1", "Setmana 1", "Setmana 1",
                              "Setmana 1", "Setmana 1", "Setmana 2", "Setmana 2",
                              "Setmana 2", "Setmana 2", "Setmana 2", "Setmana 2",
                              "Setmana 2", "Setmana 3", "Setmana 3", "Setmana 3",
                              "Setmana 3", "Setmana 3", "Setmana 3", "Setmana 3",
                              "Setmana 4", "Setmana 4", "Setmana 4", "Setmana 4",
                              "Setmana 4", "Setmana 4", "Setmana 4", "Setmana 5",
                              "Setmana 5", "Setmana 5", "Setmana 5")

######################
## Variable resposta #
######################

par(mfrow=c(1,2))
descriptiva(accident[,11], "Hi ha morts", dades = persones)

par(mfrow=c(1,2))
descriptiva(persones[,15], "Tipus de víctima", dades = persones)

##########################
## Guradem els resultats #
##########################

write.csv(accident,"./accidents_bd.csv", row.names = FALSE)
write.csv(persones,"./persones_bd.csv", row.names = FALSE)


