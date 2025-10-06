-- Failed Logins Table
-- This table tracks failed login attempts for security purposes

USE it_audit_tracker;

CREATE TABLE IF NOT EXISTS failed_logins (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) NOT NULL,
    ip_address VARCHAR(45) NOT NULL,
    user_agent TEXT,
    attempted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_email (email),
    INDEX idx_attempted_at (attempted_at),
    INDEX idx_ip_address (ip_address)
);
