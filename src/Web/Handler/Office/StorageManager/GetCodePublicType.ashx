﻿<%@ WebHandler Language="C#" Class="GetCodePublicType" %>

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
using XBase.Model.Office.StorageManager;
using XBase.Business.Office.StorageManager;
public class GetCodePublicType : IHttpHandler, System.Web.SessionState.IRequiresSessionState
{
    
    public void ProcessRequest (HttpContext context) {
        if (context.Request.RequestType == "POST")
        {
            string orderString = (context.Request.Form["orderby"].ToString());//排序
            string order = "ascending";//排序：升序
            string orderBy = (!string.IsNullOrEmpty(orderString)) ? orderString.Substring(0, orderString.Length - 2) : "ID";//要排序的字段，如果为空，默认为"ID"
            if (orderString.EndsWith("_d"))
            {
                order = "descending";//排序：降序
            }
         //   int pageCount = int.Parse(context.Request.Form["pageCount"].ToString());//每页显示记录数
           // int pageIndex = int.Parse(context.Request.Form["pageIndex"].ToString());//当前页
            //int skipRecord = (pageIndex - 1) * pageCount;//跳过记录数

            XElement dsXML = ConvertDataTableToXML(CheckReportBus.GetCodePublicType());
            
            var dsLinq =
                (order == "ascending") ?
                (from x in dsXML.Descendants("Data")
                 orderby x.Element(orderBy).Value ascending
                 select new DataSourceModel()
                 {
                     ID = x.Element("ID").Value,
                    
                     TypeName = x.Element("TypeName").Value,
                 })
                          :
                (from x in dsXML.Descendants("Data")
                 orderby x.Element(orderBy).Value descending
                 select new DataSourceModel()
                 {
                     ID = x.Element("ID").Value,
                     
                     TypeName = x.Element("TypeName").Value,
                               });
            int totalCount = dsLinq.Count();
            System.Text.StringBuilder sb = new System.Text.StringBuilder();
            sb.Append("{");
            sb.Append("totalCount:");
            sb.Append(totalCount.ToString());
            sb.Append(",data:");
            sb.Append(ToJSON(dsLinq.ToList()));
            sb.Append("}");

            context.Response.ContentType = "text/plain";
            context.Response.Write(sb.ToString());
            context.Response.End();
        }
    }
    //数据源结构
    public class DataSourceModel
    {
        public string ID { get; set; }         //
        public string TypeName { get; set; }      //
        

        
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
    public bool IsReusable {
        get {
            return false;
        }
    }

}