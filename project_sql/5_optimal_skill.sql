/*
 Q: What are the most optimal skills to learn high demand and high paying skill
 - identify the skills in high demad and associated with high avg salary 
 - concentrate on remote jobs 
 - WHy? Target skills that offfer job security high demand and fiancial benefit high salary offering strategic insights for career devlopment
 */
WITH skills_demand AS(
    SELECT skills_dim.skill_id,
        skills,
        COUNT(skills_job_dim.job_id) AS demand_count
    FROM job_postings_fact
        INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
        INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE job_title_short = 'Data Analyst'
        AND salary_year_avg IS NOT NULL
        AND job_work_from_home = TRUE
    GROUP BY skills_dim.skill_id
),
avarage_salary AS (
    SELECT skills_dim.skill_id,
        skills,
        ROUND(AVG(salary_year_avg), 2) AS avg_salary
    FROM job_postings_fact
        INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
        INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE job_title_short = 'Data Analyst'
        AND salary_year_avg IS NOT NULL
        AND job_work_from_home = TRUE
    GROUP BY skills_dim.skill_id
)
SELECT skills_demand.skill_id,
    skills_demand.skills,
    demand_count,
    avg_salary
FROM skills_demand
    INNER JOIN avarage_salary ON skills_demand.skill_id = avarage_salary.skill_id
ORDER BY demand_count DESC,
    avg_salary DESC
LIMIT 25