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
//----- EL2PLDialog.cpp : Implementation of CEL2PLDialog
//-----------------------------------------------------------------------------
#include "StdAfx.h"
#include "resource.h"
#include "EL2PLDialog.h"
int getLayers(CStringArray & LayerNames);
//-----------------------------------------------------------------------------
IMPLEMENT_DYNAMIC (CEL2PLDialog, CAcUiDialog)

BEGIN_MESSAGE_MAP(CEL2PLDialog, CAcUiDialog)
	ON_MESSAGE(WM_ACAD_KEEPFOCUS, OnAcadKeepFocus)
	ON_BN_CLICKED(IDC_SELECT, OnBnClickedSelect)
	ON_BN_CLICKED(IDC_ONELAYER, OnBnClickedOnelayer)
	ON_BN_CLICKED(IDC_ALL, OnBnClickedAll)
END_MESSAGE_MAP()

//-----------------------------------------------------------------------------
CEL2PLDialog::CEL2PLDialog (CWnd *pParent /*=NULL*/, HINSTANCE hInstance /*=NULL*/) : CAcUiDialog (CEL2PLDialog::IDD, pParent, hInstance) , m_segnum(_T(""))
{
}

//-----------------------------------------------------------------------------
void CEL2PLDialog::DoDataExchange (CDataExchange *pDX) {
	CAcUiDialog::DoDataExchange (pDX) ;
	DDX_Control(pDX, IDC_LAYERS, m_cmblayers);
	DDX_Text(pDX, IDC_SEGNUM, m_segnum);
}

//-----------------------------------------------------------------------------
//----- Needed for modeless dialogs to keep focus.
//----- Return FALSE to not keep the focus, return TRUE to keep the focus
LRESULT CEL2PLDialog::OnAcadKeepFocus (WPARAM, LPARAM) {
	return (TRUE) ;
}

//BOOL CEL2PLDialog::OnInitDialog()
//{
//	CAcUiDialog::OnInitDialog();
///*
//	CStringArray LayerNames;
//	getLayers(LayerNames);
//	for(int i=0;i<LayerNames.GetSize();i++){
//		((CComboBox*)this->GetDlgItem(IDC_LAYERS))->AddString(LayerNames[i]);
//	}
//	((CComboBox*)this->GetDlgItem(IDC_LAYERS))->SetCurSel(0);
//*/
//	return TRUE;  // return TRUE unless you set the focus to a control
//	// 异常：OCX 属性页应返回 FALSE
//}

BOOL CEL2PLDialog::OnInitDialog()
{
	CAcUiDialog::OnInitDialog();

	CStringArray LayerNames;
	getLayers(LayerNames);
	for(int i=0;i<LayerNames.GetSize();i++){
		m_cmblayers.AddString(LayerNames[i]);
	}
	m_cmblayers.SetCurSel(0);
	return TRUE;  // return TRUE unless you set the focus to a control
	// 异常：OCX 属性页应返回 FALSE
}

void CEL2PLDialog::OnBnClickedSelect()
{
	UpdateData();
	EndDialog(IDC_SELECT);
}

void CEL2PLDialog::OnBnClickedOnelayer()
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

void CEL2PLDialog::OnBnClickedAll()
{
	EndDialog(IDC_ALL);
}
