﻿<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Main.Master" AutoEventWireup="true"
    Inherits="CodeCampServer.UI.Helpers.ReportBaseViewPage<UserGroupInput>" %>
<%@ Import Namespace="CodeCampServer.Core"%>
<asp:Content ContentPlaceHolderID="Main" runat="server">
    <%Html.RenderAction("List", "Event", ViewContext.RouteData.DataTokens);%>    
</asp:Content>
