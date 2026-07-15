import { useState, useEffect } from 'react'
import axios from 'axios'

// ── Shared styles ─────────────────────────────────────────────────────────────

const input = {
  width: '100%', padding: '10px 14px', fontSize: '14px',
  border: '1.5px solid #e2e8f0', borderRadius: '8px',
  outline: 'none', boxSizing: 'border-box', color: '#1e293b', background: 'white',
}

const label = {
  display: 'block', fontSize: '13px', fontWeight: '600', color: '#475569', marginBottom: '6px',
}

const Field = ({ label: text, children }) => (
  <div style={{ marginBottom: '14px' }}>
    <label style={label}>{text}</label>
    {children}
  </div>
)

const focusBlue = e => { e.target.style.borderColor = '#1d4ed8' }
const blurGray  = e => { e.target.style.borderColor = '#e2e8f0' }

const StyledInput = ({ type = 'text', placeholder, value, onChange, required }) => (
  <input type={type} placeholder={placeholder} value={value} onChange={onChange} required={required}
    style={input} onFocus={focusBlue} onBlur={blurGray} />
)

const StyledTextarea = ({ placeholder, value, onChange }) => (
  <textarea placeholder={placeholder} value={value} onChange={onChange}
    style={{ ...input, minHeight: '72px', resize: 'vertical' }}
    onFocus={focusBlue} onBlur={blurGray} />
)

const StyledSelect = ({ value, onChange, required, disabled, children }) => (
  <select value={value} onChange={onChange} required={required} disabled={disabled}
    style={{ ...input, cursor: disabled ? 'not-allowed' : 'pointer', color: value ? '#1e293b' : '#94a3b8' }}
    onFocus={focusBlue} onBlur={blurGray}>
    {children}
  </select>
)

const PrimaryBtn = ({ type = 'button', onClick, children }) => (
  <button type={type} onClick={onClick}
    style={{
      width: '100%', padding: '11px', background: '#1d4ed8', color: 'white',
      border: 'none', borderRadius: '8px', fontSize: '14px', fontWeight: '600', cursor: 'pointer',
    }}
    onMouseOver={e => e.currentTarget.style.background = '#1e40af'}
    onMouseOut={e => e.currentTarget.style.background = '#1d4ed8'}
  >
    {children}
  </button>
)

const DeleteBtn = ({ onClick, label: text = 'Delete' }) => (
  <button onClick={onClick}
    style={{
      padding: '5px 12px', fontSize: '12px', fontWeight: '600',
      background: '#fef2f2', color: '#b91c1c',
      border: '1.5px solid #fecaca', borderRadius: '6px', cursor: 'pointer',
      whiteSpace: 'nowrap',
    }}
    onMouseOver={e => { e.currentTarget.style.background = '#fee2e2' }}
    onMouseOut={e => { e.currentTarget.style.background = '#fef2f2' }}
  >
    {text}
  </button>
)

const EmptyState = ({ icon, text }) => (
  <div style={{
    display: 'flex', flexDirection: 'column', alignItems: 'center',
    justifyContent: 'center', padding: '48px 20px',
    border: '2px dashed #e2e8f0', borderRadius: '12px', color: '#94a3b8', textAlign: 'center',
  }}>
    <span style={{ fontSize: '32px', marginBottom: '10px' }}>{icon}</span>
    <p style={{ margin: 0, fontSize: '14px' }}>{text}</p>
  </div>
)

const Avatar = ({ name, active }) => (
  <div style={{
    width: '36px', height: '36px', borderRadius: '50%', flexShrink: 0,
    background: active ? 'rgba(255,255,255,0.2)' : '#e0e7ff',
    display: 'flex', alignItems: 'center', justifyContent: 'center',
    fontSize: '14px', fontWeight: '700', color: active ? 'white' : '#3b82f6',
  }}>
    {name.charAt(0).toUpperCase()}
  </div>
)

const ItemCard = ({ children, accent = '#e2e8f0' }) => (
  <div style={{
    display: 'flex', alignItems: 'center', justifyContent: 'space-between', gap: '12px',
    padding: '12px 14px', marginBottom: '8px', borderRadius: '10px',
    background: 'white', border: '1.5px solid #e2e8f0',
    borderLeft: `4px solid ${accent}`,
    boxShadow: '0 1px 3px rgba(0,0,0,0.05)',
  }}>
    {children}
  </div>
)

// ── AdminDashboard ────────────────────────────────────────────────────────────

const AdminDashboard = () => {
  const [employees, setEmployees] = useState([])
  const [courses, setCourses] = useState([])
  const [availableCourses, setAvailableCourses] = useState([])
  const [selectedReport, setSelectedReport] = useState(null)
  const [newUser, setNewUser] = useState({ username: '', password: '', fullName: '', role: 'USER' })
  const [newUnit, setNewUnit] = useState({ title: '', section: '', content: '', orderIndex: 0, courseId: '' })
  const [pdfFile, setPdfFile] = useState(null)
  const [lessonType, setLessonType] = useState('lesson')
  const [quizQuestions, setQuizQuestions] = useState([{ questionText: '', correctOption: 'a', orderIndex: 1, options: [{ optionLetter: 'a', optionText: '' }, { optionLetter: 'b', optionText: '' }, { optionLetter: 'c', optionText: '' }, { optionLetter: 'd', optionText: '' }] }])
  const [newCourse, setNewCourse] = useState({ title: '', description: '' })
  const [assignment, setAssignment] = useState({ userId: '', courseId: '' })
  const [notification, setNotification] = useState({ message: '', type: '', visible: false })
  const [activeTab, setActiveTab] = useState('users')
  const [mode, setMode] = useState('add')
  const [unitsForSelectedCourse, setUnitsForSelectedCourse] = useState([])
  const [selectedCourseForLessons, setSelectedCourseForLessons] = useState('')
  const [employeeCourses, setEmployeeCourses] = useState([])
  const [selectedEmployeeForUnassign, setSelectedEmployeeForUnassign] = useState('')
  const [confirmModal, setConfirmModal] = useState({ visible: false, message: '', onConfirm: null })
  const [quizSummaries, setQuizSummaries] = useState([])
  const [courseFeedbacks, setCourseFeedbacks] = useState({}) // courseId → feedback[]

  useEffect(() => { fetchEmployees(); fetchCourses() }, [])

  const fetchAllFeedbacks = (courseList) => {
    courseList.forEach(c =>
      axios.get(`/api/courses/${c.id}/feedback`)
        .then(res => setCourseFeedbacks(prev => ({ ...prev, [c.id]: res.data })))
        .catch(() => setCourseFeedbacks(prev => ({ ...prev, [c.id]: [] })))
    )
  }

  const showNotification = (message, type = 'success') => setNotification({ message, type, visible: true })
  const hideNotification = () => setNotification(prev => ({ ...prev, visible: false }))
  const fetchEmployees = () => axios.get('/api/employees').then(res => setEmployees(res.data))
  const fetchCourses  = () => axios.get('/api/courses').then(res => setCourses(res.data))
  const loadReport    = (userId) => {
    axios.get(`/api/employees/${userId}/report`).then(res => setSelectedReport(res.data))
    axios.get(`/api/users/${userId}/quiz-summaries`).then(res => setQuizSummaries(res.data)).catch(() => setQuizSummaries([]))
  }

  const handleAddUser = (e) => {
    e.preventDefault()
    axios.post('/api/users', newUser)
      .then(() => { showNotification('User added successfully!'); setNewUser({ username: '', password: '', fullName: '', role: 'USER' }); fetchEmployees() })
      .catch(err => showNotification('Error adding user: ' + (err.response?.data?.message || err.message), 'error'))
  }

  const handleAddUnit = (e) => {
    e.preventDefault()
    const { courseId, ...unitData } = newUnit
    if (!courseId) { showNotification('Please select a course', 'error'); return }
    axios.post(`/api/courses/${courseId}/units`, { ...unitData, unitType: 'lesson' })
      .then(res => {
        const unitId = res.data.id
        const afterUpload = () => {
          showNotification('Lesson added successfully!')
          axios.get(`/api/courses/${courseId}/units`).then(r => {
            setUnitsForSelectedCourse(r.data)
            const nextIndex = r.data.length > 0 ? Math.max(...r.data.map(u => u.orderIndex)) + 1 : 1
            setNewUnit(prev => ({ ...prev, title: '', section: '', content: '', orderIndex: nextIndex }))
            setPdfFile(null)
          })
        }
        if (pdfFile) {
          const formData = new FormData()
          formData.append('file', pdfFile)
          axios.post(`/api/courses/units/${unitId}/pdf`, formData, { headers: { 'Content-Type': 'multipart/form-data' } })
            .then(afterUpload)
            .catch(err => showNotification('Lesson created but PDF upload failed: ' + (err.response?.data?.message || err.message), 'error'))
        } else {
          afterUpload()
        }
      })
      .catch(err => showNotification('Error adding lesson: ' + (err.response?.data?.message || err.message), 'error'))
  }

  const addQuizQuestion = () => setQuizQuestions(prev => [
    ...prev,
    { questionText: '', correctOption: 'a', orderIndex: prev.length + 1, options: [{ optionLetter: 'a', optionText: '' }, { optionLetter: 'b', optionText: '' }, { optionLetter: 'c', optionText: '' }, { optionLetter: 'd', optionText: '' }] }
  ])

  const removeQuizQuestion = (idx) => setQuizQuestions(prev => prev.filter((_, i) => i !== idx).map((q, i) => ({ ...q, orderIndex: i + 1 })))

  const updateQuestion = (idx, field, value) => setQuizQuestions(prev => prev.map((q, i) => i === idx ? { ...q, [field]: value } : q))

  const updateOption = (qIdx, oIdx, value) => setQuizQuestions(prev => prev.map((q, i) => i === qIdx
    ? { ...q, options: q.options.map((o, j) => j === oIdx ? { ...o, optionText: value } : o) }
    : q
  ))

  const handleAddQuizUnit = (e) => {
    e.preventDefault()
    const courseId = newUnit.courseId
    if (!courseId) { showNotification('Please select a course', 'error'); return }
    if (quizQuestions.length === 0) { showNotification('Add at least one question', 'error'); return }
    const payload = {
      title: newUnit.title,
      section: newUnit.section,
      orderIndex: newUnit.orderIndex,
      questions: quizQuestions,
    }
    axios.post(`/api/courses/${courseId}/quiz-units`, payload)
      .then(() => {
        showNotification('Quiz unit added!')
        axios.get(`/api/courses/${courseId}/units`).then(res => {
          setUnitsForSelectedCourse(res.data)
          const nextIndex = res.data.length > 0 ? Math.max(...res.data.map(u => u.orderIndex)) + 1 : 1
          setNewUnit(prev => ({ ...prev, title: '', section: '', content: '', pdfPath: '', orderIndex: nextIndex }))
          setQuizQuestions([{ questionText: '', correctOption: 'a', orderIndex: 1, options: [{ optionLetter: 'a', optionText: '' }, { optionLetter: 'b', optionText: '' }, { optionLetter: 'c', optionText: '' }, { optionLetter: 'd', optionText: '' }] }])
        })
      })
      .catch(err => showNotification('Error: ' + (err.response?.data?.message || err.message), 'error'))
  }

  const handleAddCourse = (e) => {
    e.preventDefault()
    axios.post('/api/courses', newCourse)
      .then(() => { showNotification('Course added successfully!'); setNewCourse({ title: '', description: '' }); fetchCourses() })
      .catch(err => showNotification('Error adding course: ' + (err.response?.data?.message || err.message), 'error'))
  }

  const handleAssignCourse = (e) => {
    e.preventDefault()
    if (!assignment.userId || !assignment.courseId) { showNotification('Select both user and course', 'error'); return }
    const assignedUserId = assignment.userId
    axios.post(`/api/users/${assignment.userId}/courses/${assignment.courseId}`)
      .then(() => {
        showNotification('Course assigned successfully!')
        setAssignment({ userId: '', courseId: '' }); setAvailableCourses([])
        fetchEmployees()
        if (selectedReport && selectedReport.employeeId === parseInt(assignedUserId)) loadReport(assignedUserId)
      })
      .catch(err => showNotification('Error assigning course: ' + (err.response?.data?.message || err.message), 'error'))
  }

  const handleUserSelectForAssignment = (userId) => {
    setAssignment({ ...assignment, userId, courseId: '' })
    userId ? axios.get(`/api/users/${userId}/courses/unassigned`).then(res => setAvailableCourses(res.data)) : setAvailableCourses([])
  }

  const confirm = (message, onConfirm) => setConfirmModal({ visible: true, message, onConfirm })
  const closeConfirm = () => setConfirmModal(prev => ({ ...prev, visible: false }))

  const handleDeleteUser = (userId) => confirm('Are you sure you want to delete this user?', () => {
    axios.delete(`/api/users/${userId}`)
      .then(() => { showNotification('User deleted!'); fetchEmployees(); if (selectedReport?.employeeId === userId) setSelectedReport(null) })
      .catch(err => showNotification('Error: ' + (err.response?.data?.message || err.message), 'error'))
    closeConfirm()
  })

  const handleDeleteCourse = (courseId) => confirm('Delete this course? All lessons and progress will be lost.', () => {
    axios.delete(`/api/courses/${courseId}`)
      .then(() => { showNotification('Course deleted!'); fetchCourses() })
      .catch(err => showNotification('Error: ' + (err.response?.data?.message || err.message), 'error'))
    closeConfirm()
  })

  const handleDeleteUnit = (unitId) => confirm('Delete this lesson?', () => {
    axios.delete(`/api/courses/units/${unitId}`)
      .then(() => {
        showNotification('Lesson deleted!')
        if (selectedCourseForLessons) axios.get(`/api/courses/${selectedCourseForLessons}/units`).then(res => setUnitsForSelectedCourse(res.data))
      })
      .catch(err => showNotification('Error: ' + (err.response?.data?.message || err.message), 'error'))
    closeConfirm()
  })

  const handleUnassignCourse = (userId, courseId) => confirm('Unassign this course from the employee?', () => {
    axios.delete(`/api/users/${userId}/courses/${courseId}`)
      .then(() => {
        showNotification('Course unassigned!')
        fetchEmployees()
        if (selectedEmployeeForUnassign === userId) axios.get(`/api/users/${userId}/courses`).then(res => setEmployeeCourses(res.data))
      })
      .catch(err => showNotification('Error: ' + (err.response?.data?.message || err.message), 'error'))
    closeConfirm()
  })

  const handleCourseSelectForLessons = (courseId) => {
    setSelectedCourseForLessons(courseId)
    if (courseId) {
      axios.get(`/api/courses/${courseId}/units`).then(res => {
        setUnitsForSelectedCourse(res.data)
        const nextIndex = res.data.length > 0 ? Math.max(...res.data.map(u => u.orderIndex)) + 1 : 1
        setNewUnit(prev => ({ ...prev, courseId, orderIndex: nextIndex }))
      })
    } else {
      setUnitsForSelectedCourse([])
      setNewUnit(prev => ({ ...prev, courseId: '', orderIndex: 1 }))
    }
  }

  const handleEmployeeSelectForUnassign = (userId) => {
    setSelectedEmployeeForUnassign(userId)
    userId ? axios.get(`/api/users/${userId}/courses`).then(res => setEmployeeCourses(res.data)) : setEmployeeCourses([])
  }

  // ── Sub-components ──────────────────────────────────────────────────────────

  const Notification = ({ message, type, visible, onClose }) => {
    useEffect(() => {
      if (!visible) return
      const t = setTimeout(onClose, 5000)
      return () => clearTimeout(t)
    }, [visible, onClose])
    if (!visible) return null
    const isError = type === 'error'
    return (
      <div style={{
        position: 'fixed', top: '20px', right: '20px', zIndex: 1001,
        display: 'flex', alignItems: 'center', gap: '12px',
        padding: '14px 20px', borderRadius: '10px', maxWidth: '380px',
        background: isError ? '#fef2f2' : '#f0fdf4',
        border: `1.5px solid ${isError ? '#fecaca' : '#bbf7d0'}`,
        color: isError ? '#b91c1c' : '#15803d',
        boxShadow: '0 4px 20px rgba(0,0,0,0.12)',
        fontSize: '14px',
      }}>
        <span style={{ fontSize: '18px' }}>{isError ? '✕' : '✓'}</span>
        <span style={{ flex: 1 }}>{message}</span>
        <button onClick={onClose} style={{ background: 'none', border: 'none', cursor: 'pointer', fontSize: '18px', color: 'inherit', opacity: 0.6, lineHeight: 1 }}>×</button>
      </div>
    )
  }

  const ConfirmationModal = ({ visible, message, onConfirm, onCancel }) => {
    if (!visible) return null
    return (
      <div style={{ position: 'fixed', inset: 0, background: 'rgba(0,0,0,0.45)', display: 'flex', alignItems: 'center', justifyContent: 'center', zIndex: 1000 }}>
        <div style={{ background: 'white', borderRadius: '14px', padding: '28px 32px', maxWidth: '400px', width: '90%', boxShadow: '0 8px 32px rgba(0,0,0,0.18)', textAlign: 'center' }}>
          <div style={{ fontSize: '36px', marginBottom: '12px' }}>⚠️</div>
          <p style={{ fontSize: '15px', color: '#1e293b', marginBottom: '24px', lineHeight: '1.5' }}>{message}</p>
          <div style={{ display: 'flex', gap: '10px', justifyContent: 'center' }}>
            <button onClick={onConfirm} style={{ padding: '9px 24px', background: '#dc2626', color: 'white', border: 'none', borderRadius: '8px', fontWeight: '600', cursor: 'pointer', fontSize: '14px' }}>
              Confirm
            </button>
            <button onClick={onCancel} style={{ padding: '9px 24px', background: 'white', color: '#475569', border: '1.5px solid #e2e8f0', borderRadius: '8px', fontWeight: '600', cursor: 'pointer', fontSize: '14px' }}>
              Cancel
            </button>
          </div>
        </div>
      </div>
    )
  }

  const ModeToggle = ({ current, onChange }) => (
    <div style={{ display: 'inline-flex', background: '#f1f5f9', borderRadius: '8px', padding: '3px', marginBottom: '20px' }}>
      {['add', 'remove'].map(m => (
        <button key={m} onClick={() => onChange(m)} style={{
          padding: '6px 20px', border: 'none', borderRadius: '6px', cursor: 'pointer',
          fontWeight: '600', fontSize: '13px',
          background: current === m ? (m === 'remove' ? '#dc2626' : '#1d4ed8') : 'transparent',
          color: current === m ? 'white' : '#64748b',
          transition: 'all 0.15s ease',
        }}>
          {m === 'add' ? '+ Add' : '− Remove'}
        </button>
      ))}
    </div>
  )

  // ── Render ──────────────────────────────────────────────────────────────────

  const TABS = [
    { id: 'users',       label: 'Users' },
    { id: 'courses',     label: 'Courses' },
    { id: 'lessons',     label: 'Lessons' },
    { id: 'assignments', label: 'Assignments' },
    { id: 'reports',     label: 'Reports' },
    { id: 'feedback',    label: 'Feedback' },
  ]

  return (
    <div style={{ fontFamily: 'system-ui, sans-serif' }}>
      <h2 style={{ color: '#0f172a', marginBottom: '20px', fontSize: '22px' }}>Admin Dashboard</h2>

      {/* Tab bar */}
      <div style={{ display: 'flex', gap: '4px', borderBottom: '2px solid #e2e8f0', marginBottom: '28px' }}>
        {TABS.map(t => (
          <button key={t.id} onClick={() => { setActiveTab(t.id); setMode('add'); if (t.id === 'feedback') fetchAllFeedbacks(courses) }} style={{
            padding: '10px 20px', border: 'none', background: 'none', cursor: 'pointer',
            fontSize: '14px', fontWeight: activeTab === t.id ? '700' : '400',
            color: activeTab === t.id ? '#1d4ed8' : '#64748b',
            borderBottom: activeTab === t.id ? '2px solid #1d4ed8' : '2px solid transparent',
            marginBottom: '-2px', transition: 'all 0.15s ease',
          }}>
            {t.label}
          </button>
        ))}
      </div>

      <Notification message={notification.message} type={notification.type} visible={notification.visible} onClose={hideNotification} />
      <ConfirmationModal visible={confirmModal.visible} message={confirmModal.message} onConfirm={confirmModal.onConfirm} onCancel={closeConfirm} />

      {/* ── Users tab ── */}
      {activeTab === 'users' && (
        <div style={{ maxWidth: '520px' }}>
          <ModeToggle current={mode} onChange={setMode} />
          {mode === 'add' ? (
            <div style={{ background: 'white', border: '1.5px solid #e2e8f0', borderRadius: '12px', padding: '24px', boxShadow: '0 1px 4px rgba(0,0,0,0.05)' }}>
              <h3 style={{ margin: '0 0 20px', fontSize: '16px', color: '#1e293b' }}>Add New User</h3>
              <form onSubmit={handleAddUser}>
                <Field label="Full Name">
                  <StyledInput placeholder="John Doe" value={newUser.fullName} onChange={e => setNewUser({ ...newUser, fullName: e.target.value })} required />
                </Field>
                <Field label="Username">
                  <StyledInput placeholder="johndoe" value={newUser.username} onChange={e => setNewUser({ ...newUser, username: e.target.value })} required />
                </Field>
                <Field label="Password">
                  <StyledInput type="password" placeholder="••••••••" value={newUser.password} onChange={e => setNewUser({ ...newUser, password: e.target.value })} required />
                </Field>
                <Field label="Role">
                  <StyledSelect value={newUser.role} onChange={e => setNewUser({ ...newUser, role: e.target.value })}>
                    <option value="USER">Employee (USER)</option>
                    <option value="ADMIN">Administrator (ADMIN)</option>
                  </StyledSelect>
                </Field>
                <PrimaryBtn type="submit">Add User</PrimaryBtn>
              </form>
            </div>
          ) : (
            <div>
              {employees.length === 0 && <EmptyState icon="👤" text="No employees found." />}
              {employees.map(emp => (
                <ItemCard key={emp.id} accent="#3b82f6">
                  <div style={{ display: 'flex', alignItems: 'center', gap: '12px' }}>
                    <Avatar name={emp.fullName} />
                    <div>
                      <div style={{ fontSize: '14px', fontWeight: '600', color: '#1e293b' }}>{emp.fullName}</div>
                      <div style={{ fontSize: '12px', color: '#94a3b8' }}>@{emp.username}</div>
                    </div>
                  </div>
                  <DeleteBtn onClick={() => handleDeleteUser(emp.id)} />
                </ItemCard>
              ))}
            </div>
          )}
        </div>
      )}

      {/* ── Courses tab ── */}
      {activeTab === 'courses' && (
        <div style={{ maxWidth: '520px' }}>
          <ModeToggle current={mode} onChange={setMode} />
          {mode === 'add' ? (
            <div style={{ background: 'white', border: '1.5px solid #e2e8f0', borderRadius: '12px', padding: '24px', boxShadow: '0 1px 4px rgba(0,0,0,0.05)' }}>
              <h3 style={{ margin: '0 0 20px', fontSize: '16px', color: '#1e293b' }}>Add New Course</h3>
              <form onSubmit={handleAddCourse}>
                <Field label="Course Title">
                  <StyledInput placeholder="e.g. Introduction to React" value={newCourse.title} onChange={e => setNewCourse({ ...newCourse, title: e.target.value })} required />
                </Field>
                <Field label="Description">
                  <StyledTextarea placeholder="Brief description of the course…" value={newCourse.description} onChange={e => setNewCourse({ ...newCourse, description: e.target.value })} />
                </Field>
                <PrimaryBtn type="submit">Add Course</PrimaryBtn>
              </form>
            </div>
          ) : (
            <div>
              {courses.length === 0 && <EmptyState icon="📚" text="No courses found." />}
              {courses.map(course => (
                <ItemCard key={course.id} accent="#8b5cf6">
                  <div>
                    <div style={{ fontSize: '14px', fontWeight: '600', color: '#1e293b' }}>{course.title}</div>
                    {course.description && <div style={{ fontSize: '12px', color: '#94a3b8', marginTop: '2px' }}>{course.description}</div>}
                  </div>
                  <DeleteBtn onClick={() => handleDeleteCourse(course.id)} />
                </ItemCard>
              ))}
            </div>
          )}
        </div>
      )}

      {/* ── Lessons tab ── */}
      {activeTab === 'lessons' && (
        <div>
          <ModeToggle current={mode} onChange={setMode} />
          {mode === 'add' ? (
            <>
              {/* Inner type toggle: Lesson | Test */}
              <div style={{ display: 'inline-flex', background: '#f1f5f9', borderRadius: '8px', padding: '3px', marginBottom: '20px' }}>
                {[{ key: 'lesson', label: '📄 Lesson', activeColor: '#16a34a' }, { key: 'quiz', label: '🧠 Quiz', activeColor: '#8b5cf6' }].map(t => (
                  <button key={t.key} onClick={() => setLessonType(t.key)} style={{
                    padding: '6px 20px', border: 'none', borderRadius: '6px', cursor: 'pointer',
                    fontWeight: '600', fontSize: '13px',
                    background: lessonType === t.key ? t.activeColor : 'transparent',
                    color: lessonType === t.key ? 'white' : '#64748b',
                    transition: 'all 0.15s ease',
                  }}>{t.label}</button>
                ))}
              </div>

              <div style={{ display: 'flex', gap: '24px', alignItems: 'flex-start' }}>
                {/* ── Lesson form ── */}
                {lessonType === 'lesson' && (
                  <div style={{ width: '420px', flexShrink: 0, background: 'white', border: '1.5px solid #e2e8f0', borderRadius: '12px', padding: '24px', boxShadow: '0 1px 4px rgba(0,0,0,0.05)' }}>
                    <h3 style={{ margin: '0 0 20px', fontSize: '16px', color: '#1e293b' }}>Add Lesson</h3>
                    <form onSubmit={handleAddUnit}>
                      <Field label="Course">
                        <StyledSelect value={newUnit.courseId} onChange={e => handleCourseSelectForLessons(e.target.value)} required>
                          <option value="">Select a course…</option>
                          {courses.map(c => <option key={c.id} value={c.id}>{c.title}</option>)}
                        </StyledSelect>
                      </Field>
                      <Field label="Title">
                        <StyledInput placeholder="e.g. Chapter 1: Introduction" value={newUnit.title} onChange={e => setNewUnit({ ...newUnit, title: e.target.value })} required />
                      </Field>
                      <Field label="Section">
                        <StyledInput placeholder="e.g. Introduction" value={newUnit.section} onChange={e => setNewUnit({ ...newUnit, section: e.target.value })} />
                      </Field>
                      <Field label="PDF File (optional)">
                        <div style={{ display: 'flex', alignItems: 'center', gap: '10px' }}>
                          <label style={{
                            padding: '8px 14px', background: '#f1f5f9', border: '1.5px solid #e2e8f0',
                            borderRadius: '8px', fontSize: '13px', fontWeight: '600', color: '#475569',
                            cursor: 'pointer', whiteSpace: 'nowrap',
                          }}>
                            📎 Choose PDF
                            <input type="file" accept="application/pdf" style={{ display: 'none' }}
                              onChange={e => setPdfFile(e.target.files[0] || null)} />
                          </label>
                          {pdfFile
                            ? <span style={{ fontSize: '13px', color: '#16a34a', fontWeight: '600', overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>✓ {pdfFile.name}</span>
                            : <span style={{ fontSize: '13px', color: '#94a3b8' }}>No file selected</span>
                          }
                        </div>
                      </Field>
                      <Field label="Content">
                        <StyledTextarea placeholder="Lesson content…" value={newUnit.content} onChange={e => setNewUnit({ ...newUnit, content: e.target.value })} />
                      </Field>
                      <Field label="Order Index">
                        <StyledInput type="number" placeholder="1" value={newUnit.orderIndex} onChange={e => setNewUnit({ ...newUnit, orderIndex: parseInt(e.target.value) || 1 })} required />
                        {newUnit.courseId && unitsForSelectedCourse.some(u => u.orderIndex === newUnit.orderIndex) && (
                          <div style={{ marginTop: '6px', fontSize: '12px', color: '#f59e0b' }}>
                            ⚠ Position {newUnit.orderIndex} is taken — existing units will shift down
                          </div>
                        )}
                      </Field>
                      <PrimaryBtn type="submit">Add Lesson</PrimaryBtn>
                    </form>
                  </div>
                )}

                {/* ── Quiz form ── */}
                {lessonType === 'quiz' && (
                  <div style={{ width: '520px', flexShrink: 0, background: 'white', border: '1.5px solid #e2e8f0', borderRadius: '12px', padding: '24px', boxShadow: '0 1px 4px rgba(0,0,0,0.05)', maxHeight: '80vh', overflowY: 'auto' }}>
                    <h3 style={{ margin: '0 0 20px', fontSize: '16px', color: '#1e293b' }}>Add Quiz Unit</h3>
                    <form onSubmit={handleAddQuizUnit}>
                      <Field label="Course">
                        <StyledSelect value={newUnit.courseId} onChange={e => handleCourseSelectForLessons(e.target.value)} required>
                          <option value="">Select a course…</option>
                          {courses.map(c => <option key={c.id} value={c.id}>{c.title}</option>)}
                        </StyledSelect>
                      </Field>
                      <Field label="Quiz Title">
                        <StyledInput placeholder="e.g. Chapter 1 Quiz" value={newUnit.title} onChange={e => setNewUnit({ ...newUnit, title: e.target.value })} required />
                      </Field>
                      <Field label="Section">
                        <StyledInput placeholder="e.g. Introduction" value={newUnit.section} onChange={e => setNewUnit({ ...newUnit, section: e.target.value })} />
                      </Field>
                      <Field label="Order Index">
                        <StyledInput type="number" value={newUnit.orderIndex} onChange={e => setNewUnit({ ...newUnit, orderIndex: parseInt(e.target.value) || 1 })} required />
                      </Field>

                      <div style={{ borderTop: '1px solid #e2e8f0', paddingTop: '16px', marginTop: '8px' }}>
                        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '14px' }}>
                          <span style={{ fontSize: '13px', fontWeight: '700', color: '#1e293b' }}>Questions ({quizQuestions.length})</span>
                          <button type="button" onClick={addQuizQuestion} style={{ padding: '5px 12px', background: '#eff6ff', color: '#1d4ed8', border: '1.5px solid #bfdbfe', borderRadius: '6px', fontSize: '12px', fontWeight: '600', cursor: 'pointer' }}>+ Add Question</button>
                        </div>

                        {quizQuestions.map((q, qIdx) => (
                          <div key={qIdx} style={{ border: '1.5px solid #e2e8f0', borderRadius: '10px', padding: '14px', marginBottom: '12px', background: '#f8fafc' }}>
                            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '10px' }}>
                              <span style={{ fontSize: '12px', fontWeight: '700', color: '#64748b' }}>Q{qIdx + 1}</span>
                              {quizQuestions.length > 1 && <button type="button" onClick={() => removeQuizQuestion(qIdx)} style={{ padding: '2px 8px', background: '#fef2f2', color: '#b91c1c', border: '1px solid #fecaca', borderRadius: '4px', fontSize: '11px', cursor: 'pointer' }}>Remove</button>}
                            </div>
                            <textarea
                              placeholder="Question text…"
                              value={q.questionText}
                              onChange={e => updateQuestion(qIdx, 'questionText', e.target.value)}
                              required
                              style={{ ...input, minHeight: '60px', resize: 'vertical', marginBottom: '10px', fontSize: '13px' }}
                            />
                            <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '6px', marginBottom: '10px' }}>
                              {q.options.map((o, oIdx) => (
                                <div key={oIdx} style={{ display: 'flex', alignItems: 'center', gap: '6px' }}>
                                  <span style={{ fontSize: '12px', fontWeight: '700', color: '#64748b', width: '14px', flexShrink: 0 }}>{o.optionLetter})</span>
                                  <input
                                    placeholder={`Option ${o.optionLetter}`}
                                    value={o.optionText}
                                    onChange={e => updateOption(qIdx, oIdx, e.target.value)}
                                    required
                                    style={{ ...input, fontSize: '12px', padding: '7px 10px' }}
                                  />
                                </div>
                              ))}
                            </div>
                            <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
                              <span style={{ fontSize: '12px', color: '#64748b', fontWeight: '600' }}>Correct:</span>
                              {['a', 'b', 'c', 'd'].map(letter => (
                                <button key={letter} type="button"
                                  onClick={() => updateQuestion(qIdx, 'correctOption', letter)}
                                  style={{
                                    width: '28px', height: '28px', borderRadius: '6px', border: '1.5px solid',
                                    borderColor: q.correctOption === letter ? '#1d4ed8' : '#e2e8f0',
                                    background: q.correctOption === letter ? '#1d4ed8' : 'white',
                                    color: q.correctOption === letter ? 'white' : '#64748b',
                                    fontWeight: '700', fontSize: '12px', cursor: 'pointer',
                                  }}>{letter}</button>
                              ))}
                            </div>
                          </div>
                        ))}
                      </div>

                      <PrimaryBtn type="submit">Add Quiz Unit</PrimaryBtn>
                    </form>
                  </div>
                )}

                {/* Current units preview (shared) */}
                <div style={{ flex: 1, minWidth: 0 }}>
                  {!newUnit.courseId ? (
                    <EmptyState icon="📋" text="Select a course to preview its units" />
                  ) : (
                    <>
                      <h3 style={{ margin: '0 0 14px', fontSize: '13px', color: '#64748b', fontWeight: '600', textTransform: 'uppercase', letterSpacing: '0.05em' }}>
                        Current Units {unitsForSelectedCourse.length > 0 && `(${unitsForSelectedCourse.length})`}
                      </h3>
                      {unitsForSelectedCourse.length === 0 && <EmptyState icon="📄" text="No units yet — yours will be first." />}
                      {unitsForSelectedCourse.map(unit => {
                        const isConflict = unit.orderIndex === newUnit.orderIndex
                        const willShift  = unit.orderIndex >= newUnit.orderIndex && unitsForSelectedCourse.some(u => u.orderIndex === newUnit.orderIndex)
                        const isQuiz = unit.unitType === 'quiz'
                        const typeAccent = isQuiz ? '#8b5cf6' : '#16a34a'
                        const typeBg     = isQuiz ? '#faf5ff' : '#f0fdf4'
                        return (
                          <div key={unit.id} style={{
                            display: 'flex', alignItems: 'center', gap: '12px',
                            padding: '10px 14px', marginBottom: '6px', borderRadius: '8px',
                            background: isConflict ? '#fffbeb' : willShift ? '#fefce8' : typeBg,
                            border: `1.5px solid ${isConflict ? '#fcd34d' : willShift ? '#fde68a' : isQuiz ? '#ddd6fe' : '#bbf7d0'}`,
                            borderLeft: `4px solid ${isConflict ? '#f59e0b' : typeAccent}`,
                            transition: 'all 0.15s ease',
                          }}>
                            <div style={{
                              width: '28px', height: '28px', borderRadius: '6px', flexShrink: 0,
                              background: isConflict ? '#fef3c7' : isQuiz ? '#ede9fe' : '#dcfce7',
                              display: 'flex', alignItems: 'center', justifyContent: 'center',
                              fontSize: '12px', fontWeight: '700', color: isConflict ? '#d97706' : typeAccent,
                            }}>
                              {willShift ? unit.orderIndex + 1 : unit.orderIndex}
                            </div>
                            <div style={{ flex: 1, minWidth: 0 }}>
                              <div style={{ display: 'flex', alignItems: 'center', gap: '6px' }}>
                                <span style={{
                                  fontSize: '10px', padding: '2px 7px', borderRadius: '4px', fontWeight: '700',
                                  background: isQuiz ? '#ede9fe' : '#dcfce7',
                                  color: isQuiz ? '#6d28d9' : '#15803d',
                                }}>
                                  {isQuiz ? '🧠 QUIZ' : '📄 LESSON'}
                                </span>
                                <div style={{ fontSize: '13px', fontWeight: '600', color: '#1e293b', whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis' }}>{unit.title}</div>
                              </div>
                              {unit.section && <div style={{ fontSize: '11px', color: '#94a3b8', marginTop: '2px' }}>{unit.section}</div>}
                            </div>
                            {willShift && <span style={{ fontSize: '11px', color: '#d97706', fontWeight: '600', flexShrink: 0 }}>→ {unit.orderIndex + 1}</span>}
                          </div>
                        )
                      })}
                    </>
                  )}
                </div>
              </div>
            </>
          ) : (
            <div style={{ maxWidth: '520px' }}>
              <div style={{ marginBottom: '16px' }}>
                <label style={label}>Select Course</label>
                <StyledSelect value={selectedCourseForLessons} onChange={e => handleCourseSelectForLessons(e.target.value)}>
                  <option value="">Select a course to view units…</option>
                  {courses.map(c => <option key={c.id} value={c.id}>{c.title}</option>)}
                </StyledSelect>
              </div>
              {selectedCourseForLessons && unitsForSelectedCourse.length === 0 && <EmptyState icon="📄" text="No units in this course yet." />}
              {unitsForSelectedCourse.map((unit, idx) => {
                const isQuiz = unit.unitType === 'quiz'
                return (
                  <div key={unit.id} style={{
                    display: 'flex', alignItems: 'center', justifyContent: 'space-between', gap: '12px',
                    padding: '12px 14px', marginBottom: '8px', borderRadius: '10px',
                    background: isQuiz ? '#faf5ff' : '#f0fdf4',
                    border: `1.5px solid ${isQuiz ? '#ddd6fe' : '#bbf7d0'}`,
                    borderLeft: `4px solid ${isQuiz ? '#8b5cf6' : '#16a34a'}`,
                    boxShadow: '0 1px 3px rgba(0,0,0,0.05)',
                  }}>
                    <div>
                      <div style={{ display: 'flex', alignItems: 'center', gap: '6px' }}>
                        <span style={{
                          fontSize: '10px', padding: '2px 7px', borderRadius: '4px', fontWeight: '700',
                          background: isQuiz ? '#ede9fe' : '#dcfce7',
                          color: isQuiz ? '#6d28d9' : '#15803d',
                        }}>
                          {isQuiz ? '🧠 QUIZ' : '📄 LESSON'}
                        </span>
                        <span style={{ fontSize: '11px', color: '#94a3b8', fontWeight: '600' }}>#{idx + 1}</span>
                        <span style={{ fontSize: '14px', fontWeight: '600', color: '#1e293b' }}>{unit.title}</span>
                      </div>
                      {unit.section && <div style={{ fontSize: '12px', color: '#94a3b8', marginTop: '2px' }}>{unit.section}</div>}
                    </div>
                    <DeleteBtn onClick={() => handleDeleteUnit(unit.id)} />
                  </div>
                )
              })}
            </div>
          )}
        </div>
      )}

      {/* ── Assignments tab ── */}
      {activeTab === 'assignments' && (
        <div style={{ maxWidth: '520px' }}>
          <ModeToggle current={mode} onChange={setMode} />
          {mode === 'add' ? (
            <div style={{ background: 'white', border: '1.5px solid #e2e8f0', borderRadius: '12px', padding: '24px', boxShadow: '0 1px 4px rgba(0,0,0,0.05)' }}>
              <h3 style={{ margin: '0 0 20px', fontSize: '16px', color: '#1e293b' }}>Assign Course to Employee</h3>
              <form onSubmit={handleAssignCourse}>
                <Field label="Employee">
                  <StyledSelect value={assignment.userId} onChange={e => handleUserSelectForAssignment(e.target.value)} required>
                    <option value="">Select an employee…</option>
                    {employees.map(emp => <option key={emp.id} value={emp.id}>{emp.fullName} (@{emp.username})</option>)}
                  </StyledSelect>
                </Field>
                <Field label="Course">
                  <StyledSelect value={assignment.courseId} onChange={e => setAssignment({ ...assignment, courseId: e.target.value })} required disabled={!assignment.userId}>
                    <option value="">{assignment.userId ? 'Select a course…' : 'Select an employee first'}</option>
                    {availableCourses.map(c => <option key={c.id} value={c.id}>{c.title}</option>)}
                  </StyledSelect>
                </Field>
                <PrimaryBtn type="submit">Assign Course</PrimaryBtn>
              </form>
            </div>
          ) : (
            <div>
              <div style={{ marginBottom: '16px' }}>
                <label style={label}>Select Employee</label>
                <StyledSelect value={selectedEmployeeForUnassign} onChange={e => handleEmployeeSelectForUnassign(e.target.value)}>
                  <option value="">Select an employee to view assignments…</option>
                  {employees.map(emp => <option key={emp.id} value={emp.id}>{emp.fullName} (@{emp.username})</option>)}
                </StyledSelect>
              </div>
              {selectedEmployeeForUnassign && employeeCourses.length === 0 && <EmptyState icon="📋" text="No courses assigned to this employee." />}
              {employeeCourses.map(course => (
                <ItemCard key={course.id} accent="#3b82f6">
                  <div>
                    <div style={{ fontSize: '14px', fontWeight: '600', color: '#1e293b' }}>{course.title}</div>
                    {course.description && <div style={{ fontSize: '12px', color: '#94a3b8', marginTop: '2px' }}>{course.description}</div>}
                  </div>
                  <DeleteBtn onClick={() => handleUnassignCourse(selectedEmployeeForUnassign, course.id)} label="Unassign" />
                </ItemCard>
              ))}
            </div>
          )}
        </div>
      )}

      {/* ── Feedback tab ── */}
      {activeTab === 'feedback' && (
        <div style={{ maxWidth: '720px' }}>
          {courses.length === 0 && <EmptyState icon="💬" text="No courses found." />}
          {courses.map(course => {
            const fbs = courseFeedbacks[course.id] || []
            const avg = fbs.length > 0
              ? (fbs.reduce((s, f) => s + f.rating, 0) / fbs.length).toFixed(1)
              : null
            return (
              <div key={course.id} style={{
                marginBottom: '16px', borderRadius: '10px',
                border: '1.5px solid #e2e8f0', borderLeft: '4px solid #f59e0b',
                background: 'white', overflow: 'hidden',
                boxShadow: '0 1px 4px rgba(0,0,0,0.05)',
              }}>
                {/* Course header */}
                <div style={{ padding: '14px 18px', borderBottom: fbs.length > 0 ? '1px solid #f1f5f9' : 'none', display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                  <div>
                    <div style={{ fontWeight: '700', fontSize: '15px', color: '#1e293b' }}>{course.title}</div>
                    {course.description && <div style={{ fontSize: '12px', color: '#94a3b8', marginTop: '2px' }}>{course.description}</div>}
                  </div>
                  <div style={{ display: 'flex', alignItems: 'center', gap: '8px', flexShrink: 0 }}>
                    {avg !== null ? (
                      <>
                        <span style={{ fontSize: '18px', color: '#f59e0b' }}>★</span>
                        <span style={{ fontWeight: '800', fontSize: '16px', color: '#1e293b' }}>{avg}</span>
                        <span style={{ fontSize: '12px', color: '#94a3b8' }}>({fbs.length} review{fbs.length !== 1 ? 's' : ''})</span>
                      </>
                    ) : (
                      <span style={{ fontSize: '12px', color: '#cbd5e1', fontStyle: 'italic' }}>No reviews yet</span>
                    )}
                  </div>
                </div>

                {/* Feedback entries */}
                {fbs.map(fb => {
                  const date = new Date(fb.createdAt).toLocaleDateString('en-GB', { day: '2-digit', month: 'short', year: 'numeric' })
                  return (
                    <div key={fb.id} style={{
                      padding: '12px 18px', borderBottom: '1px solid #f8fafc',
                      display: 'flex', gap: '12px', alignItems: 'flex-start',
                    }}>
                      {/* Avatar */}
                      <div style={{
                        width: '34px', height: '34px', borderRadius: '50%', flexShrink: 0,
                        background: '#e0e7ff', display: 'flex', alignItems: 'center', justifyContent: 'center',
                        fontSize: '13px', fontWeight: '700', color: '#3b82f6',
                      }}>
                        {fb.fullName.charAt(0).toUpperCase()}
                      </div>
                      <div style={{ flex: 1, minWidth: 0 }}>
                        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '4px' }}>
                          <div>
                            <span style={{ fontWeight: '600', fontSize: '13px', color: '#1e293b' }}>{fb.fullName}</span>
                            <span style={{ fontSize: '12px', color: '#94a3b8', marginLeft: '6px' }}>@{fb.username}</span>
                          </div>
                          <div style={{ display: 'flex', alignItems: 'center', gap: '6px', flexShrink: 0 }}>
                            <span style={{ fontSize: '13px', color: '#f59e0b', letterSpacing: '1px' }}>{'★'.repeat(fb.rating)}{'☆'.repeat(5 - fb.rating)}</span>
                            <span style={{ fontSize: '11px', color: '#cbd5e1' }}>{date}</span>
                          </div>
                        </div>
                        {fb.comment && (
                          <div style={{ fontSize: '13px', color: '#475569', lineHeight: '1.5', fontStyle: 'italic' }}>
                            "{fb.comment}"
                          </div>
                        )}
                      </div>
                    </div>
                  )
                })}
              </div>
            )
          })}
        </div>
      )}

      {/* ── Reports tab ── */}
      {activeTab === 'reports' && (
        <div style={{ display: 'flex', gap: '24px', alignItems: 'flex-start' }}>
          <div style={{ width: '260px', flexShrink: 0 }}>
            <h3 style={{ margin: '0 0 14px', fontSize: '13px', color: '#64748b', fontWeight: '600', textTransform: 'uppercase', letterSpacing: '0.05em' }}>Employees</h3>
            {employees.length === 0 && <EmptyState icon="👤" text="No employees found." />}
            {employees.map(emp => {
              const isActive = selectedReport?.employeeId === emp.id
              return (
                <div key={emp.id} onClick={() => loadReport(emp.id)} style={{
                  display: 'flex', alignItems: 'center', gap: '12px',
                  padding: '12px 14px', marginBottom: '8px', borderRadius: '10px',
                  cursor: 'pointer', userSelect: 'none',
                  background: isActive ? '#1d4ed8' : 'white',
                  border: isActive ? '2px solid #1d4ed8' : '1.5px solid #e2e8f0',
                  boxShadow: isActive ? '0 4px 14px rgba(29,78,216,0.2)' : '0 1px 3px rgba(0,0,0,0.05)',
                  transition: 'all 0.18s ease',
                }}>
                  <Avatar name={emp.fullName} active={isActive} />
                  <div style={{ minWidth: 0 }}>
                    <div style={{ fontSize: '14px', fontWeight: '600', color: isActive ? 'white' : '#1e293b', whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis' }}>{emp.fullName}</div>
                    <div style={{ fontSize: '12px', color: isActive ? 'rgba(255,255,255,0.7)' : '#94a3b8' }}>@{emp.username}</div>
                  </div>
                </div>
              )
            })}
          </div>

          <div style={{ flex: 1, minWidth: 0 }}>
            {!selectedReport ? (
              <EmptyState icon="📊" text="Select an employee to view their report" />
            ) : (() => {
              const totalCourses   = selectedReport.courses.length
              const completedCourses = selectedReport.courses.filter(c => c.completedUnits === c.totalUnits && c.totalUnits > 0).length
              const totalUnits     = selectedReport.courses.reduce((s, c) => s + c.totalUnits, 0)
              const totalCompleted = selectedReport.courses.reduce((s, c) => s + c.completedUnits, 0)
              const overallPct     = totalUnits === 0 ? 0 : Math.round(totalCompleted * 100 / totalUnits)
              return (
                <div>
                  <div style={{ background: '#1d4ed8', color: 'white', borderRadius: '12px', padding: '20px 24px', marginBottom: '20px', boxShadow: '0 4px 14px rgba(29,78,216,0.25)' }}>
                    <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start' }}>
                      <div>
                        <div style={{ fontSize: '20px', fontWeight: '700' }}>{selectedReport.employeeName}</div>
                        <div style={{ fontSize: '13px', opacity: 0.75, marginTop: '2px' }}>@{selectedReport.username}</div>
                      </div>
                      <div style={{ textAlign: 'right' }}>
                        <div style={{ fontSize: '32px', fontWeight: '800', lineHeight: 1 }}>{overallPct}%</div>
                        <div style={{ fontSize: '12px', opacity: 0.75, marginTop: '2px' }}>overall completion</div>
                      </div>
                    </div>
                    <div style={{ display: 'flex', gap: '24px', marginTop: '16px', paddingTop: '16px', borderTop: '1px solid rgba(255,255,255,0.2)' }}>
                      {[{ label: 'Courses', value: `${completedCourses} / ${totalCourses}` }, { label: 'Units done', value: `${totalCompleted} / ${totalUnits}` }].map(s => (
                        <div key={s.label}><div style={{ fontSize: '18px', fontWeight: '700' }}>{s.value}</div><div style={{ fontSize: '12px', opacity: 0.7 }}>{s.label}</div></div>
                      ))}
                    </div>
                  </div>
                  {selectedReport.courses.length === 0 && <p style={{ color: '#94a3b8', fontSize: '14px' }}>No courses assigned.</p>}
                  {selectedReport.courses.map(cp => {
                    const pct   = cp.totalUnits === 0 ? 0 : Math.round(cp.completedUnits * 100 / cp.totalUnits)
                    const color = pct === 100 ? '#16a34a' : pct >= 50 ? '#f59e0b' : '#3b82f6'
                    const courseQuizzes = quizSummaries.filter(s => s.courseTitle === cp.courseTitle)
                    return (
                      <div key={cp.courseTitle} style={{ border: `1.5px solid ${pct === 100 ? '#bbf7d0' : '#e2e8f0'}`, borderLeft: `4px solid ${color}`, borderRadius: '8px', padding: '16px', marginBottom: '12px', background: pct === 100 ? '#f0fdf4' : 'white' }}>
                        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '10px' }}>
                          <span style={{ fontWeight: '600', fontSize: '15px', color: '#1e293b' }}>{cp.courseTitle}</span>
                          <span style={{ fontSize: '13px', fontWeight: '700', color, background: `${color}18`, border: `1px solid ${color}44`, borderRadius: '99px', padding: '3px 10px' }}>{pct}%</span>
                        </div>
                        <div style={{ background: '#e2e8f0', borderRadius: '99px', height: '6px', marginBottom: '10px' }}>
                          <div style={{ background: color, width: `${pct}%`, height: '6px', borderRadius: '99px', transition: 'width 0.4s ease' }} />
                        </div>
                        <div style={{ display: 'flex', gap: '20px', marginBottom: courseQuizzes.length > 0 ? '14px' : 0 }}>
                          {[{ label: 'Total', value: cp.totalUnits }, { label: 'Completed', value: cp.completedUnits, color: '#16a34a' }, { label: 'Remaining', value: cp.remainingUnits, color: cp.remainingUnits > 0 ? '#f59e0b' : '#16a34a' }].map(s => (
                            <div key={s.label} style={{ fontSize: '13px' }}>
                              <span style={{ color: s.color ?? '#64748b', fontWeight: '600' }}>{s.value}</span>
                              <span style={{ color: '#94a3b8', marginLeft: '4px' }}>{s.label}</span>
                            </div>
                          ))}
                        </div>
                        {courseQuizzes.length > 0 && (
                          <div style={{ borderTop: '1px solid #e2e8f0', paddingTop: '12px' }}>
                            <div style={{ fontSize: '11px', fontWeight: '700', color: '#94a3b8', textTransform: 'uppercase', letterSpacing: '0.05em', marginBottom: '8px' }}>
                              Quiz Results
                            </div>
                            {courseQuizzes.map(s => {
                              const gradeColor = s.lastGrade === 'Excellent' ? '#16a34a'
                                : s.lastGrade === 'Very Good' ? '#ca8a04'
                                : s.lastGrade === 'Good'      ? '#ea580c'
                                :                               '#dc2626'
                              return (
                                <div key={s.unitId} style={{
                                  padding: '10px 12px', marginBottom: '6px', borderRadius: '7px',
                                  background: '#faf5ff', border: '1.5px solid #ddd6fe', borderLeft: '3px solid #8b5cf6',
                                }}>
                                  <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '5px' }}>
                                    <span style={{ fontWeight: '600', fontSize: '13px', color: '#1e293b' }}>🧠 {s.unitTitle}</span>
                                    <span style={{
                                      fontSize: '11px', fontWeight: '700', color: gradeColor,
                                      background: `${gradeColor}18`, border: `1px solid ${gradeColor}44`,
                                      borderRadius: '99px', padding: '2px 8px',
                                    }}>{s.lastGrade}</span>
                                  </div>
                                  <div style={{ display: 'flex', gap: '16px' }}>
                                    {[
                                      { label: 'Attempts',   value: s.attempts,             color: '#8b5cf6' },
                                      { label: 'Best',       value: `${s.bestPercentage}%`,  color: '#16a34a' },
                                      { label: 'Last',       value: `${s.lastPercentage}%`,  color: gradeColor },
                                    ].map(stat => (
                                      <div key={stat.label} style={{ fontSize: '12px' }}>
                                        <span style={{ fontWeight: '700', color: stat.color }}>{stat.value}</span>
                                        <span style={{ color: '#94a3b8', marginLeft: '4px' }}>{stat.label}</span>
                                      </div>
                                    ))}
                                  </div>
                                </div>
                              )
                            })}
                          </div>
                        )}
                      </div>
                    )
                  })}
                </div>
              )
            })()}
          </div>
        </div>
      )}
    </div>
  )
}

export default AdminDashboard
