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
    : FOR    ${I}    IN RANGE    0    5
    \    log    "install app"
    \    Adb Install Package
    \    sleep    3
    \    log    "init app"
    \    initApp
    \    log    "meminfo and topinfo"
    \    top    2
    \    Meminfo    %{G_APPIUM_APP_PACKAGE}
    \    log    "unistall apk"
    \    Adb Install Package
    \    sleep    1
    [Teardown]    Stress_Suit_Teardown

test_02live_standby
    [Setup]    Stress_Test_Setup    ${TEST_NAME}    ${OUTPUT_DIR}
    #selectR
    openApp
    sleep    3
    ${checked}    SelectR    %{U_APP_OFFLINE_Rname}
    run keyword if    '${checked}'=='true'    log    '%{U_APP_OFFLINE_Rname} is selected'
    sleep    1
    log    "start Live"
    StartStopLive
    sleep    1
    : FOR    ${I}    IN RANGE    0    10
    \    #收集cpu以及mem数据
    \    sleep    1
    \    log    "meminfo and top info"
    \    top    2
    \    sleep    1
    \    Meminfo    %{G_APPIUM_APP_PACKAGE}
    \    sleep    5
    StartStopLive
    sleep    2
    log    "R standby"
    log    收集"meminfo and topinfo"
    top    2
    Meminfo    %{G_APPIUM_APP_PACKAGE}
    [Teardown]    Stress_Suit_Teardown
