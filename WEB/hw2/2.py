class Product:
    def __init__(self, sku: str, price: float, stock: int):
        self.sku = sku
        self.price = price
        self.stock = stock

    def __str__(self):
        return f"Товар '{self.sku}': {self.price:.2f} ₽, остаток {self.stock} шт."

    def __repr__(self):
        return f"Product(sku='{self.sku}', price={self.price}, stock={self.stock})"


class Customer:
    def __init__(self, name: str):
        self.name = name
        self.money_spent = 0.0
        self.purchased_products = []

    def add_purchase(self, sku: str, qty: int, price: float):
        self.purchased_products.append((sku, qty, price))
        self.money_spent += qty * price

    def get_purchases_count(self):
        return len(self.purchased_products)

    def __str__(self):
        return (f"Покупатель '{self.name}' — потрачено: {self.money_spent:.2f} ₽, "
                f"покупок: {self.get_purchases_count()}")

    def __repr__(self):
        return (f"Customer(name='{self.name}', money_spent={self.money_spent}, "
                f"purchases={len(self.purchased_products)})")


class Shop:
    def __init__(self, name: str, area: float):
        self.name = name
        self.area = area
        self.products = []

    def add_product(self, product: Product):
        self.products.append(product)

    def remove_product(self, sku: str):
        self.products = [p for p in self.products if p.sku != sku]

    def find_product(self, sku: str):
        for p in self.products:
            if p.sku == sku:
                return p
        return None

    def get_products_count(self):
        return len(self.products)

    def get_total_stock_value(self):
        return sum(p.price * p.stock for p in self.products)

    def __str__(self):
        return (f"Магазин '{self.name}' (площадь: {self.area} м²)\n"
                f"Товарных позиций: {self.get_products_count()}\n"
                f"Стоимость всех остатков: {self.get_total_stock_value():.2f} ₽")

    def __repr__(self):
        return (f"Shop(name='{self.name}', area={self.area}, "
                f"products_count={self.get_products_count()})")


if __name__ == "__main__":
    p1 = Product("Молоко", 106.9, 30)
    p2 = Product("Хлеб", 119.9, 20)
    p3 = Product("Масло", 350.0, 10)

    shop = Shop("Продуктовый", 120.0)
    shop.add_product(p1)
    shop.add_product(p2)
    shop.add_product(p3)

    print(shop)
    print("\nСписок товаров:")
    for prod in shop.products:
        print("  -", prod)

    found = shop.find_product("Масло")
    if found:
        print(f"\nНайдено по артикулу 'Масло': {found}")

    customer = Customer("Валя Холод")
    item = shop.find_product("Хлеб")
    if item and item.stock >= 2:
        customer.add_purchase(item.sku, 2, item.price)
        item.stock -= 2

    print("\n", customer, sep="")
    print("\nОстаток после покупки по 'Хлеб':", shop.find_product("Хлеб").stock)
