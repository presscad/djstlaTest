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
//----- MyOption.cpp : Implementation of CMyOption
//-----------------------------------------------------------------------------
#include "StdAfx.h"
#include "resource.h"
#include "MyOption.h"

//extern CMyOption *g_myoption;

//-----------------------------------------------------------------------------
IMPLEMENT_DYNAMIC (CMyOption, CAcUiTabChildDialog)

BEGIN_MESSAGE_MAP(CMyOption, CAcUiTabChildDialog)
END_MESSAGE_MAP()

//-----------------------------------------------------------------------------
CMyOption::CMyOption (CWnd *pParent /*=NULL*/, HINSTANCE hInstance /*=NULL*/) : CAcUiTabChildDialog (pParent, hInstance) , m_segnum(_T(""))
{
}

//-----------------------------------------------------------------------------
void CMyOption::DoDataExchange (CDataExchange *pDX) {
	CAcUiTabChildDialog::DoDataExchange (pDX) ;
	//DDX_Control(pDX, IDC_COMBO1, m_combox1);
	//DDX_Text(pDX, IDC_SEGNUM, m_segnum);
}

//-----------------------------------------------------------------------------
//----- Called when this tab is activated. The default implementation does nothing
void CMyOption::OnTabActivation (BOOL bActivate) {
	// TODO: Add your code here
}

//-----------------------------------------------------------------------------
//----- Called when a tab is de-activated and another is about to be activated. 
//----- The default implementation returns TRUE, allowing the change. 
//----- Return FALSE to prevent the tab switch.
BOOL CMyOption::OnTabChanging () {
	// TODO: Add your code here

	return (TRUE) ;
}

BOOL CMyOption::OnInitDialog()
{
	CAcUiTabChildDialog::OnInitDialog();
	// m_combox1.SetCurSel(8);
	return TRUE;  // return TRUE unless you set the focus to a control
	// 异常：OCX 属性页应返回 FALSE
}

void CMyOption::PostNcDestroy()
{
	//delete g_myoption;
    //g_myoption = NULL;
	// TODO: 在此添加专用代码和/或调用基类
	CAcUiTabChildDialog::PostNcDestroy();
}
