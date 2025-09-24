
class Athlete:
    def __init__(self, athlete_name: str, personal_best: float):
        self.athlete_name = athlete_name
        self.personal_best = personal_best

    def improve_performance(self):
        print(f"{self.athlete_name} улучшил результат, но без деталей.")

    def __str__(self):
        return f"Спортсмен: {self.athlete_name}, Личный рекорд = {self.personal_best}"
    

class Jumper(Athlete):
    def __init__(self, athlete_name: str, personal_best: float, jump_category: int):
        super().__init__(athlete_name, personal_best)
        self.jump_category = jump_category

    def improve_performance(self):
        if self.jump_category == "прыжок в длину":
            self.personal_best += 0.15
        elif self.jump_category == "прыжок в высоту":
            self.personal_best += 0.05
        else:
            self.personal_best += 0.1
        print(f"Прыгун {self.athlete_name} улучшил результат в дисциплине '{self.jump_category}': {self.personal_best:.2f} м")

    def __str__(self):
        return (f"Прыгун: {self.athlete_name}, "
                f"Дисциплина = {self.jump_category}, "
                f"Личный рекорд = {self.personal_best:.2f} м")
        

class Sprinter(Athlete):
    def __init__(self, athlete_name: str, personal_best: float, sprint_distance: int):
        super().__init__(athlete_name, personal_best)
        self.sprint_distance = sprint_distance

    def improve_performance(self):
        if self.sprint_distance <= 100:
            self.personal_best -= 0.2
        else:
            self.personal_best -= 0.1
        print(f"Спринтер {self.athlete_name} улучшил результат на дистанции {self.sprint_distance} м: {self.personal_best:.2f} сек")

    def __str__(self):
        return (f"Спринтер: {self.athlete_name}, "
                f"Дистанция = {self.sprint_distance} м, "
                f"Личный рекорд = {self.personal_best:.2f} сек")
    

sprinter = Sprinter("Иван Иванов", 9.58, 100)
jumper = Jumper("Илья Ильич", 8.90, "прыжок в длину")

print(sprinter)
print(jumper)

sprinter.improve_performance()
jumper.improve_performance()

print("\nПосле улучшения:")
print(sprinter)
print(jumper)


