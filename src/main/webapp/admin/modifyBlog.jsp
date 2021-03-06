<%--
  Created by IntelliJ IDEA.
  User: HJS
  Date: 2017/5/13
  Time: 10:13
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" import="java.util.*" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
    <title>修改博客页面</title>
    <meta content="text/html" http-equiv="Content-Type" charset="utf-8">
    <%@include file="../common/head.jspf"%>

    <script type="text/javascript" charset="utf-8"
            src="${blog}/static/ueditor1_4_3_3/ueditor.config.js"></script>
    <script type="text/javascript" charset="utf-8"
            src="${blog}/static/ueditor1_4_3_3/ueditor.all.min.js">
    </script>
    <!--建议手动加在语言，避免在ie下有时因为加载语言失败导致编辑器加载失败-->
    <!--这里加载的语言文件会覆盖你在配置项目里添加的语言类型，比如你在配置项目里配置的是英文，这里加载的中文，那最后就是中文-->
    <script type="text/javascript" charset="utf-8"
            src="${blog}/static/ueditor1_4_3_3/lang/zh-cn/zh-cn.js"></script>

</head>
<body style="margin: 10px; font-family: microsoft yahei">
    <div id="p" class="easyui-panel" title="修改编写博客" style="padding: 10px;">
        <table cellspacing="20px">
            <tr>
                <td width="80px">博客标题：</td>
                <td><input type="text" id="title" name="title" style="width: 400px"/></td>
            </tr>
            <tr>
                <td>所属类别：</td>
            <td><select id="blogTypeId" class="easyui-combobox"
                        name="blogType.id" style="width:154px" editable="false"
                        panelHeight="auto">
                <option value="">请选择博客类别</option>
                <c:forEach items="${blogTypeList}" var="blogType">
                <option value="${blogType.id}">${blogType.typeName}</option>
                </c:forEach>
            </select></td>
                <td></td>
            </tr>
            <tr>
                <td valign="top">博客内容：</td>
                <td><script type="text/plain" id="editor" name="content" style="width:95%;height:200px;"></script> </td>
            </tr>
            <tr>
                <td>关键字：</td>
                <td><input id="keyWord" type="text" name="keyWord"
                           style="width:400px"/>&nbsp;&nbsp;&nbsp;多个关键字的话请用空格隔开</td>
            </tr>
        <tr>
            <td></td>
            <td><a href="javascript:submitData()" class="easyui-linkbutton"
                   data-options="iconCls:'icon-submit'">确认修改</a></td>
        </tr>
        </table>
    </div>
<!--实例化编辑器-->
<script type="application/javascript">
    var  ue=UE.getEditor('editor');
    ue.addListener("ready",function () {
        UE.ajax.request("${blog}/admin/blog/get.do",{
            method:"post",
            async:true,
            data:{id:"${param.id}"},
            onsuccess:function (result) {
                //result = eval("(" + result.responseText + ")");
                result=JSON.parse(result.responseText);
                $("#title").val(result.title);
                $("#keyWord").val(result.keyWord);
                $("#blogTypeId").combobox("setValue",result.blogType.id);
                UE.getEditor('editor').setContent(result.content);
            }
        })
    })
</script>
<script type="text/javascript">
    function submitData() {
        var title=$("#title").val();
        var blogTypeId=$("#blogTypeId").combobox("getValue");
        var content=UE.getEditor('editor').getContent();
        var summary=UE.getEditor('editor').getContentTxt().substr(0,155);
        var keyWord=$("#keyWord").val();
        var contentNoTag=UE.getEditor('editor').getContentTxt();

        if (title==null||title==''){
            $.messager.alert("系统提示","请输入标题!");
        } else if (blogTypeId == null || blogTypeId == '') {
            $.messager.alert("系统提示", "请选择博客类型！");
        } else if (content == null || content == '') {
            $.messager.alert("系统提示", "请编辑博客内容！");
        } else {
            $.post("${blog}/admin/blog/save.do",
                {
                    'id': '${param.id}',
                    'title' : title,
                    'blogType.id' : blogTypeId,
                    'content' : content,
                    'summary' : summary,
                    'keyWord' : keyWord,
                    'contentNoTag' : contentNoTag
                }, function(result) {
                    if (result.success) {
                        $.messager.alert("系统提示", "博客修改成功！");
                        clearValues();
                    } else {
                        $.messager.alert("系统提示", "博客修改失败！");
                    }
                }, "json");
        }
    }
    function clearValues() {
        $("#title").val("");
        $("#blogTypeId").combobox("setValue", "");
        UE.getEditor("editor").setContent("");
        $("#keyWord").val("");
    }
</script>

</body>
</html>











