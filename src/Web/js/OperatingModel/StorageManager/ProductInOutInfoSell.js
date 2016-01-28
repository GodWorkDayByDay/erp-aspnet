﻿$(document).ready(function(){

      fnGetExtAttr();//物品控件拓展属性
    });  
    /*
* 查询
*/
function DoSearch(currPage)
{
   //$("#btnPrint").css("display", "inline"); 
   var fieldText = "";
   var msgText = "";
   var isFlag = true;

           var txtProductNo=$("#txtProductNo").val();
           var txtProductName=$("#txtProductName").val();
           var txtStartDate=$("#txtStartDate").val();
           var txtEndDate=$("#txtEndDate").val();
           var RBLType=$("#RBLType").val();
           
           var RetVal=CheckSpecialWords();
            if(RetVal!="")
            {
                    isFlag = false;
                    fieldText = fieldText + RetVal+"|";
	                msgText = msgText +RetVal+  "不能含有特殊字符|";
            }
            if(txtProductNo=="")
            {
                isFlag=false;
                fieldText=fieldText + "物品编号|";
                msgText =msgText+"请选择物品|";
            }
            if(txtStartDate=="")
            {
                isFlag=false;
                fieldText=fieldText + "起始时间|";
                msgText =msgText+"请选择起始时间|";
            }
            if(txtEndDate=="")
            {
                isFlag=false;
                fieldText=fieldText + "终止时间|";
                msgText =msgText+"请选择终止时间|";
            }
           if(CompareDate(txtStartDate, txtEndDate)==1)
           {
                isFlag=false;
                fieldText=fieldText + "查询时间段|";
                msgText = msgText +  "起始时间不能大于终止时间|";
           }
           if(!isFlag)
           {
                popMsgObj.Show(fieldText,msgText);
                return;
           }
           
           var UrlParam="&action="+action+
           "&txtProductNo="+escape(txtProductNo)+
           "&txtProductName="+escape(txtProductName)+
           "&txtStartDate="+escape(txtStartDate)+
           "&txtEndDate="+escape(txtEndDate);
    
    //设置检索条件
    document.getElementById("hidSearchCondition").value = UrlParam;
    if (currPage == null || typeof(currPage) == "undefined")
    {
        TurnToPage0(1);
    }
    else
    {
        TurnToPage0(parseInt(currPage,10));
    }
}
 /*-----------------------------------------DoSearch结束----------------------------------------------*/
 
 
    var pageCount = 10;//每页计数
    var totalRecord = 0;
    var pagerStyle = "flickr";//jPagerBar样式
    
    var currentPageIndex = 1;
    var action = "";//操作
    var orderBy = "OutDate_a";//排序字段
    //jQuery-ajax获取JSON数据
    function TurnToPage0(pageIndex)
    {
           currentPageIndex = pageIndex;
           //获取查询条件
           var searchCondition = document.getElementById("hidSearchCondition").value;
           
           var UrlParam = "pageIndex=" + pageIndex + "&pageCount=" + pageCount + "&orderBy=" + orderBy + "&" + searchCondition;
           $.ajax({
           type: "POST",//用POST方式传输
           dataType:"json",//数据格式:JSON
           url:  '../../../Handler/OperatingModel/StorageManager/ProductInOutInfoSell.ashx',//目标地址
           data:UrlParam,
           cache:false,
           beforeSend:function(){AddPop();$("#pageDataList1_Pager").hide();},//发送数据之前
           
           success: function(msg){
                    //数据获取完毕，填充页面据显示
                    //数据列表
                    $("#pageDataList1 tbody").find("tr.newrow").remove();
                    if (msg.data.length != 0)
                    {
                        $("#btnPrint").css("display", "inline");
                        $.each(msg.data,function(i,item){
                            if(item.ProdNo != null && item.ProdNo != "")
                            {
                                $("<tr class='newrow'></tr>").append("<td height='22' align='center'>"+ item.ProdNo +"</a></td>"+
                                "<td height='22' align='center'>"+ item.ProductName +"</td>"+
                                "<td height='22' align='center'>"+item.Specification+"</td>"+
                                "<td height='22' align='center'>"+item.UnitID+"</td>"+
                                "<td height='22' align='center'>"+item.OutDate+"</td>"+
                                "<td height='22' align='center'>"+item.OutNo+"</td>"+
                                "<td height='22' align='center'>"+item.CustNo+"</td>"+
                                "<td height='22' align='center'>"+item.CustName+"</td>"+
                                "<td height='22' align='center'>"+NumRound(item.CountTotal,2)+"</td>"+
                                "<td height='22' align='center'>"+NumRound(item.TotalPrice,2)+"</td>"+
                                "<td height='22' align='center'>"+NumRound(item.Tax_TotalPrice,2)+"</td>"+
                                "<td height='22' align='center'>"+NumRound(item.Tax,2)+"</td>").appendTo($("#pageDataList1 tbody"));
                                
                            }
                             else
                             {
                                 $("#btnPrint").css("display", "none");
                             }
                          });
                      }
                      else
                      {
                        $("#btnPrint").css("display", "none");
                      }
                 
                    //页码
                   ShowPageBar("pageDataList1_Pager",//[containerId]提供装载页码栏的容器标签的客户端ID
                   "<%= Request.Url.AbsolutePath %>",//[url]
                    {style:pagerStyle,mark:"pageDataList1Mark",
                    totalCount:msg.totalCount,showPageNumber:3,pageCount:pageCount,currentPageIndex:pageIndex,noRecordTip:"没有符合条件的记录",preWord:"上一页",nextWord:"下一页",First:"首页",End:"末页",
                    onclick:"TurnToPage0({pageindex});return false;"}//[attr]
                    );
                  totalRecord = msg.totalCount;
                 // $("#pageDataList1_Total").html(msg.totalCount);//记录总条数
                  document.all["Text2"].value=msg.totalCount;
                  $("#ShowPageCount").val(pageCount);
                  ShowTotalPage(msg.totalCount,pageCount,pageIndex,$("#pagecount"));
                  $("#ToPage").val(pageIndex);
                  },
           error: function() {showPopup("../../../Images/Pic/Close.gif","../../../Images/Pic/note.gif","请求发生错误！");}, 
           complete:function(){hidePopup();$("#pageDataList1_Pager").show();Ifshow(document.all["Text2"].value);pageDataList1("pageDataList1","#E7E7E7","#FFFFFF","#cfc","cfc");}//接收数据完毕
           });
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
    
        
            //判断是否是数字
        if (!PositiveInteger(newPageCount))
        {
            showPopup("../../../Images/Pic/Close.gif","../../../Images/Pic/note.gif","每页显示应为正整数！");
            return;
        }
        if (!PositiveInteger(newPageIndex))
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
            this.pageCount=parseInt(newPageCount,10);
            TurnToPage0(parseInt(newPageIndex,10));
        }
    }
    //排序
    var ordering = "a";
    function OrderBy(orderColum,orderTip)
    {
        if (document.getElementById("hidSearchCondition").value == "" || document.getElementById("hidSearchCondition").value == null) return;
        ordering = "a";
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
        
        TurnToPage0(1);
    }



//打印
function fnPrint() {
    if(ordering=="a")
    {
        ordering="asc";
    }
    else
    {
        ordering="desc"
    }
    var order=orderBy.split('_')[0] + " " + ordering;//字段和升降序规则
    var strRul = $("#hidSearchCondition").val();
    window.open("PrintProductInOutInfoSell.aspx?order="+order+"&" + strRul);
}

//物品控件
function Fun_FillParent_Content(id,ProNo,ProdName)
{
   document.getElementById('txtProductNo').value=ProNo;
   document.getElementById('txtProductName').value=ProdName;
}

//转向时带上条件---To入库
function fnGoInSotck()
{
    var UrlParam="txtProductNo="+escape($("#txtProductNo").val())+
   "&txtProductName="+escape($("#txtProductName").val())+
   "&txtStartDate="+escape($("#txtStartDate").val())+
   "&txtEndDate="+escape($("#txtEndDate").val());
    window.location.href= "ProductInOutInfoInStock.aspx?"+ UrlParam;
}

//转向时带上条件---To库存余额
function fnGoInOutAll()
{
    var UrlParam="txtProductNo="+escape($("#txtProductNo").val())+
   "&txtProductName="+escape($("#txtProductName").val())+
   "&txtStartDate="+escape($("#txtStartDate").val())+
   "&txtEndDate="+escape($("#txtEndDate").val());
    window.location.href= "ProductInOutAll.aspx?"+ UrlParam;
}