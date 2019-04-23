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
//----- MyDialog.h : Declaration of the CMyDialog
//-----------------------------------------------------------------------------
#pragma once

//-----------------------------------------------------------------------------
#include "acui.h"
#include "resource.h"
//-----------------------------------------------------------------------------
class CMyDialog : public CAcUiDialog {
	DECLARE_DYNAMIC (CMyDialog)

public:
	CMyDialog (CWnd *pParent =NULL, HINSTANCE hInstance =NULL) ;

	enum { IDD = IDD_MYDIALOG} ;

protected:
	virtual void DoDataExchange (CDataExchange *pDX) ;
	afx_msg LRESULT OnAcadKeepFocus (WPARAM, LPARAM) ;

	DECLARE_MESSAGE_MAP()
public:
	afx_msg void OnBnClickedEl2pl();
	afx_msg void OnBnClickedSpl2pl();
	afx_msg void OnBnClickedMyspl();
	afx_msg void OnBnClickedEntinfo();
	afx_msg void OnBnClickedTstparam();
	afx_msg void OnBnClickedTestarc3p();
	afx_msg void OnPaint();
	afx_msg void OnBnClickedText2pl();
	afx_msg void OnBnClickedMt2dt();
	afx_msg void OnBnClickedWiden();
	afx_msg void OnBnClickedText2pl2();
	afx_msg void OnBnClickedText2pl3();
	afx_msg void OnBnClickedButton1();
	afx_msg void OnBnClickedDo5s();
	afx_msg void OnBnClickedDimmini();
} ;
