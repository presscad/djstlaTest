#include "func.h"
#include "string"
#include "EL2PL.h"
#include "EntDisplay.h"
//#include "allcmddialog.h"
#include "mydialog.h"
#include "resource.h"
#include <queue>
#include <stack>

std::queue <char *> qlog;

CEL2PL *pEl2pl;
CEntDisplay *pEntDisplay;
double m_pi;
int m_islog=0;
char sprint_buf1[1024]={0};
double myabs(double value)
{
	double dRet;
	if(value<0) dRet=-value;
	else dRet=value;
	return dRet;
}
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
Acad::ErrorStatus convertGeCurveToPolyline(AcGeCurve2d* pCurve, AcDbPolyline*& pResultPoly)
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

int initStarmask()
{
	m_pi=atan(1.0) * 4.0;
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
	if(myabs(ptOnLine.x - pt2[0]) > 1 || myabs(ptOnLine.y - pt2[1]) >1)
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
void initSpline() {
	w = 640;
	h = 480;
	h1 = h-1;
	w2 = w/2;

	n = 1;  //k=2 线性 k=3 二次 k=4 三次
	k = 3;
	n1 = n+1;
	nt = n+k+1;
	//Px = new double[n1];  Py = new double[n1];  ti = new double[nt+k];
	Px.SetSize(n1);
	Py.SetSize(n1);
	ti.SetSize(nt+k);
	//col = new Color[w2];
	//N = new double[nt+1][w2];
	N.SetSize( (nt+1) * w2 );
	iRow=w2;

	for (int i = 0; i < n1; i++){
		Px[i] = pts[i].x;
		Py[i] = pts[i].y;
		drawPoint(AcGePoint3d(Px[i],Py[i],0));
	}
	//s=getParameter("knots");
	for (int i = 0; i < nt; i++){
		ti[i] = knots[i];
	}
	double to = ti[0], dt = ti[nt-1]-to;
	for (int i = 0; i < nt; i++) 
		ti[i] = w2 + w2*(ti[i]-to)/dt;
	//
	drawFun();
	drawSplineJ();
}
void drawSpline()
{
	/*
	// y=ax^2+bx+c 一次多项式, 这条直线的斜率是a
	double a=7,b=5,c=9;
	double x,y;
	for (int i=1;i<2000;i+=1){
		x=i;
		y=a*x*x+b*x+c;
		myprintf("%f,%f\n",x,y);
		drawPoint(AcGePoint3d(x,y,0));
	}
	mysynclog();
void drawSpline(){
	// y=ax+b 一次多项式, 这条直线的斜率是a
	double a=1,b=2;
	double x,y;
	for (int i=1;i<1000;i+=1){
		x=i;
		y=a*x+b;
		myprintf("%f,%f\n",x,y);
		drawPoint(AcGePoint3d(x,y,0));
	}*/
	mysynclog();// 
	AcDbObjectId custOID;
	AcGePoint3dArray ptArr;
	AcGePoint3d pt;
	AcDbPoint* pPnt;
	int numSegs=2;
	double dLen=2000;
	double dStep=500;

	setMylog(1);
	for(int i=0;i<250;i++){
		pt.x=0;pt.y=0;
		ptArr.setLogicalLength(0);
		for (int j=0;j<numSegs;j++){
			ptArr.append(pt);
			pt.x+=dStep;
			if(j % 2) pt.y -= dStep;
			else pt.y += dStep;
			//dStep+=dStep;
			myprintf("%f,%f\n",pt.x,pt.y);
		}
		AcDbSpline* pSpl;
		pSpl = new AcDbSpline(ptArr);
		postToDatabase(pSpl,custOID);
		pSpl->close();
		numSegs++;
		dStep=dLen/numSegs;
		myprintf("%d %.4f\n",numSegs,dStep);
		mysynclog();
	}
	setMylog(0);
}

void drawEllipse(AcDbEllipse * pEnt)
{
	AcGePoint3d center;
	AcGeVector3d unitNormal;
	AcGeVector3d majorAxis;
	double radiusRatio;
	double startAngle;
	double endAngle;
	((AcDbEllipse*)pEnt)->get(center,unitNormal,majorAxis,radiusRatio,startAngle,endAngle);
	acutPrintf("center,unitNormal,majorAxis,radiusRatio,startAngle,endAngle:\n");
	acutPrintf("%.3f,%.3f \n",center.x,center.y);
	acutPrintf("%.3f,%.3f \n",majorAxis.x,majorAxis.y);
	acutPrintf("%.3f \n",radiusRatio);
	pEnt->close();

	Acad::ErrorStatus es;
	es = acdbHostApplicationServices()->workingDatabase() ->setPlineEllipse(true);
	assert(es == Acad::eOk);

	acutPrintf(_T("\nTesting make of AcDbEllipse..."));

	AcDbEllipse* ellipse = new AcDbEllipse;
	es = ellipse->set(center, AcGeVector3d::kZAxis, majorAxis, radiusRatio);
	assert(es == Acad::eOk);

	AcDbObjectId newCurveId;
}
void polyline_test1(void)
{
	// Add your code for command ROYMyTest._test1 here
	ads_point pt;
	ads_name ename;
	AcDbObjectId EntID;
	AcDbEntity *pEnt=NULL;
	if (acedEntSel(_T("\nSelect a line or arc:"),ename,pt)!=RTNORM
		|| acdbGetObjectId(EntID,ename)!=Acad::eOk
		|| acdbOpenAcDbEntity(pEnt,EntID,AcDb::kForRead)!=Acad::eOk)
		return;
	if (!(pEnt->isKindOf(AcDbLine::desc()) || pEnt->isKindOf(AcDbArc::desc())))
	{
		pEnt->close();
		return;
	}
	AcDbLine *pLine;
	AcDbArc *pArc;
	AcGePoint3d ptStart,ptEnd;
	double dBugle,startAngle,endAngle,dAngle;
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
	if (pEnt->upgradeOpen()!=Acad::eOk)
	{
		pEnt->close();
		return;
	}
	pEnt->erase();
	pEnt->close();

	AcDbPolyline *pPLine;
	pPLine=new AcDbPolyline(2);
	pPLine->addVertexAt(0,asPnt2d(asDblArray(ptStart)),dBugle);
	pPLine->addVertexAt(1,asPnt2d(asDblArray(ptEnd)));
	AcDbObjectId custOID;
	postToDatabase((AcDbEntity*)pPLine,custOID);
	pPLine->close();
}

/*
void drawPtEllipse(){
	double radiusX=50;
	double radiusY=25;
	int iCnt=360;//椭圆点数
	AcGePoint3d pt;
	AcGePoint3dArray ptArr;
	double step=0.0;
	for (int i=0;i<iCnt;i++){
		pt.x=radiusX * cos(( m_pi *step/180));
		pt.y=radiusY * sin(( m_pi *step/180));
		step+=1;
		ptArr.append(pt);
	}
	AcDbObjectId custOID;
	for (int i = 0; i < ptArr.length(); i ++)
	{
		AcDbPoint* pEnt = new AcDbPoint();
		pEnt->setPosition(ptArr.at(i));
		postToDatabase(pEnt,custOID);
		pEnt->close();
	}
	//;;;p(u)=(Cx+a*cos(u))*i+(Cy+b*sin(u))*j
}*/

LPCTSTR vectorToStr(const AcGeVector3d& vec, CString& str)
{
	str.Format(_T("(%.4f, %.4f, %.4f)"), vec.x,vec.y,vec.z);
    return str;
}

int docmd() 
{ 
	ads_point p1; 
	ads_real rad; 

	if (acedCommand(RTSTR, "circle", RTSTR, "0,0", RTSTR, 
		"3,3", 0) != RTNORM) 
		return BAD; 

	p1[X] = 1.0; p1[Y] = 1.0; p1[Z] = 0.0; 
	rad = 4.5; 

	if (acedCommand(RTSTR, "circle", RT3DPOINT, p1, RTREAL, 
		rad, 0) != RTNORM) 
		return BAD; 

	ads_point p2;
	ads_point p3;
	p2[X] = 2.0; p2[Y] = 2.0; p2[Z] = 0.0; 
	p3[X] = 3.0; p3[Y] = 1.0; p3[Z] = 0.0; 

	if (acedCommand(RTSTR, "arc", RT3DPOINT, p1, RT3DPOINT, 
		p2, RT3DPOINT, p3, 0) != RTNORM) 
		return BAD; 

	return GOOD; 
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
		acdbOpenObject(pEnt, objId, AcDb::kForWrite);
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
int starPolyWiden()
{
	pEl2pl->starPolyWiden();
	return 0;
}

int starDelWmfBlk()
{
	pEl2pl->purgeBlockRef();
	return 0;
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
	myprintf("box:%.4f,%.4f %.4f,%.4f\n",lowleft[X],lowleft[Y],upright[X],upright[Y]);
	myprintf("org: %.4f,%.4f %.5f\n",origin[X],origin[Y],rotatn);
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
					sLayer=pRb->rbnext->resval.rstring;
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
		drawSpline();
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
		starPolyWiden();
		break;
	default:
		break;
	}
	return ret;
}
