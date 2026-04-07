# ローカルTiDB

## 概要

[TiDB](https://github.com/pingcap/tidb) をローカルで実行する例です。

### 初期投入SQL

`/docker/tidb-initializer/initdb.d` 直下およびサブディレクトリ内に配置したSQLをコンテナ起動時に自動実行します。

## 使い方

### 起動

```bash
docker compose up -d
```

### 終了

```bash
docker compose down
```
