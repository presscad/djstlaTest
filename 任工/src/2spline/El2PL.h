#pragma once

#include "StdAfx.h"
#include "spldialog.h"
#include "EL2PLDialog.h"
#include "Text2PLDialog.h"
#include "TEXT2PLSEL.h"
#include "WidenDialog.h"
#include "WidenSelDialog.h"
#include "func.h"

#include "string"
#define GOOD 0
#define BAD 1
double myabs(double value);
int mypower(int value,int y);
double myaverage(double v1,double v2);
int myprintf(char *fmt, ...);
int mysynclog(void);
int setMylog(int value);

class CEL2PL
{
public:
	//CEL2PL(void);
	CEL2PL();
	~CEL2PL(void);
private:
	double m_pi;
	double m_twopi;
	double m_linewidth;
	double m_textheight;
	int m_textcnt;
	ads_point m_ptTextLeft,m_ptTextRight;
	ads_point m_lul;//vw.x vh.y
	ads_point m_vc;//vw.x vh.y
	int m_iSegNums;
	int m_bWiden;
	double m_dSegfactor;
	AcDbObjectId m_layerid;
	int MText2DText();
	bool isOnFrozenLayer(AcDbEntity* ent, bool printMsg);
	bool isOnLockedLayer(AcDbEntity* ent, bool printMsg);
	Acad::ErrorStatus visableAllLayer();
	int lineWiden(AcDbLine *pLine,double dWidth);
	int lineWiden(AcDbArc *pLine,double linewidth);
	int text2polyline(ads_name ss1);
	struct resbuf * entItem(struct resbuf *textent,short irestype);
	int polyWiden(ads_name ss1);
	AcDbPolyline*  ellipse2polyline(ads_name &en);
	AcDbPolyline*  spline2polyline(ads_name &en);
	Acad::ErrorStatus postToDatabase(AcDbEntity* ent , AcDbObjectId& objId);
	//int getArcBulge(ads_point pt1,ads_point pt2,ads_point pt3,double & dBugle);
	int getArcBulge(AcGePoint2d& pt1,AcGePoint2d& pt2,AcGePoint2d& pt3,double & dBugle);//曲线凸度
	int getLineAngle(AcGePoint2d& pt1,AcGePoint2d& pt2,double & dSlope);//直线斜率
	int isLine(AcGePoint2d& pt1,AcGePoint2d& pt2,AcGePoint2d& pt3);
	int getPlinePoints(AcDbEllipse * pEllipse, AcGePoint2dArray& ptArr);
	int getPlinePoints(AcDbSpline * pSpline, AcGePoint2dArray& ptArr);
	Acad::ErrorStatus Poly2dToLWPoly(AcDb2dPolyline *pPoly,AcDbPolyline *& pLwpoly);
public:
	int starEL2PL(void);
	int starSPL2PL(void);
	int starText2PL(int sel=0);
	int getLUL(void);
	int purgeBlockRef(void);
	double min4(double x1, double x2, double x3, double x4);
	double max4(double x1, double x2, double x3, double x4);
	int starPolyWiden(int sel=0);
};
