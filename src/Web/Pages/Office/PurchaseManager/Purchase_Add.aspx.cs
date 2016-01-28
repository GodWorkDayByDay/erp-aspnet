﻿using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using XBase.Common;
using XBase.Model.Office.PurchaseManager;
using XBase.Business.Office.PurchaseManager;
using System.Web.UI.WebControls;

namespace XBase.Pages.Office.PurchaseManager
{
    public partial class Purchase_Add : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                //临时注释
                //txtCreator.Text = ((UserInfoUtil)SessionUtil.Session["UserInfo"]).UserID;
                //临时注释
                //txtModifiedUserID.Text = ((UserInfoUtil)SessionUtil.Session["UserInfo"]).UserID;


                //临时适用变量
                txtCreator.Value = "1";
                txtModifiedUserID.Value = "1";
                txtCreateDate.Value = DateTime.Now.ToShortDateString();
                txtModifiedDate.Value = DateTime.Now.ToShortDateString();



                CodingRuleControl1.CodingType = ConstUtil.CODING_RULE_PURCHASE;
                CodingRuleControl1.ItemTypeID = ConstUtil.CODING_RULE_PURCHASE_APPLY;

                string codevalue = CodingRuleControl1.CodeValue;
            }
        }
    }
}