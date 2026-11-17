# Ứng dụng thương mại điện tử mini

Đồ án cuối kỳ môn **Mẫu thiết kế** – Khoa Công nghệ Thông tin, Trường Đại học Đà Lạt.
Giảng viên: ThS. Đoàn Minh Khuê.

Web bán hàng mini gồm back-end **Java Spring Boot** và front-end **Next.js**, áp dụng 5 mẫu thiết kế: **Strategy, Observer, Simple Factory, Repository, Unit of Work**.

## Thành viên (Nhóm 16 – CTK47B)
| 2312632 | Đặng Nam Huy | Nhóm trưởng, quản lý GitHub |

| 2314487 | Phanthamala Somsavath | Thành viên |

## Chức năng

- Xem, tìm kiếm, lọc sản phẩm theo danh mục và khoảng giá
- Đăng ký, đăng nhập, đăng xuất
- Giỏ hàng (lưu trên trình duyệt)
- Đặt hàng: kiểm tra tồn kho, chống tạo trùng đơn
- Thanh toán COD, MoMo, VNPAY (giả lập)
- Theo dõi đơn hàng và trạng thái

## Mẫu thiết kế áp dụng

| Mẫu | Vị trí | Mục đích |
|---|---|---|
| Strategy | `IPaymentStrategy`, `PaymentContext` | Mỗi phương thức thanh toán là một lớp riêng |
| Simple Factory | `PaymentFactory` | Chọn đúng strategy theo phương thức khách chọn |
| Observer | `EventPublisher`, `OrderEventHandler` | Đặt hàng xong tự gửi email, ghi nhận tồn kho |
| Repository | `IRepository<T>`, `JpaRepositoryImpl<T>` | Tách truy cập dữ liệu khỏi nghiệp vụ |
| Unit of Work | `IUnitOfWork`, `UnitOfWork` | Trừ kho và lưu đơn trong cùng một giao dịch |

## Công nghệ

- **Back-end:** Java 17, Spring Boot 3.4, JPA/Hibernate, H2 Database, Swagger
- **Front-end:** Next.js 14, React 18, TypeScript, Tailwind CSS, Zustand

## Cách chạy

**Yêu cầu:** JDK 17+ và Node.js 18+.

1. Tải mã nguồn: `git clone https://github.com/namhuy1234/DoAn_MTK_UngDungThuongMaiDienTuMini.git`
2. Nhấp đúp **`CHAY_CHUONG_TRINH.bat`**. Chương trình tự bật back-end, front-end rồi mở web.
3. Tắt chương trình: nhấp đúp **`DUNG_CHUONG_TRINH.bat`**.

| Nội dung | Địa chỉ |
|---|---|
| Web | http://localhost:3000 |
| Swagger (thử API) | http://localhost:8080/swagger-ui.html |
| H2 Console | http://localhost:8080/h2-console (JDBC URL: `jdbc:h2:mem:miniecommerce`, User: `sa`, mật khẩu để trống) |

**Tài khoản demo:** `namhuy` / `namhuy123456`

## Cấu trúc thư mục
├── mini-ecommerce-java/ Back-end Spring Boot
├── frontend/ Front-end Next.js
├── CHAY_CHUONG_TRINH.bat Chạy toàn bộ chương trình
└── DUNG_CHUONG_TRINH.bat Tắt chương trình
