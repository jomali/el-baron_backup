#! /bin/sh

#===============================================================================
# Script para compilar y ejecutar relatos interactivos programados en Inform 6.
# Herramientas utilizadas:
#	<>	bresc: Blorb resource compiler (sólo en Glulx)
#	<>	inform: Compilador Inform 6
# <>	informPreprocessor: Preprocesador de Inform 
#-------------------------------------------------------------------------------

bresc_location=~/.bin
zcode_interpreter=gargoyle-free
glulx_interpreter=gargoyle-free

inform_path=,/usr/share/inform6/library/,/usr/share/inform6/extensions/,/usr/share/inform6/extensions/gwindows/,/usr/share/inform6/extensions/vorple/

#-------------------------------------------------------------------------------

preprocesa_textos() {
	for i in *.xinf; do
		[ -f "$i" ] || break
		perl ./preprocesaTexto.pl "$i" "${i%.xinf}.inf"
	done
	for i in */*.xinf; do
		[ -f "$i" ] || break
		perl ./preprocesaTexto.pl "$i" "${i%.xinf}.inf"
	done
}

limpia_ficheros_temporales() {
	for i in *.xinf; do
		[ -f "$i" ] || break
		rm "${i%.xinf}.inf"
	done
	for i in */*.xinf; do
		[ -f "$i" ] || break
		rm "${i%.xinf}.inf"
	done
	# if [ -e "$gameFile.ulx" ]; then
	# 	rm $gameFile.ulx
	# fi

	# Elimina los ficheros antiguos:
	if [ -e "/var/www/html/$gameFile/resources/$gameFile.gblorb" ]; then
		rm /var/www/html/$gameFile/resources/$gameFile.gblorb
	fi
}

#-------------------------------------------------------------------------------

if [ "$1" != "" ]; then
	gameFile=$1
else
	echo -n "Introduce el nombre del archivo (sin la extensión): "
	read gameFile
	echo " "
fi
if [ ! -e "$gameFile.inf" ]; then
	echo "El archivo '$gameFile.inf' no existe."
	exit 1
fi

echo "============================================="
echo "COMPILANDO PARA GLULX…"
echo "---------------------------------------------"
preprocesa_textos
inform +include_path=$inform_path -G $gameFile.inf $gameFile.ulx
limpia_ficheros_temporales
# mv $gameFile.ulx ../$gameFile.ulx
# cd ..
# $glulx_interpreter $gameFile.ulx
# $bresc_location/bres $gameFile.res
# inform +include_path=$inform_path -G $gameFile.inf
# $bresc_location/bresc $gameFile.res
# cp $gameFile.gblorb /var/www/html/$gameFile/resources/$gameFile.gblorb

# cp $gameFile.ulx ../dist/server/resources/$gameFile.ulx
cp $gameFile.ulx ./web/resources/$gameFile.ulx
cp -r ./web/* /var/www/html/$gameFile

exit 0
