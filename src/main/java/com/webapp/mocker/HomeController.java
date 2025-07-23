package com.webapp.mocker;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
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
            return "redirect:/dashboard";
        }
        return "index";
    }

    @GetMapping("/pricing")
    public String pricing() {
        return "pricing";
    }

    @CrossOrigin(origins = "*")
    @PostMapping("/create-order")
    public ResponseEntity<Map<String, String>> createOrder(@RequestParam("planId") int planId) {
        try {
            RazorpayClient razorpay = new RazorpayClient("rzp_test_juGDlBGq2m7P9a", "vykq3fVWpJRLqDhw2CQthycV");
            JSONObject orderRequest = new JSONObject();
            orderRequest.put("amount", 19900); // amount in paise, or fetch from plan
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
        PremiumPlan plan = premiumPlanRepository.findById(data.getPlanId()).orElse(null);
        if (plan == null) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Selected plan does not exist.");
        }
        // (Optional) Verify Razorpay signature here
        Timestamp now = new Timestamp(System.currentTimeMillis());
        Timestamp expiry = new Timestamp(now.getTime() + plan.getDurationDays() * 24L * 60 * 60 * 1000);
        UserPurchase purchase = new UserPurchase();
        purchase.setUser(user);
        purchase.setPlan(plan);
        purchase.setPurchaseDate(now);
        purchase.setExpiryDate(expiry);
        purchase.setStatus("ACTIVE");
        purchase.setRazorpayPaymentId(data.getRazorpayPaymentId());
        userPurchaseRepository.save(purchase);
        // Set user as premium after successful payment
        user.setPremium(true);
        userRepository.save(user);
        System.out.println("[PAYMENT SUCCESS] User: " + username + ", Plan: " + plan.getName() + ", PurchaseId: " + purchase.getId());
        return ResponseEntity.ok("Payment verified and user upgraded.");
    }
} 