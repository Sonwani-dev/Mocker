# 📚 MockPrep – Mock Test Website (In Development)

MockPrep is a web-based platform designed to help students and professionals prepare for competitive exams, job interviews, and skill assessments through structured **mock tests**, **timed quizzes**, and **performance tracking**.

> 🚧 This project is currently in development. Contributions and feedback are welcome!

---

## 🧾 Project Description

**MockPrep** aims to bridge the gap between learning and real-world exam readiness by providing a flexible and scalable **mock test environment**. Whether you're preparing for technical interviews, entrance exams, or certification tests, MockPrep helps simulate the pressure and format of real assessments.

### ✅ Core Features (Planned)

- 🔐 **User Authentication** – Signup/login system with role-based access
- 📝 **Mock Test Creation** – Admin can create and categorize tests
- 🧠 **Dynamic Question Bank** – MCQs, coding questions, and more
- ⏳ **Timed Test Mode** – Countdown and auto-submit on timeout
- 📊 **Detailed Results** – Score analysis, correct answers, time taken
- 📂 **Category-wise Tests** – Java, Aptitude, Reasoning, DBMS, etc.
- 🌙 **Dark Mode Support** *(optional)*

---

## 🚀 Tech Stack (Planned / In Progress)

| Layer | Technology |
|-------|------------|
| Frontend | React / Angular (TBD), HTML, CSS, Bootstrap or Tailwind |
| Backend | Java with Spring Boot |
| Database | MySQL or PostgreSQL |
| Authentication | JWT / Spring Security |
| Testing | JUnit, Mockito |
| Deployment | Render / Heroku / AWS (Future) |
| Version Control | Git + GitHub |

---

## 🧪 Current Progress

- [x] Project Structure Initialized
- [x] Basic Frontend Layout (Home, Login, Register)
- [ ] Admin Panel for Test Management
- [ ] Test Taking Interface
- [ ] Timer & Auto-Submit Logic
- [ ] Score Calculation and Result Screen
- [ ] User Dashboard with History

---

## 📸 Screenshots *(coming soon)*

UI mockups and screenshots will be added as development progresses.

---

## 🛠️ Installation (For Developers)

```bash
# Clone the repository
git clone https://github.com/yourusername/mockprep.git

# Navigate into the folder
cd mockprep

# Start backend (if separate folder)
cd backend
mvn spring-boot:run

# Start frontend
cd ../frontend
npm install
npm start
