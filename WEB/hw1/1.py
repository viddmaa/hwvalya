class Subject:
    def __init__(self, name, teacher, count):
        self.name: str = name
        self.teacher: str = teacher
        self.count: int = count

    def __str__(self) -> str:
        return f'{self.name}: преподаватель {self.teacher}, студентов: {self.count}'

    def add (self):
        if self.count >= 0:
            self.count += 1
            print(f'На предмет "{self.name}" зачислен студент. Теперь их: {self.count}.')
        else:
            print("Ошибка: количество студентов не может быть отрицательным")

def main():
    s1 = Subject("Математика", "Ирина Владимировна", 12)    
    s1.add()
    print(s1)
    
if __name__ == '__main__':
    main()