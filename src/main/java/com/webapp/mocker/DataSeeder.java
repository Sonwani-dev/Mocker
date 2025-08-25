package com.webapp.mocker;

import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

import com.webapp.mocker.models.PremiumPlan;
import com.webapp.mocker.models.PremiumPlanRepository;

@Component
public class DataSeeder implements CommandLineRunner {

    private final PremiumPlanRepository premiumPlanRepository;

    public DataSeeder(PremiumPlanRepository premiumPlanRepository) {
        this.premiumPlanRepository = premiumPlanRepository;
    }

    @Override
    public void run(String... args) {
        ensurePlan("Starter", "Starter plan", new java.math.BigDecimal("0"), 30, 2);
        ensurePlan("Pro", "Pro plan", new java.math.BigDecimal("499"), 30, null);
        ensurePlan("Ultimate", "Ultimate plan", new java.math.BigDecimal("999"), 30, null);
    }

    private void ensurePlan(String name, String description, java.math.BigDecimal price, Integer durationDays, Integer maxTests) {
        PremiumPlan existing = premiumPlanRepository.findByName(name);
        if (existing == null) {
            PremiumPlan plan = new PremiumPlan();
            plan.setName(name);
            plan.setDescription(description);
            plan.setPrice(price);
            plan.setDurationDays(durationDays);
            plan.setMaxTests(maxTests);
            premiumPlanRepository.save(plan);
            System.out.println("[SEED] Created premium plan: " + name);
        }
    }
}


