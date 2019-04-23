#include "linelist.h"

CLineList::CLineList(void)
: m_head(0),m_count(0)
{
}

CLineList::~CLineList(void)
{
	struct stLineNode *pos,*tmpNode;
	pos=m_head;
	for(int i=0;i<m_count;i++){
		tmpNode=pos->rbnext;
		delete pos;
		pos=tmpNode;
	}
}
struct stLineNode * CLineList::getHead()
{
	return m_head;
}
struct stLineNode * CLineList::getNext(struct stLineNode *anode)
{
	if(anode==NULL)
		return NULL;
	else
		return anode->rbnext;
}
struct stLineNode * CLineList::getTail()
{
	struct stLineNode* pos=NULL;
	if(m_head!=NULL){
		pos=m_head->rbprev;
	}
	return pos;
}
struct stLineNode * CLineList::setHead(struct stLineNode* anode)
{
	if(anode==NULL){
		return NULL;
	}
	m_head=anode;
	return m_head;
}
//截断,构造环
int CLineList::getCirList(int icnt,struct stLineNode* pos1,struct stLineNode* pos4,CLineList * &pcir1,CLineList * & pcir2)
{
	if(pos1==NULL || pos4==NULL){
		return NULL;
	}
	//pos1,pos2,pos3,pos4;
	struct stLineNode* pos2,*pos3;
	pos2=pos4->rbprev;
	pos3=pos1->rbnext;

	//pcirlist 1
	pcir1->setHead(pos3);
	pos3->rbprev=pos2;
	pos2->rbnext=pos3;
	pcir1->setCount(icnt);
	//pcirlist 2
	struct stLineNode* pos0,*pos5;
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
struct stLineNode * CLineList::addHead(struct stLine& aline)
{
	if(m_head!=NULL){
		return NULL;
	}
	m_head= new stLineNode;
	m_head->Line.ptSt=aline.ptSt;
	m_head->Line.ptEnd=aline.ptEnd;

	m_head->rbnext=m_head; //环形链表
	m_head->rbprev=m_head;
	m_count=1;
	return m_head;
}

struct stLineNode* CLineList::insertAfter(struct stLineNode* anode, struct stLine& aline)
{
	if(anode==NULL){
		return addHead(aline);
	}
	struct stLineNode *bnode= new stLineNode;

	bnode->Line.ptSt=aline.ptSt;
	bnode->Line.ptEnd=aline.ptEnd;
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

struct stLineNode* CLineList::delNode(struct stLineNode* anode)
{
	struct stLineNode *ret;
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
int CLineList::setCount(int icnt)
{
	m_count=icnt;
	return 0;
}
int CLineList::getCount(void)
{
	return m_count;
}

struct stLineNode * CLineList::getPrev(struct stLineNode * anode)
{
	return anode->rbprev;
}
