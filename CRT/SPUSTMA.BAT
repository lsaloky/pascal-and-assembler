@echo off
echo   Daj ma do BIN adresara. Odoberiem CRT z .TPL suborov.
echo ÿ
echo ÿ
tpumover tpp.tpl -crt
tpumover turbo.tpl -crt
echo ÿ
echo ÿ
echo   Este treba nakopirovat CRT.TPU a CRT.TPP do /UNITS.
echo   Na rychlejsich pocitacoch to nezamrzne, ale cas pobezi rychlejsie.
