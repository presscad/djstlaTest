#include "EL2PL.h"

CEL2PL::CEL2PL()
{
}
CEL2PL::~CEL2PL(void)
{
}

int CEL2PL::starEL2PL(void)
{
	int iSel=getSelect();
	if(iSel==0){
		return 0;
	}
	ads_name ss,ss1;
	CStringList strent;
	strent.AddHead("ELLIPSE");
	if(getSelectSet(iSel,strent,ss))
		return 0;

	long length;
	if (acedSSLength(ss, &length) != RTNORM) 
		return BAD; 
	//acedSetStatusBarProgressMeter("Test Progress Bar", 0, length);
	//acedRestoreStatusBar();
	setMylog(1);
	for (int i=0;i<length;i++){
		//acedSetStatusBarProgressMeterPos(i);
		if (acedSSName(ss, i, ss1) != RTNORM) 
			break;
		AcDbPolyline* pPolyline = ellipse2polyline(ss1);
		if (pPolyline){			
			//pPolyline->setColorIndex(1);
			AcDbObjectId objId;
			postToDatabase(pPolyline, objId);
			pPolyline->close();
		}
	}
	mysynclog();
	//setMylog(0);
	acedSSFree(ss);
	return GOOD;
}

bool CEL2PL::isOnLockedLayer(AcDbEntity* ent, bool printMsg)
{
    AcDbObject* obj;
    AcDbLayerTableRecord* layer;
    bool isLocked = false;
    Acad::ErrorStatus es;

    es = acdbOpenAcDbObject(obj, ent->layerId(), AcDb::kForRead);
    if (es == Acad::eOk) {
        layer = AcDbLayerTableRecord::cast(obj);
        if (layer)
            isLocked = layer->isLocked();
        else {
            ASSERT(0);
        }
        obj->close();
    }

    if (isLocked && printMsg) {
        acutPrintf(_T("\nSelected entity is on a locked layer."));
    }
    return isLocked;
}

bool CEL2PL::isOnFrozenLayer(AcDbEntity* ent, bool printMsg)
{
    AcDbObject* obj;
    AcDbLayerTableRecord* layer;
    bool isFrozen = false;
    Acad::ErrorStatus es;

    es = acdbOpenAcDbObject(obj, ent->layerId(), AcDb::kForRead);
    if (es == Acad::eOk) {
        layer = AcDbLayerTableRecord::cast(obj);
        if (layer)
			isFrozen = layer->isFrozen();
        else {
            ASSERT(0);
        }
        obj->close();
    }

    if (isFrozen && printMsg) {
        acutPrintf(_T("\nSelected entity is on a frozen layer."));
    }
    return isFrozen;
}
int CEL2PL::spline2polyline(AcDbEntity *pEnt)
{
	AcGePoint2dArray ptArr;
	if(!pEnt->isKindOf(AcDbSpline::desc())){
		myprintf("%s %d!\n",__FUNCTION__,__LINE__);
		return 1;
	}
	AcDbSpline * pSpline=(AcDbSpline *)pEnt;
	//if(!pSpline->hasFitData()){
		getPlinePoints(pSpline,ptArr);// getPlinePoints(pSpline, ptArr, 1);
	//}else{
	//	getPlinePoints(pSpline,ptArr,1);
	//}
	//CString layerId=pSpline->layer();
	//AcDbObjectId layerId=pSpline->layerId();
	AcDbPolyline *pLwpoly = new AcDbPolyline;
	int isClosed=pSpline->isClosed();
	/*if(!pSpline->hasFitData()){
		int len=ptArr.length();
		for(int i=0;i<len;i++){
			pLwpoly->addVertexAt(0,ptArr[i],0);
		}

		if(pSpline->isClosed()){
			pLwpoly->setClosed(true);
		}
		AcDbObjectId custOID;
		postToDatabase(pLwpoly, custOID);
		pLwpoly->close();
		return 0;
	}*/

	//2,构造polyline
	/* for debug: 显示起点
	AcDbObjectId custOID;
	AcDbPoint* pPoint = new AcDbPoint();pPoint->setPosition(ptArr.at(0));postToDatabase(pPoint,custOID); */
	//AcGePoint3d ptStart,ptEnd;
	//getArcBulge(ptArr.at(0),ptArr.at(1),ptArr.at(2),dBulge);
	//pLwpoly->addVertexAt(0,ptArr.at(0),dBulge);
	if(ptArr.length()<4) return NULL;
	//第一段
	int ptIdx=0;
	double dBulge;
	double dAngle;
	int enttype[2];//0 prev 1 cur //0直线1圆弧
	double entbugle[2];
	if(isLine(ptArr.at(0),ptArr.at(1),ptArr.at(2))){
		dBulge=0;
		getLineAngle(ptArr.at(0),ptArr.at(2),dAngle);
		//myprintf("ptIdx %d angle:%.8f\n",0,dAngle);
		enttype[0]=0;
		entbugle[0]=dAngle;
	}else{
		getArcBulge(ptArr.at(0),ptArr.at(1),ptArr.at(2),dBulge);
		//myprintf("ptIdx %d bulge:%.8f\n",0,dBulge);
		enttype[0]=1;
		entbugle[0]=dBulge;
	}
	pLwpoly->addVertexAt(ptIdx,ptArr.at(0),dBulge);
	ptIdx++;
	int isSkip=0; 
	for (int i = 2; i < ptArr.length()-2; i+=2)
	{
		if(isLine(ptArr.at(i),ptArr.at(i+1),ptArr.at(i+2))){
			dBulge=0;
			//set var
			getLineAngle(ptArr.at(i),ptArr.at(i+2),dAngle);
			enttype[1]=0;
			entbugle[1]=dAngle;
			//do some
			if(enttype[0] != 0 || myabs(entbugle[1]-entbugle[0]) > m_dSegfactor ) {
				pLwpoly->addVertexAt(ptIdx,ptArr.at(i),dBulge);
				ptIdx++;
				entbugle[0]=entbugle[1];
				enttype[0]=enttype[1];
			}else {
				//myprintf("l %d angle:%.8f %.8f\n",ptIdx,entbugle[0],entbugle[1]);
			}
			//done
		}else{
			getArcBulge(ptArr.at(i),ptArr.at(i+1),ptArr.at(i+2),dBulge);
			//set var
			enttype[1]=1;
			entbugle[1]=dBulge;
			//do some
			double dDiff=myabs(entbugle[1]-entbugle[0]);
			if(enttype[0] != 1 ||  dDiff > m_dSegfactor || isSkip >4000 ) {
				/*
				if(isSkip){// skip:跳过段数,弧上的3点：[i-(skip+1)*2],[i-(skip+1)],[i]
					if(isSkip>4){//跳过的段数太多，在中间加点
						int iSt,iMid,iEnd;
						double iStep;
						int setNum=2;
						iSt=(isSkip+1)*2;
						iStep=iSt/(setNum*2.0);
						for (int k=0;k<setNum;k++){
							iMid=int(iSt-iStep);
							iEnd=int(iSt-iStep-iStep);
							getArcBulge(ptArr.at(i-iSt+2),ptArr.at(i-iMid+2),ptArr.at(i-iEnd+2),dBulge);
							pLwpoly->addVertexAt(ptIdx,ptArr.at(i-iSt+2),dBulge);
							myprintf("st mid end:%d %d %d\n",iSt,iMid,iEnd);
							iSt=iSt-int(iStep*2);
						}
					}else{//重新计算bulge
						getArcBulge(ptArr.at(i-(isSkip+1)*2+2),ptArr.at(i-(isSkip+1)+2),ptArr.at(i+2),dBulge);
						pLwpoly->addVertexAt(ptIdx,ptArr.at(i-(isSkip+1)*2+2),dBulge);
					}
					isSkip=0;
				}else{
					pLwpoly->addVertexAt(ptIdx,ptArr.at(i),dBulge);
					}*/
				getArcBulge(ptArr.at(i-(isSkip+1)*2+2),ptArr.at(i-(isSkip+1)+2),ptArr.at(i+2),dBulge);
				pLwpoly->addVertexAt(ptIdx,ptArr.at(i-(isSkip+1)*2+2),dBulge);
				ptIdx++;
				//myprintf("%d %d %d %.12f %.12f %.8f\n",ptIdx,enttype[0],enttype[1],entbugle[0],entbugle[1],dDiff);
				entbugle[0]=entbugle[1];
				enttype[0]=enttype[1];
				isSkip=0;
			}else {
				isSkip++;
				//myprintf("->%d skip ",isSkip);
				//myprintf("%d %d %d %.12f %.12f %.8f\n",ptIdx,enttype[0],enttype[1],entbugle[0],entbugle[1],dDiff);
			}
		}
		
		//myprintf("ptIdx %d pt1 %.4f,%.4f pt2 %.4f,%.4f pt3 %.4f,%.4f dBulge: %.8f\n",ptIdx,pt1[0],pt1[1],pt2[0],pt2[1],pt3[0],pt3[1],dBulge);
	}
	if(isClosed){
		if (!pLwpoly->isClosed())
		{
			pLwpoly->setClosed(true);
		}
	}else{
		//pLwpoly->addVertexAt(i/2,asPnt2d(asDblArray(ptEnd)),0);
		pLwpoly->addVertexAt(ptIdx,ptArr.last(),0.0);
	}

	//myprintf("ptIdx %d Pt3 %.4f %.4f dBulge: %.8f\n",ptIdx,ptArr.last().x,ptArr.last().y,dBulge);
	AcDbObjectId custOID;
	pLwpoly->setLayer(m_layerid);
	pLwpoly->setColor(m_color);
	postToDatabase(pLwpoly, custOID);
	pLwpoly->close();
}
int CEL2PL::spline2polyline(ads_name &en)
{
	//1,打开实体,保存图层ID,取点
	Adesk::Boolean isClosed;
	AcDbObjectId eId;
	AcDbEntity * pEnt;
	acdbGetObjectId(eId, en);
	AcGePoint2dArray ptArr;

	if(acdbOpenObject(pEnt, eId, kForRead)!=Acad::eOk){  //kForRead; kForWrite;
		acutPrintf("open failed!\n");
		return 0;
	}
	//myprintf ("entity: %s\n", pEnt->isA()->name());
	if (!pEnt->isKindOf(AcDbSpline::desc()))
	{
		pEnt->close();
		return NULL;
	}
	if(isOnLockedLayer(pEnt,true)){
		pEnt->close();
		return NULL;
	}
	m_layerid=pEnt->layerId();
	m_color=pEnt->color();
	AcDbVoidPtrArray entitySet;
	entitySet.setLogicalLength(0);
	m_layerid = pEnt->layerId();
	m_color = pEnt->color();
	pEnt->explode(entitySet);
	pEnt->close();
	int len=entitySet.length();
	if(len>0){
		for(int i=0;i<len;i++){
			AcDbEntity *pEnt=(AcDbEntity *)entitySet[i];
			spline2polyline(pEnt);
			pEnt->close();
		}
		if(acdbOpenObject(pEnt, eId, kForWrite)!=Acad::eOk){
			myprintf("%s, acdbOpenObject failed\n",__FUNCTION__);
			return 0;
		}
		pEnt->erase();
		pEnt->close();
	}else{
		if(acdbOpenObject(pEnt, eId, kForWrite)!=Acad::eOk){
			myprintf("%s, acdbOpenObject failed\n",__FUNCTION__);
			return 0;
		}
		spline2polyline(pEnt);
		pEnt->erase();
		pEnt->close();
	}
	return 0;
}

AcDbPolyline* CEL2PL::ellipse2polyline(ads_name &en)
{
	AcDbObjectId eId;
	acdbGetObjectId(eId, en);
	AcGePoint2dArray ptArr;
	Adesk::Boolean isClosed;

	AcDbEntity * pEnt;
	if(acdbOpenObject(pEnt, eId, kForRead)!=Acad::eOk){ //kForRead  kForWrite;
		acutPrintf("open object fail!\n");
		return 0;
	}
	if (!pEnt->isKindOf(AcDbEllipse::desc()))
	{
		pEnt->close();
		return NULL;
	}	
	if(isOnLockedLayer(pEnt,true)){
		pEnt->close();
		return NULL;
	}
	pEnt->close();

	if( acdbOpenObject(pEnt, eId, kForWrite) != Acad::eOk) //kForRead; kForWrite;
	{
		acutPrintf("open object fail!\n");
		return 0;
	}

	AcDbEllipse * pEl=AcDbEllipse::cast(pEnt);
	getPlinePoints(pEl,ptArr);
	isClosed=pEl->isClosed();
	pEnt->erase();
	AcDbPolyline *pLwpoly = new AcDbPolyline;
	pLwpoly->setLayer(pEl->layerId());
	pLwpoly->setColor(pEl->color());
	pEnt->close();

	/* for debug: 显示起点
	AcDbObjectId custOID;
	AcDbPoint* pPoint = new AcDbPoint();pPoint->setPosition(ptArr.at(0));postToDatabase(pPoint,custOID); */
	//AcGePoint3d ptStart,ptEnd;

	double dBulge;
	//getArcBulge(pt1,pt2,pt3,dBulge);
	//pLwpoly->addVertexAt(0,asPnt2d(pt1),dBulge);
	int ptIdx=0;
	for (int i = 0; i < ptArr.length()-2; i+=2)
	{
		getArcBulge(ptArr.at(i),ptArr.at(i+1),ptArr.at(i+2),dBulge);
		//myprintf("ptStart %.4f,%.4f PtEnd %.4f %.4f dBulge: %.4f\n",ptStart.x,ptStart.y,ptEnd.x,ptEnd.y,dBulge);
		//pLwpoly->addVertexAt(i/2,asPnt2d(asDblArray(ptStart)),dBulge);
		pLwpoly->addVertexAt(ptIdx,ptArr.at(i),dBulge);
		ptIdx++;
	}
	//
	if(isClosed){
		if (!pLwpoly->isClosed())
		{
			pLwpoly->setClosed(true);
		}
	}else{
		//pLwpoly->addVertexAt(i/2,asPnt2d(asDblArray(ptEnd)),0);
		pLwpoly->addVertexAt(ptIdx,ptArr.last(),0);
	}
	return pLwpoly;
}

Acad::ErrorStatus CEL2PL::visableAllLayer()
{
	Acad::ErrorStatus es,ret;
	AcDbLayerTable* layTbl;
	AcDbLayerTableRecord* layer;

	es = acdbHostApplicationServices()->workingDatabase()->getSymbolTable(layTbl, AcDb::kForRead);
	assert(es == Acad::eOk);
	AcDbLayerTableIterator* tblIter;
	if (layTbl->newIterator(tblIter) == Acad::eOk) {
		for (; !tblIter->done(); tblIter->step()) {
			es = tblIter->getRecord(layer, AcDb::kForWrite);
			if (es == Acad::eOk) {
				char *aname;
				layer->getName(aname);
				if (layer->isLocked()) {
					layer->setIsLocked(false);
					acutPrintf("layer %s 解锁!\n",aname);
				}
				/*if (layer->isFrozen()) {
					layer->setIsFrozen(false);
					acutPrintf("layer %s 请先解冻!\n",aname);
					acutDelString(aname);
					layer->close();
					delete tblIter;
					layTbl->close();
					return Acad::eNotImplementedYet;
				}*/
				if (layer->isOff()) {
					layer->setIsOff(false);
					acutPrintf("layer %s 打开!\n",aname);
				}
				acutDelString(aname);
				layer->close();
			}
		}
		delete tblIter;
	}
	layTbl->close();
	return Acad::eOk;
}
Acad::ErrorStatus CEL2PL::postToDatabase(AcDbEntity* ent , AcDbObjectId& objId)
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
int CEL2PL::getLineAngle(AcGePoint2d& pt1,AcGePoint2d& pt2,double & dAngle)
{
	/*ads_point apt1,apt2;
	apt1[0]=pt1.x,apt1[1]=pt1.y;
	apt2[0]=pt2.x,apt2[1]=pt2.y;*/
	dAngle=acutAngle(asDblArray(pt1),asDblArray(pt2));
	return GOOD;
}
int CEL2PL::getArcBulge(AcGePoint2d& pt1,AcGePoint2d& pt2,AcGePoint2d& pt3,double & dBulge)
{
	//计算Bugle
	AcGeCircArc2d pGArc(pt1,pt2,pt3);
	//椭圆不用判断(3点在直线上)
	double endAngle,startAngle,dAngle;
	startAngle=pGArc.startAng();
	endAngle=pGArc.endAng();
	if (endAngle<startAngle) endAngle+= m_twopi; // 8*atan(1.0);
	dAngle=endAngle-startAngle;
	dBulge=tan(dAngle/4);
	if(pGArc.isClockWise()) dBulge = -dBulge;
	return GOOD;
}
int CEL2PL::getArcBulge(AcDbArc *pArc, double & dBulge)//弧凸度
{
	//构造AcGeCircArc
	AcGePoint2d cpt;
	cpt.x=pArc->center().x;
	cpt.y=pArc->center().y;
	AcGeCircArc2d pGArc(cpt,pArc->radius(),pArc->startAngle(),pArc->endAngle());
	//计算Bugle	
	double endAngle,startAngle,dAngle;
	startAngle=pGArc.startAng();
	endAngle=pGArc.endAng();
	if (endAngle<startAngle) endAngle+= m_twopi; // 8*atan(1.0);
	dAngle=endAngle-startAngle;
	dBulge=tan(dAngle/4);
	if(pGArc.isClockWise()) dBulge = -dBulge;
	return GOOD;
}
int CEL2PL::getArcBulge(AcGeCircArc2d &geArc, double & dBulge)//弧凸度
{
	//计算Bugle	
	double endAngle,startAngle,dAngle;
	startAngle=geArc.startAng();
	endAngle=geArc.endAng();
	if (endAngle<startAngle) endAngle+= m_twopi; // 8*atan(1.0);
	dAngle=endAngle-startAngle;
	dBulge=tan(dAngle/4);
	if(geArc.isClockWise()) dBulge = -dBulge;
	return GOOD;
}
int CEL2PL::isLine(AcGePoint2d& pt1,AcGePoint2d& pt2,AcGePoint2d& pt3)
{	
	//0:不是直线 1是直线,
	double Angle1=acutAngle(asDblArray(pt1),asDblArray(pt2));  //角度
	double Angle2=acutAngle(asDblArray(pt2),asDblArray(pt3));  //角度
	if(myabs(Angle1-Angle2)>1E-6)
		return 0;
	else return 1;
	/*
	AcGeLine2d line1(pt1,pt2);
	AcGeLine2d line2(pt2,pt3);
	AcGePoint2d pt;
	int ret=line1.intersectWith(line2,pt);
	myprintf("isline %d %.5f,%.5f %.5f,%.5f %.5f,%.5f \n",ret,pt1.x,pt1.y,pt2.x,pt2.y,pt3.x,pt3.y);
	return !ret;*/
}
/*
int CEL2PL::getArcBulge(ads_point pt1,ads_point pt2,ads_point pt3,double & dBulge)
{
	bool LongARC=FALSE;
	AcDbCurve *pCur;
	ads_point cpt,mp1,mp2,mp3,mp4;
	ads_real GDist1,GDist2,Dist,Angle1,Angle2,Radius,StartAngle,EndAngle;
	GDist1=GDist2=0;
	AcGePoint3d Mid,Mp1,Mp2,Cpt;
	AcGePoint3d Spt,Mpt,Ept;
	Spt=asPnt3d(pt1);Mpt=asPnt3d(pt2);Ept=asPnt3d(pt3);
	Mid=Mpt;
	Dist=acutDistance(pt1,pt2);
	Angle1=acutAngle(pt1,pt2);
	Angle2=acutAngle(pt3,pt2);
	//距 pt1 某 angle 某 distance 的 UCS3D 点
	acutPolar(pt1,Angle1,acutDistance(pt1,pt2)*0.5,mp1);
	acutPolar(pt3,Angle2,acutDistance(pt3,pt2)*0.5,mp2);
	acutPolar(mp1,Angle1+(m_pi*0.5),Dist,mp3);
	acutPolar(mp2,Angle2+(m_pi*0.5),Dist,mp4);
	acdbInters(mp1,mp3,mp2,mp4,FALSE,cpt);
	Cpt=asPnt3d(cpt);
	Radius=acutDistance(cpt,pt2);
	StartAngle=acutAngle(cpt,pt1);
	EndAngle=acutAngle(cpt,pt3);
	//get dBulge
	double dAngle;
	int isEngAngle=0;
	if (EndAngle<StartAngle){
		EndAngle+=8*atan(1.0);
		isEngAngle=1;
	}
	dAngle=EndAngle-StartAngle;
	dBulge=tan(dAngle/4);
	//if(isEngAngle){dBulge=-1*dBulge;}
	return GOOD;
}*/

int CEL2PL::getPlinePoints(AcDbSpline* pSpl, AcGePoint2dArray& ptArr,int notFitData)
{
	if(pSpl->hasFitData())
	{
		return 0;
	}
	AcGePoint3d pt3dEnd,pt3dSt;
	AcGePoint2d ptEnd,ptSt;
	int numCtlPts=pSpl->numControlPoints();
	pSpl->getControlPointAt(0,pt3dEnd);
	ptEnd.x=pt3dEnd.x;ptEnd.y=pt3dEnd.y;
	ptArr.append(ptEnd);
	ptSt=ptEnd;
	for(int i=0;i<numCtlPts;i++){
		pSpl->getControlPointAt(i,pt3dEnd);
		ptEnd.x=pt3dEnd.x;ptEnd.y=pt3dEnd.y;
		if(ptSt==ptEnd) continue;
		ptArr.append(ptEnd);
		ptSt=ptEnd;
	}
}
int CEL2PL::getPlinePoints(AcDbSpline* pSpl, AcGePoint2dArray& ptArr)
{
	ptArr.setLogicalLength(0);
	double dParamSt,dParamEnd;
	if(Acad::eOk != pSpl->getStartParam(dParamSt) || Acad::eOk != pSpl->getEndParam(dParamEnd)){
		return 0;
	}

	//拟合点数
	AcGePoint3d ptTmp,ptLast;
	AcGePoint3dArray arCtlPt;
	int numFitPts;
	if(pSpl->hasFitData())
	{
		numFitPts=pSpl->numFitPoints();
	}
	else{
		numFitPts=pSpl->numControlPoints();
		//return 0;
	}
	if(m_iSegNums>0){
		myprintf("m_iSegNums %d\n",m_iSegNums);
	}
	else{
		m_iSegNums=126+numFitPts*64;  //2夹点:127 3:159 4:191  2*(127+(numFitPts-2)*32);
		//m_iSegNums=32+numFitPts*16;
	}
	myprintf("numFitPts,m_iSegNums %d %d\n",numFitPts,m_iSegNums);

	ptArr.setPhysicalLength(m_iSegNums);

	double dStep=(dParamEnd - dParamSt)/(m_iSegNums); //distEnd - distSt
	double dLen=dParamSt; //distEnd;
	pSpl->getStartPoint(ptTmp);
	ptArr.append(AcGePoint2d(ptTmp.x,ptTmp.y));
	dLen += dStep;
	//AcGePointOnCurve2d ptoncurve(AcDbSpline)
	for (int i=1;i<m_iSegNums;i++){
		//pSpl->getPointAtDist(dLen,ptTmp);
		pSpl->getPointAtParam(dLen,ptTmp);
		//myprintf("pt: %.4f,%.4f \n",ptTmp.x,ptTmp.y);
		//drawPoint(ptTmp);
		ptArr.append(AcGePoint2d(ptTmp.x,ptTmp.y));
		dLen += dStep;
	}
	pSpl->getEndPoint(ptTmp);
	ptArr.append(AcGePoint2d(ptTmp.x,ptTmp.y));
	return GOOD;
}
int CEL2PL::getPlinePoints(AcDbEllipse * pEllipse, AcGePoint2dArray& ptArr)
{
	//AcDbEllipse *pEllipse = (AcDbEllipse*)pEnt;
	AcGePoint3d center;
	AcGeVector3d unitNormal;
	AcGeVector3d majorAxis;
	double radiusRatio;
	double startAngle;
	double endAngle;
	pEllipse->get(center,unitNormal,majorAxis,radiusRatio,startAngle,endAngle);
	myprintf("center:%.3f,%.3f \n",center.x,center.y);
	myprintf("majorAxis: %.3f,%.3f \n",majorAxis.x,majorAxis.y);
	myprintf("radiusRatio %.3f \n",radiusRatio);
	myprintf("startAngle %.3f \n",startAngle);
	myprintf("endAngle %.3f \n",endAngle);
	AcGePoint3d pt;
	pEllipse->getStartPoint(pt);
	myprintf("startPoint %.4f %.4f\n",pt.x,pt.y);
	pEllipse->getEndPoint(pt);
	myprintf("EndPoint %.4f %.4f\n",pt.x,pt.y);

	double dParam1=0,dParam2=0;
	pEllipse->getStartParam(dParam1);
	pEllipse->getEndParam(dParam2);
	double dLen1 = 0;
	pEllipse->getDistAtParam(dParam1,dLen1);
	double dLen2 = 0;
	pEllipse->getDistAtParam(dParam2,dLen2);
	double dLength = dLen2 - dLen1;
	//double dStep = min(10,dLength/100);
	myprintf("dParam1,dParam2,dlen,len1,len2,length: \n"
		"%.4f,%.4f,%.8f,%.4f,%.4f,%.4f\n",dParam1,dParam2,dParam2-dParam1,dLen1,dLen2,dLength);

	//
	int iCnt;
	if(radiusRatio < 0.05){
		iCnt=540;
	}else if (radiusRatio <0.1){
		iCnt=360;
	}else if (radiusRatio <0.8){
		iCnt=180;
	}else {
		iCnt=90;
	}

	iCnt= int( iCnt*(dParam2-dParam1) /(m_twopi) +0.5);
	myprintf("icnt:%d\n",iCnt);
	// iCnt=16;//for test

	double dLen=0; 
	double aini=dParam1;
	//double afin=6.28318530717958647692;
	double SinArc = (dParam2-dParam1) / ((double)iCnt);
	double SemiAxisMajor=majorAxis.x;
	double Rapp=radiusRatio;
	Acad::ErrorStatus es;
	for (int j=0;j<=iCnt;j++)
	{
		//椭圆上点坐标计算公式:
		//pt.x = (SemiAxisMajor * cos(aini));
		//pt.y = (SemiAxisMajor * sin(aini)) * Rapp;
		//pt.z=0;
		//es=pEllipse->getDistAtParam(aini,dLen);
		//es=pEllipse->getPointAtDist(dLen, pt);
		es=pEllipse->getPointAtParam(aini,pt);
		assert(es==Acad::eOk);
		ptArr.append(AcGePoint2d(pt.x,pt.y));
		//myprintf("aini dLen pt:%.4f, %.4f, %.4f, %.4f\n",aini,dLen,pt.x,pt.y);
		es=pEllipse->getPointAtParam(aini + SinArc/2,pt);
		assert(es==Acad::eOk);
		ptArr.append(AcGePoint2d(pt.x,pt.y));
		//myprintf(" pt: %.4f, %.4f\n",pt.x,pt.y);
		aini += SinArc;
	}
	return GOOD;
}

int CEL2PL::starSPL2PL(void)
{
	//1, 选择实体
	m_iSegNums=0;
	/*CAcModuleResourceOverride resOverride;
	CEL2PLDialog dlgE2P(acedGetAcadFrame());
	dlgE2P.m_segnum="0";
	int iSel=dlgE2P.DoModal();
	m_iSegNums=atoi(dlgE2P.m_segnum);
	acutPrintf("dlgSpl: %d \n",m_iSegNums);*/
	int iSel=getSelect();
	if(iSel==0){
		return 0;
	}

	ads_name ss,ss1;
	CStringList strent;
	strent.AddHead("SPLINE");
	if(getSelectSet(iSel,strent,ss))
		return 0;

	//2,处理实体
	/*
	//选择精度
	//CAcModuleResourceOverride resOverride;
	CSPLDIALOG dlgSpl(acedGetAcadFrame());
	iSel=dlgSpl.DoModal();
	//myprintf("dlgSpl ret: %d\n",iSel);
	if(iSel!=IDOK){
		return BAD;
	}
	iSel=dlgSpl.iSel;
	m_dSegfactor=1.0 / mypower(10,iSel+1);
	*/
	m_dSegfactor=1E-8;
	//acutPrintf("dlgSpl m_dSegfactor: %d %.12f\n",iSel,m_dSegfactor);

	long length;
	if (acedSSLength(ss, &length) != RTNORM) {
		acedSSFree(ss);
		return BAD;
	}
	//setMylog(1);
	for (int i=0;i<length;i++){
		if (acedSSName(ss, i, ss1) != RTNORM) break;
		spline2polyline(ss1);
	}	
	mysynclog();
	//setMylog(0);
	acedSSFree(ss);
	return GOOD;
}
int CEL2PL::MText2DText()
{
	ads_name ss,ss1;
	struct resbuf *XreDa;
	XreDa=acutBuildList(RTDXF0,"MTEXT",0); //实体=MTEXT
	if (acedSSGet("X", NULL, NULL, XreDa, ss)!=RTNORM){
		acutPrintf("没有选择!\n");
		acutRelRb(XreDa);
		return BAD;
	}
	acutRelRb(XreDa);
	long length;
	if (acedSSLength(ss, &length) != RTNORM) 
		return BAD;
	for (int i=0;i<length;i++)
	{
		if (acedSSName(ss, i, ss1) != RTNORM) 
			break;
		acedCommand(RTSTR,"EXPLODE",RTENAME,ss1,RTNONE,0);
	}
	acedSSFree(ss);
	return 0;
}
int CEL2PL::starText2PL(int sel)
{
	int retCmd=acedCommand(RTNONE);
	if(retCmd!=RTNORM){
		acutPrintf("acedCommand failed!%d\n",retCmd);
		return 1;
	}
	//acedInitGet(RSG_NONULL | RSG_NOZERO | RSG_NONEG, NULL);
	MText2DText();
	ads_name ss, ss1;
	int iSel;
	CString sLayer;
	if(sel==0){
		CAcModuleResourceOverride resOverride;
		CTEXT2PLSEL mydlg(acedGetAcadFrame());
		mydlg.m_widen=TRUE;
		iSel=mydlg.DoModal();
		sLayer=mydlg.layername;
		m_bWiden=mydlg.m_widen;
	}else{
		iSel=IDC_ALL;
	}/*
	//todo: 取消命令
	iSel=IDC_ALL;
	sLayer="0";
	m_bWiden=FALSE;*/
	//acedGetInt("\n1,选择 2,指定层 3,全部: ",&iSel);

	struct resbuf *XreDa;
	if(iSel==IDC_SELECT){	//按提示生成选择集
		XreDa=acutBuildList(-4,_T("<or"),
			RTDXF0,_T("TEXT"),			//实体=TEXT
			RTDXF0,_T("ATTDEF"),			//实体=ATTDEF
			-4,_T("or>"),0);
		if (acedSSGet(NULL, NULL, NULL, XreDa, ss)!=RTNORM){
			acutPrintf("没有选择!\n");
			acutRelRb(XreDa);
			return BAD;
		}
		acutRelRb(XreDa);
	}else if(iSel==IDC_ONELAYER){ //指定层
		//acedGetString(0,"请输入层名:",sLayer);
		acutPrintf("layer:%s!\n",sLayer);
		XreDa=acutBuildList(-4,_T("<and"),
			-4,_T("<or"),
			RTDXF0,_T("TEXT"),			//实体=TEXT
			RTDXF0,_T("ATTDEF"),			//实体=ATTDEF
			-4,_T("or>"),
			AcDb::kDxfLayerName,_T(sLayer),//层=sLayer
			-4,_T("and>"),0);
		if (acedSSGet("X",NULL,NULL,XreDa,ss)!=RTNORM) {
			acutPrintf("没有选择!\n");
			acutRelRb(XreDa);
			return BAD;
		}
		acutRelRb(XreDa);
		if(visableAllLayer()!=Acad::eOk) return 1;
	}else if(iSel==IDC_ALL){ //全部
		acutPrintf("all layer!\n");
		XreDa=acutBuildList(-4,_T("<or"),
			RTDXF0,_T("TEXT"),			//实体=TEXT
			RTDXF0,_T("ATTDEF"),			//实体=MTEXT
			-4,_T("or>"),0);
		if (acedSSGet("X",NULL,NULL,XreDa,ss)!=RTNORM) {
			acutPrintf("没有选择!\n");
			acutRelRb(XreDa);
			return BAD;
		}
		acutRelRb(XreDa);
		if(visableAllLayer()!=Acad::eOk) return 1;
	}else{
		acutPrintf("没有选择\n");
		return BAD;
	}

	long length;
	if (acedSSLength(ss, &length) != RTNORM)
		return BAD;

	if(m_bWiden){
		CText2PLDialog dlgText(acedGetAcadFrame());
		dlgText.m_widthhigh = "0.1";
		iSel=dlgText.DoModal();
		if(iSel==IDOK){
			CString str=dlgText.m_widthhigh;
			acutPrintf("text: %s !\n",str);
			m_linewidth=atof(str);
		}
	}

	setMylog(0);
	ads_name last;
	m_textcnt=length;
	for (int i=0;i<length;i++)
	{
		if (acedSSName(ss, i, ss1) != RTNORM) 
			break;
		text2polyline(ss1);
		//mysynclog();
	}
	mysynclog();
	//setMylog(0);
	acedSSFree(ss);

	purgeBlockRef();
	acedSSFree(ss);
	return GOOD;
}
int CEL2PL::getSegLineBugle(AcGePoint2d &ptSt,AcGePoint2d &ptEnd, double &dBulge)
{
	double dAngle=acutAngle(asDblArray(ptSt),asDblArray(ptEnd));
	ads_point cpt,pt1,pt2,pt3;
	pt1[0]=ptEnd.x;pt1[1]=ptEnd.y;
	acutPolar(pt1, dAngle-90*m_pi/180, m_linewidth/2 ,cpt);//圆心
	acutPolar(cpt, dAngle, m_linewidth/2 ,pt2);//弧上的点
	acutPolar(cpt, dAngle-90*m_pi/180, m_linewidth/2, pt3);//弧的终点
	getArcBulge(asPnt2d(pt1),asPnt2d(pt2),asPnt2d(pt3),dBulge);
	myprintf("%.4f,%.4f %.4f,%.4f\n",ptSt.x,ptSt.y,ptEnd.x,ptEnd.y);
	myprintf("%.4f \n",dAngle);
	myprintf("%.4f,%.4f %.4f,%.4f\n",cpt[0],cpt[1],pt2[0],pt2[1]);
	return 0;
}
int CEL2PL::getSegArcBugle(AcGePoint2d &ptEnd, double dAngEnd, double &dBulge)
{
	ads_point cpt,pt1,pt2,pt3;
	pt1[0]=ptEnd.x; pt1[1]=ptEnd.y;
	acutPolar(pt1, dAngEnd, m_linewidth/2,cpt);//圆心
	acutPolar(cpt, dAngEnd-90*m_pi/180, m_linewidth/2 ,pt2);//弧上的点
	acutPolar(cpt, dAngEnd, m_linewidth/2, pt3);//弧的终点
	getArcBulge(asPnt2d(pt1),asPnt2d(pt2),asPnt2d(pt3),dBulge);
	myprintf("%.4f,%.4f %.4f,%.4f\n",cpt[0],cpt[1],pt2[0],pt2[1]);
	return 0;
}
int CEL2PL::plineFromLine(AcDbCurve *pCurve,AcDbPolyline *pNewPline,int ptIdx,int direct)
{
	if(pCurve->isKindOf(AcDbLine::desc())){
		AcGePoint3d ptTmp1,ptTmp2;
		double dBulge;
		if(direct){ //正向
			pCurve->getStartPoint(ptTmp1);
			pCurve->getEndPoint(ptTmp2);
		}
		else{ //反向
			pCurve->getEndPoint(ptTmp1);
			pCurve->getStartPoint(ptTmp2);
		}
		pNewPline->addVertexAt(ptIdx,AcGePoint2d(ptTmp1.x,ptTmp1.y),0);
		ptIdx++;
		if(m_bWidenFillet){
			getSegLineBugle(AcGePoint2d(ptTmp1.x,ptTmp2.y), AcGePoint2d(ptTmp2.x,ptTmp2.y), dBulge);
		}else{
			dBulge=0;
		}
		pNewPline->addVertexAt(ptIdx,AcGePoint2d(ptTmp2.x,ptTmp2.y),dBulge);
		ptIdx++;
	}else if (pCurve->isKindOf(AcDbArc::desc())){
		AcGePoint3d ptTmp1,ptTmp2;
		double dAngSt,dAngEnd;
		AcDbArc *pArc=(AcDbArc *)pCurve;
		double dBulge,dRadius;
		getArcBulge(pArc,dBulge);
		if(direct){ //正向
			pCurve->getStartPoint(ptTmp1);
			pCurve->getEndPoint(ptTmp2);
			dAngSt=pArc->startAngle();
			dAngEnd=pArc->endAngle();
		}
		else{ //反向
			pCurve->getEndPoint(ptTmp1);
			pCurve->getStartPoint(ptTmp2);
			dBulge=-dBulge;
			dAngSt=pArc->endAngle();
			dAngEnd=pArc->startAngle();
		}
		pNewPline->addVertexAt(ptIdx,AcGePoint2d(ptTmp1.x,ptTmp1.y),dBulge);
		ptIdx++;
		if(m_bWidenFillet){
			getSegArcBugle(AcGePoint2d(ptTmp2.x,ptTmp2.y),dAngEnd,dBulge);
		}else{
			dBulge=0;
		}
		pNewPline->addVertexAt(ptIdx,AcGePoint2d(ptTmp2.x,ptTmp2.y),dBulge);
		ptIdx++;
	}else if (pCurve->isKindOf(AcDbPolyline::desc())){
		AcDbPolyline *pPlineTmp=(AcDbPolyline *) pCurve;
		AcGePoint2d ptSt,ptEnd;
		double dAngle;
		double dBulge;
		AcGeCircArc2d geArc;
		if(direct){
			int nSize=pPlineTmp->numVerts()-1;//最后的顶点单独计算bulge,跟bugle相关
			for(int i=0;i<nSize;i++) //0,1,2
			{
				pPlineTmp->getPointAt(i,ptSt);
				switch(pPlineTmp->segType(i)){
				case AcDbPolyline::kLine:
					pNewPline->addVertexAt(ptIdx,ptSt,0);
					ptIdx++;
					break;
				case AcDbPolyline::kArc:
					if(pPlineTmp->getBulgeAt(i,dBulge)!=Acad::eOk){
						myprintf("pNewPline->getBulgeAt !\n");
					}
					pNewPline->addVertexAt(ptIdx,ptSt,dBulge);
					ptIdx++;
					break;
				default:
					acutPrintf("未实现:segType %d\n",pPlineTmp->segType(i));
					break;
				}
			}
			if(pLineisClosed(pPlineTmp)){
				myprintf("todo: pPlineTmp->isClosed!\n");
			}else{
				pPlineTmp->getPointAt(nSize-1,ptSt);//最后线段的起点
				pPlineTmp->getPointAt(nSize,ptEnd); //最后线段的终点
				if(m_bWidenFillet){//圆角
					//最后的segType是直线还是弧?
					switch(pPlineTmp->segType(nSize-1)){
					case AcDbPolyline::kLine:
						getSegLineBugle(ptSt,ptEnd,dBulge);
						break;
					case AcDbPolyline::kArc:
						pPlineTmp->getArcSegAt(nSize-1,geArc);
						dAngle=geArc.endAng();
						getSegArcBugle(ptEnd,dAngle,dBulge);
						break;
					default:
						myprintf("未实现:segType %d\n",pPlineTmp->segType(i));
						dBulge=0;
						break;
					}
				}else{ //不圆角
					dBulge=0;
				}
				pNewPline->addVertexAt(ptIdx,ptEnd,dBulge);
				ptIdx++;
			}
		}else{
			int nSize=pPlineTmp->numVerts();
			if(pLineisClosed(pPlineTmp))
			{
				pPlineTmp->getPointAt(0,ptSt);
				pNewPline->addVertexAt(ptIdx,ptSt,0);
				ptIdx++;
			}
			for(int i=nSize-2;i>=0;i--)  //2,1,0
			{
				pPlineTmp->getPointAt(i+1,ptEnd);
				switch(pPlineTmp->segType(i)){
			case AcDbPolyline::kLine:
				pNewPline->addVertexAt(ptIdx,ptEnd,0);
				ptIdx++;
				break;
			case AcDbPolyline::kArc:
				pPlineTmp->getBulgeAt(i,dBulge);
				pNewPline->addVertexAt(ptIdx,ptEnd,-dBulge);
				ptIdx++;
				break;
			default:
				acutPrintf("未实现:segType %d\n",pPlineTmp->segType(i));
				break;
				}
			}
			pPlineTmp->getPointAt(0,ptEnd);
			pNewPline->addVertexAt(ptIdx,ptEnd,0);
			ptIdx++;
		}
	}else {
		acutPrintf("未实现: %s %s\n",__FUNCTION__,pCurve->isA()->name());
	}
	return 0;
}
//直线加宽,圆弧加宽, 可判断是否圆角
int CEL2PL::lineWiden2(AcDbCurve *pCurve,double linewidth,AcDbObjectId &objId)
{
	AcGePoint2d ptSt,ptEnd;
	//AcGePoint2dArray arLeft,arRight;
	AcDbVoidPtrArray offsetCurves;
	AcDbCurve *pcurve;
	double dBulge;
	AcDbPolyline *pNewPline=new AcDbPolyline;
	int ptIdx=0;
	AcGePoint2dArray arLines;
	AcDbDoubleArray arBugle;
	int isClosedPline=0;

	if(pCurve->isKindOf(AcDbPolyline::desc())){
		int nSize;//循环大小
		offsetCurves.setLogicalLength(0);
		pCurve->getOffsetCurves(m_linewidth/2,offsetCurves);
		nSize=offsetCurves.length();
		for(int i=0;i<nSize;i++)
		{//正向
			pcurve=(AcDbCurve *)offsetCurves[i];
			if(!pcurve->isKindOf(AcDbPolyline::desc())){
				myprintf("warning: getOffsetCurves不是polyline!\n");
				continue;
			}
			AcDbPolyline *pPLine=(AcDbPolyline *)pcurve;
			int nSize=pPLine->numVerts()-1;//段数
			for(int i=0;i<nSize;i++){
				pPLine->getPointAt(i,ptSt);
				pPLine->getPointAt(i+1,ptEnd);
				if(ptSt==ptEnd) continue;//跳过长度为0的
				arLines.append(ptSt);
				if(pPLine->getBulgeAt(i,dBulge)!=Acad::eOk){
					dBulge=0;
				}
				arBugle.append(dBulge);
				//myprintf("%.4f,%.4f %.4f ;",ptSt.x,ptSt.y,dBulge);
			}
			arLines.append(ptEnd);
			arBugle.append(0);
			if(arLines.length()>0){
				if(pPLine->isClosed()){//是闭合图形
					if(ptEnd!=arLines[0]){
						arLines.append(arLines[0]);
						arBugle.append(0);
						isClosedPline=1;
					}
				}
			}
		}
		offsetCurves.setLogicalLength(0);
		pCurve->getOffsetCurves(-m_linewidth/2,offsetCurves);
		nSize=offsetCurves.length();
		for(int i=0;i<nSize;i++)
		{//反向
			int iPos=arLines.length();
			pcurve=(AcDbCurve *)offsetCurves[i];
			if(!pcurve->isKindOf(AcDbPolyline::desc())){
				myprintf("warning: getOffsetCurves不是polyline!\n");
				continue;
			}
			AcDbPolyline *pPLine=(AcDbPolyline *)pcurve;
			int nSize=pPLine->numVerts()-1;//段数
			for(int i=nSize-1;i>=0;i--){
				pPLine->getPointAt(i,ptSt);
				pPLine->getPointAt(i+1,ptEnd);
				if(ptSt==ptEnd) continue;//跳过长度为0的
				arLines.append(ptEnd);
				if(pPLine->getBulgeAt(i,dBulge)!=Acad::eOk){
					dBulge=0;
				}
				arBugle.append(-dBulge);
				//myprintf("%.4f,%.4f %.4f ;",ptSt.x,ptSt.y,dBulge);
			}
			arLines.append(ptSt);
			arBugle.append(0);
			if(arLines.length()>0){
				if(pPLine->isClosed()){//是闭合图形
					if(ptSt!=arLines[iPos]){
						arLines.append(arLines[iPos]);
						arBugle.append(0);
					}
				}
			}
		}
		int nSizeAll=arLines.length();
		int nSizeHalf=nSizeAll/2;
		if(m_bWidenFillet){//todo: nSize<2
			//构造圆角的数组结构: 一系列圆
			AcDbVoidPtrArray arCircle;
			AcDbPolyline *pPolyline=(AcDbPolyline *)pCurve;
			int nSize=pPolyline->numVerts();
			double dHalfWidth=linewidth/2;
			pPolyline->getPointAt(0,ptSt);
			AcGeCircArc2d *pGeCir=new AcGeCircArc2d(ptSt,dHalfWidth);
			arCircle.append(pGeCir);
			for(int i=1;i<nSize;i++){
				pPolyline->getPointAt(i-1,ptSt);
				pPolyline->getPointAt(i,ptEnd);
				if(ptSt==ptEnd)continue;
				AcGeCircArc2d *pGeCir=new AcGeCircArc2d(ptEnd,dHalfWidth);
				arCircle.append(pGeCir);
			}
			//构造多义线: 分成两段构造,Seg#1
			AcGePoint2d ptCenter,pnt1,pnt2;
			double dAngSt,dAngEnd;
			int iPos;
			pNewPline->addVertexAt(ptIdx,arLines[0],arBugle[0]);
			ptIdx++;
			iPos=1;
			for(int i=iPos;i<nSizeHalf-1;i++){
				myprintf("正向:%d %d %.4f\n",i,i,arBugle[i]);
				if(m_bWidenTwoEnd){
					pNewPline->addVertexAt(ptIdx,arLines[i],arBugle[i]);
					ptIdx++;
				}else{
					if(getFilletPoints((AcGeCircArc2d *)arCircle[i],
						arLines[i-1],arLines[i],arLines[i+1],arBugle[i-1],arBugle[i],
						pnt1,pnt2,dBulge)){
                        pNewPline->addVertexAt(ptIdx,pnt1,dBulge);
						ptIdx++;
						pNewPline->addVertexAt(ptIdx,pnt2,arBugle[i]);
						ptIdx++;
					}else{
						pNewPline->addVertexAt(ptIdx,arLines[i],arBugle[i]);
						ptIdx++;
					}
				}
			}
			if(isClosedPline){
				myprintf("处理多义线两头1: 闭合图形%.4f,%.4f\n",arLines[nSizeHalf].x,arLines[nSizeHalf].y);
				if(getFilletPoints((AcGeCircArc2d *)arCircle[0],arLines[nSizeHalf-2],arLines[0],arLines[1],arBugle[nSizeHalf],arBugle[0],pnt1,pnt2,dBulge)){
					if(pnt1!=pnt2){
						pNewPline->addVertexAt(ptIdx,pnt1,dBulge);
						ptIdx++;
						pNewPline->addVertexAt(ptIdx,pnt2,0);
						ptIdx++;
						//调整polyline第一点
						arLines[0]=pnt2;
						pNewPline->setPointAt(0,pnt2);
					}else{
						pNewPline->addVertexAt(ptIdx,arLines[nSizeHalf-1],0);
						ptIdx++;
					}
				}else{
					pNewPline->addVertexAt(ptIdx,arLines[nSizeHalf-1],0);
					ptIdx++;
				}
			}else{
				//处理多义线两头#1 arCircle[nSize-1] 开始点arLines[nSizeHalf-1] 结束点arLines[nSizeHalf]
				pGeCir=(AcGeCircArc2d *)arCircle[nSize-1];
				ptCenter=pGeCir->center();
				dAngSt=acutAngle(asDblArray(ptCenter),asDblArray(arLines[nSizeHalf-1]));
				dAngEnd=acutAngle(asDblArray(ptCenter),asDblArray(arLines[nSizeHalf]));
				pGeCir->setAngles(dAngSt,dAngEnd);
				getArcBulge(*pGeCir,dBulge);
				myprintf("处理多义线两头1: %.4f %.4f %.4f,%.4f\n",dAngSt,dAngEnd,arLines[nSizeHalf].x,arLines[nSizeHalf].y);
				pNewPline->addVertexAt(ptIdx,arLines[nSizeHalf-1],dBulge);
				ptIdx++;
			}
			//构造多义线: 分成两段构造,Seg#2
			
			//起点,不需处理倒角
			pNewPline->addVertexAt(ptIdx,arLines[nSizeHalf],arBugle[nSizeHalf]);
			ptIdx++;

			iPos=nSizeHalf+1;	//相当于正向的1
			int iCir=nSizeHalf-2;//倒数第2个圆,相当于正向的1
			for(int i=iPos;i<nSizeAll-1;i++,iCir--){
				myprintf("反向:%d %d %.4f\n",i,iCir,arBugle[i]);
				if(m_bWidenTwoEnd){
					pNewPline->addVertexAt(ptIdx,arLines[i],arBugle[i]);
					ptIdx++;
				}else{
					pGeCir=(AcGeCircArc2d *)arCircle[iCir];
					myprintf("circle:%.4f,%.4f\n",pGeCir->center().x,pGeCir->center().y);
					if(getFilletPoints((AcGeCircArc2d *)arCircle[iCir],arLines[i-1],arLines[i],arLines[i+1],arBugle[i-1],arBugle[i],pnt1,pnt2,dBulge)){
						pNewPline->addVertexAt(ptIdx,pnt1,dBulge);
						ptIdx++;
						pNewPline->addVertexAt(ptIdx,pnt2,arBugle[i]);
						ptIdx++;
					}else /*  */
					{
						pNewPline->addVertexAt(ptIdx,arLines[i],arBugle[i]);
						ptIdx++;
					}
				}
			}

			//处理多义线两头#2 arCircle[0] 开始点arLines[nSizeAll-1] 结束点arLines[0]
			if(isClosedPline){
				myprintf("处理多义线两头1: 闭合图形%.4f,%.4f\n",arLines[nSizeHalf].x,arLines[nSizeHalf].y);
				dBulge=0;
			}else{
				pGeCir=(AcGeCircArc2d *)arCircle[0];
				ptCenter=pGeCir->center();
				dAngSt=acutAngle(asDblArray(ptCenter),asDblArray(arLines[nSizeAll-1]));
				dAngEnd=acutAngle(asDblArray(ptCenter),asDblArray(arLines[0]));
				pGeCir->setAngles(dAngSt,dAngEnd);
				getArcBulge(*pGeCir,dBulge);
				myprintf("处理多义线两头2: %.4f,%.4f %.4f,%.4f\n",pGeCir->startPoint().x,pGeCir->startPoint().y,arLines[0].x,arLines[0].y);
			}
			pNewPline->addVertexAt(ptIdx,arLines[nSizeAll-1],dBulge);
			ptIdx++;

			nSizeAll=arCircle.length();
			for(int i=0;i<nSizeAll;i++){
				delete arCircle[i];
			}
			arCircle.setLogicalLength(0);
			/* ptSt=arLines[nSizeHalf-1];
			ptEnd=arLines[nSizeHalf];
			AcGeLineSeg2d geLine(ptSt,ptEnd);
			AcGePoint2d cpt=geLine.midPoint();
			AcGePoint2d pt2=ptSt;
			pt2.rotateBy(90*m_pi/180,cpt);
			myprintf("\ncirBugle: %.4f,%.4f %.4f,%.4f %.4f,%.4f\n",ptSt.x,ptSt.y,pt2.x,pt2.y,ptEnd.x,ptEnd.y);
			getArcBulge(ptSt,pt2,ptEnd,dBulge);
			arBugle[nSizeHalf-1]=dBulge;
			arBugle[nSizeAll-1]=dBulge;*/
		}else{
			arBugle[nSizeHalf-1]=0;
			arBugle[nSizeAll-1]=0;
			for(int i=0;i<nSizeAll;i++){
				pNewPline->addVertexAt(ptIdx,arLines[i],arBugle[i]);
				ptIdx++;
			}
		}
		/*{myprintf("\nafter append:\n");
		int nSize=arLines.length();
		for(int i=0;i<nSize;i++){
			myprintf("%d %.4f,%.4f %.4f ;",i,arLines[i].x,arLines[i].y,arBugle[i]);
		}
		myprintf("\n");}*/
	}
	else{
		offsetCurves.setLogicalLength(0);
		pCurve->getOffsetCurves(m_linewidth/2,offsetCurves);
		for(int i=0;i<offsetCurves.length();i++)
		{
			pcurve=(AcDbCurve *)offsetCurves[i];
			myprintf("%d %s\n",i,pcurve->isA()->name());
			plineFromLine(pcurve,pNewPline,ptIdx,1);
			////postToDatabase(pcurve,objId);
			pcurve->close();
		}
		offsetCurves.setLogicalLength(0);
		pCurve->getOffsetCurves(-m_linewidth/2,offsetCurves);
		for(int i=0;i<offsetCurves.length();i++)
		{
			pcurve=(AcDbCurve *)offsetCurves[i];
			myprintf("%d %s\n",i,pcurve->isA()->name());
			plineFromLine(pcurve,pNewPline,ptIdx,0);
			//postToDatabase(pcurve,objId);
			pcurve->close();
		}
	}
	pNewPline->setClosed(TRUE);
	pNewPline->setLayer(m_layerid);
	pNewPline->setColor(m_color);
	postToDatabase(pNewPline,objId);
	pNewPline->close();
	return 0;
}
//直线加宽,总是圆角
int CEL2PL::lineWiden(AcDbLine *pLine,double linewidth,AcDbObjectId &objId)
{
	ads_point pt1,pt2; 

	AcGePoint3d ptTmp;
	pLine->getStartPoint(ptTmp);
	pt1[0]=ptTmp.x;
	pt1[1]=ptTmp.y;
	pt1[2]=0;
	pLine->getEndPoint(ptTmp);
	pt2[0]=ptTmp.x;
	pt2[1]=ptTmp.y;
	pt2[2]=0;
	
	if(acutDistance(pt1,pt2)<0.0001){
		return 0;
	}

	double widthHalf=linewidth / 2;

	AcDbPolyline *pLWPolyline=new AcDbPolyline;
	int ptIdx=0;

	double Dist,Angle1,Angle2;
	Dist=acutDistance(pt1,pt2); //距离
	Angle1=acutAngle(pt1,pt2);  //角度
	Angle2=Angle1+90*m_pi/180; 
	ads_point mp1,mp2,mp3,mp4,cp1,cp2;
	double dBulge;
	acutPolar(pt1,Angle1+90*m_pi/180,widthHalf,mp1); //逆时钟90度
	acutPolar(pt1,Angle1+180*m_pi/180,widthHalf,cp1);//逆时钟180度
	acutPolar(pt1,Angle1+270*m_pi/180,widthHalf,mp2);//逆时钟270度
	getArcBulge(AcGePoint2d(mp1[0],mp1[1]),AcGePoint2d(cp1[0],cp1[1]),AcGePoint2d(mp2[0],mp2[1]),dBulge);

	pLWPolyline->addVertexAt(ptIdx,AcGePoint2d(mp1[0],mp1[1]),dBulge);
	ptIdx++;
	pLWPolyline->addVertexAt(ptIdx,AcGePoint2d(mp2[0],mp2[1]),0);
	ptIdx++;

	acutPolar(pt2,Angle1+270*m_pi/180,widthHalf,mp3); //逆时钟270度
	acutPolar(pt2,Angle1+360*m_pi/180,widthHalf,cp2);//逆时钟360度
	acutPolar(pt2,Angle1+90*m_pi/180,widthHalf,mp4);//逆时钟90度
	getArcBulge(AcGePoint2d(mp3[0],mp3[1]),AcGePoint2d(cp2[0],cp2[1]),AcGePoint2d(mp4[0],mp4[1]),dBulge);	
	pLWPolyline->addVertexAt(ptIdx,AcGePoint2d(mp3[0],mp3[1]),dBulge);
	ptIdx++;
	pLWPolyline->addVertexAt(ptIdx,AcGePoint2d(mp4[0],mp4[1]),0);
	ptIdx++;
	pLWPolyline->setClosed(Adesk::kTrue);
	pLWPolyline->setLayer(m_layerid);
	pLWPolyline->setColor(m_color);
	postToDatabase(pLWPolyline,objId);
	pLWPolyline->close();
	return 0;
}

int CEL2PL::lineWiden(AcDbArc *pArc,double linewidth,AcDbObjectId &objId)
{
	ads_point pt1,pt2;

	AcGePoint3d ptTmp;
	pArc->getStartPoint(ptTmp);
	pt1[0]=ptTmp.x;
	pt1[1]=ptTmp.y;
	pt1[2]=0;
	pArc->getEndPoint(ptTmp);
	pt2[0]=ptTmp.x;
	pt2[1]=ptTmp.y;
	pt2[2]=0;

	double widthHalf=linewidth / 2;

	AcDbPolyline *pLWPolyline=new AcDbPolyline;
	int ptIdx=0;
	
	AcGePoint2d cpt;
	double dRadius,dBulge;
	double endAngle,startAngle,dAngle;
	cpt.x=pArc->center().x;
	cpt.y=pArc->center().y;
	dRadius=pArc->radius();
	startAngle=pArc->startAngle();
	endAngle=pArc->endAngle();
	
	//计算Bugle
	AcGeCircArc2d pGArc(cpt,dRadius,startAngle,endAngle);
	startAngle=pGArc.startAng();
	endAngle=pGArc.endAng();

	if (endAngle<startAngle) endAngle+= m_pi*2; // 8*atan(1.0);
	dAngle=endAngle-startAngle;
	dBulge=tan(dAngle/4);
	if(pGArc.isClockWise()) dBulge = -dBulge;

	pGArc.setRadius(dRadius + widthHalf);
	pt1[0]=pGArc.startPoint().x;
	pt1[1]=pGArc.startPoint().y;
	pt1[2]=0;
	pLWPolyline->addVertexAt(ptIdx,asPnt2d(pt1),dBulge);
	ptIdx++;
	pt1[0]=pGArc.endPoint().x;
	pt1[1]=pGArc.endPoint().y;
	pt1[2]=0;
	pLWPolyline->addVertexAt(ptIdx,asPnt2d(pt1),0);
	ptIdx++;

	pGArc.setRadius(dRadius - widthHalf);
	pt1[0]=pGArc.endPoint().x;
	pt1[1]=pGArc.endPoint().y;
	pLWPolyline->addVertexAt(ptIdx,asPnt2d(pt1),-dBulge);
	ptIdx++;
	
	pt1[0]=pGArc.startPoint().x;
	pt1[1]=pGArc.startPoint().y;
	pLWPolyline->addVertexAt(ptIdx,asPnt2d(pt1),0);
	ptIdx++;

	pLWPolyline->setClosed(Adesk::kTrue);
	pLWPolyline->setLayer(m_layerid);
	pLWPolyline->setColor(m_color);
	postToDatabase(pLWPolyline,objId);
	pLWPolyline->close();
	return 0;
}
int CEL2PL::pLineCopy1(AcDbPolyline *pPlineTmp,AcDbPolyline *pNewPline,int &ptIdx)
{
	AcGePoint2d ptSt,ptEnd;
	double dBulge;
	int nSize=pPlineTmp->numVerts()-1;
	for(int i=0;i<nSize;i++) //0,1,2
	{
		pPlineTmp->getPointAt(i,ptSt);
		switch(pPlineTmp->segType(i)){
			case AcDbPolyline::kLine:
				pNewPline->addVertexAt(ptIdx,ptSt,0);
				ptIdx++;
				break;
			case AcDbPolyline::kArc:
				if(pPlineTmp->getBulgeAt(i,dBulge)!=Acad::eOk){
					myprintf("pNewPline->getBulgeAt !\n");
				}
				pNewPline->addVertexAt(ptIdx,ptSt,dBulge);
				ptIdx++;
				break;
			default:
				acutPrintf("未实现:segType %d\n",pPlineTmp->segType(i));
				break;
		}
	}
	pPlineTmp->getPointAt(nSize,ptSt);
	pNewPline->addVertexAt(ptIdx,ptSt,0);
	ptIdx++;
	if(pLineisClosed(pPlineTmp))
	{
		pPlineTmp->getPointAt(0,ptSt);
		pNewPline->addVertexAt(ptIdx,ptSt,0);
		ptIdx++;
	}
	return 0;
}
int CEL2PL::pLineCopy2(AcDbPolyline *pPlineTmp,AcDbPolyline *pNewPline,int &ptIdx)
{
	AcGePoint2d ptSt,ptEnd;
	double dBulge;
	int nSize=pPlineTmp->numVerts();
	if(pLineisClosed(pPlineTmp))
	{
		pPlineTmp->getPointAt(0,ptSt);
		pNewPline->addVertexAt(ptIdx,ptSt,0);
		ptIdx++;
	}
	for(int i=nSize-2;i>=0;i--)  //2,1,0
	{
		pPlineTmp->getPointAt(i+1,ptEnd);
		switch(pPlineTmp->segType(i)){
			case AcDbPolyline::kLine:
				pNewPline->addVertexAt(ptIdx,ptEnd,0);
				ptIdx++;
				break;
			case AcDbPolyline::kArc:
				pPlineTmp->getBulgeAt(i,dBulge);
				pNewPline->addVertexAt(ptIdx,ptEnd,-dBulge);
				ptIdx++;
				break;
			default:
				acutPrintf("未实现:segType %d\n",pPlineTmp->segType(i));
				break;
		}
	}
	pPlineTmp->getPointAt(0,ptEnd);
	pNewPline->addVertexAt(ptIdx,ptEnd,0);
	ptIdx++;
	return 0;
}
//多义线加宽
int CEL2PL::lineWiden(AcDbPolyline *pPLine,double linewidth,AcDbObjectId &objId)
{
	AcGePoint2d ptSt,ptEnd;
	AcGePoint2dArray arLeft,arRight;
	AcDbVoidPtrArray offsetCurves;
	AcDbCurve *pcurve;
	double dBulge;
	offsetCurves.setLogicalLength(0);
	AcDbPolyline *pNewPline=new AcDbPolyline;
	int ptIdx=0;
	pPLine->getOffsetCurves(m_linewidth/2,offsetCurves);
	for(int i=0;i<offsetCurves.length();i++)
	{
		pcurve=(AcDbCurve *)offsetCurves[i];
		myprintf("%d %s\n",i,pcurve->isA()->name());
		if(pcurve->isKindOf(AcDbPolyline::desc()))
		{
			pLineCopy1((AcDbPolyline *)pcurve,pNewPline,ptIdx);
		}else{
			acutPrintf("未实现: %s\n",pcurve->isA()->name());
		}
		//postToDatabase(pcurve,objId);
		pcurve->close();
	}
	offsetCurves.setLogicalLength(0);
	pPLine->getOffsetCurves(-m_linewidth/2,offsetCurves);
	for(int i=0;i<offsetCurves.length();i++)
	{
		pcurve=(AcDbCurve *)offsetCurves[i];
		myprintf("%d %s\n",i,pcurve->isA()->name());
		if(pcurve->isKindOf(AcDbPolyline::desc()))
		{
			pLineCopy2((AcDbPolyline *)pcurve,pNewPline,ptIdx);
		}else{
			acutPrintf("未实现: %s\n",pcurve->isA()->name());
		}
		//postToDatabase(pcurve,objId);
		pcurve->close();
	}
	pNewPline->setClosed(TRUE);
	pNewPline->setLayer(m_layerid);
	pNewPline->setColor(m_color);
	postToDatabase(pNewPline,objId);
	pNewPline->close();
	return 0;
}

int CEL2PL::widenArc(ads_name ss1)
{
	AcDbObjectId eId;
	AcDbEntity * pEntSS1;
	if( acdbGetObjectId(eId, ss1) != Acad::eOk)
	{
		acutPrintf("open object fail!\n");
		return 0;
	}
	if( acdbOpenObject(pEntSS1, eId, kForWrite) != Acad::eOk) //kForRead; kForWrite;
	{
		acutPrintf("open object fail!\n");
		return 0;
	}
	if(isOnLockedLayer(pEntSS1,true)){
		pEntSS1->close();
		return 0;
	}	
	m_layerid=pEntSS1->layerId();
	m_color=pEntSS1->color();
	int isConvOk=1;
	if(lineWiden2((AcDbLine*)pEntSS1,m_linewidth,eId)){
		acutPrintf("%s:%s\n",__FUNCTION__,pEntSS1->isA()->name());
	}
	pEntSS1->erase();
	pEntSS1->close();
	return 0;
}
struct resbuf * CEL2PL::entItem(struct resbuf *textent,short irestype)
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
int CEL2PL::Poly2dToLWPoly(AcDb2dPolyline *pPoly,AcDbPolyline *& pLwpoly)
{
	int isConvOk=1;
	int pidx=0;
	AcGePoint3d ptSt,ptEnd;
	AcDbVoidPtrArray entitySe2;
	pPoly->explode(entitySe2);
	for(int j=0;j<entitySe2.length();j++){
		AcDbCurve *pEntitytem2 =(AcDbCurve *)entitySe2.at(j);
		if(pEntitytem2->isKindOf(AcDbLine::desc())){
			((AcDbLine *)pEntitytem2)->getStartPoint(ptSt);
			((AcDbLine *)pEntitytem2)->getEndPoint(ptEnd);
			pLwpoly->addVertexAt(pidx,AcGePoint2d(ptSt.x,ptSt.y));
			pidx++;
		}else{
			isConvOk=0;
			acutPrintf("text2polyline: %s\n",pEntitytem2->isA()->name());
		}
	}
	pLwpoly->addVertexAt(pidx,AcGePoint2d(ptEnd.x,ptEnd.y));
	return isConvOk;
}
int CEL2PL::doEntitySetWiden (AcDbVoidPtrArray &entitySet)
{
	int isConvOk=1;
	AcDbObjectId eId;
	for(int i=0;i<entitySet.length();i++){
		AcDbCurve *pEntitytemp =(AcDbCurve *)entitySet.at(i);
		if(pEntitytemp->isKindOf(AcDb2dPolyline::desc())){
			AcDb2dPolyline *p2dpolyline=(AcDb2dPolyline *)pEntitytemp;
			AcDbVoidPtrArray entitySe2;
			pEntitytemp->explode(entitySe2);
			for(int j=0;j<entitySe2.length();j++){
				AcDbCurve *pEntitytem2 =(AcDbCurve *)entitySe2.at(j);
				if(pEntitytem2->isKindOf(AcDbLine::desc())){
					if(m_iWidthHeight==1){  //线宽
						lineWiden((AcDbLine *)pEntitytem2,m_linewidth,eId);
					}else{ //if(m_iWidthHeight==2){ 高度比
						lineWiden((AcDbLine *)pEntitytem2,m_linewidth * m_textheight,eId);
					}
				}else{
					isConvOk=0;
					acutPrintf("  2:%s\n",pEntitytem2->isA()->name());
				}
			}
		}
	}
	return isConvOk;
}
//交换排序法
int CEL2PL::sortEnts(AcGePoint2dArray &arLines,AcDbDoubleArray &arBuggle)
{
	//排序直线
	AcDbEntity * pEnt;
	AcGePoint3d ptSt,ptEnd;
	//myprintf("直线排序成首尾相连的环\n");
	int iFound=0;
	int nSize=arLines.length();
	AcGePoint2d ptTmp;
	double dBulgeTmp;
	int iTmp,jTmp;
	if(nSize <= 0){
		return 0;
	}
	for(int i=0;i<nSize;i+=2)
	{
		//if(ptArr[i])continue;
		for(int j=i+2;j<nSize;j+=2)
		{
			//if(ptArr[j])continue;
			if(arLines[j]==arLines[i+1]) { //j.ptSt=i.ptEnd 交换j.ptSt和i.next.ptSt
				if(j!=i+2){
					//交换j和i+2
					//myprintf("swap:%d,%d %.4f %.4f %.4f %.4f\n",i,j,arLines[j].x,arLines[j].y,arLines[i+1].x,arLines[i+1].y);
					ptTmp=arLines[j];
					arLines[j]=arLines[i+2];					
					arLines[i+2]=ptTmp;
					ptTmp=arLines[j+1];
					arLines[j+1]=arLines[i+3];
					arLines[i+3]=ptTmp;

					jTmp=j/2;iTmp=(i+2)/2;
					dBulgeTmp=arBuggle[jTmp];
					arBuggle[jTmp]=arBuggle[iTmp];
					arBuggle[iTmp]=dBulgeTmp;
				}
				break;
			}
			else if(arLines[j+1]==arLines[i+1]) { 
				if(j==i+2) //j.ptEnd=j.ptStart,
				{
					ptTmp=arLines[j];
					arLines[j]=arLines[j+1];
					arLines[j+1]=ptTmp;

				}else{//j.ptEnd=i.ptEnd	交换j.ptEnd和i.next.ptSt
					ptTmp=arLines[j];
					arLines[j]=arLines[i+3];					
					arLines[i+3]=ptTmp;
					ptTmp=arLines[j+1];
					arLines[j+1]=arLines[i+2];
					arLines[i+2]=ptTmp;
					
					jTmp=j/2;iTmp=(i+2)/2;
					dBulgeTmp=arBuggle[jTmp];
					arBuggle[jTmp]=arBuggle[iTmp];
					arBuggle[iTmp]=dBulgeTmp;
				}
				break;
			}

		}
	}
	/* //for debug
	myprintf("after sort:\n");
	for (int i=0;i<arLines.length();i+=2){
		drawLine(arLines[i],arLines[i+1]);
		myprintf("%d %.4f,%.4f %.4f,%.4f ;",i,arLines[i].x,arLines[i].y,arLines[i+1].x,arLines[i+1].y);
	}
	myprintf("\n");
		  */
	return 0;
}
int CEL2PL::region2Polyline(AcDbVoidPtrArray& entitySetReg )
{
	//AcGePoint3dArray ptPnt3d;
	//AcDbIntArray ptCirs;

	AcGePoint2dArray arLines;
	AcDbDoubleArray arBuggle;
	AcGePoint3d ptSt,ptEnd;

	int nEntCnt=entitySetReg.length();
	//myprintf("将直线放到数组\n");
	AcDbEntity *pEnt;
	double dBulge;
	for(int i=0;i<nEntCnt;i++){
		pEnt=(AcDbEntity *)entitySetReg[i];
		if(pEnt->isKindOf(AcDbLine::desc())){
			AcDbLine *pLine=(AcDbLine *)pEnt;
			ptSt=pLine->startPoint();
			ptEnd=pLine->endPoint();
			if(ptSt==ptEnd)	continue;
			arLines.append(AcGePoint2d(ptSt.x,ptSt.y));
			arLines.append(AcGePoint2d(ptEnd.x,ptEnd.y));
			arBuggle.append(0);
			//myprintf("%d %.5f,%.5f %.5f,%.5f\n",i,ptSt.x,ptSt.y,ptEnd.x,ptEnd.y);
		}else if(pEnt->isKindOf(AcDbArc::desc())) {
			AcDbArc *pArc=(AcDbArc *)pEnt;
			pArc->getStartPoint(ptSt);
			pArc->getEndPoint(ptEnd);
			if(ptSt==ptEnd)	continue;
			arLines.append(AcGePoint2d(ptSt.x,ptSt.y));
			arLines.append(AcGePoint2d(ptEnd.x,ptEnd.y));
			getArcBulge(pArc,dBulge);
			arBuggle.append(dBulge);
		}else{
			acutPrintf("error: 包含%s\n",pEnt->isA()->name());
			arLines.append(AcGePoint2d(0,0));
			arLines.append(AcGePoint2d(0,0));
			arBuggle.append(0);
		}
	}
	//myprintf("排序直线成首尾相连的环\n");
	sortEnts(arLines,arBuggle);
	AcDbPolyline* pLWPLine;
	int ptIdx=0;

	pLWPLine=new AcDbPolyline();
	ptIdx=0;
	//myprintf("%d %.5f,%.5f \n",ptIdx,ptPnt3d[i].x,ptPnt3d[i].y);
	pLWPLine->addVertexAt(ptIdx,arLines[0],arBuggle[0]);
	ptIdx++;
	//myprintf("region2Polyline %d \n",ptPnt3d.length());
	int nSize=arLines.length();
	for(int i=2;i<nSize;i+=2){
		if(arLines[i]!=arLines[i-1]){//curr.ptSt!=prev.ptEnd
			pLWPLine->setClosed(TRUE);
			//pLWPLine->addVertexAt(ptIdx,asPnt2d(ptEnd));
			AcDbObjectId objId;
			pLWPLine->setLayer(m_layerid);
			pLWPLine->setColor(m_color);
			postToDatabase(pLWPLine,objId);
			pLWPLine->close();
			pLWPLine=NULL;
			//
			//continue;
		}
		if(pLWPLine==NULL){
			myprintf("new polyline %d \n",i);
			pLWPLine=new AcDbPolyline();
			ptIdx=0;
		}
		myprintf("%d %.4f,%.4f \n",i,arLines[i].x,arLines[i].y,arBuggle[i/2]);
		pLWPLine->addVertexAt(ptIdx,arLines[i],arBuggle[i/2]);
		ptIdx++;
	}
	if(pLWPLine!=NULL){
		//myprintf("%d polyline end\n");
		pLWPLine->setClosed(TRUE);
		//pLWPLine->addVertexAt(ptIdx,asPnt2d(ptEnd));
		AcDbObjectId objId;
		pLWPLine->setLayer(m_layerid);
		pLWPLine->setColor(m_color);
		postToDatabase(pLWPLine,objId);
		pLWPLine->close();
		pLWPLine=NULL;
	}
	return 0;
}
/*
wmfin之后是blockref,explode变成polyline,explode变成line,widen之后是polyline
*/
int CEL2PL::doEntitySetWidMerge (AcDbVoidPtrArray &entitySet)
{
	//polyline,explode变成line,widen之后是polyline
	int isConvOk=1;
	AcDbObjectId eId;
	AcDbObjectIdArray objArray;
	for(int i=0;i<entitySet.length();i++){
		AcDbCurve *pEntitytemp =(AcDbCurve *)entitySet.at(i);
		if(pEntitytemp->isKindOf(AcDb2dPolyline::desc())){
			AcDb2dPolyline *p2dpolyline=(AcDb2dPolyline *)pEntitytemp;
			AcDbVoidPtrArray entitySe2;
			pEntitytemp->explode(entitySe2);
			for(int j=0;j<entitySe2.length();j++){
				AcDbCurve *pEntitytem2 =(AcDbCurve *)entitySe2.at(j);
				if(pEntitytem2->isKindOf(AcDbLine::desc())){
					if(m_iWidthHeight==1){  //线宽
						lineWiden((AcDbLine *)pEntitytem2,m_linewidth,eId);
					}else{ //if(m_iWidthHeight==2){ 高度比
						lineWiden((AcDbLine *)pEntitytem2,m_linewidth * m_textheight,eId);
					}
					objArray.append(eId);
				}else{
					isConvOk=0;
					acutPrintf("  2:%s\n",pEntitytem2->isA()->name());
				}
			}
		}
	}

	//通过面域合并
    AcDbVoidPtrArray curveSegs;
	AcDbObjectIdArray objIdArray;
	int rejectCount = 0;
	int length=objArray.length();
	AcDbEntity *pEnt;
	ErrorStatus es;
	for (int i=0; i<length; i++) {
		es = acdbOpenAcDbEntity(pEnt, objArray[i], AcDb::kForRead);
		if (es == Acad::eOk) {
			if (pEnt->isKindOf(AcDbPolyline::desc())){
				AcDbPolyline *pLine=(AcDbPolyline *)pEnt;
				if(pLineisClosed(pLine)){
					objIdArray.append(pEnt->objectId());
					curveSegs.append(static_cast<void*>(pEnt));
				}else{
					pEnt->close();    // only close those that we are rejecting
				}
			}
			else {
				rejectCount++;
				pEnt->close();    // only close those that we are rejecting
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
        pEnt = static_cast<AcDbEntity*>(curveSegs[i]);
        pEnt->close();
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
	/*for(int i=0;i<lenRegions;i++){
		regionObj = static_cast<AcDbRegion*>(regions[i]);
		postToDatabase((AcDbEntity*)regionObj,objId);
		//regionObj->erase();
		regionObj->close();
	}*/
	if(lenRegions>1)
	{		
		//面域做union
		regionObj = static_cast<AcDbRegion*>(regions[0]);
        //regionObj->setDatabaseDefaults();
		for(int j=1;j<lenRegions; j++)
		{
			if(j==i) continue;
			regionOther=static_cast<AcDbRegion*>(regions[j]);
			regionObj->booleanOper(AcDb::kBoolUnite,regionOther);
		}

		//postToDatabase((AcDbEntity*)regionObj,objId);
		//regionObj->erase();
		regionObj->close();
	//}if(0){
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
				//for(int k=0;k<pPolylines->length();k++){
				//	AcDbCurve *pCurve=(AcDbCurve *)(Polylines.at(k));
				//	myprintf("pPolylines: %s\n", pCurve->isA()->name());
				//}
				entitySetLine.setLogicalLength(0);
				if(pEntReg->explode(entitySetLine)==Acad::eOk){
					region2Polyline(entitySetLine);
				}
			}else if (pEntReg->isKindOf(AcDbLine::desc()) || pEntReg->isKindOf(AcDbArc::desc())) {
				hasChild=0;
			}else {
				myprintf("%s %s\n",__FUNCTION__,pEntReg->isA()->name());
			}
			pEntReg->close();
		}

		if(!hasChild){
			region2Polyline(entitySetReg);
		}
		//postToDatabase((AcDbEntity*)regionObj,objId);

		//regionObj->erase();
		regionObj->close();
	}

	for (int i=0; i<objIdArray.length(); i++) {
		es = acdbOpenAcDbEntity(pEnt, objIdArray[i], AcDb::kForWrite);
		if (es == Acad::eOk) 
		{
			//if (ent->isKindOf(AcDbCurve::desc())){
			pEnt->erase();
			//}
			pEnt->close();    // only close those that we are rejecting
        }
    }
	return isConvOk;
}
bool CEL2PL::pLineisClosed(AcDb2dPolyline *pPLine)
{
	bool isClosed=FALSE;
	AcGePoint3d ptSt,ptEnd;
	if(pPLine->isClosed()){
		isClosed=TRUE;
	}else{
		pPLine->getStartPoint(ptSt);
		pPLine->getEndPoint(ptEnd);
		//myprintf("%.4f,%.4f %.4f,%.4f\n",ptSt.x,ptSt.y,ptEnd.x,ptEnd.y);
		if(ptSt==ptEnd){
			isClosed=TRUE;
		}
	}
	return isClosed;
}
bool CEL2PL::pLineisClosed(AcDbPolyline *pPLine)
{
	bool isClosed=FALSE;
	AcGePoint3d ptSt,ptEnd;
	if(pPLine->isClosed()){
		isClosed=TRUE;
	}else{
		pPLine->getStartPoint(ptSt);
		pPLine->getEndPoint(ptEnd);
		//myprintf("%.4f,%.4f %.4f,%.4f\n",ptSt.x,ptSt.y,ptEnd.x,ptEnd.y);
		if(ptSt==ptEnd){
			isClosed=TRUE;
		}
	}
	return isClosed;
}
//删除共边
int CEL2PL::linesDelSample (AcGePoint2dArray & arLines)
{
	//myprintf("删除共边\n");
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
				myprintf("del:%d %d %.4f,%.4f %.4f,%.4f\n",i,j,arLines[i].x,arLines[i].y,arLines[i+1].x,arLines[i+1].y);
				/*ptArr[i]=1;
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
int CEL2PL::linesSort(AcGePoint2dArray& arLines)
{
	//myprintf("直线排序成首尾相连的环\n");
	int iFound=0;
	int nSize=arLines.length();
	AcGePoint2d ptTmp;
	if(nSize <= 0){
		return 0;
	}
	for(int i=0;i<nSize;i+=2)
	{
		//if(ptArr[i])continue;
		for(int j=i+2;j<nSize;j+=2)
		{
			//if(ptArr[j])continue;
			if(arLines[j]==arLines[i+1]) { //j.ptSt=i.ptEnd 交换j.ptSt和i.next.ptSt
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
			else if(arLines[j+1]==arLines[i+1]) { 
				if(j==i+2) //j.ptEnd=j.ptStart,
				{
					ptTmp=arLines[j];
					arLines[j]=arLines[j+1];
					arLines[j+1]=ptTmp;

				}else{//j.ptEnd=i.ptEnd	交换j.ptEnd和i.next.ptSt
					ptTmp=arLines[j];
					arLines[j]=arLines[i+3];					
					arLines[i+3]=ptTmp;
					ptTmp=arLines[j+1];
					arLines[j+1]=arLines[i+2];
					arLines[i+2]=ptTmp;
				}
				break;
			}

		}
	}
	/*	  //for debug
	myprintf("after sort:\n");
	for (int i=0;i<arLines.length();i+=2){
		drawLine(arLines[i],arLines[i+1]);
		myprintf("%d %.4f,%.4f %.4f,%.4f ;",i,arLines[i].x,arLines[i].y,arLines[i+1].x,arLines[i+1].y);
	}
	myprintf("\n");
	 */
	return 0;
}
int CEL2PL::linesDraw(AcGePoint2dArray &arLines)
{
	//return 0;
	if(arLines.length()<=0){
		return 1;
	}
	AcDbPolyline* pLWPLine=new AcDbPolyline();

	int ptIdx=0;
	pLWPLine->addVertexAt(ptIdx,arLines[0]);
	ptIdx++;
	AcGePoint2d posprev;
	for(int i=2;i<arLines.length();i+=2)
	{
		if(arLines[i] != arLines[i-1]){
			//cur.ptSt!= prev.ptSt不是连续的
			myprintf("新环 %d %.4f,%.4f %.4f,%.4f\n",i,arLines[i].x,arLines[i].y,arLines[i+1].x,arLines[i+1].y);
			pLWPLine->setClosed(TRUE);
			AcDbObjectId objId;
			pLWPLine->setLayer(m_layerid);
			pLWPLine->setColor(m_color);
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
		pLWPLine->setLayer(m_layerid);
		pLWPLine->setColor(m_color);
		postToDatabase(pLWPLine,objId);
		pLWPLine->close();
		pLWPLine=NULL;
	}
	return 0;
}

//通过删除相同的直线实现
int CEL2PL::doEntitySetMerge(AcDbVoidPtrArray& entitySet)
{
	int isConvOk=1;
	AcDbObjectId objId;
	AcDbObjectIdArray objIdArray;
	for(int i=0;i<entitySet.length();i++){
		AcDbCurve *pEntitytemp =(AcDbCurve *)entitySet.at(i);
		if(pEntitytemp->isKindOf(AcDb2dPolyline::desc())){
			AcDb2dPolyline* pLine=(AcDb2dPolyline*)pEntitytemp;
			postToDatabase(pLine,objId);
			if(pLineisClosed(pLine)){
				objIdArray.append(pLine->objectId());
			}else{
				//非闭合polyline,不处理
			}
		}else
		{
			acutPrintf("todo: doEntitySetMerge %s\n",pEntitytemp->isA()->name());
		}
		pEntitytemp->close(); 
	}

	AcDbVoidPtrArray entitySetLine;
	AcGePoint2dArray arLines; //pt start,end,...
	AcDbEntity* pEnt,*pEnt2;
	AcGePoint3d ptSt,ptEnd;
	for (int i=0; i<objIdArray.length(); i++) 
	{
		if (acdbOpenAcDbEntity(pEnt, objIdArray[i], AcDb::kForWrite) == Acad::eOk) 
		{
			entitySetLine.setLogicalLength(0);
			pEnt->explode(entitySetLine);
			//myprintf("line %d\n",i);
			//判断时针方向,
			for(int j=0;j<entitySetLine.length();j++)
			{
				pEnt2=(AcDbEntity *)entitySetLine[j];
				if(pEnt2->isKindOf(AcDbLine::desc())){
					AcDbLine *pLine = (AcDbLine *)pEnt2;
					pLine->getStartPoint(ptSt);
					pLine->getEndPoint(ptEnd);
					if(ptSt==ptEnd)  //跳过长度为0的直线
						continue;
					//if(myabs(ptSt.x-0.0117)<1E-4 && myabs(ptSt.y-80.1055) < 1E-4 ){
					//	myprintf("%d %.4f,%.4f %.4f,%.4f ;",j,ptSt.x,ptSt.y,ptEnd.x,ptEnd.y);
					//}
					//struct stLine aline;
					arLines.append(AcGePoint2d(ptSt.x,ptSt.y));
					arLines.append(AcGePoint2d(ptEnd.x,ptEnd.y));
					//myprintf("%d %.4f,%.4f %.4f,%.4f ;",j,ptSt.x,ptSt.y,ptEnd.x,ptEnd.y);
				}else{
					acutPrintf("warning: %s %s\n",__FUNCTION__,pEnt2->isA()->name());
				}
			}
			//myprintf("\n");
			pEnt->erase();
			pEnt->close();    // only close those that we are rejecting
		}
	}
	AcDbIntArray ptArr;
	logtime("time del");
	linesDelSample(arLines);
	logtime("time sort");
	linesSort(arLines);
	logtime("time draw");
	if(linesDraw(arLines)) {
		isConvOk=0;
	}
	logtime("time done");
	return isConvOk;
}
int CEL2PL::doEntitySetPolyline(AcDbVoidPtrArray& entitySet)
{
	int isConvOk=1;
	AcDbObjectId objId;
	for(int i=0;i<entitySet.length();i++){
		AcDbCurve *pEntitytemp =(AcDbCurve *)entitySet.at(i);
		if(pEntitytemp->isKindOf(AcDb2dPolyline::desc())){
			AcDbPolyline *pLWPolyline=new AcDbPolyline();
			if(Poly2dToLWPoly((AcDb2dPolyline*)pEntitytemp,pLWPolyline)==0){
				isConvOk=0;
			}			
			pLWPolyline->setLayer(m_layerid);
			pLWPolyline->setColor(m_color);
			postToDatabase(pLWPolyline,objId);
			pLWPolyline->close();
		}
		pEntitytemp->close();
	}
	return isConvOk;
}
int CEL2PL::text2polyline(ads_name& ss1)
{
	AcDbObjectId eId;
	AcDbEntity * pEntSS1;
	//打开,读
	if( acdbGetObjectId(eId, ss1) != Acad::eOk)
	{
		acutPrintf("open object fail!\n");
		return 0;
	}
	if( acdbOpenObject(pEntSS1, eId, kForRead) != Acad::eOk) //kForRead; kForWrite;
	{
		acutPrintf("open object fail!\n");
		return 0;
	}
	//排除锁定,冻结层
	if(isOnLockedLayer(pEntSS1,true)){
		pEntSS1->close();
		return NULL;
	}
	if(isOnFrozenLayer(pEntSS1,true)){
		pEntSS1->close();
		return NULL;
	}
	//pEntSS1->close();   acdbOpenObject(pEntSS1, eId, kForWrite);
	myprintf ("entity: %s\n", pEntSS1->isA()->name());
	if (pEntSS1->isKindOf(AcDbText::desc()) || pEntSS1->isKindOf(AcDbAttribute::desc()))
	{
		AcDbText *pText = (AcDbText *)pEntSS1;
		m_textheight = pText->height();
		AcDbObjectId textStyleId=pText->textStyle();
		AcDbSymbolTableRecord* tblRec;
		Acad::ErrorStatus es;
		es = acdbOpenObject(tblRec, textStyleId, AcDb::kForRead);
		if (es == Acad::eOk) {
			CString str;
			const char* locName;
			es = ((AcDbTextStyleTableRecord *)tblRec)->fileName(locName);
			if (es == Acad::eOk){
				myprintf("%s\n",locName);
				str = locName;
				if(str.Right(3).CompareNoCase("TTF")!=0){ //shx字体
					if(!m_bWiden){
						acutPrintf("cad font:%s\n",str);
						pEntSS1->close(); 
						tblRec->close();
						return NULL; 
					}
				}
				else{
					if(m_bWiden){
						acutPrintf("TrueType font:%s\n",str);
						pEntSS1->close();
						tblRec->close();
						return NULL;
					}
				}
			}
			tblRec->close();
		}
		m_layerid = pEntSS1->layerId();
		m_color=pEntSS1->color();
	}
	else if(pEntSS1->isKindOf(AcDbMText::desc()) )
	{
		//转换成AcDbText再处理
		acutPrintf("please AcDbMText explode!\n");
		pEntSS1->close();
		return NULL;
	}
	else{
		pEntSS1->close();
		return NULL;
	}
	pEntSS1->close();
	
	//zoom w
	struct resbuf *textent, *tent;
	ads_point origin,lowleft, upright;
	ads_real rotatn;
    textent = acdbEntGet(ss1);
    if (textent == NULL)
    {
		acutPrintf("error: acdbEntGet,%s\n",__FUNCTION__);
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
		acutPrintf("error: acedTextBox %s!\n",__FUNCTION__);
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
	m_ptTextLeft[0]=findMin(4,pt1.x,pt2.x,pt3.x,pt4.x)-0.01; //缩小一圈,保证文字可视,否则容易不完整文字
	m_ptTextLeft[1]=findMin(4,pt1.y,pt2.y,pt3.y,pt4.y)-0.01;
	m_ptTextRight[0]=findMax(4,pt1.x,pt2.x,pt3.x,pt4.x)-0.01;
	m_ptTextRight[1]=findMax(4,pt1.y,pt2.y,pt3.y,pt4.y)-0.01;
	//acedCommand(RTSTR,"zoom",RTSTR,"e",0);	
	//acedCommand(RTSTR,"zoom",RTSTR,"w",RTPOINT,m_ptTextLeft,RTPOINT,m_ptTextRight,0);
	//zoom w
	struct resbuf *callist, *results = NULL;
	callist = acutBuildList(RTSTR, "C:tmpZoom",
		RTPOINT, m_ptTextLeft,
		RTPOINT, m_ptTextRight, 0);
	if (acedInvoke(callist, &results) == RTERROR)
		acutPrintf("Cannot run c:tmpZoom -- 请加载starmask1.lsp\n"); 
		acutRelRb(callist); 
	acutRelRb(results);
	//text转换成blockref
	getLUL();
	callist = acutBuildList(RTSTR, "C:tmpText2Polyline",
		RTSTR,m_tmpfile,
		RTENAME,ss1,
		RTPOINT,m_lul,
		RTPOINT,m_vc,	0);
	if (acedInvoke(callist, &results) == RTERROR) 
		acutPrintf("Cannot run c:tmpZoom -- 请加载starmask1.lsp\n");
	acutRelRb(callist);
	acutRelRb(results);

	//blockref 转换成polyline
	ads_name last;

	if(acdbEntLast(last)!=RTNORM){
		acutPrintf("entlast failed!\n");
		return 1;
	}
	AcDbObjectId objId;
	Acad::ErrorStatus es;
	AcDbEntity *pEnt;
	es=acdbGetObjectId(objId, last);
	assert(es==Acad::eOk);
	es=acdbOpenObject(pEnt, objId, kForWrite);
	assert(es==Acad::eOk);
	AcDbPolyline *pLWPolyline;
	AcDb2dPolyline *p2dpolyline;
	int ptIdx=0;
	int isConvOk=1;
	if(pEnt->isKindOf(AcDbBlockReference::desc())){
		AcDbVoidPtrArray entitySet;
		pEnt->explode(entitySet);
		if(m_bWiden){
			if(m_bMerge){
				isConvOk=doEntitySetWidMerge(entitySet);
			}else{
				isConvOk=doEntitySetWiden(entitySet);
			}
		}else{
			if(m_bMerge){
				doEntitySetMerge(entitySet);
			}else{
				isConvOk=doEntitySetPolyline(entitySet);
			}
		}
		if(isConvOk){
			pEnt->erase();
		}
	}else{
		acutPrintf("0:%s\n",pEnt->isA()->name());
	}
	pEnt->close();

	return 0;
}

int CEL2PL::getLUL(void)
{
	double lvs;//viewSize
	ads_point lss;//screenSize
	ads_point vc2;// viewcenter: viewctr

	struct resbuf rbVar;
	if ( acedGetVar ("VIEWSIZE", &rbVar) != RTNORM ) {
		acutPrintf("\nError while reading VIEWSIZE setting");
		return 0;
	}
	lvs=rbVar.resval.rreal;
	if ( acedGetVar ("SCREENSIZE", &rbVar) != RTNORM ) {
		acutPrintf("\nError while reading SCREENSIZE setting");
		return 0;
	}
	lss[0]=rbVar.resval.rpoint[0];
	lss[1]=rbVar.resval.rpoint[1];
	if ( acedGetVar ("VIEWCTR", &rbVar) != RTNORM ) {
		acutPrintf("\nError while reading VIEWCTR setting");
		return 0;
	}
	m_vc[0]=rbVar.resval.rpoint[0];
	m_vc[1]=rbVar.resval.rpoint[1];
	vc2[0]=m_vc[0];
	vc2[1]=m_vc[1]+1;

	double vi;// lvs * lss.x / lss.y
	vi=lvs*lss[0]/lss[1];
	ads_point vw;// vc.x - vi*0.5 ,vc.y - lvs * 0.5
	vw[0]=m_vc[0]-vi*0.5;
	vw[1]=m_vc[1]-lvs*0.5;
	ads_point vh;// vc.x + vi*0.5 ,vc.y + lvs * 0.5
	vh[0]=m_vc[0]+vi*0.5;
	vh[1]=m_vc[1]+lvs*0.5;
	m_lul[0]=vw[0];
	m_lul[1]=vh[1];
	//myprintf("lul:%.4f,%.4f\n",m_lul[0],m_lul[1]);
	return 0;
}

int CEL2PL::purgeBlockRef(void)
{
	//删除不用的块,层,linetype,dim
	Acad::ErrorStatus es;
	AcDbBlockTable* pBlockTable;
	AcDbBlockTableRecord* pSpaceRecord;
	es = acdbHostApplicationServices()->workingDatabase()->getSymbolTable(pBlockTable, AcDb::kForRead);
	assert(es == Acad::eOk);
	char blkname[8];			
	AcDbObjectId id;
	AcDbObjectIdArray idArr;
	int idxblk=0;
	sprintf(blkname,"WMF%d",idxblk);
	idxblk++;
	while(Acad::eOk == pBlockTable->getAt(blkname, pSpaceRecord, AcDb::kForRead))
	{
		idArr.append(pSpaceRecord->objectId());
		es = pSpaceRecord->close();
		sprintf(blkname,"WMF%d",idxblk);
		idxblk++;
	}
	es = pBlockTable->close();
	es = acdbHostApplicationServices()->workingDatabase()->purge(idArr);
	assert(es == Acad::eOk);
	AcDbObject *pObj;
	for(int i=0;i<idArr.length();i++){
		es=acdbOpenObject(pObj, idArr.at(i), AcDb::kForWrite);
		if(es == Acad::eOk)
		{
			//acutPrintf ("删除块: %s\n", pObj->isA()->name());
			pObj->erase();
			pObj->close();
		}
			/*if(Acad::eOk != pSpaceRecord->erase())
			{
				acutPrintf("删除块失败%s!\n",blkname);
			}*/
	}
	return 0;
}

double CEL2PL::min4(double x1, double x2, double x3, double x4)
{
	double xmin;
	if(x1<x2){
		xmin=x1;
	}else{
		xmin=x2;
	}
	if(xmin>x3){
		xmin=x3;
	}
	if(xmin>x4){
		xmin=x4;
	}
	return xmin;
}

double CEL2PL::max4(double x1, double x2, double x3, double x4)
{
	double xmax;
	if(x1<x2){
		xmax=x2;
	}else{
		xmax=x1;
	}
	if(xmax<x3){
		xmax=x3;
	}
	if(xmax<x4){
		xmax=x4;
	}
	return xmax;
}

int CEL2PL::starWidenArc(int sel)
{
	int iSel=getSelect();
	if(iSel==0){
		return 0;
	}
	ads_name ss,ss1;
	CStringList strent;
	strent.AddHead("POLYLINE");
	strent.AddHead("LWPOLYLINE");
	strent.AddHead("LINE");
	strent.AddHead("ARC");
	strent.AddHead("CIRCLE");
	if(getSelectSet(iSel,strent,ss))
		return 0;

	//acedGetInt("\n1,选择 2,指定层 3,全部: ",&iSel);
	long length;
	if (acedSSLength(ss, &length) != RTNORM) 
		return BAD;
	int ret=acedGetReal("\n请输入线宽(input the width):",&m_linewidth);
	if(ret!=RTNORM){
		return 0;
	}
	char keyw = getKWord("Y N","Fillet the arc ends after widen(单线加宽后是否圆角)[Yes/No]?");
	if(keyw=='Y'){
		m_bWidenFillet=1;
		keyw = getKWord("Y N","Fillet the two ends of polyline(多义线只圆两头)[Yes/No]?");
		if(keyw=='Y' || keyw==' '){
			m_bWidenTwoEnd=1;
		}else if (keyw=='N'){
			m_bWidenTwoEnd=0;
		}
		else{
			return 0; //取消
		}
	}else if (keyw=='N' || keyw==' '){
		m_bWidenFillet=0;
	}
	else{
		return 0;
	}	

	//CWidenDialog dlgText(acedGetAcadFrame());
	//dlgText.m_dWiden = "0.3";
	//iSel=dlgText.DoModal();
	//if(iSel==IDOK){
	//	CString str=dlgText.m_dWiden;
	//	acutPrintf("text: %s !\n",str);
	//	m_linewidth=atof(str);
	//}

	//setMylog(0);
	//ads_point pte;
	//pte[0]=0,pte[1]=0;pte[2]=0;
	//ads_name last;
	//m_textcnt=length;
	for (int i=0;i<length;i++)
	{
		if (acedSSName(ss, i, ss1) != RTNORM) 
			break;
		widenArc(ss1);
		//mysynclog();
	}
	mysynclog();
	//setMylog(0);
	acedSSFree(ss);
	return 0;
}

int CEL2PL::starText2lineA(void)
{
	MText2DText();
	int iSel=getSelect();
	if(iSel==0){
		return 0;
	}else if(iSel!=1){
		if(visableAllLayer()!=Acad::eOk) return 1;
	}
	ads_name ss,ss1;
	CStringList strent;
	strent.AddHead("TEXT");
	strent.AddHead("MTEXT");
	if(getSelectSet(iSel,strent,ss))
		return 0;
	char kw=getKWord("W S A","文字宽度W/线宽高度比S/任意比A/<默认字高的1/10>");
	if(kw=='W'){
		m_iWidthHeight=1;
		acedGetReal("请输入宽度:",&m_linewidth);
	}else if (kw=='S'){
		m_iWidthHeight=2;
		m_linewidth=1;
		while (1){
			int ret=acedGetReal("请输入高度比:",&m_linewidth);
			if(ret!=RTNORM) //用户取消？
			{
				return 0;
			}
			if(m_linewidth<1E-5 || m_linewidth>0.33){
				acutPrintf("\n线宽高度比必须在0--0.33之间,请重新输入\n");
			}else{
				break;
			}
		}
	}else if (kw=='A'){
		m_iWidthHeight=2;
		m_linewidth=1;
		while (1){
			int ret=acedGetReal("请输入高度比:",&m_linewidth);
			if(ret!=RTNORM) //用户取消？
			{
				return 0;
			}
			break;
		}
	}else if(kw==' '){
		m_iWidthHeight=2;
		m_linewidth=0.1;
	}else{
		return 0;
	}
	myprintf("%d\n",kw);
	setFlag(fT2LA,1,0);//做widen,不做merge
	initTmpFile();
	doEntitySet(ss);
	mysynclog();
	acedSSFree(ss);
	return 0;
}

int CEL2PL::starText2lineD(void)
{
	MText2DText();
	int iSel=getSelect();	
	if(iSel==0){
		return 0;
	}else if(iSel!=1){
		if(visableAllLayer()!=Acad::eOk) return 1;
	}
	ads_name ss,ss1;
	CStringList strent;
	strent.AddHead("TEXT");
	strent.AddHead("MTEXT");
	if(getSelectSet(iSel,strent,ss))
		return 0;
	char kw=getKWord("W S A","文字宽度W/线宽高度比S/任意比A/<默认字高的1/10>");
	if(kw=='W'){
		m_iWidthHeight=1;
		acedGetReal("请输入宽度:",&m_linewidth);
	}else if (kw=='S'){
		m_iWidthHeight=2;
		m_linewidth=1;
		while (1){
			int ret=acedGetReal("请输入高度比:",&m_linewidth);
			if(ret!=RTNORM) //用户取消？
			{
				return 0;
			}
			if(m_linewidth<1E-5 || m_linewidth>0.33){
				acutPrintf("\n线宽高度比必须在0--0.33之间,请重新输入\n");
			}else{
				break;
			}
		}
	}else if (kw=='A'){
		m_iWidthHeight=2;
		m_linewidth=1;
		while (1){
			int ret=acedGetReal("请输入高度比:",&m_linewidth);
			if(ret!=RTNORM) //用户取消？
			{
				return 0;
			}
			break;
		}
	}else if(kw==' '){
		m_iWidthHeight=2;
		m_linewidth=0.1;
	}else{
		return 0;
	}
	myprintf("%d\n",kw);
	setFlag(fT2LA,1,1);//做widen,不做merge
	initTmpFile();
	doEntitySet(ss);
	mysynclog();
	acedSSFree(ss);
	return 0;
}
int CEL2PL::starText2lineB(void)
{
	MText2DText();
	int iSel=getSelect();
	if(iSel==0){
		return 0;
	}else if(iSel!=1){
		if(visableAllLayer()!=Acad::eOk) return 1;
	}
	ads_name ss,ss1;
	CStringList strent;
	strent.AddHead("TEXT");
	strent.AddHead("MTEXT");
	if(getSelectSet(iSel,strent,ss))
		return 0;

	setFlag(fT2LB,0,0);//不做widen,不做merge
	initTmpFile();
	doEntitySet(ss);
	mysynclog();
	acedSSFree(ss);
	return 0;
}

int CEL2PL::starText2lineC(void)
{
	MText2DText();
	int iSel=getSelect();
	if(iSel==0){
		return 0;
	}else if(iSel!=1){
		if(visableAllLayer()!=Acad::eOk) return 1;
	}
	ads_name ss,ss1;
	CStringList strent;
	strent.AddHead("TEXT");
	strent.AddHead("MTEXT");
	if(getSelectSet(iSel,strent,ss))
		return 0;

	setFlag(fT2LC,0,1);//不做widen,做merge
	initTmpFile();
	doEntitySet(ss);
	mysynclog();
	acedSSFree(ss);
	return 0;
}

int CEL2PL::doEntitySet(ads_name &ss)  //
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
		switch (m_iFunID){
			case fT2LA:break;
			case fT2LB:break;
			case fT2LC:break;
			default:break;
		}
		text2polyline(ss1);
	}
	mysynclog();
	return 0;
}

int CEL2PL::OnDoText2LineC(ads_name& ss1)
{
	text2polyline(ss1);
	return 0;
}

int CEL2PL::setFlag(int iFunID, int isWiden, int isMerge)
{
	m_iFunID=iFunID;
	m_bWiden=isWiden;
	m_bMerge=isMerge;
	return 0;
}

int CEL2PL::initTmpFile(void)
{
	char *pathvar = getenv( "TEMP" );
	if(pathvar==NULL){
		pathvar="C:\\";
	}
	m_tmpfile=pathvar;
	m_tmpfile=m_tmpfile+"\\temptext";
	return 0;
}
int CEL2PL::mergePolyline(AcDbObjectIdArray objIdArray, AcDbVoidPtrArray curveSegs)
{
	int isConvOk=0;
	//通过面域合并
	AcDbEntity *pEnt;

	int length=objIdArray.length();
	if (curveSegs.isEmpty()) {
		acutPrintf(_T("no 没有选择 curves!"));
		return 1;
	}

    AcDbVoidPtrArray regions;
    Acad::ErrorStatus es = AcDbRegion::createFromCurves(curveSegs, regions);

    // close all open entities used to create the region
    int lenCurves = curveSegs.length();
    for (int i=0; i<lenCurves; i++) {
        pEnt = static_cast<AcDbEntity*>(curveSegs[i]);
        pEnt->close();
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
	/*for(int i=0;i<lenRegions;i++){
		regionObj = static_cast<AcDbRegion*>(regions[i]);
		postToDatabase((AcDbEntity*)regionObj,objId);
		//regionObj->erase();
		regionObj->close();
	}*/
	if(lenRegions>1)
	{		
		//面域做union
		regionObj = static_cast<AcDbRegion*>(regions[0]);
        //regionObj->setDatabaseDefaults();
		for(int j=1;j<lenRegions; j++)
		{
			if(j==i) continue;
			regionOther=static_cast<AcDbRegion*>(regions[j]);
			regionObj->booleanOper(AcDb::kBoolUnite,regionOther);
		}

		//postToDatabase((AcDbEntity*)regionObj,objId);
		//regionObj->erase();
		regionObj->close();
	//}if(0){
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
				//for(int k=0;k<pPolylines->length();k++){
				//	AcDbCurve *pCurve=(AcDbCurve *)(Polylines.at(k));
				//	myprintf("pPolylines: %s\n", pCurve->isA()->name());
				//}
				entitySetLine.setLogicalLength(0);
				if(pEntReg->explode(entitySetLine)==Acad::eOk){
					region2Polyline(entitySetLine);
				}
			}else if (pEntReg->isKindOf(AcDbLine::desc()) || pEntReg->isKindOf(AcDbArc::desc())) {
				hasChild=0;
			}else {
				myprintf("%s %s\n",__FUNCTION__,pEntReg->isA()->name());
			}
			pEntReg->close();
		}

		if(!hasChild){
			region2Polyline(entitySetReg);
		}
		//postToDatabase((AcDbEntity*)regionObj,objId);
		//regionObj->erase();
		regionObj->close();

		for (int i=0; i<objIdArray.length(); i++) {
			es = acdbOpenAcDbEntity(pEnt, objIdArray[i], AcDb::kForWrite);
			if (es == Acad::eOk) 
			{
				//if (ent->isKindOf(AcDbCurve::desc())){
				pEnt->erase();
				//}
				pEnt->close();    // only close those that we are rejecting
			}
		}
	}
	return isConvOk;
}
int CEL2PL::starMergePolyline(void)
{
	//通过删除相同的直线实现
	int iSel=getSelect();	
	if(iSel==0){
		return 0;
	}
	myprintf("starMergePolyline %d\n",iSel);

	ads_name ss, ss1;
	CStringList strent;
	strent.AddHead("LWPOLYLINE");
	if(getSelectSet(iSel,strent,ss))
		return 0;
	long length;
	if (acedSSLength(ss, &length) != RTNORM){
		acutPrintf("error: sslength失败\n");
		return BAD;
	}

    AcDbEntity* pEnt;
	AcDbObjectId eId;
	int rejectCount = 0;
	AcDbObjectIdArray objIdArray;
	AcDbVoidPtrArray curveSegs;
	for (int i=0; i<length; i++) {
		if (acedSSName(ss, i, ss1) != RTNORM)
		{
			return 0;
		}
		if( acdbGetObjectId(eId, ss1) != Acad::eOk)
		{
			acutPrintf("open object fail!\n");
			return 0;
		}
		if (acdbOpenAcDbEntity(pEnt, eId, AcDb::kForRead) != Acad::eOk)
		{
			acutPrintf("error: acdbOpenAcDbEntity!\n");
			return 0;
		}
		m_layerid=pEnt->layerId();
		m_color=pEnt->color();
		if (pEnt->isKindOf(AcDbPolyline::desc()))
		{
			AcDbPolyline *pLine=(AcDbPolyline *)pEnt;
			if(pLineisClosed(pLine))
			{
				objIdArray.append(eId);
				curveSegs.append(static_cast<void*>(pEnt));
			}else{
				pEnt->close();    // only close those that we are rejecting
			}
		}
		else {
			rejectCount++;
			pEnt->close();    // only close those that we are rejecting
		}

	}
    if (rejectCount > 0)
        acutPrintf(_T("\n object(s) were not curves..."));
	mergePolyline(objIdArray,curveSegs);
	mysynclog();
	return 0;
}

int CEL2PL::ptOnLine(ads_point ptSt,ads_point ptEnd,ads_point ptMid)
{
	//根据角度判断
	double dAngSt,dAngEnd,dAngMid;
	dAngSt=acutAngle(ptMid,ptSt);
	dAngEnd=acutAngle(ptMid,ptEnd);
	myprintf("ptOnLine ang %.4f %.4f \n",dAngSt,dAngEnd);
	if(myabs(dAngEnd-dAngSt)>1.0) //在线段内,相差180度,弧度3.14159
		return 1;
	else 
		return 0;
}

int CEL2PL::getIntersectPnts(AcGeCircArc2d *pGeCir,AcGePoint2d ptSt,AcGePoint2d ptEnd, double &dBulge, int &intn,AcGePoint2d &p1,AcGePoint2d &p2)
{
	if( myabs(dBulge)> 0){
		AcGeCircArc2d geOther(ptSt,ptEnd,dBulge,Adesk::kFalse);
		pGeCir->intersectWith(geOther,intn,p1,p2);
		myprintf("交点arc :%.4f,%.4f %.4f",geOther.center().x,geOther.center().y,geOther.radius());
		myprintf("交点arc : %d %.4f,%.4f %.4f,%.4f %.4f %.4f,%.4f\n",intn,ptSt.x,ptSt.y,ptEnd.x,ptEnd.y,dBulge,p1.x,p1.y);
	}else{
		AcGeLine2d geOther(ptSt,ptEnd);
		pGeCir->intersectWith(geOther,intn,p1,p2);
		myprintf("交点line: %d %.4f,%.4f %.4f,%.4f %.4f %.4f,%.4f\n",intn,ptSt.x,ptSt.y,ptEnd.x,ptEnd.y,dBulge,p1.x,p1.y);
	}
	return 0;
}

/*取两条line或arc与circle交点,p1,p2和bulge
输入:circle: arCircle[i],
    两条line,3个点: arLines[i-1].[i],arLines[i].[i+1],
输出:p1,p2和bulge*/
int CEL2PL::getFilletPoints(AcGeCircArc2d *pGeCir,
							AcGePoint2d& ptSt1,AcGePoint2d& ptEnd1,AcGePoint2d& ptEnd2,
							double &dBulge1,double &dBulge2,
							AcGePoint2d& pnt1,AcGePoint2d& pnt2,double& dBulge)
{
	int intn;
	AcGePoint2d pnt3;
	double dAngSt,dAngEnd,dAngMid;
	int iFound=0;
	AcGePoint2d ptCenter=pGeCir->center();
	myprintf("getFilletPoints:ce,pt1,pt2,pt3,dbugle1,db2 %.4f,%.4f\n",ptCenter.x,ptCenter.y);
	myprintf(" %.4f,%.4f %.4f,%.4f %.4f,%.4f %.4f %.4f\n",ptSt1.x,ptSt1.y,ptEnd1.x,ptEnd1.y,ptEnd2.x,ptEnd2.y,dBulge1,dBulge2);
	getIntersectPnts(pGeCir,ptSt1,ptEnd1,dBulge1,intn,pnt1,pnt3);
	if(intn==1){//有1交点
		if(ptOnLine(asDblArray(ptSt1),asDblArray(ptEnd1),asDblArray(pnt1))){//在直线上
			myprintf(" 1交点online %.4f,%.4f\n",pnt1.x,pnt1.y);
			//下一条直线的交点
			getIntersectPnts(pGeCir,ptEnd1,ptEnd2,dBulge2,intn,pnt2,pnt3);
			if(intn==1){//有1交点
				if(ptOnLine(asDblArray(ptEnd1),asDblArray(ptEnd2),asDblArray(pnt2))){//pnt2在直线上
					myprintf(" 2交点online %.4f,%.4f\n",pnt2.x,pnt2.y);
					dAngSt=acutAngle(asDblArray(ptCenter),asDblArray(pnt1));
					dAngEnd=acutAngle(asDblArray(ptCenter),asDblArray(pnt2));
					AcGeCircArc2d geCir(ptCenter,pGeCir->radius(),dAngSt,dAngEnd);
					getArcBulge(geCir,dBulge);
					iFound=1;
				}
			}
		}
	}
	return iFound;
}

int CEL2PL::starDo5s(void)
{
	//通过删除相同的直线实现
	int iSel=getSelect();	
	if(iSel==0){
		return 0;
	}
	myprintf("starDo5s %d\n",iSel);

	ads_name ss, ss1;
	CStringList strent;
	strent.AddHead("POLYLINE");
	if(getSelectSet(iSel,strent,ss))
		return 0;
	long length;
	if (acedSSLength(ss, &length) != RTNORM){
		acutPrintf("error: sslength失败\n");
		return BAD;
	}

    AcDbEntity* pEnt;
	AcDbObjectId eId;
	int rejectCount = 0;
	AcDbObjectIdArray objIdArray;
	AcDbVoidPtrArray curveSegs;
	for (int i=0; i<length; i++) {
		m_bErase=0;
		if (acedSSName(ss, i, ss1) != RTNORM)
		{
			return 0;
		}
		if( acdbGetObjectId(eId, ss1) != Acad::eOk)
		{
			acutPrintf("open object fail!\n");
			return 0;
		}
		if (acdbOpenAcDbEntity(pEnt, eId, AcDb::kForWrite) != Acad::eOk)
		{
			acutPrintf("error: acdbOpenAcDbEntity!\n");
			return 0;
		}
		m_layerid=pEnt->layerId();
		m_color=pEnt->color();
		polyline2LWPolyline(pEnt,eId);
		if(m_bErase){
			pEnt->erase();
		}
		pEnt->close();    // only close those that we are rejecting
	}
	mysynclog();
	return 0;
}

int CEL2PL::collectVertices(const AcDbEntity* ent, AcDbObjectIdArray& subEnts)
{
    AcDb2dPolyline* pline2d;
    AcDb3dPolyline* pline3d;
    AcDbPolygonMesh* pmesh;
    AcDbPolyFaceMesh* pface;

    AcDbObjectIterator* vertexIter;

    if ((pline2d = AcDb2dPolyline::cast(ent)) != NULL)
        vertexIter = pline2d->vertexIterator();
    else if ((pline3d = AcDb3dPolyline::cast(ent)) != NULL)
        vertexIter = pline3d->vertexIterator();
    else if ((pmesh = AcDbPolygonMesh::cast(ent)) != NULL)
        vertexIter = pmesh->vertexIterator();
    else if ((pface = AcDbPolyFaceMesh::cast(ent)) != NULL)
        vertexIter = pface->vertexIterator();
    else
        vertexIter = NULL;

	if (vertexIter == NULL) {
		//ASSERT(0);
		return 1;
	}

    while (vertexIter->done() == false) {
		subEnts.append(vertexIter->objectId());
        vertexIter->step();
    }

    delete vertexIter;
	return 0;
}

int CEL2PL::polyline2LWPolyline(const AcDbEntity* ent,AcDbObjectId objId)
{
	AcDbObjectIdArray subEnts;
	collectVertices(ent, subEnts);

	AcDbObject* tmpObj;
	Acad::ErrorStatus es;
	CString str;

	AcGePoint3d ptTmp;
	double dBulge;

	int len = subEnts.length();
	AcDbPolyline *plwline=new AcDbPolyline;
	int ptIdx=0;
	int iFound=0;
	for (int i=0; i<len; i++) {
		es = acdbOpenAcDbObject(tmpObj, subEnts[i], AcDb::kForRead, true);		// might have passed in erased ones
		if (es == Acad::eOk) {
			if(tmpObj->isKindOf(AcDb2dVertex::desc())){
				myprintf("%s %s\n",__FUNCTION__,tmpObj->isA()->name());
				AcDb2dVertex *pVert = (AcDb2dVertex *)tmpObj;
				dBulge=pVert->bulge();
				ptTmp=pVert->position();
				plwline->addVertexAt(ptIdx,AcGePoint2d(ptTmp.x,ptTmp.y),dBulge);
				ptIdx++;
			}else if(tmpObj->isKindOf(AcDb3dPolylineVertex::desc())){
				AcDb3dPolylineVertex *pVert = (AcDb3dPolylineVertex *)tmpObj;
				//dBulge=pVert->bulge();
				ptTmp=pVert->position();
				plwline->addVertexAt(ptIdx,AcGePoint2d(ptTmp.x,ptTmp.y),0);
				ptIdx++;
			}
			tmpObj->close();
		}
		else{
			acutPrintf("acdbOpenAcDbObject failed!\n");
		}
	}
	if(ptIdx>0){
		plwline->setLayer(m_layerid);
		plwline->setColor(m_color);
		postToDatabase(plwline,objId);
		plwline->close();
		m_bErase=TRUE;
	}else{
		delete plwline;
	}
	return 0;
}

void CEL2PL::starDimmini(void)
{
	int iSel=getSelect();	
	if(iSel==0){
		return ;
	}
	ads_name ss, ss1;
	CStringList strent;
	strent.AddHead("LWPOLYLINE");
	if(getSelectSet(iSel,strent,ss))
		return ;
	long length;
	if (acedSSLength(ss, &length) != RTNORM){
		acutPrintf("error: sslength失败\n");
		return ;
	}

    AcDbEntity* pEnt;
	AcDbObjectId eId;
	int rejectCount = 0;
	AcDbObjectIdArray objIdArray;
	AcDbEntityArray arEnts;
	for (int i=0; i<length; i++) {
		if (acedSSName(ss, i, ss1) != RTNORM){
			break;
		}
		if( acdbGetObjectId(eId, ss1) != Acad::eOk){
			acutPrintf("error: open object fail!\n");
			break;
		}
		if (acdbOpenAcDbEntity(pEnt, eId, AcDb::kForRead) != Acad::eOk){
			acutPrintf("error: acdbOpenAcDbEntity!\n");
			break;
		}
		arEnts.append(pEnt);
	}
	int bFound;
	length=arEnts.length();
	AcGePoint3dArray points;
	double dMinDist=99999;
	AcGePoint2d ptmin1,ptmin2;
	for(int i=0;i<length;i++){
		pEnt=arEnts[i];
		getMinDist(pEnt,arEnts,i+1,dMinDist,ptmin1,ptmin2);
		pEnt->close();
	}
	AcGeLineSeg2d geLine(ptmin1,ptmin2);
	AcGePoint2d ptmid=geLine.midPoint();
	AcGePoint2d pt4;
	double dDist=3;
	//acutPolar(ptmid,*m_pi/4,dDist,pt4);
	drawLine(ptmid,pt4);
	CString str;
	str.Format("%.3fumS",dMinDist*1000);
	//drawDText(AcGePoint3d(ptmid.x,ptmid.y,0),str,NULL,
	myprintf("%.4f\n!",dMinDist);
	mysynclog();
}
//查找是否有相交实体,
int CEL2PL::isIntersect(AcDbEntity* pEnt, AcDbEntity* pEnt2)
{
	int bFound=0;
	AcGePoint3dArray points;
	if(pEnt->intersectWith(pEnt2,AcDb::kOnBothOperands,points)==Acad::eOk){
		if(points.length()>0){
			acutPrintf("存在相交%s %.4f,%.4f\n",pEnt->isA()->name(), points[0].x,points[0].y);
			bFound=1;
		}else{
			myprintf("不相交1");
		}
	}else{
		myprintf("不相交2");
	}
	return bFound;
}
//找最小距离
int CEL2PL::getMinDist(AcDbEntity* pEnt,AcDbEntityArray& arEnts,int ipos,double &dMinDist,AcGePoint2d &ptmin1,AcGePoint2d &ptmin2)
{
	double dTmpDist;
	int len=arEnts.length();
	for (int j=ipos; j<len; j++){
		AcDbEntity *pEnt2=arEnts[j];
		if(!isIntersect(pEnt, pEnt2)){
			//if(pEnt->isKindOf,,,
			dTmpDist=getMinDist((AcDbPolyline*)pEnt,(AcDbPolyline*)pEnt2,dMinDist,ptmin1,ptmin2);
			if(dMinDist>dTmpDist && dTmpDist>0){
				dMinDist=dTmpDist;
				myprintf("getMinDist1 %.4f\n!",dMinDist);
			}
		}
	}
	return 0;
}
int CEL2PL::getMinDist(AcDbPolyline* pline1, AcDbPolyline* pline2,double &dMinDist,AcGePoint2d &ptmin1,AcGePoint2d &ptmin2)
{
	int len1,len2;
	AcGePoint2d pt1, pt2;
	AcGePoint3d ptOnCurve;
	len1=pline1->numVerts();
	len2=pline2->numVerts();
	double dTmpDist;
	for(int i=0;i<len1;i++){
		pline1->getPointAt(i,pt1);
		for(int j=0;j<len2;j++){
			pline2->getPointAt(j,pt2);
			pline2->getClosestPointTo(AcGePoint3d(pt1.x,pt1.y,0), ptOnCurve);
			dTmpDist=pt1.distanceTo(AcGePoint2d(ptOnCurve.x,ptOnCurve.y));
			if(dMinDist>dTmpDist && dTmpDist>0){
				dMinDist=dTmpDist;
				ptmin1=pt1;ptmin2=AcGePoint2d(ptOnCurve.x,ptOnCurve.y);
				myprintf("getMinDist2 %.4f %.4f!\n",dMinDist,dTmpDist);
			}
			pline1->getClosestPointTo(AcGePoint3d(pt2.x,pt2.y,0), ptOnCurve);
			dTmpDist=pt2.distanceTo(AcGePoint2d(ptOnCurve.x,ptOnCurve.y));
			if(dMinDist>dTmpDist && dTmpDist>0){
				dMinDist=dTmpDist;
				ptmin1=pt2;ptmin2=AcGePoint2d(ptOnCurve.x,ptOnCurve.y);
				myprintf("getMinDist2 %.4f %.4f!\n",dMinDist,dTmpDist);
			}
		}
	}
	return 0;
}
