import { useState, useEffect } from 'react'
import axios from 'axios'
import { BrowserRouter as Router, Routes, Route, Link, Navigate, useLocation } from 'react-router-dom'
import UserDashboard from './pages/UserDashboard'
import AdminDashboard from './pages/AdminDashboard'
import Settings from './pages/Settings'
import Login from './pages/Login'

axios.interceptors.request.use(
  config => {
    const user = JSON.parse(sessionStorage.getItem('user'))
    if (user?.accessToken) config.headers.Authorization = `Bearer ${user.accessToken}`
    return config
  },
  error => Promise.reject(error)
)

const NavLink = ({ to, children }) => {
  const location = useLocation()
  const active = location.pathname === to
  return (
    <Link
      to={to}
      style={{
        color: active ? 'white' : 'rgba(255,255,255,0.65)',
        textDecoration: 'none',
        fontSize: '14px',
        fontWeight: active ? '600' : '400',
        padding: '6px 12px',
        borderRadius: '6px',
        background: active ? 'rgba(255,255,255,0.15)' : 'transparent',
        transition: 'all 0.15s ease',
      }}
    >
      {children}
    </Link>
  )
}

const Navbar = ({ user, onLogout }) => (
  <nav style={{
    background: '#1d4ed8',
    padding: '0 24px',
    display: 'flex',
    justifyContent: 'space-between',
    alignItems: 'center',
    height: '56px',
    boxShadow: '0 2px 8px rgba(0,0,0,0.15)',
  }}>
    {/* Left — brand + nav links */}
    <div style={{ display: 'flex', alignItems: 'center', gap: '4px' }}>
      <Link to="/" style={{ textDecoration: 'none', marginRight: '16px' }}>
        <span style={{ color: 'white', fontWeight: '700', fontSize: '16px', letterSpacing: '-0.3px' }}>
          📘 Learning Tracker
        </span>
      </Link>
      {user?.role === 'USER' && <NavLink to="/user">My Dashboard</NavLink>}
      {user?.role === 'ADMIN' && <NavLink to="/admin">Admin Dashboard</NavLink>}
    </div>

    {/* Right — user + logout */}
    <div style={{ display: 'flex', alignItems: 'center', gap: '12px' }}>
      {user ? (
        <>
          <Link
            to="/settings"
            style={{
              display: 'flex', alignItems: 'center', gap: '8px',
              textDecoration: 'none', color: 'white',
            }}
          >
            <div style={{
              width: '30px', height: '30px', borderRadius: '50%',
              background: 'rgba(255,255,255,0.2)',
              display: 'flex', alignItems: 'center', justifyContent: 'center',
              fontSize: '13px', fontWeight: '700', color: 'white',
              flexShrink: 0,
            }}>
              {user.fullName.charAt(0).toUpperCase()}
            </div>
            <span style={{ fontSize: '14px', color: 'rgba(255,255,255,0.9)' }}>{user.fullName}</span>
          </Link>

          <button
            onClick={onLogout}
            style={{
              padding: '6px 16px',
              background: 'rgba(255,255,255,0.12)',
              color: 'white',
              border: '1.5px solid rgba(255,255,255,0.3)',
              borderRadius: '8px',
              cursor: 'pointer',
              fontSize: '13px',
              fontWeight: '500',
              transition: 'all 0.15s ease',
            }}
            onMouseOver={e => e.currentTarget.style.background = 'rgba(255,255,255,0.22)'}
            onMouseOut={e => e.currentTarget.style.background = 'rgba(255,255,255,0.12)'}
          >
            Logout
          </button>
        </>
      ) : (
        <Link
          to="/login"
          style={{
            padding: '6px 16px',
            background: 'rgba(255,255,255,0.15)',
            color: 'white',
            border: '1.5px solid rgba(255,255,255,0.3)',
            borderRadius: '8px',
            textDecoration: 'none',
            fontSize: '13px',
            fontWeight: '500',
          }}
        >
          Login
        </Link>
      )}
    </div>
  </nav>
)

function App() {
  const [user, setUser] = useState(null)

  useEffect(() => {
    const saved = sessionStorage.getItem('user')
    if (saved) setUser(JSON.parse(saved))
  }, [])

  const handleLogin = (userData) => {
    setUser(userData)
    sessionStorage.setItem('user', JSON.stringify(userData))
  }

  const handleLogout = () => {
    setUser(null)
    sessionStorage.removeItem('user')
  }

  return (
    <Router>
      <Navbar user={user} onLogout={handleLogout} />
      <main style={{ padding: '24px' }}>
        <Routes>
          <Route path="/" element={
            <div>
              <h1 style={{ color: '#0f172a' }}>Welcome to Learning Tracker</h1>
              {!user && <p>Please <Link to="/login">login</Link> to access your dashboard.</p>}
              {user && <p style={{ color: '#64748b' }}>Go to your dashboard via the menu above.</p>}
            </div>
          } />
          <Route path="/login" element={user ? <Navigate to={user.role === 'ADMIN' ? '/admin' : '/user'} /> : <Login onLogin={handleLogin} />} />
          <Route path="/user" element={user?.role === 'USER' ? <UserDashboard userId={user.id} /> : <Navigate to="/login" />} />
          <Route path="/admin" element={user?.role === 'ADMIN' ? <AdminDashboard /> : <Navigate to="/login" />} />
          <Route path="/settings" element={user ? <Settings user={user} /> : <Navigate to="/login" />} />
        </Routes>
      </main>
    </Router>
  )
}

export default App
