﻿/**********************************************
 * 类作用：   个人所得税税率
 * 建立人：   王保军
 * 建立时间： 2009/06/20
 * 修改人：   王保军
 * 建立时间： 2009/08/27
 ***********************************************/

using System;
using XBase.Model.Office.HumanManager;
using System.Text;
using XBase.Data.DBHelper;
using System.Data.SqlClient;
using System.Data;
using System.Data.SqlTypes;
using XBase.Common;
using System.Collections;
using System.Collections.Generic;
namespace XBase.Data.Office.HumanManager
{
   public   class InputPersonTrueIncomeTaxDBHelper
    {
       public static DataTable SearchPersonTaxInfo(string companyCD)
       {

           #region 查询语句
           StringBuilder searchSql = new StringBuilder();
           searchSql.AppendLine(" SELECT                  ");
           searchSql.AppendLine(" 	 ID                    ");
           searchSql.AppendLine(" 	,CompanyCD         ");
           searchSql.AppendLine(" 	,EmployeeID          ");
           searchSql.AppendLine(" 	,StartDate        ");
           searchSql.AppendLine(" 	,SalaryCount         ");
           searchSql.AppendLine(" 	,TaxPercent            ");
           searchSql.AppendLine(" 	,TaxCount            ");
           searchSql.AppendLine(" FROM                    ");
           searchSql.AppendLine(" 	officedba.IncomeTax   ");
           searchSql.AppendLine(" WHERE                   ");
           searchSql.AppendLine(" 	CompanyCD = @CompanyCD ");
           #endregion

           //定义查询的命令
           SqlCommand comm = new SqlCommand();
           //公司代码
           comm.Parameters.Add(SqlHelper.GetParameterFromString("@CompanyCD", companyCD));

           //指定命令的SQL文
           comm.CommandText = searchSql.ToString();
           //执行查询
           return SqlHelper.ExecuteSearch(comm);
       }
       public static DataTable SearchPersonTax(string companyCD,string reportMonth)
       { 
           int year = Convert.ToInt32(reportMonth.Substring(0, 4));
           int month = Convert.ToInt32(reportMonth.Substring(4, 2));
           int day=0;
           if (month ==1||month ==3||month ==5||month ==7||month ==8||month ==10||month ==12)
           {
               day=31;
           }
           if (month ==2)
           {
               day=28;
           }else
           {
               day=30;
           }

           DateTime reportM = new DateTime(year, month, day);
           #region 查询语句
           StringBuilder searchSql = new StringBuilder();
           searchSql.AppendLine(" SELECT                  ");
           searchSql.AppendLine(" 	 ID                    ");
           searchSql.AppendLine(" 	,CompanyCD         ");
           searchSql.AppendLine(" 	,EmployeeID          ");
           searchSql.AppendLine(" 	,StartDate        ");
           searchSql.AppendLine(" 	,SalaryCount         ");
           searchSql.AppendLine(" 	,TaxPercent            ");
           searchSql.AppendLine(" 	,TaxCount            ");
           searchSql.AppendLine(" FROM                    ");
           searchSql.AppendLine(" 	officedba.IncomeTax   ");
           searchSql.AppendLine(" WHERE                   ");
           searchSql.AppendLine(" 	CompanyCD = @CompanyCD ");
           searchSql.AppendLine("  and 	@StartDate >= StartDate ");
           #endregion

           //定义查询的命令
           SqlCommand comm = new SqlCommand();
           //公司代码
           comm.Parameters.Add(SqlHelper.GetParameterFromString("@CompanyCD", companyCD));
           comm.Parameters.Add(SqlHelper.GetParameterFromString("@StartDate", reportM .ToShortDateString ()));

           //指定命令的SQL文
           comm.CommandText = searchSql.ToString();
           //执行查询
           return SqlHelper.ExecuteSearch(comm);
       }
       public static DataTable PersonTaxInfo(string companyCD)
       {

           #region 查询语句
           StringBuilder searchSql = new StringBuilder();
           searchSql.AppendLine(" SELECT                  ");
           searchSql.AppendLine(" 	MinMoney                    ");
           searchSql.AppendLine(" 	,MaxMoney         ");
           searchSql.AppendLine(" 	,TaxPercent          ");
           searchSql.AppendLine(" 	,MinusMoney        ");
           searchSql.AppendLine(" FROM                    ");
           searchSql.AppendLine(" 	officedba.IncomeTaxPercent   ");
           searchSql.AppendLine(" WHERE                   ");
           searchSql.AppendLine(" 	CompanyCD = @CompanyCD ");
           #endregion

           //定义查询的命令
           SqlCommand comm = new SqlCommand();
           //公司代码
           comm.Parameters.Add(SqlHelper.GetParameterFromString("@CompanyCD", companyCD));

           //指定命令的SQL文
           comm.CommandText = searchSql.ToString();
           //执行查询
           return SqlHelper.ExecuteSearch(comm);
       }
       public static bool UpdateIsuPersonalTaxInfo(IList<PersonTrueIncomeTaxModel> modeList)
       {
           if (!DeletePersonalTaxInfo(modeList[0].CompanyCD))
           {
               return false;
           }
           bool isSucc = false;
           foreach (PersonTrueIncomeTaxModel model in modeList)
           {
               #region 插入SQL拼写
               StringBuilder insertSql = new StringBuilder();
               insertSql.AppendLine("insert into  officedba.IncomeTax(CompanyCD,EmployeeID,StartDate,SalaryCount,TaxPercent,TaxCount,ModifiedDate,ModifiedUserID) ");
               insertSql.AppendLine("          values(@CompanyCD,@EmployeeID,@StartDate,@SalaryCount,@TaxPercent,@TaxCount,getdate(),@ModifiedUserID) ");
               #endregion
               //定义插入基本信息的命令
               SqlCommand comm = new SqlCommand();
               comm.CommandText = insertSql.ToString();
               //设置保存的参数
               comm.Parameters.Add(SqlHelper.GetParameterFromString("@CompanyCD", model.CompanyCD));	//公司代码
               comm.Parameters.Add(SqlHelper.GetParameterFromString("@EmployeeID", model.EmployeeID ));	//创建人
               comm.Parameters.Add(SqlHelper.GetParameterFromString("@StartDate ", model.StartDate ));	//启用状态
               comm.Parameters.Add(SqlHelper.GetParameterFromString("@SalaryCount", model.SalaryCount ));	//启用状态
               comm.Parameters.Add(SqlHelper.GetParameterFromString("@TaxPercent", model.TaxPercent ));	//启用状态
               comm.Parameters.Add(SqlHelper.GetParameterFromString("@TaxCount", model.TaxCount ));
               comm.Parameters.Add(SqlHelper.GetParameterFromString("@ModifiedUserID", model.ModifiedUserID ));
               //添加返回参数
               //   comm.Parameters.Add(SqlHelper.GetOutputParameter("@ElemID", SqlDbType.Int));

               //执行插入操作
               isSucc = SqlHelper.ExecuteTransWithCommand(comm);
               if (!isSucc)
               {
                   isSucc = false;
                   break;
               }
               else
               {
                   continue;
               }
           }
           return isSucc;

       }

       public static bool DeletePersonalTaxInfo(string CompanyCD)
       {
           StringBuilder insertSql = new StringBuilder();
           insertSql.AppendLine("Delete from officedba.IncomeTax where CompanyCD=@CompanyCD");

           //定义插入基本信息的命令
           SqlCommand comm = new SqlCommand();
           comm.CommandText = insertSql.ToString();
           //设置保存的参数
           comm.Parameters.Add(SqlHelper.GetParameterFromString("@CompanyCD", CompanyCD));	//公司代码
           //添加返回参数
           //   comm.Parameters.Add(SqlHelper.GetOutputParameter("@ElemID", SqlDbType.Int));

           //执行插入操作
           bool isSucc = SqlHelper.ExecuteTransWithCommand(comm);
           return isSucc;


       }



    }
}
