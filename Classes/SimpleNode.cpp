#include "SimpleNode.h"

SimpleNode *SimpleNode::create() {
    auto p = new SimpleNode();
    p.cX = 1;
    p.cY = 1;
    p.kX = 0;
    p.kY = 0;
}
void SimpleNode::setMat(float cx, float cy, float kx, float ky) {
    cX = cx;
    cY = cy;
    kX = kx;
    kY = ky;
}
