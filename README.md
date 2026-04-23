# 📚 DevOps Attendance System

A comprehensive student attendance and assignment tracking web application built with **Flutter** and **Firebase**. This system allows students to mark attendance, submit assignments, view marks, and provide feedback to instructors.

## 🌐 Live Demo

**URL:** [https://my-devops-clone.web.app](https://my-devops-clone.web.app)

## ✨ Features

### 🔐 Authentication
- User registration with email/password
- Secure login system
- Session management with Firebase Auth

### 📊 Student Dashboard
- Student profile display (Name, Enrollment, Branch, Semester)
- Real-time attendance progress tracking
- Visual attendance percentage with progress bar
- Overall attendance summary (X/12 days)

### 📝 Assignment Management
- Track 3 assignments with submission status
- Submit assignments with one click
- Visual indicators (✅ Submitted / ⏳ Pending)
- Persistent submission records in Firestore

### 🎓 Marks Display
- Mid-term marks (24/30)
- End-semester marks tracking
- Practical and CAP marks
- Total marks calculation

### 💬 Feedback System
- Submit suggestions and feedback
- Admin view to see all student feedback
- Timestamp tracking for each submission
- Separate feedback collection in Firestore

### 📱 Additional Features
- Responsive web design
- Drawer navigation menu
- Logout functionality
- Real-time data updates

## 🛠️ Tech Stack

| Technology | Purpose |
|------------|---------|
| **Flutter** | Frontend framework for web |
| **Firebase Authentication** | User management |
| **Cloud Firestore** | Database for attendance, assignments, feedback |
| **Firebase Hosting** | Web deployment |

## 📁 Firebase Collections Structure

| Collection | Purpose | Fields |
|------------|---------|--------|
| `attendance` | Stores student attendance records | userId, email, timestamp, status, date |
| `assignments` | Tracks assignment submissions | userId, userEmail, assignmentId, submitted, submittedAt, fileUrl |
| `feedbacks` | Stores student feedback | userId, userEmail, feedback, timestamp, status |

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.0 or higher)
- Firebase account
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/GrandDuchessPalak/attendance-app.git
   cd attendance-app
