package kr.co.argonet.r2rims.mail;

import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeUtility;

import org.apache.commons.lang3.StringUtils;
import org.junit.Test;

import kr.co.argonet.r2rims.core.mail.MailAuthenticator;

/**
 * <pre>
 *  kr.co.argonet.r2rims.mail
 *      ┗ SendMailTest.java
 *
 * </pre>
 *
 * @author : hojkim
 * @date 2017-08-04
 */
public class SendMailTest{

    @Test
    public void sendMail(){

        try {

            Properties props = new Properties();

            props.put("mail.smtp.host", "mail.kaist.ac.kr");
            props.put("mail.smtp.port", "465");
            props.put("mail.smtp.starttls.enable","true");
            props.put("mail.smtp.socketFactory.port", "465");
            props.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
            props.put("mail.smtp.auth", "true");
            String username = "rims";
            String password = "main1234";
            MailAuthenticator auth = new MailAuthenticator(username, password);
            Session mailSession = Session.getDefaultInstance(props, auth);
            Message msg = new MimeMessage(mailSession);

            String fromMailAddress = "학술정보개발팀;rims@kaist.ac.kr";
            msg.setFrom(new InternetAddress(fromMailAddress.split(";")[1],fromMailAddress.split(";")[0]));

            String toMailAddress = "김호진|hojkim75@kaist.ac.kr;이효재|hughlee193@kaist.ac.kr;";
            toMailAddress = StringUtils.stripEnd(toMailAddress,";");
            List<InternetAddress> toMailList = new ArrayList<InternetAddress>();
            for(String toMail : toMailAddress.split(";"))
            {
                toMailList.add(new InternetAddress(toMail.split("\\|")[1], toMail.split("\\|")[0]));
            }

            InternetAddress[] address = null;
            if(toMailList.size() > 0)
            {
                address = new InternetAddress[toMailList.size()];
                address = toMailList.toArray(address);
            }

            msg.setRecipients(Message.RecipientType.TO, address);//받는 사람설정
            msg.setSubject("send mail test");// 제목 설정
            msg.setSentDate(new java.util.Date());// 보내는 날짜 설정
            msg.setContent("This is mail test contents.","text/html;charset=utf-8"); // 내영 설정 (HTML 형식)

            Transport.send(msg); // 메일 보내기

        } catch ( MessagingException ex ) {
            ex.printStackTrace();
        } catch ( Exception e ) {
            e.printStackTrace();
        }
    }

    @Test
    public void internetAddressTest() throws Exception{
        //InternetAddress[] address = {new InternetAddress("hojkim@argonet.co.kr,hughlee193@kaist.ac.kr")};
        String address = StringUtils.stripEnd("kimhojin <hojkim@argonet.co.kr>,leehuhjae <hughlee193@kaist.ac.kr>,",",");
        for(InternetAddress ia : InternetAddress.parse(MimeUtility.encodeText(address),true))
            System.out.println(ia.toString());
    }
}
