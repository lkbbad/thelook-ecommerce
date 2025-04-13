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
  product_brand,
  product_category,
  product_department,
  has_purchased, 
  total_product_views
FROM {PROJECT_ID}.{DATASET}.fct_cross_sell_candidates
WHERE has_purchased IS NOT NULL
"""
df = client.query(query).to_dataframe()

df = df.dropna()
X = df[['estimated_lost_revenue', 'product_retail_price', 'product_brand', 'product_category', 'product_department']]
y = df['has_purchased']
X_encoded = pd.get_dummies(X)

# Step 3: Train
X_train, X_test, y_train, y_test = train_test_split(X_encoded, y, stratify=y, random_state=42)
model = LogisticRegression(max_iter=1000)
model.fit(X_train, y_train)

# Step 4: Evaluate
y_pred_proba = model.predict_proba(X_test)[:, 1]
auc = roc_auc_score(y_test, y_pred_proba)
print("AUC:", round(auc, 3))
print(classification_report(y_test, model.predict(X_test)))

# Step 5: Save model + metadata
joblib.dump(model, "mlops/cross_sell_model.pkl")
with open("mlops/model_metadata.json", "w") as f:
    f.write(f'{{"auc": {auc}, "features": {list(X_encoded.columns)}}}')