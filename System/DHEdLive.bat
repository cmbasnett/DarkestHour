echo Resetting window positions...
python ..\tools\scripts\clear-windowpositions.py ..\DarkestHour\System\DarkestHourUser.ini

echo Launching DHEd...
start ROEdLAA.exe %* -mod=DarkestHour -nogamma
