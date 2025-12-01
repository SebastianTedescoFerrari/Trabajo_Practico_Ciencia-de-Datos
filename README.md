README.md – Trabajo Final de Ciencia de Datos para Economía y Negocios (UBA)

Integrantes: Sebastián Tedesco Ferrari · Franco Verdile
Materia: Ciencia de Datos para Economía y Negocios – FCE-UBA
Año: 2025
Docente: —

Descripción general del proyecto

Este proyecto analiza el riesgo crediticio utilizando el dataset Credit Risk Dataset (Kaggle).
Se desarrolla un pipeline completo de ciencia de datos que incluye:

Limpieza y procesamiento de datos

Análisis Exploratorio (EDA)

Detección y tratamiento de outliers

Manejo de datos faltantes

Evaluación del impacto de la limpieza

Test de hipótesis

Modelado inferencial mediante regresión logística

Visualizaciones editorializadas con storytelling

Conclusiones, limitaciones y propuestas futuras

El objetivo principal es estimar la probabilidad de default, identificar variables relevantes y comunicar resultados de manera clara y reproducible.

🔬 Hipótesis del estudio
H1 (central)

La probabilidad de default aumenta con la tasa de interés y el porcentaje del ingreso comprometido, y disminuye con el nivel de ingreso y la antigüedad laboral.

H2

Los préstamos que terminan en default presentan tasas de interés significativamente mayores.

H3

Ciertas intenciones del préstamo (ej. medical, debt_consolidation) están asociadas a tasas de default más altas.

Estructura del proyecto (formato exigido por la cátedra)
proyecto/
├── data/
│   ├── raw/               # Datos crudos originales (Kaggle)
│   ├── clean/             # Datos limpios tras preprocesamiento
│   └── processed/         # Datos finales listos para modelado
│
├── scripts/               # Scripts en orden reproducible
│   ├── 01_import_y_limpieza.R
│   ├── 02_outliers_y_missing.R
│   ├── 03_eda_y_descriptivas.R
│   ├── 04_modelo_inferencial.R
│   └── 05_visualizaciones_storytelling.R
│
├── output/
│   ├── tables/            # Tabla descriptivas, métricas, test, coeficientes
│   └── figures/           # Gráficos EDA, editoriales, ROC, PR, etc.
│
└── README.md

✔ Principio de autocontención (muy importante para la nota)

Cada script genera un output que alimenta al siguiente.

01 produce /data/clean/

02 produce /data/processed/

03 genera gráficos y descriptivas

04 genera resultados estadísticos y métricas

05 produce gráficos editorializados finales

Esta estructura garantiza reproducibilidad completa.

Cómo reproducir el análisis
Requisitos

- Instalar los siguientes paquetes R:

install.packages(c(
  "tidyverse", "ggplot2", "dplyr", "readr", "scales",
  "yardstick", "patchwork", "tidymodels"
))

- Ejecutar los scripts en orden
Rscript scripts/01_import_y_limpieza.R
Rscript scripts/02_outliers_y_missing.R
Rscript scripts/03_eda_y_descriptivas.R
Rscript scripts/04_modelo_inferencial.R
Rscript scripts/05_visualizaciones_storytelling.R


Esto generará automáticamente todas las carpetas y archivos en /output/.

Resultados principales
✔ Test de hipótesis (H2)

La tasa de interés del grupo moroso es significativamente mayor (p < 0.05).
Se confirma H2.


✔ Regresión logística (H1 y H3)

Variables más influyentes:

loan_percent_income (+)

loan_int_rate (+)

person_income (–)

person_emp_length (–)

loan_intent (categorías con riesgo elevado)


El modelo alcanza:

ROC-AUC ≈ 0.73

PR-AUC ≈ 0.52 (esperable por desbalance de clases)

Se confirma parcialmente H1 y H3.

Gráficos incluidos (output/figures/)

g1_ingreso_estilo.png — Distribución de ingresos

g2_edad_estilo.png — Distribución de edad

g3_tasa_estilo.png — Distribución de tasas de interés

g4_intent_estilo.png — Default por intención del préstamo

g5_quintil_estilo.png — Default por quintil de ingreso

g6_boxplot_estilo_nuevo.png — Tasa de interés por estado del préstamo

roc_curve.png — Curva ROC

pr_curve.png — Curva Precision–Recall

confusion_matrix.png — Matriz de confusión

Todos con estilo unificado tipo storytelling.


Impacto de la limpieza

Las estadísticas descriptivas cambiaron levemente luego de winsorizar outliers.

La estructura central del dataset se mantuvo.

La limpieza redujo la dispersión excesiva en ingresos y montos, mejorando la estabilidad del modelo.

No se observó sesgo por eliminación de NA (mecanismo MCAR/MAR).


Conclusiones generales

Se identificaron variables determinantes del riesgo crediticio.

El modelo es estable, interpretable y consistente con la teoría económica.

La tasa de interés y el porcentaje del ingreso comprometido son predictores clave.

El desbalance de clases afecta métricas como PR-AUC, pero no invalida conclusiones.


Limitaciones

Dataset desbalanceado (8% morosos).

Sin estructura temporal.

Falta de variables financieras profundas (score crediticio real).

No se exploraron modelos no lineales.

Futuras líneas

Modelos avanzados: Random Forest, XGBoost.

Rebalanceo de clases: SMOTE, undersampling, class weights.

Métricas ajustadas a costo (cost-sensitive learning).

Análisis por subgrupos para fairness.

Inclusión de variables temporales si estuvieran disponibles.


FIN DEL README
