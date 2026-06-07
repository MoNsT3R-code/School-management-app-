-- Create Database Context for Al-Noor Islamic Academy
CREATE DATABASE IF NOT EXISTS al_noor_sms CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE al_noor_sms;

-- -----------------------------------------------------------------------------
-- DOMAIN: USERS & PORTAL IDENTITIES
-- -----------------------------------------------------------------------------
CREATE TABLE roles (
    role_id INT NOT NULL AUTO_INCREMENT,
    role_name VARCHAR(50) NOT NULL,
    CONSTRAINT pk_roles PRIMARY KEY (role_id),
    CONSTRAINT uq_role_name UNIQUE (role_name)
) ENGINE=InnoDB;

CREATE TABLE users (
    user_id BIGINT NOT NULL AUTO_INCREMENT,
    role_id INT NOT NULL,
    email VARCHAR(255) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    is_active TINYINT(1) DEFAULT 1 NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT pk_users PRIMARY KEY (user_id),
    CONSTRAINT uq_user_email UNIQUE (email),
    CONSTRAINT fk_users_roles FOREIGN KEY (role_id) REFERENCES roles (role_id) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE user_profiles (
    profile_id BIGINT NOT NULL AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    emergency_contact VARCHAR(255) NOT NULL,
    residential_address TEXT NOT NULL,
    biometric_template_path VARCHAR(512) DEFAULT NULL,
    CONSTRAINT pk_user_profiles PRIMARY KEY (profile_id),
    CONSTRAINT uq_profile_user UNIQUE (user_id),
    CONSTRAINT fk_profiles_users FOREIGN KEY (user_id) REFERENCES users (user_id) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

-- -----------------------------------------------------------------------------
-- DOMAIN: STANDARD ACADEMIC TRACKING
-- -----------------------------------------------------------------------------
CREATE TABLE academic_classes (
    class_id INT NOT NULL AUTO_INCREMENT,
    class_name VARCHAR(100) NOT NULL, -- e.g., Grade 6, Hifz Intensive Phase 1
    grade_level INT NOT NULL,
    CONSTRAINT pk_academic_classes PRIMARY KEY (class_id)
) ENGINE=InnoDB;

CREATE TABLE sections (
    section_id INT NOT NULL AUTO_INCREMENT,
    class_id INT NOT NULL,
    section_name VARCHAR(50) NOT NULL, -- e.g., Section A, Section B
    capacity INT NOT NULL,
    CONSTRAINT pk_sections PRIMARY KEY (section_id),
    CONSTRAINT fk_sections_classes FOREIGN KEY (class_id) REFERENCES academic_classes (class_id) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE students (
    student_id BIGINT NOT NULL AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    section_id INT NOT NULL,
    admission_number VARCHAR(100) NOT NULL,
    enrollment_date DATE NOT NULL,
    CONSTRAINT pk_students PRIMARY KEY (student_id),
    CONSTRAINT uq_student_user UNIQUE (user_id),
    CONSTRAINT uq_admission_number UNIQUE (admission_number),
    CONSTRAINT fk_students_users FOREIGN KEY (user_id) REFERENCES users (user_id) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_students_sections FOREIGN KEY (section_id) REFERENCES sections (section_id) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE subjects (
    subject_id INT NOT NULL AUTO_INCREMENT,
    subject_name VARCHAR(150) NOT NULL, -- e.g., Mathematics, Tajweed Principles
    is_core_islamic TINYINT(1) DEFAULT 0 NOT NULL,
    CONSTRAINT pk_subjects PRIMARY KEY (subject_id)
) ENGINE=InnoDB;

-- -----------------------------------------------------------------------------
-- DOMAIN: SPECIALIZED ISLAMIC MODULES (HIFZ, NAZRA & TARBIYAH)
-- -----------------------------------------------------------------------------
CREATE TABLE hifz_progress_matrix (
    record_id BIGINT NOT NULL AUTO_INCREMENT,
    student_id BIGINT NOT NULL,
    mudarris_id BIGINT NOT NULL,
    log_date DATE NOT NULL,
    sabak_surah INT NOT NULL,           -- Surah index number
    sabak_aya_start INT NOT NULL,
    sabak_aya_end INT NOT NULL,
    sabki_juz_start INT NOT NULL,       -- Recent revision checkpoint indices
    sabki_juz_end INT NOT NULL,
    manzil_juz_number INT NOT NULL,     -- Distant revision structural metrics
    fluency_score DECIMAL(5,2) NOT NULL, -- Percentage evaluating raw precision
    tajweed_score DECIMAL(5,2) NOT NULL, -- Evaluates strict compliance with articulation rules
    CONSTRAINT pk_hifz_matrix PRIMARY KEY (record_id),
    CONSTRAINT fk_hifz_student FOREIGN KEY (student_id) REFERENCES students (student_id) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_hifz_mudarris FOREIGN KEY (mudarris_id) REFERENCES users (user_id) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE tarbiyah_character_logs (
    log_id BIGINT NOT NULL AUTO_INCREMENT,
    student_id BIGINT NOT NULL,
    evaluator_id BIGINT NOT NULL,
    log_date DATE NOT NULL,
    salah_attendance_mask INT NOT NULL, -- Bitmask mapping 5 daily prayers (e.g., 11111 binary = 31 integer)
    ethical_discipline_score INT NOT NULL, -- Range 1 to 100 metric array
    community_service_minutes INT DEFAULT 0 NOT NULL,
    academic_alert_triggered TINYINT(1) DEFAULT 0 NOT NULL,
    CONSTRAINT pk_tarbiyah_logs PRIMARY KEY (log_id),
    CONSTRAINT fk_tarbiyah_student FOREIGN KEY (student_id) REFERENCES students (student_id) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_tarbiyah_evaluator FOREIGN KEY (evaluator_id) REFERENCES users (user_id) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT chk_discipline_range CHECK (ethical_discipline_score BETWEEN 0 AND 100)
) ENGINE=InnoDB;

-- -----------------------------------------------------------------------------
-- DOMAIN: TRANSACTIONAL FEE LEDGERS & FINANCIAL SCHEMAS
-- -----------------------------------------------------------------------------
CREATE TABLE fee_ledgers (
    ledger_id BIGINT NOT NULL AUTO_INCREMENT,
    student_id BIGINT NOT NULL,
    billing_period_year INT NOT NULL,
    billing_period_month INT NOT NULL,
    base_tuition_amount DECIMAL(12,2) NOT NULL,
    concession_amount DECIMAL(12,2) DEFAULT 0.00 NOT NULL,
    total_due_balance DECIMAL(12,2) NOT NULL,
    amount_paid_settled DECIMAL(12,2) DEFAULT 0.00 NOT NULL,
    payment_status_enum ENUM('UNPAID', 'PARTIAL', 'SETTLED', 'OVERDUE') DEFAULT 'UNPAID' NOT NULL,
    last_transaction_timestamp TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT pk_fee_ledgers PRIMARY KEY (ledger_id),
    CONSTRAINT fk_ledger_student FOREIGN KEY (student_id) REFERENCES students (student_id) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT chk_fee_calculations CHECK (total_due_balance = (base_tuition_amount - concession_amount))
) ENGINE=InnoDB;
