@echo off
echo   Daj ma do BIN adresara. Odoberiem CRT z .TPL suborov.
echo �
echo �
tpumover tpp.tpl -crt
tpumover turbo.tpl -crt
echo �
echo �
echo   Este treba nakopirovat CRT.TPU a CRT.TPP do /UNITS.
echo   Na rychlejsich pocitacoch to nezamrzne, ale cas pobezi rychlejsie.
