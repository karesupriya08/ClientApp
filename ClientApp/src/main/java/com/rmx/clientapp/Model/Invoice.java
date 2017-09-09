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
public class Invoice {
    private int serial;
    private String season;
    private int colour;
    private int ship_no;

    public int getSerial() {
        return serial;
    }

    public void setSerial(int serial) {
        this.serial = serial;
    }

    public String getSeason() {
        return season;
    }

    public void setSeason(String season) {
        this.season = season;
    }

    public int getColour() {
        return colour;
    }

    public void setColour(int colour) {
        this.colour = colour;
    }

    public int getShip_no() {
        return ship_no;
    }

    public void setShip_no(int ship_no) {
        this.ship_no = ship_no;
    }
    
    
}
