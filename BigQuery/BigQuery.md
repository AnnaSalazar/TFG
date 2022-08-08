 # Què és BigQuery? 
 
La documentació oficial ho descriu com un magatzem de dades multicloud sense servidor, altament escalable i rendible, dissenyat específicament per a l'agilitat empresarial. 
 
Les paraules clau en aquesta definició són **sense servidor**, cosa que significa que els usuaris poden fer ús de BigQuery sense haver de proporcionar cap servidor pel seu compte.
BigQuery **s'escalarà automàticament** per a gestionar fins a petabytes de dades, per la qual cosa mai haurem de preocupar-nos per la grandària de les dades amb els quals treballem. 
Ser **econòmic** i tenir la capacitat de combinar plataformes en el núvol és també un punt fort.
I BigQuery és essencialment un **magatzem de dades**. Recordem ràpidament llavors què és un magatzem de dades per a posar les coses en context. Es tracta d'un sistema per a l'elaboració d'informes, així com per a l'anàlisi de dades, i els magatzems són coneguts per la seva capacitat per a manejar volums molt grans de dades que han estat compilats a partir de moltes fonts diferents. L'objectiu principal de l'ús d'un magatzem de dades és extreure informació significativa que pugui impulsar les seves decisions de negoci, i BigQuery és més que capaç de complir aquest rol.

## Per què hauríem d'utilitzar BigQuery en lloc d'altres eines?

Bé, per a començar, es tracta d'una plataforma sense servidor. De fet, això significa que els servidors s'executen en segon pla, però l'usuari s'abstreu totalment d'això. I significativament, no han de preocupar-se per la sobrecàrrega de la gestió dels servidors.


BigQuery també té una alta disponibilitat. No cal preocupar-se per la caiguda dels servidors, ja que el servei s'encarrega d'això. Ja hem parlat de l'escalabilitat de BigQuery. Això inclou l'autoescalat de clústers basat en la demanda de dades. I l'escalat és capaç de fer front a petabytes de dades.

Aquestes són característiques que no estan disponibles en la majoria dels magatzems tradicionals. Com en molts altres magatzems, BigQuery és capaç de treballar amb moltes fonts de dades diferents. Pot extreure dades del seu propi sistema d'arxius, de Google Cloud Storage o fins i tot de les galledes S3 de Amazon. A continuació, pot consultar aquestes dades utilitzant SQL estàndard o fins i tot SQL heretat si realment ho necessita. El rendiment en qualsevol cas és excel·lent. Els resultats de les consultes solen emmagatzemar-se en la caixet durant 24 hores, de manera que les següents execucions d'aquesta consulta només hauran d'obtenir les dades de la caixet en lloc de fer-ho del disc. A més, el cost total de propietat de BigQuery és relativament baix en comparació amb moltes de les ofertes equivalents d'altres plataformes en el núvol. Parlant d'això, aquí estan algunes de les alternatives a BigQuery de Google. En Amazon Web Services està Redshift, està SQL Data Warehouse en el núvol Azure, i també està la plataforma Snowflake.


# Arrangement of data in BigQuery


Una vegada vista l'arquitectura de BigQuery, podem passar a alguna cosa que és una mica més tangible per a nosaltres com a usuaris, que és la disposició de les dades.

Per a començar, donem un cop d'ull a les taules, que per descomptat és una estructura de dades on la informació s'organitza en forma de files i columnes. Les taules són una part essencial de BigQuery, i normalment treballaràs amb moltes d'elles. I els permisos es poden assignar fins i tot a nivell de taula individual. Per tant, si bé podem accedir a les dades en les taules, també podem arribar a ells utilitzant vistes, que són en essència derivats de les taules. Com en la majoria de les bases de dades relacionals, les vistes en BigQuery es construeixen mitjançant consultes sobre una o diverses taules subjacents. Quin és llavors el propòsit d'una vista? Bé, el propòsit principal és ocultar la complexitat d'una consulta subjacent. Una vista pot definir-se com una consulta que implica múltiples unions i operacions complexes sobre les dades. I aquesta mateixa operació es pot realitzar amb una simple consulta contra la vista. És important destacar que les vistes en BigQuery no emmagatzemen cap dada per si mateixes. En essència, són capes d'abstracció entre un usuari i les taules subjacents. No obstant això, també és possible assignar permisos a nivell de vista sense concedir als usuaris accés directe a les taules subjacents. Atès que les vistes no emmagatzemen cap dada per si mateixes, el cost d'executar consultes contra les vistes és el mateix que el de consultar les dades subjacents. El que és una mica diferent d'una vista estàndard de BigQuery és una vista materialitzada. Aquesta també es defineix com una consulta contra les dades subjacents. No obstant això, les dades retornades per l'execució de la consulta s'emmagatzemen en caixet. Així que una consulta contra una vista materialitzada és una consulta contra aquestes dades en caixet.


Podem configurar exactament la freqüència amb la qual ha de refrescar-se aquesta caixet per a evitar que els usuaris de les vistes materialitzades rebin dades obsoletes. Alguns dels casos d'ús d'aquesta mena de vistes inclouen la preagregació de dades perquè l'agregació no hagi de realitzar-se sobre la marxa, i puguem simplement recuperar-los tal qual des de la vista materialitzada. De la mateixa manera, es poden utilitzar per a emmagatzemar dades prefiltrados, de manera que només s'emmagatzemi en la vista materialitzada la informació rellevant de les taules subjacents. I de la mateixa manera, podem evitar les operacions d'unió sobre la marxa emmagatzemant les dades d'unió en aquestes vistes.

Some of the use cases of such views include pre-aggregating data so that the aggregation need not be performed on the fly, and we can simply retrieve them as is from the materialized view. Similarly, these can be used to store pre-filtered data, so that only relevant information from the underlying tables is stored in the materialized view. And similarly, we can avoid join operations on the fly by storing the join data in such views. One more type of view supported in BigQuery is the authorized view. Users can be granted access to these views, and significantly, this is not the same as granting them access to the underlying data. If an authorized view is created by applying some filters on underlying data, a user of the view will only be able to view this filtered data and may not have access to the source tables. To enable authorized views, however, the view itself needs to be authorized to query the source data. So now that we have an understanding of the different types of views in BigQuery, we know that data can be accessed either via views or by querying tables. It is likely that you will end up with a number of related tables and views, and to group these together, BigQuery offers a construct called a dataset. Datasets in turn can be grouped together into a GCP project. With that, we have an understanding of how data can be grouped when it comes to BigQuery. But now let's zoom in a little bit on individual tables and see how this is represented. BigQuery adopts the columnar data model. So while each table is arranged as rows and columns, it is each column which is separately stored in a file block. Unlike relational databases where it is rows or records that are stored together, BigQuery stores the data in tables as columns. If a query requests specific columns in your table, it is just the corresponding file blocks which will be retrieved and processed. This of course can make data analysis or online analytical processing tasks very, very efficient. Beyond this, though, BigQuery also allows us to mutate the data in our tables, though these operations won't be as efficient as on a transactional database. While data is stored as columns, this does not mean that the entire column is stored together. These in turn can be split into segments called partitions. The partitioning may be based on one of the fields in your table, but these need to be either an integer or of a temporal type. Alternatively, you may also partition your data based on the time of ingestion. A crucial benefit of partitioning is that it reduces the number of bytes which you need to read, since the data which you need may be retrieved from just a handful of partitions rather than having to process an entire column of data. And we will soon see that this has an effect on the costs of using BigQuery. Furthermore, partitioning also improves query performance since less data needs to be scanned and processed. And, to improve performance even further, partitioning can be combined with table clustering, which is one more means of colocating related data.