#!/usr/bin/env bash
set -euo pipefail

INIT_DIR="/initdb.d"

DB_HOST="${DB_HOST:-tidb}"
DB_PORT="${DB_PORT:-4000}"
DB_USER="${DB_USER:-root}"
DB_NAME="${DB_NAME:-test}"
DB_PASSWORD="${DB_PASSWORD:-}"

if [[ ! -d "$INIT_DIR" ]]; then
	echo "init directory not found: $INIT_DIR" >&2
	exit 1
fi

shopt -s nullglob
# sql_files=("$INIT_DIR"/*.sql)
# INIT_DIR配下を再帰的に検索し、パス名で安定ソート
mapfile -d '' sql_files < <(
    find "$INIT_DIR" -type f -name '*.sql' -print0 | sort -z
)

if (( ${#sql_files[@]} == 0 )); then
	echo "no SQL files found in $INIT_DIR"
	exit 0
fi

for sql_file in "${sql_files[@]}"; do
	echo "executing: $sql_file"
	if [[ -n "$DB_PASSWORD" ]]; then
		mysql \
			--host="$DB_HOST" \
			--port="$DB_PORT" \
			--user="$DB_USER" \
			--password="$DB_PASSWORD" \
			"$DB_NAME" < "$sql_file"
	else
		mysql \
			--host="$DB_HOST" \
			--port="$DB_PORT" \
			--user="$DB_USER" \
			"$DB_NAME" < "$sql_file"
	fi
done

echo "all SQL files executed successfully"
