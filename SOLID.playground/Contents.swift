// 🎨 Design Characters

import UIKit


class ZooEntity {
  // classes are blueprints for concepts
  // atrributes [properties]
  
  //Visitor attributes
  let visitorName
  let age
  let gender
  let address
  
  //Zoo Staff attributes
  let staffName
  let employeeId
  let monthlySalary
  let address
  let gender
  
  // animal attributes
  let name
  let gender
  let species
  let weight
  
  // Methods [ behavior ]
  // visitor behavior
  func roamAroundAndLook()
  func takePictures()
  func buyTicket()
  func eat()
  func poop()
  // staff behavior
  func cleanPremises()
  func eat()
  func poop()
  func routineCheckupOnAnimals()
}


/*
 🐞 Problems with the above code?
 ❓ Readable
 It looks pretty readable. But there are some issues.
 Imagine if we had more charcters
 - different types of employees
 - managers
 - special (VVIP) guests
 - transfer animals
 - trainers for the animals
 Right now it is readable, but as the complexity grows, it will quickly become unreadable
 ❓ Testable
 Testing is difficult because making changes to staff behavior can cause unexpected changes in visitor
 behavior - because all the code is tied to each other - using the same class state
 Tightly coupled
 ❓ Extensible
 we'll come back to this later
 ❓ Maintainable
 imagine that there are 10 devs working on different animals / staff / visitors - all of them are modifying
 the same file
 when they commit the code and submit it, they will get merge conflicts!
 
 */


// MARK: HOW TO FIX THIS?

// --------------------------------------
// MARK: S
/*
 ==================================
 ⭐ Single Responsibility Principle
 ==================================
 
 - Every class/function/module (unit-of-code) should have 1 and only 1 "well-defined" responsibility.
 - Any piece of code should have only 1 reason to change
 - if you identify a piece of code which violates this - you should split that code into multiple pieces
 

 */

class ZooEntity1 {
  let name
  let age
  let gender
  
  func poop()
  func eat()
}

// Individual responsiblties will go separate pieces of code

class Visitor: ZooEntity1 {
  let address
  
  func roamAroundAndLook()
  func takePictures()
  func buyTicket()
  
}

class ZooStaff: ZooEntity1 {
  let employeeId
  let monthlySalary
  let address
  
  func cleanPremises()
  func routineCheckOnAnimals()
  
}

class Animal: ZooEntity1 {
  let species
  let weight
  
}

/*
 - Readable
 Aren't there wayy too many classes & files now? Yes!
 In reality whenever you want to make a code change, you are working with 1 specific feature/request - you
 only need to look at a handful of files
 Yes, we've more files, but each file is very very easy to read
 - Testable
 Now the code is decoupled - making changes in one class doesn't effect the other classes!
 It becomes easier to test correctly and exhaustively!
 - Maintainable
 Now if a dev is working on visitor, another dev is working on animal - will they have merge conflicts?
 No!
 the dev working on visitor doesn't need to know anything about animals
 
 */

// 🐦 Design a Bird
class Bird: Animal {
  var species = ""
  var beakLength: String?
  var wingSpan: String?
  
  init(species: String = "", beakLength: String? = nil, wingSpan: String? = nil) {
    self.species = species
    self.beakLength = beakLength
    self.wingSpan = wingSpan
  }
  
  func fly() {
    if species == "Sparrow" {
      print("flap wings and fly low")
    } else if species == "Eagle" {
      print("glide elegantly very high in the sky")
    } else if species == "Peacock" {
      print("only pehens can fly, make peacocks cant")
    }
  }
}

// 🕊 Different birds fly differently
// Add a new type of bird which flies in different manner
// Consider scientists discovered a new bird called HeliBird

class ZooGame {
  let sparrow = Bird(species: "tets")
  //sparrow.fly()
  
  var eagle = Bird(species: "eagle");
  //eagle.fly()
}



// 🐞 Problems with the above code?
/*
 - Readable
 - Testable
 - Maintainable
 - Extensible - FOCUS!
 A lot of times, we might not have modificiation access to some code. In this case, we might not be able to
 extend it.
 */

//MARK: OC
/*
 =======================
 ⭐ Open/Close Principle
 =======================
 - Your code should be closed for modification, yet, open for extension!
 - We wish the code that we've written to be "owned" by us - others should NOT be able to make
 modifications
 - At the same time, we wish others to be able to add new functionality - they should be able to extend it.
 
 */

class Bird1: Animal {
  var species = ""
  var beakLength: String?
  var wingSpan: String?
  
  func fly()
}

class sparrow: Bird1 {
  func fly() {
    print("flap")
  }
}

class eagle: Bird1 {
  func fly() {
    print("glide elegantly very high in the sky")
  }
}

//You should plan for these future "extensions" preemptively!
// As the library author, it is your responsibility to write code that follows Open/Close from day 1

//🐓 Can all the birds fly?
// =========================

class Kiwi: Bird1 {
  func fly() {
    print("Kiwi can't fly")
  }
}

/*
 Are there some species of birds which can't fly?
 Penguins, Kiwi, Ostrich, Emu, Dodo ...
 >
 > ❓ How do we solve this?
 >
 > • Throw exception with a proper message?
 > • Don't implement the `fly()` method?
 > • Return `null`?
 > • Redesign the system?
 */

// 🏃 Run away from the problem - Simply don't implement the fly() method
// Throw a proper exception / return null -- an option
class Kiwi1 : Bird {
  func fly() throws -> String {
    throw "Kiwi's cant fly "
  }
}

// ❌ Tomorrow, an intern comes - they wanna implement a new Bird

//MARK: L
/*
 ==================================
 ⭐ Liskov's Subtitution Principle
 ==================================
 - don't break contracts!
 - Any object of child class `class Child extends Parent` should be able to replace any object of a parent
 class, without any issues - the code should still work as before
 */

// accept the fact that not all birds can fly

class Bird2 {
// we should NOT have abstract void fly
// because if we do, then our children might be forced to voilate our contract
func poop()
func  eat()
}

protocol ICanFly {
func fly()
func kickToTakeOff(); // actions that the bird will take
func flapWings(); // before starting to fly
}

class Sparrow1: Bird, ICanFly {
func fly() { print("fly low") }
}

class Eagle1: Bird, ICanFly {
func  fly() { print("fly low") }
}

class Kiwi2: Bird {
  // because it doesn't implement
}

//✈️What else can fly?
class Shaktiman: ICanFly {
  func fly() { print("spin fast") }
  func flapWings() {
    // Sorry Shaktiman!
  }
}

//MARK: I
/*
 ==================================
 ⭐ Interface Segregation Principle
 ==================================
 - keep your interfaces minimal
 - don't have fat interfaces
 - your clients should not be forced to implement methods that they don't require
 
 */
//How will you fix `ICanFly`?

protocol ICanFly1 {
  func fly()
}
protocol IHasWings {
  func flapWings() // before starting to fly
}
protocol ICanJump {
  func kickToTakeOff() // actions that the bird will take
}

class Sparrow : Bird, ICanFly, IHasWings, ICanJump {
  func fly() { print("fly low") }
  func flapWings() { print("flap flap") }
  func kickToTakeOff() { print("small little jumpie jumpie") }
}

class Shaktiman: ICanFly {
  func fly() { print("spin fast") }
  
  // shaktiman doesn't jump
  // shaktiman doesn't
}

//? Isn't this just the Single Responsibility applied to interfaces?
//Yes
// 🔗 SOLID principles are linked together

/*
 🗑 Design a Cage
 ================
*/

protocol IDoor { // High level abstraction
  func resistEscape(animal: Animal ) // "do this"
  func resistAttack(attack: Attack) // I don't know how
}

class WoodenDoor:  IDoor { // Low level implementation
  func resistEscape(Animal: animal) {
    // put the animal back in the cage
    animal.setLocation(this.cage.center); // this is exactly how
    // to resist excape
  }
  
  func resistAttack(Attack: attack) {
    if(attack.power <= this.cage.power) {
      this.cage.health -= attack.power;
    } else {
      this.cage.destroy()
    }
  }
}

class IronDoor: IDoor { /*...*/ } // Low Level Implementation
class AdamantiumDoor: IDoor { /*...*/  } // Low Level Implementation
class VibraniumDoor:  IDoor { /*...*/  } // Low Level Implementation

protocol FeedingBowl { // High Level Abstraction
  func feedAnimal(Animal: animal);
}
class FruitBowl: FeedingBowl { /*...*/ } // Low Level Implementation
class MeatBowl: FeedingBowl { /*...*/ } // Low Level Implementation
class GrainBowl:  FeedingBowl { /*...*/ } // Low Level Implementation


class Cage1 { // High level code
  // this cage is for tigers // because it delegates
  // "Controller"
  var door: IronDoor
  var  bowl: MeatBowl
  
  var kitties = [Tiger]()
  
  
  public func Cage1() {
    // create the dependencies
    door = IronDoor();
    bowl = MeatBowl();
    kitties.append( Tiger("simba"));
    kitties.append( Tiger("black panther"));
  }
  
  func  resistAttack(Attack: attack) {
    // delegate the task to the door
    door.resistAttack(attack);
  }
  
  func resistEscape(Animal: animal) {
    door.resistEscape(animal);
  }
  
  func feed() {
    for(Tiger t: this.kitties) {
      bowl.feed(t)
    }
  }
  
}

class Cage2 {
// this cage is for peacocks
  var door: WoodenDoor
  var bowl: FruitBowl
  
  var beauties: [Peacocks] = []
  
  public func Cage1() {
    // create the dependencies
    door =  WoodenDoor();
    bowl =  FruitBowl();
    beauties.append(Peacock("pea1"))
    beauties.append(Peacock("pea2"))
  }
}
// 100 more different cages

class ZooGame {
  func main() {
    let forTigers = Cage1();
    let forPeacocks = Cage2();
  }
}

//🐞 Lot of code repetition
// - every cage is a new class
// - if I wish to create a new cage - I need to implement a new class

/*
 Another Issue:::
 - first need to understand what "high level" and "low level" code is
 
 - High Level abstractions::: 
 
 - they tell you what to do, but not how to do it on a factory floor,
 - managers are high level employees:::
 - they tell you what to do, not how to do it
 - CEO - high level - set the goals - what needs to be done
 
 - Low Level implementation details:::
 
 - they tell you how exactly to do something
 - engineers / workers
 - actually performs the job
 - they know exactly how to do things
 ```
 -------      --------- -------
 IBowl         IAnimal   IDoor      high level abstractions
 -------      --------- -------
 ║                ║        ║
 ║                ║        ║
 ┏━━━━━━━━━━┓ ┏━━━━━━━┓ ┏━━━━━━━━━━┓
 ┃ MeatBowl ┃ ┃ Tiger ┃ ┃ IronDoor ┃ low level implementations
 ┗━━━━━━━━━━┛ ┗━━━━━━━┛ ┗━━━━━━━━━━┛
 │               │               │
 ╰───────────────╁───────────────╯
                 ┃
             ┏━━━━━━━┓

             ┃ Cage1 ┃ high level controller

             ┗━━━━━━━┛
 ```
    High level class `Cage1` depends on low level implementations `Tiger`, `MeatBowl`, `IronDoor`
 */

//MARK: D

/*
 =================================
 ⭐ Dependency Inversion Principle - what to do? guideline
 =================================

 - High level code should NEVER depend on low level implementation details
 - Instead, it should depend only on high level abstractions

 ```
 -------     ---------   -------
 IBowl        IAnimal     IDoor
 -------     ---------   -------
 │               │              │
 ╰───────────────╁──────────────╯
                 ┃
              ┏━━━━━━┓
              ┃ Cage ┃
              ┗━━━━━━┛
 */


// But how?

//=======================
//💉 Dependency Injection - how to acieve that guideline
// =======================
// - don't create the dependencies yourself
// - instead, let your client create the dependencies, and inject them into you
// - client = any piece of code that uses you

class Cage {
  // this is a generic cage - it works for anything
  var door: IDoor;
  var bowl: IBowl
  var inhabitants = [Animal]()
  // inject the dependencies via the constructor
  // vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
  
  public func Cage(door: IDoor,bowl: IBowl, inhabitants: [Animal]) {
    self.door = door
    self.bowl = bowl
    self.inhabitants = inhabitants
  }
}

class ZooGame {
  func main() {
    let forTigers = Cage(
       IronDoor(),
        MeatBowl(),
      Arrays.asList( Tiger("simba"),  Tiger("panther"))
    )
    
    let forPeacocks =  Cage(
      WoodenDoor(),
      FruitBowl(),
      Arrays.asList( Peacock("pea1"),  Peacock("pea2"))
    )
    
    let forDucks =  Cage(
      WoodenDoor(),
      GrainBowl(),
      Arrays.asList( Duck("duckie1"),  Duck("duckie2"))
    )
    
  }
}
