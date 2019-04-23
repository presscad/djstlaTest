#pragma once
#include "gepnt2d.h"
//��״����
//�ڵ�
struct stLine {
	AcGePoint2d ptSt;
	AcGePoint2d ptEnd;
};
struct stLineNode {
	struct stLine Line;			//��Ŷ���߽ڵ������ֵ
    struct stLineNode *rbprev;	//�����һ�����ĵ�ַ
    struct stLineNode *rbnext;	//�����һ�����ĵ�ַ
};
//�㷨��
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
