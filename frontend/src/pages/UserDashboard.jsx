import { useState, useEffect, useRef } from 'react'
import axios from 'axios'

const ProgressBar = ({ percentage, active }) => (
  <div style={{ background: active ? 'rgba(255,255,255,0.25)' : '#e2e8f0', borderRadius: '99px', height: '5px', width: '100%' }}>
    <div style={{
      background: active ? 'white' : (percentage === 100 ? '#16a34a' : '#3b82f6'),
      width: `${percentage}%`, height: '5px', borderRadius: '99px', transition: 'width 0.4s ease',
    }} />
  </div>
)

const PercentBadge = ({ percentage }) => {
  const color = percentage === 100 ? '#16a34a' : percentage >= 50 ? '#f59e0b' : '#3b82f6'
  return (
    <span style={{
      fontSize: '12px', fontWeight: '700', color,
      background: `${color}18`, border: `1px solid ${color}44`,
      borderRadius: '99px', padding: '2px 8px', whiteSpace: 'nowrap',
    }}>{percentage}%</span>
  )
}

const CourseCard = ({ course, isOpen, onClick }) => (
  <div onClick={onClick} style={{
    marginBottom: '10px', borderRadius: '10px', padding: '14px 16px', cursor: 'pointer',
    background: isOpen ? '#1d4ed8' : 'white',
    border: isOpen ? '2px solid #1d4ed8' : '1.5px solid #e2e8f0',
    boxShadow: isOpen ? '0 4px 14px rgba(29,78,216,0.25)' : '0 1px 4px rgba(0,0,0,0.06)',
    transition: 'all 0.2s ease', userSelect: 'none',
  }}>
    <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', gap: '8px' }}>
      <span style={{ fontWeight: '600', fontSize: '14px', color: isOpen ? 'white' : '#1e293b', flex: 1 }}>{course.title}</span>
      {isOpen
        ? <span style={{ fontSize: '12px', fontWeight: '700', color: 'rgba(255,255,255,0.9)', whiteSpace: 'nowrap' }}>{course.completionPercentage}%</span>
        : <PercentBadge percentage={course.completionPercentage} />}
    </div>
    <div style={{ marginTop: '8px' }}>
      <ProgressBar percentage={course.completionPercentage} active={isOpen} />
      <div style={{ fontSize: '11px', color: isOpen ? 'rgba(255,255,255,0.7)' : '#94a3b8', marginTop: '4px' }}>
        {course.completedUnits} / {course.totalUnits} units
      </div>
    </div>
  </div>
)

// ── Grade helpers ─────────────────────────────────────────────────────────────
function getGrade(correct, total) {
  const pct = correct / total
  if (pct <= 0.5)  return { label: 'Failure',   color: '#dc2626', bg: '#fef2f2', border: '#fecaca', auto: false }
  if (pct < 0.75)  return { label: 'Good',       color: '#ea580c', bg: '#fff7ed', border: '#fed7aa', auto: true  }
  if (pct < 1)     return { label: 'Very Good',  color: '#ca8a04', bg: '#fefce8', border: '#fde68a', auto: true  }
                   return { label: 'Excellent',  color: '#16a34a', bg: '#f0fdf4', border: '#bbf7d0', auto: true  }
}

// ── Quiz Panel ────────────────────────────────────────────────────────────────
const QuizPanel = ({ unit, userId, isCompleted, onComplete, onUnmark }) => {
  const [questions, setQuestions] = useState([])
  const [answers, setAnswers]     = useState({})
  const [submitted, setSubmitted] = useState(false)
  const [result, setResult]       = useState(null)   // { score, grade }
  const [loading, setLoading]     = useState(true)

  useEffect(() => {
    axios.get(`/api/courses/units/${unit.id}/quiz`)
      .then(res => { setQuestions(res.data); setLoading(false) })
      .catch(() => setLoading(false))
  }, [unit.id])

  const handleSubmit = () => {
    let correct = 0
    questions.forEach(q => { if (answers[q.id] === q.correctOption) correct++ })
    const grade = getGrade(correct, questions.length)
    const pct = Math.round(correct * 100 / questions.length)
    setResult({ score: correct, grade })
    setSubmitted(true)
    if (grade.auto && !isCompleted) onComplete(unit.id)
    axios.post(`/api/users/${userId}/units/${unit.id}/quiz-result`, {
      score: correct, total: questions.length, percentage: pct, grade: grade.label,
    }).catch(err => console.error('Could not save quiz result', err))
  }

  const handleRetry = () => { setAnswers({}); setSubmitted(false); setResult(null) }

  const allAnswered = questions.length > 0 && questions.every(q => answers[q.id])

  if (loading) return <div style={{ padding: '16px', color: '#94a3b8', fontSize: '14px' }}>Loading quiz…</div>
  if (!questions.length) return <div style={{ padding: '16px', color: '#94a3b8', fontSize: '14px' }}>No questions for this quiz.</div>

  const grade = result?.grade

  return (
    <div style={{ marginTop: '16px' }}>
      {/* Result banner */}
      {submitted && grade && (
        <div style={{
          padding: '16px 20px', borderRadius: '10px', marginBottom: '16px',
          background: grade.bg, border: `1.5px solid ${grade.border}`,
          display: 'flex', alignItems: 'center', justifyContent: 'space-between',
        }}>
          <div>
            <div style={{ fontSize: '20px', fontWeight: '800', color: grade.color }}>{grade.label}</div>
            <div style={{ fontSize: '13px', color: '#64748b', marginTop: '2px' }}>
              {result.score} / {questions.length} correct
              {grade.auto && !isCompleted && ' — marked as complete!'}
              {grade.auto && isCompleted && ' — already completed.'}
              {!grade.auto && ' — you need more than 50% to pass.'}
            </div>
          </div>
          <div style={{ fontSize: '32px', fontWeight: '800', color: grade.color, opacity: 0.85 }}>
            {Math.round(result.score * 100 / questions.length)}%
          </div>
        </div>
      )}

      {/* Questions */}
      {questions.map((q, idx) => {
        const userAnswer = answers[q.id]
        const isCorrect  = submitted && userAnswer === q.correctOption
        const isWrong    = submitted && userAnswer && userAnswer !== q.correctOption
        return (
          <div key={q.id} style={{
            border: `1.5px solid ${submitted ? (isCorrect ? '#bbf7d0' : isWrong ? '#fecaca' : '#e2e8f0') : '#e2e8f0'}`,
            borderRadius: '10px', padding: '16px', marginBottom: '12px',
            background: submitted ? (isCorrect ? '#f0fdf4' : isWrong ? '#fef2f2' : 'white') : 'white',
          }}>
            <div style={{ fontSize: '14px', fontWeight: '600', color: '#1e293b', marginBottom: '12px' }}>
              <span style={{ color: '#94a3b8', marginRight: '6px' }}>Q{idx + 1}.</span>{q.questionText}
            </div>
            <div style={{ display: 'flex', flexDirection: 'column', gap: '6px' }}>
              {q.options.map(opt => {
                const sel      = userAnswer === opt.optionLetter
                const correct  = submitted && opt.optionLetter === q.correctOption
                const wrong    = submitted && sel && opt.optionLetter !== q.correctOption
                return (
                  <label key={opt.id} style={{
                    display: 'flex', alignItems: 'flex-start', gap: '10px',
                    padding: '10px 12px', borderRadius: '8px', cursor: submitted ? 'default' : 'pointer',
                    border: `1.5px solid ${correct ? '#86efac' : wrong ? '#fca5a5' : sel ? '#93c5fd' : '#e2e8f0'}`,
                    background: correct ? '#f0fdf4' : wrong ? '#fef2f2' : sel ? '#eff6ff' : 'white',
                    transition: 'all 0.15s ease',
                  }}>
                    <input type="radio" name={`q-${q.id}`} value={opt.optionLetter}
                      checked={sel} disabled={submitted}
                      onChange={() => !submitted && setAnswers(prev => ({ ...prev, [q.id]: opt.optionLetter }))}
                      style={{ marginTop: '2px', accentColor: '#1d4ed8' }}
                    />
                    <span style={{ fontSize: '13px', color: '#1e293b', flex: 1 }}>
                      <strong style={{ color: '#64748b' }}>{opt.optionLetter})</strong> {opt.optionText}
                    </span>
                    {correct && <span style={{ fontSize: '14px', flexShrink: 0 }}>✓</span>}
                    {wrong   && <span style={{ fontSize: '14px', flexShrink: 0 }}>✗</span>}
                  </label>
                )
              })}
            </div>
          </div>
        )
      })}

      {/* Action buttons */}
      <div style={{ display: 'flex', gap: '10px', marginTop: '4px' }}>
        {!submitted && (
          <button onClick={handleSubmit} disabled={!allAnswered} style={{
            padding: '9px 20px', background: allAnswered ? '#1d4ed8' : '#e2e8f0',
            color: allAnswered ? 'white' : '#94a3b8', border: 'none',
            borderRadius: '8px', fontWeight: '600', fontSize: '14px',
            cursor: allAnswered ? 'pointer' : 'not-allowed',
          }}>Submit Quiz</button>
        )}
        {submitted && (
          <button onClick={handleRetry} style={{
            padding: '9px 20px', background: 'white', color: '#64748b',
            border: '1.5px solid #e2e8f0', borderRadius: '8px', fontWeight: '600', fontSize: '14px', cursor: 'pointer',
          }}>Try Again</button>
        )}
        {submitted && isCompleted && (
          <button onClick={() => onUnmark(unit.id)} style={{
            padding: '9px 20px', background: 'white', color: '#6b7280',
            border: '1px solid #d1d5db', borderRadius: '8px', fontWeight: '600', fontSize: '14px', cursor: 'pointer',
          }}>Unmark</button>
        )}
      </div>
    </div>
  )
}

// ── Star Rating ───────────────────────────────────────────────────────────────
const StarRating = ({ value, onChange, readonly = false }) => (
  <div style={{ display: 'flex', gap: '4px' }}>
    {[1, 2, 3, 4, 5].map(star => (
      <span
        key={star}
        onClick={() => !readonly && onChange && onChange(star)}
        style={{
          fontSize: '24px', cursor: readonly ? 'default' : 'pointer',
          color: star <= value ? '#f59e0b' : '#e2e8f0',
          transition: 'color 0.1s ease',
        }}
      >★</span>
    ))}
  </div>
)

// ── Feedback Panel ────────────────────────────────────────────────────────────
const FeedbackPanel = ({ courseId, userId }) => {
  const [rating, setRating]         = useState(0)
  const [hoveredRating, setHoveredRating] = useState(0)
  const [comment, setComment]       = useState('')
  const [existing, setExisting]     = useState(undefined) // undefined=loading, null=none, obj=submitted
  const [submitting, setSubmitting] = useState(false)

  useEffect(() => {
    axios.get(`/api/users/${userId}/courses/${courseId}/feedback`)
      .then(res => setExisting(res.data))
      .catch(() => setExisting(null))
  }, [courseId, userId])

  const handleSubmit = () => {
    if (rating === 0) return
    setSubmitting(true)
    axios.post(`/api/users/${userId}/courses/${courseId}/feedback`, { rating, comment })
      .then(res => setExisting(res.data))
      .finally(() => setSubmitting(false))
  }

  if (existing === undefined) return null

  const displayRating = hoveredRating || rating

  return (
    <div style={{
      marginTop: '24px', padding: '20px 22px', borderRadius: '12px',
      background: '#fffbeb', border: '1.5px solid #fde68a', borderLeft: '4px solid #f59e0b',
    }}>
      <div style={{ fontSize: '16px', fontWeight: '700', color: '#1e293b', marginBottom: '4px' }}>
        🎉 Course Completed!
      </div>
      {existing ? (
        <>
          <div style={{ fontSize: '13px', color: '#64748b', marginBottom: '12px' }}>Your feedback has been submitted. Thank you!</div>
          <StarRating value={existing.rating} readonly />
          {existing.comment && (
            <div style={{
              marginTop: '10px', padding: '10px 14px', borderRadius: '8px',
              background: 'white', border: '1px solid #fde68a',
              fontSize: '13px', color: '#475569', fontStyle: 'italic',
            }}>
              "{existing.comment}"
            </div>
          )}
        </>
      ) : (
        <>
          <div style={{ fontSize: '13px', color: '#64748b', marginBottom: '14px' }}>
            How would you rate this course? Your feedback helps us improve.
          </div>
          <div
            style={{ display: 'flex', gap: '4px', marginBottom: '14px' }}
            onMouseLeave={() => setHoveredRating(0)}
          >
            {[1, 2, 3, 4, 5].map(star => (
              <span
                key={star}
                onClick={() => setRating(star)}
                onMouseEnter={() => setHoveredRating(star)}
                style={{
                  fontSize: '28px', cursor: 'pointer',
                  color: star <= displayRating ? '#f59e0b' : '#e2e8f0',
                  transition: 'color 0.1s ease',
                }}
              >★</span>
            ))}
          </div>
          <textarea
            placeholder="Share your thoughts about this course (optional)…"
            value={comment}
            onChange={e => setComment(e.target.value)}
            style={{
              width: '100%', padding: '10px 12px', fontSize: '13px',
              border: '1.5px solid #fde68a', borderRadius: '8px',
              outline: 'none', resize: 'vertical', minHeight: '72px',
              boxSizing: 'border-box', background: 'white', color: '#1e293b',
              marginBottom: '12px',
            }}
          />
          <button
            onClick={handleSubmit}
            disabled={rating === 0 || submitting}
            style={{
              padding: '8px 20px', fontSize: '13px', fontWeight: '700',
              background: rating > 0 ? '#f59e0b' : '#e2e8f0',
              color: rating > 0 ? 'white' : '#94a3b8',
              border: 'none', borderRadius: '8px',
              cursor: rating > 0 ? 'pointer' : 'not-allowed',
            }}
          >
            {submitting ? 'Submitting…' : 'Submit Feedback'}
          </button>
        </>
      )}
    </div>
  )
}

// ── Main dashboard ────────────────────────────────────────────────────────────
const UserDashboard = ({ userId }) => {
  const [courses, setCourses]           = useState([])
  const [progress, setProgress]         = useState([])
  const [selectedCourse, setSelectedCourse] = useState(null)
  const [units, setUnits]               = useState([])
  const [expandedQuiz, setExpandedQuiz] = useState(null)
  const [pdfUrls, setPdfUrls]           = useState({})   // unitId → blob URL
  const [pdfLoading, setPdfLoading]     = useState({})   // unitId → bool
  const [quizSummaries, setQuizSummaries] = useState({}) // unitId → summary
  const pdfUrlsRef = useRef({})

  const fetchQuizSummaries = () =>
    axios.get(`/api/users/${userId}/quiz-summaries`)
      .then(res => {
        const map = {}
        res.data.forEach(s => { map[s.unitId] = s })
        setQuizSummaries(map)
      })
      .catch(() => {})

  useEffect(() => {
    axios.get(`/api/users/${userId}/courses`).then(res => setCourses(res.data))
    axios.get(`/api/users/${userId}/progress`).then(res => setProgress(res.data))
    fetchQuizSummaries()
    // Revoke all blob URLs on unmount
    return () => { Object.values(pdfUrlsRef.current).forEach(URL.revokeObjectURL) }
  }, [userId])

  const handleCourseClick = (course) => {
    if (selectedCourse?.id === course.id) { setSelectedCourse(null); setUnits([]); return }
    axios.get(`/api/courses/${course.id}/units`).then(res => { setUnits(res.data); setSelectedCourse(course) })
  }

  const refreshData = () => {
    axios.get(`/api/users/${userId}/progress`).then(res => setProgress(res.data))
    axios.get(`/api/users/${userId}/courses`).then(res => {
      setCourses(res.data)
      setSelectedCourse(prev => { if (!prev) return null; return res.data.find(c => c.id === prev.id) ?? prev })
    })
    fetchQuizSummaries()
  }

  const completeUnit = (unitId) => axios.post(`/api/users/${userId}/units/${unitId}/complete`).then(refreshData)
  const unmarkUnit   = (unitId) => axios.post(`/api/users/${userId}/units/${unitId}/unmark`).then(refreshData)
  const isCompleted  = (unitId) => progress.some(p => p.unitId === unitId && p.completed)

  // A unit is unlocked only when all previous units are completed
  const isUnlocked = (idx) => {
    if (idx === 0) return true
    return units.slice(0, idx).every(u => isCompleted(u.id))
  }

  // Fetch PDF as blob (JWT sent via axios interceptor) then open in new tab + auto mark done
  const openPdf = async (unitId) => {
    if (pdfLoading[unitId]) return
    if (pdfUrls[unitId]) { window.open(pdfUrls[unitId], '_blank'); return }
    setPdfLoading(prev => ({ ...prev, [unitId]: true }))
    try {
      const res = await axios.get(`/api/courses/units/${unitId}/pdf`, { responseType: 'blob' })
      const url = URL.createObjectURL(res.data)
      pdfUrlsRef.current[unitId] = url
      setPdfUrls(prev => ({ ...prev, [unitId]: url }))
      window.open(url, '_blank')
      if (!isCompleted(unitId)) completeUnit(unitId)
    } catch (e) {
      console.error('Could not load PDF', e)
    } finally {
      setPdfLoading(prev => ({ ...prev, [unitId]: false }))
    }
  }

  const toggleQuiz = (unitId) => setExpandedQuiz(prev => prev === unitId ? null : unitId)

  return (
    <div style={{ padding: '24px', fontFamily: 'system-ui, sans-serif' }}>
      <h2 style={{ marginBottom: '20px', color: '#0f172a', fontSize: '22px' }}>Your Courses</h2>
      <div style={{ display: 'flex', gap: '24px', alignItems: 'flex-start' }}>

        {/* Sidebar */}
        <div style={{ width: '280px', flexShrink: 0 }}>
          {courses.length === 0 && <p style={{ color: '#94a3b8', fontSize: '14px' }}>No courses assigned yet.</p>}
          {courses.map(course => (
            <CourseCard key={course.id} course={course} isOpen={selectedCourse?.id === course.id} onClick={() => handleCourseClick(course)} />
          ))}
        </div>

        {/* Content panel */}
        <div style={{ flex: 1, minWidth: 0 }}>
          {!selectedCourse ? (
            <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', padding: '60px 20px', color: '#94a3b8', border: '2px dashed #e2e8f0', borderRadius: '12px', textAlign: 'center' }}>
              <span style={{ fontSize: '36px', marginBottom: '12px' }}>📚</span>
              <p style={{ margin: 0, fontSize: '15px' }}>Select a course to view its units</p>
            </div>
          ) : (
            <div>
              {/* Course heading */}
              <div onClick={() => handleCourseClick(selectedCourse)} style={{
                display: 'flex', alignItems: 'center', justifyContent: 'space-between',
                background: '#1d4ed8', color: 'white', borderRadius: '10px',
                padding: '14px 18px', marginBottom: '16px', cursor: 'pointer',
                userSelect: 'none', boxShadow: '0 4px 14px rgba(29,78,216,0.25)',
              }}>
                <div>
                  <div style={{ fontSize: '18px', fontWeight: '700' }}>{selectedCourse.title}</div>
                  {selectedCourse.description && <div style={{ fontSize: '13px', opacity: 0.8, marginTop: '2px' }}>{selectedCourse.description}</div>}
                </div>
                <div style={{ display: 'flex', alignItems: 'center', gap: '10px', flexShrink: 0, marginLeft: '16px' }}>
                  <span style={{ fontSize: '20px', fontWeight: '800', opacity: 0.9 }}>{selectedCourse.completionPercentage}%</span>
                  <span style={{ fontSize: '16px', opacity: 0.6 }}>✕</span>
                </div>
              </div>

              {units.length === 0 && <p style={{ color: '#94a3b8', fontSize: '14px' }}>No units yet.</p>}


              {units.map((unit, idx) => {
                const done       = isCompleted(unit.id)
                const unlocked   = isUnlocked(idx)
                const isQuiz     = unit.unitType === 'quiz'
                const hasPdf     = unit.unitType === 'lesson' && (unit.pdfName || unit.pdfPath)
                const isQuizOpen = expandedQuiz === unit.id
                const qSummary   = isQuiz ? quizSummaries[unit.id] : null
                const gradeColor = qSummary
                  ? qSummary.lastGrade === 'Excellent' ? '#16a34a'
                  : qSummary.lastGrade === 'Very Good'  ? '#ca8a04'
                  : qSummary.lastGrade === 'Good'       ? '#ea580c'
                  :                                       '#dc2626'
                  : '#94a3b8'

                return (
                  <div key={unit.id} style={{
                    border: `1.5px solid ${done ? '#bbf7d0' : !unlocked ? '#e2e8f0' : '#e2e8f0'}`,
                    borderLeft: `4px solid ${done ? '#16a34a' : !unlocked ? '#cbd5e1' : isQuiz ? '#8b5cf6' : '#3b82f6'}`,
                    borderRadius: '8px', padding: '14px 16px', marginBottom: '10px',
                    background: done ? '#f0fdf4' : !unlocked ? '#f8fafc' : 'white',
                    opacity: !unlocked ? 0.6 : 1,
                    transition: 'opacity 0.2s ease',
                  }}>
                    {/* Unit header */}
                    <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', gap: '8px' }}>
                      <div style={{ flex: 1 }}>
                        <div style={{ display: 'flex', alignItems: 'center', gap: '8px', marginBottom: '4px' }}>
                          <span style={{ fontSize: '12px', color: '#94a3b8', fontWeight: '600' }}>#{idx + 1}</span>
                          <span style={{
                            fontSize: '10px', padding: '2px 6px', borderRadius: '4px', fontWeight: '700',
                            background: isQuiz ? '#ede9fe' : '#eff6ff',
                            color: isQuiz ? '#7c3aed' : '#1d4ed8',
                          }}>{isQuiz ? 'QUIZ' : 'LESSON'}</span>
                          {!unlocked && <span style={{ fontSize: '12px' }}>🔒</span>}
                          {done && !isQuiz && <span style={{ fontSize: '11px', color: '#16a34a', fontWeight: '700' }}>✓ Done</span>}
                          <h4 style={{ margin: 0, fontSize: '15px', color: '#1e293b' }}>{unit.title}</h4>
                        </div>
                        {unit.section && (
                          <span style={{ fontSize: '11px', background: '#f1f5f9', color: '#64748b', padding: '2px 8px', borderRadius: '99px', display: 'inline-block', marginBottom: '8px' }}>
                            {unit.section}
                          </span>
                        )}
                        {!unlocked && (
                          <p style={{ margin: '4px 0 0', fontSize: '12px', color: '#94a3b8' }}>
                            Complete the previous unit to unlock this one.
                          </p>
                        )}
                        {unit.content && unlocked && (
                          <p style={{ margin: 0, fontSize: '14px', color: '#475569', lineHeight: '1.5' }}>{unit.content}</p>
                        )}
                        {/* Quiz stats — shown when the user has at least one attempt */}
                        {isQuiz && qSummary && (
                          <div style={{ display: 'flex', gap: '16px', marginTop: '8px', flexWrap: 'wrap' }}>
                            <div style={{ fontSize: '12px' }}>
                              <span style={{ fontWeight: '700', color: '#8b5cf6' }}>{qSummary.attempts}</span>
                              <span style={{ color: '#94a3b8', marginLeft: '4px' }}>attempt{qSummary.attempts !== 1 ? 's' : ''}</span>
                            </div>
                            <div style={{ fontSize: '12px' }}>
                              <span style={{ fontWeight: '700', color: '#16a34a' }}>{qSummary.bestPercentage}%</span>
                              <span style={{ color: '#94a3b8', marginLeft: '4px' }}>best</span>
                            </div>
                            <div style={{ fontSize: '12px' }}>
                              <span style={{ fontWeight: '700', color: gradeColor }}>{qSummary.lastPercentage}%</span>
                              <span style={{ color: '#94a3b8', marginLeft: '4px' }}>last</span>
                            </div>
                            <span style={{
                              fontSize: '11px', fontWeight: '700', padding: '1px 8px', borderRadius: '99px',
                              color: gradeColor, background: `${gradeColor}18`, border: `1px solid ${gradeColor}44`,
                            }}>{qSummary.lastGrade}</span>
                          </div>
                        )}
                      </div>

                      {/* Buttons — only shown when unlocked */}
                      {unlocked && (
                        <div style={{ flexShrink: 0, display: 'flex', flexDirection: 'column', alignItems: 'flex-end', gap: '6px' }}>
                          {hasPdf && (
                            <button onClick={() => openPdf(unit.id)} disabled={pdfLoading[unit.id]} style={{
                              padding: '5px 12px', fontSize: '12px', fontWeight: '600',
                              background: '#eff6ff', color: '#1d4ed8',
                              border: '1.5px solid #bfdbfe', borderRadius: '6px',
                              cursor: pdfLoading[unit.id] ? 'wait' : 'pointer', whiteSpace: 'nowrap',
                            }}>
                              {pdfLoading[unit.id] ? 'Loading…' : '📄 Open PDF'}
                            </button>
                          )}
                          {isQuiz && (
                            <button onClick={() => toggleQuiz(unit.id)} style={{
                              padding: '5px 12px', fontSize: '12px', fontWeight: '600',
                              background: isQuizOpen ? '#7c3aed' : '#ede9fe',
                              color: isQuizOpen ? 'white' : '#7c3aed',
                              border: '1.5px solid #c4b5fd', borderRadius: '6px', cursor: 'pointer', whiteSpace: 'nowrap',
                            }}>
                              {isQuizOpen ? '✕ Close Quiz' : '🧠 Take Quiz'}
                            </button>
                          )}
                          {/* Mark done / Unmark — PDF lessons auto-mark on open (no unmark) */}
                          {unit.unitType === 'lesson' && !hasPdf && (
                            done
                              ? <button onClick={() => unmarkUnit(unit.id)} style={{ fontSize: '12px', padding: '4px 10px', border: '1px solid #d1d5db', borderRadius: '6px', background: 'white', color: '#6b7280', cursor: 'pointer' }}>Unmark</button>
                              : <button onClick={() => completeUnit(unit.id)} style={{ padding: '6px 14px', background: '#3b82f6', color: 'white', border: 'none', borderRadius: '6px', cursor: 'pointer', fontSize: '13px', fontWeight: '600' }}>Mark done</button>
                          )}
                          {hasPdf && done && (
                            <span style={{ fontSize: '12px', color: '#16a34a', fontWeight: '700' }}>✓ Done</span>
                          )}
                        </div>
                      )}
                    </div>

                    {/* Quiz panel */}
                    {isQuiz && isQuizOpen && unlocked && (
                      <QuizPanel unit={unit} userId={userId} isCompleted={done} onComplete={completeUnit} onUnmark={unmarkUnit} />
                    )}
                  </div>
                )
              })}

              {/* Feedback — shown once course is 100% complete */}
              {selectedCourse.completionPercentage === 100 && (
                <FeedbackPanel courseId={selectedCourse.id} userId={userId} />
              )}
            </div>
          )}
        </div>
      </div>
    </div>
  )
}

export default UserDashboard
