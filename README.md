<div align="center">

# 📚 Learning Tracker

**A full-stack platform to assign, track and evaluate employee learning progress.**

Spring Boot · PostgreSQL · React · JWT Authentication

[![Java](https://img.shields.io/badge/Java-17-ED8B00?style=flat&logo=openjdk&logoColor=white)](https://www.oracle.com/java/)
[![Spring Boot](https://img.shields.io/badge/Spring%20Boot-3.4.3-6DB33F?style=flat&logo=springboot&logoColor=white)](https://spring.io/projects/spring-boot)
[![React](https://img.shields.io/badge/React-18-61DAFB?style=flat&logo=react&logoColor=black)](https://react.dev/)
[![Vite](https://img.shields.io/badge/Vite-5-646CFF?style=flat&logo=vite&logoColor=white)](https://vitejs.dev/)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-16-4169E1?style=flat&logo=postgresql&logoColor=white)](https://www.postgresql.org/)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](#license)

</div>

---

## 📖 Overview

**Learning Tracker** is an internal L&D (Learning & Development) platform that lets organizations assign structured courses to employees, track their progress unit-by-unit, quiz them on the material, and generate reports on individual and team-wide learning outcomes.

It ships with a **Spring Boot REST API** on the backend and a **React (Vite)** single-page app on the frontend, backed by **PostgreSQL** with version-controlled schema migrations via **Flyway**.

Two user roles are supported out of the box:

| Role | Capabilities |
|---|---|
| 👤 **USER** (employee) | Browse assigned courses, read course materials (PDFs), complete units, take quizzes, submit course feedback |
| 🛠️ **ADMIN** | Create/delete courses & units, upload learning materials, assign courses to employees, build quizzes, view employee reports and progress |

---

## ✨ Features

- 🔐 **JWT-based authentication** with role-based authorization (`USER` / `ADMIN`)
- 📂 **Course & unit management** — create courses, organize them into units, upload PDF learning material
- ✅ **Progress tracking** — mark units complete/incomplete, per-user course progress
- 📝 **Quizzes** — attach quiz questions & multiple-choice options to units, capture and summarize quiz results
- 💬 **Course feedback** — employees can rate and leave feedback on completed courses
- 📊 **Employee reports** — admins can pull individual progress reports across all assigned courses
- 🗃️ **Database-driven course content**, version-controlled with Flyway migrations
- 📑 **Interactive API docs** via Swagger / OpenAPI
- 🐳 **Docker Compose** setup for a local PostgreSQL instance

---

## 🏗️ Tech Stack

**Backend**
- Java 17 · Spring Boot 3.4.3
- Spring Web, Spring Data JPA, Spring Security
- PostgreSQL + Flyway (schema migrations)
- JWT (`jjwt`) for stateless authentication
- MapStruct + Lombok for clean DTO mapping
- springdoc-openapi (Swagger UI)

**Frontend**
- React 18 + React Router 6
- Vite 5
- Axios for API communication

**Infrastructure**
- Docker / Docker Compose (PostgreSQL container)

---

## 📁 Project Structure

```
learning-tracker/
├── backend/                     # Spring Boot REST API
│   ├── src/main/java/com/learning/tracker/
│   │   ├── config/              # App-level configuration
│   │   ├── controller/          # REST controllers (Auth, Course, Employee, User)
│   │   ├── dto/                 # Data transfer objects
│   │   ├── mapper/               # MapStruct mappers
│   │   ├── model/                # JPA entities
│   │   ├── repository/           # Spring Data repositories
│   │   ├── security/             # JWT filter, provider, user details service
│   │   └── service/               # Business logic
│   ├── src/main/resources/
│   │   ├── db/migration/          # Flyway SQL migrations
│   │   └── lessons/                # Seeded course material (PDFs)
│   ├── docker-compose.yaml         # Local PostgreSQL container
│   └── pom.xml
└── frontend/                     # React (Vite) SPA
    ├── src/
    │   ├── pages/                 # Login, UserDashboard, AdminDashboard, Settings
    │   ├── App.jsx
    │   └── main.jsx
    ├── index.html
    └── package.json
```

---

## 🚀 Getting Started

### Prerequisites

- [Java 17+](https://adoptium.net/)
- [Maven](https://maven.apache.org/) (or use the included `mvnw` wrapper, if present)
- [Node.js 18+](https://nodejs.org/) and npm
- [Docker](https://www.docker.com/) & Docker Compose

### 1. Clone the repository

```bash
git clone https://github.com/NikosKatrakoulis/learning-tracker.git
cd learning-tracker
```

### 2. Start the database

```bash
cd backend
docker compose up -d
```

This spins up a PostgreSQL 16 container on `localhost:5432` with:
- database: `learning_tracker`
- user / password: `root` / `root`

> ⚠️ These are local development defaults defined in `docker-compose.yaml`. Override them via environment variables or a separate `application-prod.properties` profile before deploying anywhere real.

### 3. Run the backend

```bash
# from the backend/ directory
mvn spring-boot:run
```

Flyway will automatically apply all migrations in `db/migration` on startup, seeding the database with sample courses, units, quizzes, and users.

The API will be available at **`http://localhost:8080`**, with interactive documentation at:

```
http://localhost:8080/swagger-ui.html
```

### 4. Run the frontend

```bash
cd frontend
npm install
npm run dev
```

The SPA will be available at **`http://localhost:5173`** by default (Vite's default dev port), and it talks to the backend via Axios.

---

## 🔌 API Overview

All endpoints are prefixed with `/api` and secured with JWT (except `/api/auth/login`).

| Resource | Endpoint | Description |
|---|---|---|
| Auth | `POST /api/auth/login` | Authenticate and receive a JWT |
| Courses | `GET /api/courses` | List all courses |
| Courses | `POST /api/courses` | Create a course *(admin)* |
| Courses | `GET /api/courses/{courseId}/units` | List units of a course |
| Courses | `POST /api/courses/{courseId}/units` | Add a unit to a course *(admin)* |
| Courses | `POST /api/courses/{courseId}/quiz-units` | Create a quiz unit *(admin)* |
| Courses | `GET /api/courses/units/{unitId}/quiz` | Fetch quiz for a unit |
| Courses | `GET/POST /api/courses/units/{unitId}/pdf` | Fetch/upload unit PDF material |
| Courses | `DELETE /api/courses/{courseId}` | Delete a course *(admin)* |
| Courses | `GET /api/courses/{courseId}/feedback` | List feedback for a course |
| Employees | `GET /api/employees` | List all employees *(admin)* |
| Employees | `GET /api/employees/{userId}/report` | Get an employee's progress report *(admin)* |
| Users | `POST /api/users` | Create a user |
| Users | `GET /api/users/{userId}/courses` | List a user's assigned courses |
| Users | `POST /api/users/{userId}/courses/{courseId}` | Assign a course to a user *(admin)* |
| Users | `POST /api/users/{userId}/units/{unitId}/complete` | Mark a unit as complete |
| Users | `POST /api/users/{userId}/units/{unitId}/quiz-result` | Submit a quiz result |
| Users | `POST /api/users/{userId}/courses/{courseId}/feedback` | Submit course feedback |

For the full, always-up-to-date list of endpoints and request/response schemas, check the Swagger UI once the backend is running.

---

## 🗄️ Database Schema

Schema evolution is fully managed through Flyway migrations found in `backend/src/main/resources/db/migration`, including:

- Initial schema & seed data
- Quiz schema (questions, options, results)
- Seeded courses for **Java**, **JavaScript**, and **Databases**
- Course feedback support
- Storing lesson PDFs directly in the database

---

## 🤝 Contributing

Contributions are welcome! To contribute:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## 📄 License

This project currently has no license file. Consider adding one (e.g. [MIT](https://choosealicense.com/licenses/mit/)) to clarify how others can use this project.

---

## 👤 Author

**Nikos Katrakoulis**
[GitHub @NikosKatrakoulis](https://github.com/NikosKatrakoulis)
