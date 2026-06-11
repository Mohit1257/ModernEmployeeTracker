# 🚀 EMP Track — Modern Employee Tracker

A professional Employee Management System built with **Spring Boot MVC**, **JSP**, **MySQL**, and a modern dark-themed UI.

---

## ✨ Features

- 📊 **Dashboard** — Live stats with animated counters and Chart.js graphs
- 👥 **Employee List** — Search, filter by department/status, sort, paginate
- ➕ **Add / Edit Employee** — Form validation with Spring MVC
- 👁️ **Employee Detail** — Full profile view
- 🔄 **Toggle Status** — Mark Active / Inactive instantly
- 🗑️ **Delete** — Custom confirm modal
- 🌙 **Dark / Light Theme** — Toggle with localStorage persistence
- 📱 **Responsive** — Works on mobile and desktop

---

## 🛠️ Tech Stack

| Layer    | Technology                  |
| -------- | --------------------------- |
| Backend  | Java 17, Spring Boot 2.7.15 |
| MVC      | Spring Web MVC              |
| ORM      | Spring Data JPA, Hibernate  |
| Database | MySQL 8                     |
| View     | JSP, JSTL                   |
| Frontend | HTML5, CSS3, Vanilla JS     |
| Charts   | Chart.js 4.4                |
| Icons    | Font Awesome 6.5            |
| Build    | Maven                       |
| Lombok   | Yes                         |

---

## 📁 Project Structure

```
ModernEmployeeTracker/
├── src/
│   └── main/
│       ├── java/com/mvc/
│       │   ├── controller/      # EmployeeController
│       │   ├── entity/          # Employee.java
│       │   ├── repo/            # EmployeeRepository
│       │   ├── service/         # EmployeeService
│       │   └── dto/             # DashboardStats
│       ├── resources/
│       │   ├── static/
│       │   │   ├── css/style.css
│       │   │   └── js/app.js
│       │   └── application.properties
│       └── webapp/
│           └── WEB-INF/
│               └── views/
│                   ├── fragments/
│                   │   ├── header.jsp
│                   │   └── footer.jsp
│                   ├── dashboard.jsp
│                   ├── employees.jsp
│                   ├── employee-form.jsp
│                   └── employee-detail.jsp
├── schema.sql
├── pom.xml
└── README.md
```

---

## ⚙️ Setup & Run

### Prerequisites

- Java 17+
- Maven 3.6+
- MySQL 8+

### 1. Database Setup

```sql
CREATE DATABASE employee_tracker;
```

Or run the provided `schema.sql` file:

```bash
mysql -u root -p < schema.sql
```

### 2. Configure Database

Edit `src/main/resources/application.properties`:

```properties
spring.datasource.url=jdbc:mysql://localhost:3306/employee_tracker
spring.datasource.username=your_username
spring.datasource.password=your_password
```

### 3. Run the Application

```bash
mvn spring-boot:run
```

Or in Eclipse/IntelliJ — Run as **Spring Boot App**.

### 4. Open in Browser

```
http://localhost:8080
```

---

## 📸 Screenshots

### 🏠 Dashboard
> Live stats with animated counters, department bar chart, and active vs inactive donut chart
![Dashboard](https://github.com/user-attachments/assets/2816da91-fc25-4f52-84c3-71d82f3c86ba)

---

### 👥 Employees List
> Search, filter by department/status, sort, paginate with action buttons

![Employees List](https://github.com/user-attachments/assets/d3ad8353-2c48-4266-a85c-be44ce6c4e98)

---

### ➕ Add / Edit Employee
> Clean form with validation — name, email, department, salary, location, joining date

![Add Employee](https://github.com/user-attachments/assets/7d10bb0c-52d8-4e7a-8938-8b6519596714)

---

## 🗄️ Database Schema

```sql
CREATE TABLE employee (
    id           BIGINT       NOT NULL AUTO_INCREMENT,
    name         VARCHAR(100) NOT NULL,
    email        VARCHAR(150) NOT NULL UNIQUE,
    department   VARCHAR(80)  NOT NULL,
    salary       DOUBLE       NOT NULL,
    location     VARCHAR(100),
    joining_date DATE         NOT NULL,
    status       VARCHAR(20)  NOT NULL DEFAULT 'Active',
    PRIMARY KEY (id)
);
```

---

## 👨‍💻 Author

Made with ❤️ by **Mohit**

---

## 📄 License

This project is open source and available under the [MIT License](LICENSE).
