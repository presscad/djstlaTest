#include "StdAfx.h"
#include "cirlist.h"
#include "linelist.h"
#include <time.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/timeb.h>
#include <string.h>
#include "string"
//#include "allcmddialog.h"
#include "mydialog.h"
#include "resource.h"
#include "cirlist.h"
#include <queue>
#include <stack>
#include "EntDisplay.h"
//#include "Text2line.h"
#include "EL2PL.h"
#include "func.h"

typedef AcArray<AcDbPolyline*> AcDbPolylinePtrArray;
typedef AcArray<CCirList*> CCirListPtrArray;
typedef AcArray<CLineList*> CLineListPtrArray;
typedef AcArray<struct stLineNode*> CLinePtrArray;
typedef AcArray<AcDbEntity *> AcDbEntityArray;

std::queue <char *> qlog;

CEL2PL *pEl2pl;
CEntDisplay *pEntDisplay;
double m_pi,m_twopi;
int m_islog=0;
char sprint_buf1[4096]={0};
int mypower(int value,int y)
{
	int iRet=1;
	for (int i=0;i<y;i++){
		iRet=iRet*value;
	}
	return iRet;
}
double myaverage(double v1,double v2)
{
	return (v1+v2)/2;
}
int myprintf(char *fmt, ...)
{
	if(m_islog){
		return 1;
	}
	va_list args;
	int n;
	va_start(args, fmt);
	n = vsprintf(sprint_buf1, fmt, args);
	va_end(args);
	int isize=strlen(sprint_buf1)+1;

	char *pbuf=(char *)malloc(isize);
	memcpy(pbuf,sprint_buf1,isize);

	qlog.push(pbuf);
	return n;
}
int mysynclog(void)
{
	if(m_islog){
		return 1;
	}
	FILE *stream;
	/* Open for write */
	if( (stream = fopen( "c:\\test.log", "a+" )) == NULL )
		acutPrintf( "The file 'c:\\test.log' was not opened\n" );
	char *pbuf;
	while (!qlog.empty()){
		pbuf=qlog.front();  qlog.pop();
		fprintf(stream,"%s",pbuf);
		free(pbuf);
	}
	/* Close stream */
	if( fclose( stream ) )
		acutPrintf( "The file 'c:\\test.log' was not closed\n" );
	return 0;
}
int setMylog(int value)
{
	m_islog=value;
	return 0;
}
int mylogclean(void)
{
	if(m_islog){
		return 1;
	}
	FILE *stream;
	/* Open for write */
	if( (stream = fopen( "c:\\test.log", "w" )) == NULL )
		acutPrintf( "The file 'c:\\test.log' was not opened\n" );
	fprintf(stream,"");
	/* Close stream */
	if( fclose( stream ) )
		acutPrintf( "The file 'c:\\test.log' was not closed\n" );
	return 0;
}
int logtime(char *msg)
{
	char tmpbuf[128];
	struct tm *today;
	_tzset();
    _strtime( tmpbuf );
    myprintf( "%s:\t%s\n",msg, tmpbuf );
	return 0;
}
double angle2radian(double angle)
{
	return angle*m_pi/180;
}
double findMax (int n, double amount, ...) 
{ 
	double val,greater; 
	va_list vl;

	va_start(vl,n); 
	greater=va_arg(vl,double); 
	for (int i=1;i<n;i++) { 
		val=va_arg(vl,double);
		greater=(greater>val)?greater:val; 
	} 
	va_end(vl); 
	return greater; 
}
double findMin ( int n,double amount, ...) 
{ 
	double val,greater; 
	va_list vl;

	va_start(vl,n); 
	greater=va_arg(vl,double); 
	for (int i=1;i<n;i++) { 
		val=va_arg(vl,double);
		greater=(greater<val)?greater:val; 
	} 
	va_end(vl); 
	return greater; 
}
 
int initStarmask()
{
	m_pi=atan(1.0) * 4.0;
	m_twopi=atan(1.0)*8.0;
	mylogclean();
	pEl2pl=new CEL2PL();
	pEntDisplay=new CEntDisplay();
	return GOOD;
}
int unloadStarmask()
{
	delete pEl2pl;
	delete pEntDisplay;
	return GOOD;
}
int starEl2Pl()
{
	pEl2pl->starEL2PL();
	return GOOD;
}
int starSpl2Pl()
{
	pEl2pl->starSPL2PL();
	return GOOD;
}
int starDumpEnt(){
	pEntDisplay->starDisplay();
	return GOOD;
}

int getLayers(CStringArray & LayerNames)
{
	Acad::ErrorStatus	es;
	AcDbLayerTable*		pLayerTable;
    AcDbObjectIdArray layerId;
    int nLayerCount = 0;

	es = acdbHostApplicationServices()->workingDatabase()->getSymbolTable(pLayerTable, AcDb::kForRead);
	assert(es == Acad::eOk);
	AcDbLayerTableIterator* pLayerIterator;
	if ((es = pLayerTable->newIterator(pLayerIterator, Adesk::kTrue, Adesk::kTrue)) != Acad::eOk)
		return 0;

	AcDbObjectId id;
	AcDbLayerTableRecord* pLayer;
	const char* pName;
	while (!pLayerIterator->done()) {
		if ((es = pLayerIterator->getRecordId(id)) == Acad::eOk) {
			if (acdbOpenAcDbObject((AcDbObject*&)pLayer, id, AcDb::kForRead) == Acad::eOk) {
				if (pLayer->getName(pName) == Acad::eOk) {
					ads_printf("pName: %s\n",pName);
					LayerNames.Add(pName);
				}
				pLayer->close();
			}
		}
		pLayerIterator->step();
	}
	pLayerTable->close();
	delete pLayerIterator;
	return 0;
}

Acad::ErrorStatus postToDatabase(AcDbEntity* ent , AcDbObjectId& objId)
{
	Acad::ErrorStatus	  es;
	AcDbBlockTable*		pBlockTable;
	AcDbBlockTableRecord*  pSpaceRecord;
	es = acdbHostApplicationServices()->workingDatabase()->getSymbolTable(pBlockTable, AcDb::kForRead);
	assert(es == Acad::eOk);
	es = pBlockTable->getAt(ACDB_MODEL_SPACE, pSpaceRecord, AcDb::kForWrite);
	assert(es == Acad::eOk);
	es = pBlockTable->close();
	assert(es == Acad::eOk);
	es = pSpaceRecord->appendAcDbEntity(objId, ent);
	assert(es == Acad::eOk);
	//es = ent->close();
	//assert(es == Acad::eOk);
	es = pSpaceRecord->close();
	assert(es == Acad::eOk);
	return es;
}

void drawLine(AcGePoint2d& pt1,AcGePoint2d& pt2)
{
	AcDbObjectId custOID;
	AcDbLine* pEnt = new AcDbLine;
	pEnt->setStartPoint(AcGePoint3d(pt1.x,pt1.y,0));
	pEnt->setEndPoint(AcGePoint3d(pt2.x,pt2.y,0));
	pEnt->setColorIndex(1);
	postToDatabase(pEnt,custOID);
	pEnt->close();
}
void drawPoint(AcGePoint3d & pt)
{
	AcDbObjectId custOID;
	AcDbPoint* pEnt = new AcDbPoint();
	pEnt->setPosition(pt);
	postToDatabase(pEnt,custOID);
	pEnt->close();
}


int getArcBulge(AcGePoint2d& pt1,AcGePoint2d& pt2,AcGePoint2d& pt3,double & dBugle)
{
	//计算Bugle
	AcGeCircArc2d pGArc(pt1,pt2,pt3);
	//椭圆不用判断(3点在直线上)
	double endAngle,startAngle,dAngle;
	startAngle=pGArc.startAng();
	endAngle=pGArc.endAng();
	if (endAngle<startAngle) endAngle += m_pi*2; // 8*atan(1.0);
	dAngle=endAngle-startAngle;
	dBugle=tan(dAngle/4);
	if(pGArc.isClockWise()) dBugle = -dBugle;
	return GOOD;
}
int starText2Pline()
{
	pEl2pl->starText2PL();
	return 0;
}
int starWidenArc()
{
	pEl2pl->starWidenArc();
	return 0;
}

struct resbuf * entitem(struct resbuf *textent,short irestype)
{
    int rt, i;
    char buf[133];
	struct resbuf *pRb=textent;

    for (i = 0;pRb != NULL;i++, pRb = pRb->rbnext) {
		if(pRb->restype==irestype){
			return pRb;
		}
	}
	return NULL;
}


int starPolarArrayText()
{
	double dRadius=50;
	double startAng=90;
	double dangle,rotatn;
	double N=0;
	double dheight=0.5;
	char buf[512];
	ads_point cpt;
	acedGetPoint(NULL,"\n请指定环的圆心:",cpt);
	acedGetReal("\n请输入环的半径:",&dRadius);
	acedGetReal("\n请输入字高:",&dheight);

	struct resbuf rbVar;	
	rbVar.restype=RTSHORT;
	rbVar.resval.rint=0;
	if ( RTNORM != acedSetVar("cmdecho", &rbVar))
	{
		acutPrintf("setvar cmdecho 0 fail!");// return 1;
	}
	rbVar.restype=RTSHORT;
	rbVar.resval.rint=1;
	if ( RTNORM != acedSetVar("MIRRTEXT", &rbVar))
	{
		acutPrintf("setvar cmdecho 0 fail!");// return 1;
	}

	AcGePoint3d ptLoc;
	AcDbText *pText;
	ptLoc.z=0;
	AcDbObjectId objId;
	ads_name ss1;
	ads_point m_ptTextLeft,m_ptTextRight;
	struct resbuf *ebuf, *eb;
	ads_point cpt1,cpt2,cpt3,cpt4; //cpt1 cpt4mirror点
	for(int i=0;i<360;i++){
		pText=new AcDbText;
		dangle= (i+startAng)*m_pi/180;
		cpt1[0]=dRadius*cos(dangle);
		cpt1[1]=dRadius*sin(dangle);
		ptLoc.x=cpt1[0];
		ptLoc.y=cpt1[1];		
		pText->setPosition(ptLoc);
		pText->setHeight(dheight);
		pText->setRotation(i*m_pi/180);
		sprintf(buf,"%d",i);
		pText->setTextString(buf);
		postToDatabase(pText,objId);
		pText->close();

		//objId=pText->objectId();
		struct resbuf *textent, *tent;
		ads_point origin,lowleft, upright;
		ads_name last;
		if(acdbEntLast(last)!=RTNORM){
			acutPrintf("entlast failed!\n");
			return 1;
		}
		//if(acdbGetAdsName(ss1,objId)== Acad::eOk)
		{
			textent = acdbEntGet(last);
			if (textent == NULL)
			{
				acdbFail("Couldn't retrieve Text entity\n");
				return BAD;
			}
			tent = entItem(textent,10);
			if(tent!=NULL){
				origin[X] = tent->resval.rpoint[X];
				//ECS coordinates
				origin[Y] = tent->resval.rpoint[Y];
			}
			tent = entItem(textent, 50);
			if(tent!=NULL){
				rotatn = tent->resval.rreal;
			}
			if (acedTextBox(textent, lowleft, upright) != RTNORM)
			{
				acdbFail("Couldn't retrieve text box coordinates\n");
				acutRelRb(textent);
				return BAD;
			}
			acutRelRb(textent);
			//myprintf("box:%.4f,%.4f %.4f,%.4f\n",lowleft[X],lowleft[Y],upright[X],upright[Y]);
			//myprintf("org: %.4f,%.4f %.5f\n",origin[X],origin[Y],rotatn);
			AcGePoint2d pt1,pt2,pt3,pt4;
			pt1.x = origin[X] + lowleft[X];
			pt1.y = origin[Y] + lowleft[Y];
			pt2.x = origin[X] + upright[X];
			pt2.y = origin[Y] + lowleft[Y];
			pt3.x = origin[X] + upright[X];
			pt3.y = origin[Y] + upright[Y];
			pt4.x = origin[X] + lowleft[X];
			pt4.y = origin[Y] + upright[Y];
			pt1.rotateBy(rotatn,asPnt2d(origin));	
			pt2.rotateBy(rotatn,asPnt2d(origin));
			pt3.rotateBy(rotatn,asPnt2d(origin));	
			pt4.rotateBy(rotatn,asPnt2d(origin));
			//myprintf("%d %.5f,%.5f %.5f,%.5f \n",i,pt1.x,pt1.y,pt3.x,pt3.y);
			//acdbInters(asDblArray(pt1),asDblArray(pt3),asDblArray(pt2),asDblArray(pt4),FALSE,cpt1); //交点
			 double Dist=acutDistance(asDblArray(pt1),asDblArray(pt3)); //距离
			dangle = acutAngle(asDblArray(pt1),asDblArray(pt3));  //角度
			acutPolar(asDblArray(pt1),dangle,Dist/2,cpt2);
			//Dist=acutDistance(cpt1,cpt2); //距离
			//dangle=acutAngle(cpt1,cpt2);  //角度
			acutPolar(cpt1,dangle,-Dist/2,cpt3);
			acutPolar(cpt1,rotatn,1.0,cpt4);
			acedCommand(RTSTR,"move",RTENAME,last,RTSTR,"",RTPOINT,cpt1, RTPOINT,cpt3, 0);
			//myprintf("%d cpt1,2 %.5f,%.5f %.5f,%.5f\n",i,cpt1[0],cpt1[1],cpt2[0],cpt2[1]);
			//myprintf("cpt3,4 %.5f,%.5f %.5f,%.5f\n",cpt3[0],cpt3[1],cpt4[0],cpt4[1]);
		}
		int retCmd=acedCommand(RTSTR,"mirror",RTENAME,last,RTSTR,"",RTPOINT,cpt1, RTPOINT,cpt4,  RTSTR,"y",0);
	}
	
	rbVar.restype=RTSHORT;
	rbVar.resval.rint=0;
	if ( RTNORM != acedSetVar("MIRRTEXT", &rbVar))
	{
		acutPrintf("setvar cmdecho 0 fail!");// return 1;
	}

	rbVar.restype=RTSHORT;
	rbVar.resval.rint=1;
	if ( RTNORM != acedSetVar("cmdecho", &rbVar))
	{
		acutPrintf("setvar cmdecho 0 fail!");// return 1;
	}
	mysynclog();
	return 0;
}
int starDelWmfBlk()
{
	pEl2pl->purgeBlockRef();
	return 0;
}

char getKWord(char *key,char *msg)
{
	unsigned char ret=0;
	struct resbuf *callist, *pRb, *results = NULL;
	callist = acutBuildList(RTSTR, "C:tmpGetKW",RTSTR,key,RTSTR,msg, 0);
	if(callist!=NULL){
		if (acedInvoke(callist, &results) == RTERROR)
			acdbFail("Cannot run -- 请加载starmask1.lsp\n"); 
		else{
			if (results != NULL) {
				pRb=results;
				if(pRb->restype==RTSTR){
					ret=pRb->resval.rstring[0];
				}else if(pRb->restype==RTNIL){
					ret=' ';
				}
				acutRelRb(results);
			}
		}
	}
	acutRelRb(callist);
	return ret;
}
int getSelect()
{
	int iSel=0;
	struct resbuf *callist, *pRb, *results = NULL;
	callist = acutBuildList(RTSTR, "C:tmpGetKW",
		RTSTR,"S O",
		RTSTR,"Select Objects手选/One Layer单层/<All Layer所有层>:", 0);
	if(callist!=NULL){
		if (acedInvoke(callist, &results) == RTERROR){
			acdbFail("Cannot run -- 请加载starmask1.lsp\n"); 
			iSel=0;
		}
		else{
			if (results != NULL) {
				pRb=results;
				if(pRb->restype==RTSTR){
					switch (pRb->resval.rstring[0])
					{
					case 'S': iSel=1;break;
					case 'O': iSel=2;break;
					}
				}else if(pRb->restype==RTNIL){
					iSel=3;
				}else{
					iSel=0;
				}
				acutRelRb(results);
			}
		}
	}
	acutRelRb(callist);
	return iSel;
}
//交换排序法
int sortEnts(AcDbVoidPtrArray &entitySetReg,AcGePoint3dArray &ptPnt3ds,AcDbIntArray &ptCirs)
{
	ptPnt3ds.setLogicalLength(0);
	ptCirs.setLogicalLength(0);
	//排序直线
	AcDbEntity * pEnt;
	AcGePoint3d ptSt,ptEnd;
	
	int nEntCnt=entitySetReg.length();
	myprintf("将直线放到数组\n");
	for(int i=0;i<nEntCnt;i++){
		pEnt=(AcDbEntity *)entitySetReg[i];
		if(pEnt->isKindOf(AcDbLine::desc())){
			AcDbLine *pLine=(AcDbLine *)pEnt;
			ptSt=pLine->startPoint();
			ptEnd=pLine->endPoint();
			ptPnt3ds.append(ptSt);
			ptPnt3ds.append(ptEnd);
			myprintf("%d %.5f,%.5f %.5f,%.5f\n",i,ptSt.x,ptSt.y,ptEnd.x,ptEnd.y);
		}else{
			acutPrintf("error: 包含%s\n",pEnt->isA()->name());
		}
	}
	myprintf("排序直线成首尾相连的环\n");
	AcGePoint3d ptTmp;
	int iFound=0;
	for(int i=0;i<nEntCnt-1;i++){
		iFound=0;
		for(int j=i+1;j<nEntCnt;j++){
			if(ptPnt3ds[2*j]==ptPnt3ds[2*i+1]){
				if(j!=i+1){//j和i+1交换
					ptTmp=ptPnt3ds[2*j];
					ptPnt3ds[2*j]=ptPnt3ds[2*(i+1)];
					ptPnt3ds[2*(i+1)]=ptTmp;					
					ptTmp=ptPnt3ds[2*j+1];
					ptPnt3ds[2*j+1]=ptPnt3ds[2*(i+1)+1];
					ptPnt3ds[2*(i+1)+1]=ptTmp;
				}
				iFound=1;
			}
		}
		if(!iFound){
			ptCirs.append(i);
			myprintf("%d 新的环!\n",i);
		}
	}
	for(int i=0;i<nEntCnt;i++){
		ptSt=ptPnt3ds[2*i];
		ptEnd=ptPnt3ds[2*i+1];
		myprintf("%d %.5f,%.5f %.5f,%.5f\n",i,ptSt.x,ptSt.y,ptEnd.x,ptEnd.y);
	}
	//以下不再使用:
	////第一点:
	//int ptIdx=0;
	//pEnt=(AcDbEntity *)entitySetReg[0];
	//if(pEnt->isKindOf(AcDbLine::desc())){
	//	AcDbLine *pLine=(AcDbLine *)pEnt;
	//	ptSt=pLine->startPoint();
	//	ptEnd=pLine->endPoint();
	//	ptPnt3ds.append(ptSt);
	//	ptPnt3ds.append(ptEnd);
	//	myprintf("%d %.5f,%.5f %.5f,%.5f\n",ptIdx,ptSt.x,ptSt.y,ptEnd.x,ptEnd.y);
	//	ptIdx+=2;
	//}else{
	//	acutPrintf("error: 包含%s\n",pEnt->isA()->name());
	//}
	//while (ptIdx<nEntCnt*2){
	//	//找下一点:
	//	for (int i=0;i<entitySetReg.length();i++){
	//		pEnt=(AcDbEntity *)entitySetReg[i];
	//		if(pEnt->isKindOf(AcDbLine::desc())){
	//			AcDbLine *pLine=(AcDbLine *)pEnt;
	//			ptSt=pLine->startPoint();
	//			ptEnd=pLine->endPoint();
	//			if(ptSt==ptPnt3ds[ptIdx-1]){
	//				ptPnt3ds.append(ptSt);
	//				ptPnt3ds.append(ptEnd);
	//				myprintf("%d %.5f,%.5f %.5f,%.5f\n",ptIdx,ptSt.x,ptSt.y,ptEnd.x,ptEnd.y);
	//				ptIdx+=2;
	//				break;
	//			}
	//		}else{
	//			acutPrintf("error: 包含%s\n",pEnt->isA()->name());
	//		}
	//	}
	//}
	return 0;
}
int region2Polyline(AcDbVoidPtrArray& entitySetReg ){
	AcGePoint3dArray ptPnt3d;
	AcDbIntArray ptCirs;
	sortEnts(entitySetReg,ptPnt3d,ptCirs);
	AcDbPolyline* pLWPLine=NULL;
	int ptIdx=0;
	int idxCir=0;
	AcGePoint3d ptSt;
	int iNumCirs=ptCirs.length();
	//todo: remove debug
	for(int i=0;i<iNumCirs;i++){
		myprintf("ptCirs: %d %d\n",i,ptCirs[i]);
	}
	//myprintf("region2Polyline %d \n",ptPnt3d.length());
	for(int i=0;i<ptPnt3d.length();i+=2){
		if(idxCir<iNumCirs){
			if(i==ptCirs[idxCir]*2){
				pLWPLine->setClosed(TRUE);
				//pLWPLine->addVertexAt(ptIdx,asPnt2d(ptEnd));
				AcDbObjectId objId;
				postToDatabase(pLWPLine,objId);
				pLWPLine->close();
				pLWPLine=NULL;
				//
				idxCir++;
				continue;
			}
		}
		{
			if(pLWPLine==NULL){
				myprintf("new polyline %d \n",i);
				pLWPLine=new AcDbPolyline();
				ptIdx=0;
			}
			{
				myprintf("%d %.5f,%.5f \n",ptIdx,ptPnt3d[i].x,ptPnt3d[i].y);
				pLWPLine->addVertexAt(ptIdx,AcGePoint2d(ptPnt3d[i].x,ptPnt3d[i].y));
				ptIdx++;
			}
		}
	}
	if(pLWPLine!=NULL){
		myprintf("%d polyline end\n");
		pLWPLine->setClosed(TRUE);
		//pLWPLine->addVertexAt(ptIdx,asPnt2d(ptEnd));
		AcDbObjectId objId;
		postToDatabase(pLWPLine,objId);
		pLWPLine->close();
		pLWPLine=NULL;
	}
	return 0;
}
int dumpCirList(CCirList *pCirList)
{
	myprintf("dump list:\n");
	struct stNode *pos;
	pos=pCirList->getHead();
	for(int i=0;i<pCirList->getCount();i++){
		myprintf("%.5f,%.5f ; ",pos->Point.x,pos->Point.y);
		pos=pCirList->getNext(pos);		
	}
	myprintf("\n");
	return 0;
}
int drawCirListPolyLine(CCirList *pCirList)
{
	struct stNode *pos=pCirList->getHead();
	AcDbPolyline *pLWPLine=new AcDbPolyline();
	int ptIdx=0;
	for(int i=0;i<pCirList->getCount();i++){
		if(pos->rbprev->Point!=pos->Point){
			pLWPLine->addVertexAt(ptIdx,pos->Point);
		}
		pos=pCirList->getNext(pos);
	}
	AcDbObjectId objId;
	postToDatabase(pLWPLine,objId);
	pLWPLine->setClosed(TRUE);
	pLWPLine->close();
	return 0;
}
CCirList * mergeCirList(AcGeVoidPointerArray &pnt2dPlineTbl)
{
	CCirList *pnt2dPlineRcd1=(CCirList *)pnt2dPlineTbl[0];
	struct stNode *pos1,*pos2,*pos3 ,*pos4;
	pos1=pnt2dPlineRcd1->getHead();
	myprintf("合并多个CirList:\n");
	for(int i=0;i<pnt2dPlineRcd1->getCount();i++){
		myprintf("%d %d %.5f,%.5f ; ",i,pnt2dPlineRcd1->getCount(),pos1->Point.x,pos1->Point.y);
		for(int j=1;j<pnt2dPlineTbl.length();j++){
			CCirList *pnt2dPlineRcd2=(CCirList *)pnt2dPlineTbl[j];
			pos2=pnt2dPlineRcd2->getHead();
			for(int k=0;k<pnt2dPlineRcd2->getCount();k++){
				if(pos1->Point == pos2->Point){
					pos3=pnt2dPlineRcd1->getNext(pos1);
					pos4=pnt2dPlineRcd2->getPrev(pos2); //方向相反的共边pos1=pos2, pos1.next=pos2.prev
					if(pos3->Point ==pos4->Point){
						myprintf("\nmerge共边:%d %d %.5f,%.5f\n",i,k,pos1->Point.x,pos1->Point.y);
						pnt2dPlineRcd2->setHead(pos2);
						pnt2dPlineRcd1->insertAfter(pos1,pnt2dPlineRcd2);
						//删除相同的点
						pnt2dPlineRcd1->delNode(pos2);
						pnt2dPlineRcd1->delNode(pos4);
						break;
					}
				}
				pos2=pnt2dPlineRcd2->getNext(pos2);
			}
		}
		pos1=pnt2dPlineRcd1->getNext(pos1);
	}
	for(int i=1;i<pnt2dPlineTbl.length();i++){
		delete pnt2dPlineTbl[i];
	}
	return pnt2dPlineRcd1;
}
int splitCirList(AcGeVoidPointerArray &pnt2dPlineTbl,CCirList *pCirList)
{
	pnt2dPlineTbl.setLogicalLength(0);
	//CCirList *pnt2dPlineRcd1=new CCirList;
	struct stNode *pos1,*pos2,*pos3 ,*pos4;
	pos1=pCirList->getHead();
	myprintf("拆分 CirList:\n");
	int iSize=pCirList->getCount();
	for(int i=0;i<iSize;i++){
		if(pos1->Point == pos1->rbnext->Point){
			pos1 = pCirList->getNext(pos1);
			myprintf("prev=curr,跳过同一点\n");
			continue;
		}
		myprintf("%d %d %.5f,%.5f ; ",i,pCirList->getCount(),pos1->Point.x,pos1->Point.y);
		pos2=pCirList->getNext(pos1);
		for(int j=i+1;j<iSize;j++){
			if(pos1->Point == pos2->Point){
				pos3=pCirList->getNext(pos1);
				pos4=pCirList->getPrev(pos2); //方向相反的共边pos1=pos2, pos1.next=pos2.prev
				if(pos3->Point ==pos4->Point){
					myprintf("\nsplit共边:%d %d %.5f,%.5f\n",i,j,pos1->Point.x,pos1->Point.y);
					myprintf(" %.5f,%.5f\n",pos3->Point.x,pos3->Point.y);
					//拆分成两个环:
					CCirList *pcir1=new CCirList;
					CCirList *pcir2=new CCirList;
					pCirList->getCirList(j-i,pos1,pos4,pcir1,pcir2);
					pnt2dPlineTbl.append(pcir1);
					pnt2dPlineTbl.append(pcir2);
					return 0;
				}
			}
			pos2 = pCirList->getNext(pos2);

		}
		pos1 = pCirList->getNext(pos1);
	}
	return 1;
}
bool pLineisClosed(AcDbPolyline *pPLine)
{
	bool isClosed=FALSE;
	AcGePoint3d ptSt,ptEnd;
	if(pPLine->isClosed()){
		isClosed=TRUE;
	}else{
		pPLine->getStartPoint(ptSt);
		pPLine->getEndPoint(ptEnd);
		if(ptSt==ptEnd){
			isClosed=TRUE;
		}
	}
	return isClosed;
}
int starMerge3()
{
	//通过多义线合并实现

	int iSel=getSelect();
	myprintf("%d\n",iSel);
	
	ads_name ss, ss1;
	struct resbuf *XreDa;
	if(iSel==1){	//按提示生成选择集
		XreDa=acutBuildList(
			RTDXF0,_T("LWPOLYLINE"),			//实体=
			0);
		if (acedSSGet(NULL, NULL, NULL, XreDa, ss)!=RTNORM){
			acutPrintf("没有选择!\n");
			acutRelRb(XreDa);
			return BAD;
		}
		acutRelRb(XreDa);
	}else if(iSel==2){ //指定层
		char sLayer[512];
		acedGetString(1,"请输入层名:",sLayer);
		XreDa=acutBuildList(
			-4,_T("<and"),
			RTDXF0,_T("LWPOLYLINE"),			//实体=TEXT
			AcDb::kDxfLayerName,_T(sLayer),//层=sLayer
			-4,_T("and>"),0);
		if (acedSSGet("X",NULL,NULL,XreDa,ss)!=RTNORM) {
			acutPrintf("没有选择!\n");
			acutRelRb(XreDa);
			return BAD;
		}
		acutRelRb(XreDa);
	}else if(iSel==3){ //全部
		myprintf("all layer!\n");
		XreDa=acutBuildList(
			RTDXF0,_T("LWPOLYLINE"),			//实体=TEXT
			0);
		if (acedSSGet("X",NULL,NULL,XreDa,ss)!=RTNORM) {
			acutPrintf("没有选择!\n");
			acutRelRb(XreDa);
			return BAD;
		}
		acutRelRb(XreDa);
	}else{
		acutPrintf("没有选择\n");
		return BAD;
	}

	long length;
	if (acedSSLength(ss, &length) != RTNORM){
		acutPrintf("error: sslength失败\n");
		return BAD;
	}

	int rejectCount = 0;
    AcDbEntity* pEnt;
	Acad::ErrorStatus es;
	AcGePoint3d ptSt,ptEnd;
	AcGePoint2d pt2dTmp;
	AcGePoint2dArray ptArr;
	AcGeVoidPointerArray pnt2dPlineTbl;
	AcDbObjectIdArray objIdArray;
	int idxPnt2d=0;

	for (int i=0; i<length; i++) {
		if (acedSSName(ss, i, ss1) != RTNORM) 
			break;
		AcDbObjectId eId;
		if( acdbGetObjectId(eId, ss1) != Acad::eOk)
		{
			acutPrintf("open object fail!\n");
			return 0;
		}
		es = acdbOpenAcDbEntity(pEnt, eId, AcDb::kForRead);
		if (es == Acad::eOk) {
			AcDbPolyline *pPLine;
			if (pEnt->isKindOf(AcDbPolyline::desc())){
				pPLine=(AcDbPolyline *)pEnt;
				if(pLineisClosed(pPLine)){
					objIdArray.append(eId);
					CCirList *pCirList=new CCirList;
					pnt2dPlineTbl.append(pCirList);
					pPLine->getStartPoint(ptSt);
					pt2dTmp.x=ptSt.x;pt2dTmp.y=ptSt.y;
					struct stNode *pos=pCirList->addHead(pt2dTmp);
					for(int j=1;j<pPLine->numVerts();j++){
						pPLine->getPointAt(j,pt2dTmp);
						if(pt2dTmp!=pos->Point){
							pCirList->insertAfter(pos,pt2dTmp);
						}
					}
					dumpCirList(pCirList);
				}
			}
			pEnt->close();
		}
	}
	if(pnt2dPlineTbl.length()<1){
		acutPrintf("没有有效的闭合polyline!\n");
		return 0;
	}
	CCirList *pnt2dPlineRcd1=mergeCirList(pnt2dPlineTbl);
	struct stNode *pos=pnt2dPlineRcd1->getHead();
	for(int i=0;i<pnt2dPlineRcd1->getCount();i++){
		if(pos->Point== pos->rbnext->Point) 
			pos=pnt2dPlineRcd1->delNode(pos);
	}
	int ret=splitCirList(pnt2dPlineTbl,pnt2dPlineRcd1);
		dumpCirList(pnt2dPlineRcd1);
		drawCirListPolyLine(pnt2dPlineRcd1);
		delete pnt2dPlineRcd1;
/*	if(ret){
		dumpCirList(pnt2dPlineRcd1);
		drawCirListPolyLine(pnt2dPlineRcd1);
		delete pnt2dPlineRcd1;
	}else{
		for(int i=0;i<pnt2dPlineTbl.length();i++){
			CCirList *pnt2dPlineRcd2=(CCirList *)pnt2dPlineTbl[i];
			dumpCirList(pnt2dPlineRcd2);
			drawCirListPolyLine(pnt2dPlineRcd2);
			//delete pnt2dPlineRcd2;
		}
	}*/
	mysynclog();
	return 0;
}
int starMerge2()
{
	//通过面域union实现
	int iSel=getSelect();
	myprintf("%d\n",iSel);
	
	ads_name ss, ss1;
	struct resbuf *XreDa;
	if(iSel==1){	//按提示生成选择集
		XreDa=acutBuildList(
			RTDXF0,_T("LWPOLYLINE"),			//实体=
			0);
		if (acedSSGet(NULL, NULL, NULL, XreDa, ss)!=RTNORM){
			acutPrintf("没有选择!\n");
			acutRelRb(XreDa);
			return BAD;
		}
		acutRelRb(XreDa);
	}else if(iSel==2){ //指定层
		char sLayer[512];
		acedGetString(1,"请输入层名:",sLayer);
		XreDa=acutBuildList(
			-4,_T("<and"),
			RTDXF0,_T("LWPOLYLINE"),			//实体=TEXT
			AcDb::kDxfLayerName,_T(sLayer),//层=sLayer
			-4,_T("and>"),0);
		if (acedSSGet("X",NULL,NULL,XreDa,ss)!=RTNORM) {
			acutPrintf("没有选择!\n");
			acutRelRb(XreDa);
			return BAD;
		}
		acutRelRb(XreDa);
	}else if(iSel==3){ //全部
		myprintf("all layer!\n");
		XreDa=acutBuildList(
			RTDXF0,_T("LWPOLYLINE"),			//实体=TEXT
			0);
		if (acedSSGet("X",NULL,NULL,XreDa,ss)!=RTNORM) {
			acutPrintf("没有选择!\n");
			acutRelRb(XreDa);
			return BAD;
		}
		acutRelRb(XreDa);
	}else{
		acutPrintf("没有选择\n");
		return BAD;
	}

	long length;
	if (acedSSLength(ss, &length) != RTNORM){
		acutPrintf("error: sslength失败\n");
		return BAD;
	}

    AcDbVoidPtrArray curveSegs;
	AcDbObjectIdArray objIdArray;
	int rejectCount = 0;
    AcDbEntity* ent;
	Acad::ErrorStatus es;
	AcGePoint3d ptSt,ptEnd;
	bool isClosed;
	for (int i=0; i<length; i++) {
		if (acedSSName(ss, i, ss1) != RTNORM) 
			break;
		AcDbObjectId eId;
		if( acdbGetObjectId(eId, ss1) != Acad::eOk)
		{
			acutPrintf("open object fail!\n");
			return 0;
		}
		es = acdbOpenAcDbEntity(ent, eId, AcDb::kForRead);
		if (es == Acad::eOk) {
			if (ent->isKindOf(AcDbCurve::desc())){
				AcDbCurve *pCurve=(AcDbCurve *)ent;
				isClosed=FALSE;
				if(pCurve->isClosed()){
					isClosed=TRUE;
				}else{
					if(pCurve->isKindOf(AcDbPolyline::desc())){
						AcDbPolyline *pLine=(AcDbPolyline *)pCurve;
						pLine->getStartPoint(ptSt);
						pLine->getEndPoint(ptEnd);
						if(ptSt==ptEnd){
							isClosed=TRUE;
						}
					}
				}
				if(isClosed){
					objIdArray.append(eId);
					curveSegs.append(static_cast<void*>(ent));
				}else{
					ent->close();    // only close those that we are rejecting
				}
			}
			else {
				rejectCount++;
				ent->close();    // only close those that we are rejecting
			}
        }
    }

    if (curveSegs.isEmpty()) {
        acutPrintf(_T("no 没有选择 curves!"));
        return 1;
    }
    if (rejectCount > 0)
        acutPrintf(_T("\n object(s) were not curves..."));

    AcDbVoidPtrArray regions;
    es = AcDbRegion::createFromCurves(curveSegs, regions);

    // close all open entities used to create the region
    int lenCurves = curveSegs.length();
    for (i=0; i<lenCurves; i++) {
        ent = static_cast<AcDbEntity*>(curveSegs[i]);
        ent->close();
    }

    if (es != Acad::eOk) {
		acutPrintf("error: createFromCurves失败\n");
        return 1;
    }
	// add all created regions to the database
    AcDbRegion* regionObj,*regionOther;
	AcDbObjectId objId;
    int lenRegions = regions.length();	
    myprintf(_T("\n%d Region(s) created from %d curve(s).\n"), lenRegions, lenCurves);
	{
        regionObj = static_cast<AcDbRegion*>(regions[0]);
        //regionObj->setDatabaseDefaults();
		for(int j=1;j<lenRegions; j++)
		{
			if(j==i) continue;
			regionOther=static_cast<AcDbRegion*>(regions[j]);
			regionObj->booleanOper(AcDb::kBoolUnite,regionOther);
		}
		AcDbPolyline *pLWPLine;
		int ptIdx=0;
		ads_point ptSt,ptEnd;
		AcDbVoidPtrArray entitySetReg;
		AcDbVoidPtrArray entitySetLine;
		AcGePoint3dArray ptArr;
		AcDbVoidPtrArray entitySetLineOrd;
		AcDbVoidPtrArray Polylines;
		//AcGeCompositeCurve3d *pCompGe=new AcGeCompositeCurve3d();
		AcDbVoidPtrArray *pPolylines=&Polylines;
		regionObj->explode(entitySetReg);
		AcGeCurve3d * pGe;
		AcDbCurve *pDb;
		entitySetLine.setLogicalLength(0);
		int hasChild=1;
		for(int j=0;j<entitySetReg.length();j++){
			AcDbEntity *pEntReg=(AcDbEntity *)(entitySetReg[j]);
			if(pEntReg->isKindOf(AcDbRegion::desc())){
				hasChild=1;
				//AcDbRegion* pRegion =(AcDbRegion*)pEntReg;
				//GetRegionBoundaryPolyline(pRegion,pPolylines);
				/*for(int k=0;k<pPolylines->length();k++){
					AcDbCurve *pCurve=(AcDbCurve *)(Polylines.at(k));
					myprintf("pPolylines: %s\n", pCurve->isA()->name());
				}*/
				entitySetLine.setLogicalLength(0);
				if(pEntReg->explode(entitySetLine)==Acad::eOk){
					region2Polyline(entitySetLine);
				}
			}else if (pEntReg->isKindOf(AcDbLine::desc())) {
				hasChild=0;
			}
			pEntReg->close();
		}

		if(!hasChild){
			region2Polyline(entitySetReg);
		}
		postToDatabase((AcDbEntity*)regionObj,objId);
		//regionObj->erase();
		regionObj->close();
    }

	for (int i=0; i<objIdArray.length(); i++) {
		es = acdbOpenAcDbEntity(ent, objIdArray[i], AcDb::kForWrite);
		if (es == Acad::eOk) 
		{
			//if (ent->isKindOf(AcDbCurve::desc())){
			ent->erase();
			//}
			ent->close();    // only close those that we are rejecting
        }
    }

	mysynclog();
	return 0;
}
bool hasLine(AcGePoint3dArray &ptArr,AcGePoint3d ptSt,AcGePoint3d ptEnd)
{
	for(int i=0;i<ptArr.length();i+=2){
		if(ptArr[i]==ptSt && ptArr[i+1]==ptEnd){
			return TRUE;
		}
	}
	return FALSE;
}
////插入排序法
//int sortLines(CLineListPtrArray & arPlines,AcGePoint2d ptSt,AcGePoint2d ptEnd)
//{
//	//是否已经存在?
//	bool iFound=FALSE;
//	for(int i=0;i<arPlines.length();i++){
//		CLineList *pllPline=arPlines[i];
//		struct stLineNode *pos=pllPline->getHead();
//		for(int j=0;j<pllPline->getCount();j++){
//			if( (pos->Line.ptSt==ptSt && pos->Line.ptEnd==ptEnd) ||
//			    (pos->Line.ptSt==ptEnd && pos->Line.ptEnd==ptSt) )
//			{
//				myprintf("found:%.4f,%.4f %.4f,%.4f\n",ptSt.x,ptSt.y,ptEnd.x,ptEnd.y);
//				return 1;
//			}
//			if(pos->Line.ptEnd==ptSt){
//				struct stLine line;
//				line.ptEnd=ptEnd;
//				line.ptSt=ptSt;
//				pllPline->insertAfter(pos,line);
//				iFound=TRUE;
//			}
//			pos=pllPline->getNext(pos);
//		}
//	}
//	//新的polyline
//	if(!iFound){
//		CLineList *pllPline=new CLineList;
//		arPlines.append(pllPline);
//		struct stLine line;
//		line.ptEnd=ptEnd;
//		line.ptSt=ptSt;
//		struct stLineNode *pos=pllPline->addHead(line);
//	}
//	return 0;
//	//for(int i=0;i<
//}

int dumpLineList(CLineList *pLineList)
{
	myprintf("dump:\n");
	struct stLineNode *pos;
	pos=pLineList->getHead();
	for(int i=0;i<pLineList->getCount();i++){
		myprintf(" %.4f,%.4f",pos->Line.ptSt,pos->Line.ptEnd);
		pos=pLineList->getNext(pos);
	}
	myprintf("\n");
	return 0;
}
int drawLineListPolyLine(CLineList * pLineList)
{
	struct stLineNode *pos=pLineList->getHead();
	AcDbPolyline *pLWPLine=new AcDbPolyline();
	int ptIdx=0;
	for(int i=0;i<pLineList->getCount();i++){
		//if(pos->rbprev->Point!=pos->Point)
		{
			pLWPLine->addVertexAt(ptIdx,pos->Line.ptSt);
		}
		pos=pLineList->getNext(pos);
	}
	AcDbObjectId objId;
	postToDatabase(pLWPLine,objId);
	pLWPLine->setClosed(TRUE);
	pLWPLine->close();
	return 0;
}
int drawLineListPolyLine(AcGePoint3dArray &ptPnt3d,AcDbIntArray &ptCirs)
{
	AcDbPolyline* pLWPLine=NULL;
	int ptIdx=0;
	int idxCir=0;
	AcGePoint3d ptSt;
	int iNumCirs=ptCirs.length();
	//todo: remove debug
	for(int i=0;i<iNumCirs;i++){
		myprintf("ptCirs: %d %d\n",i,ptCirs[i]);
	}
	//myprintf("region2Polyline %d \n",ptPnt3d.length());
	for(int i=0;i<ptPnt3d.length();i+=2){
		if(idxCir<iNumCirs){
			if(i==ptCirs[idxCir]*2){
				pLWPLine->setClosed(TRUE);
				//pLWPLine->addVertexAt(ptIdx,asPnt2d(ptEnd));
				AcDbObjectId objId;
				postToDatabase(pLWPLine,objId);
				pLWPLine->close();
				pLWPLine=NULL;
				//
				idxCir++;
				continue;
			}
		}
		{
			if(pLWPLine==NULL){
				myprintf("new polyline %d \n",i);
				pLWPLine=new AcDbPolyline();
				ptIdx=0;
			}
			{
				//myprintf("%d %.5f,%.5f \n",ptIdx,ptPnt3d[i].x,ptPnt3d[i].y);
				pLWPLine->addVertexAt(ptIdx,AcGePoint2d(ptPnt3d[i].x,ptPnt3d[i].y));
				ptIdx++;
			}
		}
	}
	if(pLWPLine!=NULL){
		myprintf("%d polyline end\n");
		pLWPLine->setClosed(TRUE);
		//pLWPLine->addVertexAt(ptIdx,asPnt2d(ptEnd));
		AcDbObjectId objId;
		postToDatabase(pLWPLine,objId);
		pLWPLine->close();
		pLWPLine=NULL;
	}
	return 0;
}
//删除共边
int linesDelSample (AcGePoint2dArray & arLines)
{
	myprintf("删除共边\n");
	int idel=0;
	//ptArr.setLogicalLength(arLines.length());
	//ptArr.setAll(0);
	for(int i=0;i<arLines.length();i+=2){
		for(int j=i+2;j<arLines.length();j+=2)
		{
			//myprintf("%d %d %.4f,%.4f %.4f,%.4f ",i,j,arLines[i].x,arLines[i].y,arLines[i+1].x,arLines[i+1].y);
			//myprintf("%.4f,%.4f %.4f,%.4f\n",arLines[j].x,arLines[j].y,arLines[j+1].x,arLines[j+1].y);
			if( (arLines[i]==arLines[j] && arLines[i+1]==arLines[j+1])
				||(arLines[i]==arLines[j+1] && arLines[i+1]==arLines[j]))
			{
				myprintf("del:%d %d %.4f,%.4f %.4f,%.4f\n",i,j,arLines[i].x,arLines[i].y,arLines[i+1].x,arLines[i+1].y);					/*ptArr[i]=1;
				ptArr[i+1]=1;
				ptArr[j]=1;
				ptArr[j+1]=1;*/
				arLines.removeAt(j+1);//注意删除顺序:从后面往前删
				arLines.removeAt(j);
				arLines.removeAt(i+1);
				arLines.removeAt(i);
				j-=2;
				idel=1;
			}
		}
		if(idel){
			i-=2;
			idel=0;
		}
	}
	
	return 0;
}
//交换排序
int linesSort(AcGePoint2dArray& arLines)
{
	myprintf("直线排序成首尾相连的环\n");
	int iFound=0;
	int nSize=arLines.length();
	AcGePoint2d ptTmp;
	for(int i=0;i<nSize;i+=2)
	{
		//if(ptArr[i])continue;
		for(int j=i+2;j<nSize;j+=2)
		{
			//if(ptArr[j])continue;
			if(arLines[j]==arLines[i+1]) { //j.ptSt=i.ptEnd
				if(j!=i+2){
					//交换j和i+2
					//myprintf("swap:%d,%d %.4f %.4f %.4f %.4f\n",i,j,arLines[j].x,arLines[j].y,arLines[i+1].x,arLines[i+1].y);
					ptTmp=arLines[j];
					arLines[j]=arLines[i+2];					
					arLines[i+2]=ptTmp;
					ptTmp=arLines[j+1];
					arLines[j+1]=arLines[i+3];
					arLines[i+3]=ptTmp;
				}
				break;
			}
		}
	}
	/* /for debug
	for (int i=0;i<arLines.length();i+=2){
		drawLine(arLines[i],arLines[i+1]);
		myprintf("%d %.4f,%.4f ;",arLines[i].x,arLines[i].y);
	}*/
	return 0;
}
int linesDraw(AcGePoint2dArray &arLines)
{
	AcDbPolyline* pLWPLine=new AcDbPolyline();

	int ptIdx=0;
	pLWPLine->addVertexAt(ptIdx,arLines[0]);
	ptIdx++;
	AcGePoint2d posprev;
	for(int i=2;i<arLines.length();i+=2)
	{
		if(arLines[i] != arLines[i-1]){
			//cur.ptSt!= prev.ptSt不是连续的
			myprintf("新环 %.4f,%.4f %.4f,%.4f\n",arLines[i].x,arLines[i].y,arLines[i+1].x,arLines[i+1].y);
			pLWPLine->setClosed(TRUE);
			AcDbObjectId objId;
			postToDatabase(pLWPLine,objId);
			pLWPLine->close();
			pLWPLine = new AcDbPolyline();
			ptIdx=0;
		}
		pLWPLine->addVertexAt(ptIdx,arLines[i]);
		ptIdx++;
	}
	if(pLWPLine != NULL){
		pLWPLine->setClosed(TRUE);
		AcDbObjectId objId;
		postToDatabase(pLWPLine,objId);
		pLWPLine->close();
		pLWPLine=NULL;
	}
	return 0;
}
int getSelectSet(int iSel,CStringList &strent,ads_name &ss)
{
	struct resbuf *XreDa;
	struct resbuf * resBufEntityFilter  = NULL;
	struct resbuf **resBufTemp;

	if(iSel<1 || iSel >3){
		acutPrintf("没有选择(%d)\n",iSel);
		return 1;
	}

	resBufTemp = &resBufEntityFilter;
	//<and 8=slayer <or RTDXF0 LWPOLYLINE,,, or> and>
	if(iSel==2){
		char sLayer[512];
		acedGetString(1,"请输入层名:",sLayer);

		*resBufTemp = acutBuildList(-4, "<AND", 0);
		resBufTemp = &(*resBufTemp)->rbnext;

		*resBufTemp = acutBuildList(8, sLayer, 0); //层=slayer
		resBufTemp = &(*resBufTemp)->rbnext;
	}
	if(strent.GetCount()==1){ //只有一个
		POSITION pos=strent.GetHeadPosition();
		*resBufTemp = acutBuildList(RTDXF0, strent.GetNext( pos ), 0);
		resBufTemp = &(*resBufTemp)->rbnext;
	}else{		//<or RTDXF0 LWPOLYLINE,,, or>
		*resBufTemp = acutBuildList(-4, "<OR", 0);
		resBufTemp = &(*resBufTemp)->rbnext;
		POSITION pos;
		for( pos = strent.GetHeadPosition(); pos != NULL; )
		{
			*resBufTemp = acutBuildList(RTDXF0, strent.GetNext( pos ), 0); //实体=
			resBufTemp = &(*resBufTemp)->rbnext;
		}
		*resBufTemp = acutBuildList(-4, "OR>", 0);
		resBufTemp = &(*resBufTemp)->rbnext;
	}
	if(iSel==2){
		*resBufTemp = acutBuildList(-4, "AND>", 0);
		resBufTemp = &(*resBufTemp)->rbnext;
	}

	char *strSMode;
	if(iSel==1){
		strSMode=NULL;	//按提示生成选择集
	}else{
		strSMode="X";	//按指定过滤器
	}

	if (acedSSGet(strSMode, NULL, NULL, resBufEntityFilter, ss)!=RTNORM){
		acutPrintf("没有选择!\n");
		acutRelRb(resBufEntityFilter);
		return 2;
	}
	acutRelRb(resBufEntityFilter);
	return 0;
}

int doEntitySet(ads_name &ss, PTRFUN pFun)  //
{
	ads_name ss1;
	long length;
	if (acedSSLength(ss, &length) != RTNORM){
		acutPrintf("error: sslength\n");
		return BAD;
	}
	AcDbEntity *pEnt;
	AcDbObjectId eId;
	Acad::ErrorStatus es;
	for(int i=0;i<length;i++)
	{		
		if (acedSSName(ss, i, ss1) != RTNORM) 
			break;
		(pEl2pl->*pFun)(ss1);
	}
	mysynclog();
	return 0;
}
int starMergePolyline()
{
	return pEl2pl->starMergePolyline();
}

int starText2LineA()
{
	pEl2pl->starText2lineA();
	return 0;
}
int starText2LineB()
{
	pEl2pl->starText2lineB();
	return 0;
}
int starText2LineC()
{
	pEl2pl->starText2lineC();
	return 0;
}
int starText2LineD()
{
	pEl2pl->starText2lineD();
	return 0;
}
int starDimmini()
{
	pEl2pl->starDimmini();
	return 0;
}
struct resbuf * entItem(struct resbuf *textent,short irestype)
{
	int rt, i;
	char buf[133];
	struct resbuf *pRb=textent;

	for (i = 0;pRb != NULL;i++, pRb = pRb->rbnext) {
		if(pRb->restype==irestype){
			return pRb;
		}
	}
	return NULL;
}
int starDo5s()
{
	pEl2pl->starDo5s();
	return 0;
}