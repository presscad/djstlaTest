#pragma once

//��״����
//�ڵ�
struct stNode {
	AcGePoint2d Point;	//��Ŷ���߽ڵ������ֵ
    struct stNode *rbprev;	//�����һ�����ĵ�ַ
    struct stNode *rbnext;	//�����һ�����ĵ�ַ
};
//�㷨��
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
