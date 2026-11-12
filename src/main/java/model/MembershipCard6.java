package model;

import java.io.Serializable;
import java.sql.Date;

public class MembershipCard6 implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private Date issueDate;
    private Date expiryDate;
    private String status;
    private MembershipTier6 tier;

    public MembershipCard6() {
    }

    public MembershipCard6(int id, Date issueDate, Date expiryDate, String status, MembershipTier6 tier) {
        this.id = id;
        this.issueDate = issueDate;
        this.expiryDate = expiryDate;
        this.status = status;
        this.tier = tier;
    }

    public MembershipCard6(Date issueDate, Date expiryDate, String status, MembershipTier6 tier) {
        this.issueDate = issueDate;
        this.expiryDate = expiryDate;
        this.status = status;
        this.tier = tier;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Date getIssueDate() {
        return issueDate;
    }

    public void setIssueDate(Date issueDate) {
        this.issueDate = issueDate;
    }

    public Date getExpiryDate() {
        return expiryDate;
    }

    public void setExpiryDate(Date expiryDate) {
        this.expiryDate = expiryDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public MembershipTier6 getTier() {
        return tier;
    }

    public void setTier(MembershipTier6 tier) {
        this.tier = tier;
    }
}

