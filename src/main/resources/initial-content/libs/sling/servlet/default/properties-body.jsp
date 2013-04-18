<%--
/************************************************************************
 **     $Date: $
 **   $Source: $
 **   $Author: $
 ** $Revision: $
 ************************************************************************/
--%><%
%><%@page session="false" contentType="text/html; charset=utf-8" %><%
%><%@page import="java.io.*,
                  java.net.*,
									java.util.*,
									javax.jcr.*,
									org.apache.sling.api.resource.*,
                  utils.*" 
%><%!

PropertyIterator getPropertyTemplate(ResourceResolver rres, String ntype, String rtype) {
	try {
		String path = "/apps/rested/templates/" + rtype.replace(':','/') + "/properties";
		Resource res = rres.getResource(path);

		if (res == null) {
			path = "/apps/rested/templates/default/properties";
			res = rres.getResource(path);
		}

		if (res == null) {
			path = "/apps/rested/templates/" + ntype.replace(':','/') + "/properties";
			res = rres.getResource(path);
		}

		if (res == null) return null;

		Node node = res.adaptTo(Node.class);
		return node.getProperties();
	}
	catch (Exception ex) {
		return null;
	}
}

%><%@ taglib prefix="sling" uri="http://sling.apache.org/taglibs/sling/1.0" %><%
%><sling:defineObjects /><%

	PropertyIterator properties = null;
	PropertyIterator defaultProperties = null;
	Map done = new HashMap ();

	String requestPath = slingRequest.getRequestPathInfo().getResourcePath();
	String content = requestPath;
	if (resource instanceof NonExistingResource) {
		content = requestPath.substring (0, requestPath.indexOf ('.'));
	}
	else {
		properties = currentNode.getProperties();
		String ntype = currentNode.getProperty("jcr:primaryType").getString();
		String rtype = resource.getResourceType();
		defaultProperties = getPropertyTemplate(resource.getResourceResolver(),ntype, rtype);
	}

%>
<form id="DELETE_PROPERTY_FORM" method="post" action="<%= content %>" enctype="multipart/form-data">
	<input type="hidden" name=":redirect" value="<%=slingRequest.getRequestURL()%>" />
	<input type="hidden" name=":errorpage" value="<%=slingRequest.getRequestURL()%>" />
</form>

<FORM style="margin-bottom:2px" ID="EDIT_PROPERTIES_FORM" class="form-horizontal" METHOD="POST" ACTION="<%= content %>" ENCTYPE="MULTIPART/FORM-DATA">
	<input type="hidden" name=":redirect" value="<%=resource.getPath()%>.edit.html" />
	<input type="hidden" name=":errorpage" value="<%=slingRequest.getRequestURL()%>" />
		<fieldset>
			<sling:include resource="<%= resource %>" replaceSelectors="properties-custom"/>
		</fieldset>
		<br/>
		<fieldset>

		<% 
			if (properties != null) {
				for (;properties.hasNext();) {
					Property p = properties.nextProperty();
					String name = p.getName();
					if (p.isMultiple() == true) continue;
					if (name.equals("jcr:data")) continue;
					if (name.equals("jcr:primaryType")) continue;
					if (name.equals("sling:resourceType")) continue;
					if (name.equals("sling:resourceSuperType")) continue;

					String value = p.getString();

					if (name.startsWith("jcr:")) {
		%>
		<div class="control-group">
		 	<label class="control-label" for="<%=name%>"><%=name%></label>
		 	<div class="controls">
				<span style="vertical-align:middle;padding:4px;display:inline-block;border:solid 1px lightgray"><%=value%></span>
			</div>
		</div>
		<%
					}
					else {
		%>
		<div class="control-group">
		 <label class="control-label" for="<%=name%>"><%=name%></label>
		 <div class="controls">
				<INPUT id="<%=name%>" TYPE="TEXT" NAME="<%=name%>" VALUE="<%=value%>" />
				<span class="help-inline">
					<div class="btn-group">
					<BUTTON class="btn btn-danger" TYPE="SUBMIT" NAME="<%=name%>" VALUE="" FORM="DELETE_PROPERTY_FORM"><i class="icon-trash icon-white"></i></BUTTON>
					</div>
				</span>
		 </div>
		</div>
		<%  	}
					done.put(name, "y");	
				}
			}
		%>
		</fieldset>
		<fieldset>
		<% 
			if (defaultProperties != null) {
				for (;defaultProperties.hasNext();) {
					Property p = defaultProperties.nextProperty();
					String name = p.getName();
					String value = p.getString().trim();

					if (p.isMultiple() == true) continue;
					if (name.startsWith("jcr:")) continue;
					if (done.get(name) != null) continue;
		%>
		<div class="control-group">
		 	<label class="control-label" for="<%=name%>"><%=name%></label>
		 	<div class="controls">
				<INPUT id="<%=name%>" TYPE="TEXT" NAME="<%=name%>" VALUE="<%=value%>" />
			</div>
		</div>
		<%
				}
			}
		%>
		</fieldset>
</FORM>
<FORM ID="ADD_PROPERTY_FORM" class="form-horizontal" METHOD="POST" ACTION="<%= content %>" ENCTYPE="MULTIPART/FORM-DATA">
	<fieldset>
		<div class="control-group">
			<INPUT TYPE="HIDDEN" NAME=":redirect" VALUE="<%=slingRequest.getRequestURL()%>" />
			<INPUT TYPE="HIDDEN" NAME=":errorpage" VALUE="<%=slingRequest.getRequestURL()%>" />
			<INPUT class="input-medium" TYPE="TEXT" placeholder="new property name" NAME=":propery_name" VALUE="" required/>
			<INPUT style="margin-left:12px" TYPE="TEXT" placeholder="value" NAME=":propery_name@NameFrom" VALUE=""/>
			<BUTTON class="btn btn-success" style="margin-left:5px" TYPE="SUBMIT"><i class="icon-plus icon-white"></i></BUTTON>
		</div>
	</fieldset>
</FORM>

<sling:include resource="<%=resource%>" replaceSelectors="errorbar"/>
