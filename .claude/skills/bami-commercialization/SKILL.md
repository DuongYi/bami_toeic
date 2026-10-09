---
name: bami-commercialization
description: "Chiến lược và hướng dẫn triển khai tính năng thương mại hoá (commercialization), giữ chân người dùng (retention), vòng lặp thói quen học tập (habit loop) và gói nâng cấp Bami PRO cho app Flutter Bami TOEIC. Tổng hợp từ paywall-upgrade-cro, monetization và growth-engine."
---

# Bami Commercialization — Hướng Dẫn Thương Mại Hoá & Giữ Chân Người Dùng

> **Mục tiêu:** Biến Bami TOEIC từ ứng dụng giải đề thông thường thành một sản phẩm EdTech thương mại chuyên nghiệp chuẩn SaaS (tương tự ELSA Speak, Migii TOEIC, Duolingo), tối ưu hóa tỷ lệ chuyển đổi và thói quen học tập hằng ngày.

---

## 1. Vòng Lặp Giá Trị & Thói Quen (The Retention & Habit Loop)

Một ứng dụng luyện thi thương mại thành công dựa trên **Vòng lặp 4 bước**:

```
      ┌──────────────────────────────────────────────┐
      │  1. KÍCH HOẠT (Trigger)                       │
      │  - Chuỗi ngày học liên tiếp (Streak 🔥)      │
      │  - Nhắc nhở từ vựng SRS đến hạn hôm nay     │
      └──────────────────────┬───────────────────────┘
                             │
                             ▼
      ┌──────────────────────────────────────────────┐
      │  2. HÀNH ĐỘNG DỄ DÀNG (Frictionless Action)   │
      │  - Nhiệm vụ ngày (Daily Mission: 1 Part test)│
      │  - Mở bài thi dở chỉ với 1 chạm              │
      └──────────────────────┬───────────────────────┘
                             │
                             ▼
      ┌──────────────────────────────────────────────┐
      │  3. PHẦN THƯỞNG BIẾN THIÊN (Variable Reward) │
      │  - Bảng điểm dự đoán TOEIC chuẩn hóa ETS     │
      │  - Huy hiệu tiến độ & nhận diện điểm yếu AI  │
      └──────────────────────┬───────────────────────┘
                             │
                             ▼
      ┌──────────────────────────────────────────────┐
      │  4. ĐẦU TƯ CỦA NGƯỜI DÙNG (Investment)       │
      │  - Lưu câu sai vào "Sổ câu sai"              │
      │  - Lưu từ mới vào kho Flashcard cá nhân      │
      └──────────────────────────────────────────────┘
```

---

## 2. Hệ Thống Điểm Chuyển Đổi Tự Nhiên (Natural Value Moments)

Không ép người dùng mua gói trả phí ngay từ lần đầu mở app. Thay vào đó, xuất hiện tinh tế tại **3 khoảnh khắc giá trị cao nhất (High-Intent Value Moments)**:

### Điểm 1: Ngay sau khi hoàn thành bài thi (Màn hình Kết quả)
- **Khoảnh khắc:** Người dùng vừa bỏ ra 30 - 120 phút hoàn thành bài thi, đang khao khát biết điểm số thật và muốn sửa các câu sai.
- **Thương mại hoá:** Hiển thị phân tích điểm ETS chuẩn hóa, phân loại trình độ CEFR (B1/B2/C1) và gợi ý:
  *"Mở khoá giải thích chi tiết AI & Luyện tập lại từng dạng bẫy với Bami PRO."*

### Điểm 2: Trong Sổ Câu Sai (Mistakes Review)
- **Khoảnh khắc:** Người dùng đối mặt với các câu làm sai nhiều lần và không hiểu tại sao đáp án lại như vậy.
- **Thương mại hoá:** Hiển thị nút "Hỏi gia sư AI Bami" hoặc tag giải thích chuyên sâu có huy hiệu `ProBadge`.

### Điểm 3: Màn hình Đề thi (Kho Đề ETS Mới Nhất)
- **Khoảnh khắc:** Người dùng tìm kiếm các bộ đề mới nhất (ETS 2024, ETS 2025, Đề thi thật theo format mới).
- **Thương mại hoá:** Gắn nhãn `TestTag` ("ETS 2024", "VIP", "Đề chọn lọc") kèm nút bắt đầu thi thử mô phỏng phòng thi thật.

---

## 3. Các Thành Phần Giao Diện Thương Mại (Commercial UI Components)

Tất cả các thành phần này được tích hợp trong thư viện `lib/core/design_system/`:

| Component | Mục đích sử dụng | Vị trí đặt chuẩn |
| :--- | :--- | :--- |
| `StreakBadge` | Hiển thị chuỗi ngày học (`🔥 3 ngày`), duy trì cam kết | Header màn hình chủ, thanh profile |
| `ProBadge` | Huy hiệu nhận diện thành viên PRO / Tính năng nâng cao | Cạnh avatar, cạnh đề thi độc quyền |
| `DailyMissionCard` | Bảng nhiệm vụ học tập hôm nay (thanh tiến độ 2/3) | Ngay dưới thẻ Hero màn hình chủ |
| `UpgradeBanner` | Banner giới thiệu đặc quyền Bami PRO tinh tế, cho phép đóng | Xen kẽ danh sách đề thi |
| `TestTag` | Gắn nhãn độ khó (`Dễ`, `Chuẩn ETS`, `Khó`) & nguồn đề (`ETS 2024`) | Thẻ đề thi (`_TestCard`), chi tiết đề |
| `ScorePredictor` | Vòng tính điểm TOEIC dự đoán so với điểm mục tiêu | Thẻ `AppHeroCard` màn hình chính |

---

## 4. Bảng So Sánh Quyền Lợi Gói Học (Tier Entitlements)

| Quyền lợi | Miễn phí (Free) | Bami PRO 🌟 |
| :--- | :--- | :--- |
| Đề thi cơ bản | Mini test, đề tuyển tập | Không giới hạn toàn bộ ETS 2022 - 2024 |
| Chế độ thi | Luyện tập tự do | Mô phỏng phòng thi thật 120p, âm thanh phòng thi |
| Giải thích câu hỏi | Đáp án A/B/C/D | Phân tích ngữ pháp chuyên sâu, giải nghĩa từ vựng |
| Sổ câu sai | Lưu tối đa 20 câu | Không giới hạn, AI phân loại bẫy câu hỏi |
| Dự đoán điểm ETS | Điểm thô | Thuật toán chuẩn hóa ETS + Lộ trình bù đắp điểm yếu |
