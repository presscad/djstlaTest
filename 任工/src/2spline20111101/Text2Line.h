#pragma once

#include "func.h"

class CText2Line
{
private:
	int m_bWiden;
	//PI
	double m_pi;
	double m_twopi;
	ads_point m_ptTextLeft,m_ptTextRight;
	//¼ÆËãwmfout,wmfin
	double m_linewidth;
	double m_textheight;
	ads_point m_lul;//vw.x vh.y
	ads_point m_vc;//vw.x vh.y
	//»Ö¸´Í¼²ã,ÑÕÉ«
	AcDbObjectId m_layerid;
public:
	CText2Line(void);
	~CText2Line(void);
	int starText2lineA(void);
	int starText2lineB(void);
	int starText2lineC(void);
	int starTextMerge(void);
	//int OnDoText2LineC(ads_name &ss1);
	int MText2Text(void);
	int text2polyline(ads_name ss1);
	int purgeBlockRef(void);
	bool isOnLockedLayer(AcDbEntity* ent, bool printMsg);
	bool isOnFrozenLayer(AcDbEntity* ent, bool printMsg);
	int lineWiden(AcDbLine *pLine,double linewidth);
	int getLUL(void);
	int getArcBulge(AcGePoint2d& pt1,AcGePoint2d& pt2,AcGePoint2d& pt3,double & dBugle);
};
