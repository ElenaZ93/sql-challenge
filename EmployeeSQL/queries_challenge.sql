-- 1. List the employee number, last name, first name, sex, and salary of each employee.

SELECT e.emp_no, e.last_name, e.first_name, e.gender, s.salary
FROM employees e
INNER JOIN (
    SELECT emp_no, salary
    FROM salaries
    WHERE (emp_no, from_date) IN (
        SELECT emp_no, MAX(from_date) AS max_from_date
        FROM salaries
        GROUP BY emp_no
    )
) s ON e.emp_no = s.emp_no
ORDER BY e.emp_no;

-- 2. List the first name, last name, and hire date for the employees who were hired in 1986.

SELECT emp_no, last_name, first_name, hire_date 
FROM employees 
WHERE EXTRACT(YEAR FROM hire_date) = 1986
ORDER BY emp_no;

-- 3. List the manager of each department along with their department number, department name, employee number, last name, and first name.

SELECT dm.dept_no, d.dept_name, dm.emp_no, e.last_name, e.first_name, dm.from_date, dm.to_date
FROM departments d
INNER JOIN dept_manager dm
    ON d.dept_no = dm.dept_no
INNER JOIN employees e
    ON dm.emp_no = e.emp_no
WHERE dm.to_date = (
    SELECT MAX(to_date)
    FROM dept_manager
    WHERE dept_no = d.dept_no
)
ORDER BY dm.dept_no;

-- 4. List the department number for each employee along with that employee’s employee number, last name, first name, and department name.

SELECT e.emp_no, e.last_name, e.first_name, d.dept_name
FROM employees e
INNER JOIN dept_emp de 
    ON e.emp_no = de.emp_no
INNER JOIN departments d 
    ON de.dept_no = d.dept_no
WHERE de.to_date = (
    SELECT MAX(to_date)
    FROM dept_emp
    WHERE emp_no = e.emp_no
)
ORDER BY e.emp_no;

-- 5. List first name, last name, and sex of each employee whose first name is Hercules and whose last name begins with the letter B.

SELECT e.last_name, e.first_name, e.gender
FROM employees e
WHERE LOWER(e.first_name) = 'hercules' AND LOWER(e.last_name) LIKE 'b%'
ORDER BY e.last_name;

-- 6. List each employee in the Sales department, including their employee number, last name, and first name.

SELECT e.emp_no, e.last_name, e.first_name
FROM employees e
INNER JOIN dept_emp de ON e.emp_no = de.emp_no
INNER JOIN departments d ON de.dept_no = d.dept_no
WHERE LOWER(d.dept_name) = 'sales' AND de.to_date = (
    SELECT MAX(to_date)
    FROM dept_emp AS de2
    WHERE de2.emp_no = de.emp_no
)
ORDER BY e.emp_no;

-- 7. List each employee in the Sales and Development departments, including their employee number, last name, first name, and department name.

SELECT e.emp_no, e.last_name, e.first_name, d.dept_name
FROM employees e
INNER JOIN dept_emp de ON e.emp_no = de.emp_no
INNER JOIN departments d ON de.dept_no = d.dept_no
WHERE LOWER(d.dept_name) IN ('sales', 'development') AND de.to_date = (
    SELECT MAX(to_date)
    FROM dept_emp AS de2
    WHERE de2.emp_no = de.emp_no
)
ORDER BY e.emp_no;

-- 8. List the frequency counts, in descending order, of all the employee last names (that is, how many employees share each last name).

SELECT last_name, COUNT(last_name) AS frequency 
FROM employees 
GROUP BY last_name
ORDER BY frequency DESC;
