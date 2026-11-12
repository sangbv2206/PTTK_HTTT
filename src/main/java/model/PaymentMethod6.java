package model;

import java.io.Serializable;

public class PaymentMethod6 implements Serializable {
    private static final long serialVersionUID = 1L;

    // Các hằng số định danh phương thức thanh toán chuẩn hóa theo CSDL
    public static final int METHOD_CASH = 1;      // Tiền mặt
    public static final int METHOD_CARD = 2;      // Thẻ ngân hàng / máy POS
    public static final int METHOD_QR = 3;        // Ví điện tử / Quét mã QR

    public static final String CODE_CASH = "CASH";
    public static final String CODE_CARD = "CARD";
    public static final String CODE_QR = "QR";

    private int id;
    private String methodName; // CASH, BANK_CARD, QR_CODE
    private String description;

    public PaymentMethod6() {}

    public PaymentMethod6(int id, String methodName, String description) {
        this.id = id;
        this.methodName = methodName;
        this.description = description;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getMethodName() { return methodName; }
    public void setMethodName(String methodName) { this.methodName = methodName; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
}

