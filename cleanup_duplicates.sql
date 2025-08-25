-- Clean up duplicate PE topics (keep the first one, delete others)
DELETE t1 FROM topics t1
INNER JOIN topics t2 
WHERE t1.id > t2.id 
AND t1.name = t2.name 
AND t1.subject = 'Physical Education' 
AND t2.subject = 'Physical Education';

-- Show final result
SELECT id, name, subject, description FROM topics WHERE subject = 'Physical Education' ORDER BY id; 