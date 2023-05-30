# TFG - BigQuery

## Entorn de desenvolupament del projecte

Aquest projecte s'ha realitzat mitjançant 2 llenguatges de programació:
- SQL: a partir de la interfície [BigQuery](https://cloud.google.com/bigquery?hl=es)
- R: mitjançant el programari [RStudio](https://www.rstudio.com/products/rstudio/download/) (Versió 4.2.0)

Específicament, els paquets necessaris pel desenvolupament del projecte a l'entorn R són els següents:
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

Per a l'emmagatzemament de les dades s'ha fet servir la plataforma [BigQuery](https://cloud.google.com/bigquery?hl=es), i per a la visualització d'aquestes s'ha creat una conexió amb [Looker Studio](https://datastudio.google.com/overview).

## Introducció

L’objectiu d’aquest treball és conèixer un dels recursos de la plataforma Google Cloud, anomenat BigQuery. A partir de l’enteniment de com funciona la computació al núvol i l’emmagatzemament de dades en el mateix entorn, es vol crear un material pedagògic per a incloure en el programari de l’assignatura de Fitxers i Bases de Dades del grau d’Estadística.

Amb aquest propòsit en ment, el treball es divideix en tres apartats principals. En primer lloc, s’aprofundirà en la descripció de la plataforma al llarg de les primeres cinc seccions. Primer es descriurà BigQuery a alt nivell per, més endavant, poder entendre l’estructura de la interfície d’usuari i les maneres en què es pot interactuar amb el sistema. En aquest apartat també s’inclouran les connexions amb altres plataformes i *softwares* per a poder treure el màxim profit de les dades d’estudi. Seguidament, el segon apartat està conformat per una única secció, que contempla l’aplicació de BigQuery a l’entorn de classe i inclou la valoració dels mateixos estudiants sobre la seva experiència i visió. En últim lloc, es presenta l’anàlisi d’una base de dades mitjançant la connexió amb el programari R. En aquest apartat, es realitza part de l’exploració de les dades a R i part a BigQuery, tot tenint en compte les limitacions del llenguatge que s’utilitza en cada entorn i els recursos visuals que ofereixen.

Dins d'aquest repositori es pot trobar:

A la carpeta [Data Studio](https://github.com/AnnaSalazar/TFG/tree/main/Data%20Studio), un curt video exemplificant com es faria una gràfica en aquest entorn, i un document amb la descripció de la plataforma. També s'hi troben els arxius amb els gràfics obtinguts.

A [Valoracio_classe](https://github.com/AnnaSalazar/TFG/tree/main/Valoracio_classe) s'hi troben tots els arxius amb les valoracions dels alumnes sobre la plataforma, així com el codi per general els gràfics de caixa exposats al treball.

Per últim, a la carpeta [Dades originals](https://github.com/AnnaSalazar/TFG/tree/main/Dades%20originals) es troben les dades analitzades a l'última secció del treball, i el codi del preprocessament i l'anàlisi per components principals a [scripts R](https://github.com/AnnaSalazar/TFG/tree/main/scripts%20R). Pel que fa a la regressió logística, tota la informació s'hi troba a [BigQueryML]().


## Metodologia

Per poder fer un seguiment del treball i exemplificar tota la informació teòrica que s’anirà veient en el transcurs d’aquest, s’ha fet ús de dos conjunts de dades.

Per una banda, s’ha tractat una base de dades pública a l’entorn de BigQuery, anomenada [Catalonia Cell Coverage](https://console.cloud.google.com/marketplace/product/gencat/cell_coverage?hl=es-419). Aquesta conté informació sobre la cobertura de telefonia mòbil de la població catalana que va ser recopilada des de l’any 2015 fins al 2017, ambdós inclosos. Algunes de les variables que es van tenir en compte en aquest estudi van ser el senyal mitjà del dispositiu, el nom de la xarxa i de l’operador, la velocitat estimada de la font i el codi postal del lloc on es va adquirir la telemetria.

| Variable           | Tipus         | Descripció                                                                                                        |
|--------------------|---------------|-------------------------------------------------------------------------------------------------------------------|
| date            | Data    | Data de telemetria en format AAAA-MM-DD                                                                                             |
| hour                | Temps    | Hora de telemetria en format HH24:MM:SS                                                                                  |
| lat               | Numèrica      | Latitud                                                                             |
| long             | Numèrica      | Longitud                                                                             |
| signal            | Numèrica    | Senyal mitjana |
| network           | Categòrica    | Nom de la xarxa                                                  |
| operator             | Categòrica      | Nom de l’operador                                                                                     |
| status           | Numèrica      | Codi de l’estat = {0, 1, 2, 3}                                                             |
| description            | Categòrica    | Descripció de l’estat: En servei (0), Fora de servei (1), Estat d’emergència (2), Apagat (3).|
| net                | Categòrica    | Tipus de xarxa = 2G, 3G, 4G                                                                                  |
| speed               | Numèrica      | Velocitat estimada de la font                                                                            |
| satellites             | Numèrica      | Nombre de satèl·lits GPS                                                                           |
| precission            | Numèrica    | Constant que decriu la precisió del proveïdor |
| provider           | Categòrica    | Nom del proveïdor de la posició                                                 |
| activity             | Categòrica      | Activitat de l’usuari: en un vehicle, parat, a peu, inclinat, amb bicicleta i desconegut                                                                                    |
| downloadSpeed           | Numèrica      | Velocitat de descàrrega actual                                                             |
| uploadSpeed            | Numèrica    | Velocitat de càrrega actual |
| postal_code           | Categòrica    | Codi postal                                                 |
| town_name             | Categòrica      | Nom de la ciutat on es va adquirir la telemetria                                                                                   |
| position_geom           | Numèrica      | Representació geogràfica de la posició                                                              |


Per altra part, s’han utilitzat unes dades que provenen de l’agència estatal de trànsit de Washington, Estats Units. L’Administració Nacional de Seguretat del Trànsit a les Carreteres, National Highway Traffic Safety Administration (NHTSA) en anglès, va fer públiques tres taules que feien referència als accidents ocorreguts al llarg de l’any 2015, les persones involucrades en aquests (siguin conductors, passatgers o vianants) i un inventari de tots els vehicles que van ser afectats. Les dades tractades són una mostra que conté tots els accidents produïts el mes de desembre d’aquell any. 

Aquesta informació es pot trobar al web de la NHTSA: 
<https://www.transportation.gov/briefing-room/traffic-fatalities-sharply-2015>



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









