from functools import wraps

def cache_int_arg(func):
    cache = {}

    @wraps(func)
    def wrapper(*args, **kwargs):
        if kwargs:
            raise TypeError("Функция должна вызываться только с одним позиционным параметром (без kwargs).")
        if len(args) != 1:
            raise TypeError("Функция должна принимать ровно один позиционный параметр.")
        n = args[0]
        if not isinstance(n, int):
            raise TypeError("Единственный параметр должен быть int.")

        if n in cache:
            return cache[n]

        result = func(n)
        cache[n] = result
        return result

    return wrapper


@cache_int_arg
def fib(n: int) -> int:
    if n < 2:
        return n
    return fib(n - 1) + fib(n - 2)


if __name__ == "__main__":
    print(fib(10))  # первый вызов считает
    print(fib(10))  # второй вызов берётся из кеша
