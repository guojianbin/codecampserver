﻿<%@ Control Language="C#" AutoEventWireup="true" Inherits="System.Web.Mvc.ViewUserControl" %>
<%@ Import Namespace="CodeCampServer.UI.Models.Forms"%>

<%@ Import Namespace="CodeCampServer.UI.Controllers"%>

<%
	var session = (SessionForm) ViewData.Model; %>
		<%if (ViewContext.HttpContext.User.Identity.IsAuthenticated){%>
				<a href="<%= Url.Action<SessionController>(t => t.Delete(null), new{session = session.Id}).ToXHTMLLink() %>"><img src="/images/icons/application_delete.png" /></a>
		<%}%>		
