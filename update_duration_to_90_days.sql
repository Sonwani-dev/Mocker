-- Update Premium Plans Duration from 30 days to 90 days
-- This script updates existing plans in the database

-- Update all existing premium plans to have 90 days duration
UPDATE premium_plans SET duration_days = 90 WHERE duration_days = 30;

-- Verify the update
SELECT id, name, description, price, duration_days, max_tests FROM premium_plans ORDER BY price;

-- Expected result should show duration_days = 90 for all plans
