*** Settings ***
Suite Teardown    Close All Applications
Library           AppiumLibrary    run_on_failure=AppiumLibrary.CapturePageScreenshot
Resource          ./MainKeys.txt
Library           String
Library           Collections
Library           myTestLibrary

*** Variables ***

*** Test Cases ***
test_01Live_Stop
    [Documentation]    test select R
    ...    Live R
    ...    stop Live
    [Tags]    liveStop
    [Setup]    OpenApp
    #selectR
    log    'select R'
    sleep    3
    ${checked}    SelectR    %{U_APP_OFFLINE_Rname}
    run keyword if    '${checked}'=='true'    log    '%{U_APP_OFFLINE_Rname} is selected'
    #start Live
    StartStopLive
    sleep    20
    ${isok}    IsLive    %{U_APP_OFFLINE_Rname}    %{U_APP_Res}
    Should Be Equal    ${isok}    1
    #stop LIve
    StartStopLive
    sleep    2
    ${isStop}    IsStop
    Should Be Equal    ${isStop}    1
    [Teardown]    Close Application

test_02SwitchCamera
    [Documentation]    1.switch Camera during living
    ...    2.take a photo during living
    [Tags]    switchCamera
    [Setup]    OpenApp
    ${checked}    SelectR    %{U_APP_OFFLINE_Rname}
    run keyword if    '${checked}'=='true'    log    '%{U_APP_OFFLINE_Rname} is selected'
    StartStopLive
    sleep    10
    ${isok}    IsLive    %{U_APP_OFFLINE_Rname}    %{U_APP_Res}
    Should Be Equal    ${isok}    1
    Click Element    com.tvunetworks.android.anywhere:id/camera_imgview
    sleep    3
    #take a photo
    Click Element    com.tvunetworks.android.anywhere:id/take_picture_imgview
    sleep    10
    StartStopLive
    sleep    3
    ${isStop}    IsStop
    Should Be Equal    ${isStop}    1
    [Teardown]    Close Application

test_03Record
    [Tags]    record
    [Setup]    OpenApp
    sleep    3
    # record during standby
    Click Element    com.tvunetworks.android.anywhere:id/buttonRecord
    sleep    20
    Wait Until Element Is Visible    com.tvunetworks.android.anywhere:id/recording_status    30
    log    "recording is ok"
    # stop record
    log    "stop record"
    Click Element    com.tvunetworks.android.anywhere:id/buttonRecord
    sleep    3
    Wait Until Page Does Not Contain Element    com.tvunetworks.android.anywhere:id/recording_status    30    "record status \ don't appear"
    #start live button
    ${checked}    SelectR    %{U_APP_OFFLINE_Rname}
    run keyword if    '${checked}'=='true'    Run Keyword    log    '%{U_APP_OFFLINE_Rname} is selected'
    StartStopLive
    sleep    1
    ${isok}    IsLive    %{U_APP_OFFLINE_Rname}    %{U_APP_Res}
    Should Be Equal    ${isok}    1
    #click record during living
    Click Element    com.tvunetworks.android.anywhere:id/buttonRecord
    sleep    20
    Wait Until Element Is Visible    com.tvunetworks.android.anywhere:id/recording_status    30
    log    "recording is ok"
    # stop record
    Click Element    com.tvunetworks.android.anywhere:id/buttonRecord
    sleep    1
    Wait Until Page Does Not Contain Element    com.tvunetworks.android.anywhere:id/recording_status    30    "record status \ \ don't appear"
    #stop Live
    StartStopLive
    sleep    1
    ${isStop}    IsStop
    Should Be Equal    ${isStop}    1
    [Teardown]    Close Application

test_04Upload
    [Tags]    Upload
    [Setup]    OpenApp
    #click Upload
    log    "execute upload"
    Wait Until Element Is Visible    com.tvunetworks.android.anywhere:id/buttonUpload    30
    Click Element    com.tvunetworks.android.anywhere:id/buttonUpload
    Wait Until Element Is Visible    com.tvunetworks.android.anywhere:id/activity_toolbar_title    30
    log    "access to upload page"
    #upload video
    ${isFinish}    Upload    %{U_APP_OFFLINE_Rname}    1
    log    ${isFinish}
    Should Be Equal    ${isFinish}    1    "上传进度不为100%,上传失败“
    [Teardown]    Close Application

test_05tokenScan
    [Tags]    token
    [Setup]    OpenApp
    #click Scan
    log    "click token"
    Click Element    com.tvunetworks.android.anywhere:id/buttonScanBarcode
    sleep    1
    Wait Until Element Is Visible    com.tvunetworks.android.anywhere:id/et_phone_number    30
    Wait Until Element Is Visible    com.tvunetworks.android.anywhere:id/et_introduce_info    30
    Wait Until Element Is Visible    com.tvunetworks.android.anywhere:id/btn_scan_qr
    Wait Until Element Is Visible    com.tvunetworks.android.anywhere:id/btn_input_license
    [Teardown]    Close Application

test_06SignIn
    [Tags]    SignIn
    [Setup]    OpenApp
    log    "test sign in "
    ${signStats}    Get Text    com.tvunetworks.android.anywhere:id/buttonAccountText
    Run Keyword If    '${signStats}'=='Sign in'    Run Keywords    Click Element    com.tvunetworks.android.anywhere:id/buttonAccount
    ...    AND    Input Text    com.tvunetworks.android.anywhere:id/input_email    %{U_APP_OFFLINE_USER}
    ...    AND    Input Password    com.tvunetworks.android.anywhere:id/input_password    %{U_APP_OFFLINE_PWD}
    ...    AND    Click Element    com.tvunetworks.android.anywhere:id/buttonSignIn
    ...    ELSE    log    "已经是登录状态“
    sleep    2
    ${isLogIn}    Get Text    com.tvunetworks.android.anywhere:id/buttonAccountText
    Should be equal    "${isLogIn}"    "Sign out"
    [Teardown]    Close Application

test_07testAbout
    [Documentation]    test about information
    [Tags]    about
    [Setup]    OpenApp
    Wait Until Element Is Visible    com.tvunetworks.android.anywhere:id/buttonSetting    30
    Click Element    com.tvunetworks.android.anywhere:id/buttonSetting
    #click about
    Click Element    com.tvunetworks.android.anywhere:id/buttonAbout
    Wait Until Element Is Visible    com.tvunetworks.android.anywhere:id/tvu_title    30
    ${aboutInfo}    get text    android:id/alertTitle
    should be equal    '${aboutInfo}'    'About'
    ${pidinfo}    get text    com.tvunetworks.android.anywhere:id/pid_info
    should be equal    '${pidinfo}'    'PID: %{U_APP_TpeerId}'
    ${ver_info}    Get Text    com.tvunetworks.android.anywhere:id/version
    should be equal    '${ver_info}'    '%{U_APP_Tversion}'
    [Teardown]    Close Application

test_09Alert
    [Documentation]    test Advance---alert
    [Tags]    alert
    [Setup]    OpenApp
    #click setting
    Wait Until Element Is Visible    com.tvunetworks.android.anywhere:id/buttonSetting    30
    Click Element    com.tvunetworks.android.anywhere:id/buttonSetting
    sleep    2
    # click alert
    Wait Until Element Is Visible    com.tvunetworks.android.anywhere:id/buttonTVUAlert
    Click Element    com.tvunetworks.android.anywhere:id/buttonTVUAlert
    sleep    2
    Wait Until Element Is Visible    com.tvunetworks.android.anywhere:id/activity_toolbar_title
    ${title}    Get Text    com.tvunetworks.android.anywhere:id/activity_toolbar_title
    Should be equal    '${title}'    'Alert'
    [Teardown]    Close Application

test_10Stream
    [Documentation]    test Advanced-->Stream
    [Tags]    PushStream
    [Setup]    OpenApp
    #click setting
    Wait Until Element Is Visible    com.tvunetworks.android.anywhere:id/buttonSetting    30
    Click Element    com.tvunetworks.android.anywhere:id/buttonSetting
    sleep    2
    #click Stream
    Wait Until Element Is Visible    com.tvunetworks.android.anywhere:id/buttonStream
    Click Element    com.tvunetworks.android.anywhere:id/buttonStream
    sleep    2
    stream    %{U_APP_OFFLINE_Rname}    %{U_APP_OFFLINE_destination}
    ${isToast}    Run Keyword And Return Status    Page Should Contain Element    //*[@resource-id="android:id/message"]
    log    "存在提示信息:${isToast}"
    Should Be Equal    '${isToast}'    'False'
    sleep    2
    ${isok}    IsLive    %{U_APP_OFFLINE_Rname}    %{U_APP_Res}
    Should Be Equal    ${isok}    1
    #stop live
    StartStopLive
    sleep    1
    ${isStop}    IsStop
    Should Be Equal    ${isStop}    1
    [Teardown]    Close Application

test_11MMAPage
    [Tags]    MMA
    [Setup]    OpenApp
    #click setting
    Wait Until Element Is Visible    com.tvunetworks.android.anywhere:id/buttonSetting    30
    Click Element    com.tvunetworks.android.anywhere:id/buttonSetting
    sleep    2
    #click MMA
    Wait Until Element Is Visible    com.tvunetworks.android.anywhere:id/buttonMediaMind    30
    Click Element    com.tvunetworks.android.anywhere:id/buttonMediaMind
    sleep    2
    Wait Until Element Is Visible    com.tvunetworks.android.anywhere:id/story    10    "mediaMind story 没有弹出”
    #选择第一个story
    Click Element    com.tvunetworks.android.anywhere:id/story_item_name
    sleep    1
    #点击go
    Click Element    com.tvunetworks.android.anywhere:id/story_go
    sleep    3
    Wait Until Element Is Visible    android:id/message    30
    ${message}    Get Text    android:id/message
    log    ${message}
    Should Be Equal    '${message}'    'Story bind success'
    #判断是否在live
    ${isok}    IsLive    %{U_APP_OFFLINE_Rname}    %{U_APP_Res}
    Should Be Equal    ${isok}    1
    sleep    10
    #stop live
    StartStopLive
    sleep    1
    ${isStop}    IsStop
    Should Be Equal    ${isStop}    1
    [Teardown]    Close Application

test_12addExternalSource
    [Tags]    External
    [Setup]    OpenApp
    log    "select \ ExternalCamera"
    #click ExternalCamera
    Click Element    com.tvunetworks.android.anywhere:id/externalCamera_imgview
    sleep    1
    #click switch camera
    Click Element    com.tvunetworks.android.anywhere:id/img_switch_camera
    Wait Until Element Is Visible    com.tvunetworks.android.anywhere:id/str_switch_camera_title    30
    ${text}    Get Text    com.tvunetworks.android.anywhere:id/str_switch_camera_title
    should be equal    '${text}'    'Switch'
    #add 3 sources
    addSource    4
    [Teardown]    Close Application

test_13delExternelSource
    [Tags]    del Source
    [Setup]    OpenApp
    log    "del ExternalSource"
    #click ExternalCamera
    Click Element    com.tvunetworks.android.anywhere:id/externalCamera_imgview
    sleep    1
    delSource    4
    [Teardown]    Close Application

test_14VFB
    [Documentation]    test vfb ---由于动态框需要手动测试
    [Tags]    VFB
    [Setup]    OpenApp
    sleep    2
    Start_VFB_LocalSDI    %{U_APP_OFFLINE_Rname}
    sleep    2
    #判断vfb是否有video出来
    #Element Should Be Visible    //*[@resource-id="com.tvunetworks.android.anywhere:id/preview_field"]/android.view.View[2]
    #Element Should Be Visible    //*[@text="VFB"]
    #stop vfb
    #Click Element    com.tvunetworks.android.anywhere:id/img_vfb
    #${text}    Get Text    com.tvunetworks.android.anywhere:id/vfb_start_or_stop
    #log    "vfb当前状态:${text}"
    #should be equal    '${text}'    'Stop'
    #Click Element    //*[@resource-id="com.tvunetworks.android.anywhere:id/vfb_start_or_stop"]
    #sleep    2
    #Page Should Not Contain Element    //*[@resource-id="com.tvunetworks.android.anywhere:id/preview_field"]/android.view.View[2]
    [Teardown]    Close Application

test_15SettingAbout
    [Documentation]    test setting (change to QA enviroment)
    [Tags]    setting
    [Setup]    OpenApp
    sleep    2
    ClickSetting
    #Comment    PAUSE
    ScrollDownApp    %{U_APP_TpeerId}
    ${pid}    Get Text    //*[@resource-id='android:id/summary' and @text='%{U_APP_TpeerId}']
    should be equal    '${pid}'    '%{U_APP_TpeerId}'
    [Teardown]    Close Application

test_16ChagneResolutionFrameRate
    [Tags]    changeSetting
    [Setup]    OpenApp
    ClickSetting
    sleep    3
    ${Resolution}    Set Variable    1920 x 1080
    ${FrameRate}    Set Variable    25p
    ${res_}    Set Variable    1080P25
    ${isOn}    Set Variable    ON
    log    "设置resolution:${Resolution}，Framerate:${FrameRate} and hevc"
    ChangeResolutionandFrameRate    ${Resolution}    ${FrameRate}    ${isOn}
    sleep    10
    #select R
    SelectR    %{U_APP_OFFLINE_Rname}
    sleep    2
    StartStopLive
    sleep    5
    ${isLive}    IsLive    %{U_APP_OFFLINE_Rname}    ${res_}
    should be equal    ${isLive}    1
    #重新设置默认配置
    sleep    2
    #stop Live
    StartStopLive
    sleep    3
    log    "恢复默认配置“
    ClickSetting
    sleep    2
    ChangeResolutionandFrameRate    %{U_APP_Resolution}    %{U_APP_Framerate}    %{U_APP_HEVC}
    [Teardown]    Close Application
