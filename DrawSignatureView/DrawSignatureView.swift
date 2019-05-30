//
//  DrawSignatureView.swift
//  DrawSignatureView
//
//  Created by Mohammmad Tahir on 30/05/19.
//  Copyright © 2019 Mohammad Tahir. All rights reserved.
//

import Foundation

public enum TouchState {
  case began
  case moved
  case ended
  case none
}

open class DrawSignatureView: UIView {
  
  // MARK: - Public Properties
  @IBInspectable public var lineWidth: CGFloat = 2.0
  @IBInspectable public var strokeColor: UIColor = UIColor.red
  @IBInspectable public var signatureIsOpaque: Bool = true
  
  // Call Back
  public var currentTouchState: ((TouchState) -> ())?
  
  // MARK: - Private Method's
  private var isDrawing = false
  private var lastPoint: CGPoint!
  private var errorColor: UIColor = UIColor.red
  private var strokes = [Stroke]()
  private let errorMessage: String = "Background and stroke color's are matched, Assigned different color's to see the (Signature & Drawing)!"
  
  /// Error lable
  lazy private var errorLabel: UILabel = {
    let errorLbl = UILabel(frame: self.bounds)
    errorLbl.text = self.errorMessage
    errorLbl.numberOfLines = 0
    errorLbl.font = UIFont.systemFont(ofSize: 20, weight: .medium)
    errorLbl.textColor = errorColor
    errorLbl.textAlignment = .center
    errorLbl.lineBreakMode = .byWordWrapping
    return errorLbl
  }()
  
  open override func awakeFromNib() {
    super.awakeFromNib()
    self.addErrorLabel()
  }
  
  /// Check the line color and Background color is same or not if same then will show the error label
  private func addErrorLabel() {
    if self.isMatchColor {
      self.addSubview(self.errorLabel)
    }
  }
  
  override public init(frame: CGRect) {
    super.init(frame: frame)
    self.setup()
  }
  
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.setup()
  }
  
  /// Initial Setup
  private func setup() {
    self.setAccessibilityElements()
  }
  
  /// Set Voice Over Text
  private func setAccessibilityElements() {
    self.isAccessibilityElement = true
    self.accessibilityTraits = .allowsDirectInteraction
  }
  
  private var isMatchColor: Bool {
    
    return self.backgroundColor?.isEqual(self.strokeColor) == true
  }
  
  /// Check Drawing is available
  public var hasSignature: Bool {
    
    return !self.strokes.isEmpty
  }
  
  override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard self.isDrawing == false else { return }
    guard self.isMatchColor == false else { return }
    self.isDrawing = true
    guard let touch = touches.first else { return }
    let currentPoint = touch.location(in: self)
    self.lastPoint = currentPoint
    self.currentTouchState?(.began)
  }
  
  override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard self.isDrawing else { return }
    guard let touch = touches.first else { return }
    let currentPoint = touch.location(in: self)
    let stroke = Stroke(startPoint: lastPoint, endPoint: currentPoint, color: strokeColor.cgColor)
    self.strokes.append(stroke)
    self.lastPoint = currentPoint
    self.currentTouchState?(.moved)
    setNeedsDisplay()
  }
  
  override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard self.isDrawing else { return }
    self.isDrawing = false
    guard let touch = touches.first else { return }
    let currentPoint = touch.location(in: self)
    let stroke = Stroke(startPoint: lastPoint, endPoint: currentPoint, color: strokeColor.cgColor)
    self.strokes.append(stroke)
    self.lastPoint = nil
    self.currentTouchState?(.ended)
    setNeedsDisplay()
  }
  
  /// Add Line Path
  override open func draw(_ rect: CGRect) {
    super.draw(rect)
    // Draw Line
    let context = UIGraphicsGetCurrentContext()
    context?.setLineWidth(self.lineWidth)
    context?.setLineCap(.round)
    self.strokes.forEach { (stroke) in
      context?.beginPath()
      context?.move(to: stroke.startPoint)
      context?.addLine(to: stroke.endPoint)
      context?.setStrokeColor(stroke.color)
      context?.strokePath()
    }
  }
  
  /// Capture Image with Siganture Call Back
  public func captureSignature(_ signature: (Signature?) -> ()) {
    guard self.hasSignature else {
      signature(nil)
      return
    }
    
    let signatureImage = captureSignatureFromView()
    if let image = signatureImage {
      signature(Signature(signature: image))
    } else {
      signature(nil)
    }
  }
  
  // MARK: - Capture Image
  private func captureSignatureFromView() -> UIImage? {
    UIGraphicsBeginImageContextWithOptions(bounds.size, self.signatureIsOpaque, 0.0)
    guard let context = UIGraphicsGetCurrentContext() else {
      return nil
    }
    
    layer.render(in: context)
    let viewImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return viewImage
  }
  
  
  // MARK: - Erase
  public func erase() {
    self.currentTouchState?(.none)
    self.strokes.removeAll()
    setNeedsDisplay()
  }
  
  deinit {
    print("\(#function)")
  }
}

// Line Path Model
private struct Stroke {
  let startPoint: CGPoint
  let endPoint: CGPoint
  let color: CGColor
}

// MARK: - Signature Model
public struct Signature {
  
  private(set) public var image : UIImage
  private(set) public var date  : Date
  
  init(signature: UIImage) {
    self.image = signature
    self.date = Date()
  }
}
