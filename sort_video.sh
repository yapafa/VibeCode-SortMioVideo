#!/bin/bash

# --- 設定路徑 ---
BASE_DIR="/mnt/data/Normal"
TARGET_ROOT="/mnt/data"

echo "正在檢查來源目錄: $BASE_DIR"

# 檢查主目錄是否存在
if [ ! -d "$BASE_DIR" ]; then
    echo "[錯誤] 找不到目錄 $BASE_DIR，請確認掛載狀態。"
    exit 1
fi

# 處理 F, NMEA, R 三個子目錄
SUB_DIRS=("F" "NMEA" "R")

for SUB in "${SUB_DIRS[@]}"; do
    CURRENT_SUB="$BASE_DIR/$SUB"
    
    if [ -d "$CURRENT_SUB" ]; then
        echo "正在處理 $SUB 資料夾..."
        # 進入子目錄
        cd "$CURRENT_SUB" || continue
        
        # 遍歷檔名開頭為 FILE 的檔案
        for FILE in FILE*; do
            # 檢查檔案是否存在，避免目錄為空時抓到字串 "FILE*"
            [ -e "$FILE" ] || continue
            
            # 擷取第 5 位開始的 6 碼 (yymmdd)
            # FILE260309 -> 260309
            DATE_PART=${FILE:4:6}
            
            # 組合目標資料夾名稱 (20 + yymmdd)
            DEST_FOLDER="$TARGET_ROOT/20$DATE_PART"
            
            # 如果目錄不存在則建立 (-p 確保重複執行不噴錯)
            if [ ! -d "$DEST_FOLDER" ]; then
                echo "建立新目錄: $DEST_FOLDER"
                mkdir -p "$DEST_FOLDER"
            fi
            
            # 搬移檔案
            mv "$FILE" "$DEST_FOLDER/"
        done
    else
        echo "[資訊] 找不到子目錄 $SUB，略過。"
    fi
done

echo ""
echo "所有檔案已分類至 $TARGET_ROOT 底下。"
