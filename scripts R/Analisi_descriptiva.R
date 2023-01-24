#########################
## Variables numèriques #
#########################

### Variables vinculades als accidents

a1 <- descr(accident$HOUR, transpose = TRUE, stats = c("N.Valid", "min", "q1", "med", "mean", "sd", "q3", "max", "iqr"), style = "rmarkdown", justify = "center")
rownames(a1) <- NULL

a2 <- descr(accident$MINUTE, transpose = TRUE, stats = c("N.Valid", "min", "q1", "med", "mean", "sd", "q3", "max",
                                                         "iqr"), style = "rmarkdown", justify = "center")
rownames(a2) <- NULL

a3 <- descr(accident$FATALS, transpose = TRUE, stats = c("N.Valid", "min", "q1", "med", "mean", "sd", "q3", "max",
                                                         "iqr"), style = "rmarkdown", justify = "center")
rownames(a3) <- NULL

a4 <- descr(accident$DRUNK_DR, transpose = TRUE, stats =  c("N.Valid", "min", "q1", "med", "mean", "sd", "q3",
                                                            "max", "iqr"), style = "rmarkdown", justify = "center")
rownames(a4) <- NULL

a5 <- descr(accident$MORTS, transpose = TRUE, stats = c("N.Valid", "min", "q1", "med", "mean", "sd", "q3",
                                                        "max", "iqr"), style = "rmarkdown", justify = "center")
rownames(a5) <- NULL

a6 <- descr(accident$NO_PER, transpose = TRUE, stats = c("N.Valid", "min", "q1", "med", "mean", "sd", "q3", "max",
                                                         "iqr"), style = "rmarkdown", justify = "center")
rownames(a6) <- NULL

a7 <- descr(accident$NO_VEHICLE, transpose = TRUE, stats =
              c("N.Valid", "min", "q1", "med", "mean", "sd", "q3", "max", "iqr"),
            style = "rmarkdown", justify = "center")
rownames(a7) <- NULL

a <- rbind(a1,a2,a3,a4,a5,a6,a7)
Variable <- c("HOUR", "MINUTE", "FATALS", "DRUNK_DR", "NO_PER", "MORTS", "NO_VEHICLE")
a <- cbind(Variable,a)
kable(a, caption = "Resum de les variables numèriques vinculades als accidents",
      format = "latex", position = "h!")




### Variables vinculades a les persones
a1 <- descr(persones$HOUR, transpose = TRUE, stats = c("N.Valid", "min", "q1", "med", "mean", "sd", "q3", "max", "iqr"), style = "rmarkdown", justify = "center")
rownames(a1) <- NULL

a2 <- descr(persones$MINUTE, transpose = TRUE, stats = c("N.Valid", "min", "q1", "med", "mean", "sd", "q3", "max",
                                                         "iqr"), style = "rmarkdown", justify = "center")
rownames(a2) <- NULL

a3 <- descr(persones$FATALS, transpose = TRUE, stats = c("N.Valid", "min", "q1", "med", "mean", "sd", "q3", "max",
                                                         "iqr"), style = "rmarkdown", justify = "center")
rownames(a3) <- NULL

a4 <- descr(persones$DRUNK_DR, transpose = TRUE, stats =  c("N.Valid", "min", "q1", "med", "mean", "sd", "q3",
                                                            "max", "iqr"), style = "rmarkdown", justify = "center")
rownames(a4) <- NULL

a5 <- descr(persones$MORTS, transpose = TRUE, stats = c("N.Valid", "min", "q1", "med", "mean", "sd", "q3",
                                                        "max", "iqr"), style = "rmarkdown", justify = "center")
rownames(a5) <- NULL

a6 <- descr(persones$NO_PER, transpose = TRUE, stats = c("N.Valid", "min", "q1", "med", "mean", "sd", "q3", "max",
                                                         "iqr"), style = "rmarkdown", justify = "center")
rownames(a6) <- NULL

a7 <- descr(persones$NO_VEHICLE, transpose = TRUE, stats =
              c("N.Valid", "min", "q1", "med", "mean", "sd", "q3", "max", "iqr"),
            style = "rmarkdown", justify = "center")
rownames(a7) <- NULL

a8 <- descr(persones$NO_FUGITS, transpose = TRUE, stats = c("N.Valid", "min", "q1",
                                                            "med", "mean", "sd", "q3",
                                                            "max", "iqr"),
            style = "rmarkdown", justify = "center")
rownames(a8) <- NULL

a9 <- descr(persones$AGE, transpose = TRUE, stats = c("N.Valid", "min", "q1",
                                                      "med", "mean", "sd",
                                                      "q3", "max", "iqr"),
            style = "rmarkdown", justify = "center")
rownames(a9) <- NULL

a <- rbind(a1, a2, a3, a4, a5, a6, a7, a8, a9)
variable <- c("HOUR", "MINUTE", "FATALS", "DRUNK_DR", "NO_PER", "MORTS", "NO_VEHICLE", "NO_FUGITS", "EDAT")
a <- cbind(variable,a)
kable(a, caption = "Resum de les variables numèriques vinculades a les persones",
      format = "latex", position = "h!")



###########################
## Variables categòriques #
###########################

### Variables vinculades als accidents

# **DAY**: Dia de l’accident (de l’1 al 31).
st_options(plain.ascii  = FALSE,  headings = FALSE, footnote = NA,
           style = 'grid', dfSummary.varnumbers = FALSE,
           dfSummary.valid.col = TRUE, tmp.img.dir  = "img", round.digits = 3,
           dfSummary.silent = TRUE, dfSummary.graph.col= FALSE)
dfSummary(accident[,1])

# **RUR_URB**: Informació sobre la localització (1 = Rural, 2 = Urbà, 6 = Via no classificada, 8 = No registrat, 9 = Desconegut).
st_options(plain.ascii  = FALSE,  headings = FALSE, footnote = NA,
           style = 'grid', dfSummary.varnumbers = FALSE,
           dfSummary.valid.col = TRUE, tmp.img.dir  = "img", round.digits = 3,
           dfSummary.silent = TRUE, dfSummary.graph.col= FALSE)
dfSummary(accident[,4])

# **DAY_WEEK**: Dia de la setmana (1 = Diumenge, 2 = Dilluns, . . . , 7 = Dissabte).
st_options(plain.ascii  = FALSE,  headings = FALSE, footnote = NA,
           style = 'grid', dfSummary.varnumbers = FALSE,
           dfSummary.valid.col = TRUE, tmp.img.dir  = "img", round.digits = 3,
           dfSummary.silent = TRUE, dfSummary.graph.col= FALSE)
dfSummary(accident[,5])


# **HIHAMORTS**
st_options(plain.ascii  = FALSE,  headings = FALSE, footnote = NA,
           style = 'grid', dfSummary.varnumbers = FALSE,
           dfSummary.valid.col = TRUE, tmp.img.dir  = "img", round.digits = 3,
           dfSummary.silent = TRUE, dfSummary.graph.col= FALSE)
dfSummary(accident[,11])




### Variables vinculades a les persones


# **SEX**: Sexe de la persona (1 = home, 2 = dona, 8 = No registrat, 9 = Desconegut).
st_options(plain.ascii  = FALSE,  headings = FALSE, footnote = NA,
           style = 'grid', dfSummary.varnumbers = FALSE,
           dfSummary.valid.col = TRUE, tmp.img.dir  = "img", round.digits = 3,
           dfSummary.silent = TRUE, dfSummary.graph.col= FALSE)
dfSummary(persones[,13])

# **PER_TYP**: Tipus de persona (1 = conductor, 2 = ocupant, resta de codis = altres).
st_options(plain.ascii  = FALSE,  headings = FALSE, footnote = NA,
           style = 'grid', dfSummary.varnumbers = FALSE,
           dfSummary.valid.col = TRUE, tmp.img.dir  = "img", round.digits = 3,
           dfSummary.silent = TRUE, dfSummary.graph.col= FALSE)
dfSummary(persones[,14])

# **DOA**: Tipus de víctima (0 = sobreviu, 7 = mort a l’accident, 8 = mort al trasllat, 9 = Desconegut).
st_options(plain.ascii  = FALSE,  headings = FALSE, footnote = NA,
           style = 'grid', dfSummary.varnumbers = FALSE,
           dfSummary.valid.col = TRUE, tmp.img.dir  = "img", round.digits = 3,
           dfSummary.silent = TRUE, dfSummary.graph.col= FALSE)
dfSummary(persones[, 15])








