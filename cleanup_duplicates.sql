-- Clean up duplicate and old pricing plans
-- Keep only: Free, Silver, Gold, Platinum

-- First, delete the old plans (Pro, Ultimate, Starter)
DELETE FROM premium_plans WHERE name IN ('Pro', 'Ultimate', 'Starter');

-- Update the remaining plans with proper max_tests values
UPDATE premium_plans SET max_tests = 1 WHERE name = 'Free';
UPDATE premium_plans SET max_tests = NULL WHERE name = 'Silver';  -- NULL means unlimited
UPDATE premium_plans SET max_tests = NULL WHERE name = 'Gold';    -- NULL means unlimited  
UPDATE premium_plans SET max_tests = NULL WHERE name = 'Platinum'; -- NULL means unlimited

-- Verify the cleanup
SELECT id, name, price, duration_days, max_tests, description FROM premium_plans ORDER BY price;

-- Expected result should be:
-- ID | Name      | Price | Duration | Max_Tests | Description
-- 4  | Free      | 0.00  | 90       | 1         | Free plan - 1 test per topic
-- 5  | Silver    | 99.00 | 90       | NULL      | Silver plan - unlimited tests
-- 6  | Gold      | 199.00| 90       | NULL      | Gold plan - premium features
-- 7  | Platinum  | 299.00| 90       | NULL      | Platinum plan - ultimate features 