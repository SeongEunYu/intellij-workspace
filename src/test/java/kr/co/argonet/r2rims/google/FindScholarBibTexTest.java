package kr.co.argonet.r2rims.google;


import java.io.IOException;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.prefs.Preferences;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.jsoup.Connection;
import org.jsoup.Connection.Response;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import org.junit.Test;

import kr.co.argonet.r2rims.AbstractApplicationContextTest;

@SuppressWarnings("deprecation")
public class FindScholarBibTexTest extends AbstractApplicationContextTest {

	private int maxConnections = 15;

	@Test
	public void usingGoogleScholarClassTest() throws IOException{
		com.google.scholar.GoogleScholar scholar = new com.google.scholar.GoogleScholar();
		List<Map<String, String>> list  =  scholar.findScholarDataByKeyword("10.1016/j.biortech.2015.03.027");
		for(Map<String, String> record : list)
		{
			System.out.println(record.get("url"));
			System.out.println(record.get("doi"));
			System.out.println(record.get("title"));
			System.out.println(record.get("author"));
			System.out.println(record.get("journal"));
			System.out.println(record.get("pages"));
			System.out.println(record.get("year"));
			System.out.println(record.get("volume"));
			System.out.println(record.get("number"));
			System.out.println(record.get("issn"));
			System.out.println(record.get("publisher"));
			System.out.println(record.get("infoid"));
		}
	}

	@Test
	public void getTextFromGoogleScholarTest() throws Exception{

	    String httpsURL = "https://scholar.google.com/scholar?q=DOI%2810.1093/nar/gkw525%29&btnG=&hl=en&as_sdt=0%2C5";

	    Table scholar =  getRecordsByUrl(httpsURL);

	    Iterator<Record> it =  scholar.iterator();

	    while (it.hasNext()) {
			Record r = it.next();
			String bibTexUrl = r.getValue("bibTexUrl");
			System.out.println("bibTexUrl  >>>>>>>>>> " +  bibTexUrl);
	    	if(bibTexUrl != null && !"".equals(bibTexUrl))
	    	{
	    		Record bibRecord = getBibTexRecord(bibTexUrl);
	    		bibRecord.setValue("infoid", r.getValue("infoid"));
	    		System.out.println(bibRecord);
	    	}
		}

	    /*
	    URL myurl = new URL(httpsURL);
	    HttpsURLConnection con = (HttpsURLConnection)myurl.openConnection();
	    con.setRequestProperty("user-agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/53.0.2785.116 Safari/537.36");
	    //con.setRequestProperty("authority", "4.client-channel.google.com");

	    String cookie = "";
	    //cookie += "GSP=IN=5695cb105b5afe8+b33d43a17f11c8a+9ae38934b569c6cd:LD=ko:CF=4:LM=1470643167:S=4xHP4fQbbkAhuhUa; ";
	    cookie += "GSP=CF=4:LM=1234567890; ";
	    con.setRequestProperty("Cookie", cookie);

	    //con.setRequestProperty("x-client-data", "CJa2yQEIorbJAQjBtskB");
	    //con.setRequestProperty("authorization", "SAPISIDHASH 1475479119_cc99aee532e895561a20c86b187464e95467bb98");

	    InputStream ins = con.getInputStream();
	    InputStreamReader isr = new InputStreamReader(ins);
	    BufferedReader in = new BufferedReader(isr);

	    String inputLine;
	    while ((inputLine = in.readLine()) != null)
	    {
	      System.out.println(inputLine);
	    }

	    in.close();
		*/

	}


	private static Pattern bibtexTypePattern = Pattern.compile("^\\s*@(\\w*)\\{");
	private static Pattern bibtexIdPattern = Pattern.compile("\\{([^\\{\\}=,]*),");
	private static Pattern bibtexPropertyPattern = Pattern.compile("\\s*(\\w*)=\\{(([^\\{\\}]|\\{([^\\{\\}]|\\{[^\\{\\}]*\\})*\\})*)\\}");

	static protected MemoryTable bibtexTable = new MemoryTable("bibtex",  new String[] { "infoid", "bibid", "type", "title", "author",
																						 "journal", "pages", "year", "volume", "number", "issn",
																						 "book", "isbn", "publisher" });

	public Record getBibTexRecord(String bibTexUrl) throws IOException {
		Record record = bibtexTable.createRecord();
		//record.setValue("infoid", infoid);

		Document doc = getDocument(bibTexUrl);
		String bibtex = doc.body().text();

		Matcher matcher = bibtexTypePattern.matcher(bibtex);
		if (!matcher.find())
			throw new IllegalArgumentException("Incorrect bibtex publication type");
		record.setValue("type", matcher.group(1));

		matcher = bibtexIdPattern.matcher(bibtex);
		if (!matcher.find())
			throw new IllegalArgumentException("Incorrect bibtex identifier: "+ bibtex);

		String bibid = matcher.group(1);
		bibid = Conversion.removeAccents(bibid);
		bibid = bibid.replace(' ', '_');
		record.setValue("bibid", bibid);

		matcher = bibtexPropertyPattern.matcher(bibtex);
		while (matcher.find()) {
			String label = matcher.group(1);
			String value = matcher.group(2);

			if (label.equals("title")) {
				if (value.startsWith("{") && value.endsWith("}"))
					value = value.substring(1, value.length() - 1);
			} else if (label.equals("author"))
				value = Conversion.removeTex(value);
			else if (label.equals("booktitle"))
				label = "book";

			if (record.getTable().hasKey(label))
				record.setValue(label, value);
		}

		return record;
	}

	public static class TooManyConnectionsException extends IOException {
		private static final long serialVersionUID = 51944780478954114L;

		TooManyConnectionsException(String message) {
			super(message);
		}
	}

	private static void addHeader(Connection conn) {
		conn.header("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/53.0.2785.116 Safari/537.36");
		conn.header("Accept", "text/html,text/plain,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8");
		conn.header("Accept-Language", "en-us,en");
		conn.header("Accept-Encoding", "gzip, deflate, sdch, br");
		conn.header("Accept-Charset", "utf-8");
	}

	private Document getDocument(String url) throws IOException {
		if (--maxConnections <= 0)  throw new TooManyConnectionsException("Too many Google Scholar HTML requests");

		Preferences pref = Preferences.userRoot().node(GoogleScholar.class.getName());

		String cookie = pref.get("cookie", "");
		if (!cookie.contains("GSP")) {
			Connection conn = Jsoup.connect("http://scholar.google.com/scholar_ncr");
			addHeader(conn);
			conn.get();

			Response resp = conn.response();
			cookie = "PREF=" + resp.cookie("PREF");
			cookie += "; GSP=" + resp.cookie("GSP") + ":CF=4:LM=1234567890;";

			pref.put("cookie", cookie);
		}

		Connection conn = Jsoup.connect(url);
		addHeader(conn);
		conn.header("Cookie", cookie);

		Document doc = conn.get();

		return doc;
	}

	private static Pattern citeidPattern = Pattern.compile("/scholar\\?cites=([\\d]*)\\&");
	private static Pattern infoidPattern = Pattern.compile("info:([\\w-]*):");
	private static Pattern britidPattern = Pattern.compile("direct.bl.uk/research/([0-9/A-Z]*)\\.html");
	private static Pattern doiPattern = Pattern.compile("id=doi:([^&]*)");
	private static Pattern yearPattern = Pattern.compile(" ([12][0-9][0-9][0-9])( |$)");

	public Table getRecordsByUrl(String url) throws IOException {
		MemoryTable records = new MemoryTable("scholar", new String[] { "title", "url", "year", "doi", "origin", "cites", "citeid", "infoid", "britid", "bibTexUrl" });

		Document doc = getDocument(url);

		//System.out.println(doc.toString());

		outer: for (;;) {
			Elements elements = doc.select("div.gs_r");
			for (Element element : elements) {
				Record record = records.createRecord();

				Elements links = element.select(".gs_rt a[href]");
				if (links.size() >= 2)  throw new IllegalArgumentException("Too many article links in scholar record");
				else if (links.size() == 1) {
					record.setValue("url", links.first().attr("href"));
					record.setValue("title", links.first().text());
				} else {
					String title = element.select(".gs_rt").text();
					if (!title.startsWith("[CITATION]"))  throw new IllegalArgumentException("Unexpected title format for scholar record");
					title = title.substring(10).trim();
					record.setValue("title", title);
				}

				/*
				links = element.select("span.gs_a");
				if (links.size() != 1)
					throw new IllegalArgumentException("No summary line in scholar record");
				else {
					String origin = links.first().text();
					record.setValue("origin", origin);

					Matcher matcher = yearPattern.matcher(origin);
					if (matcher.find())
						record.setValue("year", matcher.group(1));
				}
				*/
				record.setValue("cites", "0");

				links = element.select(".gs_fl a[href]");
				for (Element link : links) {
					String text = link.text();
					if (text.startsWith("Cited by ")) {
						Matcher matcher = citeidPattern.matcher(link.attr("href"));
						if (!matcher.find()) throw new IllegalArgumentException("Cites url does not contain the cites field");
						record.setValue("citeid", matcher.group(1));
						record.setValue("cites", text.substring(9));
					}

					else if (text.startsWith("Find it")) {
						Matcher matcher = doiPattern.matcher(link.attr("href"));
						if (matcher.find()) record.setValue("doi", matcher.group(1));
					}

					else if (text.equals("Import into BibTeX")) {
						record.setValue("bibTexUrl", link.attr("href"));
						Matcher matcher = infoidPattern.matcher(link.attr("href"));
						if (!matcher.find()) throw new IllegalArgumentException("BibTex url does not contain the info field");
						record.setValue("infoid", matcher.group(1));
					}

					else if (text.equals("BL Direct")) {
						Matcher matcher = britidPattern.matcher(link.attr("href"));
						if (!matcher.find())  throw new IllegalArgumentException("BL Direct url is not well formatted");
						record.setValue("britid", matcher.group(1));
					}
				}

				records.addRecord(record);
			}

			elements = doc.select("div.n a[href]");
			for (Element element : elements) {
				String text = element.text();

				if (text.equals("Next")) {
					String href = element.attr("href");
					if (!href.startsWith("/scholar?start"))  throw new IOException("Unexpected format of next link");

					href = "http://scholar.google.com" + href;
					doc = getDocument(href);

					continue outer;
				}
			}

			// exit if no more Next links
			break;
		}

		// url list
		return records;
	}

}
