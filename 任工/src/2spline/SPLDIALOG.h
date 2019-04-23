#pragma once
#include "afxwin.h"

#include "resource.h"

// CSPLDIALOG 对话框

class CSPLDIALOG : public CDialog
{
	DECLARE_DYNAMIC(CSPLDIALOG)

public:
	CSPLDIALOG(CWnd* pParent = NULL);   // 标准构造函数
	virtual ~CSPLDIALOG();

// 对话框数据
	enum { IDD = IDD_SPLDIALOG };

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV 支持

	DECLARE_MESSAGE_MAP()
public:
	int iSel;
	CComboBox m_combox1;
	afx_msg void OnBnClickedOk();
	virtual BOOL OnInitDialog();
};
