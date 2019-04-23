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
//----- WidenDialog.cpp : Implementation of CWidenDialog
//-----------------------------------------------------------------------------
#include "StdAfx.h"
#include "resource.h"
#include "WidenDialog.h"

//-----------------------------------------------------------------------------
IMPLEMENT_DYNAMIC (CWidenDialog, CAcUiDialog)

BEGIN_MESSAGE_MAP(CWidenDialog, CAcUiDialog)
	ON_MESSAGE(WM_ACAD_KEEPFOCUS, OnAcadKeepFocus)
	ON_BN_CLICKED(IDOK, OnBnClickedOk)
END_MESSAGE_MAP()

//-----------------------------------------------------------------------------
CWidenDialog::CWidenDialog (CWnd *pParent /*=NULL*/, HINSTANCE hInstance /*=NULL*/) : CAcUiDialog (CWidenDialog::IDD, pParent, hInstance) , m_dWiden(_T(""))
, m_bFillet(FALSE)
, m_bPolyline(FALSE)
{
}

//-----------------------------------------------------------------------------
void CWidenDialog::DoDataExchange (CDataExchange *pDX) {
	CAcUiDialog::DoDataExchange (pDX) ;
	DDX_Text(pDX, IDC_WIDEN, m_dWiden);
	DDX_Check(pDX, IDC_CHECK1, m_bFillet);
	DDX_Check(pDX, IDC_CHECK2, m_bPolyline);
}

//-----------------------------------------------------------------------------
//----- Needed for modeless dialogs to keep focus.
//----- Return FALSE to not keep the focus, return TRUE to keep the focus
LRESULT CWidenDialog::OnAcadKeepFocus (WPARAM, LPARAM) {
	return (TRUE) ;
}

void CWidenDialog::OnBnClickedOk()
{
	UpdateData();
	EndDialog(IDOK);
}
