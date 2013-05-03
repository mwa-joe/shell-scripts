# TYPE: Bash Shell script.
# PURPOSE: This bash shell script allows you to easily restore Ubuntu packages into a clean install of Ubuntu 12.04.02
# REQUIRES: Ubuntu 12.04.02 LTS 64-bit (to support UEFI+SecureBoot), wget, apt-get, unp, wine
# Author: Mark Rijckenberg
# Copyright (c) 2012-08-12
# REVISION DATE: 20130430
# Updated by: markrijckenberg at gmail dot com
PATH=/usr/sbin:/usr/bin:/sbin:/bin
#Prerequisites: USB drives SAMSUNG and IOMEGA need to be mounted correctly in order for this script to work correctly!

MACHINE_TYPE=`uname -m`

# define filename variables
YEDFILENAME=yEd-3.10.2_32-bit_setup.sh
DUFILENAME=DUv3_9pview.tgz
NIGHTSHADEFILENAME=nightshade-11.12.1.tar.gz
SCISOFTFILENAME=scisoft-7.7.0.tar.gz
SKYVIEWERFILENAME=skyviewer-1.0.0
C2AFILENAME=c2a_full_2_0_49.zip

#define source directories
HOME=/home/ulysses/
SOURCE2=/etc/
SOURCE3=/media/windows/rsync/

#define target directories where backup will be stored
TARGET1=/media/SAMSUNG/$HOME/
TARGET2=/media/IOMEGA/$HOME/
TARGET3=/media/SAMSUNG/etc/
TARGET4=/media/IOMEGA/etc/
TARGET5=/media/SAMSUNG/media/windowsdata/rsync/
TARGET6=/media/IOMEGA/media/windowsdata/rsync/
ZIP=zip/
TAR=tar/
PDF=pdf/
DEB=deb/
KMZ=kmz/
mkdir $ZIP
mkdir $TAR
mkdir $PDF
mkdir $DEB
mkdir $KMZ
mkdir triatlas

#sudo /usr/bin/rsync -quvra   --exclude='.*' --exclude "$HOME.gvfs"  --max-size='100M' $TARGET1 $HOME 
#sudo /usr/bin/rsync -quvra   --exclude='.*' --exclude "$HOME.gvfs"  --max-size='100M' $TARGET2 $HOME
#sudo /usr/bin/rsync -quvra   --exclude='.*' --exclude "$HOME.gvfs"  --max-size='100M' $TARGET3 $SOURCE2
#sudo /usr/bin/rsync -quvra   --exclude='.*' --exclude "$HOME.gvfs"  --max-size='100M' $TARGET4 $SOURCE2 
# not required during restore: sudo /usr/bin/rsync -quvra   --exclude='.*' --exclude "$HOME.gvfs"  --max-size='100M' $TARGET5 $SOURCE3
# not required during restore: sudo /usr/bin/rsync -quvra   --exclude='.*' --exclude "$HOME.gvfs"  --max-size='100M' $TARGET6 $SOURCE3
#sudo apt-get install dselect rsync -y
#sudo apt-key add $TARGET1/Repo.keys
sudo apt-key add Repo.keys
#sudo dpkg --set-selections < $TARGET1/Package.list
#sudo dpkg --set-selections < Package.list
#sudo dselect

#sudo cp /etc/apt/sources.list  /etc/apt/sources.list.backup
#sudo cp sources.list.12.04 /etc/apt/sources.list

###############################################################################################
#     BASE PACKAGES SECTION                                                                   #
###############################################################################################

# refresh list of available packages in Ubuntu repositories
sudo apt-get update
# install list of packages defined in packages files
# allpackages = basepackages + astropackages
# sudo apt-get --yes --force-yes install `cat  allpackages` -o APT::Install-Suggests="false"
sudo apt-get  install  `cat  basepackages` -o APT::Install-Suggests="false"

# Cuttlefish is an ingenious little tool. It allows you to define a set of actions that occur when a certain stimulus is activated.
sudo add-apt-repository --yes ppa:noneed4anick/cuttlefish
sudo apt-get update
sudo apt-get --yes --force-yes install cuttlefish 
# Install openshot which is a simple and easy to use video editor, like a good substitute for the windows movie maker
sudo apt-add-repository --yes ppa:openshot.developers/ppa
sudo apt-get update
sudo apt-get --yes --force-yes install openshot
# Install Ubuntu Tweak to easily uninstall old kernel versions
sudo add-apt-repository --yes ppa:tualatrix/ppa
sudo apt-get update
sudo apt-get --yes --force-yes install ubuntu-tweak
# Install razorqt desktop environment
sudo add-apt-repository --yes ppa:razor-qt/ppa
sudo apt-get update
sudo apt-get --yes --force-yes install razorqt razorqt-desktop
# Install TLP - advanced power management command line tool for Linux
sudo add-apt-repository --yes ppa:linrunner/tlp
sudo apt-get update
sudo apt-get --yes --force-yes install tlp tlp-rdw
# install skype
sudo add-apt-repository --yes ppa:upubuntu-com/chat
sudo apt-get update
sudo apt-get --yes --force-yes install skype
# install Y PPA Manager
sudo add-apt-repository --yes ppa:webupd8team/y-ppa-manager
sudo apt-get update
sudo apt-get --yes --force-yes install  y-ppa-manager

# libdvdcss2, to play encrypted DVDs
sudo apt-get --yes --force-yes install libdvdcss2
sudo /usr/share/doc/libdvdread4/./install-css.sh



###############################################################################################
#     WEBBROWSER SOFTWARE SECTION                                                             #
###############################################################################################



if [ ${MACHINE_TYPE} == 'x86_64' ]; then
  # 64-bit stuff here
# install Google Chrome browser which has better support for Flash websites (Youtube, ...)
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome*.deb
# fix the Google Chrome dependencies issue
sudo apt-get --yes --force-yes -f install
# install Google Earth
wget http://dl.google.com/dl/earth/client/current/google-earth-stable_current_amd64.deb
sudo dpkg -i google-earth-stable_current_amd64.deb
sudo apt-get --yes --force-yes -f install
# install Teamviewer server + client
wget http://download.teamviewer.com/download/teamviewer_linux_x64.deb
sudo dpkg -i teamviewer_linux_x64.deb
else
  # 32-bit stuff here
# install Google Chrome browser which has better support for Flash websites (Youtube, ...)
wget https://dl.google.com/linux/direct/google-chrome-stable_current_i386.deb
sudo dpkg -i google-chrome*.deb
# fix the Google Chrome dependencies issue
sudo apt-get --yes --force-yes -f install
# install Google Earth
wget http://dl.google.com/dl/earth/client/current/google-earth-stable_current_i386.deb
sudo dpkg -i google-earth-stable_current_i386.deb
sudo apt-get --yes --force-yes -f install
# install Teamviewer server + client
wget http://download.teamviewer.com/download/teamviewer_linux.deb
sudo dpkg -i teamviewer_linux.deb
fi

# install Opera browser
wget -O- http://deb.opera.com/archive.key | sudo apt-key add -
sudo sh -c 'echo "deb http://deb.opera.com/opera/ stable non-free" >> /etc/apt/sources.list'
sudo apt-get update
sudo apt-get --yes --force-yes install opera

# install Multimedia codecs
sudo -E wget --output-document=/etc/apt/sources.list.d/medibuntu.list http://www.medibuntu.org/sources.list.d/$(lsb_release -cs).list && sudo apt-get --quiet update && sudo apt-get --yes --quiet --allow-unauthenticated install medibuntu-keyring && sudo apt-get --quiet update
sudo apt-get --yes --force-yes install non-free-codecs libdvdcss

# clean up current directory
echo "Performing file cleanup"
mv *.zip $ZIP
mv *.pdf $PDF
mv *.deb $DEB
mv *.km? $KMZ
mv *gz $TAR
rm *.exe

# uninstall Java due to all the critical security issues in 2013
sudo apt-get --yes --force-yes remove java-common
sudo apt-get --yes --force-yes remove default-jre
sudo apt-get --yes --force-yes remove gcj-?.?-jre-headless
sudo apt-get --yes --force-yes remove openjdk-?-jre-headless
sudo apt-get remove mysql-server-core-?.?
sudo apt-get remove unity-lens-shopping
sudo apt-get autoclean
sudo apt-get clean
sudo rm /etc/apt/sources.list.d/*
grep -v opera /etc/apt/sources.list  > /tmp/sources.list
sudo cp /tmp/sources.list  /etc/apt/sources.list

# Install yEd editor 
# (powerful desktop application that can be used to quickly and effectively generate high-quality diagrams)
# Save diagrams in .pdf format so they can be included as graphics in a new latex document in texmaker
wget http://www.yworks.com/products/yed/demo/$YEDFILENAME
sh $YEDFILENAME

###############################################################################################
#     ASTRONOMY SOFTWARE SECTION                                                              #
###############################################################################################

sudo apt-get install  `cat  astropackages` -o APT::Install-Suggests="false"

# install casapy-upstream-binary  - Common Astronomy Software Applications package provided by NRAO, python bindings
sudo add-apt-repository --yes ppa:aims/casapy
sudo apt-get update
sudo apt-get --yes --force-yes install casapy-upstream-binary

sudo add-apt-repository --yes ppa:olebole/astro-precise
sudo apt-get update
sudo apt-get --yes --force-yes install casacore 
sudo apt-get --yes --force-yes install cpl
sudo apt-get --yes --force-yes install esorex
# download and decompress SAOImage DS9 software
sudo apt-get --yes --force-yes install saods9 
sudo apt-get --yes --force-yes install sextractor 


# download CSC KML Interface to Sky in Google Earth
echo "Downloading CSC KML Interface to Sky in Google Earth"
wget http://cxc.harvard.edu/csc/googlecat/cxo_1.2.kml
echo "kml file can be opened using Google Earth"

# download The Crab Nebula Explodes
echo "Downloading The Crab Nebula Explodes"
wget http://services.google.com/earth/kmz/crab_nebula_n.kmz
echo "kmz file can be opened using Google Earth"

# download Multicolor Galaxies
echo "Downloading Multicolor Galaxies"
wget http://services.google.com/earth/kmz/aegis_n.kmz
echo "kmz file can be opened using Google Earth"

# download Images of Nearby Galaxies from the National Optical Astronomical Observatory
echo "Downloading Images of Nearby Galaxies from the National Optical Astronomical Observatory"
wget http://services.google.com/earth/kmz/noao_showcase_n.kmz
echo "kmz file can be opened using Google Earth"

# download The Sloan Digital Sky Survey catalog
echo "Downloading The Sloan Digital Sky Survey catalog"
wget http://services.google.com/earth/kmz/sdss_query_n.kmz
echo "kmz file can be opened using Google Earth"

# download Exoplanets
echo "Downloading Exoplanets"
wget http://services.google.com/earth/kmz/exo_planets_n.kmz
echo "kmz file can be opened using Google Earth"

# download and decompress Digital Universe and Partiview Resources
echo "Downloading and decompressing Digital Universe and Partiview Resources"
wget http://haydenplanetarium.org/downloads/universe/linux/$DUFILENAME
unp $DUFILENAME

# download and decompress Nightshade 
# Nightshade is free, open source astronomy simulation and visualization software for teaching and exploring astronomy
echo "Downloading and decompressing Nightshade"
wget http://www.nightshadesoftware.org/attachments/download/6/$NIGHTSHADEFILENAME
unp $NIGHTSHADEFILENAME

# download and decompress scisoft utilities
echo "Downloading and decompressing scisoft utilities"
wget ftp://ftp.eso.org/scisoft/scisoft7.7.0/linux/fedora11/tar/$SCISOFTFILENAME
unp $SCISOFTFILENAME

# download and compile skyviewer from http://lambda.gsfc.nasa.gov/toolbox/tb_skyviewer_ov.cfm
echo "Downloading and compiling skyviewer from nasa website"
wget http://lambda.gsfc.nasa.gov/toolbox/skyviewer/$SKYVIEWERFILENAME.tar.gz
unp $SKYVIEWERFILENAME.tar.gz
cd $SKYVIEWERFILENAME
sudo qmake
sudo make
sudo make install
cd ..

if [ ${MACHINE_TYPE} == 'x86_64' ]; then
  # 64-bit stuff here
# download and decompress IRAF - Image Reduction and Analysis Facility, a general purpose
# software system for the reduction and analysis of astronomical data
echo "Downloading and decompressing IRAF - Image Reduction and Analysis Facility"
wget ftp://iraf.noao.edu/iraf/v216/PCIX/iraf.lnux.x86_64.tar.gz
unp iraf.lnux.x86_64.tar.gz
echo "Downloading and installing skychart"
wget http://sourceforge.net/projects/skychart/files/1-%20cdc-skychart/version_3.8/skychart_3.8-2450_amd64.deb
sudo dpkg -i skychart_3.8-2450_amd64.deb
sudo apt-get -f install
sudo apt-get --purge remove texmaker
wget http://download.opensuse.org/repositories/home:/jsundermeyer/xUbuntu_12.04/amd64/texstudio_2.5.2_amd64.deb
sudo dpkg -i texstudio_2.5.2_amd64.deb
sudo apt-get -f install

else
  # 32-bit stuff here
# download and decompress IRAF - Image Reduction and Analysis Facility, a general purpose
# software system for the reduction and analysis of astronomical data
echo "Downloading and decompressing IRAF - Image Reduction and Analysis Facility"
wget ftp://iraf.noao.edu/iraf/v216/PCIX/iraf.lnux.x86.tar.gz
unp iraf.lnux.x86.tar.gz
echo "Downloading and installing skychart"
wget http://sourceforge.net/projects/skychart/files/1-%20cdc-skychart/version_3.8/skychart_3.8-2450_i386.deb
sudo dpkg -i skychart_3.8-2450_i386.deb
sudo apt-get -f install
sudo apt-get --purge remove texmaker
wget http://download.opensuse.org/repositories/home:/jsundermeyer/xUbuntu_12.04/i386/texstudio_2.5.2_i386.deb
sudo dpkg -i texstudio_2.5.2_i386.deb
sudo apt-get -f install

fi

wget http://sourceforge.net/projects/skychart/files/2-catalogs/Stars/skychart-data-stars_3.8-2293_all.deb
sudo dpkg -i skychart-data-stars_3.8-2293_all.deb
sudo apt-get -f install

wget http://sourceforge.net/projects/skychart/files/2-catalogs/Nebulea/skychart-data-dso_3.8-2293_all.deb
sudo dpkg -i skychart-data-dso_3.8-2293_all.deb
sudo apt-get -f install

wget http://sourceforge.net/projects/skychart/files/2-catalogs/Nebulea/skychart-data-pictures_3.1-1466_all.deb
sudo dpkg -i skychart-data-pictures_3.1-1466_all.deb
sudo apt-get -f install

# download C2A Planetarium Software for Windows platform
echo "Downloading C2A Planetarium Software for Windows platform - use wine application"
wget http://www.astrosurf.com/c2a/english/download/$C2AFILENAME
unp $C2AFILENAME
wine setup.exe

###############################################################################################
#     DOWNLOAD TRIATLAS PDF FILES BEFORE ANY OTHER PDF FILES                                  #
###############################################################################################
#download Triatlas charts in PDF format from http://www.uv.es/jrtorres/triatlas.html
echo "Downloading Triatlas charts (from jrtorres) in A4 format for Europe"
wget http://www.uv.es/jrtorres/section_a/Triatlas_2ed_A.pdf
wget http://www.uv.es/jrtorres/TriAtlas_A_Index.pdf
wget http://www.uv.es/jrtorres/section_b/Triatlas_2ed_B1.pdf
wget http://www.uv.es/jrtorres/section_b/Triatlas_2ed_B2.pdf
wget http://www.uv.es/jrtorres/section_b/Triatlas_2ed_B3.pdf
wget http://www.uv.es/jrtorres/TriAtlas_B_Index.pdf
wget http://www.uv.es/jrtorres/section_c/C01_001-030.pdf
wget http://www.uv.es/jrtorres/section_c/C02_031-060.pdf
wget http://www.uv.es/jrtorres/section_c/C03_061-090.pdf
wget http://www.uv.es/jrtorres/section_c/C04_091-120.pdf
wget http://www.uv.es/jrtorres/section_c/C05_121-150.pdf
wget http://www.uv.es/jrtorres/section_c/C06_151-180.pdf
wget http://www.uv.es/jrtorres/section_c/C07_181-210.pdf
wget http://www.uv.es/jrtorres/section_c/C08_211-240.pdf
wget http://www.uv.es/jrtorres/section_c/C09_241-270.pdf
wget http://www.uv.es/jrtorres/section_c/C10_271-300.pdf
wget http://www.uv.es/jrtorres/section_c/C11_301-330.pdf
wget http://www.uv.es/jrtorres/section_c/C12_331-360.pdf
wget http://www.uv.es/jrtorres/section_c/C13_361-390.pdf
wget http://www.uv.es/jrtorres/section_c/C14_391-420.pdf
wget http://www.uv.es/jrtorres/section_c/C15_421-450.pdf
wget http://www.uv.es/jrtorres/section_c/C16_451-480.pdf
wget http://www.uv.es/jrtorres/section_c/C17_481-510.pdf
wget http://www.uv.es/jrtorres/section_c/C18_511-540.pdf
wget http://www.uv.es/jrtorres/section_c/C19_541-571.pdf
wget http://www.uv.es/jrtorres/TriAtlas_C_Index.pdf
mv *.pdf triatlas

# download SAO/NASA ADS Help Pages
echo "Downloading SAO/NASA ADS Help Pages"
wget http://adsabs.harvard.edu/abs_doc/help_pages/adshelp.pdf
mv adshelp.pdf sao_nasa_ads_help_pages_July_9_2012.pdf

# download American Astronomical Society manuscript preparation guidelines 
echo "Downloading American Astronomical Society manuscript preparation guidelines"
wget http://ctan.mackichan.com/macros/latex/contrib/aastex/docs/aasguide.pdf
mv aasguide.pdf American_Astronomical_Society_guidelines.pdf

# download Users Guide to Writing a Thesis in Physics Astronomy Institute of the University of Bonn
echo "Downloading Users Guide to Writing a Thesis in Physics Astronomy Institute of the University of Bonn"
wget http://www-biblio.physik.uni-bonn.de/info/downloads/thesis_guide.pdf
mv thesis_guide.pdf bonn_thesis_writing_guide_latex_march_31_2013.pdf

# download The Not So Short Introduction to LaTeX2e by Tobias Oetiker et alii
echo "Downloading The Not So Short Introduction to LaTeX2e by Tobias Oetiker et alii"
wget http://tobi.oetiker.ch/lshort/lshort.pdf
mv lshort.pdf latex2-not-so-short-introduction.pdf

wget http://kelder.zeus.ugent.be/~gaspard/latex/latex-cursus.pdf

# clean up current directory
echo "Performing file cleanup"
mv *.zip $ZIP
mv *.pdf $PDF
mv *.deb $DEB
mv *.km? $KMZ
mv *gz $TAR
rm *.exe

# uninstall Java due to all the critical security issues in 2013
sudo apt-get --yes --force-yes remove java-common
sudo apt-get --yes --force-yes remove default-jre
sudo apt-get --yes --force-yes remove gcj-?.?-jre-headless
sudo apt-get --yes --force-yes remove openjdk-?-jre-headless
sudo apt-get remove mysql-server-core-?.?
sudo apt-get autoclean
sudo apt-get clean
sudo rm /etc/apt/sources.list.d/*
grep -v opera /etc/apt/sources.list  > /tmp/sources.list
sudo cp /tmp/sources.list  /etc/apt/sources.list

###############################################################################################
#     SHOW INTERESTING WEBBROWSER BOOKMARKS                                                   #
###############################################################################################

echo "Please add these Astronomy bookmarks into all 5 webbrowsers (chromium, firefox, konqueror, chrome, opera)"
echo "http://www.gmail.com"
echo "http://arxiv.org/list/astro-ph/new"
# in arxiv.org: click on 'other' next to 'pdf' and choose to 'download source' using the axel command in a Terminal
# to examine the original .tex file which uses the aastex class
# decompress the extensionless source file using  the unp command
echo "http://adsabs.harvard.edu/abstract_service.html"
echo "http://ned.ipac.caltech.edu/"
echo "http://en.wikipedia.org/wiki/List_of_nearest_stars"
echo "http://www.wolframalpha.com/input/?i=astronomy&a=*C.astronomy-_*ExamplePage-"
echo "http://www.worldwidetelescope.org/webclient/"
echo "http://www.skyviewcafe.com/skyview.php"
echo "http://en.wikipedia.org/wiki/Star_catalogue#Successors_to_USNO-A.2C_USNO-B.2C_NOMAD.2C_UCAC_and_Others"
echo "http://www.aanda.org/"
echo "http://www.usno.navy.mil/USNO/astrometry/information/catalog-info/catalog-information-center-1#usnob1"
echo "http://www.usno.navy.mil/USNO/astrometry/optical-IR-prod/icas/fchpix"
echo "http://be.kompass.com/live/fr/w2866018/edition-livres/edition-livres-astronomie-geodesie-meteorologie-1.html#.UV1dCqA9RZc"
# following URL (Open Source Physics project containing Java simulations for astronomy) added on April 23, 2013:
echo "http://www.opensourcephysics.org/search/categories.cfm?t=SimSearch"
# following URL added on April 23, 2013:
echo "http://astro.unl.edu/naap/"
echo "http://en.wikibooks.org/wiki/LaTeX"
# following URL added on April 23, 2013:
echo "http://latex.ugent.be/cursus.php"
# following URL added on April 30, 2013:
echo "http://www.texdoc.net/"
echo "http://www.ottobib.com/"
echo "http://scholar.google.be"
# following URL added on April 23, 2013:
echo "http://www.google.com/mars/"
# following URL added on April 23, 2013:
echo "http://www.google.com/moon/"
echo "http://www.youtube.com/"
echo "http://www.krantenkoppen.be/"
echo "http://www.economist.com/"
echo "http://www.wired.com/"
echo "http://heasarc.gsfc.nasa.gov/docs/heasarc/astro-update/"
echo "http://mipav.cit.nih.gov/download.php"
echo "http://www.amazon.com"
echo "https://help.ubuntu.com/community/ExternalGuides"
echo "Check with book publisher in which format the digitized book needs to be sent to the publisher (preferably latex instead of Word, ODF, hybrid PDF-ODF format, etc...)"
echo "Use texmaker Ubuntu package with AASTeX special macros (aastex is part of texlive-publishers package) to write new Astronomy book"
echo "get bibliography citations at http://www.ottobib.com  using ISBN number and convert info to bibtex plain text .bib file for use in Latex document"
echo "get bibliography citations at http://scholar.google.be using full title and author and choose import to bibtex"
echo "For example use - filetype:pdf author:'h karttunen'  -  as search term in http://scholar.google.be"
echo "Get more information about latex package by using command   texdoc <packagename> , for example: texdoc graphicx"
