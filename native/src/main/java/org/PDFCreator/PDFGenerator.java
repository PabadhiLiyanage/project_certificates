package org.PDFCreator;

import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.font.PDType1Font;
import org.apache.pdfbox.pdmodel.font.PDType0Font;
import org.apache.pdfbox.pdmodel.PDPage;
import org.apache.pdfbox.pdmodel.PDPageContentStream;
import java.io.File;
import java.io.IOException;


public class PDFGenerator {
    public static void pdf(String inputFilePath, String replacement, String font_type, int fontSize, int centerX,int centerY,String fontFilePath, String outputFileName) {
        String outputDirectory = "outputs/";
        File inputFile = new File(inputFilePath);
        File outputDir = new File(outputDirectory);
        float nameHeight = 0;
        float nameWidth = 0;
        if (!outputDir.exists()) {
            outputDir.mkdirs();
        }
        String outputFilePath = outputDirectory + outputFileName;
        try (PDDocument pdfDocument = PDDocument.load(inputFile)) {
            PDPage page = pdfDocument.getPage(0);
            float centerXF = centerX < 0 ? (float) (page.getMediaBox().getWidth() / 2.0) : centerX;
            if ("CUSTOM".equals(font_type)) {
                File fontFile=new File(fontFilePath);
                PDType0Font font = PDType0Font.load(pdfDocument,fontFile);
                PDPageContentStream contentStream = new PDPageContentStream(pdfDocument, page,
                        PDPageContentStream.AppendMode.APPEND, true, true);
                contentStream.setFont(font, fontSize);
                nameWidth = font.getStringWidth(replacement) / 1000 * fontSize;
                nameHeight = (font.getFontDescriptor().getCapHeight()) / 1000 * fontSize;
                float posY = centerY + nameHeight + 7.5f;
                float posX = centerXF - (nameWidth / 2.0f);
                contentStream.beginText();
                contentStream.newLineAtOffset(posX, posY);
                contentStream.showText(replacement);
                contentStream.endText();
                contentStream.close();
            } else {
                PDType1Font font = getFontByName.getFontByName(font_type);
                PDPageContentStream contentStream = new PDPageContentStream(pdfDocument, page,
                        PDPageContentStream.AppendMode.APPEND, true, true);
                contentStream.setFont(font, fontSize);
                nameWidth = font.getStringWidth(replacement) / 1000 * fontSize;
                nameHeight = (font.getFontDescriptor().getCapHeight()) / 1000 * fontSize;
                float posY = centerY + nameHeight + 7.5f;
                float posX = centerXF - (nameWidth / 2.0f);
                contentStream.beginText();
                contentStream.newLineAtOffset(posX, posY);
                contentStream.showText(replacement);
                contentStream.endText();
                contentStream.close();
            }
            pdfDocument.save(outputFilePath);
            System.out.println("Name written successfully. Modified PDF saved to: " + outputFilePath);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}