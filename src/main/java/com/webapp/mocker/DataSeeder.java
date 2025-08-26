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
        ensurePlan("Free", "Free plan - 1 test per topic", new java.math.BigDecimal("0"), 30, 1);
        ensurePlan("Silver", "Silver plan - unlimited tests", new java.math.BigDecimal("99"), 30, null);
        ensurePlan("Gold", "Gold plan - premium features", new java.math.BigDecimal("199"), 30, null);
        ensurePlan("Platinum", "Platinum plan - ultimate features", new java.math.BigDecimal("299"), 30, null);
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
            System.out.println("[INIT] Created premium plan: " + name);
        }
    }
}


