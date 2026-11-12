package model;

import java.io.Serializable;

public class MembershipTier6 implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private String tierName;
    private double pointRate;
    private int minPointsRequired;
    private double discountRate;
    private String benefitsDescription;

    public MembershipTier6() {
    }

    public MembershipTier6(int id, String tierName, double pointRate, 
                           int minPointsRequired, double discountRate, String benefitsDescription) {
        this.id = id;
        this.tierName = tierName;
        this.pointRate = pointRate;
        this.minPointsRequired = minPointsRequired;
        this.discountRate = discountRate;
        this.benefitsDescription = benefitsDescription;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTierName() {
        return tierName;
    }

    public void setTierName(String tierName) {
        this.tierName = tierName;
    }

    public double getPointRate() {
        return pointRate;
    }

    public void setPointRate(double pointRate) {
        this.pointRate = pointRate;
    }

    public int getMinPointsRequired() {
        return minPointsRequired;
    }

    public void setMinPointsRequired(int minPointsRequired) {
        this.minPointsRequired = minPointsRequired;
    }

    public double getDiscountRate() {
        return discountRate;
    }

    public void setDiscountRate(double discountRate) {
        this.discountRate = discountRate;
    }

    public String getBenefitsDescription() {
        return benefitsDescription;
    }

    public void setBenefitsDescription(String benefitsDescription) {
        this.benefitsDescription = benefitsDescription;
    }
}

