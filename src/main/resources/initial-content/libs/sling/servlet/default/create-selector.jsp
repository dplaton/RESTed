<%--
/************************************************************************
 **     $Date: $
 **   $Source: $
 **   $Author: $
 ** $Revision: $
 ************************************************************************/
--%><%
%><%@page session="false" contentType="text/html; charset=utf-8" %><%
%><%@page import="org.apache.sling.api.resource.*,
                  java.util.*" %>
<%@ include file="/apps/rested/components/utils.jsp" %>
<%@taglib prefix="sling" uri="http://sling.apache.org/taglibs/sling/1.0" %><%
%><sling:defineObjects /><%
	
	ValueMap map = resource.adaptTo(ValueMap.class);
	String rtype = map.get("sling:resourceType", String.class);
	if (rtype != null) rtype = rtype.replace(':', '/');

	String appspath = "/apps/" + rtype;
	String libspath = "/libs/" + rtype;

%><!DOCTYPE html>
<html>
	<sling:include resource="${resource}" replaceSelectors="edit-head"/>
	<body style="background-color:gray">
		<div class="container-fluid">
			<div class="modal">
				<div class="modal-header">
    			<a class="close" href="${resource.path}.edit.html">&times;</a>
					<h3>Create Script</h3>
 				</div>

  			<div class="modal-body">
					<%=appspath %><a href="<%=appspath%>.edit.html"> <i class="icon icon-circle-arrow-right"></i></a>
					<ul>
	<%
		Iterator<Resource> children = listResources(resource.getResourceResolver(), appspath);
		while (children.hasNext ()) {
			Resource res = children.next();
			String path = res.getPath();
			String name = res.getName();
	%>
						<li><a href="<%=path%>.edit.html"><%= name %></a></li>
	<% } %>
<form class="form-horizontal" method="post" action="<%= appspath %>" enctype="multipart/form-data">
							<input type="hidden" name=":operation" value="import" />
							<input type="hidden" name=":contentType" value="json" />

							<input type="text" name=":name" placeholder="new selector script" />
							<input type="hidden" name=":redirect" value="<%= slingRequest.getRequestURL() %>" />
							<input type="hidden" name=":errorpage" value="<%=slingRequest.getRequestURL()%>" />
							<input type="hidden" name=":content" value="{ 'jcr:primaryType':'nt:file','jcr:content':{'jcr:primaryType':'nt:resource','jcr:data':'','jcr:mimeType':'text/plain'} }" />
							
							<button class="btn btn-success" type="submit"><i class="icon-white icon-plus"></i></button>
</form>
					</ul>
					<%=libspath %><a href="<%=libspath%>.edit.html"> <i class="icon icon-circle-arrow-right"></i></a>
					<ul>
	<%
		children = listResources(resource.getResourceResolver(), libspath);
		while (children.hasNext ()) {
			Resource res = children.next();
			String path = res.getPath();
			String name = res.getName();
	%>
						<li><a href="<%=path%>.edit.html"><%= name %></a></li>
	<% } %>

<form class="form-horizontal" method="post" action="<%= libspath %>" enctype="multipart/form-data">
							<input type="hidden" name=":operation" value="import" />
							<input type="hidden" name=":contentType" value="json" />

							<input type="text" name=":name" placeholder="new selector script" />
							<input type="hidden" name=":redirect" value="<%= slingRequest.getRequestURL() %>" />
							<input type="hidden" name=":errorpage" value="<%=slingRequest.getRequestURL()%>" />
							<input type="hidden" name=":content" value="{ 'jcr:primaryType':'nt:file','jcr:content':{'jcr:primaryType':'nt:resource','jcr:data':'','jcr:mimeType':'text/plain'} }" />
							<button class="btn btn-success" type="submit"><i class="icon-white icon-plus"></i></button>
</form>
					</ul>
<sling:include resource="<%=resource%>" replaceSelectors="errorbar"/>
				</div>
			</div>
		</div>
	</body>
</html>
