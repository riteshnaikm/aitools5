@echo off
echo ===================================
echo Installing Recruiter Handbook Feature Dependencies
echo ===================================
echo.

REM Activate virtual environment
echo Activating virtual environment...
call .\venv\Scripts\activate

REM Install new dependencies
echo.
echo Installing reportlab and markdown...
pip install reportlab markdown

echo.
echo ===================================
echo Installation Complete!
echo ===================================
echo.
echo Next steps:
echo 1. Run the application: python app.py
echo 2. Navigate to MatchMaker
echo 3. Click on "Recruiter Handbook" tab
echo 4. Enter a job description and generate your handbook
echo.
pause

