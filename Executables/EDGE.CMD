@echo off
for /f "delims=" %a in ('where /r C:\ *edge.lnk*') do (del /f /q "%a")