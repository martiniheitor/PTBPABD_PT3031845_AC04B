-- Questão 1. Gere uma lista de todos os instrutores,
-- mostrando sua ID, nome e número de seções que eles ministraram.
-- Não se esqueça de mostrar o número de seções como 0 para os instrutores que não ministraram qualquer seção.
-- Sua consulta deverá utilizar outer join e não deverá utilizar subconsultas escalares.

SELECT 
    instr.ID, 
    instr.name, 
    COUNT(sec.ID) AS quantidade_secoes
FROM instructor AS instr
LEFT JOIN teaches AS sec ON sec.ID = instr.ID
GROUP BY instr.ID, instr.name;

-- Questão 2. Escreva a mesma consulta do item anterior, 
-- mas usando uma subconsulta escalar, sem outer join.

SELECT 
    inst.ID, 
    inst.name,
    (
        SELECT COUNT(*) 
        FROM teaches AS t 
        WHERE t.ID = inst.ID
    ) AS total_secoes
FROM instructor inst;

-- Questão 3. Gere a lista de todas as seções de curso oferecidas na primavera de 2010, 
-- junto com o nome dos instrutores ministrando a seção. Se uma seção tiver mais de 1 instrutor, 
-- ela deverá aparecer uma vez no resultado para cada instrutor. Se não tiver instrutor algum, 
-- ela ainda deverá aparecer no resultado, com o nome do instrutor definido como “-”.

SELECT 
    sec.course_id,
    sec.sec_id,
    ens.ID,
    sec.semester,
    sec.year,
    COALESCE(instr.name, '-') AS nome_instrutor
FROM section sec
LEFT JOIN teaches ens 
    ON sec.course_id = ens.course_id 
    AND sec.sec_id = ens.sec_id 
    AND sec.semester = ens.semester 
    AND sec.year = ens.year
LEFT JOIN instructor instr ON instr.ID = ens.ID
WHERE sec.semester = 'Spring' AND sec.year = 2010;

-- Questão 4. Suponha que você tenha recebido uma relação grade_points (grade, points), 
-- que oferece uma conversão de conceitos (letras) na relação takes para notas numéricas; 
-- por exemplo, uma nota “A+” poderia ser especificada para corresponder a 4 pontos, um “A” para 3,7 pontos, e “A-” para 3,4, 
-- e “B+” para 3,1 pontos, e assim por diante. 

-- Os Pontos totais obtidos por um aluno para uma oferta de curso (section) 
-- são definidos como o número de créditos para o curso multiplicado pelos pontos numéricos para a nota que o aluno recebeu.

-- Dada essa relação e o nosso esquema university, escreva: 

-- Ache os pontos totais recebidos por aluno, para todos os cursos realizados por ele.

SELECT 
    stu.ID,
    stu.name,
    crs.title,
    stu.dept_name,
    tk.grade,
    CASE tk.grade
        WHEN 'A+' THEN 4.0
        WHEN 'A'  THEN 3.7
        WHEN 'A-' THEN 3.4
        WHEN 'B+' THEN 3.1
        WHEN 'B'  THEN 2.8
        WHEN 'B-' THEN 2.5
        WHEN 'C+' THEN 2.2
        WHEN 'C'  THEN 1.9
        WHEN 'C-' THEN 1.6
        WHEN 'D'  THEN 1.0
        WHEN 'F'  THEN 0.0
        ELSE NULL
    END AS pontos,
    crs.credits,
    CASE tk.grade
        WHEN 'A+' THEN 4.0
        WHEN 'A'  THEN 3.7
        WHEN 'A-' THEN 3.4
        WHEN 'B+' THEN 3.1
        WHEN 'B'  THEN 2.8
        WHEN 'B-' THEN 2.5
        WHEN 'C+' THEN 2.2
        WHEN 'C'  THEN 1.9
        WHEN 'C-' THEN 1.6
        WHEN 'D'  THEN 1.0
        WHEN 'F'  THEN 0.0
        ELSE NULL
    END * crs.credits AS total_pontos
FROM student stu
JOIN takes tk ON stu.ID = tk.ID
JOIN course crs ON tk.course_id = crs.course_id;

-- Questão 5. Crie uma view a partir do resultado da Questão 4 com o nome “coeficiente_rendimento”.

DROP VIEW IF EXISTS coeficiente_rendimento;

CREATE VIEW coeficiente_rendimento AS
SELECT 
    st.ID,
    st.name,
    c.title,
    st.dept_name,
    t.grade,
    CASE t.grade
        WHEN 'A+' THEN 4.0
        WHEN 'A'  THEN 3.7
        WHEN 'A-' THEN 3.4
        WHEN 'B+' THEN 3.1
        WHEN 'B'  THEN 2.8
        WHEN 'B-' THEN 2.5
        WHEN 'C+' THEN 2.2
        WHEN 'C'  THEN 1.9
        WHEN 'C-' THEN 1.6
        WHEN 'D'  THEN 1.0
        WHEN 'F'  THEN 0.0
        ELSE NULL
    END AS pontos,
    c.credits,
    CASE t.grade
        WHEN 'A+' THEN 4.0
        WHEN 'A'  THEN 3.7
        WHEN 'A-' THEN 3.4
        WHEN 'B+' THEN 3.1
        WHEN 'B'  THEN 2.8
        WHEN 'B-' THEN 2.5
        WHEN 'C+' THEN 2.2
        WHEN 'C'  THEN 1.9
        WHEN 'C-' THEN 1.6
        WHEN 'D'  THEN 1.0
        WHEN 'F'  THEN 0.0
        ELSE NULL
    END * c.credits AS pontos_total
FROM student st
JOIN takes t ON st.ID = t.ID
JOIN course c ON t.course_id = c.course_id;
