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
//----- MyDialog.cpp : Implementation of CMyDialog
//-----------------------------------------------------------------------------
#include "StdAfx.h"
#include "resource.h"
#include "MyDialog.h"

//-----------------------------------------------------------------------------
IMPLEMENT_DYNAMIC (CMyDialog, CAcUiDialog)

BEGIN_MESSAGE_MAP(CMyDialog, CAcUiDialog)
	ON_MESSAGE(WM_ACAD_KEEPFOCUS, OnAcadKeepFocus)
	ON_BN_CLICKED(IDC_EL2PL, OnBnClickedEl2pl)
	ON_BN_CLICKED(IDC_SPL2PL, OnBnClickedSpl2pl)
	ON_BN_CLICKED(IDC_MYSPL, OnBnClickedMyspl)
	ON_BN_CLICKED(IDC_ENTINFO, OnBnClickedEntinfo)
	ON_BN_CLICKED(IDC_TSTPARAM, OnBnClickedTstparam)
	ON_BN_CLICKED(IDC_TESTARC3P, OnBnClickedTestarc3p)
	ON_WM_PAINT()
	ON_BN_CLICKED(IDC_TEXT2PL, OnBnClickedText2pl)
	ON_BN_CLICKED(IDC_MT2DT, OnBnClickedMt2dt)
	ON_BN_CLICKED(IDC_WIDEN, OnBnClickedWiden)
END_MESSAGE_MAP()

//-----------------------------------------------------------------------------
CMyDialog::CMyDialog (CWnd *pParent /*=NULL*/, HINSTANCE hInstance /*=NULL*/) : CAcUiDialog (CMyDialog::IDD, pParent, hInstance) {
}

//-----------------------------------------------------------------------------
void CMyDialog::DoDataExchange (CDataExchange *pDX) {
	CAcUiDialog::DoDataExchange (pDX) ;
}

//-----------------------------------------------------------------------------
//----- Needed for modeless dialogs to keep focus.
//----- Return FALSE to not keep the focus, return TRUE to keep the focus
LRESULT CMyDialog::OnAcadKeepFocus (WPARAM, LPARAM) {
	return (TRUE) ;
}

void CMyDialog::OnBnClickedEl2pl()
{
	EndDialog(IDC_EL2PL);
}

void CMyDialog::OnBnClickedSpl2pl()
{
	EndDialog(IDC_SPL2PL);
}

void CMyDialog::OnBnClickedMyspl()
{
	EndDialog(IDC_MYSPL);
}

void CMyDialog::OnBnClickedEntinfo()
{
	EndDialog(IDC_ENTINFO);
}

void CMyDialog::OnBnClickedTstparam()
{
	EndDialog(IDC_TSTPARAM);
}

void CMyDialog::OnBnClickedTestarc3p()
{
	EndDialog(IDC_TESTARC3P);
}

void CMyDialog::OnPaint()
{
	CPaintDC dc(this); // device context for painting
	// TODO: 在此添加消息处理程序代码
	RECT rc;
	this->GetClientRect(&rc);
	POINT pt1={rc.left,rc.top};
	dc.MoveTo(pt1);
	POINT pt2={rc.right,rc.bottom};
	dc.LineTo(pt2);
	// 不为绘图消息调用	CAcUiDialog::OnPaint();
}

void CMyDialog::OnBnClickedText2pl()
{
	EndDialog(IDC_TEXT2PL);
}

void CMyDialog::OnBnClickedMt2dt()
{
	EndDialog(IDC_MT2DT);
}

void CMyDialog::OnBnClickedWiden()
{
	EndDialog(IDC_WIDEN);
}
