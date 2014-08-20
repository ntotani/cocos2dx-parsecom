#include "AppDelegate.h"
#include "CCLuaEngine.h"
#include "SimpleAudioEngine.h"
#include "cocos2d.h"
#include "Runtime.h"
#include "ConfigParser.h"
#include "PluginManager.h"
#include "ProtocolUser.h"

using namespace CocosDenshion;
using namespace plugin;

USING_NS_CC;
using namespace std;

class ParseListener : public UserActionListener
{
    void onActionResult(ProtocolUser* pPlugin, UserActionResultCode code, const char* msg)
    {
        if (code == UserActionResultCode::kLoginSucceed) {
            log("parse login succeed: %s", msg);
        }
    }
};
static ParseListener s_parseListener;

int login_glue(lua_State *L)
{
    auto parse = dynamic_cast<ProtocolUser*>(PluginManager::getInstance()->loadPlugin("UserParse"));
    if (!parse->isLogined()) {
        parse->login();
    }
    return 0;
}

AppDelegate::AppDelegate()
{
}

AppDelegate::~AppDelegate()
{
    SimpleAudioEngine::end();
}

bool AppDelegate::applicationDidFinishLaunching()
{
    
#if (COCOS2D_DEBUG>0)
    initRuntime();
#endif
    
    if (!ConfigParser::getInstance()->isInit()) {
            ConfigParser::getInstance()->readConfig();
        }

    // initialize director
    auto director = Director::getInstance();
    auto glview = director->getOpenGLView();    
    if(!glview) {
        Size viewSize = ConfigParser::getInstance()->getInitViewSize();
        string title = ConfigParser::getInstance()->getInitViewName();
#if (CC_TARGET_PLATFORM == CC_PLATFORM_WIN32 || CC_TARGET_PLATFORM == CC_PLATFORM_MAC)
        extern void createSimulator(const char* viewName, float width, float height,bool isLandscape = true, float frameZoomFactor = 1.0f);
        bool isLanscape = ConfigParser::getInstance()->isLanscape();
        createSimulator(title.c_str(),viewSize.width,viewSize.height,isLanscape);
#else
        glview = GLView::createWithRect(title.c_str(), Rect(0,0,viewSize.width,viewSize.height));
        director->setOpenGLView(glview);
#endif
    }

   
    // set FPS. the default value is 1.0/60 if you don't call this
    director->setAnimationInterval(1.0 / 60);

    auto parse = dynamic_cast<ProtocolUser*>(PluginManager::getInstance()->loadPlugin("UserParse"));
    parse->setDebugMode(true);
    TUserDeveloperInfo devInfo;
    devInfo["ApplicationID"] = "your_app_id";
    devInfo["ClientKey"] = "your_client_key";
    devInfo["TwitterConsumerKey"] = "your_consumer_key";
    devInfo["TwitterConsumerSecret"] = "your_consumer_secret";
    parse->configDeveloperInfo(devInfo);
    parse->setActionListener(&s_parseListener);

    auto engine = LuaEngine::getInstance();
    ScriptEngineManager::getInstance()->setScriptEngine(engine);

    LuaStack* stack = engine->getLuaStack();
    stack->setXXTEAKeyAndSign("2dxLua", strlen("2dxLua"), "XXTEA", strlen("XXTEA"));
    
    //register custom function
    lua_register(stack->getLuaState(), "login", login_glue);
    
#if (COCOS2D_DEBUG>0)
    if (startRuntime())
        return true;
#endif

    engine->executeScriptFile(ConfigParser::getInstance()->getEntryFile().c_str());
    return true;
}

// This function will be called when the app is inactive. When comes a phone call,it's be invoked too
void AppDelegate::applicationDidEnterBackground()
{
    Director::getInstance()->stopAnimation();

    SimpleAudioEngine::getInstance()->pauseBackgroundMusic();
}

// this function will be called when the app is active again
void AppDelegate::applicationWillEnterForeground()
{
    Director::getInstance()->startAnimation();

    SimpleAudioEngine::getInstance()->resumeBackgroundMusic();
}

