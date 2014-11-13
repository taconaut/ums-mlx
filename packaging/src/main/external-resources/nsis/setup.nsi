!include "MUI2.nsh"
!include "FileFunc.nsh"

; Include the project header file generated by the nsis-maven-plugin
!include "..\..\..\..\target\project.nsh"
!include "..\..\..\..\target\extra.nsh"

!define REG_KEY_UNINSTALL "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\${APPLICATION_NAME}"
!define REG_KEY_SOFTWARE "SOFTWARE\${APPLICATION_NAME}"

RequestExecutionLevel admin

Name "${APPLICATION_NAME}"
InstallDir "$PROGRAMFILES\${APPLICATION_NAME}"

;Get install folder from registry for updates
InstallDirRegKey HKCU "${REG_KEY_SOFTWARE}" ""

SetCompressor /SOLID lzma
SetCompressorDictSize 32

!define MUI_ABORTWARNING
!define MUI_FINISHPAGE_RUN
!define MUI_FINISHPAGE_RUN_FUNCTION RunPS3MS
!define MUI_WELCOMEFINISHPAGE_BITMAP "${NSISDIR}\Contrib\Graphics\Wizard\win.bmp"

!define MUI_FINISHPAGE_SHOWREADME ""
!define MUI_FINISHPAGE_SHOWREADME_NOTCHECKED
!define MUI_FINISHPAGE_SHOWREADME_TEXT "Create Desktop Shortcut"
!define MUI_FINISHPAGE_SHOWREADME_FUNCTION CreateDesktopShortcut

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "${PROJECT_ROOT_BASEDIR}\LICENSE.txt"
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

!define MUI_LANGDLL_ALLLANGUAGES
!insertmacro MUI_LANGUAGE "English"
!insertmacro MUI_LANGUAGE "Afrikaans"
!insertmacro MUI_LANGUAGE "Albanian"
!insertmacro MUI_LANGUAGE "Arabic"
!insertmacro MUI_LANGUAGE "Basque"
!insertmacro MUI_LANGUAGE "Belarusian"
!insertmacro MUI_LANGUAGE "Bosnian"
!insertmacro MUI_LANGUAGE "Breton"
!insertmacro MUI_LANGUAGE "Bulgarian"
!insertmacro MUI_LANGUAGE "Catalan"
!insertmacro MUI_LANGUAGE "Croatian"
!insertmacro MUI_LANGUAGE "Czech"
!insertmacro MUI_LANGUAGE "Danish"
!insertmacro MUI_LANGUAGE "Dutch"
!insertmacro MUI_LANGUAGE "Esperanto"
!insertmacro MUI_LANGUAGE "Estonian"
!insertmacro MUI_LANGUAGE "Farsi"
!insertmacro MUI_LANGUAGE "Finnish"
!insertmacro MUI_LANGUAGE "French"
!insertmacro MUI_LANGUAGE "Galician"
!insertmacro MUI_LANGUAGE "German"
!insertmacro MUI_LANGUAGE "Greek"
!insertmacro MUI_LANGUAGE "Hebrew"
!insertmacro MUI_LANGUAGE "Hungarian"
!insertmacro MUI_LANGUAGE "Icelandic"
!insertmacro MUI_LANGUAGE "Indonesian"
!insertmacro MUI_LANGUAGE "Irish"
!insertmacro MUI_LANGUAGE "Italian"
!insertmacro MUI_LANGUAGE "Japanese"
!insertmacro MUI_LANGUAGE "Korean"
!insertmacro MUI_LANGUAGE "Kurdish"
!insertmacro MUI_LANGUAGE "Latvian"
!insertmacro MUI_LANGUAGE "Lithuanian"
!insertmacro MUI_LANGUAGE "Luxembourgish"
!insertmacro MUI_LANGUAGE "Macedonian"
!insertmacro MUI_LANGUAGE "Malay"
!insertmacro MUI_LANGUAGE "Mongolian"
!insertmacro MUI_LANGUAGE "Norwegian"
!insertmacro MUI_LANGUAGE "NorwegianNynorsk"
!insertmacro MUI_LANGUAGE "Polish"
!insertmacro MUI_LANGUAGE "Portuguese"
!insertmacro MUI_LANGUAGE "PortugueseBR"
!insertmacro MUI_LANGUAGE "Romanian"
!insertmacro MUI_LANGUAGE "Russian"
!insertmacro MUI_LANGUAGE "Serbian"
!insertmacro MUI_LANGUAGE "SerbianLatin"
!insertmacro MUI_LANGUAGE "SimpChinese"
!insertmacro MUI_LANGUAGE "Slovak"
!insertmacro MUI_LANGUAGE "Slovenian"
!insertmacro MUI_LANGUAGE "Spanish"
!insertmacro MUI_LANGUAGE "SpanishInternational"
!insertmacro MUI_LANGUAGE "Swedish"
!insertmacro MUI_LANGUAGE "Thai"
!insertmacro MUI_LANGUAGE "TradChinese"
!insertmacro MUI_LANGUAGE "Turkish"
!insertmacro MUI_LANGUAGE "Ukrainian"
!insertmacro MUI_LANGUAGE "Uzbek"
!insertmacro MUI_LANGUAGE "Welsh"

ShowUninstDetails show

Function .onInit
  ;Check OS for 64-bit installer.
  !insertmacro checkSystemOS
  !insertmacro MUI_LANGDLL_DISPLAY
FunctionEnd

Function un.onInit
  !insertmacro MUI_LANGDLL_DISPLAY
FunctionEnd

;Run program through explorer.exe to de-evaluate user from admin to regular one.
;http://mdb-blog.blogspot.ru/2013/01/nsis-lunch-program-as-user-from-uac.html
Function RunPS3MS
  Exec '"$WINDIR\explorer.exe" "$INSTDIR\PMS.exe"'
FunctionEnd

Function CreateDesktopShortcut
  CreateShortCut "$DESKTOP\${APPLICATION_NAME}.lnk" "$INSTDIR\PMS.exe"
FunctionEnd

Section "Program Files"
  SetOutPath "$INSTDIR"
  SetOverwrite on
  nsSCM::Stop "${PROJECT_NAME}"
  File /r /x "*.conf" /x "*.zip" /x "*.dll" /x "third-party" "${PROJECT_CORE_BASEDIR}\src\main\external-resources\plugins" 
  File /r "${PROJECT_BASEDIR}\src\main\resources"
  File /r "${PROJECT_CORE_BASEDIR}\src\main\external-resources\documentation"
  File /r "${PROJECT_CORE_BASEDIR}\src\main\external-resources\renderers"
  File /r "${PROJECT_BUILD_DIR}\bin\win32"
  ;Install private JRE folder if needed.
  !insertmacro installPrivateJRE
  File "${PROJECT_BUILD_DIR}\PMS.exe"
  File "${PROJECT_BASEDIR}\target\pms.jar"
  File "${PROJECT_BASEDIR}\src\main\external-resources\transcode-tools\win32\MediaInfo.dll"
  File "${PROJECT_BASEDIR}\src\main\external-resources\transcode-tools\win32\MediaInfo64.dll"
  File "${PROJECT_BASEDIR}\src\main\external-resources\transcode-tools\win32\jnotify.dll"
  File "${PROJECT_BASEDIR}\src\main\external-resources\transcode-tools\win32\jnotify_64bit.dll"
  File "${PROJECT_ROOT_BASEDIR}\CHANGELOG.txt"
  File "${PROJECT_ROOT_BASEDIR}\README.md"
  File "${PROJECT_ROOT_BASEDIR}\LICENSE.txt"
  File "${PROJECT_CORE_BASEDIR}\src\main\external-resources\logback.xml"
  File "${PROJECT_CORE_BASEDIR}\src\main\external-resources\icon.ico"

  ;the user may have set the installation dir
  ;as the profile dir, so we can't clobber this
  SetOverwrite off
  File "${PROJECT_CORE_BASEDIR}\src\main\external-resources\WEB.conf"

  ;Store install folder
  WriteRegStr HKCU "${REG_KEY_SOFTWARE}" "" $INSTDIR

  ;Create uninstaller
  WriteUninstaller "$INSTDIR\uninst.exe"

  WriteRegStr HKEY_LOCAL_MACHINE "${REG_KEY_UNINSTALL}" "DisplayName" "${APPLICATION_NAME}"
  WriteRegStr HKEY_LOCAL_MACHINE "${REG_KEY_UNINSTALL}" "DisplayIcon" "$INSTDIR\icon.ico"
  WriteRegStr HKEY_LOCAL_MACHINE "${REG_KEY_UNINSTALL}" "DisplayVersion" "${PROJECT_VERSION}"
  WriteRegStr HKEY_LOCAL_MACHINE "${REG_KEY_UNINSTALL}" "Publisher" "${PROJECT_ORGANIZATION_NAME}"
  WriteRegStr HKEY_LOCAL_MACHINE "${REG_KEY_UNINSTALL}" "URLInfoAbout" "${PROJECT_ORGANIZATION_URL}"
  WriteRegStr HKEY_LOCAL_MACHINE "${REG_KEY_UNINSTALL}" "UninstallString" '"$INSTDIR\uninst.exe"'

  ${GetSize} "$INSTDIR" "/S=0K" $0 $1 $2
  IntFmt $0 "0x%08X" $0
  WriteRegDWORD HKLM "${REG_KEY_UNINSTALL}" "EstimatedSize" "$0"

  WriteUnInstaller "uninst.exe"

  ReadENVStr $R0 ALLUSERSPROFILE
  SetOutPath "$R0\PMS"
  AccessControl::GrantOnFile "$R0\PMS" "(S-1-5-32-545)" "FullAccess"
SectionEnd

Section "Start Menu Shortcuts"
  SetShellVarContext all
  CreateDirectory "$SMPROGRAMS\${APPLICATION_NAME}"
  CreateShortCut "$SMPROGRAMS\${APPLICATION_NAME}\${APPLICATION_NAME}.lnk" "$INSTDIR\PMS.exe" "" "$INSTDIR\PMS.exe" 0
  CreateShortCut "$SMPROGRAMS\${APPLICATION_NAME}\${APPLICATION_NAME} (Select Profile).lnk" "$INSTDIR\PMS.exe" "profiles" "$INSTDIR\PMS.exe" 0
  CreateShortCut "$SMPROGRAMS\${APPLICATION_NAME}\Uninstall.lnk" "$INSTDIR\uninst.exe" "" "$INSTDIR\uninst.exe" 0
SectionEnd

Section "Uninstall"
  SetShellVarContext all

  nsSCM::Stop "${PROJECT_NAME}"
  nsSCM::Remove "${PROJECT_NAME}"

  Delete /REBOOTOK "$INSTDIR\uninst.exe"
  RMDir /R /REBOOTOK "$INSTDIR\plugins"
  RMDir /R /REBOOTOK "$INSTDIR\renderers"
  RMDir /R /REBOOTOK "$INSTDIR\documentation"
  RMDir /R /REBOOTOK "$INSTDIR\win32"
  RMDir /R /REBOOTOK "$INSTDIR\resources"
  ;Uninstall private JRE folder if needed.
  !insertmacro uninstallPrivateJRE
  Delete /REBOOTOK "$INSTDIR\PMS.exe"
  Delete /REBOOTOK "$INSTDIR\pms.jar"
  Delete /REBOOTOK "$INSTDIR\MediaInfo.dll"
  Delete /REBOOTOK "$INSTDIR\MediaInfo64.dll"
  Delete /REBOOTOK "$INSTDIR\jnotify.dll"
  Delete /REBOOTOK "$INSTDIR\jnotify_64bit.dll"
  Delete /REBOOTOK "$INSTDIR\CHANGELOG"
  Delete /REBOOTOK "$INSTDIR\WEB.conf"
  Delete /REBOOTOK "$INSTDIR\README.md"
  Delete /REBOOTOK "$INSTDIR\LICENSE.txt"
  Delete /REBOOTOK "$INSTDIR\debug.log"
  Delete /REBOOTOK "$INSTDIR\logback.xml"
  Delete /REBOOTOK "$INSTDIR\icon.ico"
  RMDir /REBOOTOK "$INSTDIR"

  Delete /REBOOTOK "$DESKTOP\${APPLICATION_NAME}.lnk"
  RMDir /REBOOTOK "$SMPROGRAMS\${APPLICATION_NAME}"
  Delete /REBOOTOK "$SMPROGRAMS\${APPLICATION_NAME}\${APPLICATION_NAME}.lnk"
  Delete /REBOOTOK "$SMPROGRAMS\${APPLICATION_NAME}\${APPLICATION_NAME} (Select Profile).lnk"
  Delete /REBOOTOK "$SMPROGRAMS\${APPLICATION_NAME}\Uninstall.lnk"

  DeleteRegKey HKEY_LOCAL_MACHINE "${REG_KEY_UNINSTALL}"
  DeleteRegKey HKCU "${REG_KEY_SOFTWARE}"
SectionEnd