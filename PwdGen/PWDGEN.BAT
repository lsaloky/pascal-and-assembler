@echo off
: Opakuj
  pkunzip -s hrefkonv.zip <pwd.txt >nul
  rem type pwd.txt
  pwdgen.exe
if not exist hrefkonv.pas goto Opakuj
