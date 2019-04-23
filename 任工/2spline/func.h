#include "StdAfx.h"

#define GOOD 0
#define BAD 1

//extern double pi;
//extern double two_pi;
//#define PI 3.141592654
double findMin (int n, double amount, ...);
double findMax (int n, double amount, ...);

int starEl2Pl();
int starSpl2Pl();
int starDisplay();
int starTrim();
int starDumpEnt();
int starText2Pline();
int starDelWmfBlk();
int drawText();

void drawPoint(AcGePoint3d & pt);

int initStarmask();
int unloadStarmask();

//for test
void drawSpline();
HINSTANCE dllInstance();