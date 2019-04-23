// (C) Copyright 1990-2002 by Autodesk, Inc. 
//
// Permission to use, copy, modify, and distribute this software in
// object code form for any purpose and without fee is hereby granted, 
// provided that the above copyright notice appears in all copies and 
// that both that copyright notice and the limited warranty and
// restricted rights notice below appear in all supporting 
// documentation.
//
// AUTODESK PROVIDES THIS PROGRAM "AS IS" AND WITH ALL FAULTS. 
// AUTODESK SPECIFICALLY DISCLAIMS ANY IMPLIED WARRANTY OF
// MERCHANTABILITY OR FITNESS FOR A PARTICULAR USE.  AUTODESK, INC. 
// DOES NOT WARRANT THAT THE OPERATION OF THE PROGRAM WILL BE
// UNINTERRUPTED OR ERROR FREE.
//
// Use, duplication, or disclosure by the U.S. Government is subject to 
// restrictions set forth in FAR 52.227-19 (Commercial Computer
// Software - Restricted Rights) and DFAR 252.227-7013(c)(1)(ii)
// (Rights in Technical Data and Computer Software), as applicable.
//

//-----------------------------------------------------------------------------
//----- acrxEntryPoint.h
//-----------------------------------------------------------------------------
#include "StdAfx.h"
#include "func.h"
#include "myoption.h"
//-----------------------------------------------------------------------------
#define szRDS _RXST("asdk")

CMyOption g_myoption;

//-----------------------------------------------------------------------------
//----- ObjectARX EntryPoint
class CstarmaskApp : public AcRxArxApp {

public:
	CstarmaskApp () : AcRxArxApp () {}

	virtual AcRx::AppRetCode On_kInitAppMsg (void *pkt) {
		//g_myoption=NULL;
		AcRx::AppRetCode retCode =AcRxArxApp::On_kInitAppMsg (pkt) ;
		initStarmask();
		//acutPrintf("asdkmytest º”‘ÿ≥…π¶!");
		//showMsg();
		acedRegisterExtendedTab("ASDKSTARMASK", _T("OptionsDialog"));
		return (retCode);
		//pi=3.14159;
	}

	virtual AcRx::AppRetCode On_kUnloadAppMsg (void *pkt) {
		AcRx::AppRetCode retCode =AcRxArxApp::On_kUnloadAppMsg (pkt) ;
		// TODO: Add your code here
		unloadStarmask();
		return (retCode) ;
	}

	virtual void RegisterServerComponents () {
	}



	// ----- asdkstarmask._se2p command (do not rename)
	static void asdkstarmask_se2p(void)
	{
		starEl2Pl();
	}

	// ----- asdkstarmask._ss command (do not rename)
	static void asdkstarmask_ss(void)
	{
		starDisplay();
	}

	// ----- asdkstarmask._str command (do not rename)
	static void asdkstarmask_str(void)
	{
		starTrim();
	}

	// ----- asdkstarmask._myspl command (do not rename)
	static void asdkstarmask_myspl(void)
	{
		drawSpline();
	}

	// ----- asdkstarmask._ss2o command (do not rename)
	static void asdkstarmask_ss2o(void)
	{
		starSpl2Pl();
	}
	// -----------------------------------------------------------------------------
	virtual AcRx::AppRetCode On_kInitDialogMsg(void * pkt);
	// -----------------------------------------------------------------------------
	virtual AcRx::AppRetCode On_kEndDialogMsg(void * pkt);
public:

	// ----- asdkstarmask._st2p command
	static void asdkstarmask_st2p(void)
	{
		starText2Pline();
	}

	// ----- asdkstarmask._sdwmf command (do not rename)
	static void asdkstarmask_sdwmf(void)
	{
		drawText();
	}

	// ----- asdkstarmask._widen command (do not rename)
	static void asdkstarmask_widen(void)
	{
		// Add your code for command asdkstarmask._widen here
	}
} ;


AcRx::AppRetCode CstarmaskApp::On_kInitDialogMsg(void * pkt)
{
	AcRx::AppRetCode retCode =AcRxArxApp::On_kInitDialogMsg (pkt) ;

	// my option dialog
	CAdUiTabExtensionManager* pTabExtMgr = static_cast<CAdUiTabExtensionManager*>(pkt);
    CString tabDlgName = pTabExtMgr->GetDialogName();
	// Add the tab
    if (!tabDlgName.CompareNoCase(_T("OptionsDialog"))) {
		//if (g_myoption == NULL)
		//	g_myoption = new CMyOption;
        //if (g_myoption) {
			pTabExtMgr->AddTab(dllInstance(), IDD_MYOPTION, _T("Spline2Polyline"), &g_myoption);
			g_myoption.StretchControlXY(IDC_STATIC1, 50, 50);
			g_myoption.StretchControlXY(IDC_STATIC3, 50, 50);
			//g_myoption.StretchControlXY(IDC_COMBO1, 50, 50);
			//g_myoption.MoveControlY(IDC_STATIC1, 100);
			//g_myoption.MoveControlY(IDC_STATIC3, 200);
        //}
    } /* */

	return (retCode) ;
}
// -----------------------------------------------------------------------------

AcRx::AppRetCode CstarmaskApp::On_kEndDialogMsg(void * pkt)
{
	AcRx::AppRetCode retCode =AcRxArxApp::On_kEndDialogMsg (pkt) ;
	return (retCode) ;
}

//-----------------------------------------------------------------------------
IMPLEMENT_ARX_ENTRYPOINT(CstarmaskApp)

ACED_ARXCOMMAND_ENTRY_AUTO(CstarmaskApp, asdkstarmask, _se2p, se2p, ACRX_CMD_TRANSPARENT, NULL)
ACED_ARXCOMMAND_ENTRY_AUTO(CstarmaskApp, asdkstarmask, _ss, ss, ACRX_CMD_TRANSPARENT, NULL)
ACED_ARXCOMMAND_ENTRY_AUTO(CstarmaskApp, asdkstarmask, _str, str, ACRX_CMD_TRANSPARENT, NULL)
ACED_ARXCOMMAND_ENTRY_AUTO(CstarmaskApp, asdkstarmask, _myspl, myspl, ACRX_CMD_TRANSPARENT, NULL)
ACED_ARXCOMMAND_ENTRY_AUTO(CstarmaskApp, asdkstarmask, _ss2o, ss2o, ACRX_CMD_TRANSPARENT, NULL)
ACED_ARXCOMMAND_ENTRY_AUTO(CstarmaskApp, asdkstarmask, _st2p, st2p, ACRX_CMD_TRANSPARENT, NULL)
ACED_ARXCOMMAND_ENTRY_AUTO(CstarmaskApp, asdkstarmask, _sdwmf, sdwmf, ACRX_CMD_TRANSPARENT, NULL)
// -----------------------------------------------------------------------------
ACED_ARXCOMMAND_ENTRY_AUTO(CstarmaskApp, asdkstarmask, _widen, widen, ACRX_CMD_TRANSPARENT, NULL)
