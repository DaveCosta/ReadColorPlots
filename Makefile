#################################################################################

# David EMMANUEL-COSTA  Date: 151012

PROJECT=RCPlots
AUTHOR=David Emmanuel-Costa
CREATION_DATE=2013/05/01
VERSION=V0.5

SRCDIR=src/main/java
RESOURCESDIR=src/main/resources
LIB=.

JARNAME=RCPlots

MAIN = edu.mephys.tools.RCPlots

PACKAGE = edu/mephys/tools

ICON = icons/RCPlots.png

SOURCES  = \
	RCPlotsLib/RCImage.java \
	RCPlotsLib/RCTools.java \
    RCPlotsLib/RCPlotsController.java \
    RCPlots.java 

#################################################################################

BINDIR=build

BUILD=$(PROJECT)-$(shell date +%y%m%d%H%M)

RESOURCESFILES= $(wildcard $(RESOURCESDIR)/**/*)

JH=`/usr/libexec/java_home`

JC = /usr/bin/javac
JFLAGS = -g:none -d $(BINDIR)/production -cp $(SRCDIR) -encoding UTF-8  -server

CLASSES=$(addprefix $(BINDIR)/production/$(PACKAGE)/, $(SOURCES:.java=.class))

default: $(BINDIR) classes

classes: $(BINDIR) $(CLASSES) 

.SUFFIXES: .java .class

$(BINDIR):
	@mkdir -p $(BINDIR)/production
	@cp -r $(RESOURCESDIR)/* $(BINDIR)/production

$(BINDIR)/production/$(PACKAGE)/%.class : $(SRCDIR)/$(PACKAGE)/%.java
	@echo Compiling $<
	@$(JC) -cp $(LIB) $(JFLAGS) $<

$(BINDIR)/$(JARNAME).jar : $(BINDIR) classes 
	@echo Packing: $(BINDIR)/$(JARNAME).jar
	@cd $(BINDIR)/production; jar cmf  META-INF/MANIFEST.MF ../$(JARNAME).jar *

$(BINDIR)/$(JARNAME) :  $(BINDIR)/$(JARNAME).jar
	@echo Creating script : $(BINDIR)/$(JARNAME)
	@echo "#!/bin/sh" > $(BINDIR)/$(JARNAME)
	@echo 'exec java  -jar $$0' >> $(BINDIR)/$(JARNAME)
	@echo "exit 0" >> $(BINDIR)/$(JARNAME)
	@echo "" >> $(BINDIR)/$(JARNAME)
	@cat  $(BINDIR)/$(JARNAME).jar >> $(BINDIR)/$(JARNAME)
	@chmod u+x $(BINDIR)/$(JARNAME)
	
MANIFEST.MF :  $(BINDIR)
	@echo "Manifest-Version: 1.0" > MANIFEST.MF 
	@echo "Created-By: David Emmanuel-Costa" >> MANIFEST.MF 
	@echo "Main-Class: $(MAIN)" >> MANIFEST.MF
	@echo "Classpath: " >> MANIFEST.MF 
	@echo "" >> MANIFEST.MF 
	
$(BINDIR)/$(JARNAME).icns : $(BINDIR) $(BINDIR)/production/$(ICON)
	@echo Creating icon : $@
	@mkdir $(BINDIR)/$(JARNAME).iconset
	@sips -z 16 16     $(BINDIR)/production/$(ICON)  --out $(BINDIR)/$(JARNAME).iconset/icon_16x16.png > /dev/null
	@sips -z 32 32     $(BINDIR)/production/$(ICON)  --out $(BINDIR)/$(JARNAME).iconset/icon_16x16@2x.png  > /dev/null
	@sips -z 32 32     $(BINDIR)/production/$(ICON)  --out $(BINDIR)/$(JARNAME).iconset/icon_32x32.png  > /dev/null
	@sips -z 64 64     $(BINDIR)/production/$(ICON)  --out $(BINDIR)/$(JARNAME).iconset/icon_32x32@2x.png  > /dev/null
	@sips -z 128 128   $(BINDIR)/production/$(ICON)  --out $(BINDIR)/$(JARNAME).iconset/icon_128x128.png  > /dev/null
	@sips -z 256 256   $(BINDIR)/production/$(ICON)  --out $(BINDIR)/$(JARNAME).iconset/icon_128x128@2x.png  > /dev/null
	@sips -z 256 256   $(BINDIR)/production/$(ICON)  --out $(BINDIR)/$(JARNAME).iconset/icon_256x256.png  > /dev/null
	@sips -z 512 512   $(BINDIR)/production/$(ICON)  --out $(BINDIR)/$(JARNAME).iconset/icon_256x256@2x.png  > /dev/null
	@sips -z 512 512   $(BINDIR)/production/$(ICON)  --out $(BINDIR)/$(JARNAME).iconset/icon_512x512.png > /dev/null
	@sips -z 1024 1024   $(BINDIR)/production/$(ICON)  --out $(BINDIR)/$(JARNAME).iconset/icon_512x512@2x.png > /dev/null
	@iconutil -c icns $(BINDIR)/$(JARNAME).iconset
	@rm -r  $(BINDIR)/$(JARNAME).iconset	
	
$(BINDIR)/launcher.sh : $(BINDIR)
	@echo Creating file : $@
	@echo "#!/bin/sh" > $@
	@echo "JAVA_MAJOR=1" >> $@
	@echo "JAVA_MINOR=8" >> $@
	@echo "APP_JAR=\"$(JARNAME).jar\"" >> $@
	@echo "APP_NAME=\"$(JARNAME)\"" >> $@
	@echo "VM_ARGS=\"\"" >> $@
	@echo "" >> $@
	@echo 'DIR=$$(cd "$$(dirname "$$0")"; pwd)' >> $@
	@echo "" >> $@
	@echo "java -Dapple.laf.useScreenMenuBar=true \\"  >> $@
	@echo "       -Dcom.apple.macos.use-file-dialog-packages=true \\"  >> $@
	@echo '       -Xdock:name="$(JARNAME)." \\' >> $@
	@echo '       -Xdock:icon="$$DIR/../Resources/$(JARNAME).icns" \\' >> $@
	@echo "       -cp . \\" >> $@
	@echo ' 	   -jar $$DIR/$$APP_JAR'>> $@
	@chmod u+x $@
	
$(BINDIR)/$(JARNAME).app : $(BINDIR)/$(JARNAME).jar $(BINDIR)/$(JARNAME).icns $(BINDIR)/launcher.sh $(BINDIR)/info.plist
	@echo Creating application $@
	@rm -rf  $(BINDIR)/$(JARNAME).app
	@mkdir -p $(BINDIR)/$(JARNAME).app/Contents/MacOS
	@mkdir -p $(BINDIR)/$(JARNAME).app/Contents/Resources
	@cp $(BINDIR)/info.plist $(BINDIR)/$(JARNAME).app/Contents
	@cp $(BINDIR)/$(JARNAME).icns $(BINDIR)/$(JARNAME).app/Contents/Resources
	@cp $(BINDIR)/launcher.sh $(BINDIR)/$(JARNAME).app/Contents/MacOS
	@cp $(BINDIR)/$(JARNAME).jar $(BINDIR)/$(JARNAME).app/Contents/MacOS
			
$(BINDIR)/info.plist :  $(BINDIR)
	@echo Creating file $@
	@echo "<?xml version=\"1.0\" ?>" > $(BINDIR)/info.plist
	@echo "<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">" >> $(BINDIR)/info.plist
	@echo "<plist version="1.0">" >> $(BINDIR)/info.plist
	@echo " <dict>" >> $(BINDIR)/info.plist
	@echo " <key>LSMinimumSystemVersion</key>" >> $(BINDIR)/info.plist
	@echo "  <string>10.7.4</string>" >> $(BINDIR)/info.plist
	@echo "  <key>CFBundleDevelopmentRegion</key>" >> $(BINDIR)/info.plist
	@echo "  <string>English</string>" >> $(BINDIR)/info.plist
	@echo "  <key>CFBundleAllowMixedLocalizations</key>" >> $(BINDIR)/info.plist
	@echo "  <true/>" >> $(BINDIR)/info.plist
	@echo "  <key>CFBundleExecutable</key>" >> $(BINDIR)/info.plist
	@echo "  <string>launcher.sh</string>" >> $(BINDIR)/info.plist
	@echo "  <key>CFBundleIconFile</key>" >> $(BINDIR)/info.plist
	@echo "  <string>$(JARNAME).icns</string>" >> $(BINDIR)/info.plist
	@echo "  <key>CFBundleIdentifier</key>" >> $(BINDIR)/info.plist
	@echo "  <string>$(MAIN)</string>" >> $(BINDIR)/info.plist
	@echo "  <key>CFBundleInfoDictionaryVersion</key>" >> $(BINDIR)/info.plist
	@echo "  <string>6.0</string>" >> $(BINDIR)/info.plist
	@echo "  <key>CFBundleName</key>" >> $(BINDIR)/info.plist
	@echo "  <string>$(JARNAME)</string>" >> $(BINDIR)/info.plist
	@echo "  <key>CFBundlePackageType</key>" >> $(BINDIR)/info.plist
	@echo "  <string>APPL</string>" >> $(BINDIR)/info.plist
	@echo "  <key>CFBundleShortVersionString</key>" >> $(BINDIR)/info.plist
	@echo "  <string>1.0</string>" >> $(BINDIR)/info.plist
	@echo "  <key>CFBundleSignature</key>" >> $(BINDIR)/info.plist
	@echo "  <string>????</string>" >> $(BINDIR)/info.plist
	@echo "  <!-- See http://developer.apple.com/library/mac/#releasenotes/General/SubmittingToMacAppStore/_index.html" >> $(BINDIR)/info.plist
	@echo "      for list of AppStore categories -->" >> $(BINDIR)/info.plist
	@echo "  <key>LSApplicationCategoryType</key>" >> $(BINDIR)/info.plist
	@echo "  <string>Unknown</string>" >> $(BINDIR)/info.plist
	@echo "  <key>CFBundleVersion</key>" >> $(BINDIR)/info.plist
	@echo "  <string>1.0</string>" >> $(BINDIR)/info.plist
	@echo "  <key>NSHumanReadableCopyright</key>" >> $(BINDIR)/info.plist
	@echo "  <string>Copyright (C) 2016</string>" >> $(BINDIR)/info.plist
	@echo "  <key>NSHighResolutionCapable</key>" >> $(BINDIR)/info.plist
	@echo "  <string>true</string>" >> $(BINDIR)/info.plist
	@echo " </dict>" >> $(BINDIR)/info.plist
	@echo "</plist>" >> $(BINDIR)/info.plist
	@find . -name .DS_Store | xargs rm -f

$(BINDIR)/$(JARNAME).dmg : $(BINDIR)/$(JARNAME).icns $(BINDIR)/$(JARNAME).jar
	@echo Creating package
	@mkdir -p $(BINDIR)/package/macosx
	@cp $(BINDIR)/$(JARNAME).icns $(BINDIR)/package/macosx
	@cd $(BINDIR); $(JH)/bin/javapackager -deploy -native dmg -srcfiles $(JARNAME).jar -outdir package	 -name $(JARNAME)  -title  $(JARNAME)  -Bmac.CFBundleName=$(JARNAME) -Bruntime=$(JH)/../../ -appclass $(MAIN) -outfile $(JARNAME)
	@mv $(BINDIR)/package/bundles/$(JARNAME)-1.0.dmg  $(BINDIR)
	@rm -r  $(BINDIR)/package
	
.PHONY: clean run bin jar pack dmg app

clean:
	@$(RM) -rf  *~  $(BINDIR) 
	@find . -name .DS_Store | xargs rm -f
		
jar:  $(BINDIR)/$(JARNAME).jar

app : $(BINDIR)/$(JARNAME).app 
	
bin:  $(BINDIR)/$(JARNAME)

dmg : $(BINDIR)/$(JARNAME).dmg
	
run :
	@java -cp $(BINDIR)/production $(MAIN)

pack :
	@echo Creating $(BUILD).tar.gz 
	@find . -name .DS_Store | xargs rm -f
	@mkdir -p $(PROJECT)
	@cp -r src Makefile $(PROJECT)
	@tar czf $(BUILD).tar.gz $(PROJECT)
	@rm -r $(PROJECT)
	
