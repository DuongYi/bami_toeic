import SwiftUI
import WidgetKit

// Widget màn hình chính Bami TOEIC: chuỗi ngày học, nhiệm vụ hôm nay, thẻ từ cần ôn.
// Số liệu do app ghi qua home_widget vào App Group (xem HomeWidgetService trong lib/core/home_widget).

private let appGroupId = "group.com.app.bami.toeic"

struct StudyEntry: TimelineEntry {
  let date: Date
  let signedIn: Bool
  let streak: Int
  let studiedToday: Bool
  let missionsDone: Int
  let missionsTotal: Int
  let dueWords: Int

  static let placeholder = StudyEntry(
    date: Date(), signedIn: true, streak: 7, studiedToday: false,
    missionsDone: 1, missionsTotal: 3, dueWords: 12)

  /// Đọc số liệu app đã ghi; sang ngày mới thì "hôm nay" về chưa học, chuỗi chỉ còn nếu hôm qua có học.
  static func read(at date: Date) -> StudyEntry {
    let d = UserDefaults(suiteName: appGroupId)
    guard let d, d.bool(forKey: "bami_signed_in"),
      let dayString = d.string(forKey: "bami_day"),
      let day = dayFormatter.date(from: dayString)
    else {
      return StudyEntry(
        date: date, signedIn: false, streak: 0, studiedToday: false,
        missionsDone: 0, missionsTotal: 0, dueWords: 0)
    }
    let cal = Calendar.current
    let age = cal.dateComponents([.day], from: cal.startOfDay(for: day), to: cal.startOfDay(for: date)).day ?? 0
    let studied = d.bool(forKey: "bami_studied_today")
    let streak = d.integer(forKey: "bami_streak")
    let total = d.integer(forKey: "bami_missions_total")
    let due = d.integer(forKey: "bami_due_words")
    switch age {
    case ...0:
      return StudyEntry(
        date: date, signedIn: true, streak: streak, studiedToday: studied,
        missionsDone: d.integer(forKey: "bami_missions_done"), missionsTotal: total, dueWords: due)
    case 1:
      return StudyEntry(
        date: date, signedIn: true, streak: studied ? streak : 0, studiedToday: false,
        missionsDone: 0, missionsTotal: total, dueWords: due)
    default:
      return StudyEntry(
        date: date, signedIn: true, streak: 0, studiedToday: false,
        missionsDone: 0, missionsTotal: total, dueWords: due)
    }
  }

  private static let dayFormatter: DateFormatter = {
    let f = DateFormatter()
    f.calendar = Calendar(identifier: .gregorian)
    f.locale = Locale(identifier: "en_US_POSIX")
    f.dateFormat = "yyyy-MM-dd"
    return f
  }()
}

struct StudyProvider: TimelineProvider {
  func placeholder(in context: Context) -> StudyEntry { .placeholder }

  func getSnapshot(in context: Context, completion: @escaping (StudyEntry) -> Void) {
    completion(context.isPreview ? .placeholder : .read(at: Date()))
  }

  /// Vẽ lại lúc nửa đêm để "hôm nay" tự chuyển sang chưa học; app ghi số liệu mới thì vẽ lại ngay.
  func getTimeline(in context: Context, completion: @escaping (Timeline<StudyEntry>) -> Void) {
    let now = Date()
    let midnight = Calendar.current.nextDate(
      after: now, matching: DateComponents(hour: 0, minute: 1), matchingPolicy: .nextTime) ?? now
    completion(Timeline(entries: [.read(at: now), .read(at: midnight)], policy: .atEnd))
  }
}

struct BamiStudyWidgetView: View {
  let entry: StudyEntry
  @Environment(\.widgetFamily) private var family

  private var status: String {
    if entry.studiedToday { return "Hôm nay đã học, giữ vững nhé!" }
    return entry.streak > 0 ? "Học hôm nay để giữ chuỗi" : "Bắt đầu chuỗi mới hôm nay"
  }

  var body: some View {
    VStack(alignment: .leading, spacing: 4) {
      HStack(spacing: 6) {
        Image(systemName: "flame.fill").foregroundStyle(.orange)
        Text(entry.signedIn ? "\(entry.streak) ngày" : "Bami TOEIC")
          .font(.title3.bold())
          .lineLimit(1)
      }
      Text(entry.signedIn ? status : "Đăng nhập để theo dõi chuỗi ngày học")
        .font(.caption)
        .foregroundStyle(.secondary)
        .lineLimit(2)
      Spacer(minLength: 0)
      if entry.signedIn {
        Text("Nhiệm vụ \(entry.missionsDone)/\(entry.missionsTotal)")
          .font(.subheadline.bold())
          .foregroundStyle(.tint)
        Text("\(entry.dueWords) thẻ từ cần ôn")
          .font(.caption)
          .foregroundStyle(.secondary)
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
    .widgetBackground()
  }
}

extension View {
  /// iOS 17+ cần containerBackground; iOS 15–16 tự đệm lề và nền.
  @ViewBuilder func widgetBackground() -> some View {
    if #available(iOSApplicationExtension 17.0, *) {
      containerBackground(.fill.tertiary, for: .widget)
    } else {
      padding().background(Color(.systemBackground))
    }
  }
}

@main
struct BamiStudyWidget: Widget {
  // Phải trùng iOSName trong HomeWidgetService.
  let kind = "BamiStudyWidget"

  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: StudyProvider()) { entry in
      BamiStudyWidgetView(entry: entry)
    }
    .configurationDisplayName("Chuỗi ngày học")
    .description("Chuỗi ngày học, nhiệm vụ hôm nay và số thẻ từ cần ôn.")
    .supportedFamilies([.systemSmall, .systemMedium])
  }
}
