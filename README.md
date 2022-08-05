# TFG - Accidents de cotxe

## Entorn de desenvolupament del projecte

Aquest projecte s'ha realitzat mitjançant el llenguatge de programació [RStudio](https://www.rstudio.com/products/rstudio/download/): Versió 4.2.0

Específicament, els paquets necessàris pel desenvolupament del projecte són els següents:
- `bigrquery`
- `kableExtra`
- `DBI`
- `knitr`
- `dplyr`
- `VIM`
- `tidyverse`
- `summarytools`
- `reshape2`
- `ggplot2`
- `devtools`
- `naniar`
- `forcats`
- `sqldf`

Per a l'emmagatzemament de les dades s'ha fet servir la plataforma [BigQuery](https://cloud.google.com/bigquery?hl=es), i per a la visualització d'aquestes s'ha creat una conexió amb [Data Studio](https://datastudio.google.com/overview).

## Font d'obtenció de les dades

Les bases de dades que seran utilitzades al llarg de l'estudi provenen de l'agència estatal de trànsit dels Estats Units i contenen tres taules, entre les quals s'hi troba un llistat d’accidents de tràfic ocorreguts al desembre de 2015 als Estats Units, juntament amb un recompte de totes les persones (conductors, passatgers o vianants) involucrades als accidents i, finalment, un inventari de tots els vehicles involucrats als accidents. 

L'enllaç a la base esmentada és el següent: 

<https://www.transportation.gov/briefing-room/traffic-fatalities-sharply-2015>

## Descripció de les dades

**Accident** és un llistat d’accidents de trànsit ocorreguts al desembre de 2015 als Estats Units.

| Variable           | Tipus         | Descripció                                                                                                        |
|--------------------|---------------|-------------------------------------------------------------------------------------------------------------------|
| ST_CASE            | Categòrica    | Codi de l’accident                                                                                                |
| DAY                | Categòrica    | Dia de l’accident (de l’1 al 31)                                                                                  |
| HOUR               | Numèrica      | Hora de l’accident (99 = desconeguda)                                                                             |
| MINUTE             | Numèrica      | Minut de l’accident (99 = desconegut)                                                                             |
| RUR_URB            | Categòrica    | Informació sobre la localització (1 = Rural, 2 = Urbà, 6 = Via no classificada, 8 = No registrat, 9 = Desconegut) |
| DAY_WEEK           | Categòrica    | Dia de la setmana (1 = Diumenge, 2 = Dilluns, ..., 7 = Dissabte)                                                  |
| FATALS             | Numèrica      | Nombre de ferits a l’accident                                                                                     |
| DRUNK_DR           | Numèrica      | Nombre de conductors beguts involucrats a l’accident                                                              |



**Person** és un llistat de totes les persones (conductors, passatgers o vianants) involucrades als accidents.

| Variable           | Tipus         | Descripció                                                                                                        |
|--------------------|---------------|-------------------------------------------------------------------------------------------------------------------|
| ST_CASE            | Categòrica    | Codi de l’accident al qual està involucrada la persona                                                            |
| PER_NO             | Categòrica    | Nombre de la persona dins de cada accident                                                                        |
| AGE                | Numèrica      | Edat de la persona (998 = No registrada, 999 = Desconeguda)                                                       |
| SEX                | Categòrica    | Sexe de la persona (1 = home, 2 = dona, 8 = No registrat, 9 = Desconegut)                                          |
| PER_TYP            | Categòrica    | Tipus de persona (1 = conductor, 2 = ocupant, resta de codis = altres)                                            |
| DOA                | Categòrica    | Tipus de víctima (0 = sobreviu, 7 = mort a l’accident, 8 = mort al trasllat, 9 = Desconegut)                |



**Vehicle** és un llistat de tots els vehicles involucrats als accidents.
                                                                                                            

| Variable           | Tipus         | Descripció                                                                                                        |
|--------------------|---------------|-------------------------------------------------------------------------------------------------------------------|
| ST_CASE            | Categòrica    | Codi de l’accident al qual està involucrat el vehicle                                                             |
| NO_VEH             | Numèrica      | Nombre de vehicles implicats en l'accident                                                                        |
| HIT_RUN            | Categòrica    | Identificador de vehicle fugit (0 = No, 1 = Sí, 9 = Desconegut)                                                   |
| TRAV_SP            | Numèrica      | Velocitat estimada (mph) del vehicle quan va tenir l’accident (997,998 i 999 = Desconegut)                        |
| PREV_SP            | Categòrica    | Indicador d’existència de límit de velocitat permesa just abans de l’accident (997,998 i 999 = Desconegut)  |




## Objectius del projecte

Estudiant aquesta base de dades sobre persones que s'han vist implicades, de forma directa o indirecta, en accidents de trànsit es preten:

- Descriure els tipus d'accidents que estan registrats

- Analitzar els diferents perfils de persones que pateixen accidents de trànsit

- Desenvolupar un model de predicció que ens permeti establir el tipus de víctima que serà cada persona depenent les característiques de l'accident i els vehicles. 

- Estudiar les relacions de dependència entre variables

## Estructura del projecte
