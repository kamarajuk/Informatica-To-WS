<%@ page trimDirectiveWhitespaces="true" %>
<%@ page language="java" import="data.send.myproject.*" %>
<%@ page language="java" import="uk.co.ambuja.myproject.ws.*" %>
<%@ page import="org.apache.axis.message.MessageElement" %>
<%@ page import="javax.xml.namespace.QName" %>
<%@ page contentType="text/xml; charset=utf-8" %>
<?xml version="1.0" encoding="utf-8" ?>
<%

MessageElement me;
String outXML = "";

// extract properties from web.xml file
String endpointAddress = this.getServletContext().getInitParameter("url.informatica"); 

// extract parameters from url
String objectID = request.getParameter("obj_id");
String dbID = request.getParameter("db");

try {
   	
	// send service request to Informatica Web Service
    Document requestDocument = new Document(new DocumentHeader(objectID, dbID));
    SendData wsRequest = new SendData(requestDocument);
    wsRequest.executeWS(endpointAddress);
    ServiceResponse wsResponse = wsRequest.getWsResponse();
    me = new MessageElement(new QName(null, ">document"), wsResponse);
    
    ServiceResponseIas_header responseHeader = wsResponse.getIas_header();
    
    if(responseHeader.getReturn_status().equals("W"))
    {
    	throw new Exception(responseHeader.getReturn_message());
    }
    
    // Removes all NS information. This isn't actually required but proved to be
    // working this way during testing
    
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
 	
 	outXML = outXML.replaceAll(" xmlns\\:ns1=\"uri\\:myproject\\.send\\.data\"","");
 	outXML = outXML.replaceAll(" xmlns\\:ns2=\"uri\\:myproject\\.send\\.data\"","");
 	outXML = outXML.replaceAll(" xmlns\\:ns3=\"uri\\:myproject\\.send\\.data\"","");
 	
 	outXML = outXML.replaceAll("ns1:detail","detail");
 	outXML = outXML.replaceAll("ns2:message","message");
 	outXML = outXML.replaceAll("ns3:doc_ref","doc_ref");
 	
 	outXML = outXML.replaceAll(" soapenc\\:arrayType=\"ns1\\:\\&gt\\;\\&gt\\;\\&gt\\;serviceResponse\\&gt\\;details\\&gt\\;detail\\[[0-9]+\\]\"","");
 	outXML = outXML.replaceAll(" soapenc\\:arrayType=\"ns2\\:\\&gt\\;\\&gt\\;\\&gt\\;serviceResponse\\&gt\\;messages\\&gt\\;message\\[[0-9]+\\]\"","");
 	outXML = outXML.replaceAll(" soapenc\\:arrayType=\"ns3\\:\\&gt\\;\\&gt\\;\\&gt\\;serviceResponse\\&gt\\;doc_refs\\&gt\\;doc_ref\\[[0-9]+\\]\"","");
 	
	// Remove additional attributes before response is validated against XSD in DFM
	
 	outXML = outXML.replaceAll("\\<return_status\\>(.*)\\<\\/return_status\\>","");
 	outXML = outXML.replaceAll("\\<return_message\\>(.*)\\<\\/return_message\\>","");
	
} catch (Exception e) {
  	
	// format to the expected xml error response 
	
	String thisError = e.toString();
	thisError = thisError.replaceFirst("java\\.lang\\.Exception\\: ", "");
	
    // add error message to children error xml elements
    MessageElement statusME = new MessageElement(new QName(null, ">status"), "W");
    MessageElement messageME = new MessageElement(new QName(null, ">message"), thisError);
        
    // add children elements to the parent xml element
    me = new MessageElement(new QName(null, ">message"));
    me.addChildElement(statusME);
    me.addChildElement(messageME);
    
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
    
}

%>
<%= outXML %>
