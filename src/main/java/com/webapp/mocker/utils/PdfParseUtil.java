package com.webapp.mocker.utils;

import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;

import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.text.PDFTextStripper;

import org.springframework.web.multipart.MultipartFile;

/**
 * Parses a PDF where each question row is a single line with 7 pipe-separated columns:
 * Question | Option A | Option B | Option C | Option D | Correct Option (A/B/C/D) | Explanation
 */
public class PdfParseUtil {

    public static List<String[]> parsePipeSeparatedRows(MultipartFile file) throws IOException {
        List<String[]> rows = new ArrayList<>();
        try (InputStream in = file.getInputStream(); PDDocument document = PDDocument.load(in)) {
            PDFTextStripper stripper = new PDFTextStripper();
            // Preserve order; process whole document text
            String text = stripper.getText(document);
            String[] lines = text.split("\r?\n");
            for (int i = 0; i < lines.length; i++) {
                String line = lines[i].trim();
                if (line.isEmpty()) continue;
                // Skip a header line if present (detect by keywords)
                if (i == 0 && line.toLowerCase().contains("question") && line.contains("|")) {
                    continue;
                }
                String[] parts = line.split("\\|");
                // Normalize to 7 columns
                if (parts.length >= 7) {
                    String[] cols = new String[7];
                    for (int c = 0; c < 7; c++) {
                        cols[c] = parts[c] == null ? null : parts[c].trim();
                    }
                    // Ensure required columns exist
                    if (cols[0] != null && !cols[0].isBlank() &&
                        cols[1] != null && cols[2] != null && cols[3] != null && cols[4] != null && cols[5] != null) {
                        rows.add(cols);
                    }
                }
            }
        }
        return rows;
    }
}


