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
public class Size {

    private String seas_code;
    private String buyer_code;
    private int serial;
    private String style_no;
    private int colour_code;
    private String size_type;
    private int price;
    private int size_qty;

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

    public int getSize_qty() {
        return size_qty;
    }

    public void setSize_qty(int size_qty) {
        this.size_qty = size_qty;
    }
    
    
}
