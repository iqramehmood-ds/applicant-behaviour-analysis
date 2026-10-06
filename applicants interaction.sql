
USE applicants_interaction;
SELECT step_order, page, COUNT(DISTINCT session_id) AS sessions
FROM events
GROUP BY step_order, page
ORDER BY step_order;
WITH funnel AS (
    SELECT step_order, page, COUNT(DISTINCT session_id) AS sessions
    FROM events GROUP BY step_order, page
)
SELECT step_order, page, sessions,
       LAG(sessions) OVER (ORDER BY step_order) AS previous_step,
       ROUND(100.0 * sessions / LAG(sessions) OVER (ORDER BY step_order), 1) AS pct_continued,
       ROUND(100.0 - 100.0 * sessions / LAG(sessions) OVER (ORDER BY step_order), 1) AS pct_dropped
FROM funnel
ORDER BY step_order;
WITH last_step AS (
    SELECT session_id, MAX(step_order) AS last_order
    FROM events
    GROUP BY session_id
)

SELECT e.page AS exit_page,
       COUNT(*) AS exits
FROM last_step l
JOIN events e
    ON e.session_id = l.session_id
    AND e.step_order = l.last_order
WHERE l.last_order < 8
GROUP BY e.page
ORDER BY exits DESC;
SELECT COUNT(DISTINCT s.session_id) AS total_sessions,
       COUNT(DISTINCT c.session_id) AS applications,
       ROUND(100.0 * COUNT(DISTINCT c.session_id) / COUNT(DISTINCT s.session_id), 2) AS conversion_pct
FROM sessions s
LEFT JOIN events c ON c.session_id = s.session_id AND c.page = 'confirmation';
SELECT s.device,
       COUNT(DISTINCT s.session_id) AS sessions,
       COUNT(DISTINCT c.session_id) AS applications,
       ROUND(100.0 * COUNT(DISTINCT c.session_id) / COUNT(DISTINCT s.session_id), 2) AS conversion_pct
FROM sessions s
LEFT JOIN events c ON c.session_id = s.session_id AND c.page = 'confirmation'
GROUP BY s.device;

SELECT s.traffic_source,
       COUNT(DISTINCT s.session_id) AS sessions,
       COUNT(DISTINCT c.session_id) AS applications,
       ROUND(100.0 * COUNT(DISTINCT c.session_id) / COUNT(DISTINCT s.session_id), 2) AS conversion_pct
FROM sessions s
LEFT JOIN events c ON c.session_id = s.session_id AND c.page = 'confirmation'
GROUP BY s.traffic_source
ORDER BY conversion_pct DESC;
SELECT s.device,
       COUNT(DISTINCT u.session_id) AS reached_cv_upload,
       COUNT(DISTINCT n.session_id) AS reached_submit,
       ROUND(100.0 * COUNT(DISTINCT n.session_id) / COUNT(DISTINCT u.session_id), 1) AS pct_continued
FROM sessions s
JOIN events u ON u.session_id = s.session_id AND u.page = 'cv_upload'
LEFT JOIN events n ON n.session_id = s.session_id AND n.page = 'submit'
GROUP BY s.device;
SELECT CASE WHEN c.session_id IS NULL THEN 'left' ELSE 'completed' END AS outcome,
       COUNT(*) AS sessions,
       ROUND(AVG(f.time_on_page_sec), 1) AS avg_seconds_on_form
FROM events f
LEFT JOIN events c ON c.session_id = f.session_id AND c.page = 'confirmation'
WHERE f.page = 'application_form'
GROUP BY outcome;
SELECT DATE(event_time) AS day, COUNT(*) AS applications
FROM events
WHERE page = 'confirmation'
GROUP BY DATE(event_time)
ORDER BY day;