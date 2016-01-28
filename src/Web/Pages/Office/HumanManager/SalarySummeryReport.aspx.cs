﻿/**********************************************
 * 作    者： 王保军
 * 创建日期： 2009/06/10
 * 描    述：工资汇总报表
 * 修改日期： 2009/06/10
 * 版    本： 0.1.0
 ***********************************************/


using System;
using System.Data;
using XBase.Common;
using XBase.Business.Common;
using System.Web.UI.WebControls;
using XBase.Model.Office.HumanManager;
using XBase.Business.Office.HumanManager;
using CrystalDecisions.CrystalReports.Engine;
using CrystalDecisions.Shared;
public partial class Pages_Office_HumanManager_SalarySummeryReport : BasePage 
{
    protected void Page_Init(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            DataBindToDept();
            DataBindToYear();
            DataBindToMonth();
        }
        if (IsPostBack)
        {
            Search();
        }
    }
    public void DataBindToYear()
    {
        string year = string.Empty;
        int yearTemp = 2007;
        for (int i = 0; i <= 13; i++)
        {
            ddlYear.Items.Add(new ListItem((yearTemp + i).ToString() , (yearTemp + i).ToString()));
        }
        ddlYear.SelectedValue = DateTime.Now.Year.ToString();
    }
    public void DataBindToMonth()
    {
        string month = string.Empty;
        int monthTemp = DateTime.Now.Month;
        if (monthTemp < 10)
        {
            month = "0" + monthTemp.ToString();
        }
        ddlEndMonth.SelectedValue = month;
        this.ddlStartMonth.SelectedValue = month;
    }
    /// <summary>
    /// 绑定部门
    /// </summary>
    public void DataBindToDept()
    {
        DataTable dt = PerformanceQueryBus.SearchDeptInfo();

        ddlDeptName.DataSource = dt;
        ddlDeptName.DataTextField = "DeptName";
        ddlDeptName.DataValueField = "ID";
        ddlDeptName.DataBind();
        ddlDeptName.Items.Add(new System.Web.UI.WebControls.ListItem("--请选择--", "0"));
        ddlDeptName.SelectedValue = "0";
    }
    private void Search()
    {
        SalaryStandardModel searchModel = new SalaryStandardModel();
        //设置查询条件
        //岗位

        if (ddlDeptName.SelectedValue != "0")//部门
            searchModel.QuarterID = ddlDeptName.SelectedValue;
        if (this.ddlStartMonth .SelectedValue != "0")//起始月份
            searchModel.AdminLevel  = ddlStartMonth.SelectedValue;
        if (this.ddlEndMonth .SelectedValue != "0")//结束月份
            searchModel.AdminLevelName = ddlEndMonth.SelectedValue;
        if (this.ddlYear .SelectedValue != "0")//结束月份
            searchModel.UnitPrice = ddlYear.SelectedValue;
        UserInfoUtil userInfo = (UserInfoUtil)SessionUtil.Session["UserInfo"];
        //查询数据
        DataTable dtNewTable= SalaryStandardBus.SearchSalarySummaryReport(searchModel);
        DataTable dtData = new DataTable();
        dtData.Columns.Add("Remark");
        dtData.Columns.Add("itemNo");
        dtData.Columns.Add("CompanyCD");
        dtData.Columns.Add("UnitPrice");
        for (int i = 0; i < dtNewTable.Rows.Count; i++)
        {
             DataRow newRow = dtData.NewRow();
            newRow["Remark"] = getDeptName(dtNewTable.Rows[i]["Remark"] == null ? "" : dtNewTable.Rows[i]["Remark"].ToString ());
            newRow["itemNo"] = dtNewTable.Rows[i]["itemNo"] == null ? "" : dtNewTable.Rows[i]["itemNo"].ToString();
            newRow["CompanyCD"] = dtNewTable.Rows[i]["CompanyCD"] == null ? "" : dtNewTable.Rows[i]["CompanyCD"].ToString();
             newRow["UnitPrice"] = dtNewTable.Rows[i]["UnitPrice"] == null ? "" : dtNewTable.Rows[i]["UnitPrice"].ToString();
            dtData.Rows.Add(newRow);
        }


        ReportDocument oRpt = new ReportDocument();
        CrystalReportSource1.ReportDocument.Load(Server.MapPath(@"~/OperatingModel/CrystalReport/HumanManager/SalarySummeryReport.rpt"));
        // SetDatabaseLogon 拉模式中必须用这个方法来设置登录信息，参数一：用户名；参数二：密码；参数三：服务器；参数四：数据库名
        CrystalReportViewer1.LogOnInfo.Add(ReportUtil.GetTableLogOnInfo("officedba.SalaryReportSummary"));
        //查询数据
        CrystalReportSource1.ReportDocument.DataDefinition.FormulaFields["Creator"].Text = "\"" + "制表人:" + userInfo.EmployeeName + "\"";
        CrystalReportSource1.ReportDocument.DataDefinition.FormulaFields["DeptName"].Text = "\"" + "起始年月:" + ddlYear.SelectedValue + "." + ddlStartMonth.SelectedValue  + "\"";
        CrystalReportSource1.ReportDocument.DataDefinition.FormulaFields["PerformanceType"].Text = "\"" + "结束年月:" + ddlYear.SelectedValue + "." + ddlEndMonth.SelectedValue   + "\"";
        CrystalReportSource1.ReportDocument.SetDataSource(dtData);
        CrystalReportSource1.DataBind();
        // CrystalReportViewer1是水晶报表浏览器，下面是给该浏览器赋上对像
        CrystalReportViewer1.ReportSource = CrystalReportSource1;
        //CrystalReportViewer1.DataBind();


    }
    protected string getDeptName(string DeptId)
    {

        return SalaryStandardBus.GetNameByDeptID(DeptId);


    }
    protected void imgSearch_Click(object sender, System.Web.UI.ImageClickEventArgs e)
    {
        Search();
    }
}
