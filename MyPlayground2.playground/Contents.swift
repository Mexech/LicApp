import Foundation
func castString(completeionHandler: @escaping (String?) -> String){
    let newStr = "asds"
    completeionHandler(newStr)
}

func doStuff() -> String{
    let thing : String = castString(){ str in
        return
    }
    return thing
}

print(doStuff())
