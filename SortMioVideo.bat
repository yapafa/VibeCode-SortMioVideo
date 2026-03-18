@echo off
:: 強制切換為 UTF-8 編碼防止亂碼
chcp 65001 >nul
setlocal enabledelayedexpansion

:: --- 設定路徑 ---
set "base_dir=D:\Normal"
set "target_root=D:\"

echo 正在檢查來源目錄: %base_dir%

if not exist "%base_dir%" (
    echo [錯誤] 找不到目錄 %base_dir%，請確認路徑。
    pause
    exit
)

:: 處理 F, NMEA, R 三個子目錄
for %%D in (F NMEA R) do (
    set "sub=%base_dir%\%%D"
    if exist "!sub!" (
        echo 正在處理 %%D 資料夾...
        cd /d "!sub!"
        
        for %%F in (FILE*) do (
            set "name=%%F"
            :: 擷取第 5 位開始的 6 碼 (yymmdd)
            set "yy=!name:~4,2!"
            set "mm=!name:~6,2!"
            set "dd=!name:~8,2!"
            
            :: 組合資料夾名稱: 20 + yymmdd
            set "folder=%target_root%20!yy!!mm!!dd!"
            
            if not exist "!folder!" (
                echo 建立新日期目錄: !folder!
                mkdir "!folder!"
            )
            
            move "%%F" "!folder!\" >nul
        )
    )
)

echo.
echo 所有檔案已依照日期分類至 D:\ 根目錄。
pause
