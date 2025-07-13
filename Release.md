# Al-Afiya Rehabilitation Center Management System

A modern, full-stack application for managing patient care, treatments, payments, and notifications at rehabilitation centers.

---

## 🚀 Features

- **User Authentication:** Secure login and registration with Supabase Auth.
- **Patient Management:** Register, edit, and manage patient profiles, including status and payment info.
- **Treatment Tracking:** Record, view, and analyze treatments for each patient.
- **Payment Management:** Track payments, update payment status, and view revenue statistics.
- **Discharge Management:** Discharge and reactivate patients, with reasons and notes.
- **Notification Center:** Automated notifications for overdue payments, with priority levels and management tools.
- **Dashboard:** Overview of key metrics—active patients, revenue, pending payments, discharges, and treatments.
- **Responsive UI:** Modern, mobile-friendly interface using Tailwind CSS and Lucide icons.

---

## 🛠️ Improvements

- **Role-based Access:** Row-level security (RLS) policies for users, patients, payments, treatments, and notifications.
- **Performance:** Indexed key columns in database tables for faster queries.
- **Error Handling:** Improved error messages and loading states throughout the app.

---

## 🐛 Fixes

- Fixed RLS policies to allow proper user registration and profile management.
- Ensured only authenticated users can access and modify their own data.
- Addressed issues with notification duplication and session handling.

---

## 📦 Tech Stack

- React 18, TypeScript, Vite
- Supabase (Postgres, Auth, RLS)
- Tailwind CSS, Lucide React Icons
- date-fns for date formatting

---

## 📄 Getting Started

1. **Clone the repository:**
   ```sh
   git clone https://github.com/your-username/Alafiya-core.git
   cd Alafiya-core
   ```

2. **Install dependencies:**
   ```sh
   npm install
   ```

3. **Configure environment variables:**
   - Copy `.env.example` to `.env` and fill in your Supabase credentials.

4. **Run the development server:**
   ```sh
   npm run dev
   ```

5. **Open in your browser:**
   - Visit [http://localhost:5173](http://localhost:5173)

---

## 📚 Documentation

- See [`Release.md`](./Release.md) for the latest release notes.
- For more details, check the code comments and Supabase schema.

---

## 🙏 Acknowledgements

- [Supabase](https://supabase.com/)
- [React](https://react.dev/)
- [Tailwind CSS](https://tailwindcss.com/)
- [Lucide Icons](https://lucide.dev/)
- [date-fns](https://date-fns.org/)

---

## 📜 License

This project is licensed under the MIT