-- Update PE topic descriptions to match the original HTML
UPDATE topics 
SET description = 'Covers essential knowledge of first aid techniques and emergency response procedures'
WHERE name = 'First Aid Basics' AND subject = 'Physical Education';

UPDATE topics 
SET description = 'Understanding major body systems, joints, and movement mechanics in sports'
WHERE name = 'Human Anatomy in Sports' AND subject = 'Physical Education';

UPDATE topics 
SET description = 'Cover training types, fitness testing methodologies, and program planning'
WHERE name = 'Fitness & Training Methods' AND subject = 'Physical Education';

UPDATE topics 
SET description = 'Rules and scoring systems for common sports like football, basketball, and more'
WHERE name = 'Sports Rules & Regulations' AND subject = 'Physical Education';

UPDATE topics 
SET description = 'Benefits and techniques of yoga for physical and mental well-being'
WHERE name = 'Yoga & Wellness' AND subject = 'Physical Education';

UPDATE topics 
SET description = 'Mental preparation, motivation techniques, and concentration in athletics'
WHERE name = 'Psychology in Sports' AND subject = 'Physical Education';

UPDATE topics 
SET description = 'Teaching methods and lesson planning in PE curriculum'
WHERE name = 'Physical Education Pedagogy' AND subject = 'Physical Education';

UPDATE topics 
SET description = 'How to avoid injuries and basic rehab practices for athletes'
WHERE name = 'Injury Prevention & Rehabilitation' AND subject = 'Physical Education';

UPDATE topics 
SET description = 'Balanced diet, supplements, and hydration strategies in sports'
WHERE name = 'Nutrition for Athletes' AND subject = 'Physical Education';

UPDATE topics 
SET description = 'Origin, evolution, and importance of PE in curriculum'
WHERE name = 'History of Physical Education' AND subject = 'Physical Education'; 