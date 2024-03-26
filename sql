WITH DuplicateRows AS (
    SELECT 
        cca1.id AS duplicate_id,
        cca2.id AS original_id,
        ROW_NUMBER() OVER (PARTITION BY cca1.person_id, cca1.mentor_id, cca1.mentor_career_plans_id ORDER BY cca2.create_date) AS row_num
    FROM 
        cc_collection_adaptations cca1
    LEFT JOIN 
        cc_collection_adaptations cca2 ON cca1.person_id = cca2.person_id 
                                           AND cca1.mentor_id = cca2.mentor_id 
                                           AND cca1.mentor_career_plans_id = cca2.mentor_career_plans_id 
                                           AND cca1.id <> cca2.id
)
SELECT 
    CASE WHEN row_num = 1 THEN duplicate_id ELSE NULL END AS first_duplicate_id,
    CASE WHEN row_num > 1 THEN duplicate_id ELSE NULL END AS other_duplicate_ids
FROM 
    DuplicateRows
WHERE 
    row_num <= 2;
