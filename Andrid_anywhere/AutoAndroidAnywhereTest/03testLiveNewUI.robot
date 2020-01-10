*** Settings ***
Library           AppiumLibrary    run_on_failure=AppiumLibrary.CapturePageScreenshot
Resource          ./MainKeys.txt
Library           String
Library           Collections
Library           myTestLibrary

*** Variables ***

*** Test Cases ***
test_01changeToNewUI
    [Documentation]    更改到新的ui
    [Tags]    ChangeUI
    [Setup]    OpenApp
    Open Application    %{G_APPIUM_HOST_IP0}    platformName=%{G_APPIUM_PLATFORM_NAME}    platformVersion=%{G_APPIUM_PLATFORM_VERSION}    deviceName=%{U_APPIUM_DEVICE_NAME}    appPackage=%{G_APPIUM_APP_PACKAGE}    appActivity=%{U_APP_Activity}
    ...    noReset=True    automationName=uiautomator2
    sleep    3
    Wait Until Element Is Visible    com.tvunetworks.android.anywhere:id/btn_explore_now
    sleep    1
    click Element    com.tvunetworks.android.anywhere:id/btn_explore_now
    sleep    1
    #提示重启app使用新的ui
    Wait Until Element Is Visible    //*[@resource-id="android:id/alertTitle"]
    #选择apply
    click Element    //*[@resource-id="android:id/button1"]
    sleep    5
    #skip uiser guid
    click Element    //*[@resource-id="com.tvunetworks.android.anywhere:id/skip"]
    sleep    1
    [Teardown]    Close Application

test_02Live_Stop
    [Documentation]    live stop on new ui
    [Tags]    newUILive
    [Setup]    newUI_openApp
    sleep    1
    newUI_selectR_Live    %{U_APP_OFFLINE_Rname}
    #check是否liive成功
    ${isLive}    newUI_isLive    %{U_APP_OFFLINE_Rname}    %{U_APP_Res}
    should be equal    ${isLive}    1
    sleep    20
    #switch camera
    click Element    com.tvunetworks.android.anywhere:id/camera_imgview
    sleep    1
    #stop live
    click Element    com.tvunetworks.android.anywhere:id/buttonStartR
    sleep    1
    ${isStop}    newUI_isStop    %{U_APP_OFFLINE_Rname}
    should be equal    ${isStop}    1
    [Teardown]    Close Application

test_03Record
    [Tags]    newUIRecord
    [Setup]    newUI_openApp
    sleep    1
    log    "test record"
    #click record
    ${text}    Get Text    //*[@resource-id="com.tvunetworks.android.anywhere:id/buttonRecord"]
    Run keyword If    '${text}'=='REC'    log    "record button text is REC"
    sleep    1
    Wait Until Element Is Visible    //*[@resource-id="com.tvunetworks.android.anywhere:id/buttonRecord"]
    click element    //*[@resource-id="com.tvunetworks.android.anywhere:id/buttonRecord"]
    Wait Until Element Is Visible    //*[@resource-id="com.tvunetworks.android.anywhere:id/tv_recording_status"]    30
    ${text}    Get Text    com.tvunetworks.android.anywhere:id/tv_recording_status
    Should Not Contain    '${text}'    'Rec'
    sleep    20
    #stop record
    click element    //*[@resource-id="com.tvunetworks.android.anywhere:id/buttonRecord"]
    sleep    3
    ${text}    Get Text    com.tvunetworks.android.anywhere:id/buttonRecord
    should be equal    '${text}'    'REC'
    # start live
    newUI_selectR_Live    %{U_APP_OFFLINE_Rname}
    sleep    5
    #click record
    click element    com.tvunetworks.android.anywhere:id/buttonRecord
    Wait Until Element Is Visible    //*[@resource-id="com.tvunetworks.android.anywhere:id/tv_recording_status"]    30
    ${text}    Get Text    com.tvunetworks.android.anywhere:id/tv_recording_status
    Should Not Contain    '${text}'    'Rec'
    sleep    20
    #stop live
    Wait Until Element Is Visible    com.tvunetworks.android.anywhere:id/buttonStartR    30
    click Element    com.tvunetworks.android.anywhere:id/buttonStartR
    sleep    2
    newUI_isStop    %{U_APP_OFFLINE_Rname}
    sleep    2
    #stop record
    Wait Until Element Is Visible    //*[@resource-id="com.tvunetworks.android.anywhere:id/buttonRecord"]    30
    click element    //*[@resource-id="com.tvunetworks.android.anywhere:id/buttonRecord"]
    sleep    3
    ${text}    Get Text    com.tvunetworks.android.anywhere:id/buttonRecord
    should be equal    '${text}'    'REC'
    [Teardown]    Close Application

test_04Upload
    [Tags]    Upload_newUI
    [Setup]    newUI_openApp
    log    "click menue"
    newUI_clickMenu
    Click Element    com.tvunetworks.android.anywhere:id/imgUpload
    sleep    1
    ${isFinish}    Upload    %{U_APP_OFFLINE_Rname}    1
    log    ${isFinish}
    Should Be Equal    ${isFinish}    1    "上传进度不为100%,上传失败“
    [Teardown]    Close Application

test_05takephoto
    [Documentation]    test take photo
    [Tags]    newUI_takePhoto
    [Setup]    newUI_openApp
    log    "click menu"
    sleep    1
    newUI_selectR_Live    %{U_APP_OFFLINE_Rname}
    #check是否liive成功
    ${isLive}    newUI_isLive    %{U_APP_OFFLINE_Rname}    %{U_APP_Res}
    should be equal    ${isLive}    1
    sleep    5
    #click menu
    newUI_clickMenu
    sleep    1
    click Element    com.tvunetworks.android.anywhere:id/take_picture_imgview
    sleep    1
    Wait Until Element Is Visible    //android.widget.FrameLayout[1]/android.widget.ImageView[1]    30
    sleep    5
    #stop Live
    Wait Until Element Is Visible    com.tvunetworks.android.anywhere:id/buttonStartR    30
    click Element    com.tvunetworks.android.anywhere:id/buttonStartR
    sleep    1
    ${isStop}    newUI_isStop    %{U_APP_OFFLINE_Rname}
    sleep    1
    should be equal    ${isStop}    1
    [Teardown]    Close Application

test_06addExternalSource
    [Tags]    newUI_addExt
    [Setup]    newUI_openApp
    sleep    1
    log    "add Extternal Source"
    newUI_clickMenu
    Wait Until Element Is Visible    //*[@resource-id="com.tvunetworks.android.anywhere:id/externalCamera_imgview"]
    click Element    //*[@resource-id="com.tvunetworks.android.anywhere:id/externalCamera_imgview"]
    sleep    1
    addSource    4
    [Teardown]    Close Application

test_07delExternelSource
    [Tags]    newUI_delEXT
    [Setup]    newUI_openApp
    log    "del ExternalSource"
    newUI_clickMenu
    Wait Until Element Is Visible    //*[@resource-id="com.tvunetworks.android.anywhere:id/externalCamera_imgview"]
    click Element    //*[@resource-id="com.tvunetworks.android.anywhere:id/externalCamera_imgview"]
    sleep    1
    delSource    4
    [Teardown]    Close Application

test_08VFB
    [Tags]    newUI_VFB
    [Setup]    newUI_openApp
    sleep    1
    log    "VFB"
    newUI_clickMenu
    log    "click vfb"
    Wait Until Element Is Visible    //*[@resource-id="com.tvunetworks.android.anywhere:id/text_vfb"]
    click Element    //*[@resource-id="com.tvunetworks.android.anywhere:id/text_vfb"]
    sleep    1
    [Teardown]    Close Application

test_10Scan
    [Tags]    newUI_Scan
    [Setup]    newUI_openApp
    sleep    1
    log    "Scan"
    Wait Until Element Is Visible    com.tvunetworks.android.anywhere:id/buttonScanBarcode    30
    click element    com.tvunetworks.android.anywhere:id/buttonScanBarcode
    sleep    2
    Page Should Contain Element    //*[@resource-id="com.tvunetworks.android.anywhere:id/btn_scan_qr"]
    Page Should Contain Element    //*[@resource-id="com.tvunetworks.android.anywhere:id/btn_input_license"]
    Page Should Contain Element    com.tvunetworks.android.anywhere:id/et_phone_number
    Page Should Contain Element    com.tvunetworks.android.anywhere:id/et_introduce_info
    [Teardown]    Close Application

test_11About
    [Tags]    newUI_about
    [Setup]    newUI_openApp
    sleep    1
    log    "About"
    newUI_clickSetting
    log    "Click About"
    Wait Until Element Is Visible    com.tvunetworks.android.anywhere:id/bottom_setting_about    30
    Click Element    com.tvunetworks.android.anywhere:id/bottom_setting_about
    sleep    1
    ${text}    Get Text    android:id/alertTitle
    should be equal    '${text}'    'About'
    sleep    1
    ${tpid}    Get Text    com.tvunetworks.android.anywhere:id/pid_info
    should be equal    '${tpid}'    'PID: %{U_APP_TpeerId}'
    ${ver}    Get Text    //*[@resource-id="com.tvunetworks.android.anywhere:id/version"]
    should be equal    '${ver}'    '%{U_APP_Tversion}'
    [Teardown]    Close Application

test_12Alert
    [Tags]    newUI_alert
    [Setup]    newUI_openApp
    sleep    1
    log    "Alert"
    newUI_clickSetting
    log    "click Alert"
    Wait Until Element Is Visible    com.tvunetworks.android.anywhere:id/bottom_setting_alert
    Click Element    com.tvunetworks.android.anywhere:id/bottom_setting_alert
    sleep    1
    Wait Until Element Is Visible    //*[@resource-id="com.tvunetworks.android.anywhere:id/activity_toolbar_title"]
    ${text}    Get Text    //*[@resource-id="com.tvunetworks.android.anywhere:id/activity_toolbar_title"]
    should be equal    '${text}'    'Alert'
    [Teardown]    Close Application

test_13SignIn
    [Tags]    newUI_Signin
    [Setup]    newUI_openApp
    sleep    1
    log    "Sign in "
    newUI_clickSetting
    Click Element    com.tvunetworks.android.anywhere:id/bottom_setting_signin
    ${text}    Get text    android:id/alertTitle
    Run keyword If    '${text}'=='Sign Out'    Click Element    //*[@resource-id="android:id/button1"]
    sleep    5
    newUI_clickSetting
    Click Element    com.tvunetworks.android.anywhere:id/bottom_setting_signin
    sleep    3
    ${signStats}    Get Text    com.tvunetworks.android.anywhere:id/activity_toolbar_title
    Run Keyword If    '${signStats}'=='Sign in'    Run Keywords    Input Text    com.tvunetworks.android.anywhere:id/input_email    %{U_APP_OFFLINE_USER}
    ...    AND    Input Password    com.tvunetworks.android.anywhere:id/input_password    %{U_APP_OFFLINE_PWD}
    ...    AND    Click Element    com.tvunetworks.android.anywhere:id/buttonSignIn
    ...    ELSE    log    "已经是登录状态“
    sleep    5
    newUI_clickSetting
    Wait Until Element Is Visible    com.tvunetworks.android.anywhere:id/text_signin
    ${text}    Get Text    com.tvunetworks.android.anywhere:id/text_signin
    should be equal    '${text}'    'Sign out'
    [Teardown]    Close Application

test_14mma
    [Tags]    newUI_mma
    [Setup]    newUI_openApp
    sleep    1
    log    "MMA"
    newUI_clickSetting
    Wait Until Element Is Visible    com.tvunetworks.android.anywhere:id/bottom_setting_mma
    Click Element    com.tvunetworks.android.anywhere:id/bottom_setting_mma
    sleep    2
    Wait Until Element Is Visible    com.tvunetworks.android.anywhere:id/story    30
    ${text}    Get Text    com.tvunetworks.android.anywhere:id/story
    Should be equal    '${text}'    'Story'
    #选择第一个story去live
    Click Element    //*[@resource-id="com.tvunetworks.android.anywhere:id/story_list"]/android.view.ViewGroup[1]
    sleep    1
    Click Element    com.tvunetworks.android.anywhere:id/story_go
    sleep    10
    #判断是否在live
    ${isok}    newUI_isLive    %{U_APP_OFFLINE_Rname}    %{U_APP_Res}
    Should Be Equal    ${isok}    1
    sleep    10
    #stop live
    StartStopLive
    sleep    1
    ${isStop}    newUI_isStop    %{U_APP_OFFLINE_Rname}
    Should Be Equal    ${isStop}    1
    [Teardown]    Close Application

test_15stream
    [Tags]    newUI_stream
    [Setup]    newUI_openApp
    sleep    1
    log    "Stream"
    newUI_clickSetting
    Wait Until Element Is Visible    com.tvunetworks.android.anywhere:id/bottom_setting_stream    30
    Click Element    com.tvunetworks.android.anywhere:id/bottom_setting_stream
    sleep    1
    stream    %{U_APP_OFFLINE_Rname}    %{U_APP_OFFLINE_destination}
    sleep    10
    ${isLive}    newUI_isLive    %{U_APP_OFFLINE_Rname}    %{U_APP_Res}
    should be equal    ${isLive}    1
    #stop live
    click Element    com.tvunetworks.android.anywhere:id/buttonStartR
    sleep    1
    newUI_isStop    %{U_APP_OFFLINE_Rname}
    [Teardown]    Close Application

test_16Setting
    [Documentation]    setting birate ,framerate and hevc
    [Tags]    newUI_Setting
    [Setup]    newUI_openApp
    sleep    1
    log    "Setting-->set bitrate ,framerate ,open hevc"
    ${Resolution}    Set Variable    1920 x 1080
    ${FrameRate}    Set Variable    25p
    ${res_}    Set Variable    1080P25
    ${isOn}    Set Variable    ON
    newUI_clickSetting
    Wait Until Element Is Visible    com.tvunetworks.android.anywhere:id/bottom_setting_settings    30
    Click Element    com.tvunetworks.android.anywhere:id/bottom_setting_settings
    sleep    1
    Wait Until Element Is Visible    com.tvunetworks.android.anywhere:id/activity_toolbar_title    30
    sleep    2
    ChangeResolutionandFrameRate    ${Resolution}    ${FrameRate}    ${isOn}
    newUI_selectR_Live    %{U_APP_OFFLINE_Rname}
    sleep    2
    ${isLive}    newUI_isLive    %{U_APP_OFFLINE_Rname}    ${res_}
    Should be equal    ${isLive}    1
    sleep    5
    #stop live
    Click Element    com.tvunetworks.android.anywhere:id/buttonStartR
    sleep    3
    #恢复原来设置
    newUI_clickSetting
    Wait Until Element Is Visible    com.tvunetworks.android.anywhere:id/bottom_setting_settings    30
    Click Element    com.tvunetworks.android.anywhere:id/bottom_setting_settings
    sleep    1
    Wait Until Element Is Visible    com.tvunetworks.android.anywhere:id/activity_toolbar_title    30
    sleep    2
    ChangeResolutionandFrameRate    %{U_APP_Resolution}    %{U_APP_Framerate}    %{U_APP_HEVC}
    [Teardown]    Close Application
