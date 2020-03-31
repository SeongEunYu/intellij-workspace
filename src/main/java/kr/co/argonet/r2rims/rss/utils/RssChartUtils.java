package kr.co.argonet.r2rims.rss.utils;

import kr.co.argonet.r2rims.analysis.utils.CacheUtils;
import kr.co.argonet.r2rims.constant.R2Constant;
import kr.co.argonet.r2rims.core.vo.*;
import kr.co.argonet.r2rims.util.StringUtil;
import org.apache.commons.lang3.StringUtils;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.IOException;
import java.lang.reflect.Field;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.*;

/**
 * <pre>
 *  kr.co.argonet.r2rims.rss.utils
 *      ┗ Rssjava
 *
 * </pre>
 *
 * @author : woo
 * @date 2020-03-27
 */
public class RssChartUtils {
    private static String[] barColors = new String[]{
            "AFD8F8", "F6BD0F", "8BBA00", "FF8E46", "008E8E", "D64646", "8E468E", "588526", "B3AA00", "008ED6",
            "9D080D", "A186BE"
    };

    //	public static String paletteColors = "#AFD8F8,#F6BD0F,#8BBA00,#FF8E46,#008E8E,#D64646,#8E468E,#588526,#B3AA00,#008ED6,#9D080D,#A186BE,#CC6600,#FDC689,#ABA000,#F26D7D,#FFF200,#0054A6";
    public static String paletteColors = "#1aa1b5,#2dcdb1,#2dcd6d,#eab543,#f69e3f,#dba2f9,#358ada,#f17c8a,#ea8bba,#f196e5,#F6BD0F,#8BBA00,#FF8E46,#008E8E,#D64646,#8E468E,#588526,#B3AA00,#008ED6,#9D080D,#A186BE,#CC6600,#FDC689,#ABA000,#F26D7D,#FFF200,#0054A6";

    public static String[] fillColors = new String[]{
            "1aa1b5", "2dcdb1", "2dcd6d", "eab543", "f69e3f",
            "dba2f9", "358ada", "f17c8a", "ea8bba", "f196e5",
            "F6BD0F", "8BBA00", "FF8E46", "008E8E", "D64646",
            "8E468E", "588526", "B3AA00", "008ED6", "9D080D",
            "A186BE", "CC6600", "FDC689", "ABA000", "F26D7D",
            "FFF200", "0054A6",
            "1aa1b5", "2dcdb1", "2dcd6d", "eab543", "f69e3f",
            "dba2f9", "358ada", "f17c8a", "ea8bba", "f196e5",
            "F6BD0F", "8BBA00", "FF8E46", "008E8E", "D64646",
            "8E468E", "588526", "B3AA00", "008ED6", "9D080D",
            "A186BE", "CC6600", "FDC689", "ABA000", "F26D7D",
            "FFF200", "0054A6",
            "1aa1b5", "2dcdb1", "2dcd6d", "eab543", "f69e3f",
            "dba2f9", "358ada", "f17c8a", "ea8bba", "f196e5",
            "F6BD0F", "8BBA00", "FF8E46", "008E8E", "D64646",
            "8E468E", "588526", "B3AA00", "008ED6", "9D080D",
            "A186BE", "CC6600", "FDC689", "ABA000", "F26D7D",
            "FFF200", "0054A6",
            "1aa1b5", "2dcdb1", "2dcd6d", "eab543", "f69e3f",
            "dba2f9", "358ada", "f17c8a", "ea8bba", "f196e5",
            "F6BD0F", "8BBA00", "FF8E46", "008E8E", "D64646",
            "8E468E", "588526", "B3AA00", "008ED6", "9D080D",
            "A186BE", "CC6600", "FDC689", "ABA000", "F26D7D",
            "FFF200", "0054A6"
    };

    public static String[] rims2Color = new String[]{
            "#3366CC", "#DC3912", "#FF9900", "#109618",
            "#990099", "#3B3EAC", "#0099C6", "#DD4477",
            "#66AA00", "#B82E2E", "#316395", "#994499",
            "#22AA99", "#AAAA11", "#6633CC", "#E67300",
            "#8B0707", "#329262", "#5574A6", "#3B3EAC"
    };

    private static String[] shareFillColors = new String[]{
            "FFA500", "F0E68C", "D8BFD8", "B0E0E6", "FFEFD5",
            "ADD8E6", "FFB6C1", "F5F5DC", "FAFAD2", "FFE4E1",
            "F5FFFA", "FFF0F5", "E0FFFF", "ADFF2F", "F5F5F5",
            "7FFFD4", "E0FFFF", "FFD700", "FF6347", "FAEBD7",
            "FFA500", "F0E68C", "D8BFD8", "B0E0E6", "FFEFD5",
            "ADD8E6", "FFB6C1", "F5F5DC", "FAFAD2", "FFE4E1",
            "F5FFFA", "FFF0F5", "E0FFFF", "ADFF2F", "F5F5F5",
            "7FFFD4", "E0FFFF", "FFD700", "FF6347", "FAEBD7",
            "FFA500", "F0E68C", "D8BFD8", "B0E0E6", "FFEFD5",
            "ADD8E6", "FFB6C1", "F5F5DC", "FAFAD2", "FFE4E1",
            "F5FFFA", "FFF0F5", "E0FFFF", "ADFF2F", "F5F5F5",
            "7FFFD4", "E0FFFF", "FFD700", "FF6347", "FAEBD7"
    };

    private static String[][] netImages = new String[][]{
            {"circle1.gif", "23", "23"},
            {"circle2.gif", "33", "33"},
            {"circle3.gif", "43", "43"},
            {"circle4.gif", "54", "54"},
            {"circle5.gif", "64", "64"},
            {"circle5.gif", "64", "64"},
    };

    private static String[][] scatterImages = new String[][]{
            {"shape1.png", "12", "10"}, {"shape2.png", "12", "10"}, {"shape3.png", "12", "11"},
            {"shape4.png", "11", "10"}, {"shape5.png", "13", "10"}, {"shape6.png", "12", "10"},
            {"shape5.png", "13", "10"}, {"shape8.png", "12", "9"}, {"shape9.png", "13", "10"},
            {"shape10.png", "13", "10"}
    };

    private static Map<String, String> ipcMap;

    private static Map<String, String> dcMap; /* fill color of dept */

    public static String getColor(int index) {
        return barColors[index % barColors.length];
    }


    private static Object getValueFromObject(Object source, String valField) {
        Field[] fields = source.getClass().getDeclaredFields();
        Object valObj = null;
        try {
            for (Field f : fields) {
                f.setAccessible(true);
                if (f.getName().equals(valField)) valObj = f.get(source);
            }
        } catch (IllegalArgumentException e) {
            e.printStackTrace();
            return null;
        } catch (IllegalAccessException e) {
            e.printStackTrace();
            return null;
        }
        return valObj;
    }

    private static Object getMaxValueFromObjectList(List<AnalysisVo> list, String valField) {
        Object maxValue = null;
        try {
            for (Object item : list) {
                Field[] fields = item.getClass().getDeclaredFields();
                Object valObj = null;
                for (Field f : fields) {
                    f.setAccessible(true);
                    //System.out.println( f.getName() + " : " + f.get(item));
                    if (f.getName().equals(valField)) valObj = f.get(item);
                }
                if (valObj != null) {
                    if (maxValue == null) maxValue = valObj;
                    else {
                        if (Double.parseDouble(maxValue.toString()) < Double.parseDouble(valObj.toString()))
                            maxValue = valObj;
                    }
                }
            }
        } catch (Exception e) {
            // TODO: handle exception
        }
        return maxValue == null ? "0" : maxValue;
    }

    /**
     * <pre>
     *  1. 개   요 : Covert list to map
     *  2. 처리내용 :
     * </pre>
     *
     * @param list
     * @param key
     * @param val
     * @return
     * @Method Name : convertListToMap
     */
    public static Map convertListToMap(List<Map> list, String key, String val) {

        Map result = new HashMap();

        for (Map item : list) {
            if (item.get(key) != null) {
                result.put(item.get(key), item.get(val));
            }
        }

        return result;

    }

    public static Object getValueByKeyFieldFromObject(AnalysisVo source, String key) {
        Field[] fields = source.getClass().getDeclaredFields();
        Object value = null;
        try {
            for (Field f : fields) {
                f.setAccessible(true);
                if (f.getName().equals(key)) value = f.get(source);
            }
        } catch (IllegalArgumentException e) {
            e.printStackTrace();
            return null;
        } catch (IllegalAccessException e) {
            e.printStackTrace();
            return null;
        }
        return value;
    }

    public static Map convertObjectListToMap(List<AnalysisVo> list, String key, String val) {

        Map result = new HashMap();

        try {
            for (Object item : list) {
                Field[] fields = item.getClass().getDeclaredFields();
                Object keyObj = null;
                Object valObj = null;
                for (Field f : fields) {
                    f.setAccessible(true);
                    //System.out.println( f.getName() + " : " + f.get(item));
                    if (f.getName().equals(key)) keyObj = f.get(item);
                    if (f.getName().equals(val)) valObj = f.get(item);
                }
                if (keyObj != null) {
                    result.put(keyObj, valObj);
                }
            }
        } catch (IllegalArgumentException e) {

            e.printStackTrace();
        } catch (IllegalAccessException e) {

            e.printStackTrace();
        }

        return result;

    }

    public static Map convertObjectListToMapWithCompareValue(List<AnalysisVo> list, String compKey, String compVal, String key, String val) {

        Map result = new HashMap();

        try {
            for (Object item : list) {
                Field[] fields = item.getClass().getDeclaredFields();
                Object keyObj = null;
                Object valObj = null;
                Object compValObj = null;
                for (Field f : fields) {
                    f.setAccessible(true);
                    //System.out.println( f.getName() + " : " + f.get(item));
                    if (f.getName().equals(compKey)) compValObj = f.get(item);
                    if (f.getName().equals(key)) keyObj = f.get(item);
                    if (f.getName().equals(val)) valObj = f.get(item);
                }
                if (compVal.equals(compValObj) && keyObj != null) {
                    result.put(keyObj, valObj);
                }
            }
        } catch (IllegalArgumentException e) {

            e.printStackTrace();
        } catch (IllegalAccessException e) {

            e.printStackTrace();
        }

        return result;

    }

    public static Map convertJcrCatRankingVoListToMapWithCompareValue(List<JcrCatRankingVo> list, String compKey, String compVal, String key, String val) {

        Map result = new HashMap();

        try {
            for (Object item : list) {
                Field[] fields = item.getClass().getDeclaredFields();
                Object keyObj = null;
                Object valObj = null;
                Object compValObj = null;
                for (Field f : fields) {
                    f.setAccessible(true);
                    //System.out.println( f.getName() + " : " + f.get(item));
                    if (f.getName().equals(compKey)) compValObj = f.get(item);
                    if (f.getName().equals(key)) keyObj = f.get(item);
                    if (f.getName().equals(val)) valObj = f.get(item);
                }
                if (compVal.equals(compValObj) && keyObj != null) {
                    result.put(keyObj, valObj);
                }
            }
        } catch (IllegalArgumentException e) {

            e.printStackTrace();
        } catch (IllegalAccessException e) {

            e.printStackTrace();
        }

        return result;

    }

    public static Map convertAnalysisVoListToMapWithCompareValue(List<AnalysisVo> list, String compKey, String compVal, String key, String val) {

        Map result = new HashMap();

        try {
            for (Object item : list) {
                Field[] fields = item.getClass().getDeclaredFields();
                Object keyObj = null;
                Object valObj = null;
                Object compValObj = null;
                for (Field f : fields) {
                    f.setAccessible(true);
                    //System.out.println( f.getName() + " : " + f.get(item));
                    if (f.getName().equals(compKey)) compValObj = f.get(item);
                    if (f.getName().equals(key)) keyObj = f.get(item);
                    if (f.getName().equals(val)) valObj = f.get(item);
                }
                if (compVal.equals(compValObj) && keyObj != null) {
                    result.put(keyObj, valObj);
                }
            }
        } catch (IllegalArgumentException e) {

            e.printStackTrace();
        } catch (IllegalAccessException e) {

            e.printStackTrace();
        }

        return result;

    }

    /**
     * <pre>
     *  1. 개   요 : Covert list to map with source key and value
     *  2. 처리내용 :
     * </pre>
     *
     * @param list
     * @param fkey
     * @param fval
     * @param key
     * @param val
     * @return
     * @Method Name : convertListToMap
     */
    public static Map convertListToMap(List<Map> list, Object fkey, Object fval, String key, String val) {

        Map result = new HashMap();

        for (Map item : list) {
            if (item.get(fkey) != null) {
                if (item.get(fkey).equals(fval)) result.put(item.get(key), item.get(val).toString().trim());
            }
        }

        return result;

    }

    public static String getIPCName(String ipc) {

        String name = ipcMap.get(ipc);
        if (name == null) name = "기타";

        return name;
    }


    public static String buildResearcherPublicationByPubyear(List<AnalysisVo> list, RimsSearchVo searchVo, String contextPath) {

        String gubun = searchVo.getGubun();
        String fromYear = searchVo.getFromYear();
        String toYear = searchVo.getToYear();

        String keyField = "pubYear";
        String valField = "artsCo";

        String color = "F1683C"; //sci chart color
        if (R2Constant.ARTICLE_GUBUN_SCOPUS.equals(gubun)) color = "1D8BD1";    //scopus chart color
        else if (R2Constant.ARTICLE_GUBUN_KCI.equals(gubun)) color = "588526"; //kci chart color

        String caption = "Publications by year from " + fromYear + " to " + toYear;
        StringBuffer xml = new StringBuffer();
        xml.append("<chart ")
                .append(" caption='" + caption + "' ")
                .append(" subcaption='' ")
                .append(" baseFontColor='#666666' ")
                .append(" baseFontSize='11' ")
                .append(" subcaptionFontBold='0' ")
                .append(" canvasBgAlpha='0' ")
                .append(" showValues='0' ")
                .append(" paletteColors='" + paletteColors + "' ")
                .append(" bgAlpha='0' ")
                .append(" showBorder='0' ")
                .append(" showShadow='0' ")
                .append(" showAlternateHGridColor='0' ")
                .append(" showCanvasBorder='0' ")
                .append(" showXAxisLine='1' ")
                .append(" xAxisLineThickness='1' ")
                .append(" xAxisLineColor='#cdcdcd' ")
                .append(" xAxisNameFontColor='#8d8d8d' ")
                .append(" yAxisNameFontColor='#8d8d8d' ")
                .append(" canvasBgColor='#ffffff' ")
                .append(" lineThickness='4' ")
                .append(" legendBgColor='#ffffff' ")
                .append(" legendBgAlpha='100' ")
                .append(" legendBorderAlpha='50' ")
                .append(" legendBorderColor='#888888' ")
                .append(" legendShadow='0' ")
                .append(" legendPosition='CENTER' ")
                .append(" divlineAlpha='100' ")
                .append(" numDivLines='10' ")
                .append(" divlineColor='#999999' ")
                .append(" divlineThickness='1' ")
                .append(" divLineIsDashed='1'")
                .append(" divLineDashLen='1'")
                .append(" divLineGapLen='1' ")
                .append(" toolTipColor='#ffffff' ")
                .append(" toolTipBorderColor='#ffffff' ")
                .append(" toolTipBorderThickness='1' ")
                .append(" toolTipBgColor='#000000' ")
                .append(" toolTipBgAlpha='80' ")
                .append(" toolTipBorderRadius='4' ")
                .append(" toolTipPadding='10' ")
                .append(" toolTipFontSize ='20' ")
                .append(" anchorBgColor='#ffffff' ")
                .append(" anchorRadius='5' ")
                .append(" anchorBorderThickness='3' ")
                .append(" anchorTrackingRadius='15' ")
                .append(" showHoverEffect='1' ")
                .append(" formatNumberScale='0'")
                .append(" labelDisplay='rotate' ")
                .append(" slantLabels='1' ")
                .append(" exportEnabled='1' ")
                .append(" exportAtClient='0' ")
                .append(" exportAction='save' ")
                .append(" exportShowMenuItem='0' ")
                .append(" exportDialogMessage='Building chart output' ")
                .append(" exportHandler='" + contextPath + "/servlet/FCExporter/export.do' exportCallBack='myFN' ")
                .append(" >");

        int fy = Integer.parseInt(fromYear);
        int ty = Integer.parseInt(toYear);

        xml.append("<categories >");
        for (int ii = fy; ii <= ty; ii++) {
            xml.append("<category label='" + ii + "' />");
        }
        xml.append("</categories>");

        //total no. of publications
        int totArtsNo = 0;
        Map yearNoMap = convertObjectListToMap(list, keyField, valField);
        for (int ii = fy; ii <= ty; ii++) {
            if (yearNoMap.get(Integer.toString(ii)) != null)
                totArtsNo += Integer.parseInt(yearNoMap.get(Integer.toString(ii)).toString());
        }

        xml.append("<dataset seriesName='No. of Publications (Total: " + totArtsNo + ")' color='" + color + "' anchorBorderColor='" + color + "' >");
        for (int ii = fy; ii <= ty; ii++) {
            Object val = yearNoMap.get(Integer.toString(ii));
            if (val == null)
                xml.append("<set value='0' />");
            else
                xml.append("<set value='" + val + "' link='j-chartClick-" + ii + ";" + gubun + "' toolText='" + val + "'/>");
        }
        xml.append("</dataset>");

        xml.append("<styles>");
        xml.append("    <definition>");
        xml.append("        <style name='CaptionFont' type='font' size='12'/>");
        xml.append("   </definition>");
        xml.append("    <application>");
        xml.append("       <apply toObject='CAPTION' styles='CaptionFont' />");
        xml.append("       <apply toObject='SUBCAPTION' styles='CaptionFont' />");
        xml.append("    </application>");
        xml.append(" </styles>");

        xml.append("</chart>");

        return xml.toString();
    }

    public static String buildResearcherAllPublicationByPubyear(List<AnalysisVo> scilist, List<AnalysisVo> scplist, List<AnalysisVo> kcilist,
                                                                RimsSearchVo searchVo, String contextPath) {

        String gubun = searchVo.getGubun();
        String fromYear = searchVo.getFromYear();
        String toYear = searchVo.getToYear();

        String scicolor = "F1683C";
        String scpcolor = "1D8BD1";
        String kcicolor = "588526";
        String keyField = "pubYear";
        String valField = "artsCo";

        String caption = "Publications by year from " + fromYear + " to " + toYear;
        StringBuffer xml = new StringBuffer();

        xml.append("<chart ")
                .append(" caption='" + caption + "' ")
                .append(" subcaption='' ")
                .append(" baseFontColor='#666666' ")
                .append(" baseFontSize='11' ")
                .append(" subcaptionFontBold='0' ")
                .append(" canvasBgAlpha='0' ")
                .append(" showValues='0' ")
                .append(" paletteColors='" + paletteColors + "' ")
                .append(" bgAlpha='0' ")
                .append(" showBorder='0' ")
                .append(" showShadow='0' ")
                .append(" showAlternateHGridColor='0' ")
                .append(" showCanvasBorder='0' ")
                .append(" showXAxisLine='1' ")
                .append(" xAxisLineThickness='1' ")
                .append(" xAxisLineColor='#cdcdcd' ")
                .append(" xAxisNameFontColor='#8d8d8d' ")
                .append(" yAxisNameFontColor='#8d8d8d' ")
                .append(" canvasBgColor='#ffffff' ")
                .append(" lineThickness='4' ")
                .append(" legendBgColor='#ffffff' ")
                .append(" legendBgAlpha='100' ")
                .append(" legendBorderAlpha='50' ")
                .append(" legendBorderColor='#888888' ")
                .append(" legendShadow='0' ")
                .append(" legendPosition='CENTER' ")
                .append(" divlineAlpha='0' ")
                .append(" numDivLines='10' ")
                .append(" divlineColor='#999999' ")
                .append(" divlineThickness='1' ")
                .append(" divLineIsDashed='1'")
                .append(" divLineDashLen='1'")
                .append(" divLineGapLen='1' ")
                .append(" toolTipColor='#ffffff' ")
                .append(" toolTipBorderColor='#ffffff' ")
                .append(" toolTipBorderThickness='1' ")
                .append(" toolTipBgColor='#000000' ")
                .append(" toolTipBgAlpha='80' ")
                .append(" toolTipBorderRadius='4' ")
                .append(" toolTipPadding='10' ")
                .append(" toolTipFontSize ='20' ")
                .append(" anchorBgColor='#ffffff' ")
                .append(" anchorRadius='5' ")
                .append(" anchorBorderThickness='3' ")
                .append(" anchorTrackingRadius='15' ")
                .append(" showHoverEffect='1' ")
                .append(" formatNumberScale='0'")
                .append(" labelDisplay='rotate' ")
                .append(" slantLabels='1' ")
                .append(" exportEnabled='1' ")
                .append(" exportAtClient='0' ")
                .append(" exportAction='save' ")
                .append(" exportShowMenuItem='0' ")
                .append(" exportDialogMessage='Building chart output' ")
                .append(" exportHandler='" + contextPath + "/servlet/FCExporter/export.do' exportCallBack='myFN' ")
                .append(" >");

        int fy = Integer.parseInt(fromYear);
        int ty = Integer.parseInt(toYear);

        xml.append("<categories >");
        for (int ii = fy; ii <= ty; ii++) {
            xml.append("<category label='" + ii + "' />");
        }
        xml.append("</categories>");

        //SCI
        int totArtsNo = 0;
        Map sciYearNoMap = convertObjectListToMap(scilist, keyField, valField);
        for (int ii = fy; ii <= ty; ii++) {
            if (sciYearNoMap.get(Integer.toString(ii)) != null)
                totArtsNo += Integer.parseInt(sciYearNoMap.get(Integer.toString(ii)).toString());
        }

        xml.append("<dataset seriesName='SCI(Total: " + totArtsNo + ")' color='" + scicolor + "' anchorBorderColor='" + scicolor + "' >");
        for (int ii = fy; ii <= ty; ii++) {
            Object val = sciYearNoMap.get(Integer.toString(ii));
            if (val == null)
                xml.append("<set value='0' />");
            else
                xml.append("<set value='" + val + "' link='j-chartClick-" + ii + ";SCI' toolText='" + val + "'/>");
        }
        xml.append("</dataset>");

        //SCOPUS
        totArtsNo = 0;
        Map scpYearNoMap = convertObjectListToMap(scplist, keyField, valField);
        for (int ii = fy; ii <= ty; ii++) {
            if (scpYearNoMap.get(Integer.toString(ii)) != null)
                totArtsNo += Integer.parseInt(scpYearNoMap.get(Integer.toString(ii)).toString());
        }

        xml.append("<dataset seriesName='SCOPUS(Total: " + totArtsNo + ")' color='" + scpcolor + "' anchorBorderColor='" + scpcolor + "' >");
        for (int ii = fy; ii <= ty; ii++) {
            Object val = scpYearNoMap.get(Integer.toString(ii));
            if (val == null)
                xml.append("<set value='0' />");
            else
                xml.append("<set value='" + val + "' link='j-chartClick-" + ii + ";SCOPUS' toolText='" + val + "'/>");
        }
        xml.append("</dataset>");

        //KCI
        totArtsNo = 0;
        Map kciYearNoMap = convertObjectListToMap(kcilist, keyField, valField);
        for (int ii = fy; ii <= ty; ii++) {
            if (kciYearNoMap.get(Integer.toString(ii)) != null)
                totArtsNo += Integer.parseInt(kciYearNoMap.get(Integer.toString(ii)).toString());
        }

        xml.append("<dataset seriesName='KCI(Total: " + totArtsNo + ")' color='" + kcicolor + "' anchorBorderColor='" + kcicolor + "' >");
        for (int ii = fy; ii <= ty; ii++) {
            Object val = kciYearNoMap.get(Integer.toString(ii));
            if (val == null)
                xml.append("<set value='0' />");
            else
                xml.append("<set value='" + val + "' link='j-chartClick-" + ii + ";KCI' toolText='" + val + "'/>");
        }
        xml.append("</dataset>");

        xml.append("<styles>");
        xml.append("    <definition>");
        xml.append("        <style name='CaptionFont' type='font' size='12'/>");
        xml.append("   </definition>");
        xml.append("    <application>");
        xml.append("       <apply toObject='CAPTION' styles='CaptionFont' />");
        xml.append("       <apply toObject='SUBCAPTION' styles='CaptionFont' />");
        xml.append("    </application>");
        xml.append(" </styles>");

        xml.append("</chart>");

        return xml.toString();
    }

    /**
     * <pre>
     *  1. 개   요 : Make chart xml for citation chart
     *  2. 처리내용 :
     * </pre>
     *
     * @param list
     * @param contextPath
     * @return
     * @Method Name : buildCitationChart
     */
    public static String buildCitationChart(List<AnalysisVo> list, RimsSearchVo searchVo, String contextPath) {

        StringBuffer sb = new StringBuffer();
        int hindex = CacheUtils.calHIndex(list);
        int dn = 10;

        sb.append("<chart ")
                .append(" baseFontColor='#666666' ")
                .append(" baseFontSize='11' ")
                .append(" subcaptionFontBold='0' ")
                .append(" canvasBgAlpha='0' ")
                .append(" showValues='0' ")
                .append(" paletteColors='" + paletteColors + "' ")
                .append(" bgAlpha='0' ")
                .append(" showBorder='0' ")
                .append(" showShadow='0' ")
                .append(" showAlternateHGridColor='0' ")
                .append(" showCanvasBorder='0' ")
                .append(" showXAxisLine='1' ")
                .append(" xAxisLineThickness='1' ")
                .append(" xAxisLineColor='#cdcdcd' ")
                .append(" xAxisNameFontColor='#8d8d8d' ")
                .append(" yAxisNameFontColor='#8d8d8d' ")
                .append(" canvasBgColor='#ffffff' ")
                .append(" lineThickness='4' ")
                .append(" legendBgColor='#ffffff' ")
                .append(" legendBgAlpha='100' ")
                .append(" legendBorderAlpha='50' ")
                .append(" legendBorderColor='#888888' ")
                .append(" legendShadow='0' ")
                .append(" legendPosition='CENTER' ")
                .append(" divlineAlpha='0' ")
                .append(" numDivLines='10' ")
                .append(" divlineColor='#999999' ")
                .append(" divlineThickness='1' ")
                .append(" divLineIsDashed='1'")
                .append(" divLineDashLen='1'")
                .append(" divLineGapLen='1' ")
                .append(" toolTipColor='#ffffff' ")
                .append(" toolTipBorderColor='#ffffff' ")
                .append(" toolTipBorderThickness='1' ")
                .append(" toolTipBgColor='#000000' ")
                .append(" toolTipBgAlpha='80' ")
                .append(" toolTipBorderRadius='4' ")
                .append(" toolTipPadding='10' ")
                .append(" toolTipFontSize ='20' ")
                .append(" anchorBgColor='#ffffff' ")
                .append(" anchorRadius='5' ")
                .append(" anchorBorderThickness='3' ")
                .append(" anchorTrackingRadius='15' ")
                .append(" showHoverEffect='1' ")
                .append(" formatNumberScale='0'")
                .append(" labelDisplay='rotate' ")
                .append(" slantLabels='1' ")
                .append(" exportEnabled='1' ")
                .append(" exportAtClient='0' ")
                .append(" exportAction='save' ")
                .append(" exportShowMenuItem='0' ")
                .append(" exportDialogMessage='Building chart output' ")
                .append(" exportHandler='" + contextPath + "/servlet/FCExporter/export.do' exportCallBack='myFN' ")
                .append(" >");

        int max = 50;
        //if(max>list.size()) max = list.size();
        max = list.size();
        if (max > 150) dn = 50;

        sb.append("<categories >");

        for (int i = 0; i < max; i++) {
            if (i % dn == 0) sb.append("<category label='" + i + "'/>");
            else sb.append("<category />");
        }

        sb.append("</categories >");


        sb.append("<dataset seriesName='Citation' color='0080C0' anchorBorderColor='0080C0' anchorSides='3' showValues='0'>");

        boolean printed = false;
        for (int i = 0; i < max; i++) {
            //if(i==0) sb.append("<set value='' toolText=''/>");
            AnalysisVo citation = list.get(i);
            double tc = Double.parseDouble(citation.getTc().toString());
            if (!printed && tc <= hindex) {
                //sb.append("<vLine color='FF5904' thickness='2' />");
                printed = true;
            }
            sb.append("<set value='" + citation.getTc() + "' toolText='" + citation.getTc() + "'/>");
        }

        sb.append("</dataset>");

        sb.append("<dataset seriesName='Publication' color='FF5904' anchorRadius='0'>");

        for (int i = 0; i < max; i++) {
			/*
			AnalysisVo citation = list.get(i);
			double tc = Double.parseDouble(map.get("TC").toString());
			if(!printed && tc<=hindex) {
				sb.append("<vLine color='FF5904' thickness='2' />");
				printed = true;
			}
			 */
            sb.append("<set value='" + i + "' />");
        }

        sb.append("</dataset>");

        sb.append("<trendLines>");
        sb.append("<line startValue='" + hindex + "' isTrendZone='0' color='#6baa01' valueonright='1'  displayvalue='H-index(" + hindex + ")' dashed='1' dashLen='3' dashGap='4' />");
        sb.append("</trendLines>");

        sb.append("<styles>");
        sb.append("    <definition>");
        sb.append("        <style name='Anim1' type='animation' param='_alpha' start='0' duration='1' />");
        sb.append("    </definition>");
        sb.append("    <application>");
        sb.append("        <apply toObject='TRENDLINES' styles='Anim1' />");
        sb.append("   </application>");
        sb.append("</styles>");
        sb.append("</chart> ");

        return sb.toString();
    }

    /**
     * <pre>
     *  1. 개   요 : Make chart xml for cited vs uncited page
     *  2. 처리내용 :
     * </pre>
     *
     * @param arts
     * @param fromYear
     * @param toYear
     * @return
     * @Method Name : buildTrendsChartXmlWithYear
     */
    public static String buildTrendChart(List<AnalysisVo> list, RimsSearchVo searchVo, String contextPath) {

        String gubun = searchVo.getGubun();
        String fromYear = searchVo.getFromYear();
        String toYear = searchVo.getToYear();

        String caption = "Cited vs Uncited by year from " + fromYear + " to " + toYear;
        StringBuffer xml = new StringBuffer();

		/*
		xml.append(" <chart caption='"+caption+"' subcaption='' lineThickness='3' showValues='0' formatNumberScale='0' anchorRadius='2' ")
		   .append(" divLineAlpha='50' numvdivlines='5' divLineIsDashed='1' bgColor='F7F7F7, E9E9E9' ")
		   .append(" exportEnabled='1' exportAtClient='0' exportAction='save' exportHandler='"+contextPath+"/servlet/FCExporter/export.do' exportCallBack='myFN' ")
		   .append(" exportShowMenuItem='0' exportDialogMessage='Building chart output' ")
		   .append(" useRoundEdges='1' legendPosition ='CENTER' >");
		*/
        xml.append("<chart ")
                .append(" caption='" + caption + "' ")
                .append(" subcaption='' ")
                .append(" baseFontColor='#666666' ")
                .append(" baseFontSize='11' ")
                .append(" subcaptionFontBold='0' ")
                .append(" canvasBgAlpha='0' ")
                .append(" showValues='0' ")
                .append(" paletteColors='" + paletteColors + "' ")
                .append(" bgAlpha='0' ")
                .append(" showBorder='0' ")
                .append(" showShadow='0' ")
                .append(" showAlternateHGridColor='0' ")
                .append(" showCanvasBorder='0' ")
                .append(" showXAxisLine='1' ")
                .append(" xAxisLineThickness='1' ")
                .append(" xAxisLineColor='#cdcdcd' ")
                .append(" xAxisNameFontColor='#8d8d8d' ")
                .append(" yAxisNameFontColor='#8d8d8d' ")
                .append(" canvasBgColor='#ffffff' ")
                .append(" lineThickness='4' ")
                .append(" legendBgColor='#ffffff' ")
                .append(" legendBgAlpha='100' ")
                .append(" legendBorderAlpha='50' ")
                .append(" legendBorderColor='#888888' ")
                .append(" legendShadow='0' ")
                .append(" legendPosition='CENTER' ")
                .append(" divlineAlpha='0' ")  //점선 없애기
                .append(" numDivLines='10' ")
                .append(" divlineColor='#999999' ")
                .append(" divlineThickness='1' ")
                .append(" divLineIsDashed='1'")
                .append(" divLineDashLen='1'")
                .append(" divLineGapLen='1' ")
                .append(" toolTipColor='#ffffff' ")
                .append(" toolTipBorderColor='#ffffff' ")
                .append(" toolTipBorderThickness='1' ")
                .append(" toolTipBgColor='#000000' ")
                .append(" toolTipBgAlpha='80' ")
                .append(" toolTipBorderRadius='4' ")
                .append(" toolTipPadding='10' ")
                .append(" toolTipFontSize ='20' ")
                .append(" anchorBgColor='#ffffff' ")
                .append(" anchorRadius='5' ")
                .append(" anchorBorderThickness='3' ")
                .append(" anchorTrackingRadius='15' ")
                .append(" showHoverEffect='1' ")
                .append(" formatNumberScale='0'")
                .append(" labelDisplay='rotate' ")
                .append(" slantLabels='1' ")
                .append(" plotBorderColor='#ffffff' ") //bar 테두리없애기
                .append(" usePlotGradientColor='0' ") //bar의 그라데이션 없애기
                .append(" exportEnabled='1' ")
                .append(" exportAtClient='0' ")
                .append(" exportAction='save' ")
                .append(" exportShowMenuItem='0' ")
                .append(" exportDialogMessage='Building chart output' ")
                .append(" exportHandler='" + contextPath + "/servlet/FCExporter/export.do' exportCallBack='myFN' ")
                .append(" >");

        xml.append("<categories >");

        int fy = Integer.parseInt(fromYear);
        int ty = Integer.parseInt(toYear);

        for (int ii = fy; ii <= ty; ii++) {
            xml.append("<category label='" + ii + "' />");
        }

        xml.append("</categories>");

        String keyField = "pubYear";
        String noCitArtValField = "wosCitedCo";
        String noNotCitArtValField = "wosNotCitedCo";
        String noArtTotValField = "artsCo";
        if (R2Constant.ARTICLE_GUBUN_SCOPUS.equals(gubun)) {
            noCitArtValField = "scpCitedCo";
            noNotCitArtValField = "scpNotCitedCo";
        } else if (R2Constant.ARTICLE_GUBUN_KCI.equals(gubun)) {
            noCitArtValField = "kciCitedCo";
            noNotCitArtValField = "kciNotCitedCo";
        }


        Map yearNoMap = convertObjectListToMap(list, keyField, noCitArtValField);
        Map yearNotCitMap = convertObjectListToMap(list, keyField, noNotCitArtValField);
        Map yearNoTotMap = convertObjectListToMap(list, keyField, noArtTotValField);
        //Map yearCitMap = convertListToMap(arts, "IS_YEAR", "NO_CIT");

        //total no. of publications
        int totArtsNo = 0;
        int totCitArtsNo = 0;
        int totNotCitArtsNo = 0;
        for (int ii = fy; ii <= ty; ii++) {
            if (yearNoTotMap.get(Integer.toString(ii)) != null) {
                totArtsNo += Integer.parseInt(yearNoTotMap.get(Integer.toString(ii)).toString());
                totCitArtsNo += Integer.parseInt(yearNoMap.get(Integer.toString(ii)).toString());
                totNotCitArtsNo += Integer.parseInt(yearNotCitMap.get(Integer.toString(ii)).toString());
            }
        }

        //citated publications dataset
        xml.append("<dataset seriesName='Cited(Total: " + totCitArtsNo + ")'>");
        for (int ii = fy; ii <= ty; ii++) {
            Object val = yearNoMap.get(Integer.toString(ii));
            if (val == null)
                xml.append("<set value='0'  color='1aa1b5' toolText='" + ii + " cited : " + val + "'/>");
            else
                xml.append("<set value='" + val + "' color='1aa1b5' link='j-clickChart-cited;" + ii + "' toolText='" + ii + " cited : " + val + "'/>");
        }
        xml.append("</dataset>");

        //not citated publications dataset
        xml.append("<dataset seriesName='Uncited(Total: " + totNotCitArtsNo + ")'>");
        for (int ii = fy; ii <= ty; ii++) {
            Object val = yearNotCitMap.get(Integer.toString(ii));
            if (val == null)
                xml.append("<set value='0' color='2dcdb1' toolText='" + ii + " uncited : " + val + "'/>");
            else
                xml.append("<set value='" + val + "' color='2dcdb1' link='j-clickChart-notCited;" + ii + "' toolText='" + ii + " uncited : " + val + "'/>");
        }
        xml.append("</dataset>");

        //no publications dataset
		/*
		xml.append("<dataset seriesName='All(Total: "+totArtsNo+")' renderAs='Line' lineThickness='3'>");
		for(int ii = fy; ii <= ty ; ii++) {
			Object val = yearNoTotMap.get(Integer.toString(ii));
			if(val==null)
				xml.append("<set value='0' toolText='"+ii+" (Total: 0)'/>");
			else
				xml.append("<set value='"+val+"' toolText='"+ii+" (Total: "+val+")' />");
		}
		xml.append("</dataset>");
		*/
        xml.append("<trendlines>");
        xml.append("<style name='CanvasAnim' type='animation' param='_xScale' start='0' duration='1' />");
        xml.append("</trendlines>");
        xml.append("<styles>");
        xml.append("    <definition>");
        xml.append("        <style name='CaptionFont' type='font' size='12'/>");
        xml.append("   </definition>");
        xml.append("    <application>");
        xml.append("       <apply toObject='CAPTION' styles='CaptionFont' />");
        xml.append("       <apply toObject='SUBCAPTION' styles='CaptionFont' />");
        xml.append("    </application>");
        xml.append(" </styles>");

        xml.append("</chart>");

        return xml.toString();
    }


    public static String buildPatentTrendChart(List<AnalysisVo> list, RimsSearchVo searchVo, String contextPath) {

        String applStatus = searchVo.getApplStatus();
        String acqsDvsCd = searchVo.getAcqsDvsCd();
        String acqsNtnDvsCd = searchVo.getAcqsNtnDvsCd();
        Integer yMaxValue = 0;

        String setName = "";
        if (R2Constant.PATENT_STATUS_APPL_CD.equals(applStatus)) setName = R2Constant.PATENT_STATUS_APPL;
        else if (R2Constant.PATENT_STATUS_STTEMNT_CD.equals(applStatus)) setName = R2Constant.PATENT_STATUS_STTEMNT;
        else if (R2Constant.PATENT_STATUS_CONFM_CD.equals(applStatus)) setName = R2Constant.PATENT_STATUS_CONFM;
        else if (R2Constant.PATENT_STATUS_REGIST_CD.equals(applStatus)) setName = R2Constant.PATENT_STATUS_REGIST;
        else if (R2Constant.PATENT_STATUS_EXTSH_CD.equals(applStatus)) setName = R2Constant.PATENT_STATUS_EXTSH;

        if (R2Constant.PATENT_ACQS_DVS_APPL_CD.equals(acqsDvsCd)) setName = R2Constant.PATENT_ACQS_DVS_APPL;
        else if (R2Constant.PATENT_ACQS_DVS_REGIST_CD.equals(acqsDvsCd)) setName = R2Constant.PATENT_ACQS_DVS_REGIST;

        String fromYear = searchVo.getFromYear();
        String toYear = searchVo.getToYear();
        int fy = Integer.parseInt(fromYear);
        int ty = Integer.parseInt(toYear);

        String keyField = "patYear";
        String noPatentValField = "patentCo";
        String noDmstcPatentValField = "dmstcPatentCo";
        String noOvseaPatentValField = "ovseaPatentCo";

        Map yearDmstcMap = convertObjectListToMap(list, keyField, noDmstcPatentValField);
        Map yearOvseaMap = convertObjectListToMap(list, keyField, noOvseaPatentValField);
        Map yearNoTotMap = convertObjectListToMap(list, keyField, noPatentValField);
        //Map yearCitMap = convertListToMap(arts, "IS_YEAR", "NO_CIT");

        //total no. of publications
        int totPatsNo = 0;
        int totDmstcPatsNo = 0;
        int totOvseaPatsNo = 0;
        for (int ii = fy; ii <= ty; ii++) {
            if (yearNoTotMap.get(Integer.toString(ii)) != null) {
                Integer patCo = Integer.parseInt(yearNoTotMap.get(Integer.toString(ii)).toString());
                totPatsNo += patCo;
                totDmstcPatsNo += Integer.parseInt(yearDmstcMap.get(Integer.toString(ii)).toString());
                totOvseaPatsNo += Integer.parseInt(yearOvseaMap.get(Integer.toString(ii)).toString());
                if (yMaxValue < patCo) yMaxValue = patCo;
            }
        }

        String caption = "Patent Trend by year from " + fromYear + " to " + toYear;
        StringBuffer xml = new StringBuffer();

        xml.append("<chart ")
                .append(" caption='" + caption + "' ")
                .append(" subcaption='' ")
                .append(" baseFontColor='#666666' ")
                .append(" baseFontSize='11' ")
                .append(" subcaptionFontBold='0' ")
                .append(" canvasBgAlpha='0' ")
                .append(" showValues='0' ")
                .append(" paletteColors='" + paletteColors + "' ")
                .append(" bgAlpha='0' ")
                .append(" showBorder='0' ")
                .append(" showShadow='0' ")
                .append(" showAlternateHGridColor='0' ")
                .append(" showCanvasBorder='0' ")
                .append(" showXAxisLine='1' ")
                .append(" xAxisLineThickness='1' ")
                .append(" xAxisLineColor='#cdcdcd' ")
                .append(" xAxisNameFontColor='#8d8d8d' ")
                .append(" yAxisNameFontColor='#8d8d8d' ");
        if (yMaxValue < 3) xml.append(" yAxisMaxValue='5' ");
        xml.append(" canvasBgColor='#ffffff' ")
                .append(" lineThickness='4' ")
                .append(" legendBgColor='#ffffff' ")
                .append(" legendBgAlpha='100' ")
                .append(" legendBorderAlpha='50' ")
                .append(" legendBorderColor='#888888' ")
                .append(" legendShadow='0' ")
                .append(" legendPosition='CENTER' ")
                .append(" divlineAlpha='0' ")
                .append(" numDivLines='10' ")
                .append(" divlineColor='#999999' ")
                .append(" divlineThickness='1' ")
                .append(" divLineIsDashed='1'")
                .append(" divLineDashLen='1'")
                .append(" divLineGapLen='1' ")
                .append(" toolTipColor='#ffffff' ")
                .append(" toolTipBorderColor='#ffffff' ")
                .append(" toolTipBorderThickness='1' ")
                .append(" toolTipBgColor='#000000' ")
                .append(" toolTipBgAlpha='80' ")
                .append(" toolTipBorderRadius='4' ")
                .append(" toolTipPadding='10' ")
                .append(" toolTipFontSize ='20' ")
                .append(" anchorBgColor='#ffffff' ")
                .append(" anchorRadius='5' ")
                .append(" anchorBorderThickness='3' ")
                .append(" anchorTrackingRadius='15' ")
                .append(" showHoverEffect='1' ")
                .append(" formatNumberScale='0'")
                .append(" labelDisplay='rotate' ")
                .append(" slantLabels='1' ")
                .append(" exportEnabled='1' ")
                .append(" exportAtClient='0' ")
                .append(" exportAction='save' ")
                .append(" exportShowMenuItem='0' ")
                .append(" exportDialogMessage='Building chart output' ")
                .append(" exportHandler='" + contextPath + "/servlet/FCExporter/export.do' exportCallBack='myFN' ")
                .append(" >");

        xml.append("<categories >");

        for (int ii = fy; ii <= ty; ii++) {
            xml.append("<category label='" + ii + "' />");
        }

        xml.append("</categories>");


        if (R2Constant.PATENT_STATUS_APPL_CD.equals(applStatus)
                || R2Constant.PATENT_STATUS_REGIST_CD.equals(applStatus)
                || R2Constant.PATENT_ACQS_DVS_APPL_CD.equals(acqsDvsCd)
                || R2Constant.PATENT_ACQS_DVS_REGIST_CD.equals(acqsDvsCd)) {
            if (acqsNtnDvsCd == null || "".equals(acqsNtnDvsCd) || "1".equals(acqsNtnDvsCd)) {
                xml.append("<dataset seriesName='국내" + setName + "(Total: " + totDmstcPatsNo + ")'>");
                for (int ii = fy; ii <= ty; ii++) {
                    Object val = yearDmstcMap.get(Integer.toString(ii));
                    if (val == null)
                        xml.append("<set value='0' toolText='" + ii + " 국내" + setName + " : 0' color='" + fillColors[0] + "' anchorBorderColor='" + fillColors[0] + "' />");
                    else
                        xml.append("<set value='" + val + "' link='j-clickChart-cited;" + ii + "' toolText='" + ii + " 국내" + setName + " : " + val + "' color='" + fillColors[0] + "' anchorBorderColor='" + fillColors[0] + "'/>");
                }
                xml.append("</dataset>");
            }
            if (acqsNtnDvsCd == null || "".equals(acqsNtnDvsCd) || "2".equals(acqsNtnDvsCd)) {
                xml.append("<dataset seriesName='해외" + setName + "(Total: " + totOvseaPatsNo + ")'>");
                for (int ii = fy; ii <= ty; ii++) {
                    Object val = yearOvseaMap.get(Integer.toString(ii));
                    if (val == null)
                        xml.append("<set value='0' toolText='" + ii + " 해외" + setName + " : 0' color='" + fillColors[1] + "' anchorBorderColor='" + fillColors[1] + "'/>");
                    else
                        xml.append("<set value='" + val + "' link='j-clickChart-notCited;" + ii + "' toolText='" + ii + " 해외" + setName + " : " + val + "' color='" + fillColors[1] + "' anchorBorderColor='" + fillColors[1] + "'/>");
                }
                xml.append("</dataset>");
            }
        }
        //citated publications dataset
        xml.append("<dataset seriesName='" + setName + "(Total: " + totPatsNo + ")'>");
        for (int ii = fy; ii <= ty; ii++) {
            Object val = yearNoTotMap.get(Integer.toString(ii));
            if (val == null)
                xml.append("<set value='0'  toolText='" + ii + " " + setName + " : 0' color='" + fillColors[2] + "' anchorBorderColor='" + fillColors[2] + "' />");
            else
                xml.append("<set value='" + val + "' link='j-clickChart-cited;" + ii + "' toolText='" + ii + " " + setName + " : " + val + "' color='" + fillColors[2] + "' anchorBorderColor='" + fillColors[2] + "'/>");
        }
        xml.append("</dataset>");

        xml.append("<trendlines>");
        xml.append("<style name='CanvasAnim' type='animation' param='_xScale' start='0' duration='1' />");
        xml.append("</trendlines>");
        xml.append("<styles>");
        xml.append("    <definition>");
        xml.append("        <style name='CaptionFont' type='font' size='12'/>");
        xml.append("   </definition>");
        xml.append("    <application>");
        xml.append("       <apply toObject='CAPTION' styles='CaptionFont' />");
        xml.append("       <apply toObject='SUBCAPTION' styles='CaptionFont' />");
        xml.append("    </application>");
        xml.append(" </styles>");

        xml.append("</chart>");

        return xml.toString();
    }

    public static String buildPatentNationWithYearChart(List<AnalysisVo> list, List<AnalysisVo> nationList, RimsSearchVo searchVo, String contextPath) {

        String applStatus = searchVo.getApplStatus();
        String acqsDvsCd = searchVo.getAcqsDvsCd();
        String acqsNtnDvsCd = searchVo.getAcqsNtnDvsCd();
        Integer yMaxValue = 0;

        String setName = "";
        if (R2Constant.PATENT_STATUS_APPL_CD.equals(applStatus)) setName = R2Constant.PATENT_STATUS_APPL;
        else if (R2Constant.PATENT_STATUS_STTEMNT_CD.equals(applStatus)) setName = R2Constant.PATENT_STATUS_STTEMNT;
        else if (R2Constant.PATENT_STATUS_CONFM_CD.equals(applStatus)) setName = R2Constant.PATENT_STATUS_CONFM;
        else if (R2Constant.PATENT_STATUS_REGIST_CD.equals(applStatus)) setName = R2Constant.PATENT_STATUS_REGIST;
        else if (R2Constant.PATENT_STATUS_EXTSH_CD.equals(applStatus)) setName = R2Constant.PATENT_STATUS_EXTSH;

        if (R2Constant.PATENT_ACQS_DVS_APPL_CD.equals(acqsDvsCd)) setName = R2Constant.PATENT_ACQS_DVS_APPL;
        else if (R2Constant.PATENT_ACQS_DVS_REGIST_CD.equals(acqsDvsCd)) setName = R2Constant.PATENT_ACQS_DVS_REGIST;

        String fromYear = searchVo.getFromYear();
        String toYear = searchVo.getToYear();

        String caption = "Patent Trend by Nation from " + fromYear + " to " + toYear;
        StringBuffer xml = new StringBuffer();

        xml.append("<chart ")
                .append(" caption='" + caption + "' ")
                .append(" subcaption='' ")
                .append(" baseFontColor='#666666' ")
                .append(" baseFontSize='11' ")
                .append(" subcaptionFontBold='0' ")
                .append(" canvasBgAlpha='0' ")
                .append(" showValues='0' ")
                .append(" paletteColors='" + paletteColors + "' ")
                .append(" bgAlpha='0' ")
                .append(" showBorder='0' ")
                .append(" showShadow='0' ")
                .append(" showAlternateHGridColor='0' ")
                .append(" showCanvasBorder='0' ")
                .append(" showXAxisLine='1' ")
                .append(" xAxisLineThickness='1' ")
                .append(" xAxisLineColor='#cdcdcd' ")
                .append(" xAxisNameFontColor='#8d8d8d' ")
                .append(" yAxisNameFontColor='#8d8d8d' ");
        if (yMaxValue < 3) xml.append(" yAxisMaxValue='5' ");
        xml.append(" canvasBgColor='#ffffff' ")
                .append(" lineThickness='4' ")
                .append(" legendBgColor='#ffffff' ")
                .append(" legendBgAlpha='100' ")
                .append(" legendBorderAlpha='50' ")
                .append(" legendBorderColor='#888888' ")
                .append(" legendShadow='0' ")
                .append(" legendPosition='CENTER' ")
                .append(" divlineAlpha='0' ")
                .append(" numDivLines='10' ")
                .append(" divlineColor='#999999' ")
                .append(" divlineThickness='1' ")
                .append(" divLineIsDashed='1'")
                .append(" divLineDashLen='1'")
                .append(" divLineGapLen='1' ")
                .append(" toolTipColor='#ffffff' ")
                .append(" toolTipBorderColor='#ffffff' ")
                .append(" toolTipBorderThickness='1' ")
                .append(" toolTipBgColor='#000000' ")
                .append(" toolTipBgAlpha='80' ")
                .append(" toolTipBorderRadius='4' ")
                .append(" toolTipPadding='10' ")
                .append(" toolTipFontSize ='20' ")
                .append(" anchorBgColor='#ffffff' ")
                .append(" anchorRadius='5' ")
                .append(" anchorBorderThickness='3' ")
                .append(" anchorTrackingRadius='15' ")
                .append(" showHoverEffect='1' ")
                .append(" formatNumberScale='0'")
                .append(" labelDisplay='rotate' ")
                .append(" slantLabels='1' ")
                .append(" exportEnabled='1' ")
                .append(" exportAtClient='0' ")
                .append(" exportAction='save' ")
                .append(" exportShowMenuItem='0' ")
                .append(" exportDialogMessage='Building chart output' ")
                .append(" exportHandler='" + contextPath + "/servlet/FCExporter/export.do' exportCallBack='myFN' ")
                .append(" >");

        int fy = Integer.parseInt(fromYear);
        int ty = Integer.parseInt(toYear);

        xml.append("<categories >");
        for (int ii = fy; ii <= ty; ii++) {
            xml.append("<category label='" + ii + "' />");
        }
        xml.append("</categories>");

        int j = 0;
        for (AnalysisVo nation : nationList) {
            if (j >= 5) break;
            Map yearNoMap = convertObjectListToMapWithCompareValue(list, "applRegNtnCd", nation.getApplRegNtnCd(), "patYear", "patentCo");
            int fcIdx = j % 23;
            xml.append("<dataset seriesName='" + nation.getApplRegNtnNm() + "' color='" + fillColors[fcIdx] + "' anchorBorderColor='" + fillColors[fcIdx] + "' id='" + nation.getApplRegNtnCd() + "' >");
            for (int ii = fy; ii <= ty; ii++) {
                Object val = yearNoMap.get(Integer.toString(ii));
                if (val == null)
                    xml.append("<set value='0' toolText='" + nation.getApplRegNtnNm() + " " + ii + " : 0' />");
                else
                    xml.append("<set value='" + val + "'  toolText='" + nation.getApplRegNtnNm() + " " + ii + " : " + val + "' />");
            }
            xml.append("</dataset>");
            j++;
        }

        xml.append("<trendlines>");
        xml.append("<style name='CanvasAnim' type='animation' param='_xScale' start='0' duration='1' />");
        xml.append("</trendlines>");
        xml.append("<styles>");
        xml.append("    <definition>");
        xml.append("        <style name='CaptionFont' type='font' size='12'/>");
        xml.append("   </definition>");
        xml.append("    <application>");
        xml.append("       <apply toObject='CAPTION' styles='CaptionFont' />");
        xml.append("       <apply toObject='SUBCAPTION' styles='CaptionFont' />");
        xml.append("    </application>");
        xml.append(" </styles>");

        xml.append("</chart>");

        return xml.toString();
    }

    /**
     * <pre>
     *  1. 개   요 : Make chart xml for co-author network
     *  2. 처리내용 :
     * </pre>
     *
     * @param source
     * @param sname
     * @param coworks
     * @param contextPath
     * @return
     * @Method Name : buildNetworkInCenter
     */
    public static String buildCoAuthorNetworkChart(AnalysisVo mainUser, List<AnalysisVo> list, RimsSearchVo searchVo, String contextPath, String lang, String photoUrl) {

        //System.out.println("lang >>>>>>>>>> " + lang);

        double maxTtl = 0;
        double maxCoworkCnt = 0;
        double maxRel = 0;
        int radius = 20;
        dcMap = new HashMap<String, String>();
        int dfFillIdx = 0;
        String fillColor = "";

        for (int jj = 0; jj < list.size(); jj++) {
            int total = list.get(jj).getCoArtsCo();
            //if(maxTtl<total) maxTtl = total;
            if (maxCoworkCnt < total) maxCoworkCnt = total;
        }

        StringBuffer sb = new StringBuffer();
    	/*
    	sb.append(" <chart ")
    	  //.append(" caption='Co-Author Network' ")
    	  .append(" canvasBorderAlpha='0' canvasBorderThickness='0' ")
    	  .append(" chartTopMargin='3' chartLeftMargin='3' chartRightMargin='3' chartBottomMargin='3' ")
    	  .append(" baseFontSize='12' baseFont='Malgun Gothic' ")
    	  .append(" xAxisMaxValue='100' yAxisMinValue='0' yAxisMaxValue='100' ")
    	  .append(" is3d='0' animation='0' showformbtn='0' viewmode='0' ")
    	  .append(" divLineAlpha='30' numvdivlines='5' divLineIsDashed='1' bgColor='F7F7F7, E9E9E9' useEllipsesWhenOverflow='0' ")
    	  .append(" exportShowMenuItem='0' exportDialogMessage='Building chart output ' ")
    	  .append(" exportEnabled='1' exportAtClient='0' exportAction='save' exportHandler='"+contextPath+"/servlet/FCExporter/export.do' exportCallBack='myFN' ")
    	  .append(" theme='fint' ")
    	  .append(" >");
    	*/
        sb.append("<chart ")
                .append(" subcaption='' ")
                .append(" baseFontColor='#666666' ")
                .append(" baseFontSize='9' ")
                .append(" subcaptionFontBold='0' ")
                .append(" canvasBgAlpha='0' ")
                .append(" showValues='0' ")
                .append(" paletteColors='" + paletteColors + "' ")
                .append(" bgAlpha='0' ")
                .append(" showBorder='0' ")
                .append(" showformbtn='0' ")
                .append(" showRestoreBtn='0' ")
                .append(" viewmode='1' ")
                .append(" xAxisMaxValue='100' ")
                .append(" yAxisMinValue='0' ")
                .append(" yAxisMaxValue='100' ")
                .append(" chartTopMargin='3' ")
                .append(" chartLeftMargin='3' ")
                .append(" chartRightMargin='3' ")
                .append(" chartBottomMargin='3' ")
                .append(" showAlternateHGridColor='0' ")
                .append(" showCanvasBorder='0' ")
                .append(" showXAxisLine='0' ")
                .append(" xAxisLineThickness='0' ")
                .append(" xAxisLineColor='#cdcdcd' ")
                .append(" xAxisNameFontColor='#8d8d8d' ")
                .append(" yAxisNameFontColor='#8d8d8d' ")
                .append(" canvasBgColor='#ffffff' ")
                .append(" lineThickness='4' ")
                .append(" legendBgColor='#ffffff' ")
                .append(" legendBgAlpha='100' ")
                .append(" legendBorderAlpha='50' ")
                .append(" legendBorderColor='#888888' ")
                .append(" legendShadow='0' ")
                .append(" legendPosition='CENTER' ")
                .append(" divlineThickness='0' ")
                .append(" numDivLines='10' ")
                .append(" toolTipColor='#ffffff' ")
                .append(" toolTipBorderColor='#ffffff' ")
                .append(" toolTipBorderThickness='1' ")
                .append(" toolTipBgColor='#000000' ")
                .append(" toolTipBgAlpha='80' ")
                .append(" toolTipBorderRadius='4' ")
                .append(" toolTipPadding='10' ")
                .append(" toolTipFontSize ='20' ")
                .append(" anchorBgColor='#ffffff' ")
                .append(" anchorRadius='5' ")
                .append(" anchorBorderThickness='3' ")
                .append(" anchorTrackingRadius='15' ")
                .append(" showHoverEffect='1' ")
                .append(" formatNumberScale='0'")
                .append(" labelDisplay='rotate' ")
                .append(" slantLabels='1' ")
                .append(" exportEnabled='1' ")
                .append(" exportAtClient='0' ")
                .append(" exportAction='save' ")
                .append(" exportShowMenuItem='0' ")
                .append(" exportDialogMessage='Building chart output' ")
                .append(" exportHandler='" + contextPath + "/servlet/FCExporter/export.do' exportCallBack='myFN' ")
                .append(" >");


        double step = list.size() == 0 ? 0 : 360d / list.size();
        if (list.size() > 0) maxRel = list.get(0).getCoArtsCo();

        double total = Double.parseDouble(mainUser.getArtsCo().toString());
        if (maxTtl < total) maxTtl = total;

        radius = (int) ((total / maxTtl) * 40) + 20;

        if (dcMap.get(mainUser.getDeptKor()) == null) {
            fillColor = fillColors[dfFillIdx];
            dfFillIdx++;
            dcMap.put(mainUser.getDeptKor(), fillColor);
        }

        int imageHeight = 136;
        int imageWidth = 112;
        BufferedImage bi = null;
        int width = 0;
        int height = 0;
        String imageUrl = contextPath + "/images/no_researcher.gif";
        if (photoUrl != null && !"".equals(photoUrl)) {
            imageUrl = photoUrl;
            try {
                bi = ImageIO.read(new URL(imageUrl));
                width = bi.getWidth();
                height = bi.getHeight();
                //System.out.println(width + " : " + height);
                double ratio = (imageWidth * 1.0) / (width * 1.0);
                double resize = height * ratio;
                imageHeight = (int) resize;
                //System.out.println("imageHeight : " + imageHeight);
                bi.flush();

            } catch (MalformedURLException e) {
            } catch (IOException e) {
            } finally {
                if (bi != null) bi.flush();
            }
        }

        String name = lang.equals("KOR") ? mainUser.getKorNm() : mainUser.getEngNm();
        String abbrName = lang.equals("KOR") ? mainUser.getKorNm() : mainUser.getAbbrEngNm();
        String dept = lang.equals("KOR") ? mainUser.getDeptKor() : mainUser.getDeptEngAbbr();

        if ("".equals(abbrName.replace(",", ""))) abbrName = mainUser.getKorNm();

        imageUrl = contextPath + "/images/icon/person-icon-purple.png";

        sb.append("<dataset seriesName='" + name + "' plotborderthickness='8'  plotBorderColor='" + fillColor + "' >");
//		sb.append("<set x='50' y='50'  id='id_0'  label='"+abbrName+"' name='"+abbrName+"'  labelAlign='bottom' imageWidth='76' imageHeight='99' width='76' height='129' imageNode='1' imageurl='"+imageUrl+"' imageAlign='top' toolText='"+name+"{br}-"+dept+"' />");
        sb.append("<set width='150' x='50' y='50' label='[" + abbrName + "]{br}" + dept + "' height='150' id='id_0' radius='60' shape='CIRCLE' color='#d4f9ff' labelAlign='middle' toolText='[" + name + "]{br}" + dept + "' />");
        sb.append("</dataset>");

        boolean dist = true;
        for (int jj = 0; jj < list.size(); jj++) {

            double degree = (450d - step * (jj%2==0?jj:list.size()-jj-(list.size()%2==0?0:1))) % 360d;

            total = Double.parseDouble(list.get(jj).getCoArtsCo().toString());

            double radians = (Math.PI / 180) * degree;

            double cnt = Double.parseDouble(list.get(jj).getCoArtsCo().toString());
            double ratio = cnt / maxRel;

            double distRatio = dist == true ? CacheUtils.getHighDistanceRatio() / 10.0 : CacheUtils.getLowDistanceRatio() / 10.0;

            int distance = list.size() > 15 ? (int) (list.size()/2.5) : (int) (list.size()/3.5);
            double x = Math.sin(radians) * (30.0 + (jj % 2 == 0 ? distance : 0)) * distRatio + 50.0;
            double y = Math.cos(radians) * (30.0 + (jj % 2 == 0 ? distance : 0)) * distRatio + 50.0;

            radius = (int) ((cnt / maxCoworkCnt) * 25) + (55 -  distance);


            name = lang.equals("KOR") ? list.get(jj).getKorNm() : list.get(jj).getEngNm();
            abbrName = lang.equals("KOR") ? list.get(jj).getKorNm() : list.get(jj).getAbbrEngNm();
            dept = lang.equals("KOR") ? list.get(jj).getDeptKor() : list.get(jj).getDeptEngAbbr();

            if ("".equals(name.replace(",", "").trim())) name = list.get(jj).getKorNm();
            if ("".equals(abbrName.replace(",", "").trim())) abbrName = list.get(jj).getKorNm();
            if (dept == null) dept = list.get(jj).getDeptKor();

            String dispValue = StringUtils.replace(name, "'", "&#39;");
            String labelValue = StringUtils.replace(abbrName, "'", "&#39;");

            if (dcMap.get(list.get(jj).getDeptKor()) == null) {
                fillColor = fillColors[dfFillIdx];
                dfFillIdx++;
                dcMap.put(list.get(jj).getDeptKor(), fillColor);
            }
            String targetUserId = (String) list.get(jj).getUserId();
            sb.append("<dataset plotborderthickness='5' plotBorderColor='" + dcMap.get(list.get(jj).getDeptKor()) + "' seriesName='" + dispValue + "'>");
            sb.append("<set x='" + x + "' y='" + y + "' label='[" + labelValue + "]{br}" + dept + "' name='" + labelValue + "' id='id_" + (jj + 1) + "'  width='150' height='150' radius='" + radius + "' shape='CIRCLE' color='#ffffff' labelAlign='middle' link='j-chartClick-inst;" + targetUserId + ";" + dispValue + "' toolText='[" + dispValue + "]{br}" + dept + "'/>");
            sb.append("</dataset>");

            dist = dist == true ? false : true;
        }

        sb.append("<connectors color='FF0000' stdThickness='5' strength='1'>");

        for (int ki = 0; ki < list.size(); ki++) {
            String color = "AAAAAA";

            String targetUserId = (String) list.get(ki).getUserId();
            String dispValue = StringUtils.replace(list.get(ki).getKorNm(), "'", "&#39;");

            int cnt = list.get(ki).getCoArtsCo();

            double alpha = (cnt / maxRel) * 0.8 + 0.2;

            sb.append("<connector strength='" + (alpha) + "' ");
            sb.append("from='id_0' ");
            sb.append("label ='" + cnt + "' to='id_" + (ki + 1) + "' alpha='" + (alpha * 100) + "' link='j-chartClick-" + R2Constant.COAUTHOR_TARGET_INST + ";" + targetUserId + ";" + dispValue + "'  ");
            sb.append("color='" + color + "' arrowAtStart='0' arrowAtEnd='0' />");
        }
        sb.append("</connectors>");
        sb.append("<styles>");
        sb.append("<definition>");
        sb.append("   <style name='myLabelsFont' type='font' font='Malgun Gothic' bold='1' size='11' color='555555'/>");
        sb.append("</definition>");
        sb.append("<application>");
        sb.append("   <apply toObject='DataLabels' styles='myLabelsFont' />");
        sb.append("</application>");
        sb.append("</styles>");
        sb.append("</chart>");

        return sb.toString();
    }

    public static String buildOtherInstitutionCoAuthorNetworkChart(AnalysisVo mainUser, List<AnalysisVo> list, RimsSearchVo searchVo, String contextPath, String lang, String photoUrl) {

        //System.out.println("lang >>>>>>>>>> " + lang);

        double maxTtl = 0;
        double maxCoworkCnt = 0;
        double maxRel = 0;
        int radius = 20;
        dcMap = new HashMap<String, String>();
        int dfFillIdx = 0;
        String fillColor = "";

        for (int jj = 0; jj < list.size(); jj++) {
            int total = list.get(jj).getCoArtsCo();
            //if(maxTtl<total) maxTtl = total;
            if (maxCoworkCnt < total) maxCoworkCnt = total;
        }

        StringBuffer sb = new StringBuffer();

    	/*
    	sb.append(" <chart xAxisMinValue='0' canvasBorderAlpha='0' canvasBorderThickness='0' chartTopMargin='3' chartLeftMargin='3' chartRightMargin='3' chartBottomMargin='3' xAxisMaxValue='"+100+"' yAxisMinValue='0' yAxisMaxValue='"+100+"' is3D='0' viewmode='0' showformbtn='0' baseFontSize='12' baseFont='Malgun Gothic' ");
    	sb.append(" divLineAlpha='30' numvdivlines='5' divLineIsDashed='1' bgColor='F7F7F7, E9E9E9' useEllipsesWhenOverflow='0' ");
    	sb.append(" exportShowMenuItem='0' exportDialogMessage='Building chart output ' unescapeLinks='0' ");
    	sb.append(" exportEnabled='1' exportAtClient='0' exportAction='save' exportHandler='"+contextPath+"/servlet/FCExporter/export.do' exportCallBack='myFN' >");
    	*/
        sb.append("<chart ")
                .append(" subcaption='' ")
                .append(" baseFontColor='#666666' ")
                .append(" baseFontSize='9' ")
                .append(" subcaptionFontBold='0' ")
                .append(" canvasBgAlpha='0' ")
                .append(" showValues='0' ")
                .append(" showformbtn='0' ")
                .append(" showRestoreBtn='0' ")
                .append(" viewmode='1' ")
                .append(" paletteColors='" + paletteColors + "' ")
                .append(" bgAlpha='0' ")
                .append(" showBorder='0' ")
                .append(" showShadow='0' ")
                .append(" showAlternateHGridColor='0' ")
                .append(" showCanvasBorder='0' ")
                .append(" xAxisMaxValue='100' ")
                .append(" yAxisMinValue='0' ")
                .append(" yAxisMaxValue='100' ")
                .append(" chartTopMargin='3' ")
                .append(" chartLeftMargin='3' ")
                .append(" chartRightMargin='3' ")
                .append(" chartBottomMargin='3' ")
                .append(" showXAxisLine='0' ")
                .append(" xAxisLineThickness='0' ")
                .append(" xAxisLineColor='#cdcdcd' ")
                .append(" xAxisNameFontColor='#8d8d8d' ")
                .append(" yAxisNameFontColor='#8d8d8d' ")
                .append(" canvasBgColor='#ffffff' ")
                .append(" lineThickness='4' ")
                .append(" legendBgColor='#ffffff' ")
                .append(" legendBgAlpha='100' ")
                .append(" legendBorderAlpha='50' ")
                .append(" legendBorderColor='#888888' ")
                .append(" legendShadow='0' ")
                .append(" legendPosition='CENTER' ")
                .append(" divlineAlpha='100' ")
                .append(" numDivLines='10' ")
                .append(" divlineColor='#999999' ")
                .append(" divlineThickness='0' ")
                .append(" toolTipColor='#ffffff' ")
                .append(" toolTipBorderColor='#ffffff' ")
                .append(" toolTipBorderThickness='1' ")
                .append(" toolTipBgColor='#000000' ")
                .append(" toolTipBgAlpha='80' ")
                .append(" toolTipBorderRadius='4' ")
                .append(" toolTipPadding='10' ")
                .append(" toolTipFontSize ='20' ")
                .append(" anchorBgColor='#ffffff' ")
                .append(" anchorRadius='5' ")
                .append(" anchorBorderThickness='3' ")
                .append(" anchorTrackingRadius='15' ")
                .append(" showHoverEffect='1' ")
                .append(" formatNumberScale='0'")
                .append(" labelDisplay='rotate' ")
                .append(" slantLabels='1' ")
                .append(" exportEnabled='1' ")
                .append(" exportAtClient='0' ")
                .append(" exportAction='save' ")
                .append(" exportShowMenuItem='0' ")
                .append(" exportDialogMessage='Building chart output' ")
                .append(" exportHandler='" + contextPath + "/servlet/FCExporter/export.do' exportCallBack='myFN' ")
                .append(" >");

        double step = list.size() == 0 ? 0 : 360d / list.size();
        if (list.size() > 0) maxRel = list.get(0).getCoArtsCo();

        double total = Double.parseDouble(mainUser.getArtsCo().toString());
        if (maxTtl < total) maxTtl = total;

        radius = (int) ((total / maxTtl) * 40) + 20;

        if (dcMap.get(mainUser.getDeptKor()) == null) {
            fillColor = fillColors[dfFillIdx];
            dfFillIdx++;
            dcMap.put(mainUser.getDeptKor(), fillColor);
        }

        int imageHeight = 136;
        int imageWidth = 112;
        BufferedImage bi = null;
        int width = 0;
        int height = 0;
        String imageUrl = contextPath + "/images/no_researcher.gif";
        if (photoUrl != null && !"".equals(photoUrl)) {
            imageUrl = photoUrl;
            try {
                bi = ImageIO.read(new URL(imageUrl));
                width = bi.getWidth();
                height = bi.getHeight();
                System.out.println(width + " : " + height);
                double ratio = (imageWidth * 1.0) / (width * 1.0);
                double resize = height * ratio;
                imageHeight = (int) resize;
                System.out.println("imageHeight : " + imageHeight);
                bi.flush();

            } catch (MalformedURLException e) {
            } catch (IOException e) {
            } finally {
                if (bi != null) bi.flush();
            }
        }

        String name = lang.equals("KOR") ? mainUser.getKorNm() : mainUser.getEngNm();
        String abbrName = lang.equals("KOR") ? mainUser.getKorNm() : mainUser.getAbbrEngNm();
        String dept = lang.equals("KOR") ? mainUser.getDeptKor() : mainUser.getDeptEngAbbr();

        if ("".equals(abbrName.replace(",", ""))) abbrName = mainUser.getKorNm();
        dept = StringUtil.XMLEncode(dept);
        imageUrl = contextPath + "/images/icon/person-icon-purple.png";

        sb.append("<dataset seriesName='" + dept + "' plotborderthickness='8'  plotBorderColor='" + fillColor + "' >");
        //sb.append("<dataset showPlotBorder='0' plotBorderAlpha='0' allowDrag='1' showformbtn='0' plotFillAlpha='0' seriesName='" + name + "'>");
        //sb.append("<set x='50' y='50'  id='id_0' width='"+imageWidth+"' height='"+imageHeight+"' imageNode='1' imageurl='"+imageUrl+"' imageAlign='middle' toolText='"+source.get(nameKey)+"{br}-"+source.get(deptKey)+"' />");
        sb.append("<set width='150' x='50' y='50' label='[" + abbrName + "]{br}" + dept + "' height='150' id='id_0' radius='60' shape='CIRCLE' color='#d4f9ff' labelAlign='middle' toolText='[" + name + "]{br}" + dept + "' />");
        //sb.append("<set x='50' y='50'  id='id_0'  label='" + abbrName + "' name='" + abbrName + "'  labelAlign='bottom' imageWidth='76' imageHeight='99' width='76' height='129' imageNode='1' imageurl='" + imageUrl + "' imageAlign='top' toolText='" + name + "{br}-" + dept + "' />");
        //sb.append("<set x='50' y='50' label='"+source.get(nameAbbrKey)+"' name='"+source.get(nameAbbrKey)+"' id='id_0' radius='"+radius+"' imageNode='0' shape='CIRCLE' color='"+dcMap.get(source.get("SBJT_CD"))+"' toolText='"+source.get(nameKey)+"{br}-"+source.get(deptKey)+"' />");
        sb.append("</dataset>");

        boolean dist = true;
        for (int jj = 0; jj < list.size(); jj++) {

            double degree = (450d - step * (jj%2==0?jj:list.size()-jj-(list.size()%2==0?0:1))) % 360d;

            total = Double.parseDouble(list.get(jj).getCoArtsCo().toString());

            double radians = (Math.PI / 180) * degree;

            double cnt = Double.parseDouble(list.get(jj).getCoArtsCo().toString());
            double ratio = cnt / maxRel;


            double distRatio = dist == true ? CacheUtils.getHighDistanceRatio() / 10.0 : CacheUtils.getLowDistanceRatio() / 10.0;

            int distance = list.size() > 15 ? (int) (list.size()/2.5) : (int) (list.size()/3.5);
            double x = Math.sin(radians) * (30.0 + (jj % 2 == 0 ? distance : 0)) * distRatio + 50.0;
            double y = Math.cos(radians) * (30.0 + (jj % 2 == 0 ? distance : 0)) * distRatio + 50.0;

            radius = (int) ((cnt / maxCoworkCnt) * 25) + (55 -  distance);

            name = list.get(jj).getKorNm();
            dept = list.get(jj).getDeptKor();

            if ("".equals(name.replace(",", "").trim())) name = list.get(jj).getKorNm();
            if ("".equals(abbrName.replace(",", "").trim())) abbrName = list.get(jj).getKorNm();
            if (dept == null) dept = list.get(jj).getDeptKor();

            dept = StringUtil.XMLEncode(dept);
            String labelValue = StringUtils.replace(name, "'", "&#39;");

            if (dcMap.get(list.get(jj).getDeptKor()) == null) {
                fillColor = fillColors[dfFillIdx];
                dfFillIdx++;
                dcMap.put(list.get(jj).getDeptKor(), fillColor);
            }
            //String targetUserId = (String)list.get(jj).getUserId();
            sb.append("<dataset plotborderthickness='5' plotBorderColor='" + dcMap.get(list.get(jj).getDeptKor()) + "' seriesName='" + labelValue + "'>");
            sb.append("<set x='" + x + "' y='" + y + "' label='[" + labelValue + "]{br}" + (dept != null && !dept.equals("") ? dept : "소속기관명 없음")   + "' name='" + labelValue + "-" + dept + "' id='id_" + (jj + 1) + "'  width='150' height='150' radius='" + radius + "' shape='CIRCLE' color='#ffffff' labelAlign='middle' link='j-chartClick-other;" + dept + ";" + labelValue + "' toolText='[" + labelValue + "]{br}" + (dept != null && !dept.equals("") ? dept : "소속기관명 없음") + "'/>");
            sb.append("</dataset>");

            dist = dist == true ? false : true;
        }

        sb.append("<connectors color='FF0000' stdThickness='5' strength='1'>");

        for (int ki = 0; ki < list.size(); ki++) {
            String color = "AAAAAA";

            name = list.get(ki).getKorNm();
            dept = StringUtil.XMLEncode(list.get(ki).getDeptKor());

            int cnt = list.get(ki).getCoArtsCo();

            double alpha = (cnt / maxRel) * 0.8 + 0.2;

            sb.append("<connector strength='" + (alpha) + "' ");
            sb.append("from='id_0' ");
            sb.append("label ='" + cnt + "' to='id_" + (ki + 1) + "' alpha='" + (alpha * 100) + "'  link='j-chartClick-" + R2Constant.COAUTHOR_TARGET_OTHER + ";" + dept + ";" + name + "' ");
            sb.append("color='" + color + "' arrowAtStart='0' arrowAtEnd='0' />");
        }
        sb.append("</connectors>");
        sb.append("<styles>");
        sb.append("<definition>");
        sb.append("   <style name='myLabelsFont' type='font' font='Malgun Gothic' bold='1' size='11' color='555555'/>");
        sb.append("</definition>");
        sb.append("<application>");
        sb.append("   <apply toObject='DataLabels' styles='myLabelsFont' />");
        sb.append("</application>");
        sb.append("</styles>");
        sb.append("</chart>");

        return sb.toString();
    }

    /**
     * <pre>
     *  1. 개   요 : Make chart xml for journal chart
     *  2. 처리내용 :
     * </pre>
     *
     * @param journals
     * @param contextPath
     * @return
     * @Method Name : buildJournalsChart
     */
    public static String buildCoreJournalsChart(List<AnalysisVo> list, RimsSearchVo searchVo, String contextPath) {

        StringBuffer xml = new StringBuffer();
        String caption = "Journal Names Ordered by Number of Publications";
		/*
		xml.append(" <chart caption='Journal Names Ordered by Number of Publications'  yAxisName='' showValues='0' showSum='1' baseFont='Malgun Gothic' ")
		   .append(" divLineAlpha='30' numvdivlines='5' divLineIsDashed='1' bgColor='F7F7F7, E9E9E9' ")
		   .append(" exportEnabled='1' exportAtClient='0' exportAction='save' exportHandler='"+contextPath+"/servlet/FCExporter/export.do' exportCallBack='myFN' ")
		   .append(" exportShowMenuItem='0' exportDialogMessage='Building chart output' ")
		   .append(" useRoundEdges='1' >");
		 */
        xml.append("<chart ")
                .append(" caption='" + caption + "' ")
                .append(" subcaption='' ")
                .append(" baseFontColor='#666666' ")
                .append(" baseFontSize='11' ")
                .append(" subcaptionFontBold='0' ")
                .append(" canvasBgAlpha='0' ")
                .append(" showValues='0' ")
                .append(" paletteColors='" + paletteColors + "' ")
                .append(" bgAlpha='0' ")
                .append(" showBorder='0' ")
                .append(" showShadow='0' ")
                .append(" showAlternateHGridColor='0' ")
                .append(" showCanvasBorder='0' ")
                .append(" showXAxisLine='1' ")
                .append(" xAxisLineThickness='1' ")
                .append(" xAxisLineColor='#cdcdcd' ")
                .append(" xAxisNameFontColor='#8d8d8d' ")
                .append(" yAxisNameFontColor='#8d8d8d' ")
                .append(" canvasBgColor='#ffffff' ")
                .append(" lineThickness='4' ")
                .append(" legendBgColor='#ffffff' ")
                .append(" legendBgAlpha='100' ")
                .append(" legendBorderAlpha='50' ")
                .append(" legendBorderColor='#888888' ")
                .append(" legendShadow='0' ")
                .append(" legendPosition='CENTER' ")
                .append(" divlineAlpha='0' ")
                .append(" numDivLines='10' ")
                .append(" divlineColor='#999999' ")
                .append(" divlineThickness='1' ")
                .append(" divLineIsDashed='1'")
                .append(" divLineDashLen='1'")
                .append(" divLineGapLen='1' ")
                .append(" toolTipColor='#ffffff' ")
                .append(" toolTipBorderColor='#ffffff' ")
                .append(" toolTipBorderThickness='1' ")
                .append(" toolTipBgColor='#000000' ")
                .append(" toolTipBgAlpha='80' ")
                .append(" toolTipBorderRadius='4' ")
                .append(" toolTipPadding='10' ")
                .append(" toolTipFontSize ='20' ")
                .append(" anchorBgColor='#ffffff' ")
                .append(" anchorRadius='5' ")
                .append(" anchorBorderThickness='3' ")
                .append(" anchorTrackingRadius='15' ")
                .append(" showHoverEffect='1' ")
                .append(" formatNumberScale='0'")
                .append(" labelDisplay='rotate' ")
                .append(" slantLabels='1' ")
                .append(" plotBorderColor='#ffffff' ") //bar 테두리없애기
                .append(" usePlotGradientColor='0' ") //bar의 그라데이션 없애기
                .append(" exportEnabled='1' ")
                .append(" exportAtClient='0' ")
                .append(" exportAction='save' ")
                .append(" exportShowMenuItem='0' ")
                .append(" exportDialogMessage='Building chart output' ")
                .append(" exportHandler='" + contextPath + "/servlet/FCExporter/export.do' exportCallBack='myFN' ")
                .append(" >");


        xml.append("<categories >");

        for (int i = 0; i < list.size(); i++) {
            xml.append("<category label='" + list.get(i).getTitle() + "'/>");
        }

        xml.append("</categories >");

        xml.append("<dataset seriesName='Cited' color='1aa1b5' >");

        for (int ii = 0; ii < list.size(); ii++) {
            Integer citedCo = 0;
            if (R2Constant.ARTICLE_GUBUN_WOS.equals(searchVo.getGubun())) citedCo = list.get(ii).getWosCitedCo();
            else if (R2Constant.ARTICLE_GUBUN_SCOPUS.equals(searchVo.getGubun()))
                citedCo = list.get(ii).getScpCitedCo();
            else if (R2Constant.ARTICLE_GUBUN_KCI.equals(searchVo.getGubun())) citedCo = list.get(ii).getKciCitedCo();
            xml.append("<set value='" + citedCo + "' link='j-chartClick-cited;" + list.get(ii).getIssnNo() + "' toolText='cited : " + citedCo + "' />");
        }
        xml.append("</dataset>");

        xml.append("<dataset seriesName='Uncited' color='2dcdb1' >");
        for (int ii = 0; ii < list.size(); ii++) {
            Integer notCitedCo = 0;
            if (R2Constant.ARTICLE_GUBUN_WOS.equals(searchVo.getGubun())) notCitedCo = list.get(ii).getWosNotCitedCo();
            else if (R2Constant.ARTICLE_GUBUN_SCOPUS.equals(searchVo.getGubun()))
                notCitedCo = list.get(ii).getScpNotCitedCo();
            else if (R2Constant.ARTICLE_GUBUN_KCI.equals(searchVo.getGubun()))
                notCitedCo = list.get(ii).getKciNotCitedCo();
            xml.append("<set value='" + notCitedCo + "' link='j-chartClick-notCited;" + list.get(ii).getIssnNo() + "' toolText='uncited : " + notCitedCo + "' />");
        }
        xml.append("</dataset>");

        xml.append("<styles>");
        xml.append("    <definition>");
        xml.append("        <style name='CaptionFont' type='font' size='15' color='D64646'/>");
        xml.append("        <style name='myAxisTitlesFont' type='font' font='Arial' size='11' bold='1'/>");
        xml.append("        <style name='myLabelsFont' type='font' font='Malgun Gothic' size='11' bold='1' />");
        xml.append("   </definition>");
        xml.append("    <application>");
        xml.append("       <apply toObject='CAPTION' styles='CaptionFont' />");
        xml.append("       <apply toObject='SUBCAPTION' styles='CaptionFont' />");
        xml.append("       <apply toObject='XAxisName' styles='myAxisTitlesFont' />");
        xml.append("       <apply toObject='DataLabels' styles='myLabelsFont' />");
        xml.append("    </application>");
        xml.append(" </styles>");

        xml.append("</chart>");

        return xml.toString();
    }

    /**
     * <pre>
     *  1. 개   요 : Make chart xml from user article chart by year
     *  2. 처리내용 :
     * </pre>
     *
     * @param arts
     * @param users
     * @param fromYear
     * @param toYear
     * @param gubun
     * @param contextPath
     * @return
     * @Method Name : buildUsersArtChartXmlWithYear
     */
    public static String buildUserArtsWithYearChart(List<AnalysisVo> userList, List<AnalysisVo> list, RimsSearchVo searchVo, String contextPath) {

        String gubun = searchVo.getGubun();
        String fromYear = searchVo.getFromYear();
        String toYear = searchVo.getToYear();
        String keyField = "pubYear";

        String valField = "artsTotal";
        if (R2Constant.ARTICLE_GUBUN_WOS.equals(gubun)) valField = "sciArtsCo";
        else if (R2Constant.ARTICLE_GUBUN_SCOPUS.equals(gubun)) valField = "scpArtsCo";
        else if (R2Constant.ARTICLE_GUBUN_KCI.equals(gubun)) valField = "kciArtsCo";

        //String caption = "Publications by year from "+fromYear+ " to " + toYear;
        StringBuffer xml = new StringBuffer();

/*
 	    xml.append(" <chart animation='0' caption='' subcaption='' lineThickness='2' showValues='0' formatNumberScale='0' ")
		   .append(" divLineAlpha='30' numvdivlines='5' divLineIsDashed='1' bgColor='F7F7F7, E9E9E9' ")
		   .append(" exportEnabled='1' exportAtClient='0' exportAction='save' exportHandler='"+contextPath+"/servlet/FCExporter/export.do' exportCallBack='myFN' ")
		   .append(" exportShowMenuItem='0' exportDialogMessage='Building chart output' ")
		   .append(" showLegend='1' legendPosition ='CENTER '>");
*/

        xml.append("<chart ")
                .append(" subcaption='' ")
                .append(" baseFontColor='#666666' ")
                .append(" baseFontSize='11' ")
                .append(" subcaptionFontBold='0' ")
                .append(" canvasBgAlpha='0' ")
                .append(" showValues='0' ")
                .append(" paletteColors='" + paletteColors + "' ")
                .append(" bgAlpha='0' ")
                .append(" showBorder='0' ")
                .append(" showShadow='0' ")
                .append(" showAlternateHGridColor='0' ")
                .append(" showCanvasBorder='0' ")
                .append(" showXAxisLine='1' ")
                .append(" xAxisLineThickness='1' ")
                .append(" xAxisLineColor='#cdcdcd' ")
                .append(" xAxisNameFontColor='#8d8d8d' ")
                .append(" yAxisNameFontColor='#8d8d8d' ")
                .append(" canvasBgColor='#ffffff' ")
                .append(" lineThickness='4' ")
                .append(" legendBgColor='#ffffff' ")
                .append(" legendBgAlpha='100' ")
                .append(" legendBorderAlpha='50' ")
                .append(" legendBorderColor='#888888' ")
                .append(" legendShadow='0' ")
                .append(" legendPosition='CENTER' ")
                .append(" divlineAlpha='0' ")
                .append(" numDivLines='10' ")
                .append(" divlineColor='#999999' ")
                .append(" divlineThickness='1' ")
                .append(" divLineIsDashed='1'")
                .append(" divLineDashLen='1'")
                .append(" divLineGapLen='1' ")
                .append(" toolTipColor='#ffffff' ")
                .append(" toolTipBorderColor='#ffffff' ")
                .append(" toolTipBorderThickness='1' ")
                .append(" toolTipBgColor='#000000' ")
                .append(" toolTipBgAlpha='80' ")
                .append(" toolTipBorderRadius='4' ")
                .append(" toolTipPadding='10' ")
                .append(" toolTipFontSize ='20' ")
                .append(" anchorBgColor='#ffffff' ")
                .append(" anchorRadius='5' ")
                .append(" anchorBorderThickness='3' ")
                .append(" anchorTrackingRadius='15' ")
                .append(" showHoverEffect='1' ")
                .append(" formatNumberScale='0'")
                .append(" labelDisplay='rotate' ")
                .append(" slantLabels='1' ")
                .append(" exportEnabled='1' ")
                .append(" exportAtClient='0' ")
                .append(" exportAction='save' ")
                .append(" exportShowMenuItem='0' ")
                .append(" exportDialogMessage='Building chart output' ")
                .append(" exportHandler='" + contextPath + "/servlet/FCExporter/export.do' exportCallBack='myFN' ")
                .append(" >");

        int fy = Integer.parseInt(fromYear);
        int ty = Integer.parseInt(toYear);

        xml.append("<categories >");
        for (int ii = fy; ii <= ty; ii++) xml.append("<category label='" + ii + "' />");
        xml.append("</categories>");

        int fc = 0;
        for (AnalysisVo user : userList) {
            Map yearNoMap = convertObjectListToMapWithCompareValue(list, "userId", user.getUserId(), keyField, valField);
            //String sn = user.getKorNm() + "(" + user.getUserId() + ")";
            String sn = user.getKorNm();
            xml.append("<dataset seriesName='" + sn + "' color='" + fillColors[fc] + "' anchorBorderColor='" + fillColors[fc] + "' id='" + user.getUserId() + "' >");
            for (int ii = fy; ii <= ty; ii++) {
                Object val = yearNoMap.get(Integer.toString(ii));
                if (val == null)
                    xml.append("<set value='0' toolText='" + sn + " " + ii + " : 0' />");
                else
                    xml.append("<set value='" + val + "'  toolText='" + sn + " " + ii + " : " + val + "' />");
            }
            xml.append("</dataset>");

            if (fc > 3) break; // 초기화면에 상위 5개만 보여줌.
            fc++;
        }

        xml.append("<styles>");
        xml.append("    <definition>");
        xml.append("        <style name='CaptionFont' type='font' size='12'/>");
        xml.append("   </definition>");
        xml.append("    <application>");
        xml.append("       <apply toObject='CAPTION' styles='CaptionFont' />");
        xml.append("       <apply toObject='SUBCAPTION' styles='CaptionFont' />");
        xml.append("    </application>");
        xml.append(" </styles>");
        xml.append("</chart>");

        return xml.toString();

    }

    public static String buildUserPatsWithYearChart(List<AnalysisVo> userList, List<AnalysisVo> list, RimsSearchVo searchVo, String contextPath) {

        String fromYear = searchVo.getFromYear();
        String toYear = searchVo.getToYear();
        String applStatus = searchVo.getApplStatus();
        String acqsDvsCd = searchVo.getAcqsDvsCd();
        String acqsNtnDvsCd = searchVo.getAcqsNtnDvsCd();

        String setName = "";
        if (R2Constant.PATENT_STATUS_APPL_CD.equals(applStatus)) setName = R2Constant.PATENT_STATUS_APPL;
        else if (R2Constant.PATENT_STATUS_STTEMNT_CD.equals(applStatus)) setName = R2Constant.PATENT_STATUS_STTEMNT;
        else if (R2Constant.PATENT_STATUS_CONFM_CD.equals(applStatus)) setName = R2Constant.PATENT_STATUS_CONFM;
        else if (R2Constant.PATENT_STATUS_REGIST_CD.equals(applStatus)) setName = R2Constant.PATENT_STATUS_REGIST;
        else if (R2Constant.PATENT_STATUS_EXTSH_CD.equals(applStatus)) setName = R2Constant.PATENT_STATUS_EXTSH;

        if (R2Constant.PATENT_ACQS_DVS_APPL_CD.equals(acqsDvsCd)) setName = R2Constant.PATENT_ACQS_DVS_APPL;
        else if (R2Constant.PATENT_ACQS_DVS_REGIST_CD.equals(acqsDvsCd)) setName = R2Constant.PATENT_ACQS_DVS_REGIST;

        String xAxisName = "";
        if (R2Constant.PATENT_STATUS_APPL_CD.equals(applStatus)
                || R2Constant.PATENT_STATUS_REGIST_CD.equals(applStatus)
                || R2Constant.PATENT_ACQS_DVS_APPL_CD.equals(acqsDvsCd)
                || R2Constant.PATENT_ACQS_DVS_REGIST_CD.equals(acqsDvsCd)) {
            if ("1".equals(acqsNtnDvsCd)) {
                xAxisName = "국내" + setName;
            } else if ("2".equals(acqsNtnDvsCd)) {
                xAxisName = "해외" + setName;
            }
        } else {
            xAxisName = setName;
        }
        //String caption = "Publications by year from "+fromYear+ " to " + toYear;
        StringBuffer xml = new StringBuffer();
		/*
		xml.append(" <chart animation='0' caption='' subcaption='' lineThickness='2' showValues='0' showSum='1' formatNumberScale='0' ")
		.append(" xAxisName='"+xAxisName+"' yAxisName='특허건수' ")
		.append(" divLineAlpha='30' numvdivlines='5' useroundedges='1' divLineIsDashed='1' bgColor='FFFFFF,FFFFFF' showborder='0' ")
		.append(" exportEnabled='1' exportAtClient='0' exportAction='save' exportHandler='"+contextPath+"/servlet/FCExporter/export.do' exportCallBack='myFN' ")
		.append(" exportShowMenuItem='0' exportDialogMessage='Building chart output' ")
		.append(" showLegend='1' legendPosition ='CENTER '>");

		*/
        xml.append("<chart ")
                .append(" subcaption='' ")
                .append(" baseFontColor='#666666' ")
                .append(" baseFontSize='11' ")
                .append(" subcaptionFontBold='0' ")
                .append(" canvasBgAlpha='0' ")
                .append(" showValues='0' ")
                .append(" paletteColors='" + paletteColors + "' ")
                .append(" bgAlpha='0' ")
                .append(" showBorder='0' ")
                .append(" showShadow='0' ")
                .append(" showAlternateHGridColor='0' ")
                .append(" showCanvasBorder='0' ")
                .append(" showXAxisLine='1' ")
                .append(" xAxisName='" + xAxisName + "' ")
                .append(" xAxisLineThickness='1' ")
                .append(" xAxisLineColor='#cdcdcd' ")
                .append(" xAxisNameFontColor='#8d8d8d' ")
                .append(" yAxisName='특허건수' ")
                .append(" yAxisNameFontColor='#8d8d8d' ")
                .append(" canvasBgColor='#ffffff' ")
                .append(" lineThickness='4' ")
                .append(" legendBgColor='#ffffff' ")
                .append(" legendBgAlpha='100' ")
                .append(" legendBorderAlpha='50' ")
                .append(" legendBorderColor='#888888' ")
                .append(" legendShadow='0' ")
                .append(" legendPosition='CENTER' ")
                .append(" divlineAlpha='100' ")
                .append(" numDivLines='10' ")
                .append(" divlineColor='#999999' ")
                .append(" divlineThickness='1' ")
                .append(" divLineIsDashed='1'")
                .append(" divLineDashLen='1'")
                .append(" divLineGapLen='1' ")
                .append(" toolTipColor='#ffffff' ")
                .append(" toolTipBorderColor='#ffffff' ")
                .append(" toolTipBorderThickness='1' ")
                .append(" toolTipBgColor='#000000' ")
                .append(" toolTipBgAlpha='80' ")
                .append(" toolTipBorderRadius='4' ")
                .append(" toolTipPadding='10' ")
                .append(" toolTipFontSize ='20' ")
                .append(" anchorBgColor='#ffffff' ")
                .append(" anchorRadius='5' ")
                .append(" anchorBorderThickness='3' ")
                .append(" anchorTrackingRadius='15' ")
                .append(" showHoverEffect='1' ")
                .append(" formatNumberScale='0'")
                .append(" labelDisplay='rotate' ")
                .append(" slantLabels='1' ")
                .append(" exportEnabled='1' ")
                .append(" exportAtClient='0' ")
                .append(" exportAction='save' ")
                .append(" exportShowMenuItem='0' ")
                .append(" exportDialogMessage='Building chart output' ")
                .append(" exportHandler='" + contextPath + "/servlet/FCExporter/export.do' exportCallBack='myFN' ")
                .append(" >");

        int fy = Integer.parseInt(fromYear);
        int ty = Integer.parseInt(toYear);

        xml.append("<categories >");
        for (int ii = fy; ii <= ty; ii++) xml.append("<category label='" + ii + "' />");
        xml.append("</categories>");

        String keyField = "patYear";
        String noPatentValField = "patentCo";
        String noDmstcPatentValField = "dmstcPatentCo";
        String noOvseaPatentValField = "ovseaPatentCo";

        int fc = 0;
        for (AnalysisVo user : userList) {

            if (R2Constant.PATENT_STATUS_APPL_CD.equals(applStatus)
                    || R2Constant.PATENT_STATUS_REGIST_CD.equals(applStatus)
                    || R2Constant.PATENT_ACQS_DVS_APPL_CD.equals(acqsDvsCd)
                    || R2Constant.PATENT_ACQS_DVS_REGIST_CD.equals(acqsDvsCd)) {
                if ("1".equals(acqsNtnDvsCd)) {
                    Map yearDmstcMap = convertObjectListToMapWithCompareValue(list, "userId", user.getUserId(), keyField, noDmstcPatentValField);
                    String disp = user.getKorNm();//+"(국내"+setName+")";
                    xml.append("<dataset seriesName='" + disp + "'>");
                    for (int ii = fy; ii <= ty; ii++) {
                        Object val = yearDmstcMap.get(Integer.toString(ii));
                        if (val == null)
                            xml.append("<set value='0' toolText='" + disp + " " + ii + " : 0' />");
                        else
                            xml.append("<set value='" + val + "'  toolText='" + disp + " " + ii + " : " + val + "' />");
                    }
                    xml.append("</dataset>");
                } else if ("2".equals(acqsNtnDvsCd)) {
                    Map yearOvseaMap = convertObjectListToMapWithCompareValue(list, "userId", user.getUserId(), keyField, noOvseaPatentValField);
                    String disp = user.getKorNm();//+"(해외"+setName+")";
                    xml.append("<dataset seriesName='" + disp + "'>");
                    for (int ii = fy; ii <= ty; ii++) {
                        Object val = yearOvseaMap.get(Integer.toString(ii));
                        if (val == null)
                            xml.append("<set value='0' toolText='" + disp + " " + ii + " : 0' />");
                        else
                            xml.append("<set value='" + val + "'  toolText='" + disp + " " + ii + " : " + val + "' />");
                    }
                    xml.append("</dataset>");
                }
            } else {
                Map yearNoMap = convertObjectListToMapWithCompareValue(list, "userId", user.getUserId(), keyField, noPatentValField);
                String disp = user.getKorNm();//+"("+setName+")";
                xml.append("<dataset seriesName='" + disp + "'>");
                for (int ii = fy; ii <= ty; ii++) {
                    Object val = yearNoMap.get(Integer.toString(ii));
                    if (val == null)
                        xml.append("<set value='0' toolText='" + disp + " " + ii + " : 0' />");
                    else
                        xml.append("<set value='" + val + "'  toolText='" + disp + " " + ii + " : " + val + "' />");
                }
                xml.append("</dataset>");

            }

			/*
			Map yearNoMap = convertObjectListToMapWithCompareValue(list, "userId", user.getUserId(), keyField, valField);
			String sn = user.getKorNm() + "(" + user.getUserId() + ")";
			xml.append("<dataset seriesName='"+sn+"' color='"+fillColors[fc]+"' anchorBorderColor='"+fillColors[fc]+"' id='"+user.getUserId()+"' >");
			for(int ii = fy; ii <= ty ; ii++) {
				Object val = yearNoMap.get(Integer.toString(ii));
				if(val==null)
					xml.append("<set value='0' toolText='"+sn+" "+ii+" : 0' />");
				else
					xml.append("<set value='"+val+"'  toolText='"+sn+" "+ii+" : "+val+"' />");
			}
			xml.append("</dataset>");
			 */

            if (fc > 3) break; // 초기화면에 상위 5개만 보여줌.
            fc++;
        }

        xml.append("<styles>");
        xml.append("    <definition>");
        xml.append("        <style name='CaptionFont' type='font' size='12'/>");
        xml.append("   </definition>");
        xml.append("    <application>");
        xml.append("       <apply toObject='CAPTION' styles='CaptionFont' />");
        xml.append("       <apply toObject='SUBCAPTION' styles='CaptionFont' />");
        xml.append("    </application>");
        xml.append(" </styles>");
        xml.append("</chart>");

        return xml.toString();

    }

    public static List<AnalysisVo> buildBarChartXML(List<AnalysisVo> list, String valField) {
        List<AnalysisVo> retList = new ArrayList<AnalysisVo>();
        Object maxValue = getMaxValueFromObjectList(list, valField);
        Double maxArtsTotal = Double.parseDouble(maxValue.toString()) + 8;
        int fc = 0;
        for (AnalysisVo userArt : list) {
            StringBuffer chartXml = new StringBuffer();
            Object val = getValueFromObject(userArt, valField);
            double dValue = Math.round((Double.parseDouble(val.toString())) * 100d) / 100d;
            chartXml.append("<chart animation='0' showPlotBorder='0'  showAboutMenuItem='0' yAxisMaxValue='" + maxArtsTotal.toString() + "' ")
                    .append(" baseFont='Malgun Gothic' numDivLines='0' formatNumberScale='0' ")
                    .append(" showBorder='0' showLabels='0' showYAxisValues='0' showValues='1' ")
                    .append(" bgColor='FFFFFF,FFFFFF' plotFillRatio='100' plotfillalpha='100,100' ")
                    .append(" chartTopMargin='0' chartLeftMargin='0' chartRightMargin='0' chartBottomMargin='0' ")
                    .append(" canvasBorderColor='FFFFFF'  canvasBgColor='FFFFFF,FFFFFF' canvasborderthickness='0' >")
                    .append("<set value='" + dValue + "' showLabel='0'  color='" + fillColors[fc] + "' />")
                    .append("</chart>");
            userArt.setChartXML(chartXml.toString());
            retList.add(userArt);
            fc++;
            if (fc > (fillColors.length - 1)) fc = 0;
        }
        return retList;
    }

    /**
     * <pre>
     *  1. 개   요 : Make chart xml for user article chart by average impact factor
     *  2. 처리내용 :
     * </pre>
     *
     * @param arts
     * @param users
     * @param fromYear
     * @param toYear
     * @param gubun
     * @param contextPath
     * @return
     * @Method Name : buildUsersArtChartXmlWithAvgIF
     */
    public static String buildUsersArtAvgIFWithYearChart(List<AnalysisVo> userList, List<AnalysisVo> list, RimsSearchVo searchVo, String contextPath) {

        StringBuffer xml = new StringBuffer();
        String gubun = searchVo.getGubun();
        String avgIFType = searchVo.getAvgIFType();
        String fromYear = searchVo.getFromYear();
        String toYear = searchVo.getToYear();
        String yAxisName = "IF평균1 (IF합/전체논문수)";
        String keyField = "pubYear";

        String valField = "impctFctrAvrg";
        if (R2Constant.ARTICLE_GUBUN_SCOPUS.equals(gubun)) valField = "sjrAvrg";
        else if (R2Constant.ARTICLE_GUBUN_KCI.equals(gubun)) valField = "kciIFAvrg";

        if ("ex".equals(avgIFType)) {
            yAxisName = "IF평균2 (IF합/IF제공논문수)";
            valField = "impctFctrExsAvrg";
            if (R2Constant.ARTICLE_GUBUN_SCOPUS.equals(gubun)) valField = "sjrExsAvrg";
            else if (R2Constant.ARTICLE_GUBUN_KCI.equals(gubun)) valField = "kciIFExsAvrg";
        }
		/*
		xml.append("<chart animation='0' caption='' subcaption='' lineThickness='2' showValues='0' formatNumberScale='0' decimals='2' anchorRadius='4' showLegend='1' ")
		.append(" xAxisName='year' yAxisName='"+yAxisName+"' ")
		.append(" divLineAlpha='30' divLineIsDashed='1' bgColor='F7F7F7, E9E9E9' adjustDiv='0' yAxisMaxvalue='7' yAxisMinValue='0' numDivLines='13' yAxisValueDecimals='0' yAxisValuesStep='2' ")
		.append(" exportEnabled='1' exportAtClient='0' exportAction='save' exportHandler='"+contextPath+"/servlet/FCExporter/export.do' exportCallBack='myFN' ")
		.append(" exportShowMenuItem='0' exportDialogMessage='Building chart output' ")
		.append(" legendPosition ='CENTER '>");
		*/
        xml.append("<chart ")
                .append(" subcaption='' ")
                .append(" baseFontColor='#666666' ")
                .append(" baseFontSize='11' ")
                .append(" subcaptionFontBold='0' ")
                .append(" canvasBgAlpha='0' ")
                .append(" showValues='0' ")
                .append(" paletteColors='" + paletteColors + "' ")
                .append(" bgAlpha='0' ")
                .append(" showBorder='0' ")
                .append(" showShadow='0' ")
                .append(" showAlternateHGridColor='0' ")
                .append(" showCanvasBorder='0' ")
                .append(" showXAxisLine='1' ")
                .append(" xAxisName='year' ")
                .append(" xAxisLineThickness='1' ")
                .append(" xAxisLineColor='#cdcdcd' ")
                .append(" xAxisNameFontColor='#8d8d8d' ")
                .append(" yAxisName='" + yAxisName + "' ")
                .append(" yAxisNameFontColor='#8d8d8d' ")
                .append(" canvasBgColor='#ffffff' ")
                .append(" lineThickness='4' ")
                .append(" legendBgColor='#ffffff' ")
                .append(" legendBgAlpha='100' ")
                .append(" legendBorderAlpha='50' ")
                .append(" legendBorderColor='#888888' ")
                .append(" legendShadow='0' ")
                .append(" legendPosition='CENTER' ")
                .append(" divlineAlpha='0' ")
                .append(" numDivLines='10' ")
                .append(" divlineColor='#999999' ")
                .append(" divlineThickness='1' ")
                .append(" divLineIsDashed='1'")
                .append(" divLineDashLen='1'")
                .append(" divLineGapLen='1' ")
                .append(" toolTipColor='#ffffff' ")
                .append(" toolTipBorderColor='#ffffff' ")
                .append(" toolTipBorderThickness='1' ")
                .append(" toolTipBgColor='#000000' ")
                .append(" toolTipBgAlpha='80' ")
                .append(" toolTipBorderRadius='4' ")
                .append(" toolTipPadding='10' ")
                .append(" toolTipFontSize ='20' ")
                .append(" anchorBgColor='#ffffff' ")
                .append(" anchorRadius='5' ")
                .append(" anchorBorderThickness='3' ")
                .append(" anchorTrackingRadius='15' ")
                .append(" showHoverEffect='1' ")
                .append(" formatNumberScale='0'")
                .append(" labelDisplay='rotate' ")
                .append(" slantLabels='1' ")
                .append(" exportEnabled='1' ")
                .append(" exportAtClient='0' ")
                .append(" exportAction='save' ")
                .append(" exportShowMenuItem='0' ")
                .append(" exportDialogMessage='Building chart output' ")
                .append(" exportHandler='" + contextPath + "/servlet/FCExporter/export.do' exportCallBack='myFN' ")
                .append(" >");

        int fy = Integer.parseInt(fromYear);
        int ty = Integer.parseInt(toYear);

        xml.append("<categories >");
        for (int ii = fy; ii <= ty; ii++) {
            xml.append("<category label='" + ii + "' />");
        }
        xml.append("</categories>");

        int fc = 0;
        for (AnalysisVo user : userList) {
            Map yearNoMap = convertObjectListToMapWithCompareValue(list, "userId", user.getUserId(), keyField, valField);
            //String sn = user.getKorNm() + "(" + user.getUserId() + ")";
            String sn = user.getKorNm();
            xml.append("<dataset seriesName='" + sn + "' color='" + fillColors[fc] + "' anchorBorderColor='" + fillColors[fc] + "' id='" + user.getUserId() + "' >");
            for (int ii = fy; ii <= ty; ii++) {
                Object val = yearNoMap.get(Integer.toString(ii));
                if (val == null) {
                    xml.append("<set value='0' toolText='" + sn + " " + ii + " : 0' />");
                } else {
                    double dValue = Math.round((Double.parseDouble(val.toString())) * 100d) / 100d;
                    //d = Math.round((Double.parseDouble(val.toString()))*100d)/100d;
                    xml.append("<set value='" + val.toString().trim() + "'  toolText='" + sn + " " + ii + " : " + dValue + "' />");
                }
            }
            xml.append("</dataset>");

            if (fc > 3) break;
            fc++;
        }

        xml.append("<styles>");
        xml.append("    <definition>");

        xml.append("        <style name='CaptionFont' type='font' size='12'/>");
        xml.append("   </definition>");
        xml.append("    <application>");
        xml.append("       <apply toObject='CAPTION' styles='CaptionFont' />");
        xml.append("       <apply toObject='SUBCAPTION' styles='CaptionFont' />");
        xml.append("    </application>");
        xml.append(" </styles>");

        xml.append("</chart>");

        return xml.toString();

    }

    /**
     * <pre>
     *  1. 개   요 : Make chart xml from user citation chart
     *  2. 처리내용 :
     * </pre>
     *
     * @param users
     * @param gubun
     * @param contextPath
     * @return
     * @Method Name : buildUsersCitationChartXml
     */
    public static String buildUsersCitationChartXml(List<AnalysisVo> userList, RimsSearchVo searchVo, String contextPath) {

        //String caption = "Publications by year from "+fromYear+ " to " + toYear;
        StringBuffer xml = new StringBuffer();
        String gubun = searchVo.getGubun();

        int i = 0;
		/*
		 xml.append(" <chart animation='0' caption='' lineThickness='2' showValues='1' decimals='2'  formatNumberScale='0' anchorRadius='4' ")
		 	.append(" divLineAlpha='30' numvdivlines='5' divLineIsDashed='1' bgColor='F7F7F7, E9E9E9' ")
			.append(" PYAxisName='피인용 횟수 합계' SYAxisName='논문당 평균 피인용 횟수' slantLabels='1'  labelDisplay='ROTATE' ")
			.append(" exportEnabled='1' exportAtClient='0' exportAction='save' exportHandler='"+contextPath+"/servlet/FCExporter/export.do' exportCallBack='myFN' ")
			.append(" exportShowMenuItem='0' exportDialogMessage='Building chart output' ")
			.append(" useRoundEdges='1' legendPosition ='CENTER '>");
	 	*/
        xml.append("<chart ")
                .append(" subcaption='' ")
                .append(" baseFontColor='#666666' ")
                .append(" baseFontSize='11' ")
                .append(" subcaptionFontBold='0' ")
                .append(" canvasBgAlpha='0' ")
                .append(" showValues='0' ")
                .append(" paletteColors='" + paletteColors + "' ")
                .append(" bgAlpha='0' ")
                .append(" showBorder='0' ")
                .append(" showShadow='0' ")
                .append(" showAlternateHGridColor='0' ")
                .append(" showCanvasBorder='0' ")
                .append(" showXAxisLine='1' ")
                .append(" PYAxisName='피인용 횟수 합계' ")
                .append(" xAxisLineThickness='1' ")
                .append(" xAxisLineColor='#cdcdcd' ")
                .append(" xAxisNameFontColor='#8d8d8d' ")
                .append(" SYAxisName='논문당 평균 피인용 횟수' ")
                .append(" yAxisNameFontColor='#8d8d8d' ")
                .append(" canvasBgColor='#ffffff' ")
                .append(" lineThickness='4' ")
                .append(" legendBgColor='#ffffff' ")
                .append(" legendBgAlpha='100' ")
                .append(" legendBorderAlpha='50' ")
                .append(" legendBorderColor='#888888' ")
                .append(" legendShadow='0' ")
                .append(" legendPosition='CENTER' ")
                .append(" divlineAlpha='0' ")
                .append(" numDivLines='10' ")
                .append(" divlineColor='#999999' ")
                .append(" divlineThickness='1' ")
                .append(" divLineIsDashed='1'")
                .append(" divLineDashLen='1'")
                .append(" divLineGapLen='1' ")
                .append(" toolTipColor='#ffffff' ")
                .append(" toolTipBorderColor='#ffffff' ")
                .append(" toolTipBorderThickness='1' ")
                .append(" toolTipBgColor='#000000' ")
                .append(" toolTipBgAlpha='80' ")
                .append(" toolTipBorderRadius='4' ")
                .append(" toolTipPadding='10' ")
                .append(" toolTipFontSize ='20' ")
                .append(" anchorBgColor='#ffffff' ")
                .append(" anchorRadius='5' ")
                .append(" anchorBorderThickness='3' ")
                .append(" anchorTrackingRadius='15' ")
                .append(" showHoverEffect='1' ")
                .append(" formatNumberScale='0'")
                .append(" labelDisplay='rotate' ")
                .append(" slantLabels='1' ")
                .append(" plotBorderColor='#ffffff' ") //bar 테두리없애기
                .append(" usePlotGradientColor='0' ") //bar의 그라데이션 없애기
                .append(" exportEnabled='1' ")
                .append(" exportAtClient='0' ")
                .append(" exportAction='save' ")
                .append(" exportShowMenuItem='0' ")
                .append(" exportDialogMessage='Building chart output' ")
                .append(" exportHandler='" + contextPath + "/servlet/FCExporter/export.do' exportCallBack='myFN' ")
                .append(" >");


        xml.append("<categories >");
        for (AnalysisVo user : userList) {
            if (i > 5) break;
            xml.append("<category label='" + user.getKorNm().trim() + "' />");
            i++;
        }
        xml.append("</categories>");

        i = 0;
        xml.append("<dataset seriesName='피인용 횟수 합계' parentYAxis='P' color='" + fillColors[0] + "' >");
        for (AnalysisVo user : userList) {
            if (i > 5) break;

            Object val = user.getWosCitedSum();
            if (R2Constant.ARTICLE_GUBUN_SCOPUS.equals(gubun)) val = user.getScpCitedSum();
            else if (R2Constant.ARTICLE_GUBUN_KCI.equals(gubun)) val = user.getKciCitedSum();

            String tText = user.getKorNm().trim() + " sum : " + val;
            xml.append("<set value='" + val + "'  toolText='" + tText + "' />");
            i++;
        }
        xml.append("</dataset>");

        i = 0;
        xml.append("<dataset seriesName='논문당 평균 피인용 횟수' parentYAxis='S' renderAs='Column' color='" + fillColors[1] + "'>");
        for (AnalysisVo user : userList) {
            if (i > 5) break;

            Double val = user.getWosCitedAvrg();
            if (R2Constant.ARTICLE_GUBUN_SCOPUS.equals(gubun)) val = user.getScpCitedAvrg();
            else if (R2Constant.ARTICLE_GUBUN_KCI.equals(gubun)) val = user.getKciCitedAvrg();

            double dValue = Math.round(val * 100d) / 100d;
            String tText = user.getKorNm().trim() + " avg : " + dValue;
            xml.append("<set value='" + val + "'  toolText='" + tText + "' />");
            i++;
        }
        xml.append("</dataset>");

        xml.append("<styles>");
        xml.append("    <definition>");
        xml.append("        <style name='myLabelsFont' type='font' font='Malgun Gothic' size='12' bold='1' />");
        xml.append("        <style name='CaptionFont' type='font' size='12'/>");
        xml.append("   </definition>");
        xml.append("    <application>");
        xml.append("       <apply toObject='CAPTION' styles='CaptionFont' />");
        xml.append("       <apply toObject='SUBCAPTION' styles='CaptionFont' />");
        xml.append("       <apply toObject='DataLabels' styles='myLabelsFont' />");
        xml.append("    </application>");
        xml.append(" </styles>");
        xml.append("</chart>");

        return xml.toString();

    }

    /**
     * <pre>
     *  1. 개   요 : Make chart xml for user h-index chart
     *  2. 처리내용 :
     * </pre>
     *
     * @param users
     * @param contextPath
     * @return
     * @Method Name : buildUsersHIndexChartXml
     */
    public static String buildUsersHIndexChartXml(List<AnalysisVo> userList, RimsSearchVo searchVo, String contextPath) {
        StringBuffer xml = new StringBuffer();
        int i = 0;
		/*
		xml.append(" <chart animation='0' caption='' xAxisName='' yAxisName='H-Index' showValues='1' decimals='0' formatNumberScale='0' ")
		.append(" divLineAlpha='30' numvdivlines='5' divLineIsDashed='1' bgColor='F7F7F7, E9E9E9' ")
	    .append(" exportEnabled='1' exportAtClient='0' exportAction='save' exportHandler='"+contextPath+"/servlet/FCExporter/export.do' exportCallBack='myFN' ")
		.append(" exportShowMenuItem='0' exportDialogMessage='Building chart output ' ")
		.append(" useRoundEdges='1' labelDisplay='ROTATE' slantLabels='1' legendPosition ='CENTER '>");
		*/
        xml.append("<chart ")
                .append(" subcaption='' ")
                .append(" baseFontColor='#666666' ")
                .append(" baseFontSize='11' ")
                .append(" subcaptionFontBold='0' ")
                .append(" canvasBgAlpha='0' ")
                .append(" showValues='0' ")
                .append(" paletteColors='" + paletteColors + "' ")
                .append(" bgAlpha='0' ")
                .append(" showBorder='0' ")
                .append(" showShadow='0' ")
                .append(" showAlternateHGridColor='0' ")
                .append(" showCanvasBorder='0' ")
                .append(" showXAxisLine='1' ")
                .append(" xAxisLineThickness='1' ")
                .append(" xAxisLineColor='#cdcdcd' ")
                .append(" xAxisNameFontColor='#8d8d8d' ")
                .append(" yAxisName='H-Index' ")
                .append(" yAxisNameFontColor='#8d8d8d' ")
                .append(" canvasBgColor='#ffffff' ")
                .append(" lineThickness='4' ")
                .append(" legendBgColor='#ffffff' ")
                .append(" legendBgAlpha='100' ")
                .append(" legendBorderAlpha='50' ")
                .append(" legendBorderColor='#888888' ")
                .append(" legendShadow='0' ")
                .append(" legendPosition='CENTER' ")
                .append(" divlineAlpha='0' ")
                .append(" numDivLines='10' ")
                .append(" divlineColor='#999999' ")
                .append(" divlineThickness='1' ")
                .append(" divLineIsDashed='1'")
                .append(" divLineDashLen='1'")
                .append(" divLineGapLen='1' ")
                .append(" toolTipColor='#ffffff' ")
                .append(" toolTipBorderColor='#ffffff' ")
                .append(" toolTipBorderThickness='1' ")
                .append(" toolTipBgColor='#000000' ")
                .append(" toolTipBgAlpha='80' ")
                .append(" toolTipBorderRadius='4' ")
                .append(" toolTipPadding='10' ")
                .append(" toolTipFontSize ='20' ")
                .append(" anchorBgColor='#ffffff' ")
                .append(" anchorRadius='5' ")
                .append(" anchorBorderThickness='3' ")
                .append(" anchorTrackingRadius='15' ")
                .append(" showHoverEffect='1' ")
                .append(" formatNumberScale='0'")
                .append(" labelDisplay='rotate' ")
                .append(" slantLabels='1' ")
                .append(" plotBorderColor='#ffffff' ") //bar 테두리없애기
                .append(" usePlotGradientColor='0' ") //bar의 그라데이션 없애기
                .append(" exportEnabled='1' ")
                .append(" exportAtClient='0' ")
                .append(" exportAction='save' ")
                .append(" exportShowMenuItem='0' ")
                .append(" exportDialogMessage='Building chart output' ")
                .append(" exportHandler='" + contextPath + "/servlet/FCExporter/export.do' exportCallBack='myFN' ")
                .append(" >");

        for (AnalysisVo user : userList) {
            if (i > 5) break;
            Integer val = user.getHindex();
            String tText = user.getKorNm().trim() + " : " + val;
            xml.append("<set label='" + user.getKorNm() + "' value='" + val + "'  toolText='" + tText + "' />");
            i++;
        }

        xml.append("<styles>");
        xml.append("    <definition>");
        xml.append("        <style name='myLabelsFont' type='font' font='Malgun Gothic' size='12' bold='1' />");
        xml.append("        <style name='CaptionFont' type='font' size='12'/>");
        xml.append("   </definition>");
        xml.append("    <application>");
        xml.append("       <apply toObject='CAPTION' styles='CaptionFont' />");
        xml.append("       <apply toObject='SUBCAPTION' styles='CaptionFont' />");
        xml.append("       <apply toObject='DataLabels' styles='myLabelsFont' />");
        xml.append("    </application>");
        xml.append(" </styles>");

        xml.append("</chart>");

        return xml.toString();
    }

    /**
     * <pre>
     *  1. 개   요 : Make chart xml for subject of article chart
     *  2. 처리내용 :
     * </pre>
     *
     * @param subjects
     * @param noArts
     * @param fromYear
     * @param toYear
     * @param contextPath
     * @return
     * @Method Name : buildSubjectArtChartXmlWithYear
     */
    public static String buildSubjectChartXmlWithYear(List<AnalysisVo> subjectList, List<AnalysisVo> subjectYearList, RimsSearchVo searchVo, String contextPath) {

        StringBuffer xml = new StringBuffer();
        String fromYear = searchVo.getFromYear();
        String toYear = searchVo.getToYear();
        int i = 0;
		/*
		xml.append(" <chart animation='0' caption='' subcaption='' lineThickness='2' showValues='0' formatNumberScale='0' anchorRadius='4' showLegend='0' ")
		.append(" divLineAlpha='30' numvdivlines='5' divLineIsDashed='1' bgColor='F7F7F7, E9E9E9' ")
		.append(" exportEnabled='1' exportAtClient='0' exportAction='save' exportHandler='"+contextPath+"/servlet/FCExporter/export.do' exportCallBack='myFN' ")
		.append(" exportShowMenuItem='0' exportDialogMessage='Building chart output' ")
		.append(" legendPosition ='CENTER' slantLabels='1'  labelDisplay='ROTATE'>");
		*/
        xml.append("<chart ")
                .append(" subcaption='' ")
                .append(" baseFontColor='#666666' ")
                .append(" baseFontSize='11' ")
                .append(" subcaptionFontBold='0' ")
                .append(" canvasBgAlpha='0' ")
                .append(" showValues='0' ")
                .append(" paletteColors='" + paletteColors + "' ")
                .append(" bgAlpha='0' ")
                .append(" showBorder='0' ")
                .append(" showShadow='0' ")
                .append(" showAlternateHGridColor='0' ")
                .append(" showCanvasBorder='0' ")
                .append(" showXAxisLine='1' ")
                .append(" xAxisName='' ")
                .append(" xAxisLineThickness='1' ")
                .append(" xAxisLineColor='#cdcdcd' ")
                .append(" xAxisNameFontColor='#8d8d8d' ")
                .append(" yAxisName='' ")
                .append(" yAxisNameFontColor='#8d8d8d' ")
                .append(" canvasBgColor='#ffffff' ")
                .append(" lineThickness='4' ")
                .append(" legendBgColor='#ffffff' ")
                .append(" legendBgAlpha='100' ")
                .append(" legendBorderAlpha='50' ")
                .append(" legendBorderColor='#888888' ")
                .append(" legendShadow='0' ")
                .append(" legendPosition='CENTER' ")
                .append(" divlineAlpha='0' ")
                .append(" numDivLines='10' ")
                .append(" divlineColor='#999999' ")
                .append(" divlineThickness='1' ")
                .append(" divLineIsDashed='1'")
                .append(" divLineDashLen='1'")
                .append(" divLineGapLen='1' ")
                .append(" toolTipColor='#ffffff' ")
                .append(" toolTipBorderColor='#ffffff' ")
                .append(" toolTipBorderThickness='1' ")
                .append(" toolTipBgColor='#000000' ")
                .append(" toolTipBgAlpha='80' ")
                .append(" toolTipBorderRadius='4' ")
                .append(" toolTipPadding='10' ")
                .append(" toolTipFontSize ='20' ")
                .append(" anchorBgColor='#ffffff' ")
                .append(" anchorRadius='5' ")
                .append(" anchorBorderThickness='3' ")
                .append(" anchorTrackingRadius='15' ")
                .append(" showHoverEffect='1' ")
                .append(" formatNumberScale='0'")
                .append(" labelDisplay='rotate' ")
                .append(" slantLabels='1' ")
                .append(" exportEnabled='1' ")
                .append(" exportAtClient='0' ")
                .append(" exportAction='save' ")
                .append(" exportShowMenuItem='0' ")
                .append(" exportDialogMessage='Building chart output' ")
                .append(" exportHandler='" + contextPath + "/servlet/FCExporter/export.do' exportCallBack='myFN' ")
                .append(" >");


        int fy = Integer.parseInt(fromYear);
        int ty = Integer.parseInt(toYear);
        xml.append("<categories >");
        for (int ii = fy; ii <= ty; ii++) {
            xml.append("<category label='" + ii + "' />");
        }
        xml.append("</categories>");

        for (AnalysisVo subject : subjectList) {
            if (i >= 5) break;
            Map yearNoMap = convertObjectListToMapWithCompareValue(subjectYearList, "ctgryCode", subject.getCtgryCode(), "prodYear", "artsCo");
            String sn = (String) subject.getCtgryName();
            xml.append("<dataset seriesName='" + sn + "' id='" + subject.getCtgryCode() + "' >");
            for (int ii = fy; ii <= ty; ii++) {
                Object val = yearNoMap.get(Integer.toString(ii));
                if (val == null)
                    xml.append("<set value='0' toolText='" + sn + " " + ii + " : 0' />");
                else
                    xml.append("<set value='" + val + "'  toolText='" + sn + " " + ii + " : " + val + "' />");
            }
            xml.append("</dataset>");
            i++;
        }
        xml.append("<styles>");
        xml.append("    <definition>");
        xml.append("        <style name='CaptionFont' type='font' size='12'/>");
        xml.append("   </definition>");
        xml.append("    <application>");
        xml.append("       <apply toObject='CAPTION' styles='CaptionFont' />");
        xml.append("       <apply toObject='SUBCAPTION' styles='CaptionFont' />");
        xml.append("    </application>");
        xml.append(" </styles>");
        xml.append("</chart>");

        return xml.toString();

    }

    public static String buildSubjectPieChartXml(List<AnalysisVo> subjectList, RimsSearchVo searchVo, String contextPath) {
        //String caption = "Publications by year from "+fromYear+ " to " + toYear;
        StringBuffer xml = new StringBuffer();
		/*
		xml.append("<chart animation='1' caption='' subcaption='' lineThickness='2' showValues='1' formatNumberScale='0' anchorRadius='4' showLegend='1' ")
		.append(" divLineAlpha='30' numvdivlines='5' divLineIsDashed='1' bgColor='F7F7F7, E9E9E9' ")
		.append(" legendPosition ='CENTER' useRoundEdges='1' slantLabels='1'  labelDisplay='ROTATE' >");
		*/
        xml.append("<chart ")
                .append(" subcaption='' ")
                .append(" baseFontColor='#666666' ")
                .append(" baseFontSize='11' ")
                .append(" subcaptionFontBold='0' ")
                .append(" canvasBgAlpha='0' ")
                .append(" showValues='0' ")
                .append(" paletteColors='" + paletteColors + "' ")
                .append(" bgAlpha='0' ")
                .append(" showBorder='0' ")
                .append(" showShadow='0' ")
                .append(" showAlternateHGridColor='0' ")
                .append(" showCanvasBorder='0' ")
                .append(" showXAxisLine='1' ")
                .append(" xAxisName='' ")
                .append(" xAxisLineThickness='1' ")
                .append(" xAxisLineColor='#cdcdcd' ")
                .append(" xAxisNameFontColor='#8d8d8d' ")
                .append(" yAxisName='' ")
                .append(" yAxisNameFontColor='#8d8d8d' ")
                .append(" canvasBgColor='#ffffff' ")
                .append(" lineThickness='4' ")
                .append(" legendBgColor='#ffffff' ")
                .append(" legendBgAlpha='100' ")
                .append(" legendBorderAlpha='50' ")
                .append(" legendBorderColor='#888888' ")
                .append(" legendShadow='0' ")
                .append(" legendPosition='CENTER' ")
                .append(" divlineAlpha='100' ")
                .append(" numDivLines='10' ")
                .append(" divlineColor='#999999' ")
                .append(" divlineThickness='1' ")
                .append(" divLineIsDashed='1'")
                .append(" divLineDashLen='1'")
                .append(" divLineGapLen='1' ")
                .append(" toolTipColor='#ffffff' ")
                .append(" toolTipBorderColor='#ffffff' ")
                .append(" toolTipBorderThickness='1' ")
                .append(" toolTipBgColor='#000000' ")
                .append(" toolTipBgAlpha='80' ")
                .append(" toolTipBorderRadius='4' ")
                .append(" toolTipPadding='10' ")
                .append(" toolTipFontSize ='20' ")
                .append(" anchorBgColor='#ffffff' ")
                .append(" anchorRadius='5' ")
                .append(" anchorBorderThickness='3' ")
                .append(" anchorTrackingRadius='15' ")
                .append(" showHoverEffect='1' ")
                .append(" formatNumberScale='0'")
                .append(" labelDisplay='rotate' ")
                .append(" slantLabels='1' ")
                .append(" exportEnabled='1' ")
                .append(" exportAtClient='0' ")
                .append(" exportAction='save' ")
                .append(" exportShowMenuItem='0' ")
                .append(" exportDialogMessage='Building chart output' ")
                .append(" exportHandler='" + contextPath + "/servlet/FCExporter/export.do' exportCallBack='myFN' ")
                .append(" >");


        for (AnalysisVo subject : subjectList) {
            xml.append("<set label='" + subject.getCtgryName() + "' value='" + subject.getArtsCo() + "' toolText='" + subject.getArtsCo() + "'/>");
        }

        xml.append("<styles>");
        xml.append("    <definition>");
        xml.append("        <style name='CaptionFont' type='font' size='12'/>");
        xml.append("   </definition>");
        xml.append("    <application>");
        xml.append("       <apply toObject='CAPTION' styles='CaptionFont' />");
        xml.append("       <apply toObject='SUBCAPTION' styles='CaptionFont' />");
        xml.append("    </application>");
        xml.append(" </styles>");
        xml.append("</chart>");

        return xml.toString();
    }

    public static String buildOverviewSubjectPieChartXml(List<AnalysisVo> subjectList, RimsSearchVo searchVo) {
        //String caption = "Publications by year from "+fromYear+ " to " + toYear;
        StringBuffer xml = new StringBuffer();
		/*
		xml.append("<chart animation='1' caption='' subcaption='' lineThickness='2' formatNumberScale='0' anchorRadius='4' exportAtClient='0' ")
		.append(" divLineAlpha='30' numvdivlines='5' divLineIsDashed='1' bgColor='FFFFFF, FFFFFF' ")
		.append(" showValues='1' showLabels='0' showLegend='1' showPercentageInLabel='0' showBorder='0'  canvasBorderAlpha='0' canvasBorderThickness='0'")
		.append(" legendPosition ='CENTER' useRoundEdges='1' slantLabels='1'  labelDisplay='ROTATE' >");
		*/
        xml.append("<chart ")
                .append(" subcaption='' ")
                .append(" baseFontColor='#666666' ")
                .append(" baseFontSize='11' ")
                .append(" subcaptionFontBold='0' ")
                .append(" canvasBgAlpha='0' ")
                .append(" showValues='0' ")
                .append(" paletteColors='" + paletteColors + "' ")
                .append(" bgAlpha='0' ")
                .append(" showBorder='0' ")
                .append(" showShadow='0' ")
                .append(" showAlternateHGridColor='0' ")
                .append(" showCanvasBorder='0' ")
                .append(" showXAxisLine='1' ")
                .append(" xAxisName='' ")
                .append(" xAxisLineThickness='1' ")
                .append(" xAxisLineColor='#cdcdcd' ")
                .append(" xAxisNameFontColor='#8d8d8d' ")
                .append(" yAxisName='' ")
                .append(" yAxisNameFontColor='#8d8d8d' ")
                .append(" canvasBgColor='#ffffff' ")
                .append(" lineThickness='4' ")
                .append(" legendBgColor='#ffffff' ")
                .append(" legendBgAlpha='100' ")
                .append(" legendBorderAlpha='50' ")
                .append(" legendBorderColor='#888888' ")
                .append(" legendShadow='0' ")
                .append(" legendPosition='CENTER' ")
                .append(" divlineAlpha='100' ")
                .append(" numDivLines='10' ")
                .append(" divlineColor='#999999' ")
                .append(" divlineThickness='1' ")
                .append(" divLineIsDashed='1'")
                .append(" divLineDashLen='1'")
                .append(" divLineGapLen='1' ")
                .append(" toolTipColor='#ffffff' ")
                .append(" toolTipBorderColor='#ffffff' ")
                .append(" toolTipBorderThickness='1' ")
                .append(" toolTipBgColor='#000000' ")
                .append(" toolTipBgAlpha='80' ")
                .append(" toolTipBorderRadius='4' ")
                .append(" toolTipPadding='10' ")
                .append(" toolTipFontSize ='20' ")
                .append(" anchorBgColor='#ffffff' ")
                .append(" anchorRadius='5' ")
                .append(" anchorBorderThickness='3' ")
                .append(" anchorTrackingRadius='15' ")
                .append(" showHoverEffect='1' ")
                .append(" formatNumberScale='0'")
                .append(" labelDisplay='rotate' ")
                .append(" slantLabels='1' ")
                .append(" exportEnabled='0' ")
                .append(" exportAtClient='0' ")
                .append(" exportShowMenuItem='0' ")
                .append(" >");


        for (AnalysisVo subject : subjectList) {
            xml.append("<set label='" + subject.getCtgryName() + "' value='" + subject.getArtsCo() + "' toolText='" + subject.getArtsCo() + "'/>");
        }

        xml.append("<styles>");
        xml.append("    <definition>");
        xml.append("        <style name='CaptionFont' type='font' size='12'/>");
        xml.append("   </definition>");
        xml.append("    <application>");
        xml.append("       <apply toObject='CAPTION' styles='CaptionFont' />");
        xml.append("       <apply toObject='SUBCAPTION' styles='CaptionFont' />");
        xml.append("    </application>");
        xml.append(" </styles>");
        xml.append("</chart>");

        return xml.toString();
    }

    public static String buildJournalPieChartXml(List<AnalysisVo> journalList, RimsSearchVo searchVo, String contextPath) {
        //String caption = "Publications by year from "+fromYear+ " to " + toYear;
        StringBuffer xml = new StringBuffer();
		/*
		xml.append(" <chart animation='0' caption='' subcaption='' lineThickness='2' showValues='1' formatNumberScale='0' anchorRadius='4' showLegend='1' ")
		.append(" divLineAlpha='30' numvdivlines='5' divLineIsDashed='1' bgColor='F7F7F7, E9E9E9' ")
		.append(" exportEnabled='1' exportAtClient='0' exportAction='save' exportHandler='"+contextPath+"/servlet/FCExporter/export.do' exportCallBack='myFN' ")
		.append(" exportShowMenuItem='0' exportDialogMessage='Building chart output' ")
		.append(" legendPosition ='CENTER' useRoundEdges='1' slantLabels='1'  labelDisplay='ROTATE' >");
		*/
        xml.append("<chart ")
                .append(" subcaption='' ")
                .append(" baseFontColor='#666666' ")
                .append(" baseFontSize='11' ")
                .append(" subcaptionFontBold='0' ")
                .append(" canvasBgAlpha='0' ")
                .append(" showValues='0' ")
                .append(" paletteColors='" + paletteColors + "' ")
                .append(" bgAlpha='0' ")
                .append(" showBorder='0' ")
                .append(" showShadow='0' ")
                .append(" showAlternateHGridColor='0' ")
                .append(" showCanvasBorder='0' ")
                .append(" showXAxisLine='1' ")
                .append(" xAxisName='' ")
                .append(" xAxisLineThickness='1' ")
                .append(" xAxisLineColor='#cdcdcd' ")
                .append(" xAxisNameFontColor='#8d8d8d' ")
                .append(" yAxisName='' ")
                .append(" yAxisNameFontColor='#8d8d8d' ")
                .append(" canvasBgColor='#ffffff' ")
                .append(" lineThickness='4' ")
                .append(" legendBgColor='#ffffff' ")
                .append(" legendBgAlpha='100' ")
                .append(" legendBorderAlpha='50' ")
                .append(" legendBorderColor='#888888' ")
                .append(" legendShadow='0' ")
                .append(" legendPosition='CENTER' ")
                .append(" divlineAlpha='100' ")
                .append(" numDivLines='10' ")
                .append(" divlineColor='#999999' ")
                .append(" divlineThickness='1' ")
                .append(" divLineIsDashed='1'")
                .append(" divLineDashLen='1'")
                .append(" divLineGapLen='1' ")
                .append(" toolTipColor='#ffffff' ")
                .append(" toolTipBorderColor='#ffffff' ")
                .append(" toolTipBorderThickness='1' ")
                .append(" toolTipBgColor='#000000' ")
                .append(" toolTipBgAlpha='80' ")
                .append(" toolTipBorderRadius='4' ")
                .append(" toolTipPadding='10' ")
                .append(" toolTipFontSize ='20' ")
                .append(" anchorBgColor='#ffffff' ")
                .append(" anchorRadius='5' ")
                .append(" anchorBorderThickness='3' ")
                .append(" anchorTrackingRadius='15' ")
                .append(" showHoverEffect='1' ")
                .append(" formatNumberScale='0'")
                .append(" labelDisplay='rotate' ")
                .append(" slantLabels='1' ")
                .append(" exportEnabled='1' ")
                .append(" exportAtClient='0' ")
                .append(" exportAction='save' ")
                .append(" exportShowMenuItem='0' ")
                .append(" exportDialogMessage='Building chart output' ")
                .append(" exportHandler='" + contextPath + "/servlet/FCExporter/export.do' exportCallBack='myFN' ")
                .append(" >");


        for (AnalysisVo journal : journalList) {
            xml.append("<set label='" + journal.getTitle() + "' value='" + journal.getArtsCo() + "' toolText='" + journal.getArtsCo() + "'/>");
        }

        xml.append("<styles>");
        xml.append("    <definition>");
        xml.append("        <style name='CaptionFont' type='font' size='12'/>");
        xml.append("   </definition>");
        xml.append("    <application>");
        xml.append("       <apply toObject='CAPTION' styles='CaptionFont' />");
        xml.append("       <apply toObject='SUBCAPTION' styles='CaptionFont' />");
        xml.append("    </application>");
        xml.append(" </styles>");
        xml.append("</chart>");

        return xml.toString();
    }

    /**
     * <pre>
     *  1. 개   요 : Make chart xml for network chart among department
     *  2. 처리내용 :
     * </pre>
     *
     * @param source
     * @param sname
     * @param coworks
     * @param contextPath
     * @return
     * @Method Name : buildNetworkAmongDept
     */
    public static String buildDeptNetworkChartXml(List<AnalysisVo> coAuthorList, AnalysisVo mainDepartment, RimsSearchVo searchVo, String contextPath) {

        double maxTtl = 0;
        double maxCoworkCnt = 0;
        double maxRel = 0;
        int radius = 20;
        dcMap = new HashMap<String, String>();
        int dfFillIdx = 0;
        String fillColor = "";

        for (AnalysisVo coAuthor : coAuthorList) {
            if (maxCoworkCnt < coAuthor.getCoArtsCo()) maxCoworkCnt = coAuthor.getCoArtsCo();
        }

        StringBuffer sb = new StringBuffer();
    	/*
    	sb.append(" <chart ")
    	  .append(" viewMode='1' showFormBtn='0' showRestoreBtn='0' showplotborder='1' enableLink='1' showBorder='0' ")
    	  .append(" is3D='1' baseFontSize='12' baseFont='Malgun Gothic' ")
    	  .append(" palette='2' xAxisMinValue='0' ")
    	  .append(" canvasBorderAlpha='0' canvasBorderThickness='0' ")
    	  .append(" xAxisMaxValue='"+100+"' yAxisMinValue='0' yAxisMaxValue='"+100+"' ")
    	  .append(" chartTopMargin='3' chartLeftMargin='3' chartRightMargin='3' chartBottomMargin='3' ")
    	  .append(" showLegend='1' interactiveLegend='0' legendNumColumns='4' ")
    	  .append(" use3DLighting='0' useEllipsesWhenOverflow='0' labelDisplay='WRAP' unescapeLinks='0' ")
    	  .append(" exportShowMenuItem='0' exportDialogMessage='Building chart output ' ")
    	  .append(" exportEnabled='1' exportAtClient='0' exportAction='save' exportHandler='"+contextPath+"/servlet/FCExporter/export.do' exportCallBack='myFN' ")
    	  .append(" >");
    	*/
        sb.append("<chart ")
                .append(" subcaption='' ")
                .append(" baseFontColor='#666666' ")
                .append(" baseFontSize='9' ")
                .append(" subcaptionFontBold='0' ")
                .append(" canvasBgAlpha='0' ")
                .append(" showValues='0' ")
                .append(" paletteColors='" + paletteColors + "' ")
                .append(" bgAlpha='0' ")
                .append(" showBorder='0' ")
                .append(" showShadow='0' ")
                .append(" showAlternateHGridColor='0' ")
                .append(" showCanvasBorder='0' ")
                .append(" showformbtn='0' ")
                .append(" showRestoreBtn='0' ")
                .append(" viewmode='1' ")
                .append(" xAxisMaxValue='100' ")
                .append(" yAxisMinValue='0' ")
                .append(" yAxisMaxValue='100' ")
                .append(" chartTopMargin='3' ")
                .append(" chartLeftMargin='3' ")
                .append(" chartRightMargin='3' ")
                .append(" chartBottomMargin='3' ")
                .append(" xAxisName='' ")
                .append(" showXAxisLine='0' ")
                .append(" xAxisLineThickness='0' ")
                .append(" xAxisLineColor='#cdcdcd' ")
                .append(" xAxisNameFontColor='#8d8d8d' ")
                .append(" yAxisName='' ")
                .append(" yAxisNameFontColor='#8d8d8d' ")
                .append(" canvasBgColor='#ffffff' ")
                .append(" lineThickness='4' ")
                .append(" legendBgColor='#ffffff' ")
                .append(" legendBgAlpha='100' ")
                .append(" legendBorderAlpha='50' ")
                .append(" legendBorderColor='#888888' ")
                .append(" legendShadow='0' ")
                .append(" legendPosition='CENTER' ")
                .append(" divlineAlpha='100' ")
                .append(" numDivLines='10' ")
                .append(" divlineThickness='0' ")
                .append(" toolTipColor='#ffffff' ")
                .append(" toolTipBorderColor='#ffffff' ")
                .append(" toolTipBorderThickness='1' ")
                .append(" toolTipBgColor='#000000' ")
                .append(" toolTipBgAlpha='80' ")
                .append(" toolTipBorderRadius='4' ")
                .append(" toolTipPadding='10' ")
                .append(" toolTipFontSize ='20' ")
                .append(" anchorBgColor='#ffffff' ")
                .append(" anchorRadius='5' ")
                .append(" anchorBorderThickness='3' ")
                .append(" anchorTrackingRadius='15' ")
                .append(" showHoverEffect='1' ")
                .append(" formatNumberScale='0'")
                .append(" labelDisplay='rotate' ")
                .append(" slantLabels='1' ")
                .append(" exportEnabled='1' ")
                .append(" exportAtClient='0' ")
                .append(" exportAction='save' ")
                .append(" exportShowMenuItem='0' ")
                .append(" exportDialogMessage='Building chart output' ")
                .append(" exportHandler='" + contextPath + "/servlet/FCExporter/export.do' exportCallBack='myFN' ")
                .append(" >");


        double step = coAuthorList.size() == 0 ? 0 : 360d / coAuthorList.size();
        if (coAuthorList.size() > 0) maxRel = coAuthorList.get(0).getCoArtsCo();

        double total = Double.parseDouble(mainDepartment.getArtsCo().toString());
        if (maxTtl < total) maxTtl = total;
        radius = (int) ((total / maxTtl) * 30) + 28;
        if (dcMap.get(mainDepartment.getDeptKor()) == null) {
            fillColor = fillColors[dfFillIdx];
            dfFillIdx++;
            dcMap.put(mainDepartment.getDeptKor(), fillColor);
        }


        sb.append("<dataset seriesName='" + mainDepartment.getDeptKor() + "' plotBorderColor='#" + fillColor + "' plotborderthickness='8' >");
        sb.append("<set x='50' y='50'  name='" + mainDepartment.getDeptKor() + "' radius='" + radius + "' id='id_0' shape='CIRCLE' color='#d4f9ff'/> ");
        sb.append("</dataset>");

        boolean dist = false;
        for (int jj = 0; jj < coAuthorList.size(); jj++) {

            double degree = (450d - step * (jj%2==0?jj:coAuthorList.size()-jj-(coAuthorList.size()%2==0?0:1))) % 360d;

            total = Double.parseDouble(coAuthorList.get(jj).getArtsTotal().toString());

            double radians = (Math.PI / 180) * degree;

            double cnt = Double.parseDouble(coAuthorList.get(jj).getCoArtsCo().toString());
            double ratio = cnt / maxRel;

            double distRatio = dist == true ? CacheUtils.getHighDistanceRatio() / 10.0 : CacheUtils.getLowDistanceRatio() / 10.0;

            int distance = coAuthorList.size() > 15 ? (int) (coAuthorList.size()/2.5) : (int) (coAuthorList.size()/3.5);
            double x = Math.sin(radians) * (30.0 + (jj % 2 == 0 ? distance : 0)) * distRatio + 50.0;
            double y = Math.cos(radians) * (30.0 + (jj % 2 == 0 ? distance : 0)) * distRatio + 50.0;

            radius = (int) ((cnt / maxCoworkCnt) * 25) + (55 -  distance);

            String dispValue = StringUtils.replace((String) coAuthorList.get(jj).getDeptKor(), "'", "&#39;");

            if (dcMap.get(coAuthorList.get(jj).getDeptKor()) == null) {
                fillColor = fillColors[dfFillIdx];
                dfFillIdx++;
                dcMap.put((String) coAuthorList.get(jj).getDeptKor(), fillColor);
            }
            String deptNm = (String) coAuthorList.get(jj).getDeptKor();
            sb.append("<dataset plotborderthickness='5' seriesName='" + dispValue + "' plotBorderColor='#" + fillColor + "' >");
            sb.append("<set x='" + x + "' y='" + y + "' radius='" + radius + "' ");
            sb.append(" name='" + dispValue + "' id='id_" + (jj + 1) + "'  toolText='" + deptNm + " ' ");
            sb.append(" shape='CIRCLE' color='#ffffff' labelAlign='middle' link='j-chartClick-" + R2Constant.COAUTHOR_TARGET_INST + ";" + deptNm + "' />");
            sb.append("</dataset>");

            dist = dist == true ? false : true;
        }

        sb.append("<connectors color='#AAAAAA' stdThickness='5'>");

        for (int ki = 0; ki < coAuthorList.size(); ki++) {
            int cnt = Integer.parseInt(coAuthorList.get(ki).getCoArtsCo().toString());
            String deptNm = (String) coAuthorList.get(ki).getDeptKor();
            double alpha = (cnt / maxRel) * 1.1 + 0.7;

            sb.append("<connector strength='" + (alpha) + "' ");
            sb.append(" label ='" + cnt + "'  ");
            sb.append(" from='id_0' to='id_" + (ki + 1) + "' ");
            sb.append(" link='j-chartClick-" + R2Constant.COAUTHOR_TARGET_INST + ";" + deptNm + "' ");
            sb.append(" arrowAtStart='0' arrowAtEnd='0' />");
        }

        sb.append("</connectors>");

        sb.append("<styles>");
        sb.append("<definition>");
        sb.append("   <style name='myLabelsFont' type='font' font='Malgun Gothic' bold='0' size='11' color='000000'/>");
        sb.append("</definition>");
        sb.append("<application>");
        sb.append("   <apply toObject='DataLabels' styles='myLabelsFont' />");
        sb.append("</application>");
        sb.append("</styles>");

        sb.append("</chart>");

        return sb.toString();


    }

    /**
     * <pre>
     *  1. 개   요 : Make chart xml for department article chart by year
     *  2. 처리내용 :
     * </pre>
     *
     * @param noArts
     * @param departs
     * @param fromYear
     * @param toYear
     * @param contextPath
     * @return
     * @Method Name : buildDepartArtChartXmlWithYear
     */
    public static String buildDepartArtChartXmlWithYear(List<AnalysisVo> departWithYearList, List<AnalysisVo> departList, RimsSearchVo searchVo, String contextPath) {

        String fromYear = searchVo.getFromYear();
        String toYear = searchVo.getToYear();

        //String caption = "Publications by year from "+fromYear+ " to " + toYear;
        StringBuffer xml = new StringBuffer();

		/*
		xml.append(" <chart animation='0' caption='' subcaption='' lineThickness='2' showValues='0' formatNumberScale='0' ")
		.append(" divLineAlpha='30' numvdivlines='5' divLineIsDashed='1' bgColor='F7F7F7, E9E9E9' ")
		.append(" exportEnabled='1' exportAtClient='0' exportAction='save' exportHandler='"+contextPath+"/servlet/FCExporter/export.do' exportCallBack='myFN' ")
		.append(" exportShowMenuItem='0' exportDialogMessage='Building chart output' ")
		.append(" anchorRadius='4' showLegend='1' legendPosition ='CENTER' >");
		*/
        xml.append("<chart ")
                .append(" subcaption='' ")
                .append(" baseFontColor='#666666' ")
                .append(" baseFontSize='11' ")
                .append(" subcaptionFontBold='0' ")
                .append(" canvasBgAlpha='0' ")
                .append(" showValues='0' ")
                .append(" paletteColors='" + paletteColors + "' ")
                .append(" bgAlpha='0' ")
                .append(" showBorder='0' ")
                .append(" showShadow='0' ")
                .append(" showAlternateHGridColor='0' ")
                .append(" showCanvasBorder='0' ")
                .append(" showXAxisLine='1' ")
                .append(" xAxisName='' ")
                .append(" xAxisLineThickness='1' ")
                .append(" xAxisLineColor='#cdcdcd' ")
                .append(" xAxisNameFontColor='#8d8d8d' ")
                .append(" yAxisName='' ")
                .append(" yAxisNameFontColor='#8d8d8d' ")
                .append(" canvasBgColor='#ffffff' ")
                .append(" lineThickness='4' ")
                .append(" legendBgColor='#ffffff' ")
                .append(" legendBgAlpha='100' ")
                .append(" legendBorderAlpha='50' ")
                .append(" legendBorderColor='#888888' ")
                .append(" legendShadow='0' ")
                .append(" legendPosition='CENTER' ")
                .append(" divlineAlpha='0' ")
                .append(" numDivLines='10' ")
                .append(" divlineColor='#999999' ")
                .append(" divlineThickness='1' ")
                .append(" divLineIsDashed='1'")
                .append(" divLineDashLen='1'")
                .append(" divLineGapLen='1' ")
                .append(" toolTipColor='#ffffff' ")
                .append(" toolTipBorderColor='#ffffff' ")
                .append(" toolTipBorderThickness='1' ")
                .append(" toolTipBgColor='#000000' ")
                .append(" toolTipBgAlpha='80' ")
                .append(" toolTipBorderRadius='4' ")
                .append(" toolTipPadding='10' ")
                .append(" toolTipFontSize ='20' ")
                .append(" anchorBgColor='#ffffff' ")
                .append(" anchorRadius='5' ")
                .append(" anchorBorderThickness='3' ")
                .append(" anchorTrackingRadius='15' ")
                .append(" showHoverEffect='1' ")
                .append(" formatNumberScale='0'")
                .append(" labelDisplay='rotate' ")
                .append(" slantLabels='1' ")
                .append(" exportEnabled='1' ")
                .append(" exportAtClient='0' ")
                .append(" exportAction='save' ")
                .append(" exportShowMenuItem='0' ")
                .append(" exportDialogMessage='Building chart output' ")
                .append(" exportHandler='" + contextPath + "/servlet/FCExporter/export.do' exportCallBack='myFN' ")
                .append(" >");

        int fy = Integer.parseInt(fromYear);
        int ty = Integer.parseInt(toYear);

        xml.append("<categories >");
        for (int ii = fy; ii <= ty; ii++) xml.append("<category label='" + ii + "' />");
        xml.append("</categories>");

        int j = 0;

        for (AnalysisVo depart : departList) {
            if (j >= 5) break;
            Map yearNoMap = convertObjectListToMapWithCompareValue(departWithYearList, "deptKor", depart.getDeptKor(), "pubYear", "artsTotal");

            String sn = depart.getDeptKor() + "";
            int fcIdx = j % 23;
            xml.append("<dataset seriesName='" + sn + "' color='" + fillColors[fcIdx] + "' id='" + depart.getDeptKor() + "' >");
            for (int ii = fy; ii <= ty; ii++) {
                Object val = yearNoMap.get(Integer.toString(ii));
                if (val == null)
                    xml.append("<set value='0' toolText='" + sn + " " + ii + " : 0' />");
                else
                    xml.append("<set value='" + val + "'  toolText='" + sn + " " + ii + " : " + val + "' />");
            }
            xml.append("</dataset>");
            j++;
        }

        xml.append("<styles>");
        xml.append("    <definition>");

        xml.append("        <style name='CaptionFont' type='font' size='12'/>");
        xml.append("   </definition>");
        xml.append("    <application>");
        xml.append("       <apply toObject='CAPTION' styles='CaptionFont' />");
        xml.append("       <apply toObject='SUBCAPTION' styles='CaptionFont' />");
        xml.append("    </application>");
        xml.append(" </styles>");

        xml.append("</chart>");

        return xml.toString();

    }


    public static String buildDepartPatChartXmlWithYear(List<AnalysisVo> departWithYearList, List<AnalysisVo> departList, RimsSearchVo searchVo, String contextPath) {

        String fromYear = searchVo.getFromYear();
        String toYear = searchVo.getToYear();
        String applStatus = searchVo.getApplStatus();
        String acqsNtnDvsCd = searchVo.getAcqsNtnDvsCd();

        String setName = "";
        if (R2Constant.PATENT_STATUS_APPL_CD.equals(applStatus)) setName = R2Constant.PATENT_STATUS_APPL;
        else if (R2Constant.PATENT_STATUS_STTEMNT_CD.equals(applStatus)) setName = R2Constant.PATENT_STATUS_STTEMNT;
        else if (R2Constant.PATENT_STATUS_CONFM_CD.equals(applStatus)) setName = R2Constant.PATENT_STATUS_CONFM;
        else if (R2Constant.PATENT_STATUS_REGIST_CD.equals(applStatus)) setName = R2Constant.PATENT_STATUS_REGIST;
        else if (R2Constant.PATENT_STATUS_EXTSH_CD.equals(applStatus)) setName = R2Constant.PATENT_STATUS_EXTSH;

        String xAxisName = "";
        if (R2Constant.PATENT_STATUS_APPL_CD.equals(applStatus)
                || R2Constant.PATENT_STATUS_REGIST_CD.equals(applStatus)) {
            if ("1".equals(acqsNtnDvsCd)) {
                xAxisName = "국내" + setName;
            } else if ("2".equals(acqsNtnDvsCd)) {
                xAxisName = "해외" + setName;
            }
        } else {
            xAxisName = setName;
        }

        //String caption = "Publications by year from "+fromYear+ " to " + toYear;
        StringBuffer xml = new StringBuffer();
		/*
		xml.append(" <chart animation='0' caption='' subcaption='' lineThickness='2' showValues='0' formatNumberScale='0' ")
		.append(" xAxisName='"+xAxisName+"' yAxisName='특허건수' ")
		.append(" divLineAlpha='30' numvdivlines='5' divLineIsDashed='1' bgColor='F7F7F7, E9E9E9' ")
		.append(" exportEnabled='1' exportAtClient='0' exportAction='save' exportHandler='"+contextPath+"/servlet/FCExporter/export.do' exportCallBack='myFN' ")
		.append(" exportShowMenuItem='0' exportDialogMessage='Building chart output' ")
		.append(" anchorRadius='4' showLegend='1' legendPosition ='CENTER' >");
		*/
        xml.append("<chart ")
                .append(" subcaption='' ")
                .append(" baseFontColor='#666666' ")
                .append(" baseFontSize='11' ")
                .append(" subcaptionFontBold='0' ")
                .append(" canvasBgAlpha='0' ")
                .append(" showValues='0' ")
                .append(" paletteColors='" + paletteColors + "' ")
                .append(" bgAlpha='0' ")
                .append(" showBorder='0' ")
                .append(" showShadow='0' ")
                .append(" showAlternateHGridColor='0' ")
                .append(" showCanvasBorder='0' ")
                .append(" showXAxisLine='1' ")
                .append(" xAxisName='" + xAxisName + "' ")
                .append(" xAxisLineThickness='1' ")
                .append(" xAxisLineColor='#cdcdcd' ")
                .append(" xAxisNameFontColor='#8d8d8d' ")
                .append(" yAxisName='특허건수' ")
                .append(" yAxisNameFontColor='#8d8d8d' ")
                .append(" canvasBgColor='#ffffff' ")
                .append(" lineThickness='4' ")
                .append(" legendBgColor='#ffffff' ")
                .append(" legendBgAlpha='100' ")
                .append(" legendBorderAlpha='50' ")
                .append(" legendBorderColor='#888888' ")
                .append(" legendShadow='0' ")
                .append(" legendPosition='CENTER' ")
                .append(" divlineAlpha='0' ")
                .append(" numDivLines='10' ")
                .append(" divlineColor='#999999' ")
                .append(" divlineThickness='1' ")
                .append(" divLineIsDashed='1'")
                .append(" divLineDashLen='1'")
                .append(" divLineGapLen='1' ")
                .append(" toolTipColor='#ffffff' ")
                .append(" toolTipBorderColor='#ffffff' ")
                .append(" toolTipBorderThickness='1' ")
                .append(" toolTipBgColor='#000000' ")
                .append(" toolTipBgAlpha='80' ")
                .append(" toolTipBorderRadius='4' ")
                .append(" toolTipPadding='10' ")
                .append(" toolTipFontSize ='20' ")
                .append(" anchorBgColor='#ffffff' ")
                .append(" anchorRadius='5' ")
                .append(" anchorBorderThickness='3' ")
                .append(" anchorTrackingRadius='15' ")
                .append(" showHoverEffect='1' ")
                .append(" formatNumberScale='0'")
                .append(" labelDisplay='rotate' ")
                .append(" slantLabels='1' ")
                .append(" exportEnabled='1' ")
                .append(" exportAtClient='0' ")
                .append(" exportAction='save' ")
                .append(" exportShowMenuItem='0' ")
                .append(" exportDialogMessage='Building chart output' ")
                .append(" exportHandler='" + contextPath + "/servlet/FCExporter/export.do' exportCallBack='myFN' ")
                .append(" >");

        int fy = Integer.parseInt(fromYear);
        int ty = Integer.parseInt(toYear);

        xml.append("<categories >");
        for (int ii = fy; ii <= ty; ii++) xml.append("<category label='" + ii + "' />");
        xml.append("</categories>");

        String keyField = "patYear";
        String noPatentValField = "patentCo";
        String noDmstcPatentValField = "dmstcPatentCo";
        String noOvseaPatentValField = "ovseaPatentCo";

        int j = 0;
        for (AnalysisVo depart : departList) {
            if (j >= 5) break;
            Map yearNoMap = null;
            if (R2Constant.PATENT_STATUS_APPL_CD.equals(applStatus)
                    || R2Constant.PATENT_STATUS_REGIST_CD.equals(applStatus)) {
                if ("1".equals(acqsNtnDvsCd)) {
                    yearNoMap = convertObjectListToMapWithCompareValue(departWithYearList, "deptKor", depart.getDeptKor(), keyField, noDmstcPatentValField);
                } else if ("2".equals(acqsNtnDvsCd)) {
                    yearNoMap = convertObjectListToMapWithCompareValue(departWithYearList, "deptKor", depart.getDeptKor(), keyField, noOvseaPatentValField);
                }
            } else {
                yearNoMap = convertObjectListToMapWithCompareValue(departWithYearList, "deptKor", depart.getDeptKor(), keyField, noPatentValField);
            }

            String sn = depart.getDeptKor();
            int fcIdx = j % 23;
            xml.append("<dataset seriesName='" + sn + "' color='" + fillColors[fcIdx] + "' anchorBorderColor='" + fillColors[fcIdx] + "' id='" + depart.getDeptKor() + "' >");
            for (int ii = fy; ii <= ty; ii++) {
                Object val = yearNoMap.get(Integer.toString(ii));
                if (val == null)
                    xml.append("<set value='0' toolText='" + sn + " " + ii + " : 0' />");
                else
                    xml.append("<set value='" + val + "'  toolText='" + sn + " " + ii + " : " + val + "' />");
            }
            xml.append("</dataset>");
            j++;
        }

        xml.append("<styles>");
        xml.append("    <definition>");

        xml.append("        <style name='CaptionFont' type='font' size='12'/>");
        xml.append("   </definition>");
        xml.append("    <application>");
        xml.append("       <apply toObject='CAPTION' styles='CaptionFont' />");
        xml.append("       <apply toObject='SUBCAPTION' styles='CaptionFont' />");
        xml.append("    </application>");
        xml.append(" </styles>");

        xml.append("</chart>");

        return xml.toString();

    }

    public static String buildOverviewDepartArtChartXmlWithYear(List<AnalysisVo> departWithYearList, List<AnalysisVo> departList, RimsSearchVo searchVo) {

        String fromYear = searchVo.getFromYear();
        String toYear = searchVo.getToYear();

        //String caption = "Publications by year from "+fromYear+ " to " + toYear;
        StringBuffer xml = new StringBuffer();
		/*
		xml.append(" <chart animation='0' caption='' subcaption='' lineThickness='2' formatNumberScale='0' anchorRadius='4' ")
		.append(" divLineAlpha='30' numvdivlines='5' divLineIsDashed='1' bgColor='FFFFFF, FFFFFF' ")
		.append(" showValues='0' showLabels='1' showPercentageInLabel='0' showBorder='0'  canvasBorderAlpha='0' canvasBorderThickness='0'")
		.append(" exportEnabled='0' exportAtClient='0' exportAction='save' exportShowMenuItem='0' ")
		.append(" showLegend='1' slantLabels='1' legendPosition ='CENTER' >");
		*/
        xml.append("<chart ")
                .append(" subcaption='' ")
                .append(" baseFontColor='#666666' ")
                .append(" baseFontSize='11' ")
                .append(" subcaptionFontBold='0' ")
                .append(" canvasBgAlpha='0' ")
                .append(" showValues='0' ")
                .append(" paletteColors='" + paletteColors + "' ")
                .append(" bgAlpha='0' ")
                .append(" showBorder='0' ")
                .append(" showShadow='0' ")
                .append(" showAlternateHGridColor='0' ")
                .append(" showCanvasBorder='0' ")
                .append(" showXAxisLine='1' ")
                .append(" xAxisName='' ")
                .append(" xAxisLineThickness='1' ")
                .append(" xAxisLineColor='#cdcdcd' ")
                .append(" xAxisNameFontColor='#8d8d8d' ")
                .append(" yAxisName='' ")
                .append(" yAxisNameFontColor='#8d8d8d' ")
                .append(" canvasBgColor='#ffffff' ")
                .append(" lineThickness='4' ")
                .append(" legendBgColor='#ffffff' ")
                .append(" legendBgAlpha='100' ")
                .append(" legendBorderAlpha='50' ")
                .append(" legendBorderColor='#888888' ")
                .append(" legendShadow='0' ")
                .append(" legendPosition='CENTER' ")
                .append(" divlineAlpha='0' ")
                .append(" numDivLines='10' ")
                .append(" divlineColor='#999999' ")
                .append(" divlineThickness='1' ")
                .append(" divLineIsDashed='1'")
                .append(" divLineDashLen='1'")
                .append(" divLineGapLen='1' ")
                .append(" toolTipColor='#ffffff' ")
                .append(" toolTipBorderColor='#ffffff' ")
                .append(" toolTipBorderThickness='1' ")
                .append(" toolTipBgColor='#000000' ")
                .append(" toolTipBgAlpha='80' ")
                .append(" toolTipBorderRadius='4' ")
                .append(" toolTipPadding='10' ")
                .append(" toolTipFontSize ='20' ")
                .append(" anchorBgColor='#ffffff' ")
                .append(" anchorRadius='5' ")
                .append(" anchorBorderThickness='3' ")
                .append(" anchorTrackingRadius='15' ")
                .append(" showHoverEffect='1' ")
                .append(" formatNumberScale='0'")
                .append(" labelDisplay='rotate' ")
                .append(" slantLabels='1' ")
                .append(" exportEnabled='0' ")
                .append(" exportAtClient='0' ")
                .append(" exportShowMenuItem='0' ")
                .append(" >");

        int fy = Integer.parseInt(fromYear);
        int ty = Integer.parseInt(toYear);

        xml.append("<categories >");
        for (int ii = fy; ii <= ty; ii++) xml.append("<category label='" + ii + "' />");
        xml.append("</categories>");

        int j = 0;
        for (AnalysisVo depart : departList) {
            if (j >= 5) break;
            Map yearNoMap = convertObjectListToMapWithCompareValue(departWithYearList, "deptKor", depart.getDeptKor(), "pubYear", "artsTotal");

            String sn = depart.getDeptKor() + "";
            int fcIdx = j % 23;
            xml.append("<dataset seriesName='" + sn + "' color='" + fillColors[fcIdx] + "' anchorBorderColor='" + fillColors[fcIdx] + "' id='" + depart.getDeptKor() + "' >");
            for (int ii = fy; ii <= ty; ii++) {
                Object val = yearNoMap.get(Integer.toString(ii));
                if (val == null)
                    xml.append("<set value='0' toolText='" + sn + " " + ii + " : 0' />");
                else
                    xml.append("<set value='" + val + "'  toolText='" + sn + " " + ii + " : " + val + "' />");
            }
            xml.append("</dataset>");
            j++;
        }

        xml.append("<styles>");
        xml.append("    <definition>");

        xml.append("        <style name='CaptionFont' type='font' size='12'/>");
        xml.append("   </definition>");
        xml.append("    <application>");
        xml.append("       <apply toObject='CAPTION' styles='CaptionFont' />");
        xml.append("       <apply toObject='SUBCAPTION' styles='CaptionFont' />");
        xml.append("    </application>");
        xml.append(" </styles>");

        xml.append("</chart>");

        return xml.toString();

    }


    /**
     * <pre>
     *  1. 개   요 : Make chart xml for department Impact factor
     *  2. 처리내용 :
     * </pre>
     * @Method Name : buildDepartIFChartXml
     * @param departs
     * @param contextPath
     * @return
     */
    public static String buildDepartIFChartXml(List<AnalysisVo> departList, RimsSearchVo searchVo, String contextPath) {
        StringBuffer xml = new StringBuffer();

        String gubun = searchVo.getGubun();
        String avgIFType = searchVo.getAvgIFType();

        String yAxisName = "IF평균1 (IF합/전체논문수)";
        String valField = "impctFctrAvrg";
        if (R2Constant.ARTICLE_GUBUN_SCOPUS.equals(gubun)) valField = "sjrAvrg";
        else if (R2Constant.ARTICLE_GUBUN_KCI.equals(gubun)) valField = "kciIFAvrg";

        if ("ex".equals(avgIFType)) {
            yAxisName = "IF평균2 (IF합/IF제공논문수)";
            valField = "impctFctrExsAvrg";
            if (R2Constant.ARTICLE_GUBUN_SCOPUS.equals(gubun)) valField = "sjrExsAvrg";
            else if (R2Constant.ARTICLE_GUBUN_KCI.equals(gubun)) valField = "kciIFExsAvrg";
        }
		/*
		xml.append(" <chart animation='0' caption='' xAxisName='' yAxisName='"+yAxisName+"' showValues='1' formatNumberScale='0' decimals='2' ")
		.append(" divLineAlpha='30' numvdivlines='5' divLineIsDashed='1' bgColor='F7F7F7, E9E9E9' ")
		.append(" exportEnabled='1' exportShowMenuItem='0' exportAtClient='0' exportAction='save' exportHandler='"+contextPath+"/servlet/FCExporter/export.do' exportCallBack='myFN' ")
		.append(" useRoundEdges='1' labelDisplay='ROTATE' slantLabels='1' legendPosition ='CENTER' forceDecimals='1' >");
		*/
        xml.append("<chart ")
                .append(" subcaption='' ")
                .append(" baseFontColor='#666666' ")
                .append(" baseFontSize='11' ")
                .append(" subcaptionFontBold='0' ")
                .append(" canvasBgAlpha='0' ")
                .append(" showValues='0' ")
                .append(" paletteColors='" + paletteColors + "' ")
                .append(" bgAlpha='0' ")
                .append(" showBorder='0' ")
                .append(" showShadow='0' ")
                .append(" showAlternateHGridColor='0' ")
                .append(" showCanvasBorder='0' ")
                .append(" showXAxisLine='1' ")
                .append(" xAxisName='' ")
                .append(" xAxisLineThickness='1' ")
                .append(" xAxisLineColor='#cdcdcd' ")
                .append(" xAxisNameFontColor='#8d8d8d' ")
                .append(" yAxisName='" + yAxisName + "' ")
                .append(" yAxisNameFontColor='#8d8d8d' ")
                .append(" canvasBgColor='#ffffff' ")
                .append(" lineThickness='4' ")
                .append(" legendBgColor='#ffffff' ")
                .append(" legendBgAlpha='100' ")
                .append(" legendBorderAlpha='50' ")
                .append(" legendBorderColor='#888888' ")
                .append(" legendShadow='0' ")
                .append(" legendPosition='CENTER' ")
                .append(" divlineAlpha='0' ")
                .append(" numDivLines='10' ")
                .append(" divlineColor='#999999' ")
                .append(" divlineThickness='1' ")
                .append(" divLineIsDashed='1'")
                .append(" divLineDashLen='1'")
                .append(" divLineGapLen='1' ")
                .append(" toolTipColor='#ffffff' ")
                .append(" toolTipBorderColor='#ffffff' ")
                .append(" toolTipBorderThickness='1' ")
                .append(" toolTipBgColor='#000000' ")
                .append(" toolTipBgAlpha='80' ")
                .append(" toolTipBorderRadius='4' ")
                .append(" toolTipPadding='10' ")
                .append(" toolTipFontSize ='20' ")
                .append(" anchorBgColor='#ffffff' ")
                .append(" anchorRadius='5' ")
                .append(" anchorBorderThickness='3' ")
                .append(" anchorTrackingRadius='15' ")
                .append(" showHoverEffect='1' ")
                .append(" formatNumberScale='0'")
                .append(" labelDisplay='rotate' ")
                .append(" plotBorderColor='#ffffff' ") //bar 테두리없애기
                .append(" usePlotGradientColor='0' ") //bar의 그라데이션 없애기
                .append(" slantLabels='1' ")
                .append(" exportEnabled='1' ")
                .append(" exportAtClient='0' ")
                .append(" exportAction='save' ")
                .append(" exportShowMenuItem='0' ")
                .append(" exportDialogMessage='Building chart output' ")
                .append(" exportHandler='" + contextPath + "/servlet/FCExporter/export.do' exportCallBack='myFN' ")
                .append(" >");

        int j = 0;
        for(AnalysisVo depart : departList){
            if(j >= 12) break;
            Object val = getValueFromObject(depart, valField).toString().trim();
            double dValue = Math.round((Double.parseDouble(val.toString()))*100d)/100d;
            String tText = depart.getDeptKor().trim() + " : " + dValue;
            xml.append("<set label='"+depart.getDeptKor().trim()+"' value='"+dValue+"'  toolText='"+tText+"'/>");
            j++;
        }

        xml.append("<styles>");
        xml.append("    <definition>");
        xml.append("        <style name='myLabelsFont' type='font' font='Malgun Gothic' size='12' bold='1' />");
        xml.append("        <style name='CaptionFont' type='font' size='12'/>");
        xml.append("    </definition>");
        xml.append("    <application>");
        xml.append("       <apply toObject='CAPTION' styles='CaptionFont' />");
        xml.append("       <apply toObject='SUBCAPTION' styles='CaptionFont' />");
        xml.append("       <apply toObject='DataLabels' styles='myLabelsFont' />");
        xml.append("    </application>");
        xml.append(" </styles>");

        xml.append("</chart>");

        return xml.toString();
    }


    public static String buildOverviewDepartIFChartXml (List < AnalysisVo > departList, RimsSearchVo
            searchVo, String contextPath){
        String gubun = searchVo.getGubun();
        StringBuffer xml = new StringBuffer();
		/*
		xml.append("<chart animation='0' caption='' xAxisName='' yAxisName='평균 Impact Factor' showValues='1' ")
		.append(" divLineAlpha='30' numvdivlines='0' divLineIsDashed='0' bgColor='FFFFFF, FFFFFF' ")
		.append(" showLegend='1' showPercentageInLabel='0' showBorder='0'  canvasBorderAlpha='0' canvasBorderThickness='0' ")
		.append(" useRoundEdges='1' labelDisplay='ROTATE' slantLabels='1' legendPosition ='CENTER' decimals='2' forceDecimals='1' >");
		*/
        xml.append("<chart ")
                .append(" caption='' ")
                .append(" subcaption='' ")
                .append(" baseFontColor='#666666' ")
                .append(" baseFontSize='11' ")
                .append(" subcaptionFontBold='0' ")
                .append(" canvasBgAlpha='0' ")
                .append(" showValues='0' ")
                .append(" paletteColors='" + paletteColors + "' ")
                .append(" bgAlpha='0' ")
                .append(" showBorder='0' ")
                .append(" showShadow='0' ")
                .append(" showAlternateHGridColor='0' ")
                .append(" showCanvasBorder='0' ")
                .append(" showXAxisLine='1' ")
                .append(" xAxisName='' ")
                .append(" xAxisLineThickness='1' ")
                .append(" xAxisLineColor='#cdcdcd' ")
                .append(" xAxisNameFontColor='#8d8d8d' ")
                .append(" yAxisName='평균 Impact Factor' ")
                .append(" yAxisNameFontColor='#8d8d8d' ")
                .append(" canvasBgColor='#ffffff' ")
                .append(" lineThickness='4' ")
                .append(" legendBgColor='#ffffff' ")
                .append(" legendBgAlpha='100' ")
                .append(" legendBorderAlpha='50' ")
                .append(" legendBorderColor='#888888' ")
                .append(" legendShadow='0' ")
                .append(" legendPosition='CENTER' ")
                .append(" divlineAlpha='0' ")
                .append(" numDivLines='10' ")
                .append(" divlineColor='#999999' ")
                .append(" divlineThickness='1' ")
                .append(" divLineIsDashed='1'")
                .append(" divLineDashLen='1'")
                .append(" divLineGapLen='1' ")
                .append(" toolTipColor='#ffffff' ")
                .append(" toolTipBorderColor='#ffffff' ")
                .append(" toolTipBorderThickness='1' ")
                .append(" toolTipBgColor='#000000' ")
                .append(" toolTipBgAlpha='80' ")
                .append(" toolTipBorderRadius='4' ")
                .append(" toolTipPadding='10' ")
                .append(" toolTipFontSize ='20' ")
                .append(" anchorBgColor='#ffffff' ")
                .append(" anchorRadius='5' ")
                .append(" anchorBorderThickness='3' ")
                .append(" anchorTrackingRadius='15' ")
                .append(" showHoverEffect='1' ")
                .append(" formatNumberScale='0'")
                .append(" labelDisplay='rotate' ")
                .append(" slantLabels='1' ")
                .append(" plotBorderColor='#ffffff' ") //bar 테두리없애기
                .append(" usePlotGradientColor='0' ") //bar의 그라데이션 없애기
                .append(" exportEnabled='1' ")
                .append(" exportAtClient='0' ")
                .append(" exportAction='save' ")
                .append(" exportShowMenuItem='0' ")
                .append(" exportDialogMessage='Building chart output' ")
                .append(" exportHandler='" + contextPath + "/servlet/FCExporter/export.do' exportCallBack='myFN' ")
                .append(" >");

        int j = 0;
        for (AnalysisVo depart : departList) {
            if (j >= 5) break;
            Object val = depart.getImpctFctrAvrg().toString().trim();
            if (R2Constant.ARTICLE_GUBUN_SCOPUS.equals(gubun)) val = depart.getSjrAvrg().toString().trim();
            else if (R2Constant.ARTICLE_GUBUN_KCI.equals(gubun)) val = depart.getKciIFAvrg().toString().trim();

            double dValue = Math.round((Double.parseDouble(val.toString())) * 100d) / 100d;
            String tText = depart.getDeptKor().trim() + " : " + dValue;
            xml.append("<set label='" + depart.getDeptKor().trim() + "' value='" + dValue + "'  toolText='" + tText + "' />");
            j++;
        }

        xml.append("<styles>");
        xml.append("    <definition>");
        xml.append("        <style name='myLabelsFont' type='font' font='Malgun Gothic' size='12' bold='1' />");
        xml.append("        <style name='CaptionFont' type='font' size='12'/>");
        xml.append("   </definition>");
        xml.append("    <application>");
        xml.append("       <apply toObject='CAPTION' styles='CaptionFont' />");
        xml.append("       <apply toObject='SUBCAPTION' styles='CaptionFont' />");
        xml.append("       <apply toObject='DataLabels' styles='myLabelsFont' />");
        xml.append("    </application>");
        xml.append(" </styles>");

        xml.append("</chart>");

        return xml.toString();
    }

    /**
     * <pre>
     *  1. 개   요 : Make chart xml department time cited chart by year
     *  2. 처리내용 :
     * </pre>
     *  @Method Name : buildDepartTimeCitedChartXmlWithYear
     *  @param noArts
     *  @param departs
     *  @param fromYear
     *  @param toYear
     *  @param gubun
     *  @param contextPath
     *  @return
     */
    public static String buildDepartTimeCitedChartXmlWithYear
    (List < AnalysisVo > departWithYearList, List < AnalysisVo > departList, RimsSearchVo searchVo, String
            contextPath){

        StringBuffer xml = new StringBuffer();
        String gubun = searchVo.getGubun();
        String fromYear = searchVo.getFromYear();
        String toYear = searchVo.getToYear();
        String keyField = "pubYear";

        String valField = "wosCitedAvrg";
        if (R2Constant.ARTICLE_GUBUN_SCOPUS.equals(gubun)) valField = "scpCitedAvrg";
        else if (R2Constant.ARTICLE_GUBUN_KCI.equals(gubun)) valField = "kciCitedAvrg";

        //String caption = "Publications by year from "+fromYear+ " to " + toYear;
        String valueColumn = "SCI".equals(gubun) ? "AVG_SCI_TC" : "AVG_SCP_TC";
		/*
		xml.append("<chart animation='0' caption='' subcaption='' lineThickness='2' showValues='0' formatNumberScale='0' anchorRadius='4'  ")
		.append(" divLineAlpha='30' numvdivlines='5' divLineIsDashed='1' bgColor='F7F7F7, E9E9E9' ")
		.append(" exportEnabled='1' exportAtClient='0' exportAction='save' exportHandler='"+contextPath+"/servlet/FCExporter/export.do' exportCallBack='myFN' ")
		.append(" exportShowMenuItem='0' exportDialogMessage='Building chart output' ")
		.append(" showLegend='1' legendPosition ='CENTER' >");
		*/
        xml.append("<chart ")
                .append(" caption='' ")
                .append(" subcaption='' ")
                .append(" baseFontColor='#666666' ")
                .append(" baseFontSize='11' ")
                .append(" subcaptionFontBold='0' ")
                .append(" canvasBgAlpha='0' ")
                .append(" showValues='0' ")
                .append(" paletteColors='" + paletteColors + "' ")
                .append(" bgAlpha='0' ")
                .append(" showBorder='0' ")
                .append(" showShadow='0' ")
                .append(" showAlternateHGridColor='0' ")
                .append(" showCanvasBorder='0' ")
                .append(" showXAxisLine='1' ")
                .append(" xAxisName='' ")
                .append(" xAxisLineThickness='1' ")
                .append(" xAxisLineColor='#cdcdcd' ")
                .append(" xAxisNameFontColor='#8d8d8d' ")
                .append(" yAxisName='' ")
                .append(" yAxisNameFontColor='#8d8d8d' ")
                .append(" canvasBgColor='#ffffff' ")
                .append(" lineThickness='4' ")
                .append(" legendBgColor='#ffffff' ")
                .append(" legendBgAlpha='100' ")
                .append(" legendBorderAlpha='50' ")
                .append(" legendBorderColor='#888888' ")
                .append(" legendShadow='0' ")
                .append(" legendPosition='CENTER' ")
                .append(" divlineAlpha='0' ")
                .append(" numDivLines='10' ")
                .append(" divlineColor='#999999' ")
                .append(" divlineThickness='1' ")
                .append(" divLineIsDashed='1'")
                .append(" divLineDashLen='1'")
                .append(" divLineGapLen='1' ")
                .append(" toolTipColor='#ffffff' ")
                .append(" toolTipBorderColor='#ffffff' ")
                .append(" toolTipBorderThickness='1' ")
                .append(" toolTipBgColor='#000000' ")
                .append(" toolTipBgAlpha='80' ")
                .append(" toolTipBorderRadius='4' ")
                .append(" toolTipPadding='10' ")
                .append(" toolTipFontSize ='20' ")
                .append(" anchorBgColor='#ffffff' ")
                .append(" anchorRadius='5' ")
                .append(" anchorBorderThickness='3' ")
                .append(" anchorTrackingRadius='15' ")
                .append(" showHoverEffect='1' ")
                .append(" formatNumberScale='0'")
                .append(" labelDisplay='rotate' ")
                .append(" slantLabels='1' ")
                .append(" exportEnabled='1' ")
                .append(" exportAtClient='0' ")
                .append(" exportAction='save' ")
                .append(" exportShowMenuItem='0' ")
                .append(" exportDialogMessage='Building chart output' ")
                .append(" exportHandler='" + contextPath + "/servlet/FCExporter/export.do' exportCallBack='myFN' ")
                .append(" >");


        int fy = Integer.parseInt(fromYear);
        int ty = Integer.parseInt(toYear);

        xml.append("<categories >");
        for (int ii = fy; ii <= ty; ii++) xml.append("<category label='" + ii + "' />");
        xml.append("</categories>");

        int j = 0;
        for (AnalysisVo depart : departList) {
            if (j >= 5) break;
            Map yearNoMap = convertObjectListToMapWithCompareValue(departWithYearList, "deptKor", depart.getDeptKor(), keyField, valField);
            String sn = depart.getDeptKor() + "";
            int fcIdx = j % 23;
            xml.append("<dataset seriesName='" + sn + "' color='" + fillColors[fcIdx] + "' anchorBorderColor='" + fillColors[fcIdx] + "' id='" + depart.getDeptKor() + "' >");
            for (int ii = fy; ii <= ty; ii++) {
                Object val = yearNoMap.get(Integer.toString(ii));
                if (val == null) {
                    xml.append("<set value='0' toolText='" + sn + " " + ii + " : 0' />");
                } else {
                    double dValue = Math.round((Double.parseDouble(val.toString())) * 100d) / 100d;
                    xml.append("<set value='" + dValue + "'  toolText='" + sn + " " + ii + " : " + dValue + "' />");
                }
            }
            xml.append("</dataset>");
            j++;
        }

        xml.append("<styles>");
        xml.append("    <definition>");
        xml.append("        <style name='CaptionFont' type='font' size='12'/>");
        xml.append("   </definition>");
        xml.append("    <application>");
        xml.append("       <apply toObject='CAPTION' styles='CaptionFont' />");
        xml.append("       <apply toObject='SUBCAPTION' styles='CaptionFont' />");
        xml.append("    </application>");
        xml.append(" </styles>");

        xml.append("</chart>");

        return xml.toString();

    }

    public static String buildArtChartXmlWithYear (List < AnalysisVo > list, RimsSearchVo searchVo, String
            contextPath){

        StringBuffer xml = new StringBuffer();
        String fromYear = searchVo.getFromYear();
        String toYear = searchVo.getToYear();
        String keyField = "pubYear";
        String valField = "artsCo";
		/*
		xml.append(" <chart animation='1' caption='' subcaption='' lineThickness='4' showValues='1' formatNumberScale='0' showLegend='0'  anchorRadius='4'")
		.append(" xAxisName='Year' yAxisName='No. of Articles' ")
		.append(" divLineAlpha='30' numvdivlines='5' divLineIsDashed='1' bgColor='F7F7F7, E9E9E9' ")
		.append(" legendPosition ='CENTER'  useRoundEdges='1' slantLabels='1'  labelDisplay='ROTATE' >");
		*/
        xml.append("<chart ")
                .append(" caption='' ")
                .append(" subcaption='' ")
                .append(" baseFontColor='#666666' ")
                .append(" baseFontSize='11' ")
                .append(" subcaptionFontBold='0' ")
                .append(" canvasBgAlpha='0' ")
                .append(" showValues='0' ")
                .append(" paletteColors='" + paletteColors + "' ")
                .append(" bgAlpha='0' ")
                .append(" showBorder='0' ")
                .append(" showShadow='0' ")
                .append(" showAlternateHGridColor='0' ")
                .append(" showCanvasBorder='0' ")
                .append(" showXAxisLine='1' ")
                .append(" xAxisName='Year' ")
                .append(" xAxisLineThickness='1' ")
                .append(" xAxisLineColor='#cdcdcd' ")
                .append(" xAxisNameFontColor='#8d8d8d' ")
                .append(" yAxisName='No. of Articles' ")
                .append(" yAxisNameFontColor='#8d8d8d' ")
                .append(" canvasBgColor='#ffffff' ")
                .append(" lineThickness='4' ")
                .append(" legendBgColor='#ffffff' ")
                .append(" legendBgAlpha='100' ")
                .append(" legendBorderAlpha='50' ")
                .append(" legendBorderColor='#888888' ")
                .append(" legendShadow='0' ")
                .append(" legendPosition='CENTER' ")
                .append(" divlineAlpha='100' ")
                .append(" numDivLines='10' ")
                .append(" divlineColor='#999999' ")
                .append(" divlineThickness='1' ")
                .append(" divLineIsDashed='1'")
                .append(" divLineDashLen='1'")
                .append(" divLineGapLen='1' ")
                .append(" toolTipColor='#ffffff' ")
                .append(" toolTipBorderColor='#ffffff' ")
                .append(" toolTipBorderThickness='1' ")
                .append(" toolTipBgColor='#000000' ")
                .append(" toolTipBgAlpha='80' ")
                .append(" toolTipBorderRadius='4' ")
                .append(" toolTipPadding='10' ")
                .append(" toolTipFontSize ='20' ")
                .append(" anchorBgColor='#ffffff' ")
                .append(" anchorRadius='5' ")
                .append(" anchorBorderThickness='3' ")
                .append(" anchorTrackingRadius='15' ")
                .append(" showHoverEffect='1' ")
                .append(" formatNumberScale='0'")
                .append(" labelDisplay='rotate' ")
                .append(" slantLabels='1' ")
                .append(" exportEnabled='1' ")
                .append(" exportAtClient='0' ")
                .append(" exportAction='save' ")
                .append(" exportShowMenuItem='0' ")
                .append(" exportDialogMessage='Building chart output' ")
                .append(" exportHandler='" + contextPath + "/servlet/FCExporter/export.do' exportCallBack='myFN' ")
                .append(" >");

        int fy = Integer.parseInt(fromYear);
        int ty = Integer.parseInt(toYear);

        xml.append("<categories >");
        for (int ii = fy; ii <= ty; ii++) {
            xml.append("<category label='" + ii + "' />");
        }
        xml.append("</categories>");

        Map yearNoMap = convertObjectListToMap(list, keyField, valField);
        xml.append("<dataset seriesName='Articles' color='" + fillColors[0] + "' anchorBorderColor='" + fillColors[0] + "'  >");
        for (int ii = fy; ii <= ty; ii++) {
            Object val = yearNoMap.get(Integer.toString(ii));
            if (val == null)
                xml.append("<set value='0' toolText='" + ii + " : 0' />");
            else
                xml.append("<set value='" + val + "'  toolText=' " + ii + " : " + val + "' />");
        }
        xml.append("</dataset>");

        xml.append("<styles>");
        xml.append("    <definition>");
        xml.append("        <style name='CaptionFont' type='font' size='12'/>");
        xml.append("   </definition>");
        xml.append("    <application>");
        xml.append("       <apply toObject='CAPTION' styles='CaptionFont' />");
        xml.append("       <apply toObject='SUBCAPTION' styles='CaptionFont' />");
        xml.append("    </application>");
        xml.append(" </styles>");
        xml.append("</chart>");

        return xml.toString();

    }

    public static String buildOverviewSciArtChartXmlWithYear (List < AnalysisVo > list, RimsSearchVo searchVo){

        StringBuffer xml = new StringBuffer();
        String fromYear = searchVo.getFromYear();
        String toYear = searchVo.getToYear();
        String keyField = "pubYear";
        String valField = "artsCo";
		/*
		xml.append(" <chart animation='1' caption='' subcaption='' lineThickness='4' formatNumberScale='0' anchorRadius='4'")
		.append(" xAxisName='Year' yAxisName='No. of "+searchVo.getGubun()+" Articles' ")
		.append(" divLineAlpha='30' numvdivlines='5' divLineIsDashed='1' bgColor='FFFFFF, FFFFFF' ")
		.append(" showValues='1' showLabels='1' showLegend='0' showPercentageInLabel='0' showBorder='0'  canvasBorderAlpha='0' canvasBorderThickness='0'")
		.append(" exportShowMenuItem='0' exportDialogMessage='Building chart output ' ")
		.append(" legendPosition ='CENTER'  useRoundEdges='1' slantLabels='1' >");
		*/
        xml.append("<chart ")
                .append(" caption='' ")
                .append(" subcaption='' ")
                .append(" baseFontColor='#666666' ")
                .append(" baseFontSize='11' ")
                .append(" subcaptionFontBold='0' ")
                .append(" canvasBgAlpha='0' ")
                .append(" showValues='0' ")
                .append(" paletteColors='" + paletteColors + "' ")
                .append(" bgAlpha='0' ")
                .append(" showBorder='0' ")
                .append(" showShadow='0' ")
                .append(" showAlternateHGridColor='0' ")
                .append(" showCanvasBorder='0' ")
                .append(" showXAxisLine='1' ")
                .append(" xAxisName='Year' ")
                .append(" xAxisLineThickness='1' ")
                .append(" xAxisLineColor='#cdcdcd' ")
                .append(" xAxisNameFontColor='#8d8d8d' ")
                .append(" yAxisName='No. of " + searchVo.getGubun() + " Articles' ")
                .append(" yAxisNameFontColor='#8d8d8d' ")
                .append(" canvasBgColor='#ffffff' ")
                .append(" lineThickness='4' ")
                .append(" legendBgColor='#ffffff' ")
                .append(" legendBgAlpha='100' ")
                .append(" legendBorderAlpha='50' ")
                .append(" legendBorderColor='#888888' ")
                .append(" legendShadow='0' ")
                .append(" legendPosition='CENTER' ")
                .append(" divlineAlpha='100' ")
                .append(" numDivLines='10' ")
                .append(" divlineColor='#999999' ")
                .append(" divlineThickness='1' ")
                .append(" divLineIsDashed='1'")
                .append(" divLineDashLen='1'")
                .append(" divLineGapLen='1' ")
                .append(" toolTipColor='#ffffff' ")
                .append(" toolTipBorderColor='#ffffff' ")
                .append(" toolTipBorderThickness='1' ")
                .append(" toolTipBgColor='#000000' ")
                .append(" toolTipBgAlpha='80' ")
                .append(" toolTipBorderRadius='4' ")
                .append(" toolTipPadding='10' ")
                .append(" toolTipFontSize ='20' ")
                .append(" anchorBgColor='#ffffff' ")
                .append(" anchorRadius='5' ")
                .append(" anchorBorderThickness='3' ")
                .append(" anchorTrackingRadius='15' ")
                .append(" showHoverEffect='1' ")
                .append(" formatNumberScale='0'")
                .append(" labelDisplay='rotate' ")
                .append(" slantLabels='1' ")
                .append(" exportEnabled='0' ")
                .append(" exportAtClient='0' ")
                .append(" exportShowMenuItem='0' ")
                .append(" >");

        int fy = Integer.parseInt(fromYear);
        int ty = Integer.parseInt(toYear);

        xml.append("<categories >");
        for (int ii = fy; ii <= ty; ii++) {
            xml.append("<category label='" + ii + "' />");
        }
        xml.append("</categories>");

        Map yearNoMap = convertObjectListToMap(list, keyField, valField);
        xml.append("<dataset seriesName='Articles' color='" + fillColors[5] + "' anchorBorderColor='" + fillColors[5] + "'  >");
        for (int ii = fy; ii <= ty; ii++) {
            Object val = yearNoMap.get(Integer.toString(ii));
            if (val == null)
                xml.append("<set value='0' toolText='" + ii + " : 0' />");
            else
                xml.append("<set value='" + val + "'  toolText=' " + ii + " : " + val + "' />");
        }
        xml.append("</dataset>");

        xml.append("<styles>");
        xml.append("    <definition>");
        xml.append("        <style name='CaptionFont' type='font' size='12'/>");
        xml.append("   </definition>");
        xml.append("    <application>");
        xml.append("       <apply toObject='CAPTION' styles='CaptionFont' />");
        xml.append("       <apply toObject='SUBCAPTION' styles='CaptionFont' />");
        xml.append("    </application>");
        xml.append(" </styles>");
        xml.append("</chart>");

        return xml.toString();

    }

    public static String buildNetworkAmongOther (List < AnalysisVo > coAuthorList, AnalysisVo
            mainDepartment, RimsSearchVo searchVo, String contextPath, String instAbrv){

        double maxTtl = 0;
        double maxCoworkCnt = 0;
        double maxRel = 0;
        int radius = 20;
        dcMap = new HashMap<String, String>();
        int dfFillIdx = 0;
        String fillColor = "";

        for (AnalysisVo coAuthor : coAuthorList) {
            if (maxCoworkCnt < coAuthor.getCoArtsCo()) maxCoworkCnt = coAuthor.getCoArtsCo();
        }

        StringBuffer sb = new StringBuffer();
    	/*
    	sb.append(" <chart ")
  	      .append(" viewMode='1' showFormBtn='0' showRestoreBtn='0' showplotborder='1' enableLink='1' showBorder='0' ")
  	      .append(" is3D='1' baseFontSize='12' baseFont='Malgun Gothic' ")
  	      .append(" palette='2' xAxisMinValue='0' ")
  	      .append(" canvasBorderAlpha='0' canvasBorderThickness='0' ")
  	      .append(" xAxisMaxValue='"+100+"' yAxisMinValue='0' yAxisMaxValue='"+100+"' ")
  	      .append(" chartTopMargin='3' chartLeftMargin='3' chartRightMargin='3' chartBottomMargin='3' ")
  	      .append(" showLegend='1' interactiveLegend='0' legendNumColumns='4' ")
  	      .append(" use3DLighting='0' useEllipsesWhenOverflow='0' labelDisplay='WRAP' unescapeLinks='0' ")
  	      .append(" exportShowMenuItem='0' exportDialogMessage='Building chart output ' ")
  	      .append(" exportEnabled='1' exportAtClient='0' exportAction='save' exportHandler='"+contextPath+"/servlet/FCExporter/export.do' exportCallBack='myFN' ")
  	      .append(" >");
    	*/
        sb.append("<chart ")
                .append(" caption='' ")
                .append(" subcaption='' ")
                .append(" baseFontColor='#666666' ")
                .append(" baseFontSize='11' ")
                .append(" subcaptionFontBold='0' ")
                .append(" canvasBgAlpha='0' ")
                .append(" showValues='0' ")
                .append(" paletteColors='" + paletteColors + "' ")
                .append(" bgAlpha='0' ")
                .append(" showBorder='0' ")
                .append(" showShadow='0' ")
                .append(" showAlternateHGridColor='0' ")
                .append(" showCanvasBorder='0' ")
                .append(" showformbtn='0' ")
                .append(" showRestoreBtn='0' ")
                .append(" viewmode='1' ")
                .append(" xAxisMaxValue='100' ")
                .append(" yAxisMinValue='0' ")
                .append(" yAxisMaxValue='100' ")
                .append(" chartTopMargin='3' ")
                .append(" chartLeftMargin='3' ")
                .append(" chartRightMargin='3' ")
                .append(" chartBottomMargin='3' ")
                .append(" xAxisName='' ")
                .append(" showXAxisLine='0' ")
                .append(" xAxisLineThickness='1' ")
                .append(" xAxisLineColor='#cdcdcd' ")
                .append(" xAxisNameFontColor='#8d8d8d' ")
                .append(" yAxisName='' ")
                .append(" yAxisNameFontColor='#8d8d8d' ")
                .append(" canvasBgColor='#ffffff' ")
                .append(" lineThickness='4' ")
                .append(" legendBgColor='#ffffff' ")
                .append(" legendBgAlpha='100' ")
                .append(" legendBorderAlpha='50' ")
                .append(" legendBorderColor='#888888' ")
                .append(" legendShadow='0' ")
                .append(" legendPosition='CENTER' ")
                .append(" divlineAlpha='100' ")
                .append(" numDivLines='10' ")
                .append(" divlineThickness='0' ")
                .append(" toolTipColor='#ffffff' ")
                .append(" toolTipBorderColor='#ffffff' ")
                .append(" toolTipBorderThickness='1' ")
                .append(" toolTipBgColor='#000000' ")
                .append(" toolTipBgAlpha='80' ")
                .append(" toolTipBorderRadius='4' ")
                .append(" toolTipPadding='10' ")
                .append(" toolTipFontSize ='20' ")
                .append(" anchorBgColor='#ffffff' ")
                .append(" anchorRadius='5' ")
                .append(" anchorBorderThickness='3' ")
                .append(" anchorTrackingRadius='15' ")
                .append(" showHoverEffect='1' ")
                .append(" formatNumberScale='0'")
                .append(" labelDisplay='rotate' ")
                .append(" slantLabels='1' ")
                .append(" exportEnabled='1' ")
                .append(" exportAtClient='0' ")
                .append(" exportAction='save' ")
                .append(" exportShowMenuItem='0' ")
                .append(" exportDialogMessage='Building chart output' ")
                .append(" exportHandler='" + contextPath + "/servlet/FCExporter/export.do' exportCallBack='myFN' ")
                .append(" >");

        double step = coAuthorList.size() == 0 ? 0 : 360d / coAuthorList.size();
        if (coAuthorList.size() > 0) maxRel = coAuthorList.get(0).getCoArtsCo();

        double total = Double.parseDouble(mainDepartment.getArtsCo().toString());
        if (maxTtl < total) maxTtl = total;

        radius = (int) ((total / maxTtl) * 30) + 28;

        if (dcMap.get(mainDepartment.getDeptKor()) == null) {
            fillColor = fillColors[dfFillIdx];
            dfFillIdx++;
            dcMap.put(mainDepartment.getDeptKor(), fillColor);
        }

        String displayValue = StringUtil.XMLEncode(mainDepartment.getDeptKor());
        String tooltip = displayValue;
        if ("other".equals(searchVo.getCoauthorTarget())) {
            tooltip = instAbrv + "{br}" + tooltip + "";
            displayValue = instAbrv + "{br}" + displayValue + "";
        }

        sb.append("<dataset seriesName='" + mainDepartment.getDeptKor() + "'  plotBorderColor='#" + fillColor + "' plotborderthickness='8'  >");
        sb.append("<set x='50' y='50' name='" + displayValue + "' radius='" + radius + "' id='id_0' shape='CIRCLE' color='#d4f9ff' toolText='" + tooltip + "'/> ");
        sb.append("</dataset>");

        boolean dist = false;
        for (int jj = 0; jj < coAuthorList.size(); jj++) {

            double degree = (450d - step * (jj%2==0?jj:coAuthorList.size()-jj-(coAuthorList.size()%2==0?0:1))) % 360d;

            total = Double.parseDouble(coAuthorList.get(jj).getArtsTotal().toString());

            double radians = (Math.PI / 180) * degree;

            double cnt = Double.parseDouble(coAuthorList.get(jj).getCoArtsCo().toString());
            double ratio = cnt / maxRel;

            double distRatio = dist == true ? CacheUtils.getHighDistanceRatio() / 10.0 : CacheUtils.getLowDistanceRatio() / 10.0;

            int distance = coAuthorList.size() > 15 ? (int) (coAuthorList.size()/2.5) : (int) (coAuthorList.size()/3.5);
            double x = Math.sin(radians) * (30.0 + (jj % 2 == 0 ? distance : 0)) * distRatio + 50.0;
            double y = Math.cos(radians) * (30.0 + (jj % 2 == 0 ? distance : 0)) * distRatio + 50.0;

            radius = (int) ((cnt / maxCoworkCnt) * 25) + (55 -  distance);

            String dispValue = StringUtil.XMLEncode(StringUtils.replace((String) coAuthorList.get(jj).getDeptKor(), "'", "&#39;"));

            if (dcMap.get(coAuthorList.get(jj).getDeptKor()) == null) {
                fillColor = fillColors[dfFillIdx];
                dfFillIdx++;
                dcMap.put((String) coAuthorList.get(jj).getDeptKor(), fillColor);
            }
            String deptNm = StringUtil.XMLEncode(coAuthorList.get(jj).getDeptKor());
            sb.append("<dataset seriesName='" + dispValue + "' plotBorderColor='#" + fillColor + "' plotborderthickness='5' >");
            sb.append("<set x='" + x + "' y='" + y + "' radius='" + radius + "' ");
            sb.append(" name='" + dispValue + "' id='id_" + (jj + 1) + "' toolText='" + deptNm + "' ");
            sb.append(" shape='CIRCLE' color='#ffffff' labelAlign='middle' link='j-chartClick-other;" + deptNm + "' />");
            sb.append("</dataset>");

            dist = dist == true ? false : true;
        }

        sb.append("<connectors color='#AAAAAA' stdThickness='5'>");

        for (int ki = 0; ki < coAuthorList.size(); ki++) {
            String color = "AAAAAA";
            String deptNm = StringUtil.XMLEncode(coAuthorList.get(ki).getDeptKor());
            int cnt = Integer.parseInt(coAuthorList.get(ki).getCoArtsCo().toString());

            double alpha = (cnt / maxRel) * 1.1 + 0.7;

            sb.append("<connector strength='" + (alpha) + "' ");
            sb.append(" label ='" + cnt + "' ");
            sb.append(" from='id_0' to='id_" + (ki + 1) + "' ");
            sb.append(" arrowAtStart='0' arrowAtEnd='0' ");
            sb.append(" link='j-chartClick-other;" + deptNm + "' ");
            sb.append(" />");
        }

        sb.append("</connectors>");

        sb.append("<styles>");
        sb.append("<definition>");
        sb.append("   <style name='myLabelsFont' type='font' font='Malgun Gothic' bold='0' size='11' color='000000'/>");
        sb.append("</definition>");
        sb.append("<application>");
        sb.append("   <apply toObject='DataLabels' styles='myLabelsFont' />");
        sb.append("</application>");
        sb.append("</styles>");

        sb.append("</chart>");

        return sb.toString();


    }

    /**
     * <pre>
     *  1. 개   요 : Make cahrt data for publication of overview page
     *  2. 처리내용 :
     * </pre>
     *  @Method Name : buildOverviewArtChartXmlWithYear
     *  @param arts
     *  @param fromYear
     *  @param toYear
     *  @param gubun
     *  @return
     */
    public static String buildOverviewArtChartXmlWithYear (List < AnalysisVo > list, RimsSearchVo searchVo){

        String gubun = searchVo.getGubun();
        String fromYear = searchVo.getFromYear();
        String toYear = searchVo.getToYear();

        String keyField = "pubYear";
        String valField = "artsCo";

        String title = "No. of Publications";
        String color = "F1683C"; //sci chart color
        //if(R2Constant.ARTICLE_GUBUN_SCOPUS.equals(gubun)) color = "1D8BD1";    //scopus chart color
        //else if(R2Constant.ARTICLE_GUBUN_KCI.equals(gubun)) color = "588526"; //kci chart color

        if (searchVo.getType() != null && !searchVo.getType().isEmpty() && "wosCitedSum".equals(searchVo.getType())) {
            valField = "wosCitedSum";
            color = "1D8BD1";
            title = "No. of Citation of WOS in Publications";
        }

        String caption = "";
        StringBuffer xml = new StringBuffer();

		/*
		xml.append("<chart caption='"+caption+"' subcaption='' lineThickness='3' showValues='1' formatNumberScale='0' showLegend='0' anchorRadius='4' ")
		.append(" divLineAlpha='30' numvdivlines='5' divLineIsDashed='1' bgColor='FFFFFF, FFFFFF' slantLabels='1' labelDisplay='ROTATE'")
		.append(" exportShowMenuItem='0' exportDialogMessage='Building chart output ' canvasBorderColor='666666' canvasBorderThickness='1' canvasBorderAlpha='80'")
		.append(" useRoundEdges='1' showBorder='0' legendPosition ='CENTER' chartLeftMargin='3' chartRightMargin='5' chartBottomMargin='5'>");
		*/
        xml.append("<chart ")
                .append(" caption='" + caption + "' ")
                .append(" subcaption='' ")
                .append(" baseFontColor='#666666' ")
                .append(" baseFontSize='11' ")
                .append(" subcaptionFontBold='0' ")
                .append(" canvasBgAlpha='0' ")
                .append(" showValues='0' ")
                .append(" paletteColors='" + paletteColors + "' ")
                .append(" bgAlpha='0' ")
                .append(" showBorder='0' ")
                .append(" showShadow='0' ")
                .append(" showAlternateHGridColor='0' ")
                .append(" showCanvasBorder='0' ")
                .append(" showXAxisLine='1' ")
                .append(" xAxisLineThickness='1' ")
                .append(" xAxisLineColor='#cdcdcd' ")
                .append(" xAxisNameFontColor='#8d8d8d' ")
                .append(" yAxisNameFontColor='#8d8d8d' ")
                .append(" canvasBgColor='#ffffff' ")
                .append(" lineThickness='4' ")
                .append(" legendBgColor='#ffffff' ")
                .append(" legendBgAlpha='100' ")
                .append(" legendBorderAlpha='50' ")
                .append(" legendBorderColor='#888888' ")
                .append(" legendShadow='0' ")
                .append(" legendPosition='CENTER' ")
                .append(" divlineAlpha='0' ")
                .append(" numDivLines='10' ")
                .append(" divlineColor='#999999' ")
                .append(" divlineThickness='1' ")
                .append(" divLineIsDashed='1'")
                .append(" divLineDashLen='1'")
                .append(" divLineGapLen='1' ")
                .append(" toolTipColor='#ffffff' ")
                .append(" toolTipBorderColor='#ffffff' ")
                .append(" toolTipBorderThickness='1' ")
                .append(" toolTipBgColor='#000000' ")
                .append(" toolTipBgAlpha='80' ")
                .append(" toolTipBorderRadius='4' ")
                .append(" toolTipPadding='10' ")
                .append(" toolTipFontSize ='20' ")
                .append(" anchorBgColor='#ffffff' ")
                .append(" anchorRadius='5' ")
                .append(" anchorBorderThickness='3' ")
                .append(" anchorTrackingRadius='15' ")
                .append(" showHoverEffect='1' ")
                .append(" formatNumberScale='0'")
                .append(" labelDisplay='rotate' ")
                .append(" slantLabels='1' ")
                .append(" exportEnabled='0' ")
                .append(" exportAtClient='0' ")
                .append(" exportAction='save' ")
                .append(" exportShowMenuItem='0' ")
                .append(" >");

        int fy = Integer.parseInt(fromYear);
        int ty = Integer.parseInt(toYear);

        xml.append("<categories >");
        for (int ii = fy; ii <= ty; ii++) xml.append("<category label='" + ii + "' />");
        xml.append("</categories>");

        //total no. of publications
        int totArtsNo = 0;
        Map yearNoMap = convertObjectListToMap(list, keyField, valField);
        for (int ii = fy; ii <= ty; ii++) {
            if (yearNoMap.get(Integer.toString(ii)) != null)
                totArtsNo += Integer.parseInt(yearNoMap.get(Integer.toString(ii)).toString());
        }

        xml.append("<dataset seriesName='" + title + " (Total: " + totArtsNo + ")' color='" + color + "' anchorBorderColor='" + color + "' >");
        for (int ii = fy; ii <= ty; ii++) {
            Object val = yearNoMap.get(Integer.toString(ii));
            if (val == null)
                xml.append("<set value='0' toolText='0'/>");
            else
                xml.append("<set value='" + val + "' toolText='" + val + "'/>");
        }
        xml.append("</dataset>");

        xml.append("<styles>");
        xml.append("    <definition>");
        xml.append("        <style name='CaptionFont' type='font' size='12'/>");
        xml.append("   </definition>");
        xml.append("    <application>");
        xml.append("       <apply toObject='CAPTION' styles='CaptionFont' />");
        xml.append("       <apply toObject='SUBCAPTION' styles='CaptionFont' />");
        xml.append("    </application>");
        xml.append(" </styles>");

        xml.append("</chart>");

        return xml.toString();
    }

    /**
     * <pre>
     *  1. 개   요 : Make chart xml for cited vs uncited chart on overview page
     *  2. 처리내용 :
     * </pre>
     *  @Method Name : buildTrendsOverviewChartXmlWithYear
     *  @param arts
     *  @param fromYear
     *  @param toYear
     *  @return
     */
    public static String buildTrendsOverviewChartXmlWithYear (List < AnalysisVo > list, RimsSearchVo searchVo){

        String gubun = searchVo.getGubun();
        String fromYear = searchVo.getFromYear();
        String toYear = searchVo.getToYear();

        String caption = "";
        StringBuffer xml = new StringBuffer();
		/*
		xml.append("<chart caption='"+caption+"' subcaption='' lineThickness='3' showValues='0' formatNumberScale='0' anchorRadius='2' ")
		.append(" divLineAlpha='50' numvdivlines='5' divLineIsDashed='1' bgColor='FFFFFF,FFFFFF' slantLabels='1' labelDisplay='ROTATE' ")
		.append(" useRoundEdges='1' showBorder='0' legendPosition ='CENTER' showLegend='1' chartLeftMargin='3' chartRightMargin='5' chartBottomMargin='5'>");
		*/
        xml.append("<chart ")
                .append(" caption='" + caption + "' ")
                .append(" subcaption='' ")
                .append(" baseFontColor='#666666' ")
                .append(" baseFontSize='11' ")
                .append(" subcaptionFontBold='0' ")
                .append(" canvasBgAlpha='0' ")
                .append(" showValues='0' ")
                .append(" paletteColors='" + paletteColors + "' ")
                .append(" bgAlpha='0' ")
                .append(" showBorder='0' ")
                .append(" showShadow='0' ")
                .append(" showAlternateHGridColor='0' ")
                .append(" showCanvasBorder='0' ")
                .append(" showXAxisLine='1' ")
                .append(" xAxisName='' ")
                .append(" xAxisLineThickness='1' ")
                .append(" xAxisLineColor='#cdcdcd' ")
                .append(" xAxisNameFontColor='#8d8d8d' ")
                .append(" yAxisName='' ")
                .append(" yAxisNameFontColor='#8d8d8d' ")
                .append(" canvasBgColor='#ffffff' ")
                .append(" lineThickness='4' ")
                .append(" legendBgColor='#ffffff' ")
                .append(" legendBgAlpha='100' ")
                .append(" legendBorderAlpha='50' ")
                .append(" legendBorderColor='#888888' ")
                .append(" legendShadow='0' ")
                .append(" legendPosition='CENTER' ")
                .append(" divlineAlpha='0' ")
                .append(" numDivLines='10' ")
                .append(" divlineColor='#999999' ")
                .append(" divlineThickness='1' ")
                .append(" divLineIsDashed='1'")
                .append(" divLineDashLen='1'")
                .append(" divLineGapLen='1' ")
                .append(" toolTipColor='#ffffff' ")
                .append(" toolTipBorderColor='#ffffff' ")
                .append(" toolTipBorderThickness='1' ")
                .append(" toolTipBgColor='#000000' ")
                .append(" toolTipBgAlpha='80' ")
                .append(" toolTipBorderRadius='4' ")
                .append(" toolTipPadding='10' ")
                .append(" toolTipFontSize ='20' ")
                .append(" anchorBgColor='#ffffff' ")
                .append(" anchorRadius='5' ")
                .append(" anchorBorderThickness='3' ")
                .append(" anchorTrackingRadius='15' ")
                .append(" showHoverEffect='1' ")
                .append(" formatNumberScale='0'")
                .append(" labelDisplay='rotate' ")
                .append(" slantLabels='1' ")
                .append(" plotBorderColor='#ffffff' ") //bar 테두리없애기
                .append(" usePlotGradientColor='0' ") //bar의 그라데이션 없애기
                .append(" exportEnabled='0' ")
                .append(" exportAtClient='0' ")
                .append(" exportShowMenuItem='0' ")
                .append(" >");

        int fy = Integer.parseInt(fromYear);
        int ty = Integer.parseInt(toYear);

        xml.append("<categories >");
        for (int ii = fy; ii <= ty; ii++) xml.append("<category label='" + ii + "' />");
        xml.append("</categories>");

        String keyField = "pubYear";
        String noCitArtValField = "wosCitedCo";
        String noNotCitArtValField = "wosNotCitedCo";
        if (R2Constant.ARTICLE_GUBUN_SCOPUS.equals(gubun)) {
            noCitArtValField = "scpCitedCo";
            noNotCitArtValField = "scpNotCitedCo";
        } else if (R2Constant.ARTICLE_GUBUN_KCI.equals(gubun)) {
            noCitArtValField = "kciCitedCo";
            noNotCitArtValField = "kciNotCitedCo";
        }
        String noArtTotValField = "artsCo";

        Map yearNoMap = convertObjectListToMap(list, keyField, noCitArtValField);
        Map yearNotCitMap = convertObjectListToMap(list, keyField, noNotCitArtValField);
        Map yearNoTotMap = convertObjectListToMap(list, keyField, noArtTotValField);
        //Map yearCitMap = convertListToMap(arts, "IS_YEAR", "NO_CIT");

        //total no. of publications
        int totArtsNo = 0;
        int totCitArtsNo = 0;
        int totNotCitArtsNo = 0;
        for (int ii = fy; ii <= ty; ii++) {
            if (yearNoTotMap.get(Integer.toString(ii)) != null) {
                totArtsNo += Integer.parseInt(yearNoTotMap.get(Integer.toString(ii)).toString());
                totCitArtsNo += Integer.parseInt(yearNoMap.get(Integer.toString(ii)).toString());
                totNotCitArtsNo += Integer.parseInt(yearNotCitMap.get(Integer.toString(ii)).toString());
            }
        }

        //citated publications dataset
        xml.append("<dataset seriesName='Cited(Total: " + totCitArtsNo + ")'>");
        for (int ii = fy; ii <= ty; ii++) {
            Object val = yearNoMap.get(Integer.toString(ii));
            if (val == null)
                xml.append("<set value='0'  color='1aa1b5' toolText='" + ii + " cited : " + val + "'/>");
            else
                xml.append("<set value='" + val + "' color='1aa1b5' toolText='" + ii + " cited : " + val + "'/>");
        }
        xml.append("</dataset>");

        //not citated publications dataset
        xml.append("<dataset seriesName='Uncited(Total: " + totNotCitArtsNo + ")'>");
        for (int ii = fy; ii <= ty; ii++) {
            Object val = yearNotCitMap.get(Integer.toString(ii));
            if (val == null)
                xml.append("<set value='0' color='2dcdb1' toolText='" + ii + " uncited : " + val + "'/>");
            else
                xml.append("<set value='" + val + "' color='2dcdb1' link='JavaScript:clickChart(\\\"notCited\\\" , " + ii + ")' toolText='" + ii + " uncited : " + val + "'/>");
        }
        xml.append("</dataset>");

        xml.append("<trendlines>");
        xml.append("<style name='CanvasAnim' type='animation' param='_xScale' start='0' duration='1' />");
        xml.append("</trendlines>");
        xml.append("<styles>");
        xml.append("    <definition>");
        xml.append("        <style name='CaptionFont' type='font' size='12'/>");
        xml.append("   </definition>");
        xml.append("    <application>");
        xml.append("       <apply toObject='CAPTION' styles='CaptionFont' />");
        xml.append("       <apply toObject='SUBCAPTION' styles='CaptionFont' />");
        xml.append("    </application>");
        xml.append(" </styles>");

        xml.append("</chart>");

        return xml.toString();
    }

    public static String buildOverviewDepartCitedChartXml (List < AnalysisVo > deptList, RimsSearchVo searchVo){
        StringBuffer xml = new StringBuffer();
        String gubun = searchVo.getGubun();
        int i = 0;
		/*
		xml.append(" <chart animation='0' caption='' xAxisName='' yAxisName='' formatNumberScale='0' decimals='2' forceDecimals='1'")
		.append(" divLineAlpha='30' numvdivlines='5' divLineIsDashed='1' bgColor='FFFFFF, FFFFFF' ")
		.append(" showValues='1' showLabels='1' showPercentageInLabel='0' showBorder='0'  canvasBorderAlpha='0' canvasBorderThickness='0'")
	    .append(" exportEnabled='1' exportAtClient='0' exportAction='save' ")
		.append(" exportShowMenuItem='0' exportDialogMessage='Building chart output ' ")
		.append(" useRoundEdges='1' labelDisplay='ROTATE' slantLabels='1' legendPosition ='CENTER '>");
		*/
        xml.append("<chart ")
                .append(" caption='' ")
                .append(" subcaption='' ")
                .append(" baseFontColor='#666666' ")
                .append(" baseFontSize='11' ")
                .append(" subcaptionFontBold='0' ")
                .append(" canvasBgAlpha='0' ")
                .append(" showValues='0' ")
                .append(" paletteColors='" + paletteColors + "' ")
                .append(" bgAlpha='0' ")
                .append(" showBorder='0' ")
                .append(" showShadow='0' ")
                .append(" showAlternateHGridColor='0' ")
                .append(" showCanvasBorder='0' ")
                .append(" showXAxisLine='1' ")
                .append(" xAxisName='' ")
                .append(" xAxisLineThickness='1' ")
                .append(" xAxisLineColor='#cdcdcd' ")
                .append(" xAxisNameFontColor='#8d8d8d' ")
                .append(" yAxisName='' ")
                .append(" yAxisNameFontColor='#8d8d8d' ")
                .append(" canvasBgColor='#ffffff' ")
                .append(" lineThickness='4' ")
                .append(" legendBgColor='#ffffff' ")
                .append(" legendBgAlpha='100' ")
                .append(" legendBorderAlpha='50' ")
                .append(" legendBorderColor='#888888' ")
                .append(" legendShadow='0' ")
                .append(" legendPosition='CENTER' ")
                .append(" divlineAlpha='0' ")
                .append(" numDivLines='10' ")
                .append(" divlineColor='#999999' ")
                .append(" divlineThickness='1' ")
                .append(" divLineIsDashed='1'")
                .append(" divLineDashLen='1'")
                .append(" divLineGapLen='1' ")
                .append(" toolTipColor='#ffffff' ")
                .append(" toolTipBorderColor='#ffffff' ")
                .append(" toolTipBorderThickness='1' ")
                .append(" toolTipBgColor='#000000' ")
                .append(" toolTipBgAlpha='80' ")
                .append(" toolTipBorderRadius='4' ")
                .append(" toolTipPadding='10' ")
                .append(" toolTipFontSize ='20' ")
                .append(" anchorBgColor='#ffffff' ")
                .append(" anchorRadius='5' ")
                .append(" anchorBorderThickness='3' ")
                .append(" anchorTrackingRadius='15' ")
                .append(" showHoverEffect='1' ")
                .append(" formatNumberScale='0'")
                .append(" labelDisplay='rotate' ")
                .append(" slantLabels='1' ")
                .append(" plotBorderColor='#ffffff' ") //bar 테두리없애기
                .append(" usePlotGradientColor='0' ") //bar의 그라데이션 없애기
                .append(" exportEnabled='0' ")
                .append(" exportAtClient='0' ")
                .append(" exportShowMenuItem='0' ")
                .append(" >");

        for (AnalysisVo depart : deptList) {
            if (i > 5) break;

            Double val = depart.getWosCitedAvrg();
            if (R2Constant.ARTICLE_GUBUN_SCOPUS.equals(gubun)) val = depart.getScpCitedAvrg();
            else if (R2Constant.ARTICLE_GUBUN_KCI.equals(gubun)) val = depart.getKciCitedAvrg();

            double dValue = Math.round(val * 100d) / 100d;
            String tText = depart.getDeptKor().trim() + " : " + dValue;
            xml.append("<set label='" + depart.getDeptKor() + "' value='" + dValue + "'  toolText='" + tText + "' />");
            i++;
        }

        xml.append("<styles>");
        xml.append("    <definition>");
        xml.append("        <style name='myLabelsFont' type='font' font='Malgun Gothic' size='12' bold='1' />");
        xml.append("        <style name='CaptionFont' type='font' size='12'/>");
        xml.append("   </definition>");
        xml.append("    <application>");
        xml.append("       <apply toObject='CAPTION' styles='CaptionFont' />");
        xml.append("       <apply toObject='SUBCAPTION' styles='CaptionFont' />");
        xml.append("       <apply toObject='DataLabels' styles='myLabelsFont' />");
        xml.append("    </application>");
        xml.append(" </styles>");

        xml.append("</chart>");

        return xml.toString();
    }

    public static String buildTechtransChartWithRpmList
            (List < AnalysisVo > list, List < AnalysisVo > rpmList, RimsSearchVo searchVo, String contextPath){

        String techTransrCd = searchVo.getTechTransrCd();
        String fromYear = searchVo.getFromYear();
        String toYear = searchVo.getToYear();

        String caption = "Tech-Trans by year from " + fromYear + " to " + toYear;
        StringBuffer xml = new StringBuffer();

        int fy = Integer.parseInt(fromYear);
        int ty = Integer.parseInt(toYear);
        Integer sMaxValue = 0;

        String keyField = "transYear";
        String transCoValField = "transCo";
        String rpmKeyField = "rpmYear";
        String rpmAmtValField = "rpmAmt";

        Map patentTransfrCo = convertObjectListToMapWithCompareValue(list, "techTransrCd", R2Constant.TECHTRANSR_PATENT_TRANSFR_CD, keyField, transCoValField);
        Map dvrOprtnCo = convertObjectListToMapWithCompareValue(list, "techTransrCd", R2Constant.TECHTRANSR_DVR_OPRTN_CD, keyField, transCoValField);
        Map cmercOprtnCo = convertObjectListToMapWithCompareValue(list, "techTransrCd", R2Constant.TECHTRANSR_CMERC_OPRTN_CD, keyField, transCoValField);
        Map knowHowCo = convertObjectListToMapWithCompareValue(list, "techTransrCd", R2Constant.TECHTRANSR_KNOW_HOW_CD, keyField, transCoValField);
        Map cnsutCo = convertObjectListToMapWithCompareValue(list, "techTransrCd", R2Constant.TECHTRANSR_CNSUT_CD, keyField, transCoValField);
        Map etcCo = convertObjectListToMapWithCompareValue(list, "techTransrCd", R2Constant.TECHTRANSR_ETC_CD, keyField, transCoValField);
        Map totTechtransCoMap = new HashMap();

        for (int ii = fy; ii <= ty; ii++) {
            Integer totTransCo = 0;
            if (patentTransfrCo.get(Integer.toString(ii)) != null)
                totTransCo += Integer.parseInt(patentTransfrCo.get(Integer.toString(ii)).toString());
            if (dvrOprtnCo.get(Integer.toString(ii)) != null)
                totTransCo += Integer.parseInt(dvrOprtnCo.get(Integer.toString(ii)).toString());
            if (cmercOprtnCo.get(Integer.toString(ii)) != null)
                totTransCo += Integer.parseInt(cmercOprtnCo.get(Integer.toString(ii)).toString());
            if (knowHowCo.get(Integer.toString(ii)) != null)
                totTransCo += Integer.parseInt(knowHowCo.get(Integer.toString(ii)).toString());
            if (cnsutCo.get(Integer.toString(ii)) != null)
                totTransCo += Integer.parseInt(cnsutCo.get(Integer.toString(ii)).toString());
            if (etcCo.get(Integer.toString(ii)) != null)
                totTransCo += Integer.parseInt(etcCo.get(Integer.toString(ii)).toString());
            if (sMaxValue < totTransCo) sMaxValue = totTransCo;
            totTechtransCoMap.put(Integer.toString(ii), totTransCo);
        }
		/*
		xml.append(" <chart caption='"+caption+"' subcaption='' lineThickness='3'  ")
		.append(" xaxisname='' pyaxisname='기술이전료(천원단위)' syaxisname='기술이전건수' ");
		if(sMaxValue < 5) xml.append(" sYAxisMaxValue='5' ");
		xml.append(" showValues='0' showSum='1' formatNumberScale='0' anchorRadius='2' decimals='0' ")
		.append(" divLineAlpha='50' numvdivlines='5' divLineIsDashed='1' bgColor='F7F7F7, E9E9E9' ")
		.append(" exportShowMenuItem='0' exportDialogMessage='Building chart output' ")
		.append(" exportEnabled='1' exportAtClient='0' exportAction='save' exportHandler='"+contextPath+"/servlet/FCExporter/export.do' exportCallBack='myFN' ")
		.append(" useRoundEdges='1' legendPosition ='CENTER' >");
		*/
        xml.append("<chart ")
                .append(" caption='" + caption + "' ")
                .append(" subcaption='' ")
                .append(" baseFontColor='#666666' ")
                .append(" baseFontSize='11' ")
                .append(" subcaptionFontBold='0' ")
                .append(" canvasBgAlpha='0' ")
                .append(" showValues='0' ")
                .append(" paletteColors='" + paletteColors + "' ")
                .append(" bgAlpha='0' ")
                .append(" showBorder='0' ")
                .append(" showShadow='0' ")
                .append(" showAlternateHGridColor='0' ")
                .append(" showCanvasBorder='0' ")
                .append(" showXAxisLine='1' ")
                .append(" syaxisname='기술이전건수' ")
                .append(" xAxisLineThickness='1' ")
                .append(" xAxisLineColor='#cdcdcd' ")
                .append(" xAxisNameFontColor='#8d8d8d' ")
                .append(" pyaxisname='기술이전료(천원단위)' ")
                .append(" yAxisNameFontColor='#8d8d8d' ")
                .append(" canvasBgColor='#ffffff' ")
                .append(" lineThickness='4' ")
                .append(" legendBgColor='#ffffff' ")
                .append(" legendBgAlpha='100' ")
                .append(" legendBorderAlpha='50' ")
                .append(" legendBorderColor='#888888' ")
                .append(" legendShadow='0' ")
                .append(" legendPosition='CENTER' ")
                .append(" divlineAlpha='100' ")
                .append(" numDivLines='10' ")
                .append(" divlineColor='#999999' ")
                .append(" divlineThickness='1' ")
                .append(" divLineIsDashed='1'")
                .append(" divLineDashLen='1'")
                .append(" divLineGapLen='1' ")
                .append(" toolTipColor='#ffffff' ")
                .append(" toolTipBorderColor='#ffffff' ")
                .append(" toolTipBorderThickness='1' ")
                .append(" toolTipBgColor='#000000' ")
                .append(" toolTipBgAlpha='80' ")
                .append(" toolTipBorderRadius='4' ")
                .append(" toolTipPadding='10' ")
                .append(" toolTipFontSize ='20' ")
                .append(" anchorBgColor='#ffffff' ")
                .append(" anchorRadius='5' ")
                .append(" anchorBorderThickness='3' ")
                .append(" anchorTrackingRadius='15' ")
                .append(" showHoverEffect='1' ")
                .append(" formatNumberScale='0'")
                .append(" labelDisplay='rotate' ")
                .append(" slantLabels='1' ")
                .append(" exportEnabled='1' ")
                .append(" exportAtClient='0' ")
                .append(" exportAction='save' ")
                .append(" exportShowMenuItem='0' ")
                .append(" exportDialogMessage='Building chart output' ")
                .append(" exportHandler='" + contextPath + "/servlet/FCExporter/export.do' exportCallBack='myFN' ");
        if (sMaxValue < 5) xml.append(" sYAxisMaxValue='5' ");
        xml.append(" >");


        xml.append("<categories >");
        for (int ii = fy; ii <= ty; ii++) xml.append("<category label='" + ii + "' />");
        xml.append("</categories>");

        Map patentTransfr = convertObjectListToMapWithCompareValue(rpmList, "techTransrCd", R2Constant.TECHTRANSR_PATENT_TRANSFR_CD, rpmKeyField, rpmAmtValField);
        Map dvrOprtn = convertObjectListToMapWithCompareValue(rpmList, "techTransrCd", R2Constant.TECHTRANSR_DVR_OPRTN_CD, rpmKeyField, rpmAmtValField);
        Map cmercOprtn = convertObjectListToMapWithCompareValue(rpmList, "techTransrCd", R2Constant.TECHTRANSR_CMERC_OPRTN_CD, rpmKeyField, rpmAmtValField);
        Map knowHow = convertObjectListToMapWithCompareValue(rpmList, "techTransrCd", R2Constant.TECHTRANSR_KNOW_HOW_CD, rpmKeyField, rpmAmtValField);
        Map cnsut = convertObjectListToMapWithCompareValue(rpmList, "techTransrCd", R2Constant.TECHTRANSR_CNSUT_CD, rpmKeyField, rpmAmtValField);
        Map etc = convertObjectListToMapWithCompareValue(rpmList, "techTransrCd", R2Constant.TECHTRANSR_ETC_CD, rpmKeyField, rpmAmtValField);

        xml.append("<dataset>");

        if (techTransrCd == null || "".equals(techTransrCd) || R2Constant.TECHTRANSR_PATENT_TRANSFR_CD.equals(techTransrCd)) {
            xml.append("<dataset seriesName='" + R2Constant.TECHTRANSR_PATENT_TRANSFR + "' color='EF187D' showValues='0' >");
            for (int ii = fy; ii <= ty; ii++) {
                Object val = patentTransfr.get(Integer.toString(ii));
                if (val == null)
                    xml.append("<set value='0'  toolText='" + ii + " " + R2Constant.TECHTRANSR_PATENT_TRANSFR + " : 0'/>");
                else
                    xml.append("<set value='" + val + "'  link='j-clickChart-cited;" + ii + "' toolText='" + ii + " " + R2Constant.TECHTRANSR_PATENT_TRANSFR + " : " + val + "'/>");
            }
            xml.append("</dataset>");
        }

        if (techTransrCd == null || "".equals(techTransrCd) || R2Constant.TECHTRANSR_DVR_OPRTN_CD.equals(techTransrCd)) {
            xml.append("<dataset seriesName='" + R2Constant.TECHTRANSR_DVR_OPRTN + "' color='F5A618' showValues='0' >");
            for (int ii = fy; ii <= ty; ii++) {
                Object val = dvrOprtn.get(Integer.toString(ii));
                if (val == null)
                    xml.append("<set value='0'  toolText='" + ii + " " + R2Constant.TECHTRANSR_DVR_OPRTN + " : 0'/>");
                else
                    xml.append("<set value='" + val + "' link='j-clickChart-cited;" + ii + "' toolText='" + ii + " " + R2Constant.TECHTRANSR_DVR_OPRTN + " : " + val + "'/>");
            }
            xml.append("</dataset>");
        }

        if (techTransrCd == null || "".equals(techTransrCd) || R2Constant.TECHTRANSR_CMERC_OPRTN_CD.equals(techTransrCd)) {
            xml.append("<dataset seriesName='" + R2Constant.TECHTRANSR_CMERC_OPRTN + "' color='1A4991' showValues='0' >");
            for (int ii = fy; ii <= ty; ii++) {
                Object val = cmercOprtn.get(Integer.toString(ii));
                if (val == null)
                    xml.append("<set value='0' toolText='" + ii + " " + R2Constant.TECHTRANSR_CMERC_OPRTN + " : 0'/>");
                else
                    xml.append("<set value='" + val + "'  link='j-clickChart-cited;" + ii + "' toolText='" + ii + " " + R2Constant.TECHTRANSR_CMERC_OPRTN + " : " + val + "'/>");
            }
            xml.append("</dataset>");
        }

        if (techTransrCd == null || "".equals(techTransrCd) || R2Constant.TECHTRANSR_KNOW_HOW_CD.equals(techTransrCd)) {
            xml.append("<dataset seriesName='" + R2Constant.TECHTRANSR_KNOW_HOW + "' color='008E8E' showValues='0' >");
            for (int ii = fy; ii <= ty; ii++) {
                Object val = knowHow.get(Integer.toString(ii));
                if (val == null)
                    xml.append("<set value='0' toolText='" + ii + " " + R2Constant.TECHTRANSR_KNOW_HOW + " : 0'/>");
                else
                    xml.append("<set value='" + val + "' link='j-clickChart-cited;" + ii + "' toolText='" + ii + " " + R2Constant.TECHTRANSR_KNOW_HOW + " : " + val + "'/>");
            }
            xml.append("</dataset>");
        }

        if (techTransrCd == null || "".equals(techTransrCd) || R2Constant.TECHTRANSR_CNSUT_CD.equals(techTransrCd)) {
            xml.append("<dataset seriesName='" + R2Constant.TECHTRANSR_CNSUT + "' color='CC6600' showValues='0' >");
            for (int ii = fy; ii <= ty; ii++) {
                Object val = cnsut.get(Integer.toString(ii));
                if (val == null)
                    xml.append("<set value='0' toolText='" + ii + " " + R2Constant.TECHTRANSR_CNSUT + " : 0'/>");
                else
                    xml.append("<set value='" + val + "' link='j-clickChart-cited;" + ii + "' toolText='" + ii + " " + R2Constant.TECHTRANSR_CNSUT + " : " + val + "'/>");
            }
            xml.append("</dataset>");
        }

        if (techTransrCd == null || "".equals(techTransrCd) || R2Constant.TECHTRANSR_ETC_CD.equals(techTransrCd)) {
            xml.append("<dataset seriesName='" + R2Constant.TECHTRANSR_ETC + "' color='663300' showValues='0' >");
            for (int ii = fy; ii <= ty; ii++) {
                Object val = etc.get(Integer.toString(ii));
                if (val == null)
                    xml.append("<set value='0' toolText='" + ii + " " + R2Constant.TECHTRANSR_ETC + " : 0'/>");
                else
                    xml.append("<set value='" + val + "' link='j-clickChart-cited;" + ii + "' toolText='" + ii + " " + R2Constant.TECHTRANSR_ETC + " : " + val + "'/>");
            }
            xml.append("</dataset>");
        }

        xml.append("</dataset>");

        xml.append("<lineset  seriesName='기술이전건수' color='B3AA00' showValues='0'  linethickness='4' >");
        for (int ii = fy; ii <= ty; ii++) {
            Object val = totTechtransCoMap.get(Integer.toString(ii));
            if (val == null)
                xml.append("<set value='0'  toolText='" + ii + " 기술이전 : 0'/>");
            else
                xml.append("<set value='" + val + "' link='j-clickChart-cited;" + ii + "' toolText='" + ii + " 기술이전 : " + val + "'/>");
        }
        xml.append("</lineset >");


        xml.append("<trendlines>");
        xml.append("<style name='CanvasAnim' type='animation' param='_xScale' start='0' duration='1' />");
        xml.append("</trendlines>");
        xml.append("<styles>");
        xml.append("    <definition>");
        xml.append("        <style name='CaptionFont' type='font' size='12'/>");
        xml.append("   </definition>");
        xml.append("    <application>");
        xml.append("       <apply toObject='CAPTION' styles='CaptionFont' />");
        xml.append("       <apply toObject='SUBCAPTION' styles='CaptionFont' />");
        xml.append("    </application>");
        xml.append(" </styles>");

        xml.append("</chart>");

        return xml.toString();
    }


    public static String buildTechtransChart (List < AnalysisVo > list, RimsSearchVo searchVo, String contextPath){

        String techTransrCd = searchVo.getTechTransrCd();
        String fromYear = searchVo.getFromYear();
        String toYear = searchVo.getToYear();

        String caption = "Tech-Trans by year from " + fromYear + " to " + toYear;
        StringBuffer xml = new StringBuffer();
		/*
		xml.append(" <chart caption='"+caption+"' subcaption='' lineThickness='3'  ")
		.append(" xaxisname='' pyaxisname='기술이전료(천원단위)' syaxisname='기술이전건수' ")
		.append(" showValues='0' showSum='1' formatNumberScale='0' anchorRadius='2' decimals='0' ")
		.append(" divLineAlpha='50' numvdivlines='5' divLineIsDashed='1' bgColor='F7F7F7, E9E9E9' ")
		.append(" exportEnabled='1' exportAtClient='0' exportAction='save' exportHandler='"+contextPath+"/servlet/FCExporter/export.do' exportCallBack='myFN' ")
		.append(" exportShowMenuItem='0' exportDialogMessage='Building chart output' ")
		.append(" useRoundEdges='1' legendPosition ='CENTER' >");
		*/
        xml.append("<chart ")
                .append(" caption='" + caption + "' ")
                .append(" subcaption='' ")
                .append(" baseFontColor='#666666' ")
                .append(" baseFontSize='11' ")
                .append(" subcaptionFontBold='0' ")
                .append(" canvasBgAlpha='0' ")
                .append(" showValues='0' ")
                .append(" paletteColors='" + paletteColors + "' ")
                .append(" bgAlpha='0' ")
                .append(" showBorder='0' ")
                .append(" showShadow='0' ")
                .append(" showAlternateHGridColor='0' ")
                .append(" showCanvasBorder='0' ")
                .append(" showXAxisLine='1' ")
                .append(" pyaxisname='기술이전료(천원단위)' ")
                .append(" syaxisname='기술이전건수' ")
                .append(" xAxisName='' ")
                .append(" xAxisLineThickness='1' ")
                .append(" xAxisLineColor='#cdcdcd' ")
                .append(" xAxisNameFontColor='#8d8d8d' ")
                .append(" yAxisName='' ")
                .append(" yAxisNameFontColor='#8d8d8d' ")
                .append(" canvasBgColor='#ffffff' ")
                .append(" lineThickness='4' ")
                .append(" legendBgColor='#ffffff' ")
                .append(" legendBgAlpha='100' ")
                .append(" legendBorderAlpha='50' ")
                .append(" legendBorderColor='#888888' ")
                .append(" legendShadow='0' ")
                .append(" legendPosition='CENTER' ")
                .append(" divlineAlpha='100' ")
                .append(" numDivLines='10' ")
                .append(" divlineColor='#999999' ")
                .append(" divlineThickness='1' ")
                .append(" divLineIsDashed='1'")
                .append(" divLineDashLen='1'")
                .append(" divLineGapLen='1' ")
                .append(" toolTipColor='#ffffff' ")
                .append(" toolTipBorderColor='#ffffff' ")
                .append(" toolTipBorderThickness='1' ")
                .append(" toolTipBgColor='#000000' ")
                .append(" toolTipBgAlpha='80' ")
                .append(" toolTipBorderRadius='4' ")
                .append(" toolTipPadding='10' ")
                .append(" toolTipFontSize ='20' ")
                .append(" anchorBgColor='#ffffff' ")
                .append(" anchorRadius='5' ")
                .append(" anchorBorderThickness='3' ")
                .append(" anchorTrackingRadius='15' ")
                .append(" showHoverEffect='1' ")
                .append(" formatNumberScale='0'")
                .append(" labelDisplay='rotate' ")
                .append(" slantLabels='1' ")
                .append(" exportEnabled='1' ")
                .append(" exportAtClient='0' ")
                .append(" exportAction='save' ")
                .append(" exportShowMenuItem='0' ")
                .append(" exportDialogMessage='Building chart output' ")
                .append(" exportHandler='" + contextPath + "/servlet/FCExporter/export.do' exportCallBack='myFN' ")
                .append(" >");


        int fy = Integer.parseInt(fromYear);
        int ty = Integer.parseInt(toYear);

        xml.append("<categories >");
        for (int ii = fy; ii <= ty; ii++) xml.append("<category label='" + ii + "' />");
        xml.append("</categories>");

        String keyField = "transYear";
        String transCoValField = "transCo";
        String rpmAmtValField = "rpmAmt";


        Map patentTransfrCo = convertObjectListToMapWithCompareValue(list, "techTransrCd", R2Constant.TECHTRANSR_PATENT_TRANSFR_CD, keyField, transCoValField);
        Map dvrOprtnCo = convertObjectListToMapWithCompareValue(list, "techTransrCd", R2Constant.TECHTRANSR_DVR_OPRTN_CD, keyField, transCoValField);
        Map cmercOprtnCo = convertObjectListToMapWithCompareValue(list, "techTransrCd", R2Constant.TECHTRANSR_CMERC_OPRTN_CD, keyField, transCoValField);
        Map knowHowCo = convertObjectListToMapWithCompareValue(list, "techTransrCd", R2Constant.TECHTRANSR_KNOW_HOW_CD, keyField, transCoValField);
        Map cnsutCo = convertObjectListToMapWithCompareValue(list, "techTransrCd", R2Constant.TECHTRANSR_CNSUT_CD, keyField, transCoValField);
        Map etcCo = convertObjectListToMapWithCompareValue(list, "techTransrCd", R2Constant.TECHTRANSR_ETC_CD, keyField, transCoValField);
        Map totTechtransCoMap = new HashMap();

        for (int ii = fy; ii <= ty; ii++) {
            Integer totTransCo = 0;
            if (patentTransfrCo.get(Integer.toString(ii)) != null)
                totTransCo += Integer.parseInt(patentTransfrCo.get(Integer.toString(ii)).toString());
            if (dvrOprtnCo.get(Integer.toString(ii)) != null)
                totTransCo += Integer.parseInt(dvrOprtnCo.get(Integer.toString(ii)).toString());
            if (cmercOprtnCo.get(Integer.toString(ii)) != null)
                totTransCo += Integer.parseInt(cmercOprtnCo.get(Integer.toString(ii)).toString());
            if (knowHowCo.get(Integer.toString(ii)) != null)
                totTransCo += Integer.parseInt(knowHowCo.get(Integer.toString(ii)).toString());
            if (cnsutCo.get(Integer.toString(ii)) != null)
                totTransCo += Integer.parseInt(cnsutCo.get(Integer.toString(ii)).toString());
            if (etcCo.get(Integer.toString(ii)) != null)
                totTransCo += Integer.parseInt(etcCo.get(Integer.toString(ii)).toString());
            totTechtransCoMap.put(Integer.toString(ii), totTransCo);
        }

        Map patentTransfr = convertObjectListToMapWithCompareValue(list, "techTransrCd", R2Constant.TECHTRANSR_PATENT_TRANSFR_CD, keyField, rpmAmtValField);
        Map dvrOprtn = convertObjectListToMapWithCompareValue(list, "techTransrCd", R2Constant.TECHTRANSR_DVR_OPRTN_CD, keyField, rpmAmtValField);
        Map cmercOprtn = convertObjectListToMapWithCompareValue(list, "techTransrCd", R2Constant.TECHTRANSR_CMERC_OPRTN_CD, keyField, rpmAmtValField);
        Map knowHow = convertObjectListToMapWithCompareValue(list, "techTransrCd", R2Constant.TECHTRANSR_KNOW_HOW_CD, keyField, rpmAmtValField);
        Map cnsut = convertObjectListToMapWithCompareValue(list, "techTransrCd", R2Constant.TECHTRANSR_CNSUT_CD, keyField, rpmAmtValField);
        Map etc = convertObjectListToMapWithCompareValue(list, "techTransrCd", R2Constant.TECHTRANSR_ETC_CD, keyField, rpmAmtValField);

        xml.append("<dataset>");

        if (techTransrCd == null || "".equals(techTransrCd) || R2Constant.TECHTRANSR_PATENT_TRANSFR_CD.equals(techTransrCd)) {
            xml.append("<dataset seriesName='" + R2Constant.TECHTRANSR_PATENT_TRANSFR + "' color='EF187D' showValues='0' >");
            for (int ii = fy; ii <= ty; ii++) {
                Object val = patentTransfr.get(Integer.toString(ii));
                if (val == null)
                    xml.append("<set value='0'  toolText='" + ii + " " + R2Constant.TECHTRANSR_PATENT_TRANSFR + " : 0'/>");
                else
                    xml.append("<set value='" + val + "'  link='j-clickChart-cited;" + ii + "' toolText='" + ii + " " + R2Constant.TECHTRANSR_PATENT_TRANSFR + " : " + val + "'/>");
            }
            xml.append("</dataset>");
        }

        if (techTransrCd == null || "".equals(techTransrCd) || R2Constant.TECHTRANSR_DVR_OPRTN_CD.equals(techTransrCd)) {
            xml.append("<dataset seriesName='" + R2Constant.TECHTRANSR_DVR_OPRTN + "' color='F5A618' showValues='0' >");
            for (int ii = fy; ii <= ty; ii++) {
                Object val = dvrOprtn.get(Integer.toString(ii));
                if (val == null)
                    xml.append("<set value='0'  toolText='" + ii + " " + R2Constant.TECHTRANSR_DVR_OPRTN + " : 0'/>");
                else
                    xml.append("<set value='" + val + "' link='j-clickChart-cited;" + ii + "' toolText='" + ii + " " + R2Constant.TECHTRANSR_DVR_OPRTN + " : " + val + "'/>");
            }
            xml.append("</dataset>");
        }

        if (techTransrCd == null || "".equals(techTransrCd) || R2Constant.TECHTRANSR_CMERC_OPRTN_CD.equals(techTransrCd)) {
            xml.append("<dataset seriesName='" + R2Constant.TECHTRANSR_CMERC_OPRTN + "' color='1A4991' showValues='0' >");
            for (int ii = fy; ii <= ty; ii++) {
                Object val = cmercOprtn.get(Integer.toString(ii));
                if (val == null)
                    xml.append("<set value='0' toolText='" + ii + " " + R2Constant.TECHTRANSR_CMERC_OPRTN + " : 0'/>");
                else
                    xml.append("<set value='" + val + "'  link='j-clickChart-cited;" + ii + "' toolText='" + ii + " " + R2Constant.TECHTRANSR_CMERC_OPRTN + " : " + val + "'/>");
            }
            xml.append("</dataset>");
        }

        if (techTransrCd == null || "".equals(techTransrCd) || R2Constant.TECHTRANSR_KNOW_HOW_CD.equals(techTransrCd)) {
            xml.append("<dataset seriesName='" + R2Constant.TECHTRANSR_KNOW_HOW + "' color='008E8E' showValues='0' >");
            for (int ii = fy; ii <= ty; ii++) {
                Object val = knowHow.get(Integer.toString(ii));
                if (val == null)
                    xml.append("<set value='0' toolText='" + ii + " " + R2Constant.TECHTRANSR_KNOW_HOW + " : 0'/>");
                else
                    xml.append("<set value='" + val + "' link='j-clickChart-cited;" + ii + "' toolText='" + ii + " " + R2Constant.TECHTRANSR_KNOW_HOW + " : " + val + "'/>");
            }
            xml.append("</dataset>");
        }

        if (techTransrCd == null || "".equals(techTransrCd) || R2Constant.TECHTRANSR_CNSUT_CD.equals(techTransrCd)) {
            xml.append("<dataset seriesName='" + R2Constant.TECHTRANSR_CNSUT + "' color='CC6600' showValues='0' >");
            for (int ii = fy; ii <= ty; ii++) {
                Object val = cnsut.get(Integer.toString(ii));
                if (val == null)
                    xml.append("<set value='0' toolText='" + ii + " " + R2Constant.TECHTRANSR_CNSUT + " : 0'/>");
                else
                    xml.append("<set value='" + val + "' link='j-clickChart-cited;" + ii + "' toolText='" + ii + " " + R2Constant.TECHTRANSR_CNSUT + " : " + val + "'/>");
            }
            xml.append("</dataset>");
        }

        if (techTransrCd == null || "".equals(techTransrCd) || R2Constant.TECHTRANSR_ETC_CD.equals(techTransrCd)) {
            xml.append("<dataset seriesName='" + R2Constant.TECHTRANSR_ETC + "' color='663300' showValues='0' >");
            for (int ii = fy; ii <= ty; ii++) {
                Object val = etc.get(Integer.toString(ii));
                if (val == null)
                    xml.append("<set value='0' toolText='" + ii + " " + R2Constant.TECHTRANSR_ETC + " : 0'/>");
                else
                    xml.append("<set value='" + val + "' link='j-clickChart-cited;" + ii + "' toolText='" + ii + " " + R2Constant.TECHTRANSR_ETC + " : " + val + "'/>");
            }
            xml.append("</dataset>");
        }

        xml.append("</dataset>");

        xml.append("<lineset  seriesName='기술이전건수' color='B3AA00' showValues='0'  linethickness='4' >");
        for (int ii = fy; ii <= ty; ii++) {
            Object val = totTechtransCoMap.get(Integer.toString(ii));
            if (val == null)
                xml.append("<set value='0'  toolText='" + ii + " 기술이전 : 0'/>");
            else
                xml.append("<set value='" + val + "' link='j-clickChart-cited;" + ii + "' toolText='" + ii + " 기술이전 : " + val + "'/>");
        }
        xml.append("</lineset >");


        xml.append("<trendlines>");
        xml.append("<style name='CanvasAnim' type='animation' param='_xScale' start='0' duration='1' />");
        xml.append("</trendlines>");
        xml.append("<styles>");
        xml.append("    <definition>");
        xml.append("        <style name='CaptionFont' type='font' size='12'/>");
        xml.append("   </definition>");
        xml.append("    <application>");
        xml.append("       <apply toObject='CAPTION' styles='CaptionFont' />");
        xml.append("       <apply toObject='SUBCAPTION' styles='CaptionFont' />");
        xml.append("    </application>");
        xml.append(" </styles>");

        xml.append("</chart>");

        return xml.toString();
    }


    public static String buildTechtransCoChart (List < AnalysisVo > list, RimsSearchVo searchVo, String contextPath)
    {

        String techTransrCd = searchVo.getTechTransrCd();
        String fromYear = searchVo.getFromYear();
        String toYear = searchVo.getToYear();

        String caption = "Tech-Trans by year from " + fromYear + " to " + toYear;
        StringBuffer xml = new StringBuffer();

        xml.append("<chart ")
                .append(" caption='" + caption + "' ")
                .append(" subcaption='' ")
                .append(" baseFontColor='#666666' ")
                .append(" baseFontSize='11' ")
                .append(" subcaptionFontBold='0' ")
                .append(" canvasBgAlpha='0' ")
                .append(" showValues='0' ")
                .append(" paletteColors='" + paletteColors + "' ")
                .append(" bgAlpha='0' ")
                .append(" showBorder='0' ")
                .append(" showShadow='0' ")
                .append(" showAlternateHGridColor='0' ")
                .append(" showCanvasBorder='0' ")
                .append(" showXAxisLine='1' ")
                .append(" xAxisLineThickness='1' ")
                .append(" xAxisLineColor='#cdcdcd' ")
                .append(" xAxisNameFontColor='#8d8d8d' ")
                .append(" yAxisNameFontColor='#8d8d8d' ")
                .append(" canvasBgColor='#ffffff' ")
                .append(" lineThickness='4' ")
                .append(" legendBgColor='#ffffff' ")
                .append(" legendBgAlpha='100' ")
                .append(" legendBorderAlpha='50' ")
                .append(" legendBorderColor='#888888' ")
                .append(" legendShadow='0' ")
                .append(" legendPosition='CENTER' ")
                .append(" divlineAlpha='0' ")
                .append(" numDivLines='10' ")
                .append(" divlineColor='#999999' ")
                .append(" divlineThickness='1' ")
                .append(" divLineIsDashed='1'")
                .append(" divLineDashLen='1'")
                .append(" divLineGapLen='1' ")
                .append(" toolTipColor='#ffffff' ")
                .append(" toolTipBorderColor='#ffffff' ")
                .append(" toolTipBorderThickness='1' ")
                .append(" toolTipBgColor='#000000' ")
                .append(" toolTipBgAlpha='80' ")
                .append(" toolTipBorderRadius='4' ")
                .append(" toolTipPadding='10' ")
                .append(" toolTipFontSize ='20' ")
                .append(" anchorBgColor='#ffffff' ")
                .append(" anchorRadius='5' ")
                .append(" anchorBorderThickness='3' ")
                .append(" anchorTrackingRadius='15' ")
                .append(" showHoverEffect='1' ")
                .append(" formatNumberScale='0'")
                .append(" labelDisplay='rotate' ")
                .append(" slantLabels='1' ")
                .append(" exportEnabled='1' ")
                .append(" exportAtClient='0' ")
                .append(" exportAction='save' ")
                .append(" exportShowMenuItem='0' ")
                .append(" exportDialogMessage='Building chart output' ")
                .append(" exportHandler='" + contextPath + "/servlet/FCExporter/export.do' exportCallBack='myFN' ")
                .append(" >");

		/*
		xml.append(" <chart caption='"+caption+"' subcaption='' lineThickness='3'  ")
		.append(" xaxisname='' pyaxisname='기술이전료(천원단위)' syaxisname='기술이전건수' ")
		.append(" showValues='0' showSum='1' formatNumberScale='0' anchorRadius='2' decimals='0' ")
		.append(" divLineAlpha='50' numvdivlines='5' divLineIsDashed='1' bgColor='F7F7F7, E9E9E9' ")
		.append(" exportEnabled='1' exportAtClient='0' exportAction='save' exportHandler='"+contextPath+"/servlet/FCExporter/export.do' exportCallBack='myFN' ")
		.append(" exportShowMenuItem='0' exportDialogMessage='Building chart output' ")
		.append(" useRoundEdges='1' legendPosition ='CENTER' >");
		*/

        int fy = Integer.parseInt(fromYear);
        int ty = Integer.parseInt(toYear);

        xml.append("<categories >");
        for (int ii = fy; ii <= ty; ii++) xml.append("<category label='" + ii + "' />");
        xml.append("</categories>");

        String keyField = "transYear";
        String transCoValField = "transCo";
        String rpmAmtValField = "rpmAmt";


        Map patentTransfrCo = convertObjectListToMapWithCompareValue(list, "techTransrCd", R2Constant.TECHTRANSR_PATENT_TRANSFR_CD, keyField, transCoValField);
        Map dvrOprtnCo = convertObjectListToMapWithCompareValue(list, "techTransrCd", R2Constant.TECHTRANSR_DVR_OPRTN_CD, keyField, transCoValField);
        Map cmercOprtnCo = convertObjectListToMapWithCompareValue(list, "techTransrCd", R2Constant.TECHTRANSR_CMERC_OPRTN_CD, keyField, transCoValField);
        Map knowHowCo = convertObjectListToMapWithCompareValue(list, "techTransrCd", R2Constant.TECHTRANSR_KNOW_HOW_CD, keyField, transCoValField);
        Map cnsutCo = convertObjectListToMapWithCompareValue(list, "techTransrCd", R2Constant.TECHTRANSR_CNSUT_CD, keyField, transCoValField);
        Map etcCo = convertObjectListToMapWithCompareValue(list, "techTransrCd", R2Constant.TECHTRANSR_ETC_CD, keyField, transCoValField);
        Map totTechtransCoMap = new HashMap();

        for (int ii = fy; ii <= ty; ii++) {
            Integer totTransCo = 0;
            if (patentTransfrCo.get(Integer.toString(ii)) != null)
                totTransCo += Integer.parseInt(patentTransfrCo.get(Integer.toString(ii)).toString());
            if (dvrOprtnCo.get(Integer.toString(ii)) != null)
                totTransCo += Integer.parseInt(dvrOprtnCo.get(Integer.toString(ii)).toString());
            if (cmercOprtnCo.get(Integer.toString(ii)) != null)
                totTransCo += Integer.parseInt(cmercOprtnCo.get(Integer.toString(ii)).toString());
            if (knowHowCo.get(Integer.toString(ii)) != null)
                totTransCo += Integer.parseInt(knowHowCo.get(Integer.toString(ii)).toString());
            if (cnsutCo.get(Integer.toString(ii)) != null)
                totTransCo += Integer.parseInt(cnsutCo.get(Integer.toString(ii)).toString());
            if (etcCo.get(Integer.toString(ii)) != null)
                totTransCo += Integer.parseInt(etcCo.get(Integer.toString(ii)).toString());
            totTechtransCoMap.put(Integer.toString(ii), totTransCo);
        }

        if (techTransrCd == null || "".equals(techTransrCd) || R2Constant.TECHTRANSR_PATENT_TRANSFR_CD.equals(techTransrCd)) {
            xml.append("<dataset seriesName='" + R2Constant.TECHTRANSR_PATENT_TRANSFR + "' color='358ada' showValues='0' >");
            for (int ii = fy; ii <= ty; ii++) {
                Object val = patentTransfrCo.get(Integer.toString(ii));
                if (val == null)
                    xml.append("<set value='0'  toolText='" + ii + " " + R2Constant.TECHTRANSR_PATENT_TRANSFR + " : 0'/>");
                else
                    xml.append("<set value='" + val + "'  link='j-clickChart-cited;" + ii + "' toolText='" + ii + " " + R2Constant.TECHTRANSR_PATENT_TRANSFR + " : " + val + "'/>");
            }
            xml.append("</dataset>");
        }

        if (techTransrCd == null || "".equals(techTransrCd) || R2Constant.TECHTRANSR_DVR_OPRTN_CD.equals(techTransrCd)) {
            xml.append("<dataset seriesName='" + R2Constant.TECHTRANSR_DVR_OPRTN + "' color='2dcdb1' showValues='0' >");
            for (int ii = fy; ii <= ty; ii++) {
                Object val = dvrOprtnCo.get(Integer.toString(ii));
                if (val == null)
                    xml.append("<set value='0'  toolText='" + ii + " " + R2Constant.TECHTRANSR_DVR_OPRTN + " : 0'/>");
                else
                    xml.append("<set value='" + val + "' link='j-clickChart-cited;" + ii + "' toolText='" + ii + " " + R2Constant.TECHTRANSR_DVR_OPRTN + " : " + val + "'/>");
            }
            xml.append("</dataset>");
        }

        if (techTransrCd == null || "".equals(techTransrCd) || R2Constant.TECHTRANSR_CMERC_OPRTN_CD.equals(techTransrCd)) {
            xml.append("<dataset seriesName='" + R2Constant.TECHTRANSR_CMERC_OPRTN + "' color='2dcd6d' showValues='0' >");
            for (int ii = fy; ii <= ty; ii++) {
                Object val = cmercOprtnCo.get(Integer.toString(ii));
                if (val == null)
                    xml.append("<set value='0' toolText='" + ii + " " + R2Constant.TECHTRANSR_CMERC_OPRTN + " : 0'/>");
                else
                    xml.append("<set value='" + val + "'  link='j-clickChart-cited;" + ii + "' toolText='" + ii + " " + R2Constant.TECHTRANSR_CMERC_OPRTN + " : " + val + "'/>");
            }
            xml.append("</dataset>");
        }

        if (techTransrCd == null || "".equals(techTransrCd) || R2Constant.TECHTRANSR_KNOW_HOW_CD.equals(techTransrCd)) {
            xml.append("<dataset seriesName='" + R2Constant.TECHTRANSR_KNOW_HOW + "' color='eab543' showValues='0' >");
            for (int ii = fy; ii <= ty; ii++) {
                Object val = knowHowCo.get(Integer.toString(ii));
                if (val == null)
                    xml.append("<set value='0' toolText='" + ii + " " + R2Constant.TECHTRANSR_KNOW_HOW + " : 0'/>");
                else
                    xml.append("<set value='" + val + "' link='j-clickChart-cited;" + ii + "' toolText='" + ii + " " + R2Constant.TECHTRANSR_KNOW_HOW + " : " + val + "'/>");
            }
            xml.append("</dataset>");
        }

        if (techTransrCd == null || "".equals(techTransrCd) || R2Constant.TECHTRANSR_CNSUT_CD.equals(techTransrCd)) {
            xml.append("<dataset seriesName='" + R2Constant.TECHTRANSR_CNSUT + "' color='f69e3f' showValues='0' >");
            for (int ii = fy; ii <= ty; ii++) {
                Object val = cnsutCo.get(Integer.toString(ii));
                if (val == null)
                    xml.append("<set value='0' toolText='" + ii + " " + R2Constant.TECHTRANSR_CNSUT + " : 0'/>");
                else
                    xml.append("<set value='" + val + "' link='j-clickChart-cited;" + ii + "' toolText='" + ii + " " + R2Constant.TECHTRANSR_CNSUT + " : " + val + "'/>");
            }
            xml.append("</dataset>");
        }

        if (techTransrCd == null || "".equals(techTransrCd) || R2Constant.TECHTRANSR_ETC_CD.equals(techTransrCd)) {
            xml.append("<dataset seriesName='" + R2Constant.TECHTRANSR_ETC + "' color='dba2f9' showValues='0' >");
            for (int ii = fy; ii <= ty; ii++) {
                Object val = etcCo.get(Integer.toString(ii));
                if (val == null)
                    xml.append("<set value='0' toolText='" + ii + " " + R2Constant.TECHTRANSR_ETC + " : 0'/>");
                else
                    xml.append("<set value='" + val + "' link='j-clickChart-cited;" + ii + "' toolText='" + ii + " " + R2Constant.TECHTRANSR_ETC + " : " + val + "'/>");
            }
            xml.append("</dataset>");
        }

        xml.append("<dataset  seriesName='전체건수' color='1aa1b5' showValues='0'  linethickness='4' >");
        for (int ii = fy; ii <= ty; ii++) {
            Object val = totTechtransCoMap.get(Integer.toString(ii));
            if (val == null)
                xml.append("<set value='0'  toolText='" + ii + " 전체 : 0'/>");
            else
                xml.append("<set value='" + val + "' link='j-clickChart-cited;" + ii + "' toolText='" + ii + " 전체 : " + val + "'/>");
        }
        xml.append("</dataset >");

        xml.append("<styles>");
        xml.append("    <definition>");
        xml.append("        <style name='CaptionFont' type='font' size='12'/>");
        xml.append("   </definition>");
        xml.append("    <application>");
        xml.append("       <apply toObject='CAPTION' styles='CaptionFont' />");
        xml.append("       <apply toObject='SUBCAPTION' styles='CaptionFont' />");
        xml.append("    </application>");
        xml.append(" </styles>");

        xml.append("</chart>");

        return xml.toString();
    }

    public static String buildTechtransCoChartDispEng (List < AnalysisVo > list, RimsSearchVo searchVo, String
            contextPath){

        String techTransrCd = searchVo.getTechTransrCd();
        String fromYear = searchVo.getFromYear();
        String toYear = searchVo.getToYear();

        String caption = "Tech-Trans by year from " + fromYear + " to " + toYear;
        StringBuffer xml = new StringBuffer();

        xml.append("<chart ")
                .append(" caption='" + caption + "' ")
                .append(" subcaption='' ")
                .append(" baseFontColor='#666666' ")
                .append(" baseFontSize='11' ")
                .append(" subcaptionFontBold='0' ")
                .append(" canvasBgAlpha='0' ")
                .append(" showValues='0' ")
                .append(" paletteColors='" + paletteColors + "' ")
                .append(" bgAlpha='0' ")
                .append(" showBorder='0' ")
                .append(" showShadow='0' ")
                .append(" showAlternateHGridColor='0' ")
                .append(" showCanvasBorder='0' ")
                .append(" showXAxisLine='1' ")
                .append(" xAxisLineThickness='1' ")
                .append(" xAxisLineColor='#cdcdcd' ")
                .append(" xAxisNameFontColor='#8d8d8d' ")
                .append(" yAxisNameFontColor='#8d8d8d' ")
                .append(" canvasBgColor='#ffffff' ")
                .append(" lineThickness='4' ")
                .append(" legendBgColor='#ffffff' ")
                .append(" legendBgAlpha='100' ")
                .append(" legendBorderAlpha='50' ")
                .append(" legendBorderColor='#888888' ")
                .append(" legendShadow='0' ")
                .append(" legendPosition='CENTER' ")
                .append(" divlineAlpha='0' ")
                .append(" numDivLines='10' ")
                .append(" divlineColor='#999999' ")
                .append(" divlineThickness='1' ")
                .append(" divLineIsDashed='1'")
                .append(" divLineDashLen='1'")
                .append(" divLineGapLen='1' ")
                .append(" toolTipColor='#ffffff' ")
                .append(" toolTipBorderColor='#ffffff' ")
                .append(" toolTipBorderThickness='1' ")
                .append(" toolTipBgColor='#000000' ")
                .append(" toolTipBgAlpha='80' ")
                .append(" toolTipBorderRadius='4' ")
                .append(" toolTipPadding='10' ")
                .append(" toolTipFontSize ='20' ")
                .append(" anchorBgColor='#ffffff' ")
                .append(" anchorRadius='5' ")
                .append(" anchorBorderThickness='3' ")
                .append(" anchorTrackingRadius='15' ")
                .append(" showHoverEffect='1' ")
                .append(" formatNumberScale='0'")
                .append(" labelDisplay='rotate' ")
                .append(" slantLabels='1' ")
                .append(" exportEnabled='1' ")
                .append(" exportAtClient='0' ")
                .append(" exportAction='save' ")
                .append(" exportShowMenuItem='0' ")
                .append(" exportDialogMessage='Building chart output' ")
                .append(" exportHandler='" + contextPath + "/servlet/FCExporter/export.do' exportCallBack='myFN' ")
                .append(" >");

		/*
		xml.append(" <chart caption='"+caption+"' subcaption='' lineThickness='3'  ")
		.append(" xaxisname='' pyaxisname='기술이전료(천원단위)' syaxisname='기술이전건수' ")
		.append(" showValues='0' showSum='1' formatNumberScale='0' anchorRadius='2' decimals='0' ")
		.append(" divLineAlpha='50' numvdivlines='5' divLineIsDashed='1' bgColor='F7F7F7, E9E9E9' ")
		.append(" exportEnabled='1' exportAtClient='0' exportAction='save' exportHandler='"+contextPath+"/servlet/FCExporter/export.do' exportCallBack='myFN' ")
		.append(" exportShowMenuItem='0' exportDialogMessage='Building chart output' ")
		.append(" useRoundEdges='1' legendPosition ='CENTER' >");
		*/

        int fy = Integer.parseInt(fromYear);
        int ty = Integer.parseInt(toYear);

        xml.append("<categories >");
        for (int ii = fy; ii <= ty; ii++) xml.append("<category label='" + ii + "' />");
        xml.append("</categories>");

        String keyField = "transYear";
        String transCoValField = "transCo";
        String rpmAmtValField = "rpmAmt";


        Map patentTransfrCo = convertObjectListToMapWithCompareValue(list, "techTransrCd", R2Constant.TECHTRANSR_PATENT_TRANSFR_CD, keyField, transCoValField);
        Map dvrOprtnCo = convertObjectListToMapWithCompareValue(list, "techTransrCd", R2Constant.TECHTRANSR_DVR_OPRTN_CD, keyField, transCoValField);
        Map cmercOprtnCo = convertObjectListToMapWithCompareValue(list, "techTransrCd", R2Constant.TECHTRANSR_CMERC_OPRTN_CD, keyField, transCoValField);
        Map knowHowCo = convertObjectListToMapWithCompareValue(list, "techTransrCd", R2Constant.TECHTRANSR_KNOW_HOW_CD, keyField, transCoValField);
        Map cnsutCo = convertObjectListToMapWithCompareValue(list, "techTransrCd", R2Constant.TECHTRANSR_CNSUT_CD, keyField, transCoValField);
        Map etcCo = convertObjectListToMapWithCompareValue(list, "techTransrCd", R2Constant.TECHTRANSR_ETC_CD, keyField, transCoValField);
        Map totTechtransCoMap = new HashMap();

        for (int ii = fy; ii <= ty; ii++) {
            Integer totTransCo = 0;
            if (patentTransfrCo.get(Integer.toString(ii)) != null)
                totTransCo += Integer.parseInt(patentTransfrCo.get(Integer.toString(ii)).toString());
            if (dvrOprtnCo.get(Integer.toString(ii)) != null)
                totTransCo += Integer.parseInt(dvrOprtnCo.get(Integer.toString(ii)).toString());
            if (cmercOprtnCo.get(Integer.toString(ii)) != null)
                totTransCo += Integer.parseInt(cmercOprtnCo.get(Integer.toString(ii)).toString());
            if (knowHowCo.get(Integer.toString(ii)) != null)
                totTransCo += Integer.parseInt(knowHowCo.get(Integer.toString(ii)).toString());
            if (cnsutCo.get(Integer.toString(ii)) != null)
                totTransCo += Integer.parseInt(cnsutCo.get(Integer.toString(ii)).toString());
            if (etcCo.get(Integer.toString(ii)) != null)
                totTransCo += Integer.parseInt(etcCo.get(Integer.toString(ii)).toString());
            totTechtransCoMap.put(Integer.toString(ii), totTransCo);
        }

        if (techTransrCd == null || "".equals(techTransrCd) || R2Constant.TECHTRANSR_PATENT_TRANSFR_CD.equals(techTransrCd)) {
            xml.append("<dataset seriesName='" + R2Constant.TECHTRANSR_PATENT_TRANSFR_ENG + "' color='EF187D' showValues='0' >");
            for (int ii = fy; ii <= ty; ii++) {
                Object val = patentTransfrCo.get(Integer.toString(ii));
                if (val == null)
                    xml.append("<set value='0'  toolText='" + ii + " " + R2Constant.TECHTRANSR_PATENT_TRANSFR_ENG + " : 0'/>");
                else
                    xml.append("<set value='" + val + "'  link='j-clickChart-cited;" + ii + "' toolText='" + ii + " " + R2Constant.TECHTRANSR_PATENT_TRANSFR_ENG + " : " + val + "'/>");
            }
            xml.append("</dataset>");
        }

        if (techTransrCd == null || "".equals(techTransrCd) || R2Constant.TECHTRANSR_DVR_OPRTN_CD.equals(techTransrCd)) {
            xml.append("<dataset seriesName='" + R2Constant.TECHTRANSR_DVR_OPRTN_ENG + "' color='F5A618' showValues='0' >");
            for (int ii = fy; ii <= ty; ii++) {
                Object val = dvrOprtnCo.get(Integer.toString(ii));
                if (val == null)
                    xml.append("<set value='0'  toolText='" + ii + " " + R2Constant.TECHTRANSR_DVR_OPRTN_ENG + " : 0'/>");
                else
                    xml.append("<set value='" + val + "' link='j-clickChart-cited;" + ii + "' toolText='" + ii + " " + R2Constant.TECHTRANSR_DVR_OPRTN_ENG + " : " + val + "'/>");
            }
            xml.append("</dataset>");
        }

        if (techTransrCd == null || "".equals(techTransrCd) || R2Constant.TECHTRANSR_CMERC_OPRTN_CD.equals(techTransrCd)) {
            xml.append("<dataset seriesName='" + R2Constant.TECHTRANSR_CMERC_OPRTN_ENG + "' color='1A4991' showValues='0' >");
            for (int ii = fy; ii <= ty; ii++) {
                Object val = cmercOprtnCo.get(Integer.toString(ii));
                if (val == null)
                    xml.append("<set value='0' toolText='" + ii + " " + R2Constant.TECHTRANSR_CMERC_OPRTN_ENG + " : 0'/>");
                else
                    xml.append("<set value='" + val + "'  link='j-clickChart-cited;" + ii + "' toolText='" + ii + " " + R2Constant.TECHTRANSR_CMERC_OPRTN_ENG + " : " + val + "'/>");
            }
            xml.append("</dataset>");
        }

        if (techTransrCd == null || "".equals(techTransrCd) || R2Constant.TECHTRANSR_KNOW_HOW_CD.equals(techTransrCd)) {
            xml.append("<dataset seriesName='" + R2Constant.TECHTRANSR_KNOW_HOW_ENG + "' color='008E8E' showValues='0' >");
            for (int ii = fy; ii <= ty; ii++) {
                Object val = knowHowCo.get(Integer.toString(ii));
                if (val == null)
                    xml.append("<set value='0' toolText='" + ii + " " + R2Constant.TECHTRANSR_KNOW_HOW_ENG + " : 0'/>");
                else
                    xml.append("<set value='" + val + "' link='j-clickChart-cited;" + ii + "' toolText='" + ii + " " + R2Constant.TECHTRANSR_KNOW_HOW_ENG + " : " + val + "'/>");
            }
            xml.append("</dataset>");
        }

        if (techTransrCd == null || "".equals(techTransrCd) || R2Constant.TECHTRANSR_CNSUT_CD.equals(techTransrCd)) {
            xml.append("<dataset seriesName='" + R2Constant.TECHTRANSR_CNSUT_ENG + "' color='CC6600' showValues='0' >");
            for (int ii = fy; ii <= ty; ii++) {
                Object val = cnsutCo.get(Integer.toString(ii));
                if (val == null)
                    xml.append("<set value='0' toolText='" + ii + " " + R2Constant.TECHTRANSR_CNSUT_ENG + " : 0'/>");
                else
                    xml.append("<set value='" + val + "' link='j-clickChart-cited;" + ii + "' toolText='" + ii + " " + R2Constant.TECHTRANSR_CNSUT_ENG + " : " + val + "'/>");
            }
            xml.append("</dataset>");
        }

        if (techTransrCd == null || "".equals(techTransrCd) || R2Constant.TECHTRANSR_ETC_CD.equals(techTransrCd)) {
            xml.append("<dataset seriesName='" + R2Constant.TECHTRANSR_ETC_ENG + "' color='663300' showValues='0' >");
            for (int ii = fy; ii <= ty; ii++) {
                Object val = etcCo.get(Integer.toString(ii));
                if (val == null)
                    xml.append("<set value='0' toolText='" + ii + " " + R2Constant.TECHTRANSR_ETC_ENG + " : 0'/>");
                else
                    xml.append("<set value='" + val + "' link='j-clickChart-cited;" + ii + "' toolText='" + ii + " " + R2Constant.TECHTRANSR_ETC_ENG + " : " + val + "'/>");
            }
            xml.append("</dataset>");
        }

        xml.append("<dataset  seriesName='Total' color='B3AA00' showValues='0'  linethickness='4' >");
        for (int ii = fy; ii <= ty; ii++) {
            Object val = totTechtransCoMap.get(Integer.toString(ii));
            if (val == null)
                xml.append("<set value='0'  toolText='" + ii + " Total : 0'/>");
            else
                xml.append("<set value='" + val + "' link='j-clickChart-cited;" + ii + "' toolText='" + ii + " Total : " + val + "'/>");
        }
        xml.append("</dataset >");

        xml.append("<styles>");
        xml.append("    <definition>");
        xml.append("        <style name='CaptionFont' type='font' size='12'/>");
        xml.append("   </definition>");
        xml.append("    <application>");
        xml.append("       <apply toObject='CAPTION' styles='CaptionFont' />");
        xml.append("       <apply toObject='SUBCAPTION' styles='CaptionFont' />");
        xml.append("    </application>");
        xml.append(" </styles>");

        xml.append("</chart>");

        return xml.toString();
    }


    public static String buildLogStatsByMenuChartXml (List <CodeVo> menus, List <AnalysisLogVo> stats, String
            contextPath){
        StringBuffer xml = new StringBuffer();
        int i = 0;
		/*
		xml.append("<chart animation='0' caption='' xAxisName='' yAxisName='Click Count' showValues='1' decimals='0' formatNumberScale='0' ")
		//.append("divLineAlpha='20' divLineColor='CC3300' divLineIsDashed='1' showAlternateHGridColor='1' alternateHGridColor='CC3300' ")
		//.append("shadowAlpha='40' labelStep='1' numvdivlines='5' bgColor='FFFFFF,CC3300' bgAngle='270' bgAlpha='10,10' ")
		.append(" divLineAlpha='30' numvdivlines='5' divLineIsDashed='1' bgColor='F7F7F7, E9E9E9' ")
		//.append("PYAxisName='Accumulate' SYAxisName='Average' labelDisplay='Stagger' labelStep='4' ")
	    .append(" exportEnabled='1' exportAtClient='0' exportAction='save' exportHandler='"+contextPath+"/servlet/FCExporter/export.do' exportCallBack='myFN' ")
		.append(" exportShowMenuItem='0' exportDialogMessage='Building chart output ' ")
		.append(" useRoundEdges='1' labelDisplay='ROTATE' slantLabels='1' legendPosition ='CENTER' >");
		*/
        xml.append("<chart ")
                .append(" plotBorderColor='#ffffff' ") //bar 테두리없애기
                .append(" usePlotGradientColor='0' ") //bar의 그라데이션 없애기
                .append(" caption='' ")
                .append(" subcaption='' ")
                .append(" baseFontColor='#666666' ")
                .append(" baseFontSize='11' ")
                .append(" subcaptionFontBold='0' ")
                .append(" canvasBgAlpha='0' ")
                .append(" showValues='0' ")
                .append(" paletteColors='" + paletteColors + "' ")
                .append(" bgAlpha='0' ")
                .append(" showBorder='0' ")
                .append(" showShadow='0' ")
                .append(" showAlternateHGridColor='0' ")
                .append(" showCanvasBorder='0' ")
                .append(" showXAxisLine='1' ")
                .append(" xAxisName='' ")
                .append(" xAxisLineThickness='1' ")
                .append(" xAxisLineColor='#cdcdcd' ")
                .append(" xAxisNameFontColor='#8d8d8d' ")
                .append(" yAxisName='Click Count' ")
                .append(" yAxisNameFontColor='#8d8d8d' ")
                .append(" canvasBgColor='#ffffff' ")
                .append(" lineThickness='4' ")
                .append(" legendBgColor='#ffffff' ")
                .append(" legendBgAlpha='100' ")
                .append(" legendBorderAlpha='50' ")
                .append(" legendBorderColor='#888888' ")
                .append(" legendShadow='0' ")
                .append(" legendPosition='CENTER' ")
                .append(" divlineAlpha='0' ")
                .append(" numDivLines='10' ")
                .append(" divlineColor='#999999' ")
                .append(" divlineThickness='1' ")
                .append(" divLineIsDashed='1'")
                .append(" divLineDashLen='1'")
                .append(" divLineGapLen='1' ")
                .append(" toolTipColor='#ffffff' ")
                .append(" toolTipBorderColor='#ffffff' ")
                .append(" toolTipBorderThickness='1' ")
                .append(" toolTipBgColor='#000000' ")
                .append(" toolTipBgAlpha='80' ")
                .append(" toolTipBorderRadius='4' ")
                .append(" toolTipPadding='10' ")
                .append(" toolTipFontSize ='20' ")
                .append(" anchorBgColor='#ffffff' ")
                .append(" anchorRadius='5' ")
                .append(" anchorBorderThickness='3' ")
                .append(" anchorTrackingRadius='15' ")
                .append(" showHoverEffect='1' ")
                .append(" formatNumberScale='0'")
                .append(" labelDisplay='rotate' ")
                .append(" slantLabels='1' ")
                .append(" exportEnabled='1' ")
                .append(" exportAtClient='0' ")
                .append(" exportAction='save' ")
                .append(" exportShowMenuItem='0' ")
                .append(" exportDialogMessage='Building chart output' ")
                .append(" exportHandler='" + contextPath + "/servlet/FCExporter/export.do' exportCallBack='myFN' ")
                .append(" >");


        for (CodeVo m : menus) {
            Object val = null;
            for (AnalysisLogVo s : stats) {
                if (s.getMenuKey().equals(m.getCodeValue())) {
                    val = s.getClickCo();
                }
            }
            if (val == null) val = "0";
            String tText = m.getCodeDisp().toString().trim() + " : " + val;
            xml.append("<set label='" + m.getCodeDisp().toString().trim() + "' value='" + val + "'  toolText='" + tText + "' />");
        }

        xml.append("<styles>");
        xml.append("    <definition>");
        xml.append("        <style name='myLabelsFont' type='font' font='Malgun Gothic' size='12' bold='1' />");
        xml.append("        <style name='CaptionFont' type='font' size='12'/>");
        xml.append("   </definition>");
        xml.append("    <application>");
        xml.append("       <apply toObject='CAPTION' styles='CaptionFont' />");
        xml.append("       <apply toObject='SUBCAPTION' styles='CaptionFont' />");
        xml.append("       <apply toObject='DataLabels' styles='myLabelsFont' />");
        xml.append("    </application>");
        xml.append(" </styles>");

        xml.append("</chart>");

        return xml.toString();
    }


    public static String buildLogStatsByDateChartXml
            (List < AnalysisLogVo > regYmList, List < AnalysisLogVo > stats, String contextPath){

        //String caption = "Publications by year from "+fromYear+ " to " + toYear;
        StringBuffer xml = new StringBuffer();
		/*
		xml.append("<chart animation='0' caption='' subcaption='' lineThickness='2' showValues='0' formatNumberScale='0' showLegend='1' ")
		//.append("divLineAlpha='20' divLineColor='CC3300' divLineIsDashed='1' showAlternateHGridColor='1' alternateHGridColor='CC3300' ")
		//.append("shadowAlpha='40' labelStep='1' numvdivlines='5' chartRightMargin='35' bgColor='FFFFFF,CC3300' bgAngle='270' bgAlpha='10,10' ")
		.append(" divLineAlpha='30' numvdivlines='5' divLineIsDashed='1' bgColor='F7F7F7, E9E9E9' ")
		.append(" exportEnabled='1' exportAtClient='0' exportAction='save' exportHandler='"+contextPath+"/servlet/FCExporter/export.do' exportCallBack='myFN' ")
		.append(" exportShowMenuItem='0' exportDialogMessage='Building chart output ' ")
		.append(" legendPosition ='CENTER' >");
		*/
        xml.append("<chart ")
                .append(" plotBorderColor='#ffffff' ") //bar 테두리없애기
                .append(" usePlotGradientColor='0' ") //bar의 그라데이션 없애기
                .append(" caption='' ")
                .append(" subcaption='' ")
                .append(" baseFontColor='#666666' ")
                .append(" baseFontSize='11' ")
                .append(" subcaptionFontBold='0' ")
                .append(" canvasBgAlpha='0' ")
                .append(" showValues='0' ")
                .append(" paletteColors='" + paletteColors + "' ")
                .append(" bgAlpha='0' ")
                .append(" showBorder='0' ")
                .append(" showShadow='0' ")
                .append(" showAlternateHGridColor='0' ")
                .append(" showCanvasBorder='0' ")
                .append(" showXAxisLine='1' ")
                .append(" xAxisName='' ")
                .append(" xAxisLineThickness='1' ")
                .append(" xAxisLineColor='#cdcdcd' ")
                .append(" xAxisNameFontColor='#8d8d8d' ")
                .append(" yAxisName='' ")
                .append(" yAxisNameFontColor='#8d8d8d' ")
                .append(" canvasBgColor='#ffffff' ")
                .append(" lineThickness='4' ")
                .append(" legendBgColor='#ffffff' ")
                .append(" legendBgAlpha='100' ")
                .append(" legendBorderAlpha='50' ")
                .append(" legendBorderColor='#888888' ")
                .append(" legendShadow='0' ")
                .append(" legendPosition='CENTER' ")
                .append(" divlineAlpha='0' ")
                .append(" numDivLines='10' ")
                .append(" divlineColor='#999999' ")
                .append(" divlineThickness='1' ")
                .append(" divLineIsDashed='1'")
                .append(" divLineDashLen='1'")
                .append(" divLineGapLen='1' ")
                .append(" toolTipColor='#ffffff' ")
                .append(" toolTipBorderColor='#ffffff' ")
                .append(" toolTipBorderThickness='1' ")
                .append(" toolTipBgColor='#000000' ")
                .append(" toolTipBgAlpha='80' ")
                .append(" toolTipBorderRadius='4' ")
                .append(" toolTipPadding='10' ")
                .append(" toolTipFontSize ='20' ")
                .append(" anchorBgColor='#ffffff' ")
                .append(" anchorRadius='5' ")
                .append(" anchorBorderThickness='3' ")
                .append(" anchorTrackingRadius='15' ")
                .append(" showHoverEffect='1' ")
                .append(" formatNumberScale='0'")
                .append(" labelDisplay='rotate' ")
                .append(" slantLabels='1' ")
                .append(" exportEnabled='1' ")
                .append(" exportAtClient='0' ")
                .append(" exportAction='save' ")
                .append(" exportShowMenuItem='0' ")
                .append(" exportDialogMessage='Building chart output' ")
                .append(" exportHandler='" + contextPath + "/servlet/FCExporter/export.do' exportCallBack='myFN' ")
                .append(" >");


        xml.append("<categories >");

        for (int i = (regYmList.size() - 1); i >= 0; i--) {
            AnalysisLogVo r = regYmList.get(i);
            for (AnalysisLogVo s : stats) {
                if (r.getRegym().equals(s.getRegym())) {
                    xml.append("<category label='" + r.getRegym() + "' />");
                }
            }
        }

        xml.append("</categories>");

        xml.append("<dataset seriesName='' color='" + fillColors[0] + "' anchorBorderColor='" + fillColors[0] + "' >");

        for (int i = regYmList.size() - 1; i >= 0; i--) {
            AnalysisLogVo r = regYmList.get(i);
            Integer val = null;
            for (AnalysisLogVo s : stats) {
                if (r.getRegym().equals(s.getRegym())) {
                    val = s.getClickCo();
                    String tText = r.getRegym() + " : " + val;
                    xml.append("<set value='" + val + "'  toolText='" + tText + "' />");
                }
            }
        }

        xml.append("</dataset>");

        xml.append("<styles>");
        xml.append("    <definition>");
        xml.append("        <style name='CaptionFont' type='font' size='12'/>");
        xml.append("   </definition>");
        xml.append("    <application>");
        xml.append("       <apply toObject='CAPTION' styles='CaptionFont' />");
        xml.append("       <apply toObject='SUBCAPTION' styles='CaptionFont' />");
        xml.append("    </application>");
        xml.append(" </styles>");
        xml.append("</chart>");

        return xml.toString();

    }


    public static String buildFulltimeArtsChartXmlWithYear (List < AnalysisVo > fulltimeArticleList, String
            contextPath){
        String caption = "";
        StringBuffer xml = new StringBuffer();
		/*
		xml.append("<chart caption='"+caption+"' subcaption='' lineThickness='4' showValues='0' formatNumberScale='0' ")
		.append(" divLineAlpha='50' numvdivlines='5' divLineIsDashed='1' bgColor='F7F7F7, E9E9E9' ")
		.append(" exportEnabled='1' exportAtClient='0' exportAction='save' exportHandler='"+contextPath+"/servlet/FCExporter/export.do' exportCallBack='myFN' ")
		.append(" exportShowMenuItem='0' exportDialogMessage='Building chart output ' ")
		.append(" useRoundEdges='1' legendPosition ='CENTER' anchorradius='4'>");
		*/
        xml.append("<chart ")
                .append(" caption='" + caption + "' ")
                .append(" subcaption='' ")
                .append(" baseFontColor='#666666' ")
                .append(" baseFontSize='11' ")
                .append(" subcaptionFontBold='0' ")
                .append(" canvasBgAlpha='0' ")
                .append(" showValues='0' ")
                .append(" paletteColors='" + paletteColors + "' ")
                .append(" bgAlpha='0' ")
                .append(" showBorder='0' ")
                .append(" showShadow='0' ")
                .append(" showAlternateHGridColor='0' ")
                .append(" showCanvasBorder='0' ")
                .append(" showXAxisLine='1' ")
                .append(" xAxisName='' ")
                .append(" xAxisLineThickness='1' ")
                .append(" xAxisLineColor='#cdcdcd' ")
                .append(" xAxisNameFontColor='#8d8d8d' ")
                .append(" yAxisName='' ")
                .append(" yAxisNameFontColor='#8d8d8d' ")
                .append(" canvasBgColor='#ffffff' ")
                .append(" lineThickness='4' ")
                .append(" legendBgColor='#ffffff' ")
                .append(" legendBgAlpha='100' ")
                .append(" legendBorderAlpha='50' ")
                .append(" legendBorderColor='#888888' ")
                .append(" legendShadow='0' ")
                .append(" legendPosition='CENTER' ")
                .append(" divlineAlpha='0' ")
                .append(" numDivLines='10' ")
                .append(" divlineColor='#999999' ")
                .append(" divlineThickness='1' ")
                .append(" divLineIsDashed='1'")
                .append(" divLineDashLen='1'")
                .append(" divLineGapLen='1' ")
                .append(" toolTipColor='#ffffff' ")
                .append(" toolTipBorderColor='#ffffff' ")
                .append(" toolTipBorderThickness='1' ")
                .append(" toolTipBgColor='#000000' ")
                .append(" toolTipBgAlpha='80' ")
                .append(" toolTipBorderRadius='4' ")
                .append(" toolTipPadding='10' ")
                .append(" toolTipFontSize ='20' ")
                .append(" anchorBgColor='#ffffff' ")
                .append(" anchorRadius='5' ")
                .append(" anchorBorderThickness='3' ")
                .append(" anchorTrackingRadius='15' ")
                .append(" showHoverEffect='1' ")
                .append(" formatNumberScale='0'")
                .append(" labelDisplay='rotate' ")
                .append(" slantLabels='1' ")
                .append(" exportEnabled='1' ")
                .append(" exportAtClient='0' ")
                .append(" exportAction='save' ")
                .append(" exportShowMenuItem='0' ")
                .append(" exportDialogMessage='Building chart output' ")
                .append(" exportHandler='" + contextPath + "/servlet/FCExporter/export.do' exportCallBack='myFN' ")
                .append(" >");

        String fromYear = "";
        String toYear = "";

        int i = 1;
        for (AnalysisVo article : fulltimeArticleList) {
            if (i == 1) fromYear = article.getPubYear();
            if (i == fulltimeArticleList.size()) toYear = article.getPubYear();
            i++;
        }

        int fy = Integer.parseInt(fromYear);
        int ty = Integer.parseInt(toYear);

        xml.append("<categories >");
        for (int ii = fy; ii <= ty; ii++) {
            xml.append("<category label='" + ii + "' />");
        }
        xml.append("</categories>");

        Map yearSCIMap = convertObjectListToMap(fulltimeArticleList, "pubYear", "intrlJnalArtsCo");
        Map yearGenMap = convertObjectListToMap(fulltimeArticleList, "pubYear", "intrlGnalArtsCo");
        Map yearKCIMap = convertObjectListToMap(fulltimeArticleList, "pubYear", "dmstcKciArtsCo");
        Map yearDMSTMap = convertObjectListToMap(fulltimeArticleList, "pubYear", "dmstcGnalArtsCo");
        Map yearOthersMap = convertObjectListToMap(fulltimeArticleList, "pubYear", "othersArtsCo");
        //Map yearCitMap = convertListToMap(arts, "IS_YEAR", "NO_CIT");

        //not citated publications dataset
        xml.append("<dataset seriesName='SCI급 논문(SCI+SCOPUS)' color='#d8324e'>");
        for (int ii = fy; ii <= ty; ii++) {
            Object val = yearSCIMap.get(Integer.toString(ii).trim());
            if (val == null) {
                xml.append("<set value='0' toolText='0'/>");
            } else {
                Integer noArts = Integer.parseInt(val.toString().trim().replaceAll(",", ""));
                xml.append("<set value='" + noArts + "'  toolText='" + val.toString().trim() + "'/>");
            }
        }
        xml.append("</dataset>");

        //no publications dataset
        xml.append("<dataset seriesName='국제일반' >");
        for (int ii = fy; ii <= ty; ii++) {
            Object val = yearGenMap.get(Integer.toString(ii).trim());
            if (val == null)
                xml.append("<set value='0' toolText='0'/>");
            else
                xml.append("<set value='" + val.toString().trim() + "' toolText='" + val.toString().trim() + "' />");
        }
        xml.append("</dataset>");

        xml.append("<dataset seriesName='국내KCI급 논문' >");
        for (int ii = fy; ii <= ty; ii++) {
            Object val = yearKCIMap.get(Integer.toString(ii).trim());
            if (val == null)
                xml.append("<set value='0' toolText='0'/>");
            else
                xml.append("<set value='" + val.toString().trim() + "' toolText='" + val.toString().trim() + "' />");
        }
        xml.append("</dataset>");

        xml.append("<dataset seriesName='국내일반' >");
        for (int ii = fy; ii <= ty; ii++) {
            Object val = yearDMSTMap.get(Integer.toString(ii).trim());
            if (val == null)
                xml.append("<set value='0' toolText='0'/>");
            else
                xml.append("<set value='" + val.toString().trim() + "' toolText='" + val.toString().trim() + "' />");
        }
        xml.append("</dataset>");

        xml.append("<dataset seriesName='기타' >");
        for (int ii = fy; ii <= ty; ii++) {
            Object val = yearOthersMap.get(Integer.toString(ii).trim());
            if (val == null)
                xml.append("<set value='0' toolText='0'/>");
            else
                xml.append("<set value='" + val.toString().trim() + "' toolText='" + val.toString().trim() + "' />");
        }
        xml.append("</dataset>");

        xml.append("<trendlines>");
        xml.append("<style name='CanvasAnim' type='animation' param='_xScale' start='0' duration='1' />");
        xml.append("</trendlines>");
        xml.append("<styles>");
        xml.append("    <definition>");
        xml.append("        <style name='CaptionFont' type='font' size='12'/>");
        xml.append("        <style name='myBevel' type='bevel' distance='2' />");
        xml.append("   </definition>");
        xml.append("    <application>");
        xml.append("       <apply toObject='CAPTION' styles='CaptionFont' />");
        xml.append("       <apply toObject='SUBCAPTION' styles='CaptionFont' />");
        xml.append("       <apply toObject='ANCHORS' styles='myBevel' /> ");
        xml.append("    </application>");
        xml.append(" </styles>");

        xml.append("</chart>");

        return xml.toString();
    }

    /**
     * <pre>
     *  1. 개   요 : Make chart xml for full time sci data
     *  2. 처리내용 :
     * </pre>
     *  @Method Name : buildFulltimeSciArtsChartXmlWithYear
     *  @param sciList
     *  @param contextPath
     *  @return
     */
    public static String buildFulltimeSciArtsChartXmlWithYear (List < AnalysisVo > sciList, String contextPath){
        String caption = "";
        StringBuffer xml = new StringBuffer();
		/*
		xml.append("<chart caption='"+caption+"' subcaption='' lineThickness='3' showValues='0' formatNumberScale='0' animation='0'")
		//.append("divLineAlpha='20' divLineColor='CC3300' divLineIsDashed='1' showAlternateHGridColor='1' alternateHGridColor='CC3300' ")
		//.append("shadowAlpha='40' labelStep='1' numvdivlines='5' chartRightMargin='35' bgColor='FFFFFF,BBBBBB' bgAngle='270' bgAlpha='10,10' ")
		.append(" PYAxisName='논문수' SYAxisName='교원1인당 평균 논문수' slantLabels='1' ")
		.append(" divLineAlpha='50' numvdivlines='5' divLineIsDashed='1' bgColor='F7F7F7, E9E9E9' ")
		.append(" exportEnabled='1' exportAtClient='0' exportAction='save' exportHandler='"+contextPath+"/servlet/FCExporter/export.do' exportCallBack='myFN_ART' ")
		.append(" exportShowMenuItem='0' exportDialogMessage='Building chart output ' ")
		.append(" useRoundEdges='1' legendPosition ='CENTER' anchorradius='4'>");
		*/
        xml.append("<chart ")
                .append(" caption='' ")
                .append(" subcaption='' ")
                .append(" baseFontColor='#666666' ")
                .append(" baseFontSize='11' ")
                .append(" subcaptionFontBold='0' ")
                .append(" canvasBgAlpha='0' ")
                .append(" showValues='0' ")
                .append(" paletteColors='" + paletteColors + "' ")
                .append(" bgAlpha='0' ")
                .append(" showBorder='0' ")
                .append(" showShadow='0' ")
                .append(" showAlternateHGridColor='0' ")
                .append(" showCanvasBorder='0' ")
                .append(" showXAxisLine='1' ")
                .append(" PYAxisName='논문수' ")
                .append(" SYAxisName='교원1인당 평균 논문수' ")
                .append(" xAxisName='' ")
                .append(" xAxisLineThickness='1' ")
                .append(" xAxisLineColor='#cdcdcd' ")
                .append(" xAxisNameFontColor='#8d8d8d' ")
                .append(" yAxisName='' ")
                .append(" yAxisNameFontColor='#8d8d8d' ")
                .append(" canvasBgColor='#ffffff' ")
                .append(" lineThickness='4' ")
                .append(" legendBgColor='#ffffff' ")
                .append(" legendBgAlpha='100' ")
                .append(" legendBorderAlpha='50' ")
                .append(" legendBorderColor='#888888' ")
                .append(" legendShadow='0' ")
                .append(" legendPosition='CENTER' ")
                .append(" divlineAlpha='0' ")
                .append(" numDivLines='10' ")
                .append(" divlineColor='#999999' ")
                .append(" divlineThickness='1' ")
                .append(" divLineIsDashed='1'")
                .append(" divLineDashLen='1'")
                .append(" divLineGapLen='1' ")
                .append(" toolTipColor='#ffffff' ")
                .append(" toolTipBorderColor='#ffffff' ")
                .append(" toolTipBorderThickness='1' ")
                .append(" toolTipBgColor='#000000' ")
                .append(" toolTipBgAlpha='80' ")
                .append(" toolTipBorderRadius='4' ")
                .append(" toolTipPadding='10' ")
                .append(" toolTipFontSize ='20' ")
                .append(" anchorBgColor='#ffffff' ")
                .append(" anchorRadius='5' ")
                .append(" anchorBorderThickness='3' ")
                .append(" anchorTrackingRadius='15' ")
                .append(" showHoverEffect='1' ")
                .append(" formatNumberScale='0'")
                .append(" labelDisplay='rotate' ")
                .append(" slantLabels='1' ")
                .append(" plotBorderColor='#ffffff' ") //bar 테두리없애기
                .append(" usePlotGradientColor='0' ") //bar의 그라데이션 없애기
                .append(" exportEnabled='1' ")
                .append(" exportAtClient='0' ")
                .append(" exportAction='save' ")
                .append(" exportShowMenuItem='0' ")
                .append(" exportDialogMessage='Building chart output' ")
                .append(" exportHandler='" + contextPath + "/servlet/FCExporter/export.do' exportCallBack='myFN_ART' ")
                .append(" >");

        String fromYear = "";
        String toYear = "";

        int i = 1;
        for (AnalysisVo sci : sciList) {
            if (i == 1) fromYear = sci.getPubYear();
            if (i == sciList.size()) toYear = sci.getPubYear();
            i++;
        }
        int fy = Integer.parseInt(fromYear);
        int ty = Integer.parseInt(toYear);

        xml.append("<categories >");
        for (int ii = fy; ii <= ty; ii++) {
            xml.append("<category label='" + ii + "' />");
        }
        xml.append("</categories>");


        Map yearRCntMap = convertObjectListToMap(sciList, "pubYear", "rsrchCo");
        Map yearNoArtsMap = convertObjectListToMap(sciList, "pubYear", "artsTotal");
        Map yearNoArtsPerResercherMap = convertObjectListToMap(sciList, "pubYear", "artsAvrg");

        //not citated publications dataset
        xml.append("<dataset seriesName='논문수' parentYAxis='P' color='1aa1b5'>");
        for (int ii = fy; ii <= ty; ii++) {
            Object val = yearNoArtsMap.get(Integer.toString(ii).trim());
            if (val == null) {
                xml.append("<set value='0' toolText='0'/>");
            } else {
                Integer noArts = Integer.parseInt(val.toString().trim().replaceAll(",", ""));
                xml.append("<set value='" + noArts + "'  toolText='" + val.toString().trim() + "'/>");
            }
        }
        xml.append("</dataset>");

        //no publications dataset
        xml.append("<dataset seriesName='교원1인당 평균 논문수' showValues='1' parentYAxis='S' renderAs='Line' lineThickness='5' color='FF7800'>");
        for (int ii = fy; ii <= ty; ii++) {
            Object val = yearNoArtsPerResercherMap.get(Integer.toString(ii).trim());
            if (val == null)
                xml.append("<set value='0' toolText='0'/>");
            else
                xml.append("<set value='" + val.toString().trim() + "' toolText='" + String.format("%.2f", val) + "' />");
        }
        xml.append("</dataset>");

        xml.append("<trendlines>");
        xml.append("<style name='CanvasAnim' type='animation' param='_xScale' start='0' duration='1' />");
        xml.append("</trendlines>");
        xml.append("<styles>");
        xml.append("    <definition>");
        xml.append("        <style name='CaptionFont' type='font' size='12'/>");
        xml.append("        <style name='myBevel' type='bevel' distance='2' />");
        xml.append("   </definition>");
        xml.append("    <application>");
        xml.append("       <apply toObject='CAPTION' styles='CaptionFont' />");
        xml.append("       <apply toObject='SUBCAPTION' styles='CaptionFont' />");
        xml.append("       <apply toObject='ANCHORS' styles='myBevel' /> ");
        xml.append("    </application>");
        xml.append(" </styles>");

        xml.append("</chart>");

        return xml.toString();
    }

    /**
     * <pre>
     *  1. 개   요 : Make chart xml for full time researcher citation chart
     *  2. 처리내용 :
     * </pre>
     *  @Method Name : buildFulltimeSciCitationChartXmlWithYear
     *  @param sciList
     *  @param contextPath
     *  @return
     */
    public static String buildFulltimeSciCitationChartXmlWithYear (List < AnalysisVo > sciList, String contextPath){
        String caption = "";
        StringBuffer xml = new StringBuffer();
		/*
		xml.append("<chart caption='"+caption+"' subcaption='' lineThickness='3' showValues='0' formatNumberScale='0' animation='0' ")
		//.append("divLineAlpha='20' divLineColor='CC3300' divLineIsDashed='1' showAlternateHGridColor='1' alternateHGridColor='CC3300' ")
		//.append("shadowAlpha='40' labelStep='1' numvdivlines='5' chartRightMargin='35' bgColor='FFFFFF,BBBBBB' bgAngle='270' bgAlpha='10,10' ")
		.append(" PYAxisName='피인용수 합계' SYAxisName='논문당 평균 피인용횟수' slantLabels='1' ")
		.append(" divLineAlpha='50' numvdivlines='5' divLineIsDashed='1' bgColor='F7F7F7, E9E9E9' ")
		.append(" exportEnabled='1' exportAtClient='0' exportAction='save' exportHandler='"+contextPath+"/servlet/FCExporter/export.do' exportCallBack='myFN_TC' ")
		.append(" exportShowMenuItem='0' exportDialogMessage='Building chart output' ")
		.append(" useRoundEdges='1' legendPosition ='CENTER' anchorradius='4'>");
		*/
        xml.append("<chart ")
                .append(" caption='' ")
                .append(" subcaption='' ")
                .append(" baseFontColor='#666666' ")
                .append(" baseFontSize='11' ")
                .append(" subcaptionFontBold='0' ")
                .append(" canvasBgAlpha='0' ")
                .append(" showValues='0' ")
                .append(" paletteColors='" + paletteColors + "' ")
                .append(" bgAlpha='0' ")
                .append(" showBorder='0' ")
                .append(" showShadow='0' ")
                .append(" showAlternateHGridColor='0' ")
                .append(" showCanvasBorder='0' ")
                .append(" showXAxisLine='1' ")
                .append(" PYAxisName='피인용수 합계' ")
                .append(" SYAxisName='논문당 평균 피인용횟수' ")
                .append(" xAxisName='' ")
                .append(" xAxisLineThickness='1' ")
                .append(" xAxisLineColor='#cdcdcd' ")
                .append(" xAxisNameFontColor='#8d8d8d' ")
                .append(" yAxisName='' ")
                .append(" yAxisNameFontColor='#8d8d8d' ")
                .append(" canvasBgColor='#ffffff' ")
                .append(" lineThickness='4' ")
                .append(" legendBgColor='#ffffff' ")
                .append(" legendBgAlpha='100' ")
                .append(" legendBorderAlpha='50' ")
                .append(" legendBorderColor='#888888' ")
                .append(" legendShadow='0' ")
                .append(" legendPosition='CENTER' ")
                .append(" divlineAlpha='0' ")
                .append(" numDivLines='10' ")
                .append(" divlineColor='#999999' ")
                .append(" divlineThickness='1' ")
                .append(" divLineIsDashed='1'")
                .append(" divLineDashLen='1'")
                .append(" divLineGapLen='1' ")
                .append(" toolTipColor='#ffffff' ")
                .append(" toolTipBorderColor='#ffffff' ")
                .append(" toolTipBorderThickness='1' ")
                .append(" toolTipBgColor='#000000' ")
                .append(" toolTipBgAlpha='80' ")
                .append(" toolTipBorderRadius='4' ")
                .append(" toolTipPadding='10' ")
                .append(" toolTipFontSize ='20' ")
                .append(" anchorBgColor='#ffffff' ")
                .append(" anchorRadius='5' ")
                .append(" anchorBorderThickness='3' ")
                .append(" anchorTrackingRadius='15' ")
                .append(" showHoverEffect='1' ")
                .append(" formatNumberScale='0'")
                .append(" labelDisplay='rotate' ")
                .append(" slantLabels='1' ")
                .append(" plotBorderColor='#ffffff' ") //bar 테두리없애기
                .append(" usePlotGradientColor='0' ") //bar의 그라데이션 없애기
                .append(" exportEnabled='1' ")
                .append(" exportAtClient='0' ")
                .append(" exportAction='save' ")
                .append(" exportShowMenuItem='0' ")
                .append(" exportDialogMessage='Building chart output' ")
                .append(" exportHandler='" + contextPath + "/servlet/FCExporter/export.do' exportCallBack='myFN_TC' ")
                .append(" >");

        String fromYear = "";
        String toYear = "";

        int i = 1;
        for (AnalysisVo sci : sciList) {
            if (i == 1) fromYear = sci.getPubYear();
            if (i == sciList.size()) toYear = sci.getPubYear();
            i++;
        }
        int fy = Integer.parseInt(fromYear);
        int ty = Integer.parseInt(toYear);

        xml.append("<categories >");
        for (int ii = fy; ii <= ty; ii++) {
            xml.append("<category label='" + ii + "' />");

        }
        xml.append("</categories>");

        Map yearNoArtsMap = convertObjectListToMap(sciList, "pubYear", "artsTotal");
        Map yearSumTCMap = convertObjectListToMap(sciList, "pubYear", "citedSum");
        Map yearAvgTcMap = convertObjectListToMap(sciList, "pubYear", "citedAvrg");

        //not citated publications dataset
        xml.append("<dataset seriesName='피인용수 합계' parentYAxis='P' color='2dcdb1'>");
        for (int ii = fy; ii <= ty; ii++) {
            Object val = yearSumTCMap.get(Integer.toString(ii).trim());
            if (val == null)
                xml.append("<set value='0' toolText='0'/>");
            else
                xml.append("<set value='" + val.toString().trim() + "' toolText='" + val.toString().trim() + "'/>");
        }
        xml.append("</dataset>");

        //no publications dataset
        xml.append("<dataset seriesName='논문당 평균 피인용횟수' parentYAxis='S' renderAs='Line' lineThickness='5' showValues='1' color='f9a11b'>");
        for (int ii = fy; ii <= ty; ii++) {
            Object val = yearAvgTcMap.get(Integer.toString(ii).trim());
            if (val == null)
                xml.append("<set value='0' toolText='0'/>");
            else
                xml.append("<set value='" + val.toString().trim() + "' toolText='" + String.format("%.2f", val) + "' />");
        }
        xml.append("</dataset>");

        xml.append("<trendlines>");
        xml.append("<style name='CanvasAnim' type='animation' param='_xScale' start='0' duration='1' />");
        xml.append("</trendlines>");
        xml.append("<styles>");
        xml.append("    <definition>");
        xml.append("        <style name='CaptionFont' type='font' size='12'/>");
        xml.append("        <style name='myBevel' type='bevel' distance='2' />");
        xml.append("   </definition>");
        xml.append("    <application>");
        xml.append("       <apply toObject='CAPTION' styles='CaptionFont' />");
        xml.append("       <apply toObject='SUBCAPTION' styles='CaptionFont' />");
        xml.append("       <apply toObject='ANCHORS' styles='myBevel' /> ");
        xml.append("    </application>");
        xml.append(" </styles>");

        xml.append("</chart>");

        return xml.toString();
    }


    /**
     * <pre>
     *  1. 개   요 : Make chart xml for full time researcher Impact factor by year
     *  2. 처리내용 :
     * </pre>
     *  @Method Name : buildFulltimeSciIFChartXmlWithYear
     *  @param sciList
     *  @param contextPath
     *  @return
     */
    public static String buildFulltimeSciIFChartXmlWithYear (List < AnalysisVo > sciList, String contextPath){
        String caption = "";
        StringBuffer xml = new StringBuffer();
		/*
		xml.append("<chart caption='"+caption+"' subcaption='' lineThickness='3' showValues='0' formatNumberScale='0' animation='0' ")
		//.append("divLineAlpha='20' divLineColor='CC3300' divLineIsDashed='1' showAlternateHGridColor='1' alternateHGridColor='CC3300' ")
		//.append("shadowAlpha='40' labelStep='1' numvdivlines='5' chartRightMargin='35' bgColor='FFFFFF,BBBBBB' bgAngle='270' bgAlpha='10,10' ")
		.append(" PYAxisName='Imact Factor 합계' SYAxisName='교원1인당 Impact Factor 평균' slantLabels='1' ")
		.append(" divLineAlpha='50' numvdivlines='5' divLineIsDashed='1' bgColor='F7F7F7, E9E9E9' ")
		.append(" exportEnabled='1' exportAtClient='0' exportAction='save' exportHandler='"+contextPath+"/servlet/FCExporter/export.do' exportCallBack='myFN_IF' ")
		.append(" exportShowMenuItem='0' exportDialogMessage='Building chart output' ")
		.append(" useRoundEdges='1' legendPosition ='CENTER' anchorradius='4' >");
		*/
        xml.append("<chart ")
                .append(" caption='' ")
                .append(" subcaption='' ")
                .append(" baseFontColor='#666666' ")
                .append(" baseFontSize='11' ")
                .append(" subcaptionFontBold='0' ")
                .append(" canvasBgAlpha='0' ")
                .append(" showValues='0' ")
                .append(" paletteColors='" + paletteColors + "' ")
                .append(" bgAlpha='0' ")
                .append(" showBorder='0' ")
                .append(" showShadow='0' ")
                .append(" showAlternateHGridColor='0' ")
                .append(" showCanvasBorder='0' ")
                .append(" showXAxisLine='1' ")
                .append(" PYAxisName='Imact Factor 합계' ")
                .append(" SYAxisName='교원1인당 Impact Factor 평균' ")
                .append(" xAxisName='' ")
                .append(" xAxisLineThickness='1' ")
                .append(" xAxisLineColor='#cdcdcd' ")
                .append(" xAxisNameFontColor='#8d8d8d' ")
                .append(" yAxisName='' ")
                .append(" yAxisNameFontColor='#8d8d8d' ")
                .append(" canvasBgColor='#ffffff' ")
                .append(" lineThickness='4' ")
                .append(" legendBgColor='#ffffff' ")
                .append(" legendBgAlpha='100' ")
                .append(" legendBorderAlpha='50' ")
                .append(" legendBorderColor='#888888' ")
                .append(" legendShadow='0' ")
                .append(" legendPosition='CENTER' ")
                .append(" divlineAlpha='0' ")
                .append(" numDivLines='10' ")
                .append(" divlineColor='#999999' ")
                .append(" divlineThickness='1' ")
                .append(" divLineIsDashed='1'")
                .append(" divLineDashLen='1'")
                .append(" divLineGapLen='1' ")
                .append(" toolTipColor='#ffffff' ")
                .append(" toolTipBorderColor='#ffffff' ")
                .append(" toolTipBorderThickness='1' ")
                .append(" toolTipBgColor='#000000' ")
                .append(" toolTipBgAlpha='80' ")
                .append(" toolTipBorderRadius='4' ")
                .append(" toolTipPadding='10' ")
                .append(" toolTipFontSize ='20' ")
                .append(" anchorBgColor='#ffffff' ")
                .append(" anchorRadius='5' ")
                .append(" anchorBorderThickness='3' ")
                .append(" anchorTrackingRadius='15' ")
                .append(" showHoverEffect='1' ")
                .append(" formatNumberScale='0'")
                .append(" labelDisplay='rotate' ")
                .append(" slantLabels='1' ")
                .append(" plotBorderColor='#ffffff' ") //bar 테두리없애기
                .append(" usePlotGradientColor='0' ") //bar의 그라데이션 없애기
                .append(" exportEnabled='1' ")
                .append(" exportAtClient='0' ")
                .append(" exportAction='save' ")
                .append(" exportShowMenuItem='0' ")
                .append(" exportDialogMessage='Building chart output' ")
                .append(" exportHandler='" + contextPath + "/servlet/FCExporter/export.do' exportCallBack='myFN_IF' ")
                .append(" >");

        String fromYear = "";
        String toYear = "";

        int i = 1;
        for (AnalysisVo sci : sciList) {
            if (i == 1) fromYear = sci.getPubYear();
            if (i == sciList.size()) toYear = sci.getPubYear();
            i++;
        }
        int fy = Integer.parseInt(fromYear);
        int ty = Integer.parseInt(toYear);

        xml.append("<categories >");
        for (int ii = fy; ii <= ty; ii++) {
            xml.append("<category label='" + ii + "' />");
        }
        xml.append("</categories>");


        Map yearSumIFMap = convertObjectListToMap(sciList, "pubYear", "impctFctrSum");
        Map yearAvgIFResearcherMap = convertObjectListToMap(sciList, "pubYear", "impctFctrAvrgByRsrch");
        Map yearAvgIFArticleMap = convertObjectListToMap(sciList, "pubYear", "impctFctrAvrg");

        //citated publications dataset
        xml.append("<dataset seriesName='Imact Factor 합계' color='2dcd6d'>");
        for (int ii = fy; ii <= ty; ii++) {
            Object val = yearSumIFMap.get(Integer.toString(ii).trim());
            if (val == null)
                xml.append("<set value='0'  toolText='0'/>");
            else
                xml.append("<set value='" + val.toString().trim() + "' toolText='" + val.toString().trim() + "'/>");
        }
        xml.append("</dataset>");

        //not citated publications dataset
        xml.append("<dataset seriesName='교원1인당 Impact Factor 평균' parentYAxis='S' showValues='1' renderAs='Line' lineThickness='5' color='fdc23e'>");
        for (int ii = fy; ii <= ty; ii++) {
            Object val = yearAvgIFResearcherMap.get(Integer.toString(ii).trim());
            if (val == null)
                xml.append("<set value='0' toolText='0'/>");
            else
                xml.append("<set value='" + val.toString().trim() + "' toolText='" + String.format("%.2f", val) + "'/>");
        }
        xml.append("</dataset>");

        xml.append("<trendlines>");
        xml.append("<style name='CanvasAnim' type='animation' param='_xScale' start='0' duration='1' />");
        xml.append("</trendlines>");
        xml.append("<styles>");
        xml.append("    <definition>");
        xml.append("        <style name='CaptionFont' type='font' size='12'/>");
        xml.append("        <style name='myBevel' type='bevel' distance='2' />");
        xml.append("   </definition>");
        xml.append("    <application>");
        xml.append("       <apply toObject='CAPTION' styles='CaptionFont' />");
        xml.append("       <apply toObject='SUBCAPTION' styles='CaptionFont' />");
        xml.append("       <apply toObject='ANCHORS' styles='myBevel' /> ");
        xml.append("    </application>");
        xml.append(" </styles>");

        xml.append("</chart>");

        return xml.toString();
    }


    public static String buildDifUnivCompareIFNoArtclChartXml (List < AnalysisVo > difUnivData, String contextPath){

        StringBuffer xml = new StringBuffer();
		/*
		xml.append("<chart animation='0' caption='' lineThickness='2' showValues='1' formatNumberScale='0' anchorRadius='4' ")
		//.append("divLineAlpha='20' divLineColor='CC3300' divLineIsDashed='1' showAlternateHGridColor='1' alternateHGridColor='CC3300' ")
		//.append("shadowAlpha='40' labelStep='1' numvdivlines='5' bgColor='FFFFFF,CC3300' bgAngle='270' bgAlpha='10,10' ")
		.append(" divLineAlpha='30' numvdivlines='5' divLineIsDashed='1' bgColor='F7F7F7, E9E9E9' ")
		.append(" PYAxisName='논문수' SYAxisName='교원수' slantLabels='1' labelDisplay='ROTATE' ")
		.append(" exportEnabled='1' exportAtClient='0' exportAction='save' exportHandler='"+contextPath+"/servlet/FCExporter/export.do' exportCallBack='myFN_ART' ")
		.append(" exportShowMenuItem='0' exportDialogMessage='Building chart output ' ")
		.append(" useRoundEdges='1' legendPosition ='CENTER '>");
		*/
        xml.append("<chart ")
                .append(" caption='' ")
                .append(" subcaption='' ")
                .append(" baseFontColor='#666666' ")
                .append(" baseFontSize='11' ")
                .append(" subcaptionFontBold='0' ")
                .append(" canvasBgAlpha='0' ")
                .append(" showValues='0' ")
                .append(" paletteColors='" + paletteColors + "' ")
                .append(" bgAlpha='0' ")
                .append(" showBorder='0' ")
                .append(" showShadow='0' ")
                .append(" showAlternateHGridColor='0' ")
                .append(" showCanvasBorder='0' ")
                .append(" showXAxisLine='1' ")
                .append(" PYAxisName='논문수' ")
                .append(" SYAxisName='교원수' ")
                .append(" xAxisName='' ")
                .append(" xAxisLineThickness='1' ")
                .append(" xAxisLineColor='#cdcdcd' ")
                .append(" xAxisNameFontColor='#8d8d8d' ")
                .append(" yAxisName='' ")
                .append(" yAxisNameFontColor='#8d8d8d' ")
                .append(" canvasBgColor='#ffffff' ")
                .append(" lineThickness='4' ")
                .append(" legendBgColor='#ffffff' ")
                .append(" legendBgAlpha='100' ")
                .append(" legendBorderAlpha='50' ")
                .append(" legendBorderColor='#888888' ")
                .append(" legendShadow='0' ")
                .append(" legendPosition='CENTER' ")
                .append(" divlineAlpha='100' ")
                .append(" numDivLines='10' ")
                .append(" divlineColor='#999999' ")
                .append(" divlineThickness='1' ")
                .append(" divLineIsDashed='1'")
                .append(" divLineDashLen='1'")
                .append(" divLineGapLen='1' ")
                .append(" toolTipColor='#ffffff' ")
                .append(" toolTipBorderColor='#ffffff' ")
                .append(" toolTipBorderThickness='1' ")
                .append(" toolTipBgColor='#000000' ")
                .append(" toolTipBgAlpha='80' ")
                .append(" toolTipBorderRadius='4' ")
                .append(" toolTipPadding='10' ")
                .append(" toolTipFontSize ='20' ")
                .append(" anchorBgColor='#ffffff' ")
                .append(" anchorRadius='5' ")
                .append(" anchorBorderThickness='3' ")
                .append(" anchorTrackingRadius='15' ")
                .append(" showHoverEffect='1' ")
                .append(" formatNumberScale='0'")
                .append(" labelDisplay='rotate' ")
                .append(" slantLabels='1' ")
                .append(" exportEnabled='1' ")
                .append(" exportAtClient='0' ")
                .append(" exportAction='save' ")
                .append(" exportShowMenuItem='0' ")
                .append(" exportDialogMessage='Building chart output' ")
                .append(" exportHandler='" + contextPath + "/servlet/FCExporter/export.do' exportCallBack='myFN_ART' ")
                .append(" >");


        xml.append("<categories >");

        for (AnalysisVo difUniv : difUnivData) {
            String univNm = difUniv.getUnivNm().trim();
            if (univNm.length() > 12) univNm = univNm.substring(0, 12);
            xml.append("<category label='" + univNm + "' />");
        }
        xml.append("</categories>");


        xml.append("<dataset seriesName='논문수' parentYAxis='P' color='D8324E' >");
        for (AnalysisVo difUniv : difUnivData) {
            Object val = difUniv.getCntArtcl();
            String tText = difUniv.getUnivNm().trim() + " 논문수 : " + val;
            xml.append("<set value='" + val + "'  toolText='" + tText + "' />");
        }
        xml.append("</dataset>");

        xml.append("<dataset seriesName='교원수' parentYAxis='S' renderAs='Column' color='948E8E'>");
        for (AnalysisVo difUniv : difUnivData) {
            Object val = difUniv.getCntRsrch();
            String tText = difUniv.getUnivNm().trim() + " 교원수 : " + val;
            xml.append("<set value='" + val + "'  toolText='" + tText + "' />");
        }
        xml.append("</dataset>");

        xml.append("<styles>");
        xml.append("    <definition>");
        xml.append("        <style name='myLabelsFont' type='font' font='Malgun Gothic' size='12' bold='1' />");
        xml.append("        <style name='CaptionFont' type='font' size='12'/>");
        xml.append("   </definition>");
        xml.append("    <application>");
        xml.append("       <apply toObject='CAPTION' styles='CaptionFont' />");
        xml.append("       <apply toObject='SUBCAPTION' styles='CaptionFont' />");
        xml.append("       <apply toObject='DataLabels' styles='myLabelsFont' />");
        xml.append("    </application>");
        xml.append(" </styles>");

        xml.append("</chart>");

        return xml.toString();

    }


    public static String buildDifUnivCompareIFChartXml (List < AnalysisVo > difUnivData, String contextPath){

        //String caption = "Publications by year from "+fromYear+ " to " + toYear;
        StringBuffer xml = new StringBuffer();
		/*
		 xml.append("<chart animation='0' caption='' lineThickness='2' showValues='0' formatNumberScale='0' anchorRadius='4' ")
			//.append("divLineAlpha='20' divLineColor='CC3300' divLineIsDashed='1' showAlternateHGridColor='1' alternateHGridColor='CC3300' ")
			//.append("shadowAlpha='40' labelStep='1' numvdivlines='5' bgColor='FFFFFF,CC3300' bgAngle='270' bgAlpha='10,10' ")
		    .append(" divLineAlpha='30' numvdivlines='5' divLineIsDashed='1' bgColor='F7F7F7, E9E9E9' ")
		 	.append(" PYAxisName='Total' SYAxisName='Average' slantLabels='1'  labelDisplay='ROTATE' ")
			.append(" exportEnabled='1' exportAtClient='0' exportAction='save' exportHandler='"+contextPath+"/servlet/FCExporter/export.do' exportCallBack='myFN_IF' ")
			//.append("exportShowMenuItem='0' exportDialogMessage='Building chart output ' ")
			.append(" useRoundEdges='1' legendPosition ='CENTER '>");
		 */
        xml.append("<chart ")
                .append(" caption='' ")
                .append(" subcaption='' ")
                .append(" baseFontColor='#666666' ")
                .append(" baseFontSize='11' ")
                .append(" subcaptionFontBold='0' ")
                .append(" canvasBgAlpha='0' ")
                .append(" showValues='0' ")
                .append(" paletteColors='" + paletteColors + "' ")
                .append(" bgAlpha='0' ")
                .append(" showBorder='0' ")
                .append(" showShadow='0' ")
                .append(" showAlternateHGridColor='0' ")
                .append(" showCanvasBorder='0' ")
                .append(" showXAxisLine='1' ")
                .append(" xAxisName='' ")
                .append(" xAxisLineThickness='1' ")
                .append(" xAxisLineColor='#cdcdcd' ")
                .append(" xAxisNameFontColor='#8d8d8d' ")
                .append(" yAxisName='' ")
                .append(" yAxisNameFontColor='#8d8d8d' ")
                .append(" canvasBgColor='#ffffff' ")
                .append(" lineThickness='4' ")
                .append(" legendBgColor='#ffffff' ")
                .append(" legendBgAlpha='100' ")
                .append(" legendBorderAlpha='50' ")
                .append(" legendBorderColor='#888888' ")
                .append(" legendShadow='0' ")
                .append(" legendPosition='CENTER' ")
                .append(" divlineAlpha='100' ")
                .append(" numDivLines='10' ")
                .append(" divlineColor='#999999' ")
                .append(" divlineThickness='1' ")
                .append(" divLineIsDashed='1'")
                .append(" divLineDashLen='1'")
                .append(" divLineGapLen='1' ")
                .append(" toolTipColor='#ffffff' ")
                .append(" toolTipBorderColor='#ffffff' ")
                .append(" toolTipBorderThickness='1' ")
                .append(" toolTipBgColor='#000000' ")
                .append(" toolTipBgAlpha='80' ")
                .append(" toolTipBorderRadius='4' ")
                .append(" toolTipPadding='10' ")
                .append(" toolTipFontSize ='20' ")
                .append(" anchorBgColor='#ffffff' ")
                .append(" anchorRadius='5' ")
                .append(" anchorBorderThickness='3' ")
                .append(" anchorTrackingRadius='15' ")
                .append(" showHoverEffect='1' ")
                .append(" formatNumberScale='0'")
                .append(" labelDisplay='rotate' ")
                .append(" slantLabels='1' ")
                .append(" exportEnabled='1' ")
                .append(" exportAtClient='0' ")
                .append(" exportAction='save' ")
                .append(" exportShowMenuItem='0' ")
                .append(" exportDialogMessage='Building chart output' ")
                .append(" exportHandler='" + contextPath + "/servlet/FCExporter/export.do' exportCallBack='myFN_IF' ")
                .append(" >");

        xml.append("<categories >");

        for (AnalysisVo difUniv : difUnivData) {
            String univNm = difUniv.getUnivNm().trim();
            if (univNm.length() > 12) univNm = univNm.substring(0, 12);
            xml.append("<category label='" + univNm + "' />");
        }
        xml.append("</categories>");


        xml.append("<dataset seriesName='Total of Impact Factor' parentYAxis='P' color='F5A618' >");
        for (AnalysisVo difUniv : difUnivData) {
            Object val = difUniv.getTotalJif();
            String tText = difUniv.getUnivNm().trim() + " total : " + val;
            xml.append("<set value='" + val + "'  toolText='" + tText + "' />");
        }
        xml.append("</dataset>");

        xml.append("<dataset seriesName='Average of Impact Factor' parentYAxis='S' renderAs='Column' color='699119'>");
        for (AnalysisVo difUniv : difUnivData) {
            Object val = difUniv.getAvgJifPerRsrch();
            String tText = difUniv.getUnivNm().trim() + " avg : " + val;
            xml.append("<set value='" + val + "'  toolText='" + tText + "' />");
        }
        xml.append("</dataset>");

        xml.append("<styles>");
        xml.append("    <definition>");
        xml.append("        <style name='myLabelsFont' type='font' font='Malgun Gothic' size='12' bold='1' />");
        xml.append("        <style name='CaptionFont' type='font' size='12'/>");
        xml.append("   </definition>");
        xml.append("    <application>");
        xml.append("       <apply toObject='CAPTION' styles='CaptionFont' />");
        xml.append("       <apply toObject='SUBCAPTION' styles='CaptionFont' />");
        xml.append("       <apply toObject='DataLabels' styles='myLabelsFont' />");
        xml.append("    </application>");
        xml.append(" </styles>");

        xml.append("</chart>");

        return xml.toString();

    }

    public static String buildDifUnivCompareTCChartXml (List < AnalysisVo > difUnivData, String contextPath){

        StringBuffer xml = new StringBuffer();
		/*
		xml.append("<chart animation='0' caption='' lineThickness='2' showValues='0' formatNumberScale='0' anchorRadius='4' ")
		//.append("divLineAlpha='20' divLineColor='CC3300' divLineIsDashed='1' showAlternateHGridColor='1' alternateHGridColor='CC3300' ")
		//.append("shadowAlpha='40' labelStep='1' numvdivlines='5' bgColor='FFFFFF,CC3300' bgAngle='270' bgAlpha='10,10' ")
		.append(" divLineAlpha='30' numvdivlines='5' divLineIsDashed='1' bgColor='F7F7F7, E9E9E9' ")
		.append(" PYAxisName='Total' SYAxisName='Average' slantLabels='1'  labelDisplay='ROTATE' ")
		.append(" exportEnabled='1' exportAtClient='0' exportAction='save' exportHandler='"+contextPath+"/servlet/FCExporter/export.do' exportCallBack='myFN_TC' ")
		.append(" exportShowMenuItem='0' exportDialogMessage='Building chart output ' ")
		.append(" useRoundEdges='1' legendPosition ='CENTER '>");
		*/
        xml.append("<chart ")
                .append(" caption='' ")
                .append(" subcaption='' ")
                .append(" baseFontColor='#666666' ")
                .append(" baseFontSize='11' ")
                .append(" subcaptionFontBold='0' ")
                .append(" canvasBgAlpha='0' ")
                .append(" showValues='0' ")
                .append(" paletteColors='" + paletteColors + "' ")
                .append(" bgAlpha='0' ")
                .append(" showBorder='0' ")
                .append(" showShadow='0' ")
                .append(" showAlternateHGridColor='0' ")
                .append(" showCanvasBorder='0' ")
                .append(" showXAxisLine='1' ")
                .append(" xAxisName='' ")
                .append(" xAxisLineThickness='1' ")
                .append(" xAxisLineColor='#cdcdcd' ")
                .append(" xAxisNameFontColor='#8d8d8d' ")
                .append(" yAxisName='' ")
                .append(" yAxisNameFontColor='#8d8d8d' ")
                .append(" canvasBgColor='#ffffff' ")
                .append(" lineThickness='4' ")
                .append(" legendBgColor='#ffffff' ")
                .append(" legendBgAlpha='100' ")
                .append(" legendBorderAlpha='50' ")
                .append(" legendBorderColor='#888888' ")
                .append(" legendShadow='0' ")
                .append(" legendPosition='CENTER' ")
                .append(" divlineAlpha='100' ")
                .append(" numDivLines='10' ")
                .append(" divlineColor='#999999' ")
                .append(" divlineThickness='1' ")
                .append(" divLineIsDashed='1'")
                .append(" divLineDashLen='1'")
                .append(" divLineGapLen='1' ")
                .append(" toolTipColor='#ffffff' ")
                .append(" toolTipBorderColor='#ffffff' ")
                .append(" toolTipBorderThickness='1' ")
                .append(" toolTipBgColor='#000000' ")
                .append(" toolTipBgAlpha='80' ")
                .append(" toolTipBorderRadius='4' ")
                .append(" toolTipPadding='10' ")
                .append(" toolTipFontSize ='20' ")
                .append(" anchorBgColor='#ffffff' ")
                .append(" anchorRadius='5' ")
                .append(" anchorBorderThickness='3' ")
                .append(" anchorTrackingRadius='15' ")
                .append(" showHoverEffect='1' ")
                .append(" formatNumberScale='0'")
                .append(" labelDisplay='rotate' ")
                .append(" slantLabels='1' ")
                .append(" exportEnabled='1' ")
                .append(" exportAtClient='0' ")
                .append(" exportAction='save' ")
                .append(" exportShowMenuItem='0' ")
                .append(" exportDialogMessage='Building chart output' ")
                .append(" exportHandler='" + contextPath + "/servlet/FCExporter/export.do' exportCallBack='myFN_TC' ")
                .append(" >");

        xml.append("<categories >");

        for (AnalysisVo difUniv : difUnivData) {
            String univNm = difUniv.getUnivNm().trim();
            if (univNm.length() > 12) univNm = univNm.substring(0, 12);
            xml.append("<category label='" + univNm + "' />");
        }
        xml.append("</categories>");


        xml.append("<dataset seriesName='Total of Citation' parentYAxis='P' color='EF187D' >");
        for (AnalysisVo difUniv : difUnivData) {
            Object val = difUniv.getTotalTc();
            String tText = difUniv.getUnivNm().trim() + " total : " + val;
            xml.append("<set value='" + val + "'  toolText='" + tText + "' />");
        }
        xml.append("</dataset>");

        xml.append("<dataset seriesName='Average of Citation' parentYAxis='S' renderAs='Column' color='1A4991'>");
        for (AnalysisVo difUniv : difUnivData) {
            Object val = difUniv.getAvgTcPerArtcl();
            String tText = difUniv.getUnivNm().trim() + " avg : " + val;
            xml.append("<set value='" + val + "'  toolText='" + tText + "' />");
        }
        xml.append("</dataset>");

        xml.append("<styles>");
        xml.append("    <definition>");
        xml.append("        <style name='myLabelsFont' type='font' font='Malgun Gothic' size='12' bold='1' />");
        xml.append("        <style name='CaptionFont' type='font' size='12'/>");
        xml.append("   </definition>");
        xml.append("    <application>");
        xml.append("       <apply toObject='CAPTION' styles='CaptionFont' />");
        xml.append("       <apply toObject='SUBCAPTION' styles='CaptionFont' />");
        xml.append("       <apply toObject='DataLabels' styles='myLabelsFont' />");
        xml.append("    </application>");
        xml.append(" </styles>");

        xml.append("</chart>");

        return xml.toString();

    }


    public static String buildFulltimeChartXmlWithDept (List < Map > dataList, String contextPath,int fy,
                                                        int ty, String caption, String axisName, String postFix){
        //String caption = "Publications by year from "+fromYear+ " to " + toYear;
        StringBuffer xml = new StringBuffer();

        xml.append("<chart ")
                .append(" caption='" + caption + "' ")
                .append(" yAxisName='" + axisName + "' ")
                .append(" subcaption='' ")
                .append(" baseFontColor='#666666' ")
                .append(" baseFontSize='11' ")
                .append(" subcaptionFontBold='0' ")
                .append(" canvasBgAlpha='0' ")
                .append(" showValues='0' ")
                .append(" paletteColors='" + paletteColors + "' ")
                .append(" bgAlpha='0' ")
                .append(" showBorder='0' ")
                .append(" showShadow='0' ")
                .append(" showAlternateHGridColor='0' ")
                .append(" showCanvasBorder='0' ")
                .append(" showXAxisLine='1' ")
                .append(" xAxisLineThickness='1' ")
                .append(" xAxisLineColor='#cdcdcd' ")
                .append(" xAxisNameFontColor='#8d8d8d' ")
                .append(" yAxisNameFontColor='#8d8d8d' ")
                .append(" canvasBgColor='#ffffff' ")
                .append(" lineThickness='4' ")
                .append(" legendBgColor='#ffffff' ")
                .append(" legendBgAlpha='100' ")
                .append(" legendBorderAlpha='50' ")
                .append(" legendBorderColor='#888888' ")
                .append(" legendShadow='0' ")
                .append(" legendPosition='CENTER' ")
                .append(" divlineAlpha='0' ")
                .append(" numDivLines='10' ")
                .append(" divlineColor='#999999' ")
                .append(" divlineThickness='1' ")
                .append(" divLineIsDashed='1'")
                .append(" divLineDashLen='1'")
                .append(" divLineGapLen='1' ")
                .append(" toolTipColor='#ffffff' ")
                .append(" toolTipBorderColor='#ffffff' ")
                .append(" toolTipBorderThickness='1' ")
                .append(" toolTipBgColor='#000000' ")
                .append(" toolTipBgAlpha='80' ")
                .append(" toolTipBorderRadius='4' ")
                .append(" toolTipPadding='10' ")
                .append(" toolTipFontSize ='20' ")
                .append(" anchorBgColor='#ffffff' ")
                .append(" anchorRadius='5' ")
                .append(" anchorBorderThickness='3' ")
                .append(" anchorTrackingRadius='15' ")
                .append(" showHoverEffect='1' ")
                .append(" formatNumberScale='0'")
                .append(" labelDisplay='rotate' ")
                .append(" slantLabels='1' ")
                .append(" exportEnabled='1' ")
                .append(" exportAtClient='0' ")
                .append(" exportAction='save' ")
                .append(" exportShowMenuItem='0' ")
                .append(" exportDialogMessage='Building chart output' ")
                .append(" exportHandler='" + contextPath + "/servlet/FCExporter/export.do' exportCallBack='myFN_" + postFix + "' ")
                .append(" >");

		/*
		xml.append("<chart animation='0' caption='"+caption+"' subcaption='' yAxisName='"+axisName+"' lineThickness='2' showValues='0' formatNumberScale='0' anchorRadius='4'  ")
		//.append("divLineAlpha='20' divLineColor='CC3300' divLineIsDashed='1' showAlternateHGridColor='1' alternateHGridColor='CC3300' ")
		//.append("shadowAlpha='40' labelStep='1' numvdivlines='5' chartRightMargin='35' bgColor='FFFFFF,CC3300' bgAngle='270' bgAlpha='10,10' ")
		.append(" divLineAlpha='30' numvdivlines='5' divLineIsDashed='1' bgColor='F7F7F7, E9E9E9'")
		.append(" exportEnabled='1' exportAtClient='0' exportAction='save' exportHandler='"+contextPath+"/servlet/FCExporter/export.do' exportCallBack='myFN_"+postFix+"' ")
		.append(" exportShowMenuItem='0' exportDialogMessage='Building chart output ' ")
		.append(" showLegend='1' legendPosition ='CENTER' >");
		 */

        xml.append("<categories >");

        for (int ii = fy; ii <= ty; ii++) {
            xml.append("<category label='" + ii + "' />");
        }

        xml.append("</categories>");
        int j = 0;
        for (Map depart : dataList) {
            if (j >= 5) break;
            String sn = depart.get("deptKor") + "";
            xml.append("<dataset seriesName='" + sn + "' color='" + fillColors[j] + "' anchorBorderColor='" + fillColors[j] + "' id='" + depart.get("deptKor") + "' >");
            for (int ii = fy; ii <= ty; ii++) {
                Object val = depart.get(Integer.toString(ii));

                if (val instanceof Double) val = Math.round((((Double) val) * 100)) / 100.0;

                if (val == null)
                    xml.append("<set value='0' toolText='" + sn + " " + ii + " : 0' />");
                else
                    xml.append("<set value='" + val + "'  toolText='" + sn + " " + ii + " : " + val + "' />");
            }
            xml.append("</dataset>");
            j++;
        }

        xml.append("<styles>");
        xml.append("    <definition>");
        xml.append("        <style name='CaptionFont' type='font' size='12'/>");
        xml.append("   </definition>");
        xml.append("    <application>");
        xml.append("       <apply toObject='CAPTION' styles='CaptionFont' />");
        xml.append("       <apply toObject='SUBCAPTION' styles='CaptionFont' />");
        xml.append("    </application>");
        xml.append(" </styles>");

        xml.append("</chart>");

        return xml.toString();
    }

    public static String buildFulltimeArticleChartXmlWithDept (List < AnalysisVo > dataList, String
            contextPath, String key, String axisName, String postFix){
        //String caption = "Publications by year from "+fromYear+ " to " + toYear;
        StringBuffer xml = new StringBuffer();

        xml.append("<chart ")
                .append(" yAxisName='" + axisName + "' ")
                .append(" subcaption='' ")
                .append(" baseFontColor='#666666' ")
                .append(" baseFontSize='11' ")
                .append(" subcaptionFontBold='0' ")
                .append(" canvasBgAlpha='0' ")
                .append(" showValues='0' ")
                .append(" paletteColors='" + paletteColors + "' ")
                .append(" bgAlpha='0' ")
                .append(" showBorder='0' ")
                .append(" showShadow='0' ")
                .append(" showAlternateHGridColor='0' ")
                .append(" showCanvasBorder='0' ")
                .append(" showXAxisLine='1' ")
                .append(" xAxisLineThickness='1' ")
                .append(" xAxisLineColor='#cdcdcd' ")
                .append(" xAxisNameFontColor='#8d8d8d' ")
                .append(" yAxisNameFontColor='#8d8d8d' ")
                .append(" canvasBgColor='#ffffff' ")
                .append(" lineThickness='4' ")
                .append(" legendBgColor='#ffffff' ")
                .append(" legendBgAlpha='100' ")
                .append(" legendBorderAlpha='50' ")
                .append(" legendBorderColor='#888888' ")
                .append(" legendShadow='0' ")
                .append(" legendPosition='CENTER' ")
                .append(" divlineAlpha='0' ")
                .append(" numDivLines='10' ")
                .append(" divlineColor='#999999' ")
                .append(" divlineThickness='1' ")
                .append(" divLineIsDashed='1'")
                .append(" divLineDashLen='1'")
                .append(" divLineGapLen='1' ")
                .append(" toolTipColor='#ffffff' ")
                .append(" toolTipBorderColor='#ffffff' ")
                .append(" toolTipBorderThickness='1' ")
                .append(" toolTipBgColor='#000000' ")
                .append(" toolTipBgAlpha='80' ")
                .append(" toolTipBorderRadius='4' ")
                .append(" toolTipPadding='10' ")
                .append(" toolTipFontSize ='20' ")
                .append(" anchorBgColor='#ffffff' ")
                .append(" anchorRadius='5' ")
                .append(" anchorBorderThickness='3' ")
                .append(" anchorTrackingRadius='15' ")
                .append(" showHoverEffect='1' ")
                .append(" formatNumberScale='0'")
                .append(" labelDisplay='rotate' ")
                .append(" slantLabels='1' ")
                .append(" plotBorderColor='#ffffff' ") //bar 테두리없애기
                .append(" usePlotGradientColor='0' ") //bar의 그라데이션 없애기
                .append(" exportEnabled='1' ")
                .append(" exportAtClient='0' ")
                .append(" exportAction='save' ")
                .append(" exportShowMenuItem='0' ")
                .append(" exportDialogMessage='Building chart output' ")
                .append(" exportHandler='" + contextPath + "/servlet/FCExporter/export.do' exportCallBack='myFN_" + postFix + "' ")
                .append(" >");

		/*
		xml.append("<chart animation='0' exportEnabled='1'  caption='' subcaption='' yAxisName='"+axisName+"' lineThickness='2' showValues='1' formatNumberScale='0' anchorRadius='4' showLegend='1' ")
		//.append("divLineAlpha='20' divLineColor='CC3300' divLineIsDashed='1' showAlternateHGridColor='1' alternateHGridColor='CC3300' ")
		//.append("shadowAlpha='40' labelStep='1' numvdivlines='5' chartRightMargin='35' bgColor='FFFFFF,CC3300' bgAngle='270' bgAlpha='10,10' ")
		.append("divLineAlpha='30' numvdivlines='5' divLineIsDashed='1' bgColor='F7F7F7, E9E9E9'")
		.append("exportEnabled='1' exportAtClient='0' exportAction='save' exportHandler='"+contextPath+"/servlet/FCExporter/export.do' exportCallBack='myFN_"+postFix+"' ")
		.append("exportShowMenuItem='0' exportDialogMessage='Building chart output ' ")
		.append("legendPosition ='CENTER' formatNumberScale='0' useRoundEdges='1' slantLabels='1'  labelDisplay='ROTATE' >");
		*/

        for (AnalysisVo depart : dataList) {

            Object value = "";
            if ("intrlJnalArtsCo".equals(key)) value = depart.getIntrlJnalArtsCo();
            else if ("intrlGnalArtsCo".equals(key)) value = depart.getIntrlGnalArtsCo();
            else if ("dmstcKciArtsCo".equals(key)) value = depart.getDmstcKciArtsCo();
            else if ("dmstcGnalArtsCo".equals(key)) value = depart.getDmstcGnalArtsCo();

            xml.append("<set label='" + depart.getDeptKor() + "' value='" + value + "' toolText='" + depart.getDeptKor() + " : " + value + "'/>");
        }

        xml.append("<styles>");
        xml.append("    <definition>");
        xml.append("        <style name='CaptionFont' type='font' size='12'/>");
        xml.append("   </definition>");
        xml.append("    <application>");
        xml.append("       <apply toObject='CAPTION' styles='CaptionFont' />");
        xml.append("       <apply toObject='SUBCAPTION' styles='CaptionFont' />");
        xml.append("    </application>");
        xml.append(" </styles>");

        xml.append("</chart>");

        return xml.toString();
    }


    /**
     * <pre>
     *  1. 개   요 : Make chart xml for full time researcher's number of article with department
     *  2. 처리내용 :
     * </pre>
     *  @Method Name : buildFulltimeSciArtsChartXmlWithDept
     *  @param sciList
     *  @param contextPath
     *  @return
     */
    public static String buildFulltimeSciArtsChartXmlWithDept (List < AnalysisVo > sciList, String contextPath){
        String caption = "";
        StringBuffer xml = new StringBuffer();

        xml.append("<chart ")
                .append(" PYAxisName='논문수' ")
                .append(" SYAxisName='교원1인당 평균 논문수' ")
                .append(" subcaption='' ")
                .append(" baseFontColor='#666666' ")
                .append(" baseFontSize='11' ")
                .append(" subcaptionFontBold='0' ")
                .append(" canvasBgAlpha='0' ")
                .append(" showValues='0' ")
                .append(" paletteColors='" + paletteColors + "' ")
                .append(" bgAlpha='0' ")
                .append(" showBorder='0' ")
                .append(" showShadow='0' ")
                .append(" showAlternateHGridColor='0' ")
                .append(" showCanvasBorder='0' ")
                .append(" showXAxisLine='1' ")
                .append(" xAxisLineThickness='1' ")
                .append(" xAxisLineColor='#cdcdcd' ")
                .append(" xAxisNameFontColor='#8d8d8d' ")
                .append(" yAxisNameFontColor='#8d8d8d' ")
                .append(" canvasBgColor='#ffffff' ")
                .append(" lineThickness='4' ")
                .append(" legendBgColor='#ffffff' ")
                .append(" legendBgAlpha='100' ")
                .append(" legendBorderAlpha='50' ")
                .append(" legendBorderColor='#888888' ")
                .append(" legendShadow='0' ")
                .append(" legendPosition='CENTER' ")
                .append(" divlineAlpha='0' ")
                .append(" numDivLines='10' ")
                .append(" divlineColor='#999999' ")
                .append(" divlineThickness='1' ")
                .append(" divLineIsDashed='1'")
                .append(" divLineDashLen='1'")
                .append(" divLineGapLen='1' ")
                .append(" toolTipColor='#ffffff' ")
                .append(" toolTipBorderColor='#ffffff' ")
                .append(" toolTipBorderThickness='1' ")
                .append(" toolTipBgColor='#000000' ")
                .append(" toolTipBgAlpha='80' ")
                .append(" toolTipBorderRadius='4' ")
                .append(" toolTipPadding='10' ")
                .append(" toolTipFontSize ='20' ")
                .append(" anchorBgColor='#ffffff' ")
                .append(" anchorRadius='5' ")
                .append(" anchorBorderThickness='3' ")
                .append(" anchorTrackingRadius='15' ")
                .append(" showHoverEffect='1' ")
                .append(" formatNumberScale='0'")
                .append(" labelDisplay='rotate' ")
                .append(" slantLabels='1' ")
                .append(" plotBorderColor='#ffffff' ") //bar 테두리없애기
                .append(" usePlotGradientColor='0' ") //bar의 그라데이션 없애기
                .append(" exportEnabled='1' ")
                .append(" exportAtClient='0' ")
                .append(" exportAction='save' ")
                .append(" exportShowMenuItem='0' ")
                .append(" exportDialogMessage='Building chart output' ")
                .append(" exportHandler='" + contextPath + "/servlet/FCExporter/export.do' exportCallBack='myFN_ART' ")
                .append(" >");

		/*
		xml.append("<chart caption='"+caption+"' subcaption='' showValues='0' formatNumberScale='0' anchorRadius='2'  animation='0' ")
		//.append("divLineAlpha='20' divLineColor='CC3300' divLineIsDashed='1' showAlternateHGridColor='1' alternateHGridColor='CC3300' ")
		//.append("shadowAlpha='40' labelStep='1' numvdivlines='5' chartRightMargin='35' bgColor='FFFFFF,BBBBBB' bgAngle='270' bgAlpha='10,10' ")
		.append("PYAxisName='논문수' SYAxisName='교원1인당 평균 논문수' slantLabels='1'")
		.append("divLineAlpha='50' numvdivlines='5' divLineIsDashed='1' bgColor='F7F7F7, E9E9E9'")
		.append("exportEnabled='1' exportAtClient='0' exportAction='save' exportHandler='"+contextPath+"/servlet/FCExporter/export.do' exportCallBack='myFN_ART' ")
		.append("exportShowMenuItem='0' exportDialogMessage='Building chart output ' ")
		.append("useRoundEdges='1' legendPosition ='CENTER ' labelDisplay='ROTATE' slantLabels='1' >");
		*/

        xml.append("<categories >");
        for (AnalysisVo sci : sciList) {
            xml.append("<category label='" + sci.getDeptKor() + "' />");
        }
        xml.append("</categories>");

        //citated publications dataset
		/*
		xml.append("<dataset seriesName='No. of Full Time Researcher' color='008ED6'>");
		for(Map sci : sciList){
			xml.append("<set value='"+sci.get("R_CNT")+"' toolText='"+sci.get("R_CNT").toString().trim()+"'/>");

		}
		xml.append("</dataset>");
		*/

        //not citated publications dataset
        xml.append("<dataset seriesName='논문수' parentYAxis='P' renderAs='Column' color='" + fillColors[0] + "'>");
        for (AnalysisVo sci : sciList) {
            xml.append("<set value='" + sci.getArtsTotal() + "' toolText='" + sci.getArtsTotal().toString().trim() + "'/>");
        }
        xml.append("</dataset>");

        //no publications dataset
        xml.append("<dataset seriesName='교원1인당 평균 논문수' parentYAxis='S' renderAs='Column' color='" + fillColors[1] + "'>");
        for (AnalysisVo sci : sciList) {
            Object val = sci.getArtsAvrg();
            if (val instanceof Double) val = Math.round((((Double) val) * 100)) / 100.0;
            xml.append("<set value='" + val + "' toolText='" + val + "'/>");
        }
        xml.append("</dataset>");

        xml.append("<trendlines>");
        xml.append("<style name='CanvasAnim' type='animation' param='_xScale' start='0' duration='1' />");
        xml.append("</trendlines>");
        xml.append("<styles>");
        xml.append("    <definition>");
        xml.append("        <style name='CaptionFont' type='font' size='12'/>");
        xml.append("   </definition>");
        xml.append("    <application>");
        xml.append("       <apply toObject='CAPTION' styles='CaptionFont' />");
        xml.append("       <apply toObject='SUBCAPTION' styles='CaptionFont' />");
        xml.append("    </application>");
        xml.append(" </styles>");
        xml.append("</chart>");

        return xml.toString();
    }

    /**
     * <pre>
     *  1. 개   요 : Make chart xml for full time researcher citation by department
     *  2. 처리내용 :
     * </pre>
     *  @Method Name : buildFulltimeSciCitationChartXmlWithDept
     *  @param sciList
     *  @param contextPath
     *  @return
     */
    public static String buildFulltimeSciCitationChartXmlWithDept (List < AnalysisVo > sciList, String contextPath){
        String caption = "";
        StringBuffer xml = new StringBuffer();

        xml.append("<chart ")
                .append(" PYAxisName='피인용횟수 합계' ")
                .append(" SYAxisName='논문당 평균 피인용횟수' ")
                .append(" subcaption='' ")
                .append(" baseFontColor='#666666' ")
                .append(" baseFontSize='11' ")
                .append(" subcaptionFontBold='0' ")
                .append(" canvasBgAlpha='0' ")
                .append(" showValues='0' ")
                .append(" paletteColors='" + paletteColors + "' ")
                .append(" bgAlpha='0' ")
                .append(" showBorder='0' ")
                .append(" showShadow='0' ")
                .append(" showAlternateHGridColor='0' ")
                .append(" showCanvasBorder='0' ")
                .append(" showXAxisLine='1' ")
                .append(" xAxisLineThickness='1' ")
                .append(" xAxisLineColor='#cdcdcd' ")
                .append(" xAxisNameFontColor='#8d8d8d' ")
                .append(" yAxisNameFontColor='#8d8d8d' ")
                .append(" canvasBgColor='#ffffff' ")
                .append(" lineThickness='4' ")
                .append(" legendBgColor='#ffffff' ")
                .append(" legendBgAlpha='100' ")
                .append(" legendBorderAlpha='50' ")
                .append(" legendBorderColor='#888888' ")
                .append(" legendShadow='0' ")
                .append(" legendPosition='CENTER' ")
                .append(" divlineAlpha='0' ")
                .append(" numDivLines='10' ")
                .append(" divlineColor='#999999' ")
                .append(" divlineThickness='1' ")
                .append(" divLineIsDashed='1'")
                .append(" divLineDashLen='1'")
                .append(" divLineGapLen='1' ")
                .append(" toolTipColor='#ffffff' ")
                .append(" toolTipBorderColor='#ffffff' ")
                .append(" toolTipBorderThickness='1' ")
                .append(" toolTipBgColor='#000000' ")
                .append(" toolTipBgAlpha='80' ")
                .append(" toolTipBorderRadius='4' ")
                .append(" toolTipPadding='10' ")
                .append(" toolTipFontSize ='20' ")
                .append(" anchorBgColor='#ffffff' ")
                .append(" anchorRadius='5' ")
                .append(" anchorBorderThickness='3' ")
                .append(" anchorTrackingRadius='15' ")
                .append(" showHoverEffect='1' ")
                .append(" formatNumberScale='0'")
                .append(" labelDisplay='rotate' ")
                .append(" slantLabels='1' ")
                .append(" plotBorderColor='#ffffff' ") //bar 테두리없애기
                .append(" usePlotGradientColor='0' ") //bar의 그라데이션 없애기
                .append(" exportEnabled='1' ")
                .append(" exportAtClient='0' ")
                .append(" exportAction='save' ")
                .append(" exportShowMenuItem='0' ")
                .append(" exportDialogMessage='Building chart output' ")
                .append(" exportHandler='" + contextPath + "/servlet/FCExporter/export.do' exportCallBack='myFN_TC' ")
                .append(" >");


		/*
		xml.append("<chart caption='"+caption+"' subcaption='' showValues='0' formatNumberScale='0' anchorRadius='2' animation='0' ")
		//.append("divLineAlpha='20' divLineColor='CC3300' divLineIsDashed='1' showAlternateHGridColor='1' alternateHGridColor='CC3300' ")
		//.append("shadowAlpha='40' labelStep='1' numvdivlines='5' chartRightMargin='35' bgColor='FFFFFF,BBBBBB' bgAngle='270' bgAlpha='10,10' ")
		.append("PYAxisName='피인용횟수 합계' SYAxisName='논문당 평균 피인용횟수' slantLabels='1'")
		.append("divLineAlpha='50' numvdivlines='5' divLineIsDashed='1' bgColor='F7F7F7, E9E9E9'")
		.append("exportEnabled='1' exportAtClient='0' exportAction='save' exportHandler='"+contextPath+"/servlet/FCExporter/export.do' exportCallBack='myFN_TC' ")
		.append("exportShowMenuItem='0' exportDialogMessage='Building chart output ' ")
		.append("useRoundEdges='1' legendPosition ='CENTER ' labelDisplay='ROTATE' slantLabels='1' >");
		*/

        xml.append("<categories >");
        for (AnalysisVo sci : sciList) {
            xml.append("<category label='" + sci.getDeptKor() + "' />");
        }
        xml.append("</categories>");

		/*
		//citated publications dataset
		xml.append("<dataset seriesName='Number of Article' color='CC6600'>");
		for(Map sci : sciList){
			xml.append("<set value='"+sci.get("ARTS_TOT")+"' toolText='"+sci.get("ARTS_TOT").toString().trim()+"'/>");

		}
		xml.append("</dataset>");
		*/

        //not citated publications dataset
        xml.append("<dataset seriesName='피인용횟수 합계' parentYAxis='P' renderAs='Column' color='" + fillColors[2] + "'>");
        for (AnalysisVo sci : sciList) {
            xml.append("<set value='" + sci.getCitedSum() + "' toolText='" + sci.getCitedSum().toString().trim() + "'/>");
        }
        xml.append("</dataset>");

        xml.append("<dataset seriesName='논문당 평균 피인용횟수' parentYAxis='S' renderAs='Column' color='" + fillColors[3] + "'>");
        for (AnalysisVo sci : sciList) {
            Object val = sci.getCitedAvrg();
            if (val instanceof Double) val = Math.round((((Double) val) * 100)) / 100.0;
            xml.append("<set value='" + val + "' toolText='" + val.toString().trim() + "'/>");
        }
        xml.append("</dataset>");

        xml.append("<trendlines>");
        xml.append("<style name='CanvasAnim' type='animation' param='_xScale' start='0' duration='1' />");
        xml.append("</trendlines>");
        xml.append("<styles>");
        xml.append("    <definition>");
        xml.append("        <style name='CaptionFont' type='font' size='12'/>");
        xml.append("   </definition>");
        xml.append("    <application>");
        xml.append("       <apply toObject='CAPTION' styles='CaptionFont' />");
        xml.append("       <apply toObject='SUBCAPTION' styles='CaptionFont' />");
        xml.append("    </application>");
        xml.append(" </styles>");
        xml.append("</chart>");

        return xml.toString();
    }


    /**
     * <pre>
     *  1. 개   요 : Make chart xml for full time with department
     *  2. 처리내용 :
     * </pre>
     *  @Method Name : buildFulltimeSciIFChartXmlWithDept
     *  @param sciList
     *  @param contextPath
     *  @return
     */
    public static String buildFulltimeSciIFChartXmlWithDept (List < AnalysisVo > sciList, String contextPath){
        String caption = "";
        StringBuffer xml = new StringBuffer();

        xml.append("<chart ")
                .append(" PYAxisName='Impact Factor 합계' ")
                .append(" SYAxisName='교원1인당 Imapct Factor 평균' ")
                .append(" subcaption='' ")
                .append(" baseFontColor='#666666' ")
                .append(" baseFontSize='11' ")
                .append(" subcaptionFontBold='0' ")
                .append(" canvasBgAlpha='0' ")
                .append(" showValues='0' ")
                .append(" paletteColors='" + paletteColors + "' ")
                .append(" bgAlpha='0' ")
                .append(" showBorder='0' ")
                .append(" showShadow='0' ")
                .append(" showAlternateHGridColor='0' ")
                .append(" showCanvasBorder='0' ")
                .append(" showXAxisLine='1' ")
                .append(" xAxisLineThickness='1' ")
                .append(" xAxisLineColor='#cdcdcd' ")
                .append(" xAxisNameFontColor='#8d8d8d' ")
                .append(" yAxisNameFontColor='#8d8d8d' ")
                .append(" canvasBgColor='#ffffff' ")
                .append(" lineThickness='4' ")
                .append(" legendBgColor='#ffffff' ")
                .append(" legendBgAlpha='100' ")
                .append(" legendBorderAlpha='50' ")
                .append(" legendBorderColor='#888888' ")
                .append(" legendShadow='0' ")
                .append(" legendPosition='CENTER' ")
                .append(" divlineAlpha='0' ")
                .append(" numDivLines='10' ")
                .append(" divlineColor='#999999' ")
                .append(" divlineThickness='1' ")
                .append(" divLineIsDashed='1'")
                .append(" divLineDashLen='1'")
                .append(" divLineGapLen='1' ")
                .append(" toolTipColor='#ffffff' ")
                .append(" toolTipBorderColor='#ffffff' ")
                .append(" toolTipBorderThickness='1' ")
                .append(" toolTipBgColor='#000000' ")
                .append(" toolTipBgAlpha='80' ")
                .append(" toolTipBorderRadius='4' ")
                .append(" toolTipPadding='10' ")
                .append(" toolTipFontSize ='20' ")
                .append(" anchorBgColor='#ffffff' ")
                .append(" anchorRadius='5' ")
                .append(" anchorBorderThickness='3' ")
                .append(" anchorTrackingRadius='15' ")
                .append(" showHoverEffect='1' ")
                .append(" formatNumberScale='0'")
                .append(" labelDisplay='rotate' ")
                .append(" slantLabels='1' ")
                .append(" plotBorderColor='#ffffff' ") //bar 테두리없애기
                .append(" usePlotGradientColor='0' ") //bar의 그라데이션 없애기
                .append(" exportEnabled='1' ")
                .append(" exportAtClient='0' ")
                .append(" exportAction='save' ")
                .append(" exportShowMenuItem='0' ")
                .append(" exportDialogMessage='Building chart output' ")
                .append(" exportHandler='" + contextPath + "/servlet/FCExporter/export.do' exportCallBack='myFN_IF' ")
                .append(" >");

		/*
		xml.append("<chart caption='"+caption+"' subcaption='' showValues='0' formatNumberScale='0' anchorRadius='2'  animation='0'")
		//.append("divLineAlpha='20' divLineColor='CC3300' divLineIsDashed='1' showAlternateHGridColor='1' alternateHGridColor='CC3300' ")
		//.append("shadowAlpha='40' labelStep='1' numvdivlines='5' chartRightMargin='35' bgColor='FFFFFF,BBBBBB' bgAngle='270' bgAlpha='10,10' ")
		.append("PYAxisName='Impact Factor 합계' SYAxisName='교원1인당 Imapct Factor 평균' slantLabels='1'")
		.append("divLineAlpha='50' numvdivlines='5' divLineIsDashed='1' bgColor='F7F7F7, E9E9E9'")
		.append("exportEnabled='1' exportAtClient='0' exportAction='save' exportHandler='"+contextPath+"/servlet/FCExporter/export.do' exportCallBack='myFN_IF' ")
		.append("exportShowMenuItem='0' exportDialogMessage='Building chart output ' ")
		.append("useRoundEdges='1' legendPosition ='CENTER ' labelDisplay='ROTATE' slantLabels='1' >");
		*/

        xml.append("<categories >");
        for (AnalysisVo sci : sciList) {
            xml.append("<category label='" + sci.getDeptKor() + "' />");
        }
        xml.append("</categories>");

        //citated publications dataset
        xml.append("<dataset seriesName='Impact Factor 합계' color='" + fillColors[4] + "'>");
        for (AnalysisVo sci : sciList) {
            Object val = sci.getImpctFctrSum();
            if (val instanceof Double) val = Math.round((((Double) val) * 100)) / 100.0;
            xml.append("<set value='" + val + "' toolText='" + val.toString().trim() + "'/>");

        }
        xml.append("</dataset>");

        //not citated publications dataset
        xml.append("<dataset seriesName='교원1인당 Imapct Factor 평균' parentYAxis='S' renderAs='Column' color='" + fillColors[5] + "'>");
        for (AnalysisVo sci : sciList) {
            Object val = sci.getImpctFctrAvrgByRsrch();
            if (val instanceof Double) val = Math.round((((Double) val) * 100)) / 100.0;
            xml.append("<set value='" + val + "' toolText='" + val.toString().trim() + "'/>");
        }
        xml.append("</dataset>");

		/*
		//no publications dataset
		xml.append("<dataset seriesName='Avg of I.F by Article' parentYAxis='S' renderAs='Column' color='0054A6'>");
		for(Map sci : sciList){
			xml.append("<set value='"+sci.get("A_VAG_IF")+"' toolText='"+sci.get("A_VAG_IF").toString().trim()+"'/>");
		}
		xml.append("</dataset>");
		*/

        xml.append("<trendlines>");
        xml.append("<style name='CanvasAnim' type='animation' param='_xScale' start='0' duration='1' />");
        xml.append("</trendlines>");
        xml.append("<styles>");
        xml.append("    <definition>");
        xml.append("        <style name='CaptionFont' type='font' size='12'/>");
        xml.append("   </definition>");
        xml.append("    <application>");
        xml.append("       <apply toObject='CAPTION' styles='CaptionFont' />");
        xml.append("       <apply toObject='SUBCAPTION' styles='CaptionFont' />");
        xml.append("    </application>");
        xml.append(" </styles>");

        xml.append("</chart>");

        return xml.toString();
    }


    /**
     * <pre>
     *  1. 개   요 : Make chart xml from user article chart by year
     *  2. 처리내용 :
     * </pre>
     *  @Method Name : buildUsersArtChartXmlWithYear
     *  @param arts
     *  @param users
     *  @param fromYear
     *  @param toYear
     *  @param gubun
     *  @param contextPath
     *  @return
     */
    public static String buildKaistArtChartXmlWithYear (List < Map > arts, String fromYear, String toYear, String
            contextPath){

        //String caption = "Publications by year from "+fromYear+ " to " + toYear;
        StringBuffer xml = new StringBuffer();

        xml.append("<chart animation='0' exportEnabled='1'  caption='' subcaption='' lineThickness='4' showValues='0' formatNumberScale='0' showLegend='0'  anchorRadius='4'")
                //.append("divLineAlpha='20' divLineColor='CC3300' divLineIsDashed='1' showAlternateHGridColor='1' alternateHGridColor='CC3300' ")
                //.append("shadowAlpha='40' labelStep='1' numvdivlines='5' chartRightMargin='35' bgColor='FFFFFF,CC3300' bgAngle='270' bgAlpha='10,10' ")
                .append("xAxisName='Year' yAxisName='The num. of articles'")
                .append("divLineAlpha='30' numvdivlines='5' divLineIsDashed='1' bgColor='F7F7F7, E9E9E9'")
                .append("exportEnabled='1' exportAtClient='0' exportAction='save' exportHandler='" + contextPath + "/servlet/FCExporter/export.do' exportCallBack='myFN' ")
                .append("exportShowMenuItem='0' exportDialogMessage='Building chart output ' ")
                .append("legendPosition ='CENTER'  useRoundEdges='1' slantLabels='1'  labelDisplay='ROTATE'>");

        xml.append("<categories >");

        int fy = Integer.parseInt(fromYear);
        int ty = Integer.parseInt(toYear);

        for (int ii = fy; ii <= ty; ii++) {
            xml.append("<category label='" + ii + "' />");
        }

        xml.append("</categories>");

        Map yearNoMap = convertListToMap(arts, "IS_YEAR", "NO_ARTS");
        xml.append("<dataset seriesName='KAIST SCI' color='" + fillColors[5] + "' anchorBorderColor='" + fillColors[5] + "'  >");
        for (int ii = fy; ii <= ty; ii++) {
            Object val = yearNoMap.get(Integer.toString(ii));
            if (val == null)
                xml.append("<set value='0' toolText='" + ii + " : 0' />");
            else
                xml.append("<set value='" + val + "'  toolText=' " + ii + " : " + val + "' />");
        }
        xml.append("</dataset>");

        xml.append("<styles>");
        xml.append("    <definition>");
        xml.append("        <style name='CaptionFont' type='font' size='12'/>");
        xml.append("   </definition>");
        xml.append("    <application>");
        xml.append("       <apply toObject='CAPTION' styles='CaptionFont' />");
        xml.append("       <apply toObject='SUBCAPTION' styles='CaptionFont' />");
        xml.append("    </application>");
        xml.append(" </styles>");
        xml.append("</chart>");

        return xml.toString();

    }


    /**
     * <pre>
     *  1. 개   요 : Make chart xml for co-author network chart of overview page
     *  2. 처리내용 :
     * </pre>
     *  @Method Name : buildOverviewNetworkInCenter
     *  @param source
     *  @param lang
     *  @param coworks
     *  @param contextPath
     *  @return
     */
    public static String buildOverviewNetworkInCenter (Map source, String lang, List < Map > coworks, String
            contextPath, String photoUrl){

        double maxTtl = 0;
        double maxCoworkCnt = 0;
        double maxRel = 0;
        int radius = 20;
        dcMap = new HashMap<String, String>();
        int dfFillIdx = 0;
        String fillColor = "";

        for (int jj = 0; jj < coworks.size(); jj++) {
            int total = Integer.parseInt(coworks.get(jj).get("CNT").toString());
            //if(maxTtl<total) maxTtl = total;
            if (maxCoworkCnt < total) maxCoworkCnt = total;
        }

        StringBuffer sb = new StringBuffer();
        sb.append("<chart xAxisMinValue='0' showBorder='0'  canvasBorderAlpha='0' canvasBorderThickness='0' chartTopMargin='3' chartLeftMargin='3' chartRightMargin='3' chartBottomMargin='3' xAxisMaxValue='" + 100 + "' yAxisMinValue='0' yAxisMaxValue='" + 100 + "' is3D='0' viewMode='1' showformbtn='0' enableLink='0' baseFontSize='12' baseFont='Malgun Gothic' ");
        sb.append("divLineAlpha='30' numvdivlines='0' divLineIsDashed='0' bgColor='FFFFFF, FFFFFF' >");
        int step = coworks.size() == 0 ? 0 : 360 / coworks.size();
        if (coworks.size() > 0) maxRel = Integer.parseInt(coworks.get(0).get("CNT").toString());

        double total = Double.parseDouble(source.get("TOTAL").toString());
        if (maxTtl < total) maxTtl = total;

        radius = (int) ((total / maxTtl) * 20) + 15;

        if (dcMap.get(source.get("SBJT_CD")) == null) {
            fillColor = fillColors[dfFillIdx];
            dfFillIdx++;
            dcMap.put((String) source.get("SBJT_CD"), fillColor);
        }

        int imageHeight = 68;
        int imageWidth = 56;
        BufferedImage bi = null;
        int width = 0;
        int height = 0;
        String imageUrl = contextPath + "/images/no_researcher.gif";
        if (photoUrl != null && !"".equals(photoUrl)) {
            imageUrl = photoUrl;

            try {
                bi = ImageIO.read(new URL(imageUrl));
                width = bi.getWidth();
                height = bi.getHeight();
                System.out.println(width + " : " + height);
                double ratio = (imageWidth * 1.0) / (width * 1.0);
                double resize = height * ratio;
                imageHeight = (int) resize;
                System.out.println("imageHeight : " + imageHeight);
                bi.flush();

            } catch (MalformedURLException e) {
            } catch (IOException e) {
            } finally {
                if (bi != null) bi.flush();
            }

        }


        String nameKey = lang.equals("KOR") ? "KORNM" : "ENG_NM";
        String nameAbbrKey = lang.equals("KOR") ? "KORNM" : "ABBR_ENG_NM";
        String deptKey = lang.equals("KOR") ? "DEPT_KOR" : "DEPT_ENG_ABBR";

        imageUrl = contextPath + "/images/icon/person-icon-purple.png";

        sb.append("<dataset showPlotBorder='0' plotBorderAlpha='0' plotFillAlpha='0' allowDrag='1' showformbtn='0' seriesName='" + source.get(nameAbbrKey) + "'>");
        sb.append("<set x='50' y='50'  imageWidth='38' imageHeight='50' width='55' height='89' label='" + source.get(nameAbbrKey) + "' name='" + source.get(nameAbbrKey) + "' id='id_0' labelAlign='bottom' imageNode='1' imageurl='" + imageUrl + "' imageAlign='middle' toolText='" + source.get(nameKey) + "{br}-" + source.get(deptKey) + "'/>");
        //sb.append("<set x='50' y='50' label='"+source.get(nameAbbrKey)+"' name='"+source.get(nameAbbrKey)+"' id='id_0' width='60' height='60' imageNode='0' shape='RECTANGLE' color='"+dcMap.get(source.get("SBJT_CD"))+"' toolText='"+source.get(nameKey)+"{br}-"+source.get(deptKey)+"' />");
        sb.append("</dataset>");

        for (int jj = 0; jj < coworks.size(); jj++) {

            int degree = (450 - step * jj) % 360;

            total = Double.parseDouble(coworks.get(jj).get("CNT").toString());

            double radians = (Math.PI / 180) * degree;

            double cnt = Double.parseDouble(coworks.get(jj).get("CNT").toString());
            double ratio = cnt / maxRel;

            double x = Math.sin(radians) * 40.0 + 50.0;
            double y = Math.cos(radians) * 35.0 + 50.0;

            radius = (int) ((cnt / maxCoworkCnt) * 20) + 15;

            String labelValue = StringUtils.replace((String) coworks.get(jj).get(nameAbbrKey), "'", "&#39;");
            String dispValue = StringUtils.replace((String) coworks.get(jj).get(nameKey), "'", "&#39;");

            if (dcMap.get(coworks.get(jj).get("SBJT_CD")) == null) {
                fillColor = fillColors[dfFillIdx];
                dfFillIdx++;
                dcMap.put((String) coworks.get(jj).get("SBJT_CD"), fillColor);
            }
            String targetUserId = (String) coworks.get(jj).get("USERID");
            String deptNm = (String) coworks.get(jj).get(deptKey);
            sb.append("<dataset showPlotBorder='0' plotBorderAlpha='0' allowDrag='1' showformbtn='0' seriesName='" + dispValue + "'>");
            sb.append("<set x='" + x + "' y='" + y + "' label='" + labelValue + "' name='" + labelValue + "' id='id_" + (jj + 1) + "' radius='" + radius + "' shape='CIRCLE' color='" + dcMap.get(coworks.get(jj).get("SBJT_CD")) + "' labelAlign='top' link='JavaScript:chartClick(" + targetUserId + ", \\\"" + dispValue + "\\\");' toolText='" + dispValue + "{br}-" + deptNm + " '/>");
            sb.append("</dataset>");
        }

        sb.append("<connectors color='FF0000' stdThickness='5' strength='1'>");

        for (int ki = 0; ki < coworks.size(); ki++) {
            String color = "AAAAAA";

            int cnt = Integer.parseInt(coworks.get(ki).get("CNT").toString());

            double alpha = (cnt / maxRel) * 0.8 + 0.2;

            sb.append("<connector strength='" + (alpha) + "' ");
            sb.append("from='id_0' ");
            sb.append("label ='" + cnt + "' to='id_" + (ki + 1) + "' alpha='" + (alpha * 100) + "' ");
            sb.append("color='" + color + "' arrowAtStart='0' arrowAtEnd='0' />");
        }

        sb.append("</connectors>");

        sb.append("<styles>");
        sb.append("<definition>");
        sb.append("   <style name='myLabelsFont' type='font' font='Malgun Gothic' bold='1' size='11' color='555555'/>");
        sb.append("</definition>");
        sb.append("<application>");
        sb.append("   <apply toObject='DataLabels' styles='myLabelsFont' />");
        sb.append("</application>");
        sb.append("</styles>");

        sb.append("</chart>");

        return sb.toString();


    }

    /**
     * <pre>
     *  1. 개   요 : Make chart xml for network chart among department on overview page
     *  2. 처리내용 :
     * </pre>
     *  @Method Name : buildOverviewNetworkAmongDept
     *  @param source
     *  @param sname
     *  @param coworks
     *  @param contextPath
     *  @return
     */
    public static String buildOverviewNetworkAmongDept (Map source, String sname, List < Map > coworks, String
            contextPath){

        double maxTtl = 0;
        double maxCoworkCnt = 0;
        double maxRel = 0;
        int radius = 20;
        dcMap = new HashMap<String, String>();
        int dfFillIdx = 0;
        String fillColor = "";

        for (int jj = 0; jj < coworks.size(); jj++) {
            int total = Integer.parseInt(coworks.get(jj).get("CNT").toString());
            //if(maxTtl<total) maxTtl = total;
            if (maxCoworkCnt < total) maxCoworkCnt = total;
        }

        StringBuffer sb = new StringBuffer();
        sb.append("<chart xAxisMinValue='0' showBorder='0'  canvasBorderAlpha='0' canvasBorderThickness='0' chartTopMargin='3' chartLeftMargin='3' chartRightMargin='3' chartBottomMargin='3' xAxisMaxValue='" + 100 + "' yAxisMinValue='0' yAxisMaxValue='" + 100 + "' is3D='0' viewMode='0' showformbtn='0' enableLink='0' baseFontSize='11' baseFont='Malgun Gothic' ");
        sb.append("showLegend='1' use3DLighting='0' useEllipsesWhenOverflow='0' labelDisplay='WRAP' useRoundEdges='1'");
        sb.append("divLineAlpha='30' numvdivlines='0' divLineIsDashed='0' bgColor='FFFFFF, FFFFFF' >");
//    	sb.append("<chart constrength='2' arrowAtStart='0' arrowAtEnd='1' conDashed='0' conDashLen='5' conDashGap='5' conAlpha='100' conColor='FF5904' stdThickness='2' catVerticalLineDashGap='2' catVerticalLineDashLen='4' catVerticalLineDashed='0' catVerticalLineAlpha='45' catVerticalLineThickness='1' catVerticalLineColor='7B7D6D' catFontColor='60634E' catFontSize='10' catFont='Verdana' canvasBottomMargin='-1' canvasTopMargin='-1' canvasRightMargin='-1' canvasLeftMargin='-1' unescapeLinks='1' exportDataCaptureCallback='FC_ExportDataReady' exportDialogPBColor='E2E2E2' exportDialogFontColor='666666' exportDialogBorderColor='999999' exportDialogColor='FFFFFF' exportDialogMessage='Capturing Data : ' showExportDialog='1' exportCallback='FC_Exported' exportParameters='' exportFileName='FusionCharts' exportHandler='' exportTargetWindow='_self' exportAction='download' exportAtClient='0' exportFormats='JPG=Save as JPEG Image|PNG=Save as PNG Image|PDF=Save as PDF' exportShowMenuItem='0' exportEnabled='0' showVLineLabelBorder='1' outCnvBaseFontColor='60634E' outCnvBaseFontSize='10' outCnvBaseFont='Verdana' baseFontColor='60634E' baseFontSize='10' baseFont='Verdana' seriesNameInToolTip='1' showToolTipShadow='0' toolTipSepChar=', ' toolTipBorderColor='545454' toolTipBgColor='FFFFFF' showToolTip='1' logoScale='100' logoLink='' logoAlpha='100' logoPosition='TL' logoURL='' bgSWFAlpha='100' bgSWF='' exportDataFormattedVal='0' exportDataSeparator=',' exportDataMenuItemLabel='Copy data to clipboard' showExportDataMenuItem='0' showPrintMenuItem='1' aboutMenuItemLink='n-http://www.fusioncharts.com/?BS=AboutMenuLink' aboutMenuItemLabel='About FusionCharts' showFCMenuItem='1' yAxisValueDecimals='2' forceDecimals='0' decimals='2' inThousandSeparator='' inDecimalSeparator='' thousandSeparator=',' decimalSeparator='.' numberSuffix='' numberPrefix='' numberScaleValue='1000,1000' numberScaleUnit='K,M' defaultNumberScale='' formatNumberScale='1' formatNumber='1' negativeColor='ff0000' nodeScale='1' use3DLighting='1' plotBorderAlpha='95' plotBorderThickness='1' plotBorderColor='666666' showPlotBorder='1' plotFillAlpha='100' alternateHGridAlpha='35' alternateHGridColor='D8DCC5' showAlternateHGridColor='1' zeroPlaneAlpha='45' zeroPlaneThickness='1' zeroPlaneColor='7B7D6D' showZeroPlane='1' divLineDashGap='2' divLineDashLen='4' divLineIsDashed='0' divLineAlpha='45' divLineThickness='1' divLineColor='7B7D6D' numDivLines='0' reverseLegend='0' legendScrollBtnColor='545454' legendScrollBarColor='545454' legendScrollBgColor='CCCCCC' legendAllowDrag='0' legendShadow='1' legendBgAlpha='100' legendBgColor='ffffff' legendBorderAlpha='100' legendBorderThickness='1' legendBorderColor='545454' legendMarkerCircle='0' legendCaption='' legendPosition='BOTTOM' showLegend='1' canvasBorderAlpha='100' canvasBorderThickness='2' canvasBorderColor='545454' canvasBgAngle='0' canvasBgRatio='' canvasBgAlpha='100' canvasBgColor='FFFFFF' showBorder='0' bgAngle='270' bgRatio='0,100' bgAlpha='60,50' bgColor='CFD4BE,F3F5DD' btnTextColor='000000' btnPadding='5' formMethod='POST' formAction='/demos/gallery/DataHandlerModified.asp'  formTarget='dragNodeXMLFrame' formBtnBgColor='FFFFFF' formBtnBorderColor='CBCBCB' formBtnTitle='Submit' formBtnWidth='80' showFormBtn='1' enableLink='0' viewMode='0' clickURL='' yAxisNameWidth='undefined' rotateYAxisName='1' adjustDiv='1' yAxisValuesStep='1' showDivLineValues='0' showLimits='0' showYAxisValues='0' staggerLines='2' labelStep='1' slantLabels='0' rotateLabels='' labelDisplay='WRAP' showLabels='0' defaultAnimation='1' animation='1' xAxisMaxValue='100' xAxisMinValue='0' yAxisMaxValue='100' yAxisMinValue='0' setAdaptiveYMin='0' yAxisName='' xAxisName='' subCaption='' caption='Project Plan for Construction of a House (time duration in weeks)' chartBottomMargin='15' chartTopMargin='15' chartRightMargin='15' chartLeftMargin='15' legendPadding='6' labelPadding='3' yAxisValuesPadding='2' yAxisNamePadding='5' xAxisNamePadding='5' captionPadding='10' paletteColors='' palette='2'  >");
        int step = coworks.size() == 0 ? 0 : 360 / coworks.size();
        if (coworks.size() > 0) maxRel = Integer.parseInt(coworks.get(0).get("CNT").toString());

        double total = Double.parseDouble(source.get("TOTAL").toString());
        if (maxTtl < total) maxTtl = total;

        radius = (int) ((total / maxTtl) * 15) + 15;

        if (dcMap.get(source.get("DEPT_KOR")) == null) {
            fillColor = fillColors[dfFillIdx];
            dfFillIdx++;
            dcMap.put((String) source.get("DEPT_KOR"), fillColor);
        }


        sb.append("<dataset showPlotBorder='0' alpha='10' plotBorderAlpha='0' allowDrag='1' showformbtn='0' seriesName='" + source.get(sname) + "'>");
        sb.append("<set x='50' y='50' name='" + source.get(sname) + "' radius='" + radius + "' id='id_0' shape='CIRCLE' color='" + fillColor + "'/> ");
        sb.append("</dataset>");

        for (int jj = 0; jj < coworks.size(); jj++) {

            int degree = (450 - step * jj) % 360;

            total = Double.parseDouble(coworks.get(jj).get("CNT").toString());

            double radians = (Math.PI / 180) * degree;

            double cnt = Double.parseDouble(coworks.get(jj).get("CNT").toString());
            double ratio = cnt / maxRel;

            double x = Math.sin(radians) * 35.0 + 50.0;
            double y = Math.cos(radians) * 40.0 + 50.0;

            radius = (int) ((cnt / maxCoworkCnt) * 15) + 20;

            String dispValue = StringUtils.replace((String) coworks.get(jj).get("DEPT_KOR"), "'", "&#39;");

            if (dcMap.get(coworks.get(jj).get("DEPT_KOR")) == null) {
                fillColor = fillColors[dfFillIdx];
                dfFillIdx++;
                dcMap.put((String) coworks.get(jj).get("DEPT_KOR"), fillColor);
            }
            String targetSbjtCd = (String) coworks.get(jj).get("DEPT_KOR");
            String deptNm = (String) coworks.get(jj).get("DEPT_KOR");
            sb.append("<dataset showPlotBorder='0' plotBorderAlpha='0' alpha='10' allowDrag='1' showformbtn='0' seriesName='" + dispValue + "'>");
            sb.append("<set x='" + x + "' y='" + y + "' name='" + dispValue + "' id='id_" + (jj + 1) + "' radius='" + radius + "' shape='CIRCLE' color='" + fillColor + "' labelAlign='top' link='JavaScript:chartClick(" + targetSbjtCd + ");' toolText='" + deptNm + " '/>");
            sb.append("</dataset>");
        }

        sb.append("<connectors color='FF0000' stdThickness='5' strength='1'>");

        for (int ki = 0; ki < coworks.size(); ki++) {
            String color = "AAAAAA";

            int cnt = Integer.parseInt(coworks.get(ki).get("CNT").toString());

            double alpha = (cnt / maxRel) * 0.9 + 0.6;

            sb.append("<connector strength='" + (alpha) + "' ");
            sb.append("from='id_0' ");
            sb.append("label ='" + cnt + "' to='id_" + (ki + 1) + "' alpha='" + (alpha * 100) + "' ");
            sb.append("color='" + color + "' arrowAtStart='0' arrowAtEnd='0' />");
        }

        sb.append("</connectors>");

        sb.append("<styles>");
        sb.append("<definition>");
        sb.append("   <style name='myLabelsFont' type='font' font='Malgun Gothic' size='11' color='000000'/>");
        sb.append("</definition>");
        sb.append("<application>");
        sb.append("   <apply toObject='DataLabels' styles='myLabelsFont' />");
        sb.append("</application>");
        sb.append("</styles>");

        sb.append("</chart>");

        return sb.toString();


    }

    public static String build2DBarSameDept (List < Map > articleNos, String contextPath){

        StringBuffer xml = new StringBuffer();

        xml.append("<chart caption=''  yAxisName='No. of Publications' bgColor='F1F1F1' ")
                .append("exportEnabled='1' exportAtClient='0' exportAction='save' exportHandler='" + contextPath + "/servlet/FCExporter/export.do' exportCallBack='myFN' ")
                .append("exportShowMenuItem='0' exportDialogMessage='Building chart output ' ")
                .append("canvasBorderThickness='1' canvasBorderColor='999999' plotFillAngle='330' plotBorderColor='999999' showAlternateVGridColor='1' divLineAlpha='0' baseFont='Malgun Gothic'>");
        for (int ii = 0; ii < articleNos.size(); ii++) {
            xml.append("<set label='" + articleNos.get(ii).get("KORNM") + "                    ' value='" + articleNos.get(ii).get("TOTAL") + "' />");
        }

        //xml.append("</chart>");

        xml.append("<styles>");
        xml.append("    <definition>");
        xml.append("        <style name='CaptionFont' type='font' font='Malgun Gothic' size='12'/>");
        xml.append("        <style name='yxv' type='font' font='Malgun Gothic' size='12' align='left' />");
        xml.append("   </definition>");
        xml.append("    <application>");
        xml.append("       <apply toObject='CAPTION' styles='CaptionFont' />");
        xml.append("       <apply toObject='SUBCAPTION' styles='CaptionFont' />");
        xml.append("       <apply toObject='YAXISVALUES' styles='yxv' />");
        xml.append("    </application>");
        xml.append(" </styles>");
        xml.append("</chart>");

        return xml.toString();
    }

    public static String buildExfundCoAuthorNetworkChart (AnalysisVo
                                                                  mainUser, List < AnalysisVo > list, RimsSearchVo searchVo, String contextPath, String lang, String photoUrl){

        double maxTtl = 0;
        double maxCoworkCnt = 0;
        double maxRel = 0;
        int radius = 20;
        dcMap = new HashMap<String, String>();
        int dfFillIdx = 0;
        String fillColor = "";

        for (int jj = 0; jj < list.size(); jj++) {
            int total = list.get(jj).getCoArtsCo();
            //if(maxTtl<total) maxTtl = total;
            if (maxCoworkCnt < total) maxCoworkCnt = total;
        }

        StringBuffer sb = new StringBuffer();
        sb.append(" <chart xAxisMinValue='0' canvasBorderAlpha='0' canvasBorderThickness='0' chartTopMargin='3' chartLeftMargin='3' chartRightMargin='3' chartBottomMargin='3' xAxisMaxValue='" + 100 + "' yAxisMinValue='0' yAxisMaxValue='" + 100 + "' is3D='0' viewmode='0' showformbtn='0' baseFontSize='12' baseFont='Malgun Gothic' ");
        sb.append(" divLineAlpha='30' numvdivlines='5' divLineIsDashed='1' bgColor='F7F7F7, E9E9E9' useEllipsesWhenOverflow='0' ");
        sb.append(" exportShowMenuItem='0' exportDialogMessage='Building chart output ' unescapeLinks='0' ");
        sb.append(" exportEnabled='1' exportAtClient='0' exportAction='save' exportHandler='" + contextPath + "/servlet/FCExporter/export.do' exportCallBack='myFN' >");

        int step = list.size() == 0 ? 0 : 360 / list.size();
        if (list.size() > 0) maxRel = list.get(0).getCoArtsCo();

        double total = Double.parseDouble(mainUser.getArtsCo().toString());
        if (maxTtl < total) maxTtl = total;

        radius = (int) ((total / maxTtl) * 10) + 5;

        if (dcMap.get(mainUser.getDeptKor()) == null) {
            fillColor = fillColors[dfFillIdx];
            dfFillIdx++;
            dcMap.put(mainUser.getDeptKor(), fillColor);
        }

        int imageHeight = 136;
        int imageWidth = 112;
        BufferedImage bi = null;
        int width = 0;
        int height = 0;
        String imageUrl = contextPath + "/images/no_researcher.gif";
        if (photoUrl != null && !"".equals(photoUrl)) {
            imageUrl = photoUrl;
            try {
                bi = ImageIO.read(new URL(imageUrl));
                width = bi.getWidth();
                height = bi.getHeight();
                System.out.println(width + " : " + height);
                double ratio = (imageWidth * 1.0) / (width * 1.0);
                double resize = height * ratio;
                imageHeight = (int) resize;
                System.out.println("imageHeight : " + imageHeight);
                bi.flush();

            } catch (MalformedURLException e) {
            } catch (IOException e) {
            } finally {
                if (bi != null) bi.flush();
            }
        }

        String name = lang.equals("KOR") ? mainUser.getKorNm() : mainUser.getEngNm();
        String abbrName = lang.equals("KOR") ? mainUser.getKorNm() : mainUser.getAbbrEngNm();
        String dept = lang.equals("KOR") ? mainUser.getDeptKor() : mainUser.getDeptEngAbbr();

        if ("".equals(abbrName.replace(",", ""))) abbrName = mainUser.getKorNm();

        imageUrl = contextPath + "/images/icon/person-icon-purple.png";

        sb.append("<dataset showPlotBorder='0' plotBorderAlpha='0' allowDrag='1' showformbtn='0' plotFillAlpha='0' seriesName='" + name + "'>");
        //sb.append("<set x='50' y='50'  id='id_0' width='"+imageWidth+"' height='"+imageHeight+"' imageNode='1' imageurl='"+imageUrl+"' imageAlign='middle' toolText='"+source.get(nameKey)+"{br}-"+source.get(deptKey)+"' />");
        sb.append("<set x='50' y='50'  id='id_0'  label='" + abbrName + "' name='" + abbrName + "'  labelAlign='bottom' imageWidth='76' imageHeight='99' width='76' height='129' imageNode='1' imageurl='" + imageUrl + "' imageAlign='top' toolText='" + name + "{br}-" + dept + "' />");
        //sb.append("<set x='50' y='50' label='"+source.get(nameAbbrKey)+"' name='"+source.get(nameAbbrKey)+"' id='id_0' radius='"+radius+"' imageNode='0' shape='CIRCLE' color='"+dcMap.get(source.get("SBJT_CD"))+"' toolText='"+source.get(nameKey)+"{br}-"+source.get(deptKey)+"' />");
        sb.append("</dataset>");

        boolean dist = true;
        for (int jj = 0; jj < list.size(); jj++) {

            int degree = (450 - step * jj) % 360;

            total = Double.parseDouble(list.get(jj).getCoArtsCo().toString());

            double radians = (Math.PI / 180) * degree;

            double cnt = Double.parseDouble(list.get(jj).getCoArtsCo().toString());
            double ratio = cnt / maxRel;

            double distRatio = dist == true ? CacheUtils.getHighDistanceRatio() / 10.0 : CacheUtils.getLowDistanceRatio() / 10.0;

            double x = Math.sin(radians) * 35.0 * distRatio + 50.0;
            double y = Math.cos(radians) * 40.0 * distRatio + 50.0;

            radius = (int) ((cnt / maxCoworkCnt) * 20) + 15;

            name = list.get(jj).getKorNm();
            dept = list.get(jj).getDeptKor();
            if ("".equals(name.replace(",", "").trim())) name = list.get(jj).getKorNm();

            String labelValue = StringUtils.replace(name, "'", "&#39;");

            if (dcMap.get(list.get(jj).getDeptKor()) == null) {
                fillColor = fillColors[dfFillIdx];
                dfFillIdx++;
                dcMap.put(list.get(jj).getDeptKor(), fillColor);
            }
            sb.append("<dataset showPlotBorder='0' plotBorderAlpha='0' allowDrag='1' showformbtn='0' seriesName='" + labelValue + "'>");
            sb.append("<set x='" + x + "' y='" + y + "' label='" + labelValue + "{br}-" + dept + "' name='" + labelValue + "-" + dept + "' id='id_" + (jj + 1) + "'  width='150' height='150' radius='" + radius + "' shape='CIRCLE' color='" + dcMap.get(list.get(jj).getDeptKor()) + "' labelAlign='middle' link='j-chartClick-" + R2Constant.COAUTHOR_TARGET_EXFUND + ";" + dept + ";" + labelValue + "' toolText='" + labelValue + "{br}-" + dept + " '/>");
            sb.append("</dataset>");

            dist = dist == true ? false : true;
        }

        sb.append("<connectors color='FF0000' stdThickness='5' strength='1'>");

        for (int ki = 0; ki < list.size(); ki++) {
            String color = "AAAAAA";

            name = list.get(ki).getKorNm();
            dept = list.get(ki).getDeptKor();

            int cnt = list.get(ki).getCoArtsCo();
            double alpha = (cnt / maxRel) * 0.8 + 0.2;

            sb.append("<connector strength='" + (alpha) + "' ");
            sb.append("from='id_0' ");
            sb.append("label ='" + cnt + "' to='id_" + (ki + 1) + "' alpha='" + (alpha * 100) + "'  link='j-chartClick-" + R2Constant.COAUTHOR_TARGET_EXFUND + ";" + dept + ";" + name + "' ");
            sb.append("color='" + color + "' arrowAtStart='0' arrowAtEnd='0' />");
        }
        sb.append("</connectors>");
        sb.append("<styles>");
        sb.append("<definition>");
        sb.append("   <style name='myLabelsFont' type='font' font='Malgun Gothic' bold='1' size='11' color='555555'/>");
        sb.append("</definition>");
        sb.append("<application>");
        sb.append("   <apply toObject='DataLabels' styles='myLabelsFont' />");
        sb.append("</application>");
        sb.append("</styles>");
        sb.append("</chart>");

        return sb.toString();
    }

    public static String buildOverviewInstitutionCitedChartXml (List < AnalysisVo > institutionWithYearList, RimsSearchVo searchVo){
        StringBuffer xml = new StringBuffer();
        String gubun = searchVo.getGubun();
        int i = 0;
            /*
            xml.append(" <chart animation='0' caption='' xAxisName='' yAxisName='' formatNumberScale='0' decimals='2' forceDecimals='1'")
            .append(" divLineAlpha='30' numvdivlines='5' divLineIsDashed='1' bgColor='FFFFFF, FFFFFF' ")
            .append(" showValues='1' showLabels='1' showPercentageInLabel='0' showBorder='0'  canvasBorderAlpha='0' canvasBorderThickness='0'")
            .append(" exportEnabled='1' exportAtClient='0' exportAction='save' ")
            .append(" exportShowMenuItem='0' exportDialogMessage='Building chart output ' ")
            .append(" useRoundEdges='1' labelDisplay='ROTATE' slantLabels='1' legendPosition ='CENTER '>");
            */
        xml.append("<chart ")
                .append(" caption='' ")
                .append(" subcaption='' ")
                .append(" baseFontColor='#666666' ")
                .append(" baseFontSize='11' ")
                .append(" subcaptionFontBold='0' ")
                .append(" canvasBgAlpha='0' ")
                .append(" showValues='0' ")
                .append(" paletteColors='" + paletteColors + "'")
                .append(" bgAlpha='0' ")
                .append(" showBorder='0' ")
                .append(" showShadow='0' ")
                .append(" showAlternateHGridColor='0' ")
                .append(" showCanvasBorder='0' ")
                .append(" showXAxisLine='1' ")
                .append(" xAxisName='' ")
                .append(" xAxisLineThickness='1' ")
                .append(" xAxisLineColor='#cdcdcd' ")
                .append(" xAxisNameFontColor='#8d8d8d' ")
                .append(" yAxisName='' ")
                .append(" yAxisNameFontColor='#8d8d8d' ")
                .append(" canvasBgColor='#ffffff' ")
                .append(" lineThickness='4' ")
                .append(" legendBgColor='#ffffff' ")
                .append(" legendBgAlpha='100' ")
                .append(" legendBorderAlpha='50' ")
                .append(" legendBorderColor='#888888' ")
                .append(" legendShadow='0' ")
                .append(" legendPosition='CENTER' ")
                .append(" divlineAlpha='100' ")
                .append(" numDivLines='10' ")
                .append(" divlineColor='#999999' ")
                .append(" divlineThickness='1' ")
                .append(" divLineIsDashed='1'")
                .append(" divLineDashLen='1'")
                .append(" divLineGapLen='1' ")
                .append(" toolTipColor='#ffffff' ")
                .append(" toolTipBorderColor='#ffffff' ")
                .append(" toolTipBorderThickness='1' ")
                .append(" toolTipBgColor='#000000' ")
                .append(" toolTipBgAlpha='80' ")
                .append(" toolTipBorderRadius='4' ")
                .append(" toolTipPadding='10' ")
                .append(" toolTipFontSize ='20' ")
                .append(" anchorBgColor='#ffffff' ")
                .append(" anchorRadius='5' ")
                .append(" anchorBorderThickness='3' ")
                .append(" anchorTrackingRadius='15' ")
                .append(" showHoverEffect='1' ")
                .append(" formatNumberScale='0'")
                .append(" labelDisplay='rotate' ")
                .append(" slantLabels='1' ")
                .append(" plotBorderColor='#ffffff' ") //bar 테두리없애기
                .append(" usePlotGradientColor='0' ") //bar의 그라데이션 없애기
                .append(" exportEnabled='0' ")
                .append(" exportAtClient='0' ")
                .append(" exportShowMenuItem='0' ")
                .append(" >");
        String fromYear = searchVo.getFromYear();
        String toYear = searchVo.getToYear();

        int fy = Integer.parseInt(fromYear);
        int ty = Integer.parseInt(toYear);
        Map<String, AnalysisVo> yearMap = new HashMap<>();

        for(AnalysisVo institution : institutionWithYearList){
            yearMap.put(institution.getPubYear(), institution);
        }

        for(int ii = fy; ii <= ty; ii++){
            String year = ((Integer)ii).toString();
            AnalysisVo institution = yearMap.get(year);
            Double val = institution.getWosCitedAvrg();
            if (R2Constant.ARTICLE_GUBUN_SCOPUS.equals(gubun)) val = institution.getScpCitedAvrg();
            else if (R2Constant.ARTICLE_GUBUN_KCI.equals(gubun)) val = institution.getKciCitedAvrg();

            double dValue = Math.round(val * 100d) / 100d;
            String tText = institution.getPubYear().trim() + " : " + dValue;
            xml.append("<set label='" + institution.getPubYear().trim() + "' value='" + dValue + "'  toolText='" + tText + "' />");
            i++;
        }


        xml.append("<styles>");
        xml.append("    <definition>");
        xml.append("        <style name='myLabelsFont' type='font' font='Malgun Gothic' size='12' bold='1' />");
        xml.append("        <style name='CaptionFont' type='font' size='12'/>");
        xml.append("   </definition>");
        xml.append("    <application>");
        xml.append("       <apply toObject='CAPTION' styles='CaptionFont' />");
        xml.append("       <apply toObject='SUBCAPTION' styles='CaptionFont' />");
        xml.append("       <apply toObject='DataLabels' styles='myLabelsFont' />");
        xml.append("    </application>");
        xml.append(" </styles>");

        xml.append("</chart>");

        return xml.toString();
    }

    public static String buildInstitutionRankquartyChartXml (List < AnalysisVo > list, RimsSearchVo searchVo, String contextPath){
        String type = searchVo.getType(); //CNT / PERCENT
        StringBuffer xml = new StringBuffer();

        xml.append("<chart ")
                .append(" adjustDiv= '0' ")
                .append(" numDivlines= '1' ")
                .append(" showValues= '0' ")
                .append(" bgColor= 'ffffff' ")
                .append(" borderAlpha= '20' ")
                .append(" thousandSeparatorPosition= '2,3' ") //그래프 위로 나타난 값의 천단위에, 붙여줌
                .append(" formatNumberScale='0'")
                .append(" showCanvasBorder= '0' ")
                .append(" usePlotGradientColor= '0' ")
                .append(" showBorder='0' ")
                .append(" plotBorderAlpha= '10' ")
                .append(" legendBorderAlpha= '0' ")
                .append(" legendShadow= '0' ")
                .append(" valueFontColor= 'ffffff' ")
                .append(" showXAxisLine= '1' ")
                .append(" xAxisLineColor= '999999' ")
                .append(" divlineColor= '999999' ")
                .append(" divLineIsDashed= '1' ")
                .append(" showAlternateVGridColor= '0' ")
                .append(" showHoverEffect='1' ")
                .append(" toolTipColor='#ffffff' ")
                .append(" toolTipBorderColor='#ffffff' ")
                .append(" toolTipBorderThickness='1' ")
                .append(" toolTipBgColor='#000000' ")
                .append(" toolTipBgAlpha='80' ")
                .append(" toolTipBorderRadius='4' ")
                .append(" toolTipPadding='10' ")
                .append(" toolTipFontSize ='20' ")
                .append(" exportEnabled='1' ")
                .append(" exportAtClient='0' ")
                .append(" exportAction='save' ")
                .append(" exportShowMenuItem='0' ")
                .append(" exportDialogMessage='Building chart output' ")
                .append(" exportHandler='" + contextPath + "/servlet/FCExporter/export.do' exportCallBack='myFN' ");
        if (type != null && type.equals("PERCENT")) {
            xml.append(" stack100percent= '1' ");
            xml.append(" showpercentvalues= '1' ");
        }
        xml.append(" >");

        int fy = Integer.parseInt(searchVo.getFromYear());
        int ty = Integer.parseInt(searchVo.getToYear());

        xml.append("<categories >");
        for (int ii = ty; ii >= fy; ii--) {
            xml.append("<category label='" + ii + "' />");
        }
        xml.append("</categories>");

        Map totalByYearMap = convertAnalysisVoListToMapWithCompareValue(list, "rankquarty", "total", "prodYear", "cnt");
        Map q1Map = convertAnalysisVoListToMapWithCompareValue(list, "rankquarty", "Q1", "prodYear", "cnt");
        Map q2Map = convertAnalysisVoListToMapWithCompareValue(list, "rankquarty", "Q2", "prodYear", "cnt");
        Map q3Map = convertAnalysisVoListToMapWithCompareValue(list, "rankquarty", "Q3", "prodYear", "cnt");
        Map q4Map = convertAnalysisVoListToMapWithCompareValue(list, "rankquarty", "Q4", "prodYear", "cnt");

        for (int i = 0; i < 4; i++) {
            int num = i + 1;
            xml.append("<dataset seriesName='Q" + num + "' color='" + paletteColors.split(",")[i*2] + "'>");
            for (int ii = ty; ii >= fy; ii--) {

                Object val = null;
                if (i == 0) {
                    val = q1Map.get(Integer.toString(ii));
                } else if (i == 1) {
                    val = q2Map.get(Integer.toString(ii));
                } else if (i == 2) {
                    val = q3Map.get(Integer.toString(ii));
                } else if (i == 3) {
                    val = q4Map.get(Integer.toString(ii));
                }

                if (val == null) val = 0;

                if (type.equals("PERCENT")) {
                    Object tot = totalByYearMap.get(ii + "");

                    if((Integer) val != 0) val = (Double.parseDouble(val.toString()) / Double.parseDouble(tot.toString())) * 100;
                    else val = Double.parseDouble(val.toString());
                    xml.append("<set value='" + val + "' toolText='" + ii + "(Q" + num + ") : " + String.format("%1$,.2f", val) + "%'/>");
                } else {
                    xml.append("<set value='" + val + "' toolText='" + ii + "(Q" + num + ") : " + String.format("%,d", Integer.parseInt(val.toString())) + "'/>");
                }

            }
            xml.append("</dataset>");
        }
        xml.append("</chart>");

        return xml.toString();
    }

    public static String buildInstitutionArtChartXmlWithYear
            (List < AnalysisVo > institutionWithYearList, RimsSearchVo searchVo){

        String fromYear = searchVo.getFromYear();
        String toYear = searchVo.getToYear();

        StringBuffer xml = new StringBuffer();
        xml.append("<chart ")
                .append(" subcaption='' ")
                .append(" baseFontColor='#666666' ")
                .append(" baseFontSize='11' ")
                .append(" subcaptionFontBold='0' ")
                .append(" canvasBgAlpha='0' ")
                .append(" showValues='0' ")
                .append(" paletteColors='" + paletteColors + "'")
                .append(" bgAlpha='0' ")
                .append(" showBorder='0' ")
                .append(" showShadow='0' ")
                .append(" showAlternateHGridColor='0' ")
                .append(" showCanvasBorder='0' ")
                .append(" showXAxisLine='1' ")
                .append(" xAxisName='' ")
                .append(" xAxisLineThickness='1' ")
                .append(" xAxisLineColor='#cdcdcd' ")
                .append(" xAxisNameFontColor='#8d8d8d' ")
                .append(" yAxisName='' ")
                .append(" yAxisNameFontColor='#8d8d8d' ")
                .append(" canvasBgColor='#ffffff' ")
                .append(" lineThickness='4' ")
                .append(" legendBgColor='#ffffff' ")
                .append(" legendBgAlpha='100' ")
                .append(" legendBorderAlpha='50' ")
                .append(" legendBorderColor='#888888' ")
                .append(" legendShadow='0' ")
                .append(" legendPosition='CENTER' ")
                .append(" divlineAlpha='100' ")
                .append(" numDivLines='10' ")
                .append(" divlineColor='#999999' ")
                .append(" divlineThickness='1' ")
                .append(" divLineIsDashed='1'")
                .append(" divLineDashLen='1'")
                .append(" divLineGapLen='1' ")
                .append(" toolTipColor='#ffffff' ")
                .append(" toolTipBorderColor='#ffffff' ")
                .append(" toolTipBorderThickness='1' ")
                .append(" toolTipBgColor='#000000' ")
                .append(" toolTipBgAlpha='80' ")
                .append(" toolTipBorderRadius='4' ")
                .append(" toolTipPadding='10' ")
                .append(" toolTipFontSize ='20' ")
                .append(" anchorBgColor='#ffffff' ")
                .append(" anchorRadius='5' ")
                .append(" anchorBorderThickness='3' ")
                .append(" anchorTrackingRadius='15' ")
                .append(" showHoverEffect='1' ")
                .append(" formatNumberScale='0'")
                .append(" labelDisplay='rotate' ")
                .append(" slantLabels='1' ")
                .append(" exportEnabled='1' ")
                .append(" exportAtClient='0' ")
                .append(" exportAction='save' ")
                .append(" exportShowMenuItem='0' ")
                .append(" exportDialogMessage='Building chart output' ")
                .append(" plotBorderColor='#ffffff' ")
                .append(" usePlotGradientColor='0' ")
                .append(" >");

        int fy = Integer.parseInt(fromYear);
        int ty = Integer.parseInt(toYear);
        Map<String, String> yearMap = new HashMap<>();
        for(int ii = fy; ii <= ty; ii++){
            String year = ((Integer)ii).toString();
            for(int i = 0; i < institutionWithYearList.size(); i++){
                if(institutionWithYearList.get(i).getPubYear().equals(year)){
                    yearMap.put(year, institutionWithYearList.get(i).getArtsTotal().toString());
                }
            }
        }

        for(int ii = fy; ii <= ty; ii++){
            String year = ((Integer)ii).toString();
            xml.append("<set label=\""+year+"\" value=\""+yearMap.get(year)+"\" />");
        }


        xml.append("<styles>");
        xml.append("    <definition>");

        xml.append("        <style name='CaptionFont' type='font' size='12'/>");
        xml.append("   </definition>");
        xml.append("    <application>");
        xml.append("       <apply toObject='CAPTION' styles='CaptionFont' />");
        xml.append("       <apply toObject='SUBCAPTION' styles='CaptionFont' />");
        xml.append("    </application>");
        xml.append(" </styles>");

        xml.append("</chart>");

        return xml.toString();

    }
    /**
     * <pre>
     *  1. 개   요 : Make chart xml for institution article chart by year
     *  2. 처리내용 :
     * </pre>
     *  @Method Name : buildInstitutionArtChartXmlWithYear
     *  @param institutionWithYearList
     *  @param searchVo
     *  @param contextPath
     *  @return
     */
    public static String buildInstitutionArtChartXmlWithYear
    (List < AnalysisVo > institutionWithYearList, RimsSearchVo searchVo, String contextPath){

        String fromYear = searchVo.getFromYear();
        String toYear = searchVo.getToYear();

        //String caption = "Publications by year from "+fromYear+ " to " + toYear;
        StringBuffer xml = new StringBuffer();

		/*
		xml.append(" <chart animation='0' caption='' subcaption='' lineThickness='2' showValues='0' formatNumberScale='0' ")
		.append(" divLineAlpha='30' numvdivlines='5' divLineIsDashed='1' bgColor='F7F7F7, E9E9E9' ")
		.append(" exportEnabled='1' exportAtClient='0' exportAction='save' exportHandler='"+contextPath+"/servlet/FCExporter/export.do' exportCallBack='myFN' ")
		.append(" exportShowMenuItem='0' exportDialogMessage='Building chart output' ")
		.append(" anchorRadius='4' showLegend='1' legendPosition ='CENTER' >");
		*/
        xml.append("<chart ")
                .append(" subcaption='' ")
                .append(" baseFontColor='#666666' ")
                .append(" baseFontSize='11' ")
                .append(" subcaptionFontBold='0' ")
                .append(" canvasBgAlpha='0' ")
                .append(" showValues='0' ")
                .append(" paletteColors='" + fillColors[0] + "'")
                .append(" bgAlpha='0' ")
                .append(" showBorder='0' ")
                .append(" showShadow='0' ")
                .append(" showAlternateHGridColor='0' ")
                .append(" showCanvasBorder='0' ")
                .append(" showXAxisLine='1' ")
                .append(" xAxisName='' ")
                .append(" xAxisLineThickness='1' ")
                .append(" xAxisLineColor='#cdcdcd' ")
                .append(" xAxisNameFontColor='#8d8d8d' ")
                .append(" yAxisName='' ")
                .append(" yAxisNameFontColor='#8d8d8d' ")
                .append(" canvasBgColor='#ffffff' ")
                .append(" lineThickness='4' ")
                .append(" legendBgColor='#ffffff' ")
                .append(" legendBgAlpha='100' ")
                .append(" legendBorderAlpha='50' ")
                .append(" legendBorderColor='#888888' ")
                .append(" legendShadow='0' ")
                .append(" legendPosition='CENTER' ")
                .append(" divlineAlpha='0' ")
                .append(" numDivLines='10' ")
                .append(" divlineColor='#999999' ")
                .append(" divlineThickness='1' ")
                .append(" divLineIsDashed='1'")
                .append(" divLineDashLen='1'")
                .append(" divLineGapLen='1' ")
                .append(" toolTipColor='#ffffff' ")
                .append(" toolTipBorderColor='#ffffff' ")
                .append(" toolTipBorderThickness='1' ")
                .append(" toolTipBgColor='#000000' ")
                .append(" toolTipBgAlpha='80' ")
                .append(" toolTipBorderRadius='4' ")
                .append(" toolTipPadding='10' ")
                .append(" toolTipFontSize ='20' ")
                .append(" anchorBgColor='#ffffff' ")
                .append(" anchorRadius='5' ")
                .append(" anchorBorderThickness='3' ")
                .append(" anchorTrackingRadius='15' ")
                .append(" showHoverEffect='1' ")
                .append(" formatNumberScale='0'")
                .append(" labelDisplay='rotate' ")
                .append(" slantLabels='1' ")
                .append(" plotBorderColor='#ffffff' ") //bar 테두리없애기
                .append(" usePlotGradientColor='0' ") //bar의 그라데이션 없애기
                .append(" exportEnabled='1' ")
                .append(" exportAtClient='0' ")
                .append(" exportAction='save' ")
                .append(" exportShowMenuItem='0' ")
                .append(" exportDialogMessage='Building chart output' ")
                .append(" exportHandler='" + contextPath + "/servlet/FCExporter/export.do' exportCallBack='myFN' ")
                .append(" >");

        int fy = Integer.parseInt(fromYear);
        int ty = Integer.parseInt(toYear);

        xml.append("<categories >");
        for (int ii = fy; ii <= ty; ii++) xml.append("<category label='" + ii + "' />");
        xml.append("</categories>");

        Map yearNoMap = convertObjectListToMapWithCompareValue(institutionWithYearList, "clgNm", institutionWithYearList.get(0).getClgNm(), "pubYear", "artsTotal");

        String sn = institutionWithYearList.get(0).getClgNm();
        xml.append("<dataset seriesName='" + sn + "' id='" + sn + "' >");
        for (int ii = fy; ii <= ty; ii++) {
            Object val = yearNoMap.get(Integer.toString(ii));
            if (val == null)
                xml.append("<set label='" + ii + "' value='0' toolText='" + sn + " " + ii + " : 0' />");
            else
                xml.append("<set label='" + ii + "' value='" + val + "'  toolText='" + sn + " " + ii + " : " + val + "' />");
        }
        xml.append("</dataset>");

        xml.append("<styles>");
        xml.append("    <definition>");

        xml.append("        <style name='CaptionFont' type='font' size='12'/>");
        xml.append("   </definition>");
        xml.append("    <application>");
        xml.append("       <apply toObject='CAPTION' styles='CaptionFont' />");
        xml.append("       <apply toObject='SUBCAPTION' styles='CaptionFont' />");
        xml.append("    </application>");
        xml.append(" </styles>");

        xml.append("</chart>");

        return xml.toString();

    }

    /**
     * <pre>
     *  1. 개   요 : Make chart xml for college article chart by year
     *  2. 처리내용 :
     * </pre>
     *  @Method Name : buildCollegeArtChartXmlWithYear
     *  @param collegeWithYearList
     *  @param collegeList
     *  @param searchVo
     *  @param contextPath
     *  @return
     */
    public static String buildCollegeArtChartXmlWithYear
    (List < AnalysisVo > collegeWithYearList, List < AnalysisVo > collegeList, RimsSearchVo searchVo, String
            contextPath){

        String fromYear = searchVo.getFromYear();
        String toYear = searchVo.getToYear();

        StringBuffer xml = new StringBuffer();

        xml.append("<chart ")
                .append(" subcaption='' ")
                .append(" baseFontColor='#666666' ")
                .append(" baseFontSize='11' ")
                .append(" subcaptionFontBold='0' ")
                .append(" canvasBgAlpha='0' ")
                .append(" showValues='0' ")
                .append(" paletteColors='" + paletteColors + "' ")
                .append(" bgAlpha='0' ")
                .append(" showBorder='0' ")
                .append(" showShadow='0' ")
                .append(" showAlternateHGridColor='0' ")
                .append(" showCanvasBorder='0' ")
                .append(" showXAxisLine='1' ")
                .append(" xAxisName='' ")
                .append(" xAxisLineThickness='1' ")
                .append(" xAxisLineColor='#cdcdcd' ")
                .append(" xAxisNameFontColor='#8d8d8d' ")
                .append(" yAxisName='' ")
                .append(" yAxisNameFontColor='#8d8d8d' ")
                .append(" canvasBgColor='#ffffff' ")
                .append(" lineThickness='4' ")
                .append(" legendBgColor='#ffffff' ")
                .append(" legendBgAlpha='100' ")
                .append(" legendBorderAlpha='50' ")
                .append(" legendBorderColor='#888888' ")
                .append(" legendShadow='0' ")
                .append(" legendPosition='CENTER' ")
                .append(" divlineAlpha='0' ")
                .append(" numDivLines='10' ")
                .append(" divlineColor='#999999' ")
                .append(" divlineThickness='1' ")
                .append(" divLineIsDashed='1'")
                .append(" divLineDashLen='1'")
                .append(" divLineGapLen='1' ")
                .append(" toolTipColor='#ffffff' ")
                .append(" toolTipBorderColor='#ffffff' ")
                .append(" toolTipBorderThickness='1' ")
                .append(" toolTipBgColor='#000000' ")
                .append(" toolTipBgAlpha='80' ")
                .append(" toolTipBorderRadius='4' ")
                .append(" toolTipPadding='10' ")
                .append(" toolTipFontSize ='20' ")
                .append(" anchorBgColor='#ffffff' ")
                .append(" anchorRadius='5' ")
                .append(" anchorBorderThickness='3' ")
                .append(" anchorTrackingRadius='15' ")
                .append(" showHoverEffect='1' ")
                .append(" formatNumberScale='0'")
                .append(" labelDisplay='rotate' ")
                .append(" slantLabels='1' ")
                .append(" plotBorderColor='#ffffff' ") //bar 테두리없애기
                .append(" usePlotGradientColor='0' ") //bar의 그라데이션 없애기
                .append(" exportEnabled='1' ")
                .append(" exportAtClient='0' ")
                .append(" exportAction='save' ")
                .append(" exportShowMenuItem='0' ")
                .append(" exportDialogMessage='Building chart output' ")
                .append(" exportHandler='" + contextPath + "/servlet/FCExporter/export.do' exportCallBack='myFN' ")
                .append(" >");

        int fy = Integer.parseInt(fromYear);
        int ty = Integer.parseInt(toYear);

        xml.append("<categories >");
        for (int ii = fy; ii <= ty; ii++) xml.append("<category label='" + ii + "' />");
        xml.append("</categories>");

        int j = 0;
        for (AnalysisVo college : collegeList) {
            if (j >= 5) break;
            Map yearNoMap = convertObjectListToMapWithCompareValue(collegeWithYearList, "clgNm", college.getClgNm(), "pubYear", "artsTotal");

            String sn = college.getClgNm() + "";
            int fcIdx = j % 23;
            xml.append("<dataset seriesName='" + sn + "' color='" + fillColors[fcIdx] + "' id='" + college.getClgNm() + "' >");
            for (int ii = fy; ii <= ty; ii++) {
                Object val = yearNoMap.get(Integer.toString(ii));
                if (val == null)
                    xml.append("<set value='0' toolText='" + sn + " " + ii + " : 0' />");
                else
                    xml.append("<set value='" + val + "'  toolText='" + sn + " " + ii + " : " + val + "' />");
            }
            xml.append("</dataset>");
            j++;
        }

        xml.append("<styles>");
        xml.append("    <definition>");

        xml.append("        <style name='CaptionFont' type='font' size='12'/>");
        xml.append("   </definition>");
        xml.append("    <application>");
        xml.append("       <apply toObject='CAPTION' styles='CaptionFont' />");
        xml.append("       <apply toObject='SUBCAPTION' styles='CaptionFont' />");
        xml.append("    </application>");
        xml.append(" </styles>");

        xml.append("</chart>");

        return xml.toString();

    }

    /**
     * <pre>
     *  1. 개   요 : Make chart xml for researcher article chart by year
     *  2. 처리내용 :
     * </pre>
     *  @Method Name : buildResearcherArtChartXmlWithYear
     *  @param researcherWithYearList
     *  @param researcherList
     *  @param searchVo
     *  @param contextPath
     *  @return
     */
    public static String buildResearcherArtChartXmlWithYear
    (List < AnalysisVo > researcherWithYearList, List < AnalysisVo > researcherList, RimsSearchVo searchVo, String
            contextPath){

        String fromYear = searchVo.getFromYear();
        String toYear = searchVo.getToYear();

        StringBuffer xml = new StringBuffer();

        xml.append("<chart ")
                .append(" subcaption='' ")
                .append(" baseFontColor='#666666' ")
                .append(" baseFontSize='11' ")
                .append(" subcaptionFontBold='0' ")
                .append(" canvasBgAlpha='0' ")
                .append(" showValues='0' ")
                .append(" paletteColors='" + paletteColors + "' ")
                .append(" bgAlpha='0' ")
                .append(" showBorder='0' ")
                .append(" showShadow='0' ")
                .append(" showAlternateHGridColor='0' ")
                .append(" showCanvasBorder='0' ")
                .append(" showXAxisLine='1' ")
                .append(" xAxisName='' ")
                .append(" xAxisLineThickness='1' ")
                .append(" xAxisLineColor='#cdcdcd' ")
                .append(" xAxisNameFontColor='#8d8d8d' ")
                .append(" yAxisName='' ")
                .append(" yAxisNameFontColor='#8d8d8d' ")
                .append(" canvasBgColor='#ffffff' ")
                .append(" lineThickness='4' ")
                .append(" legendBgColor='#ffffff' ")
                .append(" legendBgAlpha='100' ")
                .append(" legendBorderAlpha='50' ")
                .append(" legendBorderColor='#888888' ")
                .append(" legendShadow='0' ")
                .append(" legendPosition='CENTER' ")
                .append(" divlineAlpha='100' ")
                .append(" numDivLines='10' ")
                .append(" divlineColor='#999999' ")
                .append(" divlineThickness='1' ")
                .append(" divLineIsDashed='1'")
                .append(" divLineDashLen='1'")
                .append(" divLineGapLen='1' ")
                .append(" toolTipColor='#ffffff' ")
                .append(" toolTipBorderColor='#ffffff' ")
                .append(" toolTipBorderThickness='1' ")
                .append(" toolTipBgColor='#000000' ")
                .append(" toolTipBgAlpha='80' ")
                .append(" toolTipBorderRadius='4' ")
                .append(" toolTipPadding='10' ")
                .append(" toolTipFontSize ='20' ")
                .append(" anchorBgColor='#ffffff' ")
                .append(" anchorRadius='5' ")
                .append(" anchorBorderThickness='3' ")
                .append(" anchorTrackingRadius='15' ")
                .append(" showHoverEffect='1' ")
                .append(" formatNumberScale='0'")
                .append(" labelDisplay='rotate' ")
                .append(" slantLabels='1' ")
                .append(" exportEnabled='1' ")
                .append(" exportAtClient='0' ")
                .append(" exportAction='save' ")
                .append(" exportShowMenuItem='0' ")
                .append(" exportDialogMessage='Building chart output' ")
                .append(" exportHandler='" + contextPath + "/servlet/FCExporter/export.do' exportCallBack='myFN' ")
                .append(" >");

        int fy = Integer.parseInt(fromYear);
        int ty = Integer.parseInt(toYear);

        xml.append("<categories >");
        for (int ii = fy; ii <= ty; ii++) xml.append("<category label='" + ii + "' />");
        xml.append("</categories>");

        int j = 0;
        for (AnalysisVo researcher : researcherList) {
            if (j >= 5) break;
            Map yearNoMap = convertObjectListToMapWithCompareValue(researcherWithYearList, "korNm", researcher.getKorNm(), "pubYear", "artsTotal");

            String sn = researcher.getKorNm() + "";
            int fcIdx = j % 23;
            xml.append("<dataset seriesName='" + sn + "' color='" + fillColors[fcIdx] + "' id='" + researcher.getKorNm() + "' >");
            for (int ii = fy; ii <= ty; ii++) {
                Object val = yearNoMap.get(Integer.toString(ii));
                if (val == null)
                    xml.append("<set value='0' toolText='" + sn + " " + ii + " : 0' />");
                else
                    xml.append("<set value='" + val + "'  toolText='" + sn + " " + ii + " : " + val + "' />");
            }
            xml.append("</dataset>");
            j++;
        }

        xml.append("<styles>");
        xml.append("    <definition>");

        xml.append("        <style name='CaptionFont' type='font' size='12'/>");
        xml.append("   </definition>");
        xml.append("    <application>");
        xml.append("       <apply toObject='CAPTION' styles='CaptionFont' />");
        xml.append("       <apply toObject='SUBCAPTION' styles='CaptionFont' />");
        xml.append("    </application>");
        xml.append(" </styles>");

        xml.append("</chart>");

        return xml.toString();

    }


    /**
     * <pre>
     *  1. 개   요 : Make chart xml college time cited chart by year
     *  2. 처리내용 :
     * </pre>
     *  @Method Name : buildCollegeTimeCitedChartXmlWithYear
     *  @param collegeWithYearList
     *  @param collegeList
     *  @param searchVo
     *  @param contextPath
     *  @return
     */
    public static String buildCollegeTimeCitedChartXmlWithYear
    (List < AnalysisVo > collegeWithYearList, List < AnalysisVo > collegeList, RimsSearchVo searchVo, String
            contextPath){

        StringBuffer xml = new StringBuffer();
        String gubun = searchVo.getGubun();
        String fromYear = searchVo.getFromYear();
        String toYear = searchVo.getToYear();
        String keyField = "pubYear";

        String valField = "wosCitedAvrg";
        if (R2Constant.ARTICLE_GUBUN_SCOPUS.equals(gubun)) valField = "scpCitedAvrg";
        else if (R2Constant.ARTICLE_GUBUN_KCI.equals(gubun)) valField = "kciCitedAvrg";

        //String caption = "Publications by year from "+fromYear+ " to " + toYear;
        String valueColumn = "SCI".equals(gubun) ? "AVG_SCI_TC" : "AVG_SCP_TC";
		/*
		xml.append("<chart animation='0' caption='' subcaption='' lineThickness='2' showValues='0' formatNumberScale='0' anchorRadius='4'  ")
		.append(" divLineAlpha='30' numvdivlines='5' divLineIsDashed='1' bgColor='F7F7F7, E9E9E9' ")
		.append(" exportEnabled='1' exportAtClient='0' exportAction='save' exportHandler='"+contextPath+"/servlet/FCExporter/export.do' exportCallBack='myFN' ")
		.append(" exportShowMenuItem='0' exportDialogMessage='Building chart output' ")
		.append(" showLegend='1' legendPosition ='CENTER' >");
		*/
        xml.append("<chart ")
                .append(" caption='' ")
                .append(" subcaption='' ")
                .append(" baseFontColor='#666666' ")
                .append(" baseFontSize='11' ")
                .append(" subcaptionFontBold='0' ")
                .append(" canvasBgAlpha='0' ")
                .append(" showValues='0' ")
                .append(" paletteColors='" + paletteColors + "' ")
                .append(" bgAlpha='0' ")
                .append(" showBorder='0' ")
                .append(" showShadow='0' ")
                .append(" showAlternateHGridColor='0' ")
                .append(" showCanvasBorder='0' ")
                .append(" showXAxisLine='1' ")
                .append(" xAxisName='' ")
                .append(" xAxisLineThickness='1' ")
                .append(" xAxisLineColor='#cdcdcd' ")
                .append(" xAxisNameFontColor='#8d8d8d' ")
                .append(" yAxisName='' ")
                .append(" yAxisNameFontColor='#8d8d8d' ")
                .append(" canvasBgColor='#ffffff' ")
                .append(" lineThickness='4' ")
                .append(" legendBgColor='#ffffff' ")
                .append(" legendBgAlpha='100' ")
                .append(" legendBorderAlpha='50' ")
                .append(" legendBorderColor='#888888' ")
                .append(" legendShadow='0' ")
                .append(" legendPosition='CENTER' ")
                .append(" divlineAlpha='0' ")
                .append(" numDivLines='10' ")
                .append(" divlineColor='#999999' ")
                .append(" divlineThickness='1' ")
                .append(" divLineIsDashed='1'")
                .append(" divLineDashLen='1'")
                .append(" divLineGapLen='1' ")
                .append(" toolTipColor='#ffffff' ")
                .append(" toolTipBorderColor='#ffffff' ")
                .append(" toolTipBorderThickness='1' ")
                .append(" toolTipBgColor='#000000' ")
                .append(" toolTipBgAlpha='80' ")
                .append(" toolTipBorderRadius='4' ")
                .append(" toolTipPadding='10' ")
                .append(" toolTipFontSize ='20' ")
                .append(" anchorBgColor='#ffffff' ")
                .append(" anchorRadius='5' ")
                .append(" anchorBorderThickness='3' ")
                .append(" anchorTrackingRadius='15' ")
                .append(" showHoverEffect='1' ")
                .append(" formatNumberScale='0'")
                .append(" labelDisplay='rotate' ")
                .append(" slantLabels='1' ")
                .append(" plotBorderColor='#ffffff' ") //bar 테두리없애기
                .append(" usePlotGradientColor='0' ") //bar의 그라데이션 없애기
                .append(" exportEnabled='1' ")
                .append(" exportAtClient='0' ")
                .append(" exportAction='save' ")
                .append(" exportShowMenuItem='0' ")
                .append(" exportDialogMessage='Building chart output' ")
                .append(" exportHandler='" + contextPath + "/servlet/FCExporter/export.do' exportCallBack='myFN' ")
                .append(" >");


        int fy = Integer.parseInt(fromYear);
        int ty = Integer.parseInt(toYear);

        xml.append("<categories >");
        for (int ii = fy; ii <= ty; ii++) xml.append("<category label='" + ii + "' />");
        xml.append("</categories>");

        int j = 0;
        for (AnalysisVo college : collegeList) {
            if (j >= 5) break;
            Map yearNoMap = convertObjectListToMapWithCompareValue(collegeWithYearList, "clgNm", college.getClgNm(), keyField, valField);
            String sn = college.getClgNm() + "";
            int fcIdx = j % 23;
            xml.append("<dataset seriesName='" + sn + "' color='" + fillColors[fcIdx] + "' anchorBorderColor='" + fillColors[fcIdx] + "' id='" + college.getClgNm() + "' >");
            for (int ii = fy; ii <= ty; ii++) {
                Object val = yearNoMap.get(Integer.toString(ii));
                if (val == null) {
                    xml.append("<set value='0' toolText='" + sn + " " + ii + " : 0' />");
                } else {
                    double dValue = Math.round((Double.parseDouble(val.toString())) * 100d) / 100d;
                    xml.append("<set value='" + dValue + "'  toolText='" + sn + " " + ii + " : " + dValue + "' />");
                }
            }
            xml.append("</dataset>");
            j++;
        }

        xml.append("<styles>");
        xml.append("    <definition>");
        xml.append("        <style name='CaptionFont' type='font' size='12'/>");
        xml.append("   </definition>");
        xml.append("    <application>");
        xml.append("       <apply toObject='CAPTION' styles='CaptionFont' />");
        xml.append("       <apply toObject='SUBCAPTION' styles='CaptionFont' />");
        xml.append("    </application>");
        xml.append(" </styles>");

        xml.append("</chart>");

        return xml.toString();

    }

    /**
     * <pre>
     *  1. 개   요 : Make chart xml institution time cited chart by year
     *  2. 처리내용 :
     * </pre>
     *  @Method Name : buildInstitutionTimeCitedChartXmlWithYear
     *  @param institutionWithYearList
     *  @param institutionList
     *  @param searchVo
     *  @param contextPath
     *  @return
     */
    public static String buildInstitutionTimeCitedChartXmlWithYear
    (List < AnalysisVo > institutionWithYearList, List < AnalysisVo > institutionList, RimsSearchVo searchVo, String
            contextPath){

        StringBuffer xml = new StringBuffer();
        String gubun = searchVo.getGubun();
        String fromYear = searchVo.getFromYear();
        String toYear = searchVo.getToYear();
        String keyField = "pubYear";

        String valField = "wosCitedAvrg";
        if (R2Constant.ARTICLE_GUBUN_SCOPUS.equals(gubun)) valField = "scpCitedAvrg";
        else if (R2Constant.ARTICLE_GUBUN_KCI.equals(gubun)) valField = "kciCitedAvrg";

        //String caption = "Publications by year from "+fromYear+ " to " + toYear;
        String valueColumn = "SCI".equals(gubun) ? "AVG_SCI_TC" : "AVG_SCP_TC";
		/*
		xml.append("<chart animation='0' caption='' subcaption='' lineThickness='2' showValues='0' formatNumberScale='0' anchorRadius='4'  ")
		.append(" divLineAlpha='30' numvdivlines='5' divLineIsDashed='1' bgColor='F7F7F7, E9E9E9' ")
		.append(" exportEnabled='1' exportAtClient='0' exportAction='save' exportHandler='"+contextPath+"/servlet/FCExporter/export.do' exportCallBack='myFN' ")
		.append(" exportShowMenuItem='0' exportDialogMessage='Building chart output' ")
		.append(" showLegend='1' legendPosition ='CENTER' >");
		*/
        xml.append("<chart ")
                .append(" caption='' ")
                .append(" subcaption='' ")
                .append(" baseFontColor='#666666' ")
                .append(" baseFontSize='11' ")
                .append(" subcaptionFontBold='0' ")
                .append(" canvasBgAlpha='0' ")
                .append(" showValues='0' ")
                .append(" paletteColors='" + fillColors[0] + "' ")
                .append(" bgAlpha='0' ")
                .append(" showBorder='0' ")
                .append(" showShadow='0' ")
                .append(" showAlternateHGridColor='0' ")
                .append(" showCanvasBorder='0' ")
                .append(" showXAxisLine='1' ")
                .append(" xAxisName='' ")
                .append(" xAxisLineThickness='1' ")
                .append(" xAxisLineColor='#cdcdcd' ")
                .append(" xAxisNameFontColor='#8d8d8d' ")
                .append(" yAxisName='' ")
                .append(" yAxisNameFontColor='#8d8d8d' ")
                .append(" canvasBgColor='#ffffff' ")
                .append(" lineThickness='4' ")
                .append(" legendBgColor='#ffffff' ")
                .append(" legendBgAlpha='100' ")
                .append(" legendBorderAlpha='50' ")
                .append(" legendBorderColor='#888888' ")
                .append(" legendShadow='0' ")
                .append(" legendPosition='CENTER' ")
                .append(" divlineAlpha='0' ")
                .append(" numDivLines='10' ")
                .append(" divlineColor='#999999' ")
                .append(" divlineThickness='1' ")
                .append(" divLineIsDashed='1'")
                .append(" divLineDashLen='1'")
                .append(" divLineGapLen='1' ")
                .append(" toolTipColor='#ffffff' ")
                .append(" toolTipBorderColor='#ffffff' ")
                .append(" toolTipBorderThickness='1' ")
                .append(" toolTipBgColor='#000000' ")
                .append(" toolTipBgAlpha='80' ")
                .append(" toolTipBorderRadius='4' ")
                .append(" toolTipPadding='10' ")
                .append(" toolTipFontSize ='20' ")
                .append(" anchorBgColor='#ffffff' ")
                .append(" anchorRadius='5' ")
                .append(" anchorBorderThickness='3' ")
                .append(" anchorTrackingRadius='15' ")
                .append(" showHoverEffect='1' ")
                .append(" formatNumberScale='0'")
                .append(" labelDisplay='rotate' ")
                .append(" slantLabels='1' ")
                .append(" plotBorderColor='#ffffff' ") //bar 테두리없애기
                .append(" usePlotGradientColor='0' ") //bar의 그라데이션 없애기
                .append(" exportEnabled='1' ")
                .append(" exportAtClient='0' ")
                .append(" exportAction='save' ")
                .append(" exportShowMenuItem='0' ")
                .append(" exportDialogMessage='Building chart output' ")
                .append(" exportHandler='" + contextPath + "/servlet/FCExporter/export.do' exportCallBack='myFN' ")
                .append(" >");


        int fy = Integer.parseInt(fromYear);
        int ty = Integer.parseInt(toYear);

        String sn = institutionList.get(0).getClgNm();
        Map yearNoMap = convertObjectListToMapWithCompareValue(institutionWithYearList, "clgNm", sn, keyField, valField);
        int fcIdx = 0;
        xml.append("<dataset seriesName='" + sn + "' color='" + fillColors[fcIdx] + "' anchorBorderColor='" + fillColors[fcIdx] + "' id='" + sn + "' >");
        for (int ii = fy; ii <= ty; ii++) {
            Object val = yearNoMap.get(Integer.toString(ii));
            if (val == null) {
                xml.append("<set label='" + ii + "' value='0' toolText='" + sn + " " + ii + " : 0' />");
            } else {
                double dValue = Math.round((Double.parseDouble(val.toString())) * 100d) / 100d;
                xml.append("<set label='" + ii + "' value='" + dValue + "'  toolText='" + sn + " " + ii + " : " + dValue + "' />");
            }
        }
        xml.append("</dataset>");

        xml.append("<styles>");
        xml.append("    <definition>");
        xml.append("        <style name='CaptionFont' type='font' size='12'/>");
        xml.append("   </definition>");
        xml.append("    <application>");
        xml.append("       <apply toObject='CAPTION' styles='CaptionFont' />");
        xml.append("       <apply toObject='SUBCAPTION' styles='CaptionFont' />");
        xml.append("    </application>");
        xml.append(" </styles>");

        xml.append("</chart>");

        return xml.toString();

    }

    /**
     * <pre>
     *  1. 개   요 : Make chart xml for college Impact factor
     *  2. 처리내용 :
     * </pre>
     *  @Method Name : buildCollegeIFChartXml
     *  @param collegeList
     *  @param searchVo
     *  @param contextPath
     *  @return
     */
    public static String buildCollegeIFChartXml (List < AnalysisVo > collegeList, RimsSearchVo searchVo, String
            contextPath){
        StringBuffer xml = new StringBuffer();

        String gubun = searchVo.getGubun();
        String avgIFType = searchVo.getAvgIFType();

        String yAxisName = "IF평균1 (IF합/전체논문수)";
        String valField = "impctFctrAvrg";
        if (R2Constant.ARTICLE_GUBUN_SCOPUS.equals(gubun)) valField = "sjrAvrg";
        else if (R2Constant.ARTICLE_GUBUN_KCI.equals(gubun)) valField = "kciIFAvrg";

        if ("ex".equals(avgIFType)) {
            yAxisName = "IF평균2 (IF합/IF제공논문수)";
            valField = "impctFctrExsAvrg";
            if (R2Constant.ARTICLE_GUBUN_SCOPUS.equals(gubun)) valField = "sjrExsAvrg";
            else if (R2Constant.ARTICLE_GUBUN_KCI.equals(gubun)) valField = "kciIFExsAvrg";
        }
		/*
		xml.append(" <chart animation='0' caption='' xAxisName='' yAxisName='"+yAxisName+"' showValues='1' formatNumberScale='0' decimals='2' ")
		.append(" divLineAlpha='30' numvdivlines='5' divLineIsDashed='1' bgColor='F7F7F7, E9E9E9' ")
		.append(" exportEnabled='1' exportShowMenuItem='0' exportAtClient='0' exportAction='save' exportHandler='"+contextPath+"/servlet/FCExporter/export.do' exportCallBack='myFN' ")
		.append(" useRoundEdges='1' labelDisplay='ROTATE' slantLabels='1' legendPosition ='CENTER' forceDecimals='1' >");
		*/
        xml.append("<chart ")
                .append(" subcaption='' ")
                .append(" baseFontColor='#666666' ")
                .append(" baseFontSize='11' ")
                .append(" subcaptionFontBold='0' ")
                .append(" canvasBgAlpha='0' ")
                .append(" showValues='0' ")
                .append(" paletteColors='" + paletteColors + "' ")
                .append(" bgAlpha='0' ")
                .append(" showBorder='0' ")
                .append(" showShadow='0' ")
                .append(" showAlternateHGridColor='0' ")
                .append(" showCanvasBorder='0' ")
                .append(" showXAxisLine='1' ")
                .append(" xAxisName='' ")
                .append(" xAxisLineThickness='1' ")
                .append(" xAxisLineColor='#cdcdcd' ")
                .append(" xAxisNameFontColor='#8d8d8d' ")
                .append(" yAxisName='" + yAxisName + "' ")
                .append(" yAxisNameFontColor='#8d8d8d' ")
                .append(" canvasBgColor='#ffffff' ")
                .append(" lineThickness='4' ")
                .append(" legendBgColor='#ffffff' ")
                .append(" legendBgAlpha='100' ")
                .append(" legendBorderAlpha='50' ")
                .append(" legendBorderColor='#888888' ")
                .append(" legendShadow='0' ")
                .append(" legendPosition='CENTER' ")
                .append(" divlineAlpha='0' ")
                .append(" numDivLines='10' ")
                .append(" divlineColor='#999999' ")
                .append(" divlineThickness='1' ")
                .append(" divLineIsDashed='1'")
                .append(" divLineDashLen='1'")
                .append(" divLineGapLen='1' ")
                .append(" toolTipColor='#ffffff' ")
                .append(" toolTipBorderColor='#ffffff' ")
                .append(" toolTipBorderThickness='1' ")
                .append(" toolTipBgColor='#000000' ")
                .append(" toolTipBgAlpha='80' ")
                .append(" toolTipBorderRadius='4' ")
                .append(" toolTipPadding='10' ")
                .append(" toolTipFontSize ='20' ")
                .append(" anchorBgColor='#ffffff' ")
                .append(" anchorRadius='5' ")
                .append(" anchorBorderThickness='3' ")
                .append(" anchorTrackingRadius='15' ")
                .append(" showHoverEffect='1' ")
                .append(" formatNumberScale='0'")
                .append(" labelDisplay='rotate' ")
                .append(" slantLabels='1' ")
                .append(" plotBorderColor='#ffffff' ") //bar 테두리없애기
                .append(" usePlotGradientColor='0' ") //bar의 그라데이션 없애기
                .append(" exportEnabled='1' ")
                .append(" exportAtClient='0' ")
                .append(" exportAction='save' ")
                .append(" exportShowMenuItem='0' ")
                .append(" exportDialogMessage='Building chart output' ")
                .append(" exportHandler='" + contextPath + "/servlet/FCExporter/export.do' exportCallBack='myFN' ")
                .append(" >");

        int j = 0;
        for (AnalysisVo college : collegeList) {
            if (j >= 12) break;
            Object val = getValueFromObject(college, valField).toString().trim();
            double dValue = Math.round((Double.parseDouble(val.toString())) * 100d) / 100d;
            String tText = college.getClgNm().trim() + " : " + dValue;
            xml.append("<set label='" + college.getClgNm().trim() + "' value='" + dValue + "'  toolText='" + tText + "' />");
            j++;
        }

        xml.append("<styles>");
        xml.append("    <definition>");
        xml.append("        <style name='myLabelsFont' type='font' font='Malgun Gothic' size='12' bold='1' />");
        xml.append("        <style name='CaptionFont' type='font' size='12'/>");
        xml.append("   </definition>");
        xml.append("    <application>");
        xml.append("       <apply toObject='CAPTION' styles='CaptionFont' />");
        xml.append("       <apply toObject='SUBCAPTION' styles='CaptionFont' />");
        xml.append("       <apply toObject='DataLabels' styles='myLabelsFont' />");
        xml.append("    </application>");
        xml.append(" </styles>");

        xml.append("</chart>");

        return xml.toString();
    }
    /**
     * <pre>
     *  1. 개   요 : Make chart xml for institution Impact factor
     *  2. 처리내용 :
     * </pre>
     *  @Method Name : buildCollegeIFChartXml
     *  @param institutionList
     *  @param searchVo
     *  @param contextPath
     *  @return
     */
    public static String buildInstitutionIFChartXml
    (List < AnalysisVo > institutionWithYearList, List < AnalysisVo > institutionList, RimsSearchVo searchVo, String
            contextPath){
        StringBuffer xml = new StringBuffer();

        String gubun = searchVo.getGubun();
        String avgIFType = searchVo.getAvgIFType();

        String fromYear = searchVo.getFromYear();
        String toYear = searchVo.getToYear();
        String yAxisName = "IF평균1 (IF합/전체논문수)";
        String valField = "impctFctrAvrg";
        if (R2Constant.ARTICLE_GUBUN_SCOPUS.equals(gubun)) valField = "sjrAvrg";
        else if (R2Constant.ARTICLE_GUBUN_KCI.equals(gubun)) valField = "kciIFAvrg";

        if ("ex".equals(avgIFType)) {
            yAxisName = "IF평균2 (IF합/IF제공논문수)";
            valField = "impctFctrExsAvrg";
            if (R2Constant.ARTICLE_GUBUN_SCOPUS.equals(gubun)) valField = "sjrExsAvrg";
            else if (R2Constant.ARTICLE_GUBUN_KCI.equals(gubun)) valField = "kciIFExsAvrg";
        }
		/*
		xml.append(" <chart animation='0' caption='' xAxisName='' yAxisName='"+yAxisName+"' showValues='1' formatNumberScale='0' decimals='2' ")
		.append(" divLineAlpha='30' numvdivlines='5' divLineIsDashed='1' bgColor='F7F7F7, E9E9E9' ")
		.append(" exportEnabled='1' exportShowMenuItem='0' exportAtClient='0' exportAction='save' exportHandler='"+contextPath+"/servlet/FCExporter/export.do' exportCallBack='myFN' ")
		.append(" useRoundEdges='1' labelDisplay='ROTATE' slantLabels='1' legendPosition ='CENTER' forceDecimals='1' >");
		*/
        xml.append("<chart ")
                .append(" subcaption='' ")
                .append(" baseFontColor='#666666' ")
                .append(" baseFontSize='11' ")
                .append(" subcaptionFontBold='0' ")
                .append(" canvasBgAlpha='0' ")
                .append(" showValues='0' ")
                .append(" paletteColors='" + fillColors[0] + "' ")
                .append(" bgAlpha='0' ")
                .append(" showBorder='0' ")
                .append(" showShadow='0' ")
                .append(" showAlternateHGridColor='0' ")
                .append(" showCanvasBorder='0' ")
                .append(" showXAxisLine='1' ")
                .append(" xAxisName='' ")
                .append(" xAxisLineThickness='1' ")
                .append(" xAxisLineColor='#cdcdcd' ")
                .append(" xAxisNameFontColor='#8d8d8d' ")
                .append(" yAxisName='" + yAxisName + "' ")
                .append(" yAxisNameFontColor='#8d8d8d' ")
                .append(" canvasBgColor='#ffffff' ")
                .append(" lineThickness='4' ")
                .append(" legendBgColor='#ffffff' ")
                .append(" legendBgAlpha='100' ")
                .append(" legendBorderAlpha='50' ")
                .append(" legendBorderColor='#888888' ")
                .append(" legendShadow='0' ")
                .append(" legendPosition='CENTER' ")
                .append(" divlineAlpha='0' ")
                .append(" numDivLines='10' ")
                .append(" divlineColor='#999999' ")
                .append(" divlineThickness='1' ")
                .append(" divLineIsDashed='1'")
                .append(" divLineDashLen='1'")
                .append(" divLineGapLen='1' ")
                .append(" toolTipColor='#ffffff' ")
                .append(" toolTipBorderColor='#ffffff' ")
                .append(" toolTipBorderThickness='1' ")
                .append(" toolTipBgColor='#000000' ")
                .append(" toolTipBgAlpha='80' ")
                .append(" toolTipBorderRadius='4' ")
                .append(" toolTipPadding='10' ")
                .append(" toolTipFontSize ='20' ")
                .append(" anchorBgColor='#ffffff' ")
                .append(" anchorRadius='5' ")
                .append(" anchorBorderThickness='3' ")
                .append(" anchorTrackingRadius='15' ")
                .append(" showHoverEffect='1' ")
                .append(" formatNumberScale='0'")
                .append(" labelDisplay='rotate' ")
                .append(" slantLabels='1' ")
                .append(" plotBorderColor='#ffffff' ") //bar 테두리없애기
                .append(" usePlotGradientColor='0' ") //bar의 그라데이션 없애기
                .append(" exportEnabled='1' ")
                .append(" exportAtClient='0' ")
                .append(" exportAction='save' ")
                .append(" exportShowMenuItem='0' ")
                .append(" exportDialogMessage='Building chart output' ")
                .append(" exportHandler='" + contextPath + "/servlet/FCExporter/export.do' exportCallBack='myFN' ")
                .append(" >");

        int fy = Integer.parseInt(fromYear);
        int ty = Integer.parseInt(toYear);

        String sn = institutionList.get(0).getClgNm();
        Map yearNoMap = convertObjectListToMapWithCompareValue(institutionWithYearList, "clgNm", sn, "pubYear", valField);
        int fcIdx = 0;
        xml.append("<dataset seriesName='" + sn + "' id='" + sn + "' >");
        for (int ii = fy; ii <= ty; ii++) {
            Object val = yearNoMap.get(Integer.toString(ii));

            if (val == null) {
                xml.append("<set label='" + ii + "' value='0' toolText='" + sn + " " + ii + " : 0' />");
            } else {
                double dValue = Math.round((Double.parseDouble(val.toString())) * 100d) / 100d;
                xml.append("<set label='" + ii + "' value='" + dValue + "'  toolText='" + sn + " " + ii + " : " + dValue + "' />");
            }
        }
        xml.append("</dataset>");


        xml.append("<styles>");
        xml.append("    <definition>");
        xml.append("        <style name='myLabelsFont' type='font' font='Malgun Gothic' size='12' bold='1' />");
        xml.append("        <style name='CaptionFont' type='font' size='12'/>");
        xml.append("   </definition>");
        xml.append("    <application>");
        xml.append("       <apply toObject='CAPTION' styles='CaptionFont' />");
        xml.append("       <apply toObject='SUBCAPTION' styles='CaptionFont' />");
        xml.append("       <apply toObject='DataLabels' styles='myLabelsFont' />");
        xml.append("    </application>");
        xml.append(" </styles>");

        xml.append("</chart>");

        return xml.toString();
    }

    public static String buildqsTheChartXmlWithYear (List < AnalysisVo > qsTheList, String contextPath){

        StringBuffer xml = new StringBuffer();
        String keyField = "year";
        String valField = "ranking";
        List<String> yearList = new ArrayList<>();
        List<AnalysisVo> qsList = new ArrayList<>();
        List<AnalysisVo> theList = new ArrayList<>();

        for (AnalysisVo qsTheVo : qsTheList) {
            if (!yearList.contains(qsTheVo.getYear())) yearList.add(qsTheVo.getYear());
            if ("QS".equals(qsTheVo.getGubun())) qsList.add(qsTheVo);
            if ("THE".equals(qsTheVo.getGubun())) theList.add(qsTheVo);
        }

        Collections.sort(yearList);

        xml.append("<chart ")
                .append(" caption='' ")
                /*.append(" pYAxisName='QS' ")
				.append(" pYAxisMinValue='1' ")
				.append(" sYAxisName='THE' ")
				.append(" sYAxisMinValue='1' ")*/
                .append(" subcaption='' ")
                .append(" yAxisMinValue='1' ")
                .append(" baseFontColor='#666666' ")
                .append(" baseFontSize='11' ")
                .append(" subcaptionFontBold='0' ")
                .append(" canvasBgAlpha='0' ")
                .append(" showValues='0' ")
                .append(" paletteColors='" + paletteColors + "' ")
                .append(" bgAlpha='0' ")
                .append(" showBorder='0' ")
                .append(" showShadow='0' ")
                .append(" showAlternateHGridColor='0' ")
                .append(" showCanvasBorder='0' ")
                .append(" showXAxisLine='1' ")
                .append(" xAxisName='Year' ")
                .append(" xAxisLineThickness='1' ")
                .append(" xAxisLineColor='#cdcdcd' ")
                .append(" xAxisNameFontColor='#8d8d8d' ")
                .append(" yAxisName='Ranking' ")
                .append(" yAxisNameFontColor='#8d8d8d' ")
                .append(" canvasBgColor='#ffffff' ")
                .append(" lineThickness='4' ")
                .append(" legendBgColor='#ffffff' ")
                .append(" legendBgAlpha='100' ")
                .append(" legendBorderAlpha='50' ")
                .append(" legendBorderColor='#888888' ")
                .append(" legendShadow='0' ")
                .append(" legendPosition='CENTER' ")
                .append(" divlineAlpha='100' ")
                .append(" numDivLines='10' ")
                .append(" divlineColor='#999999' ")
                .append(" divlineThickness='1' ")
                .append(" divLineIsDashed='1'")
                .append(" divLineDashLen='1'")
                .append(" divLineGapLen='1' ")
                .append(" toolTipColor='#ffffff' ")
                .append(" toolTipBorderColor='#ffffff' ")
                .append(" toolTipBorderThickness='1' ")
                .append(" toolTipBgColor='#000000' ")
                .append(" toolTipBgAlpha='80' ")
                .append(" toolTipBorderRadius='4' ")
                .append(" toolTipPadding='10' ")
                .append(" toolTipFontSize ='20' ")
                .append(" anchorBgColor='#ffffff' ")
                .append(" anchorRadius='5' ")
                .append(" anchorBorderThickness='3' ")
                .append(" anchorTrackingRadius='15' ")
                .append(" showHoverEffect='1' ")
                .append(" formatNumberScale='0'")
                .append(" labelDisplay='rotate' ")
                .append(" slantLabels='1' ")
                .append(" exportEnabled='1' ")
                .append(" exportAtClient='0' ")
                .append(" exportAction='save' ")
                .append(" exportShowMenuItem='0' ")
                .append(" exportDialogMessage='Building chart output' ")
                .append(" exportHandler='" + contextPath + "/servlet/FCExporter/export.do' exportCallBack='myFN' ")
                .append(" >");

        xml.append("<categories >");
        for (String year : yearList) {
            xml.append("<category label='" + year + "' />");
        }
        xml.append("</categories>");

        Map qsListMap = convertObjectListToMap(qsList, keyField, valField);
        Map theListMap = convertObjectListToMap(theList, keyField, valField);

        String qsDataset = "<dataset seriesName='QS' color='" + fillColors[0] + "' parentyaxis='P' renderas='Line'>";
        String theDataset = "<dataset seriesName='THE' color='" + fillColors[1] + "' parentyaxis='S' renderas='Line'>";

        for (String year : yearList) {
            Object qsVal = qsListMap.get(year);
            Object theVal = theListMap.get(year);

            if (qsVal == null)
                qsDataset += "<set value='' />";
            else
                qsDataset += "<set value='" + qsVal + "'  toolText=' " + year + " : " + qsVal + "' />";

            if (theVal == null)
                theDataset += "<set value='' />";
            else
                theDataset += "<set value='" + theVal + "'  toolText=' " + year + " : " + theVal + "' />";

        }
        qsDataset += "</dataset>";
        theDataset += "</dataset>";

        xml.append(qsDataset);
        xml.append(theDataset);

        xml.append("<styles>");
        xml.append("    <definition>");
        xml.append("        <style name='CaptionFont' type='font' size='12'/>");
        xml.append("   </definition>");
        xml.append("    <application>");
        xml.append("       <apply toObject='CAPTION' styles='CaptionFont' />");
        xml.append("       <apply toObject='SUBCAPTION' styles='CaptionFont' />");
        xml.append("    </application>");
        xml.append(" </styles>");
        xml.append("</chart>");

        return xml.toString();

    }


    /**
     * <pre>
     *  1. 개   요 : Make chart xml for institution chart by year
     *  2. 처리내용 :
     * </pre>
     *  @Method Name : buildInstitutionArtChartXmlWithYear
     *  @param institutionWithYearList
     *  @param searchVo
     *  @param contextPath
     *  @return
     */
    public static String buildInstitutionChartXmlByYear (List < AnalysisVo > institutionWithYearList, RimsSearchVo
            searchVo, String contextPath){

        String fromYear = searchVo.getFromYear();
        String toYear = searchVo.getToYear();
        String source = searchVo.getSource();
        String group2 = searchVo.getGroupKey2();

        //String caption = "Publications by year from "+fromYear+ " to " + toYear;
        StringBuffer xml = new StringBuffer();

        xml.append("<chart ")
                .append(" subcaption='' ")
                .append(" baseFontColor='#666666' ")
                .append(" baseFontSize='11' ")
                .append(" subcaptionFontBold='0' ")
                .append(" canvasBgAlpha='0' ")
                .append(" showValues='0' ")
                .append(" paletteColors='" + rims2Color[0] + "'")
                .append(" bgAlpha='0' ")
                .append(" showBorder='0' ")
                .append(" showShadow='0' ")
                .append(" showAlternateHGridColor='0' ")
                .append(" showCanvasBorder='0' ")
                .append(" showXAxisLine='1' ")
                .append(" xAxisName='' ")
                .append(" xAxisLineThickness='1' ")
                .append(" xAxisLineColor='#cdcdcd' ")
                .append(" xAxisNameFontColor='#8d8d8d' ")
                .append(" yAxisName='' ")
                .append(" yAxisNameFontColor='#8d8d8d' ")
                .append(" canvasBgColor='#ffffff' ")
                .append(" lineThickness='4' ")
                .append(" legendBgColor='#ffffff' ")
                .append(" legendBgAlpha='100' ")
                .append(" legendBorderAlpha='50' ")
                .append(" legendBorderColor='#888888' ")
                .append(" legendShadow='0' ")
                .append(" legendPosition='CENTER' ")
                .append(" divlineAlpha='100' ")
                .append(" numDivLines='10' ")
                .append(" divlineColor='#999999' ")
                .append(" divlineThickness='1' ")
                .append(" divLineIsDashed='1'")
                .append(" divLineDashLen='1'")
                .append(" divLineGapLen='1' ")
                .append(" toolTipColor='#ffffff' ")
                .append(" toolTipBorderColor='#ffffff' ")
                .append(" toolTipBorderThickness='1' ")
                .append(" toolTipBgColor='#000000' ")
                .append(" toolTipBgAlpha='80' ")
                .append(" toolTipBorderRadius='4' ")
                .append(" toolTipPadding='10' ")
                .append(" toolTipFontSize ='20' ")
                .append(" anchorBgColor='#ffffff' ")
                .append(" anchorRadius='5' ")
                .append(" anchorBorderThickness='3' ")
                .append(" anchorTrackingRadius='15' ")
                .append(" showHoverEffect='1' ")
                .append(" formatNumberScale='0'")
                .append(" labelDisplay='auto' ")
                .append(" slantLabels='1' ")
                .append(" exportEnabled='1' ")
                .append(" exportAtClient='0' ")
                .append(" exportAction='save' ")
                .append(" exportShowMenuItem='0' ")
                .append(" exportDialogMessage='Building chart output' ")
                .append(" exportHandler='" + contextPath + "/servlet/FCExporter/export.do' exportCallBack='myFN' ")
                .append(" >");

        int fy = Integer.parseInt(fromYear);
        int ty = Integer.parseInt(toYear);

        xml.append("<categories >");
        for (int ii = fy; ii <= ty; ii++) xml.append("<category label='" + ii + "' />");
        xml.append("</categories>");

        Map yearNoMap = convertObjectListToMapWithCompareValue(institutionWithYearList, "clgNm", institutionWithYearList.get(0).getClgNm(), group2, source);

        String sn = institutionWithYearList.get(0).getClgNm();
        xml.append("<dataset seriesName='" + sn + "' id='" + sn + "' >");
        for (int ii = fy; ii <= ty; ii++) {
            Object val = yearNoMap.get(Integer.toString(ii));
            String tText = "";
            if (val == null) {
                xml.append("<set label='" + ii + "' value='0' toolText='" + sn + " " + ii + " : 0' />");
            } else {
                if (val.toString().contains(".")) {
                    val = Double.parseDouble(String.format("%.2f", val));
                    tText = sn + " " + ii + " : " + String.format("%1$,.2f", val);
                } else {
                    tText = sn + " " + ii + " : " + String.format("%,d", Integer.parseInt(val.toString()));
                }

                xml.append("<set value='" + val + "'  toolText='" + tText + "' />");
            }
        }
        xml.append("</dataset>");

        xml.append("<styles>");
        xml.append("    <definition>");

        xml.append("        <style name='CaptionFont' type='font' size='12'/>");
        xml.append("   </definition>");
        xml.append("    <application>");
        xml.append("       <apply toObject='CAPTION' styles='CaptionFont' />");
        xml.append("       <apply toObject='SUBCAPTION' styles='CaptionFont' />");
        xml.append("    </application>");
        xml.append(" </styles>");

        xml.append("</chart>");

        return xml.toString();

    }

    /**
     * <pre>
     *  1. 개   요 : Make chart xml for institution chart by year
     *  2. 처리내용 :
     * </pre>
     *  @Method Name : buildInstitutionBarChartXmlByYear
     *  @param institutionWithYearList
     *  @param searchVo
     *  @param contextPath
     *  @return
     */
    public static String buildInstitutionBarChartXmlByYear
    (List < AnalysisVo > institutionWithYearList, RimsSearchVo searchVo, String contextPath){

        String fromYear = searchVo.getFromYear();
        String toYear = searchVo.getToYear();
        String source = searchVo.getSource();
        String group2 = searchVo.getGroupKey2();
        String caption = "";
        if (searchVo.getCaption() != null) caption = searchVo.getCaption();

        //String caption = "Publications by year from "+fromYear+ " to " + toYear;
        StringBuffer xml = new StringBuffer();

        xml.append("<chart ")
                .append(" caption='" + caption + "' ")
                .append(" subcaption='' ")
                .append(" baseFontColor='#666666' ")
                .append(" baseFontSize='11' ")
                .append(" subcaptionFontBold='0' ")
                .append(" canvasBgAlpha='0' ")
                .append(" showValues='0' ")
                .append(" paletteColors='" + rims2Color[0] + "' ")
                .append(" bgAlpha='0' ")
                .append(" showBorder='0' ")
                .append(" showShadow='0' ")
                .append(" showAlternateHGridColor='0' ")
                .append(" showCanvasBorder='0' ")
                .append(" showXAxisLine='1' ")
                .append(" xAxisName='' ")
                .append(" xAxisLineThickness='1' ")
                .append(" xAxisLineColor='#cdcdcd' ")
                .append(" xAxisNameFontColor='#8d8d8d' ")
                .append(" yAxisNameFontColor='#8d8d8d' ")
                .append(" canvasBgColor='#ffffff' ")
                .append(" divlineAlpha='0' ")
                .append(" numDivLines='1' ")
                .append(" yAxisMinValue='0' ")
                .append(" divlineColor='#999999' ")
                .append(" divlineThickness='1' ")
                .append(" divLineIsDashed='1'")
                .append(" divLineDashLen='1'")
                .append(" divLineGapLen='1' ")
                .append(" toolTipColor='#ffffff' ")
                .append(" toolTipBorderColor='#ffffff' ")
                .append(" toolTipBorderThickness='1' ")
                .append(" toolTipBgColor='#000000' ")
                .append(" toolTipBgAlpha='80' ")
                .append(" toolTipBorderRadius='4' ")
                .append(" toolTipPadding='10' ")
                .append(" toolTipFontSize ='20' ")
                .append(" showHoverEffect='1' ")
                .append(" formatNumberScale='0'")
                .append(" labelDisplay='auto' ")
                .append(" canvasBorderAlpha='0' ")
                .append(" usePlotGradientColor='0' ") //bar의 그라데이션 없애기
                .append(" plotSpacePercent='50' ") //bar의 크기
                .append(" plotBorderAlpha='10' ")
                .append(" exportEnabled='1' ")
                .append(" exportAtClient='0' ")
                .append(" exportAction='save' ")
                .append(" exportShowMenuItem='0' ")
                .append(" exportDialogMessage='Building chart output' ")
                .append(" exportHandler='" + contextPath + "/servlet/FCExporter/export.do' exportCallBack='myFN' ")
                .append(" >");

        int fy = Integer.parseInt(fromYear);
        int ty = Integer.parseInt(toYear);

        Map yearNoMap = convertObjectListToMapWithCompareValue(institutionWithYearList, "clgNm", institutionWithYearList.get(0).getClgNm(), group2, source);

        for (int ii = fy; ii <= ty; ii++) {
            Object val = yearNoMap.get(Integer.toString(ii));
            if (val == null) val = 0;

            xml.append("<set label='" + ii + "' value='" + val + "'  toolText='" + ii + " : " + String.format("%,d", Integer.parseInt(val.toString())) + "' />");
        }

        xml.append("<styles>");
        xml.append("    <definition>");
        xml.append("        <style name='myLabelsFont' type='font' font='Malgun Gothic' size='12' bold='1' />");
        xml.append("        <style name='CaptionFont' type='font' size='12'/>");
        xml.append("   </definition>");
        xml.append("    <application>");
        xml.append("       <apply toObject='CAPTION' styles='CaptionFont' />");
        xml.append("       <apply toObject='SUBCAPTION' styles='CaptionFont' />");
        xml.append("       <apply toObject='DataLabels' styles='myLabelsFont' />");
        xml.append("    </application>");
        xml.append(" </styles>");

        xml.append("</chart>");

        return xml.toString();

    }

    /**
     * <pre>
     *  1. 개   요 : Make chart xml for college article chart by year
     *  2. 처리내용 :
     * </pre>
     *  @Method Name : buildCollegeArtChartXmlWithYear
     *  @param collegeWithYearList
     *  @param collegeList
     *  @param searchVo
     *  @param contextPath
     *  @return
     */
    public static String buildCollegeChartXmlByYear
    (List < AnalysisVo > collegeWithYearList, List < AnalysisVo > collegeList, RimsSearchVo searchVo, String
            contextPath){

        String fromYear = searchVo.getFromYear();
        String toYear = searchVo.getToYear();
        String source = searchVo.getSource();
        String group2 = searchVo.getGroupKey2();

        StringBuffer xml = new StringBuffer();

        xml.append("<chart ")
                .append(" subcaption='' ")
                .append(" baseFontColor='#666666' ")
                .append(" baseFontSize='11' ")
                .append(" subcaptionFontBold='0' ")
                .append(" canvasBgAlpha='0' ")
                .append(" showValues='0' ")
                .append(" paletteColors='" + Arrays.toString(rims2Color).replace("[", "").replace("]", "") + "' ")
                .append(" bgAlpha='0' ")
                .append(" showBorder='0' ")
                .append(" showShadow='0' ")
                .append(" showAlternateHGridColor='0' ")
                .append(" showCanvasBorder='0' ")
                .append(" showXAxisLine='1' ")
                .append(" xAxisName='' ")
                .append(" xAxisLineThickness='1' ")
                .append(" xAxisLineColor='#cdcdcd' ")
                .append(" xAxisNameFontColor='#8d8d8d' ")
                .append(" yAxisName='' ")
                .append(" yAxisNameFontColor='#8d8d8d' ")
                .append(" canvasBgColor='#ffffff' ")
                .append(" lineThickness='4' ")
                .append(" legendBgColor='#ffffff' ")
                .append(" legendBgAlpha='100' ")
                .append(" legendBorderAlpha='50' ")
                .append(" legendBorderColor='#888888' ")
                .append(" legendShadow='0' ")
                .append(" legendPosition='CENTER' ")
                .append(" divlineAlpha='100' ")
                .append(" numDivLines='10' ")
                .append(" divlineColor='#999999' ")
                .append(" divlineThickness='1' ")
                .append(" divLineIsDashed='1'")
                .append(" divLineDashLen='1'")
                .append(" divLineGapLen='1' ")
                .append(" toolTipColor='#ffffff' ")
                .append(" toolTipBorderColor='#ffffff' ")
                .append(" toolTipBorderThickness='1' ")
                .append(" toolTipBgColor='#000000' ")
                .append(" toolTipBgAlpha='80' ")
                .append(" toolTipBorderRadius='4' ")
                .append(" toolTipPadding='10' ")
                .append(" toolTipFontSize ='20' ")
                .append(" anchorBgColor='#ffffff' ")
                .append(" anchorRadius='5' ")
                .append(" anchorBorderThickness='3' ")
                .append(" anchorTrackingRadius='15' ")
                .append(" showHoverEffect='1' ")
                .append(" formatNumberScale='0'")
                .append(" labelDisplay='auto' ")
                .append(" slantLabels='1' ")
                .append(" exportEnabled='1' ")
                .append(" exportAtClient='0' ")
                .append(" exportAction='save' ")
                .append(" exportShowMenuItem='0' ")
                .append(" exportDialogMessage='Building chart output' ")
                .append(" exportHandler='" + contextPath + "/servlet/FCExporter/export.do' exportCallBack='myFN' ")
                .append(" >");

        int fy = Integer.parseInt(fromYear);
        int ty = Integer.parseInt(toYear);

        xml.append("<categories >");
        for (int ii = fy; ii <= ty; ii++) xml.append("<category label='" + ii + "' />");
        xml.append("</categories>");

        int j = 0;
        for (AnalysisVo college : collegeList) {
            if (j >= 5) break;
            Map yearNoMap = convertObjectListToMapWithCompareValue(collegeWithYearList, "clgNm", college.getClgNm(), group2, source);

            String sn = college.getClgNm() + "";
            String tText = "";
            int fcIdx = j % 23;
            xml.append("<dataset seriesName='" + sn + "' color='" + rims2Color[fcIdx] + "' id='" + college.getClgNm() + "' >");
            for (int ii = fy; ii <= ty; ii++) {
                Object val = yearNoMap.get(Integer.toString(ii));
                if (val == null) {
                    xml.append("<set value='0' toolText='" + sn + " " + ii + " : 0' />");
                } else {
                    if (val.toString().contains(".")) {
                        val = Double.parseDouble(String.format("%.2f", val));
                        tText = sn + " " + ii + " : " + String.format("%1$,.2f", val);
                    } else {
                        tText = sn + " " + ii + " : " + String.format("%,d", Integer.parseInt(val.toString()));
                    }

                    xml.append("<set value='" + val + "'  toolText='" + tText + "' />");
                }
            }
            xml.append("</dataset>");
            j++;
        }

        xml.append("<styles>");
        xml.append("    <definition>");

        xml.append("        <style name='CaptionFont' type='font' size='12'/>");
        xml.append("   </definition>");
        xml.append("    <application>");
        xml.append("       <apply toObject='CAPTION' styles='CaptionFont' />");
        xml.append("       <apply toObject='SUBCAPTION' styles='CaptionFont' />");
        xml.append("    </application>");
        xml.append(" </styles>");

        xml.append("</chart>");

        return xml.toString();

    }

    /**
     * <pre>
     *  1. 개   요 : Make chart xml for department article chart by year
     *  2. 처리내용 :
     * </pre>
     *  @Method Name : buildDepartChartXmlByYear
     *  @param noArts
     *  @param departs
     *  @param fromYear
     *  @param toYear
     *  @param contextPath
     *  @return
     */
    public static String buildDepartChartXmlByYear
    (List < AnalysisVo > departWithYearList, List < AnalysisVo > departList, RimsSearchVo searchVo, String
            contextPath){

        String fromYear = searchVo.getFromYear();
        String toYear = searchVo.getToYear();
        String source = searchVo.getSource();
        String group2 = searchVo.getGroupKey2();

        //String caption = "Publications by year from "+fromYear+ " to " + toYear;
        StringBuffer xml = new StringBuffer();

		/*
		xml.append(" <chart animation='0' caption='' subcaption='' lineThickness='2' showValues='0' formatNumberScale='0' ")
		.append(" divLineAlpha='30' numvdivlines='5' divLineIsDashed='1' bgColor='F7F7F7, E9E9E9' ")
		.append(" exportEnabled='1' exportAtClient='0' exportAction='save' exportHandler='"+contextPath+"/servlet/FCExporter/export.do' exportCallBack='myFN' ")
		.append(" exportShowMenuItem='0' exportDialogMessage='Building chart output' ")
		.append(" anchorRadius='4' showLegend='1' legendPosition ='CENTER' >");
		*/
        xml.append("<chart ")
                .append(" subcaption='' ")
                .append(" baseFontColor='#666666' ")
                .append(" baseFontSize='11' ")
                .append(" subcaptionFontBold='0' ")
                .append(" canvasBgAlpha='0' ")
                .append(" showValues='0' ")
                .append(" paletteColors='" + Arrays.toString(rims2Color).replace("[", "").replace("]", "") + "' ")
                .append(" bgAlpha='0' ")
                .append(" showBorder='0' ")
                .append(" showShadow='0' ")
                .append(" showAlternateHGridColor='0' ")
                .append(" showCanvasBorder='0' ")
                .append(" showXAxisLine='1' ")
                .append(" xAxisName='' ")
                .append(" xAxisLineThickness='1' ")
                .append(" xAxisLineColor='#cdcdcd' ")
                .append(" xAxisNameFontColor='#8d8d8d' ")
                .append(" yAxisName='' ")
                .append(" yAxisNameFontColor='#8d8d8d' ")
                .append(" canvasBgColor='#ffffff' ")
                .append(" lineThickness='4' ")
                .append(" legendBgColor='#ffffff' ")
                .append(" legendBgAlpha='100' ")
                .append(" legendBorderAlpha='50' ")
                .append(" legendBorderColor='#888888' ")
                .append(" legendShadow='0' ")
                .append(" legendPosition='CENTER' ")
                .append(" divlineAlpha='100' ")
                .append(" numDivLines='10' ")
                .append(" divlineColor='#999999' ")
                .append(" divlineThickness='1' ")
                .append(" divLineIsDashed='1'")
                .append(" divLineDashLen='1'")
                .append(" divLineGapLen='1' ")
                .append(" toolTipColor='#ffffff' ")
                .append(" toolTipBorderColor='#ffffff' ")
                .append(" toolTipBorderThickness='1' ")
                .append(" toolTipBgColor='#000000' ")
                .append(" toolTipBgAlpha='80' ")
                .append(" toolTipBorderRadius='4' ")
                .append(" toolTipPadding='10' ")
                .append(" toolTipFontSize ='20' ")
                .append(" anchorBgColor='#ffffff' ")
                .append(" anchorRadius='5' ")
                .append(" anchorBorderThickness='3' ")
                .append(" anchorTrackingRadius='15' ")
                .append(" showHoverEffect='1' ")
                .append(" formatNumberScale='0'")
                .append(" labelDisplay='auto' ")
                .append(" slantLabels='1' ")
                .append(" exportEnabled='1' ")
                .append(" exportAtClient='0' ")
                .append(" exportAction='save' ")
                .append(" exportShowMenuItem='0' ")
                .append(" exportDialogMessage='Building chart output' ")
                .append(" exportHandler='" + contextPath + "/servlet/FCExporter/export.do' exportCallBack='myFN' ")
                .append(" >");

        int fy = Integer.parseInt(fromYear);
        int ty = Integer.parseInt(toYear);

        xml.append("<categories >");
        for (int ii = fy; ii <= ty; ii++) xml.append("<category label='" + ii + "' />");
        xml.append("</categories>");

        int j = 0;

        for (AnalysisVo depart : departList) {
            if (j >= 5) break;
            Map yearNoMap = convertObjectListToMapWithCompareValue(departWithYearList, "deptKor", depart.getDeptKor(), group2, source);

            String sn = depart.getDeptKor() + "";
            int fcIdx = j % 23;
            xml.append("<dataset seriesName='" + sn + "' color='" + rims2Color[fcIdx] + "' id='" + depart.getDeptKor() + "' >");
            for (int ii = fy; ii <= ty; ii++) {
                Object val = yearNoMap.get(Integer.toString(ii));
                String tText = "";

                if (val == null) {
                    xml.append("<set value='0' toolText='" + sn + " " + ii + " : 0' />");
                } else {
                    if (val.toString().contains(".")) {
                        val = Double.parseDouble(String.format("%.2f", val));
                        tText = sn + " " + ii + " : " + String.format("%1$,.2f", val);
                    } else {
                        tText = sn + " " + ii + " : " + String.format("%,d", Integer.parseInt(val.toString()));
                    }

                    xml.append("<set value='" + val + "'  toolText='" + tText + "' />");
                }
            }
            xml.append("</dataset>");
            j++;
        }

        xml.append("<styles>");
        xml.append("    <definition>");

        xml.append("        <style name='CaptionFont' type='font' size='12'/>");
        xml.append("   </definition>");
        xml.append("    <application>");
        xml.append("       <apply toObject='CAPTION' styles='CaptionFont' />");
        xml.append("       <apply toObject='SUBCAPTION' styles='CaptionFont' />");
        xml.append("    </application>");
        xml.append(" </styles>");

        xml.append("</chart>");

        return xml.toString();

    }

    /**
     * <pre>
     *  1. 개   요 : Make chart xml for researcher article chart by year
     *  2. 처리내용 :
     * </pre>
     *  @Method Name : buildResearcherArtChartXmlWithYear
     *  @param researcherWithYearList
     *  @param researcherList
     *  @param searchVo
     *  @param contextPath
     *  @return
     */
    public static String buildResearcherChartXmlByYear
    (List < AnalysisVo > researcherWithYearList, List < AnalysisVo > researcherList, RimsSearchVo searchVo, String
            contextPath){

        String fromYear = searchVo.getFromYear();
        String toYear = searchVo.getToYear();
        String source = searchVo.getSource();
        String group2 = searchVo.getGroupKey2();

        StringBuffer xml = new StringBuffer();

        xml.append("<chart ")
                .append(" subcaption='' ")
                .append(" baseFontColor='#666666' ")
                .append(" baseFontSize='11' ")
                .append(" subcaptionFontBold='0' ")
                .append(" canvasBgAlpha='0' ")
                .append(" showValues='0' ")
                .append(" paletteColors='" + Arrays.toString(rims2Color).replace("[", "").replace("]", "") + "' ")
                .append(" bgAlpha='0' ")
                .append(" showBorder='0' ")
                .append(" showShadow='0' ")
                .append(" showAlternateHGridColor='0' ")
                .append(" showCanvasBorder='0' ")
                .append(" showXAxisLine='1' ")
                .append(" xAxisName='' ")
                .append(" xAxisLineThickness='1' ")
                .append(" xAxisLineColor='#cdcdcd' ")
                .append(" xAxisNameFontColor='#8d8d8d' ")
                .append(" yAxisName='' ")
                .append(" yAxisNameFontColor='#8d8d8d' ")
                .append(" canvasBgColor='#ffffff' ")
                .append(" lineThickness='4' ")
                .append(" legendBgColor='#ffffff' ")
                .append(" legendBgAlpha='100' ")
                .append(" legendBorderAlpha='50' ")
                .append(" legendBorderColor='#888888' ")
                .append(" legendShadow='0' ")
                .append(" legendPosition='CENTER' ")
                .append(" divlineAlpha='100' ")
                .append(" numDivLines='10' ")
                .append(" divlineColor='#999999' ")
                .append(" divlineThickness='1' ")
                .append(" divLineIsDashed='1'")
                .append(" divLineDashLen='1'")
                .append(" divLineGapLen='1' ")
                .append(" toolTipColor='#ffffff' ")
                .append(" toolTipBorderColor='#ffffff' ")
                .append(" toolTipBorderThickness='1' ")
                .append(" toolTipBgColor='#000000' ")
                .append(" toolTipBgAlpha='80' ")
                .append(" toolTipBorderRadius='4' ")
                .append(" toolTipPadding='10' ")
                .append(" toolTipFontSize ='20' ")
                .append(" anchorBgColor='#ffffff' ")
                .append(" anchorRadius='5' ")
                .append(" anchorBorderThickness='3' ")
                .append(" anchorTrackingRadius='15' ")
                .append(" showHoverEffect='1' ")
                .append(" formatNumberScale='0'")
                .append(" labelDisplay='auto' ")
                .append(" slantLabels='1' ")
                .append(" exportEnabled='1' ")
                .append(" exportAtClient='0' ")
                .append(" exportAction='save' ")
                .append(" exportShowMenuItem='0' ")
                .append(" exportDialogMessage='Building chart output' ")
                .append(" exportHandler='" + contextPath + "/servlet/FCExporter/export.do' exportCallBack='myFN' ")
                .append(" >");

        int fy = Integer.parseInt(fromYear);
        int ty = Integer.parseInt(toYear);

        xml.append("<categories >");
        for (int ii = fy; ii <= ty; ii++) xml.append("<category label='" + ii + "' />");
        xml.append("</categories>");

        int j = 0;
        for (AnalysisVo researcher : researcherList) {
            if (j >= 5) break;
            Map yearNoMap = convertObjectListToMapWithCompareValue(researcherWithYearList, "korNm", researcher.getKorNm(), group2, source);
            String sn = researcher.getKorNm() + "";
            int fcIdx = j % 23;
            xml.append("<dataset seriesName='" + sn + "' color='" + rims2Color[fcIdx] + "' id='" + researcher.getKorNm() + "' >");
            for (int ii = fy; ii <= ty; ii++) {
                Object val = yearNoMap.get(Integer.toString(ii));
                String tText = "";
                if (val == null) {
                    xml.append("<set value='0' toolText='" + sn + " " + ii + " : 0' />");
                } else {
                    if (val.toString().contains(".")) {
                        val = Double.parseDouble(String.format("%.2f", val));
                        tText = sn + " " + ii + " : " + String.format("%1$,.2f", val);
                    } else {
                        tText = sn + " " + ii + " : " + String.format("%,d", Integer.parseInt(val.toString()));
                    }

                    xml.append("<set value='" + val + "'  toolText='" + tText + "' />");
                }
            }
            xml.append("</dataset>");
            j++;
        }

        xml.append("<styles>");
        xml.append("    <definition>");

        xml.append("        <style name='CaptionFont' type='font' size='12'/>");
        xml.append("   </definition>");
        xml.append("    <application>");
        xml.append("       <apply toObject='CAPTION' styles='CaptionFont' />");
        xml.append("       <apply toObject='SUBCAPTION' styles='CaptionFont' />");
        xml.append("    </application>");
        xml.append(" </styles>");

        xml.append("</chart>");

        return xml.toString();

    }

    /**
     * <pre>
     *  1. 개   요 : Make chart xml for Impact factor
     *  2. 처리내용 :
     * </pre>
     *  @Method Name : build2DChartXml
     *  @param list
     *  @param contextPath
     *  @return
     */
    public static String build2DChartXml (List < AnalysisVo > list, RimsSearchVo searchVo, String
            contextPath, String tab1){
        StringBuffer xml = new StringBuffer();

        String yAxisName = "";
        String source = searchVo.getSource();

        xml.append("<chart ")
                .append(" subcaption='' ")
                .append(" baseFontColor='#666666' ")
                .append(" baseFontSize='11' ")
                .append(" subcaptionFontBold='0' ")
                .append(" canvasBgAlpha='0' ")
                .append(" showValues='0' ")
                .append(" paletteColors='" + Arrays.toString(rims2Color).replace("[", "").replace("]", "") + "' ")
                .append(" bgAlpha='0' ")
                .append(" showBorder='0' ")
                .append(" showShadow='0' ")
                .append(" showAlternateHGridColor='0' ")
                .append(" showCanvasBorder='0' ")
                .append(" showXAxisLine='1' ")
                .append(" xAxisName='' ")
                .append(" xAxisLineThickness='1' ")
                .append(" xAxisLineColor='#cdcdcd' ")
                .append(" xAxisNameFontColor='#8d8d8d' ")
                .append(" yAxisName='" + yAxisName + "' ")
                .append(" yAxisNameFontColor='#8d8d8d' ")
                .append(" canvasBgColor='#ffffff' ")
                .append(" lineThickness='4' ")
                .append(" legendBgColor='#ffffff' ")
                .append(" legendBgAlpha='100' ")
                .append(" legendBorderAlpha='50' ")
                .append(" legendBorderColor='#888888' ")
                .append(" legendShadow='0' ")
                .append(" legendPosition='CENTER' ")
                .append(" divlineAlpha='0' ")
                .append(" numDivLines='10' ")
                .append(" divlineColor='#999999' ")
                .append(" divlineThickness='1' ")
                .append(" divLineIsDashed='1'")
                .append(" divLineDashLen='1'")
                .append(" divLineGapLen='1' ")
                .append(" toolTipColor='#ffffff' ")
                .append(" toolTipBorderColor='#ffffff' ")
                .append(" toolTipBorderThickness='1' ")
                .append(" toolTipBgColor='#000000' ")
                .append(" toolTipBgAlpha='80' ")
                .append(" toolTipBorderRadius='4' ")
                .append(" toolTipPadding='10' ")
                .append(" toolTipFontSize ='20' ")
                .append(" anchorBgColor='#ffffff' ")
                .append(" anchorRadius='5' ")
                .append(" anchorBorderThickness='3' ")
                .append(" anchorTrackingRadius='15' ")
                .append(" showHoverEffect='1' ")
                .append(" formatNumberScale='0'")
                .append(" usePlotGradientColor='0' ") //bar의 그라데이션 없애기
                .append(" plotBorderAlpha='10' ")
                .append(" labelDisplay='auto' ")
                .append(" slantLabels='1' ")
                .append(" exportEnabled='1' ")
                .append(" exportAtClient='0' ")
                .append(" exportAction='save' ")
                .append(" exportShowMenuItem='0' ")
                .append(" exportDialogMessage='Building chart output' ")
                .append(" exportHandler='" + contextPath + "/servlet/FCExporter/export.do' exportCallBack='myFN' ")
                .append(" >");

        int j = 0;
        for (AnalysisVo vo : list) {
            if (j >= 12) break;
            Object val = getValueFromObject(vo, source).toString().trim();
            String label = "";
            String tText = "";
            if ("college".equals(tab1)) label = vo.getClgNm().trim();
            if ("department".equals(tab1)) label = vo.getDeptKor().trim();
            if ("researcher".equals(tab1)) label = vo.getKorNm().trim();

            if (val.toString().contains(".")) {
                val = Math.round((Double.parseDouble(val.toString())) * 100d) / 100d;
                tText = label + " : " + String.format("%1$,.2f", val);
            } else {
                tText = label + " : " + String.format("%,d", Integer.parseInt(val.toString()));
            }

            xml.append("<set label='" + label + "' value='" + val + "'  toolText='" + tText + "' />");
            j++;
        }

        xml.append("<styles>");
        xml.append("    <definition>");
        xml.append("        <style name='myLabelsFont' type='font' font='Malgun Gothic' size='12' bold='1' />");
        xml.append("        <style name='CaptionFont' type='font' size='12'/>");
        xml.append("   </definition>");
        xml.append("    <application>");
        xml.append("       <apply toObject='CAPTION' styles='CaptionFont' />");
        xml.append("       <apply toObject='SUBCAPTION' styles='CaptionFont' />");
        xml.append("       <apply toObject='DataLabels' styles='myLabelsFont' />");
        xml.append("    </application>");
        xml.append(" </styles>");

        xml.append("</chart>");

        return xml.toString();
    }

    /**
     * <pre>
     *  1. 개   요 : Make chart xml for institution chart by month year
     *  2. 처리내용 :
     * </pre>
     *  @Method Name : buildInstitutionChartXmlByMonthYear
     *  @param institutionWithMonthYearList
     *  @param searchVo
     *  @param contextPath
     *  @return
     */
    public static String buildInstitutionChartXmlByMonthYear
    (List < AnalysisVo > institutionWithMonthYearList, RimsSearchVo searchVo, String contextPath){

        String source = searchVo.getSource();
        int fy = Integer.parseInt(searchVo.getFromYear());
        int ty = Integer.parseInt(searchVo.getToYear());

        Calendar c = Calendar.getInstance();
        int currentY = c.get(Calendar.YEAR); //현재 연도
        int currentM = c.get(Calendar.MONTH);
        String caption = "";

        if (searchVo.getCaption() != null) caption = searchVo.getCaption();

        StringBuffer xml = new StringBuffer();

        xml.append("<chart ")
                .append(" caption='" + caption + "' ")
                .append(" subcaption='' ")
                .append(" baseFontColor='#666666' ")
                .append(" baseFontSize='11' ")
                .append(" subcaptionFontBold='0' ")
                .append(" canvasBgAlpha='0' ")
                .append(" showValues='0' ")
                .append(" paletteColors='" + rims2Color[0] + "' ")
                .append(" bgAlpha='0' ")
                .append(" showBorder='0' ")
                .append(" showShadow='0' ")
                .append(" showAlternateHGridColor='0' ")
                .append(" showCanvasBorder='0' ")
                .append(" showXAxisLine='1' ")
                .append(" xAxisName='' ")
                .append(" xAxisLineThickness='1' ")
                .append(" xAxisLineColor='#cdcdcd' ")
                .append(" xAxisNameFontColor='#8d8d8d' ")
                .append(" yAxisNameFontColor='#8d8d8d' ")
                .append(" canvasBgColor='#ffffff' ")
                .append(" divlineAlpha='0' ")
                .append(" numDivLines='1' ")
                .append(" yAxisMinValue='0' ")
                .append(" divlineColor='#999999' ")
                .append(" divlineThickness='1' ")
                .append(" divLineIsDashed='1'")
                .append(" divLineDashLen='1'")
                .append(" divLineGapLen='1' ")
                .append(" toolTipColor='#ffffff' ")
                .append(" toolTipBorderColor='#ffffff' ")
                .append(" toolTipBorderThickness='1' ")
                .append(" toolTipBgColor='#000000' ")
                .append(" toolTipBgAlpha='80' ")
                .append(" toolTipBorderRadius='4' ")
                .append(" toolTipPadding='10' ")
                .append(" toolTipFontSize ='20' ")
                .append(" showHoverEffect='1' ")
                .append(" formatNumberScale='0'")
                .append(" labelDisplay='wrap' ")
                .append(" labelStep='12' ")
                .append(" usePlotGradientColor='0' ") //bar의 그라데이션 없애기
                .append(" plotSpacePercent='50' ") //bar의 크기
                .append(" plotBorderAlpha='10' ")
                .append(" exportEnabled='1' ")
                .append(" exportAtClient='0' ")
                .append(" exportAction='save' ")
                .append(" exportShowMenuItem='0' ")
                .append(" exportDialogMessage='Building chart output' ")
                .append(" exportHandler='" + contextPath + "/servlet/FCExporter/export.do' exportCallBack='myFN' ")
                .append(" >");

        Map yearNoMap = convertObjectListToMapWithCompareValue(institutionWithMonthYearList, "clgNm", institutionWithMonthYearList.get(0).getClgNm(), "pubYear", source);

        String month = "";
        for (int ii = fy; ii <= ty; ii++) {
            int forM = 12;
            if (ii == currentY) forM = currentM;

            for (int i = 1; i <= forM; i++) {
                if (i < 10) {
                    month = "0" + i;
                } else {
                    month = i + "";
                }
                Object val = yearNoMap.get(Integer.toString(ii) + month);

                if (val == null) val = 0;

                if (i == 1) {
                    xml.append("<set label='" + ii + "' value='" + val + "'  toolText='" + ii + "-" + month + " : " + String.format("%,d", Integer.parseInt(val.toString())) + "' />");
                } else {
                    xml.append("<set label='' value='" + val + "'  toolText='" + ii + "-" + month + " : " + String.format("%,d", Integer.parseInt(val.toString())) + "' />");
                }
            }
        }

        xml.append("<styles>");
        xml.append("    <definition>");
        xml.append("        <style name='myLabelsFont' type='font' font='Malgun Gothic' size='12' bold='1' />");
        xml.append("        <style name='CaptionFont' type='font' size='12'/>");
        xml.append("   </definition>");
        xml.append("    <application>");
        xml.append("       <apply toObject='CAPTION' styles='CaptionFont' />");
        xml.append("       <apply toObject='SUBCAPTION' styles='CaptionFont' />");
        xml.append("       <apply toObject='DataLabels' styles='myLabelsFont' />");
        xml.append("    </application>");
        xml.append(" </styles>");

        xml.append("</chart>");

        return xml.toString();
    }


    /**
     * <pre>
     *  1. 개   요 : Make chart xml for Impact factor
     *  2. 처리내용 :
     * </pre>
     *  @Method Name : build2DChartXml
     *  @param list
     *  @param contextPath
     *  @return
     */
    public static String buildRankquartyChartXml (List < JcrCatRankingVo > list, RimsSearchVo searchVo, String
            contextPath){
        String type = searchVo.getType(); //CNT / PERCENT
        StringBuffer xml = new StringBuffer();

        xml.append("<chart ")
                .append(" caption= 'Published Journal Impact' ")
                .append(" bgColor= 'ffffff' ")
                .append(" borderAlpha= '20' ")
                .append(" thousandSeparatorPosition= '2,3' ") //그래프 위로 나타난 값의 천단위에, 붙여줌
                .append(" formatNumberScale='0'")
                .append(" showCanvasBorder= '0' ")
                .append(" usePlotGradientColor= '0' ")
                .append(" showBorder='0' ")
                .append(" plotBorderAlpha= '10' ")
                .append(" legendBorderAlpha= '0' ")
                .append(" legendShadow= '0' ")
                .append(" valueFontColor= 'ffffff' ")
                .append(" showXAxisLine= '1' ")
                .append(" xAxisLineColor= '999999' ")
                .append(" divlineColor= '999999' ")
                .append(" divLineIsDashed= '1' ")
                .append(" showAlternateVGridColor= '0' ")
                .append(" showHoverEffect='1' ")
                .append(" toolTipColor='#ffffff' ")
                .append(" toolTipBorderColor='#ffffff' ")
                .append(" toolTipBorderThickness='1' ")
                .append(" toolTipBgColor='#000000' ")
                .append(" toolTipBgAlpha='80' ")
                .append(" toolTipBorderRadius='4' ")
                .append(" toolTipPadding='10' ")
                .append(" toolTipFontSize ='20' ")
                .append(" exportEnabled='1' ")
                .append(" exportAtClient='0' ")
                .append(" exportAction='save' ")
                .append(" exportShowMenuItem='0' ")
                .append(" exportDialogMessage='Building chart output' ")
                .append(" exportHandler='" + contextPath + "/servlet/FCExporter/export.do' exportCallBack='myFN' ");
        if (type != null && type.equals("PERCENT")) {
            xml.append(" stack100percent= '1' ");
            xml.append(" showpercentvalues= '1' ");
        }
        xml.append(" >");

        int fy = Integer.parseInt(searchVo.getFromYear());
        int ty = Integer.parseInt(searchVo.getToYear());

        xml.append("<categories >");
        for (int ii = ty; ii >= fy; ii--) {
            xml.append("<category label='" + ii + "' />");
        }
        xml.append("</categories>");

        Map totalByYearMap = convertJcrCatRankingVoListToMapWithCompareValue(list, "rankquarty", "total", "prodyear", "cnt");
        Map q1Map = convertJcrCatRankingVoListToMapWithCompareValue(list, "rankquarty", "Q1", "prodyear", "cnt");
        Map q2Map = convertJcrCatRankingVoListToMapWithCompareValue(list, "rankquarty", "Q2", "prodyear", "cnt");
        Map q3Map = convertJcrCatRankingVoListToMapWithCompareValue(list, "rankquarty", "Q3", "prodyear", "cnt");
        Map q4Map = convertJcrCatRankingVoListToMapWithCompareValue(list, "rankquarty", "Q4", "prodyear", "cnt");

        for (int i = 0; i < 4; i++) {
            int num = i + 1;
            xml.append("<dataset seriesName='Q" + num + "' color='" + rims2Color[i] + "'>");
            for (int ii = ty; ii >= fy; ii--) {

                Object val = null;
                if (i == 0) {
                    val = q1Map.get(Integer.toString(ii));
                } else if (i == 1) {
                    val = q2Map.get(Integer.toString(ii));
                } else if (i == 2) {
                    val = q3Map.get(Integer.toString(ii));
                } else if (i == 3) {
                    val = q4Map.get(Integer.toString(ii));
                }

                if (val == null) val = 0;

                if (type.equals("PERCENT")) {
                    Object tot = totalByYearMap.get(ii + "");

                    val = (Double.parseDouble(val.toString()) / Double.parseDouble(tot.toString())) * 100;
                    xml.append("<set value='" + val + "' toolText='" + ii + "(Q" + num + ") : " + String.format("%1$,.2f", val) + "%'/>");
                } else {
                    xml.append("<set value='" + val + "' toolText='" + ii + "(Q" + num + ") : " + String.format("%,d", Integer.parseInt(val.toString())) + "'/>");
                }

            }
            xml.append("</dataset>");
        }
        xml.append("</chart>");

        return xml.toString();
    }

    public static Map<String, Object> buildChartData
            (List < AnalysisVo > analysisList, List < AnalysisVo > analysisYearList, RimsSearchVo searchVo){

        String fromYear = searchVo.getFromYear();
        String toYear = searchVo.getToYear();

        int fy = Integer.parseInt(fromYear);
        int ty = Integer.parseInt(toYear);

        List<Map<String, Object>> categories = new ArrayList<Map<String, Object>>();
        List<Map<String, String>> labels = new ArrayList<Map<String, String>>();
        Map<String, Object> category = new HashMap<String, Object>();
        List<Map<String, Object>> dataset = new ArrayList<Map<String, Object>>();
        List<Map<String, Object>> styles = new ArrayList<Map<String, Object>>();
        Map<String, Object> bigMap;
        List<Map<String, Object>> contentMapList;
        Map<String, Object> detailMap;

        for (int ii = fy; ii <= ty; ii++) {
            Map<String, String> label = new HashMap<String, String>();
            label.put("label", ii + "");
            labels.add(label);
        }
        category.put("category", labels);
        categories.add(category);


        for (AnalysisVo analysis : analysisList) {
            Map yearNoMap = convertObjectListToMap(analysisYearList, analysis.getStndValue(), analysis.getDataValue());   //ex (valueWithYearList, "pubyear","artstotal")
            String sn = analysis.getCtgryName();

            List<Map<String, Object>> totData = new ArrayList<Map<String, Object>>();

            for (int ii = fy; ii <= ty; ii++) {
                Object val = yearNoMap.get(Integer.toString(ii));
                Map<String, Object> totDataMap = new LinkedHashMap<>();


                if (val == null) {
                    totDataMap.put("value", "0");
                    totDataMap.put("tooltext", sn + " " + ii + ": 0");
                } else {
                    if (val.toString().contains(".")) {
                        totDataMap.put("value", String.format("%1$.2f", Double.parseDouble(val.toString())));
                        totDataMap.put("tooltext", sn + " " + ii + ": " + String.format("%1$,.2f", Double.parseDouble(val.toString())));
                    } else {
                        totDataMap.put("value", val + "");
                        totDataMap.put("tooltext", sn + " " + ii + ": " + String.format("%,d", Integer.parseInt(val.toString())));
                    }

                }
                totData.add(totDataMap);
            }

            Map<String, Object> totDatasetMap = new HashMap<String, Object>();
            totDatasetMap.put("seriesName", sn);
            //totDatasetMap.put("id",analysis.getCtgryCode());
            totDatasetMap.put("data", totData);

            dataset.add(totDatasetMap);
        }

        // styles 영역
        bigMap = new HashMap<String, Object>();
        Map<String, Object> secondBigMap = new HashMap<>();
        contentMapList = new ArrayList<Map<String, Object>>();
        detailMap = new LinkedHashMap<>();
        List<Map<String, Object>> stylesList = new ArrayList<>();

        detailMap.put("name", "CaptionFont");
        detailMap.put("type", "font");
        detailMap.put("size", "12");
        contentMapList.add(detailMap);

        secondBigMap.put("definition", contentMapList);

        contentMapList = new ArrayList<Map<String, Object>>();
        detailMap = new LinkedHashMap<>();

        detailMap.put("toObject", "CAPTION");
        detailMap.put("styles", "CaptionFont");

        contentMapList.add(detailMap);
        detailMap = new LinkedHashMap<>();

        detailMap.put("toObject", "SUBCAPTION");
        detailMap.put("styles", "CaptionFont");

        contentMapList.add(detailMap);

        secondBigMap.put("application", contentMapList);
        stylesList.add(secondBigMap);
        bigMap.put("styles", stylesList);
        styles.add(bigMap);

        Map<String, Object> resultMap = new HashMap<>();

        resultMap.put("categories", categories);
        resultMap.put("dataset", dataset);
        resultMap.put("styles", styles);

        return resultMap;
    }

    public static Map<String, Object> buildMultiAxisChartData
            (List < AnalysisVo > analysisList, List < AnalysisVo > analysisYearList, RimsSearchVo searchVo){

        String fromYear = searchVo.getFromYear();
        String toYear = searchVo.getToYear();

        int fy = Integer.parseInt(fromYear);
        int ty = Integer.parseInt(toYear);

        List<Map<String, Object>> categories = new ArrayList<Map<String, Object>>();
        List<Map<String, String>> labels = new ArrayList<Map<String, String>>();
        Map<String, Object> category = new HashMap<String, Object>();
        List<Map<String, Object>> datasets = new ArrayList<Map<String, Object>>();

        for (int ii = fy; ii <= ty; ii++) {
            Map<String, String> label = new HashMap<String, String>();
            label.put("label", ii + "");
            labels.add(label);
        }
        category.put("category", labels);
        categories.add(category);

        int i = 0;
        for (AnalysisVo analysis : analysisList) {
            Map yearNoMap = convertObjectListToMap(analysisYearList, analysis.getStndValue(), analysis.getDataValue());   //ex (valueWithYearList, "pubyear","artstotal")
            String sn = analysis.getCtgryName();

            List<Map<String, Object>> totData = new ArrayList<Map<String, Object>>();

            for (int ii = fy; ii <= ty; ii++) {
                Object val = yearNoMap.get(Integer.toString(ii));

                Map<String, Object> totDataMap = new LinkedHashMap<>();

                if (val == null) {
                    totDataMap.put("value", "0");
                    totDataMap.put("tooltext", sn + " " + ii + ": 0");
                } else {
                    totDataMap.put("value", val + "");

                    if (val.toString().contains(".")) {
                        val = String.format("%1$,.2f", Double.parseDouble(val.toString()));
                    } else {
                        val = String.format("%,d", Integer.parseInt(val.toString()));
                    }

                    totDataMap.put("tooltext", sn + " " + ii + ": " + val);
                }
                totData.add(totDataMap);
            }

            List<Map<String, Object>> totDatasetMapList = new ArrayList<>();
            Map<String, Object> totDatasetMap = new HashMap<String, Object>();
            totDatasetMap.put("seriesName", sn);
            totDatasetMap.put("data", totData);

            totDatasetMapList.add(totDatasetMap);

            Map<String, Object> dataset = new HashMap<String, Object>();
            dataset.put("dataset", totDatasetMapList);
            dataset.put("tickwidth", "10");

            if (i != 0) dataset.put("axisonleft", "0");

            i++;
            datasets.add(dataset);
        }

        Map<String, Object> resultMap = new HashMap<>();

        resultMap.put("categories", categories);
        resultMap.put("dataset", datasets);

        return resultMap;
    }

    public static Map<String, Object> buildLineColumnChartData
            (List < AnalysisVo > analysisList, List < AnalysisVo > analysisYearList, RimsSearchVo searchVo){
        List<Map<String, Object>> categories = new ArrayList<Map<String, Object>>();
        List<Map<String, Object>> dataset = new ArrayList<Map<String, Object>>();
        List<Map<String, Object>> lineset = new ArrayList<Map<String, Object>>();
        List<Map<String, Object>> lineList = new ArrayList<Map<String, Object>>();
        List<Map<String, Object>> dataList = new ArrayList<Map<String, Object>>();
        Map<String, Object> category = new HashMap<String, Object>();
        List<Map<String, Object>> labels = new ArrayList<Map<String, Object>>();
        Map<String, Object> label;
        List<Map<String, Object>> listForDataset = new ArrayList<Map<String, Object>>();

        Map<String, Object> resultMap = new HashMap<>();

        String lineChartName = "";
        String chartName = "";

        int fy = Integer.parseInt(searchVo.getFromYear());
        int ty = Integer.parseInt(searchVo.getToYear());

        for (int ii = fy; ii <= ty; ii++) {
            //연도
            label = new HashMap<String, Object>();
            label.put("label", ii + "");
            labels.add(label);
        }

        int i = 0;
        for (AnalysisVo analysis : analysisList) {
            Map yearNoMap = convertObjectListToMap(analysisYearList, analysis.getStndValue(), analysis.getDataValue());   //ex (valueWithYearList, "pubyear","artstotal")
            String sn = analysis.getCtgryName();

            List<Map<String, Object>> totData = new ArrayList<Map<String, Object>>();

            for (int ii = fy; ii <= ty; ii++) {
                Object val = yearNoMap.get(Integer.toString(ii));
                Map<String, Object> totDataMap = new LinkedHashMap<>();
                if ("totRsrcct".equals(analysis.getDataValue()) && val != null)
                    val = (Long.parseLong(val + "") / 1000000) + "";

                if (val == null) {
                    totDataMap.put("value", "0");
                    totDataMap.put("tooltext", sn + " " + ii + ": 0");
                } else {
                    totDataMap.put("value", val + "");

                    if (val.toString().contains(".")) {
                        val = String.format("%1$,.2f", Double.parseDouble(val.toString()));
                    } else {
                        val = String.format("%,d", Integer.parseInt(val.toString()));
                    }

                    totDataMap.put("tooltext", sn + " " + ii + ": " + val);
                }

                if (i == 0) {
                    chartName = sn;
                    listForDataset.add(totDataMap);
                } else {
                    lineChartName = sn;
                    lineList.add(totDataMap);
                }
            }
            i++;
        }

        category.put("category", labels);
        categories.add(category);

        Map<String, Object> totLinesetMap = new HashMap<String, Object>();
        totLinesetMap.put("seriesName", lineChartName);
        totLinesetMap.put("showValues", "0");
        totLinesetMap.put("data", lineList);

        lineset.add(totLinesetMap);

        Map<String, Object> totDatasetMap1 = new HashMap<String, Object>();
        totDatasetMap1.put("seriesName", chartName);
        totDatasetMap1.put("data", listForDataset);

        dataList.add(totDatasetMap1);

        Map<String, Object> datasetMap = new HashMap<>();
        datasetMap.put("dataset", dataList);

        dataset.add(datasetMap);

        resultMap.put("categories", categories);
        resultMap.put("lineset", lineset);
        resultMap.put("dataset", dataset);

        return resultMap;
    }

    public static Map<String, Object> findCoAuthorChartDataset (String
                                                                        contextPath, List < AnalysisVo > coAuthorList, AnalysisVo mainDepartment, String language, String type){

        double maxTtl = 0;
        double maxCoworkCnt = 0;
        double maxRel = 0;
        int radius;
        Map<String, String> dcMap = new HashMap<String, String>();
        int dfFillIdx = 0;
        String fillColor = "";
        List<Map<String, Object>> styles = new ArrayList<Map<String, Object>>();
        List<Map<String, Object>> dataset = new ArrayList<Map<String, Object>>();
        List<Object> connectors = new ArrayList<Object>();
        Map<String, Object> bigMap;
        List<Map<String, Object>> contentMapList;
        Map<String, Object> detailMap;

        //dataset 영역
        for (AnalysisVo coAuthor : coAuthorList) {
            if (maxCoworkCnt < coAuthor.getCoArtsCo()) maxCoworkCnt = coAuthor.getCoArtsCo();
        }

        int step = coAuthorList.size() == 0 ? 0 : 360 / coAuthorList.size();
        if (coAuthorList.size() > 0) maxRel = coAuthorList.get(0).getCoArtsCo();

        double total = Double.parseDouble(mainDepartment.getArtsCo().toString());
        if (maxTtl < total) maxTtl = total;
        radius = (int) ((total / maxTtl) * 30) + 28;
        if (dcMap.get(mainDepartment.getDeptKor()) == null) {
            fillColor = shareFillColors[dfFillIdx];
            dfFillIdx++;
            dcMap.put(mainDepartment.getDeptKor(), "#" + fillColor);
        }


        bigMap = new HashMap<String, Object>();
        contentMapList = new ArrayList<Map<String, Object>>();
        detailMap = new LinkedHashMap<>();
        String deptNm = mainDepartment.getDeptKor();

        if ("en".equals(language)) {
            deptNm = mainDepartment.getDeptEngMostAbbr();
        }

        if ("mini".equals(StringUtils.defaultString(mainDepartment.getItemType()))) {
            if ("한국과학기술원".equals(mainDepartment.getDeptKor())) {
                deptNm = "KAIST";
            }
            detailMap.put("labelAlign", "middle");
            detailMap.put("color", "#ffffff");
            radius = 40;

            bigMap.put("plotborderthickness", "8");
        } else {
            detailMap.put("color", "#" + fillColor);

        }

        detailMap.put("x", "50");
        detailMap.put("y", "50");
        detailMap.put("name", deptNm);
        detailMap.put("radius", radius);
        detailMap.put("id", "id_0");
        detailMap.put("shape", "CIRCLE");

        contentMapList.add(detailMap);

        bigMap.put("data", contentMapList);
        bigMap.put("seriesName", deptNm);
        bigMap.put("plotBorderColor", "#" + fillColor);

        dataset.add(bigMap);

        boolean dist = false;

        int width = 120;
        int height = 80;
        int imageHeight = 50;
        int imageWidth = 50;

        for (int jj = 0; jj < coAuthorList.size(); jj++) {
            Random rndm = new Random();

            int degree = (450 - step * jj) % 360;

            double radians = (Math.PI / 180) * degree;

            double cnt = Double.parseDouble(coAuthorList.get(jj).getCoArtsCo().toString());

            double distRatio = dist == true ? (rndm.nextInt(1) + 9) / 10.0 : (rndm.nextInt(3) + 7) / 10.0;

            double x = Math.sin(radians) * 35.0 * distRatio + 50.0;
            double y = Math.cos(radians) * 35.0 * distRatio + 50.0;

            radius = (int) ((cnt / maxCoworkCnt) * 25) + 28;

            deptNm = coAuthorList.get(jj).getDeptKor();
            String link = "";

            if (dcMap.get(coAuthorList.get(jj).getDeptKor()) == null) {
                fillColor = shareFillColors[dfFillIdx];
                dfFillIdx++;
                dcMap.put((String) coAuthorList.get(jj).getDeptKor(), "#" + fillColor);
            }

            bigMap = new HashMap<String, Object>();
            /*bigMap.put("showPlotBorder","0");*/
            contentMapList = new ArrayList<Map<String, Object>>();
            detailMap = new LinkedHashMap<>();

            String imageUrl = contextPath + "/share/img/icon/dept_icon.png";

            if ("mini".equals(StringUtils.defaultString(mainDepartment.getItemType()))) {
                x = Math.sin(radians) * 40.0 * distRatio + 50.0;
                y = Math.cos(radians) * 40.0 * distRatio + 50.0;

                detailMap.put("labelAlign", "middle");
                detailMap.put("width", "150");
                detailMap.put("height", "150");
                detailMap.put("toolText", deptNm);
                detailMap.put("radius", "40");
                detailMap.put("shape", "CIRCLE");

                bigMap.put("plotborderthickness", "8");
                bigMap.put("plotBorderColor", "#" + fillColors[jj]);
            } else {
                bigMap.put("plotBorderAlpha", "0");
                bigMap.put("plotFillAlpha", "0");
                //내부기관 일때
                if ("co".equals(type)) {
                    if ("en".equals(language) && coAuthorList.get(jj).getDeptEngMostAbbr() != null) {
                        deptNm = coAuthorList.get(jj).getDeptEngMostAbbr();
                        link = "j-deptChartClick-" + coAuthorList.get(jj).getDeptCode() + "__" + coAuthorList.get(jj).getDeptEngNm();
                    } else {
                        link = "j-deptChartClick-" + coAuthorList.get(jj).getDeptCode() + "__" + coAuthorList.get(jj).getDeptKor();
                    }

                    //타기관 일때
                } else {
                    imageUrl = contextPath + "/share/img/icon/inst_icon.png";
                    if ("en".equals(language) && coAuthorList.get(jj).getDeptEngMostAbbr() != null) {
                        deptNm = coAuthorList.get(jj).getDeptEngMostAbbr();
                        link = "j-outChartClick-" + coAuthorList.get(jj).getDeptEngNm();
                    } else {
                        link = "j-outChartClick-" + deptNm;
                    }
                }

                detailMap.put("labelAlign", "top");
                detailMap.put("width", width + "");
                detailMap.put("height", height + "");
                detailMap.put("imageNode", "1");
                detailMap.put("imageHeight", imageHeight + "");
                detailMap.put("imageWidth", imageWidth + "");
                detailMap.put("imageurl", imageUrl);
                detailMap.put("imageAlign", "bottom");
                detailMap.put("link", link);
                detailMap.put("toolText", deptNm);
            }
            detailMap.put("x", x + "");
            detailMap.put("y", y + "");
            detailMap.put("name", deptNm);
            detailMap.put("id", "id_" + (jj + 1));
            detailMap.put("color", "#ffffff");

            contentMapList.add(detailMap);
            bigMap.put("data", contentMapList);
            bigMap.put("seriesName", deptNm);

            dataset.add(bigMap);

            dist = dist == true ? false : true;
        }

        //connector 영역
        Map<String, Object> connectorsOptMap = new LinkedHashMap<>();
        contentMapList = new ArrayList<Map<String, Object>>();

        connectorsOptMap.put("color", "#AAAAAA");
        connectorsOptMap.put("stdThickness", "5");


        for (int ki = 0; ki < coAuthorList.size(); ki++) {
            int cnt = Integer.parseInt(coAuthorList.get(ki).getCoArtsCo().toString());
            deptNm = (String) coAuthorList.get(ki).getDeptKor();
            detailMap = new LinkedHashMap<>();

            if ("en".equals(language) && coAuthorList.get(ki).getDeptEngMostAbbr() != null) {
                //타기관이 아닐때
                detailMap.put("link", "j-deptChartClick-" + coAuthorList.get(ki).getDeptCode() + "__" + coAuthorList.get(ki).getDeptEngNm());
            } else {
                //타기관 일때
                detailMap.put("link", "j-outChartClick-" + deptNm);

            }

            double alpha = (cnt / maxRel) * 1.1 + 0.7;


            detailMap.put("strength", (alpha) + "");
            detailMap.put("label", cnt + "");
            detailMap.put("from", "id_0");
            detailMap.put("to", "id_" + (ki + 1));
            detailMap.put("arrowAtStart", "0");
            detailMap.put("arrowAtEnd", "0");

            contentMapList.add(detailMap);
        }

        connectorsOptMap.put("connector", contentMapList);
        connectors.add(connectorsOptMap);

        // styles 영역
        bigMap = new HashMap<String, Object>();
        Map<String, Object> secondBigMap = new HashMap<>();
        contentMapList = new ArrayList<Map<String, Object>>();
        detailMap = new LinkedHashMap<>();
        List<Map<String, Object>> stylesList = new ArrayList<>();

        detailMap.put("name", "myLabelsFont");
        detailMap.put("type", "font");
        detailMap.put("font", "Malgun Gothic");
        detailMap.put("bold", "0");
        detailMap.put("size", "11");
        detailMap.put("color", "000000");
        contentMapList.add(detailMap);

        secondBigMap.put("definition", contentMapList);

        contentMapList = new ArrayList<Map<String, Object>>();
        detailMap = new LinkedHashMap<>();

        detailMap.put("toObject", "DataLabels");
        detailMap.put("styles", "myLabelsFont");

        contentMapList.add(detailMap);

        secondBigMap.put("application", contentMapList);
        stylesList.add(secondBigMap);
        bigMap.put("styles", stylesList);
        styles.add(bigMap);


        Map<String, Object> resultMap = new HashMap<>();

        resultMap.put("dataset", dataset);
        resultMap.put("connectors", connectors);
        resultMap.put("styles", styles);

        return resultMap;
    }

    //키워드, 빈도 리턴
    public static List<Map<String, String>> userKeywordList (List < KeywordVo > keywordList) {
        List<String> wlist = new ArrayList<String>();
        List<String> keywordRegxList = new ArrayList();

        List<Map<String, String>> resultList = new ArrayList<>();

        final Map cntWord = new HashMap();     // 키워드 , 빈도수 map
        double maxCnt = 0;

        if (keywordList != null && !keywordList.isEmpty()) {
            // 모든 키워드를 가져와서, 각 키워드 별 빈도수를 체크하는 map
            for (KeywordVo keywordVo : keywordList) {
                String keyword = keywordVo.getKeywordRegx();

                if (!"".equals(keyword) && keyword != null) {
                    if (wlist.indexOf(keyword) == -1) {
                        wlist.add(keyword);
                        cntWord.put(keyword, 1);
                    } else {
                        int currCnt = (Integer) cntWord.get(keyword);
                        if (maxCnt < currCnt + 1) maxCnt = currCnt + 1.0;
                        cntWord.put(keyword, currCnt + 1);
                    }
                }
            }
            keywordRegxList.addAll(cntWord.keySet());

            for (int i = 0; i < keywordRegxList.size(); i++) {
                for (int j = 0; j < keywordList.size(); j++) {
                    if (keywordRegxList.get(i).equals(keywordList.get(j).getKeywordRegx())) {
                        Map<String, String> resultMap = new HashMap<>();
                        String keyword = keywordList.get(j).getKeyword();

                        resultMap.put("name", keyword);
                        resultMap.put("num", cntWord.get(keywordRegxList.get(i)) + "");
                        resultList.add(resultMap);
                        break;
                    }
                }
            }

            // 빈도수가 높은 순서대로 키워드를 재 정렬함.
            Collections.sort(resultList, new Comparator() {
                @Override
                public int compare(Object o1, Object o2) {
                    int v1 = Integer.parseInt(((Map<String, String>) o1).get("num"));
                    int v2 = Integer.parseInt(((Map<String, String>) o2).get("num"));
                    int val = 0;
                    if (v1 < v2) {
                        val = 1;
                    } else if (v1 > v2) {
                        val = -1;
                    }
                    return val;
                }

            });
            //Collections.reverse(list); // 주석시 오름차순
        }

        return resultList;
    }


    public static Map<String, Object> findPatentGroupByYearAndAcqs
            (List < AnalysisVo > regListGroupYear, List < AnalysisVo > applListGroupYear, RimsSearchVo searchVo){

        List<Map<String, Object>> categories = new ArrayList<Map<String, Object>>();
        List<Map<String, Object>> dataset = new ArrayList<Map<String, Object>>();
        List<Map<String, Object>> dataset1 = new ArrayList<Map<String, Object>>();
        List<Map<String, Object>> dataset2 = new ArrayList<Map<String, Object>>();
        List<Map<String, Object>> data10 = new ArrayList<Map<String, Object>>();
        List<Map<String, Object>> data11 = new ArrayList<Map<String, Object>>();
        List<Map<String, Object>> data20 = new ArrayList<Map<String, Object>>();
        List<Map<String, Object>> data21 = new ArrayList<Map<String, Object>>();
        List<Map<String, Object>> data22 = new ArrayList<Map<String, Object>>();
        List<Map<String, Object>> data23 = new ArrayList<Map<String, Object>>();
        List<Map<String, Object>> data24 = new ArrayList<Map<String, Object>>();
        List<Map<String, Object>> data25 = new ArrayList<Map<String, Object>>();
        Map<String, Object> category = new HashMap<String, Object>();
        List<Map<String, Object>> labels = new ArrayList<Map<String, Object>>();
        Map<String, Object> label;
        List<Map<String, Object>> styles = new ArrayList<Map<String, Object>>();
        Map<String, Object> style;
        List<Map<String, Object>> contentMapList;
        Map<String, Object> detailMap;

        Map<String, Object> resultMap = new HashMap<>();

        String fromYear = searchVo.getFromYear();
        String toYear = searchVo.getToYear();
        int fy = Integer.parseInt(fromYear);
        int ty = Integer.parseInt(toYear);

        //등록
        String keyField = "patYear";
        String allRegPatentValField = "registPatentCo";

        //출원일 경우
        String aplcNoPatentValField = "aplcPatentCo";
//		String aplcNoPatentValField = "aplcCo";
		/*String aplcStatus1ValField = "aplcStatus1Co";
		String aplcStatus2ValField = "aplcStatus2Co";
		String aplcStatus3ValField = "aplcStatus3Co";
		String aplcStatus4ValField = "aplcStatus4Co";
		String aplcStatus5ValField = "aplcStatus5Co";*/

        Map allRegPatentMap = convertObjectListToMap(regListGroupYear, keyField, allRegPatentValField);

        Map yearAplcNoPatentMap = convertObjectListToMap(applListGroupYear, keyField, aplcNoPatentValField);
		/*Map yearAplcStatus1Map  = convertObjectListToMap(applListGroupYear, keyField, aplcStatus1ValField);
		Map yearAplcStatus2Map  = convertObjectListToMap(applListGroupYear, keyField, aplcStatus2ValField);
		Map yearAplcStatus3Map  = convertObjectListToMap(applListGroupYear, keyField, aplcStatus3ValField);
		Map yearAplcStatus4Map  = convertObjectListToMap(applListGroupYear, keyField, aplcStatus4ValField);
		Map yearAplcStatus5Map  = convertObjectListToMap(applListGroupYear, keyField, aplcStatus5ValField);*/

        for (int ii = fy; ii <= ty; ii++) {
            //연도
            label = new HashMap<String, Object>();
            label.put("label", ii + "");
            labels.add(label);
        }

        category.put("category", labels);
        categories.add(category);

        //출원
        for (int ii = fy; ii <= ty; ii++) {
            Object val = yearAplcNoPatentMap.get(Integer.toString(ii));
            label = new HashMap<String, Object>();
            if (val == null) {
                label.put("value", "0");
                label.put("tooltext", ii + " 출원 : 0");
            } else {
                label.put("value", val + "");
                label.put("tooltext", ii + " 출원 : " + val);
            }
            data20.add(label);
        }
        Map<String, Object> totDatasetMap = new HashMap<String, Object>();
        totDatasetMap.put("seriesName", "출원");
        totDatasetMap.put("data", data20);

        dataset2.add(totDatasetMap);

		/*for(int ii = fy; ii <= ty ; ii++) {
			Object val = yearAplcStatus1Map.get(Integer.toString(ii));
			label = new HashMap<String, Object>();
			if(val==null) {
				label.put("value", "0");
				label.put("tooltext", ii + " 거절(출원) : 0");
			}else{
				label.put("value",val+"");
				label.put("tooltext",ii + " 거절(출원) : " + val);
			}
			data21.add(label);
		}
		totDatasetMap = new HashMap<String, Object>();
		totDatasetMap.put("seriesName","거절(출원)");
		totDatasetMap.put("data",data21);

		dataset2.add(totDatasetMap);

		for(int ii = fy; ii <= ty ; ii++) {
			Object val = yearAplcStatus2Map.get(Integer.toString(ii));
			label = new HashMap<String, Object>();
			if(val==null) {
				label.put("value", "0");
				label.put("tooltext", ii + " 포기/취하/종결(출원) : 0");
			}else{
				label.put("value",val+"");
				label.put("tooltext",ii + " 포기/취하/종결(출원) : " + val);
			}
			data22.add(label);
		}
		totDatasetMap = new HashMap<String, Object>();
		totDatasetMap.put("seriesName","포기/취하/종결(출원)");
		totDatasetMap.put("data",data22);

		dataset2.add(totDatasetMap);

		for(int ii = fy; ii <= ty ; ii++) {
			Object val = yearAplcStatus3Map.get(Integer.toString(ii));
			label = new HashMap<String, Object>();
			if(val==null) {
				label.put("value", "0");
				label.put("tooltext", ii + " 소멸(출원) : 0");
			}else{
				label.put("value",val+"");
				label.put("tooltext",ii + " 소멸(출원) : " + val);
			}
			data23.add(label);
		}
		totDatasetMap = new HashMap<String, Object>();
		totDatasetMap.put("seriesName","소멸(출원)");
		totDatasetMap.put("data",data23);

		dataset2.add(totDatasetMap);

		for(int ii = fy; ii <= ty ; ii++) {
			Object val = yearAplcStatus4Map.get(Integer.toString(ii));
			label = new HashMap<String, Object>();
			if(val==null) {
				label.put("value", "0");
				label.put("tooltext", ii + " 이관/양도(출원) : 0");
			}else{
				label.put("value",val+"");
				label.put("tooltext",ii + " 이관/양도(출원) : " + val);
			}
			data24.add(label);
		}
		totDatasetMap = new HashMap<String, Object>();
		totDatasetMap.put("seriesName","이관/양도(출원)");
		totDatasetMap.put("data",data24);

		dataset2.add(totDatasetMap);

		for(int ii = fy; ii <= ty ; ii++) {
			Object val = yearAplcStatus5Map.get(Integer.toString(ii));
			label = new HashMap<String, Object>();
			if(val==null) {
				label.put("value", "0");
				label.put("tooltext", ii + " 심판/소송/보류(출원) : 0");
			}else{
				label.put("value",val+"");
				label.put("tooltext",ii + " 심판/소송/보류(출원) : " + val);
			}
			data25.add(label);
		}
		totDatasetMap = new HashMap<String, Object>();
		totDatasetMap.put("seriesName","심판/소송/보류(출원)");
		totDatasetMap.put("data",data25);

		dataset2.add(totDatasetMap);*/

        Map<String, Object> dataset2Map = new HashMap<>();
        dataset2Map.put("dataset", dataset2);

        //등록
        for (int ii = fy; ii <= ty; ii++) {
            Object val = allRegPatentMap.get(Integer.toString(ii));
            label = new HashMap<String, Object>();
            if (val == null) {
                label.put("value", "0");
                label.put("tooltext", ii + " 등록 : 0");
            } else {
                label.put("value", val + "");
                label.put("tooltext", ii + " 등록 : " + val);
            }
            data10.add(label);
        }
        totDatasetMap = new HashMap<String, Object>();
        totDatasetMap.put("seriesName", "등록");
        totDatasetMap.put("data", data10);

        dataset1.add(totDatasetMap);

        Map<String, Object> dataset1Map = new HashMap<>();
        dataset1Map.put("dataset", dataset1);

        // styles 영역
        style = new HashMap<String, Object>();
        Map<String, Object> secondBigMap = new HashMap<>();
        contentMapList = new ArrayList<Map<String, Object>>();
        detailMap = new LinkedHashMap<>();
        List<Map<String, Object>> stylesList = new ArrayList<>();

        detailMap.put("name", "CaptionFont");
        detailMap.put("type", "font");
        detailMap.put("size", "12");
        contentMapList.add(detailMap);

        secondBigMap.put("definition", contentMapList);

        contentMapList = new ArrayList<Map<String, Object>>();
        detailMap = new LinkedHashMap<>();

        detailMap.put("toObject", "CAPTION");
        detailMap.put("styles", "CaptionFont");

        contentMapList.add(detailMap);
        detailMap = new LinkedHashMap<>();

        detailMap.put("toObject", "SUBCAPTION");
        detailMap.put("styles", "CaptionFont");
        contentMapList.add(detailMap);

        secondBigMap.put("application", contentMapList);
        stylesList.add(secondBigMap);
        style.put("styles", stylesList);
        styles.add(style);


        dataset.add(dataset2Map);
        dataset.add(dataset1Map);
        resultMap.put("categories", categories);
        resultMap.put("dataset", dataset);
        resultMap.put("styles", styles);

        return resultMap;
    }


    /**
     * <pre>
     *  1. 개   요 : Make chart xml for co-author network
     *  2. 처리내용 :
     * </pre>
     *
     * @param contextPath
     * @return
     * @Method Name : buildNetworkInCenter
     */
    public static String buildCoAuthorNetworkChartV2(AnalysisVo mainUser, List<AnalysisVo> list, RimsSearchVo searchVo, String contextPath, String lang, String photoUrl) {

        //System.out.println("lang >>>>>>>>>> " + lang);

        double maxCoworkCnt = 0;
        double maxRel = 0;
        dcMap = new HashMap<String, String>();
        int dfFillIdx = 0;
        String fillColor = "";

        for (int jj = 0; jj < list.size(); jj++) {
            int total = list.get(jj).getCoArtsCo();
            if (maxCoworkCnt < total) maxCoworkCnt = total;
        }

        StringBuffer sb = new StringBuffer();

        sb.append("<chart ")
                .append(" subcaption='' ")
                .append(" baseFontColor='#666666' ")
                .append(" baseFontSize='11' ")
                .append(" subcaptionFontBold='0' ")
                .append(" canvasBgAlpha='0' ")
                .append(" showValues='0' ")
                .append(" paletteColors='" + paletteColors + "' ")
                .append(" bgAlpha='0' ")
                .append(" showBorder='0' ")
                .append(" showformbtn='0' ")
                .append(" showRestoreBtn='0' ")
                .append(" viewmode='1' ")
                .append(" xAxisMaxValue='100' ")
                .append(" yAxisMinValue='0' ")
                .append(" yAxisMaxValue='100' ")
                .append(" chartTopMargin='3' ")
                .append(" chartLeftMargin='3' ")
                .append(" chartRightMargin='3' ")
                .append(" chartBottomMargin='3' ")
                .append(" showAlternateHGridColor='0' ")
                .append(" showCanvasBorder='0' ")
                .append(" showXAxisLine='0' ")
                .append(" xAxisLineThickness='0' ")
                .append(" xAxisLineColor='#cdcdcd' ")
                .append(" xAxisNameFontColor='#8d8d8d' ")
                .append(" yAxisNameFontColor='#8d8d8d' ")
                .append(" canvasBgColor='#ffffff' ")
                .append(" lineThickness='4' ")
                .append(" legendBgColor='#ffffff' ")
                .append(" legendBgAlpha='100' ")
                .append(" legendBorderAlpha='50' ")
                .append(" legendBorderColor='#888888' ")
                .append(" legendShadow='0' ")
                .append(" legendPosition='CENTER' ")
                .append(" divlineThickness='0' ")
                .append(" numDivLines='10' ")
                .append(" toolTipColor='#ffffff' ")
                .append(" toolTipBorderColor='#ffffff' ")
                .append(" toolTipBorderThickness='1' ")
                .append(" toolTipBgColor='#000000' ")
                .append(" toolTipBgAlpha='80' ")
                .append(" toolTipBorderRadius='4' ")
                .append(" toolTipPadding='10' ")
                .append(" toolTipFontSize ='20' ")
                .append(" anchorBgColor='#ffffff' ")
                .append(" anchorRadius='5' ")
                .append(" anchorBorderThickness='3' ")
                .append(" anchorTrackingRadius='15' ")
                .append(" showHoverEffect='1' ")
                .append(" formatNumberScale='0'")
                .append(" labelDisplay='rotate' ")
                .append(" slantLabels='1' ")
                .append(" exportEnabled='1' ")
                .append(" exportAtClient='0' ")
                .append(" exportAction='save' ")
                .append(" exportShowMenuItem='0' ")
                .append(" exportDialogMessage='Building chart output' ")
                .append(" exportHandler='" + contextPath + "/servlet/FCExporter/export.do' exportCallBack='myFN' ")
                .append(" >");


        double step = list.size() == 0 ? 0 : 360d / list.size();
        if (list.size() > 0) maxRel = list.get(0).getCoArtsCo();

        if (dcMap.get(mainUser.getClgNm()) == null) {
            fillColor = fillColors[dfFillIdx];
            dfFillIdx++;
            dcMap.put(mainUser.getClgNm(), fillColor);
        }

        String name = lang.equals("KOR") ? mainUser.getKorNm() : mainUser.getEngNm();
        String abbrName = lang.equals("KOR") ? mainUser.getKorNm() : mainUser.getAbbrEngNm();
        String dept = lang.equals("KOR") ? mainUser.getDeptKor() : mainUser.getDeptEngAbbr();

        if ("".equals(abbrName.replace(",", ""))) abbrName = mainUser.getKorNm();

        sb.append("<dataset seriesName='" + name + "' plotborderthickness='8'  plotBorderColor='" + fillColor + "' >");
        sb.append("<set width='150' x='50' y='50' label='[" + abbrName + "]{br}" + dept + "' height='150' id='id_0' radius='60' shape='CIRCLE' color='#d4f9ff' labelAlign='middle' toolText='[" + name + "]{br}" + dept + "' />");
        sb.append("</dataset>");

        boolean dist = true;
        for (int jj = 0; jj < list.size(); jj++) {

            double degree = (450d - step * (jj % 2 == 0 ? jj : list.size() - jj - (list.size() % 2 == 0 ? 0 : 1))) % 360d;

            double radians = (Math.PI / 180) * degree;

            double x = Math.sin(radians) * 30.0 + 50.0;
            double y = Math.cos(radians) * 30.0 + 50.0;

            name = lang.equals("KOR") ? list.get(jj).getKorNm() : list.get(jj).getEngNm();
            abbrName = lang.equals("KOR") ? list.get(jj).getKorNm() : list.get(jj).getAbbrEngNm();
            dept = lang.equals("KOR") ? list.get(jj).getDeptKor() : list.get(jj).getDeptEngAbbr();

            if ("".equals(name.replace(",", "").trim())) name = list.get(jj).getKorNm();
            if ("".equals(abbrName.replace(",", "").trim())) abbrName = list.get(jj).getKorNm();
            if (dept == null) dept = list.get(jj).getDeptKor();

            String dispValue = StringUtils.replace(name, "'", "&#39;");
            String labelValue = StringUtils.replace(abbrName, "'", "&#39;");

            if (dcMap.get(list.get(jj).getClgNm()) == null) {
                fillColor = fillColors[dfFillIdx];
                dfFillIdx++;
                dcMap.put(list.get(jj).getClgNm(), fillColor);
            } else {
                fillColor = dcMap.get(list.get(jj).getClgNm());
            }

            String targetUserId = (String) list.get(jj).getUserId();
            String imageUrl2 = contextPath + "/images/icon/node/node_";

            String imageSize = "15";
            if (maxRel >= 3) {
                if (list.get(jj).getCoArtsCo() > (maxRel / 3 * 2)) {
                    imageSize = "35";
                } else if (list.get(jj).getCoArtsCo() > (maxRel / 3)) {
                    imageSize = "25";
                } else {
                    imageSize = "15";
                }
            }

            String image = imageUrl2 + fillColor + ".png";

            sb.append("<dataset seriesName='" + dispValue + "' showPlotBorder='0' plotBorderAlpha='0' allowDrag='1' showformbtn='0' plotFillAlpha='0' >");
            sb.append("<set x='" + x + "' y='" + y + "' label='[" + labelValue + "]{br}" + dept + "' name='" + labelValue + "' id='id_" + (jj + 1) + "' labelAlign='top' link='j-chartClick-inst;" + targetUserId + ";" + dispValue + "' toolText='[" + dispValue + "]{br}" + dept + "'");
            sb.append(" imageWidth='" + imageSize + "' imageHeight='" + imageSize + "' width='100' height='100' imageNode='1' imageurl='" + image + "' imageAlign='middle' />");
            sb.append("</dataset>");


            dist = dist == true ? false : true;
        }

        sb.append("<connectors color='FF0000' stdThickness='5' strength='1'>");

        for (int ki = 0; ki < list.size(); ki++) {
            String color = "AAAAAA";

            String targetUserId = (String) list.get(ki).getUserId();
            String dispValue = StringUtils.replace(list.get(ki).getKorNm(), "'", "&#39;");

            int cnt = list.get(ki).getCoArtsCo();

            double alpha = (cnt / maxRel) * 0.8 + 0.2;

            sb.append("<connector strength='" + (alpha) + "' ");
            sb.append("from='id_0' ");
            sb.append("label ='" + cnt + "' to='id_" + (ki + 1) + "' alpha='" + (alpha * 100) + "' link='j-chartClick-" + R2Constant.COAUTHOR_TARGET_INST + ";" + targetUserId + ";" + dispValue + "'  ");
            sb.append("color='" + color + "' arrowAtStart='0' arrowAtEnd='0' />");
        }
        sb.append("</connectors>");
        sb.append("<styles>");
        sb.append("<definition>");
        sb.append("   <style name='myLabelsFont' type='font' font='Malgun Gothic' bold='1' size='11' color='555555'/>");
        sb.append("</definition>");
        sb.append("<application>");
        sb.append("   <apply toObject='DataLabels' styles='myLabelsFont' />");
        sb.append("</application>");
        sb.append("</styles>");
        sb.append("</chart>");

        return sb.toString();
    }

    public static String buildOtherInstitutionCoAuthorNetworkChartV2(AnalysisVo mainUser, List<AnalysisVo> list, RimsSearchVo searchVo, String contextPath, String lang, String photoUrl) {

        //System.out.println("lang >>>>>>>>>> " + lang);

        double maxCoworkCnt = 0;
        double maxRel = 0;
        dcMap = new HashMap<String, String>();
        int dfFillIdx = 0;
        String fillColor = "";

        for (int jj = 0; jj < list.size(); jj++) {
            int total = list.get(jj).getCoArtsCo();
            if (maxCoworkCnt < total) maxCoworkCnt = total;
        }

        StringBuffer sb = new StringBuffer();

        sb.append("<chart ")
                .append(" subcaption='' ")
                .append(" baseFontColor='#666666' ")
                .append(" baseFontSize='11' ")
                .append(" subcaptionFontBold='0' ")
                .append(" canvasBgAlpha='0' ")
                .append(" showValues='0' ")
                .append(" showformbtn='0' ")
                .append(" showRestoreBtn='0' ")
                .append(" viewmode='1' ")
                .append(" paletteColors='" + paletteColors + "' ")
                .append(" bgAlpha='0' ")
                .append(" showBorder='0' ")
                .append(" showShadow='0' ")
                .append(" showAlternateHGridColor='0' ")
                .append(" showCanvasBorder='0' ")
                .append(" xAxisMaxValue='100' ")
                .append(" yAxisMinValue='0' ")
                .append(" yAxisMaxValue='100' ")
                .append(" chartTopMargin='3' ")
                .append(" chartLeftMargin='3' ")
                .append(" chartRightMargin='3' ")
                .append(" chartBottomMargin='3' ")
                .append(" showXAxisLine='0' ")
                .append(" xAxisLineThickness='0' ")
                .append(" xAxisLineColor='#cdcdcd' ")
                .append(" xAxisNameFontColor='#8d8d8d' ")
                .append(" yAxisNameFontColor='#8d8d8d' ")
                .append(" canvasBgColor='#ffffff' ")
                .append(" lineThickness='4' ")
                .append(" legendBgColor='#ffffff' ")
                .append(" legendBgAlpha='100' ")
                .append(" legendBorderAlpha='50' ")
                .append(" legendBorderColor='#888888' ")
                .append(" legendShadow='0' ")
                .append(" legendPosition='CENTER' ")
                .append(" divlineAlpha='100' ")
                .append(" numDivLines='10' ")
                .append(" divlineColor='#999999' ")
                .append(" divlineThickness='0' ")
                .append(" toolTipColor='#ffffff' ")
                .append(" toolTipBorderColor='#ffffff' ")
                .append(" toolTipBorderThickness='1' ")
                .append(" toolTipBgColor='#000000' ")
                .append(" toolTipBgAlpha='80' ")
                .append(" toolTipBorderRadius='4' ")
                .append(" toolTipPadding='10' ")
                .append(" toolTipFontSize ='20' ")
                .append(" anchorBgColor='#ffffff' ")
                .append(" anchorRadius='5' ")
                .append(" anchorBorderThickness='3' ")
                .append(" anchorTrackingRadius='15' ")
                .append(" showHoverEffect='1' ")
                .append(" formatNumberScale='0'")
                .append(" labelDisplay='rotate' ")
                .append(" slantLabels='1' ")
                .append(" exportEnabled='1' ")
                .append(" exportAtClient='0' ")
                .append(" exportAction='save' ")
                .append(" exportShowMenuItem='0' ")
                .append(" exportDialogMessage='Building chart output' ")
                .append(" exportHandler='" + contextPath + "/servlet/FCExporter/export.do' exportCallBack='myFN' ")
                .append(" >");

        double step = list.size() == 0 ? 0 : 360d / list.size();
        if (list.size() > 0) maxRel = list.get(0).getCoArtsCo();

        if (dcMap.get(mainUser.getDeptKor()) == null) {
            fillColor = fillColors[dfFillIdx];
            dfFillIdx++;
            dcMap.put(mainUser.getDeptKor(), fillColor);
        }

        String name = lang.equals("KOR") ? mainUser.getKorNm() : mainUser.getEngNm();
        String abbrName = lang.equals("KOR") ? mainUser.getKorNm() : mainUser.getAbbrEngNm();
        String dept = lang.equals("KOR") ? mainUser.getDeptKor() : mainUser.getDeptEngAbbr();

        if ("".equals(abbrName.replace(",", ""))) abbrName = mainUser.getKorNm();
        dept = StringUtil.XMLEncode(dept);

        sb.append("<dataset seriesName='" + dept + "' plotborderthickness='8'  plotBorderColor='" + fillColor + "' >");
        sb.append("<set width='150' x='50' y='50' label='[" + abbrName + "]{br}" + dept + "' height='150' id='id_0' radius='60' shape='CIRCLE' color='#d4f9ff' labelAlign='middle' toolText='[" + name + "]{br}" + dept + "' />");
        sb.append("</dataset>");

        boolean dist = true;
        for (int jj = 0; jj < list.size(); jj++) {

            double degree = (450d - step * (jj % 2 == 0 ? jj : list.size() - jj - (list.size() % 2 == 0 ? 0 : 1))) % 360d;

            double radians = (Math.PI / 180) * degree;

            double x = Math.sin(radians) * 30.0 + 50.0;
            double y = Math.cos(radians) * 30.0 + 50.0;

            name = list.get(jj).getKorNm();
            dept = list.get(jj).getDeptKor();

            if ("".equals(name.replace(",", "").trim())) name = list.get(jj).getKorNm();
            if ("".equals(abbrName.replace(",", "").trim())) abbrName = list.get(jj).getKorNm();
            if (dept == null) dept = list.get(jj).getDeptKor();

            dept = StringUtil.XMLEncode(dept);
            String labelValue = StringUtils.replace(name, "'", "&#39;");

            if (dcMap.get(list.get(jj).getDeptKor()) == null) {
                fillColor = fillColors[dfFillIdx];
                dfFillIdx++;
                dcMap.put(list.get(jj).getDeptKor(), fillColor);
            } else {
                fillColor = dcMap.get(list.get(jj).getDeptKor());
            }

            String imageUrl2 = contextPath + "/images/icon/node/node_";

            String imageSize = "15";
            if (maxRel >= 3) {
                if (list.get(jj).getCoArtsCo() > (maxRel / 3 * 2)) {
                    imageSize = "35";
                } else if (list.get(jj).getCoArtsCo() > (maxRel / 3)) {
                    imageSize = "25";
                } else {
                    imageSize = "15";
                }
            }

            String image = imageUrl2 + fillColor + ".png";

            sb.append("<dataset seriesName='" + labelValue + "' showPlotBorder='0' plotBorderAlpha='0' allowDrag='1' showformbtn='0' plotFillAlpha='0' >");
            sb.append("<set x='" + x + "' y='" + y + "' label='[" + labelValue + "]{br}" + (dept != null && !dept.equals("") ? dept : "소속기관명 없음") + "' name='" + labelValue + "-" + dept + "' id='id_" + (jj + 1) + "' labelAlign='top' link='j-chartClick-other;" + dept + ";" + labelValue + "' toolText='[" + labelValue + "]{br}" + (dept != null && !dept.equals("") ? dept : "소속기관명 없음") + "'");
            sb.append(" imageWidth='" + imageSize + "' imageHeight='" + imageSize + "' width='100' height='100' imageNode='1' imageurl='" + image + "' imageAlign='middle' />");
            sb.append("</dataset>");

            dist = dist == true ? false : true;
        }

        sb.append("<connectors color='FF0000' stdThickness='5' strength='1'>");

        for (int ki = 0; ki < list.size(); ki++) {
            String color = "AAAAAA";

            name = list.get(ki).getKorNm();
            dept = StringUtil.XMLEncode(list.get(ki).getDeptKor());

            int cnt = list.get(ki).getCoArtsCo();

            double alpha = (cnt / maxRel) * 0.8 + 0.2;

            sb.append("<connector strength='" + (alpha) + "' ");
            sb.append("from='id_0' ");
            sb.append("label ='" + cnt + "' to='id_" + (ki + 1) + "' alpha='" + (alpha * 100) + "'  link='j-chartClick-" + R2Constant.COAUTHOR_TARGET_OTHER + ";" + dept + ";" + name + "' ");
            sb.append("color='" + color + "' arrowAtStart='0' arrowAtEnd='0' />");
        }
        sb.append("</connectors>");
        sb.append("<styles>");
        sb.append("<definition>");
        sb.append("   <style name='myLabelsFont' type='font' font='Malgun Gothic' bold='1' size='11' color='555555'/>");
        sb.append("</definition>");
        sb.append("<application>");
        sb.append("   <apply toObject='DataLabels' styles='myLabelsFont' />");
        sb.append("</application>");
        sb.append("</styles>");
        sb.append("</chart>");

        return sb.toString();
    }


    /**
     * <pre>
     *  1. 개   요 : Make chart xml for network chart among department
     *  2. 처리내용 :
     * </pre>
     *
     * @param contextPath
     * @return
     * @Method Name : buildNetworkAmongDept
     */
    public static String buildDeptNetworkChartXmlV2(List<AnalysisVo> coAuthorList, AnalysisVo mainDepartment, RimsSearchVo searchVo, String contextPath) {

        double maxTtl = 0;
        double maxCoworkCnt = 0;
        double maxRel = 0;
        int radius = 20;
        dcMap = new HashMap<String, String>();
        int dfFillIdx = 0;
        String fillColor = "";

        for (AnalysisVo coAuthor : coAuthorList) {
            if (maxCoworkCnt < coAuthor.getCoArtsCo()) maxCoworkCnt = coAuthor.getCoArtsCo();
        }

        StringBuffer sb = new StringBuffer();

        sb.append("<chart ")
                .append(" subcaption='' ")
                .append(" baseFontColor='#666666' ")
                .append(" baseFontSize='11' ")
                .append(" subcaptionFontBold='0' ")
                .append(" canvasBgAlpha='0' ")
                .append(" showValues='0' ")
                .append(" paletteColors='" + paletteColors + "' ")
                .append(" bgAlpha='0' ")
                .append(" showBorder='0' ")
                .append(" showShadow='0' ")
                .append(" showAlternateHGridColor='0' ")
                .append(" showCanvasBorder='0' ")
                .append(" showformbtn='0' ")
                .append(" showRestoreBtn='0' ")
                .append(" viewmode='1' ")
                .append(" xAxisMaxValue='100' ")
                .append(" yAxisMinValue='0' ")
                .append(" yAxisMaxValue='100' ")
                .append(" chartTopMargin='3' ")
                .append(" chartLeftMargin='3' ")
                .append(" chartRightMargin='3' ")
                .append(" chartBottomMargin='3' ")
                .append(" xAxisName='' ")
                .append(" showXAxisLine='0' ")
                .append(" xAxisLineThickness='0' ")
                .append(" xAxisLineColor='#cdcdcd' ")
                .append(" xAxisNameFontColor='#8d8d8d' ")
                .append(" yAxisName='' ")
                .append(" yAxisNameFontColor='#8d8d8d' ")
                .append(" canvasBgColor='#ffffff' ")
                .append(" lineThickness='4' ")
                .append(" legendBgColor='#ffffff' ")
                .append(" legendBgAlpha='100' ")
                .append(" legendBorderAlpha='50' ")
                .append(" legendBorderColor='#888888' ")
                .append(" legendShadow='0' ")
                .append(" legendPosition='CENTER' ")
                .append(" divlineAlpha='100' ")
                .append(" numDivLines='10' ")
                .append(" divlineThickness='0' ")
                .append(" toolTipColor='#ffffff' ")
                .append(" toolTipBorderColor='#ffffff' ")
                .append(" toolTipBorderThickness='1' ")
                .append(" toolTipBgColor='#000000' ")
                .append(" toolTipBgAlpha='80' ")
                .append(" toolTipBorderRadius='4' ")
                .append(" toolTipPadding='10' ")
                .append(" toolTipFontSize ='20' ")
                .append(" anchorBgColor='#ffffff' ")
                .append(" anchorRadius='5' ")
                .append(" anchorBorderThickness='3' ")
                .append(" anchorTrackingRadius='15' ")
                .append(" showHoverEffect='1' ")
                .append(" formatNumberScale='0'")
                .append(" labelDisplay='rotate' ")
                .append(" slantLabels='1' ")
                .append(" exportEnabled='1' ")
                .append(" exportAtClient='0' ")
                .append(" exportAction='save' ")
                .append(" exportShowMenuItem='0' ")
                .append(" exportDialogMessage='Building chart output' ")
                .append(" exportHandler='" + contextPath + "/servlet/FCExporter/export.do' exportCallBack='myFN' ")
                .append(" >");


        double step = coAuthorList.size() == 0 ? 0 : 360d / coAuthorList.size();
        if (coAuthorList.size() > 0) maxRel = coAuthorList.get(0).getCoArtsCo();

        double total = Double.parseDouble(mainDepartment.getArtsCo().toString());
        if (maxTtl < total) maxTtl = total;
        radius = (int) ((total / maxTtl) * 30) + 28;
        if (dcMap.get(mainDepartment.getClgNm()) == null) {
            fillColor = fillColors[dfFillIdx];
            dfFillIdx++;
            dcMap.put(mainDepartment.getClgNm(), fillColor);
        }


        sb.append("<dataset seriesName='" + mainDepartment.getDeptKor() + "' plotBorderColor='#" + fillColor + "' plotborderthickness='8' >");
        sb.append("<set x='50' y='50'  name='" + mainDepartment.getDeptKor() + "' radius='" + radius + "' id='id_0' shape='CIRCLE' color='#d4f9ff'/> ");
        sb.append("</dataset>");

        boolean dist = false;
        for (int jj = 0; jj < coAuthorList.size(); jj++) {

            double degree = (450d - step * (jj % 2 == 0 ? jj : coAuthorList.size() - jj - (coAuthorList.size() % 2 == 0 ? 0 : 1))) % 360d;

            double radians = (Math.PI / 180) * degree;

            double x = Math.sin(radians) * 30.0 + 50.0;
            double y = Math.cos(radians) * 30.0 + 50.0;

            String dispValue = StringUtils.replace((String) coAuthorList.get(jj).getDeptKor(), "'", "&#39;");

            if (dcMap.get(coAuthorList.get(jj).getClgNm()) == null) {
                fillColor = fillColors[dfFillIdx];
                dfFillIdx++;
                dcMap.put((String) coAuthorList.get(jj).getClgNm(), fillColor);
            } else {
                fillColor = dcMap.get(coAuthorList.get(jj).getClgNm());
            }
            String deptNm = (String) coAuthorList.get(jj).getDeptKor();

            String imageUrl = contextPath + "/images/icon/node/node_";

            String imageSize = "15";
            if (maxRel >= 3) {
                if (coAuthorList.get(jj).getCoArtsCo() > (maxRel / 3 * 2)) {
                    imageSize = "35";
                } else if (coAuthorList.get(jj).getCoArtsCo() > (maxRel / 3)) {
                    imageSize = "25";
                } else {
                    imageSize = "15";
                }
            }

            String image = imageUrl + fillColor + ".png";

            sb.append("<dataset seriesName='" + dispValue + "' showPlotBorder='0' plotBorderAlpha='0' allowDrag='1' showformbtn='0' plotFillAlpha='0' >");
            sb.append("<set x='" + x + "' y='" + y + "'");
            sb.append(" name='" + dispValue + "' id='id_" + (jj + 1) + "' toolText='" + deptNm + "' ");
            sb.append(" imageWidth='" + imageSize + "' imageHeight='" + imageSize + "' width='100' height='100' imageNode='1' imageurl='" + image + "' imageAlign='middle' ");
            sb.append(" labelAlign='top' link='j-chartClick-other;" + deptNm + "' />");
            sb.append("</dataset>");

            dist = dist == true ? false : true;
        }

        sb.append("<connectors color='#AAAAAA' stdThickness='5'>");

        for (int ki = 0; ki < coAuthorList.size(); ki++) {
            int cnt = Integer.parseInt(coAuthorList.get(ki).getCoArtsCo().toString());
            String deptNm = (String) coAuthorList.get(ki).getDeptKor();
            double alpha = (cnt / maxRel) * 0.8 + 0.2;

            sb.append("<connector strength='" + (alpha) + "' ");
            sb.append(" label ='" + cnt + "'  ");
            sb.append(" from='id_0' to='id_" + (ki + 1) + "' ");
            sb.append(" link='j-chartClick-" + R2Constant.COAUTHOR_TARGET_INST + ";" + deptNm + "' ");
            sb.append(" arrowAtStart='0' arrowAtEnd='0' />");
        }

        sb.append("</connectors>");

        sb.append("<styles>");
        sb.append("<definition>");
        sb.append("   <style name='myLabelsFont' type='font' font='Malgun Gothic' bold='0' size='11' color='000000'/>");
        sb.append("</definition>");
        sb.append("<application>");
        sb.append("   <apply toObject='DataLabels' styles='myLabelsFont' />");
        sb.append("</application>");
        sb.append("</styles>");

        sb.append("</chart>");

        return sb.toString();


    }


    public static String buildNetworkAmongOtherV2(List<AnalysisVo> coAuthorList, AnalysisVo
            mainDepartment, RimsSearchVo searchVo, String contextPath, String instAbrv) {

        double maxTtl = 0;
        double maxCoworkCnt = 0;
        double maxRel = 0;
        int radius = 20;
        dcMap = new HashMap<String, String>();
        int dfFillIdx = 0;
        String fillColor = "";

        for (AnalysisVo coAuthor : coAuthorList) {
            if (maxCoworkCnt < coAuthor.getCoArtsCo()) maxCoworkCnt = coAuthor.getCoArtsCo();
        }

        StringBuffer sb = new StringBuffer();

        sb.append("<chart ")
                .append(" caption='' ")
                .append(" subcaption='' ")
                .append(" baseFontColor='#666666' ")
                .append(" baseFontSize='11' ")
                .append(" subcaptionFontBold='0' ")
                .append(" canvasBgAlpha='0' ")
                .append(" showValues='0' ")
                .append(" paletteColors='" + paletteColors + "' ")
                .append(" bgAlpha='0' ")
                .append(" showBorder='0' ")
                .append(" showShadow='0' ")
                .append(" showAlternateHGridColor='0' ")
                .append(" showCanvasBorder='0' ")
                .append(" showformbtn='0' ")
                .append(" showRestoreBtn='0' ")
                .append(" viewmode='1' ")
                .append(" xAxisMaxValue='100' ")
                .append(" yAxisMinValue='0' ")
                .append(" yAxisMaxValue='100' ")
                .append(" chartTopMargin='3' ")
                .append(" chartLeftMargin='3' ")
                .append(" chartRightMargin='3' ")
                .append(" chartBottomMargin='3' ")
                .append(" xAxisName='' ")
                .append(" showXAxisLine='0' ")
                .append(" xAxisLineThickness='1' ")
                .append(" xAxisLineColor='#cdcdcd' ")
                .append(" xAxisNameFontColor='#8d8d8d' ")
                .append(" yAxisName='' ")
                .append(" yAxisNameFontColor='#8d8d8d' ")
                .append(" canvasBgColor='#ffffff' ")
                .append(" lineThickness='4' ")
                .append(" legendBgColor='#ffffff' ")
                .append(" legendBgAlpha='100' ")
                .append(" legendBorderAlpha='50' ")
                .append(" legendBorderColor='#888888' ")
                .append(" legendShadow='0' ")
                .append(" legendPosition='CENTER' ")
                .append(" divlineAlpha='100' ")
                .append(" numDivLines='10' ")
                .append(" divlineThickness='0' ")
                .append(" toolTipColor='#ffffff' ")
                .append(" toolTipBorderColor='#ffffff' ")
                .append(" toolTipBorderThickness='1' ")
                .append(" toolTipBgColor='#000000' ")
                .append(" toolTipBgAlpha='80' ")
                .append(" toolTipBorderRadius='4' ")
                .append(" toolTipPadding='10' ")
                .append(" toolTipFontSize ='20' ")
                .append(" anchorBgColor='#ffffff' ")
                .append(" anchorRadius='5' ")
                .append(" anchorBorderThickness='3' ")
                .append(" anchorTrackingRadius='15' ")
                .append(" showHoverEffect='1' ")
                .append(" formatNumberScale='0'")
                .append(" labelDisplay='rotate' ")
                .append(" slantLabels='1' ")
                .append(" exportEnabled='1' ")
                .append(" exportAtClient='0' ")
                .append(" exportAction='save' ")
                .append(" exportShowMenuItem='0' ")
                .append(" exportDialogMessage='Building chart output' ")
                .append(" exportHandler='" + contextPath + "/servlet/FCExporter/export.do' exportCallBack='myFN' ")
                .append(" >");

        if (mainDepartment == null) {
            return sb.toString();
        }

        double step = coAuthorList.size() == 0 ? 0 : 360d / coAuthorList.size();
        if (coAuthorList.size() > 0) maxRel = coAuthorList.get(0).getCoArtsCo();

        double total = Double.parseDouble(mainDepartment.getArtsCo().toString());
        if (maxTtl < total) maxTtl = total;

        radius = (int) ((total / maxTtl) * 30) + 28;

        if (dcMap.get(mainDepartment.getDeptKor()) == null) {
            fillColor = fillColors[dfFillIdx];
            dfFillIdx++;
            dcMap.put(mainDepartment.getDeptKor(), fillColor);
        }

        String displayValue = StringUtil.XMLEncode(mainDepartment.getDeptKor());
        String tooltip = displayValue;
        if ("other".equals(searchVo.getCoauthorTarget())) {
            tooltip = instAbrv + "{br}" + tooltip + "";
            displayValue = instAbrv + "{br}" + displayValue + "";
        }

        sb.append("<dataset seriesName='" + mainDepartment.getDeptKor() + "'  plotBorderColor='#" + fillColor + "' plotborderthickness='8'  >");
        sb.append("<set x='50' y='50' name='" + displayValue + "' radius='" + radius + "' id='id_0' shape='CIRCLE' color='#d4f9ff' toolText='" + tooltip + "'/> ");
        sb.append("</dataset>");

        boolean dist = false;
        for (int jj = 0; jj < coAuthorList.size(); jj++) {

            double degree = (450d - step * (jj % 2 == 0 ? jj : coAuthorList.size() - jj - (coAuthorList.size() % 2 == 0 ? 0 : 1))) % 360d;

            double radians = (Math.PI / 180) * degree;

            double x = Math.sin(radians) * 30.0 + 50.0;
            double y = Math.cos(radians) * 30.0 + 50.0;

            String dispValue = StringUtil.XMLEncode(StringUtils.replace((String) coAuthorList.get(jj).getDeptKor(), "'", "&#39;"));

            if (dcMap.get(coAuthorList.get(jj).getDeptKor()) == null) {
                fillColor = fillColors[dfFillIdx];
                dfFillIdx++;
                dcMap.put((String) coAuthorList.get(jj).getDeptKor(), fillColor);
            }

            String imageUrl = contextPath + "/images/icon/node/node_";

            String imageSize = "15";
            if (maxRel >= 3) {
                if (coAuthorList.get(jj).getCoArtsCo() > (maxRel / 3 * 2)) {
                    imageSize = "35";
                } else if (coAuthorList.get(jj).getCoArtsCo() > (maxRel / 3)) {
                    imageSize = "25";
                } else {
                    imageSize = "15";
                }
            }

            String image = imageUrl + fillColor + ".png";

            String deptNm = StringUtil.XMLEncode(coAuthorList.get(jj).getDeptKor());

            sb.append("<dataset seriesName='" + dispValue + "' showPlotBorder='0' plotBorderAlpha='0' allowDrag='1' showformbtn='0' plotFillAlpha='0' >");
            sb.append("<set x='" + x + "' y='" + y + "'");
            sb.append(" name='" + dispValue + "' id='id_" + (jj + 1) + "' toolText='" + deptNm + "' ");
            sb.append(" imageWidth='" + imageSize + "' imageHeight='" + imageSize + "' width='100' height='100' imageNode='1' imageurl='" + image + "' imageAlign='middle' ");
            sb.append(" labelAlign='top' link='j-chartClick-other;" + deptNm + "' />");
            sb.append("</dataset>");

            dist = dist == true ? false : true;
        }

        sb.append("<connectors color='#AAAAAA' stdThickness='5'>");

        for (int ki = 0; ki < coAuthorList.size(); ki++) {
            String color = "AAAAAA";
            String deptNm = StringUtil.XMLEncode(coAuthorList.get(ki).getDeptKor());
            int cnt = Integer.parseInt(coAuthorList.get(ki).getCoArtsCo().toString());

            double alpha = (cnt / maxRel) * 0.8 + 0.2;

            sb.append("<connector strength='" + (alpha) + "' ");
            sb.append(" label ='" + cnt + "' ");
            sb.append(" from='id_0' to='id_" + (ki + 1) + "' ");
            sb.append(" arrowAtStart='0' arrowAtEnd='0' ");
            sb.append(" link='j-chartClick-other;" + deptNm + "' ");
            sb.append(" />");
        }

        sb.append("</connectors>");

        sb.append("<styles>");
        sb.append("<definition>");
        sb.append("   <style name='myLabelsFont' type='font' font='Malgun Gothic' bold='0' size='11' color='000000'/>");
        sb.append("</definition>");
        sb.append("<application>");
        sb.append("   <apply toObject='DataLabels' styles='myLabelsFont' />");
        sb.append("</application>");
        sb.append("</styles>");

        sb.append("</chart>");

        return sb.toString();

    }

}
