*** Settings ***
Suite Teardown    Close All Applications
Library           AppiumLibrary
Resource          ./MainKeys.txt
Library           myTestLibrary

*** Variables ***

*** Test Cases ***
test_01UninstallApp
    [Documentation]    自定以unstallApp
    [Tags]    appUninstall
    log    “判断是安装%{G_APPIUM_APP_PACKAGE}"
    ${status}    Is Package Installed    %{G_APPIUM_APP_PACKAGE}
    log    "是否了安装app:${status}
    Run keyword If    '${status}'=='True'    Adb Uninstall Package
    ...    ELSE    log    "没有安装app"
    #判断是否卸载完成
    ${status_new}    Is Package Installed    %{G_APPIUM_APP_PACKAGE}
    should be equal    '${status_new}'    'False'

test_02installApp
    [Documentation]    自定义Install app
    [Tags]    installApp
    log    "install apk:%{G_APPIUM_APP_APK}"
    sleep    2
    log    "下载最新版本到本地"
    Download Apk    %{U_APP_ApkName}    %{G_FTPFILEPATH}    %{G_APPIUM_APP_DIR}    %{G_FTPHOSTIP}    %{G_FTPUSER}    %{G_FTPPASS}
    sleep    30    #等待文件下完
    sleep    2
    log    "安装“
    Adb Install Package    %{U_APP_ApkName}    %{G_APPIUM_APP_PACKAGE}
    sleep    2
    ${status_new}    Is Package Installed    %{G_APPIUM_APP_PACKAGE}
    should be equal    '${status_new}'    'True'

test_03initApp
    [Documentation]    init app & grant app:
    ...    检查是否安装成功，授予权限
    [Tags]    init_app
    [Setup]
    sleep    3
    log    "test_03 init App"
    initApp

*** Keywords ***
