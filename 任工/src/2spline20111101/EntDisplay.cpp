#include "entdisplay.h"

CEntDisplay::CEntDisplay()
{
}

CEntDisplay::~CEntDisplay(void)
{
}

int CEntDisplay::starDisplay(void)
{
	int iSel;
	acedGetInt("1,lwpolyline 2,polyline 3, select\n",&iSel);
	ads_name ss, ss1;
	if(iSel==2){
		struct resbuf *XreDa;
		XreDa=acutBuildList(RTDXF0,"POLYLINE",0);
		if (acedSSGet("X",NULL,NULL,XreDa,ss)!=RTNORM) {
			acutPrintf("acedSSGet failed!\n");
			acutRelRb(XreDa);
			return BAD;
		}
		acutRelRb(XreDa);
	}
	else if(iSel==1){
		struct resbuf *XreDa;
		XreDa=acutBuildList(RTDXF0,"LWPOLYLINE",0);
		if (acedSSGet("X",NULL,NULL,XreDa,ss)!=RTNORM) {
			acutPrintf("acedSSGet failed!\n");
			acutRelRb(XreDa);
			return BAD;
		}
		acutRelRb(XreDa);
	}else{
		if (acedSSGet(NULL,NULL,NULL,NULL,ss)!=RTNORM) {
			acutPrintf("acedSSGet failed!\n");
			return BAD;
		}
	}
	if (acedSSName(ss, 0L, ss1) != RTNORM) 
		return BAD; 

	long length; 
	AcDbObject* pObj;

	if (acedSSLength(ss, &length) != RTNORM) 
		return BAD;	
	AcDbObjectId eId;
	for (int i=0;i<length;i++){
		//acedSetStatusBarProgressMeterPos(i);
		if (acedSSName(ss, i, ss1) != RTNORM) 
			break;
		myprintf("entity %d \n",i);
		assert( acdbGetObjectId(eId, ss1)==Acad::eOk);
		display(eId);
	}
	mysynclog();
	return GOOD;
}

int CEntDisplay::display(AcDbObjectId eId)
{

	AcDb::OpenMode openMode=kForRead; //kForRead;
	AcDbEntity * pEnt;
	if(acdbOpenAcDbEntity(pEnt, eId, openMode)!=Acad::eOk){
		acutPrintf("acdbOpenAcDbEntity bad!");
		return BAD;
	}
	//std::string str = ;
	acutPrintf("%s\n",pEnt->isA()->name());
	if (pEnt->isKindOf(AcDbEllipse::desc()))
	{
		display((AcDbEllipse *) pEnt);
	}else if (pEnt->isKindOf(AcDbPolyline::desc())) {
		display((AcDbPolyline*) pEnt);
	}else if (pEnt->isKindOf(AcDb3dPolyline::desc())) {
		display((AcDb3dPolyline*) pEnt);
	}
	pEnt->close();
	return GOOD;
}

int CEntDisplay::display(AcDbEllipse * pEllipse)
{
	Acad::ErrorStatus	  es;
	// ×ª»»
	double dParam1=0,dParam2=0;
	pEllipse->getStartParam(dParam1);
	pEllipse->getEndParam(dParam2);
	double dLen1 = 0;
	pEllipse->getDistAtParam(dParam1,dLen1);
	double dLen2 = 0;
	pEllipse->getDistAtParam(dParam2,dLen2);
	double dLength = dLen2 - dLen1;
	double dStep = min(10,dLength/100);
	AcGePoint3dArray ptArr;
	AcGePoint3d pt;
	pEllipse->getStartPoint(pt);

	AcGeVector3d firstDeriv(0,0,0),SecondDeriv;	

	es = pEllipse->getFirstDeriv(pt,firstDeriv);
	assert(es == Acad::eOk);
	acutPrintf("firstDeriv:%d, %.4f, %.4f, %.4f\n",firstDeriv.length,firstDeriv.x,firstDeriv.y,firstDeriv.z);
	acutPrintf("pt:%.4f, %.4f, %.4f\n",pt.x,pt.y,pt.z);
	es = pEllipse->getSecondDeriv(pt,SecondDeriv);
	assert(es == Acad::eOk);
	acutPrintf("SecondDeriv:%d, %.4f, %.4f, %.4f\n",SecondDeriv.length,SecondDeriv.x,SecondDeriv.y,SecondDeriv.z);
	return GOOD;
}

int CEntDisplay::display(AcDbPolyline * pline)
{
	CString str, str2;
	double dBulge;
    double tmpDouble;
    AcGePoint3d tmpPt;

	Acad::ErrorStatus	  es;
	myprintf("Is Only Lines %d\n",pline->isOnlyLines());
	myprintf("Is Closed %d\n",pline->isClosed());
	myprintf("Has Pline Gen %d\n",pline->hasPlinegen());
	myprintf("Elevation %d\n",pline->elevation());
	myprintf("Thickness %d\n",pline->thickness());
	myprintf("Normal %.4f %.4f\n",pline->normal().x,pline->normal().y);
	myprintf("Vertices %d\n",pline->numVerts());
	
	AcDbPolyline::SegType segType;
	double bulge;
	for (unsigned int i=0;i<pline->numVerts();i++){
		pline->getPointAt(i,tmpPt);
		myprintf("%.8f\t%.8f\t",tmpPt.x,tmpPt.y);	// col #1,2
		AcGeLineSeg3d line;
		es = pline->getLineSegAt(i, line);
		segType=pline->segType(i);
		myprintf("%d\n",segType);
		/* 
		if (segType == AcDbPolyline::kArc) {
            AcGeCircArc3d arc;
            es = pline->getArcSegAt(i, arc);
			myprintf("%.4f\t",arc.radius());	// col #3,4,5
			myprintf("%.4f\t",arc.startAng());
			myprintf("%.4f\t",arc.endAng());
			AcDbArc *pArc=new AcDbArc(arc.center(),arc.radius(),arc.startAng(),arc.endAng());
			AcGePoint3d ptEnd;
			pArc->getEndPoint(ptEnd);
			AcGeVector3d fdPt;
			pArc->getFirstDeriv(ptEnd,fdPt);
			delete pArc;
			myprintf("fd:%.4f\t%.4f\t",fdPt.x,fdPt.y);
		}else{
			myprintf("type:%d \t",segType);
		}
		pline->getBulgeAt(i, dBulge);
		myprintf("%.8f\n",dBulge);*/
	}
	return GOOD;
}

int CEntDisplay::display(AcDb3dPolyline * p3dPline)
{
	AcDbObjectIterator *vertexIter=p3dPline->vertexIterator();
	AcDbObjectId objId;
	AcDbEntity *pEnt;
	AcDb3dPolylineVertex *pVert;
	AcGePoint3d pt;
    while (vertexIter->done() == false) {
		objId=vertexIter->objectId();		
		Acad::ErrorStatus es = p3dPline->openVertex(pVert, objId, AcDb::kForRead);
		if (es == Acad::eOk) {
			pt=pVert->position();
			myprintf("%.8f\t%.8f\t%d\n",pt.x,pt.y,pVert->vertexType());
			pVert->close();
		}
        vertexIter->step();
    }
	delete vertexIter;
	return 0;
}
