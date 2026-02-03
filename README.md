# HealthGuard 🏥

A feature-rich mobile application frontend built with **Flutter**, designed to facilitate communication between patients, doctors, and family members. This project demonstrates a modular UI architecture for tracking vital signs and managing medical records.

> **Note:** This repository focuses on the **Presentation Layer (Frontend)** and UI logic. It is designed to consume RESTful APIs for backend services.

## 📱 Project Overview

HealthGuard addresses the complexity of modern healthcare monitoring by providing tailored interfaces for different stakeholders. The application implements strict role-based navigation and data visualization to make health trends accessible.

## 🚀 Key Features

* **Multi-Role Architecture:** Distinct UI flows and dashboards for **Patients**, **Doctors**, **Family Members**, and **Admins**.
* **Health Data Visualization:** Integrated charting widgets (`vital_chart_widget`, `overall_health_chart`) to visualize complex medical data like heart rate or blood pressure over time.
* **Medical Record Management:** structured models for handling Medical Reports, Monthly Summaries, and Vital Logs.
* **Family Monitoring:** Dedicated screens for family members to track the health status of their dependents.
* **Authentication Flow:** Complete UI implementation for Login and Registration workflows managed via a dedicated `AuthService`.

## 🏗 Architecture & Design

The codebase follows a scalable **Folder-by-Feature** structure to ensure maintainability:

* **Screens:** Segregated UI logic for each user role (Admin, Doctor, Patient, Family).
* **Widgets:** Reusable UI components, including custom chart implementations for health metrics.
* **Models:** Strongly typed Data Transfer Objects (DTOs) for robust data handling (e.g., `MedicalReport`, `VitalDataPoint`).
* **Services:** Abstraction layer for future backend integration (Authentication, API calls).

## 🛠 Tech Stack

* **Framework:** Flutter
* **Language:** Dart
* **Architecture:** Component-Based / Modular
* **Visualization:** Custom Charting Widgets
