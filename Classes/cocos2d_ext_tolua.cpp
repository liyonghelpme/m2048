#include "cocos2d_ext_tolua.h"
#include "tolua_fix.h"

#include "cocos2d.h"
#include "CCLuaEngine.h"
#include "cocos2d_ext.h"
#include "platform/CCNative.h"
#include "MyPlugins.h"

using namespace cocos2d;
using namespace cocos2d::extension;



#ifndef TOLUA_DISABLE_tolua_Cocos2d_setScriptTouchPriority00
static int tolua_Cocos2d_setScriptTouchPriority00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
	tolua_Error tolua_err;
	if (
        !tolua_isusertype(tolua_S,1,"CCLayer",0,&tolua_err) ||
		!tolua_isnumber(tolua_S,2,0,&tolua_err) ||
		!tolua_isnoobj(tolua_S,3,&tolua_err)
	)
	 goto tolua_lerror;
	else
#endif
	{
        CCLayer *lay = (CCLayer*) tolua_tousertype(tolua_S, 1, 0);
        int pri = (int)tolua_tonumber(tolua_S, 2, 0);
        setScriptTouchPriority(lay, pri);
	}
	return 0;
#ifndef TOLUA_RELEASE
     tolua_lerror:
     tolua_error(tolua_S,"#ferror in function 'setScriptTouchPriority'", &tolua_err);
     return 0;
#endif
}
#endif


/* method: getInstance of class  MyPlugins */
#ifndef TOLUA_DISABLE_tolua_Cocos2dExt_MyPlugins_getInstance00
static int tolua_Cocos2dExt_MyPlugins_getInstance00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"MyPlugins",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  {
   MyPlugins* tolua_ret = (MyPlugins*)  MyPlugins::getInstance();
    tolua_pushusertype(tolua_S,(void*)tolua_ret,"MyPlugins");
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'getInstance'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE



/* method: sendCmd of class  MyPlugins */
#ifndef TOLUA_DISABLE_tolua_Cocos2dExt_MyPlugins_sendCmd00
static int tolua_Cocos2dExt_MyPlugins_sendCmd00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"MyPlugins",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isstring(tolua_S,3,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,4,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  MyPlugins* self = (MyPlugins*)  tolua_tousertype(tolua_S,1,0);
  const char* cmd = ((const char*)  tolua_tostring(tolua_S,2,0));
  const char* arg = ((const char*)  tolua_tostring(tolua_S,3,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'sendCmd'", NULL);
#endif
  {
   self->sendCmd(cmd, arg);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'sendCmd'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE




TOLUA_API int tolua_ext_reg_types(lua_State* tolua_S)
{

 tolua_usertype(tolua_S,"MyPlugins");
 return 1;
}

TOLUA_API int tolua_ext_reg_modules(lua_State* tolua_S)
{
  tolua_function(tolua_S,"setScriptTouchPriority", tolua_Cocos2d_setScriptTouchPriority00);

  tolua_cclass(tolua_S,"MyPlugins","MyPlugins","",NULL);
  tolua_beginmodule(tolua_S,"MyPlugins");
   tolua_function(tolua_S,"getInstance",tolua_Cocos2dExt_MyPlugins_getInstance00);
   tolua_function(tolua_S,"sendCmd",tolua_Cocos2dExt_MyPlugins_sendCmd00);
  tolua_endmodule(tolua_S);
  return 1;
}
//打开状态
//注册类型

//使用全局的module 模块
//注册模块
int tolua_MyExt_open(lua_State *tolua_S) {
    tolua_open(tolua_S);
    tolua_ext_reg_types(tolua_S);
    tolua_module(tolua_S, NULL, 0);
    tolua_beginmodule(tolua_S, NULL);
    tolua_ext_reg_modules(tolua_S);
    tolua_endmodule(tolua_S);
	return 1;
}
