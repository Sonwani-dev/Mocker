-- Create Leaderboard Table
-- This table will store user performance data for leaderboard rankings

CREATE TABLE IF NOT EXISTS leaderboard (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    user_name VARCHAR(255) NOT NULL,
    avg_score FLOAT NOT NULL,
    total_tests INT NOT NULL,
    total_time_taken INT NOT NULL, -- in minutes
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    -- Indexes for performance
    INDEX idx_user_id (user_id),
    INDEX idx_avg_score (avg_score DESC),
    INDEX idx_total_tests (total_tests DESC),
    INDEX idx_last_updated (last_updated DESC)
);

-- Add foreign key constraint if users table exists
-- ALTER TABLE leaderboard ADD CONSTRAINT fk_leaderboard_user 
-- FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;

-- Sample data for testing (optional)
-- INSERT INTO leaderboard (user_id, user_name, avg_score, total_tests, total_time_taken) VALUES
-- (1, 'Ankit Sharma', 92.5, 10, 180),
-- (2, 'Priya Verma', 89.0, 8, 190),
-- (3, 'Rahul Kumar', 87.5, 12, 220),
-- (4, 'Neha Singh', 85.0, 6, 120),
-- (5, 'Amit Patel', 82.5, 15, 300);
