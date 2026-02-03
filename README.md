# HealthGuard 🏥

A feature-rich mobile application frontend built with **Flutter**, designed to facilitate communication between patients, doctors, and family members. This project demonstrates a modular UI architecture for tracking vital signs and managing medical records.

> **Note:** This repository focuses on the **Presentation Layer (Frontend)** and UI logic. It is designed to consume RESTful APIs for backend services.

## 📱 Project Overview

HealthGuard addresses the complexity of modern healthcare monitoring by providing tailored interfaces for different stakeholders. The application implements strict role-based navigation and data visualization to make health trends accessible and actionable.

## 🚀 Key Features

* **Multi-Role Experience:** Distinct UI flows and dashboards tailored specifically for **Patients** (monitoring), **Doctors** (analysis), and **Family Members** (caregiving).
* **Advanced Data Visualization:** Integrated custom charting components to visualize complex medical trends, such as heart rate variability and blood pressure history, in real-time.
* **Medical Record Management:** Structured interfaces for viewing and managing comprehensive health data, including Lab Reports, Monthly Summaries, and Daily Vital Logs.
* **Family Monitoring System:** Dedicated workflows allowing guardians to track the health status and medication adherence of their dependents.
* **Secure Authentication Flow:** Complete UI implementation for Login and Registration, designed to handle token-based authentication and session management.

## 🏗 Architecture & Design

The codebase follows a scalable **Component-Based Architecture** to ensure maintainability and UI consistency:

* **Role-Based Separation:** The UI logic is segregated by user role, ensuring that patients and doctors see strictly relevant information without logic coupling.
* **Reusable Widget Library:** A collection of custom-built UI components (Charts, Cards, Input Fields) used across the app to maintain a consistent Design System.
* **Service Abstraction:** A dedicated layer handles communication logic, preparing the app for seamless integration with backend APIs and authentication providers.
* **Strong Typing:** Utilizes strict data models to ensure type safety when handling complex medical data structures.

## 🛠 Tech Stack

* **Framework:** Flutter
* **Language:** Dart
* **Architecture:** Modular / Component-Based
* **Visualization:** Custom Charting Libraries
