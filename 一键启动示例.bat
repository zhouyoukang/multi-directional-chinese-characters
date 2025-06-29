@echo off
chcp 65001 > nul
title 多面字打印示例启动器

echo 多面字打印示例启动器
echo ==========================================
echo.
echo 请选择要打开的示例：
echo.
echo [1] 福禄双全 (双面字)
echo [2] 福禄寿 (三面字)
echo [3] 春夏秋冬 (四面字)
echo [4] 新年快乐恭喜发财 (双面多字)
echo.
echo [0] 退出
echo.

set /p choice=请输入选项编号: 

if "%choice%"=="1" (
    start "" "examples\福禄双全.scad"
) else if "%choice%"=="2" (
    start "" "examples\福禄寿三面字.scad"
) else if "%choice%"=="3" (
    start "" "examples\四季平安.scad"
) else if "%choice%"=="4" (
    start "" "examples\新年快乐恭喜发财.scad"
) else if "%choice%"=="0" (
    exit
) else (
    echo.
    echo 无效的选项，请重新运行并选择正确的编号。
    echo.
    pause
    exit
)

echo.
echo 正在启动OpenSCAD并加载示例文件...
echo 如果OpenSCAD没有自动启动，请确保它已正确安装，并且.scad文件与OpenSCAD关联。
echo.
pause 