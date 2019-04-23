#pragma once

#include "StdAfx.h"
#include "spldialog.h"
#include "EL2PLDialog.h"
#include "Text2PLDialog.h"
#include "TEXT2PLSEL.h"
#include "WidenDialog.h"
#include "WidenSelDialog.h"
#include "string"
#include "func.h"
#define GOOD 0
#define BAD 1
enum FunID
{
	fEL2PL=0,
	fSPL2PL=1,
	fT2LA=2,
	fT2LB=3,
	fT2LC=4
};
class CEL2PL;
typedef int (CEL2PL::*PTRFUN) (ads_name& ss1);
int doEntitySet(ads_name &ss, PTRFUN pFun);

class CEL2PL
{
public:
	//CEL2PL(void);
	CEL2PL();
	~CEL2PL(void);
private:
	// double m_pi;double m_twopi;
	//for widen
	int m_iWidthHeight;
	double m_linewidth;
	double m_textheight;
	int m_textcnt;	//text个数,已不用
	int m_bWidenTwoEnd;//只圆两头
	int m_bWidenFillet;	//圆角
	int m_bErase; //可以删除了

	//textbox文本放缩窗口
	ads_point m_ptTextLeft,m_ptTextRight;
	//wmfout,wmfin使用坐标
	ads_point m_lul;//vw.x vh.y
	ads_point m_vc;//viewctl, vw.x vh.y
	CString m_tmpfile;//wmfout临时文件名
	//标志
	int m_iFunID;
	int m_bWiden;//是否widen
	int m_bMerge;//是否merge
	//spline2polyline
	double m_dSegfactor;//spline2pline精度
	int m_iSegNums;		//指定段数
	//恢复图层,颜色
	AcDbObjectId m_layerid;
	AcCmColor m_color;
	//
	int MText2DText();
	bool isOnFrozenLayer(AcDbEntity* ent, bool printMsg);
	bool isOnLockedLayer(AcDbEntity* ent, bool printMsg);
	Acad::ErrorStatus visableAllLayer();
	int lineWiden(AcDbLine *pLine,double dWidth,AcDbObjectId &objId);
	int lineWiden(AcDbArc *pLine,double linewidth,AcDbObjectId &objId);
	int lineWiden(AcDbPolyline *pPLine,double linewidth,AcDbObjectId &objId);
	int pLineCopy1(AcDbPolyline *pPlineTmp,AcDbPolyline *pNewPline,int &ptIdx);
	int plineFromLine(AcDbCurve *pCurve,AcDbPolyline *pNewPline,int ptIdx,int direct);
	int getSegLineBugle(AcGePoint2d &ptSt,AcGePoint2d &ptEnd, double &dBulge);
	int getSegArcBugle(AcGePoint2d &ptEnd, double dAngEnd, double &dBulge);
	int getPlinePoints(AcDbSpline* pSpl, AcGePoint2dArray& ptArr,int notFitData);
	int lineWiden2(AcDbCurve *pCurve,double linewidth,AcDbObjectId &objId);
	int pLineCopy2(AcDbPolyline *pPlineTmp,AcDbPolyline *pNewPline,int &ptIdx);
	int text2polyline(ads_name& ss1);
	struct resbuf * entItem(struct resbuf *textent,short irestype);
	int widenArc(ads_name ss1);
	AcDbPolyline*  ellipse2polyline(ads_name &en);
	int spline2polyline(ads_name &en);
	int spline2polyline(AcDbEntity *pEnt);
	Acad::ErrorStatus postToDatabase(AcDbEntity* ent , AcDbObjectId& objId);
	//int getArcBulge(ads_point pt1,ads_point pt2,ads_point pt3,double & dBulge);
	int getArcBulge(AcDbArc *pArc, double & dBulge);//弧凸度
	int getArcBulge(AcGePoint2d& pt1,AcGePoint2d& pt2,AcGePoint2d& pt3,double & dBulge);//曲线凸度
	int getArcBulge(AcGeCircArc2d &geArc, double & dBulge);
	int getLineAngle(AcGePoint2d& pt1,AcGePoint2d& pt2,double & dSlope);//直线斜率
	int isLine(AcGePoint2d& pt1,AcGePoint2d& pt2,AcGePoint2d& pt3);
	int getPlinePoints(AcDbEllipse * pEllipse, AcGePoint2dArray& ptArr);
	int getPlinePoints(AcDbSpline * pSpline, AcGePoint2dArray& ptArr);
	int Poly2dToLWPoly(AcDb2dPolyline *pPoly,AcDbPolyline *& pLwpoly);
	int doEntitySet(ads_name &ss);
	int doEntitySetWiden (AcDbVoidPtrArray &entitySet);
	int doEntitySetPolyline(AcDbVoidPtrArray& entitySet);
	int doEntitySetMerge(AcDbVoidPtrArray& entitySet);
	int doEntitySetWidMerge (AcDbVoidPtrArray &entitySet);
	int region2Polyline(AcDbVoidPtrArray& entitySetReg );
	int getLUL(void);
	double min4(double x1, double x2, double x3, double x4);
	double max4(double x1, double x2, double x3, double x4);
	int OnDoText2LineC(ads_name& ss1);
	int setFlag(int iFunID,int isWiden, int isMerge);
	bool pLineisClosed(AcDb2dPolyline *pPLine);
	bool pLineisClosed(AcDbPolyline *pPLine);
	int linesDraw(AcGePoint2dArray &arLines);
	int linesSort(AcGePoint2dArray& arLines);
	int linesDelSample (AcGePoint2dArray & arLines);
	int sortEnts(AcGePoint2dArray &arLines,AcDbDoubleArray &arBuggle);
	int mergePolyline(AcDbObjectIdArray objIdArray, AcDbVoidPtrArray curveSegs);
	int collectVertices(const AcDbEntity* ent, AcDbObjectIdArray& subEnts);
	int isIntersect(AcDbEntity* pEnt, AcDbEntity* pEnt2);
	int getMinDist(AcDbEntity* pEnt,AcDbEntityArray& arEnts,int ipos,double &dMinDist,AcGePoint2d &ptmin1,AcGePoint2d &ptmin2);
	int getMinDist(AcDbPolyline* pline1, AcDbPolyline* pline2,double &dMinDist,AcGePoint2d &ptmin1,AcGePoint2d &ptmin2);
public:
	int purgeBlockRef(void);
	int starEL2PL(void);
	int starSPL2PL(void);
	int starText2PL(int sel=0);
	int starWidenArc(int sel=0);
	int starText2lineA(void);
	int starText2lineB(void);
	int starText2lineC(void);
	int starText2lineD(void);
	int initTmpFile(void);
	int starMergePolyline(void);
	int ptOnLine(ads_point ptSt,ads_point ptEnd,ads_point ptMid);
	int getIntersectPnts(AcGeCircArc2d *pGeCir,AcGePoint2d ptSt,AcGePoint2d ptEnd, double &dBulge, int &intn,AcGePoint2d &p1,AcGePoint2d &p2);
	int getFilletPoints(AcGeCircArc2d *pGeCir,
							AcGePoint2d& ptSt1,AcGePoint2d& ptEnd1,AcGePoint2d& ptEnd2,
							double &dBulge1,double &dBulge2,
							AcGePoint2d& pnt1,AcGePoint2d& pnt2,double& dBulge);
	int starDo5s(void);
	int polyline2LWPolyline(const AcDbEntity* ent,AcDbObjectId objId);
	void starDimmini(void);
};

