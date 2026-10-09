// Công cụ xử lý PDF đề thi (chỉ macOS, dùng PDFKit + Vision có sẵn, không cần cài thêm).
//
//   swift tool/pdf_tool.swift info   <file.pdf>
//   swift tool/pdf_tool.swift text   <file.pdf> <từ trang> <đến trang>          # text layer (PDF số)
//   swift tool/pdf_tool.swift ocr    <file.pdf> <từ trang> <đến trang>          # OCR (PDF scan)
//   swift tool/pdf_tool.swift render <file.pdf> <từ> <đến> <thư mục ra> [dpi=110]  # PNG từng trang
//   swift tool/pdf_tool.swift split  <file.pdf> <từ> <đến> <file ra.pdf>        # cắt 1 đoạn trang
//   swift tool/pdf_tool.swift crop   <file.pdf> <trang> <x> <y> <w> <h> <ra.jpg> [dpi=200]  # tỉ lệ 0–1
//   swift tool/pdf_tool.swift sheet  <file.pdf> <từ> <đến> <ra.png> [cột=5] [dpi=28]  # lưới thu nhỏ để xem lướt
//
// Trang đánh số từ 1. File gốc chỉ được đọc, không bị sửa.
import AppKit
import Foundation
import PDFKit
import Vision

func fail(_ msg: String) -> Never {
  FileHandle.standardError.write((msg + "\n").data(using: .utf8)!)
  exit(1)
}

let args = CommandLine.arguments
guard args.count >= 3 else {
  fail("Cách dùng: swift tool/pdf_tool.swift <info|text|ocr|render|split> <file.pdf> ...")
}
let cmd = args[1]
guard let doc = PDFDocument(url: URL(fileURLWithPath: args[2])) else { fail("Không mở được PDF: \(args[2])") }

func range() -> ClosedRange<Int> {
  guard args.count >= 5, let a = Int(args[3]), let b = Int(args[4]), a >= 1, b >= a, b <= doc.pageCount
  else { fail("Khoảng trang không hợp lệ (1…\(doc.pageCount))") }
  return a...b
}

func render(_ page: PDFPage, dpi: CGFloat) -> CGImage? {
  let box = page.bounds(for: .mediaBox)
  let scale = dpi / 72
  let w = Int(box.width * scale), h = Int(box.height * scale)
  guard let ctx = CGContext(
    data: nil, width: w, height: h, bitsPerComponent: 8, bytesPerRow: 0,
    space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue)
  else { return nil }
  ctx.setFillColor(CGColor(gray: 1, alpha: 1))
  ctx.fill(CGRect(x: 0, y: 0, width: w, height: h))
  ctx.scaleBy(x: scale, y: scale)
  page.draw(with: .mediaBox, to: ctx)
  return ctx.makeImage()
}

switch cmd {
case "info":
  var withText = 0
  let sample = Array(stride(from: 0, to: doc.pageCount, by: max(1, doc.pageCount / 20)))
  for i in sample where (doc.page(at: i)?.string?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0) > 50 {
    withText += 1
  }
  let first = doc.page(at: 0)?.bounds(for: .mediaBox) ?? .zero
  print("Số trang: \(doc.pageCount)")
  print("Khổ trang: \(Int(first.width))×\(Int(first.height)) pt")
  print("Trang có text layer (mẫu \(sample.count) trang): \(withText)")
  print(withText * 2 >= sample.count ? "→ PDF số: dùng lệnh `text`" : "→ PDF scan: dùng lệnh `ocr`")
  if let outline = doc.outlineRoot, outline.numberOfChildren > 0 {
    print("Mục lục:")
    for i in 0..<outline.numberOfChildren {
      guard let item = outline.child(at: i) else { continue }
      let p = item.destination?.page.map { doc.index(for: $0) + 1 } ?? 0
      print("  - \(item.label ?? "?") (trang \(p))")
    }
  }

case "text":
  for i in range() {
    print("\n===== TRANG \(i) =====")
    print(doc.page(at: i - 1)?.string ?? "")
  }

case "ocr":
  // Đọc theo cột: dòng hẹp nằm hẳn bên trái/phải là cột; dòng vắt qua giữa là full-width.
  // Gặp dòng full-width thì in hết cột trái rồi cột phải trước đó → đúng thứ tự đọc sách 2 cột.
  for i in range() {
    if ProcessInfo.processInfo.environment["OCR_TSV"] != "1" { print("\n===== TRANG \(i) (OCR) =====") }
    let ocrDpi = CGFloat(Double(ProcessInfo.processInfo.environment["OCR_DPI"] ?? "220") ?? 220)
    guard let page = doc.page(at: i - 1), let img = render(page, dpi: ocrDpi) else { continue }
    let req = VNRecognizeTextRequest()
    req.recognitionLevel = .accurate
    // OCR_LANGS=en-US,ko-KR để nhận cả chữ Hàn (rồi lọc bỏ), mặc định chỉ tiếng Anh.
    req.recognitionLanguages =
      ProcessInfo.processInfo.environment["OCR_LANGS"]?.split(separator: ",").map(String.init) ?? ["en-US"]
    req.usesLanguageCorrection = false
    try? VNImageRequestHandler(cgImage: img).perform([req])
    let obs = (req.results ?? []).sorted { $0.boundingBox.maxY > $1.boundingBox.maxY }
    // OCR_TSV=1: in "trang<TAB>cột(L/R/F)<TAB>y_top<TAB>x_left<TAB>text" (toạ độ 0–1 từ góc trên-trái)
    if ProcessInfo.processInfo.environment["OCR_TSV"] == "1" {
      for o in obs {
        guard let text = o.topCandidates(1).first?.string else { continue }
        let b = o.boundingBox
        let col = b.maxX <= 0.53 ? "L" : (b.minX >= 0.47 ? "R" : "F")
        print(String(format: "%d\t%@\t%.4f\t%.4f\t%@", i, col, 1 - b.maxY, b.minX, text))
      }
      continue
    }
    var left: [String] = [], right: [String] = []
    func flush() {
      left.forEach { print($0) }
      if !right.isEmpty { print("  ‖"); right.forEach { print($0) } }
      left.removeAll(); right.removeAll()
    }
    for o in obs {
      guard let text = o.topCandidates(1).first?.string else { continue }
      let b = o.boundingBox
      if b.maxX <= 0.53 { left.append(text) }
      else if b.minX >= 0.47 { right.append(text) }
      else { flush(); print(text) }
    }
    flush()
  }

case "ocrrect":
  // ocrrect <file> <trang> <x> <y> <w> <h> [dpi=400]: OCR 1 vùng (tỉ lệ 0–1 từ góc trên-trái), in từng dòng
  guard args.count >= 8, let p = Int(args[3]), let page = doc.page(at: p - 1),
    let x = Double(args[4]), let y = Double(args[5]), let w = Double(args[6]), let h = Double(args[7])
  else { fail("ocrrect <file> <trang> <x> <y> <w> <h> [dpi]") }
  let dpi = CGFloat(Double(args.count >= 9 ? args[8] : "400") ?? 400)
  guard let img = render(page, dpi: dpi) else { fail("Không render được trang") }
  let W = Double(img.width), H = Double(img.height)
  guard let cut = img.cropping(to: CGRect(x: x * W, y: y * H, width: w * W, height: h * H)) else {
    fail("Vùng không hợp lệ")
  }
  let req = VNRecognizeTextRequest()
  req.recognitionLevel = .accurate
  req.usesLanguageCorrection = false
  try? VNImageRequestHandler(cgImage: cut).perform([req])
  for o in (req.results ?? []) {
    guard let t = o.topCandidates(1).first?.string else { continue }
    let b = o.boundingBox
    print(String(format: "%.3f\t%.3f\t%@", b.midX, 1 - b.midY, t))
  }

case "photos":
  // photos <file> <trang>: dò các ảnh chụp lớn (vùng tối liên tục), in "x y w h" (tỉ lệ, từ góc trên-trái)
  guard args.count >= 4, let p = Int(args[3]), let page = doc.page(at: p - 1),
    let img = render(page, dpi: 50)
  else { fail("photos <file> <trang>") }
  let w = img.width, h = img.height
  guard let ctx = CGContext(
    data: nil, width: w, height: h, bitsPerComponent: 8, bytesPerRow: w,
    space: CGColorSpaceCreateDeviceGray(), bitmapInfo: CGImageAlphaInfo.none.rawValue),
    let _ = { ctx in ctx.draw(img, in: CGRect(x: 0, y: 0, width: w, height: h)); return true }(ctx) as Bool?,
    let data = ctx.data
  else { fail("Không đọc được ảnh") }
  let px = data.bindMemory(to: UInt8.self, capacity: w * h)
  let x0 = Int(Double(w) * 0.06), x1 = Int(Double(w) * 0.88)  // bỏ lề và nhãn TEST bên phải
  func dark(_ x: Int, _ y: Int) -> Bool { px[y * w + x] < 252 }  // nền giấy scan = 255
  // hàng "ảnh" = >25% điểm không-trắng trong vùng giữa
  var rows = [Bool](repeating: false, count: h)
  for y in 0..<h {
    var c = 0
    for x in x0..<x1 where dark(x, y) { c += 1 }
    rows[y] = Double(c) > Double(x1 - x0) * 0.25
  }
  var y = 0
  while y < h {
    guard rows[y] else { y += 1; continue }
    var y2 = y
    while y2 + 1 < h && (rows[y2 + 1] || (y2 + 3 < h && rows[y2 + 3])) { y2 += 1 }
    if y2 - y > h / 12 {
      var cols = [Int](repeating: 0, count: w)
      for yy in y...y2 { for x in x0..<x1 where dark(x, yy) { cols[x] += 1 } }
      let need = Int(Double(y2 - y) * 0.5)
      let xs = (x0..<x1).filter { cols[$0] > need }
      if let a = xs.first, let b = xs.last, b - a > w / 6 {
        print(String(format: "%.4f %.4f %.4f %.4f",
          Double(a) / Double(w), Double(y) / Double(h), Double(b - a + 1) / Double(w), Double(y2 - y + 1) / Double(h)))
      }
    }
    y = y2 + 1
  }

case "cropstack":
  // cropstack <file> <ra.jpg> <dpi> trang:x:y:w:h [trang:x:y:w:h ...] → cắt từng vùng rồi ghép dọc
  guard args.count >= 6, let dpi = Double(args[4]) else { fail("cropstack <file> <ra.jpg> <dpi> p:x:y:w:h ...") }
  var parts: [CGImage] = []
  for spec in args[5...] {
    let v = spec.split(separator: ":").compactMap { Double($0) }
    guard v.count == 5, let page = doc.page(at: Int(v[0]) - 1), let img = render(page, dpi: CGFloat(dpi)) else { continue }
    let W = Double(img.width), H = Double(img.height)
    if let cut = img.cropping(to: CGRect(x: v[1] * W, y: v[2] * H, width: v[3] * W, height: v[4] * H)) {
      parts.append(cut)
    }
  }
  guard !parts.isEmpty else { fail("Không có vùng hợp lệ") }
  let outW = parts.map(\.width).max()!, outH = parts.map(\.height).reduce(0, +)
  guard let ctx = CGContext(
    data: nil, width: outW, height: outH, bitsPerComponent: 8, bytesPerRow: 0,
    space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue)
  else { fail("Không tạo được ảnh") }
  ctx.setFillColor(CGColor(gray: 1, alpha: 1))
  ctx.fill(CGRect(x: 0, y: 0, width: outW, height: outH))
  var yy = outH
  for part in parts {
    yy -= part.height
    ctx.draw(part, in: CGRect(x: 0, y: yy, width: part.width, height: part.height))
  }
  let rep = NSBitmapImageRep(cgImage: ctx.makeImage()!)
  try rep.representation(using: .jpeg, properties: [.compressionFactor: 0.75])?
    .write(to: URL(fileURLWithPath: args[3]))
  print("Đã ghép \(parts.count) vùng → \(args[3])")

case "crop":
  // crop <file> <trang> <x> <y> <w> <h> <ra.png> [dpi=200]; toạ độ là tỉ lệ 0–1 tính từ góc TRÊN-trái
  guard args.count >= 9, let p = Int(args[3]), let page = doc.page(at: p - 1),
    let x = Double(args[4]), let y = Double(args[5]), let w = Double(args[6]), let h = Double(args[7])
  else { fail("crop <file> <trang> <x> <y> <w> <h> <ra.png> [dpi]") }
  let dpi = CGFloat(Double(args.count >= 10 ? args[9] : "200") ?? 200)
  guard let img = render(page, dpi: dpi) else { fail("Không render được trang") }
  let W = Double(img.width), H = Double(img.height)
  guard let cut = img.cropping(to: CGRect(x: x * W, y: y * H, width: w * W, height: h * H)) else {
    fail("Vùng cắt không hợp lệ")
  }
  let rep = NSBitmapImageRep(cgImage: cut)
  try rep.representation(using: .jpeg, properties: [.compressionFactor: 0.82])?
    .write(to: URL(fileURLWithPath: args[8]))
  print("Đã cắt → \(args[8]) (\(cut.width)×\(cut.height))")

case "render":
  guard args.count >= 6 else { fail("Thiếu thư mục ra") }
  let out = URL(fileURLWithPath: args[5])
  let dpi = CGFloat(Double(args.count >= 7 ? args[6] : "110") ?? 110)
  try? FileManager.default.createDirectory(at: out, withIntermediateDirectories: true)
  for i in range() {
    guard let page = doc.page(at: i - 1), let img = render(page, dpi: dpi) else { continue }
    let rep = NSBitmapImageRep(cgImage: img)
    let file = out.appendingPathComponent(String(format: "page_%04d.png", i))
    try rep.representation(using: .png, properties: [:])?.write(to: file)
    print(file.path)
  }

case "split":
  guard args.count >= 6 else { fail("Thiếu file ra") }
  let outDoc = PDFDocument()
  for (j, i) in range().enumerated() {
    if let page = doc.page(at: i - 1) { outDoc.insert(page, at: j) }
  }
  guard outDoc.write(to: URL(fileURLWithPath: args[5])) else { fail("Ghi file thất bại") }
  print("Đã ghi \(outDoc.pageCount) trang → \(args[5])")

case "sheet":
  guard args.count >= 6 else { fail("Thiếu file ảnh ra") }
  let cols = Int(args.count >= 7 ? args[6] : "5") ?? 5
  let dpi = CGFloat(Double(args.count >= 8 ? args[7] : "28") ?? 28)
  let pages = Array(range())
  let thumbs = pages.compactMap { doc.page(at: $0 - 1).flatMap { render($0, dpi: dpi) } }
  guard let first = thumbs.first else { fail("Không render được trang") }
  let cw = first.width, ch = first.height + 14, rows = (thumbs.count + cols - 1) / cols
  guard let ctx = CGContext(
    data: nil, width: cw * cols, height: ch * rows, bitsPerComponent: 8, bytesPerRow: 0,
    space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue)
  else { fail("Không tạo được ảnh") }
  ctx.setFillColor(CGColor(gray: 0.85, alpha: 1))
  ctx.fill(CGRect(x: 0, y: 0, width: cw * cols, height: ch * rows))
  NSGraphicsContext.current = NSGraphicsContext(cgContext: ctx, flipped: false)
  for (k, img) in thumbs.enumerated() {
    let x = (k % cols) * cw, y = (rows - 1 - k / cols) * ch
    ctx.draw(img, in: CGRect(x: x, y: y, width: img.width, height: img.height))
    ("p\(pages[k])" as NSString).draw(
      at: CGPoint(x: x + 2, y: y + img.height),
      withAttributes: [.font: NSFont.boldSystemFont(ofSize: 11), .foregroundColor: NSColor.red])
  }
  let rep = NSBitmapImageRep(cgImage: ctx.makeImage()!)
  try rep.representation(using: .png, properties: [:])?.write(to: URL(fileURLWithPath: args[5]))
  print("Đã ghi \(thumbs.count) trang → \(args[5])")

default:
  fail("Lệnh không hỗ trợ: \(cmd)")
}
