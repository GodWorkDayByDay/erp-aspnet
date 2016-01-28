﻿<%@ Page Language="C#" AutoEventWireup="true" CodeFile="StorageInitailPrint.aspx.cs"
    Inherits="Pages_PrinttingModel_StorageManager_StorageInitailPrint"  ValidateRequest="false"%>

<%@ Register Assembly="CrystalDecisions.Web, Version=10.5.3700.0, Culture=neutral, PublicKeyToken=692fbea5521e1304"
    Namespace="CrystalDecisions.Web" TagPrefix="CR" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">

    <script src="../../../js/common/Common.js" type="text/javascript"></script>

    <style type="text/css">
        @media print
        {
            .onlyShow
            {
                display: none;
            }
            .onlyPrint
            {
                border-bottom: 1px solid #000000;
                page-break-before: always;
            }
        }
    </style>
    <style type="text/css" media="print">
        .noprint
        {
            border: 0px;
        }
        .noprint2
        {
            display: none;
        }
    </style>
    <style type="text/css" id="cssID">
        .busBtn
        {
            background: url(../../../Images/default/btnbg.gif) 0px -5px;
            border: 1px solid #cccccc;
            padding-top: 2px;
            cursor: pointer;
        }
        .trTitle
        {
            text-align: left;
            vertical-align: middle;
            padding-left: 10px;
            height: 36px;
            font-size: 16px;
            border: 1px solid #000000;
        }
        .tdFirstTitleMyLove
        {
            width: 14%;
            border: 1px solid #000000;
            text-align: center;
            padding: 8px 8px 5px 0px;
            font-size: 12px;
            font-weight: bold;
        }
        .tdFirstTitle
        {
            width: 12%;
            border: 1px solid #000000;
            text-align: right;
            border-top: none;
            padding: 8px 8px 5px 0px;
            font-size: 12px;
        }
        .tdTitle
        {
            border: 1px solid #000000;
            text-align: center;
            border-left: none;
            padding: 8px 8px 5px 0px;
            font-size: 12px;
        }
        .tdTitle2
        {
            width: 12%;
            border: 1px solid #000000;
            text-align: right;
            border-left: none;
            padding: 8px 8px 5px 0px;
            font-size: 12px;
            border-top: none;
        }
        .tdContent
        {
            width: 12%;
            border: 1px solid #000000;
            border-left: none;
            text-align: left;
            padding: 8px 0px 8px 5px;
            overflow: visible;
            word-break: break-all;
            font-size: 12px;
            font-weight: bold;
        }
        .tdContent2
        {
            width: 48%;
            border: 1px solid #000000;
            border-left: none;
            text-align: left;
            border-top: none;
            padding: 8px 0px 8px 5px;
            overflow: visible;
            word-break: break-all;
            font-size: 12px;
        }
        .tdLastContent
        {
            width: 24%;
            border: 1px solid #000000;
            border-left: none;
            text-align: left;
            border-top: none;
            overflow: visible;
            word-break: break-all;
            padding: 8px 0px 8px 5px;
            font-size: 12px;
        }
        .tdColContent
        {
            border: 1px solid #000000;
            border-left: none;
            text-align: left;
            border-top: none;
            overflow: visible;
            word-break: break-all;
            padding: 8px 0px 8px 5px;
            font-size: 12px;
        }
        .tdDetail
        {
            border: 1px solid #000000;
            text-align: left;
            width: 100%;
            border-bottom: none;
            overflow: visible;
            word-break: break-all;
            padding: 5px 0px 5px 5px;
            font-size: 12px;
        }
        .tdPageLast td
        {
            border: 1px solid #000000;
            text-align: left;
            width: 100%;
            overflow: visible;
            word-break: break-all;
            padding: 5px 0px 5px 5px;
            font-size: 12px;
        }
        .trDetailFirst
        {
            border: 1px solid #000000;
            text-align: center;
            padding: 8px 8px 5px 0px;
            font-size: 12px;
            border-top: none;
        }
        .trDetail
        {
            border: 1px solid #000000;
            text-align: center;
            padding: 8px 8px 5px 0px;
            font-size: 12px;
            border-left: none;
            border-top: none;
        }
    </style>

    <script src="../../../js/JQuery/jquery_last.js" type="text/javascript"></script>

    <title>期初库存录入单</title>

    <script type="text/javascript">


        //此段js兼容ff的outerHTML，去掉后outerHTML在ff下不可用
        if (typeof (HTMLElement) != "undefined" && !window.opera) {
            HTMLElement.prototype.__defineGetter__("outerHTML", function() {
                var a = this.attributes, str = "<" + this.tagName, i = 0; for (; i < a.length; i++)
                    if (a[i].specified)
                    str += " " + a[i].name + '="' + a[i].value + '"';
                if (!this.canHaveChildren)
                    return str + " />";
                return str + ">" + this.innerHTML + "</" + this.tagName + ">";
            });
            HTMLElement.prototype.__defineSetter__("outerHTML", function(s) {
                var r = this.ownerDocument.createRange();
                r.setStartBefore(this);
                var df = r.createContextualFragment(s);
                this.parentNode.replaceChild(df, this);
                return s;
            });
            HTMLElement.prototype.__defineGetter__("canHaveChildren", function() {
                return !/^(area|base|basefont|col|frame|hr|img|br|input|isindex|link|meta|param)$/.test(this.tagName.toLowerCase());
            });
        }


        //打印的方法
        function pageSetup() {
            try {
                window.print();
            }
            catch (e) {
                alert("您的浏览器不支持此功能,请选择：文件→打印(P)…")
            }
        }

        //获取导出至excel的html的方法
        function fnGetTable() {
            var o_hid = document.getElementById("hiddExcel");
            o_hid.value = "";
            o_hid.value = o_hid.value + document.getElementById("cssID").outerHTML + document.getElementById("divMain").innerHTML;

            return true;
        }

    </script>

</head>
<body>
    <form id="form1" runat="server">
    <div align="center">
        <object classid="CLSID:8856F961-340A-11D0-A96B-00C04FD705A2" height="0" id="WB" width="0">
        </object>
        <span class="noprint2" style="text-align: center; margin-top: 4px; width: 640px;">
            <input type="button" id="print" value=" 打 印 " onclick="pageSetup();" class="busBtn" />
            <asp:Button ID="btnImport" runat="server" Text=" 导 出 " CssClass="busBtn" OnClientClick="return fnGetTable();"
                OnClick="btnImport_Click" />
            <input type="button" id="btnSet" value=" 打印模板设置 " onclick="ShowPrintSetting();" class="busBtn" />
        </span>
        <div id="divMain" align="center">
            <table width="640px" border="0" style="font-size: 12px;">
                <tbody id="tableBase" runat="server">
                </tbody>
            </table>
            <table width="640px" border="0" cellpadding="0" cellspacing="1">
                <tbody id="tableDetail" runat="server">
                </tbody>
            </table>
        </div>
        <input type="hidden" id="hiddExcel" runat="server" />
    </div>
    <!-- Start 参数设置 -->
    <div align="center" id="div_InInfo" style="width: 70%; z-index: 100; position: absolute;
       display: none "><%----%>
        <table border="0" cellspacing="1" bgcolor="#999999" style="width: 70%">
            <tr>
                <td bgcolor="#EEEEEE" align="center">
                    <table width="100%">
                        <tr>
                            <td align="left" onmousedown="MoveDiv('div_InInfo',event)" title="点击此处可以拖动窗口" onmousemove="this.style.cursor='move';"
                                style="font-size: 12px; font-weight: bold;">
                                &nbsp;&nbsp;打印模板设置
                            </td>
                            <td width="50" align="right" >
                                <img src="../../../images/default/0420close.gif" onclick='ClosePrintSetting();' style="cursor: hand;" />
                            </td>
                        </tr>
                    </table>
                    <table width="99%" border="0" cellspacing="1" bgcolor="#CCCCCC">
                        <tr>
                            <td bgcolor="#FFFFFF" align="center" valign="top" style="width: 90%">
                               <%-- --%> <div id="divSet" style="display: none;width: 796px; overflow-x: auto; overflow-y: auto;
                                    height: 400px; scrollbar-face-color: #E7E7E7; scrollbar-highlight-color: #ffffff;
                                    scrollbar-shadow-color: COLOR:#000000; scrollbar-3dlight-color: #ffffff; scrollbar-darkshadow-color: #ffffff;">
                                    <!-- Start 打印模板设置 -->
                                    <table border="0" cellspacing="1" bgcolor="#CCCCCC" style="font-size: 12px;">
                                        <tr>
                                            <td bgcolor="#FFFFFF" align="left">
                                                <table width="100%" border="0" align="center" cellspacing="0">
                                                    <tr>
                                                        <td height="20" colspan="3" bgcolor="#E1F0FF" style="font-weight: bold; color: #5D5D5D;">
                                                            基本信息
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td width="20%" align="left">
                                                            <input type="checkbox" name="ckInNo" id="ckInNo" value="InNo" />
                                                            <input type="text" id="txtMRPNo" readonly value="入库单编号：" size="10" readonly />
                                                        </td>
                                                        <td width="20%" align="left">
                                                        <input type="checkbox" name="ckTitle" id="ckTitle" value="Title" />
                                                            <input type="text" id="txtTitle" value="入库单主题：" size="10" readonly />
                                                        </td>
                                                        <td >
                                                        <input type="checkbox" name="ckStorageName" id="ckStorageName" value="StorageName" />
                                                            <input type="text" id="txtStorageName" value="仓库：" size="10" readonly />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        
                                                        <td width="20%" align="left">
                                                        <input type="checkbox" name="ckDeptName" id="ckDeptName" value="DeptName" />
                                                            <input type="text" id="txtDeptName" value="入库部门：" size="10" readonly />
                                                        </td>
                                                        <td width="20%">
                                                        <input type="checkbox" name="ckUsertxtExecutor" id="ckUsertxtExecutor" value="CustName" />
                                                            <input type="text" id="txtUsertxtExecutor" value="入库人：" size="10" readonly />
                                                        </td>
                                                        <td>
                                                        <input type="checkbox" name="ckEnterDate" id="ckEnterDate" value="EnterDate" />
                                                         <input type="text" id="txtEnterDate" value="入库时间：" size="10" readonly />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td width="20%" align="left" >
                                                        <input type="checkbox" name="ckSummary" id="ckSummary" value="Summary" />
                                                            <input type="text" id="txtSummary" value="摘要：" size="10" readonly />
                                                        </td>
                                                         <td width="20%">
                                                        <input type="checkbox" name="ckUsertxtExecutor" id="ckBatchNo" value="CustName" />
                                                            <input type="text" id="txtBatchNo" value="批次：" size="10" readonly />
                                                        </td>
                                                        <td width="20%">
                                                       
                                                        </td>
                                                       
                                                    </tr>
                                                    <tbody id="extTable">
                                                        <tr class='ext'>
                                                            <td width="20%" align="left">
                                                            <input type="checkbox" name="ckExtField1" id="ckExtField1" value="ExtField1" style="display: none" />
                                                                <input type="text" id="txtExtField1" value="" size="10" readonly style="display: none" />
                                                            </td>
                                                            <td width="20%" align="left">
                                                            <input type="checkbox" name="ckExtField2" id="ckExtField2" value="ExtField2" style="display: none" />
                                                                <input type="text" id="txtExtField2" value="" size="10" readonly style="display: none" />
                                                            </td>
                                                            <td>
                                                            <input type="checkbox" name="ckExtField3" id="ckExtField3" value="ExtField3" style="display: none" />
                                                                <input type="text" id="txtExtField3" value="" size="10" readonly style="display: none" />
                                                            </td>
                                                        </tr>
                                                        <tr class='ext'>
                                                            <td width="20%" align="left">
                                                            <input type="checkbox" name="ckExtField4" id="ckExtField4" value="ExtField4" style="display: none" />
                                                                <input type="text" id="txtExtField4" value="" size="10" readonly style="display: none" />
                                                            </td>
                                                            <td width="20%" align="left">
                                                            <input type="checkbox" name="ckExtField5" id="ckExtField5" value="ExtField5" style="display: none" />
                                                                <input type="text" id="txtExtField5" value="" size="10" readonly style="display: none" />
                                                            </td>
                                                            <td>
                                                            <input type="checkbox" name="ckExtField6" id="ckExtField6" value="ExtField6" style="display: none" />
                                                                <input type="text" id="txtExtField6" value="" size="10" readonly style="display: none" />
                                                            </td>
                                                        </tr>
                                                        <tr class='ext'>
                                                            <td width="20%" align="left">
                                                            <input type="checkbox" name="ckExtField7" id="ckExtField7" value="ExtField7" style="display: none" />
                                                                <input type="text" id="txtExtField7" value="" size="10" readonly style="display: none" />
                                                            </td>
                                                            <td width="20%" align="left">
                                                            <input type="checkbox" name="ckExtField8" id="ckExtField8" value="ExtField8" style="display: none" />
                                                                <input type="text" id="txtExtField8" value="" size="10" readonly style="display: none" />
                                                            </td>
                                                            <td>
                                                            <input type="checkbox" name="ckExtField9" id="ckExtField9" value="ExtField9" style="display: none" />
                                                                <input type="text" id="txtExtField9" value="" size="10" readonly style="display: none" />
                                                            </td>
                                                        </tr>
                                                        <tr class='ext'>
                                                            <td width="20%" align="left">
                                                            <input type="checkbox" name="ckExtField10" id="ckExtField10" value="ExtField10" style="display: none" />
                                                                <input type="text" id="txtExtField10" value="" size="10" readonly style="display: none" />
                                                            </td>
                                                            <td width="20%" align="left">
                                                            </td>
                                                            <td>
                                                            </td>
                                                           
                                                        </tr>
                                                    </tbody>
                                                    <tr>
                                                        <td height="20" colspan="3" bgcolor="#E1F0FF" style="font-weight: bold; color: #5D5D5D;">
                                                            合计信息
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td width="20%" align="left">
                                                        <input type="checkbox" name="ckTotalCount" id="ckTotalCount" value="TotalCount" />
                                                            <input type="text" id="txtTotalCount" value="入库数量合计：" size="10" readonly />
                                                        </td>
                                                        <td width="20%" align="left">
                                                        <input type="checkbox" name="ckTotalPrice" id="ckTotalPrice" value="TotalPrice" />
                                                            <input type="text" id="txtTotalPrice" value="入库金额合计：" size="10" readonly />
                                                        </td>
                                                        <td>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td height="20" colspan="3" bgcolor="#E1F0FF" style="font-weight: bold; color: #5D5D5D;">
                                                            备注信息
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        
                                                        <td width="20%" align="left">
                                                        <input type="checkbox" name="ckCreatorReal" id="ckCreatorReal" value="CreatorReal" />
                                                            <input type="text" id="txtCreatorReal" value="制单人：" size="10" readonly />
                                                        </td>
                                                        <td width="20%" align="left">
                                                        <input type="checkbox" name="ckCreateDate" id="ckCreateDate" value="CreateDate" />
                                                            <input type="text" id="txtCreateDate" value="制单日期：" size="10" readonly />
                                                        </td>
                                                        <td >
                                                        <input type="checkbox" name="ckStrBillStatusText" id="ckStrBillStatusText" value="strBillStatusText" />
                                                            <input type="text" id="txtStrBillStatusText" value="单据状态：" size="10" readonly />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td width="20%" align="left">
                                                        <input type="checkbox" name="ckConfirmorReal" id="ckConfirmorReal" value="ConfirmorReal" />
                                                            <input type="text" id="txtConfirmorReal" value="确认人：" size="10" readonly />
                                                        </td>
                                                        <td width="20%" align="left">
                                                        <input type="checkbox" name="ckConfirmDate" id="ckConfirmDate" value="ConfirmDate" />
                                                            <input type="text" id="txtConfirmDate" value="确认日期：" size="10" readonly />
                                                        </td>
                                                        <td>
                                                        <input type="checkbox" name="ckCloserReal" id="ckCloserReal" value="CloserReal" />
                                                            <input type="text" id="txtCloserReal" value="结单人：" size="10" readonly />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td width="20%" align="left">
                                                        <input type="checkbox" name="ckCloseDate" id="ckCloseDate" value="CloseDate" />
                                                            <input type="text" id="txtCloseDate" value="结单日期：" size="10" readonly />
                                                        </td>
                                                        <td width="20%" align="left">
                                                        <input type="checkbox" name="ckModifiedUserID" id="ckModifiedUserID" value="ModifiedUserID" />
                                                            <input type="text" id="txtModifiedUserID" value="最后更新人：" size="10" readonly />
                                                        </td>
                                                        <td>
                                                        <input type="checkbox" name="ckModifiedDate" id="ckModifiedDate" value="ModifiedDate" />
                                                            <input type="text" id="txtModifiedDate" value="最后更新日期：" size="10" readonly />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td width="20%" align="left">
                                                        <input type="checkbox" name="ckRemark" id="ckRemark" value="Remark" />
                                                            <input type="text" id="txtRemark" value="备注：" size="10" readonly />
                                                        </td>
                                                        <td  width="20%">
                                                        </td>
                                                        <td>
                                                        </td>
                                                        
                                                    </tr>
                                                    <tr>
                                                        <td height="20" colspan="3" bgcolor="#E1F0FF" style="font-weight: bold; color: #5D5D5D;">
                                                            明细信息
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="3">
                                                            <table width="100%" border="0" cellspacing="1" bgcolor="#000000" id="pageDataList1">
                                                                <tr>
                                                                    <td bgcolor="#FFFFFF">
                                                                        <input type="checkbox" name="ckdSortNo" id="ckdSortNo" value="SortNo" /><input type="text"
                                                                            id="txtDSortNo" value="序号" size="5" />
                                                                    </td>
                                                                    <td bgcolor="#FFFFFF">
                                                                        <input type="checkbox" name="ckdProdNo" id="ckdProdNo" value="ProdNo" /><input type="text"
                                                                            id="txtDProductNo" value="物品编号" size="10" readonly />
                                                                    </td>
                                                                    <td bgcolor="#FFFFFF">
                                                                        <input type="checkbox" name="ckdProductName" id="ckdProductName" value="ProductName" /><input
                                                                            type="text" id="txtDProductName" value="物品名称" size="10" readonly />
                                                                    </td>
                                                                    <td bgcolor="#FFFFFF">
                                                                        <input type="checkbox" name="ckdType" id="ckdType" value="Type" /><input
                                                                            type="text" id="txtDType" value="规格" size="10" readonly />
                                                                    </td>
                                                                    <td bgcolor="#FFFFFF">
                                                                        <input type="checkbox" name="ckdUnitName" id="ckdUnitName" value="UnitName" /><input
                                                                            type="text" id="txtDUnitName" value="基本单位" size="10" readonly />
                                                                    </td>
                                                                    <td bgcolor="#FFFFFF">
                                                                        <input type="checkbox" name="ckProductCount" id="ckProductCount" value="ProductCount" /><input
                                                                            type="text" id="txtProductCount" value="基本数量" size="10" readonly />
                                                                    </td>
                                                                     <td bgcolor="#FFFFFF" id="td_UsedUnitName" runat="server">
                                                                        <input type="checkbox" name="ckdUnitName" id="ckUsedUnitName" value="UnitName" /><input
                                                                            type="text" id="txtUsedUnitName" value="单位" readonly size="10" />
                                                                    </td>
                                                                     <td bgcolor="#FFFFFF" id="td_UsedUnitCount" runat="server">
                                                                        <input type="checkbox" name="ckdUnitName" id="ckUsedUnitCount" value="UnitName" /><input
                                                                            type="text" id="txtUsedUnitCount" value="数量" readonly size="10" />
                                                                    </td>
                                                                    <td bgcolor="#FFFFFF">
                                                                        <input type="checkbox" name="ckdUnitPrice" id="ckdUnitPrice" value="UnitPrice" /><input
                                                                            type="text" id="txtdUnitPrice" value="入库单价" size="10" readonly />
                                                                    </td>
                                                                    <td bgcolor="#FFFFFF">
                                                                        <input type="checkbox" name="ckdTotalPrice" id="ckdTotalPrice" value="B_TotalPrice" /><input
                                                                            type="text" id="txtdTotalPrice" value="入库金额 " size="10" readonly />
                                                                    </td>
                                                                    <td bgcolor="#FFFFFF">
                                                                        <input type="checkbox" name="ckdRemark" id="ckdRemark" value="Remark" /><input type="text"
                                                                            id="txtDRemark" value="备注" size="10" readonly />
                                                                    </td>                                                                    
                                                                </tr>
                                                            </table>
                                                            <br />
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                    </table>
                                    <input type="hidden" id="hidBillTypeFlag" name="hidBillTypeFlag" runat="server" />
                                    <input type="hidden" id="hidPrintTypeFlag" name="hidPrintTypeFlag" runat="server" />
                                    <input type="hidden" id="isSeted" value="0" runat="server" />
                                    <input type="hidden" id="HiddenMoreUnit" runat="server" /><!--是否显示多计量单位-->
                                    <!-- End 打印模板设置 -->
                                </div>
                            </td>
                        </tr>
                    </table>
                    <table width="100%">
                        <tr>
                            <td align="center">
                                <input type="button" id="btnPrintSave" name="btnPrintSave" value=" 保 存 " class="busBtn"
                                    onclick="SavePrintSetting();" />
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </div>
    <div id="divPageMask" style="display: none">
        <iframe id="PageMaskIframe" frameborder="0" width="100%"></iframe>
    </div>
    <!-- End 参数设置-->
    </form>
    <p>
</body>
</html>


<script src="../../../js/common/PrintParameterSetting.js" type="text/javascript"></script>

<script language="javascript">
    var intMrpID = <%=intMrpID %>;
    //弹出单据显示信息
    function ShowPrintSetting() {
        
        document.getElementById('div_InInfo').style.display = 'block';
        CenterToDocument("div_InInfo", true);
        openRotoscopingDiv(false, "divPageMask", "PageMaskIframe");
        document.getElementById('divSet').style.display='block';
        LoadPrintSettingInfo();
        //LoadBillData();
        LoadExtTableName('officedba.StorageInitail');

    }

    function ClosePrintSetting() {
        document.getElementById('div_InInfo').style.display = 'none';
        closeRotoscopingDiv(false, 'divPageMask');
    } 
    /*加载打印模板设置信息*/
    function LoadPrintSettingInfo() {

        var hidBillTypeFlag = document.getElementById('hidBillTypeFlag').value;
        var hidPrintTypeFlag = document.getElementById('hidPrintTypeFlag').value;
        var hidIsSeted = document.getElementById('isSeted').value;

        /*主表：复选框及其对应的字段*/
        var dbBase = new Array(
                                ['ckExtField1', 'ExtField1'],
                                ['ckExtField2', 'ExtField2'],
                                ['ckExtField3', 'ExtField3'],
                                ['ckExtField4', 'ExtField4'],
                                ['ckExtField5', 'ExtField5'],
                                ['ckExtField6', 'ExtField6'],
                                ['ckExtField7', 'ExtField7'],
                                ['ckExtField8', 'ExtField8'],
                                ['ckExtField9', 'ExtField9'],
                                ['ckExtField10', 'ExtField10'],
                                ['ckInNo', 'InNo'],//出库单编号
                                ['ckTitle', 'Title'],//主题
                                ['ckStorageName', 'StorageName'],//仓库
                                ['ckDeptName', 'DeptName'],//源单编号
                                ['ckUsertxtExecutor', 'ExecutorName'],//客户名称
                                ['ckEnterDate', 'EnterDate'],//销售部门
                                ['ckSummary', 'Summary'],//业务员
                                ['ckBatchNo', 'BatchNo'],//pici
                                
                                ['ckTotalCount', 'CountTotal'],//数量合计
                                ['ckTotalPrice', 'A_TotalPrice'],//金额合计
                                
                                ['ckCreatorReal', 'CreatorName'],//制单人
                                ['ckCreateDate', 'CreateDate'],//制单日期
                                ['ckStrBillStatusText', 'BillStatusName'],//单据状态
                                ['ckConfirmorReal', 'ConfirmorName'],//确认人
                                ['ckConfirmDate', 'ConfirmDate'],//确认日期
                                ['ckCloserReal', 'CloserName'],//结单人
                                ['ckCloseDate', 'CloseDate'],//结单日期
                                ['ckModifiedUserID', 'ModifiedUserName'],//最后更新人
                                ['ckModifiedDate', 'ModifiedDate'],//最后更新日期
                               
                                ['ckRemark', 'Remark']);//摘要
        /*明细表：复选框及其对应的字段*/
        var dbDetail=new Array();
        if(document.getElementById("HiddenMoreUnit").value == "true")
        {
            dbDetail = new Array(['ckdSortNo', 'SortNo'],//序号
                                 ['ckdProdNo', 'ProductNo'],//物品编号
                                 ['ckdProductName', 'ProductName'],//物品名称
                                 ['ckdType', 'Specification'],//规格
                                 ['ckdUnitName', 'UnitID'],//单位
                                 ['ckProductCount', 'ProductCount'],//                                 
                                 ['ckUsedUnitName', 'UsedUnitName'],//
                                 ['ckUsedUnitCount', 'UsedUnitCount'],//
                                 
                                 ['ckdUnitPrice', 'UnitPrice'],//通知数量
                                 ['ckdTotalPrice', 'B_TotalPrice'],//已出库数量
                                 ['ckdRemark', 'DetaiRemark']);//备注
        }
        else
        {
             dbDetail = new Array(['ckdSortNo', 'SortNo'],//序号
                                 ['ckdProdNo', 'ProductNo'],//物品编号
                                 ['ckdProductName', 'ProductName'],//物品名称
                                 ['ckdType', 'Specification'],//规格
                                 ['ckdUnitName', 'UnitID'],//单位
                                 ['ckProductCount', 'ProductCount'],//仓库
                                 ['ckdUnitPrice', 'UnitPrice'],//通知数量
                                 ['ckdTotalPrice', 'B_TotalPrice'],//已出库数量
                                 ['ckdRemark', 'DetaiRemark']);//备注
        }
       

        /*加载打印参数设置*/
        LoadCommonPrintParameterSet(hidBillTypeFlag, hidPrintTypeFlag,hidIsSeted, dbBase, dbDetail,null);
    }

    /*保存打印模板设置*/
    function SavePrintSetting() {      
        var strBaseFields = "";
        var strDetailFields = "";
        var toLocation='StorageInitailPrint.aspx?ID=' + intMrpID;
        var hidBillTypeFlag = document.getElementById('hidBillTypeFlag').value;
        var hidPrintTypeFlag = document.getElementById('hidPrintTypeFlag').value;

        if (document.getElementById('ckInNo').checked) strBaseFields = strBaseFields + "InNo|";
        if (document.getElementById('ckTitle').checked) strBaseFields = strBaseFields + "Title|";
        if (document.getElementById('ckStorageName').checked) strBaseFields = strBaseFields + "StorageName|";
        if (document.getElementById('ckDeptName').checked) strBaseFields = strBaseFields + "DeptName|";
        if (document.getElementById('ckUsertxtExecutor').checked) strBaseFields = strBaseFields + "ExecutorName|";
        if (document.getElementById('ckEnterDate').checked) strBaseFields = strBaseFields + "EnterDate|";
        if (document.getElementById('ckSummary').checked) strBaseFields = strBaseFields + "Summary|";
        if (document.getElementById('ckBatchNo').checked) strBaseFields = strBaseFields + "BatchNo|";
        if (document.getElementById('ckTotalCount').checked) strBaseFields = strBaseFields + "CountTotal|";
        if (document.getElementById('ckTotalPrice').checked) strBaseFields = strBaseFields + "A_TotalPrice|";
        
        if (document.getElementById('ckCreatorReal').checked) strBaseFields = strBaseFields + "CreatorName|";
        if (document.getElementById('ckCreateDate').checked) strBaseFields = strBaseFields + "CreateDate|";
        if (document.getElementById('ckStrBillStatusText').checked) strBaseFields = strBaseFields + "BillStatusName|";

        if (document.getElementById('ckConfirmorReal').checked) strBaseFields = strBaseFields + "ConfirmorName|";
        if (document.getElementById('ckConfirmDate').checked) strBaseFields = strBaseFields + "ConfirmDate|";
        if (document.getElementById('ckCloserReal').checked) strBaseFields = strBaseFields + "CloserName|";
        if (document.getElementById('ckCloseDate').checked) strBaseFields = strBaseFields + "CloseDate|";
        if (document.getElementById('ckModifiedUserID').checked) strBaseFields = strBaseFields + "ModifiedUserName|";
        if (document.getElementById('ckModifiedDate').checked) strBaseFields = strBaseFields + "ModifiedDate|";
        if (document.getElementById('ckRemark').checked) strBaseFields = strBaseFields + "Remark|";

        for(var i=0;i<10;i++)
        {
            if (document.getElementById('ckExtField'+(i+1)).checked) strBaseFields = strBaseFields + "ExtField"+(i+1)+"|";
        }

        if (document.getElementById('ckdSortNo').checked) strDetailFields = strDetailFields + "SortNo|";
        if (document.getElementById('ckdProdNo').checked) strDetailFields = strDetailFields + "ProductNo|";
        if (document.getElementById('ckdProductName').checked) strDetailFields = strDetailFields + "ProductName|";
        if (document.getElementById('ckdType').checked) strDetailFields = strDetailFields + "Specification|";
        if (document.getElementById('ckdUnitName').checked) strDetailFields = strDetailFields + "UnitID|";        
        if (document.getElementById('ckProductCount').checked) strDetailFields = strDetailFields + "ProductCount|";
        if (document.getElementById('ckUsedUnitName').checked) strDetailFields = strDetailFields + "UsedUnitName|";
        if (document.getElementById('ckUsedUnitCount').checked) strDetailFields = strDetailFields + "UsedUnitCount|";
        
        if (document.getElementById('ckdUnitPrice').checked) strDetailFields = strDetailFields + "UnitPrice|";
        if (document.getElementById('ckdTotalPrice').checked) strDetailFields = strDetailFields + "B_TotalPrice|";
        if (document.getElementById('ckdRemark').checked) strDetailFields = strDetailFields + "DetaiRemark|";
    
       
        /*保存打印参数设置*/
        SaveCommonPrintParameterSet(strBaseFields,strDetailFields,null,hidBillTypeFlag,hidPrintTypeFlag,toLocation);
    }
</script>

