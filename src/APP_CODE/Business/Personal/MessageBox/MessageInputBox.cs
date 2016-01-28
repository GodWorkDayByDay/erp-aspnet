using System;
using System.Data;
using System.Data.SqlClient;
using XBase.Data.DBHelper;
using System.Collections.Generic;

namespace XBase.Business.Personal.MessageBox
{
	/// <summary>
	/// 业务逻辑类MessageInputBox 的摘要说明。
	/// </summary>
	public class MessageInputBox
	{
		private readonly XBase.Data.Personal.MessageBox.MessageInputBox dal=new XBase.Data.Personal.MessageBox.MessageInputBox();
		public MessageInputBox()
		{}
		#region  成员方法

		

		/// <summary>
		/// 是否存在该记录
		/// </summary>
		public bool Exists(int ID)
		{
			return dal.Exists(ID);
		}

		/// <summary>
		/// 增加一条数据
		/// </summary>
		public int  Add(XBase.Model.Personal.MessageBox.MessageInputBox model)
		{
			return dal.Add(model);
		}

		/// <summary>
		/// 更新一条数据
		/// </summary>
		public void Update(XBase.Model.Personal.MessageBox.MessageInputBox model)
		{
			dal.Update(model);
		}

		/// <summary>
		/// 删除一条数据
		/// </summary>
		public void Delete(int ID)
		{
			
			dal.Delete(ID);
		}

		/// <summary>
		/// 得到一个对象实体
		/// </summary>
		public XBase.Model.Personal.MessageBox.MessageInputBox GetModel(int ID)
		{
			
			return dal.GetModel(ID);
		}

		/// <summary>
		/// 获得数据列表
		/// </summary>
		public DataTable GetList(string strWhere)
		{
			return dal.GetList(strWhere);
		}
		
		/// <summary>
		/// 获得数据列表
		/// </summary>
        public DataTable GetAllList()
		{
			return GetList("");
		}

		/// <summary>
		/// 获得数据列表
		/// </summary>
		//public DataSet GetList(int PageSize,int PageIndex,string strWhere)
		//{
			//return dal.GetList(PageSize,PageIndex,strWhere);
		//}


        /// <summary>
        /// GetPageData
        /// </summary>    
        /// <param name="where"></param>
        /// <param name="fields"></param>
        /// <param name="orderExp"></param>
        /// <param name="pageindex"></param>
        /// <param name="pagesize"></param>
        /// <returns></returns>
        public int GetPageData(out DataTable dt, string where, string fields, string orderExp, int pageindex, int pagesize)
        {
            return dal.GetPageData(out dt, where, fields, orderExp, pageindex, pagesize);
        }

        public DataTable GetDeskTopData(int eid) {
            string sqlstr = " select  *,officedba.getEmployeeNameByID(SendUserID) as SendUserName  from   officedba.MessageInputBox  where  ReceiveUserID =@eid   and   Status='0'  ";
            SqlCommand comm = new SqlCommand();
            comm.CommandText = sqlstr;
            comm.Parameters.AddWithValue("@eid", SqlDbType.Int);
            comm.Parameters["@eid"].Value = eid;
            return SqlHelper.ExecuteSearch(comm);
        }


		#endregion  成员方法
	}
}

