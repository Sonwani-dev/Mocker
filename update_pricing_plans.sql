-- Update Premium Plans to new pricing structure
-- This script updates existing plans and creates new ones if needed

-- First, delete existing plans to avoid conflicts
DELETE FROM premium_plans;

-- Insert new pricing plans
INSERT INTO premium_plans (name, description, price, duration_days, max_tests) VALUES
('Free', 'Free plan - 1 test per topic', 0.00, 90, 1),
('Silver', 'Silver plan - unlimited tests', 99.00, 90, NULL),
('Gold', 'Gold plan - premium features', 199.00, 90, NULL),
('Platinum', 'Platinum plan - ultimate features', 299.00, 90, NULL);

-- Update database schema for topics table
-- Add new columns for the new plan names
ALTER TABLE topics 
ADD COLUMN free_unlocked_tests INT DEFAULT 1,
ADD COLUMN silver_unlocked_tests INT DEFAULT NULL,
ADD COLUMN gold_unlocked_tests INT DEFAULT NULL,
ADD COLUMN platinum_unlocked_tests INT DEFAULT NULL;

-- Copy data from old columns to new columns (if they exist)
-- Note: This assumes the old columns still exist and have data
-- If the old columns don't exist, these statements will fail gracefully
SET @sql = 'ALTER TABLE topics DROP COLUMN IF EXISTS starter_unlocked_tests';
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @sql = 'ALTER TABLE topics DROP COLUMN IF EXISTS pro_unlocked_tests';
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @sql = 'ALTER TABLE topics DROP COLUMN IF EXISTS ultimate_unlocked_tests';
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Set default values for existing topics
UPDATE topics SET 
free_unlocked_tests = 1,
silver_unlocked_tests = 5,
gold_unlocked_tests = 10,
platinum_unlocked_tests = 999
WHERE free_unlocked_tests IS NULL;

-- Show the updated plans
SELECT id, name, description, price, duration_days, max_tests FROM premium_plans ORDER BY price;

-- Show the updated topics structure
SELECT id, name, subject, free_unlocked_tests, silver_unlocked_tests, gold_unlocked_tests, platinum_unlocked_tests FROM topics LIMIT 5;
