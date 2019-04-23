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
#include "myoption.h"
#include "func.h"
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



	// ----- asdkstarmask._el2pl command
	static void asdkstarmask_el2pl(void)
	{
		starEl2Pl();
	}

	// ----- asdkstarmask._ss command (do not rename)
	static void asdkstarmask_sss(void)
	{
		starDisplay();
	}

	// ----- asdkstarmask._sp2pl command
	static void asdkstarmask_sp2pl(void)
	{
		starSpl2Pl();
	}
	// -----------------------------------------------------------------------------
	//virtual AcRx::AppRetCode On_kInitDialogMsg(void * pkt);
	// -----------------------------------------------------------------------------
	//virtual AcRx::AppRetCode On_kEndDialogMsg(void * pkt);

	// ----- asdkstarmask._mrgpl command
	static void asdkstarmask_mrgpl(void)
	{
		starMergePolyline();
	}

	// ----- asdkstarmask._wdnarc command
	static void asdkstarmask_wdnarc(void)
	{
		starWidenArc();
	}

	// ----- asdkstarmask._pat command
	static void asdkstarmask_pat(void)
	{
		starPolarArrayText();
	}

	// ----- asdkstarmask._t2l1 command
	static void asdkstarmask_t2l1(void)
	{
		starText2LineA();
	}

	// ----- asdkstarmask._t2l3 command
	static void asdkstarmask_t2l3(void)
	{
		starText2LineC();
	}

	// ----- asdkstarmask._t2l2 command (do not rename)
	static void asdkstarmask_t2l2(void)
	{
		starText2LineB();
	}

	// ----- asdkstarmask._t2l4 command (do not rename)
	static void asdkstarmask_t2l4(void)
	{
		starText2LineD();
	}

	// ----- asdkstarmask._do5s command (do not rename)
	static void asdkstarmask_do5s(void)
	{
		starDo5s();
	}

	// ----- asdkstarmask._dimmini command (do not rename)
	static void asdkstarmask_dimmini(void)
	{
		starDimmini();
	}
} ;

/*
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
    }

	return (retCode) ;
}
// -----------------------------------------------------------------------------

AcRx::AppRetCode CstarmaskApp::On_kEndDialogMsg(void * pkt)
{
	AcRx::AppRetCode retCode =AcRxArxApp::On_kEndDialogMsg (pkt) ;
	return (retCode) ;
}*/

//-----------------------------------------------------------------------------
//ACED_ARXCOMMAND_ENTRY_AUTO(CstarmaskApp, asdkstarmask, _str, str, ACRX_CMD_TRANSPARENT, NULL)
//ACED_ARXCOMMAND_ENTRY_AUTO(CstarmaskApp, asdkstarmask, _myspl, myspl, ACRX_CMD_TRANSPARENT, NULL)
//ACED_ARXCOMMAND_ENTRY_AUTO(CstarmaskApp, asdkstarmask, _stextmerge, stm, ACRX_CMD_TRANSPARENT, NULL)
//ACED_ARXCOMMAND_ENTRY_AUTO(CstarmaskApp, asdkstarmask, _st2p, st2p, ACRX_CMD_TRANSPARENT, NULL)

IMPLEMENT_ARX_ENTRYPOINT(CstarmaskApp)

ACED_ARXCOMMAND_ENTRY_AUTO(CstarmaskApp, asdkstarmask, _sss, sss, ACRX_CMD_TRANSPARENT, NULL)
ACED_ARXCOMMAND_ENTRY_AUTO(CstarmaskApp, asdkstarmask, _el2pl, el2pl, ACRX_CMD_TRANSPARENT, NULL)
ACED_ARXCOMMAND_ENTRY_AUTO(CstarmaskApp, asdkstarmask, _sp2pl, sp2pl, ACRX_CMD_TRANSPARENT, NULL)
ACED_ARXCOMMAND_ENTRY_AUTO(CstarmaskApp, asdkstarmask, _mrgpl, mrgpl, ACRX_CMD_TRANSPARENT, NULL)
ACED_ARXCOMMAND_ENTRY_AUTO(CstarmaskApp, asdkstarmask, _wdnarc, wdnarc, ACRX_CMD_TRANSPARENT, NULL)
ACED_ARXCOMMAND_ENTRY_AUTO(CstarmaskApp, asdkstarmask, _pat, pat, ACRX_CMD_TRANSPARENT, NULL)
ACED_ARXCOMMAND_ENTRY_AUTO(CstarmaskApp, asdkstarmask, _t2l1, t2l1, ACRX_CMD_TRANSPARENT, NULL)
ACED_ARXCOMMAND_ENTRY_AUTO(CstarmaskApp, asdkstarmask, _t2l3, t2l3, ACRX_CMD_TRANSPARENT, NULL)ACED_ARXCOMMAND_ENTRY_AUTO(CstarmaskApp, asdkstarmask, _t2l2, t2l2, ACRX_CMD_TRANSPARENT, NULL)
ACED_ARXCOMMAND_ENTRY_AUTO(CstarmaskApp, asdkstarmask, _t2l4, t2l4, ACRX_CMD_TRANSPARENT, NULL)
ACED_ARXCOMMAND_ENTRY_AUTO(CstarmaskApp, asdkstarmask, _do5s, do5s, ACRX_CMD_TRANSPARENT, NULL)
ACED_ARXCOMMAND_ENTRY_AUTO(CstarmaskApp, asdkstarmask, _dimmini, dimmini, ACRX_CMD_TRANSPARENT, NULL)
