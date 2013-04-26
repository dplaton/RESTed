<%--
/************************************************************************
 **     $Date: $
 **   $Source: $
 **   $Author: $
 ** $Revision: $
 ************************************************************************/
--%><%
%><%@page session="false" contentType="text/html; charset=utf-8" %><%
%><%@taglib prefix="sling" uri="http://sling.apache.org/taglibs/sling/1.0" %><%
%><%@taglib prefix="c" uri="http://java.sun.com/jstl/core" %><%
%><sling:defineObjects /><%
%><!DOCTYPE html>
<html>
	<head>
	</head>
	<body>
		<table>
			<tr>
				<td>request</td>
				<td><%= request %></td>
			</tr>
			<tr>
				<td>slingResponse</td>
				<td><%= slingResponse %></td>
			</tr>
			<tr>
				<td>slingRequest</td>
				<td><%= slingRequest %></td>
			</tr>
			<tr>
				<td>resource</td>
				<td><%= resource %></td>
			</tr>
			<tr>
				<td>resourceResolver</td>
				<td><%= resourceResolver %></td>
			</tr>
			<tr>
				<td>log</td>
				<td><%= log %></td>
			</tr>
			<tr>
				<td>currentNode</td>
				<td><%= currentNode %></td>
			</tr>
		</table>
		<c:forEach items="${resource}" var="child">
		</c:forEach>
	</body>
</html>
