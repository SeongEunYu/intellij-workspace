<%@ page contentType="text/html; charset=EUC-KR"%>

<%
	response.setContentType("text/html; charset=EUC-KR");
	response.setHeader("Content-Disposition", "attachment;filename=db.doc;");
	response.setHeader("Content-Description", "테이블명세서");
%>

<%@ page import="oracle.jdbc.driver.*"%>
<%@ page import="javax.naming.*"%>
<%@ page import="javax.sql.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="javax.rmi.PortableRemoteObject"%>

<%!
  public String isnull(String str) {
		if (str == null) { return ""; }
		return str;
  }
%>

<html>

<head>
<meta http-equiv=Content-Type content="text/html; charset=ks_c_5601-1987">
<meta name=Generator content="Microsoft Word 11 (filtered)">
<title>테이블명세서</title>

<style>
<!-- /* Font Definitions */
@font-face {
	font-family: Helvetica;
	panose-1: 2 11 6 4 2 2 2 2 2 4;
}

@font-face {
	font-family: Helv;
	panose-1: 2 11 6 4 2 2 2 3 2 4;
}

@font-face {
	font-family: Wingdings;
	panose-1: 5 0 0 0 0 0 0 0 0 0;
}

@font-face {
	font-family: 돋움;
	panose-1: 2 11 6 0 0 1 1 1 1 1;
}

@font-face {
	font-family: 굴림;
	panose-1: 2 11 6 0 0 1 1 1 1 1;
}

@font-face {
	font-family: 굴림체;
	panose-1: 2 11 6 9 0 1 1 1 1 1;
}

@font-face {
	font-family: "\@굴림";
	panose-1: 2 11 6 0 0 1 1 1 1 1;
}

@font-face {
	font-family: 바탕체;
	panose-1: 2 3 6 9 0 1 1 1 1 1;
}

@font-face {
	font-family: "\@굴림체";
	panose-1: 2 11 6 9 0 1 1 1 1 1;
}

@font-face {
	font-family: "\@돋움";
	panose-1: 2 11 6 0 0 1 1 1 1 1;
}

@font-face {
	font-family: 돋움체;
	panose-1: 2 11 6 9 0 1 1 1 1 1;
}

@font-face {
	font-family: "\@돋움체";
	panose-1: 2 11 6 9 0 1 1 1 1 1;
}

@font-face {
	font-family: "\@바탕체";
	panose-1: 2 3 6 9 0 1 1 1 1 1;
}

@font-face {
	font-family: "Book Antiqua";
	panose-1: 2 4 6 2 5 3 5 3 3 4;
}

@font-face {
	font-family: "MS Sans Serif";
	panose-1: 0 0 0 0 0 0 0 0 0 0;
}
/* Style Definitions */
p.MsoNormal, li.MsoNormal, div.MsoNormal {
	margin: 0cm;
	margin-bottom: .0001pt;
	punctuation-wrap: simple;
	text-autospace: none;
	font-size: 10.0pt;
	font-family: "Book Antiqua";
}

h1 {
	margin-top: 12.0pt;
	margin-right: 0cm;
	margin-bottom: 12.0pt;
	margin-left: 21.25pt;
	text-indent: -21.25pt;
	line-height: 12.0pt;
	page-break-after: avoid;
	punctuation-wrap: simple;
	text-autospace: none;
	font-size: 10.0pt;
	font-family: Arial;
	font-weight: bold;
}

h2 {
	margin-top: 12.0pt;
	margin-right: 0cm;
	margin-bottom: 6.0pt;
	margin-left: 21.25pt;
	text-indent: -21.25pt;
	page-break-after: avoid;
	punctuation-wrap: simple;
	text-autospace: none;
	font-size: 10.0pt;
	font-family: Arial;
	font-weight: bold;
}

h3 {
	margin-top: 6.0pt;
	margin-right: 0cm;
	margin-bottom: 6.0pt;
	margin-left: 21.25pt;
	text-indent: -21.25pt;
	page-break-after: avoid;
	punctuation-wrap: simple;
	text-autospace: none;
	font-size: 10.0pt;
	font-family: "Book Antiqua";
	font-weight: bold;
}

h4 {
	margin-top: 12.0pt;
	margin-right: 0cm;
	margin-bottom: 0cm;
	margin-left: 21.25pt;
	margin-bottom: .0001pt;
	text-indent: -21.25pt;
	page-break-after: avoid;
	punctuation-wrap: simple;
	text-autospace: none;
	font-size: 10.0pt;
	font-family: Arial;
	font-weight: bold;
}

h5 {
	margin-top: 12.0pt;
	margin-right: 0cm;
	margin-bottom: 3.0pt;
	margin-left: 180.0pt;
	text-indent: -36.0pt;
	punctuation-wrap: simple;
	text-autospace: none;
	font-size: 11.0pt;
	font-family: Arial;
	font-weight: normal;
}

h6 {
	margin-top: 12.0pt;
	margin-right: 0cm;
	margin-bottom: 3.0pt;
	margin-left: 216.0pt;
	text-indent: -36.0pt;
	punctuation-wrap: simple;
	text-autospace: none;
	font-size: 11.0pt;
	font-family: "Times New Roman";
	font-weight: normal;
	font-style: italic;
}

p.MsoHeading7, li.MsoHeading7, div.MsoHeading7 {
	margin-top: 12.0pt;
	margin-right: 0cm;
	margin-bottom: 3.0pt;
	margin-left: 252.0pt;
	text-indent: -36.0pt;
	punctuation-wrap: simple;
	text-autospace: none;
	font-size: 10.0pt;
	font-family: Arial;
}

p.MsoHeading8, li.MsoHeading8, div.MsoHeading8 {
	margin-top: 12.0pt;
	margin-right: 0cm;
	margin-bottom: 3.0pt;
	margin-left: 288.0pt;
	text-indent: -36.0pt;
	punctuation-wrap: simple;
	text-autospace: none;
	font-size: 10.0pt;
	font-family: Arial;
	font-style: italic;
}

p.MsoHeading9, li.MsoHeading9, div.MsoHeading9 {
	margin-top: 12.0pt;
	margin-right: 0cm;
	margin-bottom: 3.0pt;
	margin-left: 324.0pt;
	text-indent: -36.0pt;
	punctuation-wrap: simple;
	text-autospace: none;
	font-size: 9.0pt;
	font-family: Arial;
	font-weight: bold;
	font-style: italic;
}

p.MsoIndex1, li.MsoIndex1, div.MsoIndex1 {
	margin-top: 0cm;
	margin-right: 0cm;
	margin-bottom: 0cm;
	margin-left: 21.25pt;
	margin-bottom: .0001pt;
	text-indent: -21.25pt;
	punctuation-wrap: simple;
	text-autospace: none;
	font-size: 10.0pt;
	font-family: "Book Antiqua";
}

p.MsoIndex2, li.MsoIndex2, div.MsoIndex2 {
	margin-top: 0cm;
	margin-right: 0cm;
	margin-bottom: 0cm;
	margin-left: 42.5pt;
	margin-bottom: .0001pt;
	text-indent: -21.25pt;
	punctuation-wrap: simple;
	text-autospace: none;
	font-size: 10.0pt;
	font-family: "Book Antiqua";
}

p.MsoIndex3, li.MsoIndex3, div.MsoIndex3 {
	margin-top: 0cm;
	margin-right: 0cm;
	margin-bottom: 0cm;
	margin-left: 63.75pt;
	margin-bottom: .0001pt;
	text-indent: -21.25pt;
	punctuation-wrap: simple;
	text-autospace: none;
	font-size: 10.0pt;
	font-family: "Book Antiqua";
}

p.MsoIndex4, li.MsoIndex4, div.MsoIndex4 {
	margin-top: 0cm;
	margin-right: 0cm;
	margin-bottom: 0cm;
	margin-left: 85.0pt;
	margin-bottom: .0001pt;
	text-indent: -21.25pt;
	punctuation-wrap: simple;
	text-autospace: none;
	font-size: 10.0pt;
	font-family: "Book Antiqua";
}

p.MsoIndex5, li.MsoIndex5, div.MsoIndex5 {
	margin-top: 0cm;
	margin-right: 0cm;
	margin-bottom: 0cm;
	margin-left: 106.25pt;
	margin-bottom: .0001pt;
	text-indent: -21.25pt;
	punctuation-wrap: simple;
	text-autospace: none;
	font-size: 10.0pt;
	font-family: "Book Antiqua";
}

p.MsoIndex6, li.MsoIndex6, div.MsoIndex6 {
	margin-top: 0cm;
	margin-right: 0cm;
	margin-bottom: 0cm;
	margin-left: 127.5pt;
	margin-bottom: .0001pt;
	text-indent: -21.25pt;
	punctuation-wrap: simple;
	text-autospace: none;
	font-size: 10.0pt;
	font-family: "Book Antiqua";
}

p.MsoIndex7, li.MsoIndex7, div.MsoIndex7 {
	margin-top: 0cm;
	margin-right: 0cm;
	margin-bottom: 0cm;
	margin-left: 148.75pt;
	margin-bottom: .0001pt;
	text-indent: -21.25pt;
	punctuation-wrap: simple;
	text-autospace: none;
	font-size: 10.0pt;
	font-family: "Book Antiqua";
}

p.MsoIndex8, li.MsoIndex8, div.MsoIndex8 {
	margin-top: 0cm;
	margin-right: 0cm;
	margin-bottom: 0cm;
	margin-left: 170.0pt;
	margin-bottom: .0001pt;
	text-indent: -21.25pt;
	punctuation-wrap: simple;
	text-autospace: none;
	font-size: 10.0pt;
	font-family: "Book Antiqua";
}

p.MsoIndex9, li.MsoIndex9, div.MsoIndex9 {
	margin-top: 0cm;
	margin-right: 0cm;
	margin-bottom: 0cm;
	margin-left: 191.25pt;
	margin-bottom: .0001pt;
	text-indent: -21.25pt;
	punctuation-wrap: simple;
	text-autospace: none;
	font-size: 10.0pt;
	font-family: "Book Antiqua";
}

p.MsoToc1, li.MsoToc1, div.MsoToc1 {
	margin-top: 6.0pt;
	margin-right: 0cm;
	margin-bottom: 6.0pt;
	margin-left: 0cm;
	text-align: justify;
	text-justify: inter-ideograph;
	punctuation-wrap: simple;
	text-autospace: none;
	font-size: 10.0pt;
	font-family: "Times New Roman";
	text-transform: uppercase;
	font-weight: bold;
}

p.MsoToc2, li.MsoToc2, div.MsoToc2 {
	margin-top: 0cm;
	margin-right: 0cm;
	margin-bottom: 0cm;
	margin-left: 14.2pt;
	margin-bottom: .0001pt;
	text-align: justify;
	text-justify: inter-ideograph;
	punctuation-wrap: simple;
	text-autospace: none;
	font-size: 10.0pt;
	font-family: "Times New Roman";
	font-variant: small-caps;
}

p.MsoToc3, li.MsoToc3, div.MsoToc3 {
	margin-top: 0cm;
	margin-right: 0cm;
	margin-bottom: 0cm;
	margin-left: 1.0cm;
	margin-bottom: .0001pt;
	punctuation-wrap: simple;
	text-autospace: none;
	font-size: 10.0pt;
	font-family: "Times New Roman";
	font-variant: small-caps;
}

p.MsoToc4, li.MsoToc4, div.MsoToc4 {
	margin-top: 0cm;
	margin-right: 0cm;
	margin-bottom: 0cm;
	margin-left: 30.0pt;
	margin-bottom: .0001pt;
	punctuation-wrap: simple;
	text-autospace: none;
	font-size: 9.0pt;
	font-family: "Times New Roman";
}

p.MsoToc5, li.MsoToc5, div.MsoToc5 {
	margin-top: 0cm;
	margin-right: 0cm;
	margin-bottom: 0cm;
	margin-left: 40.0pt;
	margin-bottom: .0001pt;
	punctuation-wrap: simple;
	text-autospace: none;
	font-size: 9.0pt;
	font-family: "Times New Roman";
}

p.MsoToc6, li.MsoToc6, div.MsoToc6 {
	margin-top: 0cm;
	margin-right: 0cm;
	margin-bottom: 0cm;
	margin-left: 50.0pt;
	margin-bottom: .0001pt;
	punctuation-wrap: simple;
	text-autospace: none;
	font-size: 9.0pt;
	font-family: "Times New Roman";
}

p.MsoToc7, li.MsoToc7, div.MsoToc7 {
	margin-top: 0cm;
	margin-right: 0cm;
	margin-bottom: 0cm;
	margin-left: 60.0pt;
	margin-bottom: .0001pt;
	punctuation-wrap: simple;
	text-autospace: none;
	font-size: 9.0pt;
	font-family: "Times New Roman";
}

p.MsoToc8, li.MsoToc8, div.MsoToc8 {
	margin-top: 0cm;
	margin-right: 0cm;
	margin-bottom: 0cm;
	margin-left: 70.0pt;
	margin-bottom: .0001pt;
	punctuation-wrap: simple;
	text-autospace: none;
	font-size: 9.0pt;
	font-family: "Times New Roman";
}

p.MsoToc9, li.MsoToc9, div.MsoToc9 {
	margin-top: 0cm;
	margin-right: 0cm;
	margin-bottom: 0cm;
	margin-left: 80.0pt;
	margin-bottom: .0001pt;
	punctuation-wrap: simple;
	text-autospace: none;
	font-size: 9.0pt;
	font-family: "Times New Roman";
}

p.MsoHeader, li.MsoHeader, div.MsoHeader {
	margin: 0cm;
	margin-bottom: .0001pt;
	punctuation-wrap: simple;
	text-autospace: none;
	font-size: 10.0pt;
	font-family: "Book Antiqua";
}

p.MsoFooter, li.MsoFooter, div.MsoFooter {
	margin: 0cm;
	margin-bottom: .0001pt;
	punctuation-wrap: simple;
	text-autospace: none;
	font-size: 10.0pt;
	font-family: "Book Antiqua";
}

p.MsoIndexHeading, li.MsoIndexHeading, div.MsoIndexHeading {
	margin: 0cm;
	margin-bottom: .0001pt;
	punctuation-wrap: simple;
	text-autospace: none;
	font-size: 10.0pt;
	font-family: "Book Antiqua";
}

p.MsoTitle, li.MsoTitle, div.MsoTitle {
	margin-top: 6.0pt;
	margin-right: 0cm;
	margin-bottom: 12.0pt;
	margin-left: 42.5pt;
	text-align: center;
	text-indent: -42.5pt;
	page-break-after: avoid;
	punctuation-wrap: simple;
	text-autospace: none;
	font-size: 18.0pt;
	font-family: Helvetica;
	font-weight: bold;
}

p.MsoBodyText, li.MsoBodyText, div.MsoBodyText {
	margin-top: 0cm;
	margin-right: 0cm;
	margin-bottom: 6.0pt;
	margin-left: 0cm;
	punctuation-wrap: simple;
	text-autospace: none;
	font-size: 10.0pt;
	font-family: "Book Antiqua";
}

a:link, span.MsoHyperlink {
	color: blue;
	text-decoration: underline;
}

a:visited, span.MsoHyperlinkFollowed {
	color: purple;
	text-decoration: underline;
}

p.MsoDocumentMap, li.MsoDocumentMap, div.MsoDocumentMap {
	margin: 0cm;
	margin-bottom: .0001pt;
	background: navy;
	punctuation-wrap: simple;
	text-autospace: none;
	font-size: 10.0pt;
	font-family: Arial;
}

p {
	margin-right: 0cm;
	margin-left: 0cm;
	font-size: 12.0pt;
	font-family: 굴림;
}

p.Bodytext, li.Bodytext, div.Bodytext {
	margin-top: 0cm;
	margin-right: 0cm;
	margin-bottom: 6.0pt;
	margin-left: 22.5pt;
	punctuation-wrap: simple;
	text-autospace: none;
	font-size: 10.0pt;
	font-family: Arial;
}

p.Text, li.Text, div.Text {
	margin-top: 0cm;
	margin-right: 0cm;
	margin-bottom: 6.0pt;
	margin-left: 90.0pt;
	punctuation-wrap: simple;
	text-autospace: none;
	font-size: 10.0pt;
	font-family: Arial;
}

p.Bullet, li.Bullet, div.Bullet {
	margin-top: 0cm;
	margin-right: 0cm;
	margin-bottom: 6.0pt;
	margin-left: 54.0pt;
	text-indent: -18.0pt;
	punctuation-wrap: simple;
	text-autospace: none;
	font-size: 10.0pt;
	font-family: Arial;
}

p.Indent, li.Indent, div.Indent {
	margin-top: 6.0pt;
	margin-right: 0cm;
	margin-bottom: 0cm;
	margin-left: 36.0pt;
	margin-bottom: .0001pt;
	page-break-after: avoid;
	punctuation-wrap: simple;
	text-autospace: none;
	font-size: 10.0pt;
	font-family: "Book Antiqua";
}

p.blankpage, li.blankpage, div.blankpage {
	margin-top: 275.0pt;
	margin-right: 0cm;
	margin-bottom: 275.0pt;
	margin-left: 0cm;
	text-align: center;
	page-break-before: always;
	punctuation-wrap: simple;
	text-autospace: none;
	font-size: 10.0pt;
	font-family: "Book Antiqua";
}

p.TextBullet, li.TextBullet, div.TextBullet {
	margin-top: 0cm;
	margin-right: 0cm;
	margin-bottom: 0cm;
	margin-left: 108.0pt;
	margin-bottom: .0001pt;
	text-indent: -18.0pt;
	punctuation-wrap: simple;
	text-autospace: none;
	font-size: 10.0pt;
	font-family: Arial;
}

p.TextBullet2, li.TextBullet2, div.TextBullet2 {
	margin-top: 0cm;
	margin-right: 0cm;
	margin-bottom: 6.0pt;
	margin-left: 108.0pt;
	text-indent: -18.0pt;
	punctuation-wrap: simple;
	text-autospace: none;
	font-size: 10.0pt;
	font-family: Arial;
}

p.Graphic, li.Graphic, div.Graphic {
	margin-top: 12.0pt;
	margin-right: 0cm;
	margin-bottom: 12.0pt;
	margin-left: 0cm;
	text-align: center;
	punctuation-wrap: simple;
	text-autospace: none;
	font-size: 10.0pt;
	font-family: Arial;
}

p.Bullet2, li.Bullet2, div.Bullet2 {
	margin-top: 0cm;
	margin-right: 0cm;
	margin-bottom: 0cm;
	margin-left: 90.0pt;
	margin-bottom: .0001pt;
	text-indent: -18.0pt;
	punctuation-wrap: simple;
	text-autospace: none;
	font-size: 10.0pt;
	font-family: "Book Antiqua";
}

p.Bullet3, li.Bullet3, div.Bullet3 {
	margin-top: 0cm;
	margin-right: 0cm;
	margin-bottom: 0cm;
	margin-left: 126.0pt;
	margin-bottom: .0001pt;
	text-indent: -18.0pt;
	punctuation-wrap: simple;
	text-autospace: none;
	font-size: 10.0pt;
	font-family: "Book Antiqua";
}

p.Bullet4, li.Bullet4, div.Bullet4 {
	margin-top: 0cm;
	margin-right: 0cm;
	margin-bottom: 0cm;
	margin-left: 162.0pt;
	margin-bottom: .0001pt;
	text-indent: -18.0pt;
	punctuation-wrap: simple;
	text-autospace: none;
	font-size: 10.0pt;
	font-family: "Book Antiqua";
	color: black;
}

p.Indent2, li.Indent2, div.Indent2 {
	margin-top: 6.0pt;
	margin-right: 0cm;
	margin-bottom: 0cm;
	margin-left: 0cm;
	margin-bottom: .0001pt;
	punctuation-wrap: simple;
	text-autospace: none;
	font-size: 10.0pt;
	font-family: "Book Antiqua";
	color: black;
}

p.Indent3, li.Indent3, div.Indent3 {
	margin-top: 6.0pt;
	margin-right: 0cm;
	margin-bottom: 0cm;
	margin-left: 108.0pt;
	margin-bottom: .0001pt;
	punctuation-wrap: simple;
	text-autospace: none;
	font-size: 10.0pt;
	font-family: "Book Antiqua";
}

p.Indent4, li.Indent4, div.Indent4 {
	margin-top: 6.0pt;
	margin-right: 0cm;
	margin-bottom: 0cm;
	margin-left: 126.0pt;
	margin-bottom: .0001pt;
	punctuation-wrap: simple;
	text-autospace: none;
	font-size: 10.0pt;
	font-family: "Book Antiqua";
	color: black;
}

p.Bodytext3, li.Bodytext3, div.Bodytext3 {
	margin-top: 0cm;
	margin-right: 0cm;
	margin-bottom: 6.0pt;
	margin-left: 36.0pt;
	punctuation-wrap: simple;
	text-autospace: none;
	font-size: 10.0pt;
	font-family: Arial;
}

p.TitlePageMainHead, li.TitlePageMainHead, div.TitlePageMainHead {
	margin-top: 96.0pt;
	margin-right: 0cm;
	margin-bottom: 0cm;
	margin-left: 0cm;
	margin-bottom: .0001pt;
	text-align: right;
	line-height: 36.0pt;
	punctuation-wrap: simple;
	text-autospace: none;
	font-size: 24.0pt;
	font-family: "Times New Roman";
	font-weight: bold;
}

p.Indent1, li.Indent1, div.Indent1 {
	margin-top: 0cm;
	margin-right: 0cm;
	margin-bottom: 0cm;
	margin-left: 36.0pt;
	margin-bottom: .0001pt;
	punctuation-wrap: simple;
	text-autospace: none;
	font-size: 10.0pt;
	font-family: "Book Antiqua";
}

p.Normal1stindent, li.Normal1stindent, div.Normal1stindent {
	margin-top: 0cm;
	margin-right: 0cm;
	margin-bottom: 0cm;
	margin-left: 108.0pt;
	margin-bottom: .0001pt;
	punctuation-wrap: simple;
	text-autospace: none;
	font-size: 10.0pt;
	font-family: "Book Antiqua";
}

p.Normal2ndindent, li.Normal2ndindent, div.Normal2ndindent {
	margin-top: 0cm;
	margin-right: 0cm;
	margin-bottom: 0cm;
	margin-left: 144.0pt;
	margin-bottom: .0001pt;
	punctuation-wrap: simple;
	text-autospace: none;
	font-size: 10.0pt;
	font-family: "Book Antiqua";
}

p.Note, li.Note, div.Note {
	margin-top: 6.0pt;
	margin-right: 0cm;
	margin-bottom: 0cm;
	margin-left: 72.0pt;
	margin-bottom: .0001pt;
	punctuation-wrap: simple;
	text-autospace: none;
	font-size: 10.0pt;
	font-family: "Book Antiqua";
}

p.Note2, li.Note2, div.Note2 {
	margin-top: 6.0pt;
	margin-right: 0cm;
	margin-bottom: 0cm;
	margin-left: 108.0pt;
	margin-bottom: .0001pt;
	punctuation-wrap: simple;
	text-autospace: none;
	font-size: 10.0pt;
	font-family: "Book Antiqua";
}

p.Note3, li.Note3, div.Note3 {
	margin-top: 6.0pt;
	margin-right: 0cm;
	margin-bottom: 0cm;
	margin-left: 144.0pt;
	margin-bottom: .0001pt;
	text-indent: -36.0pt;
	punctuation-wrap: simple;
	text-autospace: none;
	font-size: 10.0pt;
	font-family: "Book Antiqua";
}

p.Note4, li.Note4, div.Note4 {
	margin-top: 6.0pt;
	margin-right: 0cm;
	margin-bottom: 0cm;
	margin-left: 162.0pt;
	margin-bottom: .0001pt;
	text-indent: -36.0pt;
	punctuation-wrap: simple;
	text-autospace: none;
	font-size: 10.0pt;
	font-family: "Book Antiqua";
}

p.Style1, li.Style1, div.Style1 {
	margin-top: 0cm;
	margin-right: 0cm;
	margin-bottom: 6.0pt;
	margin-left: 126.0pt;
	text-indent: -18.0pt;
	punctuation-wrap: simple;
	text-autospace: none;
	font-size: 10.0pt;
	font-family: Arial;
}

p.TableText, li.TableText, div.TableText {
	margin-top: 0cm;
	margin-right: 0cm;
	margin-bottom: 3.0pt;
	margin-left: 0cm;
	text-indent: 0cm;
	punctuation-wrap: simple;
	text-autospace: none;
	font-size: 10.0pt;
	font-family: "Book Antiqua";
}

p.Title12, li.Title12, div.Title12 {
	margin-top: 6.0pt;
	margin-right: 0cm;
	margin-bottom: 12.0pt;
	margin-left: 36.0pt;
	text-align: center;
	text-indent: -36.0pt;
	page-break-after: avoid;
	punctuation-wrap: simple;
	text-autospace: none;
	font-size: 12.0pt;
	font-family: Arial;
	font-weight: bold;
}

p.TOCHeading, li.TOCHeading, div.TOCHeading {
	margin-top: 12.0pt;
	margin-right: 0cm;
	margin-bottom: 12.0pt;
	margin-left: 36.0pt;
	text-align: center;
	text-indent: -36.0pt;
	page-break-after: avoid;
	punctuation-wrap: simple;
	text-autospace: none;
	font-size: 16.0pt;
	font-family: Arial;
	font-weight: bold;
}

p.AuthorDateTitlePa, li.AuthorDateTitlePa, div.AuthorDateTitlePa {
	margin: 0cm;
	margin-bottom: .0001pt;
	text-align: right;
	line-height: 12.0pt;
	punctuation-wrap: simple;
	text-autospace: none;
	font-size: 10.0pt;
	font-family: "Times New Roman";
	font-style: italic;
}

p.Approvals, li.Approvals, div.Approvals {
	margin: 0cm;
	margin-bottom: .0001pt;
	punctuation-wrap: simple;
	text-autospace: none;
	font-size: 12.0pt;
	font-family: Arial;
	font-weight: bold;
}

p.a, li.a, div.a {
	margin-top: 6.0pt;
	margin-right: 0cm;
	margin-bottom: 6.0pt;
	margin-left: 0cm;
	text-align: justify;
	text-justify: inter-ideograph;
	line-height: 18.0pt;
	word-break: break-hangul;
	font-size: 11.0pt;
	font-family: "Times New Roman";
}

p.standard, li.standard, div.standard {
	margin-top: 0cm;
	margin-right: 0cm;
	margin-bottom: 8.0pt;
	margin-left: 0cm;
	line-height: 15.0pt;
	font-size: 11.0pt;
	font-family: Arial;
}

p.a0, li.a0, div.a0 {
	margin: 0cm;
	margin-bottom: .0001pt;
	text-align: justify;
	text-justify: inter-ideograph;
	line-height: 124%;
	text-autospace: none;
	word-break: break-hangul;
	font-size: 10.0pt;
	font-family: 바탕체;
	color: black;
}

p.1, li.1, div.1 {
	margin-top: 6.0pt;
	margin-right: 0cm;
	margin-bottom: 0cm;
	margin-left: 19.85pt;
	margin-bottom: .0001pt;
	text-indent: -19.85pt;
	punctuation-wrap: simple;
	text-autospace: none;
	font-size: 10.0pt;
	font-family: "Times New Roman";
}
/* Page Definitions */
@page Section1 {
	size: 612.0pt 792.0pt;
	margin: 2.0cm 89.85pt 2.0cm 89.85pt;
}

div.Section1 {
	page: Section1;
}
/* List Definitions */
ol {
	margin-bottom: 0cm;
}

ul {
	margin-bottom: 0cm;
}
-->
</style>

</head>

<body lang=KO link=blue vlink=purple>
	<div class=Section1>


		<p class=MsoNormal>
			<span lang=EN-US>&nbsp;</span>
		</p>

		<%
			//Context ctx = null;
			//DataSource ds = null;
			Connection conDs = null;
			Statement stmt = null;
			Statement stmt2 = null;
			ResultSet rs = null;

			try {
				String query = new String();
				String querysub = new String();

				Class.forName("oracle.jdbc.driver.OracleDriver");
				Connection conn = null;
				conDs = DriverManager.getConnection("jdbc:oracle:thin:@143.248.118.11:1521:rims2", "rims", "rims");

				//	ctx = new InitialContext();
				//	ds = (DataSource) ctx.lookup("xe");
				//	conDs = ds.getConnection();

				stmt = conDs.createStatement();
				stmt2 = conDs.createStatement();

				query = " SELECT NVL(A.TNAME,' '), NVL(B.COMMENTS,' ') FROM TAB A, ALL_TAB_COMMENTS B WHERE A.TNAME = B.TABLE_NAME  and A.TNAME not like 'CBO%' and A.TNAME not like 'NKR%' order by A.TNAME ";
				rs = stmt.executeQuery(query);
				ResultSet rssub = null;

				while (rs.next()) {
		%>

		<%
			querysub = "";
					querysub = querysub + " SELECT";
					querysub = querysub + " NVL(A.TABLE_NAME,' ') TABLE_NAME,";
					querysub = querysub + " NVL(A.COLUMN_NAME,' ') COLUMN_NAME,";
					querysub = querysub + " NVL(A.COMMENTS,' ') COMMENTS,";
					querysub = querysub + " NVL(B.COLTYPE,' ') COLTYPE,";
					querysub = querysub + " NVL(B.WIDTH, 0) WIDTH,";
					querysub = querysub + " NVL(B.NULLS,' ') NULLS,";
					querysub = querysub + " (";
					querysub = querysub + " select DECODE(C.COLUMN_NAME, null, ' ', 'PK')";
					querysub = querysub + " from USER_CONS_COLUMNS C, USER_CONSTRAINTS S";
					querysub = querysub + " where C.CONSTRAINT_NAME = S.CONSTRAINT_NAME and S.CONSTRAINT_TYPE = 'P' ";
					querysub = querysub + " and C.TABLE_NAME = '" + rs.getString(1) + "' and C.COLUMN_NAME = NVL(A.COLUMN_NAME,' ')";
					querysub = querysub + " ) IS_PK, ";
					querysub = querysub + " B.DEFAULTVAL DEFAULTVAL";
					querysub = querysub + " FROM SYS.ALL_COL_COMMENTS A, COL B";
					querysub = querysub + " WHERE A.TABLE_NAME = B.TNAME";
					querysub = querysub + " AND A.COLUMN_NAME = B.CNAME";
					querysub = querysub + " AND A.TABLE_NAME = '" + rs.getString(1) + "'";
					rssub = stmt2.executeQuery(querysub);

					System.out.println(querysub);

					int intCnt = 0;
					while (rssub.next()) {

						if (intCnt == 0 || intCnt % 25 == 0) {
		%>


		<%
			if (intCnt > 0) {
		%>
		<tr height=0>
			<td width=43 style='border: none'></td>
			<td width=111 style='border: none'></td>
			<td width=16 style='border: none'></td>
			<td width=110 style='border: none'></td>
			<td width=59 style='border: none'></td>
			<td width=47 style='border: none'></td>
			<td width=60 style='border: none'></td>
			<td width=62 style='border: none'></td>
			<td width=11 style='border: none'></td>
			<td width=73 style='border: none'></td>
		</tr>
		</table>

		<p class=MsoNormal>
			<span lang=EN-US>&nbsp;</span>
		</p>
		<span lang=EN-US
			style='font-size: 10.0pt; font-family: "Book Antiqua"'><br
			clear=all style='page-break-before: always'> </span>
		<p class=MsoNormal>
			<span lang=EN-US>&nbsp;</span>
		</p>
		<%
			}
		%>

		<table class=MsoNormalTable border=1 cellspacing=0 cellpadding=0 width=593 style='width: 444.85pt; border-collapse: collapse; border: none'>
			<tr style='page-break-inside: avoid'>
				<td width=133 rowspan=2 valign=top style='width: 99.9pt; border-top: solid windowtext 1.5pt; border-left: solid windowtext 1.5pt; border-bottom: none; border-right: solid windowtext 1.0pt; padding: 0cm 5.4pt 0cm 5.4pt'>
					<p class=MsoHeader style='margin-top: 0cm; margin-right: 3.4pt; margin-bottom: 0cm; margin-left: 36.0pt; margin-bottom: .0001pt'>
						<span lang=EN-US style='font-size: 5.0pt'>&nbsp;</span>
					</p>
					<p class=MsoHeader style='margin-top: 0cm; margin-right: 3.4pt; margin-bottom: 0cm; margin-left: 11.0pt; margin-bottom: .0001pt'>
						<span lang=EN-US style='font-size: 8.0pt'>KAIST 연구성과관리(RIMS)</span>
					</p>
				</td>
				<td width=460 colspan=3 valign=top style='width: 344.95pt; border-top: solid windowtext 1.5pt; border-left: none; border-bottom: none; border-right: solid windowtext 1.5pt; padding: 0cm 5.4pt 0cm 5.4pt'>
					<p class=MsoHeader style='margin-top: 0cm; margin-right: 3.6pt; margin-bottom: 0cm; margin-left: 36.0pt; margin-bottom: .0001pt'>
						<span lang=EN-US style='font-size: 8.0pt'>Title</span>
					</p>
				</td>
			</tr>
			<tr style='page-break-inside: avoid'>
				<td width=460 colspan=3 valign=top style='width: 344.95pt; border: none; border-right: solid windowtext 1.5pt; padding: 0cm 5.4pt 0cm 5.4pt'>
					<p class=MsoHeader align=center style='text-align: center'>
						<b><span style='font-size: 18.0pt; font-family: 굴림체'>테이블</span></b><b><spanstyle='font-size: 18.0pt'> </span></b><b><span style='font-size: 18.0pt; font-family: 굴림체'>명세서</span></b>
					</p>
				</td>
			</tr>
			<tr style='page-break-inside: avoid'>
				<td width=347 colspan=2 valign=top style='width: 260.55pt; border-top: 1.0pt; border-left: 1.5pt; border-bottom: 1.5pt; border-right: 1.0pt; border-color: windowtext; border-style: solid; padding: 0cm 5.4pt 0cm 5.4pt'>
					<p class=MsoHeader style='margin-top: 3.0pt; margin-right: 3.7pt; margin-bottom: 0cm; margin-left: 0cm; margin-bottom: .0001pt'>
						<span lang=EN-US style='font-size: 8.0pt'>Document #:DE-02-</span><span style='font-size: 8.0pt; font-family: 굴림'>테이블명세서</span><span lang=EN-US style='font-size: 8.0pt'>_V1.0.doc</span>
					</p>
				</td>
				<td width=113 valign=top style='width: 3.0cm; border-top: solid windowtext 1.0pt; border-left: none; border-bottom: solid windowtext 1.5pt; border-right: none; padding: 0cm 5.4pt 0cm 5.4pt'>
					<p class=MsoHeader align=center style='margin-top: 3.0pt; margin-right: 3.7pt; margin-bottom: 0cm; margin-left: 0cm; margin-bottom: .0001pt; text-align: center'>
						<span lang=EN-US style='font-size: 8.0pt'>Version #:</span><span lang=EN-US> 1.0</span>
					</p>
				</td>
				<td width=132 valign=top style='width: 99.25pt; border-top: 1.0pt; border-left: 1.0pt; border-bottom: 1.5pt; border-right: 1.5pt; border-color: windowtext; border-style: solid; padding: 0cm 5.4pt 0cm 5.4pt'>
					<p class=MsoHeader style='margin-top: 3.0pt; margin-right: 3.7pt; margin-bottom: 0cm; margin-left: 1.6pt; margin-bottom: .0001pt; text-align: justify; text-justify: inter-ideograph'>
						<span lang=EN-US style='font-size: 8.0pt'>Issue Date: 2016-11-17</span>
					</p>
				</td>
			</tr>
			<tr height=0>
				<td width=133 style='border: none'></td>
				<td width=214 style='border: none'></td>
				<td width=113 style='border: none'></td>
				<td width=132 style='border: none'></td>
			</tr>
		</table>

		<p class=MsoNormal>
			<span lang=EN-US>&nbsp;</span>
		</p>

		<table class=MsoNormalTable border=1 cellspacing=0 cellpadding=0 width=593 style='width: 444.95pt; border-collapse: collapse; border: none'>
			<tr style='page-break-inside: avoid; height: 17.25pt'>
				<td width=170 colspan=3 style='width: 127.2pt; border: solid windowtext 1.0pt; background: #D9D9D9; padding: 0cm 4.95pt 0cm 4.95pt; height: 17.25pt'>
					<p class=MsoNormal
						style='text-align: justify; text-justify: inter-ideograph'>
						<span style='font-family: 굴림체'>테이블명<span lang=EN-US>(</span>영<span lang=EN-US>)</span></span>
					</p>
				</td>
				<td width=170 colspan=2 style='width: 127.2pt; border: solid windowtext 1.0pt; border-left: none; padding: 0cm 4.95pt 0cm 4.95pt; height: 17.25pt'>
					<p class=MsoNormal style='text-align: justify; text-justify: inter-ideograph'>
						<span lang=EN-US style='font-family: 굴림체'><%=rs.getString(1)%></span>
					</p>
				</td>
				<td width=170 colspan=3 style='width: 127.2pt; border: solid windowtext 1.0pt; border-left: none; background: #D9D9D9; padding: 0cm 4.95pt 0cm 4.95pt; height: 17.25pt'>
					<p class=MsoNormal style='text-align: justify; text-justify: inter-ideograph'>
						<span style='font-family: 굴림체'>테이블명<span lang=EN-US>(</span>한<span lang=EN-US>)</span></span>
					</p>
				</td>
				<td width=84 colspan=2 style='width: 63.35pt; border: solid windowtext 1.0pt; border-left: none; padding: 0cm 4.95pt 0cm 4.95pt; height: 17.25pt'>
					<p class=MsoNormal  style='text-align: justify; text-justify: inter-ideograph'>
						<span style='font-family: 굴림체'><%=rs.getString(2)%></span>
					</p>
				</td>
			</tr>
			<tr style='height: 17.25pt'>
				<td width=43 style='width: 31.95pt; border: solid windowtext 1.0pt; border-top: none; background: #D9D9D9; padding: 0cm 4.95pt 0cm 4.95pt; height: 17.25pt'>
					<p class=MsoNormal style='text-align: justify; text-justify: inter-ideograph'>
						<span style='font-family: 굴림체'>번호</span>
					</p>
				</td>
				<td width=111 style='width: 83.0pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; background: #D9D9D9; padding: 0cm 4.95pt 0cm 4.95pt; height: 17.25pt'>
					<p class=MsoNormal style='text-align: justify; text-justify: inter-ideograph'>
						<span style='font-family: 굴림체'>필드명<span lang=EN-US>(</span>영<span lang=EN-US>)</span></span>
					</p>
				</td>
				<td width=127 colspan=2 style='width: 95.0pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; background: #D9D9D9; padding: 0cm 4.95pt 0cm 4.95pt; height: 17.25pt'>
					<p class=MsoNormal style='text-align: justify; text-justify: inter-ideograph'>
						<span style='font-family: 굴림체'>설명</span>
					</p>
				</td>
				<td width=107 colspan=2 style='width: 80.0pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; background: #D9D9D9; padding: 0cm 4.95pt 0cm 4.95pt; height: 17.25pt'>
					<p class=MsoNormal style='text-align: justify; text-justify: inter-ideograph'>
						<span lang=EN-US style='font-family: 굴림체'>TYPE</span>
					</p>
				</td>
				<td width=60 style='width: 45.0pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; background: #D9D9D9; padding: 0cm 4.95pt 0cm 4.95pt; height: 17.25pt'>
					<p class=MsoNormal style='text-align: justify; text-justify: inter-ideograph'>
						<span lang=EN-US style='font-family: 굴림체'>LENGHT</span>
					</p>
				</td>
				<td width=73 colspan=2 style='width: 55.0pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; background: #D9D9D9; padding: 0cm 4.95pt 0cm 4.95pt; height: 17.25pt'>
					<p class=MsoNormal style='text-align: justify; text-justify: inter-ideograph'>
						<span style='font-family: 굴림체'>키구분</span>
					</p>
				</td>
				<td width=73 style='width: 55.0pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; background: #D9D9D9; padding: 0cm 4.95pt 0cm 4.95pt; height: 17.25pt'>
					<p class=MsoNormal style='text-align: justify; text-justify: inter-ideograph'>
						<span lang=EN-US style='font-family: 굴림체'>DELAULT</span>
					</p>
				</td>
			</tr>
			<%
				}
							intCnt = intCnt + 1;
			%>

			<tr style='page-break-inside: avoid; height: 17.25pt'>
				<td width=43 style='width: 31.95pt; border: solid windowtext 1.0pt; border-top: none; padding: 0cm 4.95pt 0cm 4.95pt; height: 17.25pt'>
					<p class=MsoNormal style='text-align: justify; text-justify: inter-ideograph'>
						<span lang=EN-US style='font-family: 굴림체'><%=intCnt%></span>
					</p>
				</td>
				<td width=111 style='width: 83.0pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0cm 4.95pt 0cm 4.95pt; height: 17.25pt'>
					<p class=MsoNormal style='text-align: justify; text-justify: inter-ideograph'>
						<span lang=EN-US style='font-family: 굴림체'><%=rssub.getString(2)%></span>
					</p>
				</td>
				<td width=127 colspan=2 style='width: 95.0pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0cm 4.95pt 0cm 4.95pt; height: 17.25pt'>
					<p class=MsoNormal style='text-align: justify; text-justify: inter-ideograph'>
						<span style='font-family: 굴림체'><%=rssub.getString(3)%></span>
					</p>
				</td>
				<td width=107 colspan=2 style='width: 80.0pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0cm 4.95pt 0cm 4.95pt; height: 17.25pt'>
					<p class=MsoNormal style='text-align: justify; text-justify: inter-ideograph'>
						<span lang=EN-US style='font-family: 굴림체'><%=rssub.getString(4)%></span>
					</p>
				</td>
				<td width=60 style='width: 45.0pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0cm 4.95pt 0cm 4.95pt; height: 17.25pt'>
					<p class=MsoNormal style='text-align: justify; text-justify: inter-ideograph'>
						<span lang=EN-US style='font-family: 굴림체'><%=rssub.getString(5)%></span>
					</p>
				</td>
				<td width=73 colspan=2 style='width: 55.0pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0cm 4.95pt 0cm 4.95pt; height: 17.25pt'>
					<p class=MsoNormal style='text-align: justify; text-justify: inter-ideograph'>
						<span lang=EN-US style='font-family: 굴림체'>
							<%
								String nullAt = rssub.getString(6);
								String isPk = rssub.getString(7);
								if(isPk != null){
							%>
								<%=isPk %>
							<%} else { %>
								<%=nullAt %>
							<%} %>
						</span>
					</p>
				</td>
				<td width=73 style='width: 55.0pt; border-top: none; border-left: none; border-bottom: solid windowtext 1.0pt; border-right: solid windowtext 1.0pt; padding: 0cm 4.95pt 0cm 4.95pt; height: 17.25pt'>
					<p class=MsoNormal style='text-align: justify; text-justify: inter-ideograph'>
						<span lang=EN-US style='font-family: 굴림체'><%=isnull(rssub.getString(8))%></span>
					</p>
				</td>
			</tr>
			<%
				}
						rssub.close();
			%>
			<tr height=0>
				<td width=43 style='border: none'></td>
				<td width=111 style='border: none'></td>
				<td width=16 style='border: none'></td>
				<td width=110 style='border: none'></td>
				<td width=59 style='border: none'></td>
				<td width=47 style='border: none'></td>
				<td width=60 style='border: none'></td>
				<td width=62 style='border: none'></td>
				<td width=11 style='border: none'></td>
				<td width=73 style='border: none'></td>
			</tr>
		</table>

		<p class=MsoNormal>
			<span lang=EN-US>&nbsp;</span>
		</p>
		<span lang=EN-US style='font-size: 10.0pt; font-family: "Book Antiqua"'><br clear=all style='page-break-before: always'> </span>
		<p class=MsoNormal>
			<span lang=EN-US>&nbsp;</span>
		</p>
		<%
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (stmt != null) try { stmt.close(); } catch (Exception e) { }
			if (conDs != null) try { conDs.close(); } catch (Exception e) { }
		}
		%>

</body>
</html>