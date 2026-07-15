import { useState } from 'react'
import axios from 'axios'

const Settings = ({ user }) => {
  const [oldPassword, setOldPassword] = useState('')
  const [newPassword, setNewPassword] = useState('')
  const [confirmPassword, setConfirmPassword] = useState('')
  const [showPassword, setShowPassword] = useState(false)
  const [message, setMessage] = useState('')
  const [error, setError] = useState('')

  const handlePasswordChange = (e) => {
    e.preventDefault()
    setMessage('')
    setError('')

    if (newPassword !== confirmPassword) {
      setError('Passwords do not match')
      return
    }

    if (newPassword.length < 4) {
      setError('Password must be at least 4 characters long')
      return
    }

    axios.put(`/api/users/${user.id}/password`, { 
      oldPassword: oldPassword,
      password: newPassword 
    })
      .then(() => {
        setMessage('Password updated successfully!')
        setOldPassword('')
        setNewPassword('')
        setConfirmPassword('')
      })
      .catch(err => {
        setError('Error updating password: ' + (err.response?.data?.message || err.message))
      })
  }

  const togglePasswordVisibility = () => {
    setShowPassword(!showPassword)
  }

  const inputStyle = { 
    width: '100%', 
    padding: '8px', 
    boxSizing: 'border-box' 
  }

  const fieldContainerStyle = { 
    position: 'relative', 
    display: 'flex', 
    alignItems: 'center' 
  }

  const visibilityButtonStyle = {
    position: 'absolute',
    right: '5px',
    background: 'none',
    border: 'none',
    cursor: 'pointer',
    fontSize: '12px',
    color: '#007bff'
  }

  return (
    <div style={{ maxWidth: '400px', margin: '20px auto', padding: '20px', border: '1px solid #ccc', borderRadius: '8px' }}>
      <h3>Settings</h3>
      <p>Logged in as: <strong>{user.fullName}</strong> ({user.username})</p>
      
      <div style={{ marginTop: '20px' }}>
        <h4>Change Password</h4>
        <form onSubmit={handlePasswordChange} style={{ display: 'grid', gridTemplateColumns: '1fr', gap: '10px' }}>
          <div>
            <label>Old Password:</label>
            <input
              type="password"
              value={oldPassword}
              onChange={e => setOldPassword(e.target.value)}
              required
              style={inputStyle}
            />
          </div>
          <div>
            <label>New Password:</label>
            <div style={fieldContainerStyle}>
              <input
                type={showPassword ? "text" : "password"}
                value={newPassword}
                onChange={e => setNewPassword(e.target.value)}
                required
                style={inputStyle}
              />
              <button 
                type="button" 
                onClick={togglePasswordVisibility}
                style={visibilityButtonStyle}
              >
                {showPassword ? "Hide" : "Show"}
              </button>
            </div>
          </div>
          <div>
            <label>Confirm Password:</label>
            <div style={fieldContainerStyle}>
              <input
                type={showPassword ? "text" : "password"}
                value={confirmPassword}
                onChange={e => setConfirmPassword(e.target.value)}
                required
                style={inputStyle}
              />
            </div>
          </div>
          {message && <p style={{ color: 'green' }}>{message}</p>}
          {error && <p style={{ color: 'red' }}>{error}</p>}
          <button type="submit" style={{ padding: '10px', backgroundColor: '#007bff', color: 'white', border: 'none', borderRadius: '4px', cursor: 'pointer' }}>
            Update Password
          </button>
        </form>
      </div>
    </div>
  )
}

export default Settings
