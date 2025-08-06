@echo off
setlocal

echo ----------------------------------------
echo YouTube Video Downloader - Best Quality
echo ----------------------------------------

REM 1. Check for Python
python --version >nul 2>&1
if errorlevel 1 (
    echo Python not found. Checking for winget...
    winget --version >nul 2>&1
    if errorlevel 1 (
        echo Winget is also not available.
        echo Please install Python manually from https://www.python.org/downloads/
        pause
        exit /b
    ) else (
        echo Installing Python using winget...
        winget install -e --id Python.Python.3
        if errorlevel 1 (
            echo Python installation failed. Please install it manually.
            pause
            exit /b
        )
    )
)

REM 2. Check for yt-dlp
where yt-dlp >nul 2>&1
if errorlevel 1 (
    echo yt-dlp not found. Installing via pip...
    python -m pip install --upgrade yt-dlp
    if errorlevel 1 (
        echo Failed to install yt-dlp. Please check your Python and pip installation.
        pause
        exit /b
    )
)

REM 3. Ask for YouTube URL
set /p video_url=Enter the YouTube video URL: 

REM 4. Set Downloads folder path
set "downloads_folder=%USERPROFILE%\Downloads"

REM 5. Download video (highest quality, avoid Opus audio, output mp4)
echo Downloading video...
yt-dlp -f "bestvideo[ext=mp4]+bestaudio[acodec!=opus]/best[ext=mp4]/best" --merge-output-format mp4 -o "%downloads_folder%\%%(title)s.%%(ext)s" %video_url%

if errorlevel 1 (
    echo.
    echo There was an error during the download.
    pause
    exit /b
)

echo.
echo Download completed successfully.

REM 6. Open Downloads folder
echo Opening Downloads folder...
start "" explorer "%downloads_folder%"

pause
