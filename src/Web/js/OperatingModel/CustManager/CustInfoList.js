﻿    var pageCount = 10;//每页计数
    var totalRecord = 0;
    var pagerStyle = "flickr";//jPagerBar样式
    
    var currentPageIndex = 1;
    var action = "";//操作
    var orderBy = "";//排序字段
    var ifdel="0";//是否删除
        
$(document).ready(function()
{
    alerCustType();
});

function SearchCustData(aa)
{
    //search="1";
    TurnToPage(aa);
}

//jQuery-ajax获取JSON数据
function TurnToPage(pageIndex)
{
       currentPageIndex = pageIndex;
       
       var CustTypeManage = document.getElementById("SeleCustTypeManage").value;//客户管理分类
       var CustTypeSell = document.getElementById("SeleCustTypeSell").value;//客户营销分类
       var CustTypeTime = document.getElementById("SeleCustTypeTime").value;//客户时间分类       
       var CustType =document.getElementById("ddlCustType").value;       
       var CustClass =document.getElementById("CustClassDrpControl1_CustClassHidden").value;//客户细分
       var CreditGrade =document.getElementById("ddlCreditGrade").value;//客户优质级别       
       var RelaGrade = document.getElementById("seleRelaGrade").value; //客户关系等级 
       var AreaID =document.getElementById("ddlArea").value;//所在区域      
       var ManagerID =document.getElementById("txtManager").value;//分管业务员
       
       document.getElementById("hdPara").value = "orderby="+orderBy+"&CustTypeManage="+escape(CustTypeManage)+
            "&CustTypeSell="+escape(CustTypeSell)+"&CustTypeTime="+escape(CustTypeTime)+"&CustType="+escape(CustType)+"&CustClass="+escape(CustClass)+
            "&CreditGrade="+escape(CreditGrade)+"&AreaID="+escape(AreaID)+"&RelaGrade="+escape(RelaGrade)+"&ManagerID="+escape(ManagerID);
      
       $.ajax({
       type: "POST",//用POST方式传输
       dataType:"json",//数据格式:JSON
       url:  '../../../Handler/OperatingModel/CustManager/CustInfoList.ashx',//目标地址
       cache:false,
       data: "pageIndex="+pageIndex+"&pageCount="+pageCount+"&action="+action+"&orderby="+orderBy+"&CustTypeManage="+escape(CustTypeManage)+
            "&CustTypeSell="+escape(CustTypeSell)+"&CustTypeTime="+escape(CustTypeTime)+"&CustType="+escape(CustType)+"&CustClass="+escape(CustClass)+
            "&CreditGrade="+escape(CreditGrade)+"&AreaID="+escape(AreaID)+"&RelaGrade="+escape(RelaGrade)+"&ManagerID="+escape(ManagerID),//数据
       beforeSend:function(){AddPop();$("#pageDataList1_Pager").hide();},//发送数据之前
       
       success: function(msg){
       
                //数据获取完毕，填充页面据显示
                //数据列表
                $("#pageDataList1 tbody").find("tr.newrow").remove();
                var RelaGrade;
                $.each(msg.data,function(i,item){
                  if(item.ID != null && item.ID != "")
                 { //alert(item.ID);
                    $("<tr class='newrow'></tr>").append("<td height='22' align='center'>" + item.CustNo + "</td>"+
                    "<td height='22' align='center'>" + item.CustName + "</td>"+
                    "<td height='22' align='center'>"+ item.CustTypeManage +"</td>"+
                    "<td height='22' align='center'>" + item.CustTypeSell + "</td>"+
                    "<td height='22' align='center'>" + item.CustTypeTime + "</td>"+
                    "<td height='22' align='center'>" + item.CustTypeName + "</td>"+
                    "<td height='22' align='center'>" + item.CustClassName + "</td>"+
                    "<td height='22' align='center'>" + item.CreditGradeName + "</td>"+
                    "<td height='22' align='center'>" + item.RelaGrade + "</td>"+
                    "<td height='22' align='center'>" + item.Area + "</td>"+
                    "<td height='22' align='center'>" + item.Province + "</td>"+
                    "<td height='22' align='center'>" + item.City + "</td>"+
                    "<td height='22' align='center'>" + item.ManagerName + "</td>"+
                    "<td height='22' align='center'>" + item.ContactName + "</td>"+
                    "<td height='22' align='center'>" + item.Tel + "</td>"+
                    "<td height='22' align='center'>" + item.CreatorName + "</td>"+                   
                    "<td height='22' align='center'>"+item.CreatedDate+"</td>").appendTo($("#pageDataList1 tbody"));}
               });
               
                //页码
               ShowPageBar("pageDataList1_Pager",//[containerId]提供装载页码栏的容器标签的客户端ID
               "<%= Request.Url.AbsolutePath %>",//[url]
                {style:pagerStyle,mark:"pageDataList1Mark",
                totalCount:msg.totalCount,showPageNumber:3,pageCount:pageCount,currentPageIndex:pageIndex,noRecordTip:"没有符合条件的记录",preWord:"上一页",nextWord:"下一页",First:"首页",End:"末页",
                onclick:"TurnToPage({pageindex});return false;"}//[attr]
                );
              totalRecord = msg.totalCount;
             // $("#pageDataList1_Total").html(msg.totalCount);//记录总条数
              document.getElementById("Text2").value=msg.totalCount;
              $("#ShowPageCount").val(pageCount);
              ShowTotalPage(msg.totalCount,pageCount,pageIndex,$("#pagecount"));
              $("#ToPage").val(pageIndex);
              },
       error: function() 
       {
            showPopup("../../../Images/Pic/Close.gif","../../../Images/Pic/note.gif","请求发生错误！");
       }, 
       complete:function(){if(ifdel=="0"){hidePopup();}$("#pageDataList1_Pager").show();Ifshow(document.getElementById("Text2").value);pageDataList1("pageDataList1","#E7E7E7","#FFFFFF","#cfc","cfc");}//接收数据完毕
       });
}

//table行颜色
function pageDataList1(o,a,b,c,d){
	var t=document.getElementById(o).getElementsByTagName("tr");
	for(var i=0;i<t.length;i++){
		t[i].style.backgroundColor=(t[i].sectionRowIndex%2==0)?a:b;
		t[i].onmouseover=function(){
			if(this.x!="1")this.style.backgroundColor=c;
		}
		t[i].onmouseout=function(){
			if(this.x!="1")this.style.backgroundColor=(this.sectionRowIndex%2==0)?a:b;
		}
	}
}

function Ifshow(count)
{
    if(count=="0")
    {
        document.getElementById("divpage").style.display = "none";
        document.getElementById("pagecount").style.display = "none";
    }
    else
    {
        document.getElementById("divpage").style.display = "block";
        document.getElementById("pagecount").style.display = "block";
    }
}

//改变每页记录数及跳至页数
function ChangePageCountIndex(newPageCount,newPageIndex)
{
    if(!PositiveInteger(newPageCount))
    {
        showPopup("../../../Images/Pic/Close.gif","../../../Images/Pic/note.gif","每页显示应为正整数！");
        return;
    } 
    if(!PositiveInteger(newPageIndex))
    {
        showPopup("../../../Images/Pic/Close.gif","../../../Images/Pic/note.gif","转到页数应为正整数！");
        return;
    } 

    if(newPageCount <=0 || newPageIndex <= 0 ||  newPageIndex  > ((totalRecord-1)/newPageCount)+1 )
    {
        showPopup("../../../Images/Pic/Close.gif","../../../Images/Pic/note.gif","转到页数超出查询范围！");
        return false;
    }
    else
    {
        ifdel = "0";
        this.pageCount=parseInt(newPageCount);
        TurnToPage(parseInt(newPageIndex));
    }
}
    //排序
    function OrderBy(orderColum,orderTip)
    {
        if (totalRecord == 0) 
     {
        return;
     }
        ifdel = "0";
        var ordering = "a";
        //var orderTipDOM = $("#"+orderTip);
        var allOrderTipDOM  = $(".orderTip");
        if( $("#"+orderTip).html()=="↓")
        {
             allOrderTipDOM.empty();
             $("#"+orderTip).html("↑");
        }
        else
        {
            ordering = "d";
            allOrderTipDOM.empty();
            $("#"+orderTip).html("↓");
        }
        orderBy = orderColum+"_"+ordering;
        $("#hiddExpOrder").val(orderBy);
        TurnToPage(1);
    }
    
//打印 
function pageSetup()
{   
    var Url = $("#hdPara").val();
     if(Url == "")
     {
        popMsgObj.Show("打印|","请检索数据后再预览|");
        return;
     }
    window.open("CustInfoListPrint.aspx?" + Url);
}