#pragma once
#include "StdAfx.h"

#define GOOD 0
#define BAD 1
int myprintf(char *fmt, ...);
int mysynclog(void);
int setMylog(int value);

class CEntDisplay
{
public:
	CEntDisplay();
	~CEntDisplay(void);
	int starDisplay(void);
private:
	int display(AcDbObjectId eId);
	int display(AcDbEllipse * pEllipse);
	int display(AcDbPolyline * pline);
public:
	int display(AcDb3dPolyline * p3dPline);
};
