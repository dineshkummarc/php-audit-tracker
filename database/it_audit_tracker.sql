-- phpMyAdmin SQL Dump
-- version 4.8.4
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 19, 2026 at 03:22 PM
-- Server version: 10.1.37-MariaDB
-- PHP Version: 7.0.33

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `it_audit_tracker`
--

-- --------------------------------------------------------

--
-- Table structure for table `activities`
--

CREATE TABLE `activities` (
  `id` varchar(50) NOT NULL,
  `user_id` varchar(50) NOT NULL,
  `user_name` varchar(255) NOT NULL,
  `user_role` varchar(50) NOT NULL,
  `action` varchar(191) NOT NULL,
  `description` text,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text,
  `severity` enum('info','warning','error','critical') NOT NULL,
  `resource` varchar(255) DEFAULT NULL,
  `metadata` longtext
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `activities`
--

INSERT INTO `activities` (`id`, `user_id`, `user_name`, `user_role`, `action`, `description`, `timestamp`, `ip_address`, `user_agent`, `severity`, `resource`, `metadata`) VALUES
('activity-001', '1', 'John Manager', 'audit_manager', 'login', 'User logged into the system', '2026-11-19 14:13:49', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36', 'info', 'authentication', '{\"sessionId\": \"sess_1640995200000\", \"loginMethod\": \"credentials\"}'),
('activity-002', '2', 'Jane Auditor', 'auditor', 'create_audit', 'Created new audit: Q1 2024 IT Security Audit', '2026-11-19 14:13:49', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36', 'info', 'audit', '{\"auditId\": \"audit-001\", \"auditTitle\": \"Q1 2024 IT Security Audit\"}'),
('activity-003', '4', 'Alice Client', 'client', 'upload_document', 'Uploaded document: Security Policy Document', '2026-11-19 14:13:49', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36', 'info', 'document', '{\"documentId\": \"doc-001\", \"fileName\": \"security_policy.pdf\"}');

-- --------------------------------------------------------

--
-- Table structure for table `alerts`
--

CREATE TABLE `alerts` (
  `id` varchar(50) NOT NULL,
  `rule_id` varchar(50) NOT NULL,
  `rule_name` varchar(255) NOT NULL,
  `severity` enum('info','warning','error','critical') NOT NULL,
  `description` text,
  `triggered_by` varchar(50) NOT NULL,
  `triggered_by_name` varchar(255) NOT NULL,
  `triggered_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `status` enum('active','acknowledged','resolved','dismissed') DEFAULT 'active',
  `acknowledged_by` varchar(50) DEFAULT NULL,
  `acknowledged_at` timestamp NULL DEFAULT NULL,
  `resolved_by` varchar(50) DEFAULT NULL,
  `resolved_at` timestamp NULL DEFAULT NULL,
  `metadata` longtext
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `alerts`
--

INSERT INTO `alerts` (`id`, `rule_id`, `rule_name`, `severity`, `description`, `triggered_by`, `triggered_by_name`, `triggered_at`, `status`, `acknowledged_by`, `acknowledged_at`, `resolved_by`, `resolved_at`, `metadata`) VALUES
('alert-001', 'rule-001', 'Multiple Failed Login Attempts', 'error', 'User has attempted to login 5 times in the last 15 minutes', '2', 'Jane Auditor', '2026-11-19 14:13:49', 'active', NULL, NULL, NULL, NULL, '{\"attemptCount\": 5, \"timeWindow\": \"15 minutes\", \"ipAddress\": \"192.168.1.100\"}'),
('alert-002', 'rule-002', 'Suspicious Document Access', 'warning', 'User has accessed 8 confidential documents in the last 30 minutes', '4', 'Client User', '2026-11-19 14:13:49', 'acknowledged', NULL, NULL, NULL, NULL, '{\"documentCount\": 8, \"timeWindow\": \"30 minutes\", \"documentTypes\": [\"financial\", \"confidential\", \"legal\"]}'),
('alert-003', 'rule-003', 'Admin Privilege Escalation', 'critical', 'Non-admin user attempted to access admin dashboard', '5', 'Department User', '2026-11-19 14:13:49', 'active', NULL, NULL, NULL, NULL, '{\"attemptedAction\": \"admin_dashboard_access\", \"userRole\": \"department\", \"requestedResource\": \"/admin/dashboard\"}');

-- --------------------------------------------------------

--
-- Table structure for table `audits`
--

CREATE TABLE `audits` (
  `id` varchar(50) NOT NULL,
  `title` varchar(500) NOT NULL,
  `description` text,
  `status` enum('planning','in_progress','completed','cancelled') NOT NULL,
  `priority` enum('low','medium','high','critical') NOT NULL,
  `audit_manager` varchar(50) NOT NULL,
  `assigned_auditors` longtext,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `scope` longtext,
  `compliance_frameworks` longtext,
  `progress` int(11) DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `audits`
--

INSERT INTO `audits` (`id`, `title`, `description`, `status`, `priority`, `audit_manager`, `assigned_auditors`, `start_date`, `end_date`, `scope`, `compliance_frameworks`, `progress`, `created_at`, `updated_at`) VALUES
('audit-001', 'Q1 2024 IT Security Audit', 'UI Test Update at 2025-10-03T01:19:56.913Z', 'in_progress', 'high', '1', '[\"2\", \"6\"]', '2024-01-15', '2024-03-31', '[\"Network Security\", \"Access Controls\", \"Data Protection\", \"Incident Response\"]', '[\"ISO 27001\", \"SOC 2\"]', 85, '2026-11-19 14:13:49', '2026-11-19 14:13:49'),
('audit-002', 'Data Privacy Compliance Review', 'Review of data handling practices and GDPR compliance measures.', 'planning', 'medium', '1', '[\"2\"]', '2025-10-01', '2025-10-03', '[\"Data Collection\", \"Data Processing\", \"Data Storage\", \"Data Retention\"]', '[\"GDPR\", \"CCPA\"]', 5, '2026-11-19 14:13:49', '2026-11-19 14:13:49'),
('audit-003', 'Infrastructure Security Assessment', 'Assessment of server infrastructure, cloud services, and backup systems.', 'completed', 'high', '1', '[\"2\"]', '2023-12-01', '2023-12-31', '[\"Server Security\", \"Cloud Infrastructure\", \"Backup Systems\", \"Monitoring\"]', '[\"ISO 27001\"]', 100, '2026-11-19 14:13:49', '2026-11-19 14:13:49');

-- --------------------------------------------------------

--
-- Table structure for table `audit_findings`
--

CREATE TABLE `audit_findings` (
  `id` varchar(50) NOT NULL,
  `audit_id` varchar(50) NOT NULL,
  `title` varchar(500) NOT NULL,
  `severity` enum('low','medium','high','critical') NOT NULL,
  `status` enum('open','in_progress','resolved','closed') NOT NULL,
  `description` text,
  `recommendation` text,
  `assigned_to` varchar(50) DEFAULT NULL,
  `due_date` date DEFAULT NULL,
  `resolved_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `audit_findings`
--

INSERT INTO `audit_findings` (`id`, `audit_id`, `title`, `severity`, `status`, `description`, `recommendation`, `assigned_to`, `due_date`, `resolved_at`, `created_at`, `updated_at`) VALUES
('finding-001', 'audit-001', 'Weak Password Policy', 'medium', 'open', 'Current password policy does not meet industry standards', 'Implement stronger password requirements', '2', '2024-02-15', NULL, '2026-11-19 14:13:49', '2026-11-19 14:13:49'),
('finding-002', 'audit-003', 'Outdated Server Software', 'high', 'resolved', 'Several servers running outdated software versions', 'Update all server software to latest versions', '2', '2023-12-15', NULL, '2026-11-19 14:13:49', '2026-11-19 14:13:49');

-- --------------------------------------------------------

--
-- Table structure for table `documents`
--

CREATE TABLE `documents` (
  `id` varchar(50) NOT NULL,
  `title` varchar(500) NOT NULL,
  `description` text,
  `type` enum('policy','procedure','log','plan','report','evidence') NOT NULL,
  `audit_id` varchar(50) NOT NULL,
  `requested_by` varchar(50) NOT NULL,
  `requested_from` varchar(50) NOT NULL,
  `status` enum('draft','pending','submitted','approved','rejected') NOT NULL,
  `uploaded_by` varchar(50) DEFAULT NULL,
  `uploaded_at` timestamp NULL DEFAULT NULL,
  `requested_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `due_date` date NOT NULL,
  `file_size` int(11) DEFAULT NULL,
  `file_name` varchar(500) DEFAULT NULL,
  `file_path` varchar(1000) DEFAULT NULL,
  `version` varchar(50) DEFAULT NULL,
  `tags` longtext,
  `is_confidential` tinyint(1) DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `documents`
--

INSERT INTO `documents` (`id`, `title`, `description`, `type`, `audit_id`, `requested_by`, `requested_from`, `status`, `uploaded_by`, `uploaded_at`, `requested_at`, `due_date`, `file_size`, `file_name`, `file_path`, `version`, `tags`, `is_confidential`, `created_at`, `updated_at`) VALUES
('doc-001', 'Security Policy Document', 'Current IT security policies and procedures', 'policy', 'audit-001', '1', '4', 'pending', NULL, NULL, '2026-11-19 14:13:49', '2024-02-01', NULL, NULL, NULL, NULL, '[\"security\", \"policy\", \"compliance\"]', 0, '2026-11-19 14:13:49', '2026-11-19 14:13:49'),
('doc-002', 'Access Control Logs', 'Recent access control and authentication logs', 'log', 'audit-001', '2', '5', 'submitted', NULL, NULL, '2026-11-19 14:13:49', '2024-01-25', NULL, NULL, NULL, NULL, '[\"access\", \"logs\", \"authentication\"]', 1, '2026-11-19 14:13:49', '2026-11-19 14:13:49'),
('doc-003', 'Data Processing Agreement', 'GDPR compliance data processing agreement', 'procedure', 'audit-002', '1', '4', 'draft', NULL, NULL, '2026-11-19 14:13:49', '2024-02-10', NULL, NULL, NULL, NULL, '[\"gdpr\", \"data\", \"processing\"]', 0, '2026-11-19 14:13:49', '2026-11-19 14:13:49');

-- --------------------------------------------------------

--
-- Table structure for table `failed_logins`
--

CREATE TABLE `failed_logins` (
  `id` int(11) NOT NULL,
  `email` varchar(255) NOT NULL,
  `ip_address` varchar(45) NOT NULL,
  `user_agent` text,
  `attempted_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `id` varchar(50) NOT NULL,
  `user_id` varchar(50) NOT NULL,
  `user_name` varchar(255) NOT NULL,
  `user_role` varchar(50) NOT NULL,
  `title` varchar(500) NOT NULL,
  `message` text,
  `type` enum('audit_request','document_request','document_upload','audit_assignment','report_ready','security_alert','system_update') NOT NULL,
  `status` enum('unread','read','archived') DEFAULT 'unread',
  `priority` enum('low','medium','high','critical') NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `read_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `metadata` longtext
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `notifications`
--

INSERT INTO `notifications` (`id`, `user_id`, `user_name`, `user_role`, `title`, `message`, `type`, `status`, `priority`, `created_at`, `read_at`, `expires_at`, `metadata`) VALUES
('notif-001', '4', 'Alice Client', 'client', 'Document Request', 'New document request: Security Policy Document', 'document_request', 'unread', 'medium', '2026-11-19 14:13:49', NULL, NULL, '{\"documentId\": \"doc-001\", \"auditId\": \"audit-001\"}'),
('notif-002', '2', 'Jane Auditor', 'auditor', 'Audit Assignment', 'You have been assigned to audit: Q1 2024 IT Security Audit', 'audit_assignment', 'unread', 'high', '2026-11-19 14:13:49', NULL, NULL, '{\"auditId\": \"audit-001\", \"auditTitle\": \"Q1 2024 IT Security Audit\"}'),
('notif-003', '1', 'John Manager', 'audit_manager', 'System Update', 'System maintenance scheduled for tonight at 2 AM', 'system_update', 'unread', 'low', '2026-11-19 14:13:49', NULL, NULL, '{\"maintenanceWindow\": \"2024-01-21T02:00:00Z\", \"duration\": \"2 hours\"}');

-- --------------------------------------------------------

--
-- Table structure for table `reports`
--

CREATE TABLE `reports` (
  `id` varchar(50) NOT NULL,
  `title` varchar(500) NOT NULL,
  `audit_id` varchar(50) NOT NULL,
  `audit_title` varchar(500) NOT NULL,
  `report_type` varchar(255) NOT NULL,
  `status` enum('draft','pending','approved','rejected') NOT NULL,
  `created_by` varchar(50) NOT NULL,
  `created_by_name` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `submitted_at` timestamp NULL DEFAULT NULL,
  `approved_at` timestamp NULL DEFAULT NULL,
  `approved_by` varchar(50) DEFAULT NULL,
  `content` longtext,
  `findings` longtext,
  `recommendations` longtext
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `reports`
--

INSERT INTO `reports` (`id`, `title`, `audit_id`, `audit_title`, `report_type`, `status`, `created_by`, `created_by_name`, `created_at`, `submitted_at`, `approved_at`, `approved_by`, `content`, `findings`, `recommendations`) VALUES
('report-001', 'Q1 2024 IT Security Audit Report', 'audit-001', 'Q1 2024 IT Security Audit', 'executive_summary', 'draft', '2', 'Jane Auditor', '2026-11-19 14:13:49', NULL, NULL, NULL, 'This report summarizes the findings from the Q1 2024 IT Security Audit...', '[\"Weak password policy identified\", \"Access control gaps found\"]', '[\"Implement stronger password requirements\", \"Review and update access control procedures\"]'),
('report-002', 'Infrastructure Security Assessment Report', 'audit-003', 'Infrastructure Security Assessment', 'detailed_report', 'approved', '2', 'Jane Auditor', '2026-11-19 14:13:49', NULL, NULL, NULL, 'Comprehensive assessment of server infrastructure and security measures...', '[\"Outdated server software\", \"Backup system vulnerabilities\"]', '[\"Update all server software\", \"Implement automated backup verification\"]');

-- --------------------------------------------------------

--
-- Table structure for table `system_settings`
--

CREATE TABLE `system_settings` (
  `id` int(11) NOT NULL,
  `setting_key` varchar(191) NOT NULL,
  `setting_value` text,
  `description` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `system_settings`
--

INSERT INTO `system_settings` (`id`, `setting_key`, `setting_value`, `description`, `created_at`, `updated_at`) VALUES
(1, 'system_name', 'IT Audit Tracker', 'Name of the audit tracking system', '2026-11-19 14:13:49', '2026-11-19 14:13:49'),
(2, 'system_version', '1.0.0', 'Current system version', '2026-11-19 14:13:49', '2026-11-19 14:13:49'),
(3, 'max_file_size', '10485760', 'Maximum file upload size in bytes (10MB)', '2026-11-19 14:13:49', '2026-11-19 14:13:49'),
(4, 'allowed_file_types', 'pdf,doc,docx,xls,xlsx,txt,jpg,jpeg,png', 'Allowed file types for uploads', '2026-11-19 14:13:49', '2026-11-19 14:13:49'),
(5, 'session_timeout', '3600', 'Session timeout in seconds (1 hour)', '2026-11-19 14:13:49', '2026-11-19 14:13:49'),
(6, 'password_min_length', '8', 'Minimum password length', '2026-11-19 14:13:49', '2026-11-19 14:13:49'),
(7, 'audit_retention_days', '2555', 'Number of days to retain audit data (7 years)', '2026-11-19 14:13:49', '2026-11-19 14:13:49'),
(8, 'notification_retention_days', '90', 'Number of days to retain notifications', '2026-11-19 14:13:49', '2026-11-19 14:13:49'),
(9, 'backup_frequency', 'daily', 'Backup frequency: daily, weekly, monthly', '2026-11-19 14:13:49', '2026-11-19 14:13:49'),
(10, 'email_notifications', 'true', 'Enable email notifications', '2026-11-19 14:13:49', '2026-11-19 14:13:49'),
(11, 'maintenance_mode', 'false', 'System maintenance mode', '2026-11-19 14:13:49', '2026-11-19 14:13:49');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` varchar(50) NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(191) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `role` enum('super_admin','audit_manager','auditor','management','client','department') NOT NULL,
  `department` varchar(255) NOT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  `permissions` longtext,
  `last_login` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `password_hash`, `role`, `department`, `is_active`, `permissions`, `last_login`, `created_at`, `updated_at`) VALUES
('0', 'Super Administrator', 'superadmin@audit.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'super_admin', 'System Administration', 1, '[\"super_admin_access\", \"manage_all_users\", \"manage_permissions\", \"manage_system_settings\", \"manage_database_config\", \"view_all_logs\", \"export_all_data\", \"create_audit\", \"assign_tasks\", \"view_reports\", \"approve_audits\", \"manage_notifications\", \"manage_reports\", \"manage_alerts\"]', NULL, '2026-11-19 14:13:49', '2026-11-19 14:13:49'),
('1', 'John Manager', 'manager@audit.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'audit_manager', 'Audit Department', 1, '[\"create_audit\", \"assign_tasks\", \"view_reports\", \"manage_users\", \"view_all_logs\", \"approve_audits\", \"export_data\"]', NULL, '2026-11-19 14:13:49', '2026-11-19 14:13:49'),
('2', 'Jane Auditor', 'auditor@audit.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'auditor', 'IT Security', 1, '[\"view_logs\", \"submit_reports\", \"request_documents\", \"flag_activities\", \"view_assigned_audits\", \"upload_evidence\"]', NULL, '2026-11-19 14:13:49', '2026-11-19 14:13:49'),
('3', 'Bob Executive', 'management@audit.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'management', 'Executive', 1, '[\"view_dashboards\", \"approve_reports\", \"view_summaries\", \"view_compliance_scores\", \"export_executive_reports\"]', NULL, '2026-11-19 14:13:49', '2026-11-19 14:13:49'),
('4', 'Alice Client', 'client@company.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'client', 'Client Relations', 1, '[\"view_notifications\", \"respond_requests\", \"view_audit_status\", \"download_reports\"]', NULL, '2026-11-19 14:13:49', '2026-11-19 14:13:49'),
('5', 'Charlie Department', 'dept@company.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'department', 'HR', 1, '[\"upload_documents\", \"view_requests\", \"respond_to_auditors\", \"track_submissions\"]', NULL, '2026-11-19 14:13:49', '2026-11-19 14:13:49'),
('6', 'Mike Auditor', 'auditor2@audit.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'auditor', 'IT Security', 1, '[\"view_logs\", \"submit_reports\", \"request_documents\", \"flag_activities\", \"view_assigned_audits\", \"upload_evidence\"]', NULL, '2026-11-19 14:13:49', '2026-11-19 14:13:49');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `activities`
--
ALTER TABLE `activities`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_user_id` (`user_id`),
  ADD KEY `idx_timestamp` (`timestamp`),
  ADD KEY `idx_severity` (`severity`),
  ADD KEY `idx_action` (`action`);

--
-- Indexes for table `alerts`
--
ALTER TABLE `alerts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `acknowledged_by` (`acknowledged_by`),
  ADD KEY `resolved_by` (`resolved_by`),
  ADD KEY `idx_severity` (`severity`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_triggered_by` (`triggered_by`),
  ADD KEY `idx_triggered_at` (`triggered_at`);

--
-- Indexes for table `audits`
--
ALTER TABLE `audits`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_priority` (`priority`),
  ADD KEY `idx_audit_manager` (`audit_manager`),
  ADD KEY `idx_start_date` (`start_date`),
  ADD KEY `idx_end_date` (`end_date`);

--
-- Indexes for table `audit_findings`
--
ALTER TABLE `audit_findings`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_audit_id` (`audit_id`),
  ADD KEY `idx_severity` (`severity`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_assigned_to` (`assigned_to`);

--
-- Indexes for table `documents`
--
ALTER TABLE `documents`
  ADD PRIMARY KEY (`id`),
  ADD KEY `uploaded_by` (`uploaded_by`),
  ADD KEY `idx_audit_id` (`audit_id`),
  ADD KEY `idx_requested_by` (`requested_by`),
  ADD KEY `idx_requested_from` (`requested_from`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_type` (`type`),
  ADD KEY `idx_due_date` (`due_date`);

--
-- Indexes for table `failed_logins`
--
ALTER TABLE `failed_logins`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_email` (`email`),
  ADD KEY `idx_attempted_at` (`attempted_at`),
  ADD KEY `idx_ip_address` (`ip_address`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_user_id` (`user_id`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_priority` (`priority`),
  ADD KEY `idx_type` (`type`),
  ADD KEY `idx_created_at` (`created_at`);

--
-- Indexes for table `reports`
--
ALTER TABLE `reports`
  ADD PRIMARY KEY (`id`),
  ADD KEY `approved_by` (`approved_by`),
  ADD KEY `idx_audit_id` (`audit_id`),
  ADD KEY `idx_created_by` (`created_by`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_report_type` (`report_type`);

--
-- Indexes for table `system_settings`
--
ALTER TABLE `system_settings`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `setting_key` (`setting_key`),
  ADD KEY `idx_setting_key` (`setting_key`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `idx_email` (`email`),
  ADD KEY `idx_role` (`role`),
  ADD KEY `idx_department` (`department`),
  ADD KEY `idx_is_active` (`is_active`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `failed_logins`
--
ALTER TABLE `failed_logins`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `system_settings`
--
ALTER TABLE `system_settings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `alerts`
--
ALTER TABLE `alerts`
  ADD CONSTRAINT `alerts_ibfk_1` FOREIGN KEY (`triggered_by`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `alerts_ibfk_2` FOREIGN KEY (`acknowledged_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `alerts_ibfk_3` FOREIGN KEY (`resolved_by`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `audits`
--
ALTER TABLE `audits`
  ADD CONSTRAINT `audits_ibfk_1` FOREIGN KEY (`audit_manager`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `audit_findings`
--
ALTER TABLE `audit_findings`
  ADD CONSTRAINT `audit_findings_ibfk_1` FOREIGN KEY (`audit_id`) REFERENCES `audits` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `audit_findings_ibfk_2` FOREIGN KEY (`assigned_to`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `documents`
--
ALTER TABLE `documents`
  ADD CONSTRAINT `documents_ibfk_1` FOREIGN KEY (`audit_id`) REFERENCES `audits` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `documents_ibfk_2` FOREIGN KEY (`requested_by`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `documents_ibfk_3` FOREIGN KEY (`requested_from`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `documents_ibfk_4` FOREIGN KEY (`uploaded_by`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `notifications`
--
ALTER TABLE `notifications`
  ADD CONSTRAINT `notifications_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `reports`
--
ALTER TABLE `reports`
  ADD CONSTRAINT `reports_ibfk_1` FOREIGN KEY (`audit_id`) REFERENCES `audits` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `reports_ibfk_2` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `reports_ibfk_3` FOREIGN KEY (`approved_by`) REFERENCES `users` (`id`) ON DELETE SET NULL;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
