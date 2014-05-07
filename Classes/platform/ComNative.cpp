#include "CCNative.h"
#include "cocos2d.h"
#include <stdlib.h>
using namespace cocos2d;
using namespace std;

void setScriptTouchPriority(CCLayer *lay, int pri){
    CCLog("setScriptTouchPriority %d", pri);
    CCTouchScriptHandlerEntry *st = lay->getScriptTouchHandlerEntry();
    st->setPriority(pri);
    CCLog("priority %d %d", st->getPriority(), st->getSwallowsTouches());
    /*
    lay->retain();
    CCNode *par = lay->getParent();
    lay->removeFromParent();
    par->addChild(lay);
    lay->release();
    */
    lay->setTouchPriority(pri);
}

string getFileData(const char *fname) {
    unsigned long size;
    unsigned char *con = CCFileUtils::sharedFileUtils()->getFileData(fname, "r", &size);
    string str((char*)con, size);
    //删除返回的文件数据
    delete [] con;
    return str;
}
void pauseAction(CCNode *n) {
    
}

void setTextureRect(CCSprite *sp, CCRect rect, bool rotated, CCSize size) {
    sp->setTextureRect(rect, rotated, size);
}
void enableShadow(CCLabelTTF *lab, CCSize sz, float so, float sb, bool up, int r, int g, int b) {
    CCLog("enableShadow %d %d %d", r, g, b);
    lab->enableShadow(sz, so, sb, up);//, r, g, b
}
void setFontFillColor(CCLabelTTF *lab, ccColor3B c, bool u) {
    lab->setFontFillColor(c, u);
}
static unsigned int seed = 0;
void setSeed(int s) {
    seed = (unsigned int)s;
}
int myRand(int a, int b)  {
    unsigned int v = ((seed*1103515245)+12345)&0x7fffffff;
    unsigned int res = v*((unsigned int)b-(unsigned int)a)/0x7fffffff+a;
    return res;
}

