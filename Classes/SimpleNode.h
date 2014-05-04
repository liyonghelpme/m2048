#ifndef __SIM_NODE_H__
#define __SIM_NODE_H__
#include "cocos2d.h"
using namespace cocos2d;

class SimpleNode : public CCNode {
public:
    void setMat(float cx, float cy, float kx, float ky);
    virtual void visit();
    SimpleNode *create();


    float cX, cY, kX, kY;
};
#endif
