-- Update Premium Plans to new pricing structure
-- This script updates existing plans and creates new ones if needed

-- First, delete existing plans to avoid conflicts
DELETE FROM premium_plans;

-- Insert new pricing plans
INSERT INTO premium_plans (name, description, price, duration_days, max_tests) VALUES
('Free', 'Free plan - 1 test per topic', 0.00, 30, 1),
('Silver', 'Silver plan - unlimited tests', 99.00, 30, NULL),
('Gold', 'Gold plan - premium features', 199.00, 30, NULL),
('Platinum', 'Platinum plan - ultimate features', 299.00, 30, NULL);

-- Show the updated plans
SELECT id, name, description, price, duration_days, max_tests FROM premium_plans ORDER BY price;
