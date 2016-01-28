﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using XBase.Common;
using System.Data;
using System.Data.SqlClient;
using XBase.Business.Office.SellManager;


public partial class Pages_Office_SellManager_SellChannelSttlMod : BasePage
{
    //小数精度
    private int _selPoint = 2;
    public int SelPoint
    {
        get
        {
            return _selPoint;
        }
        set
        {
            _selPoint = value;
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
           
           
            FlowApply1.BillTypeFlag = ConstUtil.CODING_RULE_SELL;
            FlowApply1.BillTypeCode = ConstUtil.CODING_RULE_SELLCHANNELSTTL_NO;
           
            PayTypeUC.TypeFlag = ConstUtil.CUST_TYPE_CUST;//结算方式
            PayTypeUC.TypeCode = ConstUtil.CUST_INFO_PAYTYPE;//结算方式
            PayTypeUC.IsInsertSelect = true;
            MoneyTypeUC.IsInsertSelect = true;
            MoneyTypeUC.TypeFlag = ConstUtil.CUST_TYPE_CUST;
            MoneyTypeUC.TypeCode = ConstUtil.CUST_INFO_MONEYTYPE;
            SttlDate.Text = DateTime.Now.ToString("yyyy-MM-dd");
            //是否启用多单位
            if (UserInfo.IsMoreUnit)
            {
                txtIsMoreUnit.Value = "1";
                BaseUnitD.Visible = true;
                BaseCountD.Visible = true;
            }
            else
            {
                txtIsMoreUnit.Value = "0";
                BaseUnitD.Visible = false;
                BaseCountD.Visible = false;
            }
            // 小数位数
            _selPoint = int.Parse(UserInfo.SelPoint);
        }

    }
}
