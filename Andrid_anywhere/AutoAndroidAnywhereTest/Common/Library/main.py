import os
import sys

class main:
    def create_log_path(self, case=None, outputdir=None):
        '''Create Case log Directory
        Usage: | Create Log Path | caseName | outputDir |
        '''
        G_TEST_PATH = str(outputdir)
        g_log = os.getenv('G_LOG')
        print '=' * 100
        print G_TEST_PATH
        print '=' * 100
        # Window code
        base = 'D:\\COM_DOC\\robotframwork'
        print 'runas /user:administrator rd /Q ' + '"' + os.path.join(base, 'logs', 'current') + '"'
        os.system('runas /user:administrator rd /Q ' + '"' + os.path.join(base, 'logs', 'current') + '"')
        print 'runas /user:administrator mklink /D ' + '"' + os.path.join(base, 'logs', 'current') + '"' + ' ' + '"' + G_TEST_PATH + '"'
        os.system('runas /user:administrator mklink /D ' + '"' + os.path.join(base, 'logs', 'current') + '"' + ' ' + '"' + G_TEST_PATH + '"')
        #
        if case:
            case_name = str(case).replace(' ', '_')
            print 'case_name:' + case_name
            G_CASE_LOG_PATH = os.path.join(G_TEST_PATH, case_name)
            print 'G_CASE_LOG_PATH:' + G_CASE_LOG_PATH
            if not os.path.exists(G_CASE_LOG_PATH):
                os.makedirs(G_CASE_LOG_PATH)
                os.environ['G_CURRENTLOG'] = str(G_CASE_LOG_PATH)
                print 'G_CURRENTLOG:' + os.getenv('G_CURRENTLOG')
            else:
                print 'AT_ERROR : Create Log File FAIL!'
                print 'AT_ERROR : ' + G_CASE_LOG_PATH + ' has exist!'
        else:
            print 'AT_ERROR : Create Log File FAIL!'
            print 'AT_ERROR : ' + case + ' NOT Exist!'

#linux: login as root
#linux path: /root/robotframework/logs
#linux code
#        base = os.path.expanduser('~')
#        os.system('rm -rf ' + os.path.join(base, 'robotframework/logs', 'current'))
#        os.system("ln -s " + G_TEST_PATH + ' ' + os.path.join(base, 'robotframework/logs', 'current'))

#MAC OS: login as admin
#MAC OS path: /Users/admin/robotframework/logs
#MAC OS code
#        base = os.path.expanduser('~')
#        os.system('rm -rf ' + os.path.join(base, 'robotframework/logs', 'current'))
#        os.system("ln -s " + os.path.join(base, 'robotframework/logs', 'current') + ' ' + G_TEST_PATH)

if __name__=="__main__":
    case_name="test_01_install_uninstall_app"
    outputdir="D:\\COM_DOC\\robotframwork\logs\\20200107_133001"
    x=main()
    x.create_log_path(case_name,outputdir)
