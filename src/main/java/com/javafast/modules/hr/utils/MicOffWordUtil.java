package com.javafast.modules.hr.utils;

import groovy.io.FileType;
import org.apache.poi.POIXMLDocument;
import org.apache.poi.POIXMLTextExtractor;
import org.apache.poi.hwpf.HWPFDocument;
import org.apache.poi.hwpf.extractor.WordExtractor;
import org.apache.poi.hwpf.usermodel.Range;
import org.apache.poi.openxml4j.opc.OPCPackage;
import org.apache.poi.xwpf.extractor.XWPFWordExtractor;

import java.io.*;

public class MicOffWordUtil {
    /**
     * 根据word文件路径获取文件内的内容
     *
     * @param filePath
     * @return 如果解析失败则返回null
     */
    @SuppressWarnings("resource")
    public static String getContent(String filePath) {
        // 路径必传
        if (null == filePath || filePath.replaceAll(" ", "").length() == 0) {
            return null;
        }

        try {
            //这种识别方法能识别将doc改名为zip等的文件
            String fileType = FileTypeUtil.getFileType(filePath);
            // 判断是否是2003格式的word
            if (fileType.equals("doc")) {
                File f = new File(filePath);
                // 1.获取文件头
                FileInputStream is = new FileInputStream(f);
                HWPFDocument doc = new HWPFDocument(is);
                FileInputStream fis = new FileInputStream(f);
                String doc1 = doc.getDocumentText();
                System.out.println(doc1);
                StringBuilder doc2 = doc.getText();
                return doc2.toString();
            }else if(fileType.equals("docx")){
                OPCPackage op = POIXMLDocument.openPackage(filePath);
                POIXMLTextExtractor pte = new XWPFWordExtractor(op);
                String text2007 = pte.getText();
                return text2007;
                /**
                 *  FileInputStream fis = new FileInputStream(file);
                 *             XWPFDocument xdoc = new XWPFDocument(fis);
                 *             XWPFWordExtractor extractor = new XWPFWordExtractor(xdoc);
                 *             String doc1 = extractor.getText();
                 *             System.out.println(doc1);
                 */
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "";

    }
}