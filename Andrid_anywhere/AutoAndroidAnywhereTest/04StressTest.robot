*** Settings ***
Test Setup
Test Teardown
Resource          Share_resource.txt
Library           Common/Library/main.py

*** Test Cases ***
test_01_install_uninstall_app
    [Setup]    Stress_Test_Setup    ${TEST_NAME}    ${OUTPUT_DIR}
    sleep    2
    log    “判断是否安装%{G_APPIUM_APP_PACKAGE}"
    ${status}    Is Package Installed    %{G_APPIUM_APP_PACKAGE}
    log    "是否了安装app:${status}
    Run keyword If    '${status}'=='True'    Adb Uninstall Package
    ...    ELSE    log    "没有安装app"
    : FOR    ${I}    IN RANGE    0    10
    \    log    "install app"
    \    Adb Install Package
    \    sleep    3
    \    log    "init app"
    \    initApp
    \    log    "meminfo and topinfo"
    \    top    2
    \    Meminfo    %{G_APPIUM_APP_PACKAGE}
    \    log    "unistall apk"
    \    sleep    1
    \    Adb Uninstall Package
    \    sleep    1
    [Teardown]    Stress_Suit_Teardown

test_02live_standby
    [Setup]    Stress_Test_Setup    ${TEST_NAME}    ${OUTPUT_DIR}
    #判断是否安装了app
    ${status}    Is Package Installed    %{G_APPIUM_APP_PACKAGE}
    log    "是否了安装app:${status}
    Run keyword If    '${status}'=='True'    Adb Uninstall Package
    ...    ELSE    log    "没有安装app"
    log    "install app"
    Adb Install Package
    sleep    3
    log    "init app"
    initApp
    sleep    1
    openApp
    sleep    3
    #select R
    ${checked}    SelectR    %{U_APP_OFFLINE_Rname}
    run keyword if    '${checked}'=='true'    log    '%{U_APP_OFFLINE_Rname} is selected'
    sleep    1
    #Live
    log    "start Live"
    StartStopLive
    sleep    3
    : FOR    ${I}    IN RANGE    0    720
    \    #收集cpu以及mem数据
    \    #判断是否crash
    \    ${iscrash}    Iscrash    %{G_APPIUM_APP_PACKAGE}
    \    Run keyword If    '${iscrash}'=='1'    Run keyword    Launch App    %{G_APPIUM_APP_PACKAGE}    %{U_APPIUM_APPACTIVITY}
    \    sleep    3
    \    log    "meminfo and top info"
    \    top    2
    \    sleep    2
    \    Meminfo    %{G_APPIUM_APP_PACKAGE}
    \    sleep    5
    #stop live
    StartStopLive
    sleep    2
    log    "R standby"
    log    收集"meminfo and topinfo"
    top    2
    Meminfo    %{G_APPIUM_APP_PACKAGE}
    [Teardown]    Stress_Suit_Teardown
