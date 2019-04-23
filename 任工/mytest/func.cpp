#include "func.h"
#include "string"

Acad::ErrorStatus postToDatabase(AcDbEntity* ent, AcDbObjectId& objId)
{
    //  Given an entity, this function will post it to the database
    //  in MODEL_SPACE and then return the objectId;  returns eOk if
    //  all went well. 
    
    Acad::ErrorStatus	  es;
    AcDbBlockTable*		pBlockTable;
    AcDbBlockTableRecord*  pSpaceRecord;
    
    es = acdbHostApplicationServices()->workingDatabase()
        ->getSymbolTable(pBlockTable, AcDb::kForRead);

    assert(es == Acad::eOk);
    
    es = pBlockTable->getAt(ACDB_MODEL_SPACE, pSpaceRecord, AcDb::kForWrite);
    assert(es == Acad::eOk);
    
    es = pBlockTable->close();
    assert(es == Acad::eOk);
    
    es = pSpaceRecord->appendAcDbEntity(objId, ent);
    assert(es == Acad::eOk);
    
    es = ent->close();
    assert(es == Acad::eOk);
    
    es = pSpaceRecord->close();
    assert(es == Acad::eOk);
    
    return es;
}

AcDbPolyline* convertit(ads_name& en)
{
	AcDbObjectId eId;
	AcDb::OpenMode openMode=kForWrite; //kForRead;
	// Exchange the ads_name for an object ID.
	//
	acdbGetObjectId(eId, en);

	AcDbVoidPtrArray ptArray;
	
	AcDbEntity * pEnt;
	acdbOpenObject(pEnt, eId, openMode);    
	
	std::string str = pEnt->isA()->name();
	acutPrintf ("\nYou selected entity ID: %ld %s\n", en [0],str.c_str());
	//处理直线
	if (str == "AcDbLine")
	{
		AcDbPolyline *Pline = new AcDbPolyline(2);
		AcGePoint3d ptStart,ptEnd;
		((AcDbCurve *)pEnt)->getStartPoint(ptStart);
		((AcDbCurve *)pEnt)->getEndPoint(ptEnd);
		acutPrintf("line: %f %f %f %f!\n", ptStart.x, ptStart.y, ptEnd.x, ptEnd.y);
		Pline->addVertexAt(0, AcGePoint2d(ptStart.x, ptStart.y), 0);
		Pline->addVertexAt(1, AcGePoint2d(ptEnd.x, ptEnd.y), 0);
		ptArray.append(Pline);
		pEnt->erase();
	}
	else if  (str=="AcDbEllipse")
	{
		AcDbEllipse *pEllipse = (AcDbEllipse*)pEnt;
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

		double dLen =  0;
		pEllipse->getStartPoint(pt);
		//ptArr.append(pt);
		dLen += dStep/3;
		//pEllipse->getPointAtDist(dLen/2, pt);
		//double dLen =  dStep/2;
		for (int i=1;i<=4;i++){
			dLen -= dStep;
			dLen += dStep/3;
			for (int j=0;j<3;j++){
				pEllipse->getPointAtDist(dLen, pt);
				ptArr.append(pt);	
				dLen += dStep/3;
			}
			while(dLen < dLength * i/4)
			{
				pEllipse->getPointAtDist(dLen, pt);
				ptArr.append(pt);
				dLen += dStep;
			}	
			dLen -= dStep/3;
		}

		pEllipse->getEndPoint(pt);
		ptArr.append(pt);

		AcDbPolyline *Pline = new AcDbPolyline(ptArr.length()); 
		for (int i = 0; i < ptArr.length(); i ++)
		{
			//acutPrintf("line: %f %f!\n", ptArr.at(i).x, ptArr.at(i).y);
			Pline->addVertexAt(i, AcGePoint2d(ptArr.at(i).x, ptArr.at(i).y), 0);
		}
		ptArray.append(Pline);
		//pEnt->erase();
	}
	pEnt->close();

	AcGePoint3d ptStart,ptEnd;
	AcDbPolyline* pPolyline=NULL;
	if (ptArray.length()<1){
		pPolyline=NULL;
		return NULL;
	}
	pPolyline = (AcDbPolyline*)ptArray.at(0);
	pPolyline->getStartPoint(ptStart);
	pPolyline->getEndPoint(ptEnd);
	int num = pPolyline->numVerts();
	int Number = -1;
	int startORend = 0;
	acutPrintf("length %d!\n", ptArray.length());
	while (ptArray.length() > 1)
	{
		double Dist = 999999999;
		for (int i = 1; i < ptArray.length(); i ++)
		{
			AcDbPolyline *pPolyline1;
			AcGePoint3d ptStart1, ptEnd1;
			pPolyline1 = (AcDbPolyline*)ptArray.at(i);
			pPolyline1->getStartPoint(ptStart1);
			pPolyline1->getEndPoint(ptEnd1);
			if (Dist > ptEnd.distanceTo(ptStart1))
			{
				Dist = ptEnd.distanceTo(ptStart1);
				Number = i;
				startORend = 1;
			}
			if (Dist >  ptEnd.distanceTo(ptEnd1))
			{
				Dist = ptEnd.distanceTo(ptEnd1);
				Number = i;
				startORend = 2;
			}
		}
		acutPrintf("Number,startORend,Dist: %d %d %f\n",Number,startORend,Dist);
		AcDbPolyline *pPolyline1 = (AcDbPolyline*)ptArray.at(Number);
		if (startORend == 1)
		{
			for (int j = 0; j < pPolyline1->numVerts(); j ++)
			{
				AcGePoint2d pttemp;
				double bulge, WidthStart, WidthEnd;
				pPolyline1->getPointAt(j, pttemp);
				pPolyline1->getBulgeAt(j, bulge);
				pPolyline1->getWidthsAt(j,WidthStart, WidthEnd);
				pPolyline->addVertexAt(num, pttemp, bulge, WidthStart, WidthEnd);
				num++;
				ptEnd.x = pttemp.x;
				ptEnd.y = pttemp.y;
				ptEnd.z = 0;
			}
			ptArray.removeAt(Number);
		}
		if (startORend == 2)
		{
			for (int j =  pPolyline1->numVerts() - 1; j >= 0; j --)
			{
				AcGePoint2d pttemp;
				double bulge, WidthStart, WidthEnd;
				pPolyline1->getPointAt(j, pttemp);
				pPolyline1->getBulgeAt(j, bulge);
				pPolyline1->getWidthsAt(j, WidthEnd, WidthStart);                                        
				pPolyline->addVertexAt(num, pttemp, bulge, WidthStart, WidthEnd);
				num++;
				ptEnd.x = pttemp.x;
				ptEnd.y = pttemp.y;
				ptEnd.z = 0;
			}    
			ptArray.removeAt(Number);                 
		}
	}
	if (!pPolyline->isClosed())
	{
		pPolyline->setClosed(true);
	}
	return pPolyline;
}

int mytest()
{
	ads_name en ;
	ads_point pt ;

	ads_name ss, ss1;

	// 按提示生成选择集  
	acedSSGet(NULL, NULL, NULL, NULL, ss);
	// Get the name of first entity in sset.
	if (acedSSName(ss, 0L, ss1) != RTNORM) 
		return BAD; 

	long length; 
	AcDbObject* pObj;

	if (acedSSLength(ss, &length) != RTNORM) 
		return BAD; 
	acutPrintf("select %d \n",length);

	/* 单选
	if ( acedEntSel ("\nSelect an entity: ", en, pt) != RTNORM )
	{
		acutPrintf ("\nYou not selected entity ");
		return ;
	}*/

	/* 显示
	AcDbBlockTable *pBlockTable;
	acdbHostApplicationServices()->workingDatabase()->getSymbolTable(pBlockTable, AcDb::kForRead);

	AcDbBlockTableRecord *pBlockTableRecord;
	pBlockTable->getAt(ACDB_MODEL_SPACE, pBlockTableRecord,AcDb::kForWrite);
	pBlockTable->close(); */

	acedSetStatusBarProgressMeter("Test Progress Bar", 0, length);
    acedRestoreStatusBar();
	for (int i=0;i<length;i++){
        acedSetStatusBarProgressMeterPos(i);
		if (acedSSName(ss, i, ss1) != RTNORM) 
		break;
		AcDbPolyline* pPolyline = convertit(ss1);
		if (pPolyline){
			pPolyline->setColorIndex(1);
			//pPolyline->draw();
			AcDbObjectId custOID;
			postToDatabase(pPolyline, custOID);
			//pPolyline->close();
		}
	}

	AcGePoint3d position(4.0,2.0,3.0);
	AcDbText *pText=new AcDbText(position,"testaa");
	AcDbObjectId custOID;
	postToDatabase(pText, custOID);
	//pText->close();
	return GOOD;
}
