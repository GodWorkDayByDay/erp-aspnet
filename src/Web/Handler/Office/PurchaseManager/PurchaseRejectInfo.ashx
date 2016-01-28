﻿<%@ WebHandler Language="C#" Class="PurchaseRejectInfo" %>

using System;
using System.Web;
using System.Collections;
using System.Data;
using System.Linq;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Xml.Linq;
using System.Web.Script.Serialization;
using System.IO;
using XBase.Common;
using XBase.Business.Office.PurchaseManager;
using XBase.Model.Office.PurchaseManager;
using System.Web.SessionState;
using System.Text;

public class PurchaseRejectInfo : IHttpHandler, IRequiresSessionState
{

    public void ProcessRequest(HttpContext context)
    {
        HttpRequest request = context.Request;
        if (context.Request.RequestType == "POST")
        {
            int User = ((UserInfoUtil)SessionUtil.Session["UserInfo"]).EmployeeID;
            string Action = context.Request.Params["Action"];

            if (Action == "Delete")
            {

                string DetailNo = context.Request.Params["DetailNo"].ToString().Trim();
                DetailNo = DetailNo.Remove(DetailNo.Length - 1, 1);
                JsonClass JC;
                if (PurchaseRejectBus.DeletePurchaseRejectAll(DetailNo))
                    JC = new JsonClass("success", "", 1);
                else
                    JC = new JsonClass("faile", "", 0);
                context.Response.Write(JC);


            }

            else
            {

                //设置行为参数
                string orderString = (context.Request.Form["orderby"].ToString());//排序
                string order = "DESC";//排序：升序
                string orderBy = (!string.IsNullOrEmpty(orderString)) ? orderString.Substring(0, orderString.Length - 2) : "ModifiedDate";//要排序的字段，如果为空，默认为"ID"
                if (orderString.EndsWith("_a"))
                {
                    order = "ASC";//排序：降序
                }
                int pageCount = int.Parse(context.Request.Form["pageCount"].ToString());//每页显示记录数
                int pageIndex = int.Parse(context.Request.Form["pageIndex"].ToString());//当前页
                int skipRecord = (pageIndex - 1) * pageCount;//跳过记录数

                string RejectNo = context.Request.Form["RejectNo"];
                string Title = context.Request.Form["Title"];
                string TypeID = context.Request.Form["TypeID"];
                string Purchaser = context.Request.Form["Purchaser"];
                string FromType = context.Request.Form["FromType"];
                string ProviderID = context.Request.Form["ProviderID"];
                string BillStatus = context.Request.Form["BillStatus"];
                string UsedStatus = context.Request.Form["UsedStatus"];
                string DeptID = context.Request.Form["DeptID"];
                string ProjectID = context.Request.Form["ProjectID"];
                string EFDesc = context.Request.Form["EFDesc"];
                string EFIndex = context.Request.Form["EFIndex"];


                int TotalCount = 0;
                orderBy = orderBy + " " + order;
                context.Response.ContentType = "text/plain";
                DataTable dt = PurchaseRejectBus.SelectPurchaseReject(pageIndex, pageCount, orderBy, ref TotalCount, RejectNo, Title, TypeID, Purchaser, FromType, ProviderID, BillStatus, UsedStatus, DeptID, ProjectID, EFIndex, EFDesc);

                StringBuilder sb = new StringBuilder();
                if (dt.Rows.Count == 0)
                {
                    sb.Append("{");
                    sb.Append("totalCount:");
                    sb.Append(TotalCount.ToString());
                    sb.Append(",data:");
                    sb.Append("0");
                    sb.Append("}");
                }
                else
                    sb.Append(JsonClass.FormatDataTableToJson(dt, TotalCount));
                context.Response.Write(sb.ToString());
                context.Response.End();
            }
        }
    }
    /// <summary>
    /// datatabletoxml
    /// </summary>
    /// <param name="xmlDS"></param>
    /// <returns></returns>
    private XElement ConvertDataTableToXML(DataTable xmlDS)
    {
        StringWriter sr = new StringWriter();
        xmlDS.TableName = "Data";
        xmlDS.WriteXml(sr, System.Data.XmlWriteMode.IgnoreSchema, true);
        string contents = sr.ToString();
        return XElement.Parse(contents);
    }

    public static string ToJSON(object obj)
    {
        JavaScriptSerializer serializer = new JavaScriptSerializer();
        return serializer.Serialize(obj);
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

    ////数据源结构
    //public class DataSourceModel
    //{
    //    public string ID { get; set; }
    //    public string RejectNo { get; set; }
    //    public string Title { get; set; }
    //    public string TypeID { get; set; }
    //    public string TypeName { get; set; }
    //    public string Purchaser { get; set; }
    //    public string PurchaserName { get; set; }
    //    public string FromType { get; set; }
    //    public string FromTypeName { get; set; }
    //    public string ProviderID { get; set; }
    //    public string ProviderName { get; set; }
    //    public string TotalYthkhj { get; set; }
    //    public string DeptID { get; set; }
    //    public string DeptName { get; set; }
    //    public string BillStatus { get; set; }
    //    public string UsedStatus { get; set; }
    //    public string Isyinyong { get; set; }
    //}

}