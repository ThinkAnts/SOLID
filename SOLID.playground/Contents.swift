// 🎨 Design Characters

import UIKit


// MARK: - Single Responsiblity Principle (SRP)
/*
    NOTES:
    A class should only be responsible for one thing
 */

// BAD WAY:  Implementation

struct Product {
  let price: Double
}

struct Invoice {
  var products: [Product]
  let id = NSUUID().uuidString
  var discountPercentage: Double = 0
  
  var total: Double {
    let total = products.map({$0.price}).reduce(0, { $0 + $1})
    let discountedAmount = total * (discountPercentage / 100)
    return total - discountedAmount
  }
  
//  func printInvoice() {
//    print("----------------------")
//    print("Invoice id: \(id)")
//    print("Total Cost $\(total)")
//    print("Discounts: \(discountPercentage)")
//    print("----------------------")
//  }
//
//  func saveInvoice() {
//    // save invoice data locally or to database
//  }
}

let products: [Product] = [
  .init(price: 99.00),
  .init(price: 9.00),
  .init(price: 999.00)
]

let invoice = Invoice(products: products, discountPercentage: 20)
//invoice.printInvoice() // Dont call like this.

// SRP: Implementaion

struct InvoicePrinter {
  let invoice: Invoice
  
  func printInvoice() {
    print("----------------------")
    print("Invoice id: \(invoice.id)")
    print("Total Cost $\(invoice.total)")
    print("Discounts: \(invoice.discountPercentage)")
    print("----------------------")
  }
}

struct InvoicePersistance {
  let invoice: Invoice
  
  func saveInvoice() {
    // save invoice data locally or to database
  }
}

let invoice1 = Invoice(products: products, discountPercentage: 20)
let invoicePrinter = InvoicePrinter(invoice: invoice1)
invoicePrinter.printInvoice()
let invoicePersistance = InvoicePersistance(invoice: invoice1)
invoicePersistance.saveInvoice()

// MARK: - Open/Closed Principle (OCP)
/*
    NOTES:
     Software entities ( Classes, modules, functions etc) should be open for extension but closed for modification
    In other words, we can add additional functionality (extensions) with out touching the existing code.
 */

//Example well familar

extension Int {
  func squared() -> Int {
      return self * self
  }
}

var num = 2
num.squared()


struct InvoicePersistanceOCP {
  let persistance: InvoicePersistable
  
  func save(invoice: Invoice) {
    persistance.save(invoice: invoice)
  }
  
}

protocol InvoicePersistable {
  func save(invoice: Invoice)
}

struct CoreDataPersistance: InvoicePersistable {
  func save(invoice: Invoice) {
    print(" Save to Coredata \(invoice.id)")
  }
}

struct DatabasePersistance: InvoicePersistable {
  func save(invoice: Invoice) {
    print(" Save to FireSTore \(invoice.id)")
  }
}

let coreDataPerristance = CoreDataPersistance()
let persistanceOCP = InvoicePersistanceOCP(persistance: coreDataPerristance)
coreDataPerristance.save(invoice: invoice)


// MARK: - Liskov Substituion Principle (LSP)
/*
    NOTES:
    Derived or child classes/structures must be substitutable for their base or parent classes.
 */

enum APIError: Error {
  case invlaidUrl
  case invalidResponse
  case invalidStatusCode
}

struct MockAPI {
  func fetchData() async throws {
    do {
      throw APIError.invalidResponse
    } catch {
        print("Error \(error)")
    }
  }
}

let mockSerice = MockAPI()
Task { try await mockSerice.fetchData()}

// MARK: - Interface seggerigation Principle (ISP)
/*
    NOTES:
    Do not force any client to implement an interface which is irrelevant to them
 */

protocol GestureProtocol {
    func didTap()
    func didDoubleTap()
    func didLongPress()
}

struct SuperButton: GestureProtocol {
  func didTap() {
  }
  
  func didDoubleTap() {
  }
  
  func didLongPress() {
  }
  
}

struct DoubleTapButton: GestureProtocol {
  func didTap() { // This is also Not required
  }
  
  func didDoubleTap() {
  }
  
  func didLongPress() { // This is not required
  }
  
}

protocol SingleProtocol {
     func didTap()
}

protocol DoubleProtocol {
     func didDoubleTap()
}

protocol LongPressProtocol {
     func didLongPress()
}


struct DoubleTapButton1: DoubleProtocol {
  func didDoubleTap() {
  }
}


// MARK: - Dependency Inversion Principle (DIP)
/*
    NOTES:
    - High Level Module should not depend on low level module, but should depend on abstraction
    - if a high level module imports any low level module then the code becomes tightly coupled.
    - Changes in one class could break another class.
 */

// BADWAY :
struct DebitCardPayment: PaymentMethod {
  func execute(amount: Double) {
       print("Debit card amount \(amount)")
  }
}

struct CreditCardPayment: PaymentMethod {
  func execute(amount: Double) {
       print("Credit card amount \(amount)")
  }
}

struct ApplePayPayment: PaymentMethod {
  func execute(amount: Double) {
       print("Apple Pay amount \(amount)")
  }
}

struct Payment {
  var debitCardPayment: DebitCardPayment?
  var creditcardPayment: CreditCardPayment?
  var applePayPayment: ApplePayPayment?
}


let dPayment = DebitCardPayment()
let payment = Payment(debitCardPayment: dPayment, creditcardPayment: nil, applePayPayment: nil)

payment.debitCardPayment?.execute(amount: 200)

// DIP WAY :
protocol PaymentMethod {
  func execute(amount: Double)
}


struct PaymentDIP {
  let payment: PaymentMethod
  
  func makePayment(amount: Double) {
    payment.execute(amount: amount)
  }
}

let cPayment = CreditCardPayment()
let paymentDIP = PaymentDIP(payment: cPayment)
paymentDIP.makePayment(amount: 200)
