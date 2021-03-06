//
//  Created by Jesse Squires
//  http://www.jessesquires.com
//
//
//  Documentation
//  http://jessesquires.com/DefaultStringConvertible
//
//
//  GitHub
//  https://github.com/jessesquires/DefaultStringConvertible
//
//
//  License
//  Copyright © 2016 Jesse Squires
//  Released under an MIT license: http://opensource.org/licenses/MIT
//

private func generateDefaultDescription(_ any: Any) -> String {
    let mirror = Mirror(reflecting: any)
    var children = Array(mirror.children)

    var superclassMirror = mirror.superclassMirror
    repeat {
        if let superChildren = superclassMirror?.children {
            children.append(contentsOf: superChildren)
        }
        superclassMirror = superclassMirror?.superclassMirror
    } while superclassMirror != nil

    let chunks = children.map { (label: String?, value: Any) -> String in
        if let label = label {
            if value is String {
                return "\(label): \"\(value)\""
            }
            return "\(label): \(value)"
        }
        return "\(value)"
    }

    if chunks.count > 0 {
        let chunksString = chunks.joined(separator: ", ")
        return "\(mirror.subjectType)(\(chunksString))"
    }

    return "\(type(of: any))"
}

func generateDeepDescription(_ any: Any) -> String {

    func indentedString(_ string: String) -> String {
        return string
            .split(separator: "\n")
            .map { String($0).isEmpty ? "" : "\n    \($0)" }
            .joined(separator: "")
    }

    func deepUnwrap(_ any: Any) -> Any? {
        let mirror = Mirror(reflecting: any)

        if mirror.displayStyle != .optional {
            return any
        }

        if let child = mirror.children.first , child.label == "some" {
            return deepUnwrap(child.value)
        }

        return nil
    }

    guard let any = deepUnwrap(any) else {
        return "nil"
    }

    if any is Void {
        return "Void"
    }

    if let int = any as? Int {
        return String(int)
    } else if let double = any as? Double {
        return String(double)
    } else if let float = any as? Float {
        return String(float)
    } else if let bool = any as? Bool {
        return String(bool)
    } else if let string = any as? String {
        return "\"\(string)\""
    }

    let mirror = Mirror(reflecting: any)

    var properties = Array(mirror.children)

    var typeName = String(describing: mirror.subjectType)
    if typeName.hasSuffix(".Type") {
        typeName = ""
    } else { typeName = "<\(typeName)> " }

    guard let displayStyle = mirror.displayStyle else {
        return "\(typeName)\(String(describing: any))"
    }

    switch displayStyle {
    case .tuple:
        if properties.isEmpty { return "()" }

        var string = "("

        for (index, property) in properties.enumerated() {
            if property.label!.first! == "." {
                string += generateDeepDescription(property.value)
            } else {
                string += "\(property.label!): \(generateDeepDescription(property.value))"
            }

            string += (index < properties.count - 1 ? ", " : "")
        }
        return string + ")"

    case .collection, .set:
        if properties.isEmpty { return "[]" }

        var string = "["

        for (index, property) in properties.enumerated() {
            string += indentedString(generateDeepDescription(property.value) + (index < properties.count - 1 ? ",\n" : ""))
        }
        return string + "\n]"

    case .dictionary:
        if properties.isEmpty {
            return "[:]"
        }

        var string = "["
        for (index, property) in properties.enumerated() {
            let pair = Array(Mirror(reflecting: property.value).children)
            string += indentedString("\(generateDeepDescription(pair[0].value)): \(generateDeepDescription(pair[1].value))"
                + (index < properties.count - 1 ? ",\n" : ""))
        }
        return string + "\n]"

    case .enum:
        if let any = any as? CustomDebugStringConvertible {
            return any.debugDescription
        }

        if properties.isEmpty {
            return "\(mirror.subjectType)." + String(describing: any)
        }

        var string = "\(mirror.subjectType).\(properties.first!.label!)"
        let associatedValueString = generateDeepDescription(properties.first!.value)

        if associatedValueString.first! == "(" {
            string += associatedValueString
        } else {
            string += "(\(associatedValueString))"
        }
        return string

    case .struct, .class:
        if let any = any as? CustomDebugStringConvertible {
            return any.debugDescription
        }

        var superclassMirror = mirror.superclassMirror
        repeat {
            if let superChildren = superclassMirror?.children {
                properties.append(contentsOf: superChildren)
            }

            superclassMirror = superclassMirror?.superclassMirror
        } while superclassMirror != nil

        if properties.isEmpty { return "\(typeName)\(String(describing: any))" }
        var string = "\(typeName){"
        for (index, property) in properties.enumerated() {
            string += indentedString("\(property.label!): \(generateDeepDescription(property.value))" + (index < properties.count - 1 ? ",\n" : ""))
        }
        return string + "\n}"

    case .optional:
        return generateDefaultDescription(any)
    }
}
