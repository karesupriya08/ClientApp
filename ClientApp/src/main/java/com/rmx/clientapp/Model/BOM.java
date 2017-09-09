/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.rmx.clientapp.Model;

import org.json.simple.JSONArray;

/**
 *
 * @author Supriya Kare
 */
public class BOM {
    private JSONArray bomdata;
    private JSONArray stylenolist;
    private String b_style;
    private int order_qty;

    public JSONArray getBomdata() {
        return bomdata;
    }

    public void setBomdata(JSONArray bomdata) {
        this.bomdata = bomdata;
    }

    public JSONArray getStylenolist() {
        return stylenolist;
    }

    public void setStylenolist(JSONArray stylenolist) {
        this.stylenolist = stylenolist;
    }

    public String getB_style() {
        return b_style;
    }

    public void setB_style(String b_style) {
        this.b_style = b_style;
    }

    public int getOrder_qty() {
        return order_qty;
    }

    public void setOrder_qty(int order_qty) {
        this.order_qty = order_qty;
    }
    
    
}
