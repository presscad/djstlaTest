#pragma once
#include "afxwin.h"

#include "resource.h"

// CSPLDIALOG �Ի���

class CSPLDIALOG : public CDialog
{
	DECLARE_DYNAMIC(CSPLDIALOG)

public:
	CSPLDIALOG(CWnd* pParent = NULL);   // ��׼���캯��
	virtual ~CSPLDIALOG();

// �Ի�������
	enum { IDD = IDD_SPLDIALOG };

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV ֧��

	DECLARE_MESSAGE_MAP()
public:
	int iSel;
	CComboBox m_combox1;
	afx_msg void OnBnClickedOk();
	virtual BOOL OnInitDialog();
};
