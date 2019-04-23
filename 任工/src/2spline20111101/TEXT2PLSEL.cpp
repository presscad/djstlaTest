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
//----- TEXT2PLSEL.cpp : Implementation of CTEXT2PLSEL
//-----------------------------------------------------------------------------
#include "StdAfx.h"
#include "resource.h"
#include "TEXT2PLSEL.h"
int getLayers(CStringArray & LayerNames);

//-----------------------------------------------------------------------------
IMPLEMENT_DYNAMIC (CTEXT2PLSEL, CAcUiDialog)

BEGIN_MESSAGE_MAP(CTEXT2PLSEL, CAcUiDialog)
	ON_MESSAGE(WM_ACAD_KEEPFOCUS, OnAcadKeepFocus)
	ON_BN_CLICKED(IDC_SELECT, OnBnClickedSelect)
	ON_BN_CLICKED(IDC_ONELAYER, OnBnClickedOnelayer)
	ON_BN_CLICKED(IDC_ALL, OnBnClickedAll)
END_MESSAGE_MAP()

//-----------------------------------------------------------------------------
CTEXT2PLSEL::CTEXT2PLSEL (CWnd *pParent /*=NULL*/, HINSTANCE hInstance /*=NULL*/) : CAcUiDialog (CTEXT2PLSEL::IDD, pParent, hInstance) , m_widen(FALSE)
{
}

//-----------------------------------------------------------------------------
void CTEXT2PLSEL::DoDataExchange (CDataExchange *pDX) {
	CAcUiDialog::DoDataExchange (pDX) ;
	DDX_Control(pDX, IDC_LAYERS, m_cmblayers);
	DDX_Check(pDX, IDC_WIDEN, m_widen);
}

//-----------------------------------------------------------------------------
//----- Needed for modeless dialogs to keep focus.
//----- Return FALSE to not keep the focus, return TRUE to keep the focus
LRESULT CTEXT2PLSEL::OnAcadKeepFocus (WPARAM, LPARAM) {
	return (TRUE) ;
}

BOOL CTEXT2PLSEL::OnInitDialog()
{
	CAcUiDialog::OnInitDialog();
	CStringArray LayerNames;
	getLayers(LayerNames);
	for(int i=0;i<LayerNames.GetSize();i++){
		m_cmblayers.AddString(LayerNames[i]);
	}
	m_cmblayers.SetCurSel(0);
	m_widen=TRUE;
	return TRUE;  // return TRUE unless you set the focus to a control
	// 异常：OCX 属性页应返回 FALSE
}

void CTEXT2PLSEL::OnBnClickedSelect()
{
	UpdateData();
	EndDialog(IDC_SELECT);
}

void CTEXT2PLSEL::OnBnClickedOnelayer()
{
	UpdateData();
	if(m_cmblayers.GetCurSel()<0){
		AfxMessageBox("请输入层名!");
	}
	else{
		m_cmblayers.GetWindowText(layername);
		acutPrintf("layername: %s\n",layername);
		EndDialog(IDC_ONELAYER);
	}
}

void CTEXT2PLSEL::OnBnClickedAll()
{
	UpdateData();
	EndDialog(IDC_ALL);
}
