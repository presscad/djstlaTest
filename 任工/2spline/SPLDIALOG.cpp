// SPLDIALOG.cpp : 实现文件
//

#include "stdafx.h"
#include "starmask.h"
#include "SPLDIALOG.h"


// CSPLDIALOG 对话框

IMPLEMENT_DYNAMIC(CSPLDIALOG, CDialog)
CSPLDIALOG::CSPLDIALOG(CWnd* pParent /*=NULL*/)
	: CDialog(CSPLDIALOG::IDD, pParent)
{
}

CSPLDIALOG::~CSPLDIALOG()
{
}

void CSPLDIALOG::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	DDX_Control(pDX, IDC_COMBO1, m_combox1);
}

BEGIN_MESSAGE_MAP(CSPLDIALOG, CDialog)
	ON_BN_CLICKED(IDOK, OnBnClickedOk)
END_MESSAGE_MAP()

// CSPLDIALOG 消息处理程序

void CSPLDIALOG::OnBnClickedOk()
{
	OnOK();
	UpdateData();
	iSel=m_combox1.GetCurSel();
}

BOOL CSPLDIALOG::OnInitDialog()
{
	CDialog::OnInitDialog();
	m_combox1.SetCurSel(8);
	return TRUE;  
}
