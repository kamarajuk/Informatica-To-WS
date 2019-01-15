<%@ page trimDirectiveWhitespaces="true" %>
<%@ page language="java" import="validate.invoice.myproject.*" %>
<%@ page language="java" import="uk.co.agilesolutions.myproject.ws.*" %>
<%@ page language="java" import="uk.co.agilesolutions.myproject.sax.*" %>
<%@ page import="org.apache.axis.message.MessageElement" %>
<%@ page import="org.xml.sax.InputSource" %>
<%@ page import="java.io.StringReader" %>
<%@ page import="java.math.BigInteger" %>
<%@ page import="javax.xml.namespace.QName" %>
<%@ page import="javax.xml.parsers.SAXParser" %>
<%@ page import="javax.xml.parsers.SAXParserFactory" %>
<%@ page contentType="text/xml; charset=utf-8" %>
<?xml version="1.0" encoding="utf-8" ?>
<%

ServiceResponse wsResponse = new ServiceResponse();
String outXML = "";

// extract properties from web.xml file
String endpointAddress = this.getServletContext().getInitParameter("url.informatica");

// extract parameters from url
String xmlData = request.getParameter("xmldata");

try {

    // send service request to Informatica Web Service
    SAXParserFactory parserFactor = SAXParserFactory.newInstance();
    SAXParser parser = parserFactor.newSAXParser();
    ParseValidate handler = new ParseValidate();
    parser.parse(new InputSource(new StringReader(xmlData)), handler);
        
    Validate wsRequest = new Validate(handler.getDocument());
    wsRequest.executeWS(endpointAddress);
    wsResponse = wsRequest.getWsResponse();
    
    ServiceResponseHeader responseHeader = wsResponse.getHeader();
    
    if(responseHeader.getCode().equals("S"))
    {
    	String origMessage = responseHeader.getMessage();
    	
    	//responseHeader.setMessage("<![CDATA[  " + origMessage + "  ]]>");
    }
    
} catch (Exception e) {
    
    // build up service response containing the error details
    ServiceResponseHeader errorHeader = new ServiceResponseHeader("E",  e.toString());
    wsResponse.setHeader(errorHeader);
    
}

// return response wrapped in appropriate tags
MessageElement me = new MessageElement(new QName(null, ">serviceResponse"), wsResponse);

outXML = me.getAsString();
outXML = outXML.replaceAll(" xsi\\:type=\"xsd\\:string\"","");
outXML = outXML.replaceAll(" xsi\\:type=\"xsd\\:decimal\"","");
outXML = outXML.replaceAll(" xsi\\:type=\"xsd\\:date\"","");
outXML = outXML.replaceAll(" xsi\\:type=\"xsd\\:integer\"","");
outXML = outXML.replaceAll(" xsi\\:nil=\"true\"","");
outXML = outXML.replaceAll(" xsi\\:type=\"soapenc\\:Array\"","");

outXML = outXML.replaceAll(" xmlns\\:xsi=\"http\\:\\/\\/www\\.w3\\.org\\/2001\\/XMLSchema\\-instance\"","");
outXML = outXML.replaceAll(" xmlns\\:xsd=\"http\\:\\/\\/www\\.w3\\.org\\/2001\\/XMLSchema\"","");
outXML = outXML.replaceAll(" xmlns\\:soapenc=\"http\\:\\/\\/schemas\\.xmlsoap\\.org\\/soap\\/encoding\\/\"","");
	
outXML = outXML.replaceAll(" xmlns\\:ns1=\"uri\\:myproject\\.invoice\\.validate\"","");
	
outXML = outXML.replaceAll("ns1:detail","detail");

outXML = outXML.replaceAll(" soapenc\\:arrayType=\"ns1\\:\\&gt\\;\\&gt\\;\\&gt\\;serviceResponse\\&gt\\;details\\&gt\\;detail\\[[0-9]+\\]\"","");
%>
<%= outXML %>
