CREATE TABLE IF NOT EXISTS employees (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    position TEXT NOT NULL CHECK (
        position IN ('Менеджер', 'Разработчик', 'Аналитик', 'Тестировщик')
    ),
    salary NUMERIC(10, 2) NOT NULL CHECK (salary >= 20000)
);

INSERT INTO employees 
    (name, position, salary) 
VALUES
    ('Иван Иванов', 'Менеджер', 50000.00),
    ('Андрей Андреев', 'Разработчик', 70000.00),
    ('Сергей Сергеев', 'Аналитик', 65000.00),
    ('Мария Иванова', 'Тестировщик', 65000.00);

SELECT * FROM employees;