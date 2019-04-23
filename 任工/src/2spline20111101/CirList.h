#pragma once

//环状链表
//节点
struct stNode {
	AcGePoint2d Point;	//存放多段线节点的坐标值
    struct stNode *rbprev;	//存放上一个结点的地址
    struct stNode *rbnext;	//存放下一个结点的地址
};
//算法类
class CCirList
{
public:
	CCirList(void);
	~CCirList(void);
private:
	struct stNode *m_head;
	int m_count;
public:
	int setCount(int count);
	struct stNode * addHead(AcGePoint2d& pt);
	struct stNode * setHead(struct stNode* anode);
	int getCirList(int icnt,struct stNode* pos1,struct stNode* pos2,CCirList * &pcir1,CCirList * & pcir2);
	struct stNode* insertAfter(struct stNode* anode, AcGePoint2d & pt);
	struct stNode* insertAfter(struct stNode* anode, CCirList *pCirList);
	struct stNode * getHead();
	struct stNode * getNext(struct stNode *anode);
	struct stNode * getPrev(struct stNode * anode);
	struct stNode * getTail();
	struct stNode* delNode(struct stNode *anode);
	int getCount(void);
};
