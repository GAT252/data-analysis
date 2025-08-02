# Titanic号乗客の生存予測分析

このプロジェクトは、Kaggleの「Titanic」データセットを使用し、乗客の生存を予測する機械学習の分析環境です。

DockerとDocker Composeを利用して、分析環境（Jupyter Notebook）とデータベース（PostgreSQL）を構築します。

## 概要

本プロジェクトは、以下のコンテナ化されたサービスで構成されています。

* **`jupyter`**: データ分析、前処理、モデルの学習と予測を行うJupyter Notebook環境です。
* **`db`**: 分析対象のデータとモデルによる予測結果を永続化するためのPostgreSQLデータベースです。

### 分析フロー

分析の主な流れは `jupiter.ipynb` に記述されており、以下のステップで実行されます。

1.  **データ投入**: `input_data/Titanic_train.csv` のデータをDBの `titanic_input` テーブルに保存します。
2.  **データ取得**:　DBの `titanic_input` テーブルから取得
2.  **データ前処理**: 欠損値を補完（年齢は中央値、乗船港は最頻値）し、カテゴリ変数を数値に変換します。
3.  **モデル学習**: ロジスティック回帰モデルを使用して、生存予測モデルを学習させます。
4.  **結果の保存**: 予測結果を `titanic_survival_prediction` テーブルに保存します。
5.  **評価**: 混同行列（Confusion Matrix）を用いてモデルの精度を可視化します。

## 必要なもの

* Docker
* Docker Compose

## セットアップと実行方法

1.  **リポジトリのクローン後、ディレクトリに移動します。**

2.  **環境変数の準備**
    `.env` ファイルにデータベースのパスワードなどの設定が記述されています。


3.  **Dockerコンテナのビルドと起動**
    以下のコマンドを実行し、コンテナをバックグラウンドで起動します。
    ```bash
    docker-compose up --build -d
    ```

4.  **Jupyter Notebookへのアクセス**
    Webブラウザで `http://localhost:8888` を開きます。
    パスワードの入力を求められたら、`.env`ファイルで`NOTEBOOK_PASSWORD`に設定した値を入力してください。

5.  **分析の実行**
    Jupyter Notebookで `jupiter.ipynb` を開き、セルを最初から順番に実行してください。

## フォルダとファイルの説明
* docker-compose.yml      # Docker Compose設定ファイル
* Dockerfile-db           # DBコンテナのDockerfile
* Dockerfile-jupyter      # JupyterコンテナのDockerfile
* .env                    # 環境変数ファイル
*  jupiter.ipynb           # データ分析用Jupyter Notebook
* input_data/  #分析するデータを格納するファイル
* Titanic_train.csv   # 分析用データ
* scripts/
* initdb/ #DBを格納するフォルダ
* 01_init_database.sql  # DB作成用SQL
* 02_init_table.sql     # テーブル作成用SQL
## データベーススキーマ

`02_init_table.sql` スクリプトによって、以下のテーブルが作成されます。

### `titanic_input`
タイタニック号の乗客データを格納します。
| カラム名 | データ型 | 説明 |
| :--- | :--- | :--- |
| `passenger_id` | `INT` | 乗客ID（主キー） |
| `survived` | `INT` | 生存フラグ (0 = 死亡, 1 = 生存) |
| `p_class` | `INT` | チケットクラス (1, 2, 3) |
| `sex` | `VARCHAR(10)` | 性別 |
| `age` | `NUMERIC` | 年齢 |
| `sib_sp` | `INT` | 同乗している兄弟/配偶者の数 |
| `parch` | `INT` | 同乗している親/子供の数 |
| `fare` | `NUMERIC` | 料金 |
| `embarked` | `VARCHAR(1)` | 乗船港 (S, C, Q) |

### `titanic_survival_prediction`
機械学習モデルによる生存予測結果を格納します。
| カラム名 | データ型 | 説明 |
| :--- | :--- | :--- |
| `passenger_id` | `INT` | 乗客ID（主キー） |
| `survived_prediction` | `INT` | 予測された生存フラグ (0 or 1) |
| `create_timestamp` | `TIMESTAMP` | 作成日時 (デフォルト: 現在時刻) |