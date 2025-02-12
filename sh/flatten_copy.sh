#!/bin/bash

# 使用方法: ./flatten_copy.sh <ソースディレクトリ> <ターゲットディレクトリ>

# 引数のチェック
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <source_directory> <target_directory>"
    exit 1
fi

SOURCE_DIR="$1"
TARGET_DIR="$2"

# ソースディレクトリが存在するかチェック
if [ ! -d "$SOURCE_DIR" ]; then
    echo "Error: Source directory does not exist."
    exit 1
fi

# ターゲットディレクトリを作成（存在しない場合）
mkdir -p "$TARGET_DIR"

# findを使って全ファイルを検索し、ターゲットディレクトリへコピー
find "$SOURCE_DIR" -type f | while read -r file; do
    # ファイル名のみを取得（ディレクトリ構造は無視）
    filename=$(basename "$file")

    # ファイル名が重複する場合、"_N" という番号を付加
    if [ -e "$TARGET_DIR/$filename" ]; then
        count=1
        while [ -e "$TARGET_DIR/${filename%.*}_$count.${filename##*.}" ]; do
            ((count++))
        done
        filename="${filename%.*}_$count.${filename##*.}"
    fi

    # ファイルをコピー（パーミッションやタイムスタンプを保持）
    cp --preserve=all "$file" "$TARGET_DIR/$filename"
done

echo "Flatten copy completed."