import 'dart:io';

class Product {
  String name;
  String description;
  double price;

  Product(this.name, this.description, this.price);
}

class ProductManager {
  List<Product> products = [];

  void addProduct() {
    print("enter product name , description , price");
    String? name = stdin.readLineSync();
    String? description = stdin.readLineSync();
    double? price = double.tryParse(stdin.readLineSync()!);

    if (name != null && description != null && price != null) {
      products.add(Product(name, description, price));
      print("product added");
    } else {
      print(" invalid input");
    }
  }

  void viewAllProducts() {
    if (products.isEmpty) {
      print(" no product yet");
    } else {
      for (int i = 0; i < products.length; i++) {
        print(
            "$i: ${products[i].name}, ${products[i].description}, \$${products[i].price}");
      }
    }
  }

  void viewProduct() {
    print("enter index");
    int? index = int.tryParse(stdin.readLineSync()!);
    if (index != null && index >= 0 && index < products.length) {
      Product p = products[index];
      print("${p.name}, ${p.description}, ${p.price}");
    } else {
      print("no product found");
    }
  }

  void editProduct() {
    print("Enter index to edit:");
    int? index = int.tryParse(stdin.readLineSync()!);

    if (index != null && index >= 0 && index < products.length) {
      print("Enter new name:");
      String? name = stdin.readLineSync();

      print("Enter new description:");
      String? description = stdin.readLineSync();

      print("Enter new price:");
      double? price = double.tryParse(stdin.readLineSync()!);

      if (name != null && description != null && price != null) {
        products[index].name = name;
        products[index].description = description;
        products[index].price = price;
        print("Product updated.");
      } else {
        print("Invalid input.");
      }
    } else {
      print("Product not found.");
    }
  }

  void deleteProduct() {
    print("enter index");
    int? index = int.tryParse(stdin.readLineSync()!);

    if (index != null && index >= 0 && index < products.length) {
      products.removeAt(index);
      print(" product removed");
    } else {
      print("product not found");
    }
  }
}

void main() {
  ProductManager manage = ProductManager();
  bool running = true;

  while (running) {
    print("1. add product");
    print("2. view all product");
    print("3. view product");
    print("4. edit product");
    print("5. delete product"); // ✅ Fixed spelling here
    print("6. exit");

    String? choice = stdin.readLineSync();

    switch (choice) {
      case '1':
        manage.addProduct();
        break;
      case '2':
        manage.viewAllProducts();
        break;
      case '3':
        manage.viewProduct();
        break;
      case '4':
        manage.editProduct();
        break;
      case '5':
        manage.deleteProduct(); // ✅ Fixed function name here
        break;
      case '6':
        running = false;
        break;
      default:
        print("Invalid choice");
        break;
    }
  }
}
