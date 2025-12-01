# =====================================================
# Trabajo Final — Ciencia de Datos (FCE–UBA)
# Modelo: Regresión Logística (versión simple y funcional)
# Dataset: credit_risk_dataset.csv (colocar junto al script)
# =====================================================

# Instalar y cargar paquetes
if (!require("tidyverse")) install.packages("tidyverse", repos="https://cloud.r-project.org")
if (!require("tidymodels")) install.packages("tidymodels", repos="https://cloud.r-project.org")
library(tidyverse)
library(tidymodels)

set.seed(42)
OUT_DIR <- "./outputs"
dir.create(OUT_DIR, showWarnings = FALSE)

# 1) Cargar datos (debe estar en el mismo directorio que este script)
df <- read_csv("credit_risk_dataset.csv", show_col_types = FALSE)

# 2) Limpieza mínima
df <- df %>%
  filter(person_age >= 18, person_age <= 100) %>%
  mutate(loan_status = factor(loan_status, levels = c(0,1)))

# 3) Partición train/test
spl <- initial_split(df, prop = 0.8, strata = loan_status)
train <- training(spl)
test  <- testing(spl)

# 4) Preprocesamiento + modelo
rec <- recipe(loan_status ~ ., data = train) %>%
  step_dummy(all_nominal_predictors()) %>%
  step_zv(all_predictors()) %>%
  step_normalize(all_numeric_predictors())

model <- logistic_reg(mode = "classification") %>% set_engine("glm")

wf <- workflow() %>%
  add_recipe(rec) %>%
  add_model(model)

fit <- wf %>% fit(data = train)

# 5) Predicciones
pred <- predict(fit, test, type = "prob") %>%
  bind_cols(test %>% select(loan_status))

# 6) Métricas
roc_val <- roc_auc(pred, truth = loan_status, .pred_1)
pr_val  <- pr_auc(pred, truth = loan_status, .pred_1)

metrics <- tibble(roc_auc = roc_val$.estimate, pr_auc = pr_val$.estimate)
write_csv(metrics, file.path(OUT_DIR, "metrics_simple.csv"))

# 7) Curvas ROC y PR
roc_data <- roc_curve(pred, truth = loan_status, .pred_1)
pr_data  <- pr_curve(pred, truth = loan_status, .pred_1)

g_roc <- ggplot(roc_data, aes(x = 1 - specificity, y = sensitivity)) +
  geom_path() + geom_abline(linetype = 2) +
  ggtitle("ROC — Regresión Logística")
ggsave(file.path(OUT_DIR, "roc_simple.png"), g_roc, width = 6, height = 5)

g_pr <- ggplot(pr_data, aes(x = recall, y = precision)) +
  geom_path() + ggtitle("Precision–Recall")
ggsave(file.path(OUT_DIR, "pr_simple.png"), g_pr, width = 6, height = 5)

# 8) Matriz de confusión con umbral 0.5
pred_class <- ifelse(pred$.pred_1 >= 0.5, "1", "0") %>% factor(levels = c("0","1"))
df_cm <- tibble(
  truth = test$loan_status,
  estimate = pred_class
)

cm <- yardstick::conf_mat(df_cm, truth = truth, estimate = estimate)

# Convertimos la matriz a data frame para graficar
cm_df <- as.data.frame(cm$table)
colnames(cm_df) <- c("truth", "prediction", "n")

# Gráfico de matriz de confusión
g_cm <- ggplot(cm_df, aes(x = truth, y = prediction, fill = n)) +
  geom_tile() +
  geom_text(aes(label = n), color = "white", size = 6) +
  ggtitle("Matriz de Confusión (thr = 0.5)") +
  scale_fill_gradient(low = "grey60", high = "black")

ggsave(file.path(OUT_DIR, "cm_simple.png"), g_cm, width = 5, height = 4)


cat("✔️ Listo. Resultados guardados en ./outputs\n")
