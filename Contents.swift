/*:
 # Using Type Aliases in POP
 ## Lets review generics
*/
protocol CanAddOne {
    func addOne() -> Self
}

extension Int: CanAddOne {
    func addOne() -> Int {
        return self + 1
    }
}

extension Double: CanAddOne {
    func addOne() -> Double {
        return self + 1
    }
}

func incrementBetter<T: CanAddOne>(foo: T) -> T {
    return foo.addOne()
}

incrementBetter(1)
incrementBetter(1.0)

//: ## Inferring AssociatedType
protocol Furniture {
    associatedtype M
    func mainMaterial() -> M
    func secondaryMaterial() -> M
}

struct Chair: Furniture {
    func mainMaterial() -> String {
        return "Wood"
    }
    
    func secondaryMaterial() -> String {
        return "More Wood"
    }
}

struct Lamp: Furniture {
    func mainMaterial() -> Bool {
        return true
    }

    func secondaryMaterial() -> Bool {
        return true
    }
    
//: This function will fail. The type of M is unkown to the protocol, but once inside a implementation its type becomes known. Inside this implementation it knows M is a Bool. The function below returns a String. The compiler will catch this.
    /*
    func secondaryMaterial() -> String {
        return "Wood"
    }
    */
}

//: In the example above M can be anything. We can constrain it to only allow certain types
protocol Material {}
struct Wood: Material {}
struct Glass: Material {}
struct Metal: Material {}
struct Cotton: Material {}

protocol Furniture2 {
    associatedtype M: Material
    func mainMaterial() -> M
    func secondaryMaterial() -> M
}

struct Table: Furniture2 {
    func mainMaterial() -> Wood {
        return Wood()
    }
    
    func secondaryMaterial() -> Wood {
        return Wood()
    }
}

struct Vase: Furniture2 {
    func mainMaterial() -> Glass {
        return Glass()
    }
    
    func secondaryMaterial() -> Glass {
        return Glass()
    }
}

/*:
## Gotchas
    - If you want the functions mainMaterial and secondaryMaterial to return different Material types then you have to create another associatedtype
        protocol Furniture {
            associatedtype M: Material
            associatedtype M2: Material
            func mainMaterial() -> M
            func secondaryMaterial() -> M2
        }
    - mainMaterial() and secondaryMaterial() can not be declared to return Material. The function below will fail.
         func mainMaterial() -> Material {
             return Glass()
         }
 
## AssociatedType for Self
    Note: In Swift <2.0 it was possible for a typealias to reference itself. This is no longer valid. The code below was valid in Swift 1.2
        protocol Furniture {
            typealias T: Furniture
        }
*/
protocol Furniture3 {
    associatedtype M: Material
    func mainMaterial() -> M
    func secondaryMaterial() -> M
    static func factory() -> Self
}

final class Mirror: Furniture3 {
    func mainMaterial() -> Glass {
        return Glass()
    }
    func secondaryMaterial() -> Glass {
        return Glass()
    }
    static func factory() -> Mirror {
        return Mirror()
    }
}


