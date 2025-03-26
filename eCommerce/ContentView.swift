import SwiftUI

// MARK: - Product Model
struct Product: Identifiable {
    let id = UUID()
    let name: String
    let price: Double
    let imageName: String
}

// MARK: - Cart Manager
class CartManager: ObservableObject {
    @Published var cartItems: [Product] = []
    
    func addToCart(product: Product) {
        cartItems.append(product)
    }
    
    func removeFromCart(product: Product) {
        cartItems.removeAll { $0.id == product.id }
    }
}

// MARK: - Product List View
struct ProductListView: View {
    let products = [
        Product(name: "Laptop", price: 999.99, imageName: "laptop"),
        Product(name: "Headphones", price: 199.99, imageName: "headphones"),
        Product(name: "Smartphone", price: 799.99, imageName: "smartphone")
    ]
    
    @StateObject var cartManager = CartManager()
    
    var body: some View {
        NavigationStack {
            List(products) { product in
                NavigationLink(destination: ProductDetailView(product: product, cartManager: cartManager)) {
                    HStack {
                        Image(systemName: "cart") // Placeholder image
                        Text(product.name)
                        Spacer()
                        Text("$\(product.price, specifier: "%.2f")")
                    }
                }
            }
            .navigationTitle("Products")
            .toolbar {
                NavigationLink(destination: CartView(cartManager: cartManager)) {
                    Image(systemName: "cart.fill")
                }
            }
        }
    }
}

// MARK: - Product Detail View
struct ProductDetailView: View {
    let product: Product
    @ObservedObject var cartManager: CartManager
    
    var body: some View {
        VStack {
            Image(systemName: "photo") // Placeholder image
                .resizable()
                .frame(width: 200, height: 200)
            Text(product.name)
                .font(.title)
                .padding()
            Text("$\(product.price, specifier: "%.2f")")
                .font(.headline)
                .padding()
            Button("Add to Cart") {
                cartManager.addToCart(product: product)
            }
            .buttonStyle(.borderedProminent)
            .padding()
            Spacer()
        }
        .navigationTitle(product.name)
    }
}

// MARK: - Cart View
struct CartView: View {
    @ObservedObject var cartManager: CartManager
    
    var body: some View {
        VStack {
            List {
                ForEach(cartManager.cartItems) { product in
                    HStack {
                        Text(product.name)
                        Spacer()
                        Text("$\(product.price, specifier: "%.2f")")
                    }
                }
                .onDelete { indexSet in
                    indexSet.forEach { cartManager.cartItems.remove(at: $0) }
                }
            }
            .navigationTitle("Cart")
            
            if !cartManager.cartItems.isEmpty {
                Button("Checkout") {
                    // Future checkout functionality
                }
                .buttonStyle(.borderedProminent)
                .padding()
            }
        }
    }
}

