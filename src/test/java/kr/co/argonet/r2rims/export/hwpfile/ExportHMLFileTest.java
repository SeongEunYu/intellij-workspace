package kr.co.argonet.r2rims.export.hwpfile;

import kr.co.argonet.r2rims.AbstractApplicationContextTest;
import kr.co.argonet.r2rims.core.mapper.ArticleMapper;
import kr.co.argonet.r2rims.core.mapper.ArticleStatisticsMapper;
import kr.co.argonet.r2rims.core.vo.ArticleVo;
import org.apache.commons.lang3.StringUtils;
import org.junit.Test;
import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

import javax.annotation.Resource;
import javax.xml.namespace.NamespaceContext;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpressionException;
import javax.xml.xpath.XPathFactory;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.List;

/**
 * <pre>
 *  kr.co.argonet.r2rims.export.hwpfile
 *      ┗ ExportHMLFileTest.java
 *
 * </pre>
 *
 * @author : hojkim
 * @date 2018-10-15
 */
public class ExportHMLFileTest  extends AbstractApplicationContextTest {

    @Resource(name = "articleMapper")
    ArticleMapper articleMapper;
    @Resource(name = "articleStatisticsMapper")
    ArticleStatisticsMapper articleStatisticsMapper;


    private XPath xPathEvaluator;

    @Test
    public void exporArticleDataTest(){

         List<ArticleVo> articleList = articleMapper.findByUserId("757");

        try {
            System.out.println("articleList.size  >>>> " + articleList.size());
            //String filePath = ;

            Document doc = DocumentBuilderFactory.newInstance().newDocumentBuilder().parse(new FileInputStream("C:\\java\\workspace\\timescited\\src\\test\\java\\mypackage\\hwp_sample_2.hml"));

            initXPath();

            Node articleTable = (Node)xPathEvaluator.evaluate("//P/TEXT/TABLE[@TableName='article_tbl']", doc, XPathConstants.NODE);


            Node row = (Node)xPathEvaluator.evaluate("./ROW[@Class='data_row']", articleTable, XPathConstants.NODE);

            System.out.println("articleTable == null >>>> " + (articleTable == null));
            System.out.println("row == null >>>> " + (row == null));

            articleTable.removeChild(row);

            NodeList rowList = (NodeList)xPathEvaluator.evaluate("./ROW", articleTable, XPathConstants.NODESET);
            Integer rowAddr = rowList.getLength();

            Node newRow = null;
            int i = 0;
            for(ArticleVo articleVo : articleList)
            {
                newRow = row.cloneNode(true);
                setCellValue(newRow, rowAddr, 0, articleVo.getPblcYm().substring(0,4));
                setCellValue(newRow, rowAddr, 1, articleVo.getOrgLangPprNm());
                setCellValue(newRow, rowAddr, 2, articleVo.getFirstAuthor());
                setCellValue(newRow, rowAddr, 3, "blank");
                setCellValue(newRow, rowAddr, 4, "blank");
                setCellValue(newRow, rowAddr, 5, articleVo.getScjnlNm());
                setCellValue(newRow, rowAddr, 6, articleVo.getVolume());
                setCellValue(newRow, rowAddr, 7, "blank");
                setCellValue(newRow, rowAddr, 8, "blank");
                setCellValue(newRow, rowAddr, 9, articleVo.getImpctFctr());
                articleTable.appendChild(newRow);
                i++;
                rowAddr++;
                if(i > 5) break;
            }

            Node tableRowCount = (Node)xPathEvaluator.evaluate("./@RowCount", articleTable, XPathConstants.NODE);
            tableRowCount.setTextContent(rowAddr.toString());

            /*
            setCellValue(newRow, 0, "2018");
            setCellValue(newRow, 1, "Application of electroless plating process for multiscale Ni-La 0.8 Sr 0.2 Ga 0.8 Mg 0.2 O 3-δ SOFC anode fabrication");
            setCellValue(newRow, 2, "강주현 (Juhyun Kang)");
            setCellValue(newRow, 3, "배중면 (Joongmyeon Bae)");
            setCellValue(newRow, 4, "이건호 (Kunho Lee), 유재영 (Jae Young Yoo)");
            setCellValue(newRow, 5, "Int. Journal of Hydrogen Energy");
            setCellValue(newRow, 6, "43");
            setCellValue(newRow, 7, "국외");
            setCellValue(newRow, 8, "Y");
            setCellValue(newRow, 9, "4.229");
            */


            //Node classAttr = (Node)xpath.evaluate("./@Class", sampleData, XPathConstants.NODE);

            //sampleData.removeChild(classAttr);

            //articleTable.appendChild(sampleData);

            //articleTable.appendChild(sampleData.cloneNode(true));
            /*
            NodeList cellList = (NodeList)xpath.evaluate("./CELL", sampleData, XPathConstants.NODESET);

            for(int idx = 0; idx < cellList.getLength(); idx++)
            {
                Node cell = cellList.item(idx);
                Node celldata = (Node)xpath.evaluate("./PARALIST/P/TEXT/CHAR/text()", cell, XPathConstants.NODE);
                if(celldata != null && StringUtils.isNotBlank(celldata.getNodeValue()))
                    System.out.println("celldata value >>> " + celldata.getNodeValue());

                if(idx == 0)
                    cellList.item(idx).setTextContent("2019");
            }
            // table ROW CELL CELLMARGIN
            //                PARALIST    P     TEXT   CHAR
            */

            Transformer xformer = TransformerFactory.newInstance().newTransformer();
            xformer.transform(new DOMSource(doc), new StreamResult(new File("C:\\java\\workspace\\timescited\\src\\test\\java\\mypackage\\hwp_article_sample_15.hml")));

        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (SAXException e) {
            e.printStackTrace();
        } catch (ParserConfigurationException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        } catch (XPathExpressionException e) {
            e.printStackTrace();
        } catch (TransformerConfigurationException e) {
            e.printStackTrace();
        } catch (TransformerException e) {
            e.printStackTrace();
        }

    }

    private void setCellValue(Node rowNode, Integer rowAddr, Integer cIndex, String value) throws XPathExpressionException {
        //initXPath();
        Node colladdr = (Node)xPathEvaluator.evaluate("./CELL[@ColAddr='"+cIndex+"']", rowNode, XPathConstants.NODE);

        Node collRowAddr = (Node)xPathEvaluator.evaluate("./@RowAddr", colladdr, XPathConstants.NODE);
        if(collRowAddr != null)
            collRowAddr.setTextContent(rowAddr.toString());

        Node colladdr_paralist = (Node)xPathEvaluator.evaluate("./PARALIST", colladdr, XPathConstants.NODE);
        Node colladdr_paralist_p = (Node)xPathEvaluator.evaluate("./P", colladdr_paralist, XPathConstants.NODE);
        Node colladdr_paralist_p_text = (Node)xPathEvaluator.evaluate("./TEXT", colladdr_paralist_p, XPathConstants.NODE);
        Node colladdr_paralist_p_text_char = (Node)xPathEvaluator.evaluate("./CHAR", colladdr_paralist_p_text, XPathConstants.NODE);
        if(colladdr_paralist_p_text_char != null)
            colladdr_paralist_p_text_char.setTextContent(value);
    }

    private void initXPath() {
        XPathFactory factory = XPathFactory.newInstance();
        XPath xPath = factory.newXPath();
        this.xPathEvaluator = xPath;
    }

}
