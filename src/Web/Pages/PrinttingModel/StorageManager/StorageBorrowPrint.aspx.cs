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
using CrystalDecisions.Shared;
using CrystalDecisions.CrystalReports.Engine;
using System.Text;
using XBase.Common;
using XBase.Model.Common;
using XBase.Business.Office.StorageManager;
using XBase.Model.Office.StorageManager;
public partial class Pages_PrinttingModel_StorageManager_StorageBorrowPrint : BasePage
{
    #region MRP ID
    public int intMrpID
    {
        get
        {
            int tempID = 0;
            int.TryParse(Request["ID"], out tempID);
            return tempID;
        }
    }
    public string intMrpNo
    {
        get
        {
            string tempNo = Request["No"].ToString();
            return tempNo;
        }
    }
    #endregion

    //protected void Page_Init(object sender, EventArgs e)
    //{
  
    //}


    protected void Page_Load(object sender, EventArgs e)
    {
        hidBillTypeFlag.Value = ConstUtil.BILL_TYPEFLAG_STORAGE;
        hidPrintTypeFlag.Value = ConstUtil.PRINTBILL_TYPEFLAG_BORROW.ToString();

        if (!IsPostBack)
        {
            LoadPrintInfo();
        }
 
    }




    #region 加载打印信息
    protected void LoadPrintInfo()
    {
        PrintParameterSettingModel model = new PrintParameterSettingModel();
        model.CompanyCD = ((UserInfoUtil)SessionUtil.Session["UserInfo"]).CompanyCD;
        model.BillTypeFlag = int.Parse(ConstUtil.BILL_TYPEFLAG_STORAGE);
        model.PrintTypeFlag = ConstUtil.PRINTBILL_TYPEFLAG_BORROW;

        StorageInitailModel OutSellM_ = new StorageInitailModel();
        OutSellM_.CompanyCD = ((UserInfoUtil)SessionUtil.Session["UserInfo"]).CompanyCD;
        OutSellM_.ID = this.intMrpID.ToString();



        /*此处需注意在模板设置表里的字段和取基本信息的字段是否一致*/
        string[,] aBase = { 
                                { "{ExtField1}", "ExtField1"},
                                { "{ExtField2}", "ExtField2"},
                                { "{ExtField3}", "ExtField3"},
                                { "{ExtField4}", "ExtField4"},
                                { "{ExtField5}", "ExtField5"},
                                { "{ExtField6}", "ExtField6"},
                                { "{ExtField7}", "ExtField7"},
                                { "{ExtField8}", "ExtField8"},
                                { "{ExtField9}", "ExtField9"},
                                { "{ExtField10}", "ExtField10"},
                                { "借货单编号", "BorrowNo"}, 
                                { "借货单主题  ", "Title"}, 
                                { "借货人", "BorrowerText" },
                                { "借货部门", "DeptName" },
                                { "借货原因", "Reason"},
                                { "借货日期", "BorrowDate"},
                                { "借出仓库 ", "SotorageName"},
                                { "出库日期 ", "OutDate"},
                                { "出库人 ", "OuterText"},
                             
                                { "借出部门", "OutDeptName"},
                                { "摘要", "Summary"},
                                { "借货数量合计 ", "CountTotal"},

                                { "借货金额合计 ", "TotalPrice"},


                                { "制单人", "CreatorText"},

                                { "制单日期", "CreateDate"},
                                { "单据状态", "BillStatusText"},
                                { "确认人", "ConfirmorText"},
                                { "确认日期", "ConfirmDate"},
                                { "结单人", "CloserText"},
                                { "结单日期", "CloseDate"},
                                { "最后更新人", "ModifiedUserID"},
                                { "最后更新日期", "ModifiedDate"},
                                { "备注", "Remark"},

                          };

        string[,] aDetail = null;

        if (!UserInfo.IsMoreUnit)
            aDetail = new string[,]{ 
                                { "序号", "SortNo"}, 
                                { "物品编号", "ProdNo"}, 
                                { "物品名称", "ProductName" },
                                {"批次","BatchNo"},
                                { "规格", "Specification" },
                                { "单位", "CodeName"},
                                { "现有存量", "UseCount"},
                                { "借出单价 ", "UnitPrice"},
                                { "借货数量 ", "ProductCount"},
                                { "借货金额 ", "TotalPrice"},
                                { "预计返还日期 ", "ReturnDate"},
                                { "预计返还数量 ", "ReturnCount"},
                                { "已返还数量 ", "RealReturnCount"},
                                { "备注", "Remark"},
                           };
        else
            aDetail = new string[,] { 
                                { "序号", "SortNo"}, 
                                { "物品编号", "ProdNo"}, 
                                { "物品名称", "ProductName" },
                                {"批次","BatchNo"},
                                { "规格", "Specification" },
                                { "基本单位", "CodeName"},
                                {"基本数量","ProductCount"},
                                {"单位","UsedUnitName"},
                                { "现有存量", "UseCount"},
                                { "借出单价 ", "UsedPrice"},
                                { "借货数量 ", "UsedUnitCount"},
                                { "借货金额 ", "TotalPrice"},
                                { "预计返还日期 ", "ReturnDate"},
                                { "预计返还数量 ", "ReturnCount"},
                                { "已返还数量 ", "RealReturnCount"},
                                { "备注", "Remark"},
                           };


        #region 1.扩展属性
        int countExt = 0;
        DataTable dtExtTable = XBase.Business.Office.SupplyChain.TableExtFieldsBus.GetAllList(((UserInfoUtil)SessionUtil.Session["UserInfo"]).CompanyCD, "", "officedba.StorageBorrow");
        if (dtExtTable.Rows.Count > 0)
        {
            for (int i = 0; i < dtExtTable.Rows.Count; i++)
            {
                for (int x = 0; x < (aBase.Length / 2) - 15; x++)
                {
                    if (x == i)
                    {
                        aBase[x, 0] = dtExtTable.Rows[i]["EFDesc"].ToString();
                        countExt++;
                    }
                }
            }
        }
        #endregion
        string No = Request.QueryString["No"].ToString();
        DataTable dbPrint = XBase.Business.Common.PrintParameterSettingBus.GetPrintParameterSettingInfo(model);
        DataTable dtMRP = StorageBorrowBus.GetStorageBorrowInfo(intMrpID);
        DataTable dtDetail = StorageBorrowBus.GetStorageBorrowDetail(OutSellM_.CompanyCD, No);
        string strBaseFields = "";
        string strDetailFields = "";


        if (dbPrint.Rows.Count > 0)
        {
            #region 设置过打印模板设置时 直接取出表里设置的值
            isSeted.Value = "1";
            strBaseFields = dbPrint.Rows[0]["BaseFields"].ToString();
            strDetailFields = dbPrint.Rows[0]["DetailFields"].ToString();
            #endregion
        }
        else
        {
            #region 未设置过打印模板设置 默认显示所有的
            isSeted.Value = "0";

            /*未设置过打印模板设置时，默认显示的字段  基本信息字段*/
            for (int m = 10; m < aBase.Length / 2; m++)
            {
                strBaseFields = strBaseFields + aBase[m, 1] + "|";
            }
            /*未设置过打印模板设置时，默认显示的字段 基本信息字段+扩展信息字段*/
            if (countExt > 0)
            {
                for (int i = 0; i < countExt; i++)
                {
                    strBaseFields = strBaseFields + "ExtField" + (i + 1) + "|";
                }
            }
            /*未设置过打印模板设置时，默认显示的字段 明细信息字段*/
            for (int n = 0; n < aDetail.Length / 2; n++)
            {
                strDetailFields = strDetailFields + aDetail[n, 1] + "|";
            }
            #endregion
        }

        #region 2.主表信息
        if (!string.IsNullOrEmpty(strBaseFields))
        {
            tableBase.InnerHtml = WritePrintPageTable("借货申请单", strBaseFields.TrimEnd('|'), strDetailFields.TrimEnd('|'), aBase, aDetail, dtMRP, dtDetail, true);
        }
        #endregion

        #region 3.明细信息
        if (!string.IsNullOrEmpty(strDetailFields))
        {
            tableDetail.InnerHtml = WritePrintPageTable("借货申请单", strBaseFields.TrimEnd('|'), strDetailFields.TrimEnd('|'), aBase, aDetail, dtMRP, dtDetail, false);
        }
        #endregion

    }
    #endregion

    #region 导出
    protected void btnImport_Click(object sender, EventArgs e)
    {
        System.IO.StringWriter tw = new System.IO.StringWriter();
        System.Web.UI.HtmlTextWriter hw = new System.Web.UI.HtmlTextWriter(tw);
        Response.Clear();
        Response.Charset = "gb2312";
        Response.ContentType = "application/vnd.ms-excel";
        Response.ContentEncoding = System.Text.Encoding.GetEncoding("gb2312");
        Response.AppendHeader("Content-Disposition", "attachment;filename=" + System.Web.HttpUtility.UrlEncode("借货申请单") + ".xls");
        Response.Write("<html><head><META http-equiv=\"Content-Type\" content=\"text/html; charset=gb2312\"></head><body>");
        Response.Write(hiddExcel.Value);
        Response.Write(tw.ToString());
        Response.Write("</body></html>");
        Response.End();
        hw.Close();
        hw.Flush();
        tw.Close();
        tw.Flush();
    }
    #endregion
}
