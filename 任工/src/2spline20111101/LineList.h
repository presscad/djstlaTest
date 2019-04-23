#pragma once
#include "gepnt2d.h"
//环状链表
//节点
struct stLine {
	AcGePoint2d ptSt;
	AcGePoint2d ptEnd;
};
struct stLineNode {
	struct stLine Line;			//存放多段线节点的坐标值
    struct stLineNode *rbprev;	//存放上一个结点的地址
    struct stLineNode *rbnext;	//存放下一个结点的地址
};
//算法类
class CLineList
{
public:
	CLineList(void);
	~CLineList(void);
private:
	struct stLineNode *m_head;
	int m_count;
public:
	int setCount(int count);
	struct stLineNode * addHead(struct stLine& aline);
	struct stLineNode * setHead(struct stLineNode* anode);
	struct stLineNode* insertAfter(struct stLineNode* anode, struct stLine& aline);
	struct stLineNode * getHead();
	struct stLineNode * getNext(struct stLineNode *anode);
	struct stLineNode * getTail();
	struct stLineNode* delNode(struct stLineNode* anode);
	int getCirList(int icnt,struct stLineNode* pos1,struct stLineNode* pos4,CLineList * &pcir1,CLineList * & pcir2);
	struct stLineNode * getPrev(struct stLineNode * anode);
	int getCount(void);
};
