import UIKit

class AccessSetup {
  static let padding: CGFloat = 20
  static let textFieldHeight: CGFloat = 40
  
  private enum KeyboardType {
    case Email
    case Password
    case Default
  }
  
  private struct ScrollViewObject {
    let view: UIScrollView
    let constraints: [NSLayoutConstraint]
    let bottomConstraint: NSLayoutConstraint
    let contentHeight: CGFloat = Constant.Button.padding
  }
  
  private struct TextFieldObject {
    let view: UITextField
    let constraints: [NSLayoutConstraint]
    let height: CGFloat
  }
  
  private struct ButtonObject {
    let view: UIButton
    let constraints: [NSLayoutConstraint]
    let height: CGFloat
  }
  
  static func createLogin(controller controller: UIViewController, email: UITextField, password: UITextField, login: UIButton, forgot: UIButton, signup: UIButton) {
    // controller
    var constraints: [NSLayoutConstraint] = []
    var height: CGFloat = Constant.Button.padding
    
    // create
    createController(controller: controller)
    let scrollViewObject: ScrollViewObject = createScrollViewObject(parent: controller.view)
    let emailObject = createTextFieldObject(textField: email, title: "email", view: controller.view, topItem: scrollViewObject.view, topAttribute: .Top, topPadding: Constant.Button.padding, keyboardType: .Email)
    let passwordObject = createTextFieldObject(textField: password, title: "password", view: controller.view, topItem: emailObject.view, topAttribute: .Bottom, topPadding: Constant.Button.padding*2, keyboardType: .Password)
    let loginObject = createButtonObject(button: login, title: "log in", view: controller.view, topItem: passwordObject.view, topAttribute: .Bottom, topPadding: Constant.Button.padding*2)
    
    // views
    controller.view.addSubview(scrollViewObject.view)
    scrollViewObject.view.addSubview(emailObject.view)
    scrollViewObject.view.addSubview(passwordObject.view)
    scrollViewObject.view.addSubview(loginObject.view)
    scrollViewObject.view.addSubview(signup)
    scrollViewObject.view.addSubview(forgot)
    
    // heights
    height += emailObject.height
    height += passwordObject.height
    height += loginObject.height
    scrollViewObject.view.contentSize = CGSize(width: 0, height: height)
    print(height)
    
    //    constraints += createTextField(textField: email, title: "email", view: scrollView, topAnchor: controller.view.topAnchor, type: .Email)
    //    constraints += createTextField(textField: password, title: "password", view: scrollView, topAnchor: email.bottomAnchor, type: .Password)
//        constraints += createButton(button: login, title: "log in", view: scrollView, topAnchor: password.bottomAnchor)
    //    constraints += createLink(button: forgot, title: "forgot password", view: scrollView, align: .Left, topAnchor: login.bottomAnchor, leadingAnchor: login.leadingAnchor, trailingAnchor: signup.leadingAnchor, widthAnchor: signup.widthAnchor)
    //    constraints += createLink(button: signup, title: "create account", view: scrollView, align: .Right, topAnchor: login.bottomAnchor, leadingAnchor: forgot.trailingAnchor, trailingAnchor: login.trailingAnchor, widthAnchor: forgot.widthAnchor)
    
    // scroll view

    
    // constraints
    constraints += scrollViewObject.constraints
    constraints += emailObject.constraints
    constraints += passwordObject.constraints
    constraints += loginObject.constraints
    NSLayoutConstraint.activateConstraints(constraints)
  }
  
  private static func createScrollViewObject(parent parent: UIView) -> ScrollViewObject {
    let view = UIScrollView()
    var constraints: [NSLayoutConstraint] = []
    let bottom = NSLayoutConstraint(item: view, attribute: .Bottom, relatedBy: .Equal, toItem: parent, attribute: .Bottom, multiplier: 1, constant: 0)
    view.translatesAutoresizingMaskIntoConstraints = false
    
    constraints.append(bottom)
    constraints.append(NSLayoutConstraint(item: view, attribute: .Top, relatedBy: .Equal, toItem: parent, attribute: .Top, multiplier: 1, constant: 0))
    constraints.append(NSLayoutConstraint(item: view, attribute: .Leading, relatedBy: .Equal, toItem: parent, attribute: .Leading, multiplier: 1, constant: 0))
    constraints.append(NSLayoutConstraint(item: view, attribute: .Trailing, relatedBy: .Equal, toItem: parent, attribute: .Trailing, multiplier: 1, constant: 0))
    
    let scrollViewObject = ScrollViewObject(view: view, constraints: constraints, bottomConstraint: bottom)
    return scrollViewObject
  }
  
  private static func createTextFieldObject(textField textField: UITextField, title: String, view: UIView, topItem: UIView, topAttribute: NSLayoutAttribute, topPadding: CGFloat, keyboardType: KeyboardType) -> TextFieldObject {
    textField.placeholder = title
    textField.borderStyle = .RoundedRect
    textField.tintColor = Constant.Color.button
    textField.keyboardType = keyboardType == .Email ? .EmailAddress : .Default
    textField.returnKeyType = .Next
    textField.secureTextEntry = keyboardType == .Password ? true : false
    textField.translatesAutoresizingMaskIntoConstraints = false
    
    var constraints: [NSLayoutConstraint] = []
    constraints.append(NSLayoutConstraint(item: textField, attribute: .Top, relatedBy: .Equal, toItem: topItem, attribute: topAttribute, multiplier: 1, constant: topPadding))
    constraints.append(NSLayoutConstraint(item: textField, attribute: .Leading, relatedBy: .Equal, toItem: view, attribute: .Leading, multiplier: 1, constant: Constant.Button.padding*2))
    constraints.append(NSLayoutConstraint(item: textField, attribute: .Trailing, relatedBy: .Equal, toItem: view, attribute: .Trailing, multiplier: 1, constant: -Constant.Button.padding*2))
    constraints.append(NSLayoutConstraint(item: textField, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: Constant.Button.height))

    let height: CGFloat = Constant.Button.height+topPadding
    let textFieldObject = TextFieldObject(view: textField, constraints: constraints, height: height)
    return textFieldObject
  }
  
  
  private static func createButtonObject(button button: UIButton, title: String, view: UIView, topItem: UIView, topAttribute: NSLayoutAttribute, topPadding: CGFloat) -> ButtonObject {
    button.setTitle(title, forState: .Normal)
    button.layer.cornerRadius = 5
    button.clipsToBounds = true
    button.backgroundColor = Constant.Color.button
    button.setBackgroundImage(Constant.Color.button.image, forState: .Normal)
    button.setBackgroundImage(Constant.Color.shadow.image, forState: .Highlighted)
    button.translatesAutoresizingMaskIntoConstraints = false
    
    var constraints: [NSLayoutConstraint] = []
    constraints.append(NSLayoutConstraint(item: button, attribute: .Top, relatedBy: .Equal, toItem: topItem, attribute: topAttribute, multiplier: 1, constant: topPadding))
    constraints.append(NSLayoutConstraint(item: button, attribute: .Leading, relatedBy: .Equal, toItem: view, attribute: .Leading, multiplier: 1, constant: Constant.Button.padding*2))
    constraints.append(NSLayoutConstraint(item: button, attribute: .Trailing, relatedBy: .Equal, toItem: view, attribute: .Trailing, multiplier: 1, constant: -Constant.Button.padding*2))
    constraints.append(NSLayoutConstraint(item: button, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: Constant.Button.height))
    
    let height: CGFloat = Constant.Button.height+topPadding
    let buttonObject = ButtonObject(view: button, constraints: constraints, height: height)
    return buttonObject
  }
  
  
  static func createSignup(controller controller: UIViewController, email: UITextField, passwordOne: UITextField, passwordTwo: UITextField, signup: UIButton) {
    controller.view.addSubview(email)
    controller.view.addSubview(passwordOne)
    controller.view.addSubview(passwordTwo)
    controller.view.addSubview(signup)
    
    createController(controller: controller)
    
    var constraints: [NSLayoutConstraint] = []
    constraints += createTextField(textField: email, title: "email", view: controller.view, topAnchor: controller.view.topAnchor, type: .Email)
    constraints += createTextField(textField: passwordOne, title: "password", view: controller.view, topAnchor: email.bottomAnchor, type: .Password)
    constraints += createTextField(textField: passwordTwo, title: "confirm password", view: controller.view, topAnchor: passwordOne.bottomAnchor, type: .Password)
    constraints += createButton(button: signup, title: "sign up", view: controller.view, topAnchor: passwordTwo.bottomAnchor)
    NSLayoutConstraint.activateConstraints(constraints)
  }
  
  static func createForgot(controller controller: UIViewController, email: UITextField, forgot: UIButton) {
    controller.view.addSubview(email)
    controller.view.addSubview(forgot)
    
    createController(controller: controller)
    
    var constraints: [NSLayoutConstraint] = []
    constraints += createTextField(textField: email, title: "email", view: controller.view, topAnchor: controller.view.topAnchor, type: .Email)
    constraints += createButton(button: forgot, title: "retrieve password", view: controller.view, topAnchor: email.bottomAnchor)
    NSLayoutConstraint.activateConstraints(constraints)
  }
  
  private static func createController(controller controller: UIViewController) {
    // prevent flash of gray when transitioning between controllers
    controller.view.backgroundColor = Constant.Color.background
    // add navigation title
    controller.navigationItem.title = Constant.App.name
    // remove back button text
    controller.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
  }
  
  private static func createTextField(textField textField: UITextField, title: String, view: UIView, topAnchor: NSLayoutYAxisAnchor, type: KeyboardType) -> [NSLayoutConstraint] {
    textField.placeholder = title
    textField.borderStyle = .RoundedRect
    textField.tintColor = Constant.Color.button
    textField.keyboardType = type == .Email ? .EmailAddress : .Default
    textField.returnKeyType = .Next
    textField.secureTextEntry = type == .Password ? true : false
    textField.translatesAutoresizingMaskIntoConstraints = false
    
    return [
      textField.topAnchor.constraintEqualToAnchor(topAnchor, constant: padding),
      textField.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor, constant: padding),
      textField.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor, constant: -padding),
      textField.heightAnchor.constraintEqualToConstant(textFieldHeight),
    ]
  }
  
  private static func createButton(button button: UIButton, title: String, view: UIView, topAnchor: NSLayoutYAxisAnchor) -> [NSLayoutConstraint] {
    button.setTitle(title, forState: .Normal)
    button.layer.cornerRadius = 5
    button.clipsToBounds = true
    button.backgroundColor = Constant.Color.button
    button.setBackgroundImage(Constant.Color.button.image, forState: .Normal)
    button.setBackgroundImage(Constant.Color.shadow.image, forState: .Highlighted)
    button.translatesAutoresizingMaskIntoConstraints = false
    
    return [
      button.topAnchor.constraintEqualToAnchor(topAnchor, constant: padding),
      button.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor, constant: padding),
      button.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor, constant: -padding),
      button.heightAnchor.constraintEqualToConstant(textFieldHeight),
    ]
  }
  
  private static func createLink(button button: UIButton, title: String, view: UIView, align: UIControlContentHorizontalAlignment, topAnchor: NSLayoutYAxisAnchor, leadingAnchor: NSLayoutXAxisAnchor, trailingAnchor: NSLayoutXAxisAnchor, widthAnchor: NSLayoutDimension) -> [NSLayoutConstraint] {
    button.setTitle(title, forState: .Normal)
    button.backgroundColor = Constant.Color.background
    button.contentHorizontalAlignment = align
    button.setTitleColor(Constant.Color.button, forState: .Normal)
    button.setTitleColor(Constant.Color.shadow, forState: .Highlighted)
    button.translatesAutoresizingMaskIntoConstraints = false
    
    return [
      button.topAnchor.constraintEqualToAnchor(topAnchor, constant: padding),
      button.leadingAnchor.constraintEqualToAnchor(leadingAnchor),
      button.trailingAnchor.constraintEqualToAnchor(trailingAnchor),
      button.heightAnchor.constraintEqualToConstant(textFieldHeight),
      button.widthAnchor.constraintEqualToAnchor(widthAnchor),
    ]
  }
}