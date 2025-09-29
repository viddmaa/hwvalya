from functools import wraps

def log_with(level="INFO", prefix=""):
    def decorator(func):
        @wraps(func)
        def wrapper(*args, **kwargs):
            print(f"{level} {prefix}{func.__name__}( {args}, {kwargs} )")
            result = func(*args, **kwargs)
            print(f"RET: {repr(result)}")
            return result
        return wrapper
    return decorator


@log_with(level="DEBUG", prefix="[calc] ")
def add(a, b):
    return a + b


if __name__ == "__main__":
    print(add(2, b=3))
