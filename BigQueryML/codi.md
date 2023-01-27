# Codi BigQuery

### Crear conjunt *train*

```
CREATE OR REPLACE TABLE asalazbe23.dades.trainData AS
SELECT *
FROM `asalazbe23.dades.accidents`
WHERE NOT DAY IN (
  SELECT DISTINCT DAY FROM `asalazbe23.dades.testData`
);
```

### Crear conjunt *test*

```
CREATE TABLE asalazbe23.dades.testData AS
SELECT *
FROM `asalazbe23.dades.accidents`
WHERE MOD(ABS(FARM_FINGERPRINT(CAST(DAY AS STRING))), 5) = 0;
```

## Creació del model

```
CREATE OR REPLACE MODEL asalazbe23.dades.baseModel 

OPTIONS(input_label_cols=['HIHAMORTS'], model_type='logistic_reg', CATEGORY_ENCODING_METHOD='DUMMY_ENCODING', calculate_p_values=TRUE) AS 
SELECT *  EXCEPT (MORTS, HOUR, SETMANA, DAY)
FROM `asalazbe23.dades.trainData`;
```

### Ajustar el model a les dades *train*

```
SELECT *
FROM ML.EVALUATE(MODEL `asalazbe23.dades.baseModel`, 
(
  SELECT *  EXCEPT (MORTS, HOUR, SETMANA)
  FROM `asalazbe23.dades.trainData`));
```

### Ajustar el model a les dades *test*

```
SELECT *
FROM ML.EVALUATE(MODEL `asalazbe23.dades.baseModel`, 
(
  SELECT * EXCEPT (MORTS, HOUR, SETMANA)
  FROM `asalazbe23.dades.testData`));
```

### Obtenció dels coeficients de les variables del model

```
SELECT * from ML.WEIGHTS(MODEL asalazbe23.dades.baseModel);
```
