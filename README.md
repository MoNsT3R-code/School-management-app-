# School-management-app

# Al-Noor Islamic Academy - Student Management Platform

A multi-tenant, cloud-based educational resource planning (ERP) platform designed for Al-Noor Islamic Academy. The system integrates standard school administrative modules with specialized Islamic tracking systems such as Hifz and Tarbiyah logs. It features a decoupled architectural pattern using Python, JavaScript, SQL, HTML, and high-performance native C extensions.

---

## Repository Structure and Module Index

The project codebase is organized into the following components:

### Frontend and Interface Layers
* **frontend.html:** The structural user interface layout built with HTML and styled via utility frameworks to reflect the institutional identity.
* **Management.js:** Scripting logic for handling the frontend user experience, role validation tracking, and asynchronous client-to-server API updates.

### Core Database Configuration
* **database.sql:** Transactional relational database schema definition compiled for MariaDB/PostgreSQL. It sets up strict constraints for role-based access control (RBAC), academic course routing, specialized Hifz metrics matrices, and financial ledger data tables.

### Processing Engines and Pipelines
* **file_io_core.c:** A native C source code extension optimized for processing performance-critical operations, such as matching raw binary biometric attendance stream values.
* **attendance.py:** Ingestion script managing standard morning and mid-day prayer attendance operations using Python's `ctypes` bindings to interface with the compiled C library.
* **finance.py:** Automated billing pipeline that calculates tuition parameters, processes concessions, tracks balances, and records transactional histories into financial logs.
* **metrices.py:** Analytical data aggregation engine utilizing data manipulation tools to compute weighted student grades from quizzes, assignments, and term examinations.
* **report.py:** Automated document generation utility that processes academic analytics into report cards and outputs high-contrast progress charts for the parent/student dashboard portal.

### Documentation
* **README.md:** This repository guide and technical implementation manual.

---

## System Requirements

To deploy and run the modules in this directory, ensure the host environment meets the following baseline configurations:
* **Operating System:** Linux, macOS, or Windows (Linux environment recommended for C shared-library compilation).
* **Database Engine:** MariaDB 10.5+ or PostgreSQL 14+.
* **Python Runtime:** Python 3.8+ equipped with standard math, data analysis, and plotting library distributions.
* **C Compiler:** GCC or Clang toolchains for compilation steps.

---

## Deployment and Execution Guide

### 1. Database Initialization
Import the structured schema matrices into your active relational database instance:
```bash
mysql -u root -p < database.sql


2. Compilation of Native C Extension
​Compile the performance-critical file I/O layer into a shared library module inside your deployment platform workspace:

# For Linux environments
gcc -shared -o file_io_core.so -fPIC file_io_core.c

# For Windows environments
gcc -shared -o file_io_core.dll file_io_core.c



3. Executing Core Subsystems

### ​Run specific backend pipelines directly from your standard console window loop to execute target processes:


python3 attendance.py


### To run the weighted academic grading metrics:

python3 metrices.py


### To run the financial billing cycle and update student balances:


python3 finance.py


### To generate performance visualizations and compiled student report logs:


python3 report.py

4. Architectural Highlights

​Decoupled Architecture: Client-side rendering layouts are separated cleanly from backend analytical code, allowing cross-functional operations to execute independently.

​Memory Optimization: Heavy data aggregation routines use sequential file streaming configurations to keep operational memory costs flat during long-running tracking periods.

​Input Validation Boundaries: Text entries pass through strict string filter logic to block syntax anomalies or malicious character sequences before data hits database storage nodes.