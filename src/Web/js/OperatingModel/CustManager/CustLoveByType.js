﻿
var pageCount = 10;//每页计数
var totalRecord = 0;//总记录数

var currentPageIndex = 1;//当前页索引
var action = "";//操作
var orderBy = "";//排序字段
var Condition="";//条件变量
        
$(document).ready(function()
{
  // TurnToPage(1);
});

//重新加载页面

function TurnToPage(pageIndex)
{
       currentPageIndex = pageIndex;
       
      // var CustName =FormatStr($("#CustName").val());//客户管理分类
       var LoveType=document.getElementById("LoveType").value;
       var StartDate =$("#StartDate").val();//客户营销分类
       var EndDate =$("#EndDate").val();//客户时间分类   
       
        if(StartDate != ""&&EndDate!= "")
        {
            if( (Date.parse(EndDate.replace(/-/g,"/"))-Date.parse(StartDate.replace(/-/g,"/")))<0)
            {
                MsgBox("开始日期不能大于结束日期");
                return;
            }
        }
        
       action="lovebytype";
       
       Condition= "orderby="+orderBy+"&LoveType="+escape(LoveType)+"&StartDate="+escape(StartDate)+"&EndDate="+escape(EndDate);
       window.location.href="?"+Condition;
       //AjaxHandle(pageIndex,action,Condition,"CustLoveList.ashx");//ajax操作
}

//返回成功数据加载
function DoData(data)
{  
    $("#pageDataList1 tbody").find("tr.newrow").remove();
    for(var i=0;i<data.list.length;i++)
    {
         $("<tr class='newrow'>"+
        "<td height='22' align='center'>" +data.list[i]["TypeName"] + "</td>"+
        "<td height='22' align='center'>" +data.list[i]["LoveCount"]+ "</td>"+
        "</tr>"
        ).appendTo($("#pageDataList1 tbody"));
    } 
}

 
//打印 
function pageSetup()
{   
    var Url =Condition;
     if(Url == "")
     {
        popMsgObj.Show("打印|","请检索数据后再打印|");
        return;
     }
    window.open("CustLoveByTypePrint.aspx?" + Url);
}