#include "EL2PL.h"

/* CEL2PL::CEL2PL(void)
{
	m_pi=atan(1.0) * 4.0;
	m_twopi=atan(1.0)*8.0;
	pMyLog=new class MyLog;
}*/
CEL2PL::CEL2PL()
{
	m_pi=atan(1.0) * 4.0;
	m_twopi=atan(1.0)*8.0;
}
CEL2PL::~CEL2PL(void)
{
}

int CEL2PL::starEL2PL(void)
{
	//ads_name en;
	ads_point pt;
	ads_name ss, ss1;
	
	int iSel;
	CAcModuleResourceOverride resOverride;
	CEL2PLDialog mydlg(acedGetAcadFrame());
	iSel=mydlg.DoModal();
	acutPrintf("mydlg Sel: %d\n",iSel);
	//acedGetInt("\n1,选择 2,指定层 3,全部: ",&iSel);
	CString sLayer;
	struct resbuf *XreDa;

	if(iSel==IDC_SELECT){	//按提示生成选择集
		XreDa=acutBuildList(RTDXF0,"ELLIPSE",0);
		if (acedSSGet(NULL, NULL, NULL, XreDa, ss)!=RTNORM){
			acutPrintf("没有选择椭圆!\n");
			acutRelRb(XreDa);
			return BAD;
		}
		acutRelRb(XreDa);
	}else if(iSel==IDC_ONELAYER){ //指定层
		//acedGetString(0,"请输入层名:",sLayer);
		sLayer=mydlg.layername;
		acutPrintf("layer:%s!\n",sLayer);
		XreDa=acutBuildList(-4,_T("<and"),
			RTDXF0,_T("ELLIPSE"),			//实体=Ellipse
			AcDb::kDxfLayerName,_T(sLayer),//层=sLayer
			-4,_T("and>"),0);
		if (acedSSGet("X",NULL,NULL,XreDa,ss)!=RTNORM) {
			acutPrintf("没有选择椭圆!\n");
			acutRelRb(XreDa);
			return BAD;
		}
		acutRelRb(XreDa);
	}else if(iSel==IDC_ALL){ //全部
		acutPrintf("all layer!\n");
		XreDa=acutBuildList(RTDXF0,"ELLIPSE",0);
		if (acedSSGet("X",NULL,NULL,XreDa,ss)!=RTNORM) {
			acutPrintf("没有选择椭圆!\n");
			acutRelRb(XreDa);
			return BAD;
		}
		acutRelRb(XreDa);
	}else{
		acutPrintf("没有选择\n");
		return BAD;
	}
	// Get the name of first entity in sset.
	if (acedSSName(ss, 0L, ss1) != RTNORM) 
		return BAD; 

	long length;

	if (acedSSLength(ss, &length) != RTNORM) 
		return BAD; 
	//myprintf("select cnt:%d \n",length);

	//acedSetStatusBarProgressMeter("Test Progress Bar", 0, length);
	//acedRestoreStatusBar();
	//setMylog(1);
	for (int i=0;i<length;i++){
		//acedSetStatusBarProgressMeterPos(i);
		if (acedSSName(ss, i, ss1) != RTNORM) 
			break;
		AcDbPolyline* pPolyline = ellipse2polyline(ss1);
		if (pPolyline){			
			//pPolyline->setColorIndex(1);
			AcDbObjectId custOID;
			postToDatabase(pPolyline, custOID);
			pPolyline->close();
		}
		//mysynclog();
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

AcDbPolyline* CEL2PL::spline2polyline(ads_name &en)
{
	//1,打开实体,保存图层ID,取点
	Adesk::Boolean isClosed;
	AcDbObjectId eId;
	AcDbEntity * pEnt;
	acdbGetObjectId(eId, en);
	AcGePoint2dArray ptArr;

	acdbOpenObject(pEnt, eId, kForRead);  //kForRead; kForWrite;
	myprintf ("entity: %s\n", pEnt->isA()->name());
	if (!pEnt->isKindOf(AcDbSpline::desc()))
	{
		pEnt->close();
		return NULL;
	}
	if(isOnLockedLayer(pEnt,true)){
		pEnt->close();
		return NULL;
	}
	pEnt->close();

	acdbOpenObject(pEnt, eId, kForWrite);
	AcDbSpline * pSpline=(AcDbSpline *)pEnt;
	getPlinePoints(pSpline,ptArr);
	//CString layerId=pSpline->layer();
	//AcDbObjectId layerId=pSpline->layerId();
	AcDbPolyline *pLwpoly = new AcDbPolyline;
	pLwpoly->setLayer(pEnt->layerId());
	pLwpoly->setColor(pEnt->color());
	isClosed=pSpline->isClosed();
	pSpline->erase();
	pSpline->close();

	//2,构造polyline
	/* for debug: 显示起点
	AcDbObjectId custOID;
	AcDbPoint* pPoint = new AcDbPoint();pPoint->setPosition(ptArr.at(0));postToDatabase(pPoint,custOID); */
	//AcGePoint3d ptStart,ptEnd;
	//getArcBulge(ptArr.at(0),ptArr.at(1),ptArr.at(2),dBugle);
	//pLwpoly->addVertexAt(0,ptArr.at(0),dBugle);
	if(ptArr.length()<4) return NULL;
	//第一段
	int ptIdx=0;
	double dBugle;
	double dAngle;
	int enttype[2];//0 prev 1 cur //0直线1圆弧
	double entbugle[2];
	if(isLine(ptArr.at(0),ptArr.at(1),ptArr.at(2))){
		dBugle=0;
		getLineAngle(ptArr.at(0),ptArr.at(2),dAngle);
		myprintf("ptIdx %d angle:%.8f\n",0,dAngle);
		enttype[0]=0;
		entbugle[0]=dAngle;
	}else{
		getArcBulge(ptArr.at(0),ptArr.at(1),ptArr.at(2),dBugle);
		myprintf("ptIdx %d bugle:%.8f\n",0,dBugle);
		enttype[0]=1;
		entbugle[0]=dBugle;
	}
	pLwpoly->addVertexAt(ptIdx,ptArr.at(0),dBugle);
	ptIdx++;
	int isSkip=0;
	for (int i = 2; i < ptArr.length()-2; i+=2)
	{
		if(isLine(ptArr.at(i),ptArr.at(i+1),ptArr.at(i+2))){
			dBugle=0;
			//set var
			getLineAngle(ptArr.at(i),ptArr.at(i+2),dAngle);
			enttype[1]=0;
			entbugle[1]=dAngle;
			//do some
			if(enttype[0] != 0 || myabs(entbugle[1]-entbugle[0]) > m_dSegfactor ) {
				pLwpoly->addVertexAt(ptIdx,ptArr.at(i),dBugle);
				ptIdx++;
				entbugle[0]=entbugle[1];
				enttype[0]=enttype[1];
			}else {
				//myprintf("l %d angle:%.8f %.8f\n",ptIdx,entbugle[0],entbugle[1]);
			}
			//done
		}else{
			getArcBulge(ptArr.at(i),ptArr.at(i+1),ptArr.at(i+2),dBugle);
			//set var
			enttype[1]=1;
			entbugle[1]=dBugle;
			//do some
			double dDiff=myabs(entbugle[1]-entbugle[0]);
			if(enttype[0] != 1 ||  dDiff > m_dSegfactor || isSkip >4 ) {
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
							getArcBulge(ptArr.at(i-iSt+2),ptArr.at(i-iMid+2),ptArr.at(i-iEnd+2),dBugle);
							pLwpoly->addVertexAt(ptIdx,ptArr.at(i-iSt+2),dBugle);
							myprintf("st mid end:%d %d %d\n",iSt,iMid,iEnd);
							iSt=iSt-int(iStep*2);
						}
					}else{//重新计算bugle
						getArcBulge(ptArr.at(i-(isSkip+1)*2+2),ptArr.at(i-(isSkip+1)+2),ptArr.at(i+2),dBugle);
						pLwpoly->addVertexAt(ptIdx,ptArr.at(i-(isSkip+1)*2+2),dBugle);
					}
					isSkip=0;
				}else{
					pLwpoly->addVertexAt(ptIdx,ptArr.at(i),dBugle);
					}*/
				getArcBulge(ptArr.at(i-(isSkip+1)*2+2),ptArr.at(i-(isSkip+1)+2),ptArr.at(i+2),dBugle);
				pLwpoly->addVertexAt(ptIdx,ptArr.at(i-(isSkip+1)*2+2),dBugle);
				ptIdx++;
				myprintf("%d %d %d %.12f %.12f %.8f\n",ptIdx,enttype[0],enttype[1],entbugle[0],entbugle[1],dDiff);
				entbugle[0]=entbugle[1];
				enttype[0]=enttype[1];
				isSkip=0;
			}else {
				isSkip++;
				myprintf("->%d skip ",isSkip);
				myprintf("%d %d %d %.12f %.12f %.8f\n",ptIdx,enttype[0],enttype[1],entbugle[0],entbugle[1],dDiff);
			}
		}
		
		//myprintf("ptIdx %d pt1 %.4f,%.4f pt2 %.4f,%.4f pt3 %.4f,%.4f dBugle: %.8f\n",ptIdx,pt1[0],pt1[1],pt2[0],pt2[1],pt3[0],pt3[1],dBugle);
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

	//myprintf("ptIdx %d Pt3 %.4f %.4f dBugle: %.8f\n",ptIdx,ptArr.last().x,ptArr.last().y,dBugle);
	return pLwpoly;
}

AcDbPolyline* CEL2PL::ellipse2polyline(ads_name &en)
{
	AcDbObjectId eId;
	acdbGetObjectId(eId, en);
	AcGePoint2dArray ptArr;
	Adesk::Boolean isClosed;

	AcDbEntity * pEnt;
	acdbOpenObject(pEnt, eId, kForRead); //kForRead  kForWrite;
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

	acdbOpenObject(pEnt, eId, kForWrite);

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

	double dBugle;
	//getArcBulge(pt1,pt2,pt3,dBugle);
	//pLwpoly->addVertexAt(0,asPnt2d(pt1),dBugle);
	int ptIdx=0;
	for (int i = 0; i < ptArr.length()-2; i+=2)
	{
		getArcBulge(ptArr.at(i),ptArr.at(i+1),ptArr.at(i+2),dBugle);
		//myprintf("ptStart %.4f,%.4f PtEnd %.4f %.4f dBugle: %.4f\n",ptStart.x,ptStart.y,ptEnd.x,ptEnd.y,dBugle);
		//pLwpoly->addVertexAt(i/2,asPnt2d(asDblArray(ptStart)),dBugle);
		pLwpoly->addVertexAt(ptIdx,ptArr.at(i),dBugle);
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
	ads_point apt1,apt2;
	apt1[0]=pt1.x,apt1[1]=pt1.y;
	apt2[0]=pt2.x,apt2[2]=pt2.y;
	dAngle=acutAngle(apt1,apt2);
	return GOOD;
}
int CEL2PL::getArcBulge(AcGePoint2d& pt1,AcGePoint2d& pt2,AcGePoint2d& pt3,double & dBugle)
{
	//计算Bugle
	AcGeCircArc2d pGArc(pt1,pt2,pt3);
	//椭圆不用判断(3点在直线上)
	double endAngle,startAngle,dAngle;
	startAngle=pGArc.startAng();
	endAngle=pGArc.endAng();
	if (endAngle<startAngle) endAngle+= m_twopi; // 8*atan(1.0);
	dAngle=endAngle-startAngle;
	dBugle=tan(dAngle/4);
	if(pGArc.isClockWise()) dBugle = -dBugle;
	return GOOD;
}
int CEL2PL::isLine(AcGePoint2d& pt1,AcGePoint2d& pt2,AcGePoint2d& pt3)
{	
	//0:不是直线 1是直线,
	AcGeLine2d line1(pt1,pt2);
	AcGeLine2d line2(pt2,pt3);
	AcGePoint2d pt;
	int ret=line1.intersectWith(line2,pt);
	return !ret;
}
/*
int CEL2PL::getArcBulge(ads_point pt1,ads_point pt2,ads_point pt3,double & dBugle)
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
	//get dBugle
	double dAngle;
	int isEngAngle=0;
	if (EndAngle<StartAngle){
		EndAngle+=8*atan(1.0);
		isEngAngle=1;
	}
	dAngle=EndAngle-StartAngle;
	dBugle=tan(dAngle/4);
	//if(isEngAngle){dBugle=-1*dBugle;}
	return GOOD;
}*/
int CEL2PL::getPlinePoints(AcDbSpline* pSpl, AcGePoint2dArray& ptArr)
{
	ptArr.setLogicalLength(0);
	double dParamSt,dParamEnd;
	if(Acad::eOk != pSpl->getStartParam(dParamSt) || Acad::eOk != pSpl->getEndParam(dParamEnd)){
		return 0;
	}

	//拟合点数
	int numFitPts;
	if(pSpl->hasFitData())
	{
		numFitPts=pSpl->numFitPoints();
	}
	else{
		acutPrintf("pSpl hasFitData!");
		return 0;
	}
	if(m_iSegNums>0){
		acutPrintf("m_iSegNums %d\n",m_iSegNums);
	}
	else{
		m_iSegNums=126+numFitPts*64;  //2夹点:127 3:159 4:191  2*(127+(numFitPts-2)*32);
		//m_iSegNums=32+numFitPts*16;
	}

	ptArr.setPhysicalLength(m_iSegNums);

	double dStep=(dParamEnd - dParamSt)/(m_iSegNums); //distEnd - distSt
	double dLen=dParamSt; //distEnd;
	AcGePoint3d ptTmp;
	pSpl->getStartPoint(ptTmp);
	ptArr.append(AcGePoint2d(ptTmp.x,ptTmp.y));
	dLen += dStep;
	//AcGePointOnCurve2d ptoncurve(AcDbSpline)
	for (int i=1;i<m_iSegNums;i++){
		//pSpl->getPointAtDist(dLen,ptTmp);
		pSpl->getPointAtParam(dLen,ptTmp);
		//myprintf("pt: %.4f,%.4f \n",ptTmp.x,ptTmp.y);

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

/* //功能:三点画弧
//编程:BDY
//时间:20080812
AcDbObjectId CEL2PL::CreateArc(ads_point pt1,ads_point pt2,ads_point pt3)
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
	AcDbObjectId ObjID,ObjID1,ObjID2;
	AcDbBlockTableRecord *pModelSpace =GetModelSpace(AcDb::kForWrite);
	AcDbArc *Narc1=new AcDbArc(Cpt,Radius,StartAngle,EndAngle);
	AcDbArc *Narc2=new AcDbArc(Cpt,Radius,EndAngle,StartAngle);
	pModelSpace->appendAcDbEntity(ObjID1,Narc1);
	pModelSpace->appendAcDbEntity(ObjID2,Narc2);
	Narc1->close();
	Narc2->close();
	pModelSpace->close();
	acdbOpenObject(pCur,ObjID1,AcDb::kForRead);
	pCur->getDistAtPoint(Mid,GDist1);
	pCur->close();
	acdbOpenObject(pCur,ObjID2,AcDb::kForRead);
	pCur->getDistAtPoint(Mid,GDist2);
	pCur->close();
	if (GDist1>GDist2) {
		EraseEntity(ObjID2);
		ObjID=ObjID1;
	}else{
		EraseEntity(ObjID1);
		ObjID=ObjID2;
	}
	return ObjID;
}

int CEL2PL::getObjBulge(AcDbObjectId objId,AcGePoint3d &ptStart,AcGePoint3d &ptEnd,double &dBugle)
{

	AcDbEntity * pEnt;
	AcDb::OpenMode openMode=kForRead; //kForWrite kForRead;
	acdbOpenObject(pEnt, objId, openMode);
	// myprintf("\n getObjBulge: %ld %s\n", objId,pEnt->isA()->name());
	dBugle=0;
	//
	AcDbLine *pLine;
	AcDbArc *pArc;
	double startAngle,endAngle,dAngle;
	if (pEnt->isKindOf(AcDbLine::desc()))
	{
		pLine=AcDbLine::cast(pEnt);
		if (pLine!=NULL)
		{
			ptStart=pLine->startPoint();
			ptEnd=pLine->endPoint();
			dBugle=0;
		}
	}
	else
	{
		pArc=AcDbArc::cast(pEnt);
		if (pArc!=NULL)
		{
			pArc->getStartPoint(ptStart);
			pArc->getEndPoint(ptEnd);
			startAngle=pArc->startAngle();
			endAngle=pArc->endAngle();
			if (endAngle<startAngle)
				endAngle+=8*atan(1.0);
			dAngle=endAngle-startAngle;
			dBugle=tan(dAngle/4);
		}
	}
	pEnt->close();
	return GOOD;
}

AcDbBlockTableRecord * CEL2PL::GetModelSpace(AcDb::OpenMode Mode)
{

	//AcDbDatabase *pDwg = acdbHostApplicationServices()->workingDatabase();
	if(!pDwg)
		pDwg= new AcDbDatabase;
	AcDbBlockTable *pBlockTable;
	AcDbBlockTableRecord *pModelSpace;
	pDwg->getSymbolTable(pBlockTable, AcDb::kForRead);
	pBlockTable->getAt(ACDB_MODEL_SPACE, pModelSpace, Mode);
	pBlockTable->close();
	return pModelSpace;
}
int CEL2PL::EraseEntity(AcDbObjectId ObjId)
{
	AcDbEntity *pEnt;
	acdbOpenObject(pEnt, ObjId, AcDb::kForWrite);
	pEnt->erase();
	pEnt->close();
	return GOOD;
} */
int CEL2PL::starSPL2PL(void)
{
	//1, 选择实体
	m_iSegNums=0;
	CAcModuleResourceOverride resOverride;
	CEL2PLDialog dlgE2P(acedGetAcadFrame());
	dlgE2P.m_segnum="0";
	int iSel=dlgE2P.DoModal();
	m_iSegNums=atoi(dlgE2P.m_segnum);
	acutPrintf("dlgSpl: %d \n",m_iSegNums);
	//acedGetInt("\n1,选择 2,指定层 3,全部: ",&iSel);
	struct resbuf *XreDa;
	ads_name ss;
	if(iSel==IDC_SELECT){	//按提示生成选择集  
		XreDa=acutBuildList(RTDXF0,"SPLINE",0);//对象=SPLINE
		if (acedSSGet(NULL, NULL, NULL, XreDa, ss)!=RTNORM){
			acutPrintf("没有选择spline!\n");
			acutRelRb(XreDa);
			return BAD;
		}
		acutRelRb(XreDa);
	}else if(iSel==IDC_ONELAYER){ //指定层
		//acedGetString(0,"请输入层名:",sLayer);
		CString sLayer=dlgE2P.layername;
		acutPrintf("layer:%s!\n",sLayer);
		XreDa=acutBuildList(-4,_T("<and"),
			RTDXF0,_T("SPLINE"),	//对象=SPLINE
			AcDb::kDxfLayerName,_T(sLayer), //层=sLayer
			-4,_T("and>"),0);
		if (acedSSGet("X",NULL,NULL,XreDa,ss)!=RTNORM) {
			acutPrintf("没有选择spline!\n");
			acutRelRb(XreDa);
			return BAD;
		}
		acutRelRb(XreDa);
	}else if(iSel==IDC_ALL){ //全部
		acutPrintf("all layer!\n");
		XreDa=acutBuildList(RTDXF0,"SPLINE",0);//对象=SPLINE
		if (acedSSGet("X",NULL,NULL,XreDa,ss)!=RTNORM) {
			acutPrintf("没有选择spline!\n");
			acutRelRb(XreDa);
			return BAD;
		}
		acutRelRb(XreDa);
	}else{
		acutPrintf("没有选择\n");
		return BAD;
	}

	//2,处理实体
	ads_name ss1;
	if (acedSSName(ss, 0L, ss1) != RTNORM) return BAD;

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
	//acutPrintf("dlgSpl m_dSegfactor: %d %.12f\n",iSel,m_dSegfactor);

	long length;
	if (acedSSLength(ss, &length) != RTNORM) return BAD;
	//进度条: acedSetStatusBarProgressMeter("Test Progress Bar", 0, length); acedRestoreStatusBar();
	//setMylog(1);
	for (int i=0;i<length;i++){
		//acedSetStatusBarProgressMeterPos(i);
		if (acedSSName(ss, i, ss1) != RTNORM) break;
		AcDbPolyline* pPolyline = spline2polyline(ss1);
		if (pPolyline)
		{
			AcDbObjectId custOID;
			postToDatabase(pPolyline, custOID);
			pPolyline->close();
		}
		//mysynclog();
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

	//setMylog(0);
	ads_point pte;
	pte[0]=0,pte[1]=0;pte[2]=0;
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
	return GOOD;
}

int CEL2PL::lineWiden(AcDbLine *pLine,double linewidth)
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
	
	if(acutDistance(pt1,pt2)<0.00001){
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
	double dBugle;
	acutPolar(pt1,Angle1+90*m_pi/180,widthHalf,mp1); //逆时钟90度
	acutPolar(pt1,Angle1+180*m_pi/180,widthHalf,cp1);//逆时钟180度
	acutPolar(pt1,Angle1+270*m_pi/180,widthHalf,mp2);//逆时钟270度
	getArcBulge(AcGePoint2d(mp1[0],mp1[1]),AcGePoint2d(cp1[0],cp1[1]),AcGePoint2d(mp2[0],mp2[1]),dBugle);

	pLWPolyline->addVertexAt(ptIdx,AcGePoint2d(mp1[0],mp1[1]),dBugle);
	ptIdx++;
	pLWPolyline->addVertexAt(ptIdx,AcGePoint2d(mp2[0],mp2[1]),0);
	ptIdx++;

	acutPolar(pt2,Angle1+270*m_pi/180,widthHalf,mp3); //逆时钟270度
	acutPolar(pt2,Angle1+360*m_pi/180,widthHalf,cp2);//逆时钟360度
	acutPolar(pt2,Angle1+90*m_pi/180,widthHalf,mp4);//逆时钟90度
	getArcBulge(AcGePoint2d(mp3[0],mp3[1]),AcGePoint2d(cp2[0],cp2[1]),AcGePoint2d(mp4[0],mp4[1]),dBugle);	
	pLWPolyline->addVertexAt(ptIdx,AcGePoint2d(mp3[0],mp3[1]),dBugle);
	ptIdx++;
	pLWPolyline->addVertexAt(ptIdx,AcGePoint2d(mp4[0],mp4[1]),0);
	ptIdx++;
	pLWPolyline->setClosed(Adesk::kTrue);
	pLWPolyline->setLayer(m_layerid);
	AcDbObjectId objId;
	postToDatabase(pLWPolyline,objId);
	pLWPolyline->close();
	return 0;
}

int CEL2PL::lineWiden(AcDbArc *pArc,double linewidth)
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
	double dRadius,dBugle;
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
	dBugle=tan(dAngle/4);
	if(pGArc.isClockWise()) dBugle = -dBugle;

	pGArc.setRadius(dRadius + widthHalf);
	pt1[0]=pGArc.startPoint().x;
	pt1[1]=pGArc.startPoint().y;
	pt1[2]=0;
	pLWPolyline->addVertexAt(ptIdx,asPnt2d(pt1),dBugle);
	ptIdx++;
	pt1[0]=pGArc.endPoint().x;
	pt1[1]=pGArc.endPoint().y;
	pt1[2]=0;
	pLWPolyline->addVertexAt(ptIdx,asPnt2d(pt1),0);
	ptIdx++;

	pGArc.setRadius(dRadius - widthHalf);
	pt1[0]=pGArc.endPoint().x;
	pt1[1]=pGArc.endPoint().y;
	pLWPolyline->addVertexAt(ptIdx,asPnt2d(pt1),-dBugle);
	ptIdx++;
	
	pt1[0]=pGArc.startPoint().x;
	pt1[1]=pGArc.startPoint().y;
	pLWPolyline->addVertexAt(ptIdx,asPnt2d(pt1),0);
	ptIdx++;

	pLWPolyline->setClosed(Adesk::kTrue);
	pLWPolyline->setLayer(m_layerid);
	AcDbObjectId objId;
	postToDatabase(pLWPolyline,objId);
	pLWPolyline->close();
	return 0;
}

int CEL2PL::polyWiden(ads_name ss1)
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
		return NULL;
	}
	int isConvOk=1;
	if(pEntSS1->isKindOf(AcDb2dPolyline::desc()) || pEntSS1->isKindOf(AcDbPolyline::desc())){
		AcDbVoidPtrArray entitySe2;
		pEntSS1->explode(entitySe2);
		for(int j=0;j<entitySe2.length();j++){
			AcDbCurve *pEntitytem2 =(AcDbCurve *)entitySe2.at(j);
			if(pEntitytem2->isKindOf(AcDbLine::desc())){
				lineWiden((AcDbLine *)pEntitytem2,m_linewidth);
			}else if(pEntitytem2->isKindOf(AcDbArc::desc())){
				lineWiden((AcDbArc *)pEntitytem2,m_linewidth);
			}else {
				acutPrintf(" error:多段线包含%s\n",pEntitytem2->isA()->name());
				isConvOk=0;
			}
		}
		if(isConvOk){
			pEntSS1->erase();
		}
	}
	else{
		acutPrintf("1:%s\n",pEntSS1->isA()->name());
	}
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
Acad::ErrorStatus CEL2PL::Poly2dToLWPoly(AcDb2dPolyline *pPoly,AcDbPolyline *& pLwpoly)
{
	if (!pPoly)
		return Acad::eInvalidInput;
	Acad::ErrorStatus ret;
	AcDb::Poly2dType type;
	type=pPoly->polyType();
	if ((type==AcDb::k2dSimplePoly)||(type==AcDb::k2dFitCurvePoly)){
		pLwpoly=new AcDbPolyline;
		ret=pLwpoly->convertFrom((AcDbEntity *&)pPoly,Adesk::kTrue);
		if (ret!=Acad::eOk){
			delete pLwpoly;
			pLwpoly=NULL;
			return Acad::eNotImplementedYet;
		}
	}
	else{
		return Acad::eNotImplementedYet;
	}
	return Acad::eOk;
}
int CEL2PL::text2polyline(ads_name ss1)
{
	char *pathvar = getenv( "TEMP" );
	if(pathvar==NULL){
		pathvar="C:\\";
	}
	CString textfilename=pathvar;
	textfilename=textfilename+"\\temptext";
	myprintf("%s\n",textfilename);

	AcDbObjectId eId;
	AcDbEntity * pEntSS1;
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
		/*
		double m_textRotationt;
		double m_textwidthFactor;
		m_textwidthFactor = pText->widthFactor();
		m_textRotationt = pText->rotation();
		AcGePoint3d ptPos = pText->position();
		char *atext = pText->textString();
		double thiness = pText->thickness();
		ads_point ptText0,ptText1,ptText2,ptText3;
		ptText0[0]=ptPos.x;ptText0[1]=ptPos.y;
		acutPolar(ptText0,m_textRotationt+90*m_pi/180,m_textheight,ptText1);
		acutPolar(ptText1,m_textRotationt,m_textheight*m_textwidthFactor*m_textcnt,ptText2);
		acutPolar(ptText0,m_textRotationt,m_textheight*m_textwidthFactor*m_textcnt,ptText3);
		myprintf("%.4f,%.4f %.4f,%.4f %.4f,%.4f %.4f,%.4f thickness:%.4f\n",ptText0[0],ptText0[1],ptText1[0],ptText1[1],ptText2[0],ptText2[1],ptText3[0],ptText3[1],thiness);
		m_ptTextLeft[0]=min4(ptText0[0],ptText1[0],ptText2[0],ptText3[0]);
		m_ptTextLeft[1]=min4(ptText0[1],ptText1[1],ptText2[1],ptText3[1])-m_textheight/3;
		m_ptTextRight[0]=max4(ptText0[0],ptText1[0],ptText2[0],ptText3[0])-m_textheight*m_textwidthFactor/3;
		m_ptTextRight[1]=max4(ptText0[1],ptText1[1],ptText2[1],ptText3[1]);		
		acedCommand(RTSTR,"zoom",RTSTR,"w",RTPOINT,m_ptTextLeft,RTPOINT,m_ptTextRight,0);*/
		/*AcDbExtents ext;
		pText->getGeomExtents(ext);
		myprintf("%.4f,%.4f %.4f,%.4f \n",ext.minPoint().x,ext.minPoint().y,ext.maxPoint().x,ext.maxPoint().y);
		m_ptTextLeft[0]=ext.minPoint().x-0.00001;
		m_ptTextLeft[1]=ext.minPoint().y-0.00001;
		m_ptTextRight[0]=ext.maxPoint().x+0.00001;
		m_ptTextRight[1]=ext.maxPoint().y+0.00001;*/
		m_layerid = pEntSS1->layerId();
		//for debug pEntSS1->close(); return NULL;
	}
	else if(pEntSS1->isKindOf(AcDbMText::desc()) )
	{
		//转换成AcDbText再处理
		acutPrintf("AcDbMText explode!\n");
		pEntSS1->close();
		return NULL;
		/*
		AcDbMText *pMText = (AcDbMText *)pEntSS1;
		m_textheight = pMText->textHeight();
		
		pMText->setWidth(pMText->actualWidth());

		AcDbExtents extents;
		pMText->getGeomExtents(extents);
		AcGePoint2d extMin,extMax;
		myprintf("%.4f,%.4f %.4f,%.4f \n",extents.minPoint().x,extents.minPoint().y,extents.maxPoint().x,extents.maxPoint().y);

		m_ptTextLeft[0]=extents.minPoint().x;
		m_ptTextLeft[1]=extents.minPoint().y;
		m_ptTextRight[0]=extents.maxPoint().x;
		m_ptTextRight[1]=extents.maxPoint().y;
		acedCommand(RTSTR,"zoom",RTSTR,"w",RTPOINT,m_ptTextLeft,RTPOINT,m_ptTextRight,0);

		getLUL();
		m_layerid = pEntSS1->layerId();*/
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
	myprintf("box:%.4f,%.4f %.4f,%.4f\n",lowleft[X],lowleft[Y],upright[X],upright[Y]);
	myprintf("org: %.4f,%.4f %.5f\n",origin[X],origin[Y],rotatn);
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
	m_ptTextLeft[0]=findMin(4,pt1.x,pt2.x,pt3.x,pt4.x);
	m_ptTextLeft[1]=findMin(4,pt1.y,pt2.y,pt3.y,pt4.y);
	m_ptTextRight[0]=findMax(4,pt1.x,pt2.x,pt3.x,pt4.x);
	m_ptTextRight[1]=findMax(4,pt1.y,pt2.y,pt3.y,pt4.y);
	//acedCommand(RTSTR,"zoom",RTSTR,"e",0);	
	//acedCommand(RTSTR,"zoom",RTSTR,"w",RTPOINT,m_ptTextLeft,RTPOINT,m_ptTextRight,0);
	//zoom w
	struct resbuf *callist, *results = NULL;
	callist = acutBuildList(RTSTR, "C:tmpZoom",
		RTPOINT, m_ptTextLeft,
		RTPOINT, m_ptTextRight, 0);
	if (acedInvoke(callist, &results) == RTERROR)
		acdbFail("Cannot run c:tmpZoom -- 请加载textb.lsp\n"); 
		acutRelRb(callist); 
	acutRelRb(results);
	//text转换成blockref
	getLUL();
	callist = acutBuildList(RTSTR, "C:tmpText2Polyline",
		RTSTR,textfilename,
		RTENAME,ss1,
		RTPOINT,m_lul,
		RTPOINT,m_vc,	0);
	if (acedInvoke(callist, &results) == RTERROR) 
		acdbFail("不能运行C:tmpText2Polyline,texta.lsp加载了吗?\n");
	acutRelRb(callist);
	acutRelRb(results);

	//blockref 转换成polyline
	ads_name last;
	////不输出cmd信息
	//struct resbuf rbVar;
	//rbVar.restype=RTSHORT;
	//rbVar.resval.rint=0;
	//if ( RTNORM != acedSetVar("cmdecho", &rbVar))
	//{
	//	acutPrintf("setvar cmdecho 0 fail!");// return 1;
	//}
	//rbVar.restype=RTSHORT;
	//rbVar.resval.rint=1;
	//if ( RTNORM != acedSetVar("mirrtext", &rbVar))
	//{
	//	acutPrintf("setvar mirrtext fail!");// return 1;
	//}
	//int retCmd;
	//retCmd=acedCommand(RTNONE);
	//if(retCmd!=RTNORM){
	//	acutPrintf("acedCommand failed2!%d\n",retCmd);
	//	return 1;
	//}
	//retCmd=acedCommand(/*RTSTR,"mirror",RTENAME,ss1,RTSTR,"",RTPOINT,m_vc, RTSTR,"@0,1", RTSTR,"y",
	//	myprintf("mirror: %d\n",retCmd);
	//	ads_name last;
	//	if(acdbEntLast(last)!=RTNORM){
	//	acutPrintf("entlast failed!\n");
	//	return 1;
	//	}
	//	retCmd=acedCommand(*/
	//	RTSTR,"wmfout",RTSTR,textfilename,RTENAME,ss1,RTSTR,"",
	//	RTSTR,"erase",RTENAME,ss1,RTSTR,"",
	//	/*
	//	//erase entity
	//	if(acdbOpenObject(pEntSS1, eId, kForWrite)==Acad::eOk){
	//	pEntSS1->erase();
	//	pEntSS1->close();
	//	}*/
	//	RTSTR,"wmfin",RTSTR,textfilename, RTPOINT,m_lul, RTSTR,"2.0008", RTSTR,"", RTSTR,"", 0);
	////Sleep(2000);
	//if(retCmd!=RTNORM){
	//	acutPrintf("acedCommand failed!%d\n",retCmd);
	//	return 1;
	//}
	//if(acdbEntLast(last)!=RTNORM){
	//	acutPrintf("entlast failed!\n");
	//	return 1;
	//}
	////retCmd=acedCommand(RTSTR,"mirror",RTENAME,last,RTSTR,"",RTPOINT,m_vc, RTSTR,"@0,1", RTSTR,"y", 0);
	//rbVar.restype=RTSHORT;
	//rbVar.resval.rint=0;
	//if ( RTNORM != acedSetVar("cmdecho", &rbVar))
	//{
	//	acutPrintf("setvar cmdecho 1 fail!");// return 1;
	//}
	//rbVar.restype=RTSHORT;
	//rbVar.resval.rint=0;
	//if ( RTNORM != acedSetVar("mirrtext", &rbVar))
	//{
	//	acutPrintf("setvar mirrtext fail!");// return 1;
	//}

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
		for(int i=0;i<entitySet.length();i++){
			AcDbCurve *pEntitytemp =(AcDbCurve *)entitySet.at(i);
			if(pEntitytemp->isKindOf(AcDb2dPolyline::desc())){
				p2dpolyline=(AcDb2dPolyline *)pEntitytemp;
				if(m_bWiden){
					AcDbVoidPtrArray entitySe2;
					pEntitytemp->explode(entitySe2);
					for(int j=0;j<entitySe2.length();j++){
						AcDbCurve *pEntitytem2 =(AcDbCurve *)entitySe2.at(j);
						if(pEntitytem2->isKindOf(AcDbLine::desc())){
							lineWiden((AcDbLine *)pEntitytem2,m_linewidth * m_textheight);
						}else{
							isConvOk=0;
							acutPrintf("  2:%s\n",pEntitytem2->isA()->name());
						}
					}
				}else{
					pLWPolyline=new AcDbPolyline();
					int pidx=0;
					AcGePoint3d ptSt,ptEnd;
					AcDbVoidPtrArray entitySe2;
					pEntitytemp->explode(entitySe2);
					for(int j=0;j<entitySe2.length();j++){
						AcDbCurve *pEntitytem2 =(AcDbCurve *)entitySe2.at(j);
						if(pEntitytem2->isKindOf(AcDbLine::desc())){
							((AcDbLine *)pEntitytem2)->getStartPoint(ptSt);
							((AcDbLine *)pEntitytem2)->getEndPoint(ptEnd);
							pLWPolyline->addVertexAt(pidx,AcGePoint2d(ptSt.x,ptSt.y));
							pidx++;
						}else{
							isConvOk=0;
							acutPrintf("text2polyline: %s\n",pEntitytem2->isA()->name());
						}
					}
					pLWPolyline->addVertexAt(pidx,AcGePoint2d(ptEnd.x,ptEnd.y));
					postToDatabase(pLWPolyline,objId);
					pLWPolyline->close();
					/*postToDatabase(p2dpolyline,objId);
					p2dpolyline->close(); --
					if(Poly2dToLWPoly(p2dpolyline,pLWPolyline)==Acad::eOk){
						postToDatabase(pLWPolyline,objId);
						pLWPolyline->close();
					}*/
				}
			}else{
				isConvOk=0;
				acutPrintf("1:%s\n",pEntitytemp->isA()->name());
			}
			//pEntitytemp->close();
		}
		if(isConvOk){
			pEnt->erase();
		}
	}else{
		acutPrintf("0:%s\n",pEnt->isA()->name());
	}
	pEnt->close();
	//AcDbObjectId objId;
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
	myprintf("lul:%.4f,%.4f\n",m_lul[0],m_lul[1]);
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

int CEL2PL::starPolyWiden(int sel)
{
	ads_name ss, ss1;
	int iSel;
	CString sLayer;
	if(sel==0){
		CAcModuleResourceOverride resOverride;
		CWidenSelDialog mydlg(acedGetAcadFrame());
		mydlg.m_dWiden = "0.3";
		mydlg.m_bFillet=TRUE;
		mydlg.m_bPolyline=TRUE;
		iSel=mydlg.DoModal();
		sLayer=mydlg.layername;
		CString str=mydlg.m_dWiden;
		acutPrintf("text: %s !\n",str);
		m_linewidth=atof(str);
	}else{
		iSel=IDC_ALL;
	}
	//acedGetInt("\n1,选择 2,指定层 3,全部: ",&iSel);

	struct resbuf *XreDa;
	if(iSel==IDC_SELECT){	//按提示生成选择集
		XreDa=acutBuildList(-4,_T("<or"),
			RTDXF0,_T("POLYLINE"),			//实体=POLYLINE
			RTDXF0,_T("LWPOLYLINE"),			//实体=POLYLINE
			-4,_T("or>"),
			0);
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
			RTDXF0,_T("POLYLINE"),			//实体=TEXT
			RTDXF0,_T("LWPOLYLINE"),			//实体=ATTDEF
			-4,_T("or>"),
			AcDb::kDxfLayerName,_T(sLayer),//层=sLayer
			-4,_T("and>"),0);
		if (acedSSGet("X",NULL,NULL,XreDa,ss)!=RTNORM) {
			acutPrintf("没有选择!\n");
			acutRelRb(XreDa);
			return BAD;
		}
		acutRelRb(XreDa);
	}else if(iSel==IDC_ALL){ //全部
		acutPrintf("all layer!\n");
		XreDa=acutBuildList(-4,_T("<or"),
			RTDXF0,_T("POLYLINE"),			//实体=TEXT
			RTDXF0,_T("LWPOLYLINE"),			//实体=ATTDEF
			-4,_T("or>"),0);
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
	if (acedSSLength(ss, &length) != RTNORM) 
		return BAD;

	//CWidenDialog dlgText(acedGetAcadFrame());
	//dlgText.m_dWiden = "0.3";
	//iSel=dlgText.DoModal();
	//if(iSel==IDOK){
	//	CString str=dlgText.m_dWiden;
	//	acutPrintf("text: %s !\n",str);
	//	m_linewidth=atof(str);
	//}

	//setMylog(0);
	ads_point pte;
	pte[0]=0,pte[1]=0;pte[2]=0;
	ads_name last;
	m_textcnt=length;
	for (int i=0;i<length;i++)
	{
		if (acedSSName(ss, i, ss1) != RTNORM) 
			break;
		polyWiden(ss1);
		//mysynclog();
	}
	mysynclog();
	//setMylog(0);
	acedSSFree(ss);
	return 0;
}
