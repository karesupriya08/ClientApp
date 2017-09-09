/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.rmx.clientapp.Model;

import java.util.Date;

/**
 *
 * @author Supriya Kare
 */
public class SizePrice {
     private String buyer_code;
      private int serial;
    private String style_no;
    private int colour_code;
    private Date tran_date;
    private String tran_time;
    private String size_type;
    private int price;
    private int qty;

    public String getBuyer_code() {
        return buyer_code;
    }

    public void setBuyer_code(String buyer_code) {
        this.buyer_code = buyer_code;
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

    public int getColour_code() {
        return colour_code;
    }

    public void setColour_code(int colour_code) {
        this.colour_code = colour_code;
    }

    public Date getTran_date() {
        return tran_date;
    }

    public void setTran_date(Date tran_date) {
        this.tran_date = tran_date;
    }

    public String getTran_time() {
        return tran_time;
    }

    public void setTran_time(String tran_time) {
        this.tran_time = tran_time;
    }

    public String getSize_type() {
        return size_type;
    }

    public void setSize_type(String size_type) {
        this.size_type = size_type;
    }

    public int getPrice() {
        return price;
    }

    public void setPrice(int price) {
        this.price = price;
    }

    public int getQty() {
        return qty;
    }

    public void setQty(int qty) {
        this.qty = qty;
    }
    
    
}
