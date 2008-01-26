﻿<%@ Page Language="C#" MasterPageFile="~/Views/Layouts/TwoColumn.Master" AutoEventWireup="true" Inherits="CodeCampServer.Website.Views.ViewBase"
 Title="Register for conference" %>
<%@ Import namespace="CodeCampServer.Model.Presentation"%>
<%@ Import namespace="CodeCampServer.Website.Controllers"%>
<%@ Import namespace="CodeCampServer.Model.Domain"%>

<asp:Content ContentPlaceHolderID="Head" runat="server">
</asp:Content>

<asp:Content ContentPlaceHolderID="MainContentPlaceHolder" runat="server">
	<div>
		<h3></h3>
		<% using (Html.Form("register", "conference")) { %>    
			
		<fieldset>
		    <legend>Register for <%=getConference().Name %></legend>
		
            <label for="firstName">First Name</label>
            <%=Html.TextBox("firstName", 30)%>
		    
            <label for="lastName">Last Name</label>
            <%=Html.TextBox("lastName", 30)%>
		    
            <label for="email">Email Address:</label>
            <%=Html.TextBox("email", 30)%>
		    
            <label for="password">Password</label>
            <%=Html.Password("password", 30)%>
		    
            <label for="website">Website URL:</label>
            <%=Html.TextBox("website", 80)%>
		    
            <label for="comment">Comment</label>
            <%=Html.TextArea("comment", "", 4, 79)%>
            
            <div class="button-row">
                <%=Html.SubmitButton("register", "Register Me!")%>
            </div>
		    
		</fieldset>
		<% } %>
	</div>
</asp:Content>

<asp:Content ContentPlaceHolderID="SidebarContentPlaceHolder" runat="server">

</asp:Content>

<script runat="server">
	private ScheduledConference getConference()
	{
		ScheduledConference conference = ViewData.Get<ScheduledConference>();
		return conference;
	}

</script>