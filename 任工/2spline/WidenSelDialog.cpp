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
//----- WidenSelDialog.cpp : Implementation of CWidenSelDialog
//-----------------------------------------------------------------------------
#include "StdAfx.h"
#include "resource.h"
#include "WidenSelDialog.h"
int getLayers(CStringArray & LayerNames);

//-----------------------------------------------------------------------------
IMPLEMENT_DYNAMIC (CWidenSelDialog, CAcUiDialog)

BEGIN_MESSAGE_MAP(CWidenSelDialog, CAcUiDialog)
	ON_MESSAGE(WM_ACAD_KEEPFOCUS, OnAcadKeepFocus)
	ON_BN_CLICKED(IDC_ONELAYER, OnBnClickedOnelayer)
	ON_BN_CLICKED(IDC_SELECT, OnBnClickedSelect)
	ON_BN_CLICKED(IDC_ALL, OnBnClickedAll)
END_MESSAGE_MAP()

//-----------------------------------------------------------------------------
CWidenSelDialog::CWidenSelDialog (CWnd *pParent /*=NULL*/, HINSTANCE hInstance /*=NULL*/) : CAcUiDialog (CWidenSelDialog::IDD, pParent, hInstance) , m_dWiden(_T(""))
, m_bFillet(FALSE)
, m_bPolyline(FALSE)
{
}

//-----------------------------------------------------------------------------
void CWidenSelDialog::DoDataExchange (CDataExchange *pDX) {
	CAcUiDialog::DoDataExchange (pDX) ;
	DDX_Control(pDX, IDC_LAYERS, m_cmblayers);
	DDX_Text(pDX, IDC_SEGNUM, m_dWiden);
	DDX_Check(pDX, IDC_CHECK1, m_bFillet);
	DDX_Check(pDX, IDC_CHECK2, m_bPolyline);
}

//-----------------------------------------------------------------------------
//----- Needed for modeless dialogs to keep focus.
//----- Return FALSE to not keep the focus, return TRUE to keep the focus
LRESULT CWidenSelDialog::OnAcadKeepFocus (WPARAM, LPARAM) {
	return (TRUE) ;
}

void CWidenSelDialog::OnBnClickedOnelayer()
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

void CWidenSelDialog::OnBnClickedSelect()
{
	UpdateData();
	EndDialog(IDC_SELECT);
}

BOOL CWidenSelDialog::OnInitDialog()
{
	CAcUiDialog::OnInitDialog();

	CStringArray LayerNames;
	getLayers(LayerNames);
	for(int i=0;i<LayerNames.GetSize();i++){
		m_cmblayers.AddString(LayerNames[i]);
	}
	m_cmblayers.SetCurSel(0);
	m_dWiden="0.3";
	return TRUE;  // return TRUE unless you set the focus to a control
	// 异常：OCX 属性页应返回 FALSE
}

void CWidenSelDialog::OnBnClickedAll()
{
	UpdateData();
	EndDialog(IDC_ALL);
}
