<%@ page trimDirectiveWhitespaces="true" %>
<%@ page language="java" import="barcode.receive.myproject.*" %>
<%@ page language="java" import="uk.co.ambuja.myproject.ws.*" %>
<%@ page contentType="text/html; charset=ISO-8859-1" %>
<%

// extract properties from web.xml file
String endpointAddress = this.getServletContext().getInitParameter("url.informatica"); 

// extract parameters from url
String databaseName = request.getParameter("db");
String docBase = request.getParameter("docbase");
String objectID = request.getParameter("obj_id");
String barcodeNumber = request.getParameter("barcodeNumber");

// send service request to Informatica Web Service
// do not need to include error validation, as only HTTP exceptions are considered failures 
Document requestDocument = new Document(new DocumentHeader(databaseName, barcodeNumber, objectID));
Barcode wsRequest = new Barcode(requestDocument);
wsRequest.executeWS(endpointAddress);
ServiceResponse wsResponse = wsRequest.getWsResponse();
ServiceResponseHeader wsResponseHeader = wsResponse.getHeader();

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<HTML>
<HEAD>
<META http-equiv="Content-Type" content="text/xhtml; charset=ISO-8859-1">
<TITLE>myproject REST-SOAP Interface</title>
</HEAD>
<BODY bgcolor=#dddddd>
<TABLE bgcolor=#dddddd border=1width=100%>
<TR>
<TD valign=top><B>$dbAlias</B></TD>
<TD>DB</TD>
</TR>
<TR>
<TD valign=top><B>$dbParamsByOrder</B></TD>
<TD>true</TD>
</TR>
<TR>
<TD valign=top><B>inString</B></TD>
<TD><%= objectID %></TD>
</TR>
<TR>
<TD valign=top><B>$dbProc</B></TD>
<TD><%= docBase %>.dbo.usr_insert_usr_sap_barcode_update_SAPDCTM_sp</TD>
</TR>
<TR>
<TD valign=top><B>$dbProcSig</B></TD>
<TD>
<TABLE>
<TR>
<TD><TABLE bgcolor=#dddddd border=1width=100%>
<TR>
<TD valign=top><B>name</B></TD>
<TD>r_object_id</TD>
</TR>
<TR>
<TD valign=top><B>sqlType</B></TD>
<TD>CHAR</TD>
</TR>
<TR>
<TD valign=top><B>direction</B></TD>
<TD>in</TD>
</TR>
</TABLE>
</TD>
</TR>
<TR>
<TD><TABLE bgcolor=#dddddd border=1width=100%>
<TR>
<TD valign=top><B>name</B></TD>
<TD>barcode</TD>
</TR>
<TR>
<TD valign=top><B>sqlType</B></TD>
<TD>VARCHAR</TD>
</TR>
<TR>
<TD valign=top><B>direction</B></TD>
<TD>in</TD>
</TR>
</TABLE>
</TD>
</TR>
</TABLE>
</TD>
</TR>
<TR>
<TD valign=top><B>$data</B></TD>
<TD><TABLE bgcolor=#dddddd border=1width=100%>
<TR>
<TD valign=top><B>r_object_id</B></TD>
<TD><%= objectID %></TD>
</TR>
<TR>
<TD valign=top><B>barcode</B></TD>
<TD><%= barcodeNumber %></TD>
</TR>
</TABLE>
</TD>
</TR>
<TR>
<TD valign=top><B>serverName</B></TD>
<TD>SAP</TD>
</TR>
<TR>
<TD valign=top><B>$rfcname</B></TD>
<TD>Z_BAPI_ACC_BARCODE</TD>
</TR>
<TR>
<TD valign=top><B>P_BARCODE_ID</B></TD>
<TD><%= barcodeNumber %></TD>
</TR>
<TR>
<TD valign=top><B>P_DATABASE_ID</B></TD>
<TD><%= databaseName %></TD>
</TR>
<TR>
<TD valign=top><B>P_OBJECT_ID</B></TD>
<TD><%= objectID %></TD>
</TR>
<TR>
<TD valign=top><B>fileName</B></TD>
<TD>afterRecBarcode</TD>
</TR>
<TR>
<TD valign=top><B>barcodeNumber</B></TD>
<TD><%= barcodeNumber %></TD>
</TR>
<TR>
<TD valign=top><B>successFlag</B></TD>
<TD>false</TD>
</TR>
<TR>
<TD valign=top><B>barcodeNumberList</B></TD>
<TD>
<TABLE>
<TR>
<TD><%= barcodeNumber %></TD>
</TR>
</TABLE>
</TD>
</TR>
<TR>
<TD valign=top><B>obj_id</B></TD>
<TD><%= objectID %></TD>
</TR>
<TR>
<TD valign=top><B>obj_idList</B></TD>
<TD>
<TABLE>
<TR>
<TD><%= objectID %></TD>
</TR>
</TABLE>
</TD>
</TR>
<TR>
<TD valign=top><B>db</B></TD>
<TD><%= databaseName %></TD>
</TR>
<TR>
<TD valign=top><B>dbList</B></TD>
<TD>
<TABLE>
<TR>
<TD><%= databaseName %></TD>
</TR>
</TABLE>
</TD>
</TR>
<TR>
<TD valign=top><B>docbase</B></TD>
<TD><%= docBase %></TD>
</TR>
<TR>
<TD valign=top><B>docbaseList</B></TD>
<TD>
<TABLE>
<TR>
<TD><%= docBase %></TD>
</TR>
</TABLE>
</TD>
</TR>
<TR>
<TD valign=top><B>RETURN</B></TD>
<TD><TABLE bgcolor=#dddddd border=1width=100%>
<TR>
<TD valign=top><B>STATUS</B></TD>
<TD><%= wsResponseHeader.getStatus() %></TD>
</TR>
<TR>
<TD valign=top><B>MESSAGE</B></TD>
<TD><%= wsResponseHeader.getMessage() %></TD>
</TR>
</TABLE>
</TD>
</TR>
<TR>
<TD valign=top><B>$runtime</B></TD>
<TD>null</TD>
</TR>
<TR>
<TD valign=top><B>$rfctime</B></TD>
<TD>null</TD>
</TR>
<TR>
<TD valign=top><B>$encoding</B></TD>
<TD>UTF-16</TD>
</TR>
<TR>
<TD valign=top><B>$call</B></TD>
<TD>false</TD>
</TR>
<TR>
<TD valign=top><B>value</B></TD>
<TD><%= objectID %></TD>
</TR>
<TR>
<TD valign=top><B>$dbLocalizedMessage</B></TD>
<TD>null</TD>
</TR>
<TR>
<TD valign=top><B>$dbMessage</B></TD>
<TD>null</TD>
</TR>
</TABLE>
</BODY>
</HTML>
