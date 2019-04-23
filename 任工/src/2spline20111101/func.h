#pragma once
#ifndef _FUNC_H_
#define _FUNC_H_

#include "StdAfx.h"

typedef AcArray<double> AcDbDoubleArray;
typedef AcArray<AcDbEntity *> AcDbEntityArray;
//typedef AcArray<CList <struct stNode*>> CListArray;

#define GOOD 0
#define BAD 1

extern double m_pi;
extern double m_twopi;
//#define PI 3.141592654

//for interface
int starEl2Pl();
int starSpl2Pl();
int starDelWmfBlk();
int starMergePolyline();
int starPolarArrayText();
int starText2LineA();
int starText2LineB();
int starText2LineC();
int starText2LineD();
int starWidenArc();
int starMergePolyline();
int starDimmini();
int starDo5s();

//for internal use
int initStarmask();
int unloadStarmask();
int logtime(char *msg);
int getSelect();
char getKWord(char *key,char *msg);
int getSelectSet(int iSel,CStringList &strent,ads_name &ss);
int myprintf(char *fmt, ...);
int mysynclog(void);

double findMin (int n, double amount, ...);
double findMax (int n, double amount, ...);
int mypower(int value,int y);
double myaverage(double v1,double v2);
int myprintf(char *fmt, ...);
int mysynclog(void);
int setMylog(int value);
template <typename T>
T myabs(T value);

///////////////////////////////
template <typename T>
T myabs(T value)
{
	T dRet;
	if(value<0) dRet=-value;
	else dRet=value;
	return dRet;
}
///////////////////////////////
//for test
Acad::ErrorStatus postToDatabase(AcDbEntity* ent , AcDbObjectId& objId);
struct resbuf * entItem(struct resbuf *textent,short irestype);
void drawLine(AcGePoint2d& pt1,AcGePoint2d& pt2);
int drawText();
int starDisplay();
int starTrim();
int starDumpEnt();
int starText2Pline();
//void drawSpline();
void drawPoint(AcGePoint3d & pt);
HINSTANCE dllInstance();

#endif