﻿using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;
using XBase.Common;

public partial class Pages_Office_SellManager_SellChance_Add : BasePage
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
           
                ////临时注释
                Creator.Text = ((UserInfoUtil)SessionUtil.Session["UserInfo"]).EmployeeName.ToString();
                ////临时注释
                ModifiedUserID.Text = ((UserInfoUtil)SessionUtil.Session["UserInfo"]).UserID.ToString();
                UserSeller.Value = ((UserInfoUtil)SessionUtil.Session["UserInfo"]).EmployeeName.ToString();
                hiddSeller.Value = ((UserInfoUtil)SessionUtil.Session["UserInfo"]).EmployeeID.ToString();
          

            CreateDate.Text = DateTime.Now.ToString("yyyy-MM-dd");
            ModifiedDate.Text = DateTime.Now.ToString("yyyy-MM-dd");
          
            SellChanceUC.CodingType = ConstUtil.CODING_RULE_SELL;//销售类别单据
            SellChanceUC.ItemTypeID = ConstUtil.CODING_RULE_SELLCHANCE_NO;//销售机会编号

            chanceTypeUC.TypeFlag = ConstUtil.SELL_TYPE_SELL;//销售机会类型
            chanceTypeUC.TypeCode = ConstUtil.SELL_TYPE_CHANCETYPE;//销售机会类型
            chanceTypeUC.IsInsertSelect = true;

            FeasibilityUC.TypeFlag = ConstUtil.SELL_TYPE_SELL;//销售机会可能性
            FeasibilityUC.TypeCode = ConstUtil.SELL_TYPE_FEASIBILITY;//销售机会可能性
            FeasibilityUC.IsInsertSelect = true;

            HapSourceUC.TypeFlag = ConstUtil.SELL_TYPE_SELL;//销售机会来源
            HapSourceUC.TypeCode = ConstUtil.SELL_TYPE_HAPSOURCE;//销售机会来源
            HapSourceUC.IsInsertSelect = true;
            // 小数位数
            _selPoint = int.Parse(UserInfo.SelPoint);

            //当前时间
            hiddCurenctTime.Value = DateTime.Now.ToString("yyyy-MM-dd HH:mm");
        }
    }
}
