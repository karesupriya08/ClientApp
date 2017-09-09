/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.rmx.clientapp.Model;



/**
 *
 * @author Supriya Kare
 */
public class Cancelqty {

    private String seas_code;
    private String buyer_code;
    private String b_style;
    private String quota_cat;
    private int serial;
    private int order_qty;
    private String style_no;
    private String delv_date;
    private int qty_can;

    public String getSeas_code() {
        return seas_code;
    }

    public void setSeas_code(String seas_code) {
        this.seas_code = seas_code;
    }

    public String getBuyer_code() {
        return buyer_code;
    }

    public void setBuyer_code(String buyer_code) {
        this.buyer_code = buyer_code;
    }

    public String getB_style() {
        return b_style;
    }

    public void setB_style(String b_style) {
        this.b_style = b_style;
    }

    public String getQuota_cat() {
        return quota_cat;
    }

    public void setQuota_cat(String quota_cat) {
        this.quota_cat = quota_cat;
    }

    public int getSerial() {
        return serial;
    }

    public void setSerial(int serial) {
        this.serial = serial;
    }

    public String getStyle_no() {
        return style_no;
    }

    public void setStyle_no(String style_no) {
        this.style_no = style_no;
    }

    public String getDelv_date() {
        return delv_date;
    }

    public void setDelv_date(String delv_date) {
        this.delv_date = delv_date;
    }

    public int getQty_can() {
        return qty_can;
    }

    public void setQty_can(int qty_can) {
        this.qty_can = qty_can;
    }

    public int getOrder_qty() {
        return order_qty;
    }

    public void setOrder_qty(int order_qty) {
        this.order_qty = order_qty;
    }
  

}
