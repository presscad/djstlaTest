#include "StdAfx.h"
#include "cirlist.h"

CCirList::CCirList(void)
: m_head(0),m_count(0)
{
}

CCirList::~CCirList(void)
{
	struct stNode *pos,*tmpNode;
	pos=m_head;
	for(int i=0;i<m_count;i++){
		tmpNode=pos->rbnext;
		delete pos;
		pos=tmpNode;
	}
}
struct stNode * CCirList::getHead()
{
	return m_head;
}
struct stNode * CCirList::getNext(struct stNode *anode)
{
	return anode->rbnext;
}
struct stNode * CCirList::getTail()
{
	struct stNode* pos=NULL;
	if(m_head!=NULL){
		pos=m_head->rbprev;
	}
	return pos;
}
struct stNode * CCirList::setHead(struct stNode* anode)
{
	if(anode==NULL){
		return NULL;
	}
	m_head=anode;
	return m_head;
}
//截断,构造环
int CCirList::getCirList(int icnt,struct stNode* pos1,struct stNode* pos4,CCirList * &pcir1,CCirList * & pcir2)
{
	if(pos1==NULL || pos4==NULL){
		return NULL;
	}
	//pos1,pos2,pos3,pos4;
	struct stNode* pos2,*pos3;
	pos2=pos4->rbprev;
	pos3=pos1->rbnext;

	//pcirlist 1
	pcir1->setHead(pos3);
	pos3->rbprev=pos2;
	pos2->rbnext=pos3;
	pcir1->setCount(icnt);
	//pcirlist 2
	struct stNode* pos0,*pos5;
	pos5=pos4->rbprev;
	pos0=pos1->rbprev;
	pcir2->setHead(pos5);
	pos5->rbprev=pos0;
	pos0->rbnext=pos5;
	delNode(pos1);
	delNode(pos4);
	pcir2->setCount(m_count-icnt-2);
	m_count=0;
	return 0;
}
struct stNode * CCirList::addHead(AcGePoint2d& pt)
{
	if(m_head!=NULL){
		return NULL;
	}
	m_head= new stNode;
	m_head->Point=pt;
	m_head->rbnext=m_head;
	m_head->rbprev=m_head; //环形链表
	m_count=1;
	return m_head;
}

struct stNode* CCirList::insertAfter(struct stNode* anode, AcGePoint2d & pt)
{
	if(anode==NULL){
		return NULL;
	}
	struct stNode *bnode= new stNode;

	bnode->Point=pt;
	bnode->rbprev=anode;
	bnode->rbnext=anode->rbnext;

	//update next node 
	if(anode->rbnext!=NULL){
		anode->rbnext->rbprev=bnode;
	}
	//update prev node
	anode->rbnext=bnode;

	//update count
	m_count++;
	return bnode;
}

struct stNode* CCirList::delNode(struct stNode* anode)
{
	struct stNode *ret;
	if(anode==NULL){
		return NULL;
	}
	//后一结点
	anode->rbnext->rbprev=anode->rbprev;
	//前一结点
	anode->rbprev->rbnext=anode->rbnext;
	ret=anode->rbnext;
	//处理anode
	delete anode;
	m_count--;
	return ret;
}
struct stNode* CCirList::insertAfter(struct stNode* anode, CCirList *pCirList)
{
	if(anode==NULL){
		return NULL;
	}
	struct stNode *pNodePrev=anode->rbprev;
	struct stNode *pNodeNext=anode->rbnext;
	struct stNode *pHead=pCirList->getHead();
	struct stNode *pTail=pCirList->getTail();
	pHead->rbprev=anode;
	pTail->rbnext=pNodeNext;
	anode->rbnext=pHead;
	if(pNodeNext!=NULL){
		pNodeNext->rbprev=pTail;
	}
	m_count+=pCirList->getCount();
	pCirList->setCount(0);
	return anode;
}

int CCirList::setCount(int icnt)
{
	m_count=icnt;
	return 0;
}
int CCirList::getCount(void)
{
	return m_count;
}

struct stNode * CCirList::getPrev(struct stNode * anode)
{
	return anode->rbprev;
}
