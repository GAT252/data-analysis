\c analysis

DROP TABLE IF EXISTS titanic_input;
DROP TABLE IF EXISTS titanic_survival_prediction;

-- タイタニックの元データを保存するテーブル
CREATE TABLE titanic_input (
  passenger_id INT NOT NULL PRIMARY KEY,
  survived INT,
  p_class INT,
  sex VARCHAR(10),
  age NUMERIC,
  sib_sp INT,
  parch INT,
  fare NUMERIC,
  embarked VARCHAR(1)
);

-- 生存予測の結果を保存するテーブル
CREATE TABLE titanic_survival_prediction (
  passenger_id INT NOT NULL PRIMARY KEY,
  survived_prediction INT,
  create_timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);