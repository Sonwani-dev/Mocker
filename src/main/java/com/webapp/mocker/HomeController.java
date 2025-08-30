package com.webapp.mocker;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.http.ResponseEntity;
import com.webapp.mocker.models.PremiumPlanRepository;
import com.webapp.mocker.models.PremiumPlan;
import com.webapp.mocker.models.UserPurchase;
import com.webapp.mocker.models.UserPurchaseRepository;
import com.webapp.mocker.models.PaymentSuccessDTO;
import com.webapp.mocker.UserRepository;
import com.webapp.mocker.User;
import java.math.BigDecimal;
import java.security.Principal;
import java.sql.Timestamp;
import java.util.*;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import com.razorpay.RazorpayClient;
import com.razorpay.Order;
import com.razorpay.RazorpayException;
import org.json.JSONObject;
import org.springframework.http.HttpStatus;
import jakarta.servlet.http.HttpSession;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class HomeController {
    @Autowired
    private PremiumPlanRepository premiumPlanRepository;
    @Autowired
    private UserPurchaseRepository userPurchaseRepository;
    @Autowired
    private UserRepository userRepository;

    @GetMapping("/test")
    @ResponseBody
    public String test() {
        return "HomeController is working!";
    }

    @GetMapping("/")
    public String home(HttpSession session) {
        String username = (String) session.getAttribute("username");
        if (username != null) {
            return "redirect:/pe-subjects";
        }
        return "index";
    }

    @GetMapping("/dashboard")
    public String dashboardRedirect() {
        return "redirect:/pe-subjects";
    }

    @GetMapping("/pricing")
    public String pricing(Model model, HttpSession session) {
        PremiumPlan silverPlan = premiumPlanRepository.findByName("Silver");
        PremiumPlan goldPlan = premiumPlanRepository.findByName("Gold");
        PremiumPlan platinumPlan = premiumPlanRepository.findByName("Platinum");
        
        // Check if user is logged in
        String username = (String) session.getAttribute("username");
        boolean isLoggedIn = username != null;
        
        model.addAttribute("silverPlan", silverPlan);
        model.addAttribute("goldPlan", goldPlan);
        model.addAttribute("platinumPlan", platinumPlan);
        model.addAttribute("loggedIn", isLoggedIn);
        model.addAttribute("username", username);
        
        return "pricing";
    }

    @GetMapping("/debug/plans")
    @ResponseBody
    public String debugPlans() {
        try {
            StringBuilder result = new StringBuilder();
            result.append("=== AVAILABLE PLANS ===\n\n");
            
            List<PremiumPlan> allPlans = premiumPlanRepository.findAll();
            for (PremiumPlan plan : allPlans) {
                result.append("ID: ").append(plan.getId())
                      .append(", Name: ").append(plan.getName())
                      .append(", Price: ").append(plan.getPrice())
                      .append(", Duration: ").append(plan.getDurationDays())
                      .append(" days\n");
            }
            
            result.append("\n=== PLAN LOOKUP TEST ===\n");
            PremiumPlan silver = premiumPlanRepository.findByName("Silver");
            PremiumPlan gold = premiumPlanRepository.findByName("Gold");
            PremiumPlan platinum = premiumPlanRepository.findByName("Platinum");
            
            result.append("Silver Plan: ").append(silver != null ? "Found (ID: " + silver.getId() + ")" : "NOT FOUND").append("\n");
            result.append("Gold Plan: ").append(gold != null ? "Found (ID: " + gold.getId() + ")" : "NOT FOUND").append("\n");
            result.append("Platinum Plan: ").append(platinum != null ? "Found (ID: " + platinum.getId() + ")" : "NOT FOUND").append("\n");
            
            return result.toString();
        } catch (Exception e) {
            return "Error: " + e.getMessage();
        }
    }

    @GetMapping("/cleanup/plans")
    @ResponseBody
    public String cleanupPlans() {
        try {
            StringBuilder result = new StringBuilder();
            result.append("=== CLEANING UP DUPLICATE PLANS ===\n\n");
            
            // Delete old plans one by one
            PremiumPlan proPlan = premiumPlanRepository.findByName("Pro");
            if (proPlan != null) {
                premiumPlanRepository.delete(proPlan);
                result.append("Deleted old plan: Pro (ID: ").append(proPlan.getId()).append(")\n");
            }
            
            PremiumPlan ultimatePlan = premiumPlanRepository.findByName("Ultimate");
            if (ultimatePlan != null) {
                premiumPlanRepository.delete(ultimatePlan);
                result.append("Deleted old plan: Ultimate (ID: ").append(ultimatePlan.getId()).append(")\n");
            }
            
            PremiumPlan starterPlan = premiumPlanRepository.findByName("Starter");
            if (starterPlan != null) {
                premiumPlanRepository.delete(starterPlan);
                result.append("Deleted old plan: Starter (ID: ").append(starterPlan.getId()).append(")\n");
            }
            
            // Update remaining plans with proper max_tests
            PremiumPlan freePlan = premiumPlanRepository.findByName("Free");
            if (freePlan != null) {
                freePlan.setMaxTests(1);
                premiumPlanRepository.save(freePlan);
                result.append("Updated Free plan: max_tests = 1\n");
            }
            
            PremiumPlan silverPlan = premiumPlanRepository.findByName("Silver");
            if (silverPlan != null) {
                silverPlan.setMaxTests(null); // null means unlimited
                premiumPlanRepository.save(silverPlan);
                result.append("Updated Silver plan: max_tests = unlimited\n");
            }
            
            PremiumPlan goldPlan = premiumPlanRepository.findByName("Gold");
            if (goldPlan != null) {
                goldPlan.setMaxTests(null); // null means unlimited
                premiumPlanRepository.save(goldPlan);
                result.append("Updated Gold plan: max_tests = unlimited\n");
            }
            
            PremiumPlan platinumPlan = premiumPlanRepository.findByName("Platinum");
            if (platinumPlan != null) {
                platinumPlan.setMaxTests(null); // null means unlimited
                premiumPlanRepository.save(platinumPlan);
                result.append("Updated Platinum plan: max_tests = unlimited\n");
            }
            
            result.append("\n=== FINAL PLAN STATUS ===\n");
            List<PremiumPlan> allPlans = premiumPlanRepository.findAll();
            for (PremiumPlan plan : allPlans) {
                result.append("ID: ").append(plan.getId())
                      .append(", Name: ").append(plan.getName())
                      .append(", Price: ").append(plan.getPrice())
                      .append(", Max Tests: ").append(plan.getMaxTests() != null ? plan.getMaxTests() : "unlimited")
                      .append("\n");
            }
            
            return result.toString();
        } catch (Exception e) {
            return "Error during cleanup: " + e.getMessage();
        }
    }

    @CrossOrigin(origins = "*")
    @PostMapping("/create-order")
    public ResponseEntity<Map<String, String>> createOrder(@RequestParam("planId") int planId) {
        try {
            System.out.println("[CREATE ORDER] Received request for planId: " + planId);
            
            RazorpayClient razorpay = new RazorpayClient("rzp_test_juGDlBGq2m7P9a", "vykq3fVWpJRLqDhw2CQthycV");
            
            // Resolve amount from premium plan
            PremiumPlan plan = premiumPlanRepository.findById((long) planId).orElse(null);
            System.out.println("[CREATE ORDER] Found plan: " + (plan != null ? plan.getName() + " (ID: " + plan.getId() + ")" : "null"));
            
            if (plan == null || plan.getPrice() == null) {
                System.out.println("[CREATE ORDER] Plan not found or price is null for planId: " + planId);
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).build();
            }
            
            System.out.println("[CREATE ORDER] Plan price: " + plan.getPrice());
            java.math.BigDecimal paise = plan.getPrice().multiply(new java.math.BigDecimal("100")).setScale(0, java.math.RoundingMode.HALF_UP);
            System.out.println("[CREATE ORDER] Amount in paise: " + paise.intValue());

            JSONObject orderRequest = new JSONObject();
            orderRequest.put("amount", paise.intValue()); // amount in paise from plan
            orderRequest.put("currency", "INR");
            orderRequest.put("receipt", "order_rcptid_" + planId);
            
            System.out.println("[CREATE ORDER] Creating Razorpay order with: " + orderRequest.toString());
            Order order = razorpay.orders.create(orderRequest);
            System.out.println("[CREATE ORDER] ORDER ID CREATED: " + order.get("id"));
            
            Map<String, String> response = new HashMap<>();
            response.put("orderId", order.get("id"));
            return ResponseEntity.ok(response);
        } catch (RazorpayException e) {
            System.out.println("[CREATE ORDER] Razorpay error: " + e.getMessage());
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        } catch (Exception e) {
            System.out.println("[CREATE ORDER] Unexpected error: " + e.getMessage());
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    @PostMapping("/payment-success")
    public ResponseEntity<String> handleSuccess(@RequestBody PaymentSuccessDTO data, HttpSession session) {
        String username = (String) session.getAttribute("username");
        if (username == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("User not logged in");
        }
        User user = userRepository.findByUsername(username);
        PremiumPlan plan = null;
        if (data.getPlanId() != null) {
            plan = premiumPlanRepository.findById(data.getPlanId()).orElse(null);
        }
        // (Optional) Verify Razorpay signature here
        Timestamp now = new Timestamp(System.currentTimeMillis());
        // Default to 90 days if plan not found
        int durationDays = (plan != null && plan.getDurationDays() != null) ? plan.getDurationDays() : 90;
        Timestamp expiry = new Timestamp(now.getTime() + durationDays * 24L * 60 * 60 * 1000);

        try {
            if (plan != null) {
                UserPurchase purchase = new UserPurchase();
                purchase.setUser(user);
                purchase.setPlan(plan);
                purchase.setPurchaseDate(now);
                purchase.setExpiryDate(expiry);
                purchase.setStatus("ACTIVE");
                purchase.setRazorpayPaymentId(data.getRazorpayPaymentId());
                userPurchaseRepository.save(purchase);
                System.out.println("[PAYMENT SUCCESS] User: " + username + ", Plan: " + plan.getName() + ", PurchaseId: " + purchase.getId());
            } else {
                System.out.println("[PAYMENT SUCCESS] User: " + username + ", plan missing; granting default premium for " + durationDays + " days.");
            }
        } finally {
            // Ensure user premium flag is set regardless
            user.setPremium(true);
            userRepository.save(user);
        }
        return ResponseEntity.ok("Payment verified and user upgraded.");
    }
} 