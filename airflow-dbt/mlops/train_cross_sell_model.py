import pandas as pd
from google.cloud import bigquery
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import classification_report, roc_auc_score
import joblib
import os

PROJECT_ID = os.getenv("BQ_PROJECT")
DATASET = os.getenv("BQ_DATASET")

client = bigquery.Client()
query = f"""
SELECT
  estimated_lost_revenue,
  product_retail_price,
  product_department,
  has_purchased, 
  total_product_views
FROM {PROJECT_ID}.{DATASET}.fct_cross_sell_model_training
WHERE has_purchased IS NOT NULL
"""
df = client.query(query).to_dataframe()

df = df.dropna()
X = df[['estimated_lost_revenue', 'product_retail_price', 'product_department']]
y = df['has_purchased']

numeric_features = ['estimated_lost_revenue', 'product_retail_price']
categorical_features = ['product_department']

X_numeric = X[numeric_features]
X_categorical = pd.get_dummies(X[categorical_features], drop_first=True)

X_encoded = pd.concat([X_numeric, X_categorical], axis=1)

X_train, X_test, y_train, y_test = train_test_split(X_encoded, y, stratify=y, random_state=42)
model = LogisticRegression(max_iter=1000)
model.fit(X_train, y_train)

y_pred_proba = model.predict_proba(X_test)[:, 1]
auc = roc_auc_score(y_test, y_pred_proba)
print("AUC:", round(auc, 3))
print(classification_report(y_test, model.predict(X_test)))

joblib.dump(model, "mlops/cross_sell_model.pkl")
with open("mlops/model_metadata.json", "w") as f:
    f.write(f'{{"auc": {auc}, "features": {list(X_encoded.columns)}}}')