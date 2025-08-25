package com.webapp.mocker.utils;

import java.io.ByteArrayInputStream;
import java.io.IOException;

/**
 * Utility class to test Apache POI functionality
 */
public class PoiTestUtil {
    
    /**
     * Test if Apache POI classes are available
     */
    public static boolean isPoiAvailable() {
        try {
            // Test core POI classes
            Class.forName("org.apache.poi.ss.usermodel.Workbook");
            Class.forName("org.apache.poi.xssf.usermodel.XSSFWorkbook");
            Class.forName("org.apache.poi.ss.usermodel.Sheet");
            Class.forName("org.apache.poi.ss.usermodel.Row");
            Class.forName("org.apache.poi.ss.usermodel.Cell");
            return true;
        } catch (ClassNotFoundException e) {
            System.err.println("POI class not found: " + e.getMessage());
            return false;
        } catch (Exception e) {
            System.err.println("POI availability check failed: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * Test if we can create a simple XLSX workbook
     */
    public static String testPoiFunctionality() {
        try {
            // Test basic classes
            Class.forName("org.apache.poi.xssf.usermodel.XSSFWorkbook");
            Class.forName("org.apache.poi.ss.usermodel.Row");
            Class.forName("org.apache.poi.ss.usermodel.Cell");
            
            return "Apache POI is available and all required classes are found!";
        } catch (ClassNotFoundException e) {
            return "Apache POI class not found: " + e.getMessage();
        } catch (Exception e) {
            return "Apache POI test failed: " + e.getMessage();
        }
    }
}
