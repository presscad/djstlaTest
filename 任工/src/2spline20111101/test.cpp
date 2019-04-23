#include "string"
#include "EL2PL.h"
#include "EntDisplay.h"
#include "Text2line.h"
//#include "allcmddialog.h"
#include "mydialog.h"
#include "resource.h"
#include "cirlist.h"
#include <queue>
#include <stack>
#include "func.h"

//for test
extern double m_pi;
int istest=1;
struct resbuf * entitem(struct resbuf *textent,short irestype);
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

/*
int CEL2PL::sortEnts(AcGePoint2dArray &arLines,AcDbDoubleArray &arBuggle)
{
	//排序直线
	AcDbEntity * pEnt;
	AcGePoint3d ptSt,ptEnd;
	
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
}*/
/*计算text边框,已有acedTextBox函数.
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

/* MText做wmfout,wmfin,现改为先explode成DText,再处理
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

	//调用acedCommand, 改为调用list脚本, 防止执行中按ESC取消
	//不输出cmd信息
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

Acad::ErrorStatus Poly2dToLWPoly(AcDb2dPolyline *pPoly,AcDbPolyline *& pLwpoly)
{
	if (!pPoly)
		return Acad::eInvalidInput; Acad::ErrorStatus ret; AcDb::Poly2dType type;
	type=pPoly->polyType();
	if ((type==AcDb::k2dSimplePoly)||(type==AcDb::k2dFitCurvePoly)){
		pLwpoly=new AcDbPolyline;
		ret=pLwpoly->convertFrom((AcDbEntity *&)pPoly,Adesk::kFalse);
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
Acad::ErrorStatus convertDbCurveToGeCurve(AcDbCurve *pDbCurve,AcGeCurve3d *&pGeCurve)
{
	pGeCurve=NULL;
	if (pDbCurve->isKindOf(AcDbLine::desc()))
	{
		AcDbLine *pL=(AcDbLine *)pDbCurve;
		AcGeLineSeg3d *pGL=new AcGeLineSeg3d;
		pGL->set(pL->startPoint(),pL->endPoint());
		pGeCurve=(AcGeCurve3d *)pGL;
	}
	else if (pDbCurve->isKindOf(AcDbArc::desc()))
	{
		AcDbArc *pArc=(AcDbArc *)pDbCurve;
		double ans,ane;
		ans=pArc->startAngle();
		ane=pArc->endAngle();
		AcGeCircArc3d *pGArc=new AcGeCircArc3d;
		pGArc->setCenter(pArc->center());
		pGArc->setRadius(pArc->radius());
		pGArc->setAngles(ans,ane);
		pGeCurve=(AcGeCurve3d *)pGArc;
	}
	else if (pDbCurve->isKindOf(AcDbCircle::desc()))
	{
		AcDbCircle *pCir=(AcDbCircle *)pDbCurve;
		AcGeCircArc3d * pGCir=new AcGeCircArc3d;
		pGCir->setCenter(pCir->center());
		pGCir->setRadius(pCir->radius());
		pGeCurve=(AcGeCurve3d *)pGCir;
	}
	else if (pDbCurve->isKindOf(AcDbEllipse::desc()))
	{
		AcDbEllipse *pEli=(AcDbEllipse *)pDbCurve;
		AcGePoint3d pt1,center=pEli->center();
		AcGeEllipArc3d *pGEli=new AcGeEllipArc3d;
		pGEli->setCenter(center);
		pGEli->setAxes(pEli->majorAxis(),pEli->minorAxis());
		pEli->getClosestPointTo(center,pt1,Adesk::kTrue);
		pGEli->setMajorRadius(pt1.distanceTo(center)/pEli->radiusRatio());
		pGEli->setMinorRadius(pt1.distanceTo(center));
		double endang=pEli->endAngle(),startang=pEli->startAngle();
		if (startang>endang){
			endang+=2*m_pi;
		}
		pGEli->setAngles(endang,startang);
		pGeCurve=(AcGeCurve3d *)pGEli;
	}
	else if (pDbCurve->isKindOf(AcDbSpline::desc()))
	{
		AcDbSpline *pSL=(AcDbSpline *)pDbCurve;
		if (!pSL)
			return Acad::eNotImplemented;
		if (pSL->isNull()==Adesk::kTrue)
			return Acad::eNotImplemented;

		int degree;
		Adesk::Boolean rational;
		Adesk::Boolean closed;
		Adesk::Boolean periodic;
		AcGePoint3dArray controlPoints;
		AcGeDoubleArray knots;
		AcGeDoubleArray weights;
		double controlPtTol;
		double knotTol;
		AcGeTol tol;
		Acad::ErrorStatus es;
		es=pSL->getNurbsData(degree,rational,closed,periodic,controlPoints,knots,weights,
			controlPtTol,knotTol);
		if (es!=Acad::eOk)
			return Acad::eNotImplemented;

		if (rational==Adesk::kTrue)
		{
			AcGeNurbCurve3d *pNurb=new AcGeNurbCurve3d(degree,knots,controlPoints,weights,periodic);
			if (closed==Adesk::kTrue)
				pNurb->makeClosed();
			if (pSL->hasFitData()==Adesk::kTrue)
			{
				AcGePoint3dArray fitPoints;
				double fitTolerance;
				Adesk::Boolean tangentsExist;
				AcGeVector3d startTangent;
				AcGeVector3d endTangent;
				pSL->getFitData(fitPoints,degree,fitTolerance,tangentsExist,startTangent,endTangent);
				tol.setEqualPoint(fitTolerance);
				if (tangentsExist==Adesk::kTrue)
					pNurb->setFitData(fitPoints,startTangent,endTangent,tol);
				else
					pNurb->setFitData(degree,fitPoints,tol);

			}
			pGeCurve=(AcGeCurve3d *)pNurb;
		}
		else
		{
			AcGeNurbCurve3d *pNurb=new AcGeNurbCurve3d(degree,knots,controlPoints,periodic);
			if (closed==Adesk::kTrue)
				pNurb->makeClosed();
			if (pSL->hasFitData()==Adesk::kTrue)
			{
				AcGePoint3dArray fitPoints;
				double fitTolerance;
				Adesk::Boolean tangentsExist;
				AcGeVector3d startTangent;
				AcGeVector3d endTangent;
				pSL->getFitData(fitPoints,degree,fitTolerance,tangentsExist,startTangent,endTangent);
				tol.setEqualPoint(fitTolerance);
				if (tangentsExist==Adesk::kTrue)
					pNurb->setFitData(fitPoints,startTangent,endTangent,tol);
				else
					pNurb->setFitData(degree,fitPoints,tol);

			}
			pGeCurve=(AcGeCurve3d *)pNurb;
		}
	}
	else if ((pDbCurve->isKindOf(AcDb2dPolyline::desc()))||
		(pDbCurve->isKindOf(AcDbPolyline::desc())))
	{
		int type=0;
		AcDbPolyline *pPoly;
		if (pDbCurve->isKindOf(AcDb2dPolyline::desc()))
		{
			AcDb2dPolyline *p2L=(AcDb2dPolyline *)pDbCurve;
			Poly2dToLWPoly(p2L,pPoly);
			type=1;
		}
		else 
			pPoly=(AcDbPolyline *)pDbCurve;
		
		//convertPolylineToGeCurve(pPoly,pGeCurve);
		if (type)
			delete pPoly;
	}
	return (pGeCurve)?Acad::eOk:Acad::eNotImplemented;
}
//看看几何库的：AcGeCompositeCurve2d ，AcGeCompositeCurve3d 类，专门处理大量几何实体，得到首尾相连的几何实体的。（收获不少）
//AcGeCurve2d转换到AcDbPolyline的代码，其中有AcGeCompositeCurve2d，AcGeCompositeCurve3d几何实体的转换。
//转换AcGeCurve2d到AcDbPolyline
Acad::ErrorStatus convertGeCurveToPolyline(AcGeCurve2d* pCurve,AcDbPolyline*& pResultPoly)
{
	AcGeVoidPointerArray resultCurves;

	AcGeCompositeCurve2d* pResultCurve;
	AcGeCurve2d* pThisCurve;
	AcGeCircArc2d* pArc;
	AcGeLineSeg2d* pLine;
	AcGePoint2d endPt;

	int nCurves;
	double bulge, ang;

	if(pCurve->isKindOf(AcGe::kCompositeCrv2d))
	{
		pResultCurve = (AcGeCompositeCurve2d*)pCurve;
		pResultCurve->getCurveList(resultCurves );
	}
	else
	{
		resultCurves.append(pCurve);
	}

	nCurves = resultCurves.length();

	pResultPoly = new AcDbPolyline(nCurves);

	for(int i=0; i < nCurves; i++)
	{
		pThisCurve = (AcGeCurve2d*)(resultCurves[i]);

		if(pThisCurve->isKindOf(AcGe::kCircArc2d))
		{
			pArc = (AcGeCircArc2d*)pThisCurve;
			bulge = 0.0;
			ang = 0.25 * (pArc->endAng() - pArc->startAng()); 
			bulge = tan(ang);
			if(pArc->isClockWise())
			{
				bulge = -bulge;
			}

			pResultPoly->addVertexAt(i, pArc->startPoint(), bulge
				);
		}
		else if(pThisCurve->isKindOf( AcGe::kLineSeg2d))
		{
			pLine = (AcGeLineSeg2d*)pThisCurve;
			pResultPoly->addVertexAt(i, pLine->startPoint(), 0 );
		}
	}// for
	if(pThisCurve->hasEndPoint(endPt))
	{
		pResultPoly->addVertexAt(i, endPt, 0);
	}
	pResultPoly->setClosed(pCurve->isClosed());
	return Acad::eOk;
}
Acad::ErrorStatus convertGeCurveToPolyline(AcGeCurve3d* pCurve, AcDbPolyline*& pResultPoly)
{
	AcGeVoidPointerArray resultCurves;

	AcGeCompositeCurve3d* pResultCurve;
	AcGeCurve3d* pThisCurve;
	AcGeCircArc3d* pArc;
	AcGeLineSeg3d* pLine;
	AcGePoint3d endPt;

	int nCurves;
	double bulge, ang;

	if(pCurve->isKindOf(AcGe::kCompositeCrv3d))
	{
		pResultCurve = (AcGeCompositeCurve3d*)pCurve;
		pResultCurve->getCurveList(resultCurves );
	}
	else
	{
		resultCurves.append(pCurve);
	}

	nCurves = resultCurves.length();

	pResultPoly = new AcDbPolyline(nCurves);

	for(int i=0; i < nCurves; i++)
	{
		pThisCurve = (AcGeCurve3d*)(resultCurves[i]);

		if(pThisCurve->isKindOf(AcGe::kCircArc3d))
		{
			pArc = (AcGeCircArc3d*)pThisCurve;
			bulge = 0.0;
			ang = 0.25 * (pArc->endAng() - pArc->startAng()); 
			bulge = tan(ang);
			//if(pArc->isClockWise()){bulge = -bulge;}
			pResultPoly->addVertexAt(i,AcGePoint2d(pArc->startPoint().x,pArc->startPoint().y), bulge);
		}
		else if(pThisCurve->isKindOf( AcGe::kLineSeg3d))
		{
			pLine = (AcGeLineSeg3d*)pThisCurve;
			pResultPoly->addVertexAt(i, AcGePoint2d(pLine->startPoint().x,pLine->startPoint().y), 0);
		}
		else if(pThisCurve->isKindOf( AcGe::kNurbCurve3d))
		{
			pLine = (AcGeLineSeg3d*)pThisCurve;
		}
	}// for
	if(pThisCurve->hasEndPoint(endPt))
	{
		pResultPoly->addVertexAt(i, AcGePoint2d(endPt.x,endPt.y), 0);
	}
	pResultPoly->setClosed(pCurve->isClosed());
	return Acad::eOk;
}
void drawArc()
{
	ads_point pt1,pt2,pt3;
	int rs;
    rs=acedGetPoint(NULL,"\n输入一个点：",pt1);
	assert(rs== RTNORM);
    acutPrintf("pt1: %.4f %.4f %.4f\n",pt1[0],pt1[1],pt1[2]);
	rs=acedGetPoint(NULL,"\n输入一个点：",pt2);
	assert(rs== RTNORM);
    acutPrintf("pt2: %.4f %.4f %.4f\n",pt2[0],pt2[1],pt2[2]);
	rs=acedGetPoint(NULL,"\n输入一个点：",pt3);
	assert(rs== RTNORM);
	acutPrintf("pt3: %.4f %.4f %.4f\n",pt3[0],pt3[1],pt3[2]);

	//todo: 3pt is line?
	double dBugle;
	AcGeCircArc2d pGArc(asPnt2d(pt1),asPnt2d(pt2),asPnt2d(pt3));
	AcGePoint2d ptOnLine=pGArc.closestPointTo(asPnt2d(pt2));
	acutPrintf("pt: %.4f %.4f %.4f %.4f \n",ptOnLine[0],ptOnLine[1],ptOnLine.x - pt2[0],ptOnLine.y - pt2[1]);
	if(myabs(ptOnLine.x - pt2[0]) > 1.0 || myabs(ptOnLine.y - pt2[1]) > 1.0)
	{
		dBugle=0;  //中点不在曲线上(3点在直线上)
	}else{
		//pGArc.set(pGArc.center(),AcGeVector3d::kZAxis,pGArc.radius());
		double endAngle,startAngle,dAngle;
		startAngle=pGArc.startAng();
		endAngle=pGArc.endAng();
		if (endAngle<startAngle)
			endAngle+=8*atan(1.0);
		dAngle=endAngle-startAngle;
		dBugle=tan(dAngle/4);
		if(pGArc.isClockWise()) dBugle = -dBugle;
	}

	//AcDbArc *pArc=new AcDbArc(cpt,pGArc.radius(),pGArc.startAng(),pGArc.endAng());
	//acutPrintf("center %.8f %.8f radius %.8f endAng %.8f \n",cpt.x,cpt.y,pArc->radius(),pArc->endAngle());
	AcDbPolyline *pline=new AcDbPolyline(2);
	pline->addVertexAt(0,asPnt2d(pt1),dBugle);
	pline->addVertexAt(1,asPnt2d(pt3));

	AcDbObjectId objId,objId2;
	acdbOpenObject(pline, objId, AcDb::kForRead);
	postToDatabase(pline,objId2);
	pline->close();
}
/*circle x=r*cos(ang);y=r*sin(ang) 
 ellipse x=a*cos(ang);y=b*sin(ang)
 y=a*x*x+b*x+c 
 */
void drawPCircle()
{
	double x,y;
	double a=-0.001,b=-0.02,c=-3;
	for (int t=0;t<720;t++){
		x=t;
		y=a*x*x+b*x+c;
		drawPoint(AcGePoint3d(x,y,0));
	}
}

int n=1, k=2, n1, nt, Tmin,Tmax, w,h,h1,w2;
CArray <double> Px,Py, ti;
CArray <double> N;
int iRow;
//Color col[];
AcGePoint2dArray pts;
CArray <double> knots;

void drawSplineJ()
{
	int X,Y;
	for (int i = 0; i < n1; i++){
		X = (int)Px[i];
		Y = h1-(int)Py[i];
		//buffGraphics.drawRect(X-1,Y-1, 3,3);
		drawPoint(AcGePoint3d(X-1,Y-1,0));
	}
	if ( k > 2 ){
		int Xo = (int)Px[0],Yo = h1-(int)Py[0];
		for (int i = 1; i < n1; i++){
			X = (int)Px[i];
			Y = h1-(int)Py[i];
			//buffGraphics.drawLine(Xo,Yo, X,Y);
			drawLine(AcGePoint2d(Xo,Yo),AcGePoint2d(X,Y));
			Xo = X;  Yo = Y;}
	}
	double sX = 0, sY = 0;
	for (int j = 0; j < n1; j++){
		sX += Px[j]*N[j*iRow+Tmin];
		sY += Py[j]*N[j*iRow+Tmin];
	}
	int Xold = (int)sX, Yold = h1-(int)sY;
	for (int k = Tmin+1; k <= Tmax; k++){
		sX = 0;  sY = 0;
		for (int j = 0; j < n1; j++){
			sX += Px[j]*N[j*iRow+k];
			sY += Py[j]*N[j*iRow+k];
		}
		X = (int)sX;
		Y = h1-(int)sY;
		//buffGraphics.setColor(col[k]);
		if ( (X < w2) && (Xold < w2) ) {
			//buffGraphics.drawLine(Xold,Yold, X,Y );
			drawLine(AcGePoint2d(Xold,Yold),AcGePoint2d(X,Y));
		}
		Xold = X; Yold = Y;
	}
}
void drawFun()
{
	double step = (ti[nt-1]-ti[0])/(w2-.9);
	double t = ti[0];
	//Color[] iColor = {Color.red, new Color(0f,.7f,0f), Color.blue, Color.magenta,
	// new Color(0f,.8f,.8f), new Color(.9f,.9f,0f), Color.gray };
	//buffGraphics.clearRect(0,0, w, h);
	Tmin = (int)((ti[k-1]-ti[0])/step) + 1;
	Tmax = (int)((ti[n1]-ti[0])/step);
	int i1 = 0;
	for (int l = 0; l < w2; l++){
		while (t >= ti[i1] ) i1++;
		int i = i1-1;
		//col[l] = iColor[(i+8-k) % 7];
		for (int j = 0; j < nt; j++)
			N[j*iRow+l] = 0;
		N[i*iRow+l] = 1;

		for (int m = 2; m <= k; m++){        //  basis functions calculation
			int jb = i-m+1;  if (jb < 0) jb = 0;
			for (int j = jb; j <= i; j++){
				N[j*iRow+l] = N[j*iRow+l]*(t - ti[j])/(ti[j+m-1] - ti[j]) +
					N[(j+1)*iRow+l]*(ti[j+m] - t)/(ti[j+m] - ti[j+1]);
			}
		}
		t += step;
	}
	for (int j = 0; j < n1; j++){
		//buffGraphics.setColor(iColor[j % 7]);
		t = ti[0];
		double to = t;
		for (int l = 1; l < w2; l++){
			t += step;
			double t1 = t;
			//buffGraphics.drawLine(to, h1-(int)(h1*N[j][l-1]),t1, h1-(int)(h1*N[j][l]) );
			double t_x1=to,t_y1=h1-(h1*N[j*iRow+l-1]);
			double t_x2=t1,t_y2=h1-(h1*N[j*iRow+l]);
			drawLine(AcGePoint2d(t_x1,t_y1),AcGePoint2d(t_x2,t_y2));
			to = t1;
		}
	}
	for (int l = k; l <= n1; l++){
		//buffGraphics.setColor(iColor[(l-k) % 7]);
		//buffGraphics.drawLine((int)ti[l-1], 1, (int)ti[l], 1);
		int t_x1=ti[l-1],t_y1=1;
		int t_x2=(int)ti[l],t_y2=1;
		drawLine(AcGePoint2d(t_x1,t_y1),AcGePoint2d(t_x2,t_y2));
	}
	//buffGraphics.setColor(Color.black);
	for (int l = 0; l < nt; l++){
		//buffGraphics.drawRect((int)ti[l]-1, 0, 3,3);
	}
}

int BSPline()
{
	int w=600,h=200;
	int n=3,k=3;
    int n1 = n+1;
	int nt = n+k+1;
	//double Px[]={};
	double *Py = new double[n1];
	double *ti = new double[nt+k];
	//double *N = new double[nt+1][w2];
	return 0;
}
int dispParam()
{	
	ads_name ss, ss1;
	//选择
#ifdef SINGLE_SELECT // 单选 
	if ( acedEntSel ("\nSelect an entity: ", ss, pt) != RTNORM )
	{
		acutPrintf ("\nYou not selected entity ");
		return BAD;
	}
#else //多选
	int rs;
	char sLayer[512];
	struct resbuf *XreDa;
	//XreDa=acutBuildList(RTDXF0,"ELLIPSE",0);
	XreDa=acutBuildList(AcDb::kDxfUndo,_T("<and"),
		RTDXF0,_T("ELLIPSE"),
		AcDb::kDxfLayerName,"e2p",//显示的对象
		AcDb::kDxfUndo,_T("and>"),0);
	if (acedSSGet(NULL,NULL,NULL,NULL,ss)!=RTNORM) {
		acutPrintf("acedSSGet failed!\n");
		return BAD;
	}
	acutRelRb(XreDa);
#endif
	AcDbObjectId eId;
	//处理
	long length;
	if (acedSSLength(ss, &length) != RTNORM) 
		return BAD; 
	acutPrintf("select cnt:%d \n",length);

	AcDbEntity * pEnt;
	AcDb::OpenMode openMode=kForRead; //kForRead; kForWrite;
	for (int i=0;i<length;i++){
		if (acedSSName(ss, i, ss1) != RTNORM) break;
		acdbGetObjectId(eId, ss1);
		acdbOpenObject(pEnt, eId, openMode);
		acutPrintf ("entity: %s\n", pEnt->isA()->name());
		double dParamSt,dParamEnd,dLenSt,dLenEnd,dStep,dParamTmp;
		AcGePoint3d ptSt,ptTmp;
		AcDbCurve* pDbCurve;
		AcGeCurve3d *pGeCurve;
		AcDbPolyline *pRetPoly;
		if(pEnt->isKindOf(AcDbPolyline::desc())) {
			AcDbPolyline *pPline=(AcDbPolyline *)pEnt;
			pPline->getStartParam(dParamSt);
			pPline->getEndParam(dParamEnd);
			pPline->getStartPoint(ptSt);
			pPline->getDistAtParam(dParamSt,dLenSt);
			pPline->getDistAtParam(dParamEnd,dLenEnd);
			dStep=(dLenEnd-dLenSt)/50;
			pPline->getPointAtDist(dLenSt+dStep,ptTmp);
			pPline->getParamAtPoint(ptTmp,dParamTmp);
			myprintf("param: %.4f %.4f pt: %.4f %.4f ptTmp: %.4f %.4f paramTmp: %.4f ",
				dParamSt,dParamEnd,ptSt.x,ptSt.y,ptTmp.x,ptTmp.y,dParamTmp);
		}else if (pEnt->isKindOf(AcDbLine::desc())) {
			AcDbLine *pLine=(AcDbLine *)pEnt;
			myprintf("AcDbLine:normal %.8f %.8f %.8f thickness: %.8f \n",
				pLine->normal().x,pLine->normal().y,pLine->normal().z, pLine->thickness());
			AcGeLineSeg3d *pGLine=new AcGeLineSeg3d(pLine->startPoint(), pLine->endPoint());
			AcGeVector3d pVec=pGLine->direction();
			myprintf("dir: %.8f %.8f\n",pVec.x,pVec.y);
			pLine->getStartPoint(ptTmp);
			myprintf("start: %.8f %.8f\n",ptTmp.x,ptTmp.y);
			pLine->getEndPoint(ptTmp);
			myprintf("start: %.8f %.8f\n",ptTmp.x,ptTmp.y);
			delete pGLine;
		}else if (pEnt->isKindOf(AcDbSpline::desc())) {
			AcDbSpline *pSpl=(AcDbSpline*) pEnt;
			AcGePoint3d pt;
			int degree;
			Adesk::Boolean rational;
			Adesk::Boolean closed;
			Adesk::Boolean periodic;
			AcGePoint3dArray controlPoints;
			AcGeDoubleArray aknots;
			AcGeDoubleArray weights;
			double controlPtTol;
			double knotTol;

			pSpl->getNurbsData(degree,rational,closed,periodic,controlPoints,aknots,weights,controlPtTol,knotTol);
			myprintf("degree %d rational %d closed %d periodic %d controlPtTol %.8f knotTol %.8f!\n",degree,rational,closed,periodic,controlPtTol,knotTol);
			myprintf("controlPoints %d\n",controlPoints.length());
			pts.setLogicalLength(0);
			for(int i=0;i<controlPoints.length();i++){
				pts.append(AcGePoint2d(controlPoints[i].x,controlPoints[i].y));
				myprintf("%f %f \n", controlPoints[i].x,controlPoints[i].y);

			}
			knots.RemoveAll();
			myprintf("knots %d\n",aknots.length());
			for(int i=0;i<aknots.length();i++){
				knots.Add(aknots[i]);
				myprintf("%f \n", aknots[i]);
			}
			myprintf("weights %d\n",weights.length());
			for(int i=0;i<weights.length();i++){
				myprintf("%f \n", weights[i]);
			}

		}
		pEnt->close();
	}
	acedSSFree(ss);
	mysynclog();
	return GOOD;
}

//p:控制点坐标
//n 控制点数
//k 递推次数
int B_Spline(AcGePoint2dArray ptArr,int n,int k) //POINT p[]
{
	int i=0,j;
	double a0,a1,a2,b0,b1,b2;
	double dt,t1,t2;
	int t_x,t_y;

	dt=1.0/k;
	drawPoint(AcGePoint3d((ptArr[0].x+ptArr[1].x)/2,(ptArr[0].y+ptArr[1].y)/2,0));
	for(i=1;i<n-1;i++)
	{
		for(j=1;j<=k;j++)
		{
			t1=j*dt;
			t2=t1*t1;

			a0=(t2-2*t1+1)/2.0;
			a1=(2*t1-2*t2+1)/2.0;
			a2=t2/2.0;

			t_x=int(a0*ptArr[i-1].x+a1*ptArr[i].x+a2*ptArr[i+1].x);
			t_y=int(a0*ptArr[i-1].y+a1*ptArr[i].y+a2*ptArr[i+1].y);
			drawPoint(AcGePoint3d(t_x,t_y,0));
		}
	}
	return 0;
}

int B_Spline3(AcGePoint2dArray ptArr,int n,int k) //POINT p[]
{
	int i=0,j;
	double a0,a1,a2,b0,b1,b2;
	double dt,t1,t2;
	int t_x,t_y;
	double x,y;
	double temp0X,temp1X,temp2X;   
	double temp0Y,temp1Y,temp2Y;   
	double Step=0.01;
	double t;

	dt=1.0/k;
	drawPoint(AcGePoint3d((ptArr[0].x+ptArr[1].x)/2,(ptArr[0].y+ptArr[1].y)/2,0));
	for(i=1;i<n-1;i++)
	{
		temp0X=ptArr[i-1].x;
		temp1X=ptArr[i].x;
		temp2X=ptArr[i+1].x;
		temp0Y=ptArr[i-1].y;
		temp1Y=ptArr[i].y;
		temp2Y=ptArr[i+1].y;

		a0=(temp0X+temp1X)/2.0;
		a1=temp1X-temp0X;
		a2=(temp0X-2*temp1X+temp2X)/2.0;
		b0=(temp0Y+temp1Y)/2.0;
		b1=temp1Y-temp0Y;
		b2=(temp0Y-2*temp1Y+temp2Y)/2.0;

		for(double j=0;j<=k;j+=Step)
		{
			t=j*dt;  
			x=a0+a1*t+a2*t*t;   
			y=b0+b1*t+b2*t*t;
			drawPoint(AcGePoint3d(x,y,0));
		}
	}
	return 0;
}
int tstParam(){
	AcGePoint2dArray ptArr;
	int n,k;
	ptArr.append(AcGePoint2d(0,0));
	ptArr.append(AcGePoint2d(120,60));
	ptArr.append(AcGePoint2d(300,-60));
	ptArr.append(AcGePoint2d(280,-60));
	n=4;
	k=20;
	drawLine(ptArr[0],ptArr[1]);
	drawLine(ptArr[1],ptArr[2]);
	drawLine(ptArr[2],ptArr[3]);
	B_Spline3(ptArr,n,k);
	return 0;
}

void mydispent(ads_name en)
{
	struct resbuf *pArgs =acedGetArgs(),*ed,*cb,*cd;
	int a=0;
	ed = acdbEntGet(en);
	for(cb=ed;cb!=NULL;cb=cb->rbnext)
	{
		myprintf("type:%d\n",cb->restype);
	}
}
int astartest()
{
	Acad::ErrorStatus es;
	//测试交点
	ads_name ss, ss1;
	AcDb::OpenMode openMode=kForRead; //kForRead; kForWrite;
#ifdef SINGLE_SELECT // 单选 
	if ( acedEntSel ("\nSelect an entity: ", ss, pt) != RTNORM )
	{
		acutPrintf ("\nYou not selected entity ");
		return ;
	}
#else //多选
	int rs;
	char sLayer[512];
	struct resbuf *XLine,*XEllipse;
	long length;
	AcDbObjectId ObjID1,ObjID2;
	struct resbuf * xResBuf;

	xResBuf=acutBuildList(RTDXF0,"LWPOLYLINE",0);
	if (acedSSGet("X",NULL,NULL,xResBuf,ss)!=RTNORM) {
		acutPrintf("acedSSGet failed!\n");
		return BAD;
	}
	if (acedSSLength(ss, &length) != RTNORM) 
		return BAD;
#endif
	acutPrintf("select cnt:%d \n",length);
	//取交点
	AcDbEntity *pEnt;
	double dParam1,dParam2,dParamTmp;
	AcGePoint3dArray PTlist;
	AcDbVertex* vertex;
	for (int i=0;i<length;i++){
		if (acedSSName(ss, i, ss1) != RTNORM) 
			break;
		acdbGetObjectId(ObjID2, ss1);
		acdbOpenObject(pEnt, ObjID2, AcDb::kForWrite);
		acutPrintf ("entity: %s\n", pEnt->isA()->name());

		if ((vertex = AcDbVertex::cast(pEnt)) != NULL)
        //display(vertex);
		acutPrintf("vertex:type %x ;\n ",vertex->getAcDbHandle);
		pEnt->close();
	}
	mysynclog();
	acedSSFree(ss);
	return GOOD;
}
void get2ObjIDIntresPoints(AcDbObjectId ObjID1,AcDbObjectId ObjID2, AcGePoint3dArray &PTlist){
	PTlist.setLogicalLength(0);
	AcDbEntity *pEnt1,*pEnt2;
	acdbOpenObject(pEnt1,ObjID1,AcDb::kForRead);
	acdbOpenObject(pEnt2,ObjID2,AcDb::kForRead);
	pEnt1->intersectWith(pEnt2,AcDb::kExtendBoth,PTlist);
	pEnt1->close();
	pEnt2->close();
}

/* 裁剪ellipse和line
*/
int starTrim(){
	Acad::ErrorStatus es;
	//测试交点
	ads_name ss, ss1;
	AcDb::OpenMode openMode=kForRead; //kForRead; kForWrite;
#ifdef SINGLE_SELECT // 单选 
	if ( acedEntSel ("\nSelect an entity: ", ss, pt) != RTNORM )
	{
		acutPrintf ("\nYou not selected entity ");
		return ;
	}
#else //多选
	int rs;
	char sLayer[512];
	struct resbuf *XLine,*XEllipse;
	long length;

	XLine=acutBuildList(RTDXF0,"LINE",0);
	if (acedSSGet("X",NULL,NULL,XLine,ss)!=RTNORM) {
		acutPrintf("acedSSGet failed!\n");
		return BAD;
	}
	if (acedSSLength(ss, &length) != RTNORM) 
		return BAD;

	AcDbObjectId ObjIDLine;
	if (acedSSName(ss, 0, ss1) != RTNORM) {
		return BAD;
	}
	acdbGetObjectId(ObjIDLine, ss1);
	acedSSFree(ss);

	XEllipse=acutBuildList(RTDXF0,"ELLIPSE",0);
	if (acedSSGet("X",NULL,NULL,XEllipse,ss)!=RTNORM) {
		acutPrintf("acedSSGet failed!\n");
		return BAD;
	}
	if (acedSSLength(ss, &length) != RTNORM) 
		return BAD;
#endif
	acutPrintf("select cnt:%d \n",length);
	//取交点
	AcDbEntity *pEnt;
	double dParam1,dParam2,dParamTmp;
	AcGePoint3dArray PTlist;
	AcDbObjectId objId;
	int iLen;
	for (int i=0;i<length;i++){		
		if (acedSSName(ss, i, ss1) != RTNORM) 
			break;
		acdbGetObjectId(objId, ss1);
		get2ObjIDIntresPoints(objId,ObjIDLine,PTlist);
		if(PTlist.length()<2) {continue;}
		//drawPoint(PTlist.at(0));drawPoint(PTlist.at(1));
		//acutPrintf("pt1,pt2:%.4f %.4f %.4f %.4f\n",PTlist.at(0).x,PTlist.at(0).y,PTlist.at(1).x,PTlist.at(1).y);
		if(acdbOpenObject(pEnt, objId, AcDb::kForWrite)!=Acad::eOk){
			acutPrintf ("acdbOpenObject failed!\n");
			break;
		}
		acutPrintf ("entity: %s\n", pEnt->isA()->name());
		if (!pEnt->isKindOf(AcDbEllipse::desc()))
		{
			pEnt->close();
			continue;
		}
		/* */
		AcDbEllipse *pEllipse=(AcDbEllipse *)pEnt;
		pEllipse->getParamAtPoint(PTlist.at(0),dParam1);
		pEllipse->getParamAtPoint(PTlist.at(1),dParam2);
		acutPrintf("param pt1,pt2:%.4f %.4f\n",dParam1,dParam2);
		if(dParam1>dParam2) {dParamTmp= dParam1;dParam1=dParam2;dParam2=dParamTmp;}
		pEllipse->setStartParam(dParam1);
		pEllipse->setEndParam(dParam2);
		pEnt->close();
	}
	mysynclog();
	acedSSFree(ss);
	return GOOD;
}
int starTestArc()
{
	drawArc();
	return GOOD;
}
int testTextExt()
{

	acedCommand(RTSTR, "layer",RTSTR,"s",RTSTR,"0",RTSTR,"",0);
    ads_name tname;
    struct resbuf *textent, *tent;
    ads_point origin, lowleft, upright, p1, p2, p3, p4;
    ads_real rotatn;
    char rotatstr[15];
    if (acedEntSel("\nSelect text: ", tname, p1) != RTNORM)
    {
        acdbFail("No Text entity selected\n");
        return BAD;
    }
    textent = acdbEntGet(tname);
    if (textent == NULL)
    {
        acdbFail("Couldn't retrieve Text entity\n");
        return BAD;
    }
    tent = entitem(textent,10);
	if(tent!=NULL){
		origin[X] = tent->resval.rpoint[X];
		//ECS coordinates
		origin[Y] = tent->resval.rpoint[Y];
	}
    tent = entitem(textent, 50);
	if(tent!=NULL){
		rotatn = tent->resval.rreal;
	}
    // acdbAngToS() converts from radians to degrees.
    if (acdbAngToS(rotatn, 0, 8, rotatstr) != RTNORM)
    {
        acdbFail("Couldn't retrieve or convert angle\n");
        acutRelRb(textent);
        return BAD;
    }
    if (acedTextBox(textent, lowleft, upright) != RTNORM)
    {
        acdbFail("Couldn't retrieve text box coordinates\n");
        acutRelRb(textent);
        return BAD;
    }
    acutRelRb(textent);
    // If not currently in the WCS, at this point add
    // acedTrans() calls to convert the coordinates
    // retrieved from acedTextBox().
	//myprintf("box:%.4f,%.4f %.4f,%.4f\n",lowleft[X],lowleft[Y],upright[X],upright[Y]);
	//myprintf("org: %.4f,%.4f %.5f\n",origin[X],origin[Y],rotatn);
	p1[X] = origin[X] + lowleft[X];
    // UCS coordinates
    p1[Y] = origin[Y] + lowleft[Y];
    p2[X] = origin[X] + upright[X];
    p2[Y] = origin[Y] + lowleft[Y];
    p3[X] = origin[X] + upright[X];
    p3[Y] = origin[Y] + upright[Y];
    p4[X] = origin[X] + lowleft[X];
    p4[Y] = origin[Y] + upright[Y];

	AcGePoint2dArray ptExtArr;
	ptExtArr.append(AcGePoint2d(origin[X] + lowleft[X], origin[Y] + lowleft[Y]));
	ptExtArr.append(AcGePoint2d(origin[X] + upright[X], origin[Y] + lowleft[Y]));
	ptExtArr.append(AcGePoint2d(origin[X] + upright[X], origin[Y] + upright[Y]));
	ptExtArr.append(AcGePoint2d(origin[X] + lowleft[X], origin[Y] + upright[Y]));
	ptExtArr[0].rotateBy(rotatn,asPnt2d(origin));	
	ptExtArr[1].rotateBy(rotatn,asPnt2d(origin));
	ptExtArr[2].rotateBy(rotatn,asPnt2d(origin));	
	ptExtArr[3].rotateBy(rotatn,asPnt2d(origin));
	ads_point ptleftdown,ptrightup;
	ptleftdown[0]=findMin(4,ptExtArr[0].x,ptExtArr[1].x,ptExtArr[2].x,ptExtArr[3].x);
	ptleftdown[1]=findMin(4,ptExtArr[0].y,ptExtArr[1].y,ptExtArr[2].y,ptExtArr[3].y);
	ptrightup[0]=findMax(4,ptExtArr[0].x,ptExtArr[1].x,ptExtArr[2].x,ptExtArr[3].x);
	ptrightup[1]=findMax(4,ptExtArr[0].y,ptExtArr[1].y,ptExtArr[2].y,ptExtArr[3].y);
	myprintf("pt.x: %.4f,%.4f %.4f,%.4f \n",ptExtArr[0].x,ptExtArr[1].x,ptExtArr[2].x,ptExtArr[3].x);
	myprintf("pt.y: %.4f,%.4f %.4f,%.4f \n",ptExtArr[0].y,ptExtArr[1].y,ptExtArr[2].y,ptExtArr[3].y);
	myprintf("pt: %.4f,%.4f %.4f,%.4f \n",ptleftdown[0],ptleftdown[1],ptrightup[0],ptrightup[1]);
	//acedCommand(RTSTR,"zoom",RTSTR,"w",RTPOINT,ptleftdown,RTPOINT,ptrightup,0);
	/*double dDist;
	dDist=acutDistance(origin,p1);
	acutPolar(origin,rotatn,dDist,p1);
	dDist=acutDistance(origin,p2);
	acutPolar(origin,rotatn,dDist,p2);
	myprintf("p2: %.4f,%.4f %.5f\n",p2[X],p2[Y],dDist);
	dDist=acutDistance(origin,p3);
	acutPolar(origin,rotatn,dDist,p3);
	myprintf("p3: %.4f,%.4f %.5f\n",p3[X],p3[Y],dDist);
	dDist=acutDistance(origin,p4);
	acutPolar(origin,rotatn,dDist,p4);*/
	if (acedCommand(RTSTR, "pline", RTPOINT, asDblArray(ptExtArr[0]),RTPOINT, asDblArray(ptExtArr[1]), RTPOINT, asDblArray(ptExtArr[2]),RTPOINT, asDblArray(ptExtArr[3]), RTSTR, "c", 0) != RTNORM)
    {
        acdbFail("Problem creating polyline\n");
        return BAD;
    }
    /*if (acedCommand(RTSTR, "rotate", RTSTR, "L", RTSTR, "",         RTPOINT, origin, RTSTR, rotatstr, 0) != RTNORM)
    {
        acdbFail("Problem rotating polyline\n");
        return BAD;
    }*/
	int iSel;
	CString sLayer;
	struct resbuf *callist, *pRb, *results = NULL;
	callist = acutBuildList(RTSTR, "C:tmpGetSel", 0);
	if(callist!=NULL){
		if (acedInvoke(callist, &results) == RTERROR)
			acdbFail("Cannot run -- texta.lsp is loaded?\n"); 
		else{
			if (results != NULL) {
				pRb=results;
				if(pRb->restype==RTSHORT){
					iSel=pRb->resval.rint;
					if(pRb->rbnext!=NULL){
						sLayer=pRb->rbnext->resval.rstring;
					}
				}
				acutRelRb(results);
				acutPrintf("\nSuccess: %d %s \n", iSel,sLayer);
			}
		}
	}
	acutRelRb(callist);

	mysynclog();
    return GOOD;
}
ads_point m_lul,m_vc;
int getLUL(void)
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
	vh[0]=m_vc[0]+vi*.05;
	vh[1]=m_vc[1]+lvs*0.5;
	m_lul[0]=vw[0];
	m_lul[1]=vh[1];
	myprintf("lul:%.4f,%.4f\n",m_lul[0],m_lul[1]);
	return 0;
}

int drawText()
{
	//测试代码，draw text
	ads_point pt1,pt2,m_ptTextLeft,m_ptTextRight;
	ads_name last;
	//设置pt1在左,pt2在右
	pt2[X] = 0.0;
	pt2[Y] = 0.0;
	pt2[Z] = 0.0;
	//pt1[X] = 15.0; 
	//pt1[Y] = 20.0;	//不输出cmd信息
	struct resbuf rbVar;
	getLUL();
	rbVar.restype=RTSHORT;
	rbVar.resval.rint=0;
	if ( RTNORM != acedSetVar("cmdecho", &rbVar))
	{
		acutPrintf("setvar cmdecho 0 fail!");// return 1;
	}
	for(int i=0;i<123;i++){
		CString str;
		str.Format("%d",i);
		acedCommand(RTSTR, "text", RTPOINT, pt2, RTSTR, "2.5", RTSTR, str, RTSTR, "testabcdef中",RTSTR,"\n",RTNONE);
		ads_name last;
		if(acdbEntLast(last)!=RTNORM){
			acutPrintf("entlast failed1!\n");
			return 1;
		}
		{
			AcDbObjectId eId;
			AcDbEntity * pEntSS1;
			if( acdbGetObjectId(eId, last) != Acad::eOk)
			{
				acutPrintf("open object fail!\n");
				return 0;
			}
			if( acdbOpenObject(pEntSS1, eId, kForRead) != Acad::eOk) //kForRead; kForWrite;
			{
				acutPrintf("open object fail!\n");
				return 0;
			}
			AcDbExtents ext;
			pEntSS1->getGeomExtents(ext);
			myprintf("%.4f,%.4f %.4f,%.4f \n",ext.minPoint().x,ext.minPoint().y,ext.maxPoint().x,ext.maxPoint().y);
			m_ptTextLeft[0]=ext.minPoint().x-0.00001;
			m_ptTextLeft[1]=ext.minPoint().y-0.00001;
			m_ptTextRight[0]=ext.maxPoint().x+0.00001;
			m_ptTextRight[1]=ext.maxPoint().y+0.00001;
			acedCommand(RTSTR,"zoom",RTSTR,"w",RTPOINT,m_ptTextLeft,RTPOINT,m_ptTextRight,RTNONE);
			getLUL();
			pEntSS1->close();
		}
		//ads_name last;
		if(acdbEntLast(last)!=RTNORM){
			acutPrintf("entlast failed2!\n");
			return 1;
		}
		//int retCmd=acedCommand(RTSTR,"wmfout",RTSTR,"c:\\temptext",RTENAME,last,RTSTR,"",
		//	RTSTR,"erase",RTENAME,last,RTSTR,"",
		//	RTSTR,"wmfin",RTSTR,"c:\\temptext", RTPOINT,m_lul, RTSTR,"2", RTSTR,"", RTSTR,"", RTNONE); /* */
		//myprintf("wmfout: %d\n",retCmd);
		pt2[Y]+=2.8;
	}
	rbVar.restype=RTSHORT;
	rbVar.resval.rint=1;
	if ( RTNORM != acedSetVar("cmdecho", &rbVar))
	{
		acutPrintf("setvar cmdecho 1 fail!");// return 1;
	}
	return 0;
}

int drawDText(AcGePoint3d ptloc,char *str,AcDbObjectId style,double textheight,double textangle)
{
	AcDbText *pEnt=new AcDbText(ptloc,str,style,textheight,textangle);
	AcDbObjectId custOID;
	postToDatabase(pEnt,custOID);
	pEnt->close();
	return 0;
}

int starMText2DText()
{
	ads_name en ;
	ads_point pt ;
	if ( acedEntSel ("\nSelect an entity: ", en, pt) != RTNORM )
	{
		acutPrintf ("\nYou not selected entity ");
		return 1;
	}
	AcDbObjectId eId;
	acdbGetObjectId(eId, en);
	AcDbEntity * pEnt;
	acdbOpenObject(pEnt, eId, AcDb::kForWrite); //kForRead; kForWrite
	if(pEnt->isKindOf(AcDbText::desc()) )
	{
		AcDbText *pText = (AcDbText *)pEnt;
		ads_point ptloc;
		memcpy(&ptloc,asDblArray(pText->position()),sizeof(ptloc));
		myprintf("%.4f %.4f \n",ptloc[0],ptloc[1]);
		char *pValStr=pText->textString();
		unsigned char *pStr=(unsigned char *)pValStr;
		char buf[4]={0};
		double textwidthfactor=pText->widthFactor();
		double textheight=pText->height();
		double textangle=pText->rotation();
		while (*pStr){
			buf[0]=*pStr;
			if(*pStr < 0xA0){	//英文
				if(*pStr!=' '){
					drawDText(asPnt3d(ptloc),buf,pText->textStyle(),textheight*textwidthfactor,textangle);
				}
				acutPolar(ptloc,textangle,textheight*textwidthfactor,ptloc);
			}else if (*pStr> 0xA0){ //中文
				if(*pStr!=' '){
					pStr++;
					buf[1]=*pStr;
					drawDText(asPnt3d(ptloc),buf,pText->textStyle(),textheight*textwidthfactor,textangle);
					buf[1]='\0';
				}
				acutPolar(ptloc,textangle,textheight*textwidthfactor*1.1667,ptloc);
				//acutPolar(ptloc,textangle,textheight*textwidthfactor,ptloc);
			}
			else{
				acutPolar(ptloc,textangle,textheight*textwidthfactor,ptloc);
			}
			pStr++;
		}
		free(pValStr);
	}
	pEnt->close();
	mysynclog();
	return 0;
}
int starDisplay(){
	CAcModuleResourceOverride resOverride;
	CMyDialog* pmydlg=new CMyDialog(acedGetAcadFrame());
	int ret=pmydlg->DoModal();
	delete pmydlg;
	/*int ret;
	acedGetInt("1,el2pl,2,spl2pl,,,,",&ret);*/
	acutPrintf("ret %d \n",ret);
	switch(ret){
	case IDC_EL2PL:
		starEl2Pl();
		break;
	case IDC_SPL2PL:
		starSpl2Pl();
		break;
	//for test
	case IDC_MYSPL:
		//drawSpline();
		break;
	case IDC_ENTINFO:
		starDumpEnt();
		break;
	case IDC_TESTARC3P:
		testTextExt();
		break;
	case IDC_TSTPARAM:
		drawText();
		break;
	case IDC_TEXT2PL:
		starText2Pline();
		break;
	case IDC_MT2DT:
		starMText2DText();
		break;
	case IDC_WIDEN:
		starWidenArc();
		break;
	default:
		break;
	}
	return ret;
}