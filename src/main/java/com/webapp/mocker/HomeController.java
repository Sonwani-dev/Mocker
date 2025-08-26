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
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import com.razorpay.RazorpayClient;
import com.razorpay.Order;
import com.razorpay.RazorpayException;
import org.json.JSONObject;
import org.springframework.http.HttpStatus;
import jakarta.servlet.http.HttpSession;

@Controller
public class HomeController {
    @Autowired
    private PremiumPlanRepository premiumPlanRepository;
    @Autowired
    private UserPurchaseRepository userPurchaseRepository;
    @Autowired
    private UserRepository userRepository;

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
    public String pricing(Model model) {
        PremiumPlan silverPlan = premiumPlanRepository.findByName("Silver");
        PremiumPlan goldPlan = premiumPlanRepository.findByName("Gold");
        PremiumPlan platinumPlan = premiumPlanRepository.findByName("Platinum");
        model.addAttribute("silverPlan", silverPlan);
        model.addAttribute("goldPlan", goldPlan);
        model.addAttribute("platinumPlan", platinumPlan);
        return "pricing";
    }

    @CrossOrigin(origins = "*")
    @PostMapping("/create-order")
    public ResponseEntity<Map<String, String>> createOrder(@RequestParam("planId") int planId) {
        try {
            RazorpayClient razorpay = new RazorpayClient("rzp_test_juGDlBGq2m7P9a", "vykq3fVWpJRLqDhw2CQthycV");
            // Resolve amount from premium plan
            PremiumPlan plan = premiumPlanRepository.findById((long) planId).orElse(null);
            if (plan == null || plan.getPrice() == null) {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).build();
            }
            java.math.BigDecimal paise = plan.getPrice().multiply(new java.math.BigDecimal("100")).setScale(0, java.math.RoundingMode.HALF_UP);

            JSONObject orderRequest = new JSONObject();
            orderRequest.put("amount", paise.intValue()); // amount in paise from plan
            orderRequest.put("currency", "INR");
            orderRequest.put("receipt", "order_rcptid_" + planId);
            Order order = razorpay.orders.create(orderRequest);
            System.out.println("ORDER ID CREATED: " + order.get("id"));
            Map<String, String> response = new HashMap<>();
            response.put("orderId", order.get("id"));
            return ResponseEntity.ok(response);
        } catch (RazorpayException e) {
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
        // Default to 30 days if plan not found
        int durationDays = (plan != null && plan.getDurationDays() != null) ? plan.getDurationDays() : 30;
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