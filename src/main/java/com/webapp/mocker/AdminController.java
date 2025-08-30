package com.webapp.mocker;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.webapp.mocker.models.AnswerOption;
import com.webapp.mocker.models.AnswerOptionRepository;
import com.webapp.mocker.models.MockTest;
import com.webapp.mocker.models.MockTestRepository;
import com.webapp.mocker.models.Question;
import com.webapp.mocker.models.QuestionRepository;
import com.webapp.mocker.models.Topic;
import com.webapp.mocker.models.TopicRepository;
import com.webapp.mocker.utils.PdfParseUtil;
import com.webapp.mocker.utils.PoiTestUtil;

import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/admin")
public class AdminController {

    @Autowired private TopicRepository topicRepository;
    @Autowired private MockTestRepository mockTestRepository;
    @Autowired private QuestionRepository questionRepository;
    @Autowired private AnswerOptionRepository answerOptionRepository;

    @GetMapping("/login")
    public String loginPage() { return "admin-login-new"; }

    @PostMapping("/login")
    public String doLogin(@RequestParam String username, @RequestParam String password, HttpSession session, Model model) {
        if ("admins".equalsIgnoreCase(username) && "admins".equals(password)) {
            session.setAttribute("isAdmin", true);
            return "redirect:/admin/dashboard";
        }
        model.addAttribute("error", "Invalid credentials");
        return "admin-login-new";
    }

    @GetMapping("/dashboard")
    public String dashboard(HttpSession session, Model model) {
        if (!Boolean.TRUE.equals(session.getAttribute("isAdmin"))) return "redirect:/admin/login";
        
        // Real-time statistics from database
        long totalTests = mockTestRepository.count();
        long activeTopics = topicRepository.count();
        long totalQuestions = questionRepository.count();
        long totalAnswerOptions = answerOptionRepository.count();
        
        // Calculate student attempts (simplified - in real app this would come from user test attempts)
        long studentAttempts = totalTests * 15; // Mock calculation
        
        // Debug logging
        System.out.println("=== DASHBOARD STATISTICS ===");
        System.out.println("Total Tests: " + totalTests);
        System.out.println("Active Topics: " + activeTopics);
        System.out.println("Total Questions: " + totalQuestions);
        System.out.println("Total Answer Options: " + totalAnswerOptions);
        System.out.println("Student Attempts: " + studentAttempts);
        
        model.addAttribute("topics", topicRepository.findAll());
        model.addAttribute("totalTests", totalTests);
        model.addAttribute("activeTopics", activeTopics);
        model.addAttribute("studentAttempts", studentAttempts);
        model.addAttribute("totalQuestions", totalQuestions);
        model.addAttribute("totalAnswerOptions", totalAnswerOptions);
        
        // Recent activity - get latest tests and topics
        List<MockTest> allTests = mockTestRepository.findAll();
        List<Topic> allTopics = topicRepository.findAll();
        
        // Get the 5 most recent tests
        List<MockTest> recentTests = allTests.stream()
            .sorted((t1, t2) -> Long.compare(t2.getId(), t1.getId()))
            .limit(5)
            .toList();
            
        // Get the 3 most recent topics
        List<Topic> recentTopics = allTopics.stream()
            .sorted((t1, t2) -> Long.compare(t2.getId(), t1.getId()))
            .limit(3)
            .toList();
        
        System.out.println("Recent Tests Count: " + recentTests.size());
        System.out.println("Recent Topics Count: " + recentTopics.size());
        
        model.addAttribute("recentTests", recentTests);
        model.addAttribute("recentTopics", recentTopics);
        
        return "admin-dashboard";
    }
    
    @GetMapping("/test-poi")
    public String testPoi(Model model) {
        String result = PoiTestUtil.testPoiFunctionality();
        if (result.contains("available")) {
            model.addAttribute("message", result);
        } else {
            model.addAttribute("error", result);
        }
        return "admin-dashboard";
    }

    @PostMapping("/create-topic")
    public String createTopic(
        @RequestParam String topicName,
        @RequestParam(required = false) String topicDescription,
        @RequestParam(required = false) Integer freeUnlockedTests,
        @RequestParam(required = false) Integer silverUnlockedTests,
        @RequestParam(required = false) Integer goldUnlockedTests,
        @RequestParam(required = false) Integer platinumUnlockedTests,
        HttpSession session,
        Model model
    ) {
        if (!Boolean.TRUE.equals(session.getAttribute("isAdmin"))) return "redirect:/admin/login";
        try {
            if (!StringUtils.hasText(topicName)) throw new IllegalArgumentException("Topic name is required");
            Topic topic = new Topic();
            topic.setName(topicName.trim());
            topic.setSubject("Physical Education");
            topic.setDescription(StringUtils.hasText(topicDescription) ? topicDescription.trim() : topicName.trim());
            if (freeUnlockedTests != null) topic.setFreeUnlockedTests(freeUnlockedTests);
            if (silverUnlockedTests != null) topic.setSilverUnlockedTests(silverUnlockedTests);
            if (goldUnlockedTests != null) topic.setGoldUnlockedTests(goldUnlockedTests);
            if (platinumUnlockedTests != null) topic.setPlatinumUnlockedTests(platinumUnlockedTests);
            topicRepository.save(topic);
        } catch (Exception e) {
            // Optionally could add flash message; keep simple with redirect
            System.out.println("Create topic error: " + e.getMessage());
        }
        return "redirect:/admin/dashboard";
    }
    
    @GetMapping("/debug-classpath")
    public String debugClasspath(Model model) {
        StringBuilder sb = new StringBuilder();
        sb.append("Classpath check for Apache POI:\n\n");
        
        // Check core POI classes
        String[] poiClasses = {
            "org.apache.poi.ss.usermodel.Workbook",
            "org.apache.poi.xssf.usermodel.XSSFWorkbook", 
            "org.apache.poi.ss.usermodel.Sheet",
            "org.apache.poi.ss.usermodel.Row",
            "org.apache.poi.ss.usermodel.Cell"
        };
        
        for (String className : poiClasses) {
            try {
                Class.forName(className);
                sb.append("✓ ").append(className).append(" found\n");
            } catch (ClassNotFoundException e) {
                sb.append("✗ ").append(className).append(" NOT found\n");
            }
        }
        
        sb.append("\nPoiTestUtil result: ").append(PoiTestUtil.testPoiFunctionality());
        
        model.addAttribute("message", sb.toString());
        return "admin-dashboard";
    }

    @GetMapping("/view-test")
    public String viewTest(@RequestParam Long testId, HttpSession session, Model model) {
        if (!Boolean.TRUE.equals(session.getAttribute("isAdmin"))) return "redirect:/admin/login";
        
        try {
            MockTest mockTest = mockTestRepository.findById(testId).orElse(null);
            if (mockTest == null) {
                model.addAttribute("error", "Test not found with ID: " + testId);
                model.addAttribute("topics", topicRepository.findAll());
                return "admin-dashboard";
            }
            
            List<Question> questions = questionRepository.findByMockTestIdOrderByOrderIndexAsc(testId);
            List<QuestionWithAnswers> questionsWithAnswers = new ArrayList<>();
            
            for (Question question : questions) {
                List<AnswerOption> answerOptions = answerOptionRepository.findByQuestionIdOrderByOrderIndexAsc(question.getId());
                questionsWithAnswers.add(new QuestionWithAnswers(question, answerOptions));
            }
            
            model.addAttribute("mockTest", mockTest);
            model.addAttribute("questionsWithAnswers", questionsWithAnswers);
            return "view-test";
            
        } catch (Exception e) {
            model.addAttribute("error", "Error loading test: " + e.getMessage());
            model.addAttribute("topics", topicRepository.findAll());
            return "admin-dashboard";
        }
    }

    @PostMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/admin/login";
    }

    @GetMapping("/sample-pdf")
    public void downloadSamplePdf(HttpServletResponse response) throws IOException {
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=sample_template.pdf");
        // Generate a simple PDF using PDFBox to demonstrate the required format
        org.apache.pdfbox.pdmodel.PDDocument doc = new org.apache.pdfbox.pdmodel.PDDocument();
        org.apache.pdfbox.pdmodel.PDPage page = new org.apache.pdfbox.pdmodel.PDPage();
        doc.addPage(page);
        try (org.apache.pdfbox.pdmodel.PDPageContentStream content = new org.apache.pdfbox.pdmodel.PDPageContentStream(doc, page)) {
            content.beginText();
            content.setFont(org.apache.pdfbox.pdmodel.font.PDType1Font.HELVETICA, 12);
            content.newLineAtOffset(50, 750);
            String[] lines = new String[] {
                "Question | Option A | Option B | Option C | Option D | Correct Option | Explanation",
                "What is the capital of France? | Paris | London | Berlin | Madrid | A | Paris is the capital and largest city of France.",
                "Which planet is closest to the Sun? | Mercury | Venus | Earth | Mars | A | Mercury is the first planet from the Sun.",
                "What is 2 + 2? | 3 | 4 | 5 | 6 | B | Basic arithmetic: 2 + 2 = 4."
            };
            float leading = 16f;
            for (int i = 0; i < lines.length; i++) {
                if (i > 0) content.newLineAtOffset(0, -leading);
                content.showText(lines[i]);
            }
            content.endText();
        }
        doc.save(response.getOutputStream());
        doc.close();
    }

    @PostMapping("/upload")
    public String upload(
        @RequestParam(required = false) Long topicId,
        @RequestParam(required = false) String newTopic,
        @RequestParam(required = false) Integer freeUnlockedTests,
        @RequestParam(required = false) Integer silverUnlockedTests,
        @RequestParam(required = false) Integer goldUnlockedTests,
        @RequestParam(required = false) Integer platinumUnlockedTests,
        @RequestParam String testName,
        @RequestParam(required = false) String testDescription,
        @RequestParam Integer numberOfQuestions,
        @RequestParam Integer durationMinutes,
        @RequestParam(required = false) String testTheory,
        @RequestParam("file") MultipartFile file,
        HttpSession session,
        Model model
    ) {
        if (!Boolean.TRUE.equals(session.getAttribute("isAdmin"))) return "redirect:/admin/login";
        try {
            Topic topic;
            if (topicId != null && (newTopic == null || newTopic.isBlank())) {
                topic = topicRepository.findById(topicId).orElse(null);
                if (topic == null) throw new IllegalArgumentException("Topic not found");
            } else {
                if (!StringUtils.hasText(newTopic)) throw new IllegalArgumentException("New topic name required");
                topic = new Topic();
                topic.setName(newTopic);
                topic.setSubject("Physical Education");
                topic.setDescription(newTopic);
                        // Save per-package unlock configuration if provided
        if (freeUnlockedTests != null) topic.setFreeUnlockedTests(freeUnlockedTests);
        if (silverUnlockedTests != null) topic.setSilverUnlockedTests(silverUnlockedTests);
        if (goldUnlockedTests != null) topic.setGoldUnlockedTests(goldUnlockedTests);
        if (platinumUnlockedTests != null) topic.setPlatinumUnlockedTests(platinumUnlockedTests);
                topic = topicRepository.save(topic);
            }

            MockTest mt = new MockTest();
            mt.setTopic(topic);
            mt.setName(testName);
            mt.setDescription(testDescription != null && !testDescription.trim().isEmpty() ? testDescription.trim() : testName);
            // Determine next test number under this topic
            List<MockTest> existing = mockTestRepository.findByTopicIdOrderByTestNumberAsc(topic.getId());
            int nextNumber = existing.isEmpty() ? 1 : existing.get(existing.size() - 1).getTestNumber() + 1;
            mt.setTestNumber(nextNumber);
            
            // Generate new ID structure: topicId + testNumber (e.g., 11, 12, 13 for topic 1)
            Long newId = Long.parseLong(topic.getId().toString() + nextNumber);
            mt.setId(newId);
            
            mt.setDurationMinutes(durationMinutes);
            // Set test theory if provided
            if (testTheory != null && !testTheory.trim().isEmpty()) {
                mt.setTheoryText(testTheory.trim());
            }
            // numberOfQuestions set after parsing rows (source of truth)
            mt.setCompletionPercent(0);
            mt = mockTestRepository.save(mt);

            List<String[]> rows = new ArrayList<>();
            String filename = file.getOriginalFilename() != null ? file.getOriginalFilename().toLowerCase() : "";
            
            if (filename.isEmpty()) {
                throw new IllegalArgumentException("No file selected");
            }
            
            if (!filename.endsWith(".xlsx") && !filename.endsWith(".csv") && !filename.endsWith(".pdf")) {
                throw new IllegalArgumentException("Only .xlsx, .csv and .pdf files are supported");
            }
            
            if (filename.endsWith(".xlsx")) {
                System.out.println("Processing XLSX file: " + filename);
                System.out.println("File size: " + file.getSize() + " bytes");
                
                // First, test if the classes are available
                if (!PoiTestUtil.isPoiAvailable()) {
                    System.out.println("Apache POI classes NOT found in classpath");
                    throw new RuntimeException("Apache POI classes not available in classpath. Please ensure the application has been rebuilt with Apache POI dependencies.");
                }
                System.out.println("Apache POI classes are available");
                
                try {
                    System.out.println("Attempting to create XSSFWorkbook...");
                    XSSFWorkbook workbook = new XSSFWorkbook(file.getInputStream());
                    System.out.println("XSSFWorkbook created successfully");
                    XSSFSheet sheet = workbook.getSheetAt(0);
                    if (sheet == null) {
                        throw new IllegalArgumentException("No sheet found in XLSX file");
                    }
                    
                    int rowCount = 0;
                    for (Row row : sheet) {
                        if (row.getRowNum() == 0) continue; // skip header
                        String[] cols = new String[7];
                        for (int i = 0; i < 7; i++) {
                            Cell c = row.getCell(i);
                            cols[i] = c == null ? null : c.toString().trim();
                        }
                        // Require at least Question and 4 options
                        if (cols[0] != null && !cols[0].isBlank()) {
                            // Validate that we have all required columns
                            if (cols.length < 7 || cols[1] == null || cols[2] == null || cols[3] == null || cols[4] == null || cols[5] == null) {
                                throw new IllegalArgumentException("Row " + (row.getRowNum() + 1) + " is missing required columns. Each row must have: Question, Option A, Option B, Option C, Option D, Correct Option, Explanation");
                            }
                            rows.add(cols);
                            rowCount++;
                        }
                    }
                    
                    if (rowCount == 0) {
                        throw new IllegalArgumentException("No valid question rows found in XLSX file. Please ensure the file has data starting from row 2.");
                    }
                    
                    workbook.close();
                    System.out.println("XLSX processing completed successfully");
                    
                } catch (NoClassDefFoundError e) {
                    // Clean up the placeholder test if POI not available
                    System.out.println("NoClassDefFoundError: " + e.getMessage());
                    e.printStackTrace();
                    mockTestRepository.deleteById(mt.getId());
                    model.addAttribute("error", "XLSX support not available. Please rebuild the app (clean package) to load Apache POI, or upload a CSV instead.");
                    model.addAttribute("topics", topicRepository.findAll());
                    return "admin-dashboard";
                } catch (Exception e) {
                    // Clean up the placeholder test on any XLSX parsing error
                    System.out.println("XLSX parsing error: " + e.getMessage());
                    e.printStackTrace();
                    // Clean up the placeholder test on any XLSX parsing error
                    mockTestRepository.deleteById(mt.getId());
                    model.addAttribute("error", "Error parsing XLSX file: " + e.getMessage() + ". Please ensure the file has the correct format with 7 columns: Question, Option A, Option B, Option C, Option D, Correct Option, Explanation");
                    model.addAttribute("topics", topicRepository.findAll());
                    return "admin-dashboard";
                }
            } else if (filename.endsWith(".pdf")) {
                System.out.println("Processing PDF file: " + filename);
                try {
                    List<String[]> pdfRows = PdfParseUtil.parsePipeSeparatedRows(file);
                    if (pdfRows.isEmpty()) {
                        throw new IllegalArgumentException("No valid question rows found in PDF. Each line must have 7 '|' separated columns.");
                    }
                    rows.addAll(pdfRows);
                } catch (Exception e) {
                    System.out.println("PDF parsing error: " + e.getMessage());
                    e.printStackTrace();
                    mockTestRepository.deleteById(mt.getId());
                    model.addAttribute("error", "Error parsing PDF file: " + e.getMessage() + ". Ensure each line has: Question | Option A | Option B | Option C | Option D | Correct Option | Explanation");
                    model.addAttribute("topics", topicRepository.findAll());
                    return "admin-dashboard";
                }
            } else { // CSV
                System.out.println("Processing CSV file: " + filename);
                try (BufferedReader br = new BufferedReader(new InputStreamReader(file.getInputStream(), StandardCharsets.UTF_8))) {
                    String line; boolean header = true;
                    while ((line = br.readLine()) != null) {
                        if (header) { header = false; continue; }
                        String[] cols = line.split(",");
                        for (int i = 0; i < cols.length; i++) cols[i] = cols[i].trim();
                        if (cols.length >= 7 && !cols[0].isBlank()) {
                            // Validate that we have all required columns
                            if (cols[1] == null || cols[2] == null || cols[3] == null || cols[4] == null || cols[5] == null) {
                                throw new IllegalArgumentException("Row has missing required columns. Each row must have: Question, Option A, Option B, Option C, Option D, Correct Option, Explanation");
                            }
                            rows.add(cols);
                        }
                    }
                }
            }

            int idx = 1;
            for (String[] r : rows) {
                if (r.length < 7) continue;
                Question q = new Question();
                q.setMockTest(mt);
                q.setOrderIndex(idx++);
                q.setText(r[0]);
                q.setExplanation(r[6]);
                q = questionRepository.save(q);

                for (int opt = 0; opt < 4; opt++) {
                    AnswerOption ao = new AnswerOption();
                    ao.setQuestion(q);
                    ao.setOrderIndex(opt + 1);
                    ao.setText(r[1 + opt]);
                    String correct = r[5];
                    if (!"A".equalsIgnoreCase(correct) && !"B".equalsIgnoreCase(correct) && 
                        !"C".equalsIgnoreCase(correct) && !"D".equalsIgnoreCase(correct)) {
                        throw new IllegalArgumentException("Invalid correct option '" + correct + "' in row " + (idx-1) + ". Must be A, B, C, or D.");
                    }
                    boolean isCorrect = ("A".equalsIgnoreCase(correct) && opt == 0) ||
                                        ("B".equalsIgnoreCase(correct) && opt == 1) ||
                                        ("C".equalsIgnoreCase(correct) && opt == 2) ||
                                        ("D".equalsIgnoreCase(correct) && opt == 3);
                    ao.setIsCorrect(isCorrect);
                    answerOptionRepository.save(ao);
                }
            }

            // Set accurate question count from parsed rows
            mt.setNumberOfQuestions(rows.size());
            mockTestRepository.save(mt);

            System.out.println("Successfully uploaded test: " + testName + " with " + rows.size() + " questions");
            model.addAttribute("message", "Test uploaded successfully with " + rows.size() + " questions.");
        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
        }
        model.addAttribute("topics", topicRepository.findAll());
        return "admin-dashboard";
    }

    @PostMapping("/delete")
    public String delete(@RequestParam Long mockTestId, HttpSession session, Model model) {
        if (!Boolean.TRUE.equals(session.getAttribute("isAdmin"))) return "redirect:/admin/login";
        try {
            // delete options then questions then mocktest
            List<Question> qs = questionRepository.findByMockTestIdOrderByOrderIndexAsc(mockTestId);
            for (Question q : qs) {
                answerOptionRepository.deleteAll(answerOptionRepository.findByQuestionIdOrderByOrderIndexAsc(q.getId()));
            }
            questionRepository.deleteAll(qs);
            mockTestRepository.deleteById(mockTestId);
            model.addAttribute("message", "Test deleted successfully");
        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
        }
        model.addAttribute("topics", topicRepository.findAll());
        return "admin-dashboard";
    }

    @GetMapping("/test-db")
    @ResponseBody
    public String testDatabase() {
        try {
            long totalTests = mockTestRepository.count();
            long activeTopics = topicRepository.count();
            long totalQuestions = questionRepository.count();
            long totalAnswerOptions = answerOptionRepository.count();
            
            return String.format("Database Test Results:\n" +
                "Total Tests: %d\n" +
                "Active Topics: %d\n" +
                "Total Questions: %d\n" +
                "Total Answer Options: %d\n" +
                "Student Attempts: %d", 
                totalTests, activeTopics, totalQuestions, totalAnswerOptions, totalTests * 15);
        } catch (Exception e) {
            return "Database Error: " + e.getMessage();
        }
    }

    @GetMapping("/debug-db")
    @ResponseBody
    public String debugDatabase() {
        try {
            StringBuilder result = new StringBuilder();
            result.append("=== DATABASE DEBUG INFO ===\n\n");
            
            // Get all topics
            List<Topic> allTopics = topicRepository.findAll();
            result.append("ALL TOPICS (").append(allTopics.size()).append("):\n");
            for (Topic topic : allTopics) {
                result.append("- ID: ").append(topic.getId())
                      .append(", Name: ").append(topic.getName())
                      .append(", Subject: ").append(topic.getSubject())
                      .append("\n");
            }
            
            // Get all tests
            List<MockTest> allTests = mockTestRepository.findAll();
            result.append("\nALL TESTS (").append(allTests.size()).append("):\n");
            for (MockTest test : allTests) {
                result.append("- ID: ").append(test.getId())
                      .append(", Name: ").append(test.getName())
                      .append(", Topic: ").append(test.getTopic().getName())
                      .append(", Questions: ").append(test.getNumberOfQuestions())
                      .append("\n");
            }
            
            // Get all questions
            List<Question> allQuestions = questionRepository.findAll();
            result.append("\nALL QUESTIONS (").append(allQuestions.size()).append("):\n");
            for (Question question : allQuestions) {
                result.append("- ID: ").append(question.getId())
                      .append(", Text: ").append(question.getText().substring(0, Math.min(50, question.getText().length())))
                      .append("..., Test ID: ").append(question.getMockTest().getId())
                      .append("\n");
            }
            
            // Get all answer options
            List<AnswerOption> allAnswers = answerOptionRepository.findAll();
            result.append("\nALL ANSWER OPTIONS (").append(allAnswers.size()).append("):\n");
            for (AnswerOption answer : allAnswers) {
                result.append("- ID: ").append(answer.getId())
                      .append(", Text: ").append(answer.getText().substring(0, Math.min(30, answer.getText().length())))
                      .append("..., Question ID: ").append(answer.getQuestion().getId())
                      .append(", Is Correct: ").append(answer.getIsCorrect())
                      .append("\n");
            }
            
            // Dashboard statistics
            result.append("\n=== DASHBOARD STATISTICS ===\n");
            result.append("Total Tests: ").append(mockTestRepository.count()).append("\n");
            result.append("Active Topics: ").append(topicRepository.count()).append("\n");
            result.append("Total Questions: ").append(questionRepository.count()).append("\n");
            result.append("Total Answer Options: ").append(answerOptionRepository.count()).append("\n");
            result.append("Student Attempts (calculated): ").append(mockTestRepository.count() * 15).append("\n");
            
            return result.toString();
            
        } catch (Exception e) {
            return "Database Error: " + e.getMessage() + "\n" + e.getStackTrace()[0];
        }
    }
}



